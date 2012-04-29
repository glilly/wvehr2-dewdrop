IMRDD ;ISC-SF.SEA/JLI-CHECK FOR STATUS AGREEING WITH DATE OF DEATH ;10/21/91  15:27
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
CHEK ; called from ^DD(158,15.7,0)-Patient Status (1:alive,2:dead,9:unknown)
 S IMRXA=X,X=+^IMR(158,DA,0) D ^IMRXOR
 S (IMRXDFN,DFN)=X D DEM^VADPT K DFN
 S X=IMRXA,IMRXA=VADM(6)>0 K VA,VADM
 I IMRXA=1,X'=2 W $C(7),!,"***** Patient has a DATE OF DEATH, setting it to 2 ****",! S X=2 K IMRXA,IMRXDFN Q
 I IMRXA=0,$D(^IMR(158,DA,5)),$P(^(5),U,19)'="",$P(^(5),U,19)>0,X=2 S IMRXA=1 I X'=2 W $C(7),!,"**** Patient has an ICR DATE OF DEATH ENTERED, setting status to DEAD ****",! S X=2 K IMRXA,IMRXDFN Q
 I IMRXA=0,X=2 R !!,"Do you want to enter an ICR DATE OF DEATH (Y/N) ? ",Y:DTIME I "yY"[$E(Y_".") S IMRXB=X,%DT="AEQP" D ^%DT S X=IMRXB K %DT,IMRXB I Y>0 S $P(^IMR(158,DA,5),U,19)=Y K IMRXA,IMRXDFN Q
 I IMRXA=0,X=2 W $C(7),!,"***** PATIENT FILE has NO date of death entered,",!,"AND IMR DATE OF DEATH FIELD HAS NO DATE *****",!,"*****  You must choose 1 or 9 *****",! K X
 K IMRXA,IMRXDFN
 Q
