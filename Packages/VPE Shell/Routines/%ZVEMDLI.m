%ZVEMDLI ;DJB,VEDD**Import [5/3/95 12:49pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 Q:FLAGP  D SETARRAY,LIST
 Q
 ;===================================================================
GETVEET ;Set VEET=Display text
 S VEET=$G(^TMP("VEE","ID"_VEDDS,$J,VEET("BOT")))
 Q
LIST ;Display text
 Q:'$D(^TMP("VEE","ID"_VEDDS,$J,VEET("BOT")))
 D GETVEET W !,VEET
 S VEET("BOT")=VEET("BOT")+1
 S:VEET("GAP") VEET("GAP")=VEET("GAP")-1
 S VEET("HLN")=VEET("HLN")+1
 S:VEET("H$Y")<VEET("S2") VEET("H$Y")=VEET("H$Y")+1
 I $G(FLAGSTRT)]"" D FINDCHK(1) G:$G(FLAGSTRT)]"" LIST ;Starting field
 I VEET=" <> <> <>"!'VEET("GAP") D READ Q:FLAGQ!FLAGE
 G LIST
SETARRAY ;Set scroll array - ^TMP("VEE","ID"_VEDDS
 NEW NUM S NUM=VEET("BOT")
 I $G(VEET)']""!($G(VEET)=" <> <> <>") D  Q
 . S ^TMP("VEE","ID"_VEDDS,$J,NUM)=" <> <> <>"
 S ^TMP("VEE","ID"_VEDDS,$J,NUM)=VEET
 Q
ENDFILE() ;1=End-of-file  0=Ok
 I VEET("GAP") W $C(7) Q 1
 I ^TMP("VEE","ID"_VEDDS,$J,VEET("BOT")-1)=" <> <> <>" W $C(7) Q 1
 Q 0
READ ;Get input
 I $G(FLAGFIND)]"" D FINDCHK(2) Q:$G(FLAGFIND)]""  ;Find a field
 NEW KEY,PKG
READ1 S PKG="ID"_VEDDS W @VEES("CON") ;Turn cursor back on
 D CURSOR^%ZVEMKU1(9,VEET("S2")+VEET("FT")-1,1)
 S KEY=$$READ^%ZVEMKTM(PKG) Q:KEY="QUIT"
 I KEY="<TAB>" D  ;
 . S TABHLD=VEET("HLN")_"^"_VEET("H$Y") ;Keeps highlight at same node
 . S KEY=VEET("HLN")-1,KEY=$G(^TMP("VEE",PKG,$J,"SCR",KEY))
 . S:KEY']"" KEY="***"
 I ",?,<ESCH>,D,DA,F,G,I,G,N,P,VGL,"'[(","_KEY_","),KEY'?1.N W $C(7) G READ1
 D RUN^%ZVEMDLM(KEY) Q:FLAGQ  D REDRAW^%ZVEMKT2()
 Q
FINDCHK(TYPE) ;Find a field
 ;TYPE - 1=Starting Field  2=Field Search
 NEW NAM
 I VEET=" <> <> <>" W $C(7) KILL FLAGFIND,FLAGSTRT Q
 S NAM=$G(^TMP("VEE","ID"_VEDDS,$J,"FLD",VEET("BOT")-1)) Q:NAM']""
 I $G(TYPE)=2,$E(NAM,1,$L(FLAGFIND))=FLAGFIND KILL FLAGFIND Q
 I $G(TYPE)=1,$E(NAM,1,$L(FLAGSTRT))=FLAGSTRT KILL FLAGSTRT Q
 S VEET("TOP")=VEET("TOP")+1
 Q
FINISH ;Call here AFTER calling IMPORT
 I $G(FLAGFIND)]"" W $C(7) KILL FLAGFIND
 I 'FLAGQ,'FLAGE S VEET=" <> <> <>" D SETARRAY,LIST
 D ENDSCR^%ZVEMKT2 ;Reset scroll region to full screen
 Q
