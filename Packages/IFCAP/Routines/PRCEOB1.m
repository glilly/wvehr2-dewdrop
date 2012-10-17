PRCEOB1 ;WISC/CTB/CLH-SUBROUTINES FOR PRCEOB ;2/10/92
V       ;;5.1;IFCAP;**148**;Oct 20, 2000;Build 5
        ;Per VHA Directive 2004-038, this routine should not be modified.
SCREEN  D HILO^PRCFQ,SW,SC Q
        Q
SW      ;SWITCH BOCS IF NECESSARY
        F I=6:1:9 S @("S"_I)=$P(TRNODE(3),"^",I)
        I S8=0!(S9=0) S S8="",S9=""
        I S6=0!(S7=0) S S6=S8,S7=S9,S8="",S9=""
        S $P(TRNODE(3),"^",6,9)=S6_"^"_S7_"^"_S8_"^"_S9 K S6,S7,S8,S9 Q
        ;
SC      ;DISPLAY SCREEN
        W @IOF,!?15,"1358 TRANSACTION - ",IOINHI,$P(TRNODE(0),"^"),IOINLOW
        W !!,"  COST CENTER: ",IOINHI,+$P(TRNODE(3),"^",3),IOINLOW,?IOM-4\2,"AMOUNT: ",IOINHI,"$ ",$J($P(TRNODE(4),"^"),0,2)
        W !!,IOINLOW,"BOC #1: ",IOINHI,+$P(TRNODE(3),"^",6),IOINLOW,?IOM-10\2,"AMOUNT #1: ",IOINHI,"$ "_$J($P(TRNODE(3),"^",7),0,2)
        I $P(TRNODE(3),"^",8,9)'="^" W !!,IOINLOW,"BOC #2: ",IOINHI,+$P(TRNODE(3),"^",8),?IOM-10\2,IOINLOW,"AMOUNT #2: ",IOINHI,"$ "_$J($P(TRNODE(3),"^",9),0,2)
        W !!,IOINLOW,"AUTHORITY: ",IOINHI,$P($G(^PRCS(410.9,+$P($G(TRNODE(11)),"^",4),0)),"^")," ",$P($G(^(0)),"^",2)
        W:$P($G(TRNODE(11)),"^",5) !,IOINLOW,"SUB: ",IOINHI,$P($G(^PRCS(410.9,+$P($G(TRNODE(11)),"^",5),0)),"^")," ",$P($G(^(0)),"^",2)
        W !,IOINLOW,"SERVICE START DATE: ",IOINHI,$$FMTE^XLFDT($P($G(TRNODE(1)),"^",6))
        W !,IOINLOW,"SERVICE END DATE: ",IOINHI,$$FMTE^XLFDT($P($G(TRNODE(1)),"^",7))
        W IOINORM Q:'$D(^PRCS(410,PRCFA("TRDA"),8,0))#2  W !!,IOINHI K ^UTILITY($J,"W") S DIWF="W",DIWL=1,DIWR=IOM*.75\1,N=0 F I=1:1 S N=$O(^PRCS(410,PRCFA("TRDA"),8,N)) Q:'N  S X=^(N,0) D DIWP^PRCUTL($G(DA))
        D ^DIWW,DIWKILL^PRCFQ W IOINORM Q
        S $P(^PRC(424,DA,0),"^",2,14)=X,DIK="^PRC(424," D IX1^DIK K DIK S %=1 Q
