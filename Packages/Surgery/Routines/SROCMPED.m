SROCMPED ;BIR/MAM - ENTER/EDIT OCCURRENCES ;03/14/06
 ;;3.0; Surgery ;**26,38,47,125,153**;24 Jun 93;Build 11
 I '$P(^SRF(SRTN,SRTYPE,SRENTRY,0),"^",2) D NOCAT I SRSOUT S SRSOUT=0 Q
 I '$D(^SRF(SRTN,SRTYPE,SRENTRY,0)) K SRENTRY S SRSOUT=0 Q
START I '$D(^SRF(SRTN,SRTYPE,SRENTRY)) K SRENTRY S SRSOUT=0 Q
 S SRSOUT=0,SR=^SRF(SRTN,SRTYPE,SRENTRY,0)
 I $G(SRNEW),$P(SR,"^",2)=3,SRTYPE=16 D SEPSIS G:SRSOUT END G START
 I $G(SRNEW),$P(SR,"^",2)=27,SRTYPE=16,$P($G(^SRF(SRTN,"RA")),"^",2)="C" D RCP G:SRSOUT END G START
 D HDR^SROAUTL W !
 S SRO(1)=$P(SR,"^")_"^.01",X=$P(SR,"^",2),SRO(2)=X_"^"_$S(SRTYPE=10:3,1:5) I X S $P(SRO(2),"^")=$P(^SRO(136.5,X,0),"^")
 I $P(SR,"^",2)=3 S Y=$P(SR,"^",4),C=$P(^DD(130.22,7,0),"^",2) D:Y'="" Y^DIQ S SRO(3)=Y_"^7"
 I $P(SR,"^",2)'=3 D
 .I $P(SR,"^",2)=27,$P($G(^SRF(SRTN,"RA")),"^",2)="C" S Y=$P(SR,"^",5),C=$P(^DD(130.22,8,0),"^",2) D:Y'="" Y^DIQ S SRO(3)=Y_"^8" Q
 .S X=$P(SR,"^",3) S:X X=$P(^ICD9(X,0),"^")_"  "_$P(^(0),"^",2) S SRO(3)=X_"^"_$S(SRTYPE=10:4,1:6)
 S SR(2)=$G(^SRF(SRTN,SRTYPE,SRENTRY,2)),SRO(4)=$P(SR(2),"^")_"^"_$S(SRTYPE=10:2,1:3)
 S X=$P(SR,"^",6),SHEMP=$S(X="U":"UNRESOLVED",X="I":"IMPROVED",X="D":"DEATH",X="W":"WORSE",1:""),SRO(5)=SHEMP_"^.05"
 K SRO(6) I SRTYPE=16 S X=$P(SR,"^",7) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) S SRO(6)=X_"^2"
DISP W !,"1. Occurrence: ",?26,$P(SRO(1),"^"),!,"2. Occurrence Category: ",?26,$P(SRO(2),"^")
 W !,"3. "_$S($P(SR,"^",2)=3:"Sepsis Type",$P(SR,"^",2)=27&($P($G(^SRF(SRTN,"RA")),"^",2)="C"):"CPB Status",1:"ICD Diagnosis Code")_":",?26,$P(SRO(3),"^")
 W !,"4. Treatment Instituted:",?26,$P(SRO(4),"^"),!,"5. Outcome to Date:",?26,$P(SRO(5),"^")
 I $D(SRO(6)) W !,"6. Date Noted: ",?26,$P(SRO(6),"^")
 S SRX=$S(SRTYPE=10:6,1:7),SRO(SRX)="^" I $O(^SRF(SRTN,SRTYPE,SRENTRY,1,0)) S SRO(SRX)="*** INFORMATION ENTERED ***"_SRO(SRX)
 S X=$S(SRTYPE=10:1,1:4),SRO(SRX)=SRO(SRX)_X,SRMAX=SRX
 W !,SRX_". Occurrence Comments: ",?26,$P(SRO(SRX),"^")
 W !!,SRLINE
 W !!,"Select Occurrence Information: " R X:DTIME I '$T!("^"[X) S:X["^" SRSOUT=1 G END
 I "Aa"[X S X="1:"_SRMAX
 I X'?.N1":".N,'$D(SRO(X)) D HELP G:SRSOUT END W @IOF G START
 I X?.N1":".N S Y=$E(X),Z=$P(X,":",2) I Y<1!(Z>SRMAX)!(Y>Z) D HELP G:SRSOUT END W @IOF G START
 D HDR^SROAUTL W !
 I X?.N1":".N D RANGE G START
 I $$LOCK^SROUTL(SRTN) D  D UNLOCK^SROUTL(SRTN) D:SRZ=2 PRESS
 .S SRZ=X K DIE,DA,DR S DA(1)=SRTN,DA=SRENTRY,DIE="^SRF("_SRTN_","_SRTYPE_",",DR=$P(SRO(X),"^",2)_"T" D ^DIE K DR,DA
 G START
 Q
HELP W @IOF,!!!!,"Enter the number, or range of numbers you want to edit.  Examples of proper",!,"responses are listed below."
 W !!,"1. Enter 'A' to update all occurrence information."
 S RANGE="(1-"_SRMAX_")"
 W !!,"2. Enter a number "_RANGE_" to update a specific occurrence element.  (For",!,"   example, enter '2' to update the occurrence category)"
 W !!,"3. Enter a range of numbers "_RANGE_" separated by a ':' to enter a range of",!,"   elements.  (For example, enter '1:3' to enter occurrence, occurrence",!,"   category, and ICD diagnosis code)"
 W ! D PRESS
 Q
RANGE ; range of numbers
 I $$LOCK^SROUTL(SRTN) D  D UNLOCK^SROUTL(SRTN)
 .S SHEMP=$P(X,":"),CURLEY=$P(X,":",2) F EMILY=SHEMP:1:CURLEY Q:SRSOUT  D ONE
 I CURLEY=2 D PRESS
 Q
ONE ; edit one item
 K DR,DA,DIE S DR=$P(SRO(EMILY),"^",2)_"T",DA=SRENTRY,DA(1)=SRTN,DIE="^SRF("_SRTN_","_SRTYPE_"," D ^DIE K DR,DA I '$D(^SRF(SRTN,SRTYPE,SRENTRY))!$D(DTOUT)!$D(Y) S SRSOUT=1
 Q
END K SRO,SR,X,DA,DIE,DR,Y
 Q
SEPSIS D HDR^SROAUTL K DA,DIE,DR
 S DA=SRENTRY,DA(1)=SRTN,DR="7T",DIE="^SRF("_SRTN_","_SRTYPE_"," D ^DIE K DR,DA
 K DA,DIE,DR S SRNEW=0 I $D(DTOUT)!$D(Y) S SRSOUT=1 Q
 Q
RCP D HDR^SROAUTL K DA,DIE,DR
 S DA=SRENTRY,DA(1)=SRTN,DR="8T",DIE="^SRF("_SRTN_","_SRTYPE_"," D ^DIE K DR,DA
 K DA,DIE,DR S SRNEW=0 I $D(DTOUT)!$D(Y) S SRSOUT=1 Q
 Q
NOCAT W @IOF,!,"The occurrence selected does not have a corresponding category.  A category",!,"must be selected at this time, or the occurrence will be deleted.",!
 K DIE,DIC,X,Y,SRCAT
 S DIC=136.5,DIC(0)="QEAMZ",DIC("A")="Select Occurrence Category: ",DIC("S")="I '$P(^(0),U,2)" S:SRTYPE=10 DIC("S")=DIC("S")_",$P(^(0),U,3)" D ^DIC
 I +Y>0 S SRCAT=+Y K DIE,DR,DA S DA(1)=SRTN,DA=SRENTRY,DIE="^SRF("_DA_","_SRTYPE_",",DR=$S(SRTYPE=10:3,1:5)_"////"_SRCAT D ^DIE K DR,DA
 I $D(SRCAT) K SRCAT Q
DEL W !!,"Are you sure that you want to delete this occurrence ? NO// " R SRYN:DTIME I '$T!(SRYN["^") D YUP S SRSOUT=1 Q
 I "YyNn"'[SRYN W !!,"Enter 'YES' to delete this occurrence from the patient's record.  Enter 'NO'",!,"to backup and enter a category for this occurrence." G DEL
 I "Nn"[SRYN G NOCAT
YUP ; delete occurrence
 K DIK,DA S DA=SRENTRY,DA(1)=SRTN,DIK="^SRF("_SRTN_","_SRTYPE_"," D ^DIK S SRSOUT=1
 Q
PRESS W ! K DIR S DIR(0)="E" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
