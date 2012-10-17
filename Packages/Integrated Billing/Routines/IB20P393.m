IB20P393        ;ALB/CXW - UPDATE MCCR UTILITY/REVENUE CODE; 06/18/08
        ;;2.0;INTEGRATED BILLING;**393**;21-MAR-94;Build 4
POST    ;
        N U S U="^"
        D VAC,VACE,OSC,COC,COCE,RVC
        Q
        ;
VAC     ;New value codes in 399.1 (field .18/piece 11)
        N DLAYGO,DIC,DIE,DA,DD,DO,DR,X,Y,IBI,IBX
        D MES^XPDUTL("Adding Value Codes..")
        F IBI=1:1 S IBX=$P($T(VACF+IBI),";;",2) Q:IBX=""  I $E(IBX)'=" " D
        . I +$$EXCODE($P(IBX,U,1),11) Q
        . K DD,DO S DLAYGO=399.1,DIC="^DGCR(399.1,",DIC(0)="L",X=$P(IBX,U,2) D FILE^DICN K DIC,DLAYGO I Y<1 K X,Y Q
        . S DA=+Y,DIE="^DGCR(399.1,",DR=".02////"_$P(IBX,U,1)_";.18////1;.19////"_$P(IBX,U,3) D ^DIE K DIE,DA,DR,X,Y
        . D MES^XPDUTL(" Code# "_$P(IBX,U,1)_" - "_$P(IBX,U,2))
        Q
        ;
VACE    ;Old value codes
        N DIE,DA,DR,X,Y,IBI,IBX,IBFN
        D MES^XPDUTL("Updating Value Codes..")
        F IBI=1:1 S IBX=$P($T(VAOF+IBI),";;",2) Q:IBX=""  I $E(IBX)'=" " D
        . S IBFN=+$$EXCODE($P(IBX,U,1),11) Q:'IBFN
        . S DIE="^DGCR(399.1,",DA=IBFN,DR=".01////"_$P(IBX,U,2) D ^DIE K DIE,DA,DR,X,Y
        . D MES^XPDUTL(" Code# "_$P(IBX,U,1)_" - "_$P(IBX,U,2))
        D MES^XPDUTL("")
        Q
        ;
OSC     ;Occurrence span codes in 399.1 (field .17/piece 10)
        N DIE,DA,DR,X,Y,IBI,IBX,IBFN
        D MES^XPDUTL("Updating Occurrence Span Code..")
        F IBI=1:1 S IBX=$P($T(OSCF+IBI),";;",2) Q:IBX=""  I $E(IBX)'=" " D
        . S IBFN=+$$EXCODE($P(IBX,U,1),10) Q:'IBFN
        . S DIE="^DGCR(399.1,",DA=IBFN,DR=".01////"_$P(IBX,U,2) D ^DIE K DIE,DA,DR,X,Y
        . D MES^XPDUTL(" Code# "_$P(IBX,U,1)_" - "_$P(IBX,U,2))
        D MES^XPDUTL("")
        Q
        ;
COC     ;New condition codes in file 399.1 (field .22/piece 15)
        N DLAYGO,DIC,DIE,DA,DD,DO,DR,X,Y,IBI,IBX
        D MES^XPDUTL("Adding Condition Codes..")
        F IBI=1:1 S IBX=$P($T(CONF+IBI),";;",2) Q:IBX=""  I $E(IBX)'=" " D
        . I +$$EXCODE($P(IBX,U,1),15) Q
        . K DD,DO S DLAYGO=399.1,DIC="^DGCR(399.1,",DIC(0)="L",X=$P(IBX,U,2) D FILE^DICN K DIC,DLAYGO I Y<1 K X,Y Q
        . S DA=+Y,DIE="^DGCR(399.1,",DR=".02////"_$P(IBX,U,1)_";.22////"_1 D ^DIE K DIE,DA,DR,X,Y
        . D MES^XPDUTL(" Code# "_$P(IBX,U,1)_" - "_$P(IBX,U,2))
        Q
        ;
COCE    ;Old condition codes
        N DIE,DA,DR,X,Y,IBI,IBX,IBFN
        D MES^XPDUTL("Updating Condition Codes..")
        F IBI=1:1 S IBX=$P($T(COOF+IBI),";;",2) Q:IBX=""  I $E(IBX)'=" " D
        . S IBFN=+$$EXCODE($P(IBX,U,1),15) Q:'IBFN
        . S DIE="^DGCR(399.1,",DA=IBFN,DR=".01////"_$P(IBX,U,2) D ^DIE K DIE,DA,DR,X,Y
        . D MES^XPDUTL(" Code# "_$P(IBX,U,1)_" - "_$P(IBX,U,2))
        D MES^XPDUTL("")
        Q
        ;
EXCODE(X,P)     ;returns IEN if code found in the P piece
        N IBX,IBY S IBY=""
        I $G(X)'="" S IBX=0 F  S IBX=$O(^DGCR(399.1,"C",X,IBX)) Q:'IBX  I $P($G(^DGCR(399.1,IBX,0)),U,+$G(P)) S IBY=IBX
        Q IBY
        ;
RVC     ;New revenue codes in file 399.2
        N IBI,IBX,IBY,IBZ,DIE,DA,DR,X,Y
        D MES^XPDUTL("Adding Revenue Codes..")
        F IBI=1:1 S IBX=$P($T(RVCF+IBI),";;",2) Q:IBX=""  I $E(IBX)'=" " D 
        . S IBY=$P(IBX,U,1),IBZ=$G(^DGCR(399.2,+IBY,0)) Q:(+IBY'=+IBZ)!($P(IBZ,U,2)'="*RESERVED")
        . S DA=+IBY,DIE="^DGCR(399.2,",DR="1////"_$P(IBX,U,2)_";3////"_$P(IBX,U,3) D ^DIE K DA,DIE,DR,X,Y
        . D MES^XPDUTL(" Code# "_$P(IBX,U,1)_" - "_$P(IBX,U,3))
        D MES^XPDUTL("")
        Q
        ;
RVCF    ; - new revenue codes
        ;;343^DX/RADIOPHARMACEUTICALS^DIAGNOSTIC RADIOPHARMACEUTICALS
        ;;344^RX/RADIOPHARMACEUTICALS^THERAPEUTIC RADIOPHARMACEUTICALS
        ;;524^RHC/FQHC PRACTITIONER COVERED VISIT^RHC/FQHC PRACTITIONER COVERED VISIT AT SNF
        ;;525^RHC/FQHC PRACTITIONER NOT COVERED VISIT^RHC/FQHC PRACTITIONER NOT COVERED SNF/NF/RF VISIT
        ;;527^RHC/FQHC VISITING NURSE SVS^NURSE SVS TO MEMBER HOME IN SHORTAGE AREA VISIT
        ;;528^RHC/FQHC PRACTITIONER IN OTHER VISIT^NON RHC/FQHC SITE VISIT
        ;;583^ASSESSMENT^VISIT/HOME HLTH ASSESSMENT
        ;;658^NURSING FACILITY^HOSPICE ROOM & BOARD
        ;;663^DAILY RESPITE CHARGE^DAILY RESPITE CHARGE
        ;;680^TRAUMA RESPONSE^GENERAL CLASSIFICATION
        ;;681^TRA/RES LEVEL I^TRAUMA RESPONSE LEVEL I
        ;;682^TRA/RES LEVEL II^TRAUMA RESPONSE LEVEL II
        ;;683^TRA/RES LEVEL III^TRAUMA RESPONSE LEVEL III
        ;;684^TRA/RES LEVEL IV^TRAUMA RESPONSE LEVEL IV
        ;;689^TRA/RES OTHER^TRAUMA RESPONSE OTHER
        ;;905^INTENSIVE OPT SVS-PSYCH^INTENSIVE OUTPATIENT SVS PSYCHIATRIC
        ;;906^INTENSIVE OPT SVS-CHEM/DEP^INTENSIVE OUTPATIENT SVS CHEMICAL DEPENDENCY
        ;;907^DAY TREATMENT^COMM BEHAVIORAL PROGRAM
        ;;930^MRDP^MEDICAL REHABILITATION DAY PROGRAM
        ;;931^MRDP HALF DAY^MRDP HALF DAY
        ;;932^MRDP FULL DAY^MRDP FULL DAY
        ;
VACF    ; - new value codes
        ;;A8^PATIENT WEIGHT
        ;;A9^PATIENT HEIGHT
        ;;FC^PATIENT PAID AMOUNT^1
        ;;FD^CREDIT RECEVD FROM MANUFACTURER FOR REPLACED MEDICAL DEVICE^1
        ;
VAOF    ; - old value codes
        ;;37^UNITS OF BLOOD FURNISHED
        ;;38^BLOOD DEDUCTIBLE UNITS
        ;;39^UNITS OF BLOOD REPLACED
        ;
OSCF    ; - old occurrence span code
        ;;80^PRIOR SAME-SNF STAY DATES FOR PAYMENT BAN PURPOSES
        ;
CONF    ; - new condition codes
        ;;49^PRODUCT REPLACEMENT WITHIN PRODUCT LIFECYCLE
        ;;50^PRODUCT REPLACEMENT FOR KNOWN RECALL OF A PRODUCT
        ;;H2^DISCHARGE BY A HOSPICE PROVIDER FOR CAUSE
        ;
COOF    ; - old condition codes
        ;;D2^CHANGES IN REVENUE CODES/HCPCS/HIPPS RATE CODES
        ;;D4^CHANGE IN CLINICAL CODES-ICD FOR DIAGNOSIS AND/OR PROCEDURE
        ;
