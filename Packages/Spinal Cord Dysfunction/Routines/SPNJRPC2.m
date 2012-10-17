SPNJRPC2        ;BP/JAS - Returns list of patients with future appointments ;JUL 17, 2008 
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ; Reference to ^DPT(D0,57 supported by IA #4938
        ; Reference to API DEM^VADPT supported by IA #10061
        ; Reference to API $$SDAPI^SDAMA301 supported by IA #4433
        ; API $$FLIP^SPNRPCIC is part of Spinal Cord Version 3.0
        ;
        ; Parm values:
        ;     ICNLST is the list of patient ICNs to process
        ;     SPNSEL determines which patients to search:
        ;           1 - ICNLST ONLY
        ;           2 - ONLY VISTA PATS WITH SCD INDICATOR
        ;           3 - BOTH
        ;
        ;RETURN returns:
        ;     APPT DATE ^ APPT TIME ^ CLINIC ^ PATIENT NAME ^ 
        ;     SSN(LAST FOUR) ^ ICN ^ EOL999
        ;
COL(RETURN,ICNLST,SPNSEL,SPNSTRT,SPNEND)        ;
        ;***************************
        S RETURN=$NA(^TMP($J))
        S RETCNT=0
        S X=SPNSTRT S %DT="T" D ^%DT S SPNSTRT=Y
        S X=SPNEND S %DT="T" D ^%DT S SPNEND=Y
        I SPNSTRT=""!(SPNSTRT=-1) S SPNSTRT=DT
        I SPNEND=""!(SPNEND=-1) S SPNEND=DT+20000.2359
        K ^TMP($J)
        I SPNSEL=1!(SPNSEL=3) D ONE
        I SPNSEL=2!(SPNSEL=3) D TWO
        D CLNUP
        Q
ONE     F ICNNM=1:1:$L(ICNLST,"^") S ICN=$P(ICNLST,"^",ICNNM) D
        . Q:$G(ICN)=""
        . S DFN=$$FLIP^SPNRPCIC(ICN)
        . Q:$G(DFN)=""
        . D DEM^VADPT
        . S NAME=VADM(1),SSNLAST4=VA("BID")
        . S SPNDFN=DFN
        . D APPT
        Q
TWO     ;
        S SPNDFN=0 F  S SPNDFN=$O(^DPT(SPNDFN)) Q:(SPNDFN="")!('+SPNDFN)  D
        . S SPNCHK=$P($G(^DPT(SPNDFN,57)),U,4) I +SPNCHK D
        . . I $D(^DPT(SPNDFN,"MPI")) S ICNCK=$P(^DPT(SPNDFN,"MPI"),"^",1)
        . . I $G(ICNCK)'="",ICNLST[ICNCK Q
        . . S DFN=SPNDFN D DEM^VADPT
        . . S NAME=VADM(1),SSNLAST4=VA("BID")
        . . D APPT
        Q
APPT    ;
        S SDARRAY(1)=SPNSTRT_";"_SPNEND
        S SDARRAY(3)="R"
        S SDARRAY(4)=SPNDFN
        S SDARRAY("FLDS")="1;2"
        S SDCOUNT=$$SDAPI^SDAMA301(.SDARRAY)
        I SDCOUNT>0 D
        .S SDCLIEN=0 F  S SDCLIEN=$O(^TMP($J,"SDAMA301",SPNDFN,SDCLIEN)) Q:'+SDCLIEN  D
        ..S SDDATE=0 F  S SDDATE=$O(^TMP($J,"SDAMA301",SPNDFN,SDCLIEN,SDDATE)) Q:'+SDDATE  D
        ...S SDAPPT=$G(^TMP($J,"SDAMA301",SPNDFN,SDCLIEN,SDDATE))
        ...S SPNAPPT=$P($G(^TMP($J,"SDAMA301",SPNDFN,SDCLIEN,SDDATE)),U,1)
        ...S SPNCL=$P(SDAPPT,U,2) S SPNCL=$P(SPNCL,";",2)
        ...S SPNICN=$P($G(^DPT(SPNDFN,"MPI")),"^",1)
        ...D SETRT
        K ^TMP($J,"SDAMA301")
        Q
SETRT   ;
        S Y=SPNAPPT X ^DD("DD") S RETDATE=$P(Y,"@"),RETTIME=$P(Y,"@",2)
        S RETCNT=RETCNT+1
        S ^TMP($J,SDDATE,RETCNT)=RETDATE_"^"_RETTIME_"^"_SPNCL_"^"_NAME_"^"_SSNLAST4_"^"_SPNICN_"^"_"EOL999"
        Q
CLNUP   ;
        K %DT,AICN,DFN,ICN,ICNCK,ICNNM,NAME,PATLIST,RETCNT,RETDATE,RETTIME
        K SDAPPT,SDARRAY,SDCLIEN,SDCOUNT,SDDATE,SPN,SPNAPPT,SPNCHK,SPNCL
        K SPNDFN,SPNICN,SSNLAST4,VA,VADM,X,Y
        Q
