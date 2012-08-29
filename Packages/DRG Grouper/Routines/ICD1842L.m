ICD1842L  ; ALB/MJB - NEW DIAGNOSIS CODES; 7/27/05 14:50;
 ;;18.0;DRG Grouper;**42**;Oct 13,2000;Build 16
 ;
 Q
 ;
ADDID ;HD308046 
 ; update diagnosis with identifier for delivery
 ;
 N SDA,ICDFLG
 N SDA
 S SDA(1)="",SDA(2)=" Adding IDENTIFIER FOR DIAGNOSIS IN "
 S SDA(3)="  ICD DIAGNOSIS file (# 80)for code 659.71"  D ATADDQ
 ;
 N LINE,X,ICDDIAG,ENTRY,IDENT,DA,DIE,DR,DUPE,ID
 F LINE=1:1 S X=$T(DXID+LINE) S ICDDIAG=$P(X,";;",2) Q:ICDDIAG="EXIT"  D
 .S ENTRY=+$O(^ICD9("BA",$P(ICDDIAG,U)_" ",0)) I ENTRY D
 ..S ID=$P(ICDDIAG,U,2)
 ..; check for any dupe (there are some in MNTVBB)
 ..S DUPE=+$O(^ICD9("BA",$P(ICDDIAG,U)_" ",ENTRY)) I DUPE D ICDADDQ Q
 ..S IDENT=$P($G(^ICD9(ENTRY,0)),U,2)
 ..; check if already done in case patch is being re-installed
 ..I IDENT[ID D ICDADDQ Q
 ..S IDENT=IDENT_ID
 ..S DA=ENTRY,DIE="^ICD9("
 ..S DR="2///^S X=IDENT"
 ..D ^DIE
 ..N SDA
 ..S SDA(1)="",SDA(2)="    CODE ADDED.....",SDA(3)="" D ATADDQ
 Q
DXID ;
 ;;659.71^D
 ;;585.6^H
 ;;EXIT
 ;;
ICDADDQ ;
 N SDA
 S SDA(1)="",SDA(2)=" DUPLICATE CODE - CODE NOT ADDED" D ATADDQ
ATADDQ ;
 D MES^XPDUTL(.SDA) K SDA
 Q
 ;
