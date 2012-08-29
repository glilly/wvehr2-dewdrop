%ZVEMKY2 ;DJB,KRN**Screen Variables ; 4/5/03 7:47am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 ;;X VEES("CRSR"),VEES("RM0"). All others are: W @()
SCRNVAR ;Screen Variables
 I $G(VEES("RM0"))']"" D RIGHTMAR ;.........Right Margin
 I $G(VEES("XY"))']"" D XY^%ZVEMKY1 ;.......Reset $X & $Y
 Q:$G(VEES("CRSR"))]""  ;...................Position cursor
 D CRSRPOS S VEES("CRSR")=VEES("CRSR")_" "_VEES("XY")
 Q
CRSRPOS ;Position cursor
 Q:$D(VEES("CRSR"))
 I $G(IOST(0))]"",$D(^%ZIS(2,IOST(0),"XY")) S VEES("CRSR")=^("XY") Q
 S VEES("CRSR")="W $C(27)_""[""_(DY+1)_"";""_(DX+1)_""H"""
 Q
RIGHTMAR ;Right Margin
 I $D(VEES("RM0")),$D(VEES("RM80")) Q
 ;
 ;--> Default
 S (VEES("RM0"),VEES("RM80"))=""
 ;
 I VEE("OS")=8!(VEE("OS")=18) S VEES("RM0")="U $I:0"
 ;I VEE("OS")=16 S VEES("RM0")="U $I:WIDTH=0"
 I VEE("OS")=17!(VEE("OS")=19) S VEES("RM0")="U $I:WIDTH=0"
 ;
 NEW RM
 I $G(VEE("ID")) S RM=$G(^%ZVEMS("PARAM",VEE("ID"),"WIDTH"))
 I $G(RM)']"" S RM=80 ;Default
 I VEE("OS")=8!(VEE("OS")=18) S VEES("RM80")="U $I:"_RM Q
 ;I VEE("OS")=16 S VEES("RM80")="U $I:WIDTH="_RM Q
 I VEE("OS")=17!(VEE("OS")=19) S VEES("RM80")="U $I:WIDTH="_RM Q
 Q
WRAP ;Wrap & no wrap
 I $D(VEES("WRAP")),$D(VEES("NOWRAP")) Q
 I $G(IOST(0))]"",$D(^%ZIS(2,IOST(0),15)),$P(^(15),"^",1)]"",$P(^(15),"^",2)]"" S VEES("WRAP")=$P(^(15),"^",1),VEES("NOWRAP")=$P(^(15),"^",2) Q
 S VEES("WRAP")="$C(27)_""[?7h"""
 S VEES("NOWRAP")="$C(27)_""[?7l"""
 Q
CRSRMOVE ;Cursor move
 I $D(VEES("CU")),$D(VEES("CD")),$D(VEES("CR")),$D(VEES("CL")) Q
 I $G(IOST(0))]"",$D(^%ZIS(2,IOST(0),8)),$P(^(8),"^",1,4)'["^^" NEW NODE8 S NODE8=^(8) D  Q
 . S VEES("CU")=$P(NODE8,"^",1),VEES("CD")=$P(NODE8,"^",2)
 . S VEES("CR")=$P(NODE8,"^",3),VEES("CL")=$P(NODE8,"^",4)
 S VEES("CU")="$C(27)_""[1A""" ;Cursor up
 S VEES("CD")="$C(27)_""[1B""" ;Cursor down
 S VEES("CR")="$C(27)_""[1C""" ;Cursor right
 S VEES("CL")="$C(27)_""[1D""" ;Cursor left
 Q
CRSROFF ;Cursor on/off
 I $D(VEES("CON")),$D(VEES("COFF")) Q
 S VEES("CON")="$C(27)_""[?25h""" ;Cursor on
 S VEES("COFF")="$C(27)_""[?25l""" ;Cursor off
 Q
CRSRSAVE ;Save Cursor/Restore Cursor
 I $D(VEES("SC")),$D(VEES("RC")) Q
 I $G(IOST(0))]"",$D(^%ZIS(2,IOST(0),14)),$P(^(14),"^",3)]"",$P(^(14),"^",4)]"" S VEES("SC")=$P(^(14),"^",3),VEES("RC")=$P(^(14),"^",4) Q
 S VEES("SC")="$C(27)_7"
 S VEES("RC")="$C(27)_8"
 Q
REVVID ;Reverse Video
 I $D(VEE("RON")),$D(VEE("ROFF")) Q
 I $G(IOST(0))]"",$D(^%ZIS(2,IOST(0),5)),$P(^(5),"^",4)]"",$P(^(5),"^",5)]"" S VEE("RON")=$P(^(5),"^",4),VEE("ROFF")=$P(^(5),"^",5) Q
 S VEE("RON")="$C(27)_""[7m""",VEE("ROFF")="$C(27)_""[0m"""
 Q
GRAPHICS ;Graphics On/Off
 I $D(VEES("GON")),$D(VEES("GOFF")) Q
 I $G(IOST(0))]"",$D(^%ZIS(2,IOST(0),"G1")),$D(^("G2")) S VEES("GON")=^("G1"),VEES("GOFF")=^("G0") Q
 S VEES("GON")="$C(27)_""(0""",VEES("GOFF")="$C(27)_""(B"""
 Q
SCROLL(TOP,BOTTOM) ;Set scroll region
 S:$G(TOP)'>0 TOP=1 S:$G(BOTTOM)'>0 BOTTOM=VEE("IOSL")
 W @("$C(27)_""["_TOP_";"_BOTTOM_"r""")
 Q
SCRL ;Scroll region variables
 S VEES("INDEX")="$C(27)_""D""",VEES("REVINDEX")="$C(27)_""M""" ;Index
 S VEES("INSRT")="$C(27)_""[1L""" ;Insert 1 line
 Q
SCRNVAR1 ;Lesser Used Screen Variables
 S VEES("CION")="$C(27)_""[4h""",VEES("CIOFF")="$C(27)_""[4l""" ;Character insert
 Q
DTM ;Support for DataTree Mumps
 Q:VEE("OS")'=9  Q:$I=1
 Q:$G(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"SHL"))'="RUN"
 X "S ^%ZVEMS(""%"",$J_$G(^%ZVEMS(""SY"")),""DTM"")=$ZDEV(""IXXLATE"")_""^""_$ZDEV(""WRAP"")"
 X "U $I:(IXXLATE=0)" ;X "U $I:(IXXLATE=0:WRAP=0)"
 Q
BRK ;Enable Control C
 I $D(^%ZOSF("BRK")) X ^%ZOSF("BRK") Q
 I VEE("OS")=16 U $I:CENABLE Q
 I VEE("OS")=17 U $I:(CENABLE) Q
 I VEE("OS")=18 U $I:("":"+B") Q
 I VEE("OS")=19 U $I:(CENABLE) Q
 X "B 1"
 Q
NOBRK ;Disable Control C
 I $D(^%ZOSF("NBRK")) X ^%ZOSF("NBRK") Q
 I VEE("OS")=16 U $I:NOCENABLE Q
 I VEE("OS")=17 U $I:(NOCENABLE) Q
 I VEE("OS")=18 U $I:("":"-B") Q
 I VEE("OS")=19 U $I:(NOCENABLE) Q
 X "B 0"
 Q
