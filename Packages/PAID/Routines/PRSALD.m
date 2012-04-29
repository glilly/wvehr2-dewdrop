PRSALD ;HISC/MGD-Labor Distribution Codes Edit ;06/28/2003
 ;;4.0;PAID;**82,114**;Sep 21, 1995;Build 6
 Q
PAY ; Payroll Entry
 N PPERIOD
 S PRSTLV=7
P1 K DIC S DIC("A")="Select EMPLOYEE: ",DIC(0)="AEQM",DIC="^PRSPC("
 W ! D ^DIC S DFN=+Y K DIC G:DFN<1 EX
 S TLE=$P($G(^PRSPC(DFN,0)),"^",8)
 D POST
 G P1
 Q
TL ; Timekeeper Entry. Select T & L Unit
 N PP,PPE,PPI,PRSTLV,TLI
 S PRSTLV=2 D ^PRSAUTL G:TLI<1 EX
 ;
LASTPP ; Get Last PP received in 459
 S PP="A"
 S PP=$O(^PRST(459,PP),-1)
 S PPE=$P($G(^PRST(459,PP,0)),"^",1)
 S PPI=""
 S PPI=$O(^PRST(458,"B",PPE,PPI))
 S PPE=PPE_"  "_$P($G(^PRST(458,PPI,2)),"^",1)_" -> "_$P($G(^PRST(458,PPI,2)),"^",14)
 ;
NME ; Select individual employee
 K DIC S DIC("A")="Select EMPLOYEE: ",DIC("S")="I $P(^(0),""^"",8)=TLE,$D(^PRST(458,PPI,""E"",+Y))",DIC(0)="AEQM",DIC="^PRSPC(",D="ATL"_TLE W ! D IX^DIC S DFN=+Y K DIC
 G:DFN<1 EX S GLOB="" D POST D:GLOB]"" UNLOCK^PRSLIB00(GLOB) G NME
 ;
EX ; Clean up variables and Exit
 K D,DA,DDSFILE,DFN,DR,GLOB,LP,NN,TLE,Y,ZS,%
 Q
 ;
POST ; Edit & Post Labor Distribution Codes
 Q:'DFN
 S DA=DFN
 S DDSFILE=450,DR="[PRSA LD POST]"
 D ^DDS K DS Q:'$D(ZS)
 Q
 ;
 ; The following code will be implemented in Phase 2 of the Labor Dist.
 ;
D2 ; Select All or individual employee
 W !!,"Would you like to edit the Labor Codes in alphabetical order"
 S %=1 D YN^DICN I % S LP=% G EX:%=-1,LOOP:%=1,NME
 W !!,"Answer YES if you want all RECORDs brought up for which no data"
 W !,"has been entered." G D2
 Q
 ;
LOOP ; Loop through all employees in selected T & L
 S LP=1,NN=""
 F  S NN=$O(^PRSPC("ATL"_TLE,NN)) Q:NN=""  D
 . F DFN=0:0 S DFN=$O(^PRSPC("ATL"_TLE,NN,DFN)) Q:DFN<1  D
 . . S GLOB="" D POST D:GLOB]"" UNLOCK^PRSLIB00(GLOB) I 'LP G EX
 G EX
 Q
 ;
PP ; Select Pay Period
 S DIC="^PRST(458,",DIC(0)="AEQZ",D="B"
 D IX^DIC
 Q:Y=-1
 S PPI=+Y,PPE="PP "_$P(Y,"^",2)_"   "
 S PPE=PPE_$P($G(^PRST(458,PPI,2)),"^",1)_" -> "_$P($G(^PRST(458,PPI,2)),"^",14)
 ;
LDOUT ; Convert LABOR DIST CODE EDITED BY field into its external format.
 ;
 I "IETP"'[Y&('+Y) D  Q
 . S Y="Unknown"
 I Y="I" S Y="Initial Download"
 I Y="E" S Y="Edit & Update Download"
 I Y="T" S Y="Transfer Download"
 I Y="P" S Y="Payrun Download"
 I +Y D
 . S Y=$P($G(^VA(200,Y,0)),"^",1)
 . I Y="" S Y="Unknown"
 Q
