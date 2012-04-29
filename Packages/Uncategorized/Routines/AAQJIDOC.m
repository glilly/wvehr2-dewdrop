AAQJIDOC ;FGO/JHS - Patch Documentation Inquire ;04-30-99 [10/23/02 5:18pm]
 ;;1.4;AAQJ PATCH RECORD;; May 14, 1999
 S U="^",DIC="^DIZ(437016,",DIC(0)="AEQM" D ^DIC W !
 S AAQJDA=+Y S AAQJPKG=$P(Y,U,2),AAQPKG=AAQJPKG G:Y=-1 EXIT
 S DIC="^DIZ(437016,AAQJDA,1,",DIC(0)="AEQM",DIC("A")="Select PATCH: "
 D ^DIC W ! I Y=-1 W $C(7),"No Patch selected.  Exiting." G EXIT
 S DA=+Y S AAQJPAT=$P(Y,U,2) S AAQPAT=AAQJPAT
EN Q:IOST["P-"  D UCI^%ZOSV S AAQUCI=$P(Y,",",1),AAQU=AAQUCI K Y
 I AAQUCI="TST" W !!,"Patch Record Documentation is only available in VAH." G EXIT
 S DA=AAQDA S (AAQBLD,AAQCALL,AAQCMP,AAQDOC,AAQNODOC,AAQNOMSG)=0
 I $D(^DIZ(437016,AAQJDA,1,DA,4,0)) S AAQBLD=1 ;Build Notes
 I $D(^DIZ(437016,AAQJDA,1,DA,5,0)) S AAQDOC=1 ;Documentation
 I $D(^DIZ(437016,AAQJDA,1,DA,6,0)) S AAQCMP=1 ;Compare results
 S AAQNODOC=AAQBLD+AAQDOC+AAQCMP I AAQNODOC=0 W !,"There are no Documentation, Build, or Compare entries for this patch." G ASKMSG
ASKDOC S %=2 W !,"Do you want to see related Patch Documentation" D YN^DICN G:%=2 ASKMSG I %=0 W !!,"Additional Patch Record Documentation, if available, can be displayed or printed if YES." G ASKDOC
 G:%=-1 ASKMSG
 W:AAQBLD=1 !,"Build Notes are available for this Patch."
 W:AAQDOC=1 !,"Documentation is available for this Patch."
 W:AAQCMP=1 !,"Routine Compare Results are available for this Patch."
 W !!,"Which document(s) to you want to see?"
ASKX R !,"(B)uild Notes, (C)ompare Results ,(D)ocumentation, or (A)ll: D//",AAQX:DTIME S:AAQX="" AAQX="D" S AAQX=$E(AAQX,1)
 I AAQX?1L.E S AAQX=$$UP^XLFSTR(AAQX)
 G ASKMSG:(AAQX="^")!("ABCD"'[AAQX)
 I AAQX="A" D DOC,BLD,CMP G ASKMSG
 I AAQX="D" D DOC G ASKMSG
 I AAQX="B" D BLD G ASKMSG
 I AAQX="C" D CMP G ASKMSG
ASKMSG S %=2 W !!,"Do you want to see the Patch MailMan Text" D YN^DICN G:%=1 GETMSG I %=0 W !!,"The PackMan Message Text, if available, can be displayed or printed if YES." G ASKMSG
 G:%=-1 EXIT
 I %=2 S AAQNOMSG=0 G EXIT
GETMSG S AAQXMZ=$P($G(^DIZ(437016,AAQJDA,1,DA,0)),U,6) I (AAQXMZ="")!(AAQXMZ=0) D NOMSG G CKMSG
 S XMDUN=$P(^VA(200,DUZ,0),U) D MSG G EXIT
DOC S AAQEDT=$P($G(^DIZ(437016,AAQJDA,1,DA,3)),U,5),AAQEBY=$P($G(^DIZ(437016,AAQJDA,1,DA,3)),U,6)
 Q:AAQDOC=0  S AAQDESC="{Documentation Field}",AAQTYP=5 D LIST Q
BLD S AAQEDT=$P($G(^DIZ(437016,AAQJDA,1,DA,3)),U,3),AAQEBY=$P($G(^DIZ(437016,AAQJDA,1,DA,3)),U,4)
 Q:AAQBLD=0  S AAQDESC="{Build Notes Field}",AAQTYP=4 D LIST Q
CMP S AAQEDT=$P($G(^DIZ(437016,AAQJDA,1,DA,3)),U,7),AAQEBY=$P($G(^DIZ(437016,AAQJDA,1,DA,3)),U,8)
 Q:AAQCMP=0  S AAQDESC="{Compare Results Field}",AAQTYP=6 D LIST Q
LIST Q:'$D(^DIZ(437016,AAQJDA,1,DA,AAQTYP,0))
 W @IOF,AAQDESC,! K ^UTILITY($J,"W") S DIWL=1,DIWR=75,DIWF="N"
 F N1=0:0 S N1=$O(^DIZ(437016,AAQJDA,1,DA,AAQTYP,N1)) Q:N1'>0  S X=^DIZ(437016,AAQJDA,1,DA,AAQTYP,N1,0) D ^DIWP
 F N1=0:0 S N1=$O(^UTILITY($J,"W",DIWL,N1)) Q:N1'>0  D
 .W !,?3,^UTILITY($J,"W",DIWL,N1,0)
 .I $Y>(IOSL-5) D:$E(IOST)="C" PAUSE
 .Q
 W:AAQEDT'="" !,?35,"Last Edited: ",$$FMTE^XLFDT(AAQEDT,"1M")
 W:AAQEBY'="" !,?37,"Edited By: ",$P(^VA(200,AAQEBY,0),U,1)
PAUSE R !!,"Press RETURN to Continue: ",AAQX:20
 W @IOF Q
MSG I '$D(^XMB(3.9,AAQXMZ,0)) D NOMSG G EXIT
 S AAQDESC="{MailMan Message}" W @IOF,AAQDESC
 S AAQSUB=$$SUBGET^XMGAPI0(AAQXMZ) W !!,"Subject: ",AAQSUB,!
 S XMZ=AAQXMZ D XT^XMP2 Q
NOMSG S AAQNOMSG=0 W !!,"Sorry.  The Mailman message for this patch is not available." Q
CKMSG ;Try message lookup.  If found, update Patch Record and display.
 I AAQJPAT["S" W !!,AAQJPKG_"*"_AAQJPAT," is a Support Patch and the automatic message lookup",!,"cannot be used.  If the message number is available, it can be",!,"entered using 'Documentation, Notes, Message Entry'." G EXIT
 S AAQCALL=1,AAQP=AAQPKG_"*"_AAQPAT D CKDBA^XPDZPRE G:'$D(AAQSUB) EXIT
 I $D(AAQXMZ) W !,"Message #"_AAQXMZ_" found." S AAQNOMSG=1 H 2
 E  W !,"Message not found." G EXIT
 S DA(1)=AAQJDA,DIC="^DIZ(437016,"_DA(1)_",1,"
 K DD,D0 S DIE=DIC,DA=AAQDA,DR="1.43///^S X=AAQXMZ" D ^DIE
KUPDT K AAQBX,AAQCALL,AAQLN2,AAQLN3,AAQP,AAQP1,AAQP2,AAQP3,AAQPRE,AAQPX,AAQX1,AAQX12,AAQX2
 G:AAQXMZ'="" MSG
EXIT K %,%Y,AAQBLD,AAQCMP,AAQDESC,AAQDOC,AAQEBY,AAQEDT,AAQSUB,AAQTYP,AAQX,AAQXMZ
 ; AAQDA Killed by EXITA^AAQJPINQ
 K DA,DIC,DIE,DIF,DIR,DIW,DIWF,DIWI,DIWL,DIWR,DIWT,DIWTC,DIWX,I,J,N1,POP,X,XCF,XCN,XMZ,Y,Z Q  ;XMDUZ,XMDUN not killed, needed by TOP^XMPC
EXITK K AAQBX,AAQCALL,AAQJDA,AAQJPAT,AAQJPKG,AAQLN3,AAQNODOC,AAQNOMSG,AAQP,AAQP1,AAQP12,AAQP2,AAQP3,AAQPAT,AAQPKG,AAQPRE,AAQPX,AAQRL,AAQSUBX,AAQTST,AAQTSW,AAQU,AAQUCI,AAQX1,AAQX12,AAQX2,AAQX3,AAQXM,DR Q
