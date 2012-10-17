IBCNBAR ;ALB/ARH-Ins Buffer: process Accept and Reject ;15 Jan 2009
        ;;2.0;INTEGRATED BILLING;**82,240,345,413,416**;21-MAR-94;Build 58
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;
ACCEPT(IBBUFDA,DFN,IBINSDA,IBGRPDA,IBPOLDA,IBMVINS,IBMVGRP,IBMVPOL,IBNEWINS,IBNEWGRP,IBNEWPOL,IBELIG)   ; move buffer data into Insurance files then cleanup
        ;    1) data moved into insurance files, new records created if needed or edit existing ones
        ;    2) complete some general functions that are executed whenever insurance is entered/edited
        ;    3) allow user to view buffer entry and new/updated insurance records
        ;    4) buffer ins/group/policy data deleted
        ;    5) buffer entry status updated
        ;
        N RESULT,IBSUPRES
        ;Set IBSUPRES to zero to not suppress I/O within Accept 
        S IBSUPRES=0
        ;
PROCESS ; process all changes selected by user, add/edit insurance files based
        ; on buffer data. Entry point for ACCEPAPI^IBCNICB (patch 413)
        ;
        N IVMINSUP,IBNEW,IBCDFN,RIEN S IBCDFN=IBPOLDA S:+IBNEWPOL IBNEW=1 D BEFORE^IBCNSEVT ; insurance event driver
        ;
        N DIR,X,Y,IBX,IBINSH,IBGRPH,IBPOLH S (IBINSH,IBGRPH,IBPOLH)="Updated" W:$G(IBSUPRES)'>0 " ...",!
        ;
        S RESULT(0)="-1^Add new INSURANCE COMPANY failed"
        I +IBNEWINS S IBINSDA=+$$NEWINS^IBCNBMN(IBBUFDA) G:'IBINSDA ACCPTQ  S IBINSH="Created",RESULT(1)="IBINSDA^"_IBINSDA
        ;
        S RESULT(0)="-1^Add new GROUP INSURANCE PLAN failed"
        I +IBNEWGRP S IBGRPDA=+$$NEWGRP^IBCNBMN(IBBUFDA,+IBINSDA) G:'IBGRPDA ACCPTQ S IBGRPH="Created",RESULT(2)="IBGRPDA^"_IBGRPDA
        ;
        S RESULT(0)="-1^Add new patient insurance policy failed"
        I +IBNEWPOL S IBPOLDA=+$$NEWPOL^IBCNBMN(IBBUFDA,+IBINSDA,+IBGRPDA) G:'IBPOLDA ACCPTQ S IBPOLH="Created",RESULT(3)="IBPOLDA^"_IBPOLDA
        ;
        ;Only do this check for ICB ACCEPAPI^IBCNICB interface
        S RESULT(0)="-1^Move TYPE parameter value="_IBMVINS_" is invalid"
        I $G(IBSUPRES)>0,"^1^2^3^"'[("^"_IBMVINS_"^") Q
        ;
        S RESULT(0)="-1^Move buffer data to insurance files failed"
        I +IBINSDA,+IBMVINS D INS^IBCNBMI(IBBUFDA,IBINSDA,+IBMVINS,.RESULT) W:$G(IBSUPRES)'>0 !,"Insurance Company "_IBINSH_"..."
        I +IBINSDA,+IBMVGRP,+IBGRPDA D 
        . D GRP^IBCNBMI(IBBUFDA,IBGRPDA,+IBMVGRP,.RESULT)
        . ; For ICB Interface ensure INDIVIDUAL POLICY PATIENT (.1) field is
        . ; appropriate for IS THIS A GROUP POLICY? (.02) field
        . I $G(IBSUPRES)>0 D
        . . N IBFLDS,IBISGRP,IBPAT
        . . S IBISGRP=$$GET1^DIQ(355.3,IBGRPDA,.02,"I")
        . . S IBPAT=$$GET1^DIQ(355.3,IBGRPDA,.1,"I")
        . . ;Quit if Group Policy and .1 field isn't populated
        . . I IBISGRP>0,IBPAT'>0 Q
        . . ;Quit if Individual Policy and .1 field is populated.
        . . I IBISGRP'>0,IBPAT>0 Q
        . . ;Delete .1 field if Group Policy
        . . I IBISGRP>0 S IBFLDS(355.3,IBGRPDA_",",.1)="@"
        . . I IBISGRP'>0 S IBFLDS(355.3,IBGRPDA_",",.1)=DFN
        . . D FILE^DIE("","IBFLDS","IBERR")
        . W:$G(IBSUPRES)'>0 !,"Group/Plan "_IBGRPH_"..."
        I +IBINSDA,+IBMVPOL,+IBGRPDA,+IBPOLDA D POLICY^IBCNBMI(IBBUFDA,IBPOLDA,+IBMVPOL,.RESULT) W:$G(IBSUPRES)'>0 !,"Patient Policy "_IBPOLH_"..."
        I +IBELIG S RIEN=$O(^IBCN(365,"AF",IBBUFDA,""),-1) I RIEN D EBFILE^IBCNEHL1(DFN,IBPOLDA,RIEN,0) W:$G(IBSUPRES)'>0 !,"Eligibility/Benfits data Updated..."
        ;
        ;Only do this update for ICB ACCEPAPI^IBCNICB interface
        I $G(IBSUPRES)>0,+IBMVPOL,+IBGRPDA,+IBPOLDA,'IBNEWPOL D UPDPOL^IBCNICB(.RESULT,IBBUFDA,DFN,IBINSDA,IBGRPDA,IBPOLDA)
        ;
CLEANUP ; general updates and checks done whenever insurance is added/edited and clean up buffer file
        N IBSOURCE S IBSOURCE=$P($G(^IBA(355.33,IBBUFDA,0)),U,3)
        ;
        ;Don't do PAT^IBCNBMI for ICB ACCEPAPI^IBCNICB interface
        I $G(IBSUPRES)'>0,+IBPOLDA D PAT^IBCNBMI(DFN,IBPOLDA) ; update DOB&SSN of Pat Ins from Pat file
        D POL^IBCNSU41(DFN) ; update Tricare sponsor data
        D COVERED^IBCNSM31(DFN) ; update 'Covered by Insurance' field (2,.3192
        I +IBSOURCE=3 D IVM(1,IBBUFDA,$G(IVMREPTR),$G(IBSUPRES)) ; update/notify IVM
        ;Suppress Write in $$DUPCO^IBCNSOK1 if called from ICB Interface
        I +IBINSDA,+IBPOLDA S IBX=$$DUPCO^IBCNSOK1(DFN,IBINSDA,IBPOLDA,$S($G(IBSUPRES)>0:0,1:1)) ; warning if duplicate policy added for patient
        S RESULT(0)="0"_$S($G(IBX):"^Warning - Duplicate or inconsistent insurance data",1:"")
        ;
        ;Suppress Write in $$DUPPOL^IBCNSOK1 if called from ICB Interface
        I +IBGRPDA S IBX=$$DUPPOL^IBCNSOK1(IBGRPDA,$S($G(IBSUPRES)>0:0,1:1)) ; warning if duplicate plan was added
        S:IBX RESULT(0)=RESULT(0)_"^Warning - Duplicate or inconsistent policy data"
        ;
        ;Suppress Write in $$PTHLD^IBOHCR if called from ICB Interface
        I +IBNEWPOL I +$$PTHLD^IBOHCR(DFN,1,$S($G(IBSUPRES)>0:0,1:1)) D
        . W:$G(IBSUPRES)'>0 !!,"Patient's bills On Hold date updated due to new insurance."
        . S RESULT(0)=RESULT(0)_"^Patient's bills On Hold date updated due to new insurance"
        ;
        I $$HOLD^IBCNBLL(DFN) D
        . W:$G(IBSUPRES)'>0 !!,"There are bills On Hold for this patient."
        . S RESULT(0)=RESULT(0)_"^There are bills On Hold for this patient"
        ;
        ;Suppress DIR call functionality for ICB ACCEPAPI^IBCNICB interface
        D:$G(IBSUPRES)'>0
        . W !! S DIR(0)="FO",DIR("A")="Press 'V' to view the changes or Return to continue" D ^DIR
        . I Y="V"!(Y="v") W !! D INS^IBCNBCD(IBBUFDA,IBINSDA),WAIT^IBCNBUH,GRP^IBCNBCD(IBBUFDA,IBGRPDA),WAIT^IBCNBUH,POLICY^IBCNBCD(IBBUFDA,IBPOLDA),WAIT^IBCNBUH
        ;
        ; if source is eIV, update insurance record field in transmission queue (365.1/.13)
        I $P(^IBA(355.33,IBBUFDA,0),U,3)=5 D UPDIREC^IBCNEHL1($O(^IBCN(365,"AF",IBBUFDA,"")),IBPOLDA)
        ; update buffer file entry so only stub remains and status is changed
        D STATUS^IBCNBEE(IBBUFDA,"A",IBNEWINS,IBNEWGRP,IBNEWPOL) ; update buffer entry's status to accepted
        D DELDATA^IBCNBED(IBBUFDA) ; delete buffer's insurance/patient data
        ;
        S IBCDFN=IBPOLDA S:+IBSOURCE=3 IVMINSUP=1 D AFTER^IBCNSEVT,^IBCNSEVT ; insurance event driver
        ;
ACCPTQ  Q
        ;
REJECT(IBBUFDA) ; process a buffer entry reject
        ;    1) update/notify IVM
        ;    2) buffer ins/group/policy data deleted
        ;    3) buffer entry status updated
        ;    4) if patient has no other active insurance then release any patient bills On Hold
        ;
        N IBSUPRES,RESULT
        ;Set IBSUPRES to 0 to not suppress I/O within REJECT
        S IBSUPRES=0
        ;
REJPROC ;Entry point for REJECAPI^IBCNICB (Patch 413)
        ;
        N DFN S DFN=+$G(^IBA(355.33,+IBBUFDA,60))
        S RESULT="-1^PATIENT IEN MISSING FROM BUFFER ENTRY" Q:'$G(DFN)
        I +$P($G(^IBA(355.33,+IBBUFDA,0)),U,3)=3 D IVM(0,IBBUFDA,$G(IVMREPTR),$G(IBSUPRES))
        ;
        S RESULT=0
        D STATUS^IBCNBEE(+IBBUFDA,"R",0,0,0),DELDATA^IBCNBED(+IBBUFDA) W:$G(IBSUPRES)'>0 " ... done."
        ;
        I +DFN,'$$INSURED^IBCNS1(DFN),'$$BUFFER^IBCNBU1(DFN) D
        . ;Suppress Write in $$PTHLD^IBOHCR if called from ICB Interface
        . I +$$PTHLD^IBOHCR(DFN,2,$S($G(IBSUPRES)>0:0,1:1)) D
        . . I $G(IBSUPRES)'>0 W !!,"Patient has no other active Insurance.",!,"All patient bills On Hold waiting for Insurance to be released." D WAIT^IBCNBUH
        . . S RESULT=RESULT_"^Patient has no other active Insurance.  All patient bills On Hold waiting for Insurance to be released."
        ;
        Q
        ;
        ;
IVM(AR,IBBUFDA,IVMREPTR,IBSUPRES)       ; IVM must be notified whenever a buffer entry
        ; that originated in IVM is accepted or rejected. This lets IVM clean up
        ; its files since IVM also has a buffer type file of insurance uploaded
        ; from the IVM center.
        ; If rejected and Interactive Reads not suppressed, IVM then ask the 
        ; user for a reason it was rejected
        ; input:  AR = 1 if accepted, 0 if rejected
        ;    IBBUFDA = Internal Entry Number to 355.33 file
        ;   IVMREPTR = Internal Entry Number to 301.91 file (Optional)
        ;   IBSUPRES = If equals 1, suppress writes and interactive reads
        ;
        N DFN,IBX,IBY I $P($G(^IBA(355.33,+IBBUFDA,0)),U,3)'=3 Q
        ;
        S DFN=+$G(^IBA(355.33,+IBBUFDA,60))
        S IBX=$P($G(^IBA(355.33,+IBBUFDA,20)),U,1)_U_$P($G(^IBA(355.33,+IBBUFDA,21)),U,1)_U_$P($G(^IBA(355.33,+IBBUFDA,40)),U,3)
        ;
        S IBY=$$UPDATE^IVMLINS4(DFN,AR,IBX,$G(IVMREPTR),$G(IBSUPRES))
        Q
        ;
