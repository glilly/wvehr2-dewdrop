ICD1845C ;;ALB/MJB - FY 2010 UPDATE; 6/19/05 4:08pm ; 11/14/07 5:25pm
 ;;18.0;DRG Grouper;**45**;Oct 13,2000;Build 14
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
 .I $D(^ICD0(ENTRY,2,"B",3091001)) D
 ..;kill existing entry for FY
 .. S DA(1)=ENTRY,DA=$O(^ICD0(ENTRY,2,"B",3091001,0))
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
 ....S FDA(1820,80.171,"+2,?1,",.01)=3091001
 ....D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S DATA=$E(DATA,2,99)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3091001
 ...S FDA(1820,80.1711,"+3,?2,?1,",.01)=$P(DATA,U)
 ...D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3091001
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
 Q
 ;
REV ; PROC/OP^IDENTIFIER^MDC^DRG
 ;;17.51^O^
 ;;+5^222^223^224^225^226^227
 ;;17.52^O^
 ;;+5^245
 ;;17.61^O^
 ;;+1^023^024^025^026^027
 ;;17.62^O^
 ;;+10^625^626^627
 ;;+17^820^821^822^826^827^828
 ;;17.63^O^
 ;;+6^356^357^358
 ;;+7^405^406^407
 ;;17.69^O^
 ;;+4^163^164^165
 ;;+9^584^585
 ;;+12^715^716^717^718
 ;;+17^820^821^822^826^827^828
 ;;17.70^N
 ;;33.73^N
 ;;38.24^N
 ;;38.25^N
 ;;39.75^O^
 ;;+1^020^021^022^023^024^025^026^027
 ;;+5^237^238
 ;;+11^673^674^675
 ;;+21^907^908^909
 ;;+24^957^958^959
 ;;39.76^O^
 ;;+1^020^021^022^023^024^025^026^027
 ;;+5^237^238
 ;;+11^673^674^675
 ;;+21^907^908^909
 ;;+24^957^958^959
 ;;46.86^N
 ;;46.87^N
 ;;EXIT
