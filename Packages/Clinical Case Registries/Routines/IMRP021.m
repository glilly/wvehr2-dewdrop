IMRP021 ;HCIOFO/SG - PATCH 21 INSTALLATION ; 1/4/05 9:41am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**21**;Feb 09, 1998
 ;
 ;***** ENVIRONMENT CHECKS
ENVCHK ;
 ;;Post-install routine of this patch will COMPLETELY DELETE
 ;;the Immunology Case Registry v2.1 package from your account.
 ;;This package was replaced by the new version of the registry
 ;;added to the Clinical Case Registries package.
 ;
 N DA,DIR,DIRUT,DTOUT,DUOUT,X,Y
 I $G(DUZ)'>0  D  S XPDABORT=2  Q
 . W !!,"The DUZ variable must be defined!",!
 Q:'$G(XPDENV)
 ;
 ;--- Request a confirmation from the user
 K DIR  S DIR(0)="Y"
 F X=1:1  S Y=$P($T(ENVCHK+X),";;",2,999)  Q:Y=""  S DIR("A",X)=Y
 S DIR("A")="Do you really want to delete the IMR v2.1"
 S DIR("B")="NO"
 D ^DIR  I '$G(Y)!$D(DIRUT)  D  Q
 . S XPDQUIT=1  ; Abort and remove the transport global
 ;
 ;--- Do not ask unnecessary questions
 S XPDDIQ("XPZ1")=0
 S XPDDIQ("XPZ2")=0
 Q
 ;
 ;***** DISPLAYS THE MESSAGE IF THE INSTALLATION ABORTS
ABTMSG ;
 ;;You can use the Install File Print [XPD PRINT INSTALL FILE]
 ;;option to investigate the problem.  Please fix the error(s)
 ;;and restart the patch installation using the Restart Install
 ;;of Package(s) [XPD RESTART INSTALL] option.
 ;
 N I,INFO,TMP
 F I=1:1  S TMP=$T(ABTMSG+I)  Q:TMP'[";;"  S INFO(I)=$P(TMP,";;",2,99)
 D MSG^IMRVPPU("ERROR(S) DURING THE PATCH INSTALLATION!",.INFO,1)
 Q
 ;
 ;***** ERROR PROCESSING
ERROR ;
 N XQADATA,XQAID,XQAMSG,XQAROU
 S XPDABORT=2
 I $D(ZTQUEUED)  D  D SETUP^XQALERT
 . S XQAMSG="Error during the installation of "_XPDNM,XQA(+DUZ)=""
 D ABTMSG
 Q
 ;
 ;***** POST-INSTALLATION ENTRY POINT
POS ;
 N DEL,IMRVPP,RC,X
 S RC=0  D INIT^IMRVPP()
 ;
 ;--- Search for package data
 S RC=$$ADDNSF^IMRVPP("IMR",158,159.999)  G:RC<0 ERROR
 S RC=$$SELVIFS^IMRVPP()                  G:RC<0 ERROR
 S RC=$$SELRTNS^IMRVPP()                  G:RC<0 ERROR
 ;
 ;--- Delete package data
 S RC=$$PURGE^IMRVPP()                    G:RC<0 ERROR
 ;
 ;--- Cleanup
 D INIT^IMRVPP()  S DEL=^%ZOSF("DEL")
 F X="IMRVPP","IMRVPPE","IMRVPPU"  X DEL
 Q
