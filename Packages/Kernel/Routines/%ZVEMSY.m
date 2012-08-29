%ZVEMSY ;DJB,VSHL**Init,Error ; 4/6/03 8:25am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
INIT ;Initialize variables
 NEW VEESIZE,X,Y
 I $D(XQY0),$P(XQY0,"^",1)'["VSHELL" D XQY0MSG^%ZVEMSY1 I $D(XQY0) S FLAGQ=1 G EX
 D  I FLAGQ=1 W $C(7),!!?3,"*** VSHELL CURRENTLY ACTIVE ***",! G EX
 . I $G(VEESHL)="RUN" S FLAGQ=1 Q
 . I $D(XQY0),$G(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"SHL"))="RUN" S FLAGQ=1
 KILL ^%ZVEMS("%",$J_$G(^%ZVEMS("SY")))
 S ^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"SHL")="RUN"
 D KERNSAVE^%ZVEMSU ;Support for VA KERNEL
 I $G(VEE("ID"))'>0 D SETID G:FLAGQ EX
 D IO^%ZVEMKY
 D CLH^%ZVEMSY1,OS^%ZVEMKY G:FLAGQ EX
 D BS^%ZVEMKY1
 D ZE^%ZVEMKY1
 D TRMREAD^%ZVEMKY1
 D ECHO^%ZVEMKY1
 D HD^%ZVEMSY1
 D DTM^%ZVEMKY2
 I $D(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")),"KRNUCI")) D BRK^%ZVEMKY2 ;Enable Ctrl C if VShell is a VA KERNEL menu option.
 D AUDIT^%ZVEMSY1 Q:FLAGQ
EX ;
 Q
SETID ;Set VEE("ID") variable
 I $D(^XUSEC(0)) D KERN Q
 D GETID
 Q
KERN ;Get ID using VA KERNEL
 I $G(DUZ)'>0 D  D ^XUP I $G(DUZ)'>0 S FLAGQ=1 Q
 . W !!,"------------------------------------------"
 . W !,"Your DUZ isn't defined. I'm calling ^XUP."
 . W !,"------------------------------------------",!
 S FLAGQ=0 I '$D(^%ZOSF("UCI")) D GETID Q
 NEW VEEUCI X ^%ZOSF("UCI") S VEEUCI=Y
 I $D(^%ZVEMS("ID","DUZ",DUZ,VEEUCI)) D  Q
 . S VEE("ID")=$O(^%ZVEMS("ID","DUZ",DUZ,VEEUCI,""))
 . S ^%ZVEMS("ID","DUZ",DUZ,VEEUCI,VEE("ID"))=$H
 . S ^%ZVEMS("ID","SHL",VEE("ID"),VEEUCI,DUZ)=$H
 D KGETID Q:FLAGQ
 S ^%ZVEMS("ID","DUZ",DUZ,VEEUCI,VEE("ID"))=$H
 S ^%ZVEMS("ID","SHL",VEE("ID"),VEEUCI,DUZ)=$H
 Q
KGETID ;Get ID when using VA KERNEL
 NEW DEF,ID
 D IDMSG^%ZVEMSY1,DISCLAIM^%ZVEMKU1
 S DEF=$G(DUZ)
KGETID1 W !,"Enter ID Number: " I DEF W DEF_"// "
 R ID:600 S:'$T ID="^" S:ID="" ID=DEF
 I "^"[ID S FLAGQ=1 Q
 I +ID'=ID!(ID<.1)!(ID>999999) D IDHELP^%ZVEMSY1 G KGETID1
 I $D(^%ZVEMS("ID","SHL",ID,VEEUCI)) D  G KGETID1
 . W $C(7),"   This ID is already in use."
 S VEE("ID")=ID
 Q
GETID ;Get ID not using VA KERNEL
 NEW ID
 D IDMSG^%ZVEMSY1,DISCLAIM^%ZVEMKU1
GETID1 W !,"Enter ID Number: "
 R ID:600 S:'$T ID="^" I "^"[ID S FLAGQ=1 Q
 I +ID'=ID!(ID<.1)!(ID>999999) D IDHELP^%ZVEMSY1 G GETID1
 S VEE("ID")=ID
 Q
T() ;Set error trap. Called by ^%ZVEMS("ZA",1)
 KILL %1
 I $D(X)#2 S %1=X
 S X="ERROR^%ZVEMSY"
 I $D(^%ZOSF("TRAP")) Q ^("TRAP")
 Q "$ZT=X"
 ;
RESET ;Reset $T and Naked Reference
 NEW FLAGQ
 S VEE("$T")=$T
 I '$G(VEE("OS")) D OS^%ZVEMKY
 Q:'$G(VEE("OS"))
 I VEE("OS")=17!(VEE("OS")=19) D  I 1 ;GTM Mumps
 . X "I $R'[""^%ZVEMS"",$R'[""^TMP(""""VEE"""""" S VEE(""$ZR"")=$R"
 E  D  ;Non-GTM Mumps
 . X "I $ZR'[""^%ZVEMS"",$ZR'[""^TMP(""""VEE"""""" S VEE(""$ZR"")=$ZR"
 Q
 ;
ERROR ;Error trap.
 NEW ERROR,ZE
 S VEE("$T")=$T
 S @("ZE="_VEE("$ZE"))
 ;
 ;Stop error loops from occurring. If same error occurrs less than a
 ;second apart, quit VPE Shell.
 S ERROR=$G(^%ZVEMS("ERROR",VEE("ID")))
 I ERROR]"",ZE=$P(ERROR,"^",3),$P($H,",",1)=$P(ERROR,"^",1),$P($H,",",2)-$P(ERROR,"^",2)=0 D  Q
 . S VEESHC="^" ;Stop Shell
 . W !,"-------------------------------------------------------------"
 . W !,"The VPE Shell detected an error loop and shut itself down."
 . W !,"An error loop is the same error occurring twice for the same"
 . W !,"person, less than a second apart."
 . W !,"-------------------------------------------------------------"
 . W !
 S ^%ZVEMS("ERROR",VEE("ID"))=$P($H,",",1)_"^"_$P($H,",",2)_"^"_ZE
 ;
 I VEE("OS")=17!(VEE("OS")=19) D  I 1 ;GTM Mumps
 . X "I $R'[""^%ZVEMS"",$R'[""^TMP(""""VEE"""""" S VEE(""$ZR"")=$R"
 . X "I $R[""^%ZOSF(""""UCI"""")"" S VEE(""$ZR"")="""""
 E  D  ;Non-GTM Mumps
 . X "I $ZR'[""^%ZVEMS"",$ZR'[""^TMP(""""VEE"""""" S VEE(""$ZR"")=$ZR"
 . X "I $ZR[""^%ZOSF(""""UCI"""")"" S VEE(""$ZR"")="""""
 I ZE["PROT" S VEE("$ZR")="" ;Prevents repetitive <PROT> errors
 I ZE["NOSYS" S VEE("$ZR")="" ;Prevents repetitive <NOSYS> errors
 S VEE("$ZR")=$G(VEE("$ZR"))
 D USEZERO^%ZVEMSU
 I $D(VEE("TRMOFF")) X VEE("TRMOFF")
 I $D(VEE("EON")) X VEE("EON")
 W !!,"VPE Error Trap"
 W !,"Last Global: ",VEE("$ZR")
 W !,"ERROR: ",ZE,!
 I $G(IO)>0,$G(VEE("IO"))>0,IO'=VEE("IO") D  D PAUSE^%ZVEMKU(2)
 . W $C(7),!!,"---------> VSHELL ALERT!"
 . W !!,"Your IO device isn't what VShell thinks it should be. D ^%ZISC to"
 . W !,"restore your IO variables to match your login device.",!
 NEW I F I=1:1:9 KILL @("%"_I) ;Clean up parameter variables
 Q
 ;I stopped using following code. In OpenM, it caused Shell to Halt.
 ;Next, see if ^%ZOSF("VOL") has been deleted or changed.
 I '$D(^%ZVEMS("%",$J_$G(^%ZVEMS("SY")))) D  Q
 . W $C(7),!!,"W A R N I N G ! !"
 . W !!,"^%ZOSF(""VOL"") may have been alterred. This node must"
 . W !,"be set correctly for VShell to work."
 . S VEESHC="^" D PAUSE^%ZVEMKU(2)
 Q
