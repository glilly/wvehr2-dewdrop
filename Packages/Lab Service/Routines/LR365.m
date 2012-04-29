LR365   ;DALOI/CKA - LR*5.2*365 PATCH ENVIRONMENT CHECK ROUTINE ;05/7/07
        ;;5.2;LAB SERVICE;**365**;Sep 27, 1994;Build 9
EN      ; Does not prevent loading of the transport global.
        ; Environment check is done only during the install.
        ;
        I '$G(XPDENV) D  Q
        .N XQA,XQAMSG
        .S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")
        .S XQAMSG=XQAMSG_" loaded on "_$$HTE^XLFDT($H)
        .S XQA("G.LMI")=""
        .D SETUP^XQALERT
        .S MSG="Sending transport global loaded alert to mail group G.LMI"
        .D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
        ;
        D CHECK
        D EXIT
        Q
        ;
CHECK   ; Perform environment check
        ;
        I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D  Q
        .D BMES^XPDUTL($$CJ^XLFSTR("Terminal Device is not defined",80))
        .S XPDQUIT=2
        ;
        I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D  Q
        .S MSG="Please log in to set local DUZ... variables"
        .D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
        .S XPDQUIT=2
        ;
        I '$D(^VA(200,$G(DUZ),0))#2 D  Q
        .S MSG="You are not a valid user on this system"
        .D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
        .S XPDQUIT=2
        ;
        S XPDIQ("XPZ1","B")="NO"
        ;
        Q
        ;
EXIT    ;
        I $G(XPDQUIT) D
        .S MSG="--- Install Environment Check FAILED ---"
        .D BMES^XPDUTL($$CJ^XLFSTR(MSG,80)) K MSG
        I '$G(XPDQUIT) D
        .D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
        Q
        ;
PRE     ; KIDS Pre install for LR*5.2*365
        Q
        ;
POST    ; KIDS Post install for LR*5.2*365
        ;
        Q
