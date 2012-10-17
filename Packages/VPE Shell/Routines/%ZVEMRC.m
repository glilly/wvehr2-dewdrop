%ZVEMRC ;DJB,VRR**Saves editing changes ; 9/5/02 12:14pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SAVE(ND) ;Sets up ^UTILITY so rtn editor can save changes.
 ;ND=Rtn Session # (VRRS)
 ;If VRRPGM is defined, Editor will save edited routine to @VRRPGM.
 ;If VRRPGM="" changes aren't saved.
 ;If VRRLBRY=1, Editor will run Library & Versioning.
 ;If VRRNODT=1, Editor will bypass adjusting date on top line.
 ;
 NEW CD,FLAGQ,LN,TG,TMP,XX
 NEW VRRLBRY,VRRNODT
 ;
 S (FLAGQ,VRRLBRY,VRRNODT)=0
 D INIT
 I FLAGQ D MSG1 G EX
 S:$G(ND)'>0 ND=1
 S VRRPGM=$G(^TMP("VEE","VRR",$J,ND,"NAME"))
 I VRRPGM']"" D MSG1 G EX
 X VEES("RM0")
 D CONVERT^%ZVEMRV(ND)
 S TMP=$G(^UTILITY($J,0,1))
 I TMP']""!(TMP=" <> <> <>") D MSG1 G EX
 S TG=$P(TMP," ",1)
 S LN=$P(TMP," ",2,99)
 ;
 D ASK I VRRPGM="" D MSG1 G EX
 D DATE ;Update date on top line
 D MSG ;Display message
 ;
 I VRRLBRY=1 D  ;
 . D ADD^%ZVEMRLU(VRRPGM) ;Routine Library
 . D ADD^%ZVEMRLV(VRRPGM) ;Routine Versioning
 ;
EX ;
 KILL ^TMP("VEE","VRR",$J)
 KILL ^TMP("VEE","IR1",$J)
 X VEES("RM80")
 Q
 ;
MSG ;Routine saved
 W !!,"^",VRRPGM," saved to disk."
 W:$G(VRRNODT) !,"Date on top line not updated."
 W !
 Q
 ;
MSG1 ;Routine not saved
 S VRRPGM=""
 W !!,"Changes not saved.",!
 Q
 ;
ASK ;Ask to save changes
 NEW DEFAULT
 S DEFAULT=$S($G(FLAGSAVE)>0:2,1:1)
 W !,"Routine: ^",VRRPGM,!,"Save your changes?",!!
 S XX=$$CHOICE^%ZVEMKC("QUIT^SAVE^SAVE_AS^SAVE_NODT",DEFAULT)
 I XX<2 S VRRPGM="" Q
 D:XX=3 SAVEAS
 S:XX=4 VRRNODT=1
 S VRRLBRY=1 ;Library & Versioning
 Q
 ;
SAVEAS ;Save routine to a new name
 NEW SUBSCRIP W !
SAVEAS1 W !,"Save as routine: ^"
 R VRRPGM:300 S:'$T VRRPGM="^" I "^"[VRRPGM S VRRPGM="" Q
 I $E(VRRPGM)="?" D  G SAVEAS1
 . W "   Enter new name for this edited routine"
 I $E(VRRPGM)="^" S VRRPGM=$E(VRRPGM,2,99)
 I VRRPGM'?1A.7AN,VRRPGM'?1"%"1A.6AN D  G SAVEAS1
 . W $C(7),"   Invalid routine name."
 I $$EXIST^%ZVEMKU(VRRPGM) D EXISTS I VRRPGM']"" W ! G SAVEAS1
 S SUBSCRIP=$S(TG'["(":"",1:"("_$P(TG,"(",2,99))
 S TG=VRRPGM_SUBSCRIP
 S ^UTILITY($J,0,1)=TG_" "_LN
 Q
 ;
EXISTS ;Routine already exists
 W $C(7),!!?3,"WARNING...Routine ^",VRRPGM," already exists."
 W !?3,"Shall I overwrite?"
 S XX=$$CHOICE^%ZVEMKC("YES^NO",1)
 I XX'=1 S VRRPGM=""
 Q
 ;
DATE ;Attach date to top line
 ;
 ;Don't update date on routine's top line.
 I $G(VEENODT)!$G(VRRNODT) Q
 ;
 NEW DATE,PIECE,TIME,TMP
 Q:'$D(^UTILITY($J,0,1))  S TMP=^(1)
 ;
 ;Don't attach date if top line doesn't start with ";"
 I $E($P(TMP," ",2),1)'=";" Q
 ;
 S DATE=$$DATE^%ZVEMKDT(2)
 S TIME=$$TIME^%ZVEMKDT(2)
 I $E(TIME)=" " S TIME=$E(TIME,2,99)
 ;
 ;New date format - ; 3/2/98 1:40pm
 S PIECE=$L(LN," ;")
 I PIECE>1 S LN=$P(LN," ;",1,PIECE-1)
 ;
 ;Old date format - [3/2/98 1:40pm]
 E  S PIECE=$L(LN," [") I PIECE>1 D  ;
 . Q:$P(LN," [",PIECE)'?1.2N1"/"1.2N1"/"2N.E1."]"
 . S LN=$P(LN," [",1,PIECE-1)
 ;
 S LN=LN_" ; "_DATE_" "_TIME
 S ^UTILITY($J,0,1)=TG_" "_LN
 Q
 ;
INIT ;
 I '$D(VEE("OS")) D OS^%ZVEMKY Q:FLAGQ
 D ZSAVE^%ZVEMKY3 Q:FLAGQ
 D SCRNVAR^%ZVEMKY2
 D REVVID^%ZVEMKY2
 Q
