AUPNLK ; IHS/CMI/LAB - IHS PATIENT LOOKUP MAIN ROUTINE 24-MAY-1993 ;8DEC2006
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;patch 5 - fm v22
 ;'Modified' MAS Patient Look-up Routine for ADT Version 3.6, June 1987
 ; This routine will not be executed if DIC(0)["I" or caller
 ; used IX^DIC.
 ;
 ; AUPQF values have the following meaning:
 ;      0 = Initial state
 ;      1 = Primary error
 ;      2 = Operator/time out
 ;      3 = Retry
 ;      4 = Hit
 ;      5 = Added patient
 ;;EP;ENTERNAL ENTRY POINT
 ;
START ;
 ;Next line makes all patients accessable in a look up.
 N AUPNLK I $G(DUZ("AG"))="E" S AUPNLK("ALL")=1   ;New code DAOU/JLG  1/26/05
 D ^AUPNLKI ;             Initialization
 I AUPQF D EOJ Q
 D FINDPAT ;              Find patient
 D EOJ ;                  Cleanup
 S:'$D(X) X=""
 Q
 ;
FINDPAT ; FIND PATIENT
 I DIC(0)'["A" S AUPX=X D CHKPAT D:AUPQF=4 HIT Q
 F AUPL=0:0 S AUPQF=0 D ASKPAT D CHKPAT D:AUPQF=4 HIT Q:AUPQF'=3
 Q
 ;
ASKPAT ;
 K AUPCNT,AUPD,AUPIDS,AUPIFN,AUPIFNS,AUPNDAYS,AUPNDOB,AUPNDOD,AUPNICK,AUPNPAT,AUPNSEX,AUPNUM,AUPS,AUPSEL,DTOUT,DUOUT  ; IHS/SD/EFG  AUPN*99.1*13  3/16/2004
 ;N AUP,AUPBEG,AUPCNT,AUPDFN,AUPDIC,AUPDICS,AUPDICW,AUPI,AUPIFN,AUPIFNS,AUPIX,AUPL,AUPNICK,AUPNUM,AUPQF,AUPS,AUPSEL,AUPLP1,AUPMAPY  ; IHS/SD/EFG  AUPN*99.1*13  3/16/2004
 S AUPX=""
 ;W !!,$S($D(DIC("A")):DIC("A"),1:"Select PATIENT NAME: ") I $D(DIC("B")),DIC("B")]"" W DIC("B"),"// " S AUPX=DIC("B")
 ;D EN^DDIOL($S($D(DIC("A")):DIC("A"),1:"Select PATIENT NAME: "),"","!!") I $D(DIC("B")),DIC("B")]"" D EN^DDIOL(DIC("B")_"// ") S AUPX=DIC("B")
 NEW DSPVAL S DSPVAL=$S($D(DIC("A")):DIC("A"),1:"Select PATIENT NAME: ")
 I $D(DIC("B")),DIC("B")]"" S AUPX=DIC("B"),DSPVAL=DSPVAL_DIC("B")_"//"
 D EN^DDIOL(DSPVAL)
 R X:DTIME S:X["^" DUOUT=1 S:'$T DTOUT=1,X="^"
 S:X]"" AUPX=X
 Q
 ;
CHKPAT ;
 K AUPIFNS,AUPS,AUPSEL
 S AUPCNT=0
 I AUPX=""!(AUPX["^") S AUPQF=2 Q
 I AUPX["?" D ^AUPNLKH S AUPQF=3 Q
 ;I AUPX?1A!(AUPX'?.ANP)!($L(AUPX)>30)!($E(AUPX)=",") W:DIC(0)["Q" *7," ??" S AUPQF=3 Q
 I AUPX?1A!(AUPX'?.ANP)!($L(AUPX)>30)!($E(AUPX)=",") D:DIC(0)["Q"  S AUPQF=3 Q
 .NEW % S %=$C(7)_"  ??" D EN^DDIOL(%)
 I '$D(DIADD),AUPX'?1"""".E1"""" D LOOKUPS^AUPNLKB ; Find patient
 Q:AUPQF  ; Quit if patient found
 I DIC(0)["L" D ADDPAT^AUPNLKB ;  Try adding the patient
 Q:AUPQF  ; Quit if add successful
 ;W:DIC(0)["Q" *7," ??"
 I DIC(0)["Q" D EN^DDIOL($C(7)_"  ??")
 S AUPQF=3
 Q
 ;
HIT ;
 I DIC(0)["E" D WRT
 Q:AUPQF'=4
 I '$D(DICR),$T(SENS^DGSEC4)]"" S Y=+AUPDFN D ^DGSEC S AUPDFN=Y I Y<0 S AUPQF=3 Q  ;IHS/ANMC/LJF 9/1/2000
 S AUPX=$P(AUPS(AUPDFN),U,2),AUPDFN=AUPDFN_U_$P(AUPS(AUPDFN),U)
 N DA,X S DA=+AUPDFN X $P(^DD(2,.081,0),U,5,99) I $G(X),DIC(0)["E" D DUPECHK
 Q
 ;
WRT ;
 I $P(@(AUPDIC_"0)"),U,2)["O"!('$D(AUPSEL)&($D(AUPNICK(AUPDFN)))) D WRT2
 Q:AUPQF'=4
 I '$D(AUPSEL),'$D(AUPNICK(AUPDFN)),$P($P(AUPS(AUPDFN),U,2),AUPX)="" D
 .N % S %=$P(AUPS(AUPDFN),U,2) S:$P(AUPS(AUPDFN),U)'=% %=$E($P(AUPS(AUPDFN),U,2),$L(AUPX)+1,$L($P(AUPS(AUPDFN),U,2))) D EN^DDIOL(%)
 D EN^DDIOL($S($D(AUPSEL)!($P(AUPS(AUPDFN),U)'=$P(AUPS(AUPDFN),U,2)):"  "_$P(AUPS(AUPDFN),U)_"  ",1:"  "))
 S Y=+AUPDFN X:$D(^DPT(AUPDFN,0)) DIC("W")
 Q
 ;
WRT2 ;
 D EN^DDIOL("  "_$P(^DPT(AUPDFN,0),U)),EN^DDIOL("OK","","!?8")
 S %=1 D YN^DICN
 S:%'=1 AUPQF=3,AUPDFN=-1
 K %,%Y
 Q
 ;
DUPECHK ; SELECTED PATIENT HAS UNRESOLVED DUPES
 I $D(^VA(15,"ALK","DPT(",+Y,2)) S AUPMT=$O(^(2,0)) D DUPECHK2 Q
 ; Code to inform user of potential duplicates would go here.
 Q
 ;
DUPECHK2 ; VERIFIED DUPE
 D EN^DDIOL("The patient you have selected is a 'verified duplicate' of","","!?6")
 D EN^DDIOL($P(^DPT(AUPMT,0),U),"","!?12") D  ;S AUPSY=Y,Y=AUPMT D SET^AUPNLKZ X DIC("W") S Y=AUPSY ;D RESET^AUPNLKZ
 .N Y S Y=AUPMT X DIC("W")
 D EN^DDIOL("If you are adding data for this patient please reselect!","","!?6")
 K AUPMT,AUPSY
 Q
 ;
EOJ ;
 K AUPNLK("ICN")
 I AUPQF=1 S Y=-1 K AUPQF,AUPDIC,DIC("W") Q
 I AUPQF=2!(AUPQF=3) S Y=-1,X=AUPX D KILL Q
 S Y=AUPDFN,X=AUPX
 D EOJ2
 D KILL
 Q
 ;
EOJ2 ;
 ; - FOLLOW MERGE CHAIN  -
 S AUPSY=Y
 F AUPL=0:0 Q:'$P(^DPT(+Y,0),U,19)  S Y=$P(^(0),U,19),Y=Y_U_$P(^DPT(Y,0),U,1) ; Will abort if no ^DPT entry for Y
 I DIC(0)["E",Y'=AUPSY D EN^DDIOL("You now have patient "_$P(^DPT(+Y,0),U),"","!?6")
 K AUPSY
 ; -- SPACE BAR AND Y(0) --
 S:DIC(0)'["F" ^DISV($S($D(DUZ)#2:DUZ,1:0),"^DPT(")=+Y,^DISV($S($D(DUZ)#2:DUZ,1:0),"^AUPNPAT(")=+Y S:DIC(0)["Z" Y(0)=^DPT(+Y,0),Y(0,0)=$P(^(0),U,1)
 ; -- RESET Y AND Y(0) FOR 9000001 LOOKUP --
 I AUPDIC="^AUPNPAT(" S $P(Y,U,2)=+Y I DIC(0)["Z" S Y(0)=^AUPNPAT(+Y,0)
 ; -- POST SELECTION --
 X:$D(^DD(2,0,"ACT")) ^("ACT") X:$D(^DD(9000001,0,"ACT")) ^("ACT")
 ; -- SET NAKED --
 S:$D(AUPDIC) DIC=AUPDIC I $D(@(DIC_"+Y,0)"))
 ; ----- -
 Q
 ;
KILL ;
 ; - RESTORE DIC AND DIC("S") -
 S:$D(AUPDIC) DIC=AUPDIC
 ;K DIC("S","IHSORIG"),DIC("S","IHSLOOK") K:$D(DIC("S"))<10 DIC("S") S:$D(AUPDICS) DIC("S")=AUPDICS
 K AUPNORIG,AUPNLOOK K:$D(DIC("S"))<10 DIC("S") S:$D(AUPDICS) DIC("S")=AUPDICS ;IHS/ANMC/CLS 09/13/2000 fm v22
 ; - - -
 K D,DIC("W"),DO
 ;D:$D(AUPNLK("ALL")) RESET^AUPNLKZ ; Undocumented feature
 S AUPX=$S($D(AUPNLK("ALL")):1,1:0) K AUPNLK S:AUPX AUPNLK("ALL")=1
 K AUP,AUPBEG,AUPCNT,AUPDFN,AUPDIC,AUPDICS,AUPDICW,AUPI,AUPIFN,AUPIFNS,AUPIX,AUPL,AUPNICK,AUPNUM,AUPQF,AUPS,AUPSEL,AUPX,AUPLP1,AUPMAPY  ; IHS/SD/EFG  AUPN*99.1*13  3/16/2004
 Q
