%ZVEMKC ;DJB,KRN**Select Choices ; 12/20/00 8:23am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
CHOICE(OPTIONS,LEV,DX,DY) ;
 ;;OPTIONS=String containing options. Ex: "YES^NO"
 ;;LEV=Number of option to be highlighted
 ;;DX,DY=Pass DX&DY to place prompts on the screen
 ;
 I $G(OPTIONS)']"" Q 0
 NEW ALLCAPS,ANS,FLAGQ,I,LIMIT,PIECE,VEES,X
 S FLAGQ=0 D INIT Q:FLAGQ
 D LOCATION
 X VEES("RM0")
 W @VEES("COFF")
 D LOOP
 W @VEES("CON")
 Q LEV
 ;
LOCATION ;Starting location for each piece
 F I=1:1 S X=$P(OPTIONS,"^",I) Q:X=""  D
 . S PIECE(I)=X
 . S ALLCAPS(I)=$$ALLCAPS^%ZVEMKU(X)
 . I I=1 S DX(I)=(DX+2) Q
 . S DX(I)=(DX(I-1)+$L(PIECE(I-1))+2)
 S LIMIT=(I-1)
 Q
 ;
LOOP ;Get users response
 D DRAW
 S ANS=$$READ^%ZVEMKRN("",1,1)
 I VEE("K")="<RET>" Q
 I ANS="^"!(",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VEE("K")_",")) S LEV=0 Q
 I VEE("K")="<AL>" S LEV=LEV-1 S:LEV<1 LEV=1 G LOOP
 I VEE("K")="<AR>" S LEV=LEV+1 S:LEV>LIMIT LEV=LIMIT G LOOP
 I ANS=" " S LEV=LEV+1 S:LEV>LIMIT LEV=1 G LOOP
 S ANS=$$ALLCAPS^%ZVEMKU(ANS)
 F I=1:1:LIMIT I I'=LEV,ANS=$E(ALLCAPS(I),1) S LEV=I Q
 G LOOP
 ;
DRAW ;Display options
 F I=1:1:LIMIT S DX=DX(I) X VEES("CRSR") D  ;
 . I I=LEV W @VEE("RON") X VEES("XY")
 . W PIECE(I) W:I=LEV @VEE("ROFF")
 Q
 ;
INIT ;
 NEW L,TMP
 I '$D(VEE("OS")) D OS^%ZVEMKY Q:FLAGQ
 D SCRNVAR^%ZVEMKY2
 D REVVID^%ZVEMKY2
 D CRSROFF^%ZVEMKY2
 S:$G(LEV)'>0 LEV=1
 S L=$L(OPTIONS)+(2*$L(OPTIONS,"^"))-(1*($L(OPTIONS,"^")-1))
 S L=VEE("IOM")-1-L
 I $G(DX)>0 S:DX>L DX=0 I 1
 E  S DX=$S($X>L:0,1:$X)
 S TMP=$S($G(VEE("IOSL")):(VEE("IOSL")-1),1:23)
 I $G(DY)>0 S:DY>TMP DY=TMP I 1
 E  S DY=$S($Y>TMP:TMP,1:$Y)
 Q
 ;
PAUSE(LF) ;LF=# of line feeds
 NEW X
 F X=1:1:+$G(LF) W !
 S X=$$CHOICE("<RETURN>",1)
 Q
 ;
PAUSEQ(LF) ;LF=# of line feeds
 NEW X
 F X=1:1:+$G(LF) W !
 S:$$CHOICE("CONTINUE^QUIT",1)'=1 FLAGQ=1
 Q
 ;
PAUSEQE(LF) ;LF=# of line feeds
 NEW X
 F X=1:1:+$G(LF) W !
 S X=$$CHOICE("CONTINUE^QUIT^EXIT",1)
 S:X'=1 FLAGQ=1
 S:X=3 FLAGE=1
 Q
