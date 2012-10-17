IBY399P4        ;ALB/ARH - IB*2*399 POST-INSTALL - FTF CONVERSION ; 2/27/09
        ;;2.0;INTEGRATED BILLING;**399**;21-MAR-94;Build 8
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
CONVF   ; Convert free text Filing Time Frames to Standard Filing Time Frames
        ; if the free text Filing Time Frame exactly matchs a pre-defined text then it is deleted and 
        ; the corresponding Standard Filing Time Frame and Value is added, 
        ; both Insurance Company and Group Plan Filing Time Frames are converted, active and non-medicare only
        N IBA,IBC,IBINS,IBINS0,IBFTF,IBSFTF,DIE,DIC,DA,DR,X,Y S IBC=0
        ;
        ; Insurance Company Filing Time Frame (#36,.12) converted to Standard Filing Time Frame (.18) and Value (.19)
        S (IBC,IBINS)=0 F  S IBINS=$O(^DIC(36,IBINS)) Q:'IBINS  D
        . S IBINS0=$G(^DIC(36,IBINS,0)) I '$$ACTIVE(IBINS) Q
        . I +$P(IBINS0,U,18) Q
        . S IBFTF=$P(IBINS0,U,12) I IBFTF="" Q
        . S IBSFTF=$$STND(IBFTF) I 'IBSFTF Q
        . ;
        . S DR=".12////@;.18////"_+IBSFTF I +$P(IBSFTF,U,3) S DR=DR_";.19////"_+$P(IBSFTF,U,3)
        . S DIE="^DIC(36,",DA=IBINS D ^DIE K DIE S IBC=IBC+1
        ;
        S IBA=">> Insurance Companies (#36) Converted to Standard Filing Time Frames, "_IBC D MSG(IBA)
        ;
        ; Insurance Plan Filing Time Frame (#355.3,.13) converted to Standard Filing Time Frame (.16) and Value (.17)
        S (IBC,IBINS)=0 F  S IBINS=$O(^IBA(355.3,IBINS)) Q:'IBINS  D
        . S IBINS0=$G(^IBA(355.3,IBINS,0)) I '$$ACTIVE(+IBINS0,IBINS) Q
        . I +$P(IBINS0,U,16) Q
        . S IBFTF=$P(IBINS0,U,13) I IBFTF="" Q
        . S IBSFTF=$$STND(IBFTF) I 'IBSFTF Q
        . ;
        . S DR=".13////@;.16////"_+IBSFTF I +$P(IBSFTF,U,3) S DR=DR_";.17////"_+$P(IBSFTF,U,3)
        . S DIE="^IBA(355.3,",DA=IBINS D ^DIE K DIE S IBC=IBC+1
        ;
        S IBA=">> Insurance Plan (#355.3) Converted to Standard Filing Time Frames, "_IBC D MSG(IBA)
        ;
        Q
        ;
ACTIVE(IBINS,IBPLN)     ; check if the insurance should have the Standard FTF added, active and not medicare
        N IBACT,IBINS0,IBPLN0 S IBACT=1
        S IBINS0=$G(^DIC(36,+$G(IBINS),0)),IBPLN0=$G(^IBA(355.3,+$G(IBPLN),0))
        ;
        I +$P(IBINS0,U,5) S IBACT=0
        I $P(IBINS0,U,1)["MEDICARE" S IBACT=0
        I $G(^IBE(355.2,+$P(IBINS0,U,13),0))["MEDICARE" S IBACT=0
        ;
        I +$P(IBPLN0,U,11) S IBACT=0
        I $P($G(^IBE(355.1,+$P(IBPLN0,U,9),0)),U,3)=5 S IBACT=0
        ;
        Q IBACT
        ;
        ;
STND(IBFTF)     ; return the Standard Filing Time Frame and Value that correspond to the Free Text Filing Time Frame
        ; Input:   Filing Time Frame Free Text
        ; Returns: Standard FTF pointer (#355.13) ^ Standard FTF Name ^ Standard FTF Value (from input IBFTF)
        ; 
        N IBSFTF,IBFTV,IBFTU S IBSFTF="" I '$G(IBFTF) G STNDQ
        ;
        S IBFTF=$$UP^XLFSTR(IBFTF),IBFTV=+IBFTF,IBFTU=$P(IBFTF,IBFTV,2,999) I $E(IBFTU)=" " S IBFTU=$E(IBFTU,2,999)
        ;
        I IBFTU="D" S IBSFTF="DAYS"_U_IBFTV G STNDQ
        I IBFTU="DAYS" S IBSFTF="DAYS"_U_IBFTV G STNDQ
        I IBFTU="DAYS DOS" S IBSFTF="DAYS"_U_IBFTV G STNDQ
        I IBFTU="DAYS FROM DOS" S IBSFTF="DAYS"_U_IBFTV G STNDQ
        ;
        I IBFTU="M" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        I IBFTU="MO" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        I IBFTU="MOS" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        I IBFTU="MTHS" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        I IBFTU="MONTHS" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        I IBFTU="MO DOS" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        I IBFTU="MOS DOS" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        I IBFTU="MONTHS DOS" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        I IBFTU="MOS FROM DOS" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        I IBFTU="MONTHS FROM DOS" S IBSFTF="MONTH(S)"_U_IBFTV G STNDQ
        ;
        I IBFTU="YR" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YRS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YEAR" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YEARS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YR DOS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YRS DOS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YEAR DOS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YEARS DOS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YR FROM DOS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YRS FROM DOS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YEAR FROM DOS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        I IBFTU="YEARS FROM DOS" S IBSFTF="YEAR(S)"_U_IBFTV G STNDQ
        ;
        I IBFTF="3-31 FOL YR" S IBSFTF="MONTHS OF FOLLOWING YEAR^3" G STNDQ
        I IBFTF="3/31 FOL YR" S IBSFTF="MONTHS OF FOLLOWING YEAR^3" G STNDQ
        I IBFTF="3-31 FOLLOWING YR" S IBSFTF="MONTHS OF FOLLOWING YEAR^3" G STNDQ
        I IBFTF="3/31 FOLLOWING YR" S IBSFTF="MONTHS OF FOLLOWING YEAR^3" G STNDQ
        I IBFTF="3-31 FOLLOWING YEAR" S IBSFTF="MONTHS OF FOLLOWING YEAR^3" G STNDQ
        I IBFTF="3/31 FOLLOWING YEAR" S IBSFTF="MONTHS OF FOLLOWING YEAR^3" G STNDQ
        ;
        I IBFTF="12-31 FOL YR" S IBSFTF="END OF FOLLOWING YEAR" G STNDQ
        I IBFTF="12/31 FOL YR" S IBSFTF="END OF FOLLOWING YEAR" G STNDQ
        I IBFTF="12-31 FOLLOWING YR" S IBSFTF="END OF FOLLOWING YEAR" G STNDQ
        I IBFTF="12/31 FOLLOWING YR" S IBSFTF="END OF FOLLOWING YEAR" G STNDQ
        I IBFTF="12-31 FOLLOWING YEAR" S IBSFTF="END OF FOLLOWING YEAR" G STNDQ
        I IBFTF="12/31 FOLLOWING YEAR" S IBSFTF="END OF FOLLOWING YEAR" G STNDQ
        ;
STNDQ   I IBSFTF'="" S IBSFTF=$O(^IBE(355.13,"B",$P(IBSFTF,U,1),0))_U_IBSFTF
        Q IBSFTF
        ;
MSG(IBA)        ;
        N IBM S IBM(1)="     ",IBM(2)="     "_$G(IBA)
        D MES^XPDUTL(.IBM)
        Q
