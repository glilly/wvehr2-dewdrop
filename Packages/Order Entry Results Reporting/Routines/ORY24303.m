ORY24303        ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*243) ;NOV 2,2006 at 12:05
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
        G ^ORY24304
        ;
        Q
        ;
DATA    ;
        ;
        ;;D^IS LESS THAN
        ;;R^"863.9:","863.91:3",.01,"E"
        ;;D^OCXO GENERATE CODE FUNCTION
        ;;R^"863.9:","863.91:3",1,"E"
        ;;D^GCC NUMERIC LESS THAN
        ;;EOR^
        ;;KEY^863.9:^LOGICAL FALSE
        ;;R^"863.9:",.01,"E"
        ;;D^LOGICAL FALSE
        ;;R^"863.9:",.02,"E"
        ;;D^BOOLEAN
        ;;R^"863.9:",.03,"E"
        ;;D^GCC BOOLEAN LOGICAL FALSE
        ;;R^"863.9:",.04,"E"
        ;;D^IS FALSE
        ;;R^"863.9:","863.91:1",.01,"E"
        ;;D^OCXO GENERATE CODE FUNCTION
        ;;R^"863.9:","863.91:1",1,"E"
        ;;D^GCC BOOLEAN LOGICAL FALSE
        ;;R^"863.9:","863.92:1",.01,"E"
        ;;D^FALSE
        ;;EOR^
        ;;KEY^863.9:^LOGICAL TRUE
        ;;R^"863.9:",.01,"E"
        ;;D^LOGICAL TRUE
        ;;R^"863.9:",.02,"E"
        ;;D^BOOLEAN
        ;;R^"863.9:",.03,"E"
        ;;D^GCC BOOLEAN LOGICAL TRUE
        ;;R^"863.9:",.04,"E"
        ;;D^IS TRUE
        ;;R^"863.9:","863.91:1",.01,"E"
        ;;D^OCXO GENERATE CODE FUNCTION
        ;;R^"863.9:","863.91:1",1,"E"
        ;;D^GCC BOOLEAN LOGICAL TRUE
        ;;R^"863.9:","863.92:1",.01,"E"
        ;;D^TRUE
        ;;EOR^
        ;;KEY^863.9:^STARTS WITH
        ;;R^"863.9:",.01,"E"
        ;;D^STARTS WITH
        ;;R^"863.9:",.02,"E"
        ;;D^FREE TEXT
        ;;R^"863.9:",.04,"E"
        ;;D^STARTS WITH
        ;;R^"863.9:","863.91:3",.01,"E"
        ;;D^OCXO GENERATE CODE FUNCTION
        ;;R^"863.9:","863.91:3",1,"E"
        ;;D^GCC FREE TEXT STARTS WITH
        ;;R^"863.9:","863.92:1",.01,"E"
        ;;D^BEGINS WITH
        ;;EOR^
        ;;EOF^OCXS(863.9)^1
        ;;SOF^863.4  OCX MDD ATTRIBUTE
        ;;KEY^863.4:^CLOZAPINE ANC W/IN 7 FLAG
        ;;R^"863.4:",.01,"E"
        ;;D^CLOZAPINE ANC W/IN 7 FLAG
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^BOOLEAN
        ;;EOR^
        ;;KEY^863.4:^CLOZAPINE ANC W/IN 7 RESULT
        ;;R^"863.4:",.01,"E"
        ;;D^CLOZAPINE ANC W/IN 7 RESULT
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^NUMERIC
        ;;EOR^
        ;;KEY^863.4:^CLOZAPINE LAB RESULTS
        ;;R^"863.4:",.01,"E"
        ;;D^CLOZAPINE LAB RESULTS
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^FREE TEXT
        ;;EOR^
        ;;KEY^863.4:^CLOZAPINE MED
        ;;R^"863.4:",.01,"E"
        ;;D^CLOZAPINE MED
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^BOOLEAN
        ;;EOR^
        ;;KEY^863.4:^CLOZAPINE WBC W/IN 7 FLAG
        ;;R^"863.4:",.01,"E"
        ;;D^CLOZAPINE WBC W/IN 7 FLAG
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^BOOLEAN
        ;;EOR^
        ;;KEY^863.4:^CLOZAPINE WBC W/IN 7 RESULT
        ;;R^"863.4:",.01,"E"
        ;;D^CLOZAPINE WBC W/IN 7 RESULT
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^NUMERIC
        ;;EOR^
        ;;KEY^863.4:^DISPENSE DRUG
        ;;R^"863.4:",.01,"E"
        ;;D^DISPENSE DRUG
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^FREE TEXT
        ;;EOR^
        ;;KEY^863.4:^FILLER
        ;;R^"863.4:",.01,"E"
        ;;D^FILLER
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^FREE TEXT
        ;;EOR^
        ;;KEY^863.4:^HL7 FILLER
        ;;R^"863.4:",.01,"E"
        ;;D^HL7 FILLER
        ;;R^"863.4:",.02,"E"
        ;;D^HL7FILLR
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^FREE TEXT
        ;;EOR^
        ;;KEY^863.4:^IEN
        ;;R^"863.4:",.01,"E"
        ;;D^IEN
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^NUMERIC
        ;;EOR^
        ;;KEY^863.4:^ORDER MODE
        ;;R^"863.4:",.01,"E"
        ;;D^ORDER MODE
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^FREE TEXT
        ;;EOR^
        ;;KEY^863.4:^ORDER PATIENT
        ;;R^"863.4:",.01,"E"
        ;;D^ORDER PATIENT
        ;;R^"863.4:","863.41:1",.01,"E"
        ;;D^DATA TYPE
        ;;R^"863.4:","863.41:1",1,"E"
        ;;D^NUMERIC
        ;;EOR^
        ;;EOF^OCXS(863.4)^1
        ;;SOF^863.2  OCX MDD SUBJECT
        ;;KEY^863.2:^PATIENT
        ;;R^"863.2:",.01,"E"
        ;;D^PATIENT
        ;;R^"863.2:","863.21:1",.01,"E"
        ;;D^FILE
        ;;R^"863.2:","863.21:1",1,"E"
        ;;D^2
        ;;EOR^
        ;;EOF^OCXS(863.2)^1
        ;;SOF^863.3  OCX MDD LINK
        ;;KEY^863.3:^PATIENT.CLOZAPINE MED
        ;;R^"863.3:",.01,"E"
        ;;D^PATIENT.CLOZAPINE MED
        ;;R^"863.3:",.02,"E"
        ;;D^PATIENT
        ;;R^"863.3:",.05,"E"
        ;;D^CLOZAPINE MED
        ;;R^"863.3:",.06,"E"
        ;;D^3555
        ;;R^"863.3:","863.32:1",.01,"E"
        ;;D^OCXO EXTERNAL FUNCTION CALL
        ;;R^"863.3:","863.32:1",1,"E"
        ;;D^CLOZLABS^ORKLR(|PATIENT IEN|,7,|DISP DRUG IEN|)
        ;;R^"863.3:","863.32:2",.01,"E"
        ;;D^OCXO UP-ARROW PIECE NUMBER
        ;;R^"863.3:","863.32:2",1,"E"
        ;;D^1
        ;;EOR^
        ;;KEY^863.3:^PATIENT.CLOZ_ANC_W/IN_7_FLAG
        ;;R^"863.3:",.01,"E"
        ;;D^PATIENT.CLOZ_ANC_W/IN_7_FLAG
        ;;R^"863.3:",.02,"E"
        ;;D^PATIENT
        ;;R^"863.3:",.05,"E"
        ;;D^CLOZAPINE ANC W/IN 7 FLAG
        ;;R^"863.3:","863.32:1",.01,"E"
        ;;D^OCXO EXTERNAL FUNCTION CALL
        ;;R^"863.3:","863.32:1",1,"E"
        ;;D^CLOZLABS^ORKLR(|PATIENT IEN|,7,|DISP DRUG IEN|)
        ;;R^"863.3:","863.32:2",.01,"E"
        ;;D^OCXO UP-ARROW PIECE NUMBER
        ;;R^"863.3:","863.32:2",1,"E"
        ;;D^3
        ;;R^"863.3:","863.32:3",.01,"E"
        ;;D^OCXO SEMI-COLON PIECE NUMBER
        ;;R^"863.3:","863.32:3",1,"E"
        ;;D^1
        ;;EOR^
        ;;KEY^863.3:^PATIENT.CLOZ_ANC_W/IN_7_RSLT
        ;;R^"863.3:",.01,"E"
        ;;D^PATIENT.CLOZ_ANC_W/IN_7_RSLT
        ;;R^"863.3:",.02,"E"
        ;;D^PATIENT
        ;;R^"863.3:",.05,"E"
        ;;D^CLOZAPINE ANC W/IN 7 RESULT
        ;;R^"863.3:","863.32:1",.01,"E"
        ;;D^OCXO EXTERNAL FUNCTION CALL
        ;;R^"863.3:","863.32:1",1,"E"
        ;;D^CLOZLABS^ORKLR(|PATIENT IEN|,7,|DISP DRUG IEN|)
        ;;R^"863.3:","863.32:2",.01,"E"
        ;;D^OCXO UP-ARROW PIECE NUMBER
        ;;R^"863.3:","863.32:2",1,"E"
        ;;D^3
        ;;R^"863.3:","863.32:3",.01,"E"
        ;;D^OCXO SEMI-COLON PIECE NUMBER
        ;;R^"863.3:","863.32:3",1,"E"
        ;;D^2
        ;;EOR^
        ;;KEY^863.3:^PATIENT.CLOZ_LAB_RESULTS
        ;;R^"863.3:",.01,"E"
        ;;D^PATIENT.CLOZ_LAB_RESULTS
        ;;R^"863.3:",.02,"E"
        ;;D^PATIENT
        ;;R^"863.3:",.05,"E"
        ;;D^CLOZAPINE LAB RESULTS
        ;;R^"863.3:","863.32:1",.01,"E"
        ;;D^OCXO EXTERNAL FUNCTION CALL
        ;;R^"863.3:","863.32:1",1,"E"
        ;;D^CLOZLABS^ORKLR(|PATIENT IEN|,"",|DISP DRUG IEN|)
        ;;R^"863.3:","863.32:2",.01,"E"
        ;;D^OCXO UP-ARROW PIECE NUMBER
        ;;R^"863.3:","863.32:2",1,"E"
        ;;D^4
        ;;EOR^
        ;;KEY^863.3:^PATIENT.CLOZ_WBC_W/IN_7_FLAG
        ;;R^"863.3:",.01,"E"
        ;;D^PATIENT.CLOZ_WBC_W/IN_7_FLAG
        ;;R^"863.3:",.02,"E"
        ;;D^PATIENT
        ;;R^"863.3:",.05,"E"
        ;;D^CLOZAPINE WBC W/IN 7 FLAG
        ;;R^"863.3:",.06,"E"
        ;;D^999
        ;;R^"863.3:","863.32:1",.01,"E"
        ;;D^OCXO EXTERNAL FUNCTION CALL
        ;;R^"863.3:","863.32:1",1,"E"
        ;;D^CLOZLABS^ORKLR(|PATIENT IEN|,7,|DISP DRUG IEN|)
        ;;R^"863.3:","863.32:2",.01,"E"
        ;;D^OCXO UP-ARROW PIECE NUMBER
        ;;R^"863.3:","863.32:2",1,"E"
        ;;D^2
        ;;R^"863.3:","863.32:3",.01,"E"
        ;;D^OCXO SEMI-COLON PIECE NUMBER
        ;;R^"863.3:","863.32:3",1,"E"
        ;;D^1
        ;;EOR^
        ;;KEY^863.3:^PATIENT.CLOZ_WBC_W/IN_7_RSLT
        ;;R^"863.3:",.01,"E"
        ;;D^PATIENT.CLOZ_WBC_W/IN_7_RSLT
        ;;R^"863.3:",.02,"E"
        ;;D^PATIENT
        ;;R^"863.3:",.05,"E"
        ;;D^CLOZAPINE WBC W/IN 7 RESULT
        ;;R^"863.3:","863.32:1",.01,"E"
        ;;D^OCXO EXTERNAL FUNCTION CALL
        ;;R^"863.3:","863.32:1",1,"E"
        ;;D^CLOZLABS^ORKLR(|PATIENT IEN|,7,|DISP DRUG IEN|)
        ;;R^"863.3:","863.32:2",.01,"E"
        ;;D^OCXO UP-ARROW PIECE NUMBER
        ;;R^"863.3:","863.32:2",1,"E"
        ;;D^2
        ;;R^"863.3:","863.32:3",.01,"E"
        ;;D^OCXO SEMI-COLON PIECE NUMBER
        ;;R^"863.3:","863.32:3",1,"E"
        ;;D^2
        ;;EOR^
        ;;KEY^863.3:^PATIENT.HL7_FILLER
        ;;R^"863.3:",.01,"E"
        ;;D^PATIENT.HL7_FILLER
        ;;R^"863.3:",.02,"E"
        ;;D^PATIENT
        ;;R^"863.3:",.04,"E"
        ;;D^HL7
        ;;R^"863.3:",.05,"E"
        ;;D^HL7 FILLER
        ;;R^"863.3:","863.32:1",.01,"E"
        ;;D^OCXO VT-BAR PIECE NUMBER
        ;;R^"863.3:","863.32:2",.01,"E"
        ;;D^OCXO UP-ARROW PIECE NUMBER
        ;;R^"863.3:","863.32:2",1,"E"
        ;;D^2
        ;;R^"863.3:","863.32:3",.01,"E"
        ;;D^OCXO VARIABLE NAME
        ;1;
        ;
