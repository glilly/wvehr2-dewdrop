RORP007 ;BP/KM - PATCH ROR*1.5*7 PRE-TRANS/POST-INSTALL ROUTINE ; 4/17/08 9:42am
        ;;1.5;CLINICAL CASE REGISTRIES;**7**;Feb 17, 2006;Build 5
        ;
        Q
PRET    ;Pre-Transportation tag for patch ROR*1.5*7
        D LD79951^RORPUT02()
        Q
POST    ;Post-install tag for patch ROR*1.5*7
        S RC=$$RS79951^RORPUT02()
        Q
