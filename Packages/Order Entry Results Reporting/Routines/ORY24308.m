ORY24308        ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*243) ;NOV 2,2006 at 12:05
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17,1997;Build 242
        ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
        ;
S       ;
        ;
        D DOT^ORY243ES
        ;
        ;
        K REMOTE,LOCAL,OPCODE,REF
        F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
        .S ^TMP("OCXRULE",$J,$O(^TMP("OCXRULE",$J,"A"),-1)+1)=TEXT
        ;
        G ^ORY24309
        ;
        Q
        ;
DATA    ;
        ;
        ;;D^PATIENT.OERR_ORDER_PATIENT
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.01,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.02,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",1,"E"
        ;;D^PATIENT.IEN
        ;;R^"860.4:","860.41:GENERIC HL7 MESSAGE ARRAY^860.6",.01,"E"
        ;;D^GENERIC HL7 MESSAGE ARRAY
        ;;R^"860.4:","860.41:GENERIC HL7 MESSAGE ARRAY^860.6",.02,"E"
        ;;D^HL7 PATIENT ID SEGMENT
        ;;R^"860.4:","860.41:GENERIC HL7 MESSAGE ARRAY^860.6",1,"E"
        ;;D^PATIENT.HL7_PATIENT_ID
        ;;EOR^
        ;;KEY^860.4:^PHARMACY LOCAL ID
        ;;R^"860.4:",.01,"E"
        ;;D^PHARMACY LOCAL ID
        ;;R^"860.4:",1,"E"
        ;;D^DISP DRUG IEN
        ;;R^"860.4:",101,"E"
        ;;D^FREE TEXT
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",.01,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",.02,"E"
        ;;D^ORDER ENTRY ORDER PRESCAN
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",1,"E"
        ;;D^PATIENT.OPS_DRUG_ID
        ;;EOR^
        ;;EOF^OCXS(860.4)^1
        ;;SOF^860.3  ORDER CHECK ELEMENT
        ;;KEY^860.3:^CLOZAPINE ANC < 1.5
        ;;R^"860.3:",.01,"E"
        ;;D^CLOZAPINE ANC < 1.5
        ;;R^"860.3:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.3:","860.31:4",.01,"E"
        ;;D^4
        ;;R^"860.3:","860.31:4",1,"E"
        ;;D^CLOZAPINE ANC W/IN 7 RESULT
        ;;R^"860.3:","860.31:4",2,"E"
        ;;D^LESS THAN
        ;;R^"860.3:","860.31:4",3,"E"
        ;;D^1.5
        ;;R^"860.3:","860.31:5",.01,"E"
        ;;D^5
        ;;R^"860.3:","860.31:5",1,"E"
        ;;D^CLOZAPINE ANC W/IN 7 FLAG
        ;;R^"860.3:","860.31:5",2,"E"
        ;;D^LOGICAL TRUE
        ;;EOR^
        ;;KEY^860.3:^CLOZAPINE ANC >= 1.5
        ;;R^"860.3:",.01,"E"
        ;;D^CLOZAPINE ANC >= 1.5
        ;;R^"860.3:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.3:","860.31:1",.01,"E"
        ;;D^1
        ;;R^"860.3:","860.31:1",1,"E"
        ;;D^CLOZAPINE ANC W/IN 7 RESULT
        ;;R^"860.3:","860.31:1",2,"E"
        ;;D^GREATER THAN
        ;;R^"860.3:","860.31:1",3,"E"
        ;;D^1.499
        ;;R^"860.3:","860.31:2",.01,"E"
        ;;D^2
        ;;R^"860.3:","860.31:2",1,"E"
        ;;D^CLOZAPINE ANC W/IN 7 FLAG
        ;;R^"860.3:","860.31:2",2,"E"
        ;;D^LOGICAL TRUE
        ;;EOR^
        ;;KEY^860.3:^CLOZAPINE ANC >= 1.5 & < 2.0
        ;;R^"860.3:",.01,"E"
        ;;D^CLOZAPINE ANC >= 1.5 & < 2.0
        ;;R^"860.3:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.3:","860.31:1",.01,"E"
        ;;D^1
        ;;R^"860.3:","860.31:1",1,"E"
        ;;D^CLOZAPINE ANC W/IN 7 RESULT
        ;;R^"860.3:","860.31:1",2,"E"
        ;;D^GREATER THAN
        ;;R^"860.3:","860.31:1",3,"E"
        ;;D^1.499
        ;;R^"860.3:","860.31:2",.01,"E"
        ;;D^2
        ;;R^"860.3:","860.31:2",1,"E"
        ;;D^CLOZAPINE ANC W/IN 7 RESULT
        ;;R^"860.3:","860.31:2",2,"E"
        ;;D^LESS THAN
        ;;R^"860.3:","860.31:2",3,"E"
        ;;D^2.0
        ;;R^"860.3:","860.31:3",.01,"E"
        ;;D^3
        ;;R^"860.3:","860.31:3",1,"E"
        ;;D^CLOZAPINE ANC W/IN 7 FLAG
        ;;R^"860.3:","860.31:3",2,"E"
        ;;D^LOGICAL TRUE
        ;;EOR^
        ;;KEY^860.3:^CLOZAPINE DRUG SELECTED
        ;;R^"860.3:",.01,"E"
        ;;D^CLOZAPINE DRUG SELECTED
        ;;R^"860.3:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.3:","860.31:1",.01,"E"
        ;;D^1
        ;;R^"860.3:","860.31:1",1,"E"
        ;;D^ORDER MODE
        ;;R^"860.3:","860.31:1",2,"E"
        ;;D^EQ FREE TEXT
        ;;R^"860.3:","860.31:1",3,"E"
        ;;D^SELECT
        ;;R^"860.3:","860.31:2",.01,"E"
        ;;D^2
        ;;R^"860.3:","860.31:2",1,"E"
        ;;D^FILLER
        ;;R^"860.3:","860.31:2",2,"E"
        ;;D^STARTS WITH
        ;;R^"860.3:","860.31:2",3,"E"
        ;;D^PS
        ;;R^"860.3:","860.31:5",.01,"E"
        ;;D^5
        ;;R^"860.3:","860.31:5",1,"E"
        ;;D^CLOZAPINE MED
        ;;R^"860.3:","860.31:5",2,"E"
        ;;D^LOGICAL TRUE
        ;;EOR^
        ;;KEY^860.3:^CLOZAPINE NO ANC W/IN 7 DAYS
        ;;R^"860.3:",.01,"E"
        ;;D^CLOZAPINE NO ANC W/IN 7 DAYS
        ;;R^"860.3:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.3:","860.31:6",.01,"E"
        ;;D^6
        ;;R^"860.3:","860.31:6",1,"E"
        ;;D^CLOZAPINE ANC W/IN 7 FLAG
        ;;R^"860.3:","860.31:6",2,"E"
        ;;D^LOGICAL FALSE
        ;;EOR^
        ;;KEY^860.3:^CLOZAPINE NO WBC W/IN 7 DAYS
        ;;R^"860.3:",.01,"E"
        ;;D^CLOZAPINE NO WBC W/IN 7 DAYS
        ;;R^"860.3:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.3:","860.31:4",.01,"E"
        ;;D^4
        ;;R^"860.3:","860.31:4",1,"E"
        ;;D^CLOZAPINE WBC W/IN 7 FLAG
        ;;R^"860.3:","860.31:4",2,"E"
        ;;D^LOGICAL FALSE
        ;;EOR^
        ;;KEY^860.3:^CLOZAPINE WBC < 3.0
        ;;R^"860.3:",.01,"E"
        ;;D^CLOZAPINE WBC < 3.0
        ;;R^"860.3:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.3:","860.31:4",.01,"E"
        ;;D^4
        ;;R^"860.3:","860.31:4",1,"E"
        ;;D^CLOZAPINE WBC W/IN 7 RESULT
        ;;R^"860.3:","860.31:4",2,"E"
        ;;D^LESS THAN
        ;;R^"860.3:","860.31:4",3,"E"
        ;;D^3.0
        ;;R^"860.3:","860.31:5",.01,"E"
        ;;D^5
        ;;R^"860.3:","860.31:5",1,"E"
        ;;D^CLOZAPINE WBC W/IN 7 FLAG
        ;;R^"860.3:","860.31:5",2,"E"
        ;;D^LOGICAL TRUE
        ;;EOR^
        ;;KEY^860.3:^CLOZAPINE WBC >= 3.0 & < 3.5
        ;;R^"860.3:",.01,"E"
        ;;D^CLOZAPINE WBC >= 3.0 & < 3.5
        ;;R^"860.3:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.3:","860.31:4",.01,"E"
        ;;D^4
        ;;R^"860.3:","860.31:4",1,"E"
        ;;D^CLOZAPINE WBC W/IN 7 RESULT
        ;;R^"860.3:","860.31:4",2,"E"
        ;;D^GREATER THAN
        ;;R^"860.3:","860.31:4",3,"E"
        ;;D^2.999
        ;;R^"860.3:","860.31:5",.01,"E"
        ;;D^5
        ;;R^"860.3:","860.31:5",1,"E"
        ;;D^CLOZAPINE WBC W/IN 7 RESULT
        ;;R^"860.3:","860.31:5",2,"E"
        ;;D^LESS THAN
        ;;R^"860.3:","860.31:5",3,"E"
        ;;D^3.5
        ;;R^"860.3:","860.31:6",.01,"E"
        ;;D^6
        ;;R^"860.3:","860.31:6",1,"E"
        ;;D^CLOZAPINE WBC W/IN 7 FLAG
        ;;R^"860.3:","860.31:6",2,"E"
        ;;D^LOGICAL TRUE
        ;;EOR^
        ;;KEY^860.3:^CLOZAPINE WBC >= 3.5
        ;;R^"860.3:",.01,"E"
        ;;D^CLOZAPINE WBC >= 3.5
        ;;R^"860.3:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.3:","860.31:1",.01,"E"
        ;;D^1
        ;;R^"860.3:","860.31:1",1,"E"
        ;;D^CLOZAPINE WBC W/IN 7 RESULT
        ;;R^"860.3:","860.31:1",2,"E"
        ;;D^GREATER THAN
        ;;R^"860.3:","860.31:1",3,"E"
        ;;D^3.499
        ;;R^"860.3:","860.31:2",.01,"E"
        ;;D^2
        ;;R^"860.3:","860.31:2",1,"E"
        ;;D^CLOZAPINE WBC W/IN 7 FLAG
        ;;R^"860.3:","860.31:2",2,"E"
        ;;D^LOGICAL TRUE
        ;;EOR^
        ;;EOF^OCXS(860.3)^1
        ;;SOF^860.2  ORDER CHECK RULE
        ;;KEY^860.2:^CLOZAPINE
        ;;R^"860.2:",.01,"E"
        ;;D^CLOZAPINE
        ;;R^"860.2:","860.21:10",.01,"E"
        ;;D^1.5 <= ANC < 2.0
        ;;R^"860.2:","860.21:10",.02,"E"
        ;;D^SIMPLE DEFINITION
        ;;R^"860.2:","860.21:10",1,"E"
        ;;D^CLOZAPINE ANC >= 1.5 & < 2.0
        ;;R^"860.2:","860.21:2",.01,"E"
        ;;D^NO WBC W/IN 7 DAYS
        ;;R^"860.2:","860.21:2",.02,"E"
        ;;D^SIMPLE DEFINITION
        ;;R^"860.2:","860.21:2",1,"E"
        ;;D^CLOZAPINE NO WBC W/IN 7 DAYS
        ;;R^"860.2:","860.21:3",.01,"E"
        ;;D^WBC < 3.0
        ;;R^"860.2:","860.21:3",.02,"E"
        ;;D^SIMPLE DEFINITION
        ;;R^"860.2:","860.21:3",1,"E"
        ;;D^CLOZAPINE WBC < 3.0
        ;;R^"860.2:","860.21:4",.01,"E"
        ;;D^ANC < 1.5
        ;;R^"860.2:","860.21:4",.02,"E"
        ;;D^SIMPLE DEFINITION
        ;;R^"860.2:","860.21:4",1,"E"
        ;;D^CLOZAPINE ANC < 1.5
        ;;R^"860.2:","860.21:5",.01,"E"
        ;;D^3.0 <= WBC < 3.5
        ;;R^"860.2:","860.21:5",.02,"E"
        ;;D^SIMPLE DEFINITION
        ;;R^"860.2:","860.21:5",1,"E"
        ;;D^CLOZAPINE WBC >= 3.0 & < 3.5
        ;;R^"860.2:","860.21:6",.01,"E"
        ;;D^NO ANC W/IN 7 DAYS
        ;;R^"860.2:","860.21:6",.02,"E"
        ;;D^SIMPLE DEFINITION
        ;;R^"860.2:","860.21:6",1,"E"
        ;;D^CLOZAPINE NO ANC W/IN 7 DAYS
        ;;R^"860.2:","860.21:7",.01,"E"
        ;;D^CLOZAPINE
        ;;R^"860.2:","860.21:7",.02,"E"
        ;;D^SIMPLE DEFINITION
        ;;R^"860.2:","860.21:7",1,"E"
        ;;D^CLOZAPINE DRUG SELECTED
        ;;R^"860.2:","860.21:8",.01,"E"
        ;;D^ANC >= 1.5
        ;;R^"860.2:","860.21:8",.02,"E"
        ;;D^SIMPLE DEFINITION
        ;;R^"860.2:","860.21:8",1,"E"
        ;;D^CLOZAPINE ANC >= 1.5
        ;;R^"860.2:","860.21:9",.01,"E"
        ;;D^WBC >= 3.5
        ;;R^"860.2:","860.21:9",.02,"E"
        ;;D^SIMPLE DEFINITION
        ;1;
        ;
