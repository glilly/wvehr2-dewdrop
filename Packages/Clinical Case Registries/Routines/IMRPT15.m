IMRPT15 ;FAI/HCIOFO - PATCH 15 PRE & POST INIT ROUTINE ; 02/20/02 06:17
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**15**;Feb 09, 1998;
PRE ; KIDS Pre install for IMR*2.1*15
 ;
 N XQA,XQAMSG
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR(">>Checking status of Nightly Extract<<",80))
 D OPT
 S ZTSK=ITSK D DQ^%ZTLOAD
 D:ZTSK(0)=1 BMES^XPDUTL($$CJ^XLFSTR("** Unscheduling IMR REGISTRY DATA Task **",80))
 S MSG="Disabling Extract Data for Immunology Study Registry [IMR REGISTRY DATA] option"
 D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 Q
OPT S IMRO=""
 F  S IMRO=$O(^DIC(19,"B","IMR REGISTRY DATA",IMRO)) Q:IMRO=""  D DISO,CHK
 Q
DISO S $P(^DIC(19,IMRO,0),"^",3)="**Out of Order for Patch 15 Install**"
 Q
CHK S IOPT=""
 F  S IOPT=$O(^DIC(19.2,"B",IMRO,IOPT)) Q:IOPT=""  S ITSK=$P($G(^DIC(19.2,IOPT,1)),"^",1)
 Q
 ;
POST ; KIDS Post install for IMR*2.1*15
 ;
FOP S IMRO=""
 F  S IMRO=$O(^DIC(19,"B","IMR REGISTRY DATA",IMRO)) Q:IMRO=""  D ENAO
 Q
ENAO S $P(^DIC(19,IMRO,0),"^",3)=""
 Q
