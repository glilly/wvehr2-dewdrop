XTZRUTL ;ISCSF/RWF - Developer Routine Utilities ;7/24/97  13:47 [3/22/00 4:16pm]
 ;;7.3;TOOLKIT;**20,L02**;Apr 25, 1995
 ;
 Q  ;No entry from the top.
BUILD ;
 K ^UTILITY($J) D HOME^%ZIS
 N BLDA,DIC,IX,X
 I '$D(^XPD(9.6,0)) W !,"No BUILD file to work from." Q
 S Y=$$BUILD^XTRUTL1 G EXIT:Y'>0 S BLDA=+Y
CALL D RTN^XTRUTL1(BLDA)
 G EXIT:$O(^UTILITY($J,""))=""
 D UCI^%ZOSV S AAQUCI=$P(Y,",",1) K Y S AAQDT=$$HTE^XLFDT($H,"1M")
 W !!,"Post-Install Values from Build File "_AAQUCI_" Routines   "_AAQDT
 W !,"NOTE: Old and New values will be the same after XTRMON has run.",!,?6,"The Old value may look incorrect if a routine is patched more",!,?6,"than once in a day.  See On-Line Documentation for more info."
 S RN="" U IO W !!,?19,"Checksum",!,"Routine",?16,"Old",?26,"New",?35,"2nd Line Patches"
 F  S RN=$O(^UTILITY($J,RN)) Q:RN=""  D
 . S X=RN X ^%ZOSF("TEST") E  W !,RN," is not on the system." Q
 . S X=RN,XCNP=0,DIF="RTN(" K RTN X ^%ZOSF("LOAD") S LC=XCNP-1
 . D RSUM S Y=$O(^DIC(9.8,"B",RN,0)) Q:Y'>0
 . S OLDSUM=$P($G(^DIC(9.8,Y,0)),"^",5)
 . S X=RTN(2,0) W !,RN,?13,$J(OLDSUM,8),?23,$J(RSUM,8),?35,$P(X,";",5)
 . Q
EXIT K %,%N,AAQDT,AAQUCI,C,DIF,LC,OLDSUM,RN,RSUM,RSUM2,RTN,XCNP,Y
 D ^%ZISC
 Q
RSUM N Y,Y2,%,%1,%2,%3 S (Y,Y2)=0
 F %=1,3:1:LC S %1=RTN(%,0),%3=$F(%1," "),%3=$S($E(%1,%3)'=";":$L(%1),$E(%1,%3+1)=";":$L(%1),1:%3-2) F %2=1:1:%3 S Y=$A(%1,%2)*%2+Y,Y2=$A(%1,%2)*(%2+%)+Y2
 S RSUM=Y,RSUM2=Y2
 Q
OLDSUM(X) ;Get the OLD Checksum
 N Y S Y=$O(^DIC(9.8,"B",X,0)) Q:Y'>0 ""
 S X=$G(^DIC(9.8,Y,4))
 Q $P(X,"^",2)
UPDATE ;Update the ROUTINE file with current checksums
 K ^UTILITY($J)
 N BLDA,DIC,IX,X,NOW W !!,"This will update the ROUTINE file for the routines from a BUILD file."
 I '$D(^XPD(9.6,0)) W !,"No BUILD file to work from." Q
 S Y=$$BUILD^XTRUTL1 G EXIT:Y'>0 S BLDA=+Y
 D RTN^XTRUTL1(BLDA)
 S NOW=$$NOW^XLFDT()
 G EXIT:$O(^UTILITY($J,""))=""
 S RN=""
 F  S RN=$O(^UTILITY($J,RN)) Q:RN=""  D UD1(RN)
 W !,"Done"
 Q
UD1(RN) ;
 N X,XCNP,DIF,LC,RSUM,RSUM2,Y S:'$D(NOW) NOW=$$NOW^XLFDT
 S X=RN,XCNP=0,DIF="RTN(" K RTN X ^%ZOSF("LOAD") S LC=XCNP-1
 D RSUM
 S X=RTN(2,0)
 S Y=$$GETDA(RN) Q:Y'>0
 S ^DIC(9.8,+Y,4)=NOW_U_RSUM_"/"_RSUM2_U_$P(X,";",5)
 Q
SHOW(RN) ;Show current data
 N Y,%0,%4 S Y=$$GETDA(RN) Q:Y'>0  S %0=^DIC(9.8,Y,0),%4=$G(^(4))
 W !,$P(%0,U),?10,$P(%4,U),?28,$P(%4,U,2)
 Q
GETDA(X) ;Find a DA in file
 Q $O(^DIC(9.8,"B",X,0))
