%ZVEMKU ;DJB,KRN**General Utilities [1/13/96 10:40pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
ASK(PROMPT,DEFAULT) ;Return: Y=YES, N=NO
 ;PROMPT=Display prompt, DEFAULT= 1-YES, 2-NO
 NEW YN
 S DEFAULT=$S($G(DEFAULT)=2:"NO",1:"YES")
ASK1 W !,$G(PROMPT),"? "_DEFAULT_"// "
 R YN:300 S:'$T YN="^" S:YN="" YN=DEFAULT I YN="^" Q YN
 S YN=$$ALLCAPS($E(YN,1))
 I "YN"'[YN W "   Y=YES  N=NO" G ASK1
 Q YN
FILEMAN() ;Does Fileman exist? YES=1 NO=0
 I '$D(^DIC)!('$D(^DD)) Q 0
 Q 1
EXIST(X) ;X=Rtn...0=Routine doesn't exist, 1=Routine exists
 I $G(X)']"" Q 0
 S:X["^" X=$P(X,"^",2) S:X["(" X=$P(X,"(",1)
 I X'?1A.7AN,X'?1"%"1A.6AN Q 0
 NEW FLAGQ,VEES S FLAGQ=0
 D:'$D(VEE("OS")) OS^%ZVEMKY I FLAGQ Q 0
 D EXIST^%ZVEMKY1
 I "8,16"[VEE("OS"),$E(X)="%",@("$T(^"_X_")]""""") Q 1
 X VEES("EXIST") E  Q 0
 Q 1
ID ;Get DUZ
 I $D(^XUSEC(0)) D  Q  ;KERNEL loaded
 . W !!,"------------------------------------------"
 . W !,"Your DUZ isn't defined. I'm calling ^XUP."
 . W !,"------------------------------------------",!
 . I $G(VEESHL)'="RUN" D ^XUP Q  ;Shell not running
 . D ^XUP S VEESHL="RUN" X ^%ZVEMS("ZS",3) ;Reset Shell variables
 S DUZ=0,DUZ(0)=$S($G(DUZ(0))]"":DUZ(0),1:"@")
 Q
ALLCAPS(TXT) ;
 I $G(TXT)']"" Q ""
 S TXT=$TR(TXT,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q TXT
KILLCHK(CODE) ;Check for any exclusive KILLs
 Q:$G(CODE)']""  NEW CHK,I,X
 S CODE=$$ALLCAPS(CODE) Q:CODE'?.E1"K".E1"^".E  S CHK=0,X=""
 F I=1:1:$L(CODE," ") S X=$P(CODE," ",I) I X["^",$P(CODE," ",I-1)["K" S CHK=1 Q
 Q:'CHK  W $C(7),!!?3,"WARNING: Your code may be killing a global."
 I $G(FLAGG)="GLB" D KILLCHK1 Q
 D PAUSE^%ZVEMKU(1)
 Q
KILLCHK1 ;KILLCHK called by ^%ZVEMS global
 NEW ANS,DEF
 S DEF=$S($G(^%ZVEMS("PARAM",VEE("ID"),"WARN"))]"":^("WARN"),1:"NO")
 W !?3,"Should I execute your code: ",DEF,"// "
 R ANS:600 S:'$T ANS="N" S:ANS="" ANS=DEF S ANS=$E(ANS)
 I "^YyNn"'[ANS W "   Y=Yes  N=No" G KILLCHK1
 Q:"Yy"[ANS  S VEESHC="" W !!?3,"Code not executed..."
 Q
QUOTES1(X) ;If X contains double quotes, convert to single quotes.
 I $G(X)']"" Q ""
 I X'["""""" Q X
 NEW I,LINE S LINE=""
 F I=1:1:$L(X,"""""") S LINE=LINE_$P(X,"""""",I)_$S(I'=$L(X,""""""):"""",1:"")
 Q LINE
QUOTES2(X) ;If X contains quotes, convert to double quotes.
 I $G(X)']"" Q ""
 I X'["""" Q X
 NEW CNT S CNT=0
 F  S CNT=CNT+1 Q:$E(X,CNT)=""  I $E(X,CNT)="""" S X=$E(X,1,CNT-1)_""""""_$E(X,CNT+1,999),CNT=CNT+1
 Q X
PAUSE(LF,TYPE) ;May return FLAGQ/FLAGE
 ;LF=# of linefeeds
 ;TYPE=P/Q/QE  P=Pause Q=PauseQuit QE=PauseQuitExit
 I $G(TYPE)']"" S TYPE="P"
 I $G(VEE("TIME"))'>0 D TIME^%ZVEMKY
 NEW XX F XX=1:1:+$G(LF) W !
 I TYPE="P" D  Q
 . R ?1,"<RETURN> to continue..",XX:VEE("TIME")
 I TYPE="Q" D  Q
 . W ?1,"<RETURN> to continue, '^' to quit: "
 . R XX:VEE("TIME") S:'$T XX="^" I XX["^" S FLAGQ=1
 I TYPE="QE" D  Q
 . W ?1,"<RETURN> to continue, '^' to quit, '^^' to exit: "
 . R XX:VEE("TIME") S:'$T XX="^" I XX["^" S FLAGQ=1 S:XX="^^" FLAGE=1
 Q
