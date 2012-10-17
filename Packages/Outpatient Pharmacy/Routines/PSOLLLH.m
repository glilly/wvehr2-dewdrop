PSOLLLH ;BIR/EJW - HIPAA/NCPDP LASER LABELS ;7/20/06 10:21am
        ;;7.0;OUTPATIENT PHARMACY;**161,148,244,200,326**;DEC 1997;Build 11
        ;
        ;Reference to DUR1^BPSNCPD3 supported by DBIA 4560
        ;
        ;*244 ignore Rx status > 11
        ;
SIGLOG  N PSOSEQ,J,RXF,RXY,RXN,RX,FIRST,DATE,BLNKLIN,RX2,FDT,BLNKLN2,LAST,CNT
        D DEM^VADPT
        S FIRST=1,LAST=0
        I '$G(REPRINT) D NOWINDOW I NOWIN Q
        K NOWIN
        S $P(BLNKLN2," ",32)=" "
        S $P(BLNKLIN,"_",32)="_"
        F PSOSEQ=1:1:$L(PPL,",") S RX=$P(PPL,",",PSOSEQ) D
        .I RX="" Q
        .Q:$G(^PSRX(RX,"STA"))>11                           ;*244
        .S RXY=$G(^PSRX(RX,0)) I RXY="" Q
        .S CNT=$G(CNT)+1
        .S RX2=$G(^PSRX(RX,2)),FDT=$P(RX2,"^",2)
        .I FIRST!(CNT#4=1) D HDR,BARC S FIRST=0
        .S RXF=+$O(^PSRX(RX,1,"A"),-1)
        .I RXF>0 I +^PSRX(RX,1,RXF,0)'<FDT S FDT=+^(0)
        .S DATE=$E(FDT,1,7),Y=DATE X ^DD("DD") S DATE=Y
        .S RXN=$P(RXY,"^")
        .S T=RXN_" ("_(RXF)_") "
        .N PSODRNM
        .S PSODRNM=$$ZZ^PSOSUTL(RX)
        .S T=T_$E(FDT,4,5)_"/"_$E(FDT,6,7)_"/"_$E(FDT,2,3)_" "_$E(PSODRNM,1,(27-$L(RXN))) D PRINT(T)
        S LAST=1 D SIGN
        I $D(ZTQUEUED) S ZTREQ="@"
        Q
        ;
SIGN    ;
        I '$G(CNT) Q
        N II
        S II=CNT#4
        I LAST,II>0 F J=1:1:(4-II) S T=" " D PRINT(T)
        S PSOY=PSOY+10
        S T="Pt. Sig."_BLNKLIN D PRINT(T)
        S PSOY=PSOY+5
        D PRINT($$PLANNM())
        S PSOY=PSOY+15
        S T="Relation_____ Counseling Refused__ Accepted__" D PRINT(T)
        S PSOY=PSOY+10
        S T=PNM_"  "_$G(SSNP) D PRINT(T,1)
        Q
        ;
HDR     ;
        I 'FIRST D SIGN W @IOF
        I $G(PSOIO("BLH"))]"" X PSOIO("BLH")
        S T="VAMC "_$P(PS,"^",7)_", "_STATE_" "_$G(PSOHZIP) D PRINT(T)
        S T=$P(PS2,"^",2)_"  Ph: "_$P(PS,"^",3)_"-"_$P(PS,"^",4)_"       "_$G(PSONOW) D PRINT(T)
        I $G(PSOIO("BLB"))]"" X PSOIO("BLB")
        S XFONT=$E(PSOFONT,2,99)
        N REPMSG
        S REPMSG=BLNKLN2_"(REPRINT)"
        S T="By signing below"_$S($G(REPRINT):REPMSG,1:"") D PRINT(T,1)
        S T="you acknowledge receipt of the following Rx's" D PRINT(T,1)
        S T=" " D PRINT(T)
        S PSOY=PSOY-20
        Q
        ;
PRINT(T,B)      ;
        S BOLD=$G(B)
        I 'BOLD,$G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
        I BOLD,$G(PSOIO(PSOFONT_"B"))]"" X PSOIO(PSOFONT_"B")
        I $G(PSOIO("ST"))]"" X PSOIO("ST")
        W T,!
        I $G(PSOIO("ET"))]"" X PSOIO("ET")
        I BOLD,$G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT) ;TURN OFF BOLDING
        Q
        ;
QUEUE   ; ENTRY POINT TO REPRINT SIGNATURE LOG
        I '$D(PSOPAR) D ^PSOLSET I '$D(PSOPAR) Q
        N REPRINT,PS,STATE,PS2,PSOHZIP
        S PS=$S($D(^PS(59,PSOSITE,0)):^(0),1:"")
        S PS2=$P(PS,"^")_"^"_$P(PS,"^",6)
        I $P(PSOSYS,"^",4),$D(^PS(59,+$P($G(PSOSYS),"^",4),0)) S PS=^PS(59,$P($G(PSOSYS),"^",4),0)
        S VAADDR1=$P(PS,"^"),VASTREET=$P(PS,"^",2),STATE=$S($D(^DIC(5,+$P(PS,"^",8),0)):$P(^(0),"^",2),1:"UNKNOWN")
        S PSZIP=$P(PS,"^",5),PSOHZIP=$S(PSZIP["-":PSZIP,1:$E(PSZIP,1,5)_$S($E(PSZIP,6,9)]"":"-"_$E(PSZIP,6,9),1:""))
        S REPRINT=1
LRP     W !! S DIC("S")="I $P($G(^(0)),""^"",2),$D(^(""STA"")),$P($G(^(""STA"")),""^"")<10",DIC="^PSRX(",DIC("A")="Reprint Signature Log for Prescription: ",DIC(0)="QEAZ" D ^DIC K P,DIC("A") I Y<0!("^"[X) D KILL Q
        W !
        S (PPL,RX)=+Y
        N RXY
        S RXY=$G(^PSRX(RX,0)) I RXY="" Q
        S DFN=$P(RXY,"^",2)
GETPT2  D DEM^VADPT S PNM=VADM(1)
        I $P(VADM(6),"^",2)]"" D  G LRP
        .W $C(7),!!,PNM_" Died "_$P(VADM(6),"^",2)_".",!
        D 6^VADPT,PID^VADPT6 S SSNP=""
Q1      W ! K POP,ZTSK S %ZIS("B")="",%ZIS="MNQ",%ZIS("A")="Select LABEL DEVICE: " D ^%ZIS S PSLION=ION K %ZIS("A")
        I $G(POP) Q
        I $G(IOST(0)),'$D(^%ZIS(2,IOST(0),55,"B","LL")) W !,"Must specify a laser labels printer for Signature Log Reprint" G Q1
        I '$G(IOST(0)) W !,"Nothing queued to print." H 1 Q
        D NOW^%DTC S Y=$P(%,"."),PSOFNOW=% X ^DD("DD") S PSONOW=Y
        F G="PPL","REPRINT","PNM","STATE","PS2","PSOHZIP","PSOPAR","PSOSITE","PS","PSONOW","PSOSYS","SSNP" S:$D(@G) ZTSAVE(G)=""
        S ZTRTN="DQ^PSOLLLH",ZTIO=PSLION,ZTDESC="Outpatient Pharmacy Signature Log Reprint",ZTDTH=$H,PDUZ=DUZ
        D ^%ZISC,^%ZTLOAD W:$D(ZTSK) !!,"Signature Log Reprint queued",!! H 1 K G
        G QUEUE
        Q
DQ      N PSOBIO S (I,PSOIO)=0 F  S I=$O(^%ZIS(2,IOST(0),55,I)) Q:'I  S X0=$G(^(I,0)) I X0]"" S PSOIO($P(X0,"^"))=^(1),PSOIO=1
        I $G(PSOIO("LLI"))]"" X PSOIO("LLI")
        G SIGLOG
        ;
PLANNM()        ; Returns Insurance Name (3rd Party)
        S PLANNM=""
        N I,DUR,RX
        F I=1:1:$L(PPL,",") S RX=+$P(PPL,",",I) D  I PLANNM'="" Q
        .I 'RX Q
        .D DUR1^BPSNCPD3(RX,$$LSTRFL^PSOBPSU1(RX),.DUR) S PLANNM=$G(DUR(1,"INSURANCE NAME"))
        Q PLANNM
BARC    I '$G(FIRST) G BARCE ; PRINT BARCODE FOR 1 RX ON 1ST SIGLOG LABEL ONLY
        I $G(PSOIO("BLBC"))]"" X PSOIO("BLBC") I $G(NOBARC) G BARCE
        I '$D(PSOINST) D INST
        S X2=PSOINST_"-"_RX W X2
        I $G(PSOIO("EBLBC"))]"" X PSOIO("EBLBC")
BARCE   Q
        ;
KILL    ; CLEAN UP VARIABLES
        K DIC,DFN,PNM,PPL,PSZIP,RX,SSNP,VA,VADDR1,VADM,VAEL,VAPA,VASTREET
        Q
INST    ;
        K ^UTILITY("DIQ1",$J) S DA=$P($$SITE^VASITE(),"^")
        I $G(DA) S DIC=4,DIQ(0)="I",DR="99" D EN^DIQ1 S PSOINST=$G(^UTILITY("DIQ1",$J,4,DA,99,"I"))
        K ^UTILITY("DIQ1",$J),DA,DR,DIC
        Q
        ;
NOWINDOW        ; ON ORIGINAL PRINT - DON'T PRINT IF ALL ARE MAIL
        N I,RX,RXF,MW,RXP,RXY
        S NOWIN=1
        F I=1:1:$L(PPL,",") S RX=$P(PPL,",",I) D  I 'NOWIN Q
        .I RX="" Q
        .I $G(^PSRX(RX,"STA"))>11 Q
        .S RXY=$G(^PSRX(RX,0)) I RXY="" Q
        .I '$D(^PSRX(RX,1)) S MW=$P(RXY,"^",11) I MW="W" S NOWIN=0 Q
        .S RXF=$O(^PSRX(RX,1,99),-1) I RXF>0 S MW=$P($G(^PSRX(RX,1,RXF,0)),"^",2) I MW="W" S NOWIN=0
        .S RXP=$O(^PSRX(RX,"P",99),-1) I RXP>0 S MW=$P($G(^PSRX(RX,"P",RXP,0)),"^",2) I MW="W" S NOWIN=0
        Q
