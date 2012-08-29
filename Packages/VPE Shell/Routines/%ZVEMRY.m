%ZVEMRY ;DJB,VRR**Init,Branching,Error ; 9/23/02 1:31pm
 ;;12;VPE;COPYRIGHT David Bolduc @1993
 ;
INIT ;Initialize variables
 NEW X,Y
 S VRRS=$S($G(VRRS)="":1,1:(VRRS+1)) ;VRRS=# of pgms you are viewing
 D INIT^%ZVEMKY Q:$G(FLAGVPE)["VRR"
 I $D(VEE("OS"))#2=0 D OS^%ZVEMKY Q:FLAGQ
 I $D(VEE("$ZE"))#2=0 D ZE^%ZVEMKY1
 I $D(VEE("TRMON"))#2=0 D TRMREAD^%ZVEMKY1
 D REVVID^%ZVEMKY2
 D BS^%ZVEMKY1
 D SCRNVAR^%ZVEMKY2
 D BLANK^%ZVEMKY3
 D WRAP^%ZVEMKY2 W @(VEES("NOWRAP"))
 Q
VGL ;Run the VGlobal Lister
 I $G(VRRS)>2 D  D PAUSE^%ZVEMKC(1) Q
 . W $C(7),!?1,"You can't call VGL if you've branched to more than 2 programs."
 I $G(DUZ(0))'["@",$G(DUZ(0))'["#" D  D PAUSE^%ZVEMKC(1) Q
 . W $C(7),!?1,"You don't have access. See Help option."
 I '$$EXIST^%ZVEMKU("%ZVEMG") D  D PAUSE^%ZVEMKC(1) Q
 . W $C(7),!?1,"You don't have the 'VGlobal Lister' Routines."
 D SYMTAB^%ZVEMKST("C","VRR",VRRS) ;Clear symbol table
 D ^%ZVEMG X VEES("RM0")
 D SYMTAB^%ZVEMKST("R","VRR",VRRS) ;Restore symbol table
 Q
VEDD ;Call VEDD, VElectronic Data Dictionary
 I $G(VRRS)>2 D  D PAUSE^%ZVEMKC(1) Q
 . W $C(7),!?1,"You can't call VEDD if you've branched to more than 2 programs."
 I '$$EXIST^%ZVEMKU("%ZVEMD") D  D PAUSE^%ZVEMKC(1) Q
 . W $C(7),!?1,"You don't have the 'VElectronic Data Dictionary' Routines."
 D SYMTAB^%ZVEMKST("C","VRR",VRRS) ;Clear symbol table
 D DIR^%ZVEMD X VEES("RM0")
 D SYMTAB^%ZVEMKST("R","VRR",VRRS) ;Restore symbol table
 Q
RSE ;Search Routine for string(s)
 I $G(VRRS)>2 D  D PAUSE^%ZVEMKC(1) Q
 . W $C(7),!?1,"You can't do Routine Search if you've branched to more than 2 programs."
 D ^%ZVEMRSS
 Q
ERROR ;Error trap.
 NEW ZE
 S @("ZE="_VEE("$ZE"))
 I ZE["<INRPT>" W !!?1,"....Interrupted.",!!
 E  D ERRMSG^%ZVEMKU1("VRR")
 D PAUSE^%ZVEMKU(2)
 S:$G(VRRS)'>0 VRRS=1 G EX^%ZVEMR
 Q
ERROR1 ;Error trap
 I $D(VEE("TRMOFF")) X VEE("TRMOFF")
 I $D(VEE("EON")) X VEE("EON")
 D ENDSCR^%ZVEMKT2
 D ERRMSG^%ZVEMKU1("VRR"),PAUSE^%ZVEMKU(2)
 D REDRAW1^%ZVEMRU
 Q
