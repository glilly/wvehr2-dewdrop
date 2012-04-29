ORY24309        ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*243) ;NOV 2,2006 at 12:05
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
        ;
        ;
        Q
        ;
DATA    ;
        ;
        ;;R^"860.2:","860.21:9",1,"E"
        ;;D^CLOZAPINE WBC >= 3.5
        ;;R^"860.2:","860.22:1",.01,"E"
        ;;D^1
        ;;R^"860.2:","860.22:1",1,"E"
        ;;D^CLOZAPINE AND (NO WBC W/IN 7 DAYS OR NO ANC W/IN 7 DAYS)
        ;;R^"860.2:","860.22:1",2,"E"
        ;;D^CLOZAPINE APPROPRIATENESS
        ;;R^"860.2:","860.22:1",6,"E"
        ;;D^Clozapine orders require a CBC/Diff within past 7 days.  Please order CBC/Diff with WBC and ANC immediately.  Most recent results - |CLOZ LAB RSLTS|
        ;;R^"860.2:","860.22:2",.01,"E"
        ;;D^2
        ;;R^"860.2:","860.22:2",1,"E"
        ;;D^CLOZAPINE AND (WBC < 3.0 OR ANC < 1.5)
        ;;R^"860.2:","860.22:2",2,"E"
        ;;D^CLOZAPINE APPROPRIATENESS
        ;;R^"860.2:","860.22:2",6,"E"
        ;;D^WBC < 3.0 and/or ANC < 1.5 - pharmacy cannot fill clozapine order. Most recent results - |CLOZ LAB RSLTS|
        ;;R^"860.2:","860.22:3",.01,"E"
        ;;D^3
        ;;R^"860.2:","860.22:3",1,"E"
        ;;D^CLOZAPINE AND 3.0 <= WBC < 3.5 AND ANC >= 1.5
        ;;R^"860.2:","860.22:3",2,"E"
        ;;D^CLOZAPINE APPROPRIATENESS
        ;;R^"860.2:","860.22:3",6,"E"
        ;;D^WBC between 3.0 and 3.5 with ANC >= 1.5 - please repeat CBC/Diff including WBC and ANC immediately and twice weekly.  Most recent results - |CLOZ LAB RSLTS|
        ;;R^"860.2:","860.22:4",.01,"E"
        ;;D^4
        ;;R^"860.2:","860.22:4",1,"E"
        ;;D^CLOZAPINE AND 1.5 <= ANC < 2.0
        ;;R^"860.2:","860.22:4",2,"E"
        ;;D^CLOZAPINE APPROPRIATENESS
        ;;R^"860.2:","860.22:4",6,"E"
        ;;D^ANC between 1.5 and 2.0 - please repeat CBC/Diff including WBC and ANC immediately and twice weekly.  Most recent results - |CLOZ LAB RSLTS|
        ;;EOR^
        ;;EOF^OCXS(860.2)^1
        ;1;
        ;
