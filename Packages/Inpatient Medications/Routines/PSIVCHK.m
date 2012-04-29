PSIVCHK ;BIR/PR,MLM-CHECK ORDER FOR INTEGRITY ;12 DEC 97 / 10:16 AM
 ;;5.0; INPATIENT MEDICATIONS ;**54,58,81,111**;16 DEC 97
 ;
 ; Reference to ^PS(51.1 supported by DBIA# 2177.
 ; Reference to ^DIE supported by DBIA# 2053.
 ;
 ;Need DFN and ON
 W ! S ERR=0,P("TYP")=P(4) S:P("TYP")="C" P("TYP")=P(23) I P("TYP")="S" S P("TYP")=$S(+P(5):"P",1:"A")
 I '+P("MR") W !,"*** You have not specified a med route! ",! S ERR=1
 I P(11)]"" S X=P(11) D CHK^DIE(51.1,1,"",X,.PSJTIM) I PSJTIM="^" W !,"*** Your administration time(s) are in an invalid format !" S ERR=1
M I P(15)<0 S ERR=1 W !,"*** Time interval between doses is less than zero !"
 NEW X S X=0 S:P(9)]"" X=$O(^PS(51.1,"APPSJ",P(9),0))
 ;I P("TYP")="P",('X!("^NOW^STAT^ONCE^"[(U_$P(P(9)," ")_U))),P(11)["-" S:'ERR ERR=2 W !,"*** WARNING -- You have a non-standard schedule ...",!?15,"with an administration time."
 ;* I P("TYP")="P",(P(15)!("^NOW^STAT^ONCE^"[(U_$P(P(9)," ")_U))),P(11)["-" S:'ERR ERR=2 W !,"*** WARNING -- You have a non-standard schedule ...",!?15,"with an administration time."
 N XX F XX=2,3 I $P(P(XX),".",2)=""!($L(P(XX))>12) S ERR=1 W !,"*** ",$S(XX=2:"Start",1:"Stop")," date is in an invalid format or must contain time !"
 I P(2)>P(3) S ERR=1 W !,"*** Start date/time CANNOT be greater than the stop date/time"
 I $$SCHREQ^PSJLIVFD(.P),'X D
 .N PSJXSTMP S PSJXSTMP=P(9) I PSJXSTMP="" S ERR=1 Q
 .N X,Y,PSGS0XT,PSGS0Y,PSGOES S PSGOES=2,X=PSJXSTMP D ENOS^PSGS0 I $G(X)]""&($G(X)=$G(PSJXSTMP)) Q
 .W !," *** WARNING -- Missing or Invalid Schedule ...",! S ERR=1
INF I P(8)="","AH"[P("TYP") S ERR=1 W !,"*** You have no infusion rate defined !"
 ;I "AH"[P("TYP"),P(8)'?1N.N1" ml/hr",P(8)'?.E1"@"1N.N S ERR=1 W !,"*** Your infusion rate is in an invalid format !"
 I "AH"[P("TYP"),P(8)'?1N.N.1".".1N1" ml/hr",P(8)'?.E1"@"1N.N S ERR=1 W !,"*** Your infusion rate is in an invalid format !"
 I P(8)="",P("TYP")="P" S:'ERR ERR=2 W !,"*** WARNING -- You have not specified an infusion rate. "
 I '$$CODES1^PSIVUTL(P("TYP"),55.01,.04)!(P("TYP")="") S ERR=1 W !,"*** Type of order is invalid !"
 I '$$CODES1^PSIVUTL(P(17),55.01,100)!(P(17)="") S ERR=1 W !,"*** Status of order is invalid !"
AH ;
 I "HA"[P("TYP"),(P(11)]""!(P(9)]"")) W !,$C(7),"Order type is an admixture, hyperal, or continuous syringe, and you have",!,"a schedule and/or administration times defined!"
 I  F Q=0:0 W !,"Ok to delete these fields" S %=1 D YN^DICN D NULSET Q:%
 K % I P(6)="" S ERR=1 W !,"*** You have not entered a physician!"
 I P(6)]"",'$D(^VA(200,+P(6),"PS")) S ERR=1 W !,"*** Physician entered does not exist or is not authorized to write",!,"medication orders"
 I P(6)]"",$D(^VA(200,+P(6),"PS")),(+$P(^("PS"),U,4)),($P(^("PS"),U,4)'>DT) S ERR=1 W !,"*** Physician entered is no longer active."
 D ^PSIVCHK1
 Q
 ;
NULSET ;Delete admin/schedule fields for hyperals and/or admixtures
 I '% W !!?2,"Enter 'YES' to delete the schedule and/or administration times fields from",!,"this order.  Enter 'NO' (or '^') to leave the fields intact.",! Q
 S:%=1 P(9)="",P(11)=""
 Q
CKO S P16=0,PSIVEXAM=1,PSIVCT=1 D PSIVCHK S PSIVNOL=1 W ! D ^PSIVORLB K PSIVEXAM Q:'ERR
 I ERR=2 F J=0:0 W !!,"Since there is a warning with this order.",!,"do you wish to re-edit this order" S %=1 D YN^DICN Q:%  W !!,"Answer 'YES' to re-edit this order."
 I ERR=2,%=1 S PSIVOK="57^58^59^26^39^63^64^62^10^25^1" D ^PSIVORV2,GSTRING^PSIVORE1,GTFLDS^PSIVORFE K DA,DIE,DR G CKO
 Q
