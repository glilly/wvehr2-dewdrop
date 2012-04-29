SROESPR1        ;BIR/ADM - SURGERY E-SIG UTILITY ; [ 04/21/04  12:08 PM ]
        ;;3.0; Surgery ;**100,128,162**;24 Jun 93;Build 4
        ;
        ;** NOTICE: This routine is part of an implementation of a nationally
        ;**         controlled procedure.  Local modifications to this routine
        ;**         are prohibited.
        ;
        ; Reference to EXTRACT^TIULQ supported by DBIA #2693
        ;
        ; This routine was cloned in part or in whole from TIUPRPN1.
PRINT(SRFLAG,SRSPG)     ; Print Summary
        ; ^TMP("SRPR",$J) is array of records passed by reference
        ; SRFLAG=1 --> Chart Copy     SRSPG=1 --> Contiguous
        ; SRFLAG=0 --> Work Copy      SRSPG=0 --> Fresh Page- each note
        N SRI,SRJ,SRPAGE,SRFOOT,SRK,SRDA,SRCONT,SRPGRP,SRTYP
        N SRPFHDR,SRPFNBR,SROPAGE
        S SRFLAG=+$G(SRFLAG),SRSPG=+$G(SRSPG)
        S SRI=0 F  S SRI=$O(^TMP("SRPR",$J,SRI)) Q:SRI=""  D  Q:'SRCONT
        . N DFN,SR,SRERR
        . I SRI["$" S SRPGRP=$P(SRI,"$"),SRPFHDR=$P($P(SRI,";"),"$",2)
        . E  S SRPFHDR="Surgery Reports"
        . I $G(SRPGRP)'=2 S SRSPG=0
        . S DFN=$P(SRI,";",2)
        . D PAT^SROESPR(.SRFOOT,DFN)
        . I +$G(SRSPG) D HEADER^SROESPR2(.SRFOOT,SRFLAG,.SRPFHDR)
        . S SRJ=0 F  S SRJ=$O(^TMP("SRPR",$J,SRI,SRJ)) Q:'SRJ  D  Q:'SRCONT
        . . S SRK=0 F  S SRK=$O(^TMP("SRPR",$J,SRI,SRJ,SRK)) Q:'SRK  D  Q:'+$G(SRCONT)
        . . . N SRERR1,SRW K SRCONT1 S SRPFNBR=^(SRK)
        . . . ; If the document has been deleted, QUIT
        . . . D EXTRACT^TIULQ(SRK,"SRW",.SRERR1,".01") I $P($G(SRERR1),"^")=1 S SRCONT=1 Q
        . . . I '+$G(SRSPG) D HEADER^SROESPR2(.SRFOOT,SRFLAG,.SRPFHDR)
        . . . S SRDA=SRK
        . . . D REPORT(SRDA) Q:'+$G(SRCONT)
        . . . I '+$G(SRSPG) K SRCONT1 D SETCONT(1)
        . . . I $E(IOST)="C",'$O(^TMP("SRPR",$J,SRI,SRJ,SRK)) S SRCONT=0
        . Q:'SRCONT  I $E(IOST)="C" S SRCONT=$$STOP^SROESPR2() Q:'SRCONT
        . I +$G(SRSPG),$E(IOST)'="C" K SRCONT1 D SETCONT(1)
        Q
REPORT(SRDA)    ; Report Text
        N DIW,DIWF,DIWL,DIWR,DIWT,SRERR,SR,SRI,SRLINE,X,Z,SRY,LOC
        K ^TMP("SRLQ",$J)
        S SRLINE=0
        D EXTRACT^TIULQ(+SRDA,"^TMP(""SRLQ"",$J)",.SRERR,"",SRLINE,1)
        I +$G(SRERR) W !,$P(SRERR,U,2) Q
        Q:'$D(^TMP("SRLQ",$J))
        S SRY=4,SRCONT=1
        D SETCONT() Q:'SRCONT
        W "NOTE DATED: "
        W $$DATE^SROESPR(^TMP("SRLQ",$J,SRDA,1301,"I"),"MM/DD/CCYY HR:MIN")
        W ?30,$$UP^XLFSTR(^TMP("SRLQ",$J,SRDA,.01,"E")),!
        I +$G(^TMP("SRLQ",$J,SRDA,1205,"I")) D
        .S LOC=$G(^TMP("SRLQ",$J,SRDA,1205,"I")) Q:'$D(^SC(LOC,0))
        .W $S($P(^SC(LOC,0),U,3)="W":"ADMITTED: ",1:"VISIT: ")
        .W $$DATE^SROESPR(^TMP("SRLQ",$J,SRDA,.07,"I"),"MM/DD/CCYY HR:MIN")
        .W " ",$G(^TMP("SRLQ",$J,SRDA,1205,"E"))
        I ^TMP("SRLQ",$J,SRDA,1701,"E")]"" W !,"SUBJECT: ",^("E"),!
        S SRCONT1=1
        I $D(^TMP("SRLQ",$J,SRDA,"PROBLEM")) D  Q:'SRCONT
        .D SETCONT() Q:'SRCONT
        .W !,"ASSOCIATED PROBLEMS:"
        .N SRI S SRI=0
        .F  S SRI=$O(^TMP("SRLQ",$J,SRDA,"PROBLEM",SRI)) Q:'SRI  D  Q:'SRCONT
        ..W !,^(SRI,0)
        ..D SETCONT() Q:'SRCONT
        W !
        ;
        S SRI=0,DIWF="WN",DIWL=1,DIWR=79 K ^UTILITY($J,"W")
        F  S SRI=$O(^TMP("SRLQ",$J,SRDA,"TEXT",SRI)) Q:SRI'>0  D  Q:'SRCONT  ; D ^DIWW
        . D SETCONT() Q:'SRCONT
        . S X=^TMP("SRLQ",$J,SRDA,"TEXT",SRI,0) S:X="" X=" " D ^DIWP
        D ^DIWW K ^UTILITY($J,"W")
        Q:'SRCONT
RPTSIG  ; Signature should be on bottom of form, Addenda on Subsequent pages
        N AUTHOR,EXPSIGNR,EXPCOSNR,SIGNDATE,SIGNEDBY,SIGNNAME,SIGTITL,SIGNMODE
        N COSGDATE,COSGEDBY,COSGNAME,COSGTITL,COSGMODE,SIGCHRT,COSCHRT,SRLINE
        S $P(SRLINE,"-",81)=""
        S AUTHOR=$G(^TMP("SRLQ",$J,SRDA,1202,"I"))_";"_$G(^("E"))
        S EXPSIGNR=$G(^TMP("SRLQ",$J,SRDA,1204,"I"))_";"_$G(^("E"))
        S EXPCOSNR=$G(^TMP("SRLQ",$J,SRDA,1208,"I"))_";"_$G(^("E"))
        S SIGNDATE=$G(^TMP("SRLQ",$J,SRDA,1501,"I"))
        S SIGNEDBY=$G(^TMP("SRLQ",$J,SRDA,1502,"I"))_";"_$G(^("E"))
        S SIGNNAME=$G(^TMP("SRLQ",$J,SRDA,1503,"E"))
        S SIGTITL=$G(^TMP("SRLQ",$J,SRDA,1504,"E"))
        S SIGNMODE=$G(^TMP("SRLQ",$J,SRDA,1505,"I"))_";"_$G(^("E"))
        S COSGDATE=$G(^TMP("SRLQ",$J,SRDA,1507,"I"))
        S COSGEDBY=$G(^TMP("SRLQ",$J,SRDA,1508,"I"))_";"_$G(^("E"))
        S COSGNAME=$G(^TMP("SRLQ",$J,SRDA,1509,"E"))
        S COSGTITL=$G(^TMP("SRLQ",$J,SRDA,1510,"E"))
        S COSGMODE=$G(^TMP("SRLQ",$J,SRDA,1511,"I"))_";"_$G(^("E"))
        S SIGCHRT=$G(^TMP("SRLQ",$J,SRDA,1512,"I"))_";"_$G(^("E"))
        S COSCHRT=$G(^TMP("SRLQ",$J,SRDA,1513,"I"))_";"_$G(^("E"))
        D SETCONT() Q:'SRCONT  W !
        D SIGBLK Q:'SRCONT
ADDENDA ; Surgery Reports Addenda
        N DIW,DIWF,DIWL,DIWR,DIWT,X,Z,SRI,SRADD
        S SRADD=0,DIWF="WN",DIWL=1,DIWR=79 K ^UTILITY($J,"W")
        F  S SRADD=$O(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD)) Q:SRADD'>0  D  Q:'SRCONT
        . S SRY=4 D SETCONT() Q:'SRCONT
        . W !!,$$DATE^SROESPR(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1301,"I"),"MM/DD/CCYY HR:MIN"),?21,"ADDENDUM"
        . W ?41,"STATUS: ",^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,.05,"E")
        . S SRI=0
        . F  S SRI=$O(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,"TEXT",SRI)) Q:SRI'>0  D  Q:'SRCONT
        . . D SETCONT() Q:'SRCONT
        . . S X=^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,"TEXT",SRI,0) S:X="" X=" " D ^DIWP
        . D ^DIWW
        . D:SRCONT ADDENSIG
        K ^UTILITY($J,"W")
        ; Write 2 linefeeds between records
        Q:'SRCONT  W !!
        Q
ADDENSIG        ;
        N AUTHOR,EXPSIGNR,ATTNDING,SIGNDATE,SIGNEDBY,SIGNNAME,SIGNMODE
        N COSGDATE,COSGEDBY,COSGNAME,COSGMODE,SRLINE S $P(SRLINE,"-",80)=""
        S AUTHOR=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1202,"I"))_";"_$G(^("E"))
        S EXPSIGNR=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1204,"I"))_";"_$G(^("E"))
        S ATTNDING=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1209,"I"))_";"_$G(^("E"))
        S SIGNDATE=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1501,"I"))
        S SIGNEDBY=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1502,"I"))_";"_$G(^("E"))
        S SIGNNAME=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1503,"E"))
        S SIGTITL=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1504,"E"))
        S SIGNMODE=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1505,"I"))_";"_$G(^("E"))
        S COSGDATE=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1507,"I"))
        S COSGEDBY=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1508,"I"))_";"_$G(^("E"))
        S COSGNAME=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1509,"E"))
        S COSGTITL=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1510,"E"))
        S COSGMODE=$G(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD,1511,"I"))_";"_$G(^("E"))
        S SRY=11
SIGBLK  N SRGROOT S SRGROOT=$NA(^TMP("SRLQ",$J,SRDA))
        I '+SIGNDATE D  D SETCONT() Q:'SRCONT
        .I $$STATUS^SROESUTL(SRDA)'=7 W !,"**DRAFT COPY - DRAFT COPY -- ABOVE NOTE IS UNSIGNED-- DRAFT COPY - DRAFT COPY**"
        I SIGNEDBY]"",(+SIGNEDBY'=+AUTHOR)  D
        . W ?21,"Author:      ",$P(AUTHOR,";",2),!
        I +SIGNDATE D SETCONT() Q:'SRCONT  D
        . W ?18,"Signed by:",$S($P(SIGNMODE,";")="C":" /s/  ",1:" /es/ "),?34,$S(SIGNNAME]"":SIGNNAME,1:$P(SIGNEDBY,";",2))
        . W !?34,SIGTITL
        . I $L(SIGTITL)>30 W !?34
        . E  W " "
        . W $$DATE^SROESPR(+SIGNDATE,"MM/DD/CCYY HR:MIN")
        . I '+$G(SRFLAG)!($E(IOST)="C") D
        . . I $P($$BEEP^SROESPR(+SIGNEDBY),U) W !?34,"Analog Pager:  ",$P($$BEEP^SROESPR(+SIGNEDBY),U)
        . . I $P($$BEEP^SROESPR(+SIGNEDBY),U,2) W !?34,"Digital Pager: ",$P($$BEEP^SROESPR(+SIGNEDBY),U,2)
        I $G(^TMP("SRLQ",$J,SRDA,.05,"E"))="UNCOSIGNED" D
        . W !?34,"**REQUIRES COSIGNATURE**",!
        I +SIGCHRT,$P(SIGNMODE,";")="C" D SETCONT() Q:'SRCONT  D
        . W !?2,"Marked signed on chart by:",?34,$P(SIGCHRT,";",2)
        I +$G(SRADD) S SRGROOT=$NA(^TMP("SRLQ",$J,SRDA,"ZADD",SRADD))
        I +$D(@SRGROOT@("EXTRASGNR")) D
        . N SRI S SRI=0
        . D SETCONT() Q:'SRCONT  W !?4,"Receipt Acknowledged By:"
        . F  S SRI=$O(@SRGROOT@("EXTRASGNR",SRI)) Q:'SRI  D
        . . I +$G(@SRGROOT@("EXTRASGNR",SRI,"DATE"))'>0 Q
        . . I SRI>1 D SETCONT() Q:'SRCONT  W !
        . . W ?29,"/es/ ",$G(@SRGROOT@("EXTRASGNR",SRI,"NAME"))
        . . W !?34,$G(@SRGROOT@("EXTRASGNR",SRI,"TITLE"))
        . . I $L($G(@SRGROOT@("EXTRASGNR",SRI,"TITLE")))>30 W !?34
        . . E  W " "
        . . W $$DATE^SROESPR($G(@SRGROOT@("EXTRASGNR",SRI,"DATE")),"MM/DD/CCYY HR:MIN")
        . . I '+$G(SRFLAG)!($E(IOST)="C") D
        . . . N BEEP
        . . . S BEEP=$$BEEP^SROESPR(+$G(@SRGROOT@("EXTRASGNR",SRI,"EXTRA")))
        . . . I +BEEP W !?34,"Analog Pager:  ",$P(BEEP,U)
        . . . I +$P(BEEP,U,2) W !?34,"Digital Pager: ",$P(BEEP,U,2)
        . K @SRGROOT@("EXTRASGNR")
        I +COSGDATE,(+COSGEDBY'=+SIGNEDBY) D SETCONT() Q:'SRCONT  D
        . W !?16,"Cosigned by:",$S($P(COSGMODE,";")="C":" /s/  ",1:" /es/ "),?34,$S(COSGNAME]"":COSGNAME,1:$P(COSGEDBY,";",2))
        . W !?34,COSGTITL," "
        . W $$DATE^SROESPR(+COSGDATE,"MM/DD/CCYY HR:MIN")
        . I '+$G(SRFLAG)!($E(IOST)="C") D
        . . I $P($$BEEP^SROESPR(+COSGEDBY),U) W !?34,"Analog Pager: ",$P($$BEEP^SROESPR(+COSGEDBY),U)
        . . I $P($$BEEP^SROESPR(+COSGEDBY),U,2) W !?34,"Digital Pager:",$P($$BEEP^SROESPR(+COSGEDBY),U,2)
        I +COSCHRT,$P(COSGMODE,";")="C" D SETCONT() Q:'SRCONT  D
        . W !,"Marked cosigned on chart by:",?34,$P(COSCHRT,";",2)
        W !
        K SRCONT1
AMEND   ; signature blocks of amender
        S SRY=4 D SETCONT() Q:'SRCONT
        I +$G(@SRGROOT@(1601,"I")) D
        . W !!?12,"Amendment Filed:",?34,$$DATE^SROESPR(@SRGROOT@(1601,"I"),"MM/DD/CCYY HR:MIN")
        . I $G(@SRGROOT@(1603,"E"))']"" D
        . . W !!?29 F SRI=1:1:40 W "_"
        . . W !?29,$$SIGNAME^SROESPR(@SRGROOT@(1602,"I"))
        . . W !?29,$$SIGTITL^SROESPR(@SRGROOT@(1602,"I"))
        . I $G(@SRGROOT@(1604,"E"))]"" D
        . . W !?29,"/es/",?34,@SRGROOT@(1604,"E")
        . . W !?34,@SRGROOT@(1605,"E")
        Q
SETCONT(SRHEAD) ;Does footer and sets SRCONT
        S SRCONT=$$FOOTER^SROESPR2(.SRFOOT,SRFLAG,SRPFNBR,$G(SRHEAD),$G(SRCONT1),SRDA)
        Q
