PRCPCSO1 ;WISC/RFJ-surgery order supplies                           ;01 Sep 93
 ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q
 ;
 ;
AUTOORD ;  automatically create order
 N ORDERNO
 D SHOWCC^PRCPCSOU(OPCODE,0)
 S XP="Do you want to automatically create and add items to a new order"
 S XH="Enter 'YES' to automatically create an order with the items on it,",XH(1)="enter 'NO'  to select the order and items, or",XH(2)="enter '^'   to select a new patient and operation."
 W ! S %=$$YN^PRCPUYN(1)
 I %=2 Q
 I %'=1 S PRCPFLAG=1 Q
 W !!,"CREATING ORDER:"
 D NEWORDER^PRCPOPUS(PRCPPRIM) I '$G(X) S ORDERDA=0 Q
 S ORDERNO=X
 S ORDERDA=+$$ADDNEW^PRCPOPUS(ORDERNO,PRCPPRIM,PRCPSECO) I 'ORDERDA Q
 L +^PRCP(445.3,ORDERDA):5 I '$T D SHOWWHO^PRCPULOC(445.3,ORDERDA,0) S ORDERDA=0 Q
 D ADD^PRCPULOC(445.3,ORDERDA,0,"Ordering Surgical Supplies")
 ;  tie patient and operation to the order
 D PATLINK^PRCPCSOR(ORDERDA,PRCPPAT,PRCPSURG)
 W " NUMBER ",ORDERNO
 Q
