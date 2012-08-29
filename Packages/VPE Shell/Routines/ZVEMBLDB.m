ZVEMBLDB ;DJB,VSHL**VPE Setup - Pages 4-7 ; 1/5/04 7:48am
 ;;10;VPE;COPYRIGHT David Bolduc @1993
PAGE4 ;Instructions for upgrading VPE
 W @FF,!!?2,"U P G R A D E"
 W !!?2,"IF YOU CURRENTLY HAVE AN EARLIER VERSION OF VPE ON YOUR"
 W !?2,"SYSTEM, FOLLOW THESE INSTRUCTIONS TO UPGRADE SMOOTHLY."
 W !!?2,"1) Have all users save their QWIKs (Use ..QSAVE System QWIK)."
 W !?2,"2) Make sure all users have halted off VPE Shell."
 W !?2,"3) Delete routines ^ZVEM*, ^%ZVEM*, and ^VEEM*."
 W !?2,"4) Kill global ^%ZVEMS."
 W !?2,"5) Load VPE_xx.MGR routines from the disk."
 W !?2,"6) DO ^ZVEMBLD to install VPE."
 W !?2,"7) Load VPE_xx.PRD routines from the disk."
 W !?2,"8) DO ^VEEMINIT to install VPE Fileman files."
 W !?2,"9) Start VPE Shell and run ..QSAVE to restore your QWIKs."
 W !?1,"10) Run ..PARAM to adjust your parameters."
 W !!!!! D ASK^ZVEMBLD
 Q
PAGE5 ;
 W @FF,!!?2,"D E I N S T A L L"
 W !!!?2,"To completely deinstall VPE do the following:"
 W !!?2,"1) GLOBALS:      MGR      KILL ^%ZVEMS"
 W !!?2,"2) ROUTINES:     MGR      DELETE ^%ZVEM*"
 W !?2,"                 MGR      DELETE ^ZVEM*"
 W !?2,"                 PRD      DELETE ^VEEM*"
 W !?2,"3) FILES:        PRD      DELETE VPE* files in FM"
 W !!!!!!!!! D ASK^ZVEMBLD
 Q
PAGE6 ;Modules list
 W @FF,!!?2,"V P E   M O D U L E S   L I S T"
 W !!?40,"ROUTINES",?58,"ACTION"
 W !?40,"--------",?54,"---------------"
 W !?4,"VGL...Global Lister/Editor..........^%ZVEMG*......DO ^%ZVEMG"
 W !?4,"VRR...Routine Reader................^%ZVEMR*......DO ^%ZVEMR"
 W !?4,"E.....Routine Editor...............................X ^%ZVEMS(""E"")"
 W !?4,"VEDD..Electronic Data Dictionary...^%ZVEMD*......DO ^%ZVEMD"
 W !?4,"      VPE Shell.....................^%ZVEMS*.......X ^%ZVEMS"
 W !!!!!!!!!!! D ASK^ZVEMBLD
 Q
