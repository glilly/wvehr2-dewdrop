RORP005 ;BP/KM - PATCH ROR*1.5*5 PRE-TRANS/POST-INSTALL ROUTINE ;11/26/07 1:43pm
        ;;1.5;CLINICAL CASE REGISTRIES;**5**;Feb 17, 2006;Build 10
        ;
        Q
PRET    ;Pre-Transportation tag for patch ROR*1.5*5
        D LD79951^RORPUT02()
        Q
POST    ;Post-install tag for patch ROR*1.5*5
        S RC=$$RS79951^RORPUT02()
        Q
