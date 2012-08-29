%ZVEMGM1 ;DJB,VGL**Main Menu cont. [2/24/99 8:06am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
PIECE ;List pieces
 NEW FLAG,FLAGXREF S FLAG=0
 I '$D(^TMP("VEE","VGL"_GLS,$J,Z1)) D MSG^%ZVEMGUM(1,1) Q
 I ^TMP("VEE","VGL"_GLS,$J,Z1)']"" D MSG^%ZVEMGUM(1,1) Q  ;Node was deleted with ES (edit subscript).
 Q:'$$CHECKFM^%ZVEMGMC()
 S VEEX=^TMP("VEE","VGL"_GLS,$J,Z1)
 I VEEX'?.E1"(".E D MSG^%ZVEMGUM(2,1) Q
 D SUBSET^%ZVEMGI1(VEEX) I SUBNUM="NOFM" D MSG^%ZVEMGUM(3,1) Q
 D CHKNODE^%ZVEMGMC Q:FLAGQ  D ENDSCR^%ZVEMKT2
 D @$S(FLAG="ZERO":"ZERO^%ZVEMGPS",FLAG="WP":"WP^%ZVEMGPS",FLAG="XREF":"XREF^%ZVEMGPS",1:"^%ZVEMGP")
 Q
ALT ;Alternate Session
 D SYMTAB^%ZVEMKST("C","VGL",GLS) ;Clear symbol table
 D START^%ZVEMG
 D SYMTAB^%ZVEMKST("R","VGL",GLS) ;Restore symbol table
 Q
MORE ;
 W !?2,"VEDD ......: Victory Electonic Data Dictionary"
 W !?2,"ER ........: EDITOR - Edit range of nodes"
 W !?2,"ES ........: EDITOR - Edit node's subscript"
 W !?2,"EV ........: EDITOR - Edit node's value"
 W !?2,"SA ........: SAve code so it can be UNsaved into a routine"
 W !?2,"SC ........: Strip control characters from a node. Control"
 W !?2,"             characters will appear as 'c' in reverse video."
 W !?2,"UN ........: UNsave code that's been previously SAved"
 W !?2,"<ESC>H ....: Scroll Help"
 W !!?2,"Call VGL at R^%ZVEMG to display subscript ""constants"" in reverse video."
 D PAUSE^%ZVEMKC(2)
 Q
CHECK() ;0=Quit 1=Ok   Check: A,C,ES,EV
 I ",C,ES,EV,"[(","_Z1_","),$G(DUZ(0))'["@" D MSG^%ZVEMGUM(4,1) Q 0
 I ",C,ES,EV,"[(","_Z1_","),$G(VGLREV) D MSG^%ZVEMGUM(5,1) Q 0
 I ",ES,EV,"[(","_Z1_","),$G(FLAGVPE)["VRR"!($G(FLAGVPE)["VEDD") D MSG^%ZVEMGUM(6,1) Q 0
 I ",ES,EV,"[(","_Z1_","),GLS>1 D MSG^%ZVEMGUM(7,1) Q 0
 I Z1="C",VEET("STATUS")["SEARCH" D MSG^%ZVEMGUM(8,1) Q 0
 I Z1="C",'$D(^TMP("VEE","VGL"_GLS,$J)) D MSG^%ZVEMGUM(9,1) Q 0
 I Z1="A",GLS>1 D MSG^%ZVEMGUM(10,1) Q 0
 I Z1="A",$G(FLAGVPE)["VRR"!($G(FLAGVPE)["VEDD") D MSG^%ZVEMGUM(11,1) Q 0
 Q 1
