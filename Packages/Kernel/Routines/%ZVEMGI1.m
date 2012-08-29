%ZVEMGI1 ;DJB,VGL**Reverse Video,Set variables,Error ; 11/14/02 7:10am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
GLOBNAME(GLOB) ;Write Global name with variable subscripts in reverse video.
 I GLOB'?.E1"(".E Q GLOB
 NEW FLAGT,FLAGT1,NAME
 D SUBSET(GLOB) S NAME=GL_"("
 ;Next: FLAGT set to stop printing reverse video after a Xref.
 S FLAGT=0 F I=1:1:$L(SUBCHK,ZDELIM) S FLAGT1=0 D
 . I SUBNUM="Y",I#2=0 D SET
 . I SUBNUM="N",I#2 D SET
 . S NAME=NAME_$P(SUBCHK,ZDELIM,I) I FLAGT1 S NAME=NAME_$C(127)
 . S NAME=NAME_$S(I=$L(SUBCHK,ZDELIM):")",1:",")
 Q NAME
SET ;
 S:+$P(SUBCHK,ZDELIM,I)=0 FLAGT=1
 I 'FLAGT S NAME=NAME_$C(127) S FLAGT1=1
 Q
SUBSET(GLOB) ;Set up variables GL,GLNAM,GLSUB,SUBCHK,SUBNUM.
 ;SUBNUM="Y" if Global root is numeric [Ex ^VA(200 ].
 ;SUBNUM="N" if Global root is NOT numeric [Ex ^DPT( ].
 NEW PIECE1,TEMP,X,Y
 Q:$G(GLOB)=""  S GLNAM=GLOB
 S GL=$P(GLNAM,"("),GLSUB=$P($E(GLOB,1,$L(GLOB)-1),"(",2,99)
 S SUBCHK=$$ZDELIM^%ZVEMGU(GLOB) ;replace commas with ZDELIM
 ;Next determine if file has a numeric root.
 S SUBNUM="NOFM" I GL="^DIA" Q
 S PIECE1=$P(SUBCHK,ZDELIM,1)
 S TEMP=GL_"("_PIECE1_",0)" I $D(@TEMP)#2 D
 . S X=$P(@TEMP,U) Q:X']""  I '$D(^DIC("B",X)) D  Q:'$D(^DIC("B",X))
 . . ;Allow for subscripts which are longer than 30 characters
 . . Q:$L(X)<31
 . . F  S X=$E(X,1,$L(X)-1) Q:$L(X)<31!($D(^DIC("B",X)))
 . I GL'="^DIC" S SUBNUM="Y" Q
 . S Y=$O(^DIC("B",X,0)) I Y'>0 S SUBNUM="DIC" Q  ;Invalid ^DIC node
 . I $G(^DIC(Y,0,"GL"))=(GL_"("_PIECE1_",") S SUBNUM="Y" Q
 . S SUBNUM="DIC"
 . Q
 Q:SUBNUM'="NOFM"
 S TEMP=GL_"(0)" I $D(@TEMP)#2 D
 . S X=$P(@TEMP,U) Q:X']""  I $D(^DIC("B",X)) S SUBNUM="N" Q
 . D  S:$D(^DIC("B",X)) SUBNUM="N"
 . . Q:$L(X)<31
 . . F  S X=$E(X,1,$L(X)-1) Q:$L(X)<31!($D(^DIC("B",X)))
 Q
REVERSE(TXT) ;Display subscript in reverse video
 ;TXT=Text to be displayed
 W ! I TXT'[$C(127) W TXT Q
 NEW DX,DY,D,L,PC,VEEY
 S VEEY=(VEE("IOSL")-1)
 S D=$C(127),L=$L(TXT,D)
 F PC=1:1:L D  ;
 . I (PC#2) W $P(TXT,D,PC) D  Q
 . . Q:PC'<L
 . . S DX=$X,DY=$S($Y>VEEY:VEEY,1:$Y)
 . . W @VEE("RON") X VEES("XY") W " "
 . W $P(TXT,D,PC)_" "
 . S DX=$X,DY=$S($Y>VEEY:VEEY,1:$Y) W @VEE("ROFF") X VEES("XY") Q
 Q
 ;====================================================================
ERROR ;Error trap.
 ;VEET("STATUS") - Don't display "No data" with <PROT> errors.
 NEW ZE
 S @("ZE="_VEE("$ZE"))
 I $G(VEET("STATUS"))["START" D ENDSCR^%ZVEMKT2 I 1
 E  S $P(VEET("STATUS"),"^",5)="PROT" ;Suppress 'No Data' display
 S FLAGQ=1
 I ZE["PROT" D  D PAUSE^%ZVEMKU(1) Q
 . W $C(7),!!?1,"Access denied (global protection)"
 D ERRMSG^%ZVEMKU1("VGL/I"),PAUSE^%ZVEMKU(1)
 Q
