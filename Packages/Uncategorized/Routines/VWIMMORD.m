VWIMMORD ;Prep Immunization Order data for HL7 Message creation ;
 ;;0.1;C0Q;nopatch;noreleasedate;
 ;  ^XTMP("VWIMMORD",0)=purge date^create date
 ;  ^XTMP("VWIMMORD",order_date,order#,item_name)=item_value
 ;  ^XTMP("VWIMMORD","LASTORDR")=last order processed
FIND ; Find the next set of immunization orders
 N X1,X2,X,%DT,%H,ORDT,ORDER,LASTORDR,SUBSC,DIR,ENTRY,FRSTORDR,PATIENT,IMM
 K ^TMP("VWIMMORD",$J)
 S (LASTORDR,FRSTORDR)=+$G(^XTMP("VWIMMORD","LASTORDR"))
 W !,"The ""Last Order"" from which to begin checking for Immunization orders is: ",LASTORDR
 S DIR("A")="Do you want to reset that value"
 S DIR(0)="Y",DIR("B")="NO" D ^DIR D:Y=1
 . S DIR("A")="What value shall be used?"
 . S DIR(0)="NO",DIR("B")=LASTORDR D ^DIR
 . I Y'?.N W !,"We'll skip reseting it then."
 . E  D
 . . S (LASTORDR,FRSTORDR)=+Y
 . . S X1=DT,X2=365 D C^%DTC
 . . S ^XTMP("VWIMMORD",0)=X_U_DT
 . . S ^XTMP("VWIMMORD","LASTORDR")=LASTORDR
 . . Q
 . Q
 S DIR("A")="Ready to prep more immunization orders for HL7 messages"
 S DIR(0)="Y",DIR("B")="YES" D ^DIR Q:Y'=1
 I '$D(^XTMP("VWIMMORD",0)) D
 . S X1=DT,X2=365 D C^%DTC
 . S ^XTMP("VWIMMORD",0)=X_U_DT
 . S ^XTMP("VWIMMORD","LASTORDR")=0
 S ORDER=^XTMP("VWIMMORD","LASTORDR")
 F  S ORDER=$O(^OR(100,ORDER)) Q:ORDER'>0  D
 . S LASTORDR=ORDER
 . D:$D(^OR(100,ORDER,4.5,"ID","ORZ HL7")) GOTONE
 . Q
 S ^XTMP("VWIMMORD","LASTORDR")=LASTORDR
 ; Now consolidate the orders by patient
 K ^XTMP("VWIMMPT") S ORDER=FRSTORDR F  S ORDER=$O(^XTMP("VWIMMORD",ORDER)) Q:ORDER'>0  M ^TMP("VWIMMORD",$J,^XTMP("VWIMMORD",ORDER,"PATIENT"),ORDER)=^XTMP("VWIMMORD",ORDER)
 S X1=DT,X2=365 D C^%DTC
 S ^XTMP("VWIMMPT",0)=X_U_DT
 S PATIENT="" F  S PATIENT=$O(^TMP("VWIMMORD",$J,PATIENT)) Q:PATIENT=""  D
 . S ORDER=0,IMM=0 F  S ORDER=$O(^TMP("VWIMMORD",$J,PATIENT,ORDER)) Q:ORDER'>0  D
 . . S IMM=IMM+1 
 . . S ^XTMP("VWIMMPT",DT,PATIENT,"PATIENT")=PATIENT
 . . S:$D(^TMP("VWIMMORD",$J,PATIENT,ORDER,"LOCATION")) ^XTMP("VWIMMPT",DT,PATIENT,"LOCATION")=^TMP("VWIMMORD",$J,PATIENT,ORDER,"LOCATION")
 . . S:$D(^TMP("VWIMMORD",$J,PATIENT,ORDER,"CVX")) ^XTMP("VWIMMPT",DT,PATIENT,IMM,"CVX")=^TMP("VWIMMORD",$J,PATIENT,ORDER,"CVX")
 . . S:$D(^TMP("VWIMMORD",$J,PATIENT,ORDER,"LOT")) ^XTMP("VWIMMPT",DT,PATIENT,IMM,"LOT")=^TMP("VWIMMORD",$J,PATIENT,ORDER,"LOT")
 . . S:$D(^TMP("VWIMMORD",$J,PATIENT,ORDER,"MFC")) ^XTMP("VWIMMPT",DT,PATIENT,IMM,"MFC")=^TMP("VWIMMORD",$J,PATIENT,ORDER,"MFC")
 . . S ^XTMP("VWIMMPT",DT,PATIENT,IMM,"ORDER")=ORDER
 . . S:$D(^TMP("VWIMMORD",$J,PATIENT,ORDER,"ORDEREDBY")) ^XTMP("VWIMMPT",DT,PATIENT,IMM,"ORDEREDBY")=^TMP("VWIMMORD",$J,PATIENT,ORDER,"ORDEREDBY")
 . . S:$D(^TMP("VWIMMORD",$J,PATIENT,ORDER,"ORDERTEXT")) ^XTMP("VWIMMPT",DT,PATIENT,IMM,"ORDERTEXT")=^TMP("VWIMMORD",$J,PATIENT,ORDER,"ORDERTEXT")
 . . S:$D(^TMP("VWIMMORD",$J,PATIENT,ORDER,"QUANTITY")) ^XTMP("VWIMMPT",DT,PATIENT,IMM,"QUANTITY")=^TMP("VWIMMORD",$J,PATIENT,ORDER,"QUANTITY")
 . . S:$D(^TMP("VWIMMORD",$J,PATIENT,ORDER,"TIME")) ^XTMP("VWIMMPT",DT,PATIENT,IMM,"TIME")=^TMP("VWIMMORD",$J,PATIENT,ORDER,"TIME")
 . . S:$D(^TMP("VWIMMORD",$J,PATIENT,ORDER,"UNITS")) ^XTMP("VWIMMPT",DT,PATIENT,IMM,"UNITS")=^TMP("VWIMMORD",$J,PATIENT,ORDER,"UNITS")
 . . Q
 . W !,"PATIENT: ",$P($G(^DPT(+PATIENT,0)),U) 
 . D EN^VWIMMH7(DT,PATIENT) ; Build & send the message
 . Q
 K ^TMP("VWIMMORD",$J)
 W !,"Done",!,"Last Order processed: ",LASTORDR,!
 Q
GOTONE ; Take the order number and move the relevant HL7 information into ^XTMP
 S ^XTMP("VWIMMORD",ORDER,"PATIENT")=$P(^OR(100,ORDER,0),U,2)
 S ^XTMP("VWIMMORD",ORDER,"LOCATION")=$P(^OR(100,ORDER,0),U,10)
 S ^XTMP("VWIMMORD",ORDER,"ORDEREDBY")=$P(^OR(100,ORDER,0),U,6)
 S ENTRY=0 F  S ENTRY=$O(^OR(100,ORDER,4.5,ENTRY)) Q:ENTRY'>0  D
 . S SUBSC=$P($G(^OR(100,ORDER,4.5,ENTRY,0)),U,4)
 . Q:'$L(SUBSC)
 . I SUBSC'="TIME" S ^XTMP("VWIMMORD",ORDER,SUBSC)=^OR(100,ORDER,4.5,ENTRY,1)
 . E  S X=^OR(100,ORDER,4.5,ENTRY,1),%DT="TS" D ^%DT S ^XTMP("VWIMMORD",ORDER,SUBSC)=Y
 . Q
 S ^XTMP("VWIMMORD",ORDER,"ORDERTEXT")=$G(^OR(100,ORDER,8,1,.1,1,0))
 Q
MAILSEND ; GET FILE DIRECTORY/NAME AND SEND
 N DIR,FNAME,TO
 S DIR(0)="F",DIR("A")="File name" D ^DIR
 S FNAME=X
 S DIR(0)="F",DIR("A")="Email address" D ^DIR
 S TO=X
 D LINE^C0CMIME(FNAME,TO)
 Q
