%ZVEMRUM ;DJB,VRR**Messages ; 1/6/01 3:47pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
MSG(NUM) ;Msgs for rtn editor
 Q:$G(NUM)'>0  NEW XX
 S DX=0,DY=VEET("S2") X VEES("CRSR")
 W @VEE("RON")
 X VEES("XY")
 D @NUM
 W ?VEE("IOM")
 S DX=0,DY=VEET("S2")+1 X VEES("CRSR")
 W "<RETURN> to continue.."
 W ?VEE("IOM")
 S DX=23,DY=VEET("S2")+1 X VEES("CRSR")
 R XX:300
 W @VEE("ROFF")
 S DX=0,DY=VEET("S2") X VEES("CRSR")
 W ?VEE("IOM")
 X VEES("CRSR")
 W VEET("FT",1)
 S DX=0,DY=VEET("S2")+1 X VEES("CRSR")
 W ?VEE("IOM")
 X VEES("CRSR")
 W VEET("FT",2)
 S DX=XCUR,DY=YCUR X VEES("CRSR")
 Q
 ;====================================================================
1 W "Select from menu bar above." Q
2 W $C(7),"Invalid line number" Q
3 W $C(7),"Invalid selection" Q
4 W "GOTO: 'n'=Line number  MK=Mark  <TAB>=Cursor" Q
5 W $C(7),"No editing. " D  Q
 . I $G(VRRS)>1 W "You've branched to another Program." Q
 . I $G(FLAGVPE)'["EDIT" W "You're using the Routine Reader." Q
6 W $C(7),"You haven't Marked any lines" Q
7 W $C(7),"You can't Branch to more than 4 programs" Q
8 W $C(7),"Invalid Line Tag" Q
9 W $C(7),"Line Tag has an invalid subscript" Q
10 W $C(7),"Illegal Line" Q
11 W $C(7),"A line may not exceed 245 characters" Q
13 W $C(7),"Invalid RANGE" Q
15 W "Enter code you wish inserted. Use <TAB> as a line start character." Q
16 W $C(7),"No match" Q
17 W "The line will be broken AFTER the code you enter" Q
18 W $C(7),"Line numbers can't match" Q
19 W $C(7),"Joined line would be too long" Q
20 W $C(7),"You must use <TAB> as a line start character" Q
21 W "Purge complete" Q
22 W "It is invalid to replace LINES with saved CHARACTERS." Q
23 W "It is invalid to replace CHARACTERS with saved LINES." Q
