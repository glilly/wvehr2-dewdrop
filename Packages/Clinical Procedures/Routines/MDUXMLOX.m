MDUXMLOX        ; HOIFO/WAA -OBX converter XML text  ; 7/26/00
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ; OBX for the XML Parser
        ;
OBX     D XML^MDUXMLU1("<OBSERVATION>")
        D BLDXML^MDUXMLU1("SEQUENCE",$P(LINE,DL,2))
        D XML^MDUXMLU1("<CODE>")
        D BLDXML^MDUXMLU1("SCHEME",DEVICE)
        I $P($P(LINE,DL,4),"^")="",$P($P(LINE,DL,4),"^",2)'="" S $P(LINE,DL,4)=$P($P(LINE,DL,4),"^",2)
        D BLDXML^MDUXMLU1("VALUE",$P(LINE,DL,4))
        D BLDXML^MDUXMLU1("ORIGINAL","Y")
        D XML^MDUXMLU1("</CODE>")
        D BLDXML^MDUXMLU1("DATATYPE",$P(LINE,DL,3))
        I $P(LINE,DL,3)="FT" D FREE
        E  D BLDXML^MDUXMLU1("VALUE",$P(LINE,DL,6))
        D BLDXML^MDUXMLU1("UNITS",$P(LINE,DL,7))
        I $P(LINE,DL,8)'="" D
        . N RANGE
        . S RANGE=$P(LINE,DL,8)
        . D XML^MDUXMLU1("<REFERENCE_RANGE>")
        . D BLDXML^MDUXMLU1("LOW",$P(RANGE,"-",1))
        . D BLDXML^MDUXMLU1("HIGH",$P(RANGE,"-",2))
        . D XML^MDUXMLU1("</REFERENCE_RANGE>")
        D XML^MDUXMLU1("</OBSERVATION>")
        Q
FREE    ; This will process free test
        D XML^MDUXMLU1("<VALUE>")
        N I,X,FREE,DATA
        S I=1
        D XML^MDUXMLU1($P(LINE,DL,6)) ; First line
        S X=0
        F  S X=$O(^TMP($J,"MDHL7A",NUM,X)) Q:X<1  D
        . S DATA=$G(^TMP($J,"MDHL7A",NUM,X)) Q:DATA=""
        . S DATA=$$VAL^MDUXMLU1($P(DATA,DL))
        . D XML^MDUXMLU1(DATA)
        . Q
        ; ^---  THIS STUFF THE DATA INTO THE DATA ARRAY
        D XML^MDUXMLU1("</VALUE>")
        Q
