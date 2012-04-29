OCXSEND3        ;SLC/RJS,CLA - BUILD RULE TRANSPORTER ROUTINES (Build Routines) ;1/31/01  08:51
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,74,96,105,243**;Dec 17,1997;Build 242
        ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
        ;
EN()    ;
        ;
        N LAST,RLINE,RNUM,RTEXT,TOTLINE
        K ^TMP("OCXSEND",$J,"RTN") S ^TMP("OCXSEND",$J,"RTN",100,0)=" ;"
        S (TOTLINE,RSIZE,RLINE,RCNT)=0,RNUM=1 F  S RLINE=$O(^TMP("OCXSEND",$J,"DATA",RLINE)) Q:'RLINE  D
        .S RTEXT=$G(^TMP("OCXSEND",$J,"DATA",RLINE)) Q:'$L(RTEXT)
        .S LAST=$O(^TMP("OCXSEND",$J,"RTN",""),-1)+1,RCNT=RCNT+1,RSIZE=RSIZE+$L(RTEXT)
        .S ^TMP("OCXSEND",$J,"RTN",LAST,0)=" ;;"_RTEXT
        .I (RSIZE>6000) S TOTLINE=TOTLINE+$$RFILE($O(^TMP("OCXSEND",$J,"DATA",RLINE)),.RNUM) S (RSIZE,RCNT)=0
        I $O(^TMP("OCXSEND",$J,"RTN",100)) S TOTLINE=TOTLINE+$$RFILE(0,.RNUM)
        ;
        Q TOTLINE
        ;
RFILE(LINK,RNUM)        ;
        ;
        N DIE,LAST,X,XCN
        D HDR(LINK,RNUM)
        S LAST=$O(^TMP("OCXSEND",$J,"RTN",""),-1)+1
        S ^TMP("OCXSEND",$J,"RTN",LAST,0)=" ;1;"
        S ^TMP("OCXSEND",$J,"RTN",LAST+1,0)=" ;"
        S ^TMP("OCXSEND",$J,"RTN",LAST+2,0)="$"
        S DIE="^TMP(""OCXSEND"","_$J_",""RTN"",",XCN=0
        S X=$$RNAME(RNUM,2)
        W !,X
        X ^%ZOSF("SAVE")
        S RNUM=RNUM+1
        K ^TMP("OCXSEND",$J,"RTN") S ^TMP("OCXSEND",$J,"RTN",100,0)=" ;"
        Q ""
        ;
NOW()   ;
        N X,Y,%DT
        S X="N",%DT="T" D ^%DT S Y=$$DATE^OCXSENDD(Y)
        I (Y["@") S Y=$P(Y,"@",1)_" at "_$P(Y,"@",2)
        Q Y
        ;
HDR(LINK,RNUM)  ;
        ;
        N R,LINE,TEXT,RNAME,RLINK,NOW
        S NOW=$$NOW
        I 'LINK S RLINK=";"
        E  S RLINK="G ^"_$$RNAME(RNUM+1,2)
        S RNAME=$$RNAME(RNUM,2),(HEADER1,HEADER2,HEADER3,HEADER4,HEADER5)=";"
        ;
        F LINE=1:1:999 S TEXT=$P($T(TEXT+LINE),";",2,999) Q:TEXT  S TEXT=$P(TEXT,";",2,999) S R(LINE,0)=$$CONV(TEXT)
        ;
        M ^TMP("OCXSEND",$J,"RTN")=R
        ;
        Q
        ;
HEX(X)  Q:'X "" Q $$HEX(X\36)_$E("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",((X#36)+1))
        ;
RNAME(X,Y)      ;
        ; Y=0  -> Main Routine
        ; Y=1  -> Runtime Library Routine
        ; Y=2  -> Data Routine for ORYppp
        ; Y=3  -> Data Routine for OCXRU
        ;
        N OCXRN1,OCXRN2,OCXSEQ
        ;
        S OCXRN1="OCXRULE",OCXRN2="OCXRU"
        S:$L($G(OCXPATCH)) OCXRN2="ORY"_$E((1000+$P(OCXPATCH,"*",3)),2,4),OCXRN1=OCXRN2_"ES"
        ;
        Q:'Y OCXRN1
        ;
        I (Y=1),(X>35) Q ""
        I (Y=2),'$L($G(OCXPATCH)) S Y=3
        I (Y=2),(X>1295) Q ""
        I (Y=3),(X>46655) Q ""
        ;
        S OCXSEQ=0 S:X OCXSEQ=$$HEX(X)
        S OCXSEQ="00000"_OCXSEQ
        S OCXSEQ=$E(OCXSEQ,($L(OCXSEQ)-Y+1),$L(OCXSEQ))
        ;
        Q OCXRN2_OCXSEQ
        ;
CONV(X) ;
        N VAL
        F  Q:'(X["|")  D
        .S VAL=$P(X,"|",2)
        .X "S VAL="_VAL
        .S X=$P(X,"|",1)_VAL_$P(X,"|",3,999)
        I '(X="$"),'$L($P(X," ",2)) S X=X_" ;"
        Q X
        ;
TEXT    ;
        ;;|RNAME| ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE |OCXPATCH| ;|NOW|
        ;;|OCXLIN2|
        ;;|OCXLIN3|
        ;; ;
        ;;S ;
        ;; ;
        ;; D DOT^|$$RNAME^OCXSEND3(0,0)|
        ;; ;
        ;; ;
        ;; K REMOTE,LOCAL,OPCODE,REF
        ;; F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
        ;; .S ^TMP("OCXRULE",$J,$O(^TMP("OCXRULE",$J,"A"),-1)+1)=TEXT
        ;; ;
        ;; |RLINK|
        ;; ;
        ;; Q
        ;; ;
        ;;DATA ;
        ;1;
        ;
