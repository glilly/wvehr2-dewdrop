RORP006 ;BP/KM - PATCH ROR*1.5*6 PRE-TRANS/POST-INSTALL ROUTINE ; 1/28/08 7:47am
        ;;1.5;CLINICAL CASE REGISTRIES;**6**;Feb 17, 2006;Build 4
        ;
        Q
PRET    ;Pre-Transportation tag for patch ROR*1.5*6
        D LD79951^RORPUT02()
        Q
POST    ;Post-install tag for patch ROR*1.5*6
        S RC=$$RS79951^RORPUT02()
        Q
