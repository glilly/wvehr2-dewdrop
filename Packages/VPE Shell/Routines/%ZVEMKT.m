%ZVEMKT ;DJB,KRN**Txt Scroll-Start ; 11/16/00 8:14am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
IMPORT ;Display imported text passed in variable VEET
 NEW X S X="ERROR^%ZVEMKT2",@$S($D(^%ZOSF("TRAP")):^("TRAP"),1:"$ZT=X") KILL X ;Keep this local for speed.
 X VEET("GET")
 D LIST^%ZVEMKT1
 Q
 ;
IMPORTS(PKG) ;START - Call here BEFORE calling IMPORT
 ;PKG=Calling package (G=VGL).
 NEW TYPE
 S TYPE="I"
 KILL ^TMP("VEE",PKG,$J)
 S FLAGQ=0
 D INIT Q:FLAGQ  D INIT1,INIT2
 S VEET("IMPORT")="YES"
 D SCROLL^%ZVEMKT2()
 Q
 ;
IMPORTF ;FINISH - Call here AFTER calling IMPORT
 G:'$D(VEET) EX
 I '$G(FLAGQ) S VEET=" <> <> <>" D IMPORT
 D ENDSCR^%ZVEMKT2
 G EX
 ;====================================================================
GLB(GLB,VEEMODE,VEEPAGE) ;Display a global
 ;GLB=Global. Example: ^VA(200)
 ;VEEMODE="SC"    Display without scrolling (for screen capture).
 ;VEEPAGE=Number  Used when VEEMODE="SC".
 ;                Pause after that many nodes display.
 I $G(GLB)']"" D  Q
 . W !?1,"You must include a global reference..",!
 D  Q:GLB=""
 . NEW X S X="ERROR^%ZVEMKT",@($$TRAP^%ZVEMKU1) KILL X
 . I GLB["(",$E(GLB,$L(GLB))'=")" S GLB=GLB_")"
 . I '$D(@(GLB)) S GLB="" ;Check for valid glb
 NEW GLBHLD,TYPE
 S GLBHLD=$P(GLB,")",1)
 S TYPE="G"
 I GLBHLD?1"^[".E S GLBHLD="^"_$P(GLBHLD,"]",2)
 I GLBHLD?1"^|".E S GLBHLD="^"_$P(GLBHLD,"|",3)
 G TOP
 ;
RTN(RTN,TAG) ;;RTN=Routine,TAG=LineTag
 ;;If TAG, use Help text format. TYPE=R..Routine  TYPE=H..Help text
 I $G(RTN)["^" F  S RTN=$P(RTN,"^",2,99) Q:RTN'["^"
 Q:$G(RTN)']""
 Q:'$$EXIST^%ZVEMKU(RTN)
 NEW TYPE
 S TYPE="R",TAG=$G(TAG)
 I TAG]"" S TYPE="H"
 G TOP
 ;
VERSION(IEN) ;;Display a routine from the Version file.
 ;;IEN to file 19200.112
 Q:'$G(IEN)
 Q:'$D(^VEE(19200.112,IEN,"WP"))
 NEW GLB,TYPE
 S TYPE="V"
 S GLB="^VEE(19200.112,"_IEN_",""WP"",0)"
 G TOP
 ;
HELP(GLB) ;;GLB=Help text title for VPE VShell. Example: DIE
 Q:$G(GLB)']""
 S GLB="^%ZVEMS(""ZZ"","""_GLB_""")"
 D  Q:GLB=""  ;Check for valid global
 . NEW X S X="ERROR^%ZVEMKT",@($$TRAP^%ZVEMKU1) KILL X
 . I '$D(@(GLB)) S GLB=""
 NEW GLBHLD,TYPE
 S GLBHLD=$P(GLB,")",1)
 S TYPE="G"
 G TOP
 ;
LIST(GLB,FM) ;;Generic Lister.
 ;GLB=Global containing choices.
 ;FM=1 if you want to list a Fileman word processing field.
 ;   Example: D LIST^%ZVEMKT("^VEE(19200.114,2,""WP"",0)")
 ;                   NOTE--Always reference zero node ^
 Q:$G(GLB)']""
 Q:GLB'?1.E1"("1.E1")"
 D  Q:GLB=""  ;Check for valid global
 . NEW X S X="ERROR^%ZVEMKT",@($$TRAP^%ZVEMKU1) KILL X
 . I '$D(@(GLB)) S GLB=""
 NEW GLBHLD,TYPE
 S GLBHLD=$P(GLB,")",1)
 S TYPE="L"
 I $G(FM) S GLBHLD=$P(GLBHLD,",",1,$L(GLBHLD,",")-1)
 G TOP
 ;
SELECT(GLB,NUMBER,NEW,TEMPLATE) ;;Generic Selector.
 ;GLB.....: Global containing choices.
 ;NUMBER..: If 1, number each line.
 ;NEW.....: If 1, allow adding new entry
 ;TEMPLATE: Array of preselected nodes
 ;
 Q:$G(GLB)']""
 Q:GLB'?1.E1"("1.E1")"
 D  Q:GLB=""  ;Error trap to check if valid global
 . NEW X S X="ERROR^%ZVEMKT",@($$TRAP^%ZVEMKU1) KILL X
 . I '$D(@(GLB)) S GLB=""
 NEW GLBHLD,TYPE
 S GLBHLD=$P(GLB,")",1)
 S TYPE="S"
 G TOP^%ZVEMKTS
 ;====================================================================
TOP ;
 NEW X S X="ERROR^%ZVEMKT2",@($$TRAP^%ZVEMKU1) KILL X
 NEW DX,DY,FLAGQ,VEET
 NEW:'$D(VEE) VEE
 NEW:'$D(VEES) VEES
 KILL ^TMP("VEE","K",$J) ;"K" for VPE Kernel rtn
 S FLAGQ=0
 D INIT G:FLAGQ EX D INIT1,INIT2
 I $G(VEEMODE)="SC" W @VEE("IOF") D LISTSC^%ZVEMKT1 G EX
 W @VEE("IOF") D SCROLL^%ZVEMKT2()
 D LIST^%ZVEMKT1,ENDSCR^%ZVEMKT2
EX ;
 KILL ^TMP("VEE","K",$J)
 Q
 ;
INIT ;Screen variables
 I '$D(VEE("OS")) D OS^%ZVEMKY Q:FLAGQ
 D IO^%ZVEMKY
 D REVVID^%ZVEMKY2
 D SCRNVAR^%ZVEMKY2
 D BLANK^%ZVEMKY3
 D CRSROFF^%ZVEMKY2
 D SCRL^%ZVEMKY2
 Q
 ;
INIT1 ;Scroll area, Header, Footer
 NEW LINE,MAR
 S MAR=$G(VEE("IOM")) S:MAR'>0 MAR=80
 S $P(LINE,"=",MAR)=""
 S:'$D(VEET("S1")) VEET("S1")=2 ;S1 to S2 is the scroll region
 S:'$D(VEET("S2")) VEET("S2")=(VEE("IOSL")-2)
 I '$D(VEET("HD")) S VEET("HD")=1,VEET("HD",1)=LINE ;Header
 I '$D(VEET("FT")) S VEET("FT")=2 D  ;Footer
 . S VEET("FT",1)=LINE,VEET("FT",2)="<>  <ESC>H=ScrollHelp  F=Find  L=Locate"
 S:'$D(VEET("GET")) VEET("GET")="D GET"_TYPE_"^%ZVEMKTG"
 KILL TYPE
 Q
 ;
INIT2 ;Scroller variables
 S (VEET("GAP"),VEET("SL"))=VEET("S2")-VEET("S1")+1
 S (VEET("BOT"),VEET("LNCNT"),VEET("TOP"))=1
 S VEET("HLN")=1 ;Highlight line #
 S VEET("H$Y")=VEET("S1")-1 ;Highlight line $Y
 Q
 ;
ERROR ;
 S GLB=""
 W $C(7),!?1,"Invalid global reference..",!
 Q
