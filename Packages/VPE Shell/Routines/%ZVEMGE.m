%ZVEMGE ;DJB,VGL**Edit Global Node [2/25/99 1:30pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EDITV ;Edit node's value
 NEW CD1,FLAGQ,NEW,ND,NODE,OLD,TAB,TEMP,TEMP1,X
 NEW CD,VEESHC ;^%ZVEMKEA returns CD,VEESHC,VEE
EDITV1 Q:'$$GETND()
 I '$D(^TMP("VEE","VGL"_GLS,$J,ND)) D MSG^%ZVEMGUM(1) G EDITV1
 S NODE=^(ND)
 S (CD,CD1)=@NODE
 ;I CD?.E1C.E D MSG^%ZVEMGUM(26) G EDITV1 ;Control characters
 I VEE("OS")=9 S DX=0,DY=VEET("S2") X VEES("CRSR") W @VEES("BLANK_C_EOS")
 D CURSOR^%ZVEMKU1(0,15,1)
 W !,@VEE("RON"),!?32,"EDIT GLOBAL VALUE",?VEE("IOM"),@VEE("ROFF"),!!
 S TEMP=NODE I $L(NODE)>40 S TEMP="" D  ;
 . I $L(NODE)<VEE("IOM") W NODE Q
 . W $E(NODE,1,VEE("IOM")),!?1,$E(NODE,VEE("IOM")+1,999)
 D EDIT^%ZVEMKE(TEMP_" = ")
 D:$G(VEESHC)="TOO LONG" PAUSE^%ZVEMKU(1) D KILLCHK^%ZVEMKU(CD)
 I CD'=CD1 S @NODE=CD D RESET^%ZVEMGE1 ;Adj scroll array
 Q
EDITS ;Edit node's subscript
 ;D NOTEMSG^%ZVEMGE1 Q
 NEW CD1,FLAGQ,NEW,ND,NODE,OLD,TAB,TEMP,TEMP1
 NEW CD,VEESHC ;^%ZVEMKEA returns CD,VEESHC,VEE
EDITS1 Q:'$$GETND()
 I '$D(^TMP("VEE","VGL"_GLS,$J,ND)) D MSG^%ZVEMGUM(12) G EDITS1
 S NODE=^(ND)
 I $D(@NODE)>1 D MSG^%ZVEMGUM(23) G EDITS1 ;Don't delete node with decendents
 S CD=$P(NODE,"(",2,999),(CD,CD1)=$E(CD,1,$L(CD)-1) ;Set CD=Subscript Only
 I CD']"" D MSG^%ZVEMGUM(14,1) Q
 I VEE("OS")=9 S DX=0,DY=VEET("S2") X VEES("CRSR") W @VEES("BLANK_C_EOS")
 D CURSOR^%ZVEMKU1(0,15,1)
 W !,@VEE("RON"),!?29,"EDIT GLOBAL SUBSCRIPT",?VEE("IOM"),@VEE("ROFF")
 W !!?1,NODE D EDIT^%ZVEMKE($J("",$F(NODE,"(")-1))
 Q:CD=CD1  I CD']"" D KILLND Q
 I $L(CD)>127 W ! D MSG^%ZVEMGUM(13,1) Q
 S CD=$P(NODE,"(",1)_"("_CD_")"
 NEW X S X="ERROR^%ZVEMGE",@($$TRAP^%ZVEMKU1) KILL X
 I $D(@CD)#2 D MSG^%ZVEMGUM(12,1) Q  ;Don't overwrite existing node
 NEW X S X="",@($$TRAP^%ZVEMKU1) KILL X
 S TEMP=@NODE KILL @NODE S @CD=TEMP
 S ^TMP("VEE","VGL"_GLS,$J,ND)=CD
 D RESET^%ZVEMGE1 ;Adj scroll array
 Q
GETND() ;Get node. 0=No node selected  1=Node selected
 S ND=$$GETREF^%ZVEMKTR("IG"_GLS) I ND="^" Q 0
 I ND="***" W $C(7) Q 0
 Q ND
EDITR ;Edit a range of nodes
 ;D NOTEMSG^%ZVEMGE1 Q
 NEW RNG D MSG^%ZVEMGUM(24)
 S RNG=$$GETRANG^%ZVEMKTR("VGL"_GLS) Q:RNG="^"  D RANGE^%ZVEMGE1(RNG)
 Q
KILLND ;Edit subscript - Kill node
 NEW ANS
 W !?2,"Do you want to delete this node? Yes// "
 R ANS:300 Q:'$T!(ANS="^")  S:ANS="" ANS="YES"
 S ANS=$$ALLCAPS^%ZVEMKU(ANS)
 I "NY"'[$E(ANS) W "   Y=Yes  N=No" G KILLND
 Q:$E(ANS)'="Y"  KILL @NODE D DELETE^%ZVEMGE1
 Q
ERROR ;Invalid subscript was entered
 W $C(7),!!?3,"Invalid subscript." D PAUSE^%ZVEMKU(1)
 Q
STRIP ;Strip off control characters
 NEW ASK,CD,CD1,I,ND,NODE,TMP
STRIP1 Q:'$$GETND()
 I '$D(^TMP("VEE","VGL"_GLS,$J,ND)) D MSG^%ZVEMGUM(1) G STRIP1
 S NODE=^(ND)
 S CD=@NODE
 I CD'?.E1C.E D MSG^%ZVEMGUM(25) G STRIP1
 IF CD'?.E1C.E W "  No control characters found" G STRIP1
 S CD1=""
 F I=1:1:$L(CD) S TMP=$E(CD,I) I TMP'?1C S CD1=CD1_TMP
 Q:CD=CD1  ;No change
 R "  Strip control characters? Y//",ASK:300 S:'$T ASK="^"
 I ASK'="",$E(ASK)'="y",$E(ASK)'="Y" G STRIP1
 S @NODE=CD1
 D RESET^%ZVEMGE1 ;Adj scroll array
 Q
