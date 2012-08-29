%ZVEMDUM ;DJB,VEDD**Scroll Messages [9/24/95 3:26pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
MSG(NUM,PAUSE) ;Messages
 ;NUM=Subroutine number  PAUSE=Pause screen
 Q:$G(NUM)'>0
 S DX=0,DY=VEET("S2")+VEET("FT")-2
 D CURSOR^%ZVEMKU1(DX,DY,1),@NUM
 S DX=0,DY=DY+1 I $G(PAUSE) X VEES("CRSR") D PAUSE^%ZVEMKU(0)
 Q
1 W $C(7),"You may only branch from pointer fields (marked with ""<-Pntr"")" Q
2 W $C(7),"Pointed-to file doesn't exist." Q
3 W $C(7),"No files on record." Q
4 W $C(7),"Enter REF number from left hand column" Q
5 W "Enter field name or part of field name." Q
6 W $C(7),"Invalid field name." Q
7 W $C(7),"There is no reference to a data global in ^DD." Q
