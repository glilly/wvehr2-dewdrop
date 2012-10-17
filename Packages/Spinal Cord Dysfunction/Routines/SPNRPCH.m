SPNRPCH ;SD/WDE - Returns PHARMACY RX'S WHEN AN RX MATCHES THE FIRST TWO CHAR;DEC 17, 2009
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ;     INTEGRATION REFERENCE DBIA90-B
        ;     NTEGRATION REFERENCE   4820
        ;     INTEGRATION REFERENCES 4533
        ;
        ;
        ;
        ;
        ;NOTE  this routine will find prescriptions based on the
        ;THE FIRST TWO CHARACTERS IN THE NATIONAL DRUG CLASS
        ;ie IN, AM
        ;NOTE  To find prescriptions based on the WHOLE NDC USE SPNRPCI
        ;Parm values;
        ;ICN is THE icn of the pt
        ;CUTDATE is the date to start collection data from
        ;ROOT is the the global where the data is stored.
        ;TYPE will be for the drug class
        ;1 is rx's that have a drug class that
        ;begin with either a XA OR XX.
        ;2 LOOKS FOR RX's THAT THE NDC BEGINS WITH 'IM' AND THE 
        ;  DRUG NAME HAS INFLUENZA IN THE TEXT
        ;Returns:
        ;TMP($J,x) sorted by most recent rx
        ;VA CLASS ^ ITEM DESCRIPTION ^ DATE DISPENSED ^ PSRX(IEN
        ;
COL(ROOT,ICN,CUTDATE,TYPE)      ;
        S X=CUTDATE S %DT="T" D ^%DT S CUTDATE=Y
        K ^TMP($J)
        S ROOT=$NA(^TMP($J))
        ;************************
        Q:ICN=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:DFN=""
        ;************************
        D @TYPE
        D BLDUTIL
        D RESORT
        K RXORD,CNT,RXNUM,VACLASS,VACLASNA,COL,TYPE,DRUGNAM,VACLASDS,DESPDT
        K REVDT,SPNCNT,RXORD,RXNUM,SPNDRIEN,SPNDRNA,SPNDISP,CUTDATE,SPNREV,SPNCOL,SPNCLA
        K %DT,DFN,RXX,SHOWDT,TESTVAL,T,X,Y,TYPE,TESTVAL,SPNDISP,SPNDFN,DTZ
        Q
        ;
        ;
BLDUTIL ;
        S SPNCNT=0
        K ^TMP($J)
        D RX^PSO52API(DFN,"SPNSCRPT",,,0,2650101)
        Q:DFN=""
        Q:$G(^TMP($J,"SPNSCRPT",DFN,0))'>0
        ;RETURNS
        ;^TMP($J,"SPNSCRPT",4570,2367165,.01)=800085513
        ;          1)=2990514^MAY 14, 1999
        ;          6)=5721^OXYCODONE 5MG/ACETAMINOPHEN 325MG TA
        S RXNUM=0
        Q:DFN=""
        F  S RXNUM=$O(^TMP($J,"SPNSCRPT",DFN,RXNUM)) Q:RXNUM'>0  D
        .S SPNDRIEN=$P($G(^TMP($J,"SPNSCRPT",DFN,RXNUM,6)),U,1)  ;DRUG IEN
        .Q:SPNDRIEN=""
        .S SPNDRNA=$P($G(^TMP($J,"SPNSCRPT",DFN,RXNUM,6)),U,2)  ;DRUG NAME
        .Q:SPNDRNA=""
        .S SPNDISP=$P($G(^TMP($J,"SPNSCRPT",DFN,RXNUM,1)),U,1)  ;DISPENSE DATE
        .Q:SPNDISP=""
        .Q:SPNDISP<CUTDATE
        .S SPNREV=9999999-SPNDISP  ;USED TO SET UP FILE IN REVERSE ORDER
        .K ^TMP($J,"SPNPRE")
        .;--------------------------------------------------------------------
        .D ZERO^PSS50(,SPNDRIEN,,,,"SPNPRE")
        .;^TMP($J,"SPNPRE",5721,.01)=OXYCODONE 5MG/ACETAMINOPHEN 325MG TAB
        .;                      2)=CN101
        .;-----------------------------------------------------------------------
        .S SPNCLA=$P($G(^TMP($J,"SPNPRE",SPNDRIEN,2)),U,1)
        .;JAS - DEFECT 1183 - Check to quit if drug is missing VA Class
        .Q:SPNCLA=""
        .S SPNCOL=0
        .I $G(TESTVAL($E(SPNCLA,1,2)))'="" D
        ..S SPNCOL=1
        .I TYPE=2 D
        ..I SPNDRNA'["INFLUENZA" S SPNCOL=0
        .I SPNCOL=1 D
        ..S SPNCNT=SPNCNT+1
        ..S Y=SPNDISP D DD^%DT S SPNDISP=Y
        ..S ^TMP($J,"KEEP",SPNREV,SPNCNT)=SPNCLA_U_SPNDRNA_U_SPNDISP_U_"PSRX("_RXNUM
        .K ^TMP($J,"SPNPRE")
        Q
RESORT  ;
        S SPNCNT=0
        S SPNREVD=0 F  S SPNREVD=$O(^TMP($J,"KEEP",SPNREVD)) Q:(SPNREVD="")!('+SPNREVD)  D
        .S SPNX=0 F  S SPNX=$O(^TMP($J,"KEEP",SPNREVD,SPNX)) Q:(SPNX="")!('+SPNX)  D
        ..S SPNCNT=SPNCNT+1
        ..S ^TMP($J,SPNCNT)=$G(^TMP($J,"KEEP",SPNREVD,SPNX))_"^EOL999"
        K ^TMP($J,"UTIL")
        K ^TMP($J,"KEEP")
        K ^TMP($J,"SPNPRE")
        K ^TMP($J,"SPNSCRPT")
        K SPNREVD,SPNX,SPNCNT,Y,SPZZ,SPNTMP
        Q
1       ;Prosticis Rx's
        ;TO SET UP LOCAL ARRAY FOR TESTING
        S TESTVAL("XA")="XA"
        S TESTVAL("XX")="XX"
        Q
2       ;DRUG CLASS IM
        S TESTVAL("IM")="IM"
        Q
