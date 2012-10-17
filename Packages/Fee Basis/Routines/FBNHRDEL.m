FBNHRDEL        ;AISC/CMR - DELETION OF CNH RATE ; 1/20/10 3:45pm
        ;;3.5;FEE BASIS;**111**;JAN 30, 1995;Build 17
        ;;Per VHA Directive 10-93-142, this routine should not be modified.
CONTR   S DIC="^FBAA(161.21,",DIC(0)="AEMQ",DIC("A")="Select Contract: " D ^DIC K DIC Q:$D(DTOUT)!($D(DUOUT))!(Y=-1)
        S FBCIEN=+Y,FBCNUM=$P(Y,U,2)
        G END:'$D(^FBAA(161.21,FBCIEN,0)) S FBVIEN=$P(^(0),U,4),FBRATE=1
RATE    K FBX D DISPLAY^FBAAVD1 G END:'FBRATE
        ;S FBCTR=0 F FBI=1:1 S FBDRATE=$P(FBX,U,FBI) Q:'FBDRATE  I FBDRATE=FBRATE S FBCTR=FBCTR+1
        ;I FBCTR>1 G DEL
        ;If rate is not in use fall through to DEL, otherwise go to NODEL
        S FBART=0
        F  S FBART=$O(^FBAA(161.23,"AE",FBCNUM,FBART)) Q:'FBART  D
        .I FBART=FBRATE S FBRCK=1 Q
        I $G(FBRCK) K FBRCK G NODEL
DEL     S FBI=0,FBI=$O(^FBAA(161.22,"AD",FBCIEN,FBRATE,FBI)) G END:'FBI S DIK="^FBAA(161.22,",DA=FBI D ^DIK K DIK
        W !!,"Rate Deleted."
        ;
END     K FBCIEN,FBCNUM,Y,FBVIEN,FBRATE,FBCTR,FBI,FBDRATE,FBX,FBART,FBRCK,DUOUT,DTOUT,DA
        Q
NODEL   W !!,*7,"Rate is currently being used.  You CANNOT delete this rate!!",!
        G END
