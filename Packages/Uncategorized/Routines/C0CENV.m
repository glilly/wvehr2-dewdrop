C0CENV ;WV/JMC - CCD/CCR Environment Check/Install Routine ; Aug 16, 2009
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;
 ;
ENV ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
 ;
 ; Make sure the patch name exist
 ;
 I '$D(XPDNM) D  Q
 . D BMES("No valid patch name exist")
 . S XPDQUIT=2
 . D EXIT
 ;
 D CHECK
 D EXIT
 Q
 ;
 ;
CHECK ; Perform environment check
 ;
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D
 . D BMES("Terminal Device is not defined")
 . S XPDQUIT=2
 ;
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D
 . D BMES("Please log in to set local DUZ... variables")
 . S XPDQUIT=2
 ;
 I $P($$ACTIVE^XUSER(DUZ),"^")'=1 D
 . D BMES("You are not a valid user on this system")
 . S XPDQUIT=2
 Q
 ;
 ;
EXIT ;
 ;
 ;
 I $G(XPDQUIT) D BMES("--- Install Environment Check FAILED ---") Q
 D BMES("--- Environment Check is Ok ---")
 ;
 Q
 ;
 ;
PRE ;Pre-install entry point
 ;
 ; No action needed in pre-install
 D BMES("No action need for pre-install")
 ;
 Q
 ;
 ;
POST ;Post install
 ;
 ; Check for RPMS system with V LAB file.
 ;
 I $$VFILE^DILFD(9000010.09)'=1 Q
 ;
 S %=$$NEWCP^XPDUTL("RPMS1","POST1^C0CENV")
 S %=$$NEWCP^XPDUTL("RPMS2","POST2^C0CENV")
 S %=$$NEWCP^XPDUTL("RPMS3","POST3^C0CENV")
 S %=$$NEWCP^XPDUTL("RPMS4","POST4^C0CENV")
 S %=$$NEWCP^XPDUTL("RPMS5","POST5^C0CENV")
 S %=$$NEWCP^XPDUTL("RPMS6","POST6^C0CENV")
 S %=$$NEWCP^XPDUTL("RPMS7","POST7^C0CENV")
 ;
 Q
 ;
 ;
POST1 ; Checkpoint call back entry point.
 ; Add new style ALR1 cross-reference to V LAB file.
 ;
 N MSG
 S MSG="Starting installation of ALR1 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR1^C0CLA7DD
 S MSG="Installation of ALR1 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 Q
 ;
 ;
POST2 ; Checkpoint call back entry point.
 ; Add new style ALR2 cross-reference to V LAB file.
 ;
 N MSG
 S MSG="Starting installation of ALR2 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR2^C0CLA7DD
 S MSG="Installation of ALR2 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 Q
 ;
 ;
POST3 ; Checkpoint call back entry point.
 ; Add new style ALR3 cross-reference to V LAB file.
 ;
 N MSG
 S MSG="Starting installation of ALR3 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR3^C0CLA7DD
 S MSG="Installation of ALR3 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 Q
 ;
 ;
POST4 ; Checkpoint call back entry point.
 ; Add new style ALR4 cross-reference to V LAB file.
 ;
 N MSG
 S MSG="Starting installation of ALR4 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR4^C0CLA7DD
 S MSG="Installation of ALR4 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 Q
 ;
 ;
POST5 ; Checkpoint call back entry point.
 ; Add new style ALR5 cross-reference to V LAB file.
 ;
 N MSG
 S MSG="Starting installation of ALR5 cross-reference at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 D ALR5^C0CLA7DD
 S MSG="Installation of ALR5 cross-reference completed at "_$$HTE^XLFDT($H,"1Z")
 D BMES(MSG)
 Q
 ;
 ;
POST6 ; Checkpoint call back entry point.
 ; Check for RPMS system and determine LAB patch level
 ;  and need to load in C0C version of LA7 routines.
 ;
 N MSG
 ;
 ; Load and rename C0CQRY2 to LA7QRY2 if LA*5.2*69 not installed
 I '$$PATCH^XPDUTL("LA*5.2*69") D
 . S MSG="This system missing LAB patch LA*5.2*69"
 . D BMES(MSG)
 . S MSG="Renaming routine C0CQRY2 to LA7QRY2"
 . D BMES(MSG)
 . D LOAD("C0CQRY2")
 . D SAVE("C0CQRY2","LA7QRY2")
 ;
 ; Load and rename C0CVOBX1 to LA7VOBX1 if LA*5.2*64 not installed.
 I '$$PATCH^XPDUTL("LA*5.2*64") D
 . S MSG="This system missing LAB patch LA*5.2*64"
 . D BMES(MSG)
 . S MSG="Renaming routine C0CVOBX1 to LA7VOBX1"
 . D BMES(MSG)
 . D LOAD("C0CVOBX1")
 . D SAVE("C0CVOBX1","LA7VOBX1")
 ;
 ; Load and rename C0CQRY1 to LA7QRY1 if LA*5.2*68 not installed.
 I '$$PATCH^XPDUTL("LA*5.2*68") D
 . S MSG="This system missing LAB patch LA*5.2*68"
 . D BMES(MSG)
 . S MSG="Renaming routine C0CQRY1 to LA7QRY1"
 . D BMES(MSG)
 . D LOAD("C0CQRY1")
 . D SAVE("C0CQRY1","LA7QRY1")
 ;
 Q
 ;
 ;
POST7 ; Checkpoint call back entry point.
 ;
 D REINDEX^C0CLA7DD
 ;
 Q
 ;
 ;
BMES(STR) ; Write BMES^XPDUTL statements
 ;
 D BMES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 ;
 Q
 ;
 ;
LOAD(X) ; load routine X
 N %N,DIF,XCNP
 K ^TMP($J,X)
 S DIF="^TMP($J,X,",XCNP=0
 X ^%ZOSF("LOAD")
 Q
 ;
 ;
SAVE(OLD,NEW) ; restore routine X
 N %,DIE,X,XCM,XCN,XCS
 S DIE="^TMP($J,"""_OLD_""",",XCN=0,X=NEW
 X ^%ZOSF("SAVE")
 Q
