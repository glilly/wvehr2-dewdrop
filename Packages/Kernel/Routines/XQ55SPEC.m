XQ55SPEC        ; SEA/JLI - SEARCH FOR USERS WITH ACCESS TO 'OR CPRS GUI CHART' ;1/29/08  15:02
        ;;8.0;KERNEL;**483**;Jul 10, 1995;Build 15
        ;;Per VHA Directive 2004-038, this routine should not be modified
        ;
        ; ROUTINE XQ55 modified to be run from a server option to identify all
        ; users with access to the OR CPRS GUI CHART option
        ;
INIT    ;
        N XQDT,XQERR,XQISO,XQCOMMNT,XQQUIET,XQLINES,XQOUTPUT,XQPA,XQTOTUSR,XQSELUSR
        N XQMAIL,XQIRM
        N DIFROM ; THIS, IF PRESENT, PREVENTS MAIL FROM GOING OUT DURING INSTALLATION
        S XQMAIL("VAITFOExecLeads@va.gov")=""
        S XQDSH="-------------------------------------------------------------------------------"
        D ^XQDATE S XQDT=%Y S XQERR="",XQCOMMNT="",XQQUIET=1,XQLINES=0,XQOUTPUT=$NA(^TMP("XQ55SPEC",$J))
        S XQTOTUSR=0,XQSELUSR=0
        S XQISO=+$$GET1^DIQ(8989.3,"1,",321.01,"I") D
        . I +XQISO'>0 S XQERR="NO ENTRY FOR SITE ISO IN FILE 8989.3" Q
        . I '$$ACTIVE^XUSER(+XQISO) S XQERR="SITE ISO ENTRY IS NOT AN ACTIVE USER" S XQISO=0
        . Q
        S XQIRM=+$$GET1^DIQ(8989.3,"1,",321.02,"I") D
        . I +XQIRM'>0,XQERR'="" S XQERR=XQERR_" - NO ENTRY FOR IRM CHIEF IN FILE 8989.3" Q
        . I +XQIRM'>0 S XQERR=XQERR_"NO ENTRY FOR IRM CHIEF IN FILE 8989.3"
        . I '$$ACTIVE^XUSER(+XQIRM) S XQERR=XQERR_$S(XQERR'="":" - ",1:"")_"SITE IRM CHIEF ENTRY IS NOT AN ACTIVE USER" S XQIRM=0 I +XQISO'>0 Q
        . S:+XQISO'>0 XQCOMMNT=XQERR_" - SENDING TO SITE IRM CHIEF INSTEAD" S XQERR=""
        . Q
OPT     S Y=$$FIND1^DIC(19,"","","OR CPRS GUI CHART") S XQOPT=+Y I XQOPT'>0 S XQERR=XQERR_" - COULD NOT FIND 'OR CPRS GUI CHART' OPTION IN OPTION FILE" G NOOPT
MPAT    S XQMP=1 ; FORCE listing of paths
        K ^TMP($J),XQR,XQP,@XQOUTPUT
        S K=^DIC(19,XQOPT,0),XQHDR="Access to '"_$P(K,U,2)_"'  ["_$P(K,U,1)_"]",XQSCD=0,XQCOM=0 ;080115
LOOP1   S K=XQOPT,(L,X(0))=0,XQD=K K XQR,XQA,XQK,XQRV S XQR(K)="" I '$L($P(^DIC(19,K,0),U,3)) D TREE1
        G LOOP2
        Q
TREE    S X(L)=$O(^DIC(19,"AD",XQD,X(L))) Q:X(L)'>0  S K=X(L) G:$D(XQR(K)) TREE S XQR(K)=""
TREE1   ;
        S Y(0)=^DIC(19,K,0) G:$L($P(Y(0),U,3)) TREE S:$L($P(Y(0),U,6)) XQK(L)=$P(Y(0),U,6) S XQA(L)=K I $P(Y(0),U,16) S XQRV(L)=^DIC(19,K,3)
        D SETGLO S L=L+1,X(L)=0,(XQD,XQD(L))=K D TREE
        Q:L=1  K XQR(XQD(L)) S L=L-1 K XQA(L),XQK(L),XQRV(L) S XQD=XQD(L) G TREE
        Q
SETGLO  ;
        S XQK="" F I=L:-1:0 I $D(XQK(I)),$L(XQK(I)) S XQK=XQK_XQK(I)_","
        S XQRV="" F I=L:-1:0 I $D(XQRV(I)),$L(XQRV(I)) S XQRV=XQRV_XQRV(I)_","
        S XQA="" F I=L:-1:1 I $D(XQA(I)) S XQA=XQA_XQA(I)_","
        S XQA=XQA_XQOPT,J=0 S:$D(^TMP($J,K,0)) J=^(0) S J=J+1,^(0)=J,^TMP($J,K,J)=XQK_U_XQA_U_XQRV
        Q
LOOP2   ;
        S XQPA(0)=0,XQP=0 F  S XQP=$O(^TMP($J,XQP)) Q:XQP=""  S XQN=^TMP($J,XQP,0) S XQPS="AP" D USERS S XQPS="AD" D USERS
        D USERS1 ; 080115 - add in options from the common menu
        F I=0:0 S I=$O(^VA(200,I)) Q:I'>0  I $$ACTIVE^XUSER(I) S XQTOTUSR=XQTOTUSR+1
        G LOOP3
USERS   ;
        S XQU=0 F  S XQU=$O(^VA(200,XQPS,XQP,XQU)) Q:XQU'>0  I $D(^VA(200,XQU,.1)),+$$ACTIVE^XUSER(XQU) D EACHU
        Q
        ;
USERS1  ; 080115 code added to handle options on the COMMON (XUCOMMAND) menu
        N XUCOMMON
        S XUCOMMON=$O(^DIC(19,"B","XUCOMMAND",0))
        S XQP=0 F  S XQP=$O(^TMP($J,XQP)) Q:XQP=""  S XQN=^TMP($J,XQP,0) F J=1:1:XQN Q:'$D(^TMP($J,XQP,J))  I $P($P(^TMP($J,XQP,J),U,2),",")=XUCOMMON D
        . S XQU=0,XQPS="(C)" F  S XQU=$O(^VA(200,XQU)) Q:XQU'>0  I $D(^VA(200,XQU,.1)),+$$ACTIVE^XUSER(XQU),$$KEYCHECK() S II=1 D SETU
        Q
        ;
EACHU   ;
        S II=1
        F J=1:1:XQN Q:'$D(^TMP($J,XQP,J))  I $$KEYCHECK() D SETU ; 080115
        Q
        ;
KEYCHECK()      ; 080115 extracted common code
        ; returns 1 if user has access to the option, 0 if the user does not have access
        S XQK=$P(^TMP($J,XQP,J),U,1),XX=$L(XQK,",")-1,XQGO=1
        I XX F X=1:1:XX S Y=$P(XQK,",",X) I Y'="",('$D(^XUSEC(Y,XQU))) S XQGO=0
        S XQK=$P(^TMP($J,XQP,J),U,3),XX=$L(XQK,",")-1
        I XX F X=1:1:XX S Y=$P(XQK,",",X) I Y'="",($D(^XUSEC(Y,XQU))) S XQGO=0
        Q XQGO
        ;
SETU    ;
        S XQPA=$P(^TMP($J,XQP,J),U,2)
        I '$D(XQPA(XQPA)) S I=XQPA(0)+1,XQPA(0)=I,XQPA(0,I)=XQPA,XQPA(XQPA)=I
        S XQPA(0,XQPA(XQPA),"CNT")=$G(XQPA(0,XQPA(XQPA),"CNT"))+1
        S XQPA=XQPA(XQPA) S:XQPS="AD" XQPA=XQPA_"(S)",XQSCD=1 S:XQPS="(C)" XQPA=XQPA_"(C)",XQCOM=1 ; 080115
        S I=$P(^VA(200,XQU,0),U,1)_U_XQU S:$D(^TMP($J,0,I)) II=$O(^TMP($J,0,I,"A"),-1)+1 S ^TMP($J,0,I,II)=XQPA
        Q
LOOP3   ;
        I $O(^TMP($J,0,0))="" D  G MUS
        . N XMY M XMY=XQMAIL S:+XQISO>0 XMY(+XQISO)="" S:+XQIRM>0 XMY(+XQIRM)=""
        . S XQLINES=XQLINES+1,@XQOUTPUT@(1)="** NO USERS CAN ACCESS THIS OPTION **"
        . D SEND("SUMMARY",$E(XQOUTPUT,1,$L(XQOUTPUT)-1)_",",.XMY)
        . Q
        ;
        N XQTEXT,XMY
        S XQTEXT=$E(XQOUTPUT,1,$L(XQOUTPUT)-1)_","
        S XQU=0,XQWRITE=0 F  S XQU=$O(^TMP($J,0,XQU)) Q:XQU=""  D PRTU
        D SUMMARY M XMY=XQMAIL S:+XQISO>0 XMY(+XQISO)="" S:+XQIRM>0 XMY(+XQIRM)="" D SEND("SUMMARY",XQTEXT,.XMY)
        D SUMMARY1
        I (+XQISO>0)!(+XQIRM>0) D
        . D HDR
        . S XQU=0,XQWRITE=1 F  S XQU=$O(^TMP($J,0,XQU)) Q:XQU=""  D PRTU
        . K XMY S:+XQISO>0 XMY(+XQISO)="" S:+XQIRM>0 XMY(+XQIRM)="" D SEND("DETAILED",XQTEXT,.XMY)
        I (+XQISO'>0)&(+XQIRM'>0) D NOISO
        G MUS
HDR     ;
        F I=1:1:4 S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES)
        S XQTAB=(76-$L(XQHDR))/2,XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,$$SETLINE("?"_XQTAB,XQHDR))
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES),XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES)
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,$$SETLINE("USER NAME","?27","LAST ON","?37","PRIMARY MENU",$S(XQMP:"?63",1:""),$S(XQMP:"PATH(S)",1:"")))
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,$$SETLINE($E(XQDSH,1,25),"?27",$E(XQDSH,1,8),"?37",$E(XQDSH,1,$S(XQMP:24,1:40)),$S(XQMP:"?63",1:""),$S(XQMP:$E(XQDSH,1,14),1:"")))
        Q
        ;
WRITEOUT(GLOBAL,LINES,DATALINE) ; GLOBAL CLOSED REF TO GLOBAL
        S LINES=LINES+1,@GLOBAL@(LINES)=$G(DATALINE)
        Q LINES
        ;
SETLINE(ARG1,ARG2,ARG3,ARG4,ARG5,ARG6,ARG7,ARG8,ARG9,ARG10)     ;
        N LINE,I,VAR,VAR1
        S LINE=""
        F I=1:1:10 S VAR="ARG"_I X "S VAR1=$G(@VAR)" S:$E(VAR1)="?" VAR1=$$SPACES(LINE,VAR1) S LINE=LINE_VAR1
        Q LINE
        ;
SPACES(LINE,SPACNUM)    ;
        N CURLEN,SPACLINE,NSPACES
        S CURLEN=$L(LINE),SPACLINE=""
        S NSPACES=$E(SPACNUM,2,99)-CURLEN
        S $P(SPACLINE," ",NSPACES)=" "
        Q SPACLINE
        ;
PRTU    ;
        N LINE,J,JJ,K,LINE
        S LINE=""
        S J=$P(XQU,U,2),K="" S:$D(^VA(200,J,1.1)) K=$P(^(1.1),"^") S:$L(K) K=$E(K,4,5)_"/"_$E(K,6,7)_"/"_$E(K,2,3) S LINE=$$SETLINE($E($P(XQU,U,1),1,27),"?27",K)
        I $D(^VA(200,J,201)) S K=+^(201) I K>0,$D(^DIC(19,K,0)) S LINE=$$SETLINE(LINE,"?37",$E($P(^(0),U,1),1,24))
        I XQMP D
        . S LINE=$$SETLINE(LINE,"?63","")
        . S JJ=$O(^TMP($J,0,XQU,"A"),-1)
        . F II=1:1:JJ I $G(^TMP($J,0,XQU,II)) S LINE=LINE_$$SETLINE(^TMP($J,0,XQU,II),$S(II'=JJ:",",1:"")) ; 080115
        . Q
        S:XQWRITE XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,LINE)
        Q
SUMMARY ;
        N I,K,N,LINE
        S I="" F  S I=$O(^TMP($J,0,I)) Q:I=""  S XQSELUSR=XQSELUSR+1
        ;
        I '$$PROD^XUPROD(1) D
        . F I=1:1:4 S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,$$SETLINE("?25","***  TEST ACCOUNT DATA  ***"))
        . F I=1:1:4 S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES)
        . Q
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,$$SETLINE("'OR CPRS GUI CHART' DISTRIBUTION ANALYSIS FOR:  "))
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,"    "_$$STATION())
        F I=1:1:4 S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES)
        I XQERR'="" S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,XQERR),XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES)
        I XQCOMMNT'="" S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,XQCOMMNT),XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES)
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,XQSELUSR_" USERS WITH ACCESS TO 'OR CPRS GUI CHART'")
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,XQTOTUSR_" ACTIVE USERS TOTAL")
        Q
SUMMARY1        ;
        F I=1:1:4 S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES)
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,$$SETLINE($E(XQDSH,1,27),"     MENU PATH(S)     ",$E(XQDSH,1,29)))
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES)
        S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,"PATH  INSTANCES  MENU PATH")
        F I=1:1:XQPA(0) S K=XQPA(0,I) S LINE=$$SETLINE(I,".","?6",XQPA(0,I,"CNT"),"?18") D
        . F N=1:1 S:'$L($P(K,",",N)) XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,LINE) Q:'$L($P(K,",",N))  S:N>1 LINE=$$SETLINE(LINE," ... ") S LINE=$$SETLINE(LINE,$P(^DIC(19,$P(K,",",N),0),U,1))
        . Q
        I XQSCD S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,"(S) - secondary menu pathway")
        I XQCOM S XQLINES=$$WRITEOUT(XQOUTPUT,XQLINES,"(C) - COMMON (XUCOMMAND) menu pathway")
        Q
        ;
SEND(MSGTYPE,XMTEXT,XMY)        ;
        N XMSUB,XMDUZ
        S XMSUB=MSGTYPE_" 'GUI CHART' DATA FOR "_$$STATION()
        I '$$PROD^XUPROD(1) S XMSUB="** TEST ** "_XMSUB
        S XMDUZ=0.5
        D ^XMD
        Q
        ;
NOOPT   ;
        N XMSUB,XMDUZ,XMY,XQMSG,XMTEXT
        S XQMSG(1)=XQERR
        S XMSUB="ERROR 'GUI CHART' DATA FOR "_$$STATION()
        S XMTEXT="XQMSG("
        M XMY=XQMAIL S:+XQISO>0 XMY(+XQISO)="" S:+XQIRM>0 XMY(+XQIRM)=""
        S XMDUZ=0.5 D ^XMD
        G MUS
        ;
NOISO   ;
        N XMSUB,XMDUZ,XMY,XQMSG,XQGROUP,XMTEXT
        S XQMSG(1)="There is no valid entry in file 8989.3 for fields 321.01 OR 321.02"
        S XQMSG(2)=""
        S XQMSG(3)="Please correct this since the data is necessary to send a detailed"
        S XQMSG(4)="report to the local Information Security Officer."
        S XQMSG(5)=""
        S XQMSG(6)="Thank you"
        S XMSUB="ERROR 'GUI CHART' DATA FOR "_$$STATION()
        S XMTEXT="XQMSG("
        M XMY=XQMAIL
        S XQGROUP=$$FIND1^DIC(3.8,"","","PATCHES")
        I XQGROUP'>0 S XQGROUP=$$FIND1^DIC(3.8,"","","PATCH")
        I XQGROUP>0 S XQGROUP=$$GET1^DIQ(3.8,XQGROUP_",",.01),XMY("G."_XQGROUP)=""
        S XMDUZ=0.5 D ^XMD
        Q
        ;
STATION()       ;
        Q $$GET1^DIQ(4.2,(+^XTV(8989.3,1,0))_",",.01)_" ("_$$GET1^DIQ(4.2,(+^XTV(8989.3,1,0))_",",5.5)_")"
        ;
MUS     ;
OUT     ;
KILL    K XQDT,XQGO,XQN,XQP,XQR,XQRV,XQOPT,XQPA,XQUI,XQSCD,XQDSH,XQU,N,K,J,X,XQA,XQD,XQHDR,XQK,XQP,XQPS,XQMP,XQPG,XX
        K DIC,I,II,JJ,L,POP,Y
        K D,DG,D0,D1,D2,DICR,DIW,XMDUN,XMZ,XQCOM,XQTAB,XQWRITE
        Q
