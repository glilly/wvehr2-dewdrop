XPDZPAT ;FGO/JHS;Simple Patch Procedure ; 12/2/05 7:21pm
 ;;8.0;KERNEL;**L33**;Jul 10, 1995
 D UCI^%ZOSV S AAQU=$P(Y,",",1) W !!,"Simple Patch/Package Installation  -  "_AAQU_"  -  " S X=$$NOW^XLFDT S AAQDT=$$FMTE^XLFDT(X) W AAQDT
 W !!,"NOTE:  Do not use this option for installs which require Logins Inhibited.",!,?7,"Instead, use AAQMENU from programmer mode with Simple Patch option."
 W !!,?7,"You can finish an install using the options under",!,?7,"the KIDS Installation Menu if it terminates abnormally,",!,?7,"or you want to interrupt the process to run other options."
 S (AAQBAK,AAQCALL,AAQFTP,AAQSEQ,AAQXMZ)=0,AAQINST=1,AAQP=""
 G ENPAT^XPDZPRE
CHKRL G:AAQRL="L" ASKCHK
 G INCK
ASKCHK ; Load a Distribution
 G:^%ZOSF("OS")'["OpenM-NT" LOAD S %=1 R !!,"==> Do you want to check your Download Directory for the file" D YN^DICN G:$D(DTOUT) EXIT G:%=2 LOAD I %=0 W !!,"Answer YES for a quick lookup of the file with an optional rename."
 G:%Y="^" EXIT
 I %=1 D ^AAQFILE G:AAQFN="" EXIT G LOAD
 G ASKCHK
LOAD W ! D EN1^XPDIL G:$D(DUOUT)!$D(DTOUT) EXIT G PRE
INCK S XMR=^XMB(3.9,AAQXMZ,0),XMP2="I" D MM^XMP2 S XCF=2 D ENH^XMP2A
PRE ; Pre-Install Checksums
 W !!,"==> Pre-Install Checksums will run now."
 K ^DISV(DUZ,"^XPD(9.7,") ;Prevent selection with spacebar-return
 S AAQUCI=AAQU D TRN^XPDZCHK G:$D(DUOUT)!$D(DTOUT) EXIT
 G:$D(AAQPAT) SPAT W $C(7),!!,"A Patch INSTALL NAME was not selected."
SPAT S AAQP=AAQPAT
VER ; Verify Checksums in Transport Global
 W !!,"==> KIDS Verify Checksums option will run now."
 S AAQUCI=AAQU,D0=AAQD0,Y="PNT^XPDZVER(9.7)" D ENBAT^XPDZVER
BAK ; Backup a Transport Global
 W !,"==> KIDS Backup will run now.",!
 S AAQUCI=AAQU D ^XPDZIB G:$D(DUOUT)!$D(DTOUT) EXIT
 ; Install Package
 W !,"==> KIDS Install option will run now.",!
 S XPDIDVT=0 ;Disable Graphical Progress Bar for clean screen capture
 D EN^XPDI G:$D(DUOUT)!$D(DTOUT) EXIT
CHKQ ; Check for queued or not installed
 I '$D(^XPD(9.6,"B",AAQP)) W !!,"The KIDS Build "_AAQP_" has not been installed or has been queued.",!,"Remember to run the Post-Install Checksums after installation." G CHKDEL
POST ; Post-Install Checksums
 W !!,"==> Post-Install Checksums will run now."
 S D0=0,D0=$O(^XPD(9.6,"B",AAQP,D0)) S AAQD0=D0,AAQPAT=AAQP D ENBLD^XPDZCHK
CHKDEL ; Alpha/OpenM-NT, Delete KIDS file from Download Directory
 I AAQRL="L",^%ZOSF("OS")["OpenM-NT" W !,"==> The KIDS file can be deleted from your Download Directory now." D ^AAQFILE
REM W !!,"==> REMINDER: Check the Patch Description for Post-Install procedures."
 W !,"Simple Patch Installation Finished  -  "_AAQU_"  -  " S X=$$NOW^XLFDT W $$FMTE^XLFDT(X),!
 G:'$D(^VA(200,"B","PATCHES,ALL D")) CKUPDT
 G:'$D(XMZ) CKUPDT
 S XMY("PATCHES,ALL D")="" D ENT1^XMD
 W !,"Forwarding message #"_XMZ_" to PATCHES,ALL D.",!
CKUPDT ;;I $D(^DIZ(437016,0)),AAQU="VAH" D ^XPDZUPDT
 I $D(^DIZ(437016,0)),AAQU="EHR" D ^XPDZUPDT
 ; Checking the Status of TaskMan
 ; Code is current as of XU*8*137 SEQ #123
 I $D(^%ZTSCH("WAIT")) W $C(7),!!,"Taskman has been Placed In a Wait State." G ASKREM
 G CKSTOP
ASKREM S %=1 R !!,"Do you want to 'Remove Taskman from WAIT State'" D YN^DICN G:$D(DTOUT) CKSTOP D:%=1 RUN^ZTMKU I %=0 W !!,"Answer NO to leave Taskman in same status for another patch." G ASKREM
 G:%Y="^" CKSTOP
 I %=-1 W $C(7) G ASKREM
CKSTOP I $D(^%ZTSCH("STOP","MGR")) W $C(7),!!,"Taskman has been Stopped." G ASKRES
 G ASKRET
ASKRES S %=1 R !!,"Do you want to 'Restart Task Manager'" D YN^DICN G:$D(DTOUT) ASKRET D:%=1 RESTART^ZTMB I %=0 W !!,"Answer NO to leave Taskman in same status for another patch." G ASKRES
 G:%Y="^" ASKRET
 I %=-1 W $C(7) G ASKRES
ASKRET R !,"Press RETURN to Continue:",X:DTIME
EXIT W @IOF K AAQBAK,AAQBX,AAQD0,AAQFILE,AAQFN,AAQFTP,AAQINST,AAQLN2,AAQLN3,AAQP,AAQP1,AAQP2,AAQP3,AAQPAT,AAQPX,AAQPRE,AAQRL,AAQROU,AAQSEQ,AAQSUB,AAQU,AAQUCI,AAQX1,AAQX12,AAQX2,AAQX3,AAQXM,AAQXMZ,POP,Z
 ;AAQFILE and AAQFN set in AAQFILE, AAQROU set in XPDZIB, DTOUT and DUOUT killed by EXPRE
 D EXPRE K ^TMP($J),^UTILITY($J),%,%Y,%Z,%ZO,DA,DIE,DIF,D0,DDH,DIC,I,T,X,XCF,XCN,XMDISPI,XMDUZ,XMP2,XMR,XMZ,XPD,XPDIDVT,XQM,Y Q
EXPRE K AAQAERR,AAQAP,AAQAP1,AAQAP2,AAQAP3,AAQCALL,AAQCOM,AAQCONT,AAQDL,AAQDLX,AAQDT,AAQDUZ,AAQIERR,AAQIN,AAQINDT,AAQIRM
 K AAQLINE,AAQPKG,AAQPNO,AAQPNSV,AAQPV,AAQSERR,AAQSQ,AAQSQSV,AAQSYS,AAQSYSX,AAQTOT,AAQTXT,AAQTYP,AAQVERR,AAQX,AAQZN,DATE,DTOUT,DUOUT,IFN,K,RV0,RV1,VERSION Q
