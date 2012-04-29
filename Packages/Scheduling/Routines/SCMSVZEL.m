SCMSVZEL          ;ALB/ESD HL7 ZEL Segment Validation ; 6/20/05 9:24am
        ;;5.3;Scheduling;**44,66,142,184,180,222,239,325,441**;Aug 13, 1993;Build 14
        ;
        ;
EN(ZELSEG,HLQ,HLFS,VALERR,DFN)  ;
        ; Entry point to return the HL7 ZEL (Patient Eligibility) validation segment
        ;
        ;  Input: .ZELSEG - ZEL Segment Array
        ;             HLQ - HL7 null variable
        ;            HLFS - HL7 field separator
        ;          VALERR - The array name to put the errors in
        ;             DFN - The DFN of the patient
        ;
        ; Output:  1 if ZEL passed validity check
        ;          Error message if ZEL failed validity check in form of:
        ;          -1^"xxx failed validity check" (xxx=element in ZEL segment)
        ;
        ;
        N I,MSG,X,CNT,DATA,SEG,ELIG,VET,LP,MSTSTAT,MSTDATE,SEGLINE,NODE,OFFSET
        N CVET
        S SEG="ZEL",CNT=1
        S MSG="-1^Element in ZEL segment failed validity check"
        S ZELSEG(1)=$G(ZELSEG(1))
        D VALIDATE^SCMSVUT0(SEG,ZELSEG(1),"0010",VALERR,.CNT)
        I $D(@VALERR@(SEG)) G ENQ
        ;
        ;- Convert HLQ to null
        S ZELSEG(1)=$$CONVERT^SCMSVUT0(ZELSEG(1),HLFS,HLQ)
        S I=0
        F  S I=+$O(ZELSEG(1,I)) Q:'I  S ZELSEG(1,I)=$$CONVERT^SCMSVUT0(ZELSEG(1,I),HLFS,HLQ)
        ;
        S OFFSET=0,NODE=0,SEGLINE=ZELSEG(1)
        F I=1,3,9,19,20,23,24,25,30,38,39,41 DO
        . I $L(SEGLINE,HLFS)<(I-OFFSET) D
        . . ;Segment wrapped
        . . S OFFSET=OFFSET+$L(SEGLINE,HLFS)-1
        . . S NODE=+$O(ZELSEG(1,NODE))
        . . I NODE=0 S SEGLINE="",NODE=+$O(ZELSEG(1,NODE),-1) Q
        . . S SEGLINE=$G(ZELSEG(1,NODE))
        . S DATA=$P(SEGLINE,HLFS,I-OFFSET)
        . I I=3 S ELIG=DATA
        . I I=9 S VET=DATA
        . I I=24 S MSTSTAT=DATA
        . I I=25 S MSTDATE=DATA,DATA=MSTSTAT_"^"_MSTDATE
        . I I=38 S CVET=DATA
        . I I=39 S DATA=CVET_"^"_DATA
        . D VALIDATE^SCMSVUT0(SEG,DATA,$P($T(@(I)),";",3),VALERR,.CNT)
        . Q
        ;
        S DATA=ELIG_"^"_VET
        F LP=32,91 D VALIDATE^SCMSVUT0(SEG,$S(LP=32:ELIG,LP=91:VET,1:DATA),$P($T(@(LP)),";",3),VALERR,.CNT)
        ;
ENQ     Q $S($D(@VALERR@(SEG)):MSG,1:1)
        ;
        ;
        ;
ERR     ;;Invalid or missing patient eligibility data for encounter (HL7 ZEL segment)
        ;
        ;
        ;- ZEL data elements validated
        ;
1       ;;0035;HL7 SEGMENT NAME
3       ;;7000;ELIGIBILITY CODE MISSING
31      ;;7020;ELIGIBILITY CODE INCONSISTENT WITH VET STATUS
32      ;;7030;ELIGIBILITY CODE INACTIVE
9       ;;7050;VETERAN?
91      ;;7100;VET STATUS INCONSISTENT WITH POW
19      ;;7120;AGENT ORANGE EXPOSURE
23      ;;7150;INVALID/INCONSISTENT RADIATION EXPOSURE METHOD
20      ;;7210;RADIATION EXPOSURE INDICATED
24      ;;7040;INVALID MST CLASSIFICATION
25      ;;7060;MST STATUS DATE INVALID OR INCONSISTENT WITH MST STATUS
30      ;;7130;AGENT ORANGE EXPOSURE LOCATION
38      ;;7330;COMBAT VET INDICATOR
39      ;;7340;COMBAT VET END DATE
41      ;;7370;PROJ 112/SHAD INDICATOR
