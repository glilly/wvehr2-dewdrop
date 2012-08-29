PSJLIFN ;BIR/MV-IV FINISH USING LM ;13 Jan 98 / 11:32 AM
 ;;5.0; INPATIENT MEDICATIONS ;**1,29,34,37,42,47,50,56,94,80,116,110**;16 DEC 97
 ;
 ; Reference to ^PS(51.2 is supported by DBIA #2178.
 ; Reference to ^PS(52.6 supported by DBIA #1231.
 ; Reference to ^PS(52.7 supported by DBIA #2173.
 ; Reference to ^PSDRUG( is supported by DBIA #2192.
 ; Reference to ^PSOORDRG is supported by DBIA #2190.
 ; Reference to ^%DT is supported by DBIA #10003.
 ; Reference to ^VALM is supported by DBIA #10118.
 ; Reference to ^VALM1 is supported by DBIA #10116.
 ; Reference to RE^VALM4 is supported by DBIA #10120.
 ;
EN ; Display order with numbers.
 L +^PS(53.1,+PSJORD):1 I '$T W !,$C(7),$C(7),"This order is being edited by another user. Try later." D PAUSE^VALM1 Q
 D PENDING K PSJREN
 L -^PS(53.1,+PSJORD)
 Q
PENDING ; Process pending order.
 ;* PSIVFN1 is use so it will dipslay the AC/Edit screen
 ;* instead of go to the "IS this O.K." prompt
 ;* PSIVACEP only when accept the order. Original screen won't redisp.
 ;* PSJLMX is defined in WRTDRG^PSIVUTL and it was being call in PSJLIVMD & PSJLIVFD
 ;*        to count # of AD/SOL 
 NEW PSIVFN1,PSIVACEP,PSJLMX,PSIVOI
 S PSIVAC="CF" S (P("PON"),ON)=+PSJORD_"P",DFN=PSGP
 S PSIVUP=+$$GTPCI^PSIVUTL D GT531^PSIVORFA(DFN,ON)
 D:'$D(P("OT")) GTOT^PSIVUTL(P(4))
 NEW PSJL
 N PSIVNUM,PSJSTAR S PSIVNUM=1
 Q:ON'=PSJORD
 I $G(PSJLYN)]"" Q:ON'=PSJLYN
 S PSJMAI=ON
 I P("OT")="I" D  Q
 . S PSJSTAR="(5)^(7)^(9)^(10)"
 . D EN^VALM("PSJ LM IV INPT PENDING") ;; ^PSJLIVMD
 S PSJSTAR="(1)^(2)^(3)^(5)^(7)^(9)"
 D GTDATA D EN^VALM("PSJ LM IV PENDING") ;; ^PSJLIVFD
 K PSJMAI Q
 ;
DISPLAY ;
 S PSGACT=""
 S VALMSG="Press Return to continue"
 D:$E(P("OT"))="I" EN^VALM("PSJ LM IV INPT DISPLAY")
 D:$E(P("OT"))'="I" EN^VALM("PSJ LM IV DISPLAY")
 K PSJDISP
 S:'$G(PSJHIS) VALMBCK=""
 Q
GTDATA ;
 ;* D:P(4)="" 53^PSIVORC1 Q:P(4)=""  S P("DTYP")=$S(P(4)="":0,P(4)="P"!(P(23)="P")!(P(5)):1,P(4)="H":2,1:3)
 S P("DTYP")=$S(P(4)="":0,P(4)="P"!(P(23)="P")!(P(5)):1,P(4)="H":2,1:3)
 I 'P(2) D
 .I P("RES")="R" S PSJREN=1
 .D ENT^PSIVCAL K %DT S X=P(2),%DT="RTX" D ^%DT S P(2)=+Y
 I 'P(3) D ENSTOP^PSIVCAL K %DT S X=P(3),%DT="RTX" D ^%DT S P(3)=+Y
 I 'P("MR") S P("MR")=$O(^PS(51.2,"B","INTRAVENOUS",0))_"^IV"
 Q
FINISH ; Prompt for missing data
 ;* Ord chk for Inpat. pending only. Pend renew should not be checked.
 ;* PSIVOCON needed so this order will be excluded from the order
 ;*          list(ORDCHK^PSJLMUT1)
 ;* PSGORQF defined means cancel the order due to order check.
 ;Q:'$$LS^PSSLOCK(DFN,PSJORD)
 N PSJCOM S PSJCOM=+$P($G(^PS(53.1,+PSJORD,.2)),"^",8)
 K PSJIVBD,PSGRDTX
 N FIL,PSIVS,DRGOC,PSIVXD,DRGTMP,PSIVOCON,PSGORQF,ON55,NSFF S NSFF=1
 S (ON,PSIVOCON,ON55,PSGORD)=PSJORD Q:PSJORD'=PSJMAI  I $G(PSJLYN)]"" Q:PSJORD'=PSJLYN
 D UDVARS^PSJLIORD
 I $G(PSJPROT)=3,'$$ENIVUD^PSGOEF1(PSJORD) K NSFF Q
 D HOLDHDR^PSJOE
 ; force the display of the second screen if CPRS order checks exist
 I $O(^PS(53.1,+PSJORD,12,0))!$O(^PS(53.1,+PSJORD,10,0)) D
 .Q:$G(PSJLMX)=1   ;no second screen to display
 .S VALMBG=16 D RE^VALM4,PAUSE^VALM1 S VALMBG=1
 S P("OPI")=$$ENPC^PSJUTL("V",+PSIVUP,60,P("OPI"))
 ;I $E(P("OT"))="I" D GTDATA Q:P(4)=""
 ;I $E(P("OT"))="I",'$D(DRG("AD")),('$D(DRG("SOL"))) D
 I $G(P("RES"))'="R" D 53^PSIVORC1
 I $G(P(4))]"",$G(P(15))]"",$G(P(9))]"",$$SCHREQ^PSJLIVFD(.P) D
 . N PSGS0XT,X,PSJNSS S PSJNSS=1,X=P(9),PSGS0XT=P(15) D Q2^PSGS0
 I P(4)="" D RE^VALM4 Q
 I $E(P("OT"))="I" D GTDATA  D
 . I '$D(DRG("AD")),('$D(DRG("SOL"))) S DNE=0 D GTIVDRG^PSIVORC2 S P(3)="" D ENSTOP^PSIVCAL
 . D ORDCHK
 S VALMBG=1
 I $E(P("OT"))="F" S DNE=0 D ORDCHK I $G(PSGORQF) D RE^VALM4 Q
 I $D(PSGORQF) S VALMBCK="R",P(4)="" K DRG Q
 S PSIVOK="1^3^10^25^26^39^57^58^59^63^64" D CKFLDS^PSIVORC1 D:EDIT]"" EDIT^PSIVEDT
 I $G(DONE) S VALMBCK="R" Q
 D COMPLTE^PSIVORC1
 S:$G(PSIVACEP) VALMBCK="Q"
 I $G(PSGORQF) S VALMBG=1 D RE^VALM4
 K NSFF
 Q
ORDCHK ;* Do order check for Inpatient Meds IV.
 ; PSGORQF is defined (CONT^PSGSICHK) if not log an intervention
 K PSGORQF
 NEW DRGOC
 D OCORD Q:$G(PSGORQF) 
 ;D GTIVDRG^PSIVORC2 S P(3)="" D ENSTOP^PSIVCAL
ORDCHKA ;* Do order check agaist existing orders on the profile
 F PSIVAS="AD","SOL" Q:$G(PSGORQF)  S FIL=$S(PSIVAS="AD":52.6,1:52.7) D
 . F PSIVX=0:0 S PSIVX=$O(DRG(PSIVAS,PSIVX)) Q:'PSIVX!($G(PSGORQF))  D
 .. S DRGTMP=DRG(PSIVAS,PSIVX)
 .. ;* Do only 1 duplicate warning when order has >1 of the same additive
 .. Q:$D(PSJADTMP(+DRGTMP))
 .. D ORDERCHK^PSIVEDRG(PSGP,ON,$D(DRGOC(ON)))
 .. S DRGOC(ON,PSIVAS,PSIVX)=DRG(PSIVAS,PSIVX)
 .. S PSJADTMP(+DRGTMP)=""
 K PSJADTMP
 Q
OCORD ;* Do order check for each drug against the drugs within the order.
 NEW X,Y,DDRUG,PSIVX,PSJAD,PSJSOL,TMPDRG
 D SAVEDRG^PSIVEDRG(.TMPDRG,.DRG)
 ; Find the corresponding DD for the additive within the order
 F X=0:0 S X=$O(DRG("AD",X)) Q:'X  D
 . S DDRUG=$P($G(^PS(52.6,+DRG("AD",X),0)),U,2)
 . S:+DDRUG (DDRUG(DDRUG),PSJAD(DDRUG))=$D(DDRUG(DDRUG))+1
 ;
 ; Find the corresponding DD for the solution
 ;
 F X=0:0 S X=$O(DRG("SOL",X)) Q:'X  D
 . S DDRUG=$P($G(^PS(52.7,+DRG("SOL",X),0)),U,2)
 . S:+DDRUG (DDRUG(DDRUG),PSJSOL(DDRUG))=$D(DDRUG(DDRUG))+1
 ;
 ; Loop thru each additive to check for DD,DI & DC against the
 ; order's dispense drugs
 ;
 NEW PSJDFN,INTERVEN S INTERVEN=""
 S PSJDFN=DFN ;DFN will be killed when call ^PSOORDRG
 F PSIVX=0:0 S PSIVX=$O(PSJAD(PSIVX)) Q:'PSIVX  D
 . K DDRUG(PSIVX) D DRGCHK^PSOORDRG(PSJDFN,PSIVX,.DDRUG)
 . I PSJAD(PSIVX)>1 S ^TMP($J,"DD",1,0)=PSIVX_U_$P($G(^PSDRUG(PSIVX,0)),U)_"^^"_ON_";I"
 . NEW TYPE F TYPE="DD","DI","DC" D ORDCHK^PSJLIFNI(PSJDFN,TYPE)
 F PSIVX=0:0 S PSIVX=$O(PSJSOL(PSIVX)) Q:'PSIVX  D
 . K DDRUG(PSIVX) D DRGCHK^PSOORDRG(PSJDFN,PSIVX,.DDRUG)
 . NEW TYPE F TYPE="DI" D ORDCHK^PSJLIFNI(PSJDFN,TYPE)
 S DFN=PSJDFN
 D SAVEDRG^PSIVEDRG(.DRG,.TMPDRG)
 Q
