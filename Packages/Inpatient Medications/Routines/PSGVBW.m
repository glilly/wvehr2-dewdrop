PSGVBW ;BIR/CML3,MV-VERIFY ORDERS BY WARD, WARD GROUP, OR PATIENT ;22 Oct 98 / 3:14 PM
 ;;5.0; INPATIENT MEDICATIONS ;**5,16,39,59,62,67,58,81,80,110,111,133,139,155**;16 DEC 97
 ;
 ; Reference to ^PS(55 is supported by DBIA #2191
 ;
 N PSJNEW,PSGPTMP,PPAGE,CL,CG S PSJNEW=1
START ;
 D ENCV^PSGSETU I $D(XQUIT) K XQUIT Q
 ;I ($P(PSJSYSU,";")=3)!($P(PSJSYSU,";",3)=2) 
 D ^PSIVXU I $D(XQUIT) K XQUIT Q
 D NOW^%DTC S PSGDT=%
 I '$D(^XTMP("PSJPVNV")) D
 .K DIR S DIR(0)="Y",DIR("A")="Display an Order Summary",DIR("B")="NO"
 .S DIR("?",1)="Enter 'YES' to see a summary of orders by type and ward group",DIR("?")="or 'NO' to go directly to patient selection."
 .D ^DIR K DIR Q:$D(DIRUT)!$D(DUOUT)  I Y D CNTORDRS^PSGVBWU
 K ^TMP("PSJ",$J) S PSGPXN=0 D GTOOP G:$D(DIRUT) DONE L +^PS(53.45,PSJSYSP):1 E  D LOCKERR^PSJOE G DONE
 S PSGSSH="VBW",PSGPXN=0,PSJPROT=$S($P(PSJSYSU,";",3)=3:3,$G(PSJRNF):3,$G(PSJIRNF):3,1:1)
 S PSGVBWW=$S(PSJTOO=1:"NON-VERIFIED",PSJTOO=2:"PENDING",1:"NON-VERIFIED AND/OR PENDING")
 F  K ^TMP("PSJSELECT",$J) D ^PSGSEL Q:"^"[PSGSS  F  S (PSGP,WD,WG)=0 S PSGPTMP=0,PPAGE=1 D @PSGSS Q:+Y'>0  D GO
 ;
DONE ;
 K ^TMP("PSGVBW",$J),^TMP("PSJSELECT",$J),^TMP("PSJLIST",$J),^TMP("PSJON",$J)
 K CHK,D0,DRGI,FQC,J,ND,ON,PN,PSGODT,PSGOEA,PSGOP,PSGSS,PSGSSH,RB,SD,ST,TM,WD,WDN,WG,PRI,PSJPNV,PSJCT,PSGCLF
 K PSGODDD,PSGOEORF,PSJORL,PSJORPCL,PSJORTOU,PSJORVP,PSGTOL,PSJTOO,PSGUOW,PSGONV,PX,PSGOEAV,PSGPX,PSGVBWTO,PSGVBWW,PSJOPC,PSGOENOF,PSJPROT,PSJLM,PSJASK
 L -^PS(53.45,PSJSYSP) G:$G(PSGPXN) ^PSGPER1 D ENKV^PSGSETU K ND Q
 ;
GO ;
 I PSGSS'="P" W !,"...a few moments, please..." K ^TMP("PSGVBW",$J) D ARRAY K CHK,ON,PN,RB,SD,TM,WD,WDN,WG,X,Y
 I PSGSS'="P",'$D(^TMP("PSGVBW",$J)) W !,$C(7),"NO ",PSGVBWW," ORDERS FOR ",$S(PSGSS="P":"PATIENT",PSGSS="L":"CLINIC GROUP",PSGSS="C":"CLINIC",1:"WARD"),$S(PSGSS="G":" GROUP",1:"")," SELECTED." Q
 D ^PSGVBW0 Q
 ;
 ; look-ups on ward group, ward, or patient; depending on value of SS
G ;
 K DIR S DIR(0)="FAO",DIR("A")="Select WARD GROUP: "
 S DIR("?")="^D GDIC^PSGVBW" W ! D ^DIR
 I Y="^OTHER" D OUTPT^PSGVBW1 Q
 ;S DIC="^PS(57.5,",DIC(0)="QEAMI",DIC("A")="Select WARD GROUP: "
GDIC ;
 K DIC S DIC="^PS(57.5,",DIC(0)="QEMI" D ^DIC K DIC S:+Y>0 WG=+Y
 W:X["?" !!,"Enter ""^OTHER"" to include all Outpatient IV orders and orders from the",!,"wards that do not belong to a ward group",!
 Q
C ;
 K DIR S DIR(0)="FAO",DIR("A")="Select CLINIC: "
 S DIR("?")="^D CDIC^PSGVBW" W ! D ^DIR
CDIC ;
 K DIC S DIC="^SC(",DIC(0)="QEMIZ" D ^DIC K DIC S:+Y>0 CL=+Y
 W:X["?" !!,"Enter the clinic you want to use to select patients for processing.",!
 Q
L ;
 K DIR S DIR(0)="FAO",DIR("A")="Select CLINIC GROUP: "
 S DIR("?")="^D LDIC^PSGVBW" W ! D ^DIR
LDIC ;
 K DIC S DIC="^PS(57.8,",DIC(0)="QEMI" D ^DIC K DIC S:+Y>0 CG=+Y
 W:X["?" !!,"Enter the name of the clinic group you want to use to select patients for processing."
 Q
W ;
 K DIR S DIR(0)="FAO",DIR("A")="Select WARD: "
 S DIR("?")="^D WDIC^PSGVBW" W ! D ^DIR
 I Y="^OTHER" D OUTPT^PSGVBW1 Q
WDIC ;
 ;S DIC="^DIC(42,",DIC(0)="QEAMI",DIC("A")="Select WARD: "
 K DIC S DIC="^DIC(42,",DIC(0)="QEMIZ" D ^DIC K DIC S:+Y>0 WD=+Y
 W:X["?" !!,"Enter ""^OTHER"" for Outpatient IV orders",!
 Q
P ;
 K ^TMP("PSJSELECT",$J) S PSJCNT=1 F  D ^PSJP Q:PSGP<0  D
 .S PSJNV=0
 .NEW ON,XX F ON=0:0 S ON=$O(^PS(53.1,"AS","N",PSGP,ON)) Q:'ON  S ND=$P($G(^PS(53.1,ON,0)),U,4) S XX=$S(ND="U"&(PSJPAC'=2):1,ND'="U"&(PSJPAC'=1):1,1:0) I XX S PSJNV=1 Q
 .;S PSJNV=$O(^PS(53.1,"AS","N",+PSGP,0)),PSJPEN=$O(^PS(53.1,"AS","P",+PSGP,0))
 .S PSJPEN=$O(^PS(53.1,"AS","P",+PSGP,0))
 .I 'PSJNV D ^PSJAC D
 ..I '$D(PSGDT) D NOW^%DTC S PSGDT=$E(%,1,12)
 ..S X1=$P(PSGDT,"."),X2=-2 D C^%DTC S PSGODT=X_(PSGDT#1)
 ..I PSJPAC'=2 F ST="C","O","OC","P","R" F SD=$S(ST="O":PSJPAD,1:PSGODT):0 S SD=$O(^PS(55,PSGP,5,"AU",ST,SD)) Q:'SD!PSJNV  F ON=0:0 S ON=$O(^PS(55,PSGP,5,"AU",ST,SD,ON)) Q:'ON  I $D(^PS(55,PSGP,5,ON,0)),$P(^(0),"^",9)'["D" D IFT I  S PSJNV=1 Q
 ..I PSJPAC'=1 F SD=+PSJPAD:0 S SD=$O(^PS(55,PSGP,"IV","AIS",SD)) Q:'SD  F ON=0:0 S ON=$O(^PS(55,PSGP,"IV","AIS",SD,ON)) Q:'ON  I $D(^PS(55,PSGP,"IV",ON,0)),$P(^(0),"^",17)'["D" D IFT2 I  S PSJNV=1 Q
 .S X=$S(PSJTOO=1:PSJNV,PSJTOO=2:PSJPEN,1:(PSJNV+PSJPEN))
 .I X D SETPN S ^TMP("PSJSELECT",$J,PSJCNT)=PN,^TMP("PSJSELECT",$J,"B",$P(PN,U),PSJCNT)="",PSJCNT=PSJCNT+1 Q
 .W !,"No ",PSGVBWW," orders found for this patient."
 S:$D(^TMP("PSJSELECT",$J)) Y=1
 Q
 ;
ARRAY ; put patient(s) with non-verified orders into array
 I '$D(PSGDT) D NOW^%DTC S PSGDT=$E(%,1,12)
 S X1=$P(PSGDT,"."),X2=-2 D C^%DTC S PSGODT=X_(PSGDT#1),PSGVBWW=$S(PSJTOO=1:"NON-VERIFIED",PSJTOO=2:"PENDING",1:"NON-VERIFIED AND/OR PENDING") I PSGSS="P" D IF S:$T ^TMP("PSGVBW",$J)=$P(PSGP(0),"^")_"^"_PSGP Q
 G CG:PSGSS="L",CL:PSGSS="C",WD:PSGSS="W" F WD=0:0 S WD=$O(^PS(57.5,"AC",WG,WD)) Q:'WD  D WD
 Q
 ;
CG S CL="" F  S CL=$O(^PS(57.8,"AD",CG,CL)) Q:CL=""  D CL
 Q
CL S WDN=$S($D(^SC(CL,0)):$P(^(0),"^"),1:"")
 S PSGP="",PSGCLF=1 F  S PSGP=$O(^PS(53.1,"AD",CL,PSGP)) Q:PSGP=""  D ^PSJAC,IF
 K PSGCLF
 Q
WD S WDN=$S($D(^DIC(42,WD,0)):$P(^(0),"^"),1:"") I WDN]"" F PSGP=0:0 S PSGP=$O(^DPT("CN",WDN,PSGP)) Q:'PSGP  I $S($D(^PS(55,"APV",PSGP)):1,$D(^PS(55,"APIV",PSGP)):1,$O(^PS(55,PSGP,5,"AUS",PSGDT)):1,1:$D(^PS(53.1,"AC",PSGP))) D ^PSJAC,IF
 Q
IF ;BHW;PSJ*5*155;Added PSGCLF and PS(53.1,"AD" Check below.  If called from CL subroutine and the order Doesn't exist for that Clinic, then QUIT.
 W "." I PSJTOO'=1 F ON=0:0 S ON=$O(^PS(53.1,"AS","P",PSGP,ON)) Q:'ON!(($G(PSGCLF))&('$D(^PS(53.1,"AD",+$G(CL),PSGP,+$G(ON)))))  S X=$P($G(^PS(53.1,ON,0)),U,4),Y=0 I "FIU"[X D  G:Y SET
 .I PSJPAC=3 S Y=1 Q
 .I PSJPAC=2 S Y=X'="U" Q 
 .I PSJPAC=1 S Y=X="U"
 Q:PSJTOO=2
 F X="N","I" I $D(^PS(53.1,"AS",X,PSGP)) NEW XX S XX=0 D  G:XX SET
 . NEW ON F ON=0:0 S ON=$O(^PS(53.1,"AS",X,PSGP,ON)) Q:'ON  S ND=$P($G(^PS(53.1,ON,0)),U,4) S XX=$S(ND="U"&(PSJPAC'=2):1,ND'="U"&(PSJPAC'=1):1,1:0) Q:XX
 S X1=$P(PSGDT,"."),X2=-2 D C^%DTC S PSGODT=X_(PSGDT#1)
 I PSJPAC'=2 F ST="C","O","OC","P","R" F SD=$S(ST="O":PSJPAD,1:PSGODT):0 S SD=$O(^PS(55,PSGP,5,"AU",ST,SD)) Q:'SD  F ON=0:0 S ON=$O(^PS(55,PSGP,5,"AU",ST,SD,ON)) Q:'ON  I $D(^PS(55,PSGP,5,ON,0)),$P(^(0),"^",9)'["D" D IFT I  G SET
 I PSJPAC'=1 F SD=+PSJPAD:0 S SD=$O(^PS(55,PSGP,"IV","AIS",SD)) Q:'SD  F ON=0:0 S ON=$O(^PS(55,PSGP,"IV","AIS",SD,ON)) Q:'ON  I $D(^PS(55,PSGP,"IV",ON,0)),$P(^(0),"^",17)'["D" D IFT2 I  G SET
 Q
 ;
IFT ;
 S ND=$G(^PS(55,PSGP,5,ON,4)) I $S(SD>PSGDT:$S(ND="":1,'$P(ND,"^",$S(PSJSYSU:PSJSYSU,1:1)):1,$P(ND,"^",13):1,$P(ND,"^",19):1,$P(ND,"^",23):1,1:$P(ND,"^",16)),ST="O":$S(ND="":1,1:'$P(ND,"^",$S(PSJSYSU:PSJSYSU,1:1))),1:$P(ND,"^",16))
 Q
 ;
IFT2 ;
 ;S ND=$G(^PS(55,PSGP,"IV",ON,4)) I $S((SD>PSGDT)&(ND=""):1,'$P(ND,"^",$S(+PSJSYSU=1:1,1:4)):1,1:0)
 S ND=$G(^PS(55,PSGP,"IV",ON,4))
 I ($P($G(^PS(55,PSGP,"IV",ON,.2)),"^",4)="D")&('$P(ND,"^",$S(+PSJSYSU=1:1,1:4)))  Q
 I $S((SD>PSGDT)&('$P(ND,"^",$S(+PSJSYSU=1:1,1:4))):1,1:0)
 Q
SET ;
 S TM=$S(PSJPRB="":"",1:$P($G(^PS(57.7,WD,1,+$O(^PS(57.7,"AWRT",WD,PSJPRB,0)),0)),"^")) S:TM="" TM="zz"
 ;
SETPN ;
 S PN=$P(PSGP(0),"^")_U_PSGP_U_PSJPBID S:PSGSS'="P" ^TMP("PSGVBW",$J,WDN,TM,PN)=""
 Q
 ;
GTOOP ; Get 'Type Of Order' and Package
 I $P(PSJSYSU,";",3)<2,'$G(PSJRNF),'$G(PSJIRNF) S PSJPAC=0,PSJTOO=1 D GTPAC Q
 S (PSJPAC,PSJTOO)=0 W !!,"1) Non-Verified Orders",!,"2) Pending Orders",!!
 N DIR S DIR(0)="LAO^1:2",DIR("A")="Select Order Type(s) (1-2): ",DIR("?")="^D TOH^PSGVBW" D ^DIR
 I 'Y D EXIT("TYPE OF ORDER") Q
 S PSJTOO=$S($L(Y)>2:3,1:$P(Y,","))
 D GTPAC
 I 'PSJPAC D EXIT("PACKAGE") Q
 Q
GTPAC ;
 ;S PSJTOO=$S($L(Y)>2:3,1:$P(Y,",")) Q:PSJTOO=1
 ;I $G(PSJRNF) S PSJPAC=1 Q
 I ($G(PSJRNF))&('$G(PSJIRNF))&(PSJTOO=2) S PSJPAC=1 Q
 I ($G(PSJIRNF))&('$G(PSJRNF))&(PSJTOO=2) S PSJPAC=2 Q
 W !!,"1) Unit Dose Orders",!,"2) IV Orders",!
 K DIR S DIR(0)="LAO^1:2",DIR("A")="Select Package(s) (1-2): ",DIR("?")="^D TOH^PSGVBW" W ! D ^DIR
 S PSJPAC=$S($L(Y)>2:3,1:$P(Y,","))
 Q
EXIT(X) ;
 W !!,X," not selected, option terminated."
 Q
 ;
TOH ;
 W !!,"SELECT FROM:",!?5,"1 - NON-VERIFIED ORDERS",!?5,"2 - PENDING ORDERS"
 W !!?2,"Enter '1' if you want to verify non-verified orders.  Enter '2' if you",!,"want to complete pending orders.  Enter '1,2' or '1-2' if you want to do both." Q
