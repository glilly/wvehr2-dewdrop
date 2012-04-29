RCDPEWL0        ;ALB/TMK - ELECTRONIC EOB WORKLIST ACTIONS ;06 Jun 2007  11:50 AM
        ;;4.5;Accounts Receivable;**173,208,252**;Mar 20, 1995;Build 63
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        Q
        ;
PARAMS  ; Select params for ERA list
        ; Return ^TMP("RCERA_PARAMS",$J) array
        N DIR,X,Y,RCDFR,RCDTO,RCPAYR,RCQUIT,DUOUT,DTOUT
        K ^TMP("RCERA_PARAMS",$J)
        S RCQUIT=0
        W !!,"SELECT PARAMETERS FOR DISPLAYING THE LIST OF ERAs"
        S DIR(0)="SA^U:UNPOSTED;P:POSTED;B:BOTH",DIR("B")="UNPOSTED",DIR("A")="ERA POSTING STATUS: " W ! D ^DIR K DIR
        I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 G PARAMSQ
        S ^TMP("RCERA_PARAMS",$J,"RCPOST")=Y
        S DIR(0)="SA^N:NOT MATCHED;M:MATCHED;B:BOTH",DIR("B")="BOTH",DIR("A")="ERA-EFT MATCH STATUS: " W ! D ^DIR K DIR
        I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 G PARAMSQ
        S ^TMP("RCERA_PARAMS",$J,"RCMATCH")=Y
        ;
DT1     S RCDTO=DT,RCDFR=0
        S RCQUIT=0,DIR(0)="YA",DIR("A")="LIMIT THE SELECTION TO A DATE RANGE WHEN THE ERA WAS RECEIVED?: ",DIR("B")="NO" W ! D ^DIR K DIR
        I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 G PARAMSQ
        I Y=1 S RCQUIT=0 D  I RCQUIT K ^TMP("RCERA_PARAMS",$J,"RCDT") G DT1
        . S DIR(0)="DA",DIR("A")="EARLIEST DATE: " D ^DIR K DIR
        . I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 Q
        . S RCDFR=Y
        . S DIR(0)="DA^"_RCDFR_";"_DT,DIR("A")="LATEST DATE: " D ^DIR K DIR
        . I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 Q
        . S RCDTO=Y
        S ^TMP("RCERA_PARAMS",$J,"RCDT")=(RCDFR_U_RCDTO)
        ;
PAYR    S RCQUIT=0,DIR(0)="SA^A:ALL;R:RANGE",DIR("A")="(A)LL PAYERS, (R)ANGE OF PAYER NAMES: ",DIR("B")="ALL" W ! D ^DIR K DIR
        I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 G PARAMSQ
        S RCPAYR=Y,^TMP("RCERA_PARAMS",$J,"RCPAYR")=Y
        I RCPAYR="A" G PARAMSQ
        I RCPAYR="R" D  I RCQUIT K ^TMP("RCERA_PARAMS",$J,"RCPAYR") G PAYR
        . W !,"NAMES YOU SELECT HERE WILL BE THE PAYER NAMES FROM THE ERA, NOT THE INS FILE"
        . S DIR("?")="ENTER A NAME BETWEEN 1 AND 30 CHARACTERS IN UPPERCASE"
        . S DIR(0)="FA^1:30^K:X'?.U X",DIR("A")="START WITH PAYER NAME: " W ! D ^DIR K DIR
        . I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 Q
        . S RCPAYR("FROM")=Y,$P(^TMP("RCERA_PARAMS",$J,"RCPAYR"),U,2)=Y
        . S DIR("?")="ENTER A NAME BETWEEN 1 AND 30 CHARACTERS IN UPPERCASE"
        . S DIR(0)="FA^1:30^K:X'?.U X",DIR("A")="GO TO PAYER NAME: ",DIR("B")=$E(RCPAYR("FROM"),1,27)_"ZZZ" W ! D ^DIR K DIR
        . I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 Q
        . S $P(^TMP("RCERA_PARAMS",$J,"RCPAYR"),U,3)=Y
        W !
        ;
PARAMSQ ;
        D PARAMS^RCDPEWLD(.RCQUIT)
        Q
        ;
FILTER(Y)       ; Returns 1 if record in entry Y in 344.4 passes
        ; the edits for the worklist selection of ERAs
        ; Parameters found in ^TMP("RCERA_PARAMS",$J)
        N OK,RCPOST,RCMATCH,RCDFR,RCDTO,RCPAYFR,RCPAYTO,RCPAYR,RC0
        S OK=1,RC0=$G(^RCY(344.4,Y,0))
        ;
        S RCMATCH=$G(^TMP("RCERA_PARAMS",$J,"RCMATCH")),RCPOST=$G(^TMP("RCERA_PARAMS",$J,"RCPOST"))
        S RCDFR=+$P($G(^TMP("RCERA_PARAMS",$J,"RCDT")),U),RCDTO=+$P($G(^TMP("RCERA_PARAMS",$J,"RCDT")),U,2)
        S RCPAYR=$P($G(^TMP("RCERA_PARAMS",$J,"RCPAYR")),U),RCPAYFR=$P($G(^TMP("RCERA_PARAMS",$J,"RCPAYR")),U,2),RCPAYTO=$P($G(^TMP("RCERA_PARAMS",$J,"RCPAYR")),U,3)
        ;
        ; If receipt exists, scratchpad must exist
        ;I $P(RC0,U,8),'$D(^RCY(344.49,+Y,0)) S OK=0 G FQ
        ; Post status
        I $S(RCPOST="B":0,RCPOST="U":$P(RC0,U,14),1:'$P(RC0,U,14)) S OK=0 G FQ
        ; Match status
        I $S(RCMATCH="B":0,RCMATCH="N":$P(RC0,U,9),1:'$P(RC0,U,9)) S OK=0 G FQ
        ; dt rec'd range
        I $S(RCDFR=0:0,1:$P(RC0,U,7)\1<RCDFR) S OK=0 G FQ
        I $S(RCDTO=DT:0,1:$P(RC0,U,7)\1>RCDTO) S OK=0 G FQ
        ; Payer name
        I RCPAYR'="A" D  G:'OK FQ
        . N Q
        . S Q=$$UPPER^RCDPEWL7($P(RC0,U,6))
        . I $S(Q=RCPAYFR:1,Q=RCPAYTO:1,Q]RCPAYFR:RCPAYTO]Q,1:0) Q
        . S OK=0
FQ      Q OK
        ;
SPLIT   ; Split line in ERA list
        N RCLINE,RCZ,RCDA,Q,Q0,Z,Z0,DIR,X,Y,CT,L,L1,RCONE,RCQUIT
        D FULL^VALM1
        I $G(RCSCR("NOEDIT")) D NOEDIT^RCDPEWL G SPLITQ
        W !!,"SELECT THE ENTRY THAT HAS A LINE YOU NEED TO SPLIT/EDIT",!
        D SEL^RCDPEWL(.RCDA)
        S Z=+$O(RCDA(0)) G:'$G(RCDA(Z)) SPLITQ
        S RCLINE=+RCDA(Z),Z0=+$O(^TMP("RCDPE-EOB_WLDX",$J,Z_".999"),-1)
        S RCZ=Z F  S RCZ=$O(^TMP("RCDPE-EOB_WLDX",$J,RCZ)) Q:'RCZ!(RCZ\1'=Z)  D
        . S Q=$P($G(^TMP("RCDPE-EOB_WLDX",$J,RCZ)),U,2)
        . Q:'Q
        . S RCZ(RCZ)=Q
        . S Q0=0 F  S Q0=$O(^RCY(344.49,RCSCR,1,Q,1,Q0)) Q:'Q0  I "01"[$P($G(^(Q0,0)),U,2) K RCZ(RCZ) Q
        I '$O(RCZ(0)) D  G SPLITQ
        . S DIR(0)="EA",DIR("A",1)="THIS ENTRY HAS NO LINES AVAILABLE TO EDIT/SPLIT",DIR("A")="PRESS RETURN TO CONTINUE " W ! D ^DIR K DIR
        S RCQUIT=0
        I $P($G(^RCY(344.49,RCSCR,1,RCLINE,0)),U,13) D  G:RCQUIT SPLITQ
        . S DIR("A",1)="WARNING!  THIS LINE HAS ALREADY BEEN VERIFIED",DIR("A")="ARE YOU SURE YOU WANT TO CONTINUE?: ",DIR(0)="YA",DIR("B")="NO" W ! D ^DIR K DIR
        . I Y'=1 S RCQUIT=1
        S CT=0,CT=CT+1,DIR("?",CT)="Enter the line # that you want to split or edit:",RCONE=1
        S L=Z F  S L=$O(RCZ(L)) Q:'L  D
        . S L1=+$G(^TMP("RCDPE-EOB_WLDX",$J,L))
        . S CT=CT+1
        . S DIR("?",CT)=$G(^TMP("RCDPE-EOB_WL",$J,L1,0)),CT=CT+1,DIR("?",CT)=$G(^TMP("RCDPE-EOB_WL",$J,L1+1,0)) S RCONE(1)=$S(RCONE:L,1:"") S RCONE=0
        S DIR("?")=" ",Y=-1
        I $G(RCONE(1)) S Y=+RCONE(1) K DIR G:'Y SPLITQ
        I '$G(RCONE(1)) D  K DIR I $D(DTOUT)!$D(DUOUT)!(Y\1'=Z) G SPLITQ
        . F  S DIR(0)="NAO^"_(Z+.001)_":"_Z0_":3",DIR("A")="WHICH LINE OF ENTRY "_Z_" DO YOU WANT TO SPLIT/EDIT?: " S:$G(RCONE(1))'="" DIR("B")=RCONE(1) D ^DIR Q:'Y!$D(DUOUT)!$D(DTOUT)  D  Q:Y>0
        .. I '$D(^TMP("RCDPE-EOB_WLDX",$J,Y)) W !!,"LINE "_Y_" DOES NOT EXIST - TRY AGAIN",! S Y=-1 Q
        .. I '$D(RCZ(Y)) W !!,"LINE "_Y_" HAS BEEN USED IN A DISTRIBUTE ADJ ACTION AND CAN'T BE EDITED",! S Y=-1 Q
        .. S Q=+$O(^RCY(344.49,RCSCR,1,"B",Y,0))
        ;
        K ^TMP("RCDPE_SPLIT_REBLD",$J)
        D SPLIT^RCDPEWL3(RCSCR,+Y)
        I $G(^TMP("RCDPE_SPLIT_REBLD",$J)) K ^TMP("RCDPE_SPLIT_REBLD",$J) D BLD^RCDPEWL1($G(^TMP($J,"RC_SORTPARM")))
        ;
SPLITQ  S VALMBCK="R"
        Q
        ;
PRTERA  ; View/prt
        N DIC,X,Y,RCSCR
        S DIC="^RCY(344.4,",DIC(0)="AEMQ" D ^DIC
        Q:Y'>0
        S RCSCR=+Y
        D PRERA1
        Q
        ;
PRERA   ; RCSCR is assumed to be defined
        D FULL^VALM1 ; Protocol entry
PRERA1  ; Option entry
        N %ZIS,ZTRTN,ZTSAVE,ZTDESC,POP,DIR,X,Y,RCERADET
        S DIR("?",1)="INCLUDING EXPANDED DETAIL WILL SIGNIFICANTLY INCREASE THE SIZE OF THIS REPORT",DIR("?",2)="IF YOU CHOOSE TO INCLUDE IT, ALL PAYMENT DETAILS FOR EACH EEOB WILL BE"
        S DIR("?")="LISTED.  IF YOU WANT JUST SUMMARY DATA FOR EACH EEOB, DO NOT INCLUDE IT."
        S DIR(0)="YA",DIR("A")="DO YOU WANT TO INCLUDE EXPANDED EEOB DETAIL?: ",DIR("B")="NO" W ! D ^DIR K DIR
        I $D(DUOUT)!$D(DTOUT) G PRERAQ
        S RCERADET=+Y
        S %ZIS="QM" D ^%ZIS G:POP PRERAQ
        I $D(IO("Q")) D  G PRERAQ
        . S ZTRTN="VPERA^RCDPEWL0("_RCSCR_","_RCERADET_")",ZTDESC="AR - Print ERA From Worklist"
        . D ^%ZTLOAD
        . W !!,$S($D(ZTSK):"Your task # "_ZTSK_" has been queued.",1:"Unable to queue this job.")
        . K ZTSK,IO("Q") D HOME^%ZIS
        U IO
        D VPERA(RCSCR,RCERADET)
        Q
        ;
VPERA(RCSCR,RCERADET)   ; Queued entry
        ; RCSCR = ien of entry in file 344.4
        ; RCERADET = 1 if inclusion of all EOB details from file 361.1 is
        ;  desired, 0 if not
        N Z,Z0,RCSTOP,RCZ,RCPG,RCDOT,RCDIQ,RCDIQ1,RCDIQ2,RCXM1,RC,RCSCR1,RC3611
        K ^TMP($J,"RC_SUMRAW"),^TMP($J,"RC_SUMOUT"),^TMP($J,"RC_SUMALL")
        S (RCSTOP,RCPG)=0,RCDOT="",$P(RCDOT,".",79)=""
        D GETS^DIQ(344.4,RCSCR_",","*","IEN","RCDIQ")
        D TXT0^RCDPEX31(RCSCR,.RCDIQ,.RCXM1,.RC) ; Get top level 0-node captioned flds
        I $O(^RCY(344.4,RCSCR,2,0)) S RC=RC+1,RCXM1(RC)="  **ERA LEVEL ADJUSTMENTS**"
        S RCSCR1=0 F  S RCSCR1=$O(^RCY(344.4,RCSCR,2,RCSCR1)) Q:'RCSCR1  D
        . K RCDIQ2
        . D GETS^DIQ(344.42,RCSCR1_","_RCSCR_",","*","IEN","RCDIQ2")
        . D TXT2^RCDPEX31(RCSCR,RCSCR1,.RCDIQ2,.RCXM1,.RC) ; Get top level ERA adjs
        S RCSCR1=0 F  S RCSCR1=$O(^RCY(344.4,RCSCR,1,RCSCR1)) Q:'RCSCR1  D
        . K RCDIQ1
        . D GETS^DIQ(344.41,RCSCR1_","_RCSCR_",","*","IEN","RCDIQ1")
        . D TXT00^RCDPEX31(RCSCR,RCSCR1,.RCDIQ1,.RCXM1,.RC)
        . S RC=RC+1,RCXM1(RC-1)=$E("PATIENT: "_$$PNM4^RCDPEWL1(RCSCR,RCSCR1)_$J("",41),1,41)_"CLAIM #: "_$$BILLREF^RCDPESR0(RCSCR,RCSCR1),RCXM1(RC)=" "
        . D PROV^RCDPEWLD(RCSCR,RCSCR1,.RCXM1,.RC)
        . S RC3611=$P($G(^RCY(344.4,RCSCR,1,RCSCR1,0)),U,2)
        . I RCERADET D
        .. I 'RC3611 D  Q
        ... D DISP^RCDPESR0("^RCY(344.4,"_RCSCR_",1,"_RCSCR1_",1)","^TMP($J,""RC_SUMRAW"")",1,"^TMP($J,""RC_SUMOUT"")",75,1)
        ..;
        .. E  D  ; Detail record is in 361.1
        ... K ^TMP("PRCA_EOB",$J)
        ... D GETEOB^IBCECSA6(RC3611,2)
        ... I $O(^IBM(361.1,RC3611,"ERR",0)) D GETERR^RCDPEDS(RC3611,+$O(^TMP("PRCA_EOB",$J,RC3611," "),-1)) ; get filing errors
        ... S Z=0 F  S Z=$O(^TMP("PRCA_EOB",$J,RC3611,Z)) Q:'Z  S RC=RC+1,^TMP($J,"RC_SUMOUT",RC)=$G(^TMP("PRCA_EOB",$J,RC3611,Z))
        ... S RC=RC+2,^TMP($J,"RC_SUMOUT",RC-1)=" ",^TMP($J,"RC_SUMOUT",RC)=" "
        ... K ^TMP("PRCA_EOB",$J)
        . I $D(RCDIQ1(344.41,RCSCR1_","_RCSCR_",",2)) D
        .. S RC=RC+1,RCXM1(RC)="  **EXCEPTION RESOLUTION LOG DATA**"
        .. S Z=0 F  S Z=$O(RCDIQ1(344.41,RCSCR1_","_RCSCR_",",2,Z)) Q:'Z  S RC=RC+1,RCXM1(RC)=RCDIQ1(344.41,RCSCR1_","_RCSCR_",",2,Z)
        . S RC=RC+1,RCXM1(RC)=" "
        . S Z0=+$O(^TMP($J,"RC_SUMALL"," "),-1)
        . S Z=0 F  S Z=$O(RCXM1(Z)) Q:'Z  S Z0=Z0+1,^TMP($J,"RC_SUMALL",Z0)=RCXM1(Z)
        . K RCXM1 S RC=0
        . S Z=0 F  S Z=$O(^TMP($J,"RC_SUMOUT",Z)) Q:'Z  S Z0=Z0+1,^TMP($J,"RC_SUMALL",Z0)=$G(^TMP($J,"RC_SUMOUT",Z))
        S RCSTOP=0,Z=""
        F  S Z=$O(^TMP($J,"RC_SUMALL",Z)) Q:'Z  D  Q:RCSTOP
        . I $D(ZTQUEUED),$$S^%ZTLOAD S (RCSTOP,ZTSTOP)=1 K ZTREQ I +$G(RCPG) W !!,"***TASK STOPPED BY USER***" Q
        . I 'RCPG!(($Y+5)>IOSL) D  I RCSTOP Q
        .. D:RCPG ASK(.RCSTOP) I RCSTOP Q
        .. D HDR(.RCPG)
        . W !,$G(^TMP($J,"RC_SUMALL",Z))
        ;
        I 'RCSTOP,RCPG D ASK(.RCSTOP)
        ;
        I $D(ZTQUEUED) S ZTREQ="@"
        I '$D(ZTQUEUED) D ^%ZISC
        ;
PRERAQ  K ^TMP($J,"RC_SUMRAW"),^TMP($J,"RC_SUMOUT"),^TMP($J,"SUMALL")
        S VALMBCK="R"
        Q
        ;
HDR(RCPG)       ;Report hdr
        ; RCPG = last page #
        I RCPG!($E(IOST,1,2)="C-") W @IOF,*13
        S RCPG=$G(RCPG)+1
        W !,?5,"EDI LOCKBOX WORKLIST - ERA DETAIL",?55,$$FMTE^XLFDT(DT,2),?70,"Page: ",RCPG,!,$TR($J("",IOM)," ","=")
        Q
        ;
ASK(RCSTOP)     ;
        I $E(IOST,1,2)'["C-" Q
        N DIR,DIROUT,DIRUT,DTOUT,DUOUT
        S DIR(0)="E" W ! D ^DIR
        I ($D(DIRUT))!($D(DUOUT)) S RCSTOP=1 Q
        Q
        ;
