AAQJPINQ ;FGO/JHS - Inquire for Patch Record ;10-06-97 [10/23/02 5:14pm]
 ;;1.4;AAQJ PATCH RECORD;; May 14, 1999
 S (AAQINS,AAQDONE,AAQNOF,AAQTST,AAQTSW)=0,U="^",DIC="^DIZ(437016,",DIC(0)="AEQM" D ^DIC W !
 S AAQJDA=+Y,AAQJPKG=$P(Y,U,2),AAQPKG=AAQJPKG G:Y=-1 EXITK
 S DIC="^DIZ(437016,AAQJDA,1,",DIC(0)="AEQM",DIC("A")="Select PATCH: "
 D ^DIC W ! I Y=-1 W $C(7),"No Patch selected.  Exiting." G EXITK
 S DA=+Y,AAQDA=DA,AAQJPAT=$P(Y,U,2),AAQPAT=AAQJPAT D INIT^XMVVITAE
MRP ; Entry point for Most Recent Patch option
 D CKUCI S DIC="^DIZ(437016,",FLDS="[AAQJ INQUIRE]",BY="[AAQJ PKG/PATCH RANGE]",DHD="[AAQJ INQ HEADING]",DHIT="D PINST^AAQJPINQ",DIOEND="D EN^AAQJIDOC"
 S FR(1)=AAQJPKG,TO(1)=AAQJPKG,FR(2)=AAQJPAT,TO(2)=AAQJPAT
 S AAQPLN=10 ;Print lines for Inquire
 D EN1^DIP G DONE
PINST S AAQPLN=5 I AAQINS=1 S AAQPLN=10 ;Print lines with/without install
 S (AAQIN,AAQTSW)=0 I AAQJPAT["S" D:AAQNOF=0 NOF G DONE
 ;Support Patch will not have #9.7 entry
 I AAQJPAT["L" S AAQPAT=$P(AAQJPAT,"L",2),AAQP1=$P(AAQJPKG,"*",1),AAQP2=$P(AAQJPKG,"*",2),AAQPKG=AAQP1_"Z*"_AAQP2 ;Strip L, add Z to Nmsp
 I AAQPAT<10 S AAQPAT=+AAQPAT ;Strip leading zero
 D LKUP I '$D(^XPD(9.7,"B",AAQP)) D:AAQNOF=0 NOF G DONE
NEXT S AAQIN=$O(^XPD(9.7,"B",AAQP,AAQIN)) G:AAQIN="" EXIT
 D LKUP S AAQP3=$P(AAQP,AAQPKG,2),AAQP3=$P(AAQP3,"*",2)
 G:AAQP3'=AAQPAT EXIT
 I IOST["C-" D CKRET
 I IOST["P-" D CKHDR
SETBEG S AAQBEG=$P($G(^XPD(9.7,AAQIN,1)),U,1),AAQEND=$P($G(^XPD(9.7,AAQIN,1)),U,3) S AAQSTA=$P($G(^XPD(9.7,AAQIN,0)),U,9) DO STA
 S AAQDUZ=$P($G(^XPD(9.7,AAQIN,0)),U,11) I AAQDUZ="" S AAQDUZ="Unknown" G SETCOM
 S AAQDUZ=$P(^VA(200,AAQDUZ,0),U,1)
SETCOM S AAQCOM=^XPD(9.7,AAQIN,2)
 I AAQCOM["TEST" D:AAQTSW=0 TEST
WRTI W !,?6,"Install: ",AAQP," "_AAQSTAX," by ",AAQDUZ
 S AAQDT=AAQBEG D DT W !,?6,"Start Time: ",AAQINX
 S AAQDT=AAQEND D DT W !,?6,"Stop Time:  ",AAQINX
 W !,?6,"Comment: ",$E(AAQCOM,1,48),! S IOY=IOY+5
 G NEXT
DT I AAQDT="" S AAQINX="Unknown"
 E  S AAQINX=$$FMTE^XLFDT(AAQDT,"2ZP")
 Q
STA I AAQSTA=0 S AAQSTAX="Loaded from Distribution" Q
 I AAQSTA=1 S AAQSTAX="Queued for Install" Q
 I AAQSTA=2 S AAQSTAX="Start of Install" Q
 I AAQSTA=3 S AAQSTAX="Install Completed" Q
 I AAQSTA=4 S AAQSTAX="De-Installed" Q
 S AAQSTAX="Status Unknown" Q
 ; Changed the following line from Q:AAQX="" to Q:(+AAQX'>0) -JFW
CKUCI S (AAQT,AAQTST,AAQV,AAQX)=0 F  S AAQX=$O(^DIZ(437016,AAQJDA,1,DA,2,AAQX)) Q:(+AAQX'>0)  D
 .S AAQSYS=^DIZ(437016,AAQJDA,1,DA,2,AAQX,0)
 .I $E(AAQSYS,1,1)="T" S AAQT=AAQT+1
 .I $E(AAQSYS,1,1)="V" S AAQV=AAQV+1
 .I AAQT=1 S AAQTST=1
 .I AAQV=1 S AAQTST=0
 Q
LKUP S AAQP=AAQPKG_"*"_AAQPAT ;Lookup value for LOCAL and Released
 I AAQJPAT["V" S AAQPAT=$P(AAQJPAT,"V",1),AAQP=AAQPKG_"*"_AAQPAT ;Lookup value for TEST Patch
 Q
NOF Q:AAQNOF=1  S AAQNOF=1 W !,?5,"Patch Number not found in the INSTALL File (#9.7)." S IOY=IOY+2 Q
TEST Q:AAQINS=1  S AAQTSW=1 I IOY>(IOSL-4) D CKRET
 W !,"NOTE: The Install File lookup appears to have found a Test Patch.",!,?6,"It will attempt to find more versions of the same Test Patch,",!,?6,"and the Verified Patch with the same number.",! S IOY=IOY+4 Q
EXIT Q:AAQINS=1  I AAQTSW=1,AAQTST=1 D UPDT ;AAQINS set by ASKINS^AAQJL80
DONE Q:AAQINS=1  S AAQDONE=1,DN=0 ;If AAQINS=1, File #9.7 info on List 80
 ; DN=0 used to avoid <UNDEFINED>XDY+1^DIO2 if BROWSER selected
EXITK ; This line tag is also called by the routine AAQJL80
 K AAQBEG,AAQCOM,AAQDT,AAQDUZ,AAQEND,AAQIN,AAQINX,AAQP1,AAQP2,AAQP3,AAQNOF,AAQP,AAQPLN,AAQSHDR,AAQSTA,AAQSTAX,AAQSYS,AAQT,AAQV,AAQX
 D ^%ZISC K %ZIS,BY,DA,DDH,DHD,DHIT,DIC,FLDS,FR,IOY,POP,RV0,RV1,TO,Y Q
 ; AAQJDA,AAQJPAT,AAQJPKG,AAQPAT,AAQPKG,AAQTST,AAQTSW are killed
 ; at EXITK^AAQJIDOC ;AAQINS Killed by AAQJL80.
EXITA ; Called by [AAQJ PATCH INQUIRE] Menu Exit Action.
 K AAQDA,AAQDONE,AAQINS,DIOEND D EXITK^AAQJIDOC Q
CKRET I (IOY>(IOSL-6))!($Y>(IOSL-6)) R !,"Press RETURN to Continue: ",AAQX:20 D HDR
 Q
CKHDR I (IOY>(IOSL-AAQPLN))!($Y>(IOSL-AAQPLN)) D HDR
 Q
HDR W @IOF
HDR1 I FLDS["LIST" G LHDR
 W ?1,"PATCH INQUIRE - " D UCI^%ZOSV W $P(Y,",") W ?55,$$HTE^XLFDT($H,"1M") S IOY=6
 W !!,?15,"METHOD"
 W !,?15,"MESSAGE# BACKUP#",?35,"SUBJECT"
 W !,?1,"NO.",?8,"SEQ#",?15,"ROUTINE MULTIPLE",?35,"UCI  DATE/TIME",?62,"INITIALS"
 W !,?1,"---------------------------------------------------------------------------"
 Q
LHDR W ?1,"PATCH LIST 80 - " D UCI^%ZOSV W $P(Y,",") W ?55,$$HTE^XLFDT($H,"1M") S IOY=6
 I $D(AAQSHDR) W !,?1,AAQSHDR S IOY=IOY+1
 W !!,?15,"METHOD",?35,"SUBJECT"
 W !,?1,"NO.",?6,"SEQ#",?15,"MESSAGE# BACKUP#",?35,"UCI  DATE/TIME",?62,"INITIALS"
 W !,?1,"---------------------------------------------------------------------------"
 Q
UPDT Q:AAQJPAT["V"  I IOY>(IOSL-14) D CKRET
 S RV1="$C(27,91,55,109)",RV0="$C(27,91,109)" ;Reverse Video VT100
 W ! W:IOST["C-" @RV1 W "UPDATE NOTICE:" W:IOST["C-" @RV0
 W " If this patch shows only TST UCI information in the",!,"Patch Record and has 'TEST v' in the Comment field of the INSTALL File,",!,"you may have to use Enter/Edit Patch Record to update another entry."
 W !!,"The KIDS INSTALLATION message used by Simple Patch does not contain",!,"any data which can identify a TEST Patch.  The message sent from",!,"TST to VAH can only do the update using the patch number."
 W !!,"When a TEST Patch is installed in VAH, it can be indentified and is",!,"designated as a TEST Patch with a Version number.  Check for a TEST",!,"patch with this same patch number and a Version number."
 W !!,"If a matching TEST patch is found, update that record with install data",!,"for the TST UCI, and delete the entry created by the automatic update",!,"from TST." Q
