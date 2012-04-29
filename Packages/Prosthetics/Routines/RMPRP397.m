RMPRP397 ;BAY/KAM-Patch RMPR*3*97 Install Utility Routine ;8/25/04 10:10am
 ;;3.0;Prosthetics;**97**;AUG 13, 1993
 ;
ENV ;Main Entry point for Environment Check
 S XPDABORT=""
 D PROGCHK(.XPDABORT) ;checks programmer variables
 I XPDABORT="" K XPDABORT
 Q
PROGCHK(XPDABORT) ; checks for necessary programmer variables
 ;
 I '$G(DUZ)!($G(DUZ(0))'="@")!('$G(DT))!($G(U)'="^")  D
 . D BMES^XPDUTL("****")
 . D MES^XPDUTL("Your programming variables are not set up properly.")
 . D MES^XPDUTL("Installation aborted.")
 . D MES^XPDUTL("*****")
 . S XPDABORT=2
 Q
