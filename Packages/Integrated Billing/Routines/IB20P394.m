IB20P394        ;DAY/RRA - DSS CLINIC STOP CODES IB*2.0*394 PRE-INIT ; 3/13/07 12:55pm
        ;;2.0;INTEGRATED BILLING;**394**;21-MAR-94;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
EN      ;
        N IBEFFDT,U
        S U="^",IBEFFDT=3080215 ;effective date FEB 15th, 2008
        D START,ADD(IBEFFDT),FINISH
        Q
        ;
START   D BMES^XPDUTL("DSS Clinic Stop Codes, Post-Install Starting")
        Q
        ;
FINISH  D BMES^XPDUTL("DSS Clinic Stop Codes, Post-Install Complete")
        Q
        ;
        ;
ADD(IBEFFDT)    ;
        ;add a new code
        N Y,IBC,IBT,IBX,IBY,IBCODE,IBTYPE,IBDES,IBOVER
        D BMES^XPDUTL(" Adding new code 718 to file 352.5")
        S IBC=0
        F IBX=1:1 S IBT=$P($T(NCODE+IBX),";",3) Q:'$L(IBT)  D
        . S IBCODE=+$P(IBT,U)
        . S IBY=IBEFFDT
        . I $D(^IBE(352.5,"AEFFDT",IBCODE,-IBY)) D  Q
        . . D BMES^XPDUTL(" Duplication of stop code "_IBCODE)
        . S IBTYPE=$P(IBT,U,2)
        . S IBDES=$E($P(IBT,U,3),1,30)
        . S IBOVER=$P(IBT,U,4)
        . S Y=+$$ADD3525(IBCODE,IBY,IBTYPE,IBDES,IBOVER) S:Y>0 IBC=IBC+1
        D BMES^XPDUTL("     "_"Stop Code 718 added to 352.5")
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
        ;;718^0^DIABETIC RETINAL SCREENING^1
        ;
