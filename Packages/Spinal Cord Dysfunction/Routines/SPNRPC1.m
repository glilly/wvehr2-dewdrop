SPNRPC1 ;SD/WDE- Routine to list basic Patient data;DEC 26, 2006
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ; RPC: SPN GET VADPT DATA
        ;
        ;        INTEGRATION REFERENCE INQUIRY #4938 FOR ICN
        ;    INTEGRATION REFERENCE INQUIRY #10061
        ;    Refer to this link for documentation on the vadpt calls / return values
        ;    http://www.va.gov/vdl/documents/Clinical/Admis_Disch_Transfer_(ADT)/pimstm.doc
        ;
        ;
COL(ROOT,SPN1DFN,ICN)   ;
        K ^TMP($J)
        S ROOT=$NA(^TMP($J))
        ;JAS 01-15-2008 PUGET ERROR TRAP-DEFECT 1058 (ADDED NEXT LINE)
        I SPN1DFN=""&($G(ICN)="") Q
        ;**************************************
        I $G(ICN) D
        .S SPN2DFN=$$FLIP^SPNRPCIC(ICN)
        I $G(ICN) I $G(SPN2DFN)="" S ^TMP($J,1)="COULD NOT MATCH UP ICN WITH A DFN" K KILL Q
        ;**************************************
        I $G(ICN) I $G(SPN1DFN) I $G(SPN2DFN) I SPN1DFN'=DFN S ^TMP($J,1)="DFN AND ICN ARE NOT MATCHED" D KILL Q
        I $G(ICN)="" S DFN=SPN1DFN
ALL     ;
        K VA,VADM,VAHOW
        D DEM^VADPT
        I VAERR=1 S ^TMP($J,999999999)="VADPT RETURNED AN ERROR" D KILL Q
        S SPNCNT=1
        S SPNICN=$$GET1^DIQ(2,DFN_",",991.01,"E")
        S ^TMP($J,SPNCNT)="VA(ICN)^"_SPNICN_"^EOL999"
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="BOS VADM^EOL999"
        S ^TMP($J,SPNCNT)="VA(BID)^"_$G(VA("BID"))_"^EOL999"
        K VA("BID")
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VA(PID)^"_$G(VA("PID"))_"^EOL999"
        S SPNSUB=0 F SPNSUB=1,2,3,4,5,6,7,8,9,10 D
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,SPNCNT)="VADM("_SPNSUB_")^"_$G(VADM(SPNSUB))_"^EOL999"
        .Q
        K VA("PID")
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VADM(11)^"_$G(VADM(11))_"^EOL999"
        S SPNSUB=0 F  S SPNSUB=$O(VADM(11,SPNSUB)) Q:(SPNSUB="")!('+SPNSUB)  D
        .S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VADM(11,"_SPNSUB_")^"_$G(VADM(11,SPNSUB))_"^EOL999"
        .Q
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VADM(12)^"_$G(VADM(12))_"^EOL999"
        S SPNSUB=0 F  S SPNSUB=$O(VADM(12,SPNSUB)) Q:(SPNSUB="")!('+SPNSUB)  D
        .S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VADM(12,"_SPNSUB_")^"_$G(VADM(12,SPNSUB))_"^EOL999" D
        ..S SPNSUBB=0 F  S SPNSUBB=$O(VADM(12,SPNSUB,SPNSUBB)) Q:(SPNSUBB="")!('+SPNSUBB)  D
        ...S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VADM(12,"_SPNSUB_","_SPNSUBB_")^"_$G(VADM(12,SPNSUB,SPNSUBB))_"^EOL999"
        ...Q
        ;ELI
        K VADM
        D ELIG^VADPT
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="BOS VAEL^EOL999"
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VAEL(1)^"_$G(VAEL(1))_"^EOL999"
        S SPNSUB=0 F  S SPNSUB=$O(VAEL(1,SPNSUB)) Q:(SPNSUB="")!('+SPNSUB)  D
        .S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VAEL,1,"_SPNSUB_")^"_$G(VAEL(1,SPNSUB))_"^EOL999"
        .Q
        S SPNSUB=0 F SPNSUB=2,3,4 D
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,SPNCNT)="VAEL("_SPNSUB_")^"_$G(VAEL(SPNSUB))_"^EOL999"
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VAEL(5)^"_$G(VAEL(5))_"^EOL999"
        S SPNSUB=0 F  S SPNSUB=$O(VAEL(5,SPNSUB)) Q:(SPNSUB="")!('+SPNSUB)  D
        .S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VAEL(5,"_SPNSUB_")^"_$G(VAEL(5,SPNSUB))_"^EOL999"
        .Q
        S SPNSUB=0 F SPNSUB=6,7,8,9 D
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,SPNCNT)="VAEL("_SPNSUB_")^"_$G(VAEL(SPNSUB))_"^EOL999"
        K VAEL
        S VAPA("P")=""
        D ADD^VADPT
        S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="BOS VAPA^EOL999"
        S SPNSUB=0 F SPNSUB=1:1:21 D
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,SPNCNT)="VAPA("_SPNSUB_")^"_$G(VAPA(SPNSUB))_"^EOL999"
        .Q
        S SPNSUB=0 F  S SPNSUB=$O(VAPA(22,SPNSUB)) Q:(SPNSUB="")!('+SPNSUB)  D
        .S SPNCNT=SPNCNT+1 S ^TMP($J,SPNCNT)="VAPA(22,"_SPNSUB_")^"_$G(VAPA(22,SPNSUB))_"^EOL999"
        .Q
        ;RUN THE SAME CALL BUT BRING BACK THE TEMP ADDRESS AND DATES
        K VAPA
        D ADD^VADPT
        S SPNSUB=0 F SPNSUB=1:1:10 D
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,SPNCNT)="VAPA_TEMP_ADDRESS("_SPNSUB_")^"_$G(VAPA(SPNSUB))_"^EOL999"
        K VAPA
        ;OTHER RELATED DATA
        ;Returns other pertinent patient data which is commonly used but not contained in any other calls to VADPT.
        D OPD^VADPT
        S SPNCNT=SPNCNT+1
        S ^TMP($J,SPNCNT)="BOS VAPD^EOL999"
        S SPNSUB=0 F SPNSUB=1:1:7 D
        .S SPNCNT=SPNCNT+1
        .S ^TMP($J,SPNCNT)="VAPD("_SPNSUB_")^"_$G(VAPD(SPNSUB))_"^EOL999"
        .;JAS 01-24-08 DEFECT 834 (NEXT LINE)
        .I SPNSUB=7,$P(^TMP($J,SPNCNT),"^",2)=9 S $P(^TMP($J,SPNCNT),"^",3)="UNKNOWN"
        .Q
        K VAPD
KILL    ;
        K SPNCNT,SPNSUB,SPNSUBB,VAERR,SPNDFN,ICN,DFN
        K SPN2DFN,SPNICN  ;WDE
        Q
