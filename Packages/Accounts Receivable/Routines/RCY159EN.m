RCY159EN ;MAF/ALB - ENVIRONMENT CHECK FOR PATCH PRCA*159 AR/RCI ;APR 2,2004
 ;;4.5;Accounts Receivable;**159**;Mar 20, 1995
 D BMES^XPDUTL("This Environment check checks to see if field (32) REMOTE DOMAIN ")
 D MES^XPDUTL("in file (349.1) AR TRANSMISSIONS TYPE is populated.")
 D MES^XPDUTL("This field must be populated to complete the install.")
 D MES^XPDUTL("")
 D BMES^XPDUTL("...Checking Regional Counsel REMOTE DOMAIN field 32.")
 ; find the primary RC mail address from file 349.1 field 33
 N RCDOM,RCIFN,RCFLAG
 S RCFLAG=0
 ;I $D(^RCT(349.1,"B","RC")) S RCIFN=$O(^RCT(349.1,"B","RC",0)) I RCIFN]"" D  Q:RCFLAG
 I $D(^RCT(349.1,"B","RC")) S RCIFN=$O(^RCT(349.1,"B","RC",0)) I RCIFN]"" D
 .S RCDOM=$P($G(^RCT(349.1,RCIFN,3)),"^",3)
 .I RCDOM]""&($E(RCDOM,1,3)="RC-") D BMES^XPDUTL("...REMOTE DOMAIN populated... ") Q
 .I RCDOM]"" D MES1
 .I RCDOM="" D BMES^XPDUTL("...There is no Regional Counsel REMOTE DOMAIN entry.") D
 ..D BMES^XPDUTL("...Please update field (32) REMOTE DOMAIN in AR TRANSMISSION TYPE file (349.1)") D MES^XPDUTL("   for the Regional Counsel (RC) type of transmission.")
 .D MES
 .Q
 ;CHECKING THE DIVISION OF CARE FIELD (61) SUBFIELD (.02) REMOTE DOMAIN
 I $D(^RCT(349.1,RCIFN,6,0)),$O(^RCT(349.1,RCIFN,6,0)) D
 .D BMES^XPDUTL(" ") D BMES^XPDUTL("Checking field (61) DIVISION OF CARE subfield (.02) REMOTE DOMAIN") D MES^XPDUTL("This field must be populated to complete the install")
 .N RCNEW,RCNODE,RCDETH,RCDIVC,RCDVADD,RCDVIFN,X
 .S RCDVIFN=0,RCFLAG=0
 .F RCDIVC=0:0 S RCDVIFN=$O(^RCT(349.1,RCIFN,6,RCDVIFN)) Q:'RCDVIFN!(RCFLAG)  S RCDVADD=$P($G(^RCT(349.1,RCIFN,6,RCDVIFN,0)),"^",2) D
 ..I $G(RCDVADD)="" D BMES^XPDUTL("...Check/update subfield (.02) REMOTE DOMAIN in field (61) DIVISION OF CARE") D  Q
 ...D MES^XPDUTL("   in file 349.1 AR TRANSMISSION TYPE for all your divisions of care...") D BMES^XPDUTL(" ") D MES^XPDUTL("***The REMOTE DOMAIN must be populated with an address that starts with 'RC-'") D MES
 ..I $G(RCDVADD)]""&($E($P($G(^DIC(4.2,RCDVADD,0)),U,1),1,3)="RC-") Q
 ..I $G(RCDVADD)]"" D MES1,MES
 I 'RCFLAG D BMES^XPDUTL(" Environment Check completed successfully... ")
 Q
MES ;D BMES^XPDUTL("...After file update, run 'Restart Install of Package(s)' under the Installation")
 ;D MES^XPDUTL("   option of the Kernel Installation and Distributions System.") S XPDABORT=1,RCFLAG=1
 D MES^XPDUTL("   Use option RC PARAMETERS EDIT  [PRCA RC PARAMETERS] to update this field.")
 S XPDABORT=1,RCFLAG=1
 Q
MES1 D BMES^XPDUTL("...The REMOTE DOMAIN field is incorrectly populated and will not be properly") D MES^XPDUTL("   converted to the new Regional Counsel mail address.")
 D BMES^XPDUTL("***The REMOTE DOMAIN must be populated with an address that starts with 'RC-'")
 Q
