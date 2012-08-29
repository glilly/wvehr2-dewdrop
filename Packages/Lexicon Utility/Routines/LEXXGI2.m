LEXXGI2 ;ISL/KER - Global Import (Update Change File w/^LEXM) ;06/06/2007
 ;;2.0;LEXICON UTILITY;**25,26,28,29,46,49,50**;Sep 23, 1996
 ;             
 ; Variables NEWed or KILLed Elsewhere
 ;    XPDNM  NEWed by KIDS during Install
 ;              
 ; Global Variables
 ;    ^LEXM
 ;    DBIA   872  ^ORD(101
 ;    DBIA 10011  ^UTILITY($J
 ;              
 ; External References
 ;    DBIA  10011  ^DIWP
 ;    DBIA 10103  $$FMDIFF^XLFDT
 ;    DBIA 10103  $$NOW^XLFDT
 ;    DBIA 10141  BMES^XPDUTL 
 ;    DBIA 10141  MES^XPDUTL
 ;    DBIA 10101  EN^XQOR
 ;              
 Q
NOTIFY ; Notify by Protocol - LEXICAL SERVICES UPDATE
 ;     Uses LEXSCHG() from the Post-Install
 ;     Sets ^LEXM(0,"PRO")=$$NOW^XLFDT
 N X,LEXU,LEXT,LEXF,LEXI,LEXL,LEX1,LEX2,LEX3,LEXN,LEXP,LEXUP D:$O(LEXSCHG(0))'>0 SCHG
 S LEXUP="" S:$D(LEXSCHG("C","ICD"))!($D(LEXSCHG(80)))!($D(LEXSCHG(80.1))) LEXUP=$G(LEXUP)_"ICD"
 S:$D(LEXSCHG("C","CPT"))!($D(LEXSCHG(81)))!($D(LEXSCHG(81.3))) LEXUP=$G(LEXUP)_"/CPT"
 S:$E(LEXUP,1)="/" LEXUP=$E(LEXUP,2,$L(LEXUP)) S:$L(LEXUP) LEXUP=LEXUP_" "
 S LEXI=756.999999 F  S LEXI=$O(LEXSCHG(LEXI)) Q:+LEXI'>0!($P(LEXI,".",1)'="757")  S LEXT=$G(LEXT)_", "_LEXI
 S LEXI=79.9990999 F  S LEXI=$O(LEXSCHG(LEXI)) Q:+LEXI'>0!($P(LEXI,".",1)'="80")  S LEXT=$G(LEXT)_", "_LEXI
 S LEXI=80.9990999 F  S LEXI=$O(LEXSCHG(LEXI)) Q:+LEXI'>0!($P(LEXI,".",1)'="81")  S LEXT=$G(LEXT)_", "_LEXI
 S:$E($G(LEXT),1,2)=", " LEXT=$E($G(LEXT),3,$L($G(LEXT))),LEXT=$$TRIM(LEXT)
 I $L(LEXT) D
 . S:$L(LEXT,", ")>1 LEXT=$P($G(LEXT),", ",1,($L($G(LEXT),", ")-1))_" and "_$P($G(LEXT),", ",$L($G(LEXT),", "))
 S:$P($O(LEXSCHG(756.999999)),".",1)="757" LEXF="Lexicon" S:$P($O(LEXSCHG(79.999999)),".",1)=80 LEXF=$G(LEXF)_", ICD"
 S:$P($O(LEXSCHG(80.999999)),".",1)=81 LEXF=$G(LEXF)_", CPT"
 S:$E($G(LEXF),1,2)=", " LEXF=$E($G(LEXF),3,$L($G(LEXF))),LEXF=$$TRIM(LEXF)
 I $L(LEXF) D
 . S:$L(LEXF,", ")>1 LEXF=$P($G(LEXF),", ",1,($L($G(LEXF),", ")-1))_" and "_$P($G(LEXF),", ",$L($G(LEXF),", "))
 . S:$L($P(LEXF,", ",1)) LEXF=$G(LEXF)_" File"_$S(LEXF[", ":"s",LEXF[" and ":"s",1:"")_" Updated"
 S LEXL=78-($L(LEXF)+4),LEXU="Lexical Files Updated" I $L(LEXT)&($L(LEXF))&(LEXL>30) D
 . S LEXU=LEXF N LEX S LEX=LEXT K LEXT S LEXT(1)=LEX D WP(.LEXT,LEXL)
 S LEXP=+($O(^ORD(101,"B","LEXICAL SERVICES UPDATE",0))) Q:LEXP=0  S X=LEXP_";ORD(101," D EN^XQOR S:'$D(LEXSCHG) ^LEXM(0,"PRO")=$$NOW^XLFDT
 Q:+($G(^LEXM(0,"PRO")))'>0
 I $L($G(LEXU)) D
 . N LEXI S LEXI=$L($G(LEXU))+3
 . S X=$G(LEXU) D:$O(LEXT(0))'>0 BL,TL(X),BL I $O(LEXT(0))>0 D
 . . D BL S X=$G(LEXU)_":  " N LEX S LEX=0 F  S LEX=$O(LEXT(LEX)) Q:+LEX'>0  D
 . . . N LEXX S LEXX=$$TRIM($G(LEXT(LEX))) S:$L(LEXX) X=X_LEXX D TL(X) S X="",$P(X," ",+LEXI)=" "
 . . D BL
 S X="Protocol 'LEXICAL SERVICES UPDATE' was invoked" D TL(X)
 S X="Subscribing applications were notified of the "_LEXUP_"update" D TL(X),BL
 Q
UPCHG ;
 Q:+($G(LEXFI))'>0  N LEXID S LEXID=$S($P(LEXFI,".",1)="757":"LEX",$P(LEXFI,".",1)="80":"ICD",$P(LEXFI,".",1)="81":"CPT",1:"UNK")
 I $D(LEXSCHG) S LEXSCHG(LEXFI,0)="",LEXSCHG("B",LEXFI)="",LEXSCHG("C",LEXID,LEXFI)=""
 Q
SCHG ; Change Array LEXSCHG (Some or all, but never nothing)
 N FI,ID K LEXSCHG S LEXCHG=0
 N FI S FI=0 F  S FI=$O(^LEXM(FI)) Q:+FI'>0  D
 . S ID=$S(FI=80!(FI=80.1):"ICD",FI=81!(FI=81.1)!(FI=81.2)!(FI=81.3):"CPT",$P(FI,".",1)=757:"LEX",1:"UNK")
 . S LEXSCHG(FI,0)=+($G(^LEXM(FI,0))),LEXSCHG("B",FI)="" S LEXSCHG("C",ID,FI)=""
 S:$D(LEXSCHG("C","CPT"))!($D(LEXSCHG("C","ICD"))) LEXSCHG("D","PRO")=""
 S:$D(^LEXM(80))!($D(^LEXM(80.1)))!($D(^LEXM(81)))!($D(^LEXM(81.2)))!($D(^LEXM(81.3)))!($D(LEXSCHG("D","PRO"))) LEXCHG=1,LEXSCHG(0)=1
 D:$O(LEXSCHG(0))'>0 SALL S:$D(LEXSCHG("C","CPT"))!($D(LEXSCHG("C","ICD"))) LEXSCHG("D","PRO")=""
 Q
SALL ;   Set All (ICD/CPT/Lexicon)
 D SICD,SCPT,SLEX
 Q
SICD ;   Set ICD
 S (LEXSCHG("80",0),LEXSCHG("B","80"),LEXSCHG("C","ICD","80"))="",(LEXSCHG("80.1",0),LEXSCHG("B","80.1"),LEXSCHG("C","ICD","80.1"))="" D SLEX
 Q
SCPT ;   Set CPT
 S (LEXSCHG("81",0),LEXSCHG("B","81"),LEXSCHG("C","CPT","81"))="",(LEXSCHG("81.1",0),LEXSCHG("B","81.1"),LEXSCHG("C","CPT","81.1"))=""
 S (LEXSCHG("81.2",0),LEXSCHG("B","81.2"),LEXSCHG("C","CPT","81.2"))="",(LEXSCHG("81.3",0),LEXSCHG("B","81.3"),LEXSCHG("C","CPT","81.3"))="" D SLEX
 Q
SLEX ;   Set Lexicon
 S (LEXSCHG("757",0),LEXSCHG("B","757"),LEXSCHG("C","LEX","757"))="",(LEXSCHG("757.001",0),LEXSCHG("B","757.001"),LEXSCHG("C","LEX","757.001"))=""
 S (LEXSCHG("757.01",0),LEXSCHG("B","757.01"),LEXSCHG("C","LEX","757.01"))="",(LEXSCHG("757.02",0),LEXSCHG("B","757.02"),LEXSCHG("C","LEX","757.02"))=""
 S (LEXSCHG("757.1",0),LEXSCHG("B","757.1"),LEXSCHG("C","LEX","757.1"))=""
 Q
CS ;   Checksum for import global
 N LEXCHK,LEXNDS,LEXVER S LEXCHK=+($G(^LEXM(0,"CHECKSUM")))
 W !,"   Running checksum routine on the ^LEXM import global, please wait"
 S LEXNDS=+($G(^LEXM(0,"NODES"))),LEXVER=+($$VC(LEXCHK,LEXNDS)) W !
 W:LEXVER>0 !,"     Checksum is ok",! Q:LEXVER>0
 I LEXVER=0 W !!,"   Import global ^LEXM is missing.  Please obtain a copy of ^LEXM before",!,"   continuing." Q
 I LEXVER<0 D  Q
 . I LEXVER'=-3 W !,"   Unable to verify checksum for import global ^LEXM (possibly corrupt)"
 . I LEXVER=-3 W !,"   Import global ^LEXM failed checksum"
 . W !!,"     Please KILL the existing import global ^LEXM from your system and"
 . W !,"     obtain a new copy of ^LEXM before continuing with the installation."
 Q
VC(X,Y) ;   Verify Checksum for import global
 Q:'$D(^LEXM)!('$D(^LEXM(0)))!($O(^LEXM(0))'>0) 0  N LEXCHK,LEXNDS,LEXCNT,LEXLC,LEXL,LEXS,LEXNC,LEXD,LEXN,LEXC,LEXGCS,LEXP,LEXT
 S LEXCHK=+($G(X)),LEXNDS=+($G(Y)) Q:LEXCHK'>0!(LEXNDS'>0) -2  S LEXL=64,(LEXCNT,LEXLC)=0,LEXS=(+(LEXNDS\LEXL))
 S:LEXS=0 LEXS=1 W:+($O(^LEXM(0)))>0 ! S (LEXC,LEXN)="^LEXM",(LEXNC,LEXGCS)=0 W "   "
 F  S LEXN=$Q(@LEXN) Q:LEXN=""!(LEXN'[LEXC)  D
 . Q:LEXN="^LEXM(0,""CHECKSUM"")"  Q:LEXN="^LEXM(0,""NODES"")"  S LEXCNT=LEXCNT+1
 . I LEXCNT'<LEXS S LEXLC=LEXLC+1 W:LEXLC'>LEXL "." S LEXCNT=0
 . S LEXNC=LEXNC+1,LEXD=@LEXN,LEXT=LEXN_"="_LEXD F LEXP=1:1:$L(LEXT) S LEXGCS=$A(LEXT,LEXP)*LEXP+LEXGCS
 Q:LEXNC'=LEXNDS -3  Q:LEXGCS'=LEXCHK -3
 Q 1
 ; Miscellaneous
NF ;   Import Global Not Found
 D PB(" Import Global ^LEXM not found, consult the installation instructions")
 D TL(" to install this global")
 Q
IG ;   Invalid Import Global
 D PB(" Invalid Import Global ^LEXM, please consult the installation")
 D TL(" instructions to reload this global")
 Q
BL ;   Blank Line
 N X S X="" W:'$D(XPDNM) ! D:$D(XPDNM) MES^XPDUTL(X) Q
PB(X) ;   Preceeding Blank Line
 S X=$G(X) Q:'$L(X)  W:'$D(XPDNM) !!,X D:$D(XPDNM) BMES^XPDUTL(X) Q
TL(X) ;   Text Line
 S X=$G(X) Q:'$L(X)  W:'$D(XPDNM) !,X D:$D(XPDNM) MES^XPDUTL(X) Q
HACK(X) ;   Time
 S X=$$NOW^XLFDT Q X
ELAP(X1,X2) ;   Elapsed Time
 N X S X=$$FMDIFF^XLFDT(+($G(X2)),+($G(X1)),3)
 S:X="" X="00:00:00" S X=$TR(X," ","0") S X1=X Q X1
 Q
KLEXM ;   Subscripted Kill of ^LEXM - files only
 N LEX S LEX=0 F  S LEX=$O(^LEXM(LEX)) Q:+LEX'>0  K ^LEXM(LEX)
 Q
KALL ;   Subscripted Kill of ^LEXM - all
 K LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR,LEXB,LEXCD,LEXSTR,LEXLAST
 K %,%DT,C,D,D0,D1,D2,DG,DIC,DICR,DILOCKTM,DIW,IREC,J,XMDUN,XMZ,ZTSK N LEX
 S LEX=0 F  S LEX=$O(^LEXM(LEX)) Q:+LEX'>0  K ^LEXM(LEX)
 K ^LEXM(0)
 Q
 ;   Error Text
ET(X) ;     Save Text
 N LEXI S LEXI=+($G(LEXE(0))),LEXI=LEXI+1,LEXE(LEXI)=$G(X),LEXE(0)=LEXI Q
ED ;     Display Text
 N LEXI S LEXI=0 F  S LEXI=$O(LEXE(LEXI)) Q:+LEXI=0  W !,LEXE(LEXI)
 W ! K LEXE
 Q
 ;   Case
MIX(X) ;     Mixed Case
 S X=$G(X) N LEXT,LEXI S LEXT=""
 F LEXI=1:1:$L(X," ") S LEXT=LEXT_" "_$$UP($E($P(X," ",LEXI),1))_$$LO($E($P(X," ",LEXI),2,$L($P(X," ",LEXI))))
 F  Q:$E(LEXT,1)'=" "  S LEXT=$E(LEXT,2,$L(LEXT))
 S:$E(LEXT,1,3)="Cpt" LEXT="CPT"_$E(LEXT,4,$L(LEXT)) S:$E(LEXT,1,3)="Icd" LEXT="ICD"_$E(LEXT,4,$L(LEXT)) S X=LEXT
 Q X
UP(X) ;     Uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
LO(X) ;     Lowercase
 Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
WP(LEX,L) ;   Wrap Text LEX with Length L
 K ^UTILITY($J,"W") N %,CT,DA,DIC,DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,DTOUT,DUOUT,LENGTH,TI,X,Z,END,I
 S TI=0,LENGTH=+($G(L)) F  S TI=$O(LEX(TI)) Q:+TI'>0  D
 . N X,DIWX,DN,DTOUT,DUOUT S X=$G(LEX(TI)),DIWL=1,DIWF="C78" S:+($G(LENGTH))>0 DIWF="C"_+($G(LENGTH)) D ^DIWP
 K LEX S (CT,I)=0 F  S I=$O(^UTILITY($J,"W",1,I)) Q:+I=0  D
 . S X=$G(^UTILITY($J,"W",1,I,0)),CT=CT+1,LEX(CT)=$$TRIM(X)
 K ^UTILITY($J,"W")
 Q
CLR ;   Clear
 K %,%DT,C,CT,D,D0,D1,D2,DA,DG,DIC,DICR,DILOCKTM,DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,DN,DTOUT
 K DUOUT,END,FI,I,ID,IREC,J,L,LENGTH,LEX,LEX1,LEX2,LEX3,LEXB,LEXBUILD,LEXC,LEXCD,LEXCHG,LEXCHK,LEXCNT
 K LEXD,LEXE,LEXF,LEXFI,LEXFY,LEXGCS,LEXI,LEXID,LEXIGHF,LEXL,LEXLAST,LEXLC,LEXLREV,LEXN,LEXNC,LEXNDS,LEXP
 K LEXPTYPE,LEXQTR,LEXREQP,LEXS,LEXSCHG,LEXSTR,LEXT,LEXU,LEXUP,LEXVER,LEXX,TI,X,X1,X2,XMDUN,XMZ,Y,Z,ZTSK
 Q
TRIM(X) ;   Trim Spaces
 S X=$G(X) Q:X="" X F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,229)
 Q X
