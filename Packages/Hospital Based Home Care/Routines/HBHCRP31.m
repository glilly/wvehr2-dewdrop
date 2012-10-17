HBHCRP31        ; LR VAMC(IRMS)/MJT-HBHC report on file 634.7 Form 7 Error(s)), sorted by Medical Foster Home (MFH) Name, & includes MFH file IEN, MFH Name, & Opened Date ; Mar 2008
        ;;1.0;HOSPITAL BASED HOME CARE;**24**;NOV 01, 1993;Build 201
        I $P(^HBHC(631.9,1,0),U,8)]"" W $C(7),!,"File Update in progress.  Please try again later." H 3 Q
        S %ZIS="Q",HBHCCC=0 K IOP,ZTIO,ZTSAVE D ^%ZIS Q:POP
        I $D(IO("Q")) S ZTRTN="DQ^HBHCRP31",ZTSAVE("HBHC*")="",ZTDESC="HBPC MFH Form Errors Report" D ^%ZTLOAD G EXIT
DQ      ; De-queue
        U IO
        ; Max length for HBHCHEAD = 50
        S $P(HBHCY,"-",81)="",HBHCPAGE=0,HBHCHEAD="Medical Foster Home (MFH) Form Errors"
        S HBHCHDR="W !,""MFH File IEN"",?17,""Medical Foster Home Name"",?59,""Opened Date"""
        S HBHCCOLM=(80-(30+$L(HBHCHEAD))\2) S:HBHCCOLM'>0 HBHCCOLM=1 D TODAY^HBHCUTL
        D:IO'=IO(0)!($D(IO("S"))) HDRPAGE^HBHCUTL
        I '$D(IO("S")),(IO=IO(0)) S HBHCCC=HBHCCC+1 D HDRPAGE^HBHCUTL
LOOP    ; Loop thru file 634.7 "B" cross-ref
        S HBHCMFHP="" F  S HBHCMFHP=$O(^HBHC(634.7,"B",HBHCMFHP)) Q:HBHCMFHP=""  S HBHCIEN="" F  S HBHCIEN=$O(^HBHC(634.7,"B",HBHCMFHP,HBHCIEN)) Q:HBHCIEN=""  D PRINT
        D ENDRPT^HBHCUTL1
EXIT    ; Exit module
        D ^%ZISC
        K HBHC,HBHCCC,HBHCCOLM,HBHCHDR,HBHCHEAD,HBHCIEN,HBHCMFHP,HBHCNOD0,HBHCPAGE,HBHCTDY,HBHCY,HBHCZ,X,Y
        Q
PRINT   ; Print record
        I ($D(ZTRTN)!(HBHCCC=0))&((IOSL-$Y)<10) W:HBHCPAGE>0 @IOF D HDRPAGE^HBHCUTL
        S HBHCNOD0=$G(^HBHC(633.2,HBHCMFHP,0)),HBHC="`"_HBHCMFHP
        W !,$J(HBHC,6),?17,$P(HBHCNOD0,U)
        W:$P(HBHCNOD0,U,2)]"" ?59,$E($P(HBHCNOD0,U,2),4,5)_"-"_$E($P(HBHCNOD0,U,2),6,7)_"-"_$E($P(HBHCNOD0,U,2),2,3)
        W !,HBHCY
        Q
