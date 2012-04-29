XPDZPRE ;FGO/JHS; Pre-Install Checks ; 12/8/05 9:08pm
 ;;8.0;KERNEL;**L33**;Jul 10, 1995
 I '$D(DTIME) W !,"DTIME is not set.  Calling XUP to set up required variables.",!,"Press RETURN at the Select OPTION NAME: prompt.",!! D ^XUP
 S (AAQBAK,AAQFTP,AAQINST)=0 S AAQTYP="UNK"
ENPAT D UCI^%ZOSV S AAQU=$P(Y,",",1) K Y S (AAQAERR,AAQIERR,AAQSERR,AAQVERR,AAQCALL)=0 S AAQTYP="UNK",RV1="$C(27,91,55,109)",RV0="$C(27,91,109)" ;Reverse Video VT100
 I AAQINST=0 W !!,"Simple Patch Pre-Install Check  -  "_AAQU_"  -  " S X=$$NOW^XLFDT W $$FMTE^XLFDT(X)
LOOKUP W !!,"(Press Return to skip automatic Patch Message lookup",!," and use Read a Message or Load a Distribution instead.)",!!
 W "==> For automatic Patch Message lookup and Install/Check,",!,"      enter Patch Name in format Namespace*Version*Patch: " R AAQP:DTIME I '$T!(AAQP["^") G EXIT
 G:AAQP="" ASKRL
 G:$P(AAQP,"*",1)["Z" CKLOC
 I $P(AAQP,"*",1)'?2.4UN W $C(7),!!,"Namespace must be 2-4 Uppercase or Numeric with first character being Alpha." G LOOKUP
 G CKDBA
CKLOC I $P(AAQP,"*",1)'?2.4UN1"Z" W $C(7),!!,"Namespace for a LOCAL Patch must be 2-4 Uppercase or Numeric",!,"characters with the first being Alpha and last character a 'Z'." G LOOKUP
CKDBA I $P(AAQP,"*",2)="DBA" W $C(7),!!,"This message refers to a DBA patch.",!!,"For Patch Record Updating:  METHOD will be FileMan." S AAQTYP="DBA" G DBA
 I $P(AAQP,"*",2,3)?1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.6N S AAQPRE="Released " G LKUP
 W $C(7),!!,"Version number must include a whole number and at least one decimal position.",!,"Non-significant zeros in the Patch Name will be ignored for message lookup." G LOOKUP
LKUP S AAQP3=$P(AAQP,"*",3),AAQLN3=$L(AAQP3)
 S AAQP1=$P(AAQP,"*",1),AAQX1=AAQP1,AAQP2=$P(AAQP,"*",2),AAQX2=AAQP2,AAQP12=AAQP1_"*"_AAQP2 ;AAQP12 is for File #9.7 and #437016 lookup
 I $P($G(AAQX2),".",2)=0 S AAQX2=$P(AAQX2,".0",1) ;Check X.0 versions
 I $E(AAQX2,1,2)="0." S AAQX2=$E(AAQX2,2,3) ;Check .X versions
 S AAQX12=AAQX1_"*"_AAQX2,AAQPAT=AAQX12_"*"_AAQP3 ;For #3.9 lookup
 S AAQPX=AAQPAT,AAQSUBX=AAQPRE_AAQPX
LKUP2 W !!,"Looking for message with '"_AAQSUBX_"' in the subject."
 S AAQBX=$O(^XMB(3.9,"B",AAQSUBX)) I AAQBX'[AAQPX G LOCAL
 I AAQBX[" TEST " G CKTEST
 S AAQX=$P(AAQBX,AAQPRE) I $P(AAQX," ")]AAQX1 G LOCAL
 I $P(AAQBX,"*",2)>AAQX2 G LOCAL
 S AAQX=$P(AAQBX,AAQX12_"*",2),AAQX=$P(AAQX," ") I AAQX'=AAQP3 G LOCAL
CKBX I $D(^XMB(3.9,"B",AAQBX)) S AAQXMZ=0,AAQXMZ=$O(^XMB(3.9,"B",AAQBX,AAQXMZ)) G GOTXM
LOCAL I $E(AAQSUBX,1,5)="LOCAL" W !,"Sorry.  The automatic lookup could not find this Patch Message." G RML
 I $E(AAQSUBX,1,8)="Released" S AAQPRE="EMERGENCY "_AAQPRE,AAQSUBX=AAQPRE_AAQPX G LKUP2
 I $E(AAQSUBX,1,8)="EMERGENC" S AAQSUBX=AAQPX_" TEST" G LKUP2
 I AAQSUBX[" TEST" S AAQPRE="LOCAL ",AAQSUBX=AAQPRE_AAQPX  S AAQX3=AAQP3,AAQPX=AAQX1_"*"_AAQX2_"*"_AAQX3,AAQSUBX="LOCAL "_AAQPX G LKUP2
GOTXM W !!,"Found Message: #"_AAQXMZ,!,?6,"Subject: " S AAQSUB=$$SUBGET^XMGAPI0(AAQXMZ),XMZ=AAQXMZ,AAQXM=AAQSUB,AAQRL="R" W AAQSUB,!
 I AAQSUB["LOCAL " G ASKMSG
 I AAQSUB[" TEST" G ASKMSG
 Q:AAQCALL=1
 G GETSEQ
CKTEST S AAQLNS=$L(AAQSUBX) G:$E(AAQBX,1,AAQLNS)'=AAQSUBX LOCAL G CKBX
ASKMSG S %=1 R !,"Is this the correct message" D YN^DICN G:$D(DTOUT) EXIT G:%=1 GETSEQ I %=0 W !!,"Answer YES to continue, NO to find next message, or '^' to Exit." G ASKMSG
 G:%Y="^" EXIT
 I %=-1 W $C(7) G NOMSG
 S AAQSUBX=AAQSUB,AAQBX=$O(^XMB(3.9,"B",AAQSUBX)) G CKBX ;Wrong msg
 S AAQBX=$O(^XMB(3.9,"B",AAQSUBX)) G ASKMSG
GETSEQ Q:AAQCALL=1
 S AAQSUB=$$SUBGET^XMGAPI0(AAQXMZ),AAQSEQ=$P($G(AAQSUB),"SEQ #",2)
 I $E(AAQSUB,1,6)="LOCAL " S AAQTYP="LOCAL" D SEQTYP G CHKKID
 I AAQSUB[" TEST" S AAQTYP="TEST" D SEQTYP G CHKKID
 I AAQSEQ="" D NOSEQ
 I AAQTYP="DBA" G ENDT
CHKKID I $P(^XMB(3.9,AAQXMZ,0),"^",7)="K" G CHKPRE
 W $C(7),!,"This is not a KIDS PackMan Distribution message."
ASKFTP S %=1 R !!,"Does this message refer to a KIDS FTP, or Informational Patch" D YN^DICN G:$D(DTOUT) EXIT G:%=2 LOOKUP I %=0 W !!,"Answer YES to Continue, NO to find another message, or '^' to Exit." G ASKFTP
 G:%Y="^" EXIT I %=-1 G ASKFTP
ASKTYP R !,"Which type of Patch is this (F)TP or (I)nformational?: I// ",AAQTYP:60 G:AAQTYP="^" EXIT W:$E(AAQTYP,1)="F" "TP" W:$E(AAQTYP,1)="I" "nformational"
 I AAQTYP?1L.E S AAQTYP=$$UP^XLFSTR(AAQTYP)
 I (AAQTYP="")!(AAQTYP="I") S AAQTYP="I"
 I $E(AAQTYP,1)'="F",$E(AAQTYP,1)'="I" W !!,"Enter F or I, `^' to quit." G ASKTYP
 G:AAQTYP="F" CKFTP
 W !!,"For Patch Record Updating:  METHOD will be Informational." S AAQTYP="INFO",AAQRL="I"
 W !,"BACKUP# will be 0, and UCI DATE/TIME will be NOW.",!,"If default values are incorrect, make changes using Enter/Edit Patch Record." G ENDT
CKFTP W !!,"FTP/KIDS Patch Pre-Install.",!!,"For Patch Record Updating:  METHOD will be Not Installed." S AAQTYP="FTP",AAQRL="F"
 W !,"BACKUP# will be 0.",!,"The UCI data and METHOD will be updated after install is finished.",!,"If default values are incorrect, make changes using Enter/Edit Patch Record." G ENDT
INFTP S AAQFTP=1,AAQRL="L" G CHKPRE
SEQTYP Q:AAQCALL=1  S AAQSEQ=0 D RV1NOTE W "This is a ",AAQTYP," Patch without a valid SEQ #.  Zero will be used." S AAQSEQ=0,AAQSERR=1 Q
NOSEQ S AAQSEQ=0 D RV1NOTE W "No Patch Sequence number could be found.  Zero will be used." S AAQSERR=1 Q
ASKRL I AAQFTP=1 S AAQRL="L" G END
 R !!,"==> Do you want to load this with (R)ead a message,",!,?31,"or (L)oad a Distribution?: L// ",AAQRL:DTIME S:AAQRL="" AAQRL="L" G:AAQRL="^" EXIT I '$T G EXIT
 I AAQRL?1L.E S AAQRL=$$UP^XLFSTR(AAQRL)
 I $E(AAQRL,1)'="R",$E(AAQRL,1)'="L" W $C(7),!!,"Enter the letter R or L, `^' to quit." G ASKRL
 G:AAQRL="L" ASKCHK^XPDZPAT
RML Q:AAQCALL=1  W ! S DIC="^XMB(3.9,",DIC(0)="AEQM",DIC("A")="Enter Message Subject or Number: " D ^DIC G:$D(DUOUT)!$D(DTOUT) EXIT I Y=-1 W $C(7),!!,"Invalid Selection.  Try again or type '^' to Exit." G RML
 S AAQXMZ=+Y,XMZ=AAQXMZ,AAQXM=$P(Y,U,2),AAQSEQ=$P($G(AAQXM),"SEQ #",2),AAQP3=$P(Y,U,2) I AAQSEQ="" G CHKP3
 S AAQSEQ=$P($G(AAQSEQ),U)
CHKP3 I AAQP3[" TEST" S AAQTYP="TEST" D SEQTYP S AAQP3=$P(X," "),AAQXM="TEST "_AAQP3 G SEQERR
 I AAQP3["LOCAL" S AAQTYP="LOCAL" D SEQTYP G SEQERR
 I AAQSEQ="" D NOSEQ
 G CHKPRE
SEQERR S AAQSERR=1,AAQSEQ=0
CHKPRE I $E(AAQXM,1,5)="Relea" S AAQXM=$P(AAQXM,"Released ",2),AAQXM=$P(AAQXM," ")
 I $E(AAQXM,1,5)="EMERG" S AAQXM=$P(AAQXM,"EMERGENCY Released ",2),AAQXM=$P(AAQXM," ")
 I $E(AAQXM,1,5)="LOCAL" S AAQXM=$P(AAQXM,"LOCAL ",2),AAQXM=$P(AAQXM," "),AAQX1=$P(AAQXM,"Z")
 I AAQXM[" TEST" S AAQXM=$P(AAQXM," TEST",1)
 I AAQP'["*" W !,"This was not identified as a Patch and will be installed as a Package.",! G CHKRL^XPDZPAT
 S AAQX1=$P(AAQXM,"*"),AAQX2=$P(AAQXM,"*",2),AAQX3=$P(AAQXM,"*",3),AAQX3=$P(AAQX3," ")
 I $E(AAQX2,1,1)="." S AAQX2="0"_AAQX2
 I AAQX2'["." S AAQX2=AAQX2_".0"
 D VERS^XPDZPRE1 G END
DBA I AAQCALL=0 W !,"BACKUP# will be 0, and UCI DATE/TIME will be NOW.",!,"If default values are incorrect, make changes using Enter/Edit Patch Record."
 S AAQPX=AAQP,AAQPRE="Released ",AAQSUB=AAQPRE_AAQPX G LKUP
RV1NOTE W !!,@RV1,"NOTE:",@RV0,$C(7)," " Q
NOMSG I AAQXMZ=0 W $C(7),!!,"No message has been found and read.  Exiting." H 2 G EXIT
END I AAQFTP=1 S AAQRL="L"
 E  S AAQRL="R"
 G:AAQU="TST" ENDT I $E(AAQAP,1,8)="No Assoc" W !,AAQAP
ENDT S AAQCONT=0,AAQTOT=AAQAERR+AAQIERR+AAQSERR+AAQVERR I AAQTOT>0 W !!,@RV1,"Discrepancies were Noted.",@RV0 S AAQCONT=2
 S AAQR=$G(^%ZOSF("VOL"))  ;Pick up volume such as ROU,LOU,COU...
 I AAQU="VAH" S AAQSITE=^XMB("NETNAME"),AAQSITE="TEST."_^XMB("NETNAME"),AAQXMY=$P(^VA(200,DUZ,0),"^",1)_"@"_AAQSITE
 I AAQU="VAH",(AAQR="ROU"),(AAQXMY'["TEST.TEST"),(AAQXMY'["VISN13-APPS"),(AAQXMY'["CENTRAL-PLAINS") S XMY(AAQXMY)="" D ENT1^XMD W !!,"Forwarding message #"_XMZ_" to "_AAQXMY
 I AAQU="VAH",(AAQXMY["VISN13-APPS") S $P(AAQXMY,"@",2)="TEST.V23IRM.VA.GOV" S XMY(AAQXMY)="" D ENT1^XMD W !!,"Forwarding message #"_XMZ_" to "_AAQXMY  ;Added line 07-30-2003/JFW MPLS
 I AAQU="VAH",(AAQXMY["CENTRAL-PLAINS") S $P(AAQXMY,"@",2)="TEST.VISN14.MED.VA.GOV" S XMY(AAQXMY)="" D ENT1^XMD W !!,"Forwarding message #"_XMZ_" to "_AAQXMY  ;Added line 08-19-2003/JFW MPLS
 I AAQFTP=1 D LKUP^XPDZPRE1
 I AAQP2="DBA" D LKUP^XPDZPRE1 G EXIT
 I AAQRL="I" D LKUP^XPDZPRE1 G EXIT
 I AAQRL="F" D ^XPDZPRE1,LKUP^XPDZPRE1 G EXIT
 G:AAQCONT=2 CHKINST
 S AAQCONT=1
CHKINST I AAQINST=0 K AAQP,AAQU,AAQXMZ R !!,"  Press RETURN to Continue:",X:DTIME W @IOF G EXIT
 S %=AAQCONT
ASKINS R !!,"Do you want to Continue with the Install" D YN^DICN G:$D(DTOUT) EXIT G:%=1 CHKRL^XPDZPAT I %=0 W !!,"Answer YES to Continue with Install, NO to stop at this point." G ASKINS
 G:%Y="^" EXIT
 I %=-1 W $C(7) G ASKINS
 S AAQINST=0
EXIT W ! K AAQBX,AAQLN3,AAQLNS,AAQP1,AAQP12,AAQP2,AAQP3,AAQPAT,AAQPNO,AAQPRE,AAQPV,AAQPX,AAQSITE,AAQSUB,AAQSUBX,AAQX,AAQX1,AAQX12,AAQX2,AAQX3,AAQXM,AAQXMY,AAQXMZ
 D EXPRE^XPDZPAT K %,%A,%C,%D,%DT,%M,%NX,%Y,DIC,X,XMZ,Y
 I AAQFTP="^" G EXIT^XPDZPAT ;AAQRL,AAQDT Killed by XPZPAT
 K AAQBAK,AAQCALL,AAQFTP,AAQINST,AAQLN,AAQP,AAQRL,AAQSEQ,AAQU,DLAYGO Q  ;Other variables killed by EXPRE^XPDZPAT
