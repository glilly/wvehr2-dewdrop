IBYP430 ;ALB/RDK - IB*2.0*430: UPDATE PLACE OF SERVICE CODES ; 7/2/10 9:44am
        ;;2.0;INTEGRATED BILLING;**430**;21-MAR-94;Build 13
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
EN      N IBA
        S IBA(1)="",IBA(2)="    IB*2.0*430 Preparing to Update Place of Service Codes .....",IBA(3)="" D MES^XPDUTL(.IBA) K IBA
        ;
        ;
        D ADDPOS ;         add Place of Service Codes  (353.1)
        ;
        S IBA(1)="",IBA(2)="    IB*2.0*430 Place of Service Updates Complete",IBA(3)="" D MES^XPDUTL(.IBA) K IBA
        ;
        Q
        ;
ADDPOS  ; Add Place of Service Codes (353.1)
        N IBA,IBCNT,IBI,IBLN,DD,DO,DLAYGO,DIC,DIE,DA,DR,X,Y S IBCNT=0
        ;
        F IBI=1:1 S IBLN=$P($T(POSF+IBI),";;",2) Q:IBLN=""  I $E(IBLN)'=" " D
        . ;
        . I $D(^IBE(353.1,"B",$P(IBLN,U,1)))=10 Q
        . ;
        . K DD,DO S DLAYGO=353.1,DIC="^IBE(353.1,",DIC(0)="L",X=$P(IBLN,U,1),DIC("DR")=".02///"_$P(IBLN,U,2)_";.03///"_$P(IBLN,U,3) D FILE^DICN K DIC I Y<1 S IBA(1)="  ***WARNING ***  CODE "_$P(IBLN,U,1)_" NOT ADDED" D MES^XPDUTL(.IBA) K X,Y,IBA Q
        . ;
        . S IBCNT=IBCNT+1
        . ;
        ;
POSQ    S IBA(1)="",IBA(2)="      * "_$J(IBCNT,3)_"  Place of Service Codes added (353.1)"
        D MES^XPDUTL(.IBA)
        Q
        ;
POSF    ;  Place of Service (353.1)
        ;; code ^ name ^ abbreviation
        ;;    
        ;;01^PHARMACY^PHARMACY
        ;;03^SCHOOL^SCHOOL
        ;;04^HOMELESS SHELTER^HOMELESS SHELTER
        ;;05^IHS FREE STANDING FACILITY^IHS FREE-STANDING
        ;;06^IHS PROVIDER BASED FACILITY^IHS PROVIDER-BASED
        ;;07^TRIBAL 638 FREE STANDING FACILITY^TRIBAL 638 FREE-STDG
        ;;08^TRIBAL 638 PROVIDER BASED FACILITY^TRIBAL 638 PROV-BSD
        ;;09^PRISON CORRECTIONAL FACILITY^PRISON/CORRECT FAC
        ;;13^ASSISTED LIVING FACILITY^ASSTD LIVING FAC
        ;;14^GROUP HOME^GROUP HOME
        ;;15^MOBILE UNIT^MOBILE UNIT
        ;;16^TEMPORARY LODGING^TEMP LODGING
        ;;17^RETAIL WALK-IN^RETAIL/WALK IN
        ;;20^URGENT CARE FACILITY^URGENT CARE
        ;;49^INDEPENDENT CLINIC^INDEPENDENT CLINIC
        ;;57^NON RESIDENTIAL SUBSTANCE ABUSE TREATMENT FACILITY^NON-RES SUBST ABUSE
        ;;
