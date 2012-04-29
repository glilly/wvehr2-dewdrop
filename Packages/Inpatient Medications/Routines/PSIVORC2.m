PSIVORC2 ;BIR/MLM-PROCESS INCOMPLETE IV ORDER - CONT ;22 OCT 97 / 3:16 PM
 ;;5.0; INPATIENT MEDICATIONS ;**29,49,50,65,58,85,101,110,127,151**;16 DEC 97
 ;
 ; Reference to ^ORD(101 is supported by DBIA #872
 ; Reference to ^PS(51.2 is supported by DBIA #2178
 ; Reference to ^PS(55 is supported by DBIA #2191
 ; Reference to ^PS(52.6 is supported by DBIA #1231.
 ; Reference to ^PS(52.7 is supported by DBIA #2173.
 ; Reference to EN1^ORCFLAG is supported by DBIA #3620.
 ; Reference to ^PSSLOCK is supported by DBIA #2789
 ;
EDCHK ;Update or create new order in 55.
 D CKORD D:'$G(PSJIVORF) ORPARM^PSIVOREN I 'PSJIVORF W !,"Either the Inpatient Medications or the IV Medications package is not on, please check the Order Parameters file" Q
 I PSIVCHG,PSJIVORF D NATURE^PSIVOREN I '$D(P("NAT")) W $C(7),"Order unchanged" Q
 ;;S:PSIVCHG P(21)=""
 S:PSIVCHG P("21FLG")=""
 I $G(PSJCOM) D IV^PSJCOMV Q
 Q:$$NONVF()
ACTIVE ;
 S PSJCOM=P("PRNTON")
 I PSJCOM D VFYIV^PSJCOMV Q
 S P("RES")=$P($G(^PS(53.1,+ON,0)),U,24)
 I P("RES")="R" S P("NEWON")=P("OLDON") S PSJOSTOP="" D RUPDATE^PSIVOREN(DFN,ON,P(2))
 I P("RES")'="R" S PSJORD=ON,P(17)="A",ORSTS=6,PSJORNP=P(6) D SETNEW^PSIVORFB S P("NEWON")=ON55 D @$S(PSIVCHG:"NEWORD",1:"OLDORD")
 S (ON55,ON)=P("NEWON"),OD=P(2) D EN^PSIVORE
 D VF1^PSJLIACT("F","ORDER VERIFIED BY ",1)
 D ENLBL^PSIVOPT(2,DUZ,DFN,3,+ON55,"N")
 I $G(^PS(55,DFN,"IV",+ON55,4)) D EN1^PSJHL2(DFN,"ZV",ON55)
 L -^PS(53.1,+$G(PSJORD)) L -^PS(55,DFN,"IV",+ON55)
 Q
 ;
CKORD ;Check if new order is to be created.
 I $G(PSIVCOPY) S PSIVCHG=0 Q
 N ND S PSIVCHG=0,ND(0)=$G(^PS(53.1,+ON,0)),ND("PD")=$G(^PS(53.1,+ON,.2))_U_$P(ND(0),U,3)
 N X S X=$P($G(^PS(53.1,+ON,8)),U,5),X=$S(P(8)["@":$P(X,"@"),1:X)
 S ND=$S($E(P("OT"))="I":P(8)_U_$P($G(^PS(53.1,+ON,2)),U)_U_$P(ND(0),U,3)_U_+$P(ND("PD"),U),1:X_U_$P($G(^PS(53.1,+ON,2)),U)_U_+P("MR")_U_+P("PD"))
 S ND=ND_U_$S($P(ND(0),U,2)=+P("CLRK"):+$P(ND(0),U,2),1:+P(6))
 I ND'=($S($E(P("OT"))="I":P(8),P(8)["@":$P(P(8),"@"),1:P(8))_U_P(9)_U_+P("MR")_U_+P("PD")_U_+P(6)) S PSIVCHG=1  Q
 Q:P(17)="P"
 N DNE,ND,TDRG S (DRG("DRGC"),DNE)=0
 Q:PSIVCHG  F DRGT="AD","SOL" F DRGI=0:0 S DRGI=$O(DRG(DRGT,DRGI)) Q:'DRGI  S TDRG(DRGT,+$P(DRG(DRGT,DRGI),U),DRGI)=$P(DRG(DRGT,DRGI),U,3) I $P(P("OT"),U)="F",'$P(DRG(DRGT,DRGI),U,5) S P("OT")="I"
 F DRGT="AD","SOL" Q:DRGT="SOL"&(P("DTYP")=1)  F DRGI=0:0 S DRGI=$O(^PS(53.1,+ON,DRGT,DRGI)) Q:'DRGI!DNE  D
 .S X=$G(^PS(53.1,+ON,DRGT,DRGI,0)),DRG("DRGC")=$G(DRG("DRGC"))+1
 .I $D(TDRG(DRGT,+$P(X,U),DRGI)),$P(X,U,2)=$P(TDRG(DRGT,+$P(X,U),DRGI),U) Q
 .S (PSIVCHG,DNE)=1
 Q:PSIVCHG
 I $G(DRG("AD",0))+$S(P("DTYP")=1:0,1:DRG("SOL",0))'=DRG("DRGC") S PSIVCHG=1 Q
CKPC ;
 Q:PSIVCHG  I $E(P("OT"))'="I" D
 .;
 .; Check IV drugs for changes.
 .S DNE=0 F DRGT="AD","SOL" I $D(DRG(DRGT)) S FIL="52."_$S(DRGT="AD":6,1:7) D
 ..N ND,TDRG F DRGI=0:0 S DRGI=$O(DRG(DRGT,DRGI)) Q:'DRGI!DNE  S TDRG(+$P(DRG(DRGT,DRGI),U),DRGI)=DRGI,TDRG("CNT")=+$G(TDRG("CNT"))+1
 ..F ON1=0:0 S ON1=$O(^PS(53.1,+ON,DRGT,ON1)) Q:'+ON1!DNE  S ND=$G(^PS(53.1,+ON,DRGT,ON1,0)),ND("CNT")=$G(ND("CNT"))+1 D
 ...S DRG=+$P(ND,U) S:'$D(TDRG(+DRG)) (DNE,PSIVCHG)=1 F DRGI=0:0 S DRGI=$O(TDRG(+DRG,DRGI)) Q:'DRGI!DNE  I $P($G(DRG(DRGT,DRGI)),U)_U_$P($G(DRG(DRGT,DRGI)),U,3)'=$P(ND,U,1,2) S (DNE,PSIVCHG)=1
 ..S:$G(ND("CNT"))'=$G(TDRG("CNT")) (DNE,PSIVCHG)=1 K ND,TDRG
 Q
 ;
OLDORD ; Update old order, update order links.
 Q:P("RES")="R"
 S P("OLDON")=$P($G(^PS(53.1,+ON,0)),U,25) I P("OLDON")'=ON55 S $P(^PS(55,DFN,"IV",+ON55,2),U,8)=P("RES"),$P(^(2),U,5)=P("OLDON") I P("OLDON") D
 .I P("OLDON")["V",$D(^PS(55,DFN,"IV",+P("OLDON"),0)) S $P(^(2),U,6)=ON55,$P(^(2),U,9)=P("RES")
 .I P("OLDON")["A",$D(^PS(55,DFN,5,+P("OLDON"),0)) S $P(^(0),U,26,27)=ON55_U_P("RES")
 .;I P("OLDON")["P",$D(^PS(53.1,+P("OLDON"),0)) S $P(^(0),U,26,27)=ON55_U_P("RES")
 .I $S(P("OLDON")["P":1,P("OLDON")["N":1,1:0),$D(^PS(53.1,+P("OLDON"),0)) S $P(^(0),U,26,27)=ON55_U_P("RES")
 D PUT531^PSIVORFA S $P(^PS(53.1,+ON,0),U,25,26)="^",ON=ON55 D UPD100^PSIVORFA
 Q
 ;
NEWORD ; Create new order, update order links.
 Q:P("RES")="R"
 S $P(^PS(53.1,+ON,0),U,26,27)=P("NEWON")_U_"E",PSIVAC="CE",PSJORNAT=P("NAT") D DC^PSIVORA
 S P("NEWON")=$P($G(^PS(53.1,+PSJORD,0)),U,26),$P(^PS(55,DFN,"IV",+P("NEWON"),2),U,5)=PSJORD,$P(^(2),U,8)="E",ON=ON55
 ;;I PSJIVORF D SET^PSIVORFE D EN1^PSJHL2(DFN,"SN",+ON55_"V","NEW ORDER CREATED")
 I PSJIVORF D EN1^PSJHL2(DFN,"SN",+ON55_"V","NEW ORDER CREATED")
 Q
 ;
GTIVDRG ; Try to find an IV drug from the Orderable Item.
 ; If there is only 1 match to OI then stuff in DRG otherwise prompt user to select which
 ; ad/sol matched to OI
 K PSIVOI NEW FIL,ND,SCR,PSJNOW
 D NOW^%DTC S PSJNOW=%
 S SCR("S")="S ND=$P($G(^(""I"")),U) I ND=""""!(ND>PSJNOW)"
 F FIL=52.6,52.7 D FIND^DIC(FIL,,"@;.01;2","QXP",+P("PD"),,"AOI",SCR("S"),,"PSIVOI") I +PSIVOI("DILIST",0)>0 D  Q
 . S DRGT=$S(FIL=52.6:"AD",1:"SOL"),PSIVOI=DRGT
 . I PSIVOI="AD" D
 .. N XX,XXX,QC S XX=0 F  S XX=$O(PSIVOI("DILIST",XX)) Q:XX=""  S XXX=+PSIVOI("DILIST",XX,0) D LIST^DIC(52.61,","_XXX_",","@;.01","PQ",,,,,,,"PSIVQC") D
 ... I +$G(PSIVQC("DILIST",0))>0 S QC=0 F  S QC=$O(PSIVQC("DILIST",QC)) Q:QC=""  S PSIVOI("DILIST",XX,QC,0)=PSIVQC("DILIST",QC,0)
 ... K PSIVQC("DILIST",0),PSIVQC("DILIST",0,"MAP")
 .. D RESET
 . I +PSIVOI("DILIST",0)=1 D
 .. S DRG=+PSIVOI("DILIST",1,0)
 .. S DNE=1,DRG(DRGT,0)=1,ND=$G(^PS(FIL,+DRG,0)),DRG(DRGT,1)=+DRG_U_$P(ND,U)_U_$S(FIL=52.7:$P(ND,U,3),1:"")_U_U_$P(ND,U,13)_U_$P(ND,U,11)
 K:+PSIVOI("DILIST",0)<2 PSIVOI
 Q
 ;
EDIT ; Edit incomplete order
 S PSIVAC="CE"
 I $E(P("OT"))="I",'$D(DRG("AD")),('$D(DRG("SOL"))) D GTIVDRG
 I P(4)="" D 53^PSIVORC1 Q:P(4)=""  D ^PSIVORV2
 D GSTRING^PSIVORE1,GTFLDS^PSIVORFE ;S (PSIVOK,EDIT)="57^58^59^3"_$S(P("DTYP")=1:"^26^39",1:"")_"^63^64^"_$S($E(P("OT"))="I":"101^109^",1:"")_"10^25"_$S(+P(6)'=+P("CLRK"):"^1",1:"") D GTFLDS^PSIVORFE
 Q:$G(DONE)
 I $G(^ORD(101,+$P($G(VALM("PROTOCOL")),";"),0))["PSJ PC IV AC/EDIT ACTION" S PSIVENO=1
 I '$G(PSIVENO) S PSIVENO=1 D EN^VALM("PSJ LM IV AC/EDIT") S VALMBCK="Q"
 ;;K ON55 D COMPLTE^PSIVORC1
 Q
 ;
FINISH ; Ask only for missing data in incomplete IV order.
 S P("OPI")=$$ENPC^PSJUTL("V",+PSIVUP,60,P("OPI")) I $E(P("OT"))="I",'$D(DRG("AD")),('$D(DRG("SOL"))) S DNE=0 D GTIVDRG
 D:P(4)="" 53^PSIVORC1 Q:P(4)=""  S P("DTYP")=$S(P(4)="":0,P(4)="P"!(P(23)="P")!(P(5)):1,P(4)="H":2,1:3)
 I 'P(2) D ENT^PSIVCAL K %DT S X=P(2),%DT="RTX" D ^%DT S P(2)=+Y
 I 'P(3) D ENSTOP^PSIVCAL K %DT S X=P(3),%DT="RTX" D ^%DT S P(3)=+Y
 I 'P("MR") S P("MR")=$O(^PS(51.2,"B","INTRAVENOUS",0))_"^IV"
 S PSIVOK="1^3^10^25^26^39^57^58^59^63^64" D CKFLDS^PSIVORC1 D:EDIT]"" EDIT^PSIVEDT G COMPLTE^PSIVORC1
 Q
NONVF() ; Updated 53.1 status to non-verified after finish.
 NEW PSGOEAV S PSGOEAV=+$P(PSJSYSP0,U,9)
 I +PSJSYSU=3,PSGOEAV Q 0
 I +PSJSYSU=1,PSGOEAV Q 0
 I PSIVCHG D NWNONVF Q 1
 S P(17)="N",P("REN")=0
 D GTPD^PSIVORE2
 W !,"...transcribing this non-verified order...."
 S $P(^PS(53.1,+ON,.2),U)=""
 D PUT531^PSIVORFA
 D NEWNVAL^PSGAL5(ON,$S(+PSJSYSU=1:22000,+PSJSYSU=3:22005,1:22006),"","")
 NEW PSIVORFA S PSIVORFA=1 D:ON["V" DEL55^PSIVORE2
 D EN1^PSJHL2(DFN,"XX",ON,"UPDATED ORDER")
 D VF
 Q 1
NWNONVF ;Create non-verified due to edit
 ;D NATURE^PSIVOREN I '$D(P("NAT")) Q
 K DA D ENGNN^PSGOETO S P("NEWON")=DA_"P",P(17)="N",P("REN")=0
 S PSJORD=ON,$P(^PS(53.1,+ON,0),U,26,27)=P("NEWON")_U_"E",PSIVAC="CE",PSJORNAT=P("NAT") D DC^PSIVORA
 S P("OLDON")=ON,ON=P("NEWON")
 S P("RES")="E"
 ;D:P("DO")="" GTPD^PSIVORE2 ;Get dosage order if not defined for IPM IV
 S P("DO")="" D GTPD^PSIVORE2 ;Get dosage order if not defined for IPM IV
 D PUT531^PSIVORFA
 S $P(^PS(53.1,+ON,0),U,25,26)=P("OLDON")_U_""
 D NEWNVAL^PSGAL5(ON,$S(+PSJSYSU=1:22000,+PSJSYSU=3:22005,1:22006),"","")
 D EN1^PSJHL2(DFN,"SN",ON,"SEND ORDER NUMBER")
 S:$D(PSGP)#10 PSJNOL=$$LS^PSSLOCK(PSGP,ON)
 D VF
 Q
VF ; Display Verify screen
 Q:ON'["P"
 K PSJIVBD
 D GT531^PSIVORFA(DFN,ON)
 S PSGACT="EL"
 I P(17)="N",(P("OLDON")=""),(+P("CLRK")=DUZ) S PSGACT="ELD"
 I +PSJSYSU=3!(+PSJSYSU=1) S PSGACT="DELV"
 I +PSJSYSU=3,$L($T(EN1^ORCFLAG)) S PSGACT=PSGACT_"G"
 I P("OT")="I" S PSJSTAR="(1)^(5)^(7)^(9)^(10)"
 I P("OT")'="I" S PSJSTAR="(1)^(2)^(3)^(5)^(7)^(9)"
 D EN^VALM("PSJ LM IV INPT ACTIVE")
 Q
 ;
RESET ;Reset PSIVOI("DILIST") for additives with quick codes
 N XX,XXX,CNT S CNT=0
 S XX=0 F  S XX=$O(PSIVOI("DILIST",XX)) Q:XX=""  S CNT=CNT+1,LYN(CNT)=PSIVOI("DILIST",XX,0) D
 . S XXX=0 F  S XXX=$O(PSIVOI("DILIST",XX,XXX)) Q:XXX=""  S CNT=CNT+1,LYN(CNT)=$P(PSIVOI("DILIST",XX,0),"^")_"^"_$P(PSIVOI("DILIST",XX,XXX,0),"^",2)_"^"_$P(PSIVOI("DILIST",XX,XXX,0),"^")_"^"_"QC"
 K PSIVOI("DILIST")
 S PSIVOI("DILIST",0)=CNT_"^*^0^"
 S XX=0 F  S XX=$O(LYN(XX)) Q:'XX  S PSIVOI("DILIST",XX,0)=LYN(XX)
 K LYN
 Q
