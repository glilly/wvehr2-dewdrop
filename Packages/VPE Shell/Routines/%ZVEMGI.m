%ZVEMGI ;DJB,VGL**Loop,Print,Import [2/25/99 3:19pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
TOP(ZGR) ;ZGR contains starting point, such as ^VA(200).
 NEW X S X="ERROR^%ZVEMGI1",@($$TRAP^%ZVEMKU1) KILL X
 I FLAGOPEN NEW GLB,FLAGSKIP,SKIPHLD,STK D  D:$D(@GLB(STK))#2 PRINT Q
 . S STK=1,GLB(STK)=ZGR,FLAGSKIP=0 KILL SKIPHLD
 NEW ZCHK,ZORD,GLB,FLAGSKIP,SKIPHLD,STK
 S STK=1,GLB(STK)=ZGR,ZORD(STK)="",FLAGSKIP=0 KILL SKIPHLD
LOOP ;Loop to increment and decrement STK to go up and down the subscript.
 S ZCHK=$D(@GLB(STK)) D:ZCHK#2 PRINT Q:FLAGQ!FLAGE
 I ZCHK=0 S STK=STK-1 Q:STK=0
LOOP1 ;When ZORD(STK) is null come here
 ;Convert double quotes to single quotes
 I ZORD(STK)["""""" S ZORD(STK)=$$QUOTES1^%ZVEMKU(ZORD(STK))
 S ZORD(STK)=$O(@GLB(STK)@(ZORD(STK)))
 I ZORD(STK)="" S STK=STK-1 Q:STK=0  G LOOP1
 ;Convert single quotes to double quotes
 I ZORD(STK)["""" S ZORD(STK)=$$QUOTES2^%ZVEMKU(ZORD(STK))
 I GLB(STK)?.E1")" S VEEX=$E(GLB(STK),1,$L(GLB(STK))-1)_","""_ZORD(STK)_""")",STK=STK+1,ZORD(STK)="",GLB(STK)=VEEX G LOOP
 S VEEX=ZGL_"("""_ZORD(STK)_""")",STK=STK+1,GLB(STK)=VEEX,ZORD(STK)=""
 G LOOP
 ;==================================================================
PRINT ;Print a single node
 ;Next line: restrict levels because user entered commas.
 I FLAGC S SUBCHK=$$ZDELIM^%ZVEMGU(GLB(STK)) Q:FLAGC1="NP"&($L(SUBCHK,ZDELIM)<FLAGC)  Q:FLAGC1="P"&($L(SUBCHK,ZDELIM)'=FLAGC)
 I VEET("STATUS")'["START" D IMPORTS^%ZVEMKT("IG"_GLS) S $P(VEET("STATUS"),"^",1)="START"
 S GLNAM=GLB(STK),GL=$P(GLNAM,"("),GLVAL=@GLB(STK)
 S GLSUB=$P($E(GLNAM,1,$L(GLNAM)-1),"(",2,99)
 ;Next strip quotes from numeric subscripts.
 F I=1:1 S VEEX=$P(GLSUB,",",I) Q:VEEX=""  D
 . I VEEX?1"""".E1"""",VEEX'["E",VEEX'["e" D
 . . S VEEX=$E(VEEX,2,$L(VEEX)-1) I +VEEX=VEEX S $P(GLSUB,",",I)=VEEX
 I GLSUB]"" S GLNAM=GL_"("_GLSUB_")"
 I CODE'=0 X CODE E  R VEEX#1:0 Q:'$T  D  Q
 . S CODE=0,$P(VEET("STATUS"),"^",4)="" ;Hit any key to quit
 S ^TMP("VEE","VGL"_GLS,$J,ZREF)=GLNAM
 I $G(VGLREV) S GLNAM("REV")=$$GLOBNAME^%ZVEMGI1(GLNAM)
 S VEET=GLNAM D SETARRAY,LIST
 S ZREF=ZREF+1
 Q
 ;====================[ IMPORT TO SCROLLER ]=========================
GETVEET ;Set VEET=Display text
 S VEET=$G(^TMP("VEE","IG"_GLS,$J,VEET("BOT")))
 Q
LIST ;Display text
 Q:'$D(^TMP("VEE","IG"_GLS,$J,VEET("BOT")))  D GETVEET
 I VEET[$C(127) D REVERSE^%ZVEMGI1(VEET) I 1
 E  W !,VEET
 S VEET("BOT")=VEET("BOT")+1
 S:VEET("GAP") VEET("GAP")=VEET("GAP")-1
 S VEET("HLN")=VEET("HLN")+1
 S:VEET("H$Y")<VEET("S2") VEET("H$Y")=VEET("H$Y")+1
 I VEET=" <> <> <>"!'VEET("GAP") D READ^%ZVEMGM Q:FLAGQ!FLAGE
 G LIST
SETARRAY ;Set scroll array - ^TMP("VEE","IG"_GLS,$J
 NEW LN,NUM,SP,VAL
 S NUM=VEET("BOT"),VEET=$G(VEET)
 I VEET']""!(VEET=" <> <> <>") D  Q
 . S ^TMP("VEE","IG"_GLS,$J,NUM)=" <> <> <>"
 ;Next line tracks what scroll nodes are associated to what VGL nodes.
 S ^TMP("VEE","IG"_GLS,$J,"SCR",NUM)=ZREF
 S @("LN="_VEET)
 I LN?.E1C.E S LN=$$CC(LN) ;Control characters
 S SP=$J(ZREF,3)_") "_$S('$G(VGLREV):VEET,1:GLNAM("REV"))
 S LN=SP_" = "_LN,SP=$L(SP)
 F NUM=NUM:1 D  Q:LN']""
 . S VAL=$E(LN,1,VEE("IOM")-1)
 . S ^TMP("VEE","IG"_GLS,$J,NUM)=VAL
 . S LN=$E(LN,VEE("IOM"),999) Q:LN']""
 . I $L(VEET)<40 S LN=$J("",SP)_" = "_LN Q
 . I NUM=VEET("BOT"),($L(VEET)+10)>VEE("IOM") S LN="          "_LN Q
 . S LN="          = "_LN
 Q
CC(TXT) ;Display control characters
 ;Example: replace $C(9) with /009.
 NEW I,TXT1,VAL
 I $G(TXT)']"" Q ""
 S TXT1=TXT,TXT=""
 F I=1:1:$L(TXT1) S VAL=$A($E(TXT1,I)) D  ;
 . I VAL>31 S TXT=TXT_$C(VAL) Q
 . S TXT=TXT_"/"_$E("000",1,3-$L(VAL))_VAL
 Q TXT
FINISH ;Call here AFTER calling IMPORT
 Q:$G(VEET("STATUS"))'["START"  S $P(VEET("STATUS"),"^",2)="FINISH"
 ;Next terminate any Code Search
 S $P(VEET("STATUS"),"^",4)="" I CODE'=0 W $C(7),$C(7) S CODE=0
 I $G(FLAGSKIP) W $C(7) S FLAGSKIP=0 KILL SKIPHLD ;Turn off node skip
 I 'FLAGQ,'FLAGE S VEET=" <> <> <>" D SETARRAY,LIST
 D ENDSCR^%ZVEMKT2 ;Reset scroll region to full screen
 Q
