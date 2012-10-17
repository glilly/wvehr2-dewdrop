FBXIP110        ;ALB/RC -FB*3.5*110 POST INSTALL ROUTINE ; 3/4/09 7:21pm
        ;;3.5;FEE BASIS;**110**;;Build 8
        Q
EN      ;post-install entry point
        ;create KIDS checkpoints with call backs
        N FBX,Y
        S FBX="POST" D
        .S Y=$$NEWCP^XPDUTL(FBX,FBX_"^FBXIP110")
        .I 'Y D BMES^XPDUTL("ERROR creating "_FBX_" checkpoint.")
        Q
POST    ;begin post-install
        D RVU
        D UPD
        Q
RVU     ;update RVUs for 67113
        N CPT,DA,DIE,DR
        S CPT="67113",DA="",DA(1)=""
        S DA(1)=$$FIND1^DIC(162.97,,"MX","67113")
        S DIE="^FB(162.97,"_DA(1)_",""CY"","
        S DA=$$FIND1^DIC(162.971,$$IENS^DILF(.DA),"MX","2008")
        S DR=".03///25.00;.04///13.75;.05///13.75"
        D ^DIE
        K CPT,DA,DIE,DR
        Q
UPD     ;update entries for POV 56,67,78,69
        D BMES^XPDUTL("Updating Place of Visit entries in the FEE BASIS PURPOSE OF VISIT file (#161.82)")
        N FBCNT,X,UPDENTRY,UPDNAME,UPDCODE,UPDPROG,POVCHECK
        F FBCNT=1:1  S UPDENTRY=$P($T(UPDTABLE+FBCNT),";;",2) Q:UPDENTRY="EXIT"  D
        .S UPDCODE=$P(UPDENTRY,"^",1),UPDNAME=$P(UPDENTRY,"^",2),UPDPROG=$P(UPDENTRY,"^",3)
        .S POVCHECK=$O(^FBAA(161.82,"C",UPDCODE,"")) D
        ..I 'POVCHECK D BMES^XPDUTL("POV "_UPDCODE_" not found, please verify this entry in the FEE BASIS PURPOSE of VISIT file (#161.82).") Q
        ..N DIE,DA,DR
        ..S DA=$$FIND1^DIC(161.82,,"MX",UPDCODE)
        ..S DIE="^FBAA(161.82,"
        ..S DR=".01///^S X=UPDNAME;2///^S X=UPDPROG"
        ..D ^DIE K DIE,DA,DR
        Q
UPDTABLE        ;updates to the POVS
        ;;56^DIALYSIS^OUTPATIENT
        ;;67^OUTPATIENT MATERNITY CARE SERVICES^OUTPATIENT
        ;;68^BOWEL AND BLADDER CARE: AGENCY^OUTPATIENT
        ;;69^BOWEL AND BLADDER CARE: FAMILY CAREGIVER^OUTPATIENT
        ;;EXIT
        ;FBXIP110
