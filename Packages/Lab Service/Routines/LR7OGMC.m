LR7OGMC ;DALOI/STAFF- Interim report rpc memo chem ; Aug 16, 2004
        ;;5.2;LAB SERVICE;**187,230,312,286,356,372**;Sep 27, 1994;Build 11
        ;
        ; sets lab data into ^TMP("LR7OG",$J,"TP"
        ; ^TMP("LR7OG",$J,"G")=dfn^pnm^lrdfn^age^sex^lrcw
        ; ^TMP("LR7OG",$J,"TMP",test subscript in data)=zero node of test
        ; ^TMP("LR7OG",$J,"TP",collect date/time)=zero node from data
        ; ^TMP("LR7OG",$J,"TP",collect date/time,printorder)=test#^name^printname^^printcode^dataname^result^flag^units^range^performing site
        ; ^TMP("LR7OG",$J,"TP",collect date/time,printorder,#)=interpretation
        ; ^TMP("LR7OG",$J,"TP",collect date/time,"C",#)=comment
        ;
        ;
CH(LRDFN,IDT,ALL,OUTCNT,FORMAT,DONE)    ; from LR7OGM
        N CDT,CHSUB,CMNT,INTP,LABSUB,PNODE,PORDER,SPEC,TCNT,TESTNUM,TESTSUB,ZERO
        S ZERO=$G(^LR(LRDFN,"CH",IDT,0))
        I '$P(ZERO,U,3) Q
        S CDT=+ZERO,LABSUB="CH",TCNT=0,SPEC=$P(ZERO,U,5)
        S CHSUB=1
        F  S CHSUB=$O(^LR(LRDFN,"CH",IDT,CHSUB)) Q:CHSUB=""  I ALL!$D(^TMP("LR7OG",$J,"TMP",CHSUB)) D  Q
        . I FORMAT D
        .. S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)="0^CH^"_(9999999-IDT)
        .. S OUTCNT=OUTCNT+1
        .. S DONE=1
        . K ^TMP("LR7OG",$J,"TP")
        . I ALL S TESTSUB=1 F  S TESTSUB=$O(^LR(LRDFN,"CH",IDT,TESTSUB)) Q:TESTSUB<1  S TESTNUM=$O(^LAB(60,"C","CH;"_TESTSUB_";1",0)) D CHSETUP
        . I 'ALL S TESTSUB=1 F  S TESTSUB=$O(^TMP("LR7OG",$J,"TMP",TESTSUB)) Q:TESTSUB<1  S TESTNUM=+^(TESTSUB) D CHSETUP
        . I TCNT D
        .. S ^TMP("LR7OG",$J,"TP",CDT)=ZERO,CMNT=0
        .. F  S CMNT=+$O(^LR(LRDFN,LABSUB,IDT,1,CMNT)) Q:CMNT<1  S ^TMP("LR7OG",$J,"TP",CDT,"C",CMNT)=^(CMNT,0) S TCNT=TCNT+1
        . I FORMAT D GRID^LR7OGMG(.OUTCNT)
        . I 'FORMAT D PRINT^LR7OGMP(.OUTCNT)
        . K ^TMP("LR7OG",$J,"TP")
        Q
        ;
        ;
CHSETUP ; within scope of CH
        ;
        N LRX
        I 'TESTNUM Q
        Q:'$D(^LAB(60,TESTNUM,.1))  S PNODE=^(.1) I '("BO"[$P($G(^(0)),U,3)) Q
        Q:'$D(^LR(LRDFN,LABSUB,IDT,TESTSUB))  Q:'$L($P(^(TESTSUB),U))
        ;
        S PORDER=$P(PNODE,U,6),PORDER=$S(PORDER:PORDER,1:TESTSUB/1000000)
        F  Q:'$D(^TMP("LR7OG",$J,"TP",CDT,PORDER))  Q:TESTNUM=+^(PORDER)  S PORDER=PORDER+1
        ;
        I $D(^TMP("LR7OG",$J,"TP",CDT,PORDER)) Q
        ;
        S LRX=$$TSTRES^LRRPU(LRDFN,LABSUB,IDT,TESTSUB,TESTNUM)
        S ^TMP("LR7OG",$J,"TP",CDT,PORDER)=TESTNUM_U_$P(^LAB(60,TESTNUM,0),U)_U_$P(PNODE,U)_U_$P(PNODE,U,2)_U_$P(PNODE,U,3)_U_$P(^(0),U,5)_U_$P(LRX,U)_U_$P(LRX,U,2)_U_$P(LRX,U,5)_U_$$EN^LRLRRVF($P(LRX,U,3),$P(LRX,U,4))_U_$P(LRX,U,6)
        ;
        ; Save performing lab ien in list
        I $P(LRX,U,6) S ^TMP("LRPLS",$J,$P(LRX,U,6))=""
        ;
        S TCNT=TCNT+1
        I $D(^LAB(60,TESTNUM,1,SPEC,1,0)) D
        . S INTP=0
        . F  S INTP=+$O(^LAB(60,TESTNUM,1,SPEC,1,INTP)) Q:INTP<1  D
        . . S ^TMP("LR7OG",$J,"TP",CDT,PORDER,INTP)=^(INTP,0)
        . . S TCNT=TCNT+1
        Q
