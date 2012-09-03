C0QMU121        ;VEN/SMH - Patient Reminder List, cont. ; 7/31/12 12:33pm
        ;;1.0;C0Q;;May 21, 2012;Build 68
        ;
        ; Licensed under package license.
        ;
SMOKING ; Smoking data collection
        ; WANT TO CHANGE SMOKING STATUS CHECKING FOR 2012 TO A SIMPLE SET OF
        ; HEALTH FACTORS. GPL
        I $$INLIST^C0QMU12(ZYR_"HasSmokingStatus",DFN) D  Q  ; ALREADY HAS SMOKING STAT CHECK
        . S C0QLIST(ZYR_"HasSmokingStatus",DFN)=""
        . S C0QLIST(ZYR_"Over12",DFN)=""
        I $$INLIST^C0QMU12(ZYR_"NoSmokingStatus",DFN) D  Q  ; ALREADY HAS SMOKING STATUS CHECK
        . S C0QLIST(ZYR_"NoSmokingStatus",DFN)=""
        . S C0QLIST(ZYR_"Over12",DFN)=""
        N C0QSMOKE,C0QSYN
        S C0QSYN=0
        I $$AGE^C0QUTIL(DFN)<13 Q  ; DON'T CHECK UNDER AGE 13
        D HFCAT^C0QHF(.C0QSMOKE,DFN,"TOBACCO") ; GET ALL HEALTH FACTORS FOR THE
        ; PATIENT IN THE CATEGORY OF TOBACCO
        I $D(C0QSMOKE) S C0QSYN=1
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smokeless Tobacco <1 Yr Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smokeless Tobacco > 20 Yrs Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smokeless Tobacco: 1-5 Yrs Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smokeless Tobacco: 10-20 Yrs Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smokeless Tobacco: 5-10 Yrs Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smoking")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smoking < 1 Yr Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smoking > 20 Yrs Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smoking: 1-5 Yrs Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smoking: 10-20 Yrs Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Quit Smoking: 5-10 Yrs Ago")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKELESS TOBACCO USER")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKELESS: 1-5 YRS AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKELESS: 10-20 YRS AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKELESS: 5-10 YRS AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKELESS: < 1 YR AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKELESS: > 20 YRS AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER 10-20 YRS")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER 20+ YRS")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER < 1 YR")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER < 1 YR AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER > 20 YRS AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER: 1-5 YRS")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER: 1-5 YRS AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER: 10-20 YRS AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER: 5-10 YRS")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKER: 5-10 YRS AGO")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"PREVIOUS SMOKELESS TOBACCO USER")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"LIFETIME NON-SMOKER")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoke Exposure/2nd Hand Exposure")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoker (HPI)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (FMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking Cessation (OPH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"LIFETIME NON-SMOKER")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoke Exposure/2nd Hand Exposure")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoker (HPI)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (FMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Non-Smoker")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"LIFETIME NON-SMOKER")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoke Exposure/2nd Hand Exposure")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoker (HPI)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (FMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"LIFETIME NON-SMOKER")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoke Exposure/2nd Hand Exposure")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoker (HPI)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (FMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Non-Smoker")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"LIFETIME NON-SMOKER")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Former Smoker (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoke Exposure/2nd Hand Exposure")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoked For > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 1-5 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 10-20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for 5-10 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for < 1 Yr")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smokeless Used for > 20 Yrs")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoker (HPI)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (FMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Smoking (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Non-Smoker")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Non-Smoker (PMH)")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Non-Tobacco User")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Current Smoker - No")
        S:'C0QSYN C0QSYN=$$HFYN^C0QHF(DFN,"Current Smoker - Yes")
        S C0QLIST(ZYR_"Over12",DFN)=""
        ;N GT
        ;S GT(1,"HasSmokingStatus","SMOK")=""
        ;S GT(2,"HasSmokingStatus","Smok")=""
        ;S GT(3,"HasSmokingStatus","smok")=""
        ;I 'C0QSYN D  ;
        ;. N G
        ;. S OK=$$TXTALL^C0QNOTES(.G,.GT,DFN)
        ;. I $D(G) S C0QSYN=1
        I C0QSYN S C0QLIST(ZYR_"HasSmokingStatus",DFN)=""
        E  S C0QLIST(ZYR_"NoSmokingStatus",DFN)=""
        Q
        ;
DOTIME(ZHF)         ; COMPUTE THE MEAN TIME IN THE ED FROM ARRIVAL TO DEPARTURE
        ; THIS IS A QUALITY MEASURE ED-1 FOR MEANINGFUL USE
        ; IT PRINTS A REPORT OF EACH PATIENT WITH THE ED TIMES RECORDED
        ; AND THEIR TIME. AT THE END IT PRINTS THE MEAN TIME
        N ZP
        S ZP=$$PATLN^C0QMU12(ZYR_"HasEDtime") ; patient list name for patients to process
        S ZHFN=9000010.23 ; FILE NUMBER FOR V HEALTH FACTORS
        S ZVFN=9000010 ; VISIT FILE NUMBER
        K ZARY1,ZARY2
        N ZI S ZI=""
        S COUNT=0
        F  S ZI=$O(@ZP@(ZI)) Q:ZI=""  D  ; FOR EACH PATIENT
        . S COUNT=COUNT+1
        . N ZA,ZD
        . S ZA=$$VHFIEN^C0QHF(ZI,"ED ARRIVAL TIME") ; IEN OF ARRIVAL HEALTH FACTOR
        . S ZD=$$VHFIEN^C0QHF(ZI,ZHF) ; IEN OF DEPART HEALTH FACTOR
        . N ZAD,ZDD ; ARRIVAL DATE, DEPARTURE DATE
        . N ZAC,ZDC ; ARRIVAL COMMENT, DEPARTURE COMMENT 
        . ; THE COMMENT IS THE TIME XXYY
        . N OK,TMP
        . S TMP=$$GET1^DIQ(ZHFN,ZA_",",.03,"I") ; VISIT POINTER
        . S ZAD=$$GET1^DIQ(ZVFN,TMP_",",.01,"I") ; VISIT DATE
        . ;S ZAD=$P(^AUPNVHF(ZA,0),U,3) ; DATE IS PIECE 3
        . S TMP=$$GET1^DIQ(ZHFN,ZD_",",.03,"I") ; VISIT POINTER
        . S ZDD=$$GET1^DIQ(ZVFN,TMP_",",.01,"I") ; VISIT DATE
        . ;S ZDD=$$GET1^DIQ(ZHFN,ZD_",",1201,"I") ; EVENT DATE FIELD
        . ;S ZDD=$P(^AUPNVHF(ZD,0),U,3) ; DATE IS PIECE 3
        . ;S OK=$$GET1^DIQ(ZHFN,ZA_",",81101,"","ZAC") ; ARRIVAL TIME
        . S ZAC=$G(^AUPNVHF(ZA,811)) ; THE TIME
        . ;S OK=$$GET1^DIQ(ZHFN,ZD_",",81101,"","ZDC") ; DEPARTURE TIME
        . S ZDC=$G(^AUPNVHF(ZD,811)) ; DEPARTURE TIME
        . N ZT ; THE TIME DIFFERENCE BETWEEN THE DATES
        . W !,!,"PATIENT: ",ZI," ",$P(^DPT(ZI,0),U,1)
        . W !,"IN: ",$$FMTE^XLFDT(ZAD_"."_ZAC)," OUT: ",$$FMTE^XLFDT(ZDD_"."_ZDC)
        . S G1=($E(ZDC,1,2)*60)+($E(ZDC,3,4))
        . S G2=($E(ZAC,1,2)*60)+($E(ZAC,3,4))
        . I (ZDD-ZAD)>0 S G1=G1+(((ZDD-ZAD)*24)*60)
        . S GTOT=G1-G2
        . W !,"TIME: ",GTOT," ESTIMATED"
        . S ZT=$$DTDIFF^C0QUTIL(ZDD,ZDC,ZAD,ZAC) ; COMPUTE THE DIFFERENCE IN MINUTES
        . W !,"COMPUTED MINUTES: ",ZT
        . ;I ZT'=GTOT B  ; LET'S FIND OUT WHAT'S WRONG
        . I ZT<0 D  Q  ; SKIP PATIENTS WITH NEGATIVE TIMES
        . . W !,"****EXCLUDED****"
        . I ZT>400000 D  Q  ; THESE ARE ERRORS
        . . W !,"****EXCLUDED****"
        . S ZARY1(ZT,ZI)="" ; ARRAY ORDERED BY MINUTES OF PATIENTS
        N ZY,ZZ S ZY="" S ZZ=""
        N ZCOUNT S ZCOUNT=0
        F  S ZY=$O(ZARY1(ZY)) Q:ZY=""  D  ; FOR EACH TIME
        . F  S ZZ=$O(ZARY1(ZY,ZZ)) Q:ZZ=""  D  ; FOR EACH PATIENT WITH THIS TIME
        . . S ZCOUNT=ZCOUNT+1
        . . S ZARY2(ZCOUNT,ZY,ZZ)=""
        . . ;W !,ZCOUNT," PATIENT: ",ZZ," MINUTES: ",ZY
        N ZMID
        S ZMID=$P(ZCOUNT/2,".")
        W !,"NUMBER OF PATIENTS IN REPORT: ",ZCOUNT
        W !,"ED ARRIVAL TIME UNTIL ",ZHF
        W !,"MEDIAN TIME: ",$O(ZARY2(ZMID,""))
        Q
        ;
DOTIME2(ZHF)       ; COMPUTE THE MEAN TIME IN THE ED FROM ARRIVAL TO DEPARTURE
        ; THIS IS A QUALITY MEASURE ED-1 FOR MEANINGFUL USE
        ; IT PRINTS A REPORT OF EACH PATIENT WITH THE ED TIMES RECORDED
        ; AND THEIR TIME. AT THE END IT PRINTS THE MEAN TIME
        N ZP
        S ZP=$$PATLN^C0QMU12(ZYR_"HasEDtime") ; patient list name for patients to process
        S ZHFN=9000010.23 ; FILE NUMBER FOR V HEALTH FACTORS
        S ZVFN=9000010 ; VISIT FILE NUMBER
        K ZARY1,ZARY2
        N ZI S ZI=""
        S COUNT=0
        F  S ZI=$O(@ZP@(ZI)) Q:ZI=""  D  ; FOR EACH PATIENT
        . S COUNT=COUNT+1
        . N ZA,ZD
        . ;S ZA=$$VHFIEN^C0QHF(ZI,"ED ARRIVAL TIME") ; IEN OF ARRIVAL HEALTH FACTOR
        . ;S ZD=$$VHFIEN^C0QHF(ZI,ZHF) ; IEN OF DEPART HEALTH FACTOR
        . S ZA=$$VHFIEN^C0QHF(ZI,ZHF) ; IEN OF DEPART HEALTH FACTOR
        . S ZD=$$VHFIEN^C0QHF(ZI,"ED DEPARTURE TIME") ; IEN OF ARRIVAL HEALTH FACTOR
        . N ZAD,ZDD ; ARRIVAL DATE, DEPARTURE DATE
        . N ZAC,ZDC ; ARRIVAL COMMENT, DEPARTURE COMMENT 
        . ; THE COMMENT IS THE TIME XXYY
        . N OK,TMP
        . S TMP=$$GET1^DIQ(ZHFN,ZA_",",.03,"I") ; VISIT POINTER
        . S ZAD=$$GET1^DIQ(ZVFN,TMP_",",.01,"I") ; VISIT DATE
        . ;S ZAD=$P(^AUPNVHF(ZA,0),U,3) ; DATE IS PIECE 3
        . S TMP=$$GET1^DIQ(ZHFN,ZD_",",.03,"I") ; VISIT POINTER
        . S ZDD=$$GET1^DIQ(ZVFN,TMP_",",.01,"I") ; VISIT DATE
        . ;S ZDD=$$GET1^DIQ(ZHFN,ZD_",",1201,"I") ; EVENT DATE FIELD
        . ;S ZDD=$P(^AUPNVHF(ZD,0),U,3) ; DATE IS PIECE 3
        . ;S OK=$$GET1^DIQ(ZHFN,ZA_",",81101,"","ZAC") ; ARRIVAL TIME
        . S ZAC=$G(^AUPNVHF(ZA,811)) ; THE TIME
        . ;S OK=$$GET1^DIQ(ZHFN,ZD_",",81101,"","ZDC") ; DEPARTURE TIME
        . S ZDC=$G(^AUPNVHF(ZD,811)) ; DEPARTURE TIME
        . N ZT ; THE TIME DIFFERENCE BETWEEN THE DATES
        . W !,!,"PATIENT: ",ZI," ",$P(^DPT(ZI,0),U,1)
        . W !,"IN: ",$$FMTE^XLFDT(ZAD_"."_ZAC)," OUT: ",$$FMTE^XLFDT(ZDD_"."_ZDC)
        . S G1=($E(ZDC,1,2)*60)+($E(ZDC,3,4))
        . S G2=($E(ZAC,1,2)*60)+($E(ZAC,3,4))
        . I (ZDD-ZAD)>0 S G1=G1+(((ZDD-ZAD)*24)*60)
        . S GTOT=G1-G2
        . W !,"TIME: ",GTOT," ESTIMATED"
        . S ZT=$$DTDIFF^C0QUTIL(ZDD,ZDC,ZAD,ZAC) ; COMPUTE THE DIFFERENCE IN MINUTES
        . W !,"COMPUTED MINUTES: ",ZT
        . ;I ZT'=GTOT B  ; LET'S FIND OUT WHAT'S WRONG
        . I ZT<0 D  Q  ; SKIP PATIENTS WITH NEGATIVE TIMES
        . . W !,"****EXCLUDED****"
        . I ZT>400000 D  Q  ; THESE ARE ERRORS
        . . W !,"****EXCLUDED****"
        . S ZARY1(ZT,ZI)="" ; ARRAY ORDERED BY MINUTES OF PATIENTS
        N ZY,ZZ S ZY="" S ZZ=""
        N ZCOUNT S ZCOUNT=0
        F  S ZY=$O(ZARY1(ZY)) Q:ZY=""  D  ; FOR EACH TIME
        . F  S ZZ=$O(ZARY1(ZY,ZZ)) Q:ZZ=""  D  ; FOR EACH PATIENT WITH THIS TIME
        . . S ZCOUNT=ZCOUNT+1
        . . S ZARY2(ZCOUNT,ZY,ZZ)=""
        . . ;W !,ZCOUNT," PATIENT: ",ZZ," MINUTES: ",ZY
        N ZMID
        S ZMID=$P(ZCOUNT/2,".")
        W !,"NUMBER OF PATIENTS IN REPORT: ",ZCOUNT
        W !,"ED ARRIVAL TIME UNTIL ",ZHF
        W !,"MEDIAN TIME: ",$O(ZARY2(ZMID,""))
        Q
        ;
        ; LOOK AT GETTING RID OF PRINT AND SS AS THEY ARE NOT BEING USED. GPL
        ; VEN/SMH - Call is used in C0QMU12, perhaps not called.
        ;
PRINT   ; PRINT TO SCREEN 
        I $D(WARD) W !!,WARD_"-"_WARDNAME_" "_RB_": "_PTNAME_"("_PTSEX_") "
        I $D(EXDTE) D  ;
        . W !,"Discharge Date: ",EXDTE
        . W !,DFN," ",PTNAME
        W !,"DOB: ",PTDOB," HRN: ",PTHRN
        W !,"Language Spoken: ",$G(PTLANG)
        W !,"Race: ",RACEDSC
        W !,"Ethnicity: ",$G(ETHNDSC)
        W !,"Problems: "
        W !,PBDESC
        W !,"Allergies: "
        W !,ALDESC
        W !,"Medications: "
        W !
        Q
        ;
SS      ; CREATE SPREADSHEET ARRAY
        S G1("Patient")=DFN
        I $D(WARD) D  ;
        . S G1("WardName")=WARDNAME
        . S G1("RoomAndBed")=RB
        I $D(EXDTE) D  ; 
        . S G1("DischargeDate")=EXDTE
        S G1("PatientName")=PTNAME
        S G1("Gender")=PTSEX
        S G1("DateOfBirth")=PTDOB
        S G1("HealthRecordNumber")=PTHRN
        S G1("LanguageSpoken")=$G(PTLANG)
        S G1("Race")=RACEDSC
        S G1("Ehtnicity")=$G(ETHNDSC)
        S G1("Problem")=PBDESC
        I PBDESC["No problems found" S G1("HasProblem")=0
        E  S G1("HasProblem")=1
        S G1("Allergies")=ALDESC
        I ALDESC["No Allergy" S G1("HasAllergy")=0
        E  S G1("HasAllergy")=1
        I $D(MDITEM) D  ;
        . S G1("HasMed")=1
        E  S G1("HasMed")=0
        S G1("MedDescription")=$G(MDDESC)
        I $D(MDITEM) W !,"("_MDITEM_")"_MDDESC E  W !,MDDESC
        D RNF1TO2B^C0CRNF("GRSLT","G1")
        K G1
        Q  ; DON'T WANT TO DO THE NHIN STUFF NOW
        ;
PATLIST ; CREATE PATIENT LISTS
        ; WANT TO GET RID OF PATLIST AND MOVE FUNCTION TO OTHER ROUTINES. GPL
        ; VEN/SMH - Call is moved here. Seems to be used in C0QMU12. 
        ; Think about removing at another time.
        S C0QLIST(ZYR_"Patient",DFN)="" ; THE PATIENT LIST
        N DEMOYN S DEMOYN=1
        I $G(PTSEX)="" S DEMOYN=0
        I $G(PTDOB)="" S DEMOYN=0
        I $G(PTHRN)="" S DEMOYN=0
        I $G(PTLANG)="" S DEMOYN=0
        I $G(RACEDSC)="" S DEMOYN=0
        I $G(ETHNDSC)="" S DEMOYN=0
        ;I DEMOYN S C0QLIST("HasDemographics",DFN)=""
        ;E  S C0QLIST("FailedDemographics",DFN)=""
        ;S G1("Gender")=PTSEX
        ;S G1("DateOfBirth")=PTDOB
        ;S G1("HealthRecordNumber")=PTHRN
        ;S G1("LanguageSpoken")=$G(PTLANG)
        ;S G1("Race")=RACEDSC
        ;S G1("Ehtnicity")=$G(ETHNDSC)
        S G1("Problem")=PBDESC
        I PBDESC["No problems found" S C0QLIST(ZYR_"NoProblem",DFN)=""
        E  S C0QLIST(ZYR_"HasProblem",DFN)=""
        ;S G1("Allergies")=ALDESC
        I ALDESC["No Allergy" S C0QLIST(ZYR_"NoAllergy",DFN)=""
        E  S C0QLIST(ZYR_"HasAllergy",DFN)=""
        ;I $D(MDITEM) D  ;
               ;. S C0QLIST("HasMed",DFN)=""
        ;E  S G1("NoMed",DFN)=""
        ;S G1("MedDescription")=$G(MDDESC)
        Q
        ;
NHIN    ; SHOW THE NHIN ARRAY FOR THIS PATIENT
        Q:DFN=137!(DFN=14)
        D EN^C0CNHIN(.G,DFN,"")
        D ZWRITE^C0QUTIL("G")
        K G
        ;
        QUIT  ;end of WARD
        ;
