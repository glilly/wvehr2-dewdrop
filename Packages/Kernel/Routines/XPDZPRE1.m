XPDZPRE1 ;FGO/JHS; Pre-Install Patch Check ; 8/19/03 11:03am
 ;;8.0;KERNEL;**L33**;Jul 10, 1995
VERS W !,"Checking if Patch is for Current Version of Package."
 I AAQP2="DBA" W !!,"DBA Patches are not checked for Current Version." G INST
 S AAQX=AAQP1 S:AAQP1["Z" AAQX=$P(AAQP1,"Z")
 I '$D(^DIC(9.4,"C",AAQP1)) D RV1NOTE W "Sorry.  Package couldn't be found with "_AAQP1_" Prefix." G VERERR
 D VERSION
 I AAQP2=VERSION W !,"Current Version "_VERSION_" agrees with this Patch."
 E  D RV1NOTE W "Current Version "_VERSION_" does NOT agree with this Patch." S AAQVERR=1
 S AAQPKG=$P(^DIC(9.4,IFN,0),U) W !,AAQPKG," Version ",VERSION," was installed "_$$FMTE^XLFDT(DATE),".",! G INST
VERERR S AAQVERR=1
INST I '$D(^XPD(9.7,"B",AAQP)) W !,"There is No Record in the INSTALL File",!,"of this Patch being previously installed.",! G SEQ
 S AAQIN=0,AAQIN=$O(^XPD(9.7,"B",AAQP,AAQIN)) S AAQINDT=$P($G(^XPD(9.7,AAQIN,1)),U,3) I AAQINDT="" G NOTIN
 S AAQDUZ=$P($G(^XPD(9.7,AAQIN,0)),U,11) I AAQDUZ="" S AAQDUZ="Unknown" G SETCOM
 S AAQDUZ=$P(^VA(200,AAQDUZ,0),U,1)
SETCOM S AAQCOM=^XPD(9.7,AAQIN,2)
 S AAQINDT=$$FMTE^XLFDT(AAQINDT)
 D RV1NOTE W "INSTALL file shows at least one ",AAQP," already installed." S AAQIERR=1
 W !,"First installed ",AAQINDT," by ",AAQDUZ,"."
 W !,"Partial Install Comment: ",$E(AAQCOM,1,40),! G SEQ
NOTIN W !,"Install Complete Time for this patch was not found in INSTALL file.",!
SEQ I IOST["C-",$Y>(IOSL-4) R !,"  Press RETURN to Continue: ",AAQX:20 S $Y=0 W !
 G:AAQU="VAH" CHKSEQ
 W !,"The Pre-Install Checks for Sequence Number and Associated Patches",!,"can only be done with the Patch Record in the VAH account." Q
CHKSEQ W !,"Checking the Patch Sequence Numbers for the correct order."
 I AAQSEQ=0 D RV1NOTE W "This patch has SEQ #0.  Sequence Numbers cannot be checked." G SEQBAD
 S AAQSQSV=0,AAQZN=0
 S X=AAQP12,DIC="^DIZ(437016," S DIC(0)="XM" D ^DIC S AAQPV=+Y
 I Y=-1 D RV1NOTE W "This PKG*VER is not found in the Patch Record.",!,"The Patch Sequence number will not be checked." G ASSOC
 F K=0:0 S AAQZN=$O(^DIZ(437016,AAQPV,1,AAQZN)) Q:AAQZN="B"  D
 .I AAQZN="" W !,"This appears to be the first patch for the PKG*VER, so SEQ# cannot be checked." G ASSOC
 .S AAQSQ=$P($G(^DIZ(437016,AAQPV,1,AAQZN,0)),U,3)
 .S AAQPNO=$P(^DIZ(437016,AAQPV,1,AAQZN,0),U)
 .I AAQSQ=AAQSEQ D RV1NOTE W "SEQ #",AAQSEQ," has already been entered for the ",AAQP12," package." S AAQSERR=1 Q
 .I AAQSQ>AAQSQSV S AAQSQSV=AAQSQ,AAQPNSV=AAQPNO
 I AAQSQSV=0,AAQSEQ=1 S AAQSQSV=AAQSEQ,AAQPNSV=AAQP3 G SEQ1
 I AAQSERR=1 G SEQBAD
 I AAQSQSV=0,AAQSEQ'=1 D RV1NOTE W "The Sequence Number for Patch ",AAQP," cannot be checked.",!,"There are no SEQ #'s for the ",AAQP12," package in the Patch Record." G SEQBAD
SEQ1 W !,"Patch #",AAQPNSV," with SEQ #",AAQSQSV," has the highest Sequence Number." G:AAQSEQ=1 ASSOC
 S AAQAP2=AAQP3 I $L(AAQP3)<2 S AAQAP2="0"_AAQP3
 W !,"Patch #",AAQP3," with SEQ #",AAQSEQ," is being compared for pre-install."
 I AAQSQSV=AAQSEQ D RV1NOTE W !,"The highest SEQ # installed is equal to the SEQ # for this patch." G SEQBAD
 S AAQSQ=AAQSEQ-AAQSQSV I AAQSQ'=1 D RV1NOTE W "The difference between these Sequence Numbers is not equal to 1.",!,"It appears something may have been installed out of sequence." G SEQBAD
 W !,"Patch ",AAQP," is OK for the sequence number order." G ASSOC
SEQBAD W !,"Patch ",AAQP," may have a problem with sequence number order." S AAQSERR=1
ASSOC S AAQAP="No Associated patches found in Message." Q:AAQXMZ'>0
 S AAQLINE=0 W !!,"Looking for Associated patches."
GETAP S AAQLINE=$O(^XMB(3.9,AAQXMZ,2,AAQLINE)) Q:AAQLINE=""  S AAQTXT=^XMB(3.9,AAQXMZ,2,AAQLINE,0)
 Q:$E(AAQTXT,1,4)="$END"  ;Quit for PackMan Patch Message
 Q:AAQTXT["Released By"  ;Quit for FTP Patch Message
 I AAQTXT["(v)" S AAQAP=$P(AAQTXT,"(v)",2) S AAQAP=$P(AAQAP," ") S AAQAP=$P(AAQAP,"<<") W !!,AAQAP D CHKAP
 I AAQTXT["(u)" S AAQAP=$P(AAQTXT,"(u)",2) S AAQAP=$P(AAQAP," ") S AAQAP=$P(AAQAP,"<<") W !!,AAQAP D CHKAP
 I IOST["C-",$Y>(IOSL-4) R !,"  Press RETURN to Continue: ",AAQX:20 S $Y=0 W !
 G GETAP
CHKAP I '$D(^DIZ(437016,0)) Q  ;Check Patch Record
 I AAQU'="VAH" W !,"Patch Record can only be checked in VAH." Q  ;Could check #9.7 in TST, but data may be unreliable after Restore/Reset
 ;;I '$D(^DIZ(437016,"B",AAQP12)) D RV1NOTE W "This PKG*VER is not found in the Patch Record." S AAQAERR=1 Q
 S X=AAQP12,DIC="^DIZ(437016," S DIC(0)="XM" D ^DIC S AAQPV=+Y
 S AAQDL="*",AAQAP1=$P(AAQAP,"*",1),AAQAP2=$P(AAQAP,"*",2),AAQDLX=AAQAP2_AAQDL,AAQAP3=$P(AAQAP,AAQDLX,2)
 I $L(AAQAP3)<2 S AAQAP3="0"_AAQAP3
 I $E(AAQAP2,1,1)="." S AAQAP2="0"_AAQAP2
 G:AAQAP2="DBA" SX12
 I AAQAP2'["." S AAQAP2=AAQAP2_".0"
SX12 S AAQX12=AAQAP1_AAQDL_AAQAP2,AAQX3=AAQX12_AAQDL_AAQAP3
 S X=AAQX12,DIC="^DIZ(437016," S DIC(0)="XM" D ^DIC S AAQPV=+Y
 S X=AAQAP3,DIC="^DIZ(437016,AAQPV,1," S DIC(0)="XM" D ^DIC S AAQPNO=+Y
 I Y=-1 D RV15NOTE W "Patch #"_AAQAP3_" is not found in the Patch Record." S AAQAERR=1 Q
 W ?15,"SEQ #",$P($G(^DIZ(437016,AAQPV,1,AAQPNO,0)),U,3)
 S AAQX=0 W ?25,$P(^DIZ(437016,AAQPV,1,AAQPNO,0),U,2)
 ; Changed following line fr AAQX="" to (+AAQX'>0)  L33/JFW
 F  S AAQX=$O(^DIZ(437016,AAQPV,1,AAQPNO,2,AAQX)) Q:(+AAQX'>0)  D
 .S AAQSYS=^DIZ(437016,AAQPV,1,AAQPNO,2,AAQX,0)
 .S AAQDT=$P(^DIZ(437016,AAQPV,1,AAQPNO,2,AAQX,0),U,2)
 .S AAQIRM=$P(^DIZ(437016,AAQPV,1,AAQPNO,2,AAQX,0),U,3)
 .I $E(AAQSYS,1,1)="T" S AAQSYSX="TST"
 .I $E(AAQSYS,1,1)="V" S AAQSYSX="VAH"
 .W !,?25,"Installed in ",AAQSYSX," on ",$$FMTE^XLFDT(AAQDT)," by ",AAQIRM
 Q
VERSION ;Version & Date code from A5CSTAU; SLC/STAFF
 S IFN=+$O(^DIC(9.4,"C",AAQX,0))
 S VERSION=$G(^DIC(9.4,IFN,"VERSION"))
 S DATE=$$DATE(IFN,VERSION)
 ; if package installed but no 'CURRENT VERSION' in Package file
 I VERSION,'DATE S DATE=$$DATE(IFN,VERSION)
 I 'DATE,VERSION,VERSION'[".",VERSION=+VERSION S VERSION=VERSION_".0",DATE=$$DATE(IFN,VERSION)
 Q
DATE(IFN,VERSION) ; $$(package ifn,version) -> date of install
 N IFN1
 I 'VERSION Q ""
 S IFN1=+$O(^DIC(9.4,IFN,22,"B",VERSION,0))
 Q $P($G(^DIC(9.4,IFN,22,IFN1,0)),U,3)
LKUP S X=AAQP12,DIC="^DIZ(437016,",DIC(0)="XM" D ^DIC I +Y>0 S AAQPV=+Y
 I '$D(^DIZ(437016,"B",AAQP12)) D
 .S X=AAQP12,DIC="^DIZ(437016," S DIC(0)="ML" D FILE^DICN
 .S AAQPV=+Y
 I $L(AAQP3)<2 S AAQP3="0"_AAQP3
 S AAQPNO=AAQP3
 I $D(^DIZ(437016,AAQPV,1,"B",AAQP3)) S DA=0,DA=$O(^DIZ(437016,AAQPV,1,"B",AAQP3,DA)) S AAQPNO=DA,DA(1)=AAQPV,DIC="^DIZ(437016,"_DA(1)_",1," G CKFWD
 I '$D(^DIZ(437016,AAQPV,1,"B",AAQP3)) D
 .S:'$D(^DIZ(437016,AAQPV,1,0)) DIC("P")=$P(^DD(437016,1,0),"^",2)
 .S DA(1)=AAQPV,DIC="^DIZ(437016,"_DA(1)_",1,",X=AAQP3,DIC(0)="L",DLAYGO=437016
 .D ^DIC S AAQPNO=+Y
CKFWD I AAQRL="F"!"R" D FWD
 G:'$D(^VA(200,"B","PATCHES,ALL D")) UPDT
 G:'$D(XMZ) UPDT
 S XMY("PATCHES,ALL D")="" D ENT1^XMD
 W !!,"Forwarding message #"_XMZ_" to PATCHES,ALL D."
UPDT W !!,"Doing Partial Update of the Patch Record now."
 K DD,D0 S DIE=DIC,DA=AAQPNO,DR="1.43///^S X=AAQXMZ;1.44///^S X=AAQBAK" D ^DIE
 I AAQRL="F",AAQINST=1 K DD,D0 S DIE=DIC,DA=AAQPNO,DR="1.3///^S X=AAQSEQ" D ^DIE ;To avoid warning, update SEQ# only when called by XPDZPAT
 S:AAQRL="F" AAQX="NI" S:AAQRL="I" AAQX="IN" S:AAQP2="DBA" AAQX="FM" K DD,D0 S DIE=DIC,DA=AAQPNO,DR="1.5///^S X=AAQX" D ^DIE
 I AAQP2="DBA" S AAQRL="P" D ^XPDZUPDT G KILD
 I AAQRL="I" D SETX^XPDZUPDT G KILD
 S AAQLN=1 D CHKL^XPDZUPDT
KILD K D,D0,DA,DDER,DI,DIE,DQ,DR
 Q  ;Other variables killed by XPDZPRE or XPDZPAT
FWD D GETENV^%ZOSV S AAQUCI=$P(Y,"^",1),AAQSITE=^XMB("NETNAME") ;L33
 S AAQR=$G(^%ZOSF("VOL"))  ;Pick up volume such as ROU,LOU,COU...
 I AAQU="VAH" S AAQSITE=^XMB("NETNAME"),AAQSITE="TEST."_^XMB("NETNAME"),AAQXMY=$P(^VA(200,DUZ,0),"^",1)_"@"_AAQSITE
 I AAQU="VAH",(AAQR="ROU"),(AAQXMY'["TEST.TEST"),(AAQXMY'["VISN13-APPS"),(AAQXMY'["CENTRAL-PLAINS") S XMY(AAQXMY)="" D ENT1^XMD W !!,"Forwarding message #"_XMZ_" to "_AAQXMY
 I AAQU="VAH",(AAQXMY["VISN13-APPS") S $P(AAQXMY,"@",2)="TEST.V23IRM.VA.GOV" S XMY(AAQXMY)="" D ENT1^XMD W !!,"Forwarding message #"_XMZ_" to "_AAQXMY  ;Added line 07-30-2003/JFW MPLS
 I AAQU="VAH",(AAQXMY["CENTRAL-PLAINS") S $P(AAQXMY,"@",2)="TEST.VISN14.MED.VA.GOV" S XMY(AAQXMY)="" D ENT1^XMD W !!,"Forwarding message #"_XMZ_" to "_AAQXMY  ;Added line 08-19-2003/JFW MPLS
 Q
RV1NOTE W !,@RV1,"NOTE:",@RV0,$C(7)," " Q
RV15NOTE W ?15,@RV1,"NOTE:",@RV0,$C(7)," " Q
