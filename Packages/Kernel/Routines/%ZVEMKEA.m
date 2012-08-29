%ZVEMKEA ;DJB,KRN**Screen Mode Line Editor ; 11/14/02 6:56am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SCREEN(PROMPT,LMAR,RMAR) ;Edit a line of text
 ;PROMPT = Prompt
 ;LMAR=Left Margin
 ;RMAR=Right Margin
 ;
 NEW DX,DY,FLAGQ,I,START,WIDTH,X,XCHAR,XCUR,YCNT,YCUR
 NEW:'$D(VEES) VEES
 ;
 S FLAGQ=0
 D INIT Q:FLAGQ
 X VEES("RM0")
 W ! D LISTCD
 D SETUP
 F  D READ Q:X="QUIT"
EX ;
 ;Reposition cursor to bottom line
 I YCUR<YCNT F I=1:1:(YCNT-YCUR) W !
 X VEES("RM80")
 Q
 ;
READ ;
 S X=$$READ^%ZVEMKRN("",1),VEESHC=$G(VEE("K"))
 I ",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VEESHC_",") S X="QUIT" Q
 I ",<AU>,<AD>,<AR>,<AL>,"[(","_VEESHC_",") D ARROW^%ZVEMKEC Q
 I ",<F1AL>,<F1AR>,<F2AL>,<F2AR>,"[(","_VEESHC_",") D OTHER^%ZVEMKEC Q
 I ",<BS>,<DEL>,"[(","_VEESHC_",") D  D DELETE^%ZVEMKEB Q
 . S:$G(VEE("BS"))="SAME" VEESHC="<BS>"
 I VEESHC?1"<".E1">".E S X="QUIT" Q
 D INSERT^%ZVEMKEB
 Q
 ;
LISTCD ;Print Code with controlled wrapping.
 NEW TEMP
 S TEMP=CD
 I TEMP?.E1C.E S TEMP=$$CC(TEMP) ;Control characters
 W ?LMAR,PROMPT
 W ?START,$E(TEMP,1,WIDTH)
 S TEMP=$E(TEMP,WIDTH+1,999)
LISTCD1 ;Print remainder of line
 I TEMP="" Q
 W !?START,$E(TEMP,1,WIDTH)
 S TEMP=$E(TEMP,WIDTH+1,999)
 G LISTCD1
 ;
SETUP ;Set up starting values.
 F YCNT=1:1 Q:$L(CD)<(YCNT*WIDTH+1)
 S XCHAR=$L(CD)+1
 S XCUR=$X
 S YCUR=YCNT
 ;
 ;If CD is exactly the screen width move the cursor to next line.
 I $L(CD)>0,$L(CD)#WIDTH=0 D  ;
 . S YCUR=YCUR+1
 . S XCUR=START
 . W ! Q:START'>0
 . W $C(27)_"["_START_"C"
 . D RESETY
 Q
 ;
CC(TXT) ;Control characters
 ;Substitute a 'c' for any control characters.
 ;
 NEW I
 I $G(TXT)']"" Q ""
 F I=1:1:$L(TXT) I $E(TXT,I)?.E1C.E D  ;
 . S TXT=$E(TXT,1,I-1)_"c"_$E(TXT,I+1,9999)
 Q TXT
 ;
RESETY ;Reset $Y
 NEW VEEY
 S VEEY=(VEE("IOSL")-1)
 S DX=0,DY=$S($Y>VEEY:VEEY,1:$Y) X VEES("XY")
 Q
 ;
INIT ;
 I '$D(VEE("OS")) D OS^%ZVEMKY Q:FLAGQ
 I '$D(VEE("IOM")) D IO^%ZVEMKY
 D SCRNVAR^%ZVEMKY2
 D CRSRMOVE^%ZVEMKY2
 D CRSRSAVE^%ZVEMKY2
 D BLANK^%ZVEMKY3
 S CD=$G(CD),PROMPT=$G(PROMPT),LMAR=$G(LMAR),RMAR=$G(RMAR)
 S:LMAR'>0!(LMAR>(VEE("IOM")-5)) LMAR=0
 S:RMAR'>LMAR!(RMAR>VEE("IOM")) RMAR=VEE("IOM")-1
 S START=LMAR+$L(PROMPT)
 S WIDTH=RMAR-START
 D RESETY
 Q
