FBCHSCB ;AISC/GRR-SUPERVISOR RELEASE ;01JAN86
 ;;3.5;FEE BASIS;;JAN 30, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 D DT^DICRW
 I '$D(^FBAA(161.7,"AC","C")) W !!,*7,"There are no batches Pending Release!" Q
BT W !! S DIC="^FBAA(161.7,",DIC(0)="AEQZ",DIC("S")="I $P(^(0),U,15)=""Y"",$G(^(""ST""))=""C""" D ^DIC K DIC("S") G Q:X="^"!(X=""),BT:Y<0 S FBN=+Y,FZ=Y(0),FBTYPE=$P(FZ,"^",3),FBAAON=$P(FZ,"^",2),FBAAB=$P(FZ,"^")
 I $P(FZ,"^",18)["Y" W !!,*7,"This Batch is exempt from the Pricer!!!",!,"Please use the 'Release a Batch' option to forward this batch for payment." G Q
 S DA=FBN,DR="0;ST" W !! D EN^DIQ
RD S B=FBN S DIR(0)="Y",DIR("A")="Want line items listed",DIR("B")="NO" D ^DIR K DIR G BT:$D(DIRUT) D:Y LISTC
RDD S DIR(0)="Y",DIR("A")="Do you want to Release Batch as Correct",DIR("B")="NO" D ^DIR K DIR G BT:$D(DIRUT) I 'Y W !!,"Batch has NOT been Released!",*7 G BT
 S $P(FZ,"^",6)=DT,$P(FZ,"^",7)=DUZ,^FBAA(161.7,FBN,0)=FZ
 S DA=FBN,(DIC,DIE)="^FBAA(161.7,",DIC(0)="LQ",DR="11////^S X=""S""",DLAYGO=161.7 D ^DIE
 S DA=FBN,DR="0;ST",DIC="^FBAA(161.7," W !! D EN^DIQ W !!," Batch has been Released!" G BT
Q K B,J,K,L,M,X,Y,Z,DIC,FBN,A,A1,A2,BE,CPTDESC,D0,DA,DL,DR,DRX,DX,FBAACB,FBAACPT,FBAAON,FBAAOUT,FBVP,FBIN,DK,N,XY,FBINOLD,FBINTOT,FBTYPE,FZ,P3,P4,Q,S,T,V,VID,ZS,FBAAB,FBAAMT,FBAAOB,FBCOMM,FBAUT,FBSITE,I,X,Y,Z,FBERR,DIRUT,DUOUT,DTOUT
 K FBK,FBL,FBPDT,FBTD
 K DLAYGO,FBLISTC D END^FBCHDI Q
 ;
LISTC D HOME^%ZIS W @IOF
 D LISTC^FBAACCB1 Q
