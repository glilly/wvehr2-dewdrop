ICD1850O ;ALB/MJB - YEARLY DRG UPDATE;8/9/2010
 ;;18.0;DRG Grouper;**50**;Oct 13, 2000;Build 8
 ;
 ; Inactivating DRG(s) - will add an entry for fiscal year
 ; DRG is being inactivated with an inactive status.
 Q
 ;
INACTDRG ;
 N LINE,X,ICDDRG,DESC,DA,DIE,DR,MDC,SURG,ICDFDA
 D BMES^XPDUTL(">>> Inactivating DRG(s)...")
 F LINE=1:1 S X=$T(INAC+LINE) S ICDDRG=$P(X,";;",2) Q:ICDDRG="EXIT"  D
 .S DESC="NO LONGER VALID"
 .S DA(1)=$P(ICDDRG,U)
 .S DA=1
 .S DIE="^ICD("_DA(1)_",1,"
 .S DR=".01///^S X=DESC"
 .D ^DIE
 .; check if already done in case patch being re-installed
 .Q:$D(^ICD($P(ICDDRG,U),66,"B",3101001))
 .; add entry to 80.266
 .S MDC=$P(ICDDRG,U,2)
 .S SURG=$P(ICDDRG,U,3)
 .S ICDDRG=$P(ICDDRG,U)
 .S ICDFDA(80.2,"?1,",.01)=ICDDRG
 .S ICDFDA(80.266,"+2,?1,",.01)=3101001
 .S ICDFDA(80.266,"+2,?1,",.03)=0
 .S ICDFDA(80.266,"+2,?1,",.05)=MDC
 .S ICDFDA(80.266,"+2,?1,",.06)=SURG
 .D UPDATE^DIE("","ICDFDA") K ICDFDA
 .; add entry to 80.268 and 80.2681
 .S ICDFDA(80.2,"?1,",.01)=ICDDRG
 .S ICDFDA(80.268,"+2,?1,",.01)=3101001
 .D UPDATE^DIE("","ICDFDA") K ICDFDA
 .S ICDFDA(80.2,"?1,",.01)=ICDDRG
 .S ICDFDA(80.268,"?2,?1,",.01)=3101001
 .S ICDFDA(80.2681,"+3,?2,?1,",.01)=DESC
 .D UPDATE^DIE("","ICDFDA") K ICDFDA
 Q
 ;
INAC ;DRG^MDC^SURG (1=surg, 0=med)
 ;;9^1^1
 ;;EXIT
