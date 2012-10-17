PSOLLLHN        ;BIR/SJA - HIPAA/NCPDP LASER LABELS ;2/21/07 10:21am
        ;;7.0;OUTPATIENT PHARMACY;**200,268,326**;DEC 1997;Build 11
        ;
        ;*244 ignore Rx status > 11
        ;
ST      ; ENTRY POINT TO SPEED SIGNATURE LOG REPRINT
        I '$D(PSOPAR) D ^PSOLSET I '$D(PSOPAR) Q
        N REPRINT,PS,STATE,PS2,PSOHZIP,PSODISP,PSOOELSE,PSOIEN,VALMCNT
        S PS=$S($D(^PS(59,PSOSITE,0)):^(0),1:"")
        S PS2=$P(PS,"^")_"^"_$P(PS,"^",6)
        I $P(PSOSYS,"^",4),$D(^PS(59,+$P($G(PSOSYS),"^",4),0)) S PS=^PS(59,$P($G(PSOSYS),"^",4),0)
        S VAADDR1=$P(PS,"^"),VASTREET=$P(PS,"^",2),STATE=$S($D(^DIC(5,+$P(PS,"^",8),0)):$P(^(0),"^",2),1:"UNKNOWN")
        S PSZIP=$P(PS,"^",5),PSOHZIP=$S(PSZIP["-":PSZIP,1:$E(PSZIP,1,5)_$S($E(PSZIP,6,9)]"":"-"_$E(PSZIP,6,9),1:""))
        D 6^VADPT,PID^VADPT6 S SSNP=""
        S REPRINT=1
        I '$G(PSOCNT) S VALMSG="This patient has no Prescriptions!" S VALMBCK="" Q
OS      K DIR,DUOUT,DIRUT S DIR("A")="Select Orders by number",DIR(0)="LO^1:"_PSOCNT D ^DIR S LST=Y I $D(DTOUT)!($D(DUOUT)) K DIR,DIRUT,DTOUT,DUOUT S VALMBCK="" Q
        K DIR,DIRUT,DTOUT,PSOOELSE,PSOREPX I '+LST D KILL S VALMBCK="" Q
        S PSOOELSE=1 D FULL^VALM1
Q1      K POP,ZTSK S %ZIS("B")="",%ZIS="MNQ",%ZIS("A")="Select LABEL DEVICE: " D ^%ZIS S PSLION=ION K %ZIS("A")
        I $G(POP) S VALMBCK="R",VALMSG="No Labels Reprinted." Q
        I $G(IOST(0)),'$D(^%ZIS(2,IOST(0),55,"B","LL")) W !,"Must specify a laser labels printer for Signature Log Reprint" G Q1
        I '$G(IOST(0)) S VALMBCK="R",VALMSG="Nothing queued to print." Q
        D DEM^VADPT S PNM=VADM(1)
        I $P(VADM(6),"^",2)]"" D  G OS
        .W $C(7),!!,PNM_" Died "_$P(VADM(6),"^",2)_".",!
        S PPL="" F ORD=1:1:$L(LST,",") Q:$P(LST,",",ORD)']""  S ORN=$P(LST,",",ORD),PSOIEN=$P(PSOLST(ORN),"^",2) D
        .I '$P($G(^PSRX(PSOIEN,0)),"^",2)!($G(^("STA"),"^")>11) Q
        .I $P($G(^PSRX(PSOIEN,0)),"^",2) S PPL=$S(PPL:PPL_",",1:"")_PSOIEN
        .S VALMBCK="R"
        I +PPL D QUEUE W:$D(ZTSK) !!,"Signature Log Reprint queued",!! H 1
        I '$G(PSOOELSE) S VALMBCK=""
        D ^PSOBUILD
        D KILL D KVA^VADPT
        Q
QUEUE   D NOW^%DTC S Y=$P(%,"."),PSOFNOW=% X ^DD("DD") S PSONOW=Y
        F G="PPL","REPRINT","PNM","STATE","PS2","PSOHZIP","PSOPAR","PSOSITE","PS","PSONOW","PSOSYS","RX","SSNP" S:$D(@G) ZTSAVE(G)=""
        S ZTRTN="DQ^PSOLLLH",ZTIO=PSLION,ZTDESC="Outpatient Pharmacy Signature Log Reprint",ZTDTH=$H,PDUZ=DUZ
        D ^%ZISC,^%ZTLOAD K G
        Q
        ;
KILL    ; CLEAN UP VARIABLES
        K DIC,LST,ORD,ORN,PSOIEN,PNM,PPL,PSZIP,RX,SSNP,VA,VADDR1,VADM,VAEL,VAPA,VASTREET
        Q
