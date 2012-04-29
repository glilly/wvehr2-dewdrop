XQALSET ;ISC-SF.SEA/JLI - SETUP ALERTS ;4/10/07  14:06
        ;;8.0;KERNEL;**1,6,65,75,114,125,173,207,285,443**;Jul 10, 1995;Build 4
        ;;
        Q
        ; Original entry point - throw away return value since no value expected
SETUP   ;
        N I S I=$$SETUP1() K XQALERR
        Q
        ;
SETUP1()        ; .SR Returns a string beginning with 1 if successful, 0 if not successful, the second piece is the IEN in the Alert Tracking File and the third piece is the value of XQAID.
        ; If not successful XQALERR is defined and contains reason for failure.
        K XQALERR
        I $O(XQA(0))="" S XQALERR="No recipient list in XQA array" Q 0
        I '($D(XQAMSG)#2)!($G(XQAMSG)="") S XQALERR="No valid XQAMSG for display" Q 0
        N X,XQI,XQJ,XQX,XQK,XQACOMNT,XQARESET,DA,XQADA,XQALTYPE
        S XQALTYPE="INITIAL RECIPIENT"
        S XQAOPT1=$S('($D(XQAROU)#2):U,XQAROU'[U:U_XQAROU,1:XQAROU),XQAOPT1=$S(XQAOPT1'=U:XQAOPT1,$D(XQAOPT)#2:XQAOPT_U,1:XQAOPT1) S:XQAOPT1=U XQAOPT1=U_" "
NOW     S XQX=$$NOW^XLFDT()
        S:$S('$D(XQAID):1,XQAID="":1,1:0) XQAID="NO-ID" S:XQAID[";" XQAID=$P(XQAID,";") S XQA1=XQAID,XQI=XQX
        S XQAID=$$SETIEN(XQA1,XQX),XQADA=""
        Q $$REENT()
        ;
REENT() ; Entry for forwarding, etc.
        N RETVAL S RETVAL=1
        K ^TMP("XQAGROUP",$J) ; P443 - clear location for storage of groups processed
        N XQADATIM,XQALIST,XQALIST1,XQNRECIP S XQNRECIP=0 S XQADATIM=$$NOW^XLFDT()
        S XQALIN1=$S($D(XQAID)#2:XQAID,1:"")_U_$E(XQAMSG,1,80)_"^1^"_$S(XQAOPT1=U:"D",1:"R")_U_$S($D(XQACTMSG):$E(XQACTMSG,1,40),1:"")_U_XQAOPT1
        S:$D(XQACNDEL) $P(XQALIN1,U,9)=1 S:$D(XQASURO) $P(XQALIN1,U,12)=XQASURO S:$D(XQASUPV) $P(XQALIN1,U,13)=XQASUPV S:$D(XQAREVUE) $P(XQALIN1,U,14)=XQAREVUE
        S XQALIN=XQX_U_XQALIN1,XQJ=0
        K XQALIN1 S:$D(XQADATA) XQALIN1=XQADATA
LOOP1   S XQJ=$O(XQA(" ")) I XQJ'="" K:"G.g."'[$E(XQJ_",,",1,2) XQA(XQJ) D:$D(XQA(XQJ)) GROUP^XQALSET1 G LOOP1
LOOP2   ; RE-ENTRY FOR FORWARDING IF ALL RECIPIENTS ARE UNDELIVERABLE
        N:'$D(XQAUSER) XQAUSER M XQALIST=XQA F I=0:0 S I=$O(XQALIST(I)) Q:I'>0  S XQALIST(I,XQALTYPE)="" I '$D(XQAUSER) S XQAUSER=I ; SAVE ORIGINAL LIST OF RECIPIENTS AND REASON
        ; The following section of code was added to provide a generalized way to handle surrogates
        F XQJ=0:0 S XQJ=$O(XQA(XQJ)) Q:XQJ=""  D
        . N X S X=$$ACTVSURO^XQALSURO(XQJ) I X>0 D  ; Modified to get final surrogate if a sequence of them
        . . S XQA(X)="" K XQA(XQJ) ; Add Surrogate to XQA array, delete XQJ entry
        . . S XQALIST(X,$O(XQALIST(XQJ,""))_"-SURROGATE")="" ; Add Surrogate to XQALIST with same type as original
        . . S XQALIST(X,"z AS_SURO",XQJ)="" ; Mark user as in list as a surrogate, subscript for surrogate to
        . . S XQALIST(XQJ,"z TO_SURO",X)=""
        . . Q
        . Q
        ;
        S XQJ=0
LOOP    ;
        S XQJ=$O(XQA(XQJ)) G:XQJ="" WRAP
        ;
        I '(+$$ACTIVE^XUSER(XQJ)) K XQA(XQJ) N XX S XX=$O(XQALIST(XQJ,"")) K XQALIST(XQJ,XX) S XQALIST(XQJ,XX_"-UNDELIVERABLE")="" G LOOP ;Don't send to users that can't sign-on
        ;
        I '$D(^XTV(8992,XQJ,0)) D  I '$D(^XTV(8992,XQJ,0)) S ^(0)=XQJ
        . N FDA,IENS
        . F  D  Q:'$D(DIERR)  Q:'$D(^TMP("DIERR",$J,"E",110))&'$D(^TMP("DIERR",$J,"E",111))
        . . K DIERR,^TMP("DIERR",$J)
        . . S FDA=$NA(^TMP($J,"XQALSET")) K @FDA S @FDA@(8992,"+1,",.01)=XQJ
        . . S IENS(1)=XQJ
        . . D UPDATE^DIE("S",FDA,"IENS")
        . . Q
        . Q
        L +^XTV(8992,XQJ):10 S XQXI=XQX S:'$D(^XTV(8992,XQJ,"XQA",0)) ^(0)="^8992.01DA^"
REP     I $D(^XTV(8992,XQJ,"XQA",XQXI,0)) S XQXI=XQXI+.00000001 G REP
        S ^XTV(8992,XQJ,"XQA",XQXI,0)=XQALIN S:$D(XQALIN1) ^(1)=XQALIN1 S:$D(XQAGUID)!$D(XQADFN) ^(3)=$G(XQAGUID)_U_$G(XQADFN) S:$D(XQARESET) ^(2)=XQAUSER_U_XQX_U_$G(XQACOMNT) S ^(0)=$P(^XTV(8992,XQJ,"XQA",0),U,1,2)_U_XQXI_U_($P(^(0),U,4)+1)
        I $D(XQATEXT) S:($D(XQATEXT)#2) XQATEXT(.1)=XQATEXT D WP^DIE(8992.01,(XQXI_","_XQJ_","),4,"","XQATEXT") ; P443 PUT DATA IN XQATEXT INTO ARRAY
        L -^XTV(8992,XQJ)
        K XQA(XQJ) S:XQAID'="" ^XTV(8992,"AXQA",XQAID,XQJ,XQXI)="",^XTV(8992,"AXQAN",XQA1,XQJ,XQXI)=""
        S XQNRECIP=XQNRECIP+1
        G LOOP
        ;
WRAP    ;
        M XQALIST1=XQALIST
        I XQNRECIP=0,'$$SNDNACTV(XQAID) S RETVAL=0,XQALERR="NO ACTIVE RECIPIENTS - OLDER TIU ALERTS"
        E  I XQNRECIP=0 D  I $D(XQA) S XQACOMNT=$E("None of recipients were active users. "_$G(XQACOMNT),1,245),XQNRECIP=1,XQARESET=1 K XQALIST G LOOP2 ; SET NUMBER OF RECIPIENTS TO 1 SO WE WON'T COME HERE AGAIN
        . N XQAA,XQJ F XQI=0:0 S XQI=$O(XQALIST(XQI)) Q:XQI'>0  D GETBKUP^XQALDEL(.XQAA,XQI) S XQALTYPE="BACKUP REVIEWER" F XQJ=0:0 S XQJ=$O(XQAA(XQJ)) Q:XQJ'>0  S XQA(XQAA(XQJ))=""
        . I $D(XQA) D CHEKACTV^XQALSET1(.XQA)
        . I '$D(XQA) S XQJ="G.XQAL UNPROCESSED ALERTS" D GROUP^XQALSET1 S XQALTYPE="UNPROCESSED ALERTS MAIL GROUP" ;D GETMLGRP(.XQA,XQI) ; COULDN'T FIND ANY BACKUP, GET A MAILGROUP AND MEMBERS TO SEND IT TO
        . I '$D(XQA) S XQJ="G.PATCHES" D GROUP^XQALSET1 S XQALTYPE="LAST HOPE" ; Last gasp, send it to G.PATCHES
        . I '$D(XQA) S XQJ="G.PATCH" D GROUP^XQALSET1 S XQALTYPE="LAST HOPE" ; Last gasp, send it to G.PATCH
        . I '$D(XQA) S RETVAL=0,XQALERR="Could not find any active user to send it to" ; Should not get here, this is only if all backups and mail groups tried don't have any active users
        . Q
        ; END OF JLI 030129 INSERTION P285
        ; moved recording of users in Alert Tracking file to here to include all of them  030220
        ; modified code to use FM calls instead of direct global references
        I RETVAL,$G(XQADA)'>0,XQAID'="" D SETTRACK ; moved to here to avoid tracking entries with no users
        ;
        I RETVAL,$G(XQADA)>0 L +^XTV(8992.1,XQADA):10 D  L -^XTV(8992.1,XQADA) ; 030131
        . F XQJ=0:0 S XQJ=$O(XQALIST1(XQJ)) Q:XQJ'>0  D
        . . N NCOUNT,SUBSCRPT,SUBSCRPN,KCNT,IENVAL
        . . S IENVAL=XQADA_",",KCNT=$$FIND1^DIC(8992.11,","_IENVAL,"Q",XQJ)
        . . S FDA=$NA(^TMP($J,"XQALSET")) K @FDA I KCNT=0 S @FDA@(8992.11,"+1,"_IENVAL,.01)=XQJ,KCNT="+1"
        . . S IENVAL=","_KCNT_","_IENVAL,NCOUNT=1 S SUBSCRPT="" F  S SUBSCRPT=$O(XQALIST1(XQJ,SUBSCRPT)) Q:SUBSCRPT=""  I $E(SUBSCRPT,1)'="z" D
        . . . S SUBSCRPN=$$FIND1^DIC(8992.2,"","X",SUBSCRPT) I SUBSCRPN'>0 D
        . . . . N FDA1,IENROOT S FDA1=$NA(^TMP($J,"XQALSET1")) K @FDA1 S @FDA1@(8992.2,"+1,",.01)=SUBSCRPT D UPDATE^DIE("",FDA1,"IENROOT") S SUBSCRPN=$G(IENROOT(1))
        . . . . Q
        . . . S NCOUNT=NCOUNT+1,@FDA@(8992.111,"+"_NCOUNT_IENVAL,.01)=SUBSCRPN,@FDA@(8992.111,"+"_NCOUNT_IENVAL,.04)=XQADATIM
        . . . Q
        . . I $D(XQALIST1(XQJ,"z TO_SURO")) S @FDA@(8992.111,"+"_NCOUNT_IENVAL,.02)=$O(XQALIST1(XQJ,"z TO_SURO",0))
        . . I $D(XQALIST1(XQJ,"z AS_SURO")) D
        . . . S @FDA@(8992.111,"+"_NCOUNT_IENVAL,.03)="Y"
        . . . N XQK S NCOUNT=NCOUNT+1 F XQK=0:0 S XQK=$O(XQALIST1(XQJ,"z AS_SURO",XQK)) Q:XQK'>0  S @FDA@(8992.113,"+"_NCOUNT_IENVAL,.01)=XQK,@FDA@(8992.113,"+"_NCOUNT_IENVAL,.02)=XQADATIM
        . . . Q
        . . S SUBSCRPT=$O(XQALIST1(XQJ,"")) I SUBSCRPT'["INITIAL" S SUBSCRPT=$P(SUBSCRPT,"-") D  ; FORWARDING
        . . . S SUBSCRPN=$$FIND1^DIC(8992.2,"","X",SUBSCRPT) I SUBSCRPN'>0 D
        . . . . N FDA1,IENROOT S FDA1=$NA(^TMP($J,"XQALSET1")) K @FDA1 S @FDA1@(8992.2,"+1,",.01)=SUBSCRPT D UPDATE^DIE("",FDA1,"IENROOT") S SUBSCRPN=$G(IENROOT(1))
        . . . . Q
        . . . S NCOUNT=NCOUNT+1,@FDA@(8992.112,"+"_NCOUNT_IENVAL,.01)=XQADATIM,@FDA@(8992.112,"+"_NCOUNT_IENVAL,.02)=SUBSCRPN I $G(XQACOMNT)'="" S @FDA@(8992.112,"+"_NCOUNT_IENVAL,1.01)=XQACOMNT
        . . . I $G(XQAUSER)>0 S @FDA@(8992.112,"+"_NCOUNT_IENVAL,.03)=XQAUSER
        . . . Q
        . . N IENSTR D UPDATE^DIE("",FDA,"IENSTR")
        . . Q
        . Q
        ;
        I RETVAL S RETVAL=RETVAL_U_$G(XQADA)_U_XQAID
        K:XQAID'="" ^XTV(8992,"AXQA",XQAID,0,0)
        K ^TMP("XQAGROUP",$J) ; P443 - clear global used to track processing of groups
        K XQA,XQALIN,XQALIN1,XQAMSG,XQAID,XQAFLG,XQAOPT,XQAOPT1,XQAROU,XQADATA,XQI,XQX,XQJ,XQK,XQA1,XQACTMSG,XQJ,XQXI,XQAARCH,XQACNDEL,XQAREVUE,XQASUPV,XQASURO,XQATEXT
        Q RETVAL
        ;
SNDNACTV(XQAID) ; Determine if we go ahead and send alerts addressed only to inactive users to backup reviewers
        N XVAL
        I $E(XQAID,1,3)="TIU" S XVAL=$E($P(XQAID,";"),4,99),XVAL=$$GET1^DIQ(8925,XVAL_",",1201,"I") I XVAL>0,$$FMDIFF^XLFDT(DT,XVAL)>60 Q 0
        Q 1
        ;
SETIEN(XQA1,XQI)        ; determine unique XQAID value for alert
        N XQAID
        S:$G(XQA1)="" XQA1="NO-ID" F  S XQAID=XQA1_";"_DUZ_";"_XQI L +^XTV(8992,"AXQA",XQAID):10 D  L -^XTV(8992,"AXQA",XQAID) Q:XQI=""  S XQI=XQI+.00000001
        . I $D(^XTV(8992,"AXQA",XQAID)) Q
        . S ^XTV(8992,"AXQA",XQAID,0,0)="",XQI=""
        . Q
        Q XQAID
        ;
SETTRACK        ; Setup entry in Alert Tracking file
        ; Note: if there are error messages or we can't create an entry for some reason, it simply returns and continues
        N FDA,IENS,XQA2,DIERR
        S XQADA=0
        S XQA2=XQA1 I XQA2[",",$P(XQA2,",",3)'="" S XQA2=$P(XQA2,",")_","_$P(XQA2,",",3)
        F  D  Q:'$D(DIERR)  Q:'$D(^TMP("DIERR",$J,"E",111))
        . K DIERR,^TMP("DIERR",$J)
        . S FDA=$NA(^TMP($J,"XQALSET")) K @FDA
        . S @FDA@(8992.1,"+1,",.01)=XQAID D UPDATE^DIE("",FDA,"IENS")
        . K @FDA
        . Q
        I $D(DIERR) Q  ;S XQDIERR1=DIERR M XQDIERR=^TMP("DIERR",$J) Q
        Q:IENS(1)'>0  S (DA,XQADA)=IENS(1)
        S IENS=IENS(1)_",",@FDA@(8992.1,IENS,.02)=XQX,^(.03)=XQA2,^(.05)=DUZ,^(1.01)=XQAMSG
        I $D(XQAARCH) S X=$$FMADD^XLFDT(DT,XQAARCH) I X>DT S @FDA@(8992.1,IENS,.08)=X
        I $P(XQA1,",")="OR",$P(XQA1,",",2)>0 S @FDA@(8992.1,IENS,.04)=$P(XQA1,",",2)
        I $D(ZTQUEUED) S @FDA@(8992.1,IENS,.06)=1
        I $D(XQAOPT)#2 S @FDA@(8992.1,IENS,1.02)=XQAOPT
        I $D(XQAROU)#2 N XQAXX S XQAXX=$S(XQAROU[U:XQAROU,1:U_XQAROU) I $P(XQAXX,U,2)'="" S:$P(XQAXX,U)'="" @FDA@(8992.1,IENS,1.03)=$P(XQAXX,U) S @FDA@(8992.1,IENS,1.04)=$P(XQAXX,U,2)
        I $D(XQACTMSG) S @FDA@(8992.1,IENS,1.05)=XQACTMSG
        I $D(XQADATA) S @FDA@(8992.1,IENS,2)=XQADATA
        I $D(XQAGUID) S @FDA@(8992.1,IENS,3.01)=XQAGUID
        I $D(XQADFN) S @FDA@(8992.1,IENS,.04)=XQADFN
        D FILE^DIE("KS",FDA)
        I $D(XQATEXT) D WP^DIE(8992.1,IENS,4,"","XQATEXT")
        Q
        ;
CHEKUSER(XQAUSER)       ; .SR Returns 0 if no valid user or surrogate, otherwise returns IEN of user or surrogate
        Q $$CHEKUSER^XQALSET1(XQAUSER)
        ;
