PPPGET2 ;ALB/DMB - PDX DATA EXTRACT ROUTINES ; 3/2/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**10**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
GETPDX(PDXPARRY,ARRYNM) ; Get the pdx pharmacy data and put it in arraynm
 ;
 ; This function extracts the needed pharmacy data from the
 ; PDX data file and stores it in ARRYNM.  It stores it sorted
 ; by last fill date with the most recent date first.
 ;
 ; Parameters:
 ;   PDXPARRY - Array containing the PDX Data File IFN's
 ;   ARRYNM - Name of array to store results in
 ;
 N DRUG,ERR,ISSUEDT,LFDT,PARMERR,QTY,RX,RXNUM,SIG,STANO,STATUS
 N XTARRY,RFNERR,XTRCTERR,STANAME,PROVIDER,TRANPTR,SEGPTR,X
 ;
 S PARMERR=-9001
 S RFNERR=-9009
 S XTRCTERR=-9010
 S ERR=0
 ;
 S XTARRY="^UTILITY(""VAQ"","_$J_")"
 ;
 I '$D(@PDXPARRY) Q PARMERR
 ;
 S X="VAQUPD25" X ^%ZOSF("TEST") I ('$T) Q RFNERR
 ;
 ;GET POINTER TO SEGMENT 'PDX*MPL' (MED PROFILE LONG)
 S SEGPTR=+$O(^VAT(394.71,"C","PDX*MPL",""))
 Q:('SEGPTR) XTRCTERR
 ;
 S STANAME=""
 F  S STANAME=$O(@PDXPARRY@(STANAME)) Q:(STANAME="")  D
 .S TRANPTR=$P(@PDXPARRY@(STANAME,0),"^",2) Q:(TRANPTR<1)
 .S STANO=$P($G(@PDXPARRY@(STANAME,0)),"^",3)
 .;EXTRACT INFO
 .K @XTARRY
 .S X=$$EXTARR^VAQUPD25(TRANPTR,SEGPTR,XTARRY,0)
 .I (+X) D  Q
 ..S TRANPTR=""
 ..S ERR=XTRCTERR
 .;GET NARRATIVE
 .S X=$G(@XTARRY@("VALUE",55,1,0)) S:(X'="") @ARRYNM@(0,STANAME)=X
 .;GET RX INFO
 .S RX=""
 .F  S RX=$O(@XTARRY@("ID",52,.01,RX)) Q:(RX="")  D
 ..S X=$G(@XTARRY@("VALUE",52,101,RX))
 ..S LFDT=$$E2IDT^PPPCNV1(X)
 ..S:(LFDT=-1) LFDT=""
 ..S X=$G(@XTARRY@("VALUE",52,1,RX))
 ..S ISSUEDT=$$E2IDT^PPPCNV1(X)
 ..S:(ISSUEDT=-1) ISSUEDT=""
 ..S RXNUM=$G(@XTARRY@("VALUE",52,.01,RX))
 ..S PROVIDER=$G(@XTARRY@("VALUE",52,4,RX))
 ..S PID=$G(@XTARRY@("VALUE",52,2,RX)) ;Dave B 14nov97
 ..S DRUG=$G(@XTARRY@("VALUE",52,6,RX))
 ..S QTY=$G(@XTARRY@("VALUE",52,7,RX))
 ..S SIG=$G(@XTARRY@("VALUE",52,10,RX)) S:$L(SIG)>100 SIG=$E(SIG,1,100)
 ..S STATUS=$G(@XTARRY@("VALUE",52,100,RX))
 ..S @ARRYNM@((9999999-LFDT),STANO,RX)=RXNUM_"^"_DRUG_"^"_STATUS_"^"_QTY_"^"_ISSUEDT_"^"_LFDT_"^"_SIG_"^"_STANAME_"^"_STANO_"^"_PROVIDER_"^"_PID
 ..;Next line added on 27Feb97 (Daveb)
 ..S @ARRYNM@((9999999-LFDT),STANO,"PID")=$G(^VAT(394.61,TRANPTR,"QRY")) ;Patient Name^SSN^DOB^SSN
 .K @XTARRY
 K @XTARRY
 Q ERR
