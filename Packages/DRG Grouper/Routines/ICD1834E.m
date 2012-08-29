ICD1834E ;;ALB/EG/MJB - FY 2009 UPDATE; 6/19/05 4:08pm ; 6/24/05 3:29pm
 ;;18.0;DRG Grouper;**34**;Oct 13,2000;Build 4
 ;
 Q
 ;
PRO ;-update operation/procedure codes
 ; from Table 6B in Fed Reg - assumes new codes already added by Lexicon
 D BMES^XPDUTL(">>>Modifying new op/pro codes - file 80.1")
 N LINE,X,ICDPROC,ENTRY,DA,DIE,DR,IDENT,MDC24,SUBLINE,DATA,FDA
 F LINE=1:1 S X=$T(REV+LINE) S ICDPROC=$P(X,";;",2) Q:ICDPROC="EXIT"  D
 .Q:ICDPROC["+"
 .; check if already created in case patch being re-installed
 .S ENTRY=+$O(^ICD0("BA",$P(ICDPROC,U)_" ",0))
 .I $D(^ICD0(ENTRY,2,"B",3071001)) D
 ..;kill existing entry for FY
 .. S DA(1)=ENTRY,DA=$O(^ICD0(ENTRY,2,"B",3071001,0))
 .. S DIK="^ICD0("_DA(1)_",2," D ^DIK K DIK,DA
 .I ENTRY D
 ..;check for possible inactive dupe
 ..I $P($G(^ICD0(ENTRY,0)),U,9)=1 S ENTRY=+$O(^ICD0("BA",$P(ICDPROC,U)_" ",ENTRY)) I 'ENTRY Q
 ..S DA=ENTRY,DIE="^ICD0("
 ..S IDENT=$P(ICDPROC,U,2)
 ..S MDC24=$P(ICDPROC,U,3)
 ..S DR="2///^S X=IDENT;5///^S X=MDC24"
 ..;I IDENT=""&(MDC24="") Q
 ..D ^DIE
 ..;add 80.171, 80.1711 and 80.17111 records
 ..F SUBLINE=1:1 S X=$T(REV+LINE+SUBLINE) S DATA=$P(X,";;",2) Q:DATA'["+"  D
 ...I SUBLINE=1 D
 ....S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ....S FDA(1820,80.171,"+2,?1,",.01)=3071001
 ....D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S DATA=$E(DATA,2,99)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3071001
 ...S FDA(1820,80.1711,"+3,?2,?1,",.01)=$P(DATA,U)
 ...D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3071001
 ...S FDA(1820,80.1711,"?3,?2,?1,",.01)=$P(DATA,U)
 ...S FDA(1820,80.17111,"+4,?3,?2,?1,",.01)=$P(DATA,U,2)
 ...I $P(DATA,U,3) S FDA(1820,80.17111,"+5,?3,?2,?1,",.01)=$P(DATA,U,3)
 ...I $P(DATA,U,4) S FDA(1820,80.17111,"+6,?3,?2,?1,",.01)=$P(DATA,U,4)
 ...I $P(DATA,U,5) S FDA(1820,80.17111,"+7,?3,?2,?1,",.01)=$P(DATA,U,5)
 ...I $P(DATA,U,6) S FDA(1820,80.17111,"+8,?3,?2,?1,",.01)=$P(DATA,U,6)
 ...I $P(DATA,U,7) S FDA(1820,80.17111,"+9,?3,?2,?1,",.01)=$P(DATA,U,7)
 ...I $P(DATA,U,8) S FDA(1820,80.17111,"+10,?3,?2,?1,",.01)=$P(DATA,U,8)
 ...I $P(DATA,U,9) S FDA(1820,80.17111,"+11,?3,?2,?1,",.01)=$P(DATA,U,9)
 ...D UPDATE^DIE("","FDA(1820)") K FDA(1820)
ID ;
 ; Modify Identifier field (#2) in file 80.1 - 
 N LINE,X,ICDPROC,ENTRY,DA,DIE,DR,IDENT,DIC
 F LINE=1:1 S X=$T(REVID+LINE) S ICDPROC=$P(X,";;",2) Q:ICDPROC="EXIT"  D
 .S ENTRY=+$O(^ICD0("BA",$P(ICDPROC,U)_" ",0)) I ENTRY D
 ..S DA=ENTRY,DIE="^ICD0("
 ..S IDENT=$P(ICDPROC,U,2)
 ..S DR="2///^S X=IDENT"
 ..D ^DIE
 Q
 ; 
REV ;
 ;;39.52^OQK7
 ;;+1^23^24^25^26^27^31^32^33
 ;;+5^237^238
 ;;EXIT
 ;
REVID ; update identifier for procedure codes
 ;;37.83^o
 ;;37.72^oV
 ;;EXIT
