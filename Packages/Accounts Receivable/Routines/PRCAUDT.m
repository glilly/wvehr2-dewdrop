PRCAUDT ;SF-ISC/YJK-AUDIT A NEW BILL/EDIT INCOMPLETE AR ;10/17/96  5:33 PM
V ;;4.5;Accounts Receivable;**1,21,57,97,143,107,173**;Mar 20, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 NEW X,Y,LOOP,DIR
 W ! S DIR("B")="YES",DIR("A")="Do you want to loop thru 'NEW BILLS'",DIR(0)="Y" D ^DIR K DIR G:$D(DIRUT) END S LOOP=+Y
 D AUDITB(0,0,LOOP)
 Q
 ;
AUDITB(PRCABN,PRAUTOA,LOOP) ;
 ; PRCABN = the ien of the entry to audit or 0 for batch entry above
 ; PRAUTOA = 1 for auto-audit
 ; LOOP = 1 if looping through bills, 0 if not
 N PREND,PRCA,PRCASEG,X,Y
 S PREND=0,PRCA("AUTO_AUDIT")=PRAUTOA
 F  D  Q:$S(PREND:1,PRAUTOA:1,1:0)
 . K PRCABT S PRCA("MESG")="*** AUDITED AND RELEASED ***"
 . I LOOP,'$O(^PRCA(430,"AC",18,PRCABN)) W !!,"*** Loop Done ***",!! S PREND=1 Q
 . I PRAUTOA S PRCA("CKSITE")="",PRCA("SITE")=$P($$BILL(PRCABN),"-") K PRCAT
 . I '$D(PRCA("CKSITE")) D CKSITE K:$D(PRCA("CKSITE")) PRCAT I '$D(PRCA("CKSITE")) S PREND=1 Q
 . I LOOP S PRCABN=$O(^PRCA(430,"AC",18,PRCABN)) I 'PRCABN S PREND=1 Q
 . I LOOP!PRAUTOA D
 .. S PRCATY=$P(^PRCA(430,PRCABN,0),U,2),PRCA("SEG")=$S(+$P(^(0),U,21)>240:$P(^(0),U,21),1:"")
 .. S PRCA("STATUS")=$P(^PRCA(430,PRCABN,0),U,8),PRCA("APPR")=$P(^(0),U,18)
 . E  D  Q:PREND
 .. S DIC("S")="S Z0=$S($D(^PRCA(430.3,+$P(^(0),U,8),0)):$P(^(0),U,3),1:0) I Z0=104" D DIC I '$G(PRCABN) S PREND=1
 . ;
 . S PRCAKT=$S($P(^PRCA(430,PRCABN,0),U,2)]"":$P(^(0),U,2),1:"")
 . I +PRCAKT'>0 D:$G(PRAUTOA) SETERR("NO CATEGORY DEFINED FOR BILL "_$$BILL(PRCABN)) D END Q
 . S PRCARI=$O(^PRCA(430.2,"AC",21,0))
 . I $P(^PRCA(430,PRCABN,0),U,21)="" S X=PRCABN D:PRCARI=PRCAKT SEGMT S:'$D(Y) Y=-1 S PRCASEG=$S(PRCARI=PRCAKT&(Y<1):"",PRCARI=PRCAKT:Y,$D(^PRCA(430.2,PRCAKT,0)):$P(^(0),U,3),1:""),$P(^PRCA(430,PRCABN,0),U,21)=PRCASEG
 . S PRCAT=$S($D(^PRCA(430.2,PRCAKT,0)):$P(^(0),U,6),1:"") I PRCAT="" D:$G(PRAUTOA) SETERR("NO CATEGORY TYPE DEFINED FOR BILL "_$$BILL(PRCABN)) D END Q
 . I $P(^PRCA(430.2,PRCAKT,0),U,7)=24 S PRCAT("C")=1,Z0=$P(^PRCA(430,PRCABN,0),U,16) S:+Z0'>0 Z0=PRCAKT S $P(^PRCA(430,PRCABN,0),U,21)=$S($D(^PRCA(430.2,+Z0,0)):$P(^(0),U,3),1:0) K Z0,PRCAKT
 . ;
 . I '$G(PRAUTOA) D DISPL,DISPLACC^PRCAFUT D  Q:PREND
 .. I $D(PRCA("EXIT")) S PREND=1 Q 
 .. D MESSG
 . S PRCARETN=0,PRCAOK=$G(PRAUTOA)
 . I '$G(PRAUTOA) D ASK I $D(PRCA("EXIT")) D END S PREND=1 Q
 . I PRCAOK=1 D  D:$D(PRCA("EXIT")) END Q
 .. K PRCA("EXIT") D MTCHK I $D(PRCA("EXIT")) Q
 .. D:PRCAT="T" THIRD^PRCAUDT1
 .. I +$P(^PRCA(430,PRCABN,0),U,5)'>0 D CAUSED^PRCAUDT1 Q:PRCAOK=0
 .. D COMMENTS^PRCAUT3 Q:$D(PRCA("EXIT"))
 .. S PRCASIG=0 D SIG K PRCA("EXIT") Q:PRCASIG=0
 .. D UPBALN^PRCAUDT1,UPSEG
 .. I '$$ACCK^PRCAACC(PRCABN),("^28^29^"'[("^"_$G(PRCAKT)_"^")) D EN^PRCAFBD(PRCABN,.ERR)
 .. I $G(PRCAKT)=28 D EN^PRCACPV(PRCABN,.ERR) S:ERR<0 PRCA("MESG")="FMS document created . . . "
 .. K PRCA("EXIT")
 .. I +$G(ERR)>0 D  D END Q
 ... N Z,Z0,Z1
 ... S Z="Unable to create FMS Billing Document: ",Z0=$P(ERR,U,2),Z1="Status remains NEW BILL."
 ... I '$G(PRAUTOA) D
 .... W *7,!!,Z,!,?10,Z0,!!,Z1,!! H 3
 ... E  D
 .... D SETERR(Z),SETERR(Z0),SETERR(Z1)
 ... S PRCA("STATUS")=18 D UPSTATS^PRCAUT2
 ... ;
 .. I '$G(PRAUTOA) D SIG1 W !,PRCA("MESG")
 .. D END
 . I PRCARETN=1,'$G(PRAUTOA) D RETN^PRCAUDT1 Q
 . D END
 D END
 Q
 ;
END L -^PRCA(430,+$G(PRCABN)) K %,DA,PRCAKT,PRCATY,PRCANM,PRCARETN,PRCAOK,PRCAT,DIC,DIE,DR,ERR,PRCASIG,J,Z0,D0,DI,PRC,PRCARI,DIR,DIRUT,DIROUT,DUOUT
 D CLEAN^DILF
 Q
 ;
 ;======================== SUBROUTINES ==========================
BULL(PRCABN) ; Send a bulletin for auto audit errors
 ; PRCABN = ien of bill in file 430
 N XMBODY,XMB,XMINSTR,XMTYPE,XMFULL,XMTO,XMZ,XMERR,PRCAE,CT,Z
 S XMTO("I:G.RCDPE PAYMENTS")="",CT=0
 S CT=CT+1,PRCAE(CT)="The following problem(s) were encountered when attempting to auto-audit a bill",CT=CT+1,PRCAE(CT)="from IB's electronic return messages"
 S CT=CT+1,PRCAE(CT)=" ",Z=0
 F  S Z=$O(^TMP($J,"PRCA_AUTO_AUDIT_ERROR",Z)) Q:'Z  S CT=CT+1,PRCAE(CT)=$G(^(Z))
 S XMBODY="PRCAE"
 D SENDMSG^XMXAPI("","AUTO AUDIT FAILED FOR BILL "_$$BILL(PRCABN),XMBODY,.XMTO)
 Q
 ;
DIC S DIC="^PRCA(430,",DIC(0)="AEQM" D BILLN^PRCAUTL Q
DIE W ! S DA=PRCABN,DIC="^PRCA(430,",PRCA("LOCK")=0 D LOCKF^PRCAWO1 Q:PRCA("LOCK")=1  S DIE=DIC
 I '$$ACCK^PRCAACC(PRCABN),("^27^28^"'[("^"_PRCAKT_"^")) D CPLK^PRCAFUT(PRCABN)
 Q:$D(PRCA("EXIT"))  S DR="[PRCAE AUDIT]" D ^DIE K DIE,DR Q
DISPL ;display the accounts receivable data user has entered.
 Q:'$D(PRCABN)  NEW DIC,L,FR,TO,FLDS,IOP,BY
 S IOP=IO(0),DIC="^PRCA(430,",FLDS="[PRCA DISP AUDIT]",(FR,TO)=PRCABN,L=0,BY="@NUMBER" D EN1^DIP,WOBIL^PRCAUDT1 Q
ASK S %=2 W !,"IS THIS DATA CORRECT" D YN^DICN I %<0 S PRCA("EXIT")="" Q
 I %=0 D M1^PRCAMESG G ASK
 I %=1 S PRCAOK=1 Q
ASK1 S %=2 W !!,"Do you want to edit this information " D YN^DICN I %<0 S PRCA("EXIT")="" Q
 I %=0 D M2^PRCAMESG G ASK1
 I %=1 D DIE,DISPL,DISPLACC^PRCAFUT G ASK
ASK2 S %=2 W !!,"Then do you want to return this bill to the service" D YN^DICN I %<0 S PRCA("EXIT")="" Q
 Q:%=2  I %=0 W !,"Answer 'Y' (YES) or 'N' (NO)" G ASK2
ASK3 S %=2 W !,"Are you sure you want to return" D YN^DICN I %<0 S PRCA("EXIT")="" Q
 I %=0 W "Answer 'Y' (YES) if you want to return this bill to the service that originated it.  If not, answer 'N' (NO)." G ASK3
 I %=1 S PRCARETN=1 Q
 Q  ;end of ASK
SIG N PRCADUZ
 I $G(PRAUTOA) S PRCADUZ=+$O(^VA(200,"B","PRCA,AUTOAUDIT",0)),PRCANM="AUTO-AUDIT"
 I '$G(PRAUTOA) S DA=PRCABN D SIG^PRCASIG
 D NOW^%DTC I $D(PRCANM) S $P(^PRCA(430,PRCABN,9),U,1,3)=$S('$G(PRAUTOA):+DUZ,1:PRCADUZ)_U_PRCANM_U_%,PRCASIG=1
 Q
SIG1 S PRCANM=$P($G(^VA(200,DUZ,20)),U,2) I PRCANM]"" D EN^PRCASIG(.PRCANM,DUZ,PRCABN_+$P(^PRCA(430,PRCABN,0),U,3)) S $P(^PRCA(430,PRCABN,9),U,2)=PRCANM
 Q
MESSG Q
SEGMT D:$D(^DGCR(399,PRCABN)) ^IBCAMS S:'$D(^DGCR(399,PRCABN)) Y=297 Q
UPSEG ;
 S PRCAT=$P(^PRCA(430,PRCABN,0),U,2),$P(^(0),U,21)=""
 D SEGMT^PRCAEOL
 Q
CKSITE ;check site parameter and user number.
 NEW DIC
 S DIC="^DIC(4,",DIC(0)="QEAM",DIC("B")=$P($G(^RC(342,1,0)),"^"),DIC("A")="SITE: " D ^DIC Q:Y<0  S PRCA("SITE")=+$$GET1^DIQ(4,+Y,99) Q:'PRCA("SITE")
 S PRCA("CKSITE")="" Q
MTCHK N PRCAI,PRCAMT,PRCAMT1,Z,Z0
 S PRCAMT1=0 F PRCAI=0:0 S PRCAI=$O(^PRCA(430,PRCABN,2,PRCAI)) Q:'PRCAI  S PRCAMT=+$P($G(^(PRCAI,0)),"^",8) I PRCAMT S PRCAMT1=PRCAMT1+1
 I PRCAMT1=1 Q
 S Z="Currently, just one Fiscal Year amount is sent to FMS.",Z0="This bill has "_PRCAMT1_" entered and should be returned to the service."
 I '$G(PRAUTOA) D
 . W !!,?3,Z,?3,Z0,!
 E  D
 . D SETERR("BILL: "_$$BILL(PRCABN)),SETERR(Z),SETERR(Z0)
 S PRCA("EXIT")=""
 Q
 ;
AUDITX(PRCABN) ; Auto audit a bill
 N PRAUTOA
 K ^TMP($J,"PRCA_AUTO_AUDIT_ERROR")
 L +^PRCA(430,+$G(PRCABN)):5 I '$T D SETERR(PRCABN,"ANOTHER USER HAS LOCKED BILL "_$$BILL(PRCABN))
 I '$D(^TMP($J,"PRCA_AUTO_AUDIT_ERROR")) D AUDITB(PRCABN,1,0)
 ;
 I $D(^TMP($J,"PRCA_AUTO_AUDIT_ERROR")) D BULL(PRCABN)
 K ^TMP($J,"PRCA_AUTO_AUDIT_ERROR")
 Q
 ;
SETERR(TEXT) ;
 S ^TMP($J,"PRCA_AUTO_AUDIT_ERROR",+$O(^TMP($J,"PRCA_AUTO_AUDIT_ERROR",""),-1)+1)=TEXT
 Q
 ;
BILL(PRCABN) ; Returns AR bill number in external format
 Q $P($G(^PRCA(430,+$G(PRCABN),0)),U)
 ;
