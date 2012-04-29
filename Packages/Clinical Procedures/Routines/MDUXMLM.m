MDUXMLM ; HOIFO/WAA -Utilities for XML text  ; 7/26/00
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ; This routine will loop throught the HL7 Message as sent
        ; by the vendor and convert that message into XML for
        ; Processing by the gateway.
        ;
MSH     ; Parse the MSH
        N MSGDATE
        D XML^MDUXMLU1("<MESSAGE_HEADER>")
        D BLDXML^MDUXMLU1("INTERNAL_APPLICATION","CLOB")
        S DEVICE=$P(LINE,DL,4)
        D BLDXML^MDUXMLU1("INSTRUMENT_INSTANCE_ID",DEVICE)
        S MSGDATE=$P(LINE,DL,7) I MSGDATE="" D
        . D NOW^%DTC
        . S MSGDATE=%
        . S MSGDATE=$$FTOHL7^MDHL7U2(MSGDATE)
        . Q
        D DATE^MDUXMLU1("TRANSMISSION_DATE_TIME",MSGDATE)
        D BLDXML^MDUXMLU1("MESSAGE_CONTROL_ID",$P(LINE,DL,10))
        D BLDXML^MDUXMLU1("MESSAGE_TYPE",$P(LINE,DL,9))
        D BLDXML^MDUXMLU1("PRODUCTION_MODE",$S($P(LINE,DL,11)="P":"Y",1:"N"))
        D BLDXML^MDUXMLU1("HL7_VERSION",$P(LINE,DL,12))
        D XML^MDUXMLU1("</MESSAGE_HEADER>")
        Q
PID     ; Parse the PID
        N SSN
        D XML^MDUXMLU1("<PATIENT_INFORMATION>")
        D BLDXML^MDUXMLU1("PATIENT_ID",$P(LINE,DL,4))
        D XML^MDUXMLU1("<PATIENT_NAME>")
        D NAME^MDUXMLU1($P(LINE,DL,6))
        D XML^MDUXMLU1("</PATIENT_NAME>")
        D DATE^MDUXMLU1("DATE_OF_BIRTH",$P(LINE,DL,8))
        D BLDXML^MDUXMLU1("SEX",$P(LINE,DL,9))
        S SSN=$P(LINE,DL,20) I SSN="" S SSN=$P(LINE,DL,4)
        D BLDXML^MDUXMLU1("SSN",$P(LINE,DL,20))
        D XML^MDUXMLU1("</PATIENT_INFORMATION>")
        Q
PV1     ; Parse the PV1
        D BLDXML^MDUXMLU1("PATIENT_CLASS",$P(LINE,DL,3))
        D BLDXML^MDUXMLU1("PATIENT_LOCATION",$P(LINE,DL,4))
        Q
ORC     ; Parse the ORC
        S ORDER=1
        D XML^MDUXMLU1("<ORDER_INFORMATION>")
        D BLDXML^MDUXMLU1("ORDER_CONTROL",$P(LINE,DL,2))
        D BLDXML^MDUXMLU1("PLACER_ORDER_NUMBER",$P(LINE,DL,3))
        D DATE^MDUXMLU1("TRANSACTION_DATE_TIME",$P(LINE,DL,10))
        Q
OBR     ; Parse the OBR
        D XML^MDUXMLU1("<RESULTS>")
        D BLDXML^MDUXMLU1("FILLER_ORDER_NUMBER",$P(LINE,DL,4))
        D BLDXML^MDUXMLU1("PROCEDURE_INSTANCE_ID",$P(LINE,DL,4))
        I $P(LINE,DL,5)'="" D  ; Get the procedure type if there is one.
        . N LINX
        . S LINX=$P($P(LINE,DL,5),"^")
        . I LINX="" S LINX=$P($P(LINE,DL,5),"^",2)
        . D BLDXML^MDUXMLU1("PROCEDURE_TYPE",LINX)
        . Q
        D DATE^MDUXMLU1("DATE_OBSERVED",$P(LINE,DL,8))
        I $P(LINE,DL,14)'="" D  ; Pick up ICD9 code
        . D XML^MDUXMLU1("<RELEVENT_CLINICAL>")
        . D CODING^MDUXMLU1("ICD",$P(LINE,DL,14))
        . D XML^MDUXMLU1("</RELEVENT_CLINICAL>")
        . Q
        I $P(LINE,DL,17)'="" D
        . D XML^MDUXMLU1("<ORDERING_PROVIDER>")
        . D NAME^MDUXMLU1($P(LINE,DL,17))
        . D XML^MDUXMLU1("</ORDERING_PROVIDER>")
        . Q
        D BLDXML^MDUXMLU1("STATUS",$P(LINE,DL,26))
        D BLDXML^MDUXMLU1("QUALITY_TIMING",$P(LINE,DL,28))
        I $P(LINE,DL,37)'="" D DATE^MDUXMLU1("DATE_SCHEDULED",$P(LINE,DL,37))
        I $P(LINE,DL,45)'="" D  ; Pick up CPT code
        . D XML^MDUXMLU1("<PROCEDURE_CODE>")
        . D CODING^MDUXMLU1("CPT",$P(LINE,DL,45))
        . D XML^MDUXMLU1("</PROCEDURE_CODE>")
        . Q
        Q
OBX     ; Parse the OBX
        D OBX^MDUXMLOX
        Q
