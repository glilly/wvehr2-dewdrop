C0QMU12 ;JJOH/ZAG/GPL - Patient Reminder List ; 7/31/12 12:34pm
        ;;1.0;C0Q;;May 21, 2012;Build 68
        ;
        ;2011 Zach Gonzales<zach@linux.com> - Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ; GPL - THIS ROUTINE IS A COPY OF JJOHMU11 THAT HAS BEEN MODIFIED
        ; FOR MEANINGFUL USE CALCULATION FOR FISCAL YEAR 2012 AT OROVILLE HOSPITAL
        ;
C0QPFN()        Q 1130580001.401 ; PARAMETER FILE
C0QPCFN()       Q 1130580001.411 ; CLINIC SUBFILE
C0QMFN()        Q 1130580001.201 ; FILE NUMBER FOR C0Q MEASUREMENT FILE
C0QMMFN()       Q 1130580001.2011 ; FN FOR MEASURE SUBFILE
INIT(ZARY,ZTYP) ; INITIALIZE THE PARAMETERS FOR BUILDING PATIENT LISTS
        ; ZARY IS PASSED BY NAME
        ; ZTYP IS "INP" OR "EP"
        N ZMU S ZMU="MU12" ; THIS IS THE ONLY HARD CODED VALUE LEFT
        ; TBD - CHANGE IT TO A READ FROM SYSTEM PARAMETERS
        K @ZARY ; CLEAR RETURN ARRAY
        N ZIEN,ZCNT,ZX
        I $O(^C0Q(401,"MUTYP",ZMU,ZTYP,""))="" D  Q  ; OOPS NO RECORD THERE
        . W !,"ERROR, NO PARAMETERS AVAILABLE"
        S ZIEN=""
        S ZCNT=0
        F  S ZIEN=$O(^C0Q(401,"MUTYP",ZMU,ZTYP,ZIEN)) Q:ZIEN=""  D  ;
        . S ZCNT=ZCNT+1
        . S @ZARY@(ZCNT,"MU")=$$GET1^DIQ($$C0QPFN,ZIEN_",",.02)
        . S @ZARY@(ZCNT,"TYPE")=$$GET1^DIQ($$C0QPFN,ZIEN_",",.03)
        . S ZX=$$GET1^DIQ($$C0QPFN,ZIEN_",",1,"I")
        . S @ZARY@(ZCNT,"InpatientMeasurementSet")=ZX
        . S @ZARY@(ZCNT,"InpatientBeginDate")=$$GET1^DIQ($$C0QMFN,ZX_",",.02,"I")
        . S @ZARY@(ZCNT,"InpatientEndDate")=$$GET1^DIQ($$C0QMFN,ZX_",",.03,"I")
        . S @ZARY@(ZCNT,"InpatientQualitySet")=$$GET1^DIQ($$C0QPFN,ZIEN_",",1.1,"I")
        . S ZX=$$GET1^DIQ($$C0QPFN,ZIEN_",",2,"I")
        . S @ZARY@(ZCNT,"EPMeasurementSet")=ZX
        . S @ZARY@(ZCNT,"EPBeginDate")=$$GET1^DIQ($$C0QMFN,ZX_",",.02,"I")
        . S @ZARY@(ZCNT,"EPEndDate")=$$GET1^DIQ($$C0QMFN,ZX_",",.03,"I")
        . S @ZARY@(ZCNT,"EPQualitySet")=$$GET1^DIQ($$C0QPFN,ZIEN_",",2.1,"I")
        . S @ZARY@(ZCNT,"InpatientQualitySet")=$$GET1^DIQ($$C0QPFN,ZIEN_",",1.1,"I")
        . D CLEAN^DILF
        . D LIST^DIC($$C0QPCFN,","_ZIEN_",",".01I")
        . I $D(^TMP("DIERR",$J)) D  Q  ; ERROR READING CLINIC LIST
        . . W !,"ERROR READING CLINIC PARAMETER LIST"
        . M @ZARY@(ZCNT,"CLINICS")=^TMP("DILIST",$J)
        ;
        Q
        ;
BUILD   ; CALL ALL AND DIS AND BUILD THE GRSLT ARRAY or print or create
        ; patient lists
        ;N GRSLT ; ARRAY FOR RESULTS
        I '$D(C0QSS) S C0QSS=0 ;default don't build spreadsheet array
        I '$D(C0QPR) S C0QPR=0 ;default don't print out results
        I '$D(C0QPL) S C0QPL=1 ;default do create patient lists
        S ZYR="MU12-"
        D INITCLST ; initialize C0QLIST
        N G1 ; ONE SET OF VALUES - RNF1 FORMAT
        N C0QPARM
        D INIT("C0QPARM","INP") ; initialize inpatient parms
        I $O(C0QPARM(""))="" D  Q  ; no parms for inpatient
        . W !,"No inpatient parameters"
        N ZDIV S ZDIV=""
        F  S ZDIV=$O(C0QPARM(ZDIV)) Q:ZDIV=""  D  ; for each inpatient division
        . D ALL ; all currently admitted patients in the hospital
        . D DIS ; all patients discharged since the reporting period began
        . I C0QSS D ZWRITE^C0QUTIL("GRSLT")
        . ;D ICUPAT ; GENERATE ICU PATIENT LIST
        . I C0QPL D  ;
        . . D FILE ; FILE THE PATIENT LISTS
        . . D UPDATE^C0QUPDT(.G,C0QPARM(ZDIV,"InpatientMeasurementSet")) ; 
        . . D UPDATE^C0QUPDT(.G,C0QPARM(ZDIV,"InpatientQualitySet")) ; 
        . K C0QLIST
        Q
        ;
INITCLST        ; initialize C0QLIST
        ; INITIALIZE LISTS
        ; this is done so that if there are no matching patients, the patient list
        ; will be zeroed out
        K C0QLIST
        S C0QLIST(ZYR_"HasDemographics")=""
        S C0QLIST(ZYR_"Patient")=""
        S C0QLIST(ZYR_"HasProblem")=""
        S C0QLIST(ZYR_"HasAllergy")=""
        S C0QLIST(ZYR_"HasMed")=""
        S C0QLIST(ZYR_"HasVitalSigns")=""
        S C0QLIST(ZYR_"HasMedOrders")=""
        S C0QLIST(ZYR_"HasSmokingStatus")=""
        Q
        ;
ALL     ;retrieve active inpatients
        N WARD S WARD=""
        F  D  Q:WARD=""
        . S WARD=$O(^DIC(42,"B",WARD)) ;ward name
        . Q:WARD=""
        . N WIEN S WIEN=""
        . F  S WIEN=$O(^DIC(42,"B",WARD,WIEN)) Q:'WIEN  D  ;wards IEN
        . . S WARDNAME=$P(^DIC(42,WIEN,0),U,2) ;ward name
        . . N DFN,RB S DFN=""
        . . F  S DFN=$O(^DPT("CN",WARD,+DFN)) Q:'DFN  D  ;DFN of patient on ward
        . . . D DEMO^C0QMU122
        . . . D PROBLEM
        . . . D ALLERGY
        . . . D MEDS4
        . . . D RECON2
        . . . D ADVDIR
        . . . D SMOKING
        . . . D VITALS
        . . . D VTE1
        . . . D COD
        . . . D EDTIME
        . . . I C0QPR D PRINT^C0QMU121
        . . . I C0QSS D SS^C0QMU121
        . . . I C0QPL D PATLIST^C0QMU121
        Q
        ;
PROBLEM ; PATIENT PROBLEMS
        D LIST^ORQQPL(.PROBL,DFN,"A")
        S PBCNT=""
        F  S PBCNT=$O(PROBL(PBCNT)) Q:PBCNT=""  D
        . S PBDESC=$P(PROBL(PBCNT),U,2) ;problem description
        I PBDESC["No problems found" S C0QLIST(ZYR_"NoProblem",DFN)=""
        E  S C0QLIST(ZYR_"HasProblem",DFN)=""
        K PROBL
        Q
        ; 
ALLERGY ; ALLERGY LIST
        ; WANT TO CHANGE ALLERGIES FOR 2012 TO POPULATE THE C0QLIST DIRECTLY. GPL
        D LIST^ORQQAL(.ALRGYL,DFN)
        S ALCNT=""
        F  S ALCNT=$O(ALRGYL(ALCNT)) Q:ALCNT=""  D
        . S ALDESC=$P(ALRGYL(ALCNT),U,2) ;allergy description
        I ALDESC["No Allergy" S C0QLIST(ZYR_"NoAllergy",DFN)=""
        E  S C0QLIST(ZYR_"HasAllergy",DFN)=""
        K ALRGYL
        Q
        ;
MEDS4   ; USE OCL^PSOORRL TO GET ALL MEDS
        ; DELETED MEDS, MEDS2, AND MEDS3 FOR 2012 TO USE ONLY MEDS4
        N BEG,END
        S BEG=$$DT^C0QUTIL("JULY 3,2011")
        S END=$$DT^C0QUTIL("NOW")
        D OCL^PSOORRL(DFN,BEG,END)  ;DBIA #2400
        N C0QMEDS
        M C0QMEDS=^TMP("PS",$J) ; MEDS RETURNED FROM CALL
        N FOUND
        N ZI
        I '$D(C0QMEDS(1)) D  Q  ; QUIT IF NO MEDS
        . S C0QLIST(ZYR_"NoMed",DFN)=""
        E  D  ; HAS MEDS
        . S C0QLIST(ZYR_"HasMed",DFN)=""
        S ZI="" S FOUND=0
        F  S ZI=$O(C0QMEDS(ZI)) Q:ZI=""  D  ; FOR EACH MED
        . N ZM
        . S ZM=$G(C0QMEDS(ZI,0)) ;THE MEDICATION
        . I $P($P(ZM,"^",1),";",2)="I" D  ; IE 1U;I FOR AN INPATIENT UNIT DOSE
        . . S FOUND=1
        I FOUND S C0QLIST(ZYR_"HasMedOrders",DFN)="" ; MET CPOE MEASURE
        E  S C0QLIST(ZYR_"NoMedOrders",DFN)=""
        Q
        ;
RECON   ; MEDICATIONS RECONCILIATION
        ; WANT TO SIMPLIFY MEDS RECON FOR 2012. GPL
        ; 
        I $$HASNTYN^C0QNOTES("MED/SURG NURSING ADMISSION ASSESSMENT",DFN) D  ;
        . S C0QLIST(ZYR_"XferOfCare",DFN)="" ; transfer of care patient
        N HASRECON S HASRECON=0
        N GT,G
        S GT(4,"HasMedRecon","MEDICATION RECONCILIATION COMPLET")=""
        S GT(5,"HasMedRecon","Medication Reconcilation Complete")=""
        I $$TXTALL^C0QNOTES(.G,.GT,DFN) D  ; SEARCH ALL NOTES FOR MED RECON
        . S HASRECON=1
        ;N ZT
        ;S ZT="MEDICATION RECONCILIATION COMPLET"
        ;I $$NTTXT^C0QNOTES("ER NURSE NOTE",ZT,DFN) D  ;
        ;. S HASRECON=1
        ;E  D  ;
        ;. S ZT="Medication Reconcilation Complete"
        ;. I $$NTTXT^C0QNOTES("MED/SURG NURSING ADMISSION ASSESSMENT",ZT,DFN) D  ;
        ;. . S HASRECON=1
        ;I $$HFYN^C0QHF("MEDS HAVE BEEN REVIEWED",DFN) S HASRECON=1
        I HASRECON D  ;
        . S C0QLIST(ZYR_"HasMedRecon",DFN)=""
        E  S C0QLIST(ZYR_"NoMedRecon",DFN)=""
        Q
        ;
RECON2  ; USE HEALTH FACTORS FOR MEDICATION RECONCILIATION
        I $$HASNTYN^C0QNOTES("MED/SURG NURSING ADMISSION ASSESSMENT",DFN) D  ;
        . S C0QLIST(ZYR_"XferOfCare",DFN)="" ; transfer of care patient
        I $$HFYN^C0QHF(DFN,"Medication Reconciliation Completed: Yes") D  ;
        . S C0QLIST(ZYR_"HasMedRecon",DFN)=""
        E  S C0QLIST(ZYR_"NoMedRecon",DFN)=""
        Q
        ;
ERX     ; FOR EP, WE LOOK AT ERX MEDS
        N ZI S ZI=""
        N ZERX S ZERX=$NA(^PS(55,DFN,"NVA"))
        F  S ZI=$O(@ZERX@(ZI)) Q:ZI=""  D  ;
        . ;B
        . I $G(@ZERX@(ZI,1,1,0))["E-Rx Web" D  ;
        . . S C0QLIST(ZYR_"HasMed",DFN)=""
        . . S C0QLIST(ZYR_"HasMedOrders",DFN)=""
        . . S C0QLIST(ZYR_"HasERX",DFN)=""
        . . S C0QLIST(ZYR_"HasMedRecon",DFN)=""
        . E  D  ;
        . . S C0QLIST(ZYR_"NoMed",DFN)=""
        . . S C0QLIST(ZYR_"NoMedOrders",DFN)=""
        . . S C0QLIST(ZYR_"NoERX",DFN)=""
        . . S C0QLIST(ZYR_"NoMedRecon",DFN)=""
        Q
        ;
ADVDIR  ; ADVANCE DIRECTIVE
        ;
        I $$AGE^C0QUTIL(DFN)>64 D  ; ONLY FOR PATIENTS 65 AND OLDER
        . S C0QLIST(ZYR_"Over65",DFN)=""
        . I $$HASNTYN^C0QNOTES("ADVANCE DIRECTIVE",DFN) D  ;
        . . S C0QLIST(ZYR_"HasAdvanceDirective",DFN)=""
        . E  D  ;
        . . S C0QLIST(ZYR_"NoAdvanceDirective",DFN)=""
        Q
        ;
SMOKING G SMOKING^C0QMU121
VITALS  ;
        ;
        N C0QSDT,C0QEDT
        D DT^DILF(,"JULY 3,2011",.C0QSDT) ; START DATE
        D DT^DILF(,"T",.C0QEDT) ; END DATE TODAY
        D VITALS^ORQQVI(.VITRSLT,DFN,C0QSDT,C0QEDT) ; CALL FAST VITALS
        I $D(VITRSLT) D  ;ZWR VITRSLT B  ;
        . I VITRSLT(1)["No vitals found." S C0QLIST(ZYR_"NoVitalSigns",DFN)=""
        . E  S C0QLIST(ZYR_"HasVitalSigns",DFN)=""
        Q
        ;
VTE1    ; VTE PROPHYLAXIS WITHIN 24HRS OF ARRIVAL
        ;
        I $$HFYN^C0QHF(DFN,"VTE PROPHYLAXIS WITHIN 24HRS OF ARRIVAL") D  ;
        . S C0QLIST(ZYR_"HasVTE24",DFN)=""
        E  S C0QLIST(ZYR_"NoVTE24",DFN)=""
        Q
        ;
COD     ; TEST FOR PRELIMINARY CAUSE OF DEATH NOTE
        I $$HASNTYN^C0QNOTES("PRELIMINARY CAUSE OF DEATH",DFN) D  ;
        . S C0QLIST(ZYR_"CauseOfDeath",DFN)=""
        Q
        ;
EDTIME  ; CHECK FOR EMERGENCY DEPT TIME FACTORS
        N FOUND
        S FOUND=0
        I $$HFYN^C0QHF(DFN,"ED ARRIVAL TIME") S FOUND=1
        I '$$HFYN^C0QHF(DFN,"ED DEPARTURE TIME") S FOUND=0
        I '$$HFYN^C0QHF(DFN,"TIME DECISION TO ADMIT MADE") S FOUND=0
        I FOUND D  ; 
        . S C0QLIST(ZYR_"HasEDtime",DFN)=""
        E  S C0QLIST(ZYR_"NoEDtime",DFN)=""
        Q
        ;
ICUPAT  ; CREATE LIST OF ICU PATIENTS
        N ZICU
        S ZICU=$O(^SC("B","IC","")) ; IEN OF ICU HOSPITAL LOCATION
        N ZI,ZJ,ZP
        S ZI=""
        F  S ZI=$O(^AUPNVSIT("AHL",ZICU,ZI)) Q:ZI=""  D  ; EACH DATE
        . S ZJ=""
        . F  S ZJ=$O(^AUPNVSIT("AHL",ZICU,ZI,ZJ)) Q:ZJ=""  D  ; EACH VISIT
        . . S ZP=$P(^AUPNVSIT(ZJ,0),"^",5) ; DFN
        . . S C0QLIST(ZYR_"ICUPatient",ZP)=""
        Q
        ;
FILTER  ; CALLED AFTER ALL THE PATIENT LISTS HAVE BEEN FILED
        ; WILL KILL C0QLIST AND CREATE DERIVATIVE PATIENT LISTS BY FILTERING
        K C0QLIST
        N ZPAT
        S ZPAT=$$PATLN(ZYR_"Patient") ; name of patient list of all patients admitted
        ; during the reporting period. used to filter other lists
        ;
        ; filter ICU patients against ZPAT
        N GN,GO,GF
        S GN=ZPAT
        S GO=$$PATLN(ZYR_"ICUPatient") ; all ICU patient
        S GF=$NA(C0QLIST(ZYR_"ICUReporting")) ; the filtered list destination
        D AND^C0QSET(GF,GN,GO) ; filter the list with the AND set operation
        ; 
        ; FILTER VTE-2 DENOMINATOR FOR QUALITY MEASURE
        ;
        S GN=$NA(C0QLIST(ZYR_"ICUReporting")) ; ICU patients admitted inside rpt period
        S GO=$$RPATLN("MU VTE-2 DENOM PL") ; TAXONOMY BASED DENOMENATOR
        S GF=$NA(C0QLIST(ZYR_"VTE2DEN")) ; NEW DENOMINATOR PL
        D AND^C0QSET(GF,GN,GO) ; filter the list with the AND set operation
        ;
        S GN=ZPAT
        S GO=$$RPATLN("MU VTE-3 DENOM PL") ; TAXONOMY BASED DENOMENATOR
        S GF=$NA(C0QLIST(ZYR_"VTE3DEN")) ; NEW DENOMINATOR PL
        D AND^C0QSET(GF,GN,GO) ; filter the list with the AND set operation
        ;
        S GN=ZPAT
        S GO=$$RPATLN("MU VTE-4 DENOM PL") ; TAXONOMY BASED DENOMENATOR
        S GF=$NA(C0QLIST(ZYR_"VTE4DEN")) ; NEW DENOMINATOR PL
        D AND^C0QSET(GF,GN,GO) ; filter the list with the AND set operation
        ;
        S GN=ZPAT
        S GO=$$RPATLN("MU VTE-5 DENOM PL") ; TAXONOMY BASED DENOMENATOR
        S GF=$NA(C0QLIST(ZYR_"VTE5DEN")) ; NEW DENOMINATOR PL
        D AND^C0QSET(GF,GN,GO) ; filter the list with the AND set operation
        ;
        D FILE ; FILE ALL THE PATIENT LISTS
        D UPDATE^C0QUPDT(.G,5) ; UPDATE THE HOS 2011 MEANINGFUL USE measure set
        Q
        ;
ED1     ;
        S ZYR="MU12-"
        D DOTIME^C0QMU121("ED DEPARTURE TIME")
        Q
        ;
ED2     ;
        S ZYR="MU12-"
        D DOTIME2^C0QMU121("TIME DECISION TO ADMIT MADE")
        Q
        ;
RPATLN(ZLST)    ; EXTRINSIC RETURNS THE GLOBAL NAME OF THE REMINDER PATIENT LIST
        ; WHOSE NAME IS ZLST
        N ZIEN,ZN
        S ZIEN=$O(^PXRMXP(810.5,"B",ZLST,"")) ; ien of patient list
        S ZN=$NA(^PXRMXP(810.5,ZIEN,30,"B")) ; GLOBAL NAME IN REMINDER PATIENT LIST
        Q ZN
        ;
PATLN(ZATTR)    ; EXTRINSIC RETURNS THE NAME OF THE PATIENT LIST WITH
        ; THE ATTRIBUTE ZATTR
        N ZIEN,ZN
        S ZIEN=$O(^C0Q(301,"CATTR",ZATTR,"")) ; ien of patient list
        S ZN=$NA(^C0Q(301,ZIEN,1,"B")) ; NAME OF PATIENT LIST IN C0Q PATIENT LIST
        Q ZN
        ;
INLIST(ZLIST,DFN)       ; EXTRINSIC FOR IS PATIENT ALREADY IN LIST ZLIST
        N ZL,ZR
        S ZL=$O(^C0Q(301,"CATTR",ZLIST,"")) ; IEN OF LIST IN C0Q PATIENT LIST FILE
        I ZL="" Q 0 ; LIST DOES NOT EXIST
        S ZR=0 ; ASSUME NOT IN LIST
        I $D(^C0Q(301,ZL,1,"B",DFN)) S ZR=1 ; PATIENT IS IN LIST
        Q ZR
        ;
LOCPAT(PREFIX,LOC)        ;retrieve active outpatients
        ; PREFIX WILL GO IN C0XLIST(PREFIX_"-PATIENT",DFN)=""
        ; LOC IS HOSPITAL LOCATION
        S ULOC=$O(^SC("B",LOC,"")) ; IEN OF HOSPITAL LOCATION
        I ULOC="" D  Q  ; OOPS
        . W !,"HOSPITAL LOCATION NOT FOUND: ",LOC
        S IDTE=9999999-DTE ; INVERSE DATE
        N ZI
        S ZI="" ; BEGIN AT LATEST DATE FOR THIS LOC IN VISIT FILE
        F  S ZI=$O(^AUPNVSIT("AHL",ULOC,ZI)) Q:(ZI="")!(ZI>IDTE)  D  ; FOR EACH DATE
        . W !,$$FMTE^XLFDT(9999999-ZI) ;B  ;
        . I ZI="" Q  ;
        . N ZJ S ZJ=""
        . F  S ZJ=$O(^AUPNVSIT("AHL",ULOC,ZI,ZJ)) Q:ZJ=""  D  ; FOR EACH VISIT
        . . S DFN=$$GET1^DIQ(9000010,ZJ,.05,"I") ; PATIENT
        . . S C0QLIST(PREFIX_"Patient",DFN)=""
        Q
        ;
EPPAT(ZYR)      ; BUILD ALL PATIENT LISTS FOR CLINICS
        ;
        S DTE=3111000
        S MUYR=ZYR
        N ZC,ZN
        S ZN=0
        N ZI S ZI=0
        F  S ZI=$O(^SC(ZI)) Q:+ZI=0  D  ; FOR EVERY HOSPITAL LOCATION
        . I $$GET1^DIQ(44,ZI_",",2,"I")'="C" Q   ; NOT A CLINIC
        . S ZC=$$GET1^DIQ(44,ZI_",",.01) ; NAME OF CLINIC
        . S ZCIEN=ZI ; IEN OF CLINIC
        . S ZN=ZN+1 ; COUNT OF CLINICS
        . S PRE=MUYR_"-EP-"_ZC_"-"
        . D LOCPAT(PRE,ZC)
        W !,"NUMBER OF CLINICS: ",ZN
        D FILE ; CREATE ALL THE EP PATIENT LISTS
        Q
        ;
DOEP    ; DO EP COMPUTATIONS
        S ZYR="MU12-"
        N C0QPARM,C0QCLNC
        D INIT("C0QPARM","EP") ; INITIALIZE PARAMETERS
        K C0QLIST ; CLEAR THE LIST
        N ZI S ZI=""
        F  S ZI=$O(C0QPARM(ZI)) Q:ZI=""  D  ; FOR EACH EP
        . S DTE=C0QPARM(ZI,"EPBeginDate") ; beginning of measurement period
        . S EDTE=C0QPARM(ZI,"EPEndDate") ; end of measurement period -- tbd use this
        . S C0QCLNC=C0QPARM(ZI,"CLINICS",1,1) ; only one clinic for now
        . S PRE=ZYR_"EP-"_C0QCLNC_"-"
        . D LOCPAT(PRE,C0QCLNC) ; GET THE PATIENTS
        . I $D(DEBUG) D ZWRITE^C0QUTIL("C0QLIST")
        . M C0QLIST(ZYR_"EP-ALL-PATIENTS")=C0QLIST(PRE_"Patient")
        S DFN=""
        S ZYR=ZYR_"EP-"
        F  S DFN=$O(C0QLIST(ZYR_"ALL-PATIENTS",DFN)) Q:DFN=""  D  ; EACH PATIENT
        . D DEMO^C0QMU122
        . D PROBLEM
        . D ALLERGY
        . ;D MEDS
        . D ERX
        . D SMOKING
        . D VITALS
        D FILE ; FILE THE PATIENT LISTS
        N C0QCIEN
        S ZI=""
        F  S ZI=$O(C0QPARM(ZI)) Q:ZI=""  D  ;
        . S C0QCIEN=C0QPARM(ZI,"EPMeasurementSet") ; ien of measurement set
        . D UPDATE^C0QUPDT(.G,C0QCIEN) ; UPDATE THE MU MEASUREMENT SET
        Q
        ;
DIS     ;
        N DFN,DTE,EXDTE S DTE=""
        F  D  Q:DTE=""
        . S DTE=$O(^DGPM("B",DTE))
        . Q:'DTE
        . ;Q:$P(DTE,".")<3110703
        . Q:$P(DTE,".")<3111000  ; NEW BEGIN DATE FOR FISCAL YEAR 2012
        . S EXDTE=$$FMTE^XLFDT(DTE)
        . N PTFM S PTFM=""
        . D
        . . S PTFM=$O(^DGPM("B",DTE,PTFM))
        . . Q:'PTFM
        . . S DFN=$P(^DGPM(PTFM,0),U,3)
        . . S C0QLIST(ZYR_"Patient",DFN)=""
        . . D DEMO^C0QMU122
        . . D PROBLEM
        . . D ALLERGY
        . . D MEDS4
        . . D RECON2
        . . D ADVDIR
        . . D SMOKING
        . . D VITALS
        . . ;D:$P(DTE,".")>3110912 VTE1
        . . D VTE1
        . . D COD
        . . D EDTIME
        . . I C0QPR D PRINT^C0QMU121
        . . I C0QSS D SS^C0QMU121
        . . I C0QPL D PATLIST^C0QMU121
        Q
        ;
C0QPLF()        Q 1130580001.301 ; FILE NUMBER FOR C0Q PATIENT LIST FILE
C0QALFN()       Q 1130580001.311 ; FILE NUMBER FOR C0Q PATIENT LIST PATIENT SUBFILE
FILE    ; FILE THE PATIENT LISTS TO C0Q PATIENT LIST
        ;
        I '$D(C0QLIST) Q  ;
        N LFN S LFN=$$C0QALFN()
        N ZI,ZN
        S ZI=""
        F  S ZI=$O(C0QLIST(ZI)) Q:ZI=""  D  ;
        . S ZN=$O(^C0Q(301,"CATTR",ZI,""))
        . I ZN="" D  ; LIST NOT FOUND, CREATE IT
        . . K C0QFDA
        . . S FN=$$C0QPLF ; C0Q PATIENT LIST FILE
        . . S C0QFDA(FN,"+1,",.01)=ZI
        . . S C0QFDA(FN,"+1,",999)=ZI ; ATTRIBUTE
        . . W !,"CREATING ",ZI
        . . D UPDIE ; ADD THE RECORD
        . . S ZN=$O(^C0Q(301,"CATTR",ZI,"")) ; THE NEW IEN
        . ;I ZN="" D  Q  ; OOPS
        . ;. W !,"ERROR, ATTRIBUTE NOT FOUND IN PATIENT LIST FILE:"_ZI
        . ;S ZN=$$KLNCR(ZN) ; KILL AND RECREATE RECORD ZN
        . N C0QNEW,C0QOLD,C0QRSLT
        . S C0QNEW=$NA(C0QLIST(ZI)) ; THE NEW PATIENT LIST
        . S C0QOLD=$NA(^C0Q(301,ZN,1,"B")) ; THE OLD PATIENT LIST
        . D UNITY^C0QSET("C0QRSLT",C0QNEW,C0QOLD) ; FIND WHAT'S NEW
        . N ZJ,ZK
        . ; FIRST, DELETE THE OLD ONES - NO LONGER IN THE LIST
        . K C0QFDA
        . S ZJ=""
        . F  S ZJ=$O(C0QRSLT(2,ZJ)) Q:ZJ=""  D  ; MARKED WITH A 2 FROM UNITY
        . . S ZK=$O(@C0QOLD@(ZJ,"")) ; GET THE IEN OF THE RECORD TO DELETE
        . . I ZK="" D  Q  ; OOPS SHOULDN'T HAPPEN
        . . . W !,"INTERNAL ERROR FINDING A PATIENT TO DELETE"
        . . . S $EC=",U1130580001,"  ; smh - instead of a BREAK
        . . S C0QFDA(LFN,ZK_","_ZN_",",.01)="@"
        . I $D(C0QFDA) D UPDIE ; PROCESS THE DELETIONS
        . ; SECOND, PROCESS THE ADDITIONS
        . K C0QFDA
        . S ZJ="" S ZK=1
        . F  S ZJ=$O(C0QRSLT(0,ZJ)) Q:ZJ=""  D  ; PATIENTS TO ADD ARE MARKED WITH 0
        . . S C0QFDA(LFN,"+"_ZK_","_ZN_",",.01)=ZJ
        . . S ZK=ZK+1
        . I $D(C0QFDA) D UPDIE ; PROCESS THE ADDITIONS
        ;. Q
        ;. K C0QFDA
        ;. N ZJ,ZC
        ;. S ZJ="" S ZC=1
        ;. F  S ZJ=$O(C0QLIST(ZI,ZJ)) Q:ZJ=""  D  ; FOR EACH PAT IN LIST
        ;. . S C0QFDA(LFN,"?+"_ZC_","_ZN_",",.01)=ZJ
        ;. . S ZC=ZC+1
        ;. D UPDIE
        ;. W !,"FOUND:"_ZI
        Q
        ;
KLNCR(ZREC)     ; KILL AND RECREATE RECORD ZREC IN PATIENT LIST FILE
        ;
        N C0QFDA,ZFN,LIST,ATTR
        S ZFN=$$C0QPLF() ; FILE NUMBER FOR C0Q PATIENT LIST FILE
        D CLEAN^DILF
        S LIST=$$GET1^DIQ(ZFN,ZREC_",",.01) ;  MEASURE NAME
        S ATTR=$$GET1^DIQ(ZFN,ZREC_",",999) ; ATTRIBUTE
        D CLEAN^DILF
        K ZERR
        S C0QFDA(ZFN,ZREC_",",.01)="@" ; GET READY TO DELETE THE MEASURE
        D FILE^DIE(,"C0QFDA","ZERR") ; KILL THE SUBFILE
        I $D(ZERR) S ZZERR=ZZERR ; ZZERR DOESN'T EXIST, INVOKE THE ERROR TRAP IF TASKED
        ;. W "ERROR",!
        ;. ZWR ZERR
        ;. B
        K C0QFDA
        S C0QFDA(ZFN,"+1,",.01)=LIST ; GET READY TO RECREATE THE RECORD
        S C0QFDA(ZFN,"+1,",999)=ATTR ; ATTRIBUTE
        D UPDIE ; CREATE THE SUBFILE
        N ZR ; NEW IEN FOR THE RECORD
        S ZR=$O(^C0Q(301,"CATTR",ATTR,""))
        ;
        Q ZR
        ;
UPDIE   ; INTERNAL ROUTINE TO CALL UPDATE^DIE AND CHECK FOR ERRORS
        K ZERR
        D CLEAN^DILF
        D UPDATE^DIE("","C0QFDA","","ZERR")
        I $D(ZERR) S ZZERR=ZZERR ; ZZERR DOESN'T EXIST, INVOKE THE ERROR TRAP IF TASKED
        K C0QFDA
        Q
        ;
END     ;end of C0QPRML;
