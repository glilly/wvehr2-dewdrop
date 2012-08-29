%ZVEMGS ;DJB,VGL**SAVE,UNSAVE [4/16/95 5:50am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SAVE ;Save lines of code (to be UNsaved to a new location).
 NEW CNT,GLNAM,I,ND,RNG
 S CNT=1,RNG=$$GETRANG^%ZVEMKTR("VGL"_GLS) Q:RNG="^"
 I RNG["^" F ND=$P(RNG,"^",1):1:$P(RNG,"^",2) D SAVE1
 I RNG["," F I=1:1:$L(RNG,",") S ND=$P(RNG,",",I) D SAVE1
 S ^%ZVEMS("E","SAVE",$J,CNT)=""
 W "   Save Complete" H 1
 Q
SAVE1 ;
 Q:'$D(^TMP("VEE","VGL"_GLS,$J,ND))  S GLNAM=^(ND) Q:GLNAM']""
 S ^%ZVEMS("E","SAVE",$J,CNT)=$C(9)_@GLNAM,CNT=CNT+1
 Q
 ;===================================================================
UNSAVE ;Unsave code previously saved
 I '$D(^%ZVEMS("E","SAVE",$J)) D MSG^%ZVEMGUM(22,1) Q
 NEW CD,FLAGERR,I,J,LINES,NODE I $G(VEESHL)'="RUN" NEW VEESHC
 D CURSOR^%ZVEMKU1(0,VEET("S2")+VEET("FT")-2,1)
 F I=1:1 Q:^%ZVEMS("E","SAVE",$J,I)=""  Q:'$D(^(I))
 S LINES=I-1 D  D PAUSE^%ZVEMKU(1)
 . W LINES," LINE",$S(LINES=1:"",1:"S")," of code saved."
 . W " NOTE: Exit and reenter VGL to see newly created nodes."
 F I=1:1:LINES D UNSAVS Q:CD="^"
 Q
UNSAVS ;Get subscript
 S CD="" D CURSOR^%ZVEMKU1(0,VEET("S2")+VEET("FT")-2,1)
 W "Enter subscript to load LINE ",I," into a global node:"
 D SCREEN^%ZVEMKEA(GL_"(",2,75)
 I VEESHC="<ESCH>" D MSG^%ZVEMGUM(21,1) G UNSAVS
 I CD="?"!(CD="??") D MSG^%ZVEMGUM(21,1) G UNSAVS
 I ",<ESC>,<F1E>,<F1Q>,<TAB>,<TO>,"[(","_VEESHC_",")!(CD']"") S CD="^"
 Q:CD="^"
 I VEESHC'="<RET>",VEESHC?1"<".E1">".E G UNSAVS
 S NODE=GL_"("_CD S:$E(NODE,$L(NODE))'=")" NODE=NODE_")"
 S FLAGERR=0 D  G:FLAGERR UNSAVS
 . NEW X S X="ERROR^%ZVEMGS",@($$TRAP^%ZVEMKU1) KILL X
 . S CD=^%ZVEMS("E","SAVE",$J,I)
 . F J=1:1:($L(CD,$C(9))-1) S CD=$P(CD,$C(9),1)_$P(CD,$C(9),2,999)
 . I $D(@NODE)#2 D MSG^%ZVEMGUM(12,1) S CD="",FLAGERR=1 Q
 . S @NODE=CD
 Q
ERROR ;
 D CURSOR^%ZVEMKU1(0,VEET("S2")+VEET("FT")-2,1)
 W $C(7),"Invalid subscript.."
 S CD="",FLAGERR=1 D PAUSE^%ZVEMKU(1)
 Q
