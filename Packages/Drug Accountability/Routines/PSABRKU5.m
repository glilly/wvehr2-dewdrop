PSABRKU5        ;BIR/DB-Upload and Process Prime Vendor Invoice Data - CONT'D ;7/23/97
        ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**26,67**; 10/24/97;Build 15
        ;This routine checks for correct X12 formating.
        ;
ORDER   ;  check order of code sheets
        S PSANEXT=$P(PSADATA,"^")
        ;
        I PSALAST="GE",PSANEXT="GS" Q
        I PSALAST="GE",PSANEXT'="IEA" D ORDERROR("GE",PSANEXT,"IEA") Q
        ;
        I PSALAST="ISA",PSANEXT'="GS" D ORDERROR("ISA",PSANEXT,"GS") Q
        ;
        I PSALAST="SE",PSANEXT="ST" Q
        I PSALAST="SE",PSANEXT'="GE" D ORDERROR("SE",PSANEXT,"GE") Q
        ;
        I PSALAST="GS",PSANEXT'="ST" D ORDERROR("GS",PSANEXT,"ST") Q
        ;
        I PSALAST="CTT",PSANEXT'="SE" D ORDERROR("CTT",PSANEXT,"SE") Q
        ;
        I PSALAST="ST",PSANEXT'="BIG" D ORDERROR("ST",PSANEXT,"BIG") Q
        ;
        ;adding next two lines for new format
        I PSALAST="IT1",PSANEXT="PID" Q
        I PSALAST="PO4",PSANEXT'="IT1",PSANEXT'="CTT"&(PSANEXT'="TDS") D ORDERROR("PO4",PSANEXT,"CTT") Q
        ;End of PSA*3*67 Changes
        Q
        ;
ORDERROR(PSALAST,PSANEW,PSAEXPEC)       ;Segments out of order
        ;ISA segment should be first
        I PSALAST="" S PSASEG="ORDER1" D MSG^PSABRKU8 Q
        ;Segments other than ISA
        S PSASEG="ORDER2" D MSG^PSABRKU8
        Q
