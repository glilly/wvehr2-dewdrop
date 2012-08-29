PSIVORE ;BIR/PR,MLM-ORDER ENTRY ; 4/1/08 2:37pm
        ;;5.0; INPATIENT MEDICATIONS ;**18,29,50,56,58,81,110,127,133,157,203**;16 DEC 97;Build 13
        ;
        ; Reference to ^PS(55 is supported by DBIA 2191
        ; Reference to ^ORX2 is supported by DBIA #867
        ; Reference to ^PSSLOCK is supported by DBIA #2789
        ; Reference to ^DICN is supported by DBIA 10009.
        ; Reference to ^DIR is supported by DBIA 10026.
        ; Reference to EN^VALM is supported by DBIA 10118.
        ; Reference to ^VADPT is supported by DBIA 10061.
        ;
        N PSJNEW,PSJOUT,PSGPTMP,PPAGE,FLAG S PSJNEW=1
        ;
        D SITE Q:'$G(PSIVQ)  K PSIVQ S PSGOP=""
        ;
BEG     ;Get patient and make sure he is living.
        L +^PS(53.45,DUZ):1 E  D LOCKERR^PSJOE G Q
        ;* F  K WSCHADM S PSGPTMP=0,PPAGE=1 D ENGETP^PSIV Q:DFN<0  D ASK
        ;* F  K WSCHADM S PSGPTMP=0,PPAGE=1 D ENGETP^PSIV Q:DFN<0  S X=DFN_";DPT(" D LK^ORX2 Q:'Y  D ASK S X=DFN_";DPT(" D ULK^ORX2
        NEW PSJLK
        F  K WSCHADM S PSGPTMP=0,PPAGE=1 D ENGETP^PSIV Q:DFN<0  S PSJLK='$$L^PSSLOCK(DFN,1) Q:PSJLK  D ASK,UL^PSSLOCK(DFN)
        I PSGOP,$P(PSJSYSL,"^",2)]"" D ENQL^PSGLW
        G Q
        ;
ASK     ;See if patient has been admitted.
        I VADM(6) W !?5,"Patient has died." Q
        I 'VAIN(4) K DIK S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="NO",DIR("??")="^S HELP=""ADMYN"" D ^PSIVHLP1" W !,"This patient has not been admitted." D ^DIR K DIR Q:'Y
        S:VAIN(4) WSCHADM=+VAIN(4)
        ;
SETN    ;Set up patient 0 node if needed.
        I '$D(^PS(55,DFN,0)) K DO,DA,DD,DIC,PSIVFN S:$D(^(5.1)) PSIVFN=^(5.1) K:$D(PSIVFN) ^(5.1) S (DINUM,X)=DFN,DIC(0)="L",DIC="^PS(55," D FILE^DICN S:$D(PSIVFN) ^PS(55,DFN,5.1)=PSIVFN D  K DIC,PSIVFN,DO,DA,DD,DINUM
        .; Mark PSJ and PSO as converted
        .S $P(^PS(55,DFN,5.1),"^",11)=2
        S PSJNARC=1
        S PSGP=DFN,PSJPWD=+VAIN(4),PSIVAC="P",PSIVBR="D ^PSIVOPT" D HK,ENCHS1^PSIV Q:'$D(DFN)
        Q
        ;
NEW     ;Ask to enter new order.
        D:'$D(VADM(1)) DEM^VADPT
        K P,PSIVCHG,PSIVTYPE,PSJOE,DIR S DIR(0)="Y",DIR("A")="New order for "_VADM(1),DIR("B")="YES",DIR("??")="^S HELP=""NEWORD"" D ^PSIVHLP" D ^DIR K DIR Q:'Y
        NEW X S X=DFN_";DPT(" D LK^ORX2 Q:'Y  S PSJLSORX=1
INMED   K ON55,PSJOUT S (P(4),P("OT"),P("FRES"))="" D NEW55^PSIVORFB I '$D(ON55) D ULK G:'$D(PSJOE)&('$D(PSJOUT)) NEW G Q
        S P("RES")="N",PSIVAC="PN",P("PON")=ON55,PSIVUP=+$$GTPCI^PSIVUTL D NEW^PSIVORE2 I $G(P(2))="" D DEL55^PSIVORE2 D ULK G:'$D(PSJOE) NEW Q
        D OK L -^PS(55,DFN,"IV",+ON55) D ULK G:'$D(PSJOE) NEW
        ;
Q       ; Kill and exit.
        L:'$D(PSJOE) -^PS(53.45,DUZ) S PSJNKF=1 D Q^PSIV
        K FIL,I1,ND,PC,PDM,PSGDT,PSGID,PSGLMT,PSGSI,PSJNARC,PSIVAC,PSIVCHG,PSIVUP,PSIVX,PSJOPC
        Q
        ;
ULK     ;
        Q:'$G(PSJLSORX)  ;If NEW^PSIVORE did not lock, don't kill it here.
        NEW X S X=DFN_";DPT(" D ULK^ORX2 K PSJLSORX
        Q
HK      ;Queue job to print MAR labels generated for this patient.
        I PSGOP,PSGOP'=DFN D
        .N PSJACPF,PSJACNWP,PSJPWD,PSJSYSL,PSJSYSW,PSJSYSW0,DFN,VAIN,VAERR S DFN=PSGOP
        .D INP^VADPT S PSJPWD=+VAIN(4) I PSJPWD S PSJACPF=10 S PSJACPF=10 D WP^PSJAC D:$P(PSJSYSL,U,2)]"" ENQL^PSGLW
        S PSGOP=DFN
        Q
        ;
SITE    ;See if site parameters are ok.
        K PSIVQ D ^PSIVXU Q:$D(XQUIT)
        I '$D(PSIVSN)!('$D(PSIVSITE)) W $C(7),$C(7),!!,"You have no IV ROOM parameters ... PLEASE ... PLEASE ...",!,"Exit this package and reenter properly !!",!! Q
        D ORPARM^PSIVOREN S PSIVQ=1
        Q
        ;
OK      ;Print example label, run order through checker, ask if it is ok.
        S P16=0,PSIVEXAM=1,(PSIVNOL,PSIVCT)=1 D GTOT^PSIVUTL(P(4)) I $G(P("PD"))="" D GTPD^PSIVORE2
        D ^PSIVCHK I $D(DUOUT) S X="^" G DOA
        I ERR=1 S X="N" G BAD
        W ! D ^PSIVORLB K PSIVEXAM S Y=P(2) W !,"Start date: " X ^DD("DD") W $P(Y,"@")," ",$P(Y,"@",2),?30," Stop date: " S Y=P(3) X ^DD("DD") W $P(Y,"@")," ",$P(Y,"@",2),!
        ;PSJ*5*157 EFD for IVs
        D EFDIV^PSJUTL($G(ZZND))
        W:$G(PSIVCHG) !,"*** This change will cause a new order to be created. ***"
        I '$G(PSIVCOPY) G:PSIVAC["R" OK1 S X="Is this O.K.: ^"_$S(ERR:"NO",1:"YES")_"^^NO"_$S(ERR'=1:",YES",1:"") D ENQ^PSIV
        S PSJIVBD=1 ;var use to indicate order enter from back door
BAD     ;; I X["N" D GSTRING^PSIVORE1,^PSIVORV2,GTFLDS^PSIVORFE G OK
        I ON55["V",($G(P(21))="") S P(17)="N"
        I X["N" NEW PSGEBN,PSGLI S (P("INS"),PSGEBN,PSGLI)="",(PSJORD,ON)=ON55 D EN^VALM("PSJ LM IV AC/EDIT") S VALMBCK="Q" Q
        I X["?" S HELP="OK" D ^PSIVHLP G OK
DOA     I X["^" D DEL55^PSIVORE2 Q
        Q:$$NONVF("SN")
OK1     S PSJORL=$$ENORL^PSJUTL($G(VAIN(4))),P(17)="A",ORSTS=6,ON=ON55,PSJORNP=+P(6)
        D:'$D(PSJIVORF) ORPARM^PSIVOREN
        I PSJIVORF D NATURE^PSIVOREN I '$D(P("NAT")) D DEL55^PSIVORE2 Q
        D SET55^PSIVORFB
        I PSJIVORF,($G(P(22))=.5) D CLINIC^PSIVOREN
        I PSJIVORF D SET^PSIVORFE S ORNATR=P("NAT"),ON=+ON55,OD=P(2) D EN1^PSJHL2(DFN,"SN",+ON55_"V","SEND ORDER NUMBER") ;,EN1^PSJHL2(DFN,"SC",+ON55_"V","NEW ORDER CREATED")
        D VF1^PSJLIACT("V","ORDER ENTERED AS ACTIVE BY ",1)
        D ENLBL^PSIVOPT(2,DUZ,DFN,3,+ON55,"N")
        ;
CAL     ;Calculate doses.
        ;S OD=P(2) D EN,^PSIVORE1,^PSIVOPT
        S OD=P(2) D EN,^PSIVOPT
        Q
        ;
EN      ;Update schedule interval P(15) only on continuous orders.
        ;This includes Hyp/Adm/Continuous Syringes/Chemos =>P(5)=0
        Q:'$D(DFN)!('$D(ON55))  Q:$P(^PS(55,DFN,"IV",+ON55,0),U,4)="P"!($P(^(0),U,5))!($P(^(0),U,23)="P")
        D SPSOL S XXX=$P(^PS(55,DFN,"IV",+ON55,0),U,8) G:'SPSOL ENQ I XXX?1N.N.1".".N1" ml/hr" S P(15)=$S('XXX:0,1:SPSOL\XXX*60+(SPSOL#XXX/XXX*60+.5)\1),$P(^PS(55,DFN,"IV",+ON55,0),U,15)=P(15) G ENQ
        S P(15)=$S('$P(XXX,"@",2):0,1:1440/$P(XXX,"@",2)\1),$P(^PS(55,DFN,"IV",+ON55,0),U,15)=P(15)
ENQ     K SPSOL,XXX Q
SPSOL   S SPSOL=0 F XXX=0:0 S XXX=$O(^PS(55,DFN,"IV",+ON55,"SOL",XXX)) Q:'XXX  S SPSOL=SPSOL+$P(^(XXX,0),U,2)
        K XXX Q
ENIN    ;Entry for Combined IV/UD order entry. Called by PSJOE0.
        D HOLDHDR^PSJOE
        W !
        N PSJOUT S (DONE,FLAG)=0,PSIVAC="PN"
ENIN1   ;
        N DA,DIR,PSJOE,PSJPCAF,PSJSYSL,WSCHADM S:$G(VAIN(4)) WSCHADM=VAIN(4)
        K P,PSIVCHG,PSJCOM
        S PSJOE=1,DIR(0)="55.01,.04O",DIR("A")="Select IV TYPE" D ^DIR
        I X]"",X'="^",$P("^PROFILE",X)="" S PSJOEPF=X Q
        S:$D(DTOUT) X="^" I "^"[X S PSJORQF=PSJORQF+$S(X="^":2,$G(FLAG):0,1:1),X="." Q
        S FLAG=1,PSIVTYPE=Y,(P(5),P(23))="" I "SC"[Y D @(Y_"^PSIVORC1") S $P(PSIVTYPE,U,2)=P(23)
        D INMED G:'$D(PSJOUT) ENIN S:$D(PSJOUT) PSJORQF=2
        Q
NONVF(PSJOC)     ;If file at NonVF then quit with 1
        NEW PSGOEAV S PSGOEAV=+$P(PSJSYSP0,U,9)
        I +PSJSYSU=3,PSGOEAV Q 0
        I +PSJSYSU=1,PSGOEAV Q 0
        K DA D ENGNN^PSGOETO S ON=DA_"P",P(17)="N",P("REN")=0
        D GTPD^PSIVORE2
        D NATURE^PSIVOREN I '$D(P("NAT")) D:ON55["V" DEL55 Q 1
        D:$G(VAIN(4))="" CLINIC^PSIVOREN
        W !,"...transcribing this non-verified order...."
        D PUT531^PSIVORFA
        D:$G(PSJOC)]"" EN1^PSJHL2(DFN,PSJOC,ON,"SEND ORDER NUMBER")
        D:ON55["V" DEL55
        NEW PSJORD S (ON55,PSJORD)=ON
        D VF^PSIVORC2
        Q 1
DEL55   ;
        Q:ON55["P"
        S X=$G(^PS(55,DFN,"IV",+ON55,0))
        I $P(X,U,21)]"",($G(^PS(55,DFN,"IV",+ON55,2))]"") S $P(^(2),U,6)=ON,$P(^PS(53.1,+ON,0),U,25)=ON55 Q
        NEW PSIVORFA S PSIVORFA=1
        D DEL55^PSIVORE2
        Q 
