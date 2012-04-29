PXRMETT ; SLC/PJH - Extract Summary Display ;04/09/2007
        ;;2.0;CLINICAL REMINDERS;**4,6**;Feb 04, 2005;Build 123
        ;
        ;Main entry point for PXRM EXTRACT SUMMARY
START(IEN)      N TOGGLE,TOGGLE1,VALMBCK,VALMBG,VALMCNT,VALMSG,X,XMZ,XQORM,XQORNOD
        S X="IORESET"
        D ENDR^%ZISS
        S VALMCNT=0,TOGGLE=0,TOGGLE1=0
        D EN^VALM("PXRM EXTRACT SUMMARY")
        Q
        ;
BLDLIST(IEN,FINDINGS,PATIENT)   ;Build workfile.
        ;FINDINGS=1 means display finding totals
        K ^TMP("PXRMETT",$J)
        ;Build a list of extract summary totals.
        N APPL,DATA,DUE,IND,LIST,NDUE,NAPPL,OLIST
        N PLCNT,PLIST,RIEN,RNAME,SARRAY,SEQ,SNAME,STATION,TOT
        ;Build the list in alphabetical order.
        S VALMCNT=0,OLIST="",PLCNT=0
        S IND=0 F  S IND=$O(^PXRMXT(810.3,IEN,3,IND)) Q:IND'>0  D
        .S DATA=$G(^PXRMXT(810.3,IEN,3,IND,0)) Q:DATA=""
        .S RIEN=$P(DATA,U,2) Q:'RIEN
        .S RNAME=$P(^PXD(811.9,RIEN,0),U,3)
        .I RNAME="" S RNAME=$P(^PXD(811.9,RIEN,0),U,1)
        .S STATION=$P(DATA,U,3),SARRAY=""
        .D GETS^DIQ(4,STATION,99,"E","SARRAY")
        .S SNAME=$G(SARRAY(4,STATION_",",99,"E"))
        .I SNAME="" S SNAME=STATION
        .S TOT=+$P(DATA,U,5),APPL=+$P(DATA,U,6),NAPPL=+$P(DATA,U,7)
        .S DUE=+$P(DATA,U,8),NDUE=+$P(DATA,U,9)
        .S PLIST=$P(DATA,U,4)
        .I PLIST,PLIST'=OLIST D
        ..I PLCNT>0 D
        ...S VALMCNT=VALMCNT+1
        ...S ^TMP("PXRMETT",$J,VALMCNT,0)=""
        ...S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        ..S PLNAME=$P($G(^PXRMXP(810.5,PLIST,0)),U),OLIST=PLIST Q:PLNAME=""
        ..S VALMCNT=VALMCNT+1,PLCNT=PLCNT+1
        ..S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        ..S ^TMP("PXRMETT",$J,"SEL",PLCNT)=PLIST
        ..S ^TMP("PXRMETT",$J,VALMCNT,0)=$$RJ^XLFSTR(PLCNT,4," ")_" "_PLNAME
        .S VALMCNT=VALMCNT+1
        .S ^TMP("PXRMETT",$J,VALMCNT,0)=$$FRE(VALMCNT,RNAME,SNAME,TOT,APPL,NAPPL,DUE,NDUE)
        .S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        .;Finding totals
        .I +FINDINGS>0 D FBLD(PATIENT)
        ;
        S ^TMP("PXRMETT",$J,"VALMCNT")=VALMCNT
        Q
        ;
ENTRY   ;Entry code
        D BLDLIST(IEN,TOGGLE,TOGGLE1),XQORM
        Q
        ;
EXIT    ;Exit code
        K ^TMP("PXRMETT",$J)
        K ^TMP("PXRMETTH",$J)
        D CLEAN^VALM10
        D FULL^VALM1
        S VALMBCK="Q"
        Q
        ;
FBLD(PATIENT)   ;Build finding list
        N APPL,DATA,DUE,ETYP,EVAL,GNAM,GTYP
        N NAPPL,NDUE,OGNAM,SEQ,SUB,TIEN,TNAME,TOTAL
        S SUB=0,OGNAM=""
        F  S SUB=$O(^PXRMXT(810.3,IEN,3,IND,1,SUB)) Q:'SUB  D
        .S DATA=$G(^PXRMXT(810.3,IEN,3,IND,1,SUB,0)) Q:DATA=""
        .S TIEN=$P(DATA,U,2) Q:'TIEN
        .S TNAME=$P($G(^PXRMD(811.5,TIEN,0)),U)
        .S SEQ=$P(DATA,U),ETYP=$P(DATA,U,3),GNAM=$P(DATA,U,9),GTYP=$P(DATA,U,10)
        .S TOT=+$P(DATA,U,4),APPL=+$P(DATA,U,5),NAPPL=+$P(DATA,U,6)
        .S DUE=+$P(DATA,U,7),NDUE=+$P(DATA,U,8)
        .I OGNAM'=GNAM D
        ..I OGNAM'="" D
        ...S VALMCNT=VALMCNT+1
        ...S ^TMP("PXRMETT",$J,VALMCNT,0)=""
        ...S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        ..S OGNAM=GNAM,VALMCNT=VALMCNT+1
        ..S ^TMP("PXRMETT",$J,VALMCNT,0)=$$RJ^XLFSTR("Counting Group: ",21)_GNAM
        ..S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)="",VALMCNT=VALMCNT+1
        ..S ^TMP("PXRMETT",$J,VALMCNT,0)=$J("",6)_$$LJ^XLFSTR($$TXT^PXRMEPM(ETYP,GTYP),49)
        ..S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        .S VALMCNT=VALMCNT+1
        .S ^TMP("PXRMETT",$J,VALMCNT,0)=$$FREF(VALMCNT,TNAME,SEQ,TOT,APPL,NAPPL,DUE,NDUE,ETYP)
        .S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        .I +PATIENT>0 D PBLD(IEN,IND,SUB)
        S VALMCNT=VALMCNT+1
        S ^TMP("PXRMETT",$J,VALMCNT,0)=""
        S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        Q
        ;
FLIST   ;Toggle list with/without finding totals
        S TOGGLE=(TOGGLE+1)#2
        I TOGGLE=0 S TOGGLE1=0
        ;Rebuild Workfile
        D BLDLIST(IEN,TOGGLE,TOGGLE1)
        ;Refresh
        S VALMBCK="R",VALMBG=1
        Q
        ;
FRE(NUMBER,NAME,SNAME,TOT,APPL,NAPPL,DUE,NDUE)  ;Format reminder entry
        N TEMP,TNAME,TSOURCE
        S TEMP="     "
        S TNAME=SNAME_"/"_$E(NAME,1,35-$L(SNAME))
        S TEMP=TEMP_$$LJ^XLFSTR(TNAME,36," ")
        S TEMP=TEMP_$$RJ^XLFSTR(TOT,8," ")
        S TEMP=TEMP_$$RJ^XLFSTR(APPL,8," ")
        S TEMP=TEMP_$$RJ^XLFSTR(NAPPL,7," ")
        S TEMP=TEMP_$$RJ^XLFSTR(DUE,7," ")
        S TEMP=TEMP_$$RJ^XLFSTR(NDUE,7," ")
        Q TEMP
        ;
FREF(NUMBER,NAME,SNAME,TOT,APPL,NAPPL,DUE,NDUE,ETYP)    ;Format finding entry
        N TEMP,TNAME,TSOURCE
        S TEMP="      "
        S TNAME=$E(NAME,1,31)
        S TEMP=TEMP_"  "_$$LJ^XLFSTR(TNAME,31," ")
        S TEMP=TEMP_"  "_$$RJ^XLFSTR(TOT,8," ")
        I ETYP'="FC" D
        .S TEMP=TEMP_$$RJ^XLFSTR(APPL,8," ")
        .S TEMP=TEMP_$$RJ^XLFSTR(NAPPL,7," ")
        .S TEMP=TEMP_$$RJ^XLFSTR(DUE,7," ")
        .S TEMP=TEMP_$$RJ^XLFSTR(NDUE,7," ")
        Q TEMP
        ;
HDR     ; Header code
        S VALMHDR(1)="Extract Summary Name: "_$P($G(^PXRMXT(810.3,IEN,0)),U)
        S VALMHDR(2)="      Extract Period: "_$$FMTE^XLFDT($P($G(^PXRMXT(810.3,IEN,0)),U,2),"5Z")_" - "_$$FMTE^XLFDT($P($G(^PXRMXT(810.3,IEN,0)),U,3),"5Z")
        S VALMHDR(2)=VALMHDR(2)_"   Created: "_$$FMTE^XLFDT($P($G(^PXRMXT(810.3,IEN,0)),U,6),"5Z")
        S VALMSG="+ Next Screen   - Prev Screen   ?? More Actions"
        Q
        ;
HLP     ;Help code
        N ORU,ORUPRMT,XQORM
        S SUB="PXRMETTH"
        D EN^VALM("PXRM EXTRACT HELP")
        Q
        ;
INIT    ;Init
        S VALMCNT=0
        Q
        ;
PBLD(IEN,IND,SUB)       ;
        N ARRAY,NAME,LEN,PCNT,DFN,CNT,USTR
        S VALMCNT=VALMCNT+1,CNT=0
        S PCNT=0 F  S PCNT=$O(^PXRMXT(810.3,IEN,3,IND,1,SUB,1,PCNT)) Q:PCNT'>0  D
        .S DFN=$P($G(^PXRMXT(810.3,IEN,3,IND,1,SUB,1,PCNT,0)),U) Q:DFN'>0
        .S NAME=$P($G(^DPT(DFN,0)),U)
        .S CNT=CNT+1,ARRAY(NAME)=""
        S ^TMP("PXRMETT",$J,VALMCNT,0)="     "_$$RJ^XLFSTR("Unique Applicable Patients ("_CNT_")",36," ")
        S USTR=$P($G(^TMP("PXRMETT",$J,VALMCNT,0)),"U"),LEN=$L(USTR)
        S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        S NAME="" F  S NAME=$O(ARRAY(NAME)) Q:NAME=""  D
        .S VALMCNT=VALMCNT+1
        .S ^TMP("PXRMETT",$J,VALMCNT,0)=USTR_$$LJ^XLFSTR(NAME,36," ")
        .S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        S VALMCNT=VALMCNT+1
        S ^TMP("PXRMETT",$J,VALMCNT,0)="  "
        S ^TMP("PXRMETT",$J,"IDX",VALMCNT,PLCNT)=""
        Q
        ;
PEXIT   ;Protocol exit code
        S VALMSG="+ Next Screen   - Prev Screen   ?? More Actions"
        D XQORM
        Q
        ;
PLIST(IEN)      ;Patient list display
        N IND,PLIEN,VALMY
        D EN^VALM2(XQORNOD(0))
        ;If there is no list quit.
        I '$D(VALMY) Q
        ;PXRMDONE is newed in PXRMLPM
        S PXRMDONE=0
        S IND=""
        F  S IND=$O(VALMY(IND)) Q:(+IND=0)!(PXRMDONE)  D
        .;Get the ien.
        .S PLIEN=^TMP("PXRMETT",$J,"SEL",IND)
        .D START^PXRMLPP(PLIEN)
        S VALMBCK="R"
        Q
        ;
PLIST1  ;Toggle list with/without finding totals
        S TOGGLE1=(TOGGLE1+1)#2
        ;Rebuild Workfile
        D BLDLIST(IEN,TOGGLE,TOGGLE1)
        ;Refresh
        S VALMBCK="R",VALMBG=1
        Q
        ;
XQORM   S XQORM("#")=$O(^ORD(101,"B","PXRM EXTRACT SUMMARY SELECT ENTRY",0))_U_"1:"_VALMCNT
        S XQORM("A")="Select Item: "
        Q
        ;
XSEL    ;PXRM EXTRACT TOTALS SELECT ENTRY validation
        N SEL,PLIEN
        S SEL=$P(XQORNOD(0),"=",2)
        ;Remove trailing ,
        I $E(SEL,$L(SEL))="," S SEL=$E(SEL,1,$L(SEL)-1)
        ;Invalid selection
        I SEL["," D  Q
        .W $C(7),!,"Only one item number allowed." H 2
        .S VALMBCK="R"
        I ('SEL)!(SEL>VALMCNT)!('$D(@VALMAR@("SEL",SEL))) D  Q
        .W $C(7),!,SEL_" is not a valid item number." H 2
        .S VALMBCK="R"
        ;Get the list ien.
        S PLIEN=^TMP("PXRMETT",$J,"SEL",SEL)
        D START^PXRMLPP(PLIEN)
        S VALMBCK="R"
        Q
        ;
