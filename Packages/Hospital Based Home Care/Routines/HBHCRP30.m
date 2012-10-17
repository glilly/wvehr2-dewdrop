HBHCRP30        ; LR VAMC(IRMS)/MJT-HBHC report on Medical Foster Home file 633.2 data, sorted by name, includes: MFH Name, Opened Date, Primary Caregiver Name, Date of Birth, & Age, includes # OF MFHs & Average Age @ end of rpt ; Feb 2008
        ;;1.0;HOSPITAL BASED HOME CARE;**24**;NOV 01, 1993;Build 201
        S %ZIS="Q",HBHCCC=0 K IOP,ZTIO,ZTSAVE D ^%ZIS G:POP EXIT
        I $D(IO("Q")) S ZTRTN="DQ^HBHCRP30",ZTDESC="HBPC Medical Foster Home Caregiver Age Report",ZTSAVE("HBHC*")="" D ^%ZTLOAD G EXIT
DQ      ; De-queue
        U IO
        S HBHCPAGE=0,$P(HBHCY,"-",133)="",$P(HBHCZ,"=",133)="",HBHCHEAD="Medical Foster Home (MFH) Caregiver Age"
        S HBHCHDR="W !!,""Medical Foster Home (MFH) Name"",?40,""Opened Date"",?58,""Primary Caregiver Name"",?103,""Date of Birth"",?121,""Age"""
        S HBHCCOLM=(132-(30+$L(HBHCHEAD))\2) S:HBHCCOLM'>0 HBHCCOLM=1
        D TODAY^HBHCUTL D:IO'=IO(0)!($D(IO("S"))) HDR132NR^HBHCUTL
        I '$D(IO("S")),(IO=IO(0)) S HBHCCC=HBHCCC+1 D HDR132NR^HBHCUTL
LOOP    ; Loop thru ^HBHC(633.2,"B") MFH Name cross-ref to build report
        S HBHCDFN=0 F  S HBHCDFN=$O(^HBHC(633.2,HBHCDFN)) Q:HBHCDFN'>0  D PROCESS
        I $D(^TMP("HBHC",$J)) D PRTLOOP,PRTTOT
        D END132^HBHCUTL1
EXIT    ; Exit module
        D ^%ZISC
        K HBHCAGE,HBHCCC,HBHCCDOB,HBHCCOLM,HBHCDFN,HBHCHDR,HBHCHEAD,HBHCNAME,HBHCNOD0,HBHCPAGE,HBHCTDY,HBHCTMP,HBHCTOT,HBHCTOT1,HBHCY,HBHCZ,X,Y,^TMP("HBHC",$J)
        Q
PROCESS ; Process record & build ^TMP("HBHC",$J) global
        S HBHCNOD0=^HBHC(633.2,HBHCDFN,0)
        ; Quit if MFH Closed
        Q:$P(HBHCNOD0,U,6)]""
        S HBHCCDOB=$P(HBHCNOD0,U,16)
        ; Quit if Caregiver Date of Birth = null
        Q:HBHCCDOB=""
        S HBHCAGE=$E(DT,1,3)-$E(HBHCCDOB,1,3)
        S:($E(DT,4,7)<$E(HBHCCDOB,4,7)) HBHCAGE=HBHCAGE-1
        S ^TMP("HBHC",$J,$P(HBHCNOD0,U),HBHCDFN)=$E($P(HBHCNOD0,U,2),4,5)_"-"_$E($P(HBHCNOD0,U,2),6,7)_"-"_$E($P(HBHCNOD0,U,2),2,3)_U_$P(HBHCNOD0,U,3)_U_$E($P(HBHCNOD0,U,16),4,5)_"-"_$E($P(HBHCNOD0,U,16),6,7)_"-"_$E($P(HBHCNOD0,U,16),2,3)_U_HBHCAGE
        Q
PRTLOOP ; Print loop
        S (HBHCTOT,HBHCTOT1)=0
        S HBHCNAME="" F  S HBHCNAME=$O(^TMP("HBHC",$J,HBHCNAME)) Q:HBHCNAME=""  S HBHCDFN="" F  S HBHCDFN=$O(^TMP("HBHC",$J,HBHCNAME,HBHCDFN)) Q:HBHCDFN=""  D PRINT
        Q
PRINT   ; Print report
        I ($D(ZTRTN)!(HBHCCC=0))&((IOSL-$Y)<5) W @IOF D HDR132NR^HBHCUTL
        S HBHCTMP=^TMP("HBHC",$J,HBHCNAME,HBHCDFN),HBHCTOT=HBHCTOT+1,HBHCTOT1=HBHCTOT1+($P(HBHCTMP,U,4))
        W !,HBHCNAME,?40,$P(HBHCTMP,U),?58,$P(HBHCTMP,U,2),?103,$P(HBHCTMP,U,3),?121,$P(HBHCTMP,U,4),!,HBHCY
        Q
PRTTOT  ; Print report totals
        I ($D(ZTRTN)!(HBHCCC=0))&((IOSL-$Y)<1) W @IOF D HDR132NR^HBHCUTL
        W !!,HBHCZ,!,"Medical Foster Home (MFH) Total: ",?34,$J(HBHCTOT,5),!,"Average Caregiver Age: ",?34,$J(HBHCTOT1/HBHCTOT,5),!,HBHCZ
        Q
