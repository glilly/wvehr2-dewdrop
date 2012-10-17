IBCNERPG        ;BP/YMG - IBCNE EIV INSURANCE UPDATE REPORT COMPILE;16-SEP-2009
        ;;2.0;INTEGRATED BILLING;**416**;16-SEP-09;Build 58
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; variables from IBCNERPF:
        ;   IBCNERTN = "IBCNERPF"
        ;   IBCNESPC("BEGDT") = start date for date range
        ;   IBCNESPC("ENDDT") = end date for date range
        ;   IBCNESPC("PYR",ien) = payer iens for report, if IBCNESPC("PYR")="A", then include all
        ;   IBCNESPC("PAT",ien) = patient iens for report, if IBCNESPC("PAT")="A", then include all
        ;   IBCNESPC("SORT") = sort by: 1 - Payer name, 2 - Patient Name, 3 - Clerk Name
        ;   IBCNESPC("TYPE") = report type: "S" - summary, "D" - detailed
        ;
        ; Output variables passed to IBCNERPH:
        ;   Summary report:
        ;     ^TMP($J,IBCNERTN,SORT1,SORT2)=Count
        ;     SORT1 - Payer Name or *, SORT2 - Clerk Name or 0 if not processed
        ;
        ;   Detailed report:
        ;     ^TMP($J,IBCNERTN,SORT1)=Count 
        ;     ^TMP($J,IBCNERTN,SORT1,SORT2)=Pat. Name ^ SSN ^ Date received ^ Payer Name ^ Ck AB ^ Clerk Name ^ Date Verified ^ Days old
        ;     SORT1 - Payer Name, Patient Name, or Clerk Name, SORT2 - Date received
        ;
        Q
        ;
EN(IBCNERTN,IBCNESPC)   ; Entry point
        N ALLPYR,ALLPAT,DATE,BDATE,EDATE,RPDATA,RTYPE,SORT
        S ALLPYR=$S($G(IBCNESPC("PYR"))="A":1,1:0)
        S ALLPAT=$S($G(IBCNESPC("PAT"))="A":1,1:0)
        S BDATE=$G(IBCNESPC("BEGDT"))
        S EDATE=$G(IBCNESPC("ENDDT"))
        I EDATE'="",$P(EDATE,".",2)="" S EDATE=$$FMADD^XLFDT(EDATE,0,23,59,59)
        S RTYPE=$G(IBCNESPC("TYPE"))
        S SORT=$G(IBCNESPC("SORT"))
        I '$D(ZTQUEUED),$G(IOST)["C-" W !!,"Compiling report data ..."
        ; Kill scratch global
        K ^TMP($J,IBCNERTN)
        S DATE=$O(^IBCN(365,"AD",BDATE),-1)
        F  S DATE=$O(^IBCN(365,"AD",DATE)) Q:'DATE!(DATE>EDATE)  D PAYERS(DATE,ALLPYR,ALLPAT) Q:$G(ZTSTOP)
        M ^TMP($J,IBCNERTN)=RPDATA
        Q
        ;
PAYERS(DATE,ALLPYR,ALLPAT)      ; loop through payers
        N PYR
        S PYR=""
        I 'ALLPYR F  S PYR=$O(IBCNESPC("PYR",PYR)) Q:'PYR  D:$O(^IBCN(365,"AD",DATE,PYR,"")) PATIENTS(DATE,PYR,ALLPAT) Q:$G(ZTSTOP)
        I ALLPYR F  S PYR=$O(^IBCN(365,"AD",DATE,PYR)) Q:'PYR  D PATIENTS(DATE,PYR,ALLPAT) Q:$G(ZTSTOP)
        Q
        ;
PATIENTS(DATE,PYR,ALLPAT)       ; loop through patients
        N PAT
        S PAT=""
        I 'ALLPAT F  S PAT=$O(IBCNESPC("PAT",PAT)) Q:'PAT  D:$O(^IBCN(365,"AD",DATE,PYR,PAT,"")) GETDATA(DATE,PYR,PAT) Q:$G(ZTSTOP)
        I ALLPAT F  S PAT=$O(^IBCN(365,"AD",DATE,PYR,PAT)) Q:'PAT  D GETDATA(DATE,PYR,PAT) Q:$G(ZTSTOP)
        Q
        ;
GETDATA(DATE,PYR,PAT)   ; loop through responses and compile report
        N ABDATE,ABIEN,AUTOUPD,CHKAB,CLNAME,GIEN,IENS2,IENS312,INS,NOW,PATNAME,PYRNAME,RIEN,SORT1,SORT2,SSN,TOTMES,TQ,VDATE
        ;
        S NOW=$$NOW^XLFDT
        S (TOTMES,INS)=0
        S RIEN="" F  S RIEN=$O(^IBCN(365,"AD",DATE,PYR,PAT,RIEN)) Q:'RIEN  D  Q:$G(ZTSTOP)
        .S TOTMES=TOTMES+1 I $D(ZTQUEUED),TOTMES#100=0,$$S^%ZTLOAD() S ZTSTOP=1 Q
        .S TQ=+$P(^IBCN(365,RIEN,0),U,5) I TQ S INS=+$P(^IBCN(365.1,TQ,0),U,13)
        .I 'INS Q
        .S IENS2=PAT_",",IENS312=INS_","_IENS2
        .S VDATE=$$GET1^DIQ(2.312,IENS312,1.03,"I") I VDATE=""!(VDATE<BDATE)!(VDATE>EDATE) Q
        .S PYRNAME=$P(^IBE(365.12,PYR,0),U),PATNAME=$$GET1^DIQ(2,IENS2,.01,"E")
        .S AUTOUPD=+$$GET1^DIQ(2.312,IENS312,4.04,"I")
        .I AUTOUPD S CLNAME="AUTOUPDATE,IB-eIV"
        .I 'AUTOUPD S CLNAME=$$GET1^DIQ(2.312,IENS312,1.04,"E") I CLNAME="" S CLNAME="UNKNOWN"
        .I RTYPE="S" S SORT1=$S(ALLPYR:"*",1:PYRNAME),SORT2=CLNAME,RPDATA(SORT1,SORT2)=$G(RPDATA(SORT1,SORT2))+1 Q
        .S SSN=$$GET1^DIQ(2,IENS2,.09,"E")
        .S CHKAB="Y"
        .S GIEN=$$GET1^DIQ(2.312,IENS312,.18,"I"),ABIEN="",ABDATE=""
        .I +GIEN,$D(^IBA(355.4,"APY",GIEN)) S ABIEN=$O(^IBA(355.4,"APY",GIEN,$O(^IBA(355.4,"APY",GIEN,"")),""))
        .S:+ABIEN ABDATE=$P($G(^IBA(355.4,ABIEN,1)),U,3)
        .S:+ABDATE CHKAB=$S($$FMDIFF^XLFDT(NOW,ABDATE)>365:"Y",1:"N")
        .S SORT1=$S(SORT=1:PYRNAME,SORT=2:PATNAME,1:CLNAME),SORT2=DATE
        .S RPDATA(SORT1)=$G(RPDATA(SORT1))+1
        .S RPDATA(SORT1,SORT2)=PATNAME_U_SSN_U_DATE_U_PYRNAME_U_CHKAB_U_CLNAME_U_VDATE_U_$$FMDIFF^XLFDT(NOW,DATE)
        .Q
        Q
