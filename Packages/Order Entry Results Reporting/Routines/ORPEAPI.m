ORPEAPI ;SLC/JMH - WRAPPERS FOR PHARMACY ENCAPSULATION;  ; Compiled April 17, 2006 09:44:11
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
NAME50(ORDRGIEN)        ;
        N NAME
        D DATA^PSS50(ORDRGIEN,,,,,"ORLST")
        S NAME=$G(^TMP($J,"ORLST",ORDRGIEN,.01))
        K ^TMP($J,"ORLST")
        Q NAME
        ;
CLASS50(ORDRGIEN)       ;
        N CLASS
        D DATA^PSS50(ORDRGIEN,,,,,"ORLST")
        S CLASS=$G(^TMP($J,"ORLST",ORDRGIEN,2))
        K ^TMP($J,"ORLST")
        Q CLASS
        Q
        ;
