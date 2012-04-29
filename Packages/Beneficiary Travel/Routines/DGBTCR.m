DGBTCR  ;ALB/SCK - BENEFICIARY TRAVEL FORM 70-3542d VARIABLES; 2/7/88@08:00 ;6/11/93@09:30
        ;;1.0;Beneficiary Travel;**7,14**;September 25, 2001;Build 7
        ;Modification of AIVBTPRT / pmg / GRAND ISLAND ; 07 Jul 88 12:02 PM
START   Q:'$D(DGBTDT)
        S DGBTVAR(0)=$G(^DGBT(392,+DGBTDT,0)),DGBTACCT=$P($G(^DGBT(392.3,+$P(DGBTVAR(0),"^",6),0)),"^",5)
        Q:DGBTACCT'>3
        W !!,*7,"This needs to be printed at 132 columns"
        S DGPGM="PRINT^DGBTCR",DGVAR="DGBTDT"
        S %ZIS="PMQ" D ^%ZIS G QUIT:POP
        I $D(IO("Q")) D QUE G QUIT
        D PRINT
QUIT    ;
        D:'$D(ZTQUEUED) ^%ZISC
        K DGPGM,DGVAR,VADAT,VADATE,I,X,X2,DGBTVAR,DGBTCC,DGBTDIV,DGBTDOB,DGBTINS,DGBTINS1,DGBTINS2,DGBTCNA,DGBTCSZ,DGBTCNU,DGBTTCTY,DGBTFCTY,DGBTDT,DGBTACCT,DFN,Y
        K DGBTM6,DGBTM7,DGBTM8,DGBTM9,DGBTM10,DGBTM11,DGBTM12,DGBTM13,DGBTM14,DGBTM15,DGBTM16,DGBTM17,DGBTRATE,DGBTSCP,DGBTSSN,DGBTST
        Q
PRINT   ;
        U IO D SET,PRINT^DGBTCR1,PRINT^DGBTCR2,KVAR^VADPT
        Q
SET     S DFN=$P(^DGBT(392,DGBTDT,0),"^",2) D 6^VADPT S (DGBTFCTY,DGBTTCTY)=""
NODES   F I=0,"A","D","M","R","T" S DGBTVAR(I)=$S($D(^DGBT(392,DGBTDT,I)):^(I),1:"")
        I $D(^DG(43.1,$O(^DG(43.1,(9999999.99999-DGBTDT))),"BT")) S DGBTRATE=^("BT"),DGBTM7=$S($P(DGBTVAR("A"),"^",3)=1:$P(DGBTRATE,"^",5),1:$P(DGBTRATE,"^",3))
        I $P(DGBTVAR("D"),"^",4)]"" S DGBTCNA=$P(DGBTVAR("D"),"^",4) D CITY I DGBTCSZ[DGBTCNA D
        . S DGBTCSZ=DGBTCNA_", "_$S(+$P(DGBTVAR("D"),"^",5)>0:$P(^DIC(5,$P(DGBTVAR("D"),"^",5),0),U,2),1:"")_"  "
        . S Y=$P(DGBTVAR("D"),U,6),Y=$E(Y,1,5)_$S($E(Y,6,9)]"":"-"_$E(Y,6,9),1:""),DGBTCSZ=DGBTCSZ_Y,DGBTFCTY=DGBTCSZ
        I $P(DGBTVAR("T"),"^",4)]"" S DGBTCNA=$P(DGBTVAR("T"),U,4) D CITY^DGBTCR S:DGBTCSZ[DGBTCNA DGBTCSZ=DGBTCNA_", "_$S(+$P(DGBTVAR("T"),"^",5)>0:$P(^DIC(5,$P(DGBTVAR("T"),"^",5),0),U,2),1:"")_"  "_$P(DGBTVAR("T"),U,6) S DGBTTCTY=DGBTCSZ
DIV     S DGBTDIV=$P(DGBTVAR(0),"^",11) I +DGBTDIV S DGBTDIV=$P(^DG(40.8,DGBTDIV,0),"^",7) S (DGBTCC,DGBTST)=""
        I $D(^DIC(4,+DGBTDIV,0)) S DGBTINS=^(0),DGBTINS1=$S($D(^DIC(4,DGBTDIV,1)):^(1),1:""),DGBTINS2=$S(DGBTINS1]"":$P(DGBTINS1,"^",3)_",",1:"UNSPECIFIED")_" "_$S($D(^DIC(5,+$P(DGBTINS,U,2),0)):$P(^(0),U,2),1:"")_"  "_$P(DGBTINS1,"^",4)
        I VAPA(5)&(VAPA(7)) S DGBTCC=$S($D(^DIC(5,+VAPA(5),1,+VAPA(7),0)):$P(^(0),"^",3),1:""),DGBTST=$P(^DIC(5,+VAPA(5),0),"^",2)
        ;S DGBTSSN=$P($P(VADM(2),"^",2),"-")_" "_$P($P(VADM(2),"^",2),"-",2)_" "_$P($P(VADM(2),"^",2),"-",3),DGBTDOB=$E(VADM(3),4,7)_$E(VADM(3),2,3)
        D PID^VADPT6 S DGBTSSN=VA("PID"),DGBTDOB=$E(VADM(3),4,7)_($E(VADM(3),1,3)+1700)
        S DGBTSCP=$S($L($P(VAEL(3),"^",2)<3):"0",1:"")_$P(VAEL(3),"^",2)
MILES   S DGBTM6=$P(DGBTVAR("M"),"^")*$P(DGBTVAR("M"),"^",2)
        N X3
        S X2="2$",X=DGBTM6*DGBTM7 D COMMA^%DTC S DGBTM8=X
        S X=$P(DGBTVAR("M"),"^",4) D COMMA^%DTC S DGBTM9=X
        S X=$P(DGBTVAR("M"),"^",5) D COMMA^%DTC S DGBTM10=X
        S X=DGBTM6*DGBTM7+$P(DGBTVAR("M"),"^",4)+$P(DGBTVAR("M"),"^",5) D COMMA^%DTC S DGBTM11=X
        S X2="3$",X=DGBTM7 D COMMA^%DTC S DGBTM7=X
        S X2="2$"  ;Reset edit mask to 2 decimal positions for rest of report
        S X=$P(DGBTVAR(0),"^",8) D COMMA^%DTC S DGBTM12=X
        S X=$P(DGBTVAR("M"),"^",4)+$P(DGBTVAR(0),"^",8) D COMMA^%DTC S DGBTM13=X
        S X=$P(DGBTVAR(0),"^",10) D COMMA^%DTC S DGBTM14=X
        S X=$P(DGBTVAR(0),"^",9) D COMMA^%DTC S $P(DGBTM14,"^",2)=X
CERT    S VADAT("W")=DGBTDT D ^VADATE S DGBTM15=VADATE("E")
        S X=$S($P(^DG(43,1,"BT"),"^")'="":$P(^DG(43,1,"BT"),"^"),1:DUZ),DGBTM16=$P($P(^VA(200,X,0),",",2),"^")_" "_$P(^VA(200,X,0),",")_$S($P(^DG(43,1,"BT"),"^")'="":"",1:", DESIGNEE OF CERTIFYING OFFICIAL") K X
        S DGBTM17=$P($P(DGBTVAR("A"),"^",2),",",2)_" "_$P($P(DGBTVAR("A"),"^",2),",")
        Q
CITY    S DGBTCSZ=DGBTCNA
        S:VAPA(5)'="" DGBTCNU=$O(^DGBT(392.1,"ACS",DGBTCNA,+VAPA(5),0))
        I $D(DGBTCNU),(DGBTCNU'="") S DGBTCSZ=$P(^DGBT(392.1,DGBTCNU,0),"^")_", "_($P(^DIC(5,+VAPA(5),0),"^",2))_"  "_($P(^DGBT(392.1,DGBTCNU,0),"^",4))
        Q
QUE     ;
        N I
        S ZTRTN="PRINT^DGBTCR",ZTDESC="VA FORM 70-3542d"
        F I="DFN","DGBTDT","DGBTFCTY","DGBTTCTY" S ZTSAVE(I)=""
        D ^%ZTLOAD W:$D(ZTSK) !,"TASK #",ZTSK
        D HOME^%ZIS K IO("Q")
        Q
