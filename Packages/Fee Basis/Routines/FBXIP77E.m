FBXIP77E ;AISC/SS - PATCH FB*3.5*77 ENVIRONMENT CHECK ;03/29/04
 ;;3.5;Fee Basis;**77**;JAN 30, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
ENV ;
 ;this is the environment check pre-init routine
 I $$PATCH^XPDUTL("FB*3.5*42") D
 .N X,Y,DUOUT,DTOUT
 .W !,"You are a test site for a CoreFLS version (patch FB*3.5*42) of Fee Basis"
 .W !,"This patch has a conflict with the FB-CoreFLS test software."
 .W !,"It must NOT be installed unless an accompanying update is made to the"
 .W !,"FB-CoreFLS software immediately after installation of this patch."
 .W !
 .K DIR S DIR(0)="YA"
 .S DIR("A")="Do you have the corresponding update to the FB-CoreFLS software that is associated with this patch? (Note: Entering ""No"" here will stop the installation of this patch) Y/N//"
 .D ^DIR K DIR
 .I $D(DTOUT)!$D(DUOUT)!(Y'=1) W !,"Installation of this patch has been stopped!" S XPDQUIT=2 Q
 .W !,"OK to install!"
 Q
