ONCOAID ;Hines OIFO/GWB-PATIENT DEMOGRAPHIC INFORMATION ;7/20/93
 ;;2.11;ONCOLOGY;**23,37**;Mar 07, 1995
DEM ;Display demographic information
 D SET S X=ONCOVP,DFN=$P(X,";",1),FIL=$P(X,";",2)
 S ONC="^"_FIL_DFN
 S ONCO=ONC_",0)" S ONCO0=$S($D(@ONCO):^(0),1:"") I ONCO0="" W "??dangling pointer" Q
FIL ;name file
 S FN=$S(FIL="DPT(":"Patient",1:"Referral")
SN S SN=$P(ONCO0,U,9),ONCOMR=SN,ONCOSN=$E(SN,1,3)_"-"_$E(SN,4,5)_"-"_$E(SN,6,9)
DB S Y=$P(ONCO0,U,3) D DD^%DT S ONCODB=Y
PB S POB=$P(ONCO0,U,12),SOB=$S(POB="":"",1:$P(^DIC(5,POB,0),U))
 ;translate SEX,RACE & code Ethenticity
SX S SX=$P(ONCO0,U,2),SEX=$S(SX="M":"Male",SX="F":"Female",1:"Not Stated")
RC S R=$P(ONCO0,U,6),RC=$G(^ONCO(164.46,+R,0)),R=$P(RC,U,2),RCE=$P(RC,U),RCE=$S(RC="":"Not Stated",1:RCE)
MS ;marital status
 S MS=$P(ONCO0,U,5),MS=$S(MS=1:4,MS=4:5,MS=5:3,MS=6:1,MS=7:9,1:MS) ;SAVE for abstract
XD S ONCO=ONC_",.35)" S Y=$S($D(@ONCO):$P(@ONCO,U),1:"") I Y'="" S ONCODD=Y D DD^%DT S XD=Y ;    ONC defined in paragraph DEM above
AD S ONCO=ONC_",.11)" S YY=$S($D(@ONCO):^(.11),1:"") I YY F J=1:1:7 S A(J)=$P(YY,U,J) K:A(J)="" A(J) ;    ONC defined in paragraph DEM above
TL S ONCO=ONC_",.13)" I $D(@ONCO) S TL=$P(^(.13),U,1) ;    ONC defined in paragraph DEM above
W W !!,?6,"The following information is contained in the ",FN," file"
 W !?12,"NOT editable - See your MAS department IF in error",!
N W !?20,"Name: ",ONCONM,!
1 W !,"DOB:  ",ONCODB W:$D(A(1)) ?31,"Address: ",A(1) W:$D(A(2)) " ",A(2)
2 W !,"SSN:  ",ONCOSN W:$D(A(4)) ?40,A(4) W:$D(A(5)) ",",$P(^DIC(5,A(5),0),U)
4 W !,"SEX:  ",SEX W:$D(CT) ?40,"County: ",CT
 W !,"POB:  ",$S(SOB="":"Not Stated",1:SOB) W:$D(TL) ?40,TL
 W:$D(XD) !,"DEATH: ",XD
TT S D0=ONCOD0 W ! D NOK^ONCOCON
W4 W !!?10,"************* Oncology Patient file DATA **************"
 G PAT
CT ;get county from zipcode (may be different from COUNTY).
 K CT S Y=A(6),Y=$O(^VIC(5.11,"B",Y_" ",0)),ZP0=$S($D(^VIC(5.11,+Y,0)):^(0),1:"") Q:ZP0=""  S CY=$P(ZP0,U,2),CT=$P(^VIC(5.1,$P(ZP0,U,3),0),U)
 Q
 ;
PAT S ONCOSX=$S(SX="M":1,SX="F":2,1:9)
 ;S ONCOET=$S(R="":9,R<3:6,R>2&(R<7):0,R=7:9,1:9)
XX S RCC=$S(R="":99,R<4:R,R=4:2,R=6:1,1:99)
POB S X=SOB,DIC="^ONCO(165.2,",DIC(0)="ZM" D ^DIC K DIC,X
 S ONCOPB=$S(Y=-1:999,+Y=633:33,1:+Y)
 S $P(^ONCO(160,ONCOD0,0),U,5,8)=ONCOPB_U_ONCORC_U_ONCOET_U_ONCOSX
 S:$D(ONCODD) $P(^ONCO(160,ONCOD0,1),U,8)=ONCODD
 D KIL Q
 ;
SET S (POB,ET,YY,TL,ONCODB,ONCODD,ONCOET,ONCOMR,ONCOPB,ONCORC,ONCOSN,ONCOSX)=""
 Q
KIL ;Kill Variables
 K A,DOB,CT,CY,DA,DFN,DIC,DIE,DR,ET,ETH,FIL,FN,J,MS,POB,ONC,ONCO,PRT,R,RC,RCC,RCE,SN,SOB,TL,X,XD,XX,Y,YY,ZP0
 Q
