RCY159PO ;MAF/ALB - POST-INIT FOR PATCH PRCA*159 AR/RCI ;FEB 19,2004
 ;;4.5;Accounts Receivable;**159**;Mar 20, 1995
 D BMES^XPDUTL("This Post-Installation populates new fields (34) RC MAIL ADDRESS and ")
 D MES^XPDUTL("(35) RC DEATH NOTIFICATION ADDRESS in file 349.1 AR TRANSMISSIONS TYPE")
 D MES^XPDUTL("with the new Regional Counsel Mail Address and Death Notification addresses.")
 I $D(^RCT(349.1,"B","RC")) S RCIFN=$O(^RCT(349.1,"B","RC",0)) I RCIFN]"",$D(^RCT(349.1,RCIFN,6,0)),$O(^RCT(349.1,RCIFN,6,0)) D
 .D BMES^XPDUTL("If sites are currently testing the software for patch IB*2.0*159 and have")
 .D MES^XPDUTL("information in the new DIVISION OF CARE field (61), this information will be")
 .D MES^XPDUTL("updated with the new RC mail address and death notification address that")
 .D MES^XPDUTL("corresponds with the division.")
 .D BMES^XPDUTL("New fields (.03) RC MAIL ADDRESS and (.04) RC DEATH NOTIFICATION ADDRESS")
 .D MES^XPDUTL("are updated in the DIVISION OF CARE multiple in file 349.1")
 ;
ARRAY ;This will update two new fields in file 349.1:
 ;field RC MAIL ADDRESS #34
 ;field RC DEATH NOTIFICATION ADDRESS #35
 ;with the new Regional Counsel addresses
 ;D BMES^XPDUTL("...Updating field (34) RC MAIL ADDRESS ")
 ;D MES^XPDUTL("...Updating field (35) RC DEATH NOTIFICATIONS ADDRESS for file 349.1 ")
 K ADDR
 N ADDR,RCCT,RCSITE,RCRC,RCDOM,RCDETH,RCNEW,RCIFN,RCNODE,X
 ;
 ; find the primary RC mail address from file 349.1 field 33
 I $D(^RCT(349.1,"B","RC")) S RCIFN=$O(^RCT(349.1,"B","RC",0)) I RCIFN]"" D
 .S RCDOM=$P($G(^RCT(349.1,RCIFN,3)),"^",3)
 .Q
 I $G(RCDOM)="" D  G EXIT
 .D BMES^XPDUTL("...There is no primary REMOTE DOMAIN.") D BMES^XPDUTL("...Please update field (32) REMOTE DOMAIN in AR TRANSMISSION TYPE file (349.1)") D MES^XPDUTL("   for the Regional Counsel (RC) type of transmission.")
 .D BMES^XPDUTL("...After file update, run 'Restart Install of Package(s) under the Installation")
 .D MES^XPDUTL("   option of the Kernel Installation and Distributions System.") S XPDABORT=1
 .Q
 D BMES^XPDUTL("...Updating field (34) RC MAIL ADDRESS ")
 D MES^XPDUTL("...Updating field (35) RC DEATH NOTIFICATIONS ADDRESS for file 349.1 ")
 D SETARR
 I $D(ADDR(RCDOM)) D
 .S RCNODE=ADDR(RCDOM),RCNEW=$P(RCNODE,"^",2),RCDETH=$P(RCNODE,"^",4)
 .S DIE="^RCT(349.1,",DA=RCIFN,DR="34////^S X="""_RCNEW_""""_";35////^S X="""_RCDETH_""""
 .D ^DIE K DIE,DA,DR
 D BMES^XPDUTL("...Fields 34 and 35 have been updated for the primary site.")
 ;I $D(^RCT(349.1,RCIFN,6,0)) D
 I $D(^RCT(349.1,RCIFN,6,0)),$O(^RCT(349.1,RCIFN,6,0)) D
 .D BMES^XPDUTL("...Updating DIVISION OF CARE MULTIPLE fields:") D MES^XPDUTL("   (.03) RC MAIL ADDRESS and (.04) RC DEATH NOTIFICATION ADDRESS")
 .N RCNEW,RCNODE,RCDETH,RCDIVC,RCDVADD,RCDVIFN,X,RCDVSION
 .S RCDVIFN=0
 .F RCDIVC=0:0 S RCDVIFN=$O(^RCT(349.1,RCIFN,6,RCDVIFN)) Q:'RCDVIFN  S RCDVADD=$P($G(^RCT(349.1,RCIFN,6,RCDVIFN,0)),"^",2) I RCDVADD]"" D
 ..S RCDOM=$P($G(^DIC(4.2,RCDVADD,0)),"^",1)
 ..S RCDVSION=$P($G(^RCT(349.1,RCIFN,6,RCDVIFN,0)),"^",1)
 ..I RCDOM]""&($D(ADDR(RCDOM))) S RCNODE=ADDR(RCDOM),RCNEW=$P(ADDR(RCDOM),"^",2),RCDETH=$P(ADDR(RCDOM),"^",4)
 ..S DIE="^RCT(349.1,"_RCIFN_",6,",DA(1)=RCIFN,DA=RCDVIFN,DR=".03////^S X="""_RCNEW_""""_";.04////^S X="""_RCDETH_""""
 ..;S DIE="^RCT(349.1,",DA=RCDVIFN,DR="61",DR(2,349.161)=".03////^S X="""_RCNEW_""""_";.04////^S X="""_RCDETH_""""
 ..D ^DIE  K DIE,DA,DA(1),DR
 ..D BMES^XPDUTL("...Fields (.03) and (.04) have been updated for "_$P($G(^DG(40.8,RCDVSION,0)),U,1))
 D BMES^XPDUTL("Post-Installation Updates Complete.")
 Q
SETARR ;Set up the ADDR array with all of the addresses and information
 F RCCT=1:1 S RCSITE=$P($T(ADDR+RCCT),";;",2) Q:RCSITE="END"  S ADDR($P(RCSITE,"^",1))=RCSITE
 Q
EXIT ;EXIT
 Q
 Q
 ;Regional Counsel Addresses old and new
 ;piece 1 old address to RC
 ;piece 2 new RC address
 ;piece 3 old RC death notification address
 ;piece 4 new RC death notification address
ADDR ;
 ;;RC-BOSTON.GC.VA.GOV^OGCBOSRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-BOSTON.GC.VA.GOV^OGCRegion1DeathNotification@mail.va.gov
 ;;RC-NEWYORK.GC.VA.GOV^OGCNYNRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-NEWYORK.GC.VA.GOV^OGCRegion2DeathNotification@mail.va.gov
 ;;RC-BALTIMORE.GC.VA.GOV^OGCBALRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-BALTIMORE.GC.VA.GOV^OGCRegion3DeathNotification@mail.va.gov
 ;;RC-PHILADELP.GC.VA.GOV^OGCPHIRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-PHILADELP.GC.VA.GOV^OGCRegion4DeathNotification@mail.va.gov
 ;;RC-ATLANTA.GC.VA.GOV^OGCATLRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-ATLANTA.GC.VA.GOV^OGCRegion5DeathNotification@mail.va.gov
 ;;RC-BAY-PINES.GC.VA.GOV^OGCBAYRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-BAY-PINES.GC.VA.GOV^OGCRegion6DeathNotification@mail.va.gov
 ;;RC-CLEVELAND.GC.VA.GOV^OGCCLERI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-CLEVELAND.GC.VA.GOV^OGCRegion7DeathNotification@mail.va.gov
 ;;RC-NASHVILLE.GC.VA.GOV^OGCNASRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-NASHVILLE.GC.VA.GOV^OGCRegion8DeathNotification@mail.va.gov
 ;;RC-JACKSON.GC.VA.GOV^OGCJACRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-JACKSON.GC.VA.GOV^OGCRegion9DeathNotification@mail.va.gov
 ;;RC-CHICAGO.GC.VA.GOV^OGCCHIRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-CHICAGO.GC.VA.GOV^OGCRegion10DeathNotification@mail.va.gov
 ;;RC-DETROIT.GC.VA.GOV^OGCDETRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-DETROIT.GC.VA.GOV^OGCRegion11DeathNotification@mail.va.gov
 ;;RC-STLOUIS.GC.VA.GOV^OGCSTLRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-STLOUIS.GC.VA.GOV^OGCRegion12DeathNotification@mail.va.gov
 ;;RC-WACO.GC.VA.GOV^OGCWACRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-WACO.GC.VA.GOV^OGCRegion13DeathNotification@mail.va.gov
 ;;RC-HOUSTON.GC.VA.GOV^OGCHOURI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-HOUSTON.GC.VA.GOV^OGCRegion14DeathNotification@mail.va.gov
 ;;RC-MINNEAPO.GC.VA.GOV^OGCMINRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-MINNEAPO.GC.VA.GOV^OGCRegion15DeathNotification@mail.va.gov
 ;;RC-DENVER.GC.VA.GOV^OGCDENRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-DENVER.GC.VA.GOV^OGCRegion16DeathNotification@mail.va.gov
 ;;RC-LOSANG.GC.VA.GOV^OGCLOSRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-LOSANG.GC.VA.GOV^OGCRegion17DeathNotification@mail.va.gov
 ;;RC-SANFRAN.GC.VA.GOV^OGCSFCRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-SANFRAN.GC.VA.GOV^OGCRegion18DeathNotification@mail.va.gov
 ;;RC-PHOENIX.GC.VA.GOV^OGCPHORI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-PHOENIX.GC.VA.GOV^OGCRegion19DeathNotification@mail.va.gov
 ;;RC-PORTLAND.GC.VA.GOV^OGCPORRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-PORTLAND.GC.VA.GOV^OGCRegion20DeathNotification@mail.va.gov
 ;;RC-BUFFALO.GC.VA.GOV^OGCBUFRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-BUFFALO.GC.VA.GOV^OGCRegion21DeathNotification@mail.va.gov
 ;;RC-INDIANAPO.GC.VA.GOV^OGCINDRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-INDIANAPO.GC.VA.GOV^OGCRegion22DeathNotification@mail.va.gov
 ;;RC-WINSTON.GC.VA.GOV^OGCWINRI@MAIL.VA.GOV^G.RC RC REFERRALS@RC-WINSTON.GC.VA.GOV^OGCRegion23DeathNotification@mail.va.gov
 ;;END
