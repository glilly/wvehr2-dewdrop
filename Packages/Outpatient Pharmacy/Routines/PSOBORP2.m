PSOBORP2        ;ALBANY/BLD - TRICARE BYPASS/OVERRIDE AUDIT REPORT ;7/1/2010
        ;;7.0;OUTPATIENT PHARMACY;**358**;DEC 1997;Build 35
        ;
        ;
        Q
        ;
EN(RX,RFL,RESP) ;
        ;entry point to insert an entry in to the Tricare Audit Report
        ;       Passed In:
        ;       RX =   Prescription file (52) IEN
        ;       RFL =  Prescription refill number
        ;       RESP = response back from ECME billing. (from ECMESN^PSOBPSU1)
        ;
        ;
        N REFILNBR,TRITXT
        S TRITXT=$P(RESP,"^",2)
        D AUDIT^PSOTRI(RX,RFL,,TRITXT,"I")
        ;
        Q
        ;
RUNRPT(PSOSEL)  ;
        ;
        ;THE INFORMATION FOR THE TRICARE BYPASS / OVERRIDE REPORT WILL BE GATHERED BY LOOPING THROUGH 
        ;FILE 52.87 (PSO TRICARE AUDIT LOG FILE) TO RETRIEVE THE INFORMATION BASED UPON THE FILTERING 
        ;REQUIREMENTS IN ROUTINE PSOBORP0.
        ;
        ;  SEE TRICARE BYPASS / OVERRIDE REPORT SDD FOR MOCK UP OF REPORT
        ;
        D EN^PSOBORP3(.PSOSEL)
        ;
        ;
PROCESS(PSOSEL,PSOAUD)  ;this will process file 52.87, the Tricare Audit File
        ;
        N ACTDT,BEGDT,ENDDT,DIVISION,I,PHAMCST,PROVIDER,PSOFILL,PSOD0,PSOARRAY,PSORX,REJCODE,TCTYPE,REJIEN,TCTYPE
        S BEGDT=PSOSEL("BEGIN DATE"),ENDDT=PSOSEL("END DATE")
        S ACTDT=BEGDT,PSOD0=0
        D PSOARRAY(.PSOARRAY)
        F  S ACTDT=$O(^PS(52.87,"E",ACTDT)) Q:ACTDT=""!(ACTDT\1>ENDDT)  D
        .F  S PSOD0=$O(^PS(52.87,"E",ACTDT,PSOD0)) Q:PSOD0=""  D
        ..;
        ..;quit if duplicate prescription
        ..S PSORX=$P(^PS(52.87,PSOD0,0),"^",2)
        ..S PSOFILL=$P(^PS(52.87,PSOD0,0),"^",3)
        ..I PSOD0'=PSOARRAY(PSORX,PSOFILL) Q
        ..;
        ..;quit if division not selected or not all
        ..S DIVISION=$P(^PS(52.87,PSOD0,0),"^",5)
        ..I PSOSEL("DIVISION")'="A" Q:'$D(PSOSEL("DIVISION",DIVISION))
        ..S DIVISION=$P(^PS(59,DIVISION,0),"^",1)
        ..;
        ..;quit if audit type not selected or not all
        ..S TCTYPE=$P(^PS(52.87,PSOD0,1),"^",2)
        ..Q:'$D(PSOSEL("REJECT CODES",TCTYPE))
        ..S TCTYPE=$S(TCTYPE="I":"TRICARE INPATIENT",TCTYPE="N":"TRICARE NON-BILLABLE PRODUCT",TCTYPE="R":"TRICARE REJECT OVERRIDE",1:"ALL")
        ..;
        ..;quit if specific pharmacist not selected or not all
        ..S PHAMCST=$P(^PS(52.87,PSOD0,1),"^",4)
        ..I PHAMCST'="",PSOSEL("PHARMACIST")'="A" Q:'$D(PSOSEL("PHARMACIST",PHAMCST))
        ..S PHAMCST=$P(^VA(200,PHAMCST,0),"^",1)
        ..;
        ..;quit if specific provider not selected or not all
        ..S PROVIDER=$P(^PS(52.87,PSOD0,0),"^",6)
        ..I PSOSEL("PROVIDER")'="A" Q:'$D(PSOSEL("PROVIDER",PROVIDER))
        ..S PROVIDER=$P(^VA(200,PROVIDER,0),"^",1)
        ..;
        ..;summary report
        ..I PSOSEL("SUM_DETAIL")="D"!(PSOSEL("SUM_DETAIL")="S") D
        ...;totals by provider
        ...I PSOSEL("TOTALS BY")="P" D  Q
        ....S PSOAUD(DIVISION,TCTYPE,PROVIDER,ACTDT,0)=^PS(52.87,PSOD0,0)
        ....S PSOAUD(DIVISION,TCTYPE,PROVIDER,ACTDT,1)=^PS(52.87,PSOD0,1)
        ....S PSOAUD(DIVISION,TCTYPE,PROVIDER,ACTDT,2)=^PS(52.87,PSOD0,2)
        ...;
        ...;totals by pharmacist and Division
        ...I PSOSEL("TOTALS BY")="R" D  Q
        ....S PSOAUD(DIVISION,TCTYPE,PHAMCST,ACTDT,0)=^PS(52.87,PSOD0,0)
        ....S PSOAUD(DIVISION,TCTYPE,PHAMCST,ACTDT,1)=^PS(52.87,PSOD0,1)
        ....S PSOAUD(DIVISION,TCTYPE,PHAMCST,ACTDT,2)=^PS(52.87,PSOD0,2)
        ..;
        ..S REJIEN=0,REJCODE=""
        ..F  S REJIEN=$O(^PS(52.87,PSOD0,3,REJIEN)) Q:'REJIEN  D
        ...I PSOSEL("TOTALS BY")="P" S PSOAUD(DIVISION,TCTYPE,PROVIDER,ACTDT,3,REJIEN)=^PS(52.87,PSOD0,3,REJIEN,0)
        ...I PSOSEL("TOTALS BY")="R" S PSOAUD(DIVISION,TCTYPE,PHAMCST,ACTDT,3,REJIEN)=^PS(52.87,PSOD0,3,REJIEN,0)
        ;
        Q
        ;
END     ;
        I 'PSOEXCEL W !!!!,"REPORT HAS FINISHED"
        K DIVRXTOT,DIVTOT,GRDRXTOT,GROUPCNT,GRDTOT,PAGE,PROV,PSODIV,PSOCNT,PSORPTNM,PSORTYPE,PSOTOTAL,TC,TCT
        Q
        ;
GETPARAM(PSOFLDNO,PSODUZ)       ;
        Q $$GET^XPAR(PSODUZ_";VA(200,","PSOS USRSCR",PSOFLDNO,"I")
        ;
        ;
UP(PSVAR)       ;converts to upper case
        Q $TR(PSVAR,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        ;
        ;
        ;will build an of array of RX's to eliminate duplicates.
PSOARRAY(PSOARRAY)      ;
        N ACTDT,BEGDT,ENDDT,DIVISION,I,PHAMCST,PROVIDER,PSOD0,PSOFILL,REJCODE,TCTYPE,REJIEN,TCTYPE
        S BEGDT=PSOSEL("BEGIN DATE"),ENDDT=PSOSEL("END DATE")
        S ACTDT=BEGDT,PSOD0=0
        F  S ACTDT=$O(^PS(52.87,"E",ACTDT)) Q:ACTDT=""!(ACTDT\1>ENDDT)  D
        .F  S PSOD0=$O(^PS(52.87,"E",ACTDT,PSOD0)) Q:PSOD0=""  D
        ..S PSOFILL=$P(^PS(52.87,PSOD0,0),"^",3)
        ..S PSOARRAY($P(^PS(52.87,PSOD0,0),"^",2),PSOFILL)=PSOD0
        Q
