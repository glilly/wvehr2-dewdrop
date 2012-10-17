PRCH135P        ;VMP/RB - FIX XREF 'RB' FOR DUPLCATE ENTRIES #410 ;03/09/09
        ;;5.1;IFCAP;**135**;02/09/09;Build 7
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;;
        Q
FIX410  ;
        ;1. Post install to delete duplicate entries in x-rec 'RB' caused when
        ;   using option [CHANGE EXISTING TRANSACTION NUMBER] or when editing
        ;   incomplete orders to new FCP.
        ;
BUILD   K ^XTMP("PRCH135P") D NOW^%DTC S RMSTART=%
        S ^XTMP("PRCH135P","START COMPILE")=RMSTART
        S ^XTMP("PRCH135P","END COMPILE")="RUNNING"
        S ^XTMP("PRCH135P",0)=$$FMADD^XLFDT(RMSTART,120)_"^"_RMSTART
0       ;FIND DUPLICATE ENTRIES IN ^PRC(410,"RB") INDEX
        S REQNO="",IEN=0,U="^",DSH="-"
1       S REQNO=$O(^PRCS(410,"RB",REQNO)) G EXIT:REQNO=""!(REQNO]"@")
2       S IEN=$O(^PRCS(410,"RB",REQNO,IEN)) G 1:IEN=""
        ;BUILD 'RB' X-REF
        S R0=$G(^PRCS(410,IEN,0)) I R0="" S WDS="MISSING 0 NODE" G 3
        S R0REQ=$P(R0,U),QTRDT=$P(R0,U,11) G 2:QTRDT'>0
        S BREQ=QTRDT_DSH_$P(R0REQ,DSH)_DSH_$P(R0REQ,DSH,4)_DSH_$P(R0REQ,DSH,2)_DSH_$P(R0REQ,DSH,5)
        I REQNO=BREQ G 2
        S WDS="DUPLICATE RB" G 3
        G 2
3       S ^XTMP("PRCH135P",410,REQNO,IEN,0)=R0_";"_WDS
        K ^PRCS(410,"RB",REQNO,IEN)
        G 2
EXIT    ;
        D NOW^%DTC S RMEND=%
        S ^XTMP("PRCH135P","END COMPILE")=RMEND
        K RMEND,RMSTART,%,IEN,R0,REQNO,RBXREF,QTRDT,BREQ,DSH,R0REQ,WDS
        Q
