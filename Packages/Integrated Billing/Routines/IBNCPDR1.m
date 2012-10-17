IBNCPDR1        ;ALB/BDB - ROI MANAGEMENT ;30-NOV-07
        ;;2.0;INTEGRATED BILLING;**384**; 21-MAR-94;Build 74
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
EN      ; -- ROI Update
        D FULL^VALM1 W !!
        N IBDIF,DA,DR,DIC,DIE,DGSENFLG,IBEFF,IBROI
        L +^IBT(356.25,IBNCRPR):5 I '$T D LOCKED^IBTRCD1 G ROIQ
        S DIE="^IBT(356.25,",DA=IBNCRPR,DIE("NO^")="BACK",DR="@1;.05;S IBEFF=X;.06;I X<IBEFF W !,""   EXPIRATION DATE < EFFECTIVE DATE ??"" S Y=""@1"";I X>(IBEFF+10000) W !,""   EXPIRATION DATE > EFFECTIVE DATE + ONE YEAR??"" S Y=""@1"";.07;2.01"
        D ^DIE K DIC,DIE,DA,DR
        S IBDIF=0
        I $G(^IBT(356.25,IBNCRPR,0))'=$G(TMP("IBNCR",$J,"ROI0")) S IBDIF=1
        I $G(^IBT(356.25,IBNCRPR,1))'=$G(TMP("IBNCR",$J,"ROI1")) S IBDIF=1
        I $G(^IBT(356.25,IBNCRPR,2))'=$G(TMP("IBNCR",$J,"ROI2")) S IBDIF=1
        I IBDIF D UPDATE,BLD^IBNCPDR5
        L -^IBT(356.25,IBNCRPR)
        S ZTIO="",ZTRTN="CTCLN^IBNCPDR2",ZTSAVE("IBNCRPR")="",ZTDTH=$H,ZTDESC="IB - Make ROI Pharmacy entries in Claims Tracking billable"
        D ^%ZTLOAD K ZTSK,ZTIO,ZTSAVE,ZTDESC,ZTRTN
        ;D CTCLN^IBNCPDR2
ROIQ    S VALMBCK="R" Q
        ;
UPDATE  ; -- Update last edited by
        N DA,DIC,DIE,DR
        S DIE="^IBT(356.25,",DA=IBNCRPR,DR="1.03///NOW;1.04////"_DUZ
        D ^DIE
        S VALMBCK="R" Q
        ;
