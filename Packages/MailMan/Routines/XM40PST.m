XM40PST ;ALB/JDG - XM*8.0*40 POST INIT: DOMAIN FILE UPDATE(#4.2); 04/26/10 ; 5/24/10 4:58pm
        ;;8.0;MAILMAN;**40**;26-APR-10;Build 11
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
EN      ;LOCATES IEN FOR THE LRN.VA.GOV DOMAIN AND STUFF'S A "CN" FOR CLOSE  AND NO-FORWARD INACTIVATING THE DOMAIN.
        ;
        N XMDOM,XMFLG
        S (XMDOM,XMFLG)=0
        D BMES^XPDUTL("Closing the LRN.VA.GOV domain...")
        S XMDOM=+$O(^DIC(4.2,"B","LRN.VA.GOV",XMDOM))  I XMDOM D
        .S XMFLG=1
        .S DR="1///CN"
        .S DIE="^DIC(4.2,",DA=XMDOM D ^DIE
        .D BMES^XPDUTL("Domain updated successfully!")
        .Q
        I 'XMFLG D BMES^XPDUTL("Unable to locate LRN.VA.GOV domain entry. Nothing updated.")
        K DIE,DA,DR,XMDOM,XMFLG
        Q
