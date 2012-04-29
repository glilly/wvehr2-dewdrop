LR7OSUM5        ;slc/dcm - Silent Patient cum cont. ;8/11/97
        ;;5.2;LAB SERVICE;**121,187,228,241,250,251,256,356,372**;Sep 27, 1994;Build 11
TS      ;from  LR7OSUM3
        N A,B,I,J,LRII,LRCTR,LRFALT,LRCL,LRCW,LRTLOC,X,XZ,Z
        I LRACT'=0 S X="",$P(X,"=",GIOM)="" D LN S ^TMP("LRC",$J,GCNT,0)=X
        S I=0,LRII=0
        F  S LRII=$O(^LAB(64.5,1,1,LRMH,1,LRSH,1,LRII)) Q:LRII<1  S I=I+1,I(I)=LRII
        S LRFALT=0,LRCTR=0,LRACT=LRACT+1,J=LRJS+1,LRCL=20
        I J'>LRSHD D LINE^LR7OSUM4,LN S ^TMP("LRC",$J,GCNT,0)="",^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(CCNT,CCNT,LRTOPP)_$$S^LR7OS(LRCL,CCNT,"")
        F I=J:1:LRSHD S Z=^LAB(64.5,1,1,LRMH,1,LRSH,1,I(I),0),LRCW=$P(Z,U,2) Q:(GIOM-LRCL)<LRCW  D
        . S LRCL=LRCL+LRCW,A=$L($P(Z,U,3))\2,B=LRCW\2,^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,$J($E($P(Z,U,3),1,(LRCW-1)),(A+B)))_$$S^LR7OS(LRCL,CCNT,"")
        . S:'$P($G(^TMP("LRT",$J,$P(Z,"^",3))),"^",2) $P(^TMP("LRT",$J,$P(Z,"^",3)),"^",2)=GCNT
        S LRJS=(I-1)
        S:LRACT=LRPL LRJS=LRJS+1
        F I=J:1:LRJS Q:'$D(^LAB(64.5,"A",1,LRMH,LRSH,I(I)))  S Z=^(I(I)) S:$L($P(Z,U,2))!$L($P(Z,U,11)) LRFALT=1
        I LRFALT D
        . D LN S ^TMP("LRC",$J,GCNT,0)="" D
        . . S LRCL=20
        . . S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(CCNT,CCNT,$S($L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(J)),U,11)):"Therapeutic low",1:"Ref range low"))_$$S^LR7OS(LRCL,CCNT,"")
        . . D TS1
        . D LN S ^TMP("LRC",$J,GCNT,0)="" D
        . . S LRCL=20
        . . S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(CCNT,CCNT,$S($L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(J)),U,11)):"Therapeutic high",1:"Ref range high"))_$$S^LR7OS(LRCL,CCNT,"")
        . . D TS2
        F I=J:1:LRJS Q:'$D(^LAB(64.5,"A",1,LRMH,LRSH,I(I)))  S:$L($P(^(I(I)),U,7)) LRFALT=1
        I LRFALT S LRCL=20 D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(LRCL,CCNT,"") F I=J:1:LRJS D TS3
        S LRFALT=0,XZ="",$P(XZ,"-",GIOM)=""
        D LN
        S ^TMP("LRC",$J,GCNT,0)=XZ
LRFDT   ;
        S:LRNP LRFFDT=LRFDT,LRNP=0
        S LRFDT=$O(^TMP($J,LRDFN,LRMH,LRSH,LRFDT)) G:LRFDT<1 LOOP^LR7OSUM3 S LRTLOC=$P(^(LRFDT,0),U,1)
        S:LRFDT>LRLFDT LRLFDT=LRFDT
GOUT    ;
        D QRS
        I LRCTR>LRLNS&(LRACT'<LRPL) S LRFULL=1 D TXT1 G:$O(^TMP($J,LRDFN,LRMH,LRSH,LRLFDT))<1 LRSH^LR7OSUM3 D HEAD^LR7OSUM6,LRLNS^LR7OSUM3 S LRFULL=0,LRFDT=LRLFDT G TS
        I LRCTR>LRLNS&(LRACT<LRPL) S LRFDT=LRFFDT G TS
        G LRFDT
QRS     ;
        S LRCTR=LRCTR+1
        F I=J:1:LRJS I $D(^TMP($J,LRDFN,LRMH,LRSH,LRFDT,I(I))) S:$L(^(I(I))) LRFALT=1
        Q:'LRFALT
        S LRFALT=0,LRTM=1
        D UDT^LR7OSUM3
        S LRCL=20,LRTM=0
        D LN
        S ^TMP("LRC",$J,GCNT,0)=""
        S:'LRNXSW ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(2,CCNT,""),^(0)=^(0)_$$S^LR7OS(3,CCNT,"")
        S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,LRUDT)
        F I=J:1:LRJS S LRG=^LAB(64.5,1,1,LRMH,1,LRSH,1,I(I),0) S X=^(0) D QRS1
        Q
QRS1    ;
        S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(LRCL,CCNT,""),LRCW=$P(LRG,U,2),LRDP=$P(X,U,6)
        Q:(GIOM-LRCL)<LRCW
        S LRCL=LRCL+LRCW
        I $D(^TMP($J,LRDFN,LRMH,LRSH,LRFDT,I(I))) S X=^(I(I)) D C(.X,.X1) S:$L($P(LRG,U,4))&($L(X)) @("X="_$P(LRG,U,4)),^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,X_X1) D
        . I '$L($P(LRG,U,4)) S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,X_X1)
        Q
TXT     ;from LR7OSUM4
        S LRVAR=0,LRIV=0
        F  S LRIV=$O(^TMP($J,LRDFN,LRMH,LRSH,LRFDT,"TX",LRIV)) Q:LRIV<1  S X=^(LRIV,0),LRVAR=LRVAR+1 D
        . I LRVAR>1 D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(3,CCNT,"")
        . S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,X)
        Q
LRLO    ;from LR7OSUM4
        S @("LRLO="_$S($L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(I)),U,2)):$P(^(I(I)),U,2),$L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(I)),U,11)):$P(^(I(I)),U,11),1:""""""))
LRHI    S @("LRHI="_$S($L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(I)),U,3)):$P(^(I(I)),U,3),$L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(I)),U,12)):$P(^(I(I)),U,12),1:"""""")),P7=$P(^(I(I)),U,7)
        S LRLOHI=$$EN^LRLRRVF(LRLO,LRHI)
        Q
TXT1    ;from LR7OSUM3, LR7OSUM4
        S XZ="",$P(XZ,"=",GIOM)=""
        Q:'$D(LRTM(0))
        N C6,I,L
        S C6=0
        F  S C6=$O(^TMP($J,"TM",C6)) Q:C6<1  S X=^(C6) D
        . D LN
        . S I=$S($L($P(X,"^"))>1:2,1:3),^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(I,CCNT,$P(X,U)_". "),L(0)=0,L=0 D
        . F  S L=$O(^TMP($J,"TM",C6,L)) Q:L<1  S X=^(L),L(0)=L(0)+1 D
        .. I L(0)>1 D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(6,CCNT,"")
        .. S ^(0)=^TMP("LRC",$J,GCNT,0)_X
        Q
C(X,X1)    ;
        N X2
        S X1=" "_$P(X,U,2),X=$P(X,U,1)
        I $L($P(LRG,U,4)) S LRCW=LRCW-3 Q
        I "<>"[$E(X,1),$E(X,2,$L(X))?.N.P1N S X2=$E(X,1),X=$E(X,2,$L(X))
        S LRCW(1)=LRCW-3
        I X?.N.P1N!(LRDP="")!(X?.N1".".N) S X=$S(LRDP="":$J(X,LRCW(1)),1:$J(X,LRCW(1),LRDP)) D C2(.X,.X2)
        Q
C1(X,X1)        ;from LR7OSUM4
        S LRCW=$S('$L(X1):7,1:10),X1=$S($L(X1)=1:" "_X1_" ",$L(X1)=0:X1,1:" "_X1)
        I $L($P(LRG,U,4)) S LRCW=7 Q
        S X=$S($L(X1):X_X1,1:X)
        Q
C2(X,X2)        ;
        Q:'$D(X2)
        Q:'$D(X)
        N X3
        F X3=1:1:$L(X) I $E(X,X3)'=" " S X=$E(X,1,X3-2)_X2_$E(X,X3,$L(X)) Q
        Q
TS1     ;Print low therapeutic or reference range values
        F I=J:1:LRJS S LRCW=$P(^LAB(64.5,1,1,LRMH,1,LRSH,1,I(I),0),U,2),LRCL=LRCL+LRCW D
        . S @("LRLO="_$S($L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(I)),U,2)):$P(^(I(I)),U,2),$L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(I)),U,11)):$P(^(I(I)),U,11),1:""""""))
        . S A=$L(LRLO)\2,B=LRCW\2
        . S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,$J(LRLO,(A+B))),^(0)=^(0)_$$S^LR7OS(LRCL,CCNT,"")
        Q
TS2     ;Print high therapeutic or reference range values
        F I=J:1:LRJS S LRCW=$P(^LAB(64.5,1,1,LRMH,1,LRSH,1,I(I),0),U,2),LRCL=LRCL+LRCW D
        . S @("LRHI="_$S($L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(I)),U,3)):$P(^(I(I)),U,3),$L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(I)),U,12)):$P(^(I(I)),U,12),1:"""""")),P7=$P(^(I(I)),U,7)
        . S A=$L(LRHI)\2,B=LRCW\2
        . S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,$J(LRHI,(A+B))),^(0)=^(0)_$$S^LR7OS(LRCL,CCNT,"")
        Q
TS3     ;Print units
        S LRCW=$P(^LAB(64.5,1,1,LRMH,1,LRSH,1,I(I),0),U,2)
        Q:(GIOM-LRCL)<LRCW
        S LRCL=LRCL+LRCW,A=$L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(I)),U,7))\2,B=LRCW\2,X=^(I(I))
        S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(CCNT,CCNT,$J($P(X,U,7),(A+B)))
        S ^TMP("LRC",$J,GCNT,0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(LRCL,CCNT,""),LRFALT=0
        Q
LN      ;
        S GCNT=GCNT+1,CCNT=1
        Q
