ORY24307        ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*243) ;NOV 2,2006 at 12:05
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
        G ^ORY24308
        ;
        Q
        ;
DATA    ;
        ;
        ;;R^"860.8:",100,74
        ;;D^  ; ;
        ;;R^"860.8:",100,75
        ;;D^  ; Q
        ;;R^"860.8:",100,76
        ;;D^  ; ;
        ;;R^"860.8:",100,77
        ;;D^  ; ;
        ;;EOR^
        ;;KEY^860.8:^RETURN POINTED TO VALUE
        ;;R^"860.8:",.01,"E"
        ;;D^RETURN POINTED TO VALUE
        ;;R^"860.8:",.02,"E"
        ;;D^POINTER
        ;;R^"860.8:",1,1
        ;;D^  ;POINTER(OCXFILE,D0) ;    This Local Extrinsic Function gets the value of the name field
        ;;R^"860.8:",1,2
        ;;D^  ; ;  of record D0 in file OCXFILE
        ;;R^"860.8:",100,1
        ;;D^  ;POINTER(OCXFILE,D0) ;    This Local Extrinsic Function gets the value of the name field
        ;;R^"860.8:",100,2
        ;;D^  ; ;  of record D0 in file OCXFILE
        ;;R^"860.8:",100,3
        ;;D^T+; I $G(OCXTRACE) W !,"%%%%",?20,"   FILE: ",$G(OCXFILE),"  D0: ",$G(D0)
        ;;R^"860.8:",100,4
        ;;D^  ; Q:'$G(D0) "" Q:'$L($G(OCXFILE)) ""
        ;;R^"860.8:",100,5
        ;;D^  ; N GLREF
        ;;R^"860.8:",100,6
        ;;D^  ; I '(OCXFILE=(+OCXFILE)) S GLREF=U_OCXFILE
        ;;R^"860.8:",100,7
        ;;D^  ; E  S GLREF=$$FILE^OCXBDTD(+OCXFILE,"GLOBAL NAME") Q:'$L(GLREF) ""
        ;;R^"860.8:",100,8
        ;;D^T+; I $G(OCXTRACE) W !,"%%%%",?20," GLREF: ",GLREF,"  RESOLVES TO: ",$P($G(@(GLREF_(+D0)_",0)")),U,1)
        ;;R^"860.8:",100,9
        ;;D^  ; Q $P($G(@(GLREF_(+D0)_",0)")),U,1)
        ;;R^"860.8:",100,10
        ;;D^  ; ;
        ;;EOR^
        ;;KEY^860.8:^STRING CONTAINS ONE OF A LIST OF VALUES
        ;;R^"860.8:",.01,"E"
        ;;D^STRING CONTAINS ONE OF A LIST OF VALUES
        ;;R^"860.8:",.02,"E"
        ;;D^CLIST
        ;;R^"860.8:",100,1
        ;;D^  ;CLIST(DATA,LIST) ;   DOES THE DATA FIELD CONTAIN AN ELEMENT IN THE LIST
        ;;R^"860.8:",100,2
        ;;D^  ; ;
        ;;R^"860.8:",100,3
        ;;D^T+; W:$G(OCXTRACE) !!,"$$CLIST(",DATA,",""",LIST,""")"
        ;;R^"860.8:",100,4
        ;;D^  ; N PC F PC=1:1:$L(LIST,","),0 I PC,$L($P(LIST,",",PC)),(DATA[$P(LIST,",",PC)) Q
        ;;R^"860.8:",100,5
        ;;D^  ; Q ''PC
        ;;EOR^
        ;;EOF^OCXS(860.8)^1
        ;;SOF^860.6  ORDER CHECK DATA CONTEXT
        ;;KEY^860.6:^CPRS ORDER PRESCAN
        ;;R^"860.6:",.01,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.6:",.02,"E"
        ;;D^OEPS
        ;;R^"860.6:",1,"E"
        ;;D^DATA DRIVEN
        ;;EOR^
        ;;KEY^860.6:^CPRS ORDER PROTOCOL
        ;;R^"860.6:",.01,"E"
        ;;D^CPRS ORDER PROTOCOL
        ;;R^"860.6:",.02,"E"
        ;;D^OERR
        ;;R^"860.6:",1,"E"
        ;;D^DATA DRIVEN
        ;;EOR^
        ;;KEY^860.6:^DATABASE LOOKUP
        ;;R^"860.6:",.01,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.6:",.02,"E"
        ;;D^DL
        ;;R^"860.6:",1,"E"
        ;;D^PACKAGE LOOKUP
        ;;EOR^
        ;;KEY^860.6:^GENERIC HL7 MESSAGE ARRAY
        ;;R^"860.6:",.01,"E"
        ;;D^GENERIC HL7 MESSAGE ARRAY
        ;;R^"860.6:",.02,"E"
        ;;D^HL7
        ;;R^"860.6:",1,"E"
        ;;D^DATA DRIVEN
        ;;EOR^
        ;;EOF^OCXS(860.6)^1
        ;;SOF^860.5  ORDER CHECK DATA SOURCE
        ;;KEY^860.5:^DATABASE LOOKUP
        ;;R^"860.5:",.01,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.5:",.02,"E"
        ;;D^DATABASE LOOKUP
        ;;EOR^
        ;;KEY^860.5:^HL7 COMMON ORDER SEGMENT
        ;;R^"860.5:",.01,"E"
        ;;D^HL7 COMMON ORDER SEGMENT
        ;;R^"860.5:",.02,"E"
        ;;D^GENERIC HL7 MESSAGE ARRAY
        ;;EOR^
        ;;KEY^860.5:^HL7 PATIENT ID SEGMENT
        ;;R^"860.5:",.01,"E"
        ;;D^HL7 PATIENT ID SEGMENT
        ;;R^"860.5:",.02,"E"
        ;;D^GENERIC HL7 MESSAGE ARRAY
        ;;EOR^
        ;;KEY^860.5:^OERR ORDER EVENT FLAG PROTOCOL
        ;;R^"860.5:",.01,"E"
        ;;D^OERR ORDER EVENT FLAG PROTOCOL
        ;;R^"860.5:",.02,"E"
        ;;D^CPRS ORDER PROTOCOL
        ;;EOR^
        ;;KEY^860.5:^ORDER ENTRY ORDER PRESCAN
        ;;R^"860.5:",.01,"E"
        ;;D^ORDER ENTRY ORDER PRESCAN
        ;;R^"860.5:",.02,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;EOR^
        ;;EOF^OCXS(860.5)^1
        ;;SOF^860.4  ORDER CHECK DATA FIELD
        ;;KEY^860.4:^CLOZAPINE ANC W/IN 7 FLAG
        ;;R^"860.4:",.01,"E"
        ;;D^CLOZAPINE ANC W/IN 7 FLAG
        ;;R^"860.4:",1,"E"
        ;;D^CLOZ ANC FLAG
        ;;R^"860.4:",101,"E"
        ;;D^BOOLEAN
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.01,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.02,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",1,"E"
        ;;D^PATIENT.CLOZ_ANC_W/IN_7_FLAG
        ;;EOR^
        ;;KEY^860.4:^CLOZAPINE ANC W/IN 7 RESULT
        ;;R^"860.4:",.01,"E"
        ;;D^CLOZAPINE ANC W/IN 7 RESULT
        ;;R^"860.4:",1,"E"
        ;;D^CLOZ ANC RSLT
        ;;R^"860.4:",101,"E"
        ;;D^NUMERIC
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.01,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.02,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",1,"E"
        ;;D^PATIENT.CLOZ_ANC_W/IN_7_RSLT
        ;;EOR^
        ;;KEY^860.4:^CLOZAPINE LAB RESULTS
        ;;R^"860.4:",.01,"E"
        ;;D^CLOZAPINE LAB RESULTS
        ;;R^"860.4:",1,"E"
        ;;D^CLOZ LAB RSLTS
        ;;R^"860.4:",101,"E"
        ;;D^FREE TEXT
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.01,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.02,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",1,"E"
        ;;D^PATIENT.CLOZ_LAB_RESULTS
        ;;EOR^
        ;;KEY^860.4:^CLOZAPINE MED
        ;;R^"860.4:",.01,"E"
        ;;D^CLOZAPINE MED
        ;;R^"860.4:",1,"E"
        ;;D^CLOZAPINE
        ;;R^"860.4:",101,"E"
        ;;D^BOOLEAN
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.01,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.02,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",1,"E"
        ;;D^PATIENT.CLOZAPINE MED
        ;;EOR^
        ;;KEY^860.4:^CLOZAPINE WBC W/IN 7 FLAG
        ;;R^"860.4:",.01,"E"
        ;;D^CLOZAPINE WBC W/IN 7 FLAG
        ;;R^"860.4:",1,"E"
        ;;D^CLOZ WBC FLAG
        ;;R^"860.4:",101,"E"
        ;;D^BOOLEAN
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.01,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.02,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",1,"E"
        ;;D^PATIENT.CLOZ_WBC_W/IN_7_FLAG
        ;;EOR^
        ;;KEY^860.4:^CLOZAPINE WBC W/IN 7 RESULT
        ;;R^"860.4:",.01,"E"
        ;;D^CLOZAPINE WBC W/IN 7 RESULT
        ;;R^"860.4:",1,"E"
        ;;D^CLOZ WBC RSLT
        ;;R^"860.4:",101,"E"
        ;;D^NUMERIC
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.01,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",.02,"E"
        ;;D^DATABASE LOOKUP
        ;;R^"860.4:","860.41:DATABASE LOOKUP^860.6",1,"E"
        ;;D^PATIENT.CLOZ_WBC_W/IN_7_RSLT
        ;;EOR^
        ;;KEY^860.4:^FILLER
        ;;R^"860.4:",.01,"E"
        ;;D^FILLER
        ;;R^"860.4:",1,"E"
        ;;D^FILL
        ;;R^"860.4:",101,"E"
        ;;D^FREE TEXT
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",.01,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",.02,"E"
        ;;D^ORDER ENTRY ORDER PRESCAN
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",1,"E"
        ;;D^PATIENT.OPS_FILLER
        ;;R^"860.4:","860.41:GENERIC HL7 MESSAGE ARRAY^860.6",.01,"E"
        ;;D^GENERIC HL7 MESSAGE ARRAY
        ;;R^"860.4:","860.41:GENERIC HL7 MESSAGE ARRAY^860.6",.02,"E"
        ;;D^HL7 COMMON ORDER SEGMENT
        ;;R^"860.4:","860.41:GENERIC HL7 MESSAGE ARRAY^860.6",1,"E"
        ;;D^PATIENT.HL7_FILLER
        ;;EOR^
        ;;KEY^860.4:^ORDER MODE
        ;;R^"860.4:",.01,"E"
        ;;D^ORDER MODE
        ;;R^"860.4:",101,"E"
        ;;D^FREE TEXT
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",.01,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",.02,"E"
        ;;D^ORDER ENTRY ORDER PRESCAN
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",1,"E"
        ;;D^PATIENT.OPS_ORD_MODE
        ;;EOR^
        ;;KEY^860.4:^PATIENT IEN
        ;;R^"860.4:",.01,"E"
        ;;D^PATIENT IEN
        ;;R^"860.4:",101,"E"
        ;;D^NUMERIC
        ;;R^"860.4:","860.41:CPRS ORDER PROTOCOL^860.6",.01,"E"
        ;;D^CPRS ORDER PROTOCOL
        ;;R^"860.4:","860.41:CPRS ORDER PROTOCOL^860.6",.02,"E"
        ;;D^OERR ORDER EVENT FLAG PROTOCOL
        ;;R^"860.4:","860.41:CPRS ORDER PROTOCOL^860.6",1,"E"
        ;1;
        ;
