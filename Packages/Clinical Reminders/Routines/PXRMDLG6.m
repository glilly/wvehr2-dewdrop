PXRMDLG6        ; SLC/AGP - Reminder Dialog Edit/Inquiry ;07/31/2009
        ;;2.0;CLINICAL REMINDERS;**12**;Feb 04, 2005;Build 73
        ;
ISACTDLG(DIEN)  ;
        ;this returns a 1 if the dialog can be used in a TIU Template
        N NODE
        S NODE=$G(^PXRMD(801.41,DIEN,0))
        I $P(NODE,U,4)'="R" Q 0
        I +$P(NODE,U,3)>0 Q 0
        Q 1
        ;
DISCKINP(DIEN,X,ORG)    ;
        ;sub script 1 = name field
        ;sub script 2 = disable field
        ;
        I X(1)="" Q 1
        I $G(PXRMINST)=1 Q 1
        I X(2)=1!(X(2)=2) Q 1
        ;
        N CANACT,CNT,CNT1,MSG,NAME,RESULT,TEXT,TYPE,STDFILES
        D DIALDSAR^PXRMFRPT(.STDFILES) I '$D(STDFILES) Q 1
        S TYPE=$P($G(^PXRMD(801.41,DIEN,0)),U,4)
        I "RFPT"[TYPE Q 1
        S TYPE=$S(TYPE="E":"Element",TYPE="G":"Group",TYPE="S":"Result Group")
        S RESULT=$$DISABCHK(DIEN,.STDFILES,.MSG)
        S NAME=$P($G(^PXRMD(801.41,DIEN,0)),U)
        S CNT1=1
        I RESULT=0 D 
        .S TEXT(CNT1)="Disabled value cannot be changed."
        .S $P(^PXRMD(801.41,DIEN,0),U,3)=ORG(2)
        I $D(MSG)>0 D
        .S CNT=0 F  S CNT=$O(MSG(CNT)) Q:CNT'>0  S CNT1=CNT1+1,TEXT(CNT1)=MSG(CNT)
        .D EN^DDIOL(.TEXT)
        Q RESULT
        ;
DISABCHK(DIEN,STDFILES,MSG)     ;
        ;
        N CNT,FILE,FILESTAT,FIND,NODE,IEN,RESULT,STATUS,VPTR
        S RESULT=1,CNT=0
        S NODE=$G(^PXRMD(801.41,DIEN,1))
        ;;Check for MH Test only in Result Groups
        I $D(STDFILES("^YTT(601.71,"))>0 D
        .S FILESTAT=$P(STDFILES("YTT(607.71,"),U,2)
        .S IEN=$P($G(^PXRMD(801.41,DIEN,50)),U)
        .S STATUS=$$ENSTAT(STDFILES("^YTT(601.71,"),IEN)
        .I STATUS=0 D DSMSG(.MSG,.CNT,"MH Test",IEN,"^YTT(601.71)") I FILESTAT=6 S RESULT=0
        ;
        ;Check for Orderable Items
        I $D(STDFILES("^ORD(101.43,"))>0 D
        .S FILESTAT=$P(STDFILES("^ORD(101.43,"),U,2)
        .S IEN=$P(NODE,U,7)
        .S STATUS=$$ENSTAT(STDFILES("^ORD(101.43,"),IEN)
        .I STATUS=0 D DSMSG(.MSG,.CNT,"Orderable Item",IEN,"^ORD(101.43)") I FILESTAT=6 S RESULT=0
        ;
        ;Check for Finding Items
        S FIND=$P(NODE,U,5)
        S IEN=$P(FIND,";"),FILE=$P(FIND,";",2)
        I $D(STDFILES(U_FILE))>0 D
        .S FILESTAT=$P(STDFILES(U_FILE),U,2)
        .S STATUS=$$ENSTAT(STDFILES(U_FILE),IEN)
        .I STATUS=0 D DSMSG(.MSG,.CNT,"Finding Item",IEN,$$SETGBL^PXRMDLG5(FILE)) I FILESTAT=6 S RESULT=0
        ;
        ;Check for additional finding items
        S FIND=0 F  S FIND=$O(^PXRMD(801.41,DIEN,3,"B",FIND)) Q:FIND=""  D
        .S IEN=$P(FIND,";"),FILE=$P(FIND,";",2)
        .I $D(STDFILES(U_FILE))>0 D
        ..S FILESTAT=$P(STDFILES(U_FILE),U,2)
        ..S STATUS=$$ENSTAT(STDFILES(U_FILE),IEN)
        ..I STATUS=0 D DSMSG(.MSG,.CNT,"Additional Finding Item",IEN,$$SETGBL^PXRMDLG5(FILE)) I FILESTAT=6 S RESULT=0
        Q RESULT
        ;
DSMSG(MSG,CNT,FIELD,IEN,GBL)    ;
        N ENTRY
        S CNT=CNT+1
        S ENTRY=$P($G(@GBL@(IEN,0)),U)
        S MSG(CNT)="   "_FIELD_" entry "_ENTRY_" is inactive."
        Q
        ;
ENSTAT(FILENUM,IEN)     ;
        ;Return values 0 if finding is inactive, return 1 if finding is active
        N FIENS,STATUS
        S FIENS=IEN_","
        ;DBIA #4631
        S STATUS=$P($$GETSTAT^XTID(FILENUM,.01,FIENS),U,1)
        Q STATUS
        ;
FILESCR(IEN,FILENUM)    ;
        N LOCK,RESULT,STATUS
        I $G(PXRMINST)=1 Q 1
        S RESULT=1
        ;DBIA #4640
        S STATUS=+$$GETSTAT^HDISVF01(FILENUM)
        S LOCK=$S(STATUS=6:1,STATUS=7:1,1:0)
        I LOCK=1 S RESULT=$P($$GETSTAT^XTID(FILENUM,.01,IEN_","),U,1)
        I +RESULT=0 Q +RESULT
        I FILENUM=9999999.64 I $P($G(^AUTTHF(IEN,0)),U,10)="C" S RESULT=0
        I FILENUM=601.71 I $$MH^PXRMDLG5(IEN)=0 S RESULT=0
        Q +RESULT
        ;
OKTODEL(DIEN)   ;
        ;this checks to see if an entry is okay to delete. the entry
        ;cannot be used anywhere else.
        ;"AD" for component multiple
        ;"R" for replacement element/groups
        ;"RG" for result groups
        ;
        I $G(PXRMEXCH)=1 Q 1
        I $D(^PXRMD(801.41,"AD",DIEN)) Q 0
        I $D(^PXRMD(801.41,"R",DIEN)) Q 0
        I $D(^PXRMD(801.41,"RG",DIEN)) Q 0
        Q 1
        ;
PIPECHK(DIEN)   ;
        N AMOUNT,CNT,FLDNAM,NODE,NUM,TYPE
        S TYPE=$P($G(^PXRMD(801.41,DA,0)),U,4)
        F NODE=25,35 D
        .S CNT=0,NUM=0
        .F  S NUM=$O(^PXRMD(801.41,DIEN,NODE,NUM)) Q:NUM'>0  D
        ..S AMOUNT=$L(^PXRMD(801.41,DIEN,NODE,NUM,0),"|") I AMOUNT=1 Q
        ..S CNT=CNT+(AMOUNT-1)
        ..I CNT=0 Q
        ..I CNT#2=0 Q
        ..I TYPE="E" S FLDNAM=$S(NODE=25:"Dialog/Progress Note  Text",1:"Alternate Progress Note Text")
        ..I TYPE="G" S FLDNAM=$S(NODE=25:"Group Header Dialog Text",1:"Group Header Alternate Progress Note Text")
        ..D TIUOBJW^PXRMFNFT(FLDNAM,CNT)
        Q
        ;
