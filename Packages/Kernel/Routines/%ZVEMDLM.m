%ZVEMDLM ;DJB,VEDD**Menu,Find,Goto [11/25/95 12:22pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
RUN(Z1) ;
 I Z1?1.N D INDFLD Q
 I Z1="DA" D ^%ZVEMDLD Q
 I Z1="F" D FIND Q
 I Z1="G" D GOTO Q
 I Z1="P" D ^%ZVEMDLB Q
 D ENDSCR^%ZVEMKT2
 I Z1="<ESCH>" D HELP^%ZVEMKT2 Q
 I Z1="?" D HELP^%ZVEMKT("VEDD2") Q
 I Z1="I" D ^%ZVEMDI S FLAGQ=0 Q
 I Z1="N" D ^%ZVEMDN Q
 I Z1="VGL" D VGL2^%ZVEMDY Q
 Q
INDFLD ;Print Indiv Fld DD
 NEW FILE,FLAGQ,FNUM
 I '$D(^TMP("VEE","VEDD"_VEDDS,$J,Z1)) D MSG^%ZVEMDUM(4,1) Q
 D ENDSCR^%ZVEMKT2
 S FILE=$P(^TMP("VEE","VEDD"_VEDDS,$J,Z1),U)
 S FNUM=$P(^(Z1),U,2)
 S FLAGQ=0 D INDIV^%ZVEMKI1(FILE,FNUM) Q:FLAGQ  D PAUSE^%ZVEMKC(1)
 Q
FIND ;Find a field. Return FLAGFIND if search is valid
 R "   Enter FIELD NAME: ",FLAGFIND:VEE("TIME")
 S:'$T FLAGFIND="^" I "^"[FLAGFIND KILL FLAGFIND Q
 I "??"[FLAGFIND D MSG^%ZVEMDUM(5) G FIND
 I $L(FLAGFIND)>30!(FLAGFIND["""")!(FLAGFIND["=") D MSG^%ZVEMDUM(6) G FIND
 Q
GOTO ;Goto line number
 NEW ND,PKG,X S PKG="ID"_VEDDS
 S ND=$$GETREF^%ZVEMKTR(PKG) Q:ND="^"
 I ND="***" W $C(7) Q
 I '$D(^TMP("VEE","VEDD"_VEDDS,$J,ND)) D  Q:ND'>0
 . S ND=$O(^TMP("VEE","VEDD"_VEDDS,$J,ND)) Q:ND>0
 . S ND=$O(^TMP("VEE","VEDD"_VEDDS,$J,ND),-1)
 S VEET("TOP")=$$GETSCR^%ZVEMKTR(ND,PKG)
 Q
