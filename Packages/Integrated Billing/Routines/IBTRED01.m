IBTRED01        ;ALB/AAS - EXPAND/EDIT CLAIMS TRACKING ENTRY - CONT; 01-JUL-1993
        ;;2.0;INTEGRATED BILLING;**389**;21-MAR-94;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
%       I '$G(IBTRN)!($G(IORVON)="") G ^IBTRED
        D UR,REVIEW,SC
        Q
REVIEW  ; -- List Reviews done
        N OFFSET,START,IBTRV,IDT,IBTRVD,IBTRTP
        S START=24,OFFSET=2,IBLCNT=0
        D SET^IBCNSP(START,OFFSET," Hospital Reviews Entered ",IORVON,IORVOFF)
        S IDT="" F  S IDT=$O(^IBT(356.1,"ATIDT",IBTRN,IDT)) Q:'IDT  S IBTRV="" F  S IBTRV=$O(^IBT(356.1,"ATIDT",IBTRN,IDT,IBTRV)) Q:'IBTRV  D
        .S IBLCNT=$G(IBLCNT)+1
        .S IBTRVD=$G(^IBT(356.1,IBTRV,0))
        .S IBTRTP=$P($G(^IBE(356.11,+$P(IBTRVD,"^",22),0)),"^")
        .;D SET^IBCNSP(START+IBLCNT,OFFSET,$J(IBLCNT,2)_".  "_$E(IBTRTP_"                        ",1,28)_"  on  "_$E($$DAT1^IBOUTL($P(IBTRVD,"^"),"2P")_"  ",1,8)_"  Status: "_$$EXPAND^IBTRE(356.1,.21,$P(IBTRVD,"^",21)))
        .S IBTEXT=$E(IBTRTP_"  Status: "_$$EXPAND^IBTRE(356.1,.21,$P(IBTRVD,"^",21))_"                                ",1,50)
        .D SET^IBCNSP(START+IBLCNT,OFFSET,$J(IBLCNT,2)_".  "_IBTEXT_"  on  "_$$DAT1^IBOUTL($P(IBTRVD,"^"),"2P"))
        .Q
        D COMM
        Q
COMM    ; -- List Communication Entries
        N OFFSET,START,IDT,IBTRCD,IBCNT
        S START=26+$G(IBLCNT),OFFSET=2
        D SET^IBCNSP(START,OFFSET," Insurance Reviews Entered ",IORVON,IORVOFF)
        S IDT="" F  S IDT=$O(^IBT(356.2,"ATIDT",IBTRN,IDT)) Q:'IDT  S IBTRC="" F  S IBTRC=$O(^IBT(356.2,"ATIDT",IBTRN,IDT,IBTRC)) Q:'IBTRC  D
        .S IBLCNT=$G(IBLCNT)+1,IBCNT=$G(IBCNT)+1
        .S IBTRCD=$G(^IBT(356.2,IBTRC,0))
        .S IBTEXT=$E($$EXPAND^IBTRE(356.2,.04,$P(IBTRCD,"^",4))_" Contact  "_$$EXPAND^IBTRE(356.2,.11,$P(IBTRCD,"^",11))_"                                         ",1,50)
        .D SET^IBCNSP(START+IBCNT,OFFSET,$J(IBCNT,2)_".  "_IBTEXT_"  on  "_$$DAT1^IBOUTL(+IBTRCD,"2P"))
        .Q
        Q
        ;
SC      ; -- Show eligibility/sc conditions
        N OFFSET,START,IDT,IBTRCD,IBCNT,I1,I2,I3
        S START=28+$G(IBLCNT),OFFSET=2
SC1     D SET^IBCNSP(START,OFFSET," Service Connected Conditions: ",IORVON,IORVOFF)
        D ELIG^VADPT
        S IBLCNT=$G(IBLCNT)+1,IBCNT=$G(IBCNT)+1,I3=0
        ;
        D SET^IBCNSP(START+IBCNT,OFFSET,"Service Connected: "_$S('$G(VAEL(3)):"NO",1:$P(VAEL(3),"^",2)_"%"))
        ;
        F I=0:0 S I=$O(^DPT(DFN,.372,I)) Q:'I  D
        .S I1=^DPT(DFN,.372,I,0)
        .Q:'$P(I1,"^",3)
        .S I2=$G(^DIC(31,+I1,0))
        .S:$P(I2,"^",4)'="" I2=$P(I2,"^",4)
        .S I2=$P(I2,"^")
        .S IBLCNT=$G(IBLCNT)+1,IBCNT=$G(IBCNT)+1
        .D SET^IBCNSP(START+IBCNT,OFFSET,$J(IBCNT-1,2)_".  "_$E(I2_"                                               ",1,45)_$J($P(I1,"^",2),3)_"%")
        .S I3=I3+1
        .Q
        I 'I3 S IBLCNT=$G(IBLCNT)+1,IBCNT=$G(IBCNT)+1 D SET^IBCNSP(START+IBCNT,OFFSET,$S('$O(^DPT(DFN,.372,0)):"NONE STATED",1:"NO SC DISABILITIES LISTED")) S I3=1
SCQ     Q
        ;
UR      ; -- ur information region
        N OFFSET,START
        S START=7,OFFSET=51
        D SET^IBCNSP(START,OFFSET," Review Information ",IORVON,IORVOFF)
        D SET^IBCNSP(START+1,OFFSET,"  Insurance Claim: "_$$EXPAND^IBTRE(356,.24,$P(IBTRND,"^",24)))
        D SET^IBCNSP(START+2,OFFSET,"   Follow-up Type: "_$$EXPAND^IBTRE(356,1.07,$P(IBTRND1,"^",7)))
        D SET^IBCNSP(START+3,OFFSET,"    Random Sample: "_$$EXPAND^IBTRE(356,.25,$P(IBTRND,"^",25)))
        D SET^IBCNSP(START+4,OFFSET,"Special Condition: "_$$EXPAND^IBTRE(356,.26,$P(IBTRND,"^",26)))
        D SET^IBCNSP(START+5,OFFSET,"   Local Addition: "_$$EXPAND^IBTRE(356,.27,$P(IBTRND,"^",27)))
        D SET^IBCNSP(START+6,OFFSET,"    Ins. Reviewer: "_$$EXPAND^IBTRE(356,1.06,$P(IBTRND1,"^",6)))
        D SET^IBCNSP(START+7,OFFSET,"Hospital Reviewer: "_$$EXPAND^IBTRE(356,1.05,$P(IBTRND1,"^",5)))
        Q
        ;
4       ; -- Visit region for prosthetics
        N IBDA,IBRMPR S IBDA=$P(IBTRND,"^",9) D PRODATA^IBTUTL1(IBDA)
        D SET^IBCNSP(START+2,OFFSET,"          Item: "_$P($$PIN^IBCSC5B(+IBDA),U,2))
        D SET^IBCNSP(START+3,OFFSET,"   Description: "_$G(IBRMPR(660,+IBDA,24,"E")))
        D SET^IBCNSP(START+4,OFFSET,"      Quantity: "_$J($G(IBRMPR(660,+IBDA,5,"E")),$L($G(IBRMPR(660,+IBDA,14,"E")))))
        D SET^IBCNSP(START+5,OFFSET,"    Total Cost: $"_$G(IBRMPR(660,+IBDA,14,"E")))
        D SET^IBCNSP(START+6,OFFSET,"   Transaction: "_$G(IBRMPR(660,+IBDA,2,"E")))
        D SET^IBCNSP(START+7,OFFSET,"        Vendor: "_$G(IBRMPR(660,+IBDA,7,"E")))
        D SET^IBCNSP(START+8,OFFSET,"        Source: "_$G(IBRMPR(660,+IBDA,12,"E")))
        D SET^IBCNSP(START+9,OFFSET," Delivery Date: "_$G(IBRMPR(660,+IBDA,10,"E")))
        D SET^IBCNSP(START+10,OFFSET,"       Remarks: "_$G(IBRMPR(660,+IBDA,16,"E")))
        D SET^IBCNSP(START+11,OFFSET," Return Status: "_$G(IBRMPR(660,+IBDA,17,"E")))
        Q
