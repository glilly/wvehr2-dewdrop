SPNLRK8 ;SD/WDE - SCD LAB TEST UTILIZATION REPORT;Nov 22, 2006
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
P1      ;
        S CNT=0
        ; NDTESTS   Number of different lab tests
        ; TESTNR    Type of Lab test (lab test number)
        ; ORDERS    Number of orders places
        N NDTESTS,TESTNR,OUT,LINE,STARTLIN,COL,ORDERS,NPATS,RESULTS
        S ORDERS=+$G(^TMP("SPN",$J,"CH","ORDERS"))
        S RESULTS=+$G(^TMP("SPN",$J,"CH","RESULTS"))
        S NPATS=+$G(^TMP("SPN",$J,"CH","PAT"))
        S CNT=CNT+1
        S ^TMP($J,"UTIL",CNT)="BOS999"_U_"Totals:  "_ORDERS_" order"_$S(ORDERS=1:"",1:"s")_" placed ("_RESULTS_" result"_$S(RESULTS=1:"",1:"s")_" reported) for "_NPATS_" patient"_$S(NPATS=1:"",1:"s")_"^EOL999"
        S TESTNR=""
        F NDTESTS=0:1 S TESTNR=$O(^TMP("SPN",$J,"CH","TEST",TESTNR)) Q:TESTNR=""
        I NDTESTS=1&(RESULTS>1) S CNT=CNT+1 S ^TMP($J,"UTIL",CNT)="HDR999"_U_"(This includes just one type of lab test)"_"^EOL999"
        I NDTESTS>1 S CNT=CNT+1 S ^TMP($J,"UTIL",CNT)="HDR999"_U_"(These include "_$FN(NDTESTS,",")_" different lab tests)"_"^EOL999"
        S SPZ1="" F  S SPZ1=$O(^TMP("SPN",$J,"CH","ORDERS",SPZ1)) Q:SPZ1=""  D
        .S CNT=CNT+1
        .S ^TMP($J,"UTIL",CNT)=$G(^TMP("SPN",$J,"CH","ORDERS",SPZ1))_U_-SPZ1_"^EOL999"
        Q
P2      ;
        S CNT=CNT+1
        S ^TMP($J,"UTIL",CNT)="BOS999"_U_"Lab Tests with "_$FN(QLIST("MIN"),",")_" or more Results"_"^EOL999"
        S CNT=CNT+1 S ^TMP($J,"UTIL",CNT)="HDR999"_U_"Lab Test"_U_"Results"_U_"Patients"_U_"(# patients)"_"^EOL999"
        S TESTNR=""
        F  S TESTNR=$O(^TMP("SPN",$J,"CH","TEST",TESTNR)) Q:TESTNR=""  D
        . S RESULTS=^TMP("SPN",$J,"CH","TEST",TESTNR)
        . Q:RESULTS<QLIST("MIN")
        . S NPATS=^TMP("SPN",$J,"CH","TEST",TESTNR,"PAT")
        . S NAME=^TMP("SPN",$J,"CH","TEST",TESTNR,"NAME")
        . S ^TMP("SPN",$J,"CH","OUT",-RESULTS,-NPATS,NAME)=TESTNR
        S RESULTS=""
        F  S RESULTS=$O(^TMP("SPN",$J,"CH","OUT",RESULTS)) Q:RESULTS=""  D
        . S NPATS=""
        . F  S NPATS=$O(^TMP("SPN",$J,"CH","OUT",RESULTS,NPATS)) Q:NPATS=""  D
        . . S NAME=""
        . . F  S NAME=$O(^TMP("SPN",$J,"CH","OUT",RESULTS,NPATS,NAME)) Q:NAME=""  D
        . . . S TESTNR=^TMP("SPN",$J,"CH","OUT",RESULTS,NPATS,NAME)
        . . . S MAXTESTS=$O(^TMP("SPN",$J,"CH","TEST",TESTNR,"RESULTS",""))
        . . . S MAXPATS=^TMP("SPN",$J,"CH","TEST",TESTNR,"RESULTS",MAXTESTS)
        . . . S CNT=CNT+1
        . . . S ^TMP($J,"UTIL",CNT)=NAME_U_-RESULTS_U_-NPATS
        . . . I RESULTS'=NPATS&(-RESULTS>1)&(-NPATS>1) S ^TMP($J,"UTIL",CNT)=^TMP($J,"UTIL",CNT)_U_-MAXTESTS_"("_MAXPATS_")"
        . . . S ^TMP($J,"UTIL",CNT)=^TMP($J,"UTIL",CNT)_"^EOL999"
        Q
P3      ;
        N RESULTS,NDTESTS,PID,PNAME,PSSN,I,ORDERS
        S CNT=CNT+1
        S ^TMP($J,"UTIL",CNT)="BOS999"_U_"HIGH USERS"_"^EOL999"
        S CNT=CNT+1
        S ^TMP($J,"UTIL",CNT)="HDR999"_U_"Patient Name"_U_"SSN"_U_"Orders"_U_"Results"_U_"Different Lab Tests"_"^EOL999"
        S ORDERS=""
        F I=1:1:HIUSERS S ORDERS=$O(^TMP("SPN",$J,"CH","HI","H1",ORDERS)) Q:ORDERS=""  D
        . S RESULTS=""
        . F  S RESULTS=$O(^TMP("SPN",$J,"CH","HI","H1",ORDERS,RESULTS)) Q:RESULTS=""  D
        . . S NDTESTS=""
        . . F  S NDTESTS=$O(^TMP("SPN",$J,"CH","HI","H1",ORDERS,RESULTS,NDTESTS)) Q:NDTESTS=""  D
        . . . S PID=""
        . . . F  S PID=$O(^TMP("SPN",$J,"CH","HI","H1",ORDERS,RESULTS,NDTESTS,PID)) Q:PID=""  D
        . . . . D GETNAME^SPNLRU(PID,.PNAME,.PSSN)
        . . . . S CNT=CNT+1
        . . . . S ^TMP($J,"UTIL",CNT)=PNAME_U_PSSN_U_-ORDERS_U_-RESULTS_U_-NDTESTS_"^EOL999"
        Q
KILL    ;CALLED FROM MAIN ROUTINE
        K NDTESTS,NAME,MAXTESTS,MAXPATS,HIUSERS,CNT,QLIST,SPZ1
