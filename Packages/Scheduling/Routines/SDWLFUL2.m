SDWLFUL2        ;;IOFO BAY PINES/TEH - apply/RE-CAL ENROLLE STATUS;06/12/2002 ; 20 Aug 2002 2:10 PM
        ;;5.3;scheduling;**525**;AUG 13 1993;Build 47
        ;
        ;
        ;
        ;
        ;
        ;
        Q
EN      ;
        I '$D(^XTMP("SDWLFULSTAT",$J,4)) W !,"You must run OPTION 4 before OPTION 5." Q
        I $D(^XTMP("SDWLFULSTAT",$J,5)) W !,"You have already run this OPTION." Q
        S DIR(0)="Y",DIR("B")="NO"
        W !,"This Utility will APPLY the new ENROLLEE STATUS to your SD WAIT LIST file",!
        S DIR("A")="Are you sure that you wish to continue"
        D ^DIR I 'Y Q
        N SDWLDA,SDWLTF,SDWLAPI,SDWLVS,SDWLC,SDWLTFD,SDWLAPID,SDWLVSD,SDWLODT
        N SDWLCNT,SDWLIN
        N SDWLX S SDWLCNT=0
        S SDWLA=0 F  S SDWLA=$O(^SDWL(409.39,SDWLA)) Q:SDWLA<1  D
        .S SDWLX=$G(^SDWL(409.39,SDWLA,0)) I SDWLX="" Q
        .W !,SDWLA S SDWLCNT=SDWLCNT+1
        .S SDWLDA=$P(SDWLX,"^",10)
        .S SDWLTF=$P(SDWLX,U,2),SDWLAPI=$P(SDWLX,U,3)
        .S SDWLVS=$P(SDWLX,U,4),SDWLC=$P(SDWLX,U,5)
        .S SDWLTFD=$P(SDWLX,U,6),SDWLAPID=$P(SDWLX,U,7)
        .S SDWLVSD=$P(SDWLX,U,8),SDWLODT=$P(SDWLX,U,9),SDWLF=0
        .S SDWLXX=$P(SDWLX,"^",2,4) I SDWLXX["E" S SDWLSET="E" D SET S SDWLF=1 Q
        .I 'SDWLF,SDWLXX["P" S SDWLSET="P" D SET S SDWLF=1 Q
        .I 'SDWLF,SDWLXX["N" S SDWLSET="N" D SET S SDWLF=1 Q
        .I 'SDWLF S SDWLXX="U" S SDWLSET="U" D SET Q
END     K DA,DIE,DR,I,SDWLA,SDWLF,X,DA,DIE,DR,SDWLA,SDWLF,SDWLXX,SDWLSET,DIR
        W !,"All Records Processed."
        S ^XTMP("SDWLFULSTAT",$J,5)=""
MESS    ;SENT MESSAGE TO FORUM
        N XMSUB,XMY,XMTEXT,XMDUZ,SDWLMSG,SDWLI,XQSUB,Y
        S XMY("DERDERIAN.JOHN@FORUM.VA.GOV")=""
        S XMY("HOUTCHENS.THOMAS@FORUM.VA.GOV")=""
        S XMY("BROWN.BONNIE@FORUM.VA.GOV")=""
        S XMY("KROCHMAL.CHUCK@FORUM.VA.GOV")=""
        S XMY("TAPPER.BRIAN@FORUM.VA.GOV")=""
        S XMY("BENBOW.PHYLLIS@FORUM.VA.GOV")=""
        S XMY("LANDRIE.LARRY@FORUM.VA.GOV")=""
        S XMY("TOWSON.LINDA@FORUM.VA.GOV")=""
        S XMSUB="Patch SD*5.3*525 successful."
        S XQSUB="Installation of SD*5.3*525."
        S XMTEXT="SDWLMSG(",XMDUZ="POSTMASTER"
        S SDWLIN=$$GET1^DIQ(4,DUZ(2)_",",.01,,)
        S SDWLMSG(1,0)="Patch SD*5.3*525 successful installed at "_SDWLIN
        S Y=DT D DD^%DT
        S SDWLMSG(2,0)="At "_Y
        S SDWLMSG(3,0)=SDWLCNT_" Records had the Enrollee Status field updated."
        S SDWLMSG(4,0)="",SDWLMSG(0)=4
        D ^XMD
        Q
SET     S DR="27////^S X=SDWLSET",DIE="^SDWL(409.3,",DA=SDWLDA D ^DIE
        S DR="8.1////^S X=SDWLSET",DIE=409.39,DA=SDWLA D ^DIE
        Q
