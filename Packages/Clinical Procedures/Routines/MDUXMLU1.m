MDUXMLU1        ; HOIFO/WAA -Utilities for XML text  ; 7/26/00
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ; Utilities for the XML Parser
        ;
FILTER(DATA)    ;Filter out the bad chars.
        Q:$G(DATA)'?.E1C.E DATA
        N RESULTS
        S RESULTS=""
        F  Q:'$L(DATA)  S:$E(DATA)'?1C RESULTS=RESULTS_$E(DATA) S DATA=$E(DATA,2,$L(DATA))
        Q RESULTS
VAL(DATA)       ;Convert any special charcters to standard XML format
        N DATA2,RESULT,CHAR,CHAR1,CHAR2,CNT,I
        S RESULT="",CNT=0,I=0,DATA2=""
        S DATA=$$FILTER(DATA)
        F CHAR="&,amp","<,lt",">,gt","',apos",""",quot" D
        . S CNT=$L(DATA,$P(CHAR,","))
        . S CHAR1=$P(CHAR,","),CHAR2=$P(CHAR,",",2)
        . S RESULT=""
        . I CNT>1 F I=1:1:CNT D
        . . S RESULT=RESULT_$P(DATA,CHAR1,I)
        . . I CNT'=I S RESULT=RESULT_"&"_CHAR2_";"
        . . Q
        . I RESULT'="" S DATA=RESULT
        . Q
        I RESULT="" S RESULT=DATA
        Q RESULT
        ;
CODING(TYPE,DATA)       ; Coding of both CPT and ICD9
        Q:TYPE=""
        Q:DATA=""
        N DATAC,I,DEFF
        S DATAC=$L(DATA,"~")
        S DEFF=$S(TYPE="CPT":"PROCEDURE",TYPE="ICD":"DIAGNOSIS",1:0)
        Q:'DEFF
        F I=1:1:DATAC D
        . D BLDXML^MDUXMLU1(TYPE_"_CODE",$P($P(DATA,"~",I),"^",1))
        . D BLDXML^MDUXMLU1(TYPE_"_"_DEFF,$P($P(DATA,"~",I),"^",2))
        . D BLDXML^MDUXMLU1(TYPE_"_CODE_TYPE",$P($P(DATA,"~",I),"^",3))
        . Q
        Q
HEAD    ;Creat the header of the XML message
        D XML^MDUXMLU1("<?xml version="_QUOT_"1.0"_QUOT_" encoding="_QUOT_"UTF-8"_QUOT_" ?>")
        D XML^MDUXMLU1("<HL7_MESSAGE xmlns:xsi="_QUOT_"http://www.w3.org/2001/XMLSchema-instance"_QUOT_" xsi:noNamespaceSchemaLocation="_QUOT_"CLOB.xsd"_QUOT_">")
        Q
TAIL    ; Complete the message
        D XML^MDUXMLU1("</RESULTS>")
        I ORDER=1 D XML^MDUXMLU1("</ORDER_INFORMATION>")
        D XML^MDUXMLU1("</HL7_MESSAGE>")
        Q
NAME(NAME)      ; Convert name
        I NAME="" Q
        D BLDXML^MDUXMLU1("LAST_NAME",$P(NAME,"^",1))
        D BLDXML^MDUXMLU1("FIRST_NAME",$P(NAME,"^",2))
        D BLDXML^MDUXMLU1("MIDDLE_NAME",$P(NAME,"^",3))
        Q
DATE(FIELD,DATE)        ; Convert date and post as xml
        I FIELD="" Q
        I DATE="" Q
        D XML^MDUXMLU1("<"_FIELD_">")
        D BLDXML^MDUXMLU1("YEAR",$E(DATE,1,4))
        D BLDXML^MDUXMLU1("MONTH",$E(DATE,5,6))
        D BLDXML^MDUXMLU1("DAY",$E(DATE,7,8))
        I $E(DATE,9,10)?2N D BLDXML^MDUXMLU1("HOUR",$E(DATE,9,10))
        I $E(DATE,11,12)?2N D BLDXML^MDUXMLU1("MINUTE",$E(DATE,11,12))
        I $E(DATE,13,14)?2N D BLDXML^MDUXMLU1("SECOND",$E(DATE,13,14))
        D XML^MDUXMLU1("</"_FIELD_">")
        Q
BLDXML(HEAD,DATA)       ;
        Q:HEAD=""
        Q:DATA=""
        D XML^MDUXMLU1("<"_HEAD_">"_DATA_"</"_HEAD_">")
        Q
XML(XMLLINE)    ; create the XML Line in the temp file to be passed
        Q:XMLLINE=""
        S XMLCNT=XMLCNT+1
        S ^TMP($J,"MDHL7XML",XMLCNT)=XMLLINE
        Q
FILE(MDIEN)     ; File off the XML data into 703.1
        N CNT,MDDZ,LINE,LN
        S CNT=0,CCNT=0
        S MDDZ=$$UPDATE^MDHL7U(MDIEN)
        Q:'MDDZ
        F  S CNT=$O(^TMP($J,"MDHL7XML",CNT)) Q:CNT<1  D
        . S LINE=$G(^TMP($J,"MDHL7XML",CNT)) Q:LINE=""
        . S ^MDD(703.1,MDIEN,.4,CNT,0)=LINE,CCNT=CCNT+1
        . Q
        S ^MDD(703.1,MDIEN,.4,0)="^^"_CCNT_"^"_CCNT_"^"_DT_"^"
        K ^TMP($J,"MDHL7XML")
        Q
