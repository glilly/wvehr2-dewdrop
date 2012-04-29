PSIVEDT1 ;BIR/MLM-EDIT IV ORDER (CONT) ;10 Mar 98 / 2:36 PM
 ;;5.0; INPATIENT MEDICATIONS ;**3,7,41,47,50,64,58,116,110,111**;16 DEC 97
 ;
 ; Reference to ^PS(55 is supported by DBIA# 2191.
 ; Reference to ^PS(51.1 is supported by DBIA# 2177.
 ;
10 ; Start Date
 D:'P(2)&P("IVRM")!($G(PSJREN)) ENT^PSIVCAL
A10 I $G(P("RES"))="R" I $G(ON)["P",$P($G(^PS(53.1,+ON,0)),"^",24)="R" D  Q
 . Q:'$G(PSIVRENW)  W !!?5,"This is a Renewal Order. Start Date may not be edited at this point." D PAUSE^VALM1
 I $G(ON)["V"!($G(ON)["U") I $$COMPLEX^PSJOE(DFN,ON) D  Q
 .Q:$G(PSJBKDR)  W !!?5,"This is a Complex Order. Start Date may not be edited at this point." D PAUSE^VALM1
 S Y=P(2) X ^DD("DD") W !,"START DATE/TIME: "_$S(Y]"":Y_"// ",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 I $E(X)=U!(P(2)&X="") Q
 I X["???",($E(P("OT"))="I"),(PSIVAC["C") D ORFLDS G 10
 I X="@"!(X?1."?") W:X="@" $C(7),"  (Required)" S F1=53.1,F2=10 S:X="@" X="?" D ENHLP^PSIVORC1 G A10
 K %DT S:X="" X=P(2) S %DT="ERTX" D ^%DT K %DT G:Y'>0 A10
 I $G(P("RES"))="R",(+Y<+$P($G(^PS(55,DFN,"IV",+$G(P("OLDON")),0)),U,2)) D  G 10
 .; naked ref below refers to line above
 .S Y=$P(^(0),U,2) X ^DD("DD") W $C(7),!!,"Start date of order being renewed is ",Y,".",!,"Start date of renewal order must be AFTER start date of order being renewed.",!
 S X1=$G(P("LOG")),X2=-7 D C^%DTC I +Y<X W !!,"Start date/time may not be entered prior to 7 days from the order's LOGIN DATE.",! D A10
 S P(2)=+Y,PSGSDX=1
 Q
 ;
25 ; Stop Date
 G:$D(PSGFDX) A25
 I P("IVRM")]"",$S(P(3)<P(2):1,$G(PSIVAC)["E":0,1:1) S PSIVSITE=$G(^PS(59.5,+P("IVRM"),1)),$P(PSIVSITE,"^",20,21)=$G(^PS(59.5,+P("IVRM"),5)) D ENSTOP^PSIVCAL
A25 I $G(ON)["V"!($G(ON)["U") I $$COMPLEX^PSJOE(DFN,ON) D  Q
 .Q:$G(PSJBKDR)  W !!?5,"This is a Complex Order. Stop Date may not be edited at this point." D PAUSE^VALM1
 S Y=P(3) X ^DD("DD") W !,"STOP DATE/TIME: "_$S(Y]"":Y_"// ",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 Q:X=""&P(2)  I $E(X)=U!(X=""&P(2)) Q
 I X["???",($E(P("OT"))="I"),(PSIVAC["C") D ORFLDS G 25
 I X="@"!(X["?") W $C(7),"  (Required)" S F1=53.1,F2=25,X="?" D ENHLP^PSIVORC1 G A25
 K %DT S:X="" X=P(3) S %DT="ERTX" D:X'=+X ^%DT
 I X=+X,X>0,X'>2000000 G A25:'$$ENDL^PSGDL(P(9),X) D ENDL^PSIVSP
 S X=Y S:Y<1!Y'["." X="" G:Y'>0 A25 S P(3)=+Y,PSGFDX=1
 Q
26 ; Schedule
 I $G(P("RES"))="R" I $G(ON)["P",$P($G(^PS(53.1,+ON,0)),"^",24)="R" D  Q
 . Q:'$G(PSIVRENW)  W !!?5,"This is a Renewal Order. Schedule may not be edited at this point." D PAUSE^VALM1
 I $G(ON)["V"!($G(ON)["U") I $$COMPLEX^PSJOE(DFN,ON) D  Q
 .Q:$G(PSJBKDR)  W !!?5,"This is a Complex Order. Schedule may not be edited at this point." D PAUSE^VALM1
 W !,"SCHEDULE: ",$S(P(9)]"":P(9)_"// ",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 I $E(X)=U!(X="") Q
 I X="@" D DEL^PSIVEDRG S:%=1 P(9)="" G 26
 I X["???",($E(P("OT"))="I"),(PSIVAC["C") D ORFLDS G 26
 ;/I X?1."?"!($L(X)>22)!($L(X," ")>2) S F1=55.01,F2=.09 D ENHLP^PSIVORC1 G 26
 I X?1."?"!($L(X)>22)!($L(X," ")>3) S F1=55.01,F2=.09 D ENHLP^PSIVORC1 G 26
 S P(7)="" N PSGOES K PSGOES D EN^PSIVSP S:XT<0 X="" I $G(X)="" W $C(7),"??" G 26
 S P(9)=X,P(11)=Y,P(15)=XT
 Q
 ;
39 ; Admin Times
 I $G(P("RES"))="R" I $G(ON)["P",($P($G(^PS(53.1,+ON,0)),"^",24)="R") D  Q
 . Q:'$G(PSIVRENW)  W !!?5,"This is a Renewal Order. Administration times may not be edited at this point." D PAUSE^VALM1
 I $G(ON)["V"!($G(ON)["U") I $$COMPLEX^PSJOE(DFN,ON) D  Q
 .Q:$G(PSJBKDR)  W !!?5,"This is a Complex Order. Admin Times may not be edited at this point." D PAUSE^VALM1
 I $$ODD^PSGS0(P(9)) Q
 W !,"ADMINISTRATION TIMES: ",$S(P(11)]"":P(11)_"//",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 I '($G(P(15))="D"&'DONE) I $E(X)=U!(X="") Q
 I ($G(P(15))="D"!($G(P(9))["@"))&('$G(X)!(X["@")) W $C(7),"  ??" S X="?" W:(P(15)="D"!(X["@")) !,"This is a 'DAY OF THE WEEK' schedule and MUST have admin times." G 39
 I X="@" D DEL^PSIVEDRG S:%=1 P(11)="" G 39
 I X["?" S F1=55.01,F2=.12 D ENHLP^PSIVORC1 G 39
 I X["???",($E(P("OT"))="I"),(PSIVAC["C") D ORFLDS G 39
 ;K:X[""""!($A(X)=45) X D:$D(X) CHK^DIE(51.1,1,"",X,.X) W:$G(X)="^"!('$D(X)) $C(7),"  ??" G:$G(X)="^"!('$D(X)) 39 S P(11)=X D:$G(PSIVCAL) ENT^PSIVCAL,ENSTOP^PSIVCAL K PSIVCAL
 K:X[""""!($A(X)=45) X D:$D(X) ENCHK^PSGS0 W:$G(X)="^"!('$D(X)) $C(7),"  ??" G:$G(X)="^"!('$D(X)) 39 S P(11)=X D:$G(PSIVCAL) ENT^PSIVCAL,ENSTOP^PSIVCAL K PSIVCAL
 Q
 ;
59 ; Infusion Rate
 I $G(P("RES"))="R" I $G(ON)["P",$P($G(^PS(53.1,+ON,0)),"^",24)="R" D  Q
 . Q:'$G(PSIVRENW)  W !!?5,"This is a Renewal Order. Infusion Rate may not be edited at this point." D PAUSE^VALM1
 W !,"INFUSION RATE: ",$S(P(8)]"":P(8)_"//",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 I $S($E(X)=U:1,X]"":0,1:P(8)]"") Q
 I X=""&(("C^P"[P(4))!(("C^S"[P(4))&(P(5)=1))) Q
 I X="@" D DEL^PSIVEDRG S:%=1 P(8)="" G 59
 I X["???",($E(P("OT"))="I"),(PSIVAC["C") D ORFLDS G 59
 I X["?" S F1=53.1,F2=59 D ENHLP^PSIVORC1 G 59
 I X]"" D ENI^PSIVSP W:'$D(X) $C(7)," ??" G:'$D(X) 59 S P(8)=X
 I P(8)="" W $C(7),!!,"An infusion rate must be entered!" G 59
 Q
 ;
63 ; Remarks
 N DIR S X="",DIR(0)="53.1,63" S:P("REM")]"" DIR("B")=P("REM") D ^DIR I X="^"!$D(DTOUT) S DONE=1 Q
 I X="@" D DEL^PSIVEDRG S:%=1 P("REM")="" G 63
 I X]"",$E(X)'="^" S P("REM")=X
 Q
 ;
64 ; Other Print Info
 N DIR S X="",DIR(0)="53.1,64" S:P("OPI")]"" DIR("B")=$P(P("OPI"),"^") D ^DIR I X="^"!$D(DTOUT) S DONE=1 Q
 I X="@" D DEL^PSIVEDRG S:%=1 P("OPI")="" G 64
 I X]"",$E(X)'="^" S P("OPI")=X,P("OPI")=$$ENBCMA^PSJUTL("V")
 Q
 ;
ORFLDS ; Display OE/RR fields during edit.
 D FULL^VALM1
 W !!,"Orderable Item: ",$P(P("PD"),U,2),!,"Give: ",$P(P("MR"),U,2)," ",P(9),!!
 Q
