IBCNBAR ;ALB/ARH-Ins Buffer: process Accept and Reject ;1 Jun 97
 ;;2.0;INTEGRATED BILLING;**82,240,345**;21-MAR-94;Build 28
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ;
ACCEPT(IBBUFDA,DFN,IBINSDA,IBGRPDA,IBPOLDA,IBMVINS,IBMVGRP,IBMVPOL,IBNEWINS,IBNEWGRP,IBNEWPOL) ; move buffer data into Insurance files then cleanup
 ;    1) data moved into insurance files, new records created if needed or edit existing ones
 ;    2) complete some general functions that are executed whenever insurance is entered/edited
 ;    3) allow user to view buffer entry and new/updated insurance records
 ;    4) buffer ins/group/policy data deleted
 ;    5) buffer entry status updated
 ;
 ;
PROCESS ; process all changes selected by user, add/edit insurance files based on buffer data
 ;
 N IVMINSUP,IBNEW,IBCDFN S IBCDFN=IBPOLDA S:+IBNEWPOL IBNEW=1 D BEFORE^IBCNSEVT ; insurance event driver
 ;
 N DIR,X,Y,IBX,IBINSH,IBGRPH,IBPOLH S (IBINSH,IBGRPH,IBPOLH)="Updated" W " ...",!
 ;
 I +IBNEWINS S IBINSDA=+$$NEWINS^IBCNBMN(IBBUFDA) G:'IBINSDA ACCPTQ  S IBINSH="Created"
 I +IBNEWGRP S IBGRPDA=+$$NEWGRP^IBCNBMN(IBBUFDA,+IBINSDA) G:'IBGRPDA ACCPTQ  S IBGRPH="Created"
 I +IBNEWPOL S IBPOLDA=+$$NEWPOL^IBCNBMN(IBBUFDA,+IBINSDA,+IBGRPDA) G:'IBPOLDA ACCPTQ  S IBPOLH="Created"
 ;
 I +IBINSDA,+IBMVINS D INS^IBCNBMI(IBBUFDA,IBINSDA,+IBMVINS) W !,"Insurance Company "_IBINSH_"..."
 I +IBINSDA,+IBMVGRP,+IBGRPDA D GRP^IBCNBMI(IBBUFDA,IBGRPDA,+IBMVGRP) W !,"Group/Plan "_IBGRPH_"..."
 I +IBINSDA,+IBMVPOL,+IBGRPDA,+IBPOLDA D POLICY^IBCNBMI(IBBUFDA,IBPOLDA,+IBMVPOL) W !,"Patient Policy "_IBPOLH_"..."
 ;
CLEANUP ; general updates and checks done whenever insurance is added/edited and clean up buffer file
 N IBSOURCE S IBSOURCE=$P($G(^IBA(355.33,IBBUFDA,0)),U,3)
 ;
 I +IBPOLDA D PAT^IBCNBMI(DFN,IBPOLDA) ;                             update DOB&SSN of Pat Ins from Pat file
 D POL^IBCNSU41(DFN) ;                                               update Tricare sponsor data
 D COVERED^IBCNSM31(DFN) ;                                           update 'Covered by Insurance' field (2,.3192
 I +IBSOURCE=3 D IVM(1,IBBUFDA) ;                                    update/notify IVM
 I +IBINSDA,+IBPOLDA S IBX=$$DUPCO^IBCNSOK1(DFN,IBINSDA,IBPOLDA,1) ; warning if duplicate policy added for patient
 I +IBGRPDA S IBX=$$DUPPOL^IBCNSOK1(IBGRPDA,1) ;                     warning if duplicate plan was added
 I +IBNEWPOL I +$$PTHLD^IBOHCR(DFN,1,1) W !!,"Patient's bills On Hold date updated due to new insurance."
 I $$HOLD^IBCNBLL(DFN) W !!,"There are bills On Hold for this patient."
 ;
 W !! S DIR(0)="FO",DIR("A")="Press 'V' to view the changes or Return to continue" D ^DIR
 I Y="V"!(Y="v") W !! D INS^IBCNBCD(IBBUFDA,IBINSDA),WAIT^IBCNBUH,GRP^IBCNBCD(IBBUFDA,IBGRPDA),WAIT^IBCNBUH,POLICY^IBCNBCD(IBBUFDA,IBPOLDA),WAIT^IBCNBUH
 ;
 ; update buffer file entry so only stub remains and status is changed
 D STATUS^IBCNBEE(IBBUFDA,"A",IBNEWINS,IBNEWGRP,IBNEWPOL) ;          update buffer entry's status to accepted
 D DELDATA^IBCNBED(IBBUFDA) ;                                        delete buffer's insurance/patient data
 ;
 S IBCDFN=IBPOLDA S:+IBSOURCE=3 IVMINSUP=1 D AFTER^IBCNSEVT,^IBCNSEVT ; insurance event driver
 ;
ACCPTQ Q
 ;
 ;
REJECT(IBBUFDA) ; process a buffer entry reject
 ;    1) update/notify IVM
 ;    2) buffer ins/group/policy data deleted
 ;    3) buffer entry status updated
 ;    4) if patient has no other active insurance then release any patient bills On Hold
 ;
 N DFN S DFN=+$G(^IBA(355.33,+IBBUFDA,60))
 ;
 I +$P($G(^IBA(355.33,+IBBUFDA,0)),U,3)=3 D IVM(0,IBBUFDA)
 ;
 D STATUS^IBCNBEE(+IBBUFDA,"R",0,0,0),DELDATA^IBCNBED(+IBBUFDA) W " ... done."
 ;
 I +DFN,'$$INSURED^IBCNS1(DFN),'$$BUFFER^IBCNBU1(DFN) D
 . I +$$PTHLD^IBOHCR(DFN,2,1) W !!,"Patient has no other active Insurance.",!,"All patient bills On Hold waiting for Insurance have been released." D WAIT^IBCNBUH
 ;
 Q
 ;
 ;
IVM(AR,IBBUFDA) ; IVM must be notified whenever a buffer entry that originated in IVM is accepted or rejected
 ; this lets them clean up their files since they also have a buffer type file of insurance uploaded from the IVM center
 ; if rejected they then ask the user for a reason it was rejected
 ; input:  AR = 1 if accepted, 0 if rejected
 ;
 N DFN,IBX,IBY I $P($G(^IBA(355.33,+IBBUFDA,0)),U,3)'=3 Q
 ;
 S DFN=+$G(^IBA(355.33,+IBBUFDA,60))
 S IBX=$P($G(^IBA(355.33,+IBBUFDA,20)),U,1)_U_$P($G(^IBA(355.33,+IBBUFDA,21)),U,1)_U_$P($G(^IBA(355.33,+IBBUFDA,40)),U,3)
 ;
 S IBY=$$UPDATE^IVMLINS4(DFN,AR,IBX)
 Q
