ZVEMBLDL ;DJB,VSHL**VPE Setup - Load Editor & Shell ; 9/7/02 2:06pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
TOP ;
 D SHELL
 I FLAGQ D  G EX
 . W !!,"VPE Shell global not loaded."
 D EDITOR
 W !!,"VPE Programmer Shell successfully loaded."
 W !,"VPE full screen routine editor successfully loaded."
 W !,"Initialization finished."
 W !!,"NOTE: To start the VPE Shell, type:  X ^%ZVEMS"
 R !!,"<RETURN> to continue..",XX:300
 D DISCLAIM^%ZVEMKU1
EX ;
 Q
 ;===================================================================
SHELL ;Load VPE Shell Global - ^%ZVEMS
 S FLAGQ=0
 ;W !!?2,"S T E P   2",!
 D YESNO^ZVEMBLD("Load VPE Shell global: YES// ")
 Q:FLAGQ
 D ALL^ZVEMSG
 Q
 ;
EDITOR ;Load Editor into ^%ZVEMS("E") global
 NEW CODE,I,TXT
 ;S FLAGQ=0
 ;W !!?2,"S T E P   1",!
 ;D YESNO^ZVEMBLD("Install 'VPE Routine Editor': YES// ")
 ;Q:FLAGQ
EDITOR1 ;
 S TXT=$T(CODE+1)
 S CODE=$P(TXT,";",3,99)
 KILL ^%ZVEMS("E")
 S ^%ZVEMS("E")=CODE
 F I=2:1 S TXT=$T(CODE+I) Q:$P(TXT,";",3)="***"  S CODE=$P(TXT,";",3,99),^%ZVEMS("E",I-1)=CODE
 Q
 ;
CODE ;Global for Rtn editing
 ;;X ^%ZVEMS("E",3) Q:$G(DUZ)=""  NEW FLAGSAVE,FLAGVPE,VEES NEW:$G(VEE("OS"))']"" VEE X ^%ZVEMS("E",4) Q:'$D(^TMP("VEE","VRR",$J))  X ^%ZVEMS("E",1) KILL ^UTILITY($J) L
 ;;NEW %Y,VRRPGM,X D SAVE^%ZVEMRC(1) Q:$G(VRRPGM)']""  X ^%ZVEMS("E",2)
 ;;NEW X S X=VRRPGM X VEES("ZS"),^%ZVEMS("E",5)
 ;;Q:$G(DUZ)>0  S ^TMP("VEE",$J,1)=$G(%1),^(2)=$G(%2) D ID^%ZVEMKU S:$G(VEESHL)="RUN" %1=^TMP("VEE",$J,1),%2=^(2) KILL ^TMP("VEE",$J)
 ;;S $P(FLAGVPE,"^",4)="EDIT" D PARAM^%ZVEMR($G(%1),$G(%2))
 ;;Q:VEE("OS")'=17&(VEE("OS")'=19)  NEW LINK,PGM S PGM=VRRPGM,PGM=$TR(PGM,"%","_") S LINK="ZLINK """_PGM_"""" X LINK
 ;;***
