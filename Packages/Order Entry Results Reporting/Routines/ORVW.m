ORVW    ;FO-SLC/SRM-VISTAWEB GENERAL UTILITES; ; 9/14/09 3:17pm
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**319**;DEC 17, 1997;Build 13
        Q
        ;
FACLIST(ORY,ORDFN)      ; Return a list from the TFL^VAFCTFU1 call
        D TFL^VAFCTFU1(.ORY,ORDFN)
        Q
        ;
