%ZVEMOUM ;DJB,VRROLD**Messages [12/31/94]
 ;;7.0;VPE;;COPYRIGHT David Bolduc @1993
 ;
MSG1(NUM,PAUSE) ;Clear 21 to bottom. Write msg on 21. Leave cursor on 21
 ;NUM=Subroutine number  PAUSE=Pause screen
 Q:$G(NUM)'>0  D BOTTOM^%ZVEMOU
 S DX=0,DY=21 X VEES("CRSR") D @NUM
 I $G(PAUSE) S DY=DY+1 X VEES("CRSR") D PAUSE^%ZVEMKU(0)
 S DY=21 X VEES("CRSR")
 Q
MSG2(NUM,PAUSE) ;Clear 21 to bottom. Write msg on 22. Leave cursor on 21
 ;NUM=Subroutine number  PAUSE=Pause screen
 Q:$G(NUM)'>0  D BOTTOM^%ZVEMOU
 S DX=0,DY=22 X VEES("CRSR") D @NUM
 I $G(PAUSE) S DY=DY+1 X VEES("CRSR") D PAUSE^%ZVEMKU(0)
 S DY=21 X VEES("CRSR")
 Q
MSGS(NUM,PAUSE) ;Clear 22 to bottom. Write msg on 22. Leave cursor on 22.
 ;NUM=Subroutine #
 Q:$G(NUM)'>0  D BOTTOM1^%ZVEMOU D @NUM
 I $G(PAUSE) S DY=DY+1 X VEES("CRSR") D PAUSE^%ZVEMKU(0)
 S DX=0,DY=22 X VEES("CRSR")
 Q
 ;====================================================================
1 W ?1,"Select from menu bar above." Q
2 W $C(7),?1,"Invalid line number" Q
3 W $C(7),?1,"Invalid selection" Q
4 W ?1,"GOTO: 'n'=Line number  MK=Mark  <TAB>=Cursor" Q
5 W $C(7),?1,"No editing. " D  Q
 . I $G(VRRS)>1 W "You've branched to another Program." Q
 . I $G(FLAGVPE)'["EDIT" W "You're using the Routine Reader." Q
 . I $G(FLAGHOT)="YES" W "HOT KEY is active." Q
6 W $C(7),?1,"You haven't Marked any lines" Q
7 W $C(7),?1,"You can't Branch to more than 4 programs" Q
8 W $C(7),?1,"Invalid Line Tag" Q
9 W $C(7),?1,"Line Tag has an invalid subscript" Q
10 W $C(7),?1,"Illegal Line" Q
11 W $C(7),?1,"Code length may not exceed 245 characters" Q
 ;
12 W ?1,"Enter line number (1 to ",VRRHIGH,"), a range (2-6), or <TAB> for HIGHLIGHT line." Q
13 W $C(7),?1,"Invalid RANGE" Q
14 W ?1,"Enter line number from 1 to ",VRRHIGH,", or <TAB> to select CURSOR line." Q
15 W ?1,"Enter code you wish inserted. Use <TAB> as a line start character." Q
16 W $C(7),?1,"No match" Q
17 W ?1,"The line will be broken AFTER the code you enter" Q
18 W $C(7),?1,"Line numbers can't match" Q
19 W $C(7),?1,"Joined line would be too long" Q
