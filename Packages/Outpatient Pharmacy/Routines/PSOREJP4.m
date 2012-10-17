PSOREJP4        ;BP/CMF - Pharmacy Rejects List Mail message 
        ;;7.0;OUTPATIENT PHARMACY;**289**;DEC 1997;Build 107
        ;; use of ^VADPT supported by IA#10061
        ;@author  - Chris Flegel
        ;@date    - August 18, 2008
        ;@version - 1.0
        Q
EN      ; entry point for background option
        N RESULT,C
        S RESULT=0
        D BEGIN
        I +$$LOAD() D SORT S RESULT=$$MAIL()
        D END
        Q
        ;;
BEGIN   ;
        K ^TMP($J,"PSOREJP4")
        Q
        ;;
END     ;
        K ^TMP($J,"PSOREJP4")
        Q
        ;;
BUFDATE(DIVISION)       ;
        Q:'$G(DIVISION) ""
        N RXDIVBUF,CUTDT
        D:'$D(^TMP($J,"PSOREJP4","DIVISION",DIVISION))
        .S RXDIVBUF=$$GET1^DIQ(52.86,DIVISION,4)
        .S ^TMP($J,"PSOREJP4","DIVISION",DIVISION)=RXDIVBUF
        S RXDIVBUF=+^TMP($J,"PSOREJP4","DIVISION",DIVISION)
        S RXDIVBUF=$S(RXDIVBUF=""!(RXDIVBUF<1):5,1:RXDIVBUF)
        S X1=DT,X2=-RXDIVBUF D C^%DTC S CUTDT=X
        Q CUTDT
        ;
LOAD()  ;;
        N RXIEN,REJECT,BUFDATE,REJDATE,COMDATE,DIVISION,COUNT,RXSTAT,RXDIV
        S COUNT=0
        S RXIEN=0
        F  S RXIEN=$O(^PSRX("REJSTS",0,RXIEN)) Q:'RXIEN  D
        .S REJECT=0
        .F  S REJECT=$O(^PSRX("REJSTS",0,RXIEN,REJECT)) Q:'REJECT  D
        ..S RXSTAT=$$GET1^DIQ(52,RXIEN,100,"I") Q:",10,12,13,14,15,"[(","_RXSTAT_",")  ;quit unless active
        ..S RXDIV=$$GET1^DIQ(52,RXIEN,20,"I"),DIVISION="",DIVISION=$O(^PS(52.86,"B",RXDIV,DIVISION))
        ..Q:'DIVISION
        ..S BUFDATE=$$BUFDATE(DIVISION)
        ..S REJDATE=$P(^PSRX(RXIEN,"REJ",REJECT,0),U,2),REJDATE=$P(REJDATE,".")
        ..Q:REJDATE>BUFDATE  ;;quit if reject date is newer than the cutoff date
        ..S COMDATE=""
        ..I $D(^PSRX(RXIEN,"REJ",REJECT,"COM")) S COMDATE=$O(^PSRX(RXIEN,"REJ",REJECT,"COM","B",COMDATE),-1),COMDATE=$P(COMDATE,".")  ;Get the last comments date
        ..;S COMDATE=$O(^PSRX(RXIEN,"REJ",REJECT,"COM","B",BUFDATE))
        ..Q:COMDATE>BUFDATE  ;don't put on the list if comment was defined after cutoff date
        ..S ^TMP($J,"PSOREJP4",DIVISION,RXIEN,REJECT)=RXSTAT
        ..S COUNT=COUNT+1
        Q COUNT
        ;;
SORT    ;;
        N DIVISION,RXIEN,RX,DRUGNAME,PATNAME,PATSSN,PATLAST4,REJECT,DFN,RXSTAT
        N ENTRYNUM,SORT,OUT,I,J,LINE,II,COMM1,COMM2
        K ^UTILITY($J,"W")
        S (DIVISION,ENTRYNUM)=0
        F  S DIVISION=$O(^TMP($J,"PSOREJP4",DIVISION)) Q:+DIVISION=0  D
        .S RXIEN=0
        .F  S RXIEN=$O(^TMP($J,"PSOREJP4",DIVISION,RXIEN)) Q:+RXIEN=0  D
        ..S REJECT=0
        ..F  S REJECT=$O(^TMP($J,"PSOREJP4",DIVISION,RXIEN,REJECT)) Q:'REJECT  D
        ...S DFN=$$GET1^DIQ(52,RXIEN,2,"I")
        ...S RXSTAT=$$GET1^DIQ(52,RXIEN,100)
        ...N VA,VADM,VAERR,SORT,OUT
        ...N RXIENS,REJIENS,REFIENS,RXNUM,RXFILL,I
        ...N FILLDATE,REJDATE,DETCDATE,RSNCODE,RSNTEXT
        ...D DEM^VADPT
        ...Q:+$G(VAERR)
        ...S PATNAME=VADM(1)
        ...S PATSSN=VA("PID")
        ...S PATLAST4=VA("BID")
        ...S SORT=PATNAME_U_PATSSN_U
        ...S RXNUM=$$GET1^DIQ(52,RXIEN,.01)
        ...S REJIENS=REJECT_","_RXIEN_","
        ...S RXFILL=$$GET1^DIQ(52.25,REJIENS,5)
        ...S SORT=SORT_RXNUM_U_(999-RXFILL)_U_(999-REJECT)
        ...S OUT=""
        ...S OUT=OUT_$$LJ^XLFSTR(RXNUM_"/"_RXFILL,13)
        ...S PATNAME=$E(PATNAME,1,12)_"("_PATLAST4_")"
        ...S PATNAME=$E(PATNAME,1,18)
        ...S OUT=OUT_$$LJ^XLFSTR(PATNAME,20)
        ...S DRUGNAME=$$GET1^DIQ(52,RXIEN,6)
        ...S DRUGNAME=$E(DRUGNAME,1,22)
        ...S OUT=OUT_$$LJ^XLFSTR(DRUGNAME,24)
        ...S REFIENS=RXFILL_","_RXIEN_","
        ...S FILLDATE=$S(RXFILL=0:$$GET1^DIQ(52,RXIEN,22,"I"),1:$$GET1^DIQ(52.1,REFIENS,.01,"I"))
        ...S FILLDATE=$$FMTE^XLFDT(FILLDATE,2)
        ...S OUT=OUT_$$LJ^XLFSTR(FILLDATE,10)
        ...S DETCDATE=$P($$GET1^DIQ(52.25,REJIENS,1,"I"),".")
        ...S DETCDATE=$$FMTE^XLFDT(DETCDATE,2)
        ...S OUT=OUT_$$LJ^XLFSTR(DETCDATE,8)
        ...S ^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT,0)=RXIEN_U_REJECT
        ...S ^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT,1)=OUT
        ...S OUT="     Rx Status: "_RXSTAT
        ...S ^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT,2)=OUT
        ...S RSNCODE=$$GET1^DIQ(52.25,REJIENS,.01)
        ...S OUT="     Reason:  "_RSNCODE
        ...S RSNCODE=$$FIND1^DIC(9002313.93,,,RSNCODE)
        ...S RSNTEXT=$$GET1^DIQ(9002313.93,RSNCODE_",",.02,"E")
        ...S ^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT,3)=OUT_" :"_RSNTEXT
        ...S LINE=3
        ...D:$D(^PSRX(RXIEN,"REJ",REJECT,"COM"))
        ....N DIWL,DIWR,X
        ....S LINE=LINE+1,COMM1=1
        ....S II=0
        ....F  S II=$O(^PSRX(RXIEN,"REJ",REJECT,"COM",II)) Q:'II  D
        .....N COMIENS,COMDATE,COMUSER,COMTEXT,TXT
        .....S DIWL=1,DIWR=60
        .....K ^UTILITY($J,"W")
        .....S COMIENS=II_","_REJECT_","_RXIEN_","
        .....S COMDATE=$$GET1^DIQ(52.2551,COMIENS,.01)
        .....S X=COMDATE
        .....S COMTEXT=$$GET1^DIQ(52.2551,COMIENS,2)
        .....S X=X_" - "_COMTEXT
        .....S COMUSER=$$GET1^DIQ(52.2551,COMIENS,1)
        .....S X=X_" ("_COMUSER_")"
        .....D ^DIWP
        .....S COMM2=0
        .....F J=1:1 Q:'$D(^UTILITY($J,"W",1,J,0))  D
        ......S TXT=^UTILITY($J,"W",1,J,0),COMM2=COMM2+1
        ......I COMM1=1 S OUT="   COMMENTS: -"_TXT
        ......E  S OUT="             "_$S(COMM2=1:"-",1:"")_TXT
        ......S ^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT,LINE)=OUT
        ......S LINE=LINE+1,(COMM2,COMM1)=COMM1+1
        .....K ^UTILITY($J,"W")
        ...S ^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT,LINE+1)=""
        ;derive entry number for message
        S DIVISION=0
        F  S DIVISION=$O(^TMP($J,"PSOREJP4",DIVISION)) Q:+DIVISION=0  D
        .S SORT=""
        .S ENTRYNUM=0
        .F  S SORT=$O(^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT)) Q:SORT']""  D
        ..S ENTRYNUM=ENTRYNUM+1
        ..S OUT=^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT,1)
        ..S ^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT,1)=$$RJ^XLFSTR(ENTRYNUM,3)_" "_OUT
        ;;
MAIL()  ;;
        N DIVISION,RESULT,COUNT,REJECT,I,SORT,COUNT
        S (DIVISION,RESULT)=0
        F  S DIVISION=$O(^TMP($J,"PSOREJP4",DIVISION)) Q:+DIVISION=0  D
        .N XMSUB,XMDUZ,XMTEXT,XMY
        .S XMSUB="ePharmacy - OPEN/UNRESOLVED REJECTS LIST for "_$$GET1^DIQ(52.86,DIVISION,.01)
        .S XMDUZ="OUTPATIENT PHARMACY PACKAGE"
        .S XMTEXT="^TMP($J,""PSOREJP4"",""MESSAGE"","
        .S XMY("G.PSO REJECTS BACKGROUND MESSAGE")=""
        .K ^TMP($J,"PSOREJP4","MESSAGE")
        .S ^TMP($J,"PSOREJP4","MESSAGE",1)="The prescriptions listed below are third party electronically billable and can"
        .S ^TMP($J,"PSOREJP4","MESSAGE",2)="not be filled until the rejection is resolved.  No action to resolve the"
        .S ^TMP($J,"PSOREJP4","MESSAGE",3)="rejection has taken place within the past "_^TMP($J,"PSOREJP4","DIVISION",DIVISION)_" days."
        .S ^TMP($J,"PSOREJP4","MESSAGE",4)=""
        .S ^TMP($J,"PSOREJP4","MESSAGE",5)="Please use the THIRD PARTY PAYER REJECTS WORKLIST option to resolve the"
        .S ^TMP($J,"PSOREJP4","MESSAGE",6)="rejection or add a comment to the rejection."
        .S ^TMP($J,"PSOREJP4","MESSAGE",7)=""
        .S ^TMP($J,"PSOREJP4","MESSAGE",8)="Unresolved rejects will not be sent to CMOP or the local print queue for"
        .S ^TMP($J,"PSOREJP4","MESSAGE",9)="filling.  They will continue to show on the rejects list until acted upon."
        .S ^TMP($J,"PSOREJP4","MESSAGE",10)=""
        .S ^TMP($J,"PSOREJP4","MESSAGE",11)="                                                             FILL      REJECT"
        .S ^TMP($J,"PSOREJP4","MESSAGE",12)="  # RX/FILL      PATIENT(ID)         DRUG                    DATE      DATE"
        .S ^TMP($J,"PSOREJP4","MESSAGE",13)="------------------------------------------------------------------------------"
        .S COUNT=14
        .S SORT=""
        .F  S SORT=$O(^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT)) Q:SORT']""  D
        ..S I=0
        ..F  S I=$O(^TMP($J,"PSOREJP4",DIVISION,"SORT",SORT,I)) Q:'I  S COUNT=COUNT+1,^TMP($J,"PSOREJP4","MESSAGE",COUNT)=^(I) D
        .D ^XMD
        .S:+$G(XMZ) RESULT=XMZ
        Q RESULT
