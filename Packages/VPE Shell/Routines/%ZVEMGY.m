%ZVEMGY ;DJB,VGL**Init,Partition,Branching,Error ; 10/11/03 2:25pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
INIT ;Initialize variables
 S GLS=$S($G(GLS)=1:GLS+1,1:1) ;GLS is the current session number.
 S ^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"GLS")=GLS ;Protect GLS variable
 S ZDELIM=$C(127)_$C(124) ;Commas
 S ZDELIM1=$C(127)_$C(126) ;Spaces
 S ZDELIM2=$C(127)_$C(64) ;Colons
 I $D(VEE("OS"))#2=0 D OS^%ZVEMKY Q:FLAGQ
 I $D(VEE("$ZE"))#2=0 D ZE^%ZVEMKY1
 I $D(VEE("TRMON"))#2=0 D TRMREAD^%ZVEMKY1
 D REVVID^%ZVEMKY2
 D INIT^%ZVEMKY
 Q
VEDD ;Call VEDD, VElectronic Data Dictionary
 I $G(FLAGVPE)["VEDD" D  D PAUSE Q
 . W $C(7),!?1,"You are already running VEDD."
 I GLS>1 D  D PAUSE Q
 . W $C(7),!?1,"You may not call VEDD from an Alternate session."
 I $T(^%ZVEMD)']"" D  D PAUSE Q
 . W $C(7),!?1,"You do not have ^%ZVEMD routine on your system."
 I $G(FLAGVPE)["VRR" D  D PAUSE Q
 . W $C(7),!?1,"You can't call VEDD when VRR is running."
 I '$$EXIST^%ZVEMKU("%ZVEMD") D  D PAUSE Q
 . W $C(7),!?1,"You don't have the 'VEDD' routines."
 D SYMTAB^%ZVEMKST("C","VGL",GLS) ;Clear symbol table
 D ^%ZVEMD
 D SYMTAB^%ZVEMKST("R","VGL",GLS) ;Restore symbol table
 Q
PAUSE ;Pause screen
 Q:$E($G(VEEIOST),1,2)="P-"  D PAUSE^%ZVEMKU(2)
 Q
ERROR ;Normal error trap.
 NEW ZE
 S @("ZE="_VEE("$ZE"))
 I '$D(GLS) S GLS=$G(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"GLS"))
 KILL ^TMP("VEE","IG"_GLS,$J)
 KILL ^TMP("VEE","VGL"_GLS,$J),^TMP("VEE",$J)
 S GLS=GLS-1
 S ^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"GLS")=GLS
 I $G(VEET("STATUS"))["START" D ENDSCR^%ZVEMKT2 ;Reset scroll region back to full screen
 S FLAGQ=1 I ZE["<INRPT>" W !!?1,"....Interrupted.",!! Q
 D ERRMSG^%ZVEMKU1("VGL")
 I $G(FLAGVPE)["VEDD"!($G(FLAGVPE)["VRR") D PAUSE^%ZVEMKU(2)
 Q
ERROR1 ;Error Trap when testing validity of CODE.
 W $C(7),!!?5,"There is an error in your code. Remember, you must set $T with"
 W !?5,"an IF statement.",!
 G CODE1^%ZVEMGO
