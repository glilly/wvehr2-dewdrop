TIU215R ;VMP/RJT - Utililty to analyze problems cause by PATCH TIU*1.0*215 ; 7/25/2007
        ;;1.0;TEXT INTEGRATION UTILITIES;**231**;Jun 20, 1997;Build 63
        ; DBIA 4502 TO ACCESS SURGERY FILE
        ; DBIA 5025 ACCESS ROUTINE SROANR
        ; DBIA 5024 ACCESS ROUTINE SRONRP
STRT    ;
        W !!
EN      NEW SRTN,TIUDA,TIUVAL,TIUCHKSU,SRVAL,SRCHKSUM,TIUDT,SRTNA,TIUEND,TIUACNT,TIUER,TIUFDEL,TIUADEL
        NEW TIUA,TIUDAD,TIUDFN,TIUDONE,TIUNAM,TIUND,TIUX,TIUERR,SURFNAME,TIUFNAME,TIUPATH,SURFILEN,TIUFILEN
        NEW TIUIO,SURIO,TIUCPF,TIUAIO,TIUANAME
        S U="^",SURFILEN=1,TIUFILEN=1,TIUACNT=0
        K ^TMP("TIUSNIR",$J),^TMP("SRNIR",$J)
        S DIR("A")="Enter a begin date to start searching Surgery cases "
        S DIR(0)="D^:DT:EX"
        D ^DIR
        I $D(DIRUT) K DIRUT Q
        K DIR
        S TIUDT=+Y
        S DIR("A")="Enter date patch was backed out"
        S DIR(0)="D^"_TIUDT_":DT:EX"
        D ^DIR
        K DIR
        I $D(DIRUT) K DIRUT G STRT
        S TIUEND=+Y
        S DIR("A")="Enter the maximum number of cases per file"
        S DIR(0)="N^5:50"
        D ^DIR
        K DIR
        I $D(DIRUT) K DIRUT G STRT
        S TIUCPF=Y
PATH    ;
        K TIUFDEL
        S DIR("A")="Enter the path of the output files"
        S DIR(0)="F"
        S DIR("?")=" "
        S DIR("?",1)="Enter file path as USER$:[<DIRECTORY NAME>]"
        D ^DIR
        I $D(DIRUT) K DIRUT G STRT
        S TIUPATH=Y
        K DIR
        S DIR("A")="Surgery output file (without file extension)"
        S DIR(0)="F"
        D ^DIR
        K DIR
        I $D(DIRUT) K DIRUT G PATH
        S SURFNAME=Y
        D OPENS I POP'=0 G PATH
        S TIUFDEL(SURFNAME_SURFILEN_".TXT")=""
        D CLOSE^%ZISH("SUR"_SURFILEN)
        S DIR("A")="TIU output file (without file extension)"
        S DIR(0)="F"
        D ^DIR I $D(DIRUT) S TIUER=$$DEL^%ZISH(TIUPATH,$NA(TIUFDEL)) D ERR:'TIUER K DIR,DIRUT G PATH
        S TIUFNAME=Y
        K DIR
        D OPENT I POP'=0 S TIUER=$$DEL^%ZISH(TIUPATH,$NA(TIUFDEL)) D ERR:'TIUER K DIR G PATH
        S TIUFDEL(TIUFNAME_TIUFILEN_".TXT")=""
        D CLOSE^%ZISH("TIU"_TIUFILEN)
        S DIR("A")="TIU Addenda output file (without file extension)"
        S DIR(0)="F"
        D ^DIR I $D(DIRUT) S TIUER=$$DEL^%ZISH(TIUPATH,$NA(TIUFDEL)) D ERR:'TIUER K DIR,DIRUT G PATH
        S TIUANAME=Y
        K DIR
        D OPENA I POP'=0 S TIUER=$$DEL^%ZISH(TIUPATH,$NA(TIUFDEL)) D ERR:'TIUER K DIR G PATH
        S TIUADEL(TIUANAME_TIUFILEN_".TXT")=""
        D CLOSE^%ZISH("TIUA"_TIUFILEN)
        W !!!,"Processing...",!
        S TIUIO=TIUPATH_TIUFNAME,SURIO=TIUPATH_SURFNAME,TIUAIO=TIUPATH_TIUANAME
        K TIUFDEL
EN1     ;
        NEW TIUCNT,TIURECNT,SURRECNT,TIUCOUNT,SURDT,SURDONE S TIUCNT=0,TIURECNT=0,SURRECNT=0,TIUCOUNT=0
        ; LOOP THROUGH SURGERY CASES WITHIN DATE RANGE
        S (TIUDT,SURDT)=TIUDT-.0001
        F  S SURDT=$O(^SRF("AC",SURDT)) Q:'$L(SURDT)  Q:SURDT\1>TIUEND  D
        . S TIUA=0 F  S TIUA=$O(^SRF("AC",SURDT,TIUA)) Q:TIUA'>0  D
        . . S SURDONE="" D CHK,CHK1
        I TIUACNT=0 S TIUER=$$DEL^%ZISH(TIUPATH,$NA(TIUADEL))
EN2     ; 
        W !,"There were "_TIUCOUNT_" records found to be discrepant.",!
        Q
        ; BUILD TMP GLOBALS AND COMPARE NIR CASES
CHK     S SRTN=TIUA
        S TIUDA=$P($G(^SRF(SRTN,"TIU")),"^",2)
        Q:+TIUDA'>0
        ;DONT EVALUATE UNDICTATED
        Q:$P($G(^TIU(8925,TIUDA,0)),U,5)=1
        S TIUDFN=$P($G(^TIU(8925,TIUDA,0)),U,2)
        K ^TMP("TIUSNIR",$J),^TMP("SRNIR",$J)
        D RPT^SRONRPT(SRTN)
        ;STRIP OUT SUBFILE DATA
        S TIUX=0
        F  S TIUX=$O(^TIU(8925,+TIUDA,"TEXT",TIUX)) Q:TIUX=""  D
        . S ^TMP("TIUSNIR",$J,TIUDA,TIUX)=$G(^TIU(8925,+TIUDA,"TEXT",TIUX,0))
        S TIUVAL="^TMP(""TIUSNIR"","_$J_","_+TIUDA_")"
        S TIUCHKSU=$$CHKSUM^XUSESIG1(TIUVAL)
        S SRVAL="^TMP(""SRNIR"","_$J_","_+SRTN_")"
        S SRCHKSUM=$$CHKSUM^XUSESIG1(SRVAL)
        I $G(TIUCHKSU)=$G(SRCHKSUM) Q
        D NRPT
        S TIURECNT=TIURECNT+1,SURRECNT=SURRECNT+1,TIUCOUNT=TIUCOUNT+1
        K @TIUVAL,@SRVAL
        Q
CHK1    ; COMPARE ANESTHESIA REPORTS
        S TIUDA=$P($G(^SRF(SRTN,"TIU")),"^",4)
        Q:+TIUDA'>0
        ;DONT EVALUATE UNDICTATED
        Q:$P($G(^TIU(8925,TIUDA,0)),U,5)=1
        K ^TMP("TIUSRANE",$J),^TMP("SRANE",$J)
        D RPT^SROANR(SRTN)
        ;STRIP OUT SUBFILE DATA
        S TIUX=0
        F  S TIUX=$O(^TIU(8925,+TIUDA,"TEXT",TIUX)) Q:TIUX=""  D
        . S ^TMP("TIUSRANE",$J,TIUDA,TIUX)=$G(^TIU(8925,+TIUDA,"TEXT",TIUX,0))
        S TIUVAL="^TMP(""TIUSRANE"","_$J_","_+TIUDA_")"
        S TIUCHKSU=$$CHKSUM^XUSESIG1(TIUVAL)
        S SRVAL="^TMP(""SRANE"","_$J_","_+SRTN_")"
        S SRCHKSUM=$$CHKSUM^XUSESIG1(SRVAL)
        I $G(TIUCHKSU)=$G(SRCHKSUM) Q
        D ARPT
        S TIURECNT=TIURECNT+1,SURRECNT=SURRECNT+1,TIUCOUNT=TIUCOUNT+1
        K @TIUVAL,@SRVAL
        Q
NRPT     D RPT^SRONRPT(SRTN) S DFN=$P(^SRF(SRTN,0),"^")
        D SRHDR
        D:SURRECNT=TIUCPF NEWSFILE
        ;D CLOSE^%ZISH("TIU"_TIUFILEN)
        D OPEN^%ZISH("SUR"_SURFILEN,TIUPATH,SURFNAME_SURFILEN_".TXT","A")
        U SURIO_SURFILEN_".TXT"
        W !!!!!!,SRHDR
        W !,?4,"PRINTED BY TIU215R UTILITY***** NURSE INTRAOPERATIVE REPORT - CASE #"_SRTN
        S SRI=0 F  S SRI=$O(^TMP("SRNIR",$J,SRTN,SRI)) Q:'SRI  D
        .W !,^TMP("SRNIR",$J,SRTN,SRI),!
        D SRHDR
        D:TIURECNT=TIUCPF NEWTFILE
        D CLOSE^%ZISH("SUR"_SURFILEN)
        D OPEN^%ZISH("TIU"_TIUFILEN,TIUPATH,TIUFNAME_TIUFILEN_".TXT","A")
        U TIUIO_TIUFILEN_".TXT"
        I +TIUDA'>0 G NE
        W !!!!!!,SRHDR
        W !,?4,"PRINTED BY TIU215R UTILITY***** NURSE INTRAOPERATIVE REPORT - CASE #"_SRTN
        S SRI=0 F  S SRI=$O(^TMP("TIUSNIR",$J,TIUDA,SRI)) Q:'SRI  D
        .W !,^TMP("TIUSNIR",$J,TIUDA,SRI),!
        S TIUDAD=$O(^TIU(8925,"DAD",TIUDA,0))
        I +TIUDAD>0 D CLOSE^%ZISH("TIU"_TIUFILEN),ADDENDA
NE      D CLOSE^%ZISH("TIU"_TIUFILEN)
        D KIL
        Q
ARPT    ;
        D SRHDR
        D:SURRECNT=TIUCPF NEWSFILE
        ;D CLOSE^%ZISH("TIU"_TIUFILEN)
        D OPEN^%ZISH("SUR"_SURFILEN,TIUPATH,SURFNAME_SURFILEN_".TXT","A")
        U SURIO_SURFILEN_".TXT"
        W !,SRHDR
        W !,?3,"PRINTED BY TIU215R UTILITY***** ANESTHESIA REPORT - CASE #"_SRTN
        D RPT^SROANR(SRTN)
        S DFN=$P(^SRF(SRTN,0),"^")
        S SRI=0 F  S SRI=$O(^TMP("SRANE",$J,SRTN,SRI)) Q:'SRI  D
        .W !,^TMP("SRANE",$J,SRTN,SRI),!
        D SRHDR
        D:TIURECNT=TIUCPF NEWTFILE
        D CLOSE^%ZISH("SUR"_SURFILEN)
        D OPEN^%ZISH("TIU"_TIUFILEN,TIUPATH,TIUFNAME_TIUFILEN_".TXT","A")
        U TIUIO_TIUFILEN_".TXT"
        I +TIUDA'>0 G AE
        W !!!!!!,SRHDR
        W !,?3,"PRINTED BY TIU215R UTILITY***** ANESTHESIA REPORT - CASE #"_SRTN
        S SRI=0 F  S SRI=$O(^TMP("TIUSRANE",$J,TIUDA,SRI)) Q:'SRI  D
        .W !,^TMP("TIUSRANE",$J,TIUDA,SRI),!
        S TIUDAD=$O(^TIU(8925,"DAD",TIUDA,0))
        I +TIUDAD>0 D CLOSE^%ZISH("TIU"_TIUFILEN),ADDENDA
AE      D CLOSE^%ZISH("TIU"_TIUFILEN)
        D KIL
        Q
KIL     K SRHDR,SRI,SRSDATE,VADM,VA,POP,VAINDT
        Q
ERR     W !,"UNABLE TO CLEAN UP FILES ON ^ ABORT" Q
SRHDR   NEW DFN,Y
        S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT
        S Y=$E($P(^SRF(SRTN,0),"^",9),1,7) D D^DIQ S SRSDATE=Y
        S SRHDR=" "_VADM(1)_" ("_VA("PID")_")   Case #"_SRTN_" - "_SRSDATE
        Q
ADDENDA ;
        N TIUI,TIUDAD S TIUI=0,TIUDAD=0,TIUACNT=1
        D OPEN^%ZISH("TIUA"_TIUFILEN,TIUPATH,TIUANAME_TIUFILEN_".TXT","A")
        U TIUAIO_TIUFILEN_".TXT"
        W !!!!,"**************************************************************************",!,SRHDR
        W !,?4,"PRINTED BY TIU215F UTILITY***** TIU ADDENDA - CASE #"_SRTN,!,"**************************************************************************",!
         ; Loop through all addenda for that note
        F  S TIUDAD=$O(^TIU(8925,"DAD",TIUDA,TIUDAD)) Q:TIUDAD'>0  D
        . W !!,?2,"ADDENDUM #"_TIUDAD,!,?2,"-----------------------------------------" S TIUI=0
        . ; Loop through entire addendum
        . F  S TIUI=$O(^TIU(8925,TIUDAD,"TEXT",TIUI)) Q:TIUI'>0  D
        . . W !,$G(^TIU(8925,TIUDAD,"TEXT",TIUI,0))
        D CLOSE^%ZISH("TIUA"_TIUFILEN)
        Q
NEWSFILE        ;
        D CLOSE^%ZISH("SUR"_SURFILEN) S SURFILEN=SURFILEN+1,SURRECNT=0
        D OPEN^%ZISH("SUR"_SURFILEN,TIUPATH,SURFNAME_SURFILEN_".TXT","W")
        Q
NEWTFILE        ;
        D CLOSE^%ZISH("TIU"_TIUFILEN) S TIUFILEN=TIUFILEN+1,TIURECNT=0
        D OPEN^%ZISH("TIU"_TIUFILEN,TIUPATH,TIUFNAME_TIUFILEN_".TXT","W")
        Q
OPENS   ;
        D OPEN^%ZISH("SUR"_SURFILEN,TIUPATH,SURFNAME_SURFILEN_".TXT","W")
        I POP'=0 W !,"Error opening Surgery output file.",!
        Q
OPENT   ;
        D OPEN^%ZISH("TIU"_TIUFILEN,TIUPATH,TIUFNAME_TIUFILEN_".TXT","W")
        I POP'=0 W !,"Error opening TIU output file.",!
        Q
OPENA   ;
        D OPEN^%ZISH("TIUA"_TIUFILEN,TIUPATH,TIUANAME_TIUFILEN_".TXT","W")
        I POP'=0 W !,"Error opening TIU Addendum output file.",!
        Q
