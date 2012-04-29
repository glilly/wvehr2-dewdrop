IBCC ;ALB/MJB - CANCEL THIRD PARTY BILL ;14 JUN 88  10:12
 ;;2.0;INTEGRATED BILLING;**2,19,77,80,51,142,137,161,199,241,155,276,320,358**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;MAP TO DGCRC
 ;
 I '$D(IBCAN) S IBCAN=1
ASK ;
 ;***
 ;I $D(XRT0) S:'$D(XRTN) XRTN="IBCC" D T1^%ZOSV ;stop rt clock
 ;S XRTL=$ZU(0),XRTN="IBCC-1" D T0^%ZOSV ;start rt clock
 ;
 ; If called at entry point PROCESS, variable IBNOASK will exist.
 ; First time through, IBNOASK=1
 ; Second time through, IBNOASK=2 and it will quit
 I $G(IBNOASK)=2 G Q
 I $G(IBNOASK)=1 S IBNOASK=2
 ;
 G Q:$G(IBCE("EDI"))
 D Q
 S IBQUIT=0
 N DPTNOFZY S DPTNOFZY=1  ;Suppress PATIENT file fuzzy lookups
 I '$G(IBNOASK) S DIC="^DGCR(399,",DIC(0)="AEMQZ",DIC("A")="Enter BILL NUMBER or Patient NAME: " W !! D ^DIC I Y<1 S IBQUIT=1 G Q1
 K IB364
NOPTF ; Note if IB364 is >0 it will be used as the ien to update in file 364
 N DA,I
 I '$G(IBNOASK) S IBIFN=+$G(Y)
 I '$G(IBIFN) G ASK
 I IBCAN>1 D NOPTF^IBCB2 I 'IBAC1 D NOPTF1^IBCB2 G ASK
 ; Check if bill has been referred to Counsel
 I $P($G(^PRCA(430,IBIFN,6)),U,4) D  G ASK
 . W !,"This bill has been referred to Regional Counsel and cannot be 'CANCELLED' in"
 . W !,"Integrated Billing.  Please use the option 'TP Referred Follow-up'"
 . W !,"[PRCA RC ACTION MENU] in Accounts Receivable to request that Regional"
 . W !,"Counsel return the bill to your facility."
 . Q
 ;
 F I=0,"S","U1" S IB(I)=$G(^DGCR(399,IBIFN,I))
 S IBSTAT=$P(IB(0),U,13)
 ;
 ; Restrict access to this process for REQUEST MRA bills
 I IBSTAT=2,'$G(IBCE("EDI")),$$MRAWL^IBCEMU2(IBIFN) D  G ASK
 . W !!?4,"This bill is in a status of REQUEST MRA and it does appear on the"
 . W !?4,"MRA Management Work List.  Please use the 'MRA Management Menu' options"
 . W !?4,"for all processing related to this bill."
 . Q
 ;
 ; Warning message if in a REQUEST MRA status with no MRA on file
 I IBSTAT=2,'$$MRACNT^IBCEMU1(IBIFN) D
 . N REJ
 . D TXSTS^IBCEMU2(IBIFN,,.REJ)
 . W *7,!!?4,"Warning!  This bill is in a status of REQUEST MRA."
 . W !?4,"No MRAs have been received"
 . I REJ W ", but the most recent transmission of this",!?4,"MRA request bill was rejected."
 . I 'REJ W " and there are no rejection messages on file",!?4,"for the most recent transmission of this MRA request bill."
 . Q
 ;
 I IBCAN=2,IB("S")]"",+$P(IB("S"),U,16),$P(IB("S"),U,17)]"" D  G 1
 . W !!,"This bill was cancelled on " S Y=$P(IB("S"),U,17) X ^DD("DD") W Y," by ",$S($P(IB("S"),U,18)']"":IBU,$D(^VA(200,$P(IB("S"),U,18),0)):$P(^(0),U,1),1:IBU),"."
 . S IBQUIT=1
 ; Notify if a payment has been posted to this bill before cancel
 N PRCABILL
 S PRCABILL=$$TPR^PRCAFN(IBIFN)
 I PRCABILL=-1 W !!,"Please note: PRCA was unable to determine if a payment has been posted."
 I PRCABILL>0 W !!,"Please note a PAYMENT of **$"_$$TPR^PRCAFN(IBIFN)_"** has been POSTED to this bill."
 ;
 ; If bill was created via Electronic claims process then notify
 ; user that cancellation should occur using ECME package
 I $$GET1^DIQ(399,IBIFN_",",460)]"" D  G:'Y ASK
 . W !!!?5,"This bill was created by the"
 . W !?5,"Electronic Claims Management Engine (ECME)."
 . W !?5,"Cancellation needs to occur in the ECME package by"
 . W !?5,"submitting a REVERSAL to the Payer.",!!
 . K DIR S DIR("A",1)="Has a REVERSAL for this e-Claim already been",DIR("A")="submitted to the payer via the ECME package (Y/N)",DIR(0)="Y",DIR("B")="NO" D ^DIR
 . I Y=0 W !!,"<PLEASE SUBMIT A REVERSAL USING THE APPROPRIATE OPTION IN THE ECME PACKAGE>",$C(7)
 ;
CHK S (IBCCCC,IBQUIT)=0 I '$G(IBCEAUTO),'$G(IBMCSCAN) W !!,"ARE YOU SURE YOU WANT TO CANCEL THIS BILL" S %=2 D YN^DICN G:%=0 HELP I %'=1 S IBQUIT=1 G NO
 ;
 I '$G(IBCEAUTO) W !!,"LAST CHANCE TO CHANGE YOUR MIND..."
 S DIE=399,DA=IBIFN,DIE("NO^")=""
 S DR="16;S:'X Y=0;19;S IBCCCC=1;"
 I $G(IBCEAUTO) S DR="16////1;19////EDI/MRA TURNED OFF;S IBCCCC=1;"
 ;
 ; esg - 8/23/06 - IB*2*358 - fix semi-colon in free text field
 I $G(IBMCSRSC)'="" S DR="16;S:'X Y=0;19//^S X=IBMCSRSC;S IBCCCC=1;"
 D ^DIE K DIE,DR
 ;
NO I 'IBCCCC W !!,"<NO ACTION TAKEN>",*7 S IBQUIT=1 G ASK:IBCAN<2,Q
 S IBCCR=$P($G(^DGCR(399,IBIFN,"S")),U,19)
 W !!,"...Bill has been cancelled..." D BULL^IBCBULL,BSTAT^IBCDC(IBIFN),PRIOR^IBCCC2(IBIFN)
 ;
 ; cancelling in ingenix claimsmanager if ingenix is running
 ; clean-up of variables is OK if not coming in from ListMan screen
 I $$CM^IBCIUT1(IBIFN) S IBCISNT=4 D ST2^IBCIST I '$G(IBCICNCL) K IBCISNT,IBCISTAT,IBCIREDT,IBCIERR
 ;
 S IBEDI=$G(IB364)
 I 'IBEDI S IBEDI=+$$LAST364^IBCEF4(IBIFN)
 I IBEDI D UPDEDI^IBCEM(IBEDI,"C") ;Update EDI files, if needed
 ;
 F I="S","U1" S IB(I)=$S($D(^DGCR(399,IBIFN,I)):^(I),1:"")
 S PRCASV("ARREC")=IBIFN,PRCASV("AMT")=$S(IB("U1")']"":0,1:$P(IB("U1"),"^")),PRCASV("DATE")=$P(IB("S"),"^",17),PRCASV("BY")=$P(IB("S"),"^",18)
 S PRCASV("COMMENT")=$S($P(IB("S"),U,19)]"":$P(IB("S"),U,19),$P(^IBE(350.9,1,2),"^",7)]"":$P(^(2),"^",7),1:"BILL CANCELLED IN MAS")
 S PRCASV("BY")=$S($P(IB("S"),U,18)]"":$P(IB("S"),U,18),1:"")
 S X=$$CANCEL^RCBEIB($G(PRCASV("ARREC")),$G(PRCASV("DATE")),$G(PRCASV("BY")),$G(PRCASV("AMT")),$G(PRCASV("COMMENT")))
 W !,$S(X:">> The receivable associated with the claim was cancelled.",1:">> The receivable associated with the claim was not cancelled.")
 I $P(X,U,2)]"" W !,">>> ",$P(X,U,2) ; The reason why the claim can not be cancelled.
 I IBCAN<2 D RNB^IBCC1 ;assign a reason not billable
 G ASK:IBCAN<2,Q
 ;
HELP W !,?3,"Answer 'YES' or 'Y' if you wish to cancel this bill.",!,?3,"Answer 'NO' or 'N' if you want to abort." G CHK
 Q
1 I $P(IB(0),U,13)=1 W !,"This record was re-opened on " S Y=$P(IB(0),U,14) X ^DD("DD") W Y,"." G CHK
 G ASK
Q1 K:IBCAN=1 IBQUIT K IBCAN
Q K %,IBEPAR,IBSTAT,IBARST,IBAC1,IB,DFN,IBX,IBZ,DIC,DIE,DR,PRCASV,PRCASVC,X,Y,IBEDI
 ;***
 ;I $D(XRT0) S:'$D(XRTN) XRTN="IBCC" D T1^%ZOSV ;stop rt clock
 Q
 ;
PROCESS(IBIFN,IBCAN) ;
 ; Entry point when the bill number is already known.  Use this when
 ; you just want to try to cancel this bill and this bill only.
 ; Input:
 ;   IBIFN - Internal bill# (Required)
 ;   IBCAN - Cancel Flag (optional, defaults to 1 if not included)
 ;
 NEW IBNOASK
 S IBNOASK=1
 S IBCAN=$G(IBCAN,1)
 G ASK
 ;
 ;IBCC
