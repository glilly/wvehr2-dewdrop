DG53637P ;ALB/PHH - 2005 MEANS TEST THRESHOLDS ;12/6/2004
 ;;5.3;Registration;**637**;Aug 13, 1993
 ;
 ; This routine will upload the 2005 means test thresholds onto your
 ; system.
 ;
EN N DA,DIE,DIC,DINUM,DR,I,X,Y,EXST
 S EXST=0
 D BMES^XPDUTL(">>>Means Test Thresholds for 2005 being installed...")
 I $D(^DG(43,1,"MT",3050000)) D
 .D BMES^XPDUTL(" ...Entry exists for income year 2004, entry being deleted")
 .D MES^XPDUTL("     and replaced with nationally released thresholds.")
 .S DIK="^DG(43,1,""MT"",",DA=3050000,DA(1)=1
 .D ^DIK,IX1^DIK
 .K DA,D0,DIK
 K DO
 S DIC="^DG(43,1,""MT"","
 S DIC(0)="L"
 S DA(1)=1
 S (DINUM,X)=3050000
 D FILE^DICN
 S DA=+Y
 ;
 I +Y'=3050000 D  Q
 . D BMES^XPDUTL("   ...Problem encountered adding 2005 thresholds.  Please try")
 . D MES^XPDUTL("      again or contact the CIO Field Office for assistance.")
 ;
 D MES^XPDUTL("")
 S DIE=DIC,DR=""
 F I=1:1 S X=$P($T(DATA+I),";;",2) Q:X="QUIT"  D   ; build dr string
 . S DR=DR_+X_"////"_$P(X,"^",2)_";"
 . D MES^XPDUTL("   "_$P(X,"^",3)_" set to $"_$FN($P(X,"^",2),","))
 D ^DIE
 Q
 ;
 ;
DATA ; lines to stuff in values (field////value)
 ;;2^25842^MT COPAY EXEMPT VET INCOME
 ;;3^5171^MT COPAY EXEMPT 1ST DEP INCOME
 ;;4^1734^MT COPAY EXEMPT INCOME PER DEP
 ;;8^80000^THRESHOLD PROPERTY
 ;;17^8200^CHILD INCOME EXCLUSION
 ;;QUIT
 Q
