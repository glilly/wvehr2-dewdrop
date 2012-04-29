RMPRPIFD        ;PHX/RFM,RGB-DELETE ISSUE FROM STOCK ;8/27/07  07:27
        ;;3.0;PROSTHETICS;**139**;Feb 09, 1996;Build 4
        ; RVD #61 - phase III of PIP enhancement.
        ;
        ;Per VHA Directive 10-93-142, this routine should not be modified.
DEL1    ;ENTRY POINT TO DELETE AN ISSUE FROM STOCK
        K DIR N ITEMIEN,RITEM,ITEMCK,ITEMSTA,ITEMLOC
        S DIR("A")="Are you sure you want to DELETE this entry",DIR("B")="N",DIR(0)="Y"
        D ^DIR I $D(DTOUT)!$D(DUOUT)!$D(DIRUT) G EXIT
        I Y'=1 G CO^RMPRPIYE
        ;
DEL1A   ;ASK IF INACTIVE ITEM
        S ITEMSTA=$P(R1(0),U,10),ITEMLOC=$P(R1(1),U,5)
DEL1B   S ITEMIEN=$O(^RMPR(661.11,"ASHI",ITEMSTA,$P(RMIT,"-"),$P(RMIT,"-",2),0)) G:ITEMIEN="" DEL2 D  G:ITEMCK=0 EXIT G:ITEMCK=1 DEL2
        . S ITEMCK=0,RITEM=^RMPR(661.11,ITEMIEN,0)
        . I $P(RITEM,U,9)'=1 S ITEMCK=1 Q
        . S DIR("A")="Scanned item is inactive, reactivate?",DIR("B")="N",DIR(0)="Y"
        . D ^DIR I $D(DTOUT)!$D(DUOUT)!$D(DIRUT) S ITEMCK=0 Q
        . I Y'=1 S ITEMCK=1 Q
        . S $P(^RMPR(661.11,ITEMIEN,0),U,9)=0,$P(^RMPR(661.11,ITEMIEN,0),U,10)="",ITEMCK=2
        ;ask to reset ROP to zero
        S DIR("A")="Scanned item Is now ACTIVE, set ROP to zero?",DIR("B")="N",DIR(0)="Y"
        D ^DIR I $D(DTOUT)!$D(DUOUT)!$D(DIRUT) G DEL2
        I Y'=1 G DEL2
        I 'ITEMSTA!'ITEMLOC G DEL2
        S ITEMLOC=$P($G(^RMPR(661.6,ITEMLOC,0)),U,14) G:'ITEMLOC DEL2
        S ITEMIEN=$O(^RMPR(661.4,"ASLHI",ITEMSTA,ITEMLOC,$P(RMIT,"-"),$P(RMIT,"-",2),0)) G:'ITEMIEN DEL2
        S $P(^RMPR(661.4,ITEMIEN,0),U,4)=0
        ;
DEL2    ;call API for returning item to PIP
        K RITEM,ITEMCK,ITEMIEN,ITEMSTA,ITEMLOC
        S (RMCHK,RMERPCE)=0
        S RMI68=$P($G(^RMPR(660,RMPRIEN,10)),U,1) I RMI68>0 D  I RMERPCE W !!,"** STOCK ISSUE DELETE ABORTED",!! G EXIT
        .S RMCHK=$$DEL^RMPRPCED(RMPRIEN)
        .I RMCHK'=0 W !!,"*** ERROR in PCE DELETE, Please notify your IRM..660 IEN = ",RMPRIEN,!! S RMERPCE=1 H 3
        S RMPR60("IEN")=RMPRIEN
        S RMCHK=$$DEL^RMPRPIU3(.RMPR60)
        I $G(RMCHK) W !,"*** Error in API RMPRPIU3, ERROR = ",RMCHK,!,"*** Please inform your IRM !!",! G EXIT
        ;
        W $C(7),!?10,"Deleted..." H 1
EXIT    ;KILL VARIABLES AND EXIT ROUTINE
        I $G(RMPRIEN),$D(^RMPR(660,RMPRIEN)) L -^RMPR(660,RMPRIEN)
        K ^TMP($J) N RMPRSITE,RMPR D KILL^XUSCLEAN
        Q
        ;
