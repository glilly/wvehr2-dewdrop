ICD1837L  ; ALB/JAT - NEW DIAGNOSIS CODES; 7/27/05 14:50;
 ;;18.0;DRG Grouper;**37**;Oct 13,2000;Build 20
 ;
 Q
DRG ;
 N FDA,DA,DIE,DR,MAJOR
 ;
 ; HD233286
 ; 
 ; next line in case patch being re-installed
 ;I $P(^ICD9(14197,3,1,1,0),U,4)=7 G NEXT
 ;S FDA(1820,80,"?1,",.01)="`14197"
 ;S FDA(1820,80.071,"?2,?1,",.01)=3071001
 ;S FDA(1820,80.711,"+3,?2,?1,",.01)=826
 ;S FDA(1820,80.711,"+4,?2,?1,",.01)=827
 ;S FDA(1820,80.711,"+5,?2,?1,",.01)=828
 ;S FDA(1820,80.711,"+6,?2,?1,",.01)=829
 ;S FDA(1820,80.711,"+7,?2,?1,",.01)=830
 ;D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ;S FDA(1820,80,"?1,",.01)="`14198"
 ;S FDA(1820,80.071,"?2,?1,",.01)=3071001
 ;S FDA(1820,80.711,"+3,?2,?1,",.01)=826
 ;S FDA(1820,80.711,"+4,?2,?1,",.01)=827
 ;S FDA(1820,80.711,"+5,?2,?1,",.01)=828
 ;S FDA(1820,80.711,"+6,?2,?1,",.01)=829
 ;S FDA(1820,80.711,"+7,?2,?1,",.01)=830
 ;D UPDATE^DIE("","FDA(1820)") K FDA(1820)
 ;
NEXT ;
 ; HD223286
 ; 
 ;S DA=3035
 ;S DIE="^ICD0("
 ;S MAJOR="B"
 ;S DR="20///^S X=MAJOR"
 ;D ^DIE
 ;
 ; HD241831
 ;K DIC,DA,X,ROUTINE
 ;S DA(1)=217
 ;S DIC="^ICD("_DA(1)_",2,"
 ;S DIC(0)="L"
 ;S ROUTINE="ICDTLB3C"
 ;S DIC("DR")="1///^S X=ROUTINE"
 ;S X=3061001
 ;K DO D FILE^DICN
 ;
ADDID ;HD275718 
 ; update diagnoses with new identifier for delivery
 ;
 N LINE,X,ICDDIAG,ENTRY,IDENT,DA,DIE,DR,DUPE
 F LINE=1:1 S X=$T(DXID+LINE) S ICDDIAG=$P(X,";;",2) Q:ICDDIAG="EXIT"  D
 .S ENTRY=+$O(^ICD9("BA",$P(ICDDIAG,U)_" ",0)) I ENTRY D
 ..; check for any dupe (there are some in MNTVBB)
 ..S DUPE=+$O(^ICD9("BA",$P(ICDDIAG,U)_" ",ENTRY)) I DUPE Q
 ..S IDENT=$P($G(^ICD9(ENTRY,0)),U,2)
 ..; check if already done in case patch is being re-installed
 ..I IDENT["D" Q
 ..S IDENT=IDENT_"D"
 ..S DA=ENTRY,DIE="^ICD9("
 ..S DR="2///^S X=IDENT"
 ..D ^DIE
 Q
DXID ;
 ;;645.11^D
 ;;EXIT
