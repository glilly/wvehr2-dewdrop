%ZVEMOEU ;DJB,VRROLD**CHANGE - Utilities [12/31/94]
 ;;7.0;VPE;;COPYRIGHT David Bolduc @1993
 ;
LINECHK(CODE) ;Check Line. 1=Line bad,2=Line null
 I $G(CODE)']"" Q 0
 NEW LINE
 S LINE=$P(CODE,$C(9),2,999)
 I $L(CODE,$C(9))'>1 D MSG2^%ZVEMOUM(10,1) Q 1
 I LINE="" Q 2
 I $L(CODE)>244 D MSG2^%ZVEMOUM(11,1)
 Q 0
TAGCHK(CODE) ;Check Tag. 1=Tag bad
 I $G(CODE)']"" Q 0
 NEW TAG,TAG1,TAG2,TEST
 S TAG=$P(CODE,$C(9),1),TAG1=$P(TAG,"(")
 I TAG']"" Q 0
 I $L(TAG1)>8 D MSG2^%ZVEMOUM(8,1) Q 1
 I $E(TAG1)'?1AN,$E(TAG1)'="%" D MSG2^%ZVEMOUM(8,1) Q 1
 I $L(TAG1)>1,$E(TAG1)'?1N,$E(TAG1,2,999)'?1.AN D MSG2^%ZVEMOUM(8,1) Q 1
 I $E(TAG1)?1N,TAG1'?1.N D MSG2^%ZVEMOUM(8,1) Q 1
 I TAG'?.E1"(".E Q 0
 I $E(TAG,$L(TAG))'=")" D MSG2^%ZVEMOUM(9,1) Q 1
 S TAG2=$P(TAG,"(",2,99),TAG2=$E(TAG2,1,$L(TAG2)-1) I TAG2="" Q 0
 S TEST=0 F I=1:1:$L(TAG2,",") I $P(TAG2,",",I)'?1A.AN&($P(TAG2,",",I)'?1"%".AN) S TEST=1 Q
 I TEST D MSG2^%ZVEMOUM(9,1) Q 1
 Q 0
SAVE ;Save changes
 S ^TMP("VEE","VRR",$J,VRRS,"TXT",VRRLN)=CD,FLAGSAVE=1
 Q
CLRSCRN ;Clear the editing portion of the screen
 S DX=0,DY=TOP X VEES("CRSR")
 W @VEES("BLANK_C_EOS") X VEES("XY")
 W VRRLINE X VEES("CRSR")
 Q
CLRSCRN1 ;
 S DX=XCUR,DY=(TOP+YCUR+1) X VEES("CRSR")
 Q
