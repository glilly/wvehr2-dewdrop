HBHCRP10        ; LR VAMC(IRMS)/MJT-HBHC report on file 631, All active (admitted but not discharged) cases by date range, sorted by patient name, includes: patient name, Last Four, admission date, & total ; 12/21/05 3:31pm
        ;;1.0;HOSPITAL BASED HOME CARE;**6,22,24**;NOV 01, 1993;Build 201
        D START^HBHCUTL
        G:(HBHCBEG1=-1)!(HBHCEND1=-1) EXIT
        W ! D MFHS^HBHCUTL3 D:$D(HBHCMFHS) MFH^HBHCUTL3
        G:$D(DIRUT) EXIT
        S %ZIS="Q",HBHCCC=0 K IOP,ZTIO,ZTSAVE D ^%ZIS G:POP EXIT
        I $D(IO("Q")) S ZTRTN="DQ^HBHCRP10",ZTDESC="HBPC Program Census Report",ZTSAVE("HBHC*")="" D ^%ZTLOAD G EXIT
DQ      ; De-queue
        U IO
        S HBHCTOT=0,$P(HBHCY,"-",81)="",HBHCHEAD="Program Census"
        ; HBHCMFHS variable set in MFHS^HBHCUTL3
        S:'$D(HBHCMFHS) HBHCHDR="W !,""Patient Name"",?43,""Last Four"",?68,""Date"""
        S:$D(HBHCMFHS) HBHCHDR="W !,?33,""Last"",!,""Patient Name"",?33,""Four"",?40,""Date"",?55,""Medical Foster Name Name"""
        ; HBHCMFHR variable set in MFH^HBHCUTL3
        S:$D(HBHCMFHR) HBHCHEAD="Medical Foster Home (MFH) "_HBHCHEAD
        S HBHCCOLM=(80-(30+$L(HBHCHEAD))\2) S:HBHCCOLM'>0 HBHCCOLM=1
        D TODAY^HBHCUTL D:IO'=IO(0)!($D(IO("S"))) HDRRANGE^HBHCUTL
        I '$D(IO("S")),(IO=IO(0)) S HBHCCC=HBHCCC+1 D HDRRANGE^HBHCUTL
LOOP    ; Loop thru ^HBHC(631) "AD" (admission date) cross-ref to build report
        S X1=HBHCBEG1,X2=-1 D C^%DTC S HBHCADDT=X
        F  S HBHCADDT=$O(^HBHC(631,"AD",HBHCADDT)) Q:(HBHCADDT="")!(HBHCADDT>HBHCEND1)  S HBHCDFN="" F  S HBHCDFN=$O(^HBHC(631,"AD",HBHCADDT,HBHCDFN)) Q:HBHCDFN=""  S HBHCNOD0=^HBHC(631,HBHCDFN,0) D:$P(HBHCNOD0,U,15)=1 PROCESS
        W:'$D(^TMP("HBHC",$J)) !!,"No data found for Date Range selected."
        I $D(^TMP("HBHC",$J)) D PRTLOOP W !!,HBHCZ,!,"Program Census Total: ",HBHCTOT,!,HBHCZ
        D ENDRPT^HBHCUTL1
EXIT    ; Exit module
        D ^%ZISC
        K DIR,HBHCADDT,HBHCBEG1,HBHCBEG2,HBHCCOLM,HBHCCC,HBHCDFN,HBHCDPT0,HBHCEND1,HBHCEND2,HBHCHDR,HBHCHEAD,HBHCMFHN,HBHCMFHP,HBHCMFHR,HBHCMFHS,HBHCNAME,HBHCNOD0,HBHCPAGE,HBHCTDY,HBHCTMP,HBHCTOT,HBHCY,HBHCZ,X,X1,X2,Y,^TMP("HBHC",$J)
        Q
PROCESS ; Process record & build ^TMP("HBHC",$J) global
        Q:($P(HBHCNOD0,U,40)]"")&($P(HBHCNOD0,U,40)<HBHCEND1)
        ; Quit if Medical Foster Home (MFH) Report, but not MFH patient; HBHCMFHR variable set in MFH^HBHCUTL3 
        I $D(HBHCMFHR) Q:'$D(^HBHC(631,"AJ","Y",HBHCDFN))
        S HBHCDPT0=^DPT($P(HBHCNOD0,U),0)
        I '$D(HBHCMFHS) S ^TMP("HBHC",$J,$P(HBHCDPT0,U),HBHCADDT)=$E($P(HBHCDPT0,U,9),6,9)
        I $D(HBHCMFHS) S HBHCMFHN="",HBHCMFHP=$P($G(^HBHC(631,HBHCDFN,3)),U,2) S:HBHCMFHP]"" HBHCMFHN=$E($P(^HBHC(633.2,HBHCMFHP,0),U),1,25) S ^TMP("HBHC",$J,$P(HBHCDPT0,U),HBHCADDT)=$E($P(HBHCDPT0,U,9),6,9)_U_HBHCMFHN
        Q
PRTLOOP ; Print loop
        S HBHCNAME="" F  S HBHCNAME=$O(^TMP("HBHC",$J,HBHCNAME)) Q:HBHCNAME=""  S HBHCADDT="" F  S HBHCADDT=$O(^TMP("HBHC",$J,HBHCNAME,HBHCADDT)) Q:HBHCADDT=""  D PRINT
        Q
PRINT   ; Print report
        I ($D(ZTRTN)!(HBHCCC=0))&((IOSL-$Y)<5) W @IOF D HDRRANGE^HBHCUTL
        S Y=HBHCADDT D DD^%DT
        W:'$D(HBHCMFHS) !,HBHCNAME,?43,^TMP("HBHC",$J,HBHCNAME,HBHCADDT),?68,Y,!,HBHCY
        I $D(HBHCMFHS) S HBHCTMP=^TMP("HBHC",$J,HBHCNAME,HBHCADDT) W !,HBHCNAME,?33,$P(HBHCTMP,U),?40,Y,?55,$P(HBHCTMP,U,2),!,HBHCY
        S HBHCTOT=HBHCTOT+1
        Q
