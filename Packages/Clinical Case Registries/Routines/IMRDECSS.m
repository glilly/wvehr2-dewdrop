IMRDECSS ;HCIOFO/FAI-DECODE SSN ENCRYPTION;07/05/00 4:21
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
BEGIN ;
 D START,SEARCH
KILL K ^TMP($J),IMRSSN,IMRX,IMRDOB,IMRNAME,IMRSSN1,X1,IMRDFN
 Q
START W !! K DIR S DIR(0)="F^9:13^",DIR("A")="Enter Coded SSN" D ^DIR K DIR S IMRCDSSN=Y
 Q:$G(IMRCDSSN)["^"
 W !!,"I will now search the database to decode the SSN... please wait",!
 F IMRJ=0:0 S IMRJ=$O(^IMR(158,IMRJ)),IMRCAT="" Q:IMRJ'>0  S X=+^(IMRJ,0) D ^IMRXOR S (IMRDFN,IMRFN)=X,(FN,DFN,D0,DA)=IMRFN,IMRCAT=$P($G(^IMR(158,IMRJ,0)),U,42) D IMRREF
 Q
IMRREF ; store and reference immunology decoding
 D DEM^VADPT
 S IMRNAME=VADM(1),IMRSSN1=$P(VADM(2),U),IMRDOB1=$P(VADM(3),U)
 K DFN,VA,VADM
 S X=IMRDFN D ^IMRXOR S IMRX=X,X=+IMRSSN1 D ^IMRXOR
 S IMRSSN=X_$S(IMRSSN1["P":"P",1:""),X=$E(IMRDOB1,1,5)_"00" D ^IMRXOR
 S IMRDOB=X
 S X=IMRDOB1,X1=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
 S:$G(IMRX)'="" ^TMP($J,IMRSSN,IMRX)=IMRDOB_"^"_IMRNAME_"^"_IMRSSN1_"^"_X1_"^"_IMRDFN
 Q
SEARCH Q:$G(IMRCDSSN)["^"
 S (IMRX,IMRDOB,IMRNAME,IMRSSN1,X1,IMRDFN)=""
 S IMRX="" F  S IMRX=$O(^TMP($J,IMRCDSSN,IMRX)) Q:IMRSSN=""  G DISP
 Q
DISP ; Display patient info
 I $G(IMRX)="" W !,"The coded number you entered is either not listed in your local ICR",!,"or was typed incorrectly.  Please check that you entered the coded SSN",!,"correctly.   *** NO TRANSLATION FOUND FOR THIS PATIENT ***" Q
 S REC=^TMP($J,IMRCDSSN,IMRX),IMRDOB=$P(REC,U,1),IMRNAME=$P(REC,U,2),IMRSSN1=$P(REC,U,3),X1=$P(REC,U,4),IMRDFN=$P(REC,U,5)
 W !!?12,"Coded SSN: ",IMRCDSSN
 W !?12,"Name: ",IMRNAME
 W !?12,"SSN: ",IMRSSN1
 W !?12,"Date of Birth: ",X1
 W !?12,"Patient's id in the Immunology Case Study file: ",IMRX
 W !?12,"Coded Date of Birth: ",IMRDOB
 W !?12,"Patient's number in the Patient file: ",IMRDFN
 G BEGIN
 Q
