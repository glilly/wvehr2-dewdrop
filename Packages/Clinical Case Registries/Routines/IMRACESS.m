IMRACESS ;ISC-SF/JLI,HCIOFO/FT-HANDLE LISTING AND DELETION OF ACCESS VIOLATIONS ;10/17/97  9:59
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 ;[IMR ACCESS LOG] - Access Violation Log
 I '$D(^XUSEC("IMRA",DUZ)) S IMRLOC="IMRACESS" D ACESSERR^IMRERR,H^XUS K IMRLOC
 ;
ASK W !!,"Do you want to:",!?5,"1.  List Access Violations",!?5,"2.  Delete Entries from the file",!!,"Select your choice:  " R X:DTIME G:'$T!(X[U)!(X="") EXIT S X=$E(X) S X=$S("Ll"[X:X=1,"Dd"[X:X=2,1:+X) I X<1!(X>2) W $C(7),"  ??",! G ASK
 S IMRX=X
 I X=2 S X1=DT,X2=-31 D C^%DTC F IMRJ=0:0 S IMRJ=$O(^IMR(158.8,IMRJ)) Q:IMRJ'>0!(IMRJ'<X)  S IMRK=$P(^(IMRJ,0),"^",1) I IMRK K ^IMR(158.8,IMRJ),^IMR(158.8,"B",IMRK,IMRJ)
 I IMRX=2 S X=0 F IMRJ=0:0 S IMRJ=$O(^IMR(158.8,IMRJ)) Q:IMRJ'>0  S X=X+1
 I IMRX=2 S:X>0 $P(^IMR(158.8,0),U,4)=X S:X'>0 ^(0)=$P(^IMR(158.8,0),U,1,2) W !!,"All entries over 30 days old have been removed",!! G EXIT
 K IOP,%ZIS S %ZIS="QM" D ^%ZIS G:POP EXIT I $D(IO("Q")) K IO("Q") S ZTRTN="DQ^IMRACESS",ZTDESC="List IMR Access Violations",ZTIO=ION,ZTREQ="@",ZTSAVE("ZTREQ")="" D ^%ZTLOAD K ZTRTN,ZTDESC,ZTIO,ZTSAVE,ZTSK G EXIT
DQ ; List Access Violations
 U IO S IMRPG=0 D GETNOW,HEDR S IMRUT=0
 F IMRI=0:0 S IMRI=$O(^IMR(158.8,IMRI)) Q:IMRI'>0  I $D(^(IMRI,0)) D:$Y>(IOSL-4) HDR Q:IMRUT  S X=IMRI W !,"   " D PDATE W "   " S X=^(0),Y=+$P(X,U,2),Y=$S('$D(^VA(200,+Y,0)):"DUZ = "_Y,1:$P(^(0),U)) W $E(Y,1,30),?55,$P(X,U,3,6)
 I 'IMRUT D
 .Q:$E(IOST)'="C"
 .Q:$D(IO("S"))
 .K DIR S DIR(0)="E" D ^DIR
 .Q
 D ^%ZISC
EXIT K %,%H,%T,%ZIS,IMRDTE,IMRX,IMRI,IMRJ,IMRK,IMRPG,IMRUT,IOP,POP,X,X1,X2,Y,D,DISYS,DIR,DIROUT,DIRUT,DTOUT,DUOUT
 Q
PDATE W $E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)," " S X=$P(X,".",2)_"000000" W $E(X,1,2),":",$E(X,3,4),":",$E(X,5,6)
 Q
GETNOW ; Get External Printed Date/time
 D NOW^%DTC S IMRDTE=% K %,%H,%I,X
 S Y=IMRDTE D DD^%DT S:Y'="" IMRDTE=Y K Y
 Q
HDR I ($E(IOST,1,2)="C-"&IMRPG) W ! S DIR(0)="E" D ^DIR K DIR I 'Y S IMRUT=1 Q
HEDR ; Header For Listing Access Violation
 W:'($E(IOST,1,2)'="C-"&'IMRPG) @IOF,!! S IMRPG=IMRPG+1
 W !,IMRDTE,?72,"Page ",IMRPG,!!
 W !,"For each entry on this list there should be a complete listing of the current",!,"local variables in the system error log, which may provide more information",!,"on these access attempts.",!!
 W !?5,"DATE",?15,"TIME",?25,"USER ID",?55,"LOCATION OF VIOLATION",!
 Q
