MAGJLS2 ;WIRMFO/JHC Rad. Workstation RPC calls ; 29 Jul 2003  9:58 AM
        ;;3.0;IMAGING;**22,18,76**;Jun 22, 2007;Build 19
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;; +---------------------------------------------------------------+
        ;; | Property of the US Government.                                |
        ;; | No permission to copy or redistribute this software is given. |
        ;; | Use of unreleased versions of this software requires the user |
        ;; | to execute a written test agreement with the VistA Imaging    |
        ;; | Development Office of the Department of Veterans Affairs,     |
        ;; | telephone (301) 734-0100.                                     |
        ;; |                                                               |
        ;; | The Food and Drug Administration classifies this software as  |
        ;; | a medical device.  As such, it may not be changed in any way. |
        ;; | Modifications to this software may result in an adulterated   |
        ;; | medical device under 21CFR820, the use of which is considered |
        ;; | to be a violation of US Federal Statutes.                     |
        ;; +---------------------------------------------------------------+
        ;;
        Q
        ;  ACTIVE -- list exams (Unread, Recent, &/or Pending) for input Imaging Type(s)
        ;    RPC Call: MAGJ RADACTIVEEXAMS
        ;  BKGND -- EP for Bkgnd Compile of UNREAD list
        ;  BKGND2 -- EP for Bkgnd Compile of RECENT list
        Q
BKGERR  S ERRCOUNT=$G(ERRCOUNT)+1 H 3 I ERRCOUNT>2 K ZTQUEUED G ^XUSCLEAN ; prevent bkgnd loop
ERR1    I $G(LSTNAM)]"" L -^XTMP("MAGJ2","BKGND",LSTNAM,"COMPILE")
        L -^XTMP("MAGJ2","BKGND2","RUN")
ERR     N ERR S ERR=$$EC^%ZOSV S ^TMP($J,"RET",0)="0^4~"_ERR
        S MAGGRY=$NA(^TMP($J,"RET"))
        D @^%ZOSF("ERRTN")
        Q:$Q 1  Q
ACTIVE(MAGGRY,DATA)     ; EP--get Active (Unread/Recent/Pend) Exam Lists
        ; MAGGRY holds $NA ref to ^TMP where return msg is assembled
        ;   all refs to MAGGRY use SS indirection
        ; If not use bkgnd, compile in foregnd
        ;
        N BKGND,COMPFAIL,MAGLST,LSTPARAM,LSTREQ,LSTID,LSTNUM,LSTNAM,NEWLIST
        N $ETRAP,$ESTACK S $ETRAP="D ERR^MAGJLS2"
        S X=$P(DATA,U) D PARAMS^MAGJLS2B(X)
        I 'LSTID S MAGGRY=$NA(^TMP($J,"RET")),@MAGGRY@(0)="0^4~Problem with Exams List Compile--"_DATA_"." Q
        I MAGJOB("P32"),+$G(MAGJOB("P32STOP")) S MAGGRY=$NA(^TMP($J,"RET")),@MAGGRY@(0)="0^4~VistARad Patch 32 is no longer supported.  Contact Imaging support for the current version of the VistARad client software." Q  ; <*>
        I BKGND,LSTREQ="U" D BKREQU Q  ; UNREAD in bkgnd
        I BKGND,LSTREQ="R" D BKREQR Q  ; RECENT in bkgnd
        I BKGND,LSTREQ="A" D BKREQA(DATA) Q  ; ALL Active Exams
        D FOREGND  ; other list types, or bkgnd compile not enabled
ACTIVEZ Q
        ;
FOREGND ; compile in foregnd
        I LSTREQ="H" G HISTORY
        D BLDACTV^MAGJLS3(.MAGLST,LSTPARAM)
        D LSTOUT^MAGJLS2B(.MAGGRY,LSTID,MAGLST) K @MAGLST
        Q
        ;
HISTORY ; compile History list
        D BLDACTV^MAGJLS3(.MAGLST,LSTPARAM)
        D LSTOUT^MAGJLS2B(.MAGGRY,LSTID,MAGLST)
        ; copy data from above compile into History file
        N EXID,HISTIEN,IEN,REC1,REC2,CDAT,TMP,PC
        I +$G(@MAGLST@(0,1)) D
        . S IEN="" F  S IEN=$O(@MAGLST@(IEN)) Q:(IEN="")  S REC1=^(IEN,1),REC2=^(2) D
        . . I IEN=0 S ^XTMP("MAGJ2","HISTORY",DUZ,DUZ(2),IEN,1)=REC1,^(2)=REC2 Q  ; header string
        . . S HISTIEN=+$P(REC2,"|",3) Q:'HISTIEN  S EXID=$P(REC2,"|",2)
        . . S X=$G(^XTMP("MAGJ2","HISTORY",DUZ,DUZ(2),0,"ADD",HISTIEN))
        . . I X]"" D
        . . . I EXID'=$P(X,"|",2) Q
        . . . ; copy Client data into list column fields 12-15 in node 2
        . . . S CDAT=$P(REC2,"|",3),TMP=$P(REC2,"|")
        . . . F I=1:1:4 S PC=11+I,$P(TMP,U,PC)=$P(CDAT,U,I)
        . . . S TMP=TMP_U ; pad extra nil piece
        . . . S $P(REC2,"|")=TMP,$P(REC2,"|",3)=HISTIEN ; preserve IEN in PP3
        . . . S ^XTMP("MAGJ2","HISTORY",DUZ,DUZ(2),HISTIEN,1)=REC1,^(2)=REC2
        . . . K ^XTMP("MAGJ2","HISTORY",DUZ,DUZ(2),0,"ADD",HISTIEN) ; Kill input node
        K @MAGLST
        Q
        ;
BKREQU  ; UNREAD exams from bkgnd
        L +^XTMP("MAGJ2","BKGND2","RUN"):0
        E  D BKOUT("UNREAD") Q  ; bkgnd process IS running
        ; NOT running, so start it!
        ; 2nd errtrap is to deal with locks if error occurs
        N $ETRAP,$ESTACK S $ETRAP="D ERR1^MAGJLS2"
        N ZTDESC,ZTDTH,ZTIO,ZTRTN
        S ZTRTN="BKGND^MAGJLS2",ZTDESC="IMAGING VistaRad UNREAD List Compile"
        S ZTDTH=$H,ZTIO="" D ^%ZTLOAD
        S X=$$CURLIST(LSTNAM),LSTAGE=$P(X,U,2),LSTNUM=+X
        I LSTAGE>(DELTA+300)  S BKGPROC=2 D  ; Foregnd compile if need fresh list
        . D LSTCOMP(.COMPFAIL) K BKGPROC S X=$$CURLIST(LSTNAM),LSTAGE=$P(X,U,2),LSTNUM=+X
        L -^XTMP("MAGJ2","BKGND2","RUN")
        I +$G(COMPFAIL) S MAGGRY=$NA(^TMP($J,"RET")),@MAGGRY@(0)="0^4~Unable to Compile Unread Exams list"
        E  D LSTOUT^MAGJLS2B(.MAGGRY,LSTID,$NA(^XTMP("MAGJ2",LSTNAM,LSTNUM)),LSTAGE)
        K LSTAGE
        Q
        ;
BKREQR  ; Recent Exams from bkgnd
        D BKOUT("RECENT")
        Q
        ;
BKOUT(LSTNM)    ; output list from the bkgnd process
        S X=$$CURLIST(LSTNAM),LSTAGE=$P(X,U,2),LSTNUM=+X
        I 'LSTNUM S MAGGRY=$NA(^TMP($J,"RET")),@MAGGRY@(0)="0^4~Problem with "_LSTNM_" List Compile program (age="_LSTAGE_" for "_LSTNAM_")"_$S(LSTNAM["9992":"--May need to Schedule RECENT List Compile in TaskMan.",1:"")
        E  D LSTOUT^MAGJLS2B(.MAGGRY,LSTID,$NA(^XTMP("MAGJ2",LSTNAM,LSTNUM)),LSTAGE)
        K LSTAGE
        Q
        ;
BKREQA(DATA)    ; ALL Active from Bkgnd
        ; Copy compiles of Unread & Recent to a scratch global, & call lstout
        N ALLGO,CNT,GETLST,ICNT,REPLY
        S ALLGO=1,CNT=0
        F GETLST=9991,9992 D  I 'ALLGO S REPLY="Component List "_GETLST_ALLGO Q
        . D PARAMS^MAGJLS2B(GETLST) I 'LSTID S ALLGO=" not properly defined."  Q
        . S X=$$CURLIST(LSTNAM),LSTAGE=$P(X,U,2),LSTNUM=+X
        . I 'LSTNUM S ALLGO=" needs more time to compile." Q
        . F ICNT=1:1:$G(^XTMP("MAGJ2",LSTNAM,LSTNUM,0,1)) S X=^XTMP("MAGJ2",LSTNAM,LSTNUM,ICNT,1),Y=^(2),CNT=CNT+1,^TMP($J,"MAGJ",CNT,1)=X,^(2)=Y
        I ALLGO D
        . S ^TMP($J,"MAGJ",0,1)=CNT_U_"1~ALL Active Exams",^(2)=""
        . D PARAMS^MAGJLS2B($P(DATA,U))
        . D LSTOUT^MAGJLS2B(.MAGGRY,LSTID,$NA(^TMP($J,"MAGJ")))
        I 'ALLGO S MAGGRY=$NA(^TMP($J,"RET")),@MAGGRY@(0)="0^4~Problem with ALL Exams List Compile "_DATA_". "_REPLY
        K LSTAGE
        Q
        ;
BKGND   ; EP for background compile of UNREAD exams
        L +^XTMP("MAGJ2","BKGND2","RUN"):600 ; allow fgnd job to finish compile
        E  Q  ; I must already be running!
        N BKGLSTID S BKGLSTID=9991 G BKGNDA
        Q
BKGND2  ; EP--bkgnd compile RECENT
        N BKGLSTID S BKGLSTID=9992 G BKGNDA
        Q
BKGNDA  S BKGPROC=1,U="^"
        N $ETRAP,$ESTACK S $ETRAP="D BKGERR^MAGJLS2"
        D MAGJOBNC^MAGJUTL3
        D PARAMS^MAGJLS2B(BKGLSTID)
BKLOOP  ; Loop & compile "master" UNREAD List only
        S BKLOOP=$G(BKLOOP)+1
        I BKLOOP>1 D PARAMS^MAGJLS2B(9991)
        I 'LSTID D  G BKGNDZ
        . S X="0^4~Problem with BACKGROUND Compile of Exams List"
        . F I=1,2 K ^XTMP("MAGJ2",LSTNAM,I)
        . F I=1,2 S ^XTMP("MAGJ2",LSTNAM,I,0,1)=X,^(2)=""  ; get msg to WS user
        I 'BKGND G BKGNDZ  ; need this to cover for excessive time to compile
        S X=$$CURLIST(LSTNAM),LSTAGE=$P(X,U,2),LSTNUM=+X
        I LSTREQ="U",(LSTAGE<DELTA) D  I 'BKGND G BKGNDZ ;bkgnd compile off?
        . N ITEST,TEST,MORE
        . S TEST=(DELTA-LSTAGE)\5,MORE=(DELTA-LSTAGE)-(5*TEST)
        . ; while waiting, periodic chk for stop conditions
        . F ITEST=1:1:TEST H 5 D  Q:'BKGND
        .. S BKGND=+$P($G(^MAG(2006.69,1,0)),U,8) Q:'BKGND
        .. I $D(ZTQUEUED),$$S^%ZTLOAD S BKGND=0 ; Exit bkgnd via TaskMan Req
        . H MORE
        D LSTCOMP()
        I LSTREQ="R" D NEWINT
        I LSTREQ="U" D UPDR^MAGJLS2B G BKLOOP  ;UNREAD loops; RECENT uses TaskMan
BKGNDZ  I LSTREQ="U" L -^XTMP("MAGJ2","BKGND2","RUN")
        N ZTREQ S ZTREQ="@"  ;  clean up task entry
        K BKLOOP,DELTA,LSTAGE
        Q  ; Exit bkgnd
        ;
NEWINT  ; Add exams newly Interp since Recent Compile started to Recent List
        ; 1st, get list of candidates:
        N INDX L +^XTMP("MAGJ2","RECENT"):15
        E  Q
        S INDX=+$G(^TMP($J,"NEWINT")) ; counter when Recent Compile started
        I INDX S INDX=INDX-1 F  S INDX=$O(^XTMP("MAGJ2","RECENT",INDX)) Q:'INDX  S X=^(INDX) I X S ^TMP($J,"NEWINT",0,INDX)=X
        K ^XTMP("MAGJ2","RECENT") S ^("RECENT",0)=0
        L -^XTMP("MAGJ2","RECENT")
        ;if not in Recent Compile, add to index
        S INDX=""
        F  S INDX=$O(^TMP($J,"NEWINT",0,INDX)) Q:'INDX  S X=^(INDX) D
        . I $D(^TMP($J,"NEWINT",$P(X,U,1,3))) Q  ; already there
        . L +^XTMP("MAGJ2","RECENT"):15
        . E  Q
        . S I=+$G(^XTMP("MAGJ2","RECENT",0))+1,$P(^(0),U)=I,^(I)=X ;add
        . L -^XTMP("MAGJ2","RECENT")
        K ^TMP($J,"NEWINT")
        Q
        ;
LSTCOMP(COMPFAIL)       ; Compile new list; subrtn used by Active and Bkgnd tags
        S COMPFAIL=0 ; Return T/F for "Executed a List Compile?"
        L +^XTMP("MAGJ2","BKGND",LSTNAM,"COMPILE"):60
        E  S COMPFAIL=1 G LSTCOMZ
        S NEWLIST=$S(LSTNUM=1:2,1:1) ; toggle node to use
        N TS,COMTIM
        S TS="" F I=2,0 S TS=TS_$S(TS="":"",1:U)_$$HTFM^XLFDT($H+I,0)
        S ^XTMP("MAGJ2",0)=TS_U_"VistaRad List Compile"
        S ^XTMP("MAGJ2",0,LSTNAM,NEWLIST)=$H
        D BLDACTV^MAGJLS3(.MAGGRY,LSTPARAM,$NA(^XTMP("MAGJ2",LSTNAM,NEWLIST)))
        S COMTIM=$$DELTA($P(^XTMP("MAGJ2",0,LSTNAM,NEWLIST),U))
        S ^XTMP("MAGJ2",LSTNAM,NEWLIST)=$H_U_$J_U_COMTIM
        S ^XTMP("MAGJ2","BKGND",LSTNAM,0)=NEWLIST_U_$H
        I $G(^XTMP("MAGJ2",0,"TIME")) D
        . S T1=$P($H,",",2)/3600,T2=$E(100+(T1\1),2,3),T=T2_":"_$E(100+(T1-T2*60),2,3)
        . S ^XTMP("MAGJ2",0,"TIME",LSTNAM,+$H,T)=COMTIM K T,T1,T2
LSTCOMZ L -^XTMP("MAGJ2","BKGND",LSTNAM,"COMPILE")
        Q  ;
CURLIST(LSTNAM,WAIT)    ; return cur. list & age in secs
        S WAIT=+$G(WAIT)
        N X,RET,AGE,TRY,START,EXTRATIM
        S TRY=0,START=$H,EXTRATIM=$S(LSTREQ="U":600,1:1800)
        S X=$G(^XTMP("MAGJ2","BKGND",LSTNAM,0))  ; Cur # ^ $H created
        I X="" S RET="^86400" G CURLISZ  ; this lstnam not yet compiled!
        S AGE=$$DELTA($P(X,U,2)),RET=$P(X,U)_U_AGE
        I AGE>(DELTA+EXTRATIM) S $P(RET,U)=""  ; Something's wrong w/ compile; force error message
CURLISZ Q RET
        ;
DELTA(X,Y)      ; calc # secs bet 2 $h values; dflt 2nd value = now
        ; useful limit is one day
        I $G(Y)="" S Y=$H
        I +Y=+X
        E  D
        . I Y-X=1 S $P(Y,",",2)=86400+$P(Y,",",2)  ; midnight boundary
        . E  S $P(X,",",2)=0,$P(Y,",",2)=86400  ; > one day
        Q ($P(Y,",",2)-$P(X,",",2))
        ;
END     ;
