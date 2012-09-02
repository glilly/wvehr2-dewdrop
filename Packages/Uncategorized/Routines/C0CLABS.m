C0CLABS ; CCDCCR/GPL - CCR/CCD PROCESSING FOR LAB RESULTS ; 10/01/08 ; 5/10/12 2:49pm
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;Copyright 2008,2009 George Lilly, University of Minnesota.
        ;Licensed under the terms of the GNU General Public License.
        ;See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
                  ;
MAP(MIXML,DFN,MOXML)    ;TO MAKE THIS COMPATIBLE WITH OLD CALLING FOR EXTRACT
        ; ASSUMES THAT EXTRACT HAS BEEN RUN AND THE VARIABLES STORED IN MIVAR
        ; MIXML,MIVAR, AND MOXML ARE PASSED BY NAME
        ; MIXML IS THE TEMPLATE TO USE
        ; MOXML IS THE OUTPUT XML ARRAY
        ; DFN IS THE PATIENT RECORD NUMBER
        N C0COXML,C0CO,C0CV,C0CIXML
        I '$D(MIVAR) S C0CV="" ;DEFAULT
        E  S C0CV=MIVAR ;PASSED VARIABLE ARRAY
        I '$D(MIXML) S C0CIXML="" ;DEFAULT
        E  S C0CIXML=MIXML ;PASSED INPUT XML
        D RPCMAP(.C0COXML,DFN,C0CV,C0CIXML) ; CALL RPC TO DO THE WORK
        I '$D(MOXML) S C0CO=$NA(^TMP("C0CCCR",$J,DFN,"RESULTS")) ;DEFAULT FOR OUTPUT
        E  S C0CO=MOXML
        ; ZWR C0COXML
        M @C0CO=C0COXML ; COPY RESULTS TO OUTPUT
        Q
        ;
RPCMAP(RTN,DFN,RMIVAR,RMIXML)   ; RPC ENTRY POINT FOR MAPPING RESULTS
        ; RTN IS PASSED BY REFERENCE
        ;N C0CT0,C0CT,C0CV ; CCR TEMPLATE, RESULTS SUBTEMPLATE, VARIABLES
        ;N C0CRT,C0CTT ; TEST REQUEST TEMPLATE, TEST RESULT TEMPLATE
        I '$D(DEBUG) S DEBUG=0 ; DEFAULT NO DEBUGGING
        I RMIXML="" D  ; INPUT XML NOT PASSED
        . D LOAD^C0CCCR0("C0CT0") ; LOAD ENTIRE CCR TEMPLATE
        . D QUERY^C0CXPATH("C0CT0","//ContinuityOfCareRecord/Body/Results","C0CT0R")
        . S C0CT="C0CT0R" ; NAME OF EXTRACTED RESULTS TEMPLATE
        E  S C0CT=RMIXML ; WE ARE PASSED THE RESULTS PART OF THE TEMPLATE
        I RMIVAR="" D  ; LOCATION OF VARIABLES NOT PASSED
        . S C0CV=$NA(^TMP("C0CCCR",$J,"RESULTS")) ;DEFAULT VARIABLE LOCATION
        E  S C0CV=RMIVAR ; PASSED LOCATIONS OF VARS
        D CP^C0CXPATH(C0CT,"C0CRT") ; START MAKING TEST REQUEST TEMPLATE
        D REPLACE^C0CXPATH("C0CRT","","//Results/Result/Test") ; DELETE TEST FROM REQ
        D QUERY^C0CXPATH(C0CT,"//Results/Result/Test","C0CTT") ; MAKE TEST TEMPLATE
        I '$D(C0CQT) S C0CQT=0 ; DEFAULT NOT SILENT
        I 'C0CQT D  ; WE ARE DEBUGGING
        . W "I MAPPED",!
        . W "VARS:",C0CV,!
        . W "DFN:",DFN,!
        . ;D PARY^C0CXPATH("C0CT") ; SECTION TEMPLATE
        . ;D PARY^C0CXPATH("C0CRT") ;REQUEST TEMPLATE (OCR)
        . ;D PARY^C0CXPATH("C0CTT") ;TEST TEMPLATE (OCX)
        D EXTRACT("C0CT",DFN,) ; FIRST CALL EXTRACT
        I '$D(@C0CV@(0)) D  Q  ; NO VARS THERE
        . S RTN(0)=0 ; PASS BACK NO RESULTS INDICATOR
        I @C0CV@(0)=0 S RTN(0)=0 Q ; NO RESULTS
        S RIMVARS=$NA(^TMP("C0CRIM","VARS",DFN,"RESULTS"))
        K @RIMVARS
        M @RIMVARS=@C0CV ; UPDATE RIMVARS SO THEY STAY IN SYNCH
        N C0CI,C0CJ,C0CMAP,C0CTMAP,C0CTMP
        S C0CIN=@C0CV@(0) ; COUNT OF RESULTS (OBR)
        N C0CRTMP ; AREA TO BUILD ONE RESULT REQUEST AND ALL TESTS FOR IT
        N C0CRBASE S C0CRBASE=$NA(^TMP($J,"TESTTMP")) ;WORK AREA
        N C0CRBLD ; BUILD LIST FOR XML - THE BUILD IS DELAYED UNTIL THE END
        ; TO IMPROVE PERFORMANCE
        D QUEUE^C0CXPATH("C0CRBLD","C0CRT",1,1) ;<Results>
        F C0CI=1:1:C0CIN D  ; LOOP THROUGH VARIABLES
        . K C0CMAP,C0CTMP ;EMPTY OUT LAST BATCH OF VARIABLES
        . S C0CRTMP=$NA(@C0CRBASE@(C0CI)) ;PARTITION OF WORK AREA FOR EACH TEST
        . S C0CMAP=$NA(@C0CV@(C0CI)) ;
        . I 'C0CQT W "MAPOBR:",C0CMAP,!
        . ;MAPPING FOR TEST REQUEST GOES HERE
        . D MAP^C0CXPATH("C0CRT",C0CMAP,C0CRTMP) ; MAP OBR DATA
        . ;D QOPEN^C0CXPATH("C0CRBLD",C0CRTMP,C0CIS) ;1ST PART OF XML
        . D QUEUE^C0CXPATH("C0CRBLD",C0CRTMP,2,@C0CRTMP@(0)-4) ;UP TO <Test>
        . I $D(@C0CMAP@("M","TEST",0)) D  ; TESTS EXIST
        . . S C0CJN=@C0CMAP@("M","TEST",0) ; NUMBER OF TESTS
        . . K C0CTO ; CLEAR OUTPUT VARIABLE
        . . F C0CJ=1:1:C0CJN D   ;FOR EACH TEST RESULT
        . . . K C0CTMAP ; EMPTY MAPS FOR TEST RESULTS
        . . . S C0CTMP=$NA(@C0CRBASE@(C0CI,C0CJ)) ;WORK AREA FOR TEST RESULTS
        . . . S C0CTMAP=$NA(@C0CMAP@("M","TEST",C0CJ)) ;
        . . . I 'C0CQT W "MAPOBX:",C0CTMAP,!
        . . . D MAP^C0CXPATH("C0CTT",C0CTMAP,C0CTMP) ; MAP TO TMP
        . . . I C0CJ=1 S C0CJS=2 E  S C0CJS=1 ;FIRST TIME,SKIP THE <Test>
        . . . I C0CJ=C0CJN S C0CJE=@C0CTMP@(0)-1 E  S C0CJE=@C0CTMP@(0) ;</Test>
        . . . S C0CJS=1 S C0CJE=@C0CTMP@(0) ; INSERT ALL OF THE TEXT XML
        . . . D QUEUE^C0CXPATH("C0CRBLD",C0CTMP,C0CJS,C0CJE) ; ADD TO BUILD LIST
        . . . ;I C0CJ=1 D  ; FIRST TIME, JUST COPY
        . . . ;. D CP^C0CXPATH("C0CTMP","C0CTO") ; START BUILDING TEST XML
        . . . ;E  D INSINNER^C0CXPATH("C0CTO","C0CTMP")
        . . . ;
        . . . ;D PUSHA^C0CXPATH("C0CTO",C0CTMP) ;ADD THE TEST TO BUFFER
        . . ; I 'C0CQT D PARY^C0CXPATH("C0CTO")
        . . ;D INSINNER^C0CXPATH(C0CRTMP,"C0CTO","//Results/Result/Test") ;INSERT TST
        . ;D QCLOSE^C0CXPATH("C0CRBLD",C0CRTMP,"//Results/Result/Test") ;END OF XML
        . D QUEUE^C0CXPATH("C0CRBLD","C0CRT",C0CRT(0)-1,C0CRT(0)-1) ;</Result>
        . ;I C0CI=1 D  ; FIRST TIME, COPY INSTEAD OF INSERT
        . . ;D CP^C0CXPATH(C0CRTMP,"RTN") ;
        . ;E  D INSINNER^C0CXPATH("RTN",C0CRTMP) ; INSERT THIS TEST REQUEST
        D QUEUE^C0CXPATH("C0CRBLD","C0CRT",C0CRT(0),C0CRT(0)) ;</Results>
        D BUILD^C0CXPATH("C0CRBLD","RTN") ;RENDER THE XML
        K @C0CRBASE ; CLEAR OUT TEMPORARY STURCTURE
        Q
        ;
EXTRACT(ILXML,DFN,OLXML)        ; EXTRACT LABS INTO THE C0CLVAR GLOBAL
        ;
        ; LABXML AND LABOUTXML ARE PASSED BY NAME SO GLOBALS CAN BE USED
        ;
        ;
        ;
        N C0CNSSN ; IS THERE AN SSN FLAG
        S C0CNSSN=0
        S C0CLB=$NA(^TMP("C0CCCR",$J,"RESULTS")) ; BASE GLB FOR LABS VARS
        D GHL7 ; GET HL7 MESSAGE FOR THIS PATIENT
        I C0CNSSN=1 D  Q  ; NO SSN, CAN'T GET HL7 FOR THIS PATIENT
        . S @C0CLB@(0)=0
        K @C0CLB ; CLEAR OUT OLD VARS IF ANY
        N QTSAV S QTSAV=C0CQT ;SAVE QUIET FLAG
        S C0CQT=1 ; SURPRESS LISTING
        D LIST ; EXTRACT THE VARIABLES
        ; FOR CERTIFICATION, SEE IF THERE ARE OTHER RESULTS TO ADD
        D EN^C0CORSLT(C0CLB,DFN) ; LOOKS FOR ECG TESTS
        S C0CQT=QTSAV ; RESET SILENT FLAG
        K ^TMP("HLS",$J) ; KILL HL7 MESSAGE OUTPUT
        I $D(OLXML) S @OLXML@(0)=0 ; EXTRACT DOES NOT PRODUCE XML... SEE MAP^C0CLABS
        Q
            ;
GHL7    ; GET HL7 MESSAGE FOR LABS FOR THIS PATIENT
        ; N C0CPTID,C0CSPC,C0CSDT,C0CEDT,C0CR
        ; SET UP FOR LAB API CALL
        S C0CPTID=$$SSN^C0CDPT(DFN) ; GET THE SSN FOR THIS PATIENT
        I C0CPTID="" D  Q  ; NO SSN, COMPLAIN AND QUIT
        . W "LAB LOOKUP FAILED, NO SSN",!
        . S C0CNSSN=1 ; SET NO SSN FLAG
        S C0CSPC="*" ; LOOKING FOR ALL LABS
        ;I $D(^TMP("C0CCCR","RPMS")) D  ; RUNNING RPMS
        ;. D DT^DILF(,"T-365",.C0CSDT) ; START DATE ONE YEAR AGO TO LIMIT VOLUME
        ;E  D DT^DILF(,"T-5000",.C0CSDT) ; START DATE LONG AGO TO GET EVERYTHING
        ;D DT^DILF(,"T",.C0CEDT) ; END DATE TODAY
        S C0CLLMT=$$GET^C0CPARMS("LABLIMIT") ; GET THE LIMIT PARM
        S C0CLSTRT=$$GET^C0CPARMS("LABSTART") ; GET START PARM
        D DT^DILF(,C0CLLMT,.C0CSDT) ;
        W "LAB LIMIT: ",C0CLLMT,!
        D DT^DILF(,C0CLSTRT,.C0CEDT) ; END DATE TODAY - IMPLEMENT END DATE PARM
        S C0CEDT=$$NOW^XLFDT ; PULL LABS STARTING NOW
        S C0CR=$$LAB^C0CLA7Q(C0CPTID,C0CSDT,C0CEDT,C0CSPC,C0CSPC) ; CALL LAB LOOKUP
        Q
        ;
LIST    ; LIST THE HL7 MESSAGE; ALSO, EXTRACT THE RESULT VARIABLES TO C0CLB
        ;
        ; N C0CI,C0CJ,C0COBT,C0CHB,C0CVAR
        I '$D(C0CLB) S C0CLB=$NA(^TMP("C0CCCR",$J,"RESULTS")) ; BASE GLB FOR LABS VARS
        I '$D(C0CQT) S C0CQT=0
        I '$D(DFN) S DFN=1 ; DEFAULT TEST PATIENT
        I '$D(^TMP("C0CCCR","LABTBL",0)) D SETTBL ;INITIALIZE LAB TABLE
        I ^TMP("C0CCCR","LABTBL",0)'="V3" D SETTBL ;NEED NEWEST VERSION
        I '$D(^TMP("HLS",$J,1)) D GHL7 ; GET HL7 MGS IF NOT ALREADY DONE
        S C0CTAB=$NA(^TMP("C0CCCR","LABTBL")) ; BASE OF OBX TABLE
        S C0CHB=$NA(^TMP("HLS",$J))
        S C0CI=""
        S @C0CLB@(0)=0 ; INITALIZE RESULTS VARS COUNT
        F  S C0CI=$O(@C0CHB@(C0CI)) Q:C0CI=""  D  ; FOR ALL RECORDS IN HL7 MSG
        . K C0CVAR,XV ; CLEAR OUT VARIABLE VALUES
        . S C0CTYP=$P(@C0CHB@(C0CI),"|",1)
        . D LTYP(@C0CHB@(C0CI),C0CTYP,.C0CVAR,C0CQT)
        . I $G(C0CVAR("RESULTCODINGSYSTEM"))="LN" D  ; gpl - for certification
        . . S C0CVAR("RESULTCODINGSYSTEM")="LOINC" ; NEED TO SPELL IT OUT
        . . N C0CRDT S C0CRDT=C0CVAR("RESULTDESCRIPTIONTEXT") ; THE DESCRIPTION
        . . N C0CRCD S C0CRCD=C0CVAR("RESULTCODE") ; THE LOINC CODE
        . . S C0CVAR("RESULTDESCRIPTIONTEXT")=C0CRDT_" LOINC: "_C0CRCD
        . M XV=C0CVAR ;
        . I C0CTYP="OBR" D  ; BEGINNING OF NEW SECTION
        . . S @C0CLB@(0)=@C0CLB@(0)+1 ; INCREMENT COUNT
        . . S C0CLI=@C0CLB@(0) ; INDEX FOR THIS RESULT
        . . ;M @C0CLB@(C0CLI)=C0CVAR ; PERSIST THE OBR VARS
        . . S XV("RESULTOBJECTID")="RESULT_"_C0CLI
        . . S C0CX1=XV("RESULTSOURCEACTORID") ; SOURCE FROM OBR
        . . S XV("RESULTSOURCEACTORID")="ACTORPROVIDER_"_$P($P(C0CX1,"^",1),"-",1)
        . . S C0CX1=XV("RESULTASSESSMENTDATETIME") ;DATE TIME IN HL7 FORMAT
        . . S C0CX2=$$HL7TFM^XLFDT(C0CX1,"L") ;FM DT LOCAL
        . . S XV("RESULTASSESSMENTDATETIME")=$$FMDTOUTC^C0CUTIL(C0CX2,"DT") ;UTC TIME
        . . M @C0CLB@(C0CLI)=XV ; PERSIST THE OBR VARS
        . . S C0CLOBX=0 ; MARK THE BEGINNING OF A NEW SECTION
        . I C0CTYP="OBX" D  ; SPECIAL CASE FOR OBX3
        . . ; RESULTTESTCODEVALUE
        . . ; RESULTTESTDESCRIPTIONTEXT
        . . I C0CVAR("C3")="LN" D  ; PRIMARY CODE IS LOINC
        . . . S XV("RESULTTESTCODEVALUE")=C0CVAR("C1") ; THE LOINC CODE VALUE
        . . . S XV("RESULTTESTCODINGSYSTEM")="LOINC" ; DISPLAY NAME FOR LOINC
        . . . ;S XV("RESULTTESTDESCRIPTIONTEXT")=C0CVAR("C2") ; DESC TXT
        . . . S XV("RESULTTESTDESCRIPTIONTEXT")=C0CVAR("C2")_" LOINC: "_C0CVAR("C1")
        . . E  I C0CVAR("C6")="LN" D  ; SECONDARY CODE IS LOINC
        . . . S XV("RESULTTESTCODEVALUE")=C0CVAR("C4") ; THE LOINC CODE VALUE
        . . . S XV("RESULTTESTCODINGSYSTEM")="LOINC" ; DISPLAY NAME FOR LOINC
        . . . S XV("RESULTTESTDESCRIPTIONTEXT")=C0CVAR("C5") ; DESCRIPTION TEXT
        . . E  I C0CVAR("C6")'="" D  ; NO LOINC CODES, USE SECONDARY IF PRESENT
        . . . S XV("RESULTTESTCODEVALUE")=C0CVAR("C4") ; SECONDARY CODE VALUE
        . . . S XV("RESULTTESTCODINGSYSTEM")=C0CVAR("C6") ; SECONDARY CODE NAME
        . . . S XV("RESULTTESTDESCRIPTIONTEXT")=C0CVAR("C5") ; SECONDARY TEXT
        . . E  D  ; NO SECONDARY, USE PRIMARY
        . . . S XV("RESULTTESTCODEVALUE")=C0CVAR("C1") ; PRIMARY CODE VALUE
        . . . S XV("RESULTTESTCODINGSYSTEM")=C0CVAR("C3") ; PRIMARY DISPLAY NAME
        . . . S XV("RESULTTESTDESCRIPTIONTEXT")=C0CVAR("C2") ; USE PRIMARY TEXT
        . . N C0CZG S C0CZG=XV("RESULTTESTNORMALDESCTEXT") ;
        . . ; mod to remove local XML escaping rely upon MAP^C0CXPATH
        . . ;S XV("RESULTTESTNORMALDESCTEXT")=$$SYMENC^MXMLUTL(C0CZG) ;ESCAPE
        . . S XV("RESULTTESTNORMALDESCTEXT")=C0CZG
        . . S C0CZG=XV("RESULTTESTVALUE")
         . . ; mod to remove local XML escaping rely upon MAP^C0CXPATH
        . . ;S XV("RESULTTESTVALUE")=$$SYMENC^MXMLUTL(C0CZG) ;ESCAPE
        . . S XV("RESULTTESTVALUE")=C0CZG
        . I C0CTYP="OBX" D  ; PROCESS TEST RESULTS
        . . I C0CLOBX=0 D  ; FIRST TEST RESULT FOR THIS SECTION
        . . . S C0CLB2=$NA(@C0CLB@(C0CLI,"M","TEST")) ; INDENT FOR TEST RESULTS
        . . S C0CLOBX=C0CLOBX+1 ; INCREMENT TEST COUNT
        . . S @C0CLB2@(0)=C0CLOBX ; STORE THE TEST COUNT
        . . S XV("RESULTTESTOBJECTID")="RESULTTEST_"_C0CLI_"_"_C0CLOBX
        . . S C0CX1=XV("RESULTTESTSOURCEACTORID") ; TEST SOURCE
        . . S C0CX2=$P($P(C0CX1,"^",1),"-",1) ; PULL OUT STATION NUMBER
        . . S XV("RESULTTESTSOURCEACTORID")="ACTORORGANIZATION_"_C0CX2
        . . S XV("RESULTTESTNORMALSOURCEACTORID")=XV("RESULTTESTSOURCEACTORID")
        . . S C0CX1=XV("RESULTTESTDATETIME") ;DATE TIME IN HL7 FORMAT
        . . S C0CX2=$$HL7TFM^XLFDT(C0CX1,"L") ;FM DT LOCAL
        . . S XV("RESULTTESTDATETIME")=$$FMDTOUTC^C0CUTIL(C0CX2,"DT") ;UTC TIME
        . . ; I 'C0CQT ZWR XV
        . . M @C0CLB2@(C0CLOBX)=XV ; PERSIST THE TEST RESULT VARIABLES
        . I 'C0CQT D  ;
        . . W C0CI," ",C0CTYP,!
        . ; S C0CI=$O(@C0CHB@(C0CI))
        ;K ^TMP("C0CRIM","VARS",DFN,"RESULTS")
        ;M ^TMP("C0CRIM","VARS",DFN,"RESULTS")=@C0CLB
        Q
LTYP(OSEG,OTYP,OVARA,OC0CQT)    ;
        S OTAB=$NA(@C0CTAB@(OTYP)) ; TABLE FOR SEGMENT TYPE
        I '$D(OC0CQT) S C0CQT=0 ; NOT C0CQT IS DEFAULT
        E  S C0CQT=OC0CQT ; ACCEPT C0CQT FLAG
        I 1 D  ; FOR HL7 SEGMENT TYPE
        . S OI="" ; INDEX INTO FIELDS IN SEG
        . F  S OI=$O(@OTAB@(OI)) Q:OI=""  D  ; FOR EACH FIELD OF THE SEGMENT
        . . S OTI=$P(@OTAB@(OI),"^",1) ; TABLE INDEX
        . . S OVAR=$P(@OTAB@(OI),"^",4) ; CCR VARIABLE IF DEFINED
        . . S OV=$P(OSEG,"|",OTI+1) ; PULL OUT VALUE
        . . I $P(OI,";",2)'="" D  ; THIS IS DEFINING A SUB-VALUE
        . . . S OI2=$P(OTI,";",2) ; THE SUB-INDEX
        . . . S OV=$P(OV,"^",OI2) ; PULL OUT SUB-VALUE
        . . I OVAR'="" S OVARA(OVAR)=OV ; PASS BACK VARIABLE AND VALUE
        . . I 'C0CQT D  ; PRINT OUTPUT IF C0CQT IS FALSE
        . . . I OV'="" W OI_": "_$P(@OTAB@(OI),"^",3),": ",OVAR,": ",OV,!
        Q
LOBX    ;
        Q
        ;
OUT(DFN)        ; WRITE OUT A CCR THAT HAS JUST BEEN PROCESSED (FOR TESTING)
        N GA,GF,GD
        S GA=$NA(^TMP("C0CCCR",$J,DFN,"CCR",1))
        S GF="RPMS_CCR_"_DFN_"_"_DT_".xml"
        S GD=^TMP("C0CCCR","ODIR")
        W $$OUTPUT^C0CXPATH(GA,GF,GD)
        Q
        ;
SETTBL  ;
        K X ; CLEAR X
        S X("PID","PID1")="1^00104^Set ID - Patient ID"
        S X("PID","PID2")="2^00105^Patient ID (External ID)"
        S X("PID","PID3")="3^00106^Patient ID (Internal ID)"
        S X("PID","PID4")="4^00107^Alternate Patient ID"
        S X("PID","PID5")="5^00108^Patient's Name"
        S X("PID","PID6")="6^00109^Mother's Maiden Name"
        S X("PID","PID7")="7^00110^Date of Birth"
        S X("PID","PID8")="8^00111^Sex"
        S X("PID","PID9")="9^00112^Patient Alias"
        S X("PID","PID10")="10^00113^Race"
        S X("PID","PID11")="11^00114^Patient Address"
        S X("PID","PID12")="12^00115^County Code"
        S X("PID","PID13")="13^00116^Phone Number - Home"
        S X("PID","PID14")="14^00117^Phone Number - Business"
        S X("PID","PID15")="15^00118^Language - Patient"
        S X("PID","PID16")="16^00119^Marital Status"
        S X("PID","PID17")="17^00120^Religion"
        S X("PID","PID18")="18^00121^Patient Account Number"
        S X("PID","PID19")="19^00122^SSN Number - Patient"
        S X("PID","PID20")="20^00123^Drivers License - Patient"
        S X("PID","PID21")="21^00124^Mother's Identifier"
        S X("PID","PID22")="22^00125^Ethnic Group"
        S X("PID","PID23")="23^00126^Birth Place"
        S X("PID","PID24")="24^00127^Multiple Birth Indicator"
        S X("PID","PID25")="25^00128^Birth Order"
        S X("PID","PID26")="26^00129^Citizenship"
        S X("PID","PID27")="27^00130^Veteran.s Military Status"
        S X("PID","PID28")="28^00739^Nationality"
        S X("PID","PID29")="29^00740^Patient Death Date/Time"
        S X("PID","PID30")="30^00741^Patient Death Indicator"
        S X("NTE","NTE1")="1^00573^Set ID - NTE"
        S X("NTE","NTE2")="2^00574^Source of Comment"
        S X("NTE","NTE3")="3^00575^Comment"
        S X("ORC","ORC1")="1^00215^Order Control"
        S X("ORC","ORC2")="2^00216^Placer Order Number"
        S X("ORC","ORC3")="3^00217^Filler Order Number"
        S X("ORC","ORC4")="4^00218^Placer Order Number"
        S X("ORC","ORC5")="5^00219^Order Status"
        S X("ORC","ORC6")="6^00220^Response Flag"
        S X("ORC","ORC7")="7^00221^Quantity/Timing"
        S X("ORC","ORC8")="8^00222^Parent"
        S X("ORC","ORC9")="9^00223^Date/Time of Transaction"
        S X("ORC","ORC10")="10^00224^Entered By"
        S X("ORC","ORC11")="11^00225^Verified By"
        S X("ORC","ORC12")="12^00226^Ordering Provider"
        S X("ORC","ORC13")="13^00227^Enterer's Location"
        S X("ORC","ORC14")="14^00228^Call Back Phone Number"
        S X("ORC","ORC15")="15^00229^Order Effective Date/Time"
        S X("ORC","ORC16")="16^00230^Order Control Code Reason"
        S X("ORC","ORC17")="17^00231^Entering Organization"
        S X("ORC","ORC18")="18^00232^Entering Device"
        S X("ORC","ORC19")="19^00233^Action By"
        S X("OBR","OBR1")="1^00237^Set ID - Observation Request"
        S X("OBR","OBR2")="2^00216^Placer Order Number"
        S X("OBR","OBR3")="3^00217^Filler Order Number"
        S X("OBR","OBR4")="4^00238^Universal Service ID"
        S X("OBR","OBR4;LOINC")="4;1^00238^Universal Service ID - LOINC^RESULTCODE"
        S X("OBR","OBR4;DESC")="4;2^00238^Universal Service ID - DESC^RESULTDESCRIPTIONTEXT"
        S X("OBR","OBR4;VACODE")="4;3^00238^Universal Service ID - VACODE^RESULTCODINGSYSTEM"
        S X("OBR","OBR5")="5^00239^Priority"
        S X("OBR","OBR6")="6^00240^Requested Date/Time"
        S X("OBR","OBR7")="7^00241^Observation Date/Time^RESULTASSESSMENTDATETIME"
        S X("OBR","OBR8")="8^00242^Observation End Date/Time"
        S X("OBR","OBR9")="9^00243^Collection Volume"
        S X("OBR","OBR10")="10^00244^Collector Identifier"
        S X("OBR","OBR11")="11^00245^Specimen Action Code"
        S X("OBR","OBR12")="12^00246^Danger Code"
        S X("OBR","OBR13")="13^00247^Relevant Clinical Info."
        S X("OBR","OBR14")="14^00248^Specimen Rcv'd. Date/Time"
        S X("OBR","OBR15")="15^00249^Specimen Source"
        S X("OBR","OBR16")="16^00226^Ordering Provider XCN^RESULTSOURCEACTORID"
        S X("OBR","OBR17")="17^00250^Order Callback Phone Number"
        S X("OBR","OBR18")="18^00251^Placers Field 1"
        S X("OBR","OBR19")="19^00252^Placers Field 2"
        S X("OBR","OBR20")="20^00253^Filler Field 1"
        S X("OBR","OBR21")="21^00254^Filler Field 2"
        S X("OBR","OBR22")="22^00255^Results Rpt./Status Change"
        S X("OBR","OBR23")="23^00256^Charge to Practice"
        S X("OBR","OBR24")="24^00257^Diagnostic Service Sect"
        S X("OBR","OBR25")="25^00258^Result Status^RESULTSTATUS"
        S X("OBR","OBR26")="26^00259^Parent Result"
        S X("OBR","OBR27")="27^00221^Quantity/Timing"
        S X("OBR","OBR28")="28^00260^Result Copies to"
        S X("OBR","OBR29")="29^00261^Parent Number"
        S X("OBR","OBR30")="30^00262^Transportation Mode"
        S X("OBR","OBR31")="31^00263^Reason for Study"
        S X("OBR","OBR32")="32^00264^Principal Result Interpreter"
        S X("OBR","OBR33")="33^00265^Assistant Result Interpreter"
        S X("OBR","OBR34")="34^00266^Technician"
        S X("OBR","OBR35")="35^00267^Transcriptionist"
        S X("OBR","OBR36")="36^00268^Scheduled Date/Time"
        S X("OBR","OBR37")="37^01028^Number of Sample Containers"
        S X("OBR","OBR38")="38^38^01029 Transport Logistics of Collected Sample"
        S X("OBR","OBR39")="39^01030^Collector.s Comment"
        S X("OBR","OBR40")="40^01031^Transport Arrangement Responsibility"
        S X("OBR","OBR41")="41^01032^Transport Arranged"
        S X("OBR","OBR42")="42^01033^Escort Required"
        S X("OBR","OBR43")="43^01034^Planned Patient Transport Comment"
        S X("OBX","OBX1")="1^00559^Set ID - OBX"
        S X("OBX","OBX2")="2^00676^Value Type"
        S X("OBX","OBX3")="3^00560^Observation Identifier"
        S X("OBX","OBX3;C1")="3;1^00560^Observation Identifier^C1"
        S X("OBX","OBX3;C2")="3;2^00560^Observation Identifier^C2"
        S X("OBX","OBX3;C3")="3;3^00560^Observation Identifier^C3"
        S X("OBX","OBX3;C4")="3;4^00560^Observation Identifier^C4"
        S X("OBX","OBX3;C5")="3;5^00560^Observation Identifier^C5"
        S X("OBX","OBX3;C6")="3;6^00560^Observation Identifier^C6"
        S X("OBX","OBX4")="4^00769^Observation Sub-Id"
        S X("OBX","OBX5")="5^00561^Observation Results^RESULTTESTVALUE"
        S X("OBX","OBX6")="6^00562^Units^RESULTTESTUNITS"
        S X("OBX","OBX7")="7^00563^Reference Range^RESULTTESTNORMALDESCTEXT"
        S X("OBX","OBX8")="8^00564^Abnormal Flags^RESULTTESTFLAG"
        S X("OBX","OBX9")="9^00639^Probability"
        S X("OBX","OBX10")="10^00565^Nature of Abnormal Test"
        S X("OBX","OBX11")="11^00566^Observ. Result Status^RESULTTESTSTATUSTEXT"
        S X("OBX","OBX12")="12^00567^Date Last Normal Value"
        S X("OBX","OBX13")="13^00581^User Defined Access Checks"
        S X("OBX","OBX14")="14^00582^Date/Time of Observation^RESULTTESTDATETIME"
        S X("OBX","OBX15")="15^00583^Producer.s ID^RESULTTESTSOURCEACTORID"
        S X("OBX","OBX16")="16^00584^Responsible Observer"
        S X("OBX","OBX17")="17^00936^Observation Method"
        K ^TMP("C0CCCR","LABTBL")
        M ^TMP("C0CCCR","LABTBL")=X ; SET VALUES IN LAB TBL
        S ^TMP("C0CCCR","LABTBL",0)="V3"
        Q
        ;
