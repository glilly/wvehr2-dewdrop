AUPNLK2B ; IHS/CMI/LAB - Broke up AUPNLK2 because of size ;1/29/07  09:04
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;
TALK ; TALK TO OPERATOR
 D ASK ;                       Ask if want to add patient
 Q:AUPQF2
 D MIDDLE ;                    Ask for complete middle
 D NICKNM ;                    Check for nicknames
 D CHKID ;                     Get identifiers
 Q:AUPQF2
 D DUPECHK ;                   Check for dupes
 Q:AUPQF2
 W !!?3,"...adding new patient"
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
ASK ; ASK OPERATOR
 F AUPL=0:0 D ASKADD Q:%
 S:%'=1 AUPQF2=3
 Q
 ;
ASKADD ;
 S Y=+$P(^DPT(0),U,4)+1 W !?3,*7,"ARE YOU ADDING ",$S(AUPX'?.N:"'"_AUPX_"' AS ",1:""),"A NEW PATIENT (THE ",Y,$S(Y#10=1&(Y#100-11):"ST",Y#10=2&(Y#100-12):"ND",Y#10=3&(Y#100-13):"RD",1:"TH"),")"
 S %=2 D YN^DICN I '% W !?6,"Enter 'YES' to add a new patient, or 'NO' not to."
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
MIDDLE ;
 S AUPNMM=$P($P(AUPX,",",2)," ",2)
 Q:$L(AUPNMM)>2
 I $L(AUPNMM)=2,$E(AUPNMM,2)'="." Q
 ; IHS/SD/EFG  AUPN*99.1*12  12/2/2003  FIX PROBLEM WITH MIDDLE
 ; OR NAME NOT POPULATING PATIENT FILES CORRECTLY
 ;W !!?3,"Enter complete middle name if known,",!?5,"   or press <return> to add as entered: " R X:DTIME
 ;I '$T!(X="^") Q
 ;S Y=AUPX,Z=$P(Y,",",2),$P(Z," ",2)=X,$P(Y,",",2)=Z,X=Y K Z
 ;D NAME^AUPNPED
 ;Q:'$D(X)
 ;S AUPX=X
 K DIR
 S DIR(0)="FO^2:15"
 S DIR("A")="Enter complete middle name if known or press <return> to add as entered: "
 D ^DIR
 S:Y="/.,"!(Y="^^") DFOUT=""
 Q:$D(DFOUT)!$D(DUOUT)!$D(DTOUT)
 I $G(X)'="" S Y=AUPX,Z=$P(Y,",",2),$P(Z," ",2)=X,$P(Y,",",2)=Z,X=Y K Z
 I $G(X)="" S X=AUPX
 D NAME^AUPNPED
 K DIR,DFOUT,DUOUT,X,Y
 ; END OF CODE CHANGES FOR AUPN*99.1*12
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
NICKNM ; CHECK FIRST & MIDDLE NAMES FOR NICK NAMES
 S AUPNML=$P(AUPX,",",1),AUPNMF=$P($P(AUPX,",",2)," ",1),AUPNMM=$P($P(AUPX,",",2)," ",2),AUPNMX=$P(AUPX,",",3)
 I AUPNMF'="",$D(^APMM(99,"B",AUPNMF)) S AUPNMCVN=1 F AUPNMCV=0:0 S AUPNMCV=$O(^APMM(99,"B",AUPNMF,AUPNMCV)) Q:AUPNMCV=""  D NICKNM2 Q:AUPNMCV=""
 I AUPNMM'="",$D(^APMM(99,"B",AUPNMM)) S AUPNMCVN=2 F AUPNMCV=0:0 S AUPNMCV=$O(^APMM(99,"B",AUPNMM,AUPNMCV)) Q:AUPNMCV=""  D NICKNM2 Q:AUPNMCV=""
 S AUPX=AUPNML_","_AUPNMF_$S(AUPNMM'="":" "_AUPNMM,1:"")_$S(AUPNMX'="":","_AUPNMX,1:"")
 K AUPNML,AUPNMF,AUPNMM,AUPNMCV,AUPNMCVN,AUPNMCVX,AUPNMX
 Q
 ;
NICKNM2 ; CHECK NICK NAMES
 S AUPNMCVX=$S(AUPNMCVN=1:AUPNMF,1:AUPNMM)
 Q:AUPNMCVX=$P(^APMM(99,AUPNMCV,0),U,1)
 W !,"     Do you want ",$S(AUPNMCVN=1:AUPNMF,1:AUPNMM)," entered as ",$P(^APMM(99,AUPNMCV,0),U,1)
 S %=2 D YN^DICN
 S:%=1 @($S(AUPNMCVN=1:"AUPNMF",1:"AUPNMM"))=$P(^APMM(99,AUPNMCV,0),U,1),AUPNMCV=""
 K %,%Y
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
CHKID ; CHECK IDENTIFIERS
 Q:$D(DIC("DR"))
 S AUPGID="^.02^.03^.09^"
 F AUPID=.02,.03,.09 D CHKID1 Q:AUPQF2
 Q:AUPQF2
 F AUPID=0:0 S AUPID=$O(^DD(2,0,"ID",AUPID)) Q:'AUPID!(AUPQF2)  I '$F(AUPGID,U_AUPID_U) S AUPLID="",AUP("DR")=AUP("DR")_";"_AUPID
 Q
 ;
CHKID1 ;
 S AUP("DR")=$S('$D(AUP("DR")):AUPID,1:AUP("DR")_";"_AUPID) I $D(^DD(2,AUPID,0)) S AUPID0=^(0) D ASKID S:'$D(X) AUPQF2=4
 Q
 ;
ASKID W !?3,"PATIENT ",$P(AUPID0,U),": " R X:DTIME I '$T!(X?1"^") W !?6,*7,"<'",AUPX,"'> DELETED" K X Q
 I X="",AUPID=.09 S AUPIDS(AUPID)="",AUP("DR")=AUP("DR")_"////"_X Q
 I X["^" W:$E(X)["^" !?6,*7,"Sorry, '^' not allowed!" W " ??" G ASKID
 I X["?"!(X="") W:X="" *7," ??" D HLPID G ASKID
 I $P(AUPID0,U,2)["S" F I=1:1 S Y=$P($P(AUPID0,U,3),";",I) K:Y="" X Q:Y=""  I $P(Y,":",1)=X!($E($P(Y,":",2),1,$L(X))=X) S X=$P(Y,":",1),AUPSET=$P(Y,":",2) Q
 S (DA,D0)=0
 X $P(^DD(2,AUPID,0),U,5,99) I $D(X) W:$D(AUPSET) " ",AUPSET S AUPIDS(AUPID)=X,AUP("DR")=AUP("DR")_"////"_X K AUPSET Q
 W:'$D(X)&($P(AUPID0,U,2)'["D") *7," ??" D HLPID
 G ASKID
 ;
HLPID W:$D(^DD(2,AUPID,.1)) !?5,^(.1) W:$D(^DD(2,AUPID,3)) !?5,^(3) I $D(X),X["?" F I=0:0 S I=$O(^DD(2,AUPID,21,I)) Q:'I!(I>3&(X?1"?"))  I $D(^(I,0)) W !?5,^(0) I I>2,X?1"?" W !?5,"..."
 W:$D(^DD(2,AUPID,4)) !?5,^(4) I $P(AUPID0,U,2)["D" S X="?",%DT="E" D ^%DT
 I $P(AUPID0,U,2)["S" W !?7,"CHOOSE FROM: " F I=1:1 S Y=$P($P(AUPID0,U,3),";",I) Q:Y=""  W !?7,$P(Y,":",1),?15," ",$P(Y,":",2)
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
DUPECHK ; CHECK FOR DUPLICATE PATIENTS
 Q:$D(DIC("DR"))
 D ^AUPNLK3 S:AUPNLK3<0 AUPQF2=5 K AUPNLK3
 Q
