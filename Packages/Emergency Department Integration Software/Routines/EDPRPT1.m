EDPRPT1 ;SLC/MKB - Activity Report
        ;;1.0;EMERGENCY DEPARTMENT;**1**;Sep 30, 2009;Build 74
        ;
ACT(BEG,END)    ; Get Activity Report for EDPSITE by date range
        N LOG,X,X0,X1,X3,DX,IN,OUT,ROW,PROV,I
        N ELAPSE,TRIAGE,WAIT,ADMDEC,ADMDEL,ALL,ADM,NOT,DISP
        D INIT ;set counters, sums to 0
        D:'$G(CSV) XML^EDPX("<logEntries>") I $G(CSV) D  ;headers
        . N TAB S TAB=$C(9)
        . S X="ED"_TAB_"Time In"_TAB_"Time Out"_TAB_"Complaint"_TAB_"MD"_TAB_"Acuity"_TAB_"Elapsed"_TAB_"Triage"_TAB_"Wait"_TAB_"Dispo"_TAB_"Adm Dec"_TAB_"Adm Delay"_TAB_"Arrival"_TAB_"Diagnosis"_TAB_"ICD9"
        . D ADD^EDPCSV(X)
        S IN=BEG-.000001
        F  S IN=$O(^EDP(230,"ATI",EDPSITE,IN)) Q:'IN  Q:IN>END  S LOG=0 F  S LOG=+$O(^EDP(230,"ATI",EDPSITE,IN,LOG)) Q:LOG<1  D
        . S X0=^EDP(230,LOG,0),X1=$G(^(1)),X3=$G(^(3))
        . S OUT=$P(X0,U,9),DX=$$DXPRI^EDPQPCE(+$P(X0,U,3),LOG)
        . K ROW S ROW("id")=LOG,ALL=ALL+1
        . S ROW("inTS")=$S($G(CSV):$$EDATE^EDPRPT(IN),1:IN)
        . S ROW("outTS")=$S($G(CSV):$$EDATE^EDPRPT(OUT),1:OUT)
        . S ROW("complaint")=$P(X1,U)
        . S DISP=$$ECODE^EDPRPT($P(X1,U,2)),ROW("disposition")=DISP
        . S ROW("arrival")=$$ENAME^EDPRPT($P(X1,U,10))
        . S ROW("acuity")=$$ECODE^EDPRPT($P(X3,U,3))
        . S ROW("md")=$$EPERS^EDPRPT($P(X3,U,5))
        . S:$P(X3,U,5) PROV(+$P(X3,U,5))=""
        . S ROW("icd")=$P(DX,U),ROW("dx")=$P(DX,U,2)
        . S:'$L(DISP) DISP="none" S DISP(DISP)=DISP(DISP)+1
        . ;
A1      . ; calculate times
        . ; S:OUT="" OUT=NOW ;for calculations
        . S ELAPSE=$S(OUT:($$FMDIFF^XLFDT(OUT,IN,2)\60),1:0)
        . S ROW("elapsed")=ELAPSE_$S(ELAPSE>359:" *",1:"")
        . S ALL("elapsed")=ALL("elapsed")+ELAPSE
        . S DISP(DISP,"elapsed")=DISP(DISP,"elapsed")+ELAPSE
        . ;
        . S X=$$ACUITY^EDPRPT(LOG),TRIAGE=0 ;S:X<1 X=OUT
        . S:X TRIAGE=($$FMDIFF^XLFDT(X,IN,2)\60)
        . S ROW("triage")=TRIAGE,ALL("triage")=ALL("triage")+TRIAGE
        . S DISP(DISP,"triage")=DISP(DISP,"triage")+TRIAGE
        . ;
        . S X=$$LVWAITRM^EDPRPT(LOG),WAIT=0
        . S:X WAIT=($$FMDIFF^XLFDT(X,IN,2)\60)
        . S ROW("wait")=WAIT,ALL("wait")=ALL("wait")+WAIT
        . S DISP(DISP,"wait")=DISP(DISP,"wait")+WAIT
        . ;
        . S X=$$ADMIT^EDPRPT(LOG) I X<1 D
        .. S NOT=NOT+1,NOT("elapsed")=NOT("elapsed")+ELAPSE
        .. S NOT("triage")=NOT("triage")+TRIAGE
        .. S NOT("wait")=NOT("wait")+WAIT
        . E  D  ;decision to admit
        .. S ADMDEC=($$FMDIFF^XLFDT(X,IN,2)\60)
        .. S ADMDEL=$S(OUT:($$FMDIFF^XLFDT(OUT,X,2)\60),1:0)
        .. S ROW("admDec")=ADMDEC,ROW("admDel")=ADMDEL
        .. S ADM=ADM+1,ADM("elapsed")=ADM("elapsed")+ELAPSE
        .. S ADM("triage")=ADM("triage")+TRIAGE
        .. S ADM("wait")=ADM("wait")+WAIT
        .. S ADM("admDec")=ADM("admDec")+ADMDEC
        .. S ADM("admDel")=ADM("admDel")+ADMDEL
        .. S DISP(DISP,"admDec")=DISP(DISP,"admDec")+ADMDEC
        .. S DISP(DISP,"admDel")=DISP(DISP,"admDel")+ADMDEL
        . ;
        . I '$G(CSV) S X=$$XMLA^EDPX("log",.ROW) D XML^EDPX(X) Q
        . S X=ROW("id")
        . F I="inTS","outTS","complaint","md","acuity","elapsed","triage","wait","disposition","admDec","admDel","arrival","dx","icd" S X=X_$C(9)_$G(ROW(I))
        . D ADD^EDPCSV(X)
        D:'$G(CSV) XML^EDPX("</logEntries>")
        ;
A2      ; calculate & include averages
        Q:ALL<1  ;no visits found
        S ALL("type")="All Patients",NOT("type")="Not Admitted",ADM("type")="Admitted"
        F I="elapsed","triage","wait" S ALL(I)=$$ETIME^EDPRPT(ALL(I)\ALL)
        F I="elapsed","triage","wait" S NOT(I)=$S(NOT:$$ETIME^EDPRPT(NOT(I)\NOT),1:"00:00")
        F I="elapsed","triage","wait","admDec","admDel" S ADM(I)=$S(ADM:$$ETIME^EDPRPT(ADM(I)\ADM),1:"00:00")
        F I="admDec","admDel" S ALL(I)=ADM(I)
        S ALL("total")=ALL,NOT("total")=NOT,ADM("total")=ADM
        S X="" F  S X=$O(DISP(X)) Q:X=""  I DISP(X) D
        . S DISP(X,"total")=DISP(X),DISP(X,"type")=X
        . F I="elapsed","triage","wait","admDec","admDel" S DISP(X,I)=$$ETIME^EDPRPT(DISP(X,I)\DISP(X))
        ;
A3      I $G(CSV) D  Q  ;CSV format
        . N TAB,D S TAB=$C(9)
        . D BLANK^EDPCSV
        . S X=TAB_"Total Patients"_TAB_ALL_TAB_TAB_TAB_TAB_ALL("elapsed")_TAB_ALL("triage")_TAB_ALL("wait")_TAB_TAB_ALL("admDec")_TAB_ALL("admDel")
        . D ADD^EDPCSV(X),BLANK^EDPCSV
        . S X=TAB_TAB_TAB_TAB_"Total"_TAB_"Visit"_TAB_"Triage"_TAB_"Wait"_TAB_"Adm Dec"_TAB_"Adm Del"
        . D ADD^EDPCSV(X),BLANK^EDPCSV
        . S X=TAB_TAB_TAB_"Patients Not Admitted"_TAB_NOT_TAB_NOT("elapsed")_TAB_NOT("triage")_TAB_NOT("wait")
        . D ADD^EDPCSV(X),BLANK^EDPCSV
        . S X=TAB_TAB_TAB_"Patients Admitted"_TAB_ADM_TAB_ADM("elapsed")_TAB_ADM("triage")_TAB_ADM("wait")_TAB_ADM("admDec")_TAB_ADM("admDel")
        . D ADD^EDPCSV(X),BLANK^EDPCSV
        . S X=TAB_TAB_TAB_"Disposition" D ADD^EDPCSV(X)
        . S D="" F  S D=$O(DISP(D)) Q:D=""  I DISP(D) D
        .. S X=D_TAB_DISP(D)_TAB_DISP(D,"elapsed")_TAB_DISP(D,"triage")_TAB_DISP(D,"wait")_TAB_DISP(D,"admDec")_TAB_DISP(D,"admDel")
        .. D ADD^EDPCSV(X)
        D XML^EDPX("<averages>")
        S X=$$XMLA^EDPX("average",.ALL) D XML^EDPX(X)
        S X=$$XMLA^EDPX("average",.NOT) D XML^EDPX(X)
        S X=$$XMLA^EDPX("average",.ADM) D XML^EDPX(X)
        S I="" F  S I=$O(DISP(I)) Q:I=""  I DISP(I) K ROW M ROW=DISP(I) S X=$$XMLA^EDPX("average",.ROW) D XML^EDPX(X)
        D XML^EDPX("</averages>")
        ; include list of providers assigned
        I $O(PROV(0)) D PROV^EDPRPT(.PROV)
        Q
        ;
INIT    ; Initialize counters and sums
        N I,DA,X,Y S (ALL,ADM,NOT)=0
        F I="elapsed","triage","wait" S (ALL(I),NOT(I),ADM(I))=0
        F I="admDec","admDel" S ADM(I)=0
        S X="" F  S X=$O(^EDPB(233.1,"AB","disposition",X)) Q:X=""  D
        . S DA=0 F  S DA=$O(^EDPB(233.1,"AB","disposition",X,DA)) Q:DA<1  D
        .. S Y=$$ECODE^EDPRPT(DA) Q:'$L(Y)  S DISP(Y)=0
        .. F I="elapsed","triage","wait","admDec","admDel" S DISP(Y,I)=0
        S DISP("none")=0 F I="elapsed","triage","wait","admDec","admDel" S DISP("none",I)=0
        Q
