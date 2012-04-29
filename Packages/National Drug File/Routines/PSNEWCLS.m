PSNEWCLS        ;BIR/DMA-NOTIFY OF CLASS CHANGES ; 10 Sep 2008  1:21 PM
        ;;4.0; NATIONAL DRUG FILE;**176**; 30 Oct 98;Build 14
        ;
        ;Reference to UPDATE^GMRAUTL2 supported by DBIA #4667
        ;
        K ^TMP("PSN1",$J),^TMP("PSNN",$J) N CLASS,DA,DIE,DR,LIN,NC,OC,PR,PSDA,PSNG,PSNGD,PSNK,X,XMDUZ,XMSUB,XMTEXT,XMY
        S DA=0 F  S DA=$O(^TMP("PSN",$J,DA)) Q:'DA  S PSDA=^(DA,0) D
        .K CLASS S CLASS("D",$P(PSDA,"^",2))="",CLASS("A",$P(PSDA,"^",3))="",X=$P(PSDA,"^",4)_";PSNDF(50.6,^"_$P(^PSNDF(50.6,$P(PSDA,"^",4),0),"^")
        .S PSNG=$P(^PSNDF(50.68,DA,0),"^",2),PSNK=0,PSNGD=0 F  S PSNGD=$O(^PSNDF(50.6,"APRO",PSNG,PSNGD)) Q:'PSNGD  I $P(^PSNDF(50.68,PSNGD,3),"^")=$P(PSDA,"^",2) S PSNK=1 Q
        .I PSNK K CLASS("D")
        .D UPDATE^GMRAUTL2(X,,.CLASS)
        .S PR=$P(^PSNDF(50.68,+PSDA,0),"^"),OC=$P(^PS(50.605,$P(PSDA,"^",2),0),"^"),NC=$P(^PS(50.605,$P(PSDA,"^",3),0),"^"),^TMP("PSN1",$J,PR_"^"_OC_"^"_NC)=""
        ;
        S LIN=1,DA="" F  S DA=$O(^TMP("PSN1",$J,DA)) Q:DA=""  S ^TMP("PSNN",$J,LIN,0)="Product: "_$P(DA,"^"),^TMP("PSNN",$J,LIN+1,0)="Old Class: "_$P(DA,"^",2),^TMP("PSNN",$J,LIN+2,0)="New Class: "_$P(DA,"^",3),^TMP("PSNN",$J,LIN+3,0)=" ",LIN=LIN+4
        ;
        K XMY S XMY(DUZ)="",XMY("G.NDF DATA@"_^XMB("NETNAME"))="" S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
        S XMDUZ="NDF MANAGER",XMSUB="Products with changed classes",XMTEXT="^TMP(""PSNN"",$J," D ^XMD
        ;
        K CLASS,DA,DIE,DR,LIN,NC,OC,PR,PSDA,PSNG,PSNGD,PSNK,X,XMDUZ,XMSUB,XMTEXT,XMY,^TMP("PSN1",$J),^TMP("PSNN",$J) Q
