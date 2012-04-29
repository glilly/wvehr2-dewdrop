TIUSRVT2        ; SLC/JM - Server functions for templates ;5/11/2009
        ;;1.0;TEXT INTEGRATION UTILITIES;**80,105,249**;Jun 20, 1997;Build 48
TACCESS(TIUY,ROOT,USER,LOC)     ;Returns Template Access level of User
        ;
        ;Return Values:
        ;
        ; 0 = FULL ACCESS
        ; 1 = READ ONLY
        ; 2 = NO ACCESS
        ; 3 = SHARED TEMPLATES EDITOR - ACCESS PARAMETERS DO NOT APPLY
        ;
        I +ROOT D  Q:+TIUY
        .D ISEDITOR^TIUSRVT(.TIUY,ROOT,USER)
        .I +TIUY S TIUY=3
        .E  S TIUY=0
        S TIUY=$$GET^XPAR(USER_";VA(200,","TIU PERSONAL TEMPLATE ACCESS",1,"I")
        I TIUY="" D
        .N TIUCLLST,TIUERR,IDX,TMP
        .D GETLST^XPAR(.TIUCLLST,"SYS","TIU TEMPLATE ACCESS BY CLASS","Q",.TIUERR)
        .I TIUERR>0 Q
        .S IDX=0
        .F  S IDX=$O(TIUCLLST(IDX)) Q:'IDX  D
        ..I $$ISA^USRLM(USER,$P(TIUCLLST(IDX),U),.TIUERR) D
        ...S TMP=+$P(TIUCLLST(IDX),U,2)
        ...I +TIUY'>TMP S TIUY=TMP
        I TIUY="" D
        .N XPARSRCH,SERVICE
        .I +$G(LOC) S XPARSRCH=LOC_";SC("_U
        .E  S XPARSRCH=""
        .S SERVICE=$P($G(^VA(200,USER,5)),U)
        .I +SERVICE>0 S XPARSRCH=XPARSRCH_SERVICE_";DIC(49,"_U
        .S XPARSRCH=XPARSRCH_"DIV^SYS"
        .S TIUY=$$GET^XPAR(XPARSRCH,"TIU PERSONAL TEMPLATE ACCESS")
        I TIUY="" S TIUY=0
        Q
GETDFLT(TIUY)   ;Returns Default Templates for the current user
        N TIUTMP,TIUERR
        D GETLST^XPAR(.TIUTMP,"USR","TIU DEFAULT TEMPLATES","Q",.TIUERR)
        S TIUY=$P($G(TIUTMP(1)),U,2)
        Q
SETDFLT(TIUY,SETTINGS)  ;Saves Default Templates for the user
        N TIUERR
        D EN^XPAR(DUZ_";VA(200,","TIU DEFAULT TEMPLATES",1,SETTINGS,.TIUERR)
        S TIUY=1
        Q
LSTACCUM(TIUY,TIULVL,TYP,PARAM) ; Accumulates TIUTMP into TIUY
        N IDX,I,J,FOUND,TIUERR,TIUTMP
        D GETLST^XPAR(.TIUTMP,TIULVL,PARAM,TYP,.TIUERR)
        S I=0,IDX=$O(TIUY(999999),-1)+1
        F  S I=$O(TIUTMP(I)) Q:'I  D
        .S (FOUND,J)=0
        .F  S J=$O(TIUY(J)) Q:'J  D  Q:FOUND
        ..I TIUY(J)=TIUTMP(I) S FOUND=1
        .I 'FOUND D
        ..S TIUY(IDX)=TIUTMP(I)
        ..S IDX=IDX+1
        Q
RDACCUM(TIUY,TIULVL,TYP)        ; Accumulates Reminder Dialog List
        D LSTACCUM(.TIUY,TIULVL,TYP,"TIU TEMPLATE REMINDER DIALOGS")
        Q
REMDLGS(TIUY)   ;Returns a list of all reminder dialogs usable in templates
        N SRV
        K TIUY
        D RDACCUM(.TIUY,"USR","N")
        S SRV=$P($G(^VA(200,DUZ,5)),U)
        D RDACCUM(.TIUY,"SRV.`"_+$G(SRV),"N")
        D RDACCUM(.TIUY,"DIV","N")
        D RDACCUM(.TIUY,"SYS","N")
        Q
RDINLST(TIULST,TIUIEN)  ; Searches TIULST for TIUIEN
        N IDX,RES
        S (IDX,RES)=0
        F  S IDX=$O(TIULST(IDX)) Q:'IDX  D  Q:+RES
        . I $P(TIULST(IDX),U,2)=TIUIEN S RES=1
        K TIUIEN
        Q RES
REMDLGOK(TIUY,TIUIEN)   ;Returns TRUE if the passed in Reminder Dialog IEN is
        ;                Allowed to be used as a TIU Template
        N TIULST,SRV
        S TIUY=-1
        I '$D(^PXRMD(801.41,+$G(TIUIEN))) Q
        ;I $P(^PXRMD(801.41,+$G(TIUIEN),0),U,3)'="" Q
        I +$P(^PXRMD(801.41,+$G(TIUIEN),0),U,3)>0 Q
        S TIUY=1
        D RDACCUM(.TIULST,"USR","Q")
        I $$RDINLST(.TIULST,TIUIEN) Q
        S SRV=$P($G(^VA(200,DUZ,5)),U)
        D RDACCUM(.TIULST,"SRV.`"_+$G(SRV),"Q")
        I $$RDINLST(.TIULST,TIUIEN) Q
        D RDACCUM(.TIULST,"DIV","Q")
        I $$RDINLST(.TIULST,TIUIEN) Q
        D RDACCUM(.TIULST,"SYS","Q")
        I $$RDINLST(.TIULST,TIUIEN) Q
        S TIUY=0
        Q
OBJACCUM(TIUY,TIULVL)   ; Accumulates Reminder Dialog List
        D LSTACCUM(.TIUY,TIULVL,"N","TIU TEMPLATE PERSONAL OBJECTS")
        Q
PERSOBJS(TIUY)  ; Returns the list of Patient Data Objects that are
        ;         allowed to be used in Personal Templates
        N SRV
        K TIUY
        D OBJACCUM(.TIUY,"USR")
        S SRV=$P($G(^VA(200,DUZ,5)),U)
        I +SRV D OBJACCUM(.TIUY,"SRV.`"_+$G(SRV))
        D OBJACCUM(.TIUY,"DIV")
        D OBJACCUM(.TIUY,"SYS")
        Q
LOCK(TIUY,TIUDA)        ; Lock Template
        L +^TIU(8927,TIUDA,0):1
        S TIUY=$T
        Q
UNLOCK(TIUY,TIUDA)      ; Unlock Template
        L -^TIU(8927,TIUDA,0):1
        S TIUY=1
        Q
