XPDZUPDT ;FGO/JHS; Update Patch Record #436016 ; 12/2/05 9:16pm
 ;;8.0;KERNEL;**L33**;Jul 10, 1995
 Q:'$D(^DD(437016.01,1.3,0))  ;Patch File does not have SEQ# & MSG#s
 I AAQP'["*" W !,"This was installed as a Package and will not be updated in the Patch Record.",! Q
 S AAQP2=$P(AAQP,"*",2) G:(AAQP2="DBA")!(AAQRL="I") SETX
 Q:'$D(^XPD(9.6,"B",AAQP))  ;The KIDS Build has not been installed
SETX S X=AAQP,AAQLOC=0 Q:$L(X)>50!($L(X)<3)
 G:AAQP2="DBA" SETX1
 I X["*" K:$P(X,"*",2,3)'?1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.6N X
 G:'$D(X) EXIT
SETX1 S AAQX1=$P(AAQP,"*",1),AAQX2=$P(AAQP,"*",2) D CHKLOC S AAQX12=AAQX1_"*"_AAQX2
 S AAQX3=$P(AAQP,"*",3) I $L(AAQX3)<2 S AAQX3="0"_AAQX3 K DD,DIC,D0
 I AAQLOC=1 S AAQX3="L"_AAQX3
 S AAQSUB="Subject of Patch Not Found" G:AAQRL="L" SET12 S AAQSUB=$$SUBGET^XMGAPI0(AAQXMZ)
SET12 S AAQX12=AAQX1_"*"_AAQX2
 S X=AAQX12,DIC="^DIZ(437016,",DIC(0)="XM" D ^DIC I +Y>0 S AAQPV=+Y
 I '$D(^DIZ(437016,"B",AAQX12)) D
 .S X=AAQX12,DIC="^DIZ(437016," S DIC(0)="ML" D FILE^DICN
 .S AAQPV=+Y
 I AAQSUB[" TEST v" S AAQVER=$P(AAQSUB,"TEST v",2),AAQX3=AAQX3_"V"_AAQVER
 I $D(^DIZ(437016,AAQPV,1,"B",AAQX3)) S DA=0,DA=$O(^DIZ(437016,AAQPV,1,"B",AAQX3,DA)) S AAQPNO=DA,DA(1)=AAQPV,DIC="^DIZ(437016,"_DA(1)_",1," G UPDT
 I '$D(^DIZ(437016,AAQPV,1,"B",AAQX3)) D
 .S:'$D(^DIZ(437016,AAQPV,1,0)) DIC("P")=$P(^DD(437016,1,0),"^",2)
 .S DA(1)=AAQPV,DIC="^DIZ(437016,"_DA(1)_",1,",X=AAQX3,DIC(0)="L",DLAYGO=437016
 .D ^DIC S AAQPNO=+Y
UPDT W !,"Updating the Patch Record now."
 I AAQX2="DBA" S AAQX="FM",AAQBAK=0 G KDD
 I AAQRL="I" S AAQX="IN",AAQBAK=0 G KDD
 I AAQRL="F" S AAQX="NI",AAQBAK=0 G KDD
 I AAQRL="R" S AAQX="PM"
 I AAQRL="L" S AAQX="FT"
KDD K DD,DO S DIE=DIC,DA=AAQPNO,DR="1.44///^S X=AAQBAK;1.5///^S X=AAQX" D ^DIE
 I AAQX'="FT" K DD,DO S DIE=DIC,DA=AAQPNO,DR="1.43///^S X=AAQXMZ;1.3///^S X=AAQSEQ" D ^DIE
 G:'$D(AAQD0) CKU S DR="1.4///^S X=AAQD0" D ^DIE ;Update Build Pointer
 G:'$D(^XPD(9.6,AAQD0,"KRN",9.8,"NM",0)) CKU S AAQRTN=^XPD(9.6,AAQD0,"KRN",9.8,"NM",0)  I ($P(AAQRTN,U,4)=0)!($P(AAQRTN,U,4)="") G CKU
 S AAQX=0 I '$D(^DIZ(437016,AAQPV,1,AAQPNO,1,"B")) D
 .S:'$D(^DIZ(437016,AAQPV,1,AAQPNO,1,0)) DIC("P")=$P(^DD(437016.01,2,0),"^",2)
 .S DA(2)=AAQPV,DA(1)=AAQPNO,DIC="^DIZ(437016,AAQPV,1,"_DA(1)_",1,",DIC(0)="L",DLAYGO=437016.01
 S AAQIX="" S AAQIX=$O(^DD(437016,0,"IX",AAQIX)) ;Get first xref
 F JJ=0:1:4 S AAQX=$O(^XPD(9.6,AAQD0,"KRN",9.8,"NM",AAQX)) Q:AAQX=AAQIX  S AAQBRTN=$P(^XPD(9.6,AAQD0,"KRN",9.8,"NM",AAQX,0),U),X=AAQBRTN  D ^DIC Q:AAQX=""
 I $P(AAQRTN,U,4)>5 S X="Total="_$P(AAQRTN,U,4) D ^DIC
CKU I '$D(^DIZ(437016,AAQPV,1,AAQPNO,2,0)) S ^(0)="^437016.13S^^" S (AAQUNO,AAQT,AAQV)=0 G SETU
 S AAQX=^DIZ(437016,AAQPV,1,DA,2,0) I ($P(AAQX,U,4)=0)!($P(AAQX,U,4)="") S (AAQUNO,AAQT,AAQV)=0 G SETU
 ; Changed following line fr AAQX="" to (+AAQX'>0)  L33/JFW
 S (AAQT,AAQV,AAQX)=0 F  S AAQX=$O(^DIZ(437016,AAQPV,1,AAQPNO,2,AAQX)) Q:(+AAQX'>0)  D
 .S AAQSYS=^DIZ(437016,AAQPV,1,AAQPNO,2,AAQX,0)
 .I $E(AAQSYS,1,1)="T" S AAQT=AAQT+1
 .I $E(AAQSYS,1,1)="V" S AAQV=AAQV+1
 I AAQV>0 W !,"UCI Install information for VAH is on file." G CHKT
SETU K DD,DO S AAQSYS=$E(AAQU,1,1)
SDIC S DIC="^DIZ(437016,"_AAQPV_",1,"_AAQPNO_",2,",DIC(0)="LM",X=AAQSYS,DA(1)=AAQPNO,DA(2)=AAQPV D FILE^DICN S AAQUNO=+Y K DIC
INST S AAQDT=$$NOW^XLFDT,AAQIRM=$P(^VA(200,DUZ,0),U,2)
 S DIE="^DIZ(437016,"_AAQPV_",1,"_AAQPNO_",2,",DA(2)=AAQPV,DA(1)=AAQPNO,DA=AAQUNO,DR="1///^S X=AAQDT;2///^S X=AAQIRM" D ^DIE
 I AAQSYS="V",AAQX2="DBA" S AAQSYS="T",AAQT=1 G SDIC
 I AAQSYS="V",AAQRL="I" S AAQSYS="T",AAQT=1 G SDIC ;Info Patch
CHKT ;;I AAQT=0 W !,"UCI Install information for TST is missing."
 ;;I (AAQT=0)!(AAQV>1) W $C(7),!,"Use Enter/Edit Patch option to update UCI data, as needed."
CHKL I AAQRL="L" S AAQMSUB="No Subject found in FTP File" G GETPR
 S AAQLN=1,AAQMSUB="No Subject found in Message" I AAQXMZ'>0 G GETPR
 W !!,"Looking for Subject in MailMan Message #",AAQXMZ,!
 F J=0:0 S AAQLN=$O(^XMB(3.9,AAQXMZ,2,AAQLN)) Q:AAQLN=""  S AAQTXT=^XMB(3.9,AAQXMZ,2,AAQLN,0) Q:$E(AAQTXT,1,4)="$END"  D
 .I AAQTXT["Subject:" S AAQMSUB=$P(AAQTXT,"Subject: ",2) W !,"Subject found in Message is: "_AAQMSUB Q
 .I $E(AAQTXT,1,4)="$END" W !,AAQMSUB
GETPR S AAQPSUB=$P($G(^DIZ(437016,AAQPV,1,AAQPNO,0)),U,2) I AAQPSUB="" S AAQPSUB="No Subject Entered" G CHKXM
 W !," Subject in Patch Record is: "_AAQPSUB,!
ASKPR S %=2 W !,"Do you want to use the Patch Record Subject as is" D YN^DICN G:$D(DTOUT) CHKXM G:%=1 SDIE I %=0 D FORP G ASKPR
 I %=-1 W $C(7),!!,"Using the '^' is not allowed at this prompt." G ASKPR
CHKXM G:AAQXMZ'>0 HLPSUB
 I $L(AAQMSUB)<41 W ! G ASKXM
 S AAQMSUB=$E(AAQMSUB,1,40) W !,"MailMan Message Subject is greater than 40 characters.",!,"It has been shortened to: ",AAQMSUB
ASKXM S %=1 W !,"Do you want to use the MailMan Message Subject as is" D YN^DICN G:$D(DTOUT)!(%=1) SETSUB G:%=2 HLPSUB I %=0 W !!,"If you answer NO, you can enter a new Subject." G ASKXM
 I %=-1 W $C(7),!!,"Using the '^' is not allowed at this prompt." G ASKXM
HLPSUB W !!,"Enter a maximum of 40 characters for patch subject.",!?9,"_________|_________|_________|_________|"
 R !,"Subject: ",X:60 G:$E(X,1,1)="?" HLPSUB
 I $L(X)>40 W $C(7),!,"Too many characters entered for patch subject." G HLPSUB
 I X="" W $C(7),!,"You cannot leave the patch subject blank." G HLPSUB
 I $E(X,1,1)="^" W $C(7),!,"Using the '^' is not allowed at this prompt." G HLPSUB
 S AAQPSUB=X G SDIE
SETSUB S AAQPSUB=AAQMSUB
SDIE S DIE="^DIZ(437016,"_AAQPV_",1,",DA(1)=AAQPV,DA=AAQPNO,DR="1///^S X=AAQPSUB" D ^DIE
 I AAQFTP=1 K AAQLN,AAQMSUB,AAQPSUB,AAQRL,J Q
 I (AAQSUB["LOCAL ")!(AAQSUB[" TEST v") G EXIT
EXIT W ! K AAQB,AAQBRTN,AAQDT,AAQIRM,AAQIX,AAQLN,AAQLOC,AAQMSUB,AAQP,AAQPNO,AAQPSUB,AAQPV,AAQRTN,AAQSYS,AAQT,AAQTXT,AAQUNO,AAQV,AAQVER,AAQX,AAQX1,AAQX12,AAQX2,AAQX3
 K %,%DT,%H,%Y,%ZO,D,D0,D1,DA,DDER,DI,DIC,DIE,DIOUT2,DLAYGO,DQ,DR,DTOUT,J,JJ,X,XQM,Y
 Q  ;AAQBAK,AAQD0,AAQFTP,AAQP2,AAQSEQ,AAQSUB,AAQU,AAQXMZ killed in the routine XPDZPAT
CHKLOC Q:AAQX1'["Z"
 S AAQX1=$P(AAQX1,"Z",1),AAQLOC=1
 Q
FORP I AAQFTP=1 W !!,"For FTP Patch, the only other option will be to Enter a Subject." Q
 E   W !!,"For PackMan Patch, use Message Subject or Enter a Subject." Q
