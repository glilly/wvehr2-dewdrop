%ZVEMKTS ;DJB,KRN**Txt Scroll-SELECTOR [8/28/98 1:31pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
TOP ;
 NEW X S X="ERROR^%ZVEMKT2",@($$TRAP^%ZVEMKU1) KILL X
 NEW DX,DY,FLAGQ,VEET NEW:'$D(VEE) VEE NEW:'$D(VEES) VEES
 S FLAGQ=0
 KILL ^TMP("VEE","K",$J)
 KILL ^TMP("VPE","SELECT",$J)
 D INIT G:FLAGQ EX
 D TEMPLATE
 D SCROLL^%ZVEMKT2()
 D LIST
 D ENDSCR^%ZVEMKT2
EX ;
 KILL ^TMP("VEE","K",$J)
 I $G(DDS) X VEES("RM0") ;...Called from ScreenMan
 Q
 ;===============================================================
LIST ;Display text
 S VEET=$G(^TMP("VEE","K",$J,VEET("BOT")))
 W ! I VEET=" <> <> <>" W ?3,VEET
 E  D  ;
 . W:$D(^TMP("VPE","SELECT",$J,VEET("HLN"))) "=>"
 . W ?3 W:$G(NUMBER) $J(VEET("HLN"),3)_". "
 . W $S(VEET[$C(9):$P(VEET,$C(9),2,999),1:VEET)
 S VEET("BOT")=VEET("BOT")+1
 S:VEET("GAP") VEET("GAP")=VEET("GAP")-1
 S VEET("HLN")=VEET("HLN")+1 ;Highlight Line
 S:VEET("H$Y")<VEET("S2") VEET("H$Y")=VEET("H$Y")+1 ;Highlight $Y
 I VEET=" <> <> <>"!'VEET("GAP") D READ^%ZVEMKTT Q:FLAGQ
 G LIST
 ;====================================================================
TAG ;Tag/Untag a line
 I $D(^TMP("VPE","SELECT",$J,VEET("HLN")-1)) KILL ^(VEET("HLN")-1) Q
 D SET(VEET("HLN")-1)
 Q
ALL ;Tag all lines
 NEW I
 F I=1:1 Q:'$D(^TMP("VEE","K",$J,I))  D SET(I)
 D REDRAW^%ZVEMKT2()
 Q
CURSORUP ;Tag Cursor-to-Top
 NEW I
 F I=1:1:(VEET("HLN")-1) Q:'$D(^TMP("VEE","K",$J,I))  D SET(I)
 D REDRAW^%ZVEMKT2()
 Q
CURSORDN ;Tag Cursor-to-Bottom
 NEW I
 F I=(VEET("HLN")-1):1 Q:'$D(^TMP("VEE","K",$J,I))  D SET(I)
 D REDRAW^%ZVEMKT2()
 Q
CLEAR ;Clear all tagged lines
 KILL ^TMP("VPE","SELECT",$J) D REDRAW^%ZVEMKT2()
 Q
PAGE ;Tag a page
 NEW I
 F I=VEET("TOP"):1:(VEET("BOT")-1) D SET(I)
 D REDRAW^%ZVEMKT2()
 Q
FIND(MODE) ;MODE: +=Find&Tag  -=Find&Clear
 NEW AND,CHAR1,CHAR2,COL1,COL2,DATA,FIND,I
 D ENDSCR^%ZVEMKT2
 S MODE=$G(MODE)
 S (COL1,COL2,CHAR1,CHAR2,AND)=""
 W !,"F I N D   &   "
 W $S(MODE="+":"T A G",1:"C L E A R")_"   U T I L I T Y"
FIND1 S COL1=$$FINDCOL() I COL1="" D REDRAW^%ZVEMKT2() Q
FIND2 S CHAR1=$$FINDCHR() I CHAR1="" G FIND1
 W !
 G:$$ASK^%ZVEMKU("Do you want to include a 2nd criteria",2)'="Y" FIND6
FIND3 W !!,"[A]nd -or- [O]r: "
 R AND:300 S:'$T AND="" I "^"[AND G FIND6
 S AND=$$ALLCAPS^%ZVEMKU(AND)
 I AND'="A",AND'="O" D  G FIND3
 . W !,"If you want to include a 2nd criteria, then enter A or O."
 . W !,?3,"A = Both criteria must be true"
 . W !,?3,"O = Either criteria must be true"
FIND4 S COL2=$$FINDCOL() I COL2="" G FIND6
FIND5 S CHAR2=$$FINDCHR() I CHAR2="" G FIND4
FIND6 F I=1:1 Q:'$D(^TMP("VEE","K",$J,I))  S DATA=^(I) D  ;
 . I DATA[$C(9) S DATA=$P(DATA,$C(9),2,999)
 . I AND="",$P(DATA,"|",COL1)'[CHAR1 Q
 . I AND="A",$P(DATA,"|",COL1)'[CHAR1!($P(DATA,"|",COL2)'[CHAR2) Q
 . I AND="O",$P(DATA,"|",COL1)'[CHAR1&($P(DATA,"|",COL2)'[CHAR2) Q
 . I MODE="+" D SET(I) Q
 . KILL ^TMP("VPE","SELECT",$J,I) ;Clear tag
 D REDRAW^%ZVEMKT2()
 Q
 ;
FINDCOL() ;Get column #
 NEW COL
 W !!,"Look in which column?"
FINDCOL1 W !,"Enter COLUMN: "
 R COL:300 S:'$T COL="" I "^"[COL Q ""
 S COL=COL\1
 I COL<1 W "   Enter a valid column number." G FINDCOL1
 Q COL
 ;
FINDCHR() ;Get characters
 NEW CHAR
 W !!,"Look for what characters?"
FINDCHR1 W !,"Enter CHARACTERS: "
 R CHAR:300 S:'$T CHAR="" I "^"[CHAR Q ""
 I CHAR["?" W "   Enter characters to look for." G FINDCHR1
 Q CHAR
 ;
SET(VAL) ;Set "tagged" array. VAL=Line number
 Q:'$D(^TMP("VEE","K",$J,VAL))  Q:^(VAL)=" <> <> <>"
 S ^TMP("VPE","SELECT",$J,VAL)=^TMP("VEE","K",$J,VAL)
 Q
 ;====================================================================
TEMPLATE ;Set pre-selected nodes
 Q:$G(TEMPLATE)']""  Q:'$D(@TEMPLATE)
 NEW SUB
 S SUB=0
 F  S SUB=$O(@TEMPLATE@(SUB)) Q:'SUB  D  ;
 . Q:'$D(^TMP("VEE","K",$J,SUB))
 . S ^TMP("VPE","SELECT",$J,SUB)=^TMP("VEE","K",$J,SUB)
 Q
INIT ;
 NEW HD,TOT
 S FLAGQ=0
 D INIT^%ZVEMKT Q:FLAGQ
 D INIT1^%ZVEMKT
 D INIT2^%ZVEMKT
 S @("HD=$G("_GLBHLD_",""HD""))"),HD=$E(HD,1,VEE("IOM")-10)
 D GETS^%ZVEMKTG ;...Build array. TOT will equal number of entries.
 S TOT=TOT_$S(TOT>1:" Items",1:" Item")
 S VEET("HD")=2,VEET("HD",2)=VEET("HD",1)
 S VEET("HD",1)=" Select: "_$S(HD]"":HD,1:"ITEMS")
 S VEET("FT",1)=$E(VEET("FT",1),1,VEE("IOM")-$L(TOT)-6)_TOT_$E(VEET("FT",1),1,5)
 S VEET("FT",2)="<> <SPACE>=Tag  A=TgAll  C=ClrAll  +=Fnd&Tg  -=Fnd&Clr  ?=Help  M=More"_$S($G(NEW)=1:"  N=New",1:"")
 S VEET("S1")=3,(VEET("GAP"),VEET("SL"))=VEET("S2")-VEET("S1")+1
 S VEET("H$Y")=VEET("S1")-1 ;...Highlight line $Y
 Q
