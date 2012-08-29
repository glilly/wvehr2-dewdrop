TIU215F ;VMP/ELR - Utililty to analyze problems cause by PATCH tiu*1.0*215 ; 7/25/2007
        ;;1.0;TEXT INTEGRATION UTILITIES;**231**;Jun 20, 1997;Build 63
        ;COMPARE CHECKSUMS BETWEEN TIU AND SURGERY TO TRY AND FIND RECORDS WHERE THE ADDENDUM WAS NOT FILED IN TIU
        ; DBIA 4502 TO ACCESS SURGERY FILE
        ; DBIA 5025 ACCESS ROUTINE SROANR
        ; DBIA 5024 ACCESS ROUTINE SRONRPT
ENV     ;DUMMY ENVIRONMENT CHECK TO GET ROUTINE LOADED FOR USE IN INSTALL QUESTIONS
        Q
STRT    ;
        Q
        W !!!
        W !,"1. ANALYZE POTENTIAL SURGERY/TIU PROBLEMS"
        W !,"2. VIEW SINGLE SURGERY CASE USING CASE #"
        W !,"3, SEND OUTPUT TO TEXT FILES"
        S DIR("A")="SELECT 1 OR 2 OR 3"
        S DIR(0)=("N^1:3")
        D ^DIR
        I $D(DIRUT) K DIRUT Q
        K DIR
        G EN:Y=1
        G ASK:Y=2
        D ^TIU215R G STRT
        Q
EN      NEW SRTN,TIUDA,TIUVAL,TIUCHKSU,SRVAL,SRCHKSUM,TIUDT,SRTNA,TIUEND
        NEW TIUA,TIUDAD,TIUDFN,TIUDONE,TIUNAM,TIUND,TIUX,TIUERR
        S U="^"
        K ^TMP("TIUSNIR",$J),^TMP("SRNIR",$J)
        S DIR("A")="Enter a date equal or prior to the date patch was installed"
        S DIR(0)="D^:DT:EX"
        D ^DIR
        K DIR
        I $D(DIRUT) K DIRUT G STRT
        S TIUDT=+Y
        S DIR("A")="Enter date patch was backed out"
        S DIR(0)="D^"_TIUDT_":DT:EX"
        D ^DIR
        K DIR
        I $D(DIRUT) K DIRUT G STRT
        S TIUEND=+Y
EN1     ;
        NEW TIUCNT S TIUCNT=0
        D HD
        G EN2:$G(TIUDT)'>0
        S TIUDT=TIUDT-.0001
        F  S TIUDT=$O(^SRF("AC",TIUDT)) Q:'$L(TIUDT)  Q:TIUDT\1>TIUEND  D
        . S TIUA=0 F  S TIUA=$O(^SRF("AC",TIUDT,TIUA)) Q:TIUA'>0  D
        . . S TIUDONE="" D CHK,CHK1
        I $D(XPDQUES),$G(XPDQUES("POS1"))=1 D BULL
EN2     I $D(XPDQUES),$G(XPDQUES("POS1"))'=1 D MSG H .5
        I $G(TIUERR)=1 D BULL1("It looks like you did not back out patch TIU*1.0*215")
        I $D(XPDQUES) Q
        G STRT
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
        D SETLN("NIR")
        K @TIUVAL,@SRVAL
        Q
CHK1    ;
        S TIUDA=$P($G(^SRF(SRTN,"TIU")),"^",4)
        Q:+TIUDA'>0
        ;DONT EVALUATE UNDICTATED
        Q:$P($G(^TIU(8925,TIUDA,0)),U,5)=1
        K ^TMP("TIUSNIR",$J),^TMP("SRANE",$J)
        D RPT^SROANR(SRTN)
        ;STRIP OUT SUBFILE DATA
        S TIUX=0
        F  S TIUX=$O(^TIU(8925,+TIUDA,"TEXT",TIUX)) Q:TIUX=""  D
        . S ^TMP("TIUSNIR",$J,TIUDA,TIUX)=$G(^TIU(8925,+TIUDA,"TEXT",TIUX,0))
        S TIUVAL="^TMP(""TIUSNIR"","_$J_","_+TIUDA_")"
        S TIUCHKSU=$$CHKSUM^XUSESIG1(TIUVAL)
        S SRVAL="^TMP(""SRANE"","_$J_","_+SRTN_")"
        S SRCHKSUM=$$CHKSUM^XUSESIG1(SRVAL)
        I $G(TIUCHKSU)=$G(SRCHKSUM) Q
        D SETLN("ANES")
        K @TIUVAL,@SRVAL
        Q
NAM     NEW DFN
        Q:$G(TIUDONE)=1
        S TIUNAM=$P($G(^TIU(8925,TIUDA,0)),U,2)
        S DFN=TIUNAM D DEM^VADPT
        I $D(XPDQUES) S TIUNAM=$E(VADM(1))_VA("BID")
        E  S TIUNAM=$E(VADM(1),1,20)
        S Y=$P($G(^TIU(8925,TIUDA,13)),U,1)
        D DD^%DT S TIUND=Y
        S TIUDONE=1
        Q
ASK     S DIR(0)="P^130"
        S DIR("A")="ENTER THE CASE NUMBER AS `NNNNNN"
        D ^DIR
        I $D(DIRUT) K DIRUT G STRT
        S SRTN=+Y
        D ^%ZIS G ASK:$G(POP)=1
        N TIUERR S TIUERR=""
        D SRHDR
        U IO
        W !,SRHDR
        W !,?4,"PRINTED BY TIU215F UTILITY***** NURSE INTRAOPERATIVE REPORT - CASE #"_SRTN
        ;D CSUM I $G(TIUERR)=1 W !!,"******It looks like you did not back out patch TIU*1.0*215*****",!
RPT      D RPT^SRONRPT(SRTN) S DFN=$P(^SRF(SRTN,0),"^")
        S SRI=0 F  S SRI=$O(^TMP("SRNIR",$J,SRTN,SRI)) Q:'SRI  D
        .W !,^TMP("SRNIR",$J,SRTN,SRI),!
        I $Y'=0 W @IOF
        G RPTX:$P($G(^SRF(SRTN,"TIU")),"^",4)'>0
        S TIUDA=$P($G(^SRF(SRTN,"TIU")),"^",4) G RPTX:$P($G(^TIU(8925,TIUDA,0)),U,5)=1
        W !,SRHDR
        W !,?3,"PRINTED BY TIU215F UTILITY***** ANESTHESIA REPORT - CASE #"_SRTN
        I $G(TIUERR)=1 W !!,"******It looks like you did not back out patch TIU*1.0*215*****",!
        D RPT^SROANR(SRTN)
        S DFN=$P(^SRF(SRTN,0),"^")
        S SRI=0 F  S SRI=$O(^TMP("SRANE",$J,SRTN,SRI)) Q:'SRI  D
        .W !,^TMP("SRANE",$J,SRTN,SRI),!
RPTX    D ^%ZISC
        K SRAGE,SRDIV,SRHDR,SRI,SRLOC,SRPRINT,SRSDATE,TIUERR,VADM,VA,POP,SREST,SRP,SRPOS,SRTN,VAINDT
        G ASK
SRHDR   S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT
        S Y=$E($P(^SRF(SRTN,0),"^",9),1,7) D D^DIQ S SRSDATE=Y
        S SRHDR=" "_VADM(1)_" ("_VA("PID")_")   Case #"_SRTN_" - "_SRSDATE
        Q
HD      NEW HD1,HD2,HD3,HD4,HD5,TIUI,Y
        S HD1="DIFFERENCE IN CHECKSUMS BETWEEN SURGERY & TIU "
        S HD2="RUN DATE " D NOW^%DTC S Y=% D DD^%DT S HD2=HD2_Y K %
        S HD3="START DATE " S Y=TIUDT D DD^%DT S HD3=HD3_Y
        S HD4="END DATE " S Y=TIUEND D DD^%DT S HD4=HD4_Y
        S HD5="TYPE  CASE #",$E(HD5,37)=" ",HD5=HD5_"TIU NOTE DATE",$E(HD5,57)=" ",HD5=HD5_"PATIENT "
        I '$D(XPDQUES) W !,HD1,!,HD2,!,HD3,!,HD4,!,HD5 Q
        F TIUI=HD1,HD2,HD3,HD4,HD5 S TIUCNT=TIUCNT+1,^TMP("TIU215F",$J,TIUCNT)=TIUI
        Q
SETLN(A)        ;
        NEW TIULN
        S TIUCNT=TIUCNT+1
        S TIULN=A,$E(TIULN,5)=" "
        S TIULN=TIULN_" "_SRTN
        S TIUDAD=0,TIUDAD=$O(^TIU(8925,"DAD",TIUDA,TIUDAD))
        I +TIUDAD>0 S TIULN=TIULN_"  TIU REPORT HAS ADDENDUM"
        D NAM
        S $E(TIULN,37)=" ",TIULN=TIULN_TIUND,$E(TIULN,57)=" ",TIULN=TIULN_TIUNAM
        I '$D(XPDQUES) W !,TIULN Q
        S ^TMP("TIU215F",$J,TIUCNT)=TIULN
        Q
INS     ;ENTRY POINT FOR INSTALL
        S TIUDT=$G(XPDQUES("POS2"))
        S TIUEND=$G(XPDQUES("POS3"))
        K ^TMP("TIU215F",$J)
        ;D CSUM
        G EN1
BULL    ; Bulletin of analysis
        N XMSUB,XMTEXT,XMY,XMDUZ,DIFROM,XMZ,XMMG
        I $G(TIUCNT)'>5 S ^TMP("TIU215F",$J,6)="No discrepencies found in date range"
        S XMSUB="ANALYSIS OF POTENTIAL PROBLEMS CAUSED BY PATCH TIU*1.0*215 " K XMY
        S XMTEXT="^TMP(""TIU215F"",$J,"
        S XMY($S(DUZ:DUZ,1:.5))=""
        S XMDUZ=.5 D NOW^%DTC
        D ^XMD
        K ^TMP("TIU215F",$J),XMY,XMTEXT,XMSUB
        Q
BULL1(A)        ; Bulletin
        S TIUCNT=TIUCNT+1
        N XMSUB,XMTEXT,XMY,XMDUZ,DIFROM,XMZ,XMMG
        S XMSUB="ANALYSIS OF POTENTIAL PROBLEMS CAUSED BY PATCH TIU*1.0*215" K XMY
        S XMTEXT="^TMP(""TIU215F"",$J,"
        S ^TMP("TIU215F",$J,TIUCNT)=A
        S XMY($S(DUZ:DUZ,1:.5))=""
        S XMDUZ=.5 D NOW^%DTC
        D ^XMD
        K ^TMP("TIU215F",$J),XMY,XMTEXT,XMSUB
        Q
POS2    I $G(XPDQUES("POS1"))'=1 K DIR Q
        Q
POS3    I $G(XPDQUES("POS1"))'=1 K DIR Q
        S DIR(0)="D^"_$G(XPDQUES("POS2"))_":DT:EX"
        Q
CSUM    Q  I $D(^%ZOSF("RSUM1")) N X,Y S TIUERR="",X="TIULP" X ^%ZOSF("RSUM1") I Y'="47310116" S TIUERR=1
        Q
MSG     NEW TIUMSG S TIUMSG="No analysis performed, you entered patch not loaded. "
        I +$O(^XPD(9.7,"B","TIU*1.0*215",0)) S TIUMSG=TIUMSG_"But it is in your install file"
        D BULL1(TIUMSG)
        Q 
