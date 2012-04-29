PSABRKU3        ;BIR/JMB/PDW-Upload and Process Prime Vendor Invoice Data - CONT'D ;8/13/97
        ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**26,41,47,67**; 10/24/97;Build 15
        ;Checking the X12 invoice data.
        S (PSASTCNT,PSAITCNT,PSACTRL(1))=0
        K ^TMP($J,"PSAPV SET"),PSAERR
        S PSALAST=""
        S PSALINE=0 F  S PSALINE=$O(^TMP($J,"PSAPVS",PSALINE)) Q:PSALINE=""  S PSADATA=^(PSALINE) D
        .;check segment order
        .D ^PSABRKU5 S PSALAST=$P(PSADATA,"^")
ISA     .;control header
        .I PSALAST="ISA" D  Q
        ..S PSASTCNT=0
        ..S PSAISA=PSADATA,PSACTRL="" I $L($P(PSADATA,"^",14))'=9 S PSASEG="ISA" D MSG^PSABRKU8
        .;
IEA     .;control trailer
        .I PSALAST="IEA" D  Q
        ..I $P(PSADATA,"^",3)'=$P(PSAISA,"^",14) S PSASEG="IEA" D MSG^PSABRKU8
        .;
GS      .;group header
        .I PSALAST="GS" S PSAGS=PSADATA D  Q
        ..F %=3,4 S PSAPC=$S(%=3:7,1:9) I $P(PSADATA,"^",%)'=$TR($P(PSAISA,"^",PSAPC)," ") S PSASEG="GS" D MSG^PSABRKU8
        .;
GE      .;group trailer
        .I PSALAST="GE" D  Q
        ..I $P(PSADATA,"^",3)'=$P($G(PSAGS),"^",7) S PSASEG="GE" D MSG^PSABRKU8
        .;
ST      .;set header
        .I PSALAST="ST" D  Q
        ..S PSAST=PSADATA,PSACTRL=$P(PSADATA,"^",3),PSASTCNT=1,PSAITCNT=0,PSANTYPE=""
        ..I $L(PSACTRL)<4!($L(PSACTRL)>10) S PSASEG="ST" D MSG^PSABRKU8 Q
        .. I PSACTRL="0001" S PSACTRL=0 D RESETST
        ..;PSA*3*41 - McKesson probability of multiple files, may have to
        ..;increment transaction set control numbers in 'ST' & 'SE'
        ..I $D(^TMP($J,"PSAPV SET",PSACTRL,"IN")) D RESETST
        ..I $D(^XTMP("PSAPV",PSACTRL)) D RESETST ;may already be on file
        .;
SE      .;set trailer
        .I PSALAST="SE" S PSASTCNT=PSASTCNT+1 D  Q
        ..I $G(PSACTRL(1))'>0,$P(PSADATA,"^",3)'=PSACTRL S PSASEG="SE1" D MSG^PSABRKU8 Q
        ..I PSASTCNT'=$P(PSADATA,"^",2) S PSASEG="SE2" D MSG^PSABRKU8
        .;
BIG     .;beginning segment for invoice
        .I PSALAST="BIG" S PSASTCNT=PSASTCNT+1 D  Q
        ..I $P(PSADATA,"^",4)="" S $P(PSADATA,"^",4)=$P(PSADATA,"^",2)
        ..S $P(PSADATA,"^",5)=$TR($P(PSADATA,"^",5)," ")
        ..S ^TMP($J,"PSAPV SET",PSACTRL,"IN")=$P(PSADATA,"^",2,5)
        .;
REF     .;(not used)
        .I PSALAST="REF" S PSASTCNT=PSASTCNT+1 Q
        .;
        .;buyer, seller, shipping addresses
N1      .I PSALAST="N1" S PSASTCNT=PSASTCNT+1,PSANTYPE=$P(PSADATA,"^",2) D  Q
        ..I PSANTYPE'="BY",PSANTYPE'="DS",PSANTYPE'="ST" S PSASEG="N1" D MSG^PSABRKU8 Q
        ..S ^TMP($J,"PSAPV SET",PSACTRL,PSANTYPE)=$P(PSADATA,"^",3)
        .;
N2      .I PSALAST="N2" D  Q
        ..D:PSANTYPE="" NTYPE
        ..S $P(^TMP($J,"PSAPV SET",PSACTRL,PSANTYPE),"^",2)=$P(PSADATA,"^",2) S PSASTCNT=PSASTCNT+1
        .;
N3      .I PSALAST="N3" D  Q
        ..D:PSANTYPE="" NTYPE
        ..S $P(^TMP($J,"PSAPV SET",PSACTRL,PSANTYPE),"^",3)=$P(PSADATA,"^",2) S PSASTCNT=PSASTCNT+1
        .;
N4      .I PSALAST="N4" D  Q
        ..D:PSANTYPE="" NTYPE
        ..S $P(^TMP($J,"PSAPV SET",PSACTRL,PSANTYPE),"^",4,6)=$P(PSADATA,"^",2,4) S PSASTCNT=PSASTCNT+1,PSANTYPE=""
        .;
DTM     .;date time reference
        .I PSALAST="DTM" S PSASTCNT=PSASTCNT+1 D  Q
        ..S %=$S($P(PSADATA,"^",2)="002":5,$P(PSADATA,"^",2)="035":6,1:0) I '% Q
        ..S $P(^TMP($J,"PSAPV SET",PSACTRL,"IN"),"^",%)=$P(PSADATA,"^",3)
        .;
IT1     .;invoice line item
        .I PSALAST="IT1" S PSASTCNT=PSASTCNT+1,PSAITCNT=PSAITCNT+1 D ITEM Q
        .;BGN PSA*3*67
PID     .;generic vendor item name
        .I PSALAST="PID" S PSASTCNT=PSASTCNT+1,$P(^TMP($J,"PSAPV SET",PSACTRL,"IT",PSAITEM),"^",29)=$S($P(PSADATA,"^",6)=$P(^TMP($J,"PSAPV SET",PSACTRL,"IT",PSAITEM),"^",28):"Unknown",1:$P(PSADATA,"^",6)) Q
PO4     .;DESCRIPTION OF ITEM
        .I PSALAST="PO4" S PSASTCNT=PSASTCNT+1,$P(^TMP($J,"PSAPV SET",PSACTRL,"IT",PSAITEM),"^",30)=$P(PSADATA,"^",3)_"^"_$P(PSADATA,"^",9) D  Q
        .;END PSA*3*67
CTT     .;item count
        .I PSALAST="CTT" S PSASTCNT=PSASTCNT+1 D  Q
        ..I PSAITCNT'=$P(PSADATA,"^",2) S PSASEG="CTT" D MSG^PSABRKU8
        .;
UNKNOWN .;Segment we don't use
        .S PSASTCNT=PSASTCNT+1
        ;
ERROR   S PSASEG=$O(PSAERR("")) D:PSASEG'="" ERROR^PSABRKU8
        Q
        ;
NTYPE   S PSASEG="NONTYPE" D NONTYPE^PSABRKU8
        Q
        ;
ITEM    ;check line item
        I '$P(PSADATA,"^",2) S PSASEG="IT1-1" D MSG^PSABRKU8 Q
        I $P(PSADATA,"^",6)'="DS" S PSASEG="IT1-2" D MSG^PSABRKU8 Q
        I $P(PSADATA,"^",8)="",$P(PSADATA,"^",10)="",$P(PSADATA,"^",12)="" S PSASEG="IT1-3" D MSG^PSABRKU8 Q
        ;"IT1" Seg=Qty Invoiced ^ Unit of Measure ^ Unit Price ^ Basic Unit Code "DS" ^ NDC ^ VSN
        S PSAITEM=+$P(PSADATA,"^",2),^TMP($J,"PSAPV SET",PSACTRL,"IT",PSAITEM)=+$P(PSADATA,"^",3)_"^"_$P(PSADATA,"^",4)_"^"_$P(PSADATA,"^",5)_"^"_$P(PSADATA,"^",8)_"^"_$P(PSADATA,"^",10)
        I $P(PSADATA,"^",12)'="",$P(PSADATA,"^",11)="UP" S $P(^TMP($J,"PSAPV SET",PSACTRL,"IT",PSAITEM),"^",26)=$P(PSADATA,"^",12)
        ;Next line to add vendor Generic Description
        I $P(PSADATA,"^",14)'="" S $P(^TMP($J,"PSAPV SET",PSACTRL,"IT",PSAITEM),"^",28)=$P(PSADATA,"^",14)
        ;Eop67
        Q
RESETST ;Reset PSACTRL
        S PSACTRL(1)=+PSACTRL+1,X1=PSACTRL(1)
        S PSACTRL=X1 I $D(^TMP($J,"PSAPV SET",PSACTRL)) G RESETST
        I $D(^XTMP("PSAPV",PSACTRL)) G RESETST
        Q
