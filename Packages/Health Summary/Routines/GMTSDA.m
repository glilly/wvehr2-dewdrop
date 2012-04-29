GMTSDA  ; SLC/DLT,KER/NDBI - Appointments ; 5/21/07 11:12am
        ;;2.7;Health Summary;**5,19,28,49,70,80**;Oct 20, 1995;Build 9
        ;
        ; External Reference
        ;   DBIA  1024  ^DIC(40.7
        ;   DBIA 10040  ^SC(
        ;   DBIA  2065  ^SCE(
        ;   DBIA  2065  ^SCE("ADFN"
        ;   DBIA  2929  CVP^A7RHSM
        ;   DBIA 10061  SDA^VADPT
        ;
PAST    ; Gets Patient's Past Appointments for date range
        N GMDT,GMIDT,MAX S X=1
        S VASD("F")=$S(GMTSBEG=1:2560101,1:GMTSBEG),VASD("T")=$S(GMTS1=6666666:DT,1:9999999-GMTS1)
        S MAX=$S(+($G(GMTSNDM))>0:+($G(GMTSNDM)),1:99999)
        S VASD("W")=123456789 D SDA^VADPT
        I VAERR=1 D CKP^GMTSUP W "RSA ERROR",! D END Q
        I VAERR=2 D CKP^GMTSUP W "DATABASE NOT AVAILABLE",! D END Q
        S (YCNT,Y)=0 F  S Y=$O(^UTILITY("VASD",$J,Y)) Q:'Y  S YCNT=YCNT+1,ADATE=$P(^(Y,"I"),U,1),^UTILITY("GMTSVASD",$J,9999999-ADATE)=ADATE_U_$P(^UTILITY("VASD",$J,Y,"E"),U,2,99)
        S GMDT=VASD("F")
        F  S GMDT=$O(^SCE("ADFN",DFN,GMDT)) Q:GMDT'>0!(GMDT>VASD("T"))  D
        . S GMI=0 F  S GMI=$O(^SCE("ADFN",DFN,GMDT,GMI)) Q:GMI'>0  D
        . . S GMIDT=9999999-GMDT
        . . I '$D(^UTILITY("GMTSVASD",$J,GMIDT)) D
        . . . Q:$P($G(^SCE(GMI,0)),U,6)'=""
        . . . I $P($G(^SCE(GMI,0)),U,4) Q:$P($G(^SC($P(^SCE(GMI,0),U,4),"OOS")),U)
        . . . S ^UTILITY("GMTSVASD",$J,GMIDT)=GMDT_U_$S(+$P(^SCE(GMI,0),U,4):$P($G(^SC(+$P(^(0),U,4),0)),U),1:$P($G(^DIC(40.7,$P(^SCE(GMI,0),U,3),0)),U))_U_"UNSCHEDULED"
        D:$$ROK^GMTSU("A7RHSM")&($$NDBI^GMTSU) CVP^A7RHSM
        I '$D(^UTILITY("GMTSVASD",$J)) D END Q
        S IDATE="",YCNT=0
        F  S IDATE=$O(^UTILITY("GMTSVASD",$J,IDATE)) Q:+IDATE'>0!(YCNT=MAX)  D
        . S ADATE=+^(IDATE),ADATE(0)=^(IDATE) D PRINT S YCNT=YCNT+1
        D END Q
FUTURE  ; Gets Patient's Future Appointments
        D SDA^VADPT N MAX S MAX=$S(+($G(GMTSNDM))>0:+($G(GMTSNDM)),1:99999)
        I VAERR=2 D CKP^GMTSUP W "DATABASE NOT AVAILABLE",! D END Q
        S (YCNT,Y)=0 F  S Y=$O(^UTILITY("VASD",$J,Y)) Q:'Y  S YCNT=YCNT+1,ADATE=$P(^(Y,"I"),U,1),ADATE(0)=^UTILITY("VASD",$J,Y,"E") D PRINT Q:YCNT=MAX
        D END Q
PRINT   ; Output
        D CKP^GMTSUP Q:$D(GMTSQIT)  S X=ADATE D REGDTM4^GMTSU,CKP^GMTSUP
        W X,?18,$E($P(ADATE(0),"^",2),1,25),?58,$E($P(ADATE(0),"^",3),1,21)
        W ! Q
END     ; Clean-up and Quit
        K %I,IDATE,IDATES,ADATE,VASD,X,Y,YCNT,Z,^UTILITY("VASD",$J),^UTILITY("GMTSVASD",$J) Q
