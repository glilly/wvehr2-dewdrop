FBAAPCC ;AISC/GRR-PRINT CURRENTLY ISSUED CARDS ; 8/28/09 12:02pm
        ;;3.5;FEE BASIS;**111**;JAN 30, 1995;Build 17
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        S VAR="",PGM="START^FBAAPCC" D ZIS^FBAAUTL G:FBPOP Q
START   U IO S UL="",FBAAOUT=0 W:$E(IOST,1,2)["C-" @IOF F A=1:1:80 S UL=UL_"="
        D HED S J=0 F JJ=0:0 S J=$O(^FBAAA("AE",J)) Q:J=""!(FBAAOUT)  F DFN=0:0 S DFN=$O(^FBAAA("AE",J,DFN)) Q:DFN'>0!(FBAAOUT)  I $D(^FBAAA(DFN,4)) S Y(0)=^(4) D GOT
Q       W ! K A,J,DFN,UL,I,JJ,X,Y,FBAAOUT,FBDT,FBNM,FBSSN D CLOSE^FBAAUTL
        Q
GOT     S FBDT=$P(Y(0),"^",2),FBNM=$P($G(^DPT(+DFN,0)),"^"),FBSSN=$$SSN^FBAAUTL(DFN)
        I $Y+4>IOSL D HANG Q:FBAAOUT  W @IOF D HED
        W !!,J,?10,FBNM,?42,FBSSN,?61,$$DATX^FBAAUTL(FBDT)
        Q
HED     W !,"Card No.",?10,"Patient Name",?42,"Patient SSN",?61,"Issue Date",!,UL Q
HANG    I $E(IOST,1,2)["C-" S DIR(0)="E" D ^DIR K DIR S:'Y FBAAOUT=1
        Q
