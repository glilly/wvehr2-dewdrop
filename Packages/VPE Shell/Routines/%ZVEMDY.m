%ZVEMDY ;DJB,VEDD**Init,Partition,Branching,Error ; 9/23/02 1:31pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
INIT ;
 S:'$D(FLAGH) FLAGH=0
 ;If PRINTING="YES", Print option in Main Menu will be enabled.
 S PRINTING="NO" I $D(^%ZIS(1)),$D(^%ZIS(2)) S PRINTING="YES"
 I '$D(VEE("OS")) D OS^%ZVEMKY Q:FLAGQ
 I '$D(VEE("$ZE")) D ZE^%ZVEMKY1
 D INIT^%ZVEMKY
 I $D(VEE("TRMON"))#2=0 D TRMREAD^%ZVEMKY1
 Q
VGL1 ;Global Lister called from Main Menu
 I $G(FLAGVPE)["VRR" D  S FLAGG=1 Q
 . W $C(7),"   You can't call VGL when VRR is running."
 I $G(FLAGVPE)["VGL" D  S FLAGG=1 Q
 . W $C(7),"   You are already running VGL."
 I '$$EXIST^%ZVEMKU("%ZVEMG") D  S FLAGG=1 Q
 . W $C(7),"   You don't have the 'Acme Global Lister' Routines."
 I $G(DUZ(0))'["@",$G(DUZ(0))'["#" D  S FLAGG=1 Q
 . W $C(7),"   You don't have access. See Help option."
 D VGLRUN Q
VGL2 ;Global Lister called from 'Fld Global Location' option
 I $G(FLAGVPE)["VRR" D  D PAUSE^%ZVEMKC(2) Q
 . W $C(7),!!?1,"You can't call VGL when VRR is running."
 I $G(FLAGVPE)["VGL" D  D PAUSE^%ZVEMKC(2) Q
 . W $C(7),!!?1,"You are already running VGL."
 I '$$EXIST^%ZVEMKU("%ZVEMG") D  D PAUSE^%ZVEMKC(2) Q
 . W $C(7),!!?1,"You don't have the 'Acme Global Lister' Routines."
 I $G(DUZ(0))'["@",$G(DUZ(0))'["#" D  D PAUSE^%ZVEMKC(2) Q
 . W $C(7),!!?1,"You don't have access. See Help option in Main Menu."
 D VGLRUN Q
VGLRUN ;Run the Acme Global Lister
 I FLAGP D PRINT^%ZVEMDPR ;Shut off printing
 W !?1,"VGL - VGlobal Lister"
 D SYMTAB^%ZVEMKST("C","VEDD",1) ;Clear symbol table
 D ^%ZVEMG
 D SYMTAB^%ZVEMKST("R","VEDD",1) ;Restore symbol table
 S FLAGQ=1
 Q
ERROR ;Error trap.
 NEW ZE
 S @("ZE="_VEE("$ZE"))
 S FLAGE=1 KILL ^TMP("VEE","VEDD",$J)
 I ZE["<INRPT>" W !!?1,"....Interrupted.",!! Q
 D ERRMSG^%ZVEMKU1("VEDD")
 I $G(FLAGVPE)["VGL"!($G(FLAGVPE)["VRR") D PAUSE^%ZVEMKU(2)
 Q
