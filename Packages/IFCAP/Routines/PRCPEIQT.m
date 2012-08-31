PRCPEIQT        ;WISC/RFJ-edit quantities, dueins, costs ; 5/4/99 3:40pm
V       ;;5.1;IFCAP;**124**;Oct 20, 2000;Build 2
        ;Per VHA Directive 10-93-142, this routine should not be modified.
        Q
        ;
        ;
QTY(PRCPINPT,ITEMDA)    ;  adjust primary or secondary quantity
        N %,ITEMDATA,ORDERNO,PRCPEIQT,PRCPID,QTY,REASON,VALUE,X,Y
        S ITEMDATA=$G(^PRCP(445,PRCPINPT,1,ITEMDA,0)) I ITEMDATA="" Q
        W !!?3,"QTY ON-HAND (in ",$$UNIT^PRCPUX1(PRCPINPT,ITEMDA," per "),"): ",+$P(ITEMDATA,"^",7)
        W !?10,"x",?16,"AVERAGE COST: ",$J(+$P(ITEMDATA,"^",22),0,3)
        W !?10,"=",?13,"INVENTORY VALUE: ",$J(+$P(ITEMDATA,"^",27),0,2),!
        S QTY=$$QTY^PRCPAWU0(-99999,99999) Q:QTY["^"
        W ! S VALUE=$$VALUE^PRCPAWU0(-9999999.99,9999999.99,"",0) Q:VALUE["^"
        S QTY=+QTY,VALUE=+VALUE I QTY=0,VALUE=0 Q
        W ! S REASON=$$REASON^PRCPAWU0("",1) Q:REASON["^"
        S ORDERNO=$$ORDERNO^PRCPUTRX(PRCPINPT)
        K PRCPEIQT S PRCPEIQT("QTY")=QTY,PRCPEIQT("INVVAL")=VALUE,PRCPEIQT("SELVAL")=0,PRCPEIQT("REASON")="0:"_REASON,PRCPEIQT("2237PO")=""
        D ITEM^PRCPUUIW(PRCPINPT,ITEMDA,"A",ORDERNO,.PRCPEIQT)
        Q
        ;
        ;
DUEIN(PRCPINPT,ITEMDA)  ;  change primary or secondary due-ins
        N %,%H,D,D0,D1,DA,DD,DDC,DDH,DI,DIC,DIE,DIX,DIY,DIZ,DO,DQ,DR,DZ,ITEMDATA,PRCPTYPE,X,Y,Z
        S ITEMDATA=$G(^PRCP(445,PRCPINPT,1,ITEMDA,0)) I ITEMDATA="" Q
        S PRCPTYPE=$P(^PRCP(445,PRCPINPT,0),"^",3)
        W !!?3,"QTY DUE-IN (in ",$$UNIT^PRCPUX1(PRCPINPT,ITEMDA," per "),"): ",$$GETIN^PRCPUDUE(PRCPINPT,ITEMDA),!
        S:'$D(^PRCP(445,PRCPINPT,1,ITEMDA,7,0)) ^(0)="^445.09P^^"
        S (DIC,DIE)="^PRCP(445,"_PRCPINPT_",1,",DA(1)=PRCPINPT,DA=ITEMDA,DR=$S(PRCPTYPE="S":8.1,1:20)
        D ^DIE
        I PRCPTYPE="S" Q
        S (X,Y)=0 F  S X=$O(^PRCP(445,PRCPINPT,1,ITEMDA,7,X)) Q:'X  S Y=Y+$P($G(^(X,0)),"^",2)
        S X=Y-$$GETIN^PRCPUDUE(PRCPINPT,ITEMDA) I X W !?5,"...total DUE-IN QUANTITY adjusted (by: ",X,") to: ",Y D SETIN^PRCPUDUE(PRCPINPT,ITEMDA,X),R^PRCPUREP
        Q
        ;
        ;
COSTEDIT(PRCPINPT,ITEMDA)       ;  edit last cost for invpt and item
        N %,D,D0,DA,DI,DIC,DIE,DQ,DR,DZ,X,X1,Y,Y1
CE1     S DA(1)=PRCPINPT,DA=ITEMDA,(DIC,DIE)="^PRCP(445,"_PRCPINPT_",1,",DR="4.7LAST COST;"
        D ^DIE
        S X1=$P(^PRCP(445,PRCPINPT,1,ITEMDA,0),"^",22),X=$P(^PRCP(445,PRCPINPT,1,ITEMDA,0),"^",15),Y=X1*1.1,Y1=X1/1.1
        I X>Y!(X<Y1) D
        . S Y="",DIR(0)="Y",DIR("B")="YES",DIR("A")="Re-Edit Last Cost"
        . S DIR("A",1)="** WARNING: Difference between last cost entered "
        . S DIR("A",2)="and average cost ("_X1_") is more than 10% **"
        . D ^DIR K DIR
        . I Y=1 S Y="YES"
        . Q
        I Y="YES" G CE1
        Q
