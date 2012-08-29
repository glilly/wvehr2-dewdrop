%ZVEMOC ;DJB,VRROLD**Saves editing changes ; 12/16/00 10:45pm
 ;;7.0;VPE;;COPYRIGHT David Bolduc @1993
 ;
SAVE ;Sets up ^UTILITY so rtn editor can save changes.
 ;If VRRPGM is defined, Editor will save edited routine to @VRRPGM.
 ;If VRRPGM="" changes aren't saved.
 ;
 NEW CD,FLAGQ,XX
 S VRRPGM=$G(^TMP("VEE","VRR",$J,1,"NAME")) G:VRRPGM']"" EX1
 I '$D(^TMP("VEE","VRR",$J,1,"TXT")) S VRRPGM="" G EX1
 S FLAGQ=0
 D INIT I FLAGQ S VRRPGM="" G EX1
 X VEES("RM0")
 D @$S($G(FLAGSAVE):"ASK",1:"ASK1")
 G:VRRPGM="" EX
 D DATE,LOAD
EX ;
 X VEES("RM80")
EX1 KILL ^TMP("VEE","VRR",$J)
 I VRRPGM="" W !?3,"Changes not saved..",!
 E  W !?3,"^",VRRPGM," saved to disk..",!
 Q
 ;
ASK ;Ask to save changes
 W !?3,"Routine: ^",VRRPGM,!?3,"Save your changes?"
 S XX=$$CHOICE^%ZVEMKC("YES^NO^SAVE_AS",1)
 I XX=0!(XX=2) S VRRPGM="" Q
 I XX=3 D SAVEAS
 Q
 ;
ASK1 ;No changes made. Ask to save to new rtn.
 W !?3,"Routine: ^",VRRPGM,!?3,"Select OPTION:"
 S XX=$$CHOICE^%ZVEMKC("QUIT^SAVE_AS",1)
 I XX'=2 S VRRPGM="" Q
 D SAVEAS
 Q
 ;
SAVEAS ;Save routine to a new name
 NEW TMP
 W !?3,"Save as routine: ^"
 R VRRPGM:600 S:'$T VRRPGM="^" I "^"[VRRPGM S VRRPGM="" Q
 I $E(VRRPGM)="?" W "   Enter new name for this edited routine" G SAVEAS
 I $E(VRRPGM)="^" S VRRPGM=$E(VRRPGM,2,99)
 I VRRPGM'?1A.7AN,VRRPGM'?1"%"1A.6AN W $C(7),"   Invalid routine name" G SAVEAS
 I $$EXIST^%ZVEMKU(VRRPGM) D EXISTS I VRRPGM']"" W ! G SAVEAS
 S TMP=$P(^TMP("VEE","VRR",$J,1,"TXT",1),$C(9))
 S TMP=$S(TMP'["(":"",1:"("_$P(TMP,"(",2,99))
 S $P(^TMP("VEE","VRR",$J,1,"TXT",1),$C(9))=VRRPGM_TMP
 Q
 ;
EXISTS ;Routine already exists
 W $C(7),!!?3,"WARNING...Routine ^",VRRPGM," already exists."
 W !?3,"Shall I overwrite?"
 S XX=$$CHOICE^%ZVEMKC("YES^NO",1)
 I XX'=1 S VRRPGM=""
 Q
 ;
LOAD ;Load routine into ^UTILITY
 KILL ^UTILITY($J)
 F XX=1:1 Q:'$D(^TMP("VEE","VRR",$J,1,"TXT",XX))  S CD=^(XX),CD=$P(CD,$C(9))_" "_$P(CD,$C(9),2,999),^UTILITY($J,0,XX)=CD
 Q
 ;
DATE ;Attach date to top line
 NEW DATE,LN,PIECE,TIME
 Q:'$D(^TMP("VEE","VRR",$J,1,"TXT",1))  S LN=^(1),PIECE=$L(^(1)," [")
 S:$P(LN," [",PIECE)?1.2N1"/"2N1"/"2N.E1"]" LN=$P(LN," [",1,PIECE-1)
 S DATE=$$DATE^%ZVEMKDT(2),TIME=$$TIME^%ZVEMKDT(2)
 S ^(1)=LN_" ["_DATE_" "_TIME_"]"
 Q
 ;
INIT ;
 I '$D(VEE("OS")) D OS^%ZVEMKY Q:FLAGQ
 D ZSAVE^%ZVEMKY3 Q:FLAGQ  D SCRNVAR^%ZVEMKY2,REVVID^%ZVEMKY2
 Q
