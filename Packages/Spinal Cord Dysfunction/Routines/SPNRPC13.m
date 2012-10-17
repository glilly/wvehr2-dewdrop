SPNRPC13        ;SD/WDE - RPC ADMISSIONS REPORT BY DATE RANGE;JUN 11, 2009
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ; Reference to ^DGPM("B" supported by IA# 92
        ; References to ^DGPM(D0,0 supported by IA# 4942
        ; Reference to file 2, field .01 supported by IA# 998
        ; Reference to file 2, field 57.4 supported by IA# 4938
        ; Reference to API ICDDX^ICDCODE supported by IA# 3990
        ; RETIRED AND REPLACED WITH IA# 3990 [Reference to ^ICD9(D0 supported by IA# 10082]
        ; RETIRED AND REPLACED WITH IA# 3990 [Reference to file 80 supported by IA# 10082]
        ; Reference to API IN5^VADPT supported by IA# 10061
        ; Reference to API DEM^VADPT supported by IA# 10061
        ;
EN1(ROOT,SPNDATE,SPNEDAT,PTLIST)        ; Main Entry Point
        ;=========================================================================
        ;PTLIST ICN;ICN;ICN...
        ;SPNDATE The earliest date of Admission for the print to START at.
        ;SPNEDAT the latest date of Admission for the print to END with.
        ;=========================================================================
        S ROOT=$NA(^TMP($J))
        K ^TMP($J),PTARRY,NOINLST
        S ICN=0 F ZYZ=1:1 S ICN=$P(PTLIST,"^",ZYZ) Q:ICN=""  D
        .S DFN=$$FLIP^SPNRPCIC(ICN)
        .I +DFN S PTARRY(DFN)=ICN
        K ICN,DFN,PTLIST
        S X=SPNDATE D ^%DT S SPNDATE=Y  ;START DATE
        S X=SPNEDAT D ^%DT S SPNEDAT=Y  ;END DATE
        S SPNEDAT=SPNEDAT_.999999       ;JAS 6/13/06 - TO EXTEND END DATE THRU END OF DAY
        S SPNCNT=0
        S ROOT=$NA(^TMP($J))
        ;K SPNA,SPNIEN,SPNLPRT,SPNQ,SPNQDAT,SPNDATE,VADM,VAIP,ZTSAVE
        K ^TMP($J),^TMP("SPN",$J)
        N SPNDFN,SPNX
        S (SPNDFN,SPNLPRT)=0
        S SPNQDAT=SPNDATE-.000001
        ;JAS 6/13/06  REMOVED 2ND SET OF SPNQDAT...THE 2ND SET MADE THE START DATE TOO EARLY
        ;S SPNQDAT=SPNDATE-000001 F  S SPNQDAT=$O(^DGPM("B",SPNQDAT)) Q:'+SPNQDAT  Q:(SPNQDAT>SPNEDAT)  D
        F  S SPNQDAT=$O(^DGPM("B",SPNQDAT)) Q:'+SPNQDAT  Q:(SPNQDAT>SPNEDAT)  D
        . S SPNIEN=0 F  S SPNIEN=$O(^DGPM("B",SPNQDAT,SPNIEN)) Q:'+SPNIEN  D:$P($G(^DGPM(SPNIEN,0)),U,2)=1
        .. S SPNDFN=$P(^DGPM(SPNIEN,0),U,3)
        .. N DFN,SPNLINE
        .. I '$D(PTARRY(SPNDFN)) Q  ;pt not passed in the list
        .. S DFN=SPNDFN,VAIP("E")=SPNIEN D IN5^VADPT
        .. ;JAS 2/8/07  ADDED ICN TO END OF PATIENT DETAIL AS REQUESTED IN DEFECT 796
        .. ; SPNLINE=Admission date(E)^Ward location(E)^Room-Bed(E)^Adm date^Pointer to PTF^ICN
        .. ;S SPNLINE=$P(VAIP(3),U,1)_U_$P(VAIP(5),U,2)_U_$P(VAIP(6),U,2)_U_SPNQDAT_U_VAIP(12)
        .. S SPNLINE=$P(VAIP(3),U,1)_U_$P(VAIP(5),U,2)_U_$P(VAIP(6),U,2)_U_SPNQDAT_U_VAIP(12)_U_PTARRY(SPNDFN)
        .. S ^TMP("SPN",$J,$$GET1^DIQ(2,SPNDFN,.01,"E"),SPNDFN,SPNIEN)=SPNLINE
        .. D KVAR^VADPT
        .. Q
        . Q
        I $D(^TMP("SPN",$J)) D
        . N SPNDFN,SPNNAME,SPNCOU
        . S SPNCOU=0
        . S SPNNAME="" F  S SPNNAME=$O(^TMP("SPN",$J,SPNNAME)) Q:SPNNAME=""  D
        .. S SPNDFN=0 F  S SPNDFN=$O(^TMP("SPN",$J,SPNNAME,SPNDFN)) Q:SPNDFN<1  D         ; NEWPAT(SPNDFN)  D
        ... S SPNIEN=0 F  S SPNIEN=$O(^TMP("SPN",$J,SPNNAME,SPNDFN,SPNIEN)) Q:SPNIEN<1  D
        .... S SPNLINE=^TMP("SPN",$J,SPNNAME,SPNDFN,SPNIEN)
        .... D NEWPAT(SPNDFN)
        .... D PATIENT(SPNDFN,SPNLINE)
        ... Q
        .. Q
        . Q
        S ROOT=$NA(^TMP($J))
        ;K ^TMP("SPN",$J)
        K SPNCNT,SPNA,SPNIEN,SPNLPRT,SPNQ,SPNQDAT,SPNDATE,VADM,VAIP,ZTSAVE
        Q
NEWPAT(SPNDFN)  ; New patient to print
        N DFN
        S DFN=SPNDFN D DEM^VADPT
        S SPNCOU=SPNCOU+1
        Q
PATIENT(SPNDFN,SPNLINE) ; Print Patient data
        S NOTINLST=""
        I $G(PTARRY(SPNDFN))="" S NOTINLST="Not in Registry"
        I $G(PTARRY(SPNDFN)) S NOTINLST=$$GET1^DIQ(2,SPNDFN,57.4,"E") I NOTINLST="NOT APPLICABLE" S NOTINLST="Marked as NOT APPLICABLE in VISTA"
        ;JAS 2/8/07  REMOVED TIME FROM DATESTAMP TO STANDARDIZE DATE FORMAT AS REQUESTED IN DEFECT 802
        ;            ADDED ICN TO END OF PATIENT DETAIL AS REQUESTED IN DEFECT 796
        ;S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT,0)="BOR"_U_$G(VADM(1))_U_$P($G(VADM(2)),"^",2)_U_$$FMTE^XLFDT($P(SPNLINE,U,1),"5Z")_U_$P(SPNLINE,U,2)_U_$P(SPNLINE,U,3)_U_NOTINLST_U_"EOL999"
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT,0)="BOR"_U_$G(VADM(1))_U_$P($G(VADM(2)),"^",2)_U_$$FMTE^XLFDT($P(SPNLINE,U,1),"5DZ")_U_$P(SPNLINE,U,2)_U_$P(SPNLINE,U,3)_U_NOTINLST_U_$P(SPNLINE,U,6)_U_"EOL999"
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT,0)="BOSDIAG"_U_"Diagnosis Codes"_U_"EOL999"
        Q:$P(SPNLINE,U,2)=""
        Q:$P(SPNLINE,U,5)=""
        N SPNODE,SPNNODE
        S SPNNODE=$G(^DGPT($P(SPNLINE,U,5),70)) Q:SPNNODE=""
        N SPNY
        S SPNCNTB=SPNCNT
        F SPNODE=10,16:1:24 D
        .S SPNY=$P(SPNNODE,U,SPNODE)
        .I SPNY'>0 Q
        .;JAS 6/11/09 - DEFECT 1137 - Removed direct & FM reads of CPT/ICD files to API usage
        .;I $G(^ICD9(SPNY,0))="" Q
        .S SPNYAPI=$$ICDDX^ICDCODE(SPNY,"","","")
        .Q:$P(SPNYAPI,"^")=-1
        .;S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)=$$GET1^DIQ(80,SPNY,3,"E")_U_"EOL999"
        .S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)=$P(SPNYAPI,"^",4)_U_"EOL999"
        .Q
        K SPNYAPI
        I SPNCNT=SPNCNTB D
        . S SPNCNT=SPNCNT+1
        . S ^TMP($J,SPNCNT)="^EOL999"
        D KVAR^VADPT
        Q
KILL    ;CALLED FROM VARIOUS OTHER RTN'S
        K ENDATE,NOTINLST,SPNCNTB,STDATE,X,Y,ZYZ
        Q
