%ZVEMRP1 ;DJB,VRR**Cut,Copy,Paste ; 12/28/00 5:59pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
CUT ;Save lines to clipboard, then delete
 ;<ESCX> Key combination
 I $D(^TMP("VEE","SAVE",$J)) D SAVE,DELETE()
 Q
 ;
COPY ;Save lines to clipboard
 ;<ESCC> Key combination
 I $D(^TMP("VEE","SAVE",$J)) D SAVE ;.......Line save
 I $D(^TMP("VEE","SAVECHAR",$J)) D SAVE1 ;..Character save
 D CLEARALL^%ZVEMRP
 Q
 ;
PREPASTE ;Make sure a paste occurs after last of scrolled lines.
 NEW DATA,TMP,OLDYND
 S (TMP,OLDYND)=YND
 F  S TMP=$O(^TMP("VEE","IR"_VRRS,$J,TMP)) Q:TMP'>0  S DATA=^(TMP) Q:DATA[$C(30)!(DATA=" <> <> <>")!(DATA']"")  S YND=YND+1
 D PASTE
 S YND=OLDYND
 Q
 ;
PASTE ;Paste lines from clipboard to current routine
 ;<ESCV> Key combination
 ;
 Q:'$D(^%ZVEMS("E","SAVEVRR",$J))
 I YND>1,$G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>" W $C(7) Q
 ;
 NEW CNT,END,I,SPREAD,START
 F SPREAD=1:1 Q:$G(^%ZVEMS("E","SAVEVRR",$J,SPREAD))']""
 S SPREAD=SPREAD-1
 S END=$O(^TMP("VEE","IR"_VRRS,$J,""),-1)
 F I=(END+SPREAD):-1:YND+SPREAD D  ;
 . S ^TMP("VEE","IR"_VRRS,$J,I)=^TMP("VEE","IR"_VRRS,$J,I-SPREAD)
 S CNT=0,START=YND+1
 ;-> If there is no code in this rtn, paste to starting line.
 S:$G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>" START=YND
 F I=START:1 S CNT=CNT+1 D  Q:CNT=SPREAD
 . S ^TMP("VEE","IR"_VRRS,$J,I)=^%ZVEMS("E","SAVEVRR",$J,CNT)
 D RENUMBER
 Q
 ;
SAVE ;Save highlighted line code to clipboard
 NEW CNT,X
 S CNT=1,X=0
 F  S X=$O(^TMP("VEE","SAVE",$J,X)) Q:X'>0  D  ;
 . S ^%ZVEMS("E","SAVEVRR",$J,CNT)=^TMP("VEE","SAVE",$J,X)
 . S CNT=CNT+1
 S ^%ZVEMS("E","SAVEVRR",$J,CNT)=""
 S ^%ZVEMS("E","SAVEVRR",$J)="LINE"
 Q
 ;
SAVE1 ;Save highlighted character code to clipboard
 S ^%ZVEMS("E","SAVEVRR",$J,1)=$G(^TMP("VEE","SAVECHAR",$J))
 S ^%ZVEMS("E","SAVEVRR",$J,2)=""
 S ^%ZVEMS("E","SAVEVRR",$J)="CHAR"
 Q
 ;
DELETE(QUIT) ;Delete nodes from scroll array
 ;If QUIT=1 don't do DELETE1. Allows other rtns to use this code.
 ;
 Q:'$D(^TMP("VEE","SAVE",$J))
 ;
 NEW END,I,SPREAD,START,STOP
 S START=$O(^TMP("VEE","SAVE",$J,""))
 S STOP=$O(^TMP("VEE","SAVE",$J,""),-1)
 S SPREAD=STOP-START+1
 S END=$O(^TMP("VEE","IR"_VRRS,$J,""),-1)
 F I=START:1:END-SPREAD D  ;
 . S ^TMP("VEE","IR"_VRRS,$J,I)=^TMP("VEE","IR"_VRRS,$J,I+SPREAD)
 F I=END-SPREAD+1:1:END KILL ^TMP("VEE","IR"_VRRS,$J,I)
 D RENUMBER
 KILL ^TMP("VEE","SAVE",$J)
 Q:$G(QUIT)
DELETE1 ;If highlight made by cursor up, keep cursor where it is
 I YND'<START S VEET("TOP")=YND-(SPREAD+(YND-VEET("TOP")))
 S YND=VEET("TOP")+YCUR-1 ;..Reset YND to account for deleted lines
 I VEET("TOP")<1 S (VEET("TOP"),YCUR,YND)=1
 Q
 ;
RENUMBER ;Renumber scroll array
 NEW L,L1,NUM,NUM1,ONE,TMP,TWO,X
 S (NUM,X)=0
 F  S X=$O(^TMP("VEE","IR"_VRRS,$J,X)) Q:X'>0  D  ;
 . S TMP=^(X) I TMP[$C(30) D  ;...Number lines
 . . S NUM=NUM+1,NUM1=+TMP Q:NUM1'>0  S L=$L(NUM),L1=$L(NUM1)
 . . I L>L1!(L=L1) S ONE="",TWO=$L(NUM)+1
 . . E  S ONE=$J("",L1-L),TWO=L1+1
 . . S TMP=NUM_ONE_$E(TMP,TWO,999)
 . S ^TMP("VEE","IR"_VRRS,$J,X)=TMP
 S VRRHIGH=NUM,FLAGSAVE=1
 Q
 ;
ESCD ;User hit <ESC>D to delete current line
 I $D(^TMP("VEE","SAVE",$J)) W $C(7) Q
 I $G(^TMP("VEE","IR"_VRRS,$J,YND))=" <> <> <>" W $C(7) Q
 NEW I,TMP
 F I=YND:-1:1 S ^TMP("VEE","SAVE",$J,I)=$G(^TMP("VEE","IR"_VRRS,$J,I)) Q:^(I)[$C(30)
 F I=YND+1:1 S TMP=$G(^TMP("VEE","IR"_VRRS,$J,I)) Q:TMP']""!(TMP[$C(30))!(TMP=" <> <> <>")  S ^TMP("VEE","SAVE",$J,I)=TMP
 D DELETE(1)
 Q
