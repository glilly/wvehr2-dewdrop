ORY31607        ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*316) ;NOV 17,2009 at 13:36
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
        ;
        ;
        Q
        ;
DATA    ;
        ;
        ;;D^GLUCOPHAGE,METFORMIN
        ;;R^"860.3:","860.31:3",3.1,"E"
        ;;D^1
        ;;EOR^
        ;;EOF^OCXS(860.3)^1
        ;1;
        ;
