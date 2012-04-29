AAQJCASE ;CTC/DSC;ROUTINE NAME SAVER ;11-Mar-91; [5/25/99 4:01pm]
 ;;1.4;AAQJ PATCH RECORD;; May 14, 1999
 ;;FGO/JHS-Modified for Kernel V8.0 and OpenM ;04-20-98
INIT I $G(DUZ(0))'="@" W !!,*7,"You don't have the necessary variables set up.  Calling XUP." D ^XUP ;NOTE: Originally written for @ access
 S U="^",CNT=0,(CHK,DO,DEL,DOO,II,KK,OPT,TXT,X,ZXX)="" K ^UTILITY($J)
INTRO W ! F TX=0:1:17 W !,$P($T(TXT+TX),";",2)
ASKOPT R "Select Option Number: ",X:$S($D(DTIME):DTIME,1:60) G:"12"'[$E(X,1) BADOPT G:X="" EXIT S OPT=$E(X,1)
 W !!,$S(OPT=2:"'lower' to 'UPPER' case chosen?   YES// ",OPT=1:"'UPPER' to 'lower' case chosen?   YES// ") R DO:$S($D(DTIME):DTIME,1:60) W ! G:"nN"[$E(DO_1,1) INIT
CHK W !,"Select routine(s) by the CURRENT name(s).",!,"Wild Card * and minus - selections may be used." D KERNEL^%RSET
 I %R=0 W !,"No routines were selected." G EXIT
 F CNT=1:1 S CHK=$O(^UTILITY($J,CHK)) I CHK="" Q
 D DISPLAY,CKCASE G:AAQMIX=1 INIT W !!,"Do you wish to save as all ",$S(OPT=1:"lowercase",OPT=2:"UPPERCASE"),"?   YES// " R DOO:$S($D(DTIME):DTIME,1:60) W ! G:"nN"[$E(DOO_1,1) INTRO
 G:OPT=1 SAVLO
SAVUP W "Saving as UPPERCASE." S ZX=0 F II=1:1 S ZXX="",ZX=$O(^UTILITY($J,ZX)) G:ZX="" ASKDEL D
 .F KK=1:1:$L(ZX) S:$E(ZX,KK)?1L ZXX=ZXX_$C($A(ZX,KK)-32) S:$E(ZX,KK)'?1L ZXX=ZXX_$E(ZX,KK)
 .S SAV="ZL @ZX ZS @ZXX" X SAV Q
SAVLO W "Saving as lowercase." S ZX=0 F II=1:1 S ZXX="",ZX=$O(^UTILITY($J,ZX)) G:ZX="" EXIT D
 .F KK=1:1:$L(ZX) S:$E(ZX,KK)?1U ZXX=ZXX_$C($A(ZX,KK)+32) S:$E(ZX,KK)'?1U ZXX=ZXX_$E(ZX,KK)
 .S SAV="ZL @ZX ZS @ZXX" X SAV Q
ASKDEL R !!,"Want to DELETE the lowercase routines?   YES// ",DEL:$S($D(DTIME):DTIME,1:60) G:DEL["N"!(DEL["n") EXIT
SHOW W ! S A=0,N=0 F N=0:1 S A=$O(^UTILITY($J,A)) Q:A=""  W:N<7 ?N#8*10,A
 W "...",!,N," Routines, use existing routine set? Y// " R X:60,! S:X="" X="Y" G:"Yy"[X RDEL
 K ^UTILITY($J) D KERNEL^%RSET
RDEL S X=0 S X=$O(^UTILITY($J,X)) Q:X=""
 R !,"OK to Delete? NO// ",DEL:60 I "Nn"[DEL W $C(7),!,"No Routines Deleted" G EXIT
 S NULL="" W ! X "F I=1:1 ZR  ZS @X W:$X>78 ! W $E(X_""          "",1,10) S X=$O(^(X)) Q:X=NULL"
EXIT W !,"Finished.",! K %R,%RN,%RS,%X,A,AAQ1RTN,AAQMIX,AAQOPT,AAQOPT1,AAQOPT2,AAQRCASE,CHK,CNT,DEL,DO,DOO,I,II,KK,N,NULL,OPT,SAV,TX,TXT,X,ZX,ZXX,^UTILITY($J)
 Q
BADOPT W $C(7),!!,"Reply with 1 or 2 or Press Return to Exit.",! G ASKOPT
DISPLAY S $Y=0,%X=0 S %RN=0,%RS=0 F X=1:1 S %RS=$O(^UTILITY($J,%RS)) Q:%RS=""  D:'(X-1#8) PAGE Q:%X  W ?(X-1)#8*10,%RS S %RN=%RN+1,AAQ1RTN=%RS
 Q
CKCASE S AAQOPT1="'UPPERCASE to lowercase'",AAQOPT2="'lowercase to UPPERCASE'",AAQRCASE="",AAQMIX=0
 I OPT=1,$E(AAQ1RTN,1)'?1U.E S AAQOPT=AAQOPT1,AAQRCASE="lowercase" G BADMIX
 I OPT=2,$E(AAQ1RTN,1)'?1L.E S AAQOPT=AAQOPT2,AAQRCASE="UPPERCASE" G BADMIX
 Q
BADMIX W $C(7),!!,"Wait a minute.  There seems to be something wrong here."
 W !,"You selected Option ",OPT," for changing ",AAQOPT,"."
 W !,"I checked one of the routines you selected and it was ",AAQRCASE,".",!,"That was an illogical choice or perhaps a simple typing mistake."
 W !,"Regardless of the CASE, you will have to make your selections",!,"and read the instructions again."
 R !!,"Press RETURN to continue: ",X:60
 S AAQMIX=1 Q
PAGE I $Y<21 W ! Q
 R !!,"Press RETURN to continue, '^' to quit: ",X:60
 Q:X=$A("^")
 W ! S $Y=0,%X=0
 Q
TXT ;              ***** ROUTINE NAME/CASE SAVER *****
 ;
 ;I'm going to use the routine(s) you select and change the names
 ;from all uppercase to lowercase characters or vice-versa.
 ;When you are changing from uppercase to lowercase, the original
 ;routines will remain untouched and stored under the same name.
 ;The result will be a duplicate set of routines with uppercase
 ;names and lowercase names.  When installing new routines, the
 ;lowercase set may be useful for running routine compares.
 ;When finished changing from lowercase to uppercase, you will be
 ;asked if you want to automatically delete the lowercase routines.
 ;
 ;Select (by number) from the following:
 ;
 ; 1. UPPERCASE - lowercase (eg afvTXT3 - afvtxt3)
 ; 2. lowercase - UPPERCASE (eg afvTXT3 - AFVTXT3)
