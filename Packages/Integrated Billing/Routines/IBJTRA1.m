IBJTRA1 ;ALB/AAS,ARH - TPI CT INSURANCE COMMUNICATIONS BUILD ; 4/1/95
        ;;2.0;INTEGRATED BILLING;**39,91,347,389**;21-MAR-94;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; copyed from IBTRC with modifications to show reviews for multiple events
        ;
        ;
BLD     ; -- Build list of Insurance contacts, including reviews, appeals, and denials
        K ^TMP("IBJTRA",$J),^TMP("IBJTRADX",$J),IBJTA1,IBJTA2
        N X,IBI,IBJ,J,IBTRC,IBTRCD,IBTRCD1,IBJTEVNT,IBCNT,IBTRN,IBTRND,IBETYP,IBBEG
        S VALMSG=$$MSG^IBTUTL3(DFN)
        S (IBTRC,IBCNT,VALMCNT)=0,IBI=""
        D IFNTRN^IBJTU5(IBIFN,.IBJTA1,.IBJTA2)
        I 'IBJTA1 S IBCNT=1 D SET1(" ") S IBCNT=2 D SET1("No Claims Tracking Entries.") G BLDQ
        S IBJ=0 F  S IBJ=$O(IBJTA2(IBJ)) Q:'IBJ  S IBTRN=IBJTA2(IBJ) D
        .S IBTRND=$G(^IBT(356,IBTRN,0))
        .S IBJTEVNT="    "_$$EVNT(IBTRND)
        .F  S IBI=$O(^IBT(356.2,"ATIDT",IBTRN,IBI)) Q:'IBI  S IBTRC=0 F  S IBTRC=$O(^IBT(356.2,"ATIDT",IBTRN,IBI,IBTRC)) Q:'IBTRC  D
        ..S IBTRCD=$G(^IBT(356.2,+IBTRC,0))
        ..S IBTRCD1=$G(^IBT(356.2,+IBTRC,1))
        ..Q:'+$P(IBTRCD,"^",19)  ;quit if inactive
        ..S IBCNT=IBCNT+1
        ..I IBJTEVNT'="" D SET(" ",0),SET(IBJTEVNT,0) S IBJTEVNT=""
        ..S IBETYP=$G(^IBE(356.11,+$P(IBTRCD,"^",4),0))
        ..W "."
        ..S X=""
        ..S X=$$SETFLD^VALM1(IBCNT,X,"NUMBER")
        ..S X=$$SETFLD^VALM1($P($$DAT1^IBOUTL(+IBTRCD,"2P")," "),X,"DATE")
        ..S X=$$SETFLD^VALM1($P($G(^DIC(36,+$P(IBTRCD,"^",8),0)),"^"),X,"INS CO")
        ..S X=$$SETFLD^VALM1($$EXPAND^IBTRE(356.2,.11,$P(IBTRCD,"^",11)),X,"ACTION")
        ..;
        ..S X=$$SETFLD^VALM1($P(IBETYP,"^",3),X,"TYPE")
        ..S X=$$SETFLD^VALM1($P(IBTRCD,"^",28),X,"PRE-CERT")
        ..I $P(IBTRCD,"^",13) S X=$$SETFLD^VALM1($J($$DAY^IBTUTL3($P(IBTRCD,"^",12),$P(IBTRCD,"^",13),IBTRN),3),X,"DAYS")
        ..I $P($G(^IBE(356.7,+$P(IBTRCD,"^",11),0)),"^",3)=20 S X=$$SETFLD^VALM1($J($$DAY^IBTUTL3($P(IBTRCD,"^",15),$P(IBTRCD,"^",16),IBTRN),3),X,"DAYS")
        ..I $P(IBTRCD1,"^",7)!($P(IBTRCD1,"^",8)) S X=$$SETFLD^VALM1("ALL",X,"DAYS")
        ..S X=$$SETFLD^VALM1($P(IBTRCD,"^",6),X,"CONTACT")
        ..S X=$$SETFLD^VALM1($P(IBTRCD,"^",7),X,"PHONE")
        ..S X=$$SETFLD^VALM1($P(IBTRCD,"^",9),X,"REF NO")
        ..I $P(IBETYP,"^",2)=60!($P(IBETYP,"^",2)=65) D APPEAL^IBTRC3
        ..D SET(X,1)
        I 'IBCNT S IBCNT=1 D SET1(" ") S IBCNT=2 D SET1("No Insurance Reviews for Episodes on this Bill.") G BLDQ
BLDQ    K IBJTA1,IBJTA2
        Q
        ;
SET1(X) ; set array (no selection)
        S VALMCNT=VALMCNT+1
        S ^TMP("IBJTRA",$J,VALMCNT,0)=X
        Q
        ;
SET(X,Y)        ; -- set arrays
        S VALMCNT=VALMCNT+1
        S ^TMP("IBJTRA",$J,VALMCNT,0)=X
        S ^TMP("IBJTRA",$J,"IDX",VALMCNT,IBCNT)=""
        I +$G(Y) S ^TMP("IBJTRADX",$J,IBCNT)=VALMCNT_"^"_IBTRC
        Q
        ;
EVNT(IBTRND)    ; return line for display on event
        N X,Y,IBTYP S X="" I $G(IBTRND)="" G EVNTQ
        S IBTYP=+$P(IBTRND,U,18)
        S X=$$EXSET^IBJU1(IBTYP,356,.18)
        I IBTYP=2 S X=X_" of "_$P($G(^DIC(40.7,+$$SCE^IBSDU(+$P(IBTRND,U,4),3),0)),U,1)
        I IBTYP=3 S X=X_" of "_$P($$PIN^IBCSC5B(+$P(IBTRND,U,9)),U,2)
        I IBTYP=4 S X=X_" of "_$$FILE^IBRXUTL(+$P(IBTRND,U,8),.01)
        S X=X_" on "_$$DAT1^IBOUTL($P(IBTRND,U,6),"2P")
EVNTQ   Q X
