PSOORFL ;BIR/SJA - Flag order through CPRS entry point ;10/24/06 2:27pm
        ;;7.0;OUTPATIENT PHARMACY;**225,345**;DEC 1997;Build 5
        ;
        ; Reference to EN1^ORCFLAG is supported by DBIA #3620
        ;
FLAG    ;Flag order through CPRS entry point.
        N ORIFN
        S ORIFN=+$P($G(^PS(52.41,ORD,0)),"^")
        ;D FULL^VALM1 W ! D EN1^ORCFLAG(ORIFN),BLD^PSOORUT1 ;*345 
        D FULL^VALM1 W ! D EN1^ORCFLAG(ORIFN) ; *345 REMOVE CALL TO BLD^PSOORUT1
        Q
RV      ;reverse video
        Q:'$G(VALMCNT)
        N PSLIST S PSLIST=0 F PSLIST=1:1:VALMCNT D
        .I $D(^TMP("PSOPF",$J,PSLIST,"RV")) D CNTRL^VALM10(PSLIST,1,3,IORVON,IORVOFF,0) Q
        .I '$D(^TMP("PSOPF",$J,PSLIST,"RV")) D CNTRL^VALM10(PSLIST,1,3,IOINORM,IOINORM,0)
        ;S VALMBCK="R" Q
