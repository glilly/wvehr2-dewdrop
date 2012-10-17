IB20P442        ;ALB/RDK - IB*2.0*442; DSS CLINIC STOP CODES ; 1/5/11 3:14pm
        ;;2.0;INTEGRATED BILLING;**442**;21-MAR-94;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
EN      ;
        N IBEFFDT,U
        S U="^"
        D START,ADD,UPDATE,FINISH
        Q
        ;
START   D BMES^XPDUTL("DSS Clinic Stop Codes, Post-Install Starting")
        Q
        ;
FINISH  D BMES^XPDUTL("DSS Clinic Stop Codes, Post-Install Complete")
        Q
        ;
        ;
ADD     ;add a new code
        N Y,IBC,IBT,IBX,IBY,IBCODE,IBTYPE,IBDES,IBOVER
        D BMES^XPDUTL(" Adding new codes to file 352.5")
        S IBC=0
        F IBX=1:1 S IBT=$P($T(NCODE+IBX),";",3) Q:'$L(IBT)  D
        . S IBCODE=+$P(IBT,U)
        . S IBTYPE=$P(IBT,U,2)
        . S IBDES=$E($P(IBT,U,3),1,30)
        . S IBOVER=$P(IBT,U,4)
        . S IBY=$P(IBT,U,5)
        . I $D(^IBE(352.5,"AEFFDT",IBCODE,-IBY)) D  Q
        . . D BMES^XPDUTL(" Duplication of stop code "_IBCODE)
        . S Y=+$$ADD3525(IBCODE,IBY,IBTYPE,IBDES,IBOVER) S:Y>0 IBC=IBC+1
        D BMES^XPDUTL("     "_IBC_$S(IBC<2:" entry",1:" entries")_" added to 352.5")
        Q
        ;
UPDATE  ;update an old code
        N Y,IB1,IBC,IBT,IBX,IBCODE,IBMSG,IBTYPE,IBDES,IBOVER,IBLSTDT
        S (IBC,IBMSG(1),IBMSG(2),IBMSG(3))=0
        D BMES^XPDUTL(" Updating Stop Code entries in file 352.5")
        F IBX=1:1 S IBT=$P($T(OCODE+IBX),";",3) Q:'$L(IBT)  D
        . S IBCODE=+$P(IBT,U)
        . S IBY=$P(IBT,U,5)
        . I $D(^IBE(352.5,"AEFFDT",IBCODE,-IBY)) D  Q 
        . . D BMES^XPDUTL(" Duplication of stop code "_IBCODE)
        . S IBLSTDT=$O(^IBE(352.5,"AEFFDT",IBCODE,-9999999))
        . I +IBLSTDT=0 D  Q
        . . D BMES^XPDUTL(" Code "_IBCODE_" not found in file 352.5")
        . S IB1=$O(^IBE(352.5,"AEFFDT",IBCODE,IBLSTDT,0))
        . S IB1=$G(^IBE(352.5,IB1,0))
        . S IBTYPE=$S($P(IBT,U,2)'="":$P(IBT,U,2),1:$P(IB1,U,3))
        . S IBDES=$S($P(IBT,U,3)'="":$E($P(IBT,U,3),1,30),1:$P(IB1,U,4))
        . S IBOVER=$P(IBT,U,4)
        . S Y=+$$ADD3525(IBCODE,IBY,IBTYPE,IBDES,IBOVER) S:Y>0 IBC=IBC+1
        D BMES^XPDUTL("     "_IBC_$S(IBC<2:" update",1:" updates")_" added to file 352.5")
        Q
        ;
ADD3525(IBCODE,IBEFFDT,IBTYPE,IBDES,IBOVER)     ;
        ;add a new entry
        D BMES^XPDUTL("   "_IBCODE_"  "_IBDES)
        N IBIENS,IBFDA,IBER,IBRET
        S IBRET=""
        S IBIENS="+1,"
        S IBFDA(352.5,IBIENS,.01)=IBCODE
        S IBFDA(352.5,IBIENS,.02)=IBEFFDT
        S IBFDA(352.5,IBIENS,.03)=IBTYPE
        S IBFDA(352.5,IBIENS,.04)=IBDES
        S:IBOVER IBFDA(352.5,IBIENS,.05)=1
        D UPDATE^DIE("","IBFDA","IBRET","IBER")
        I $D(IBER) D BMES^XPDUTL(IBER("DIERR",1,"TEXT",1))
        Q $G(IBRET(1))
        ;
        ;new non-billable type data
NCODE   ;;code^billable type^description^override flag
        ;;539^1^MH INTGRTD CARE GRP^^3100201
        ;;588^1^RRTP AFTERCARE IND^1^3100201
        ;;598^1^RRTP PRE-ADMIT IND^1^3100201
        ;;599^1^RRTP PRE-ADMIT GRP^1^3100201
        ;;158^2^BRACHYTHERAPY TREATMENT^1^3110301
        ;;511^0^GRANT AND PER DIEM^1^3110301
        ;
        ;codes update
OCODE   ;;code^billable type^description^override flag
        ;;416^1^PRE-SURG EVAL BY NON-MD^1^3100201
        ;;432^1^PRE-SURG EVAL BY MD^^3100201
        ;;433^1^PRE-SURG EVAL BY NURSING^^3100201
        ;;534^1^MH INTGRTD CARE IND^^3100201
        ;;595^0^RRTP AFTERCARE GRP^^3100201
        ;;197^2^POLYTRAUMA/TBI IND^1^3110301
        ;;198^2^POLYTRAUMA/TBI GRP^1^3110301
        ;;199^0^TELEPHONE POLYTRAUMA/TBI^1^3110301
        ;;348^1^PRIMARY CARE SHARED APPT^^3110301
        ;;394^1^MED SPECIALTY SHARED APPT^^3110301
        ;;416^1^PRE-SURG EVAL BY NON-MD^1^3110301
        ;;529^0^HCHV/HCMI^1^3110301
        ;;595^1^RRTP AFTERCARE GRP^^3110301
        ;;714^1^OTHER ED IND^1^3110301
        ;;716^1^POST SURG ROUTINE AFTERCARE^^3110301
        ;
