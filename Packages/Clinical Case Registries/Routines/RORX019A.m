RORX019A        ;BPOIFO/ACS - MELD SCORE BY RANGE (CONT.) ;11/1/09
        ;;1.5;CLINICAL CASE REGISTRIES;**10**;Feb 17, 2006;Build 32
        ;
        ;
        Q
        ;
        ;*****************************************************************************
        ;OUTPUT REPORT 'RANGE' PARAMETERS, SET UP REPORT ID LIST (EXTRINISIC FUNCTION)
        ;
        ; PARTAG        Reference (IEN) to the parent tag
        ;
        ; Return Values:
        ;        RORDATA("IDLST") - list of IDs for tests requested
        ;       <0  Error code
        ;        0  Ok
        ;*****************************************************************************
PARAMS(PARTAG,RORDATA,RORTSK)   ;
        N PARAMS,DESC,TMP,RC S RC=0
        ;--- Lab test ranges
        S RORDATA("RANGE",1)=0 ;initialize MELD to 'no range passed in'
        S RORDATA("RANGE",2)=0 ;initialize MELD Na to 'no range passed in'
        I $D(RORTSK("PARAMS","LRGRANGES","C"))>1  D  Q:RC<0 RC
        . N GRC,ELEMENT,NODE,RTAG,RANGE
        . S NODE=$NA(RORTSK("PARAMS","LRGRANGES","C"))
        . S RTAG=$$ADDVAL^RORTSK11(RORTSK,"LRGRANGES",,PARTAG)
        . S (GRC,RC)=0
        . F  S GRC=$O(@NODE@(GRC))  Q:GRC'>0  D  Q:RC<0
        .. S RANGE=0,DESC=$$RTEXT(GRC,.RORDATA,.RORTSK) ;get range description
        .. S ELEMENT=$$ADDVAL^RORTSK11(RORTSK,"LRGRANGE",DESC,RTAG) ;add desc to output
        .. I ELEMENT<0 S RC=ELEMENT Q
        .. D ADDATTR^RORTSK11(RORTSK,ELEMENT,"ID",GRC)
        .. ;add test ID to the test ID 'list'
        .. S RORDATA("IDLST")=$G(RORDATA("IDLST"))_$S($G(RORDATA("IDLST"))'="":","_GRC,1:GRC)
        .. ;--- Process the range values
        .. S TMP=$G(@NODE@(GRC,"L"))
        .. I TMP'="" D  S RANGE=1
        ... D ADDATTR^RORTSK11(RORTSK,ELEMENT,"LOW",TMP) S RORDATA("RANGE",GRC)=1
        .. S TMP=$G(@NODE@(GRC,"H"))
        .. I TMP'="" D  S RANGE=1
        ... D ADDATTR^RORTSK11(RORTSK,ELEMENT,"HIGH",TMP) S RORDATA("RANGE",GRC)=1
        .. I RANGE D ADDATTR^RORTSK11(RORTSK,ELEMENT,"RANGE",1)
        ;if user didn't select any tests, default to both tests
        I $G(RORDATA("IDLST"))="" S RORDATA("IDLST")="1,2"
        ;--- Success
        Q RC
        ;
        ;*****************************************************************************
        ;RETURN RANGE TEXT, ADD RANGE VALUES TO RORDATA (EXTRINISIC FUNCTION)
        ;ID=1: MELD
        ;ID=2: MELD-Na
        ;
        ;INPUT:
        ;  GRC   Test ID number
        ;  RORDATA - Array with ROR data
        ;
        ;OUTPUT:
        ;  RORDATA(ID,"L") - test ID low range
        ;  RORDATA(ID,"H") - test ID high range
        ;  Description - <range>
        ;*****************************************************************************
RTEXT(GRC,RORDATA,RORTSK)       ;
        N RANGE,TMP
        S RANGE=""
        ;--- Range
        I $D(RORTSK("PARAMS","LRGRANGES","C",GRC))>1 D
        . ;--- Low
        . S TMP=$G(RORTSK("PARAMS","LRGRANGES","C",GRC,"L"))
        . S RORDATA(GRC,"L")=$G(TMP)
        . S:TMP'="" RANGE=RANGE_" not less than "_TMP
        . ;--- High
        . S TMP=$G(RORTSK("PARAMS","LRGRANGES","C",GRC,"H"))
        . S RORDATA(GRC,"H")=$G(TMP)
        . I TMP'=""  D:RANGE'=""  S RANGE=RANGE_" not greater than "_TMP
        . . S RANGE=RANGE_" and"
        ;--- Description
        S TMP=$G(RORTSK("PARAMS","LRGRANGES","C",GRC))
        S:TMP="" TMP="Unknown ("_GRC_")"
        Q TMP_" - "_$S(RANGE'="":"numeric results"_RANGE,1:"all results")
        ;
