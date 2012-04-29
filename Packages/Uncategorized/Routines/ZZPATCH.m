ZZPATCH ; REVIEW INSTALL FILE FOR RECENTLY LOADED/INSTALLED PATCHES
 NEW ICSCREEN,ZZIOSL,DIR,PATCHES,X,Y,IEN,STOP,KATHY,KAREN,STATUS,PSEARCH
 NEW PATCHNM,OLDPCH,DT,DTIME,DUZ,DIRUT,DUOUT,DISYS,IO
EN ;
 W !!
 K ICSCREEN,PSEARCH
 S ZZIOSL=20,OLDPCH=4600
 S DIR(0)="SO^1:Regular Listing;2:Screen out 'Install Completed';3:Modify Page Length;4:Search for Specific Package or Patch;5:Quit"
 S DIR("A")="Select the type of display"
 S DIR("B")=1
 I $G(PATCHES) S DIR("B")=5
 D ^DIR K DIR I 'Y G EXIT
 I Y=1 G 1
 I Y=2 G S
 I Y=3 G F
 I Y=4 G X
 I Y=5 G EXIT
EXIT ;
 QUIT
 ;
 ;
1 ;
 S IEN=999999,STOP=0,U="^",DUZ=12799,DT=$P($$NOW^XLFDT,".",1)
 S DTIME=300,DUZ(0)="@",PATCHES=0
 K ^TMP($J,"ZZPATCH")
 W #
 F  S IEN=$O(^XPD(9.7,IEN),-1) Q:'IEN!STOP!(IEN<OLDPCH)  D
 . I $Y>ZZIOSL D  Q:STOP
 .. N X R !,"Continue? ",X:DTIME
 .. I $L(X),$F("^Nn",$E(X)) S STOP=1 Q
 .. W #
 .. Q
 . S PATCHES=PATCHES+1
 . I PATCHES#50=0,$G(ICSCREEN)!($G(PSEARCH)'="") W "."
 . S KATHY=$G(^XPD(9.7,IEN,0))
 . S KAREN=$G(^XPD(9.7,IEN,1))
 . S STATUS=$$EXTERNAL^DILFD(9.7,.02,"",$P(KATHY,U,9))
 . I $G(ICSCREEN),STATUS="Install Completed" Q
 . S PATCHNM=$P(KATHY,U,1)
 . I $D(PSEARCH),PATCHNM'[PSEARCH Q
 . W !,PATCHNM
 . I $D(^TMP($J,"ZZPATCH",PATCHNM)) W " **"
 . S ^TMP($J,"ZZPATCH",PATCHNM,IEN)=""
 . W ?15,STATUS
 . W ?45,"Loaded: ",$$FMTE^XLFDT($P(KATHY,U,3),"2Z")
 . W !?15,$P($G(^VA(200,+$P(KATHY,U,11),0)),U,1)
 . W ?42,"Installed: ",$$FMTE^XLFDT($P(KAREN,U,3),"2Z")
 . Q
 K ^TMP($J,"ZZPATCH")
 G EN
 ;
 ;
S ; screen out "Install Completed" patches from display
 S ICSCREEN=1,ZZIOSL=20 G 1
 ;
F ; ask how big the page length should be
 K ICSCREEN
 S DIR(0)="NO^1:999:0",DIR("A")="Page Length",DIR("B")=20
 D ^DIR K DIR
 I 'Y Q
 S ZZIOSL=Y
 G 1
 ;
X ; search for package or patch indicated
 S OLDPCH=2000   ; go back farther
 R !!,"Enter Package or Patch to search for:  ",PSEARCH
 I PSEARCH="" KILL PSEARCH
 G 1
 ;
