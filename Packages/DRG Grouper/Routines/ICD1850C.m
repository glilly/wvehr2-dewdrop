ICD1850C ;ALB/MJB - YEARLY DRG UPDATE;8/9/2010
 ;;18.0;DRG Grouper;**50**;Oct 13, 2000;Build 8
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
 .I $D(^ICD0(ENTRY,2,"B",3101001)) D
 ..;kill existing entry for FY
 .. S DA(1)=ENTRY,DA=$O(^ICD0(ENTRY,2,"B",3101001,0))
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
 ....S FDA(1820,80.171,"+2,?1,",.01)=3101001
 ....D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S DATA=$E(DATA,2,99)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3101001
 ...S FDA(1820,80.1711,"+3,?2,?1,",.01)=$P(DATA,U)
 ...D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ...S FDA(1820,80.1,"?1,",.01)="`"_ENTRY
 ...S FDA(1820,80.171,"?2,?1,",.01)=3101001
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
 ;;00.60^N^
 ;;01.20^O^
 ;;+1^23^24^40^41^42
 ;;01.29^O^
 ;;+1^40^41^42
 ;;17.71^N^
 ;;32.27^O^
 ;;+4^163^164^165
 ;;35.97^OP1^
 ;;+5^231^232^246^247^248^249^250^251
 ;;37.37^O^
 ;;+5^228^229^230
 ;;38.97^NH^
 ;;39.81^O
 ;;+5^252^253^254
 ;;39.82^O^
 ;;+5^252^253^254
 ;;39.83^O^
 ;;+5^252^253^254
 ;;39.84^O^
 ;;+5^252^253^254
 ;;39.85^O^
 ;;+5^252^253^254
 ;;39.86^O^
 ;;+5^252^253^254
 ;;39.87^O^
 ;;+5^252^253^254
 ;;39.88^O^
 ;;+5^252^253^254
 ;;39.89^O^
 ;;+5^252^253^254
 ;;81.88^O^
 ;;+8^483^484
 ;;+21^907^908^909
 ;;+24^957^958^959
 ;;84.94^O^
 ;;+4^166^167^168
 ;;+5^264
 ;;+8^515^516^517
 ;;+21^907^908^909
 ;;+24^957^958^959
 ;;85.55^OkM^
 ;;+9^584^585
 ;;86.87^Ok^
 ;;+3^133^134
 ;;+9^579^580^581
 ;;+10^619^620^621
 ;;+21^907^908^909
 ;;+24^957^958^959
 ;;86.90^Ok^
 ;;+9^579^580^581
 ;;41.00^OB^
 ;;+98^15
 ;;41.01^OB^
 ;;+98^15
 ;;41.04^OB^
 ;;+98^15
 ;;41.07^OB^
 ;;+98^15
 ;;41.09^OB^
 ;;+98^15
 ;;41.02^OB^
 ;;+98^14
 ;;41.03^OB^
 ;;+98^14
 ;;41.05^OB^
 ;;+98^14
 ;;41.06^OB^
 ;;+98^14
 ;;41.08^OB^
 ;;+98^14
 ;;EXIT
