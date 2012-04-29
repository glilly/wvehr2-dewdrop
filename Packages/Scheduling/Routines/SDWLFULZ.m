SDWLFULZ        ;;IOFO BAY PINES/TEH - CLEAN-UP ENROLLE STATUS;06/12/2002 ; 20 Aug 20022:10 PM
        ;;5.3;scheduling;**525**;AUG 13 1993;Build 47
        ;
        ;
        ;
        Q
EN      ;SD*5.3*525 POST INIT TO REMOVE PATCH COMPONENTS AND FILES.
        ;ROUTINE REMOVAL
        S DIR(0)="Y",DIR("B")="NO"
        W !,"This Utility will 'DELETE' all COMPONENTS of SD WAIT CLEAN-UP ENROLLEE MENU.",!
        S DIR("A")="Are you sure that you wish to continue"
        D ^DIR I 'Y Q
        N SDWLRTN,SDWLI,SDWLR,SDWLRX
        S SDWLRTN="SDWLFUL,SDWLFUL1,SDWLFUL2,SDWLFULP,SDWLFULU"
        F SDWLI=1:1:5 S SDWLR=$P(SDWLRTN,",",SDWLI) D
        .W !,"Removing ROUTINE: ",SDWLR
        .S SDWLRX="ZR  ZS @SDWLR" X SDWLRX
        W !!,"Routine deletion completed."
        ;REMOVE ^TMP("SDWLFUL") TMP("SDWLFUL1")
        W !,"File Deletion"
        K ^DISV(DUZ) S ^DISV(DUZ,"^DIC(")=409.39
        D ^DIU
        W !,"Deleting ^XTMP(""SDWLFUL"")" K ^XTMP("SDWLFUL")
        W !,"Deleting ^XTMP(""SDWLFUL1"")" K ^XTMP("SDWLFUL1")
        W !,"Deleting ^XTMP(""SDWLFULSTAT"")" K ^XTMP("SDWLFULSTAT")
        W !!,"Deleting SD WAIT CLEAN-UP ENROLLEE MENU"
        K DA,Y
        S DA=$$FIND1^DIC(19,"","MX","SD WAIT CLEAN-UP ENROLLEE MENU","","","ERR")
        I 'DA W !!,"Error unable to delete MENU." Q
        S DIK="^DIC(19," D ^DIK
        W !!,"SD WAIT CLEAN-UP ENROLLEE MENU deleted."
        K DIC,DIR,DA,DIK
        D MESS W !!,"Deletion completed."
        Q
MESS    ;SENT MESSAGE TO FORUM
        N XMSUB,XMY,XMTEXT,XMDUZ,SDWLMSG,SDWLI,XQSUB,Y
        S XMY("DERDERIAN.JOHN@FORUM.VA.GOV")=""
        S XMY("HOUTCHENS.THOMAS@FORUM.VA.GOV")=""
        S XMY("BROWN.BONNIE@FORUM.VA.GOV")=""
        S XMY("KROCHMAL.CHUCK@FORUM.VA.GOV")=""
        S XMY("TAPPER.BRIAN@FORUM.VA.GOV")=""
        S XMSUB="Patch components for SD*5.3*525 removed."
        S XQSUB="Components for SD*5.3*525 removed."
        S XMTEXT="SDWLMSG(",XMDUZ="POSTMASTER"
        S SDWLIN=$$GET1^DIQ(4,DUZ(2)_",",.01,,)
        S SDWLMSG(1,0)="EWL PATCH COMPONENTS FOR SD*5.3*525 HAVE BEEN REMOVED "_SDWLIN
        S Y=DT D DD^%DT
        S SDWLMSG(2,0)="At "_Y
        S SDWLMSG(3,0)=" EWL Patch components for SD*5.3*525 have been removed."
        S SDWLMSG(4,0)="",SDWLMSG(0)=4
        D ^XMD K SDWLIN
        Q
