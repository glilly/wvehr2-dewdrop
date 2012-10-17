LR7OGMM ;SLC/STAFF- Interim report rpc memo micro ;7/16/09  16:06
        ;;5.2;LAB SERVICE;**187,312,364,395**;Sep 27, 1994;Build 27
        ;
MI(LRDFN,IDT,MICROSUB,ALL,OUTCNT,FORMAT,DONE,SKIP)      ; from LR7OGM
        N MISUB,OK,ZERO,INEXACT,DISPDATE,XDT,UID,ACC,AREA,ACDT
        I '$D(^LR(LRDFN,"MI",IDT)) Q
        S UID=$P($G(^LR(LRDFN,"MI",IDT,"ORU")),"^")
        I UID'="" S UID=$$CHECKUID^LRWU4(UID)
        I 'UID,'$P($G(^LR(LRDFN,"MI",IDT,0)),"^",3) S SKIP=1 Q
        S AREA=$P(UID,"^",2),ACDT=$P(UID,"^",3),NUM=$P(UID,"^",4)
        S OK=ALL
        I 'OK S MISUB=0 F  S MISUB=+$O(MICROSUB(MISUB)) Q:MISUB<1  I $D(^LR(LRDFN,"MI",IDT,MISUB)) S OK=1 Q
        D ACC
        I 'OK Q
        I $G(FORMAT) D
        . S XDT=9999999-IDT
        . S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)="^MI^"_XDT D
        .. ; determine if collection time is "inexact" and put the 
        .. ; collection day/time that is to be displayed in piece 10
        .. S ZERO=$G(^LR(LRDFN,"MI",IDT,0)) Q:ZERO=""
        .. S INEXACT=$P(ZERO,U,2),DISPDATE=$S(INEXACT:XDT\1,1:XDT),$P(^TMP("LR7OGX",$J,"OUTPUT",OUTCNT),U,10)=DISPDATE
        . S OUTCNT=OUTCNT+1,DONE=1
        D MIC(LRDFN,IDT,.OUTCNT)
        Q
        ;
ACC     ;Look for data from Accession file
        N ANODE,MICROEC,NO,TESTNUM
        K ^TMP("LR7OG",$J,"ACC")
        I '$D(^LRO(68,+AREA,1,+ACDT,1,+NUM)) Q
        S TESTNUM=0 F  S TESTNUM=$O(^LRO(68,+AREA,1,+ACDT,1,+NUM,4,TESTNUM)) Q:'TESTNUM  S ANODE=^(TESTNUM,0) D
        . I 'ALL S MICROEC=+$P(^LAB(60,TESTNUM,0),"^",14),MICROEC=$G(^LAB(62.07,MICROEC,.1)),NO=0 D  Q:'$D(MICROSUB(+NO))
        .. I MICROEC["11.5" S NO=1 ;Matching done of fields in DR string from Execute Code field in file 62.07
        .. I MICROEC["11.6" S NO=2
        .. I MICROEC["15" S NO=5
        .. I MICROEC["19" S NO=8
        .. I MICROEC["23" S NO=11
        .. I MICROEC["34" S NO=16
        . S ^TMP("LR7OG",$J,"ACC",TESTNUM)=ANODE
        I $O(^TMP("LR7OG",$J,"ACC",0)) S OK=1
        K ^TMP("LR7OG",$J,"ACC")
        Q
MIC(LRDFN,LRIDT,OUTCNT) ;
        N AGE,GCNT,GIOM,LINE,LREND,LRONESPC,LRONETST,NUM,SEX
        S GCNT=0,GIOM=80,LREND=0,LRONESPC="",LRONETST=0
        S AGE=$P(^TMP("LR7OG",$J,"G"),U,5),SEX=$P(^("G"),U,6)
        ; new variables used by LR7OSMZ0
        N %,A,A8,AB,B,B1,B2,B3,C,CCNT,DIC,DZ,I,IA,II,INC,J,K,LR1PASS,LR2ORMOR,LRAA,LRABCNT,LRACC,LRACNT,LRAD,LRADM,LRADX,LRAFS,LRAMT,LRAN,LRAO,LRAX
        N LRBN,LRBRR,LRBUG,LRCMNT,LRCOMTAB,LRCS,LRDCOM,LRDOC,LRDRTM1,LRDRTM2,LREF,LRFLAG,LRFMT,LRGRM,LRIFN,LRINT,LRJ02,LRLABKY,LRLLT,LRMYC,LRNS,LRNUM
        N LRORG,LRPAR,LRPATLOC,LRPC,LRPG,LRPRE,LRPRINT,LRQU,LRRC,LRRES,LRSB,LRSBC1,LRSBC2,LRSET,LRSIC1,LRSIC2,LRSET,LRSIC1,LRSIC2,LRSPEC,LRSSD,LRST
        N LRTA,LRTB,LRTBA,LRTBC,LRTBS,LRTK,LRTS,LRTSTS,LRTUS,LRUS,LRWRD,LRWRDVEW,N,S1,SP,X,X1,Y,Y1
        K DIC,LR1PASS,LRBUG,LRDCOM,LRINT,LRRES,LRTS K ^TMP("LR",$J),^TMP("LRC",$J),^TMP("LRT",$J)
        D EN1^LR7OSMZ0
        I '$O(^TMP("LRC",$J,0)) Q
        S NUM=0 F  S NUM=$O(^TMP("LRC",$J,NUM)) Q:NUM<1  S LINE=^(NUM,0) D
        . S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=LINE,OUTCNT=OUTCNT+1
        S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)="===============================================================================",OUTCNT=OUTCNT+1
        S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=" ",OUTCNT=OUTCNT+1
        K ^TMP("LR",$J),^TMP("LRC",$J),^TMP("LRT",$J)
        Q
