%ZVEMGP ;DJB,VGL**PIECES - Display Global Pieces [12/19/96 7:19am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
TOP ;FLAGTYPE="IorX^SWITCH" when switching between Int or eXt views
 NEW X S X="ERROR^%ZVEMGP",@($$TRAP^%ZVEMKU1) KILL X
 NEW DD,DOTS,FLAGQ,FLAGTYPE,GLVAL,GLVAL1,KEY,NODE,SPACE
 S DOTS=".........................................."
 D GETNODE Q:'$D(^DD(DD,"GL",NODE))
 S FLAGQ=0,FLAGTYPE="I",GLVAL=@GLNAM
LOOP S GLVAL=@GLNAM,FLAGTYPE=$P(FLAGTYPE,U,1)
 D LIST(FLAGTYPE)
 I '$D(GLS) S GLS=$G(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"GLS"))
 Q:FLAGQ!FLAGE
 G LOOP
LIST(TYPE) ;List pieces. TYPE="I" (internal values),TYPE="X" (External values)
 S:$G(TYPE)']"" TYPE="I"
 NEW FNUM,I,PC,PCNT
 NEW DX,DY,VEET NEW:'$D(VEES) VEES
 D START^%ZVEMGPI
 S PC=$O(^DD(DD,"GL",NODE,"")) I PC["E" D MUMPS Q  ;MUMPS fld typ
 S (PCNT,PC)=0 F  S PC=$O(^DD(DD,"GL",NODE,PC)) Q:PC=""  S PCNT=PC
 F PC=1:1:PCNT S VEEX=".) " D  Q:FLAGTYPE["SWITCH"!FLAGQ!FLAGE
 . I $D(^DD(DD,"GL",NODE,PC)) D  ;
 . . S FNUM=$O(^DD(DD,"GL",NODE,PC,""))  Q:'FNUM
 . . Q:'$D(^DD(DD,FNUM,0))  I $P(^(0),U,2)["S" S VEEX="s) " Q
 . . Q:$P(^(0),U,2)'["P"  S VEEX="p) " Q:TYPE'="X"
 . . I $P(GLVAL,U,PC)]"",+$P(GLVAL,U,PC)'=$P(GLVAL,U,PC) D
 . . . S $P(GLVAL,U,PC)="--> *Bad Pointer*"
 . . Q
 . S VEEX=$J(PC,3)_VEEX
 . I TYPE="X",$G(FNUM)]"",$P(GLVAL,U,PC)'["*Bad Pointer*" D  Q:FLAGQ
 . . NEW X S X="ERROR1^%ZVEMGP",@($$TRAP^%ZVEMKU1) KILL X
 . . NEW C,I,Y S Y=$P(GLVAL,U,PC) Q:'$D(^DD(DD,FNUM,0))
 . . S C=$P(^(0),U,2) D Y^DIQ S $P(GLVAL,U,PC)=Y
 . S VEET=$$GETNAME(PC) S VEET=VEET_$E(DOTS,1,26-$L(VEET))_VEEX
 . S SPACE=$L(VEET),GLVAL1=$P(GLVAL,U,PC),VEET=VEET_$E(GLVAL1,1,46)
 . D IMPORT^%ZVEMGPI Q:FLAGQ!FLAGE
 . F  S GLVAL1=$E(GLVAL1,47,999) Q:GLVAL1=""  D  Q:FLAGQ
 . . S VEET=$J("",SPACE)_$E(GLVAL1,1,46) D IMPORT^%ZVEMGPI
 I FLAGTYPE["SWITCH" Q  ;Switching between Int & Ext display.
 D FINISH^%ZVEMGPI
 Q
GETNODE ;Returns DD & NODE
 NEW TMP S TMP=""
 I $L(SUBCHK,ZDELIM)>2 F I=1:1:$L(SUBCHK,ZDELIM)-2 D
 . S TMP=TMP_$P(SUBCHK,ZDELIM,I)_","
 S TMP=GL_"("_TMP_"0)",DD=+$P(@TMP,U,2) ;Use + to strip off alpha
 S NODE=$P(SUBCHK,ZDELIM,$L(SUBCHK,ZDELIM))
 I +NODE'=NODE S NODE=$E(NODE,2,$L(NODE)-1) ;If alpha, strip quotes.
 Q
GETNAME(PIECE) ;Get field name
 NEW ERR,NAM S ERR="       *Not in use*       "
 I $G(PIECE)']"" Q ERR
 I '$D(^DD(DD,"GL",NODE,PIECE)) Q ERR
 S NAM=$O(^DD(DD,"GL",NODE,PIECE,""))
 I NAM,$D(^DD(DD,NAM,0)) S NAM=$P(^(0),U) I NAM]"" Q $E(NAM,1,25)
 Q ERR
MUMPS ;MUMPS data type
 S VEEX="  1.) "
 S VEET=$$GETNAME(PC) S VEET=VEET_$E(DOTS,1,25-$L(VEET))_VEEX
 S SPACE=$L(VEET),GLVAL1=GLVAL,VEET=VEET_$E(GLVAL1,1,46)
 D IMPORT^%ZVEMGPI Q:FLAGQ
 F  S GLVAL1=$E(GLVAL1,47,999) Q:GLVAL1=""  D  Q:FLAGQ
 . S VEET=$J("",SPACE)_$E(GLVAL1,1,46) D IMPORT^%ZVEMGPI
 I 'FLAGQ D FINISH^%ZVEMGPI
 Q
INDIV(PIECE) ;Print indiv fld sum
 Q:$G(PIECE)']""  NEW FLAGQ,FNUM,PC S FLAGQ=0
 I PIECE=1,$O(^DD(DD,"GL",NODE,""))["E" D  ;MUMPS data type
 . S PIECE=$O(^DD(DD,"GL",NODE,""))
 I '$D(^DD(DD,"GL",NODE,PIECE)) D MSG Q
 S FNUM=$O(^DD(DD,"GL",NODE,PIECE,0))
 I FNUM']"" D MSG Q
 D INDIV^%ZVEMKI1(DD,FNUM) I 'FLAGQ D PAUSE^%ZVEMKC(1)
 Q
MSG ;Display message if field is not viewable or no longer in use.
 W $C(7),"   This field is not viewable, or is no longer in use."
 D PAUSE^%ZVEMKC(2)
 Q
ERROR ;
 D ENDSCR^%ZVEMKT2 KILL ^TMP("VEE",$J,"IGP")
 D ERRMSG^%ZVEMKU1("Piece/VGL"),PAUSE^%ZVEMKU(2)
 Q
ERROR1 ;Trap error in Y^DIQ. Error is caused by the ^DD containing a
 ;reference to D0 which is undefined.
 S FLAGQ=1
 D ENDSCR^%ZVEMKT2 KILL ^TMP("VEE",$J,"IGP")
 W $C(7)
 W !?1,"FM's Y^DIQ call has encountered an error. This is usually"
 W !?1,"caused by references to D0 in the data dictionary of the"
 W !?1,"global you are viewing. D0 is not defined with this call."
 D PAUSE^%ZVEMKU(2)
 Q
