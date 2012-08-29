%ZVEMSQW ;DJB,VSHL**QWIKs - Vendor List [9/9/95 6:40pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
VENLIST ;List Vendor Specific Code
 NEW CD,FLAGQ,NAM,TYPE
 W !?1,"*** List Vendor Specific Code ***"
 W !?1,"Enter the name of an existing System/User QWIK"
 S FLAGQ=0 F  S TYPE="" D GETNAM Q:FLAGQ  I TYPE]"" D LISTCD
 Q
GETNAM ;Get either User or System QWIK
 W ! S CD="" D SCREEN^%ZVEMKEA("Enter QWIK: ",1,VEE("IOM")-2)
 I CD="?"!(CD="??")!(VEESHC="<ESCH>") D  G GETNAM
 . W !?3,"Enter the name of an existing System/User QWIK"
 I ",<ESC>,<F1E>,<F1Q>,<TAB>,<TO>,"[(","_VEESHC_",")!(CD']"")!(CD="^") S FLAGQ=1 Q
 S CD=$$ALLCAPS^%ZVEMKU(CD)
 I CD'?1A.7AN D MSG^%ZVEMSQA(1) G GETNAM
 S NAM=CD
 I $D(^%ZVEMS("QU",VEE("ID"),NAM)),$D(^%ZVEMS("QS",NAM)) D BOTH Q
 S TYPE=$S($D(^%ZVEMS("QU",VEE("ID"),NAM)):"User",$D(^%ZVEMS("QS",NAM)):"System",1:"")
 I TYPE']"" W "   No such QWIK"
 Q
LISTCD ;List Code
 W @VEE("IOF"),!?12,"D I S P L A Y   V E N D O R   S P E C I F I C   C O D E"
 W !!?1,"QWIK NAME...... ",NAM
 W !?1,"TYPE........... ",TYPE
 W !?1,"DESCRIPTION.... " W $S(TYPE="System":$P(^%ZVEMS("QS",NAM,"DSC"),"^",1),1:$P(^%ZVEMS("QU",VEE("ID"),NAM,"DSC"),"^",1))
 W !!?1,"Default Code..." S CD=$S(TYPE="System":^%ZVEMS("QS",NAM),1:^%ZVEMS("QU",VEE("ID"),NAM)) D LISTCD1
 I TYPE="User" NEW X S X="" F  S X=$O(^%ZVEMS("QU",VEE("ID"),NAM,X)) Q:X'>0  D LISTNAM S CD=^(X) D LISTCD1
 I TYPE="System" NEW X S X="" F  S X=$O(^%ZVEMS("QS",NAM,X)) Q:X'>0  D LISTNAM S CD=^(X) D LISTCD1
 Q
LISTCD1 ;List Code with wrapping
 NEW LMAR,PROMPT,START,WIDTH
 S PROMPT="",(LMAR,START)=17,WIDTH=61 D LISTCD^%ZVEMKEA
 Q
LISTNAM ;
 W !!?1,"Vendor ",$S(X=1:"M/11.... ",X=2:"DSM..... ",X=7:"M/VX.... ",X=8:"MSM..... ",X=9:"DTM..... ",X=13:"M/11+... ",X=16:"VAXDSM.. ",1:"........ ")
 Q
BOTH ;Both a User & System QWIK exists
 NEW XX
 W !!!?1,"There are 2 QWIKs named ",NAM,". Which one do you wish to see?",!?3,"U = User QWIK",!?3,"S = System QWIK"
BOTH1 R !?1,"Enter letter of your choice: ",XX:300 S:'$T XX="^" I "^"[XX Q
 S XX=$$ALLCAPS^%ZVEMKU($E(XX))
 I "US"'[XX W "   Enter U or S" G BOTH1
 S TYPE=$S(XX="U":"User",XX="S":"System",1:"")
 Q
