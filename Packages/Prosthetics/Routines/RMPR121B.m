RMPR121B        ;PHX/HNC -POST GUI PURCHASE ORDER TRANSACTION ;3/1/2003
        ;;3.0;PROSTHETICS;**90,75,137,147**;FEB 09,1996;Build 4
        ;Per VHA Directive 10-93-142, this routine should not be modified.
A1(SIG,RMPRA,RMPRSITE)  S RMPRGUI=1 G A2
GUI(RESULT,SIG,RMPRA,RMPRSITE,RMPRPTR)  ;
A2      I (SIG="")!($E(SIG)="^") S RESULT=1_"^"_"Not Valid, Try Again..." Q
        K RESULT D SIGN
        Q
        ;
SIGN    ; Validate /es/-code
        ;
        S X=SIG
        S RMPRY=0
        D HASH^XUSHSHP I X]"",(X=$P($G(^VA(200,+DUZ,20)),U,4)) S RMPRY=1
        I RMPRY=0 S RESULT=1_"^"_"Checked signature Not Valid, Try Again..." Q
        ;
        S RMPRV=$P(^RMPR(664,RMPRA,0),U,4)
        S RMPRPER=$P(^RMPR(664,RMPRA,2),U,6)/100
        D GUIVAR
        S PRCRMPR=1,X=1,PRCRMPR=1
        D UP1^PRCH7PUC(.X,PRCA,PRCB,PRCC,PRCSITE,PRCVEN,PRCRMPR)
        I X="^" D C664 G QUIT
        S PRC442=$P(^RMPR(664,RMPRA,4),U,6)
        I $P(^PRC(442,PRC442,7),U,1)'=6 G QUT
        S $P(^RMPR(664,RMPRA,0),U,5)="",$P(^RMPR(664,RMPRA,2),U)="",$P(^RMPR(664,RMPRA,2),U,2)=""
        I $D(RMPRPSC) S $P(^RMPR(664,RMPRA,2),U,5)=RMPRPSC
        S RMPRPCD=$P(^RMPR(664,RMPRA,4),U,1),$P(^RMPR(664,RMPRA,4),U,1)=$$ENC^RMPR4LI(RMPRPCD,DUZ,RMPRA)
        S DA=RMPRA,DIK="^RMPR(664," D IX1^DIK
        ;get AMIS grouper number
        L +^RMPR(669.9,RMPRSITE,0):999 I $T=0 S RMPRG=DT_99 G GGC
        S RMPRG=$P(^RMPR(669.9,RMPRSITE,0),U,7),RMPRG=RMPRG-1,$P(^(0),U,7)=RMPRG L -^RMPR(669.9,RMPRSITE,0)
        ;
GGC     S B2=0
        F  S B2=$O(^RMPR(664,RMPRA,1,B2)) Q:B2'>0  D R19^RMPR121C
        K RMPRDP
        ; Shipping Record
        I +RMPRSH'>0 G NS
        K DD,DO S X=DT,DIC="^RMPR(660,",DIC(0)="LZ" D FILE^DICN K DIC,D0 S (RMPR660,DA)=+Y
        S RMPRTRN=$P(^RMPR(664,RMPRA,4),U,5)
        S $P(^RMPR(660,RMPR660,4),U,3)=RMPRV
        S ^RMPR(660,RMPR660,0)=DT_U_RMPRDFN_U_DT_"^X^^^^^"_U_RMPR("STA")_"^^^14"_U_RMPRS_"^^"_RMPRSH_"^"_RMPRSH_"^^^^^",^("AMS")=RMPRG,^("AM")=U_U_RMPRDIS_U_RMPRSC,$P(^(0),U,27)=DUZ
        ; /SPS Removed the following 2 lines for 75 may re-use at a later time
        ; I $D(RMPRWO),RMPRWO S $P(^("AM"),U,2)=1 D
        ;.I $D(^RMPR(664.2,RMPRWO,0)) S $P(^(0),U,6)=$P(^(0),U,6)+RMPRSH
        S:$D(RMPRDELN) ^RMPR(660,RMPR660,3)=RMPRDELN S ^(1)=RMPRTRN
        S DIK="^RMPR(660," D IX1^DIK S $P(^RMPR(664,RMPRA,0),U,12)=RMPR660 K RMPRDP
NS      S $P(^RMPR(664,RMPRA,2),U,4)="2421PC"
        S RESULT=0_"^"_"PO COMPLETE"
        S ^TMP("SPS",0)=RMPRPTR
        I RMPRPTR=0 D ^RMPR4P21
        I +RMPRPTR>0 D EN1^RMPR4P21(RMPRPTR)
        Q
QUIT    ; Quit where IFCAP encountered a problem
        S RESULT=1_"^"_"**STAND BY**  Your IFCAP order may be canceled due to a lack of funds. If you can immediately get an increase of funds re-enter your e-sig and complete this PO.  IF YOU LEAVE THIS SCREEN YOUR PO WILL BE LOST"
        Q
QUT     ;
        S RESULT="1^IFCAP did not update your Purchase Order, Please Log out and start over."
        Q
GUIVAR  ; Get variable setup from the GUI application
        ; Setup Site Variables
        D INF^RMPRSIT
        ; Shipping info
        S $P(^RMPR(664,RMPRA,0),U,14)=RMPR("STA")
        S (R1,RMPRCT,RMPRQT,RMPRTO,RMPRI,RMPRR)=0
        S RMPRSH=$S($P(^RMPR(664,RMPRA,0),U,10):$P(^(0),U,10),1:"")
        F  S R1=$O(^RMPR(664,RMPRA,1,R1)) Q:R1'>0  D
        .S RB=^RMPR(664,RMPRA,1,R1,0)
        .S RMPRCT=$P(RB,U,3)
        .S RMPRQT=$P(RB,U,4)
        .S RMPRR=$P(RB,U,8) ;REMARKS
        .S RMPRTO=RMPRTO+$J(RMPRCT*RMPRQT,0,2)
        S RMPRTOTC=$P($G(^RMPR(664,RMPRA,4)),U,3)
        S PRCA=RMPRA
        S PRCB=$P(^RMPR(664,RMPRA,4),U,6)
        S PRCC=RMPRTOTC
        S PRCSITE=$P(^RMPR(664,RMPRA,0),U,14)
        S PRCVEN=$P(^RMPR(664,RMPRA,0),U,4)
        S RMPRDFN=$P(^RMPR(664,RMPRA,0),U,2)
        S RMPRPPA=$P(^VA(200,DUZ,1),U,9)
        ; Setup Delivery to Variables
        S RMPRY(0)=$P($G(^RMPR(664,RMPRA,3)),U)
TST     S RMPRY=$S(RMPRY(0)="VETERAN":1,RMPRY(0)="PROSTHETICS":2,RMPRY(0)="OTHER LOCATION AT THIS SITE":3,RMPRY(0)="OTHER LOCATION NOT AT THIS SITE":4,1:"")
        D DELIV^RMPR121A
        Q
C664    ;CANCEL 664 ENTRY WHEN IFCAP IS CANCELLED
        S $P(^RMPR(664,RMPRA,0),U,5)=$P(^RMPR(664,RMPRA,0),U),$P(^RMPR(664,RMPRA,2),U,2)=+DUZ
        S WDS="INSUFF FUNDS CANCEL",DA=RMPRA,DR="3.1////^S X=WDS",DIE="^RMPR(664," D ^DIE K WDS
        Q
