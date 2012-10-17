PRCPCROC        ;WISC/RFJ-operation code case cart link report ; 06/23/2009  2:14 PM
        ;;5.1;IFCAP;**136**;Oct 20, 2000;Build 6
        ;Per VHA Directive 2004-038, this routine should not be modified.
        D ^PRCPUSEL Q:'$G(PRCP("I"))
        N ALLCARTS,X
        K X S X(1)="The Operation Code-Case Cart Link Report will print a list of selected case carts displaying the operation codes linked to the case cart."
        D DISPLAY^PRCPUX2(40,79,.X)
        D CASECART^PRCPCRU1
        I '$O(^TMP($J,"PRCPCARTS",0)),'$D(ALLCARTS) Q
        W ! S %ZIS="Q" D ^%ZIS Q:POP  I $D(IO("Q")) D  D ^%ZTLOAD K IO("Q"),ZTSK D Q Q
        .   S ZTDESC="Operation Code-Case Cart Link Report",ZTRTN="DQ^PRCPCROC"
        .   S ZTSAVE("PRCP*")="",ZTSAVE("ALLCARTS")="",ZTSAVE("^TMP($J,""PRCPCARTS"",")="",ZTSAVE("ZTREQ")="@"
        W !!,"<*> please wait <*>"
DQ      ;  queue starts here
        N %I,CCDATA,CCITEM,CCNAME,DATA,NOW,ONHAND,OPCODE,PAGE,PRCPFLAG,PRCPINNM,PRCPINPT,SCREEN,X,Y
        D NOW^%DTC S Y=% D DD^%DT S NOW=Y,PAGE=1,SCREEN=$$SCRPAUSE^PRCPUREP U IO D H
        I $D(ALLCARTS) S CCITEM=0 F  S CCITEM=$O(^PRCP(445.7,CCITEM)) Q:'CCITEM!($G(PRCPFLAG))  D PRINT
        ;
        I '$D(ALLCARTS) S CCITEM=0 F  S CCITEM=$O(^TMP($J,"PRCPCARTS",CCITEM)) Q:'CCITEM  D PRINT
        I '$G(PRCPFLAG) D END^PRCPUREP
Q       D ^%ZISC K ^TMP($J,"PRCPCARTS")
        Q
        ;
        ;
PRINT   ;  print a case cart operation code link
        I $Y>(IOSL-6) D:SCREEN P^PRCPUREP Q:$D(PRCPFLAG)  D H
        S CCDATA=$G(^PRCP(445.7,CCITEM,0))
        S PRCPINPT=+$P(CCDATA,"^",2),PRCPINNM=$$INVNAME^PRCPUX1(PRCPINPT)
        S CCNAME=$$DESCR^PRCPUX1(PRCPINPT,CCITEM)
        S ONHAND=$P($G(^PRCP(445,PRCPINPT,1,CCITEM,0)),"^",7)
        W !!,$E(CCNAME,1,30),?32,CCITEM,?40,$E(PRCPINNM,1,20),?70,$J(ONHAND,10)
        S OPCODE=0 F  S OPCODE=$O(^PRCP(445.7,CCITEM,3,OPCODE)) Q:'OPCODE!($G(PRCPFLAG))  S DATA=$G(^(OPCODE,0)) D
        . N A
        . S A=$$ICPT^PRCPCUT1(OPCODE,$P(CCDATA,U,4)) W !,?5,$P(A,U),?12,$P(A,U,2)
        . I $Y>(IOSL-4) D:SCREEN P^PRCPUREP Q:$D(PRCPFLAG)  D H
        Q
        ;
        ;
H       S %=NOW_"  PAGE "_PAGE,PAGE=PAGE+1 I PAGE'=2!(SCREEN) W @IOF
        W $C(13),"OPERATION CODE-CASE CART LINK REPORT",?(80-$L(%)),%
        S %="",$P(%,"-",81)=""
        W !,"DESCRIPTION",?32,"MI#",?40,"ORDER FROM INV PT",?70,$J("QTY ONHAND",10),!,%
        Q
