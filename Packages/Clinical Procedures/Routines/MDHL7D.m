MDHL7D  ; HOIFO/WAA -B-Braun, Fresenius Dialysis ; 06/08/00
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ;S (TCNT,ICNT,LN)=0
OBX     ; Process OBX
        ; M ^ZZBILL("MDHL7",$J,"POST-HL7")=^TMP($J,"MDHL7A")  ; POST PROCESSING
        N MDATT,PROC
        D ATT^MDHL7U(DEVIEN,.MDATT) Q:MDATT<1
        S PROC=0
        F  S PROC=$O(MDATT(PROC)) Q:PROC<1  D
        . N PROCESS
        . S PROCESS=$P(MDATT(PROC),";",5)
        . D @PROCESS
        . Q
        Q:'MDIEN
        D EN1^MDUXML  ; XML conversion utility
        ; M ^ZZBILL("MSHL7",$J,"XML")=^TMP($J,"MDHL7XML")  ; "XML RESULTS"
        D FILE^MDUXMLU1(MDIEN)  ;  File the results
        D REX^MDHL7U1(MDIEN)
        D GENACK^MDHL7X
        Q
