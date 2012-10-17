SPNJRPRC        ;BP/JAS - Returns VA Race info ;Dec 15, 2006
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ; Reference to API DEM^VADPT & KVAR^VADPT supported by IA #10061
        ; API $$FLIP^SPNRPCIC is part of Spinal Cord Version 3.0
        ;
        ; Parm values:
        ;     RETURN is the race type for a given ICN
        ;
        ; Returns: RETURN($J)
        ;
COL(RETURN,ICN) ;
        ;***************************
        K ^TMP($J)
        S RETURN=$NA(^TMP($J)),RETCNT=1
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:$G(DFN)=""
        ;***************************
        D DEM^VADPT
        S RCNT=VADM(12) Q:RCNT=0
        F I=1:1:RCNT D
        . S RACE=$P(VADM(12,I),"^",2)
        . D RACE
        . S ^TMP($J,RETCNT)=RACE_"^EOL999"
        . S RETCNT=RETCNT+1
        D KVAR^VADPT
        K DFN,RACE,RCNT,RDA,RETCNT
        K I,VADM  ;WDE
        Q
RACE    ;
        I RACE["BLACK" S RACE="BLACK OR AFRICAN AMERICAN" Q
        I RACE["AFRICAN" S RACE="BLACK OR AFRICAN AMERICAN" Q
        I RACE["AFROAMERICAN" S RACE="BLACK OR AFRICAN AMERICAN" Q
        I RACE["NEGRO" S RACE="BLACK OR AFRICAN AMERICAN" Q
        I RACE["ALASKA" S RACE="AMERICAN INDIAN OR ALASKA NATIVE" Q
        I RACE["INDIAN" S RACE="AMERICAN INDIAN OR ALASKA NATIVE" Q
        I RACE["HISPANIC" S RACE="WHITE" Q
        I RACE["MEXICAN" S RACE="WHITE" Q
        I RACE["CAUCASIAN" S RACE="WHITE" Q
        I RACE["WHITE" S RACE="WHITE" Q
        I RACE["ASIAN" S RACE="ASIAN" Q
        I RACE["HAWAIIAN" S RACE="NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER" Q
        I RACE["PACIFIC" S RACE="NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER" Q
        S RACE="UNKNOWN"
        Q
