ICD1837D   ; ALB/MJB - FY 2009 UPDATE; 7/27/05 14:50;
 ;;18.0;DRG Grouper;**37**;Oct 13,2000;Build 20
 Q
 ;
DIAG ; - update diagnosis codes
 ;  
 D BMES^XPDUTL(">>>Modifying existing diagnosis codes - file 80")
 N LINE,X,ICDDIAG,ENTRY,DA,DIE,DR,IDENT,MDC,MDC25,FDA
 F LINE=1:1 S X=$T(REVD+LINE) S ICDDIAG=$P(X,";;",2) Q:ICDDIAG="EXIT"  D
 .S ENTRY=+$O(^ICD9("BA",$P(ICDDIAG,U)_" ",0))
 .I ENTRY D
    ..;check for possible inactive dupe
 ..I $P($G(^ICD9(ENTRY,0)),U,9)=1 S ENTRY=+$O(^ICD9("BA",$P(ICDDIAG,U)_" ",ENTRY)) I 'ENTRY Q 
 ..S DA=ENTRY,DIE="^ICD9("
 ..S IDENT=$P(ICDDIAG,U,2)
 ..S MDC=$P(ICDDIAG,U,3)
 ..;this would only apply to diagnoses who have no other MDC than a pre-MDC
 ..I MDC="PRE" S MDC=98
 ..S MDC25=$P(ICDDIAG,U,4)
 ..S MDC24=$P(ICDDIAG,U,5)
 ..S DR="2///^S X=IDENT;5///^S X=MDC;5.9///^S X=MDC25;5.7///^S X=MDC24"
 ..;S DR="2///^S X=IDENT;5///^S X=MDC;5.9///^S X=MDC25"
 ..D ^DIE
 ..;check if already created in case patch being re-installed
 ..Q:$D(^ICD9(ENTRY,3,"B",3081001))
 ..; add 80.071 and 80.711 and 80.072 records
 ..N FDA
 ..S FDA(1820,80,"?1,",.01)="`"_ENTRY
 ..S FDA(1820,80.071,"+2,?1,",.01)=3081001
 ..S FDA(1820,80.072,"+3,?1,",.01)=3081001
 ..S FDA(1820,80.072,"+3,?1,",1)=$P(ICDDIAG,U,3)
 ..D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ..S FDA(1820,80,"?1,",.01)="`"_ENTRY
 ..S FDA(1820,80.071,"?2,?1,",.01)=3081001
 ..S FDA(1820,80.711,"+3,?2,?1,",.01)=$P(ICDDIAG,U,6)
 ..;I $P(ICDDIAG,U,6) S FDA(1820,80.711,"+4,?2,?1,",.01)=$P(ICDDIAG,U,6)
 ..I $P(ICDDIAG,U,7) S FDA(1820,80.711,"+5,?2,?1,",.01)=$P(ICDDIAG,U,7)
 ..I $P(ICDDIAG,U,8) S FDA(1820,80.711,"+6,?2,?1,",.01)=$P(ICDDIAG,U,8)
 ..I $P(ICDDIAG,U,9) S FDA(1820,80.711,"+7,?2,?1,",.01)=$P(ICDDIAG,U,9)
 ..I $P(ICDDIAG,U,10) S FDA(1820,80.711,"+8,?2,?1,",.01)=$P(ICDDIAG,U,10)
 ..I $P(ICDDIAG,U,11) S FDA(1820,80.711,"+9,?2,?1,",.01)=$P(ICDDIAG,U,11)
 ..I $P(ICDDIAG,U,12) S FDA(1820,80.711,"+10,?2,?1,",.01)=$P(ICDDIAG,U,12)
 ..I $P(ICDDIAG,U,13) S FDA(1820,80.711,"+11,?2,?1,",.01)=$P(ICDDIAG,U,13)
 ..I $P(ICDDIAG,U,14) S FDA(1820,80.711,"+12,?2,?1,",.01)=$P(ICDDIAG,U,14)
 ..D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 Q
 ;
REVD ; DIAG^IDEN^MDC^MDC25^MDC24^MS-DRG
 ;;958.90^T^21^^^922^923^963^964^965
 ;;958.91^T^21^^7^922^923^963^964^965
 ;;958.92^T^21^^8^922^923^963^964^965
 ;;958.93^T^21^^3^922^923^963^964^965
 ;;958.99^T^21^^^922^923^963^964^965
 ;;EXIT
