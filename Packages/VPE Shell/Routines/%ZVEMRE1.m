%ZVEMRE1 ;DJB,VRR**EDIT - DO Menu Options ; 9/24/02 1:28pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
QUIT ;Call here if you should Quit after returning to ^%ZVEMRE
 S QUIT=1
 ;
 ;If in WEB mode, redraw WEB in upper right of screen
 I FLAGMODE["WEB" D MODEON^%ZVEMRU("WEB",1)
 Q
 ;
DO ;Run menu options from ^%ZVEMRE
 I $G(FLAGVPE)'["EDIT",",<ESCW>,<BS>,<DEL>,<ESCB>,<ESCD>,<ESCJ>,<RET>,"[(","_VK_",") D MSG^%ZVEMRUM(5) Q
 I $G(FLAGVPE)["LBRY",",<TAB>,<ESCR>,<ESCG>,<ESCH>,<ESCK>,"[(","_VK_",") D MSG^%ZVEMRUM(5) Q
 ;
WEB I VK="<ESCW>" D WEB^%ZVEMREP Q
 ;
 I VK="<TAB>" D ^%ZVEMRM,REDRAW1^%ZVEMRU G QUIT
 I VK="<ESCN>" D LOCATE1^%ZVEMRM,REDRAW1^%ZVEMRU G QUIT
 I VK="<ESCB>" D BREAK^%ZVEMREJ,REDRAW^%ZVEMRU(YND) Q
 I VK="<ESCR>" D PARSE^%ZVEMREP,REDRAW1^%ZVEMRU G QUIT
 I VK="<ESCG>" D GLB^%ZVEMREP Q:KEY="S"  G QUIT
 I VK="<ESCL>" D LNDOWN^%ZVEMREM Q
 I ",<ESC=>,<ESC->,<ESC_>,<ESC.>,<ESC;>,"[(","_VK_",") D INSERT Q
 ;
 ;Exit. Verify tags/lines are legal.
 I ",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VK_",") D VERIFY G QUIT
 ;
 I ",<HOME>,<END>,<F4AL>,<F4AR>,"[(","_VK_",") D RUN3^%ZVEMRER G QUIT
 I ",<PGDN>,<F4AD>,"[(","_VK_",") Q:$$ENDFILE^%ZVEMRE()  D FORWARD^%ZVEMRER G QUIT ;Page down
 I ",<PGUP>,<F4AU>,"[(","_VK_",") Q:$$TOPFILE^%ZVEMRE()  D BACKUP^%ZVEMRER G QUIT  ;Page up
 ;
 I ",<ESCH>,<ESCK>,"[(","_VK_",") D RUN2^%ZVEMRER G QUIT
 I ",<BS>,<DEL>,"[(","_VK_",") D HIGHOFF^%ZVEMRE,RUN^%ZVEMRER,HIGHON^%ZVEMRE Q
 I VK?1"<F".E1">" D HIGHOFF^%ZVEMRE,RUN^%ZVEMRER,HIGHON^%ZVEMRE Q
 I VK="<RET>" D HIGHOFF^%ZVEMRE,RETURN^%ZVEMREP,HIGHON^%ZVEMRE Q
 ;
 Q:VK?1"<".E1">".E  S FLAGSAVE=1
 D HIGHOFF^%ZVEMRE ;...Highlight off
 D ^%ZVEMREA ;.........Insert text
 D HIGHON^%ZVEMRE ;....Highlight on
 Q
 ;
VERIFY ;Verify tags/lines are legal.
 ;If FLAGQ is set to 0 by VERIFY^%ZVEMRV, user will be returned to
 ;current rtn to continue editing.
 S FLAGQ=1
 Q:$G(FLAGVPE)'["EDIT"
 I VRRS>1 D  Q
 . I $G(FLAGSAVE) D ENDSCR^%ZVEMKT2,SAVE^%ZVEMRMS
 D VERIFY^%ZVEMRV(VRRS)
 Q
 ;
INSERT ;Speed insert a line of characters (=._-), or a single ';'.
 ;Use when documenting your routine.
 NEW CD,NUM,X
 S X=$E(VK,5) ;.......Get character
 S $P(CD,X,67)="" ;...Set CD=line of character's
 I X=";" S CD="" ;....Only insert a single ';'.
 S CD=";"_CD
 S NUM=$$LINENUM^%ZVEMRU(YCUR)+1
 ;Put line into clipboard
 S ^%ZVEMS("E","SAVEVRR",$J,1)=NUM_$J("",9-$L(NUM))_$C(30)_CD
 S ^%ZVEMS("E","SAVEVRR",$J,2)="" ;Mark clipboard ending point
 D PREPASTE^%ZVEMRP1
 D REDRAW^%ZVEMRU(YND)
 Q
