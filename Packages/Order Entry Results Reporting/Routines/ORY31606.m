ORY31606        ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*316) ;NOV 17,2009 at 13:36
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**316**;Dec 17,1997;Build 17
        ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
        ;
S       ;
        ;
        D DOT^ORY316ES
        ;
        ;
        K REMOTE,LOCAL,OPCODE,REF
        F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
        .S ^TMP("OCXRULE",$J,$O(^TMP("OCXRULE",$J,"A"),-1)+1)=TEXT
        ;
        G ^ORY31607
        ;
        Q
        ;
DATA    ;
        ;
        ;;D^T+; ..D SETAP(OCXGR2_")","860.71223P","Data Field",$P($G(^OCXS(860.4,OCXDFI,0)),U,1),.OCXDATA,OCXDFI)
        ;;R^"860.8:",100,64
        ;;D^T-; ..D SETAP(OCXGR2_")","860.71223P",.OCXDATA,OCXDFI)
        ;;R^"860.8:",100,65
        ;;D^  ; ;
        ;;R^"860.8:",100,66
        ;;D^  ; Q 1
        ;;R^"860.8:",100,67
        ;;D^  ; ;
        ;;R^"860.8:",100,68
        ;;D^T+;SETAP(ROOT,DD,ITEM,ITEMNAME,DATA,DA) ;  Set Rule Event data
        ;;R^"860.8:",100,69
        ;;D^T-;SETAP(ROOT,DD,DATA,DA) ;  Set Rule Event data
        ;;R^"860.8:",100,70
        ;;D^  ; M @ROOT=DATA
        ;;R^"860.8:",100,71
        ;;D^  ; I +$G(DD) S @ROOT@(0)="^"_($G(DD))_"^"_($P($G(@ROOT@(0)),U,3)+1)_"^"_$G(DA)
        ;;R^"860.8:",100,72
        ;;D^  ; I '$G(DD) S $P(@ROOT@(0),U,3,4)=($P($G(@ROOT@(0)),U,3)+1)_"^"_$G(DA)
        ;;R^"860.8:",100,73
        ;;D^T+; W:$G(OCXTRACE) !,"File Active Data ",$G(ITEM),": ",$G(ITEMNAME)
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
        ;;KEY^860.4:^OI LOCAL TEXT
        ;;R^"860.4:",.01,"E"
        ;;D^OI LOCAL TEXT
        ;;R^"860.4:",101,"E"
        ;;D^FREE TEXT
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",.01,"E"
        ;;D^CPRS ORDER PRESCAN
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",.02,"E"
        ;;D^ORDER ENTRY ORDER PRESCAN
        ;;R^"860.4:","860.41:CPRS ORDER PRESCAN^860.6",1,"E"
        ;;D^PATIENT.OPS_LOCAL_TEXT
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
        ;;EOF^OCXS(860.4)^1
        ;;SOF^860.3  ORDER CHECK ELEMENT
        ;;KEY^860.3:^GLUCOPHAGE ORDER
        ;;R^"860.3:",.01,"E"
        ;;D^GLUCOPHAGE ORDER
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
        ;;R^"860.3:","860.31:3",.01,"E"
        ;;D^3
        ;;R^"860.3:","860.31:3",1,"E"
        ;;D^OI LOCAL TEXT
        ;;R^"860.3:","860.31:3",2,"E"
        ;;D^CONTAINS NOCASE ELEMENT IN SET
        ;;R^"860.3:","860.31:3",3,"E"
        ;1;
        ;
