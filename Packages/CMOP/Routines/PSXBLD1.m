PSXBLD1 ;BIR/BAB,HTW,WPB-Document Data for Transmission ;10/15/98  10:38 AM
        ;;2.0;CMOP;**3,18,19,42,41,49,57,64**;11 Apr 97;Build 1
        ;Reference to  ^PSRX(     supported by DBIA #1977
        ;Reference to  ^PSDRUG(   supported by DBIA #1983
        ;Reference to  ^PS(55,    supported by DBIA #2228
        ;Reference to  ^PS(59.7,  supported by DBIA #694
        ;Reference to  ^PS(59,    supported by DBIA #1976
        ;Reference to PROD2^PSNAPIS supported by DBIA #2531
MRX     ;Multi rx
        G:'$P(PSOPAR,"^",18) SUS
        F ZZ=0:0 S ZZ=$O(^PS(55,DFN,"P",ZZ)) Q:'ZZ  S NBR=0 D RZX
BUILD   ;
        F PSA=0:0 S PSA=$O(RX(PSA)) Q:'PSA  D SCRNEW
        K NAME,REFILL,PSDT2,NBR,PSRX,PSA,TN,AMC,PSRFL,X1,X2,PSRXX,RXNUM,ZZ
        G SUS
SCRNEW  ;
        S IEN50=+$P(^PSRX(PSA,0),U,6),NAME=$P(^PSDRUG(IEN50,0),U)
        I '$D(^PSDRUG(IEN50,"ND")) G S1
        S IENDF=$P($G(^PSDRUG(IEN50,"ND")),U),ZD1=$P($G(^("ND")),U,3)
        I $G(IENDF),($G(ZD1)) S ZX=$$PROD2^PSNAPIS(IENDF,ZD1),ZNDF=$P($G(ZX),"^")
S1      S ZPRT=$S($G(ZNDF):ZNDF,1:NAME) K ZNDF,IENDF,NAME,IEN50,ZD1
        S ZPRT=$E(ZPRT,1,30)
        S REFILL=$P(RX(PSA),"^",2)
        S PSDT2=$P(RX(PSA),"^",1),PSDT2=PSDT2+17000000
        S RXNUM=$P($G(^PSRX(PSA,0)),"^")
        S NBR=NBR+1,PSXORD("M",NBR)="NTE|5||"_RXNUM_"\F\"_ZPRT_"\F\"_REFILL_"\F\"_PSDT2_$S($P(PSOPAR,"^",19):"\F\"_PSOINST_"-"_PSA,1:"")
        Q
REFILL  F AMC=0:0 S AMC=$O(^PSRX(PSRXX,1,AMC)) Q:'AMC  S PSRFL=PSRFL-1
        I PSRFL>0 S X1=DT,X2=$P(^PSRX(PSRXX,0),"^",8)-10 D C^%DTC I X'<$P(^(2),"^",6) S PSRFL=0
        Q
RZX     S PSRXX=+^PS(55,DFN,"P",ZZ,0) I $D(^PSRX(PSRXX,0)) S PSRFL=$P(^(0),"^",9) D:$D(^(1))&PSRFL REFILL I PSRFL>0,$P(^PSRX(PSRXX,"STA"),"^",1)<10,13456'[$E($P(^("STA"),"^",1)),$P(^(2),"^",6)>DT S RX(PSRXX)=$P(^(2),"^",6)_"^"_PSRFL
        Q
SUS     ;Susp Notif-(PSXDTRG-last date transmitted)
        Q:'$G(DFN)!('$G(PSXDTRG))
        S CT=1
        F I=PSXDTRG:0 S I=$O(^PS(55,DFN,"P","A",I)) Q:'I  D
        .F J=0:0 S J=$O(^PS(55,DFN,"P","A",I,J)) Q:'J  S JJ=J D:$D(JJ)  S CT=CT+1
        ..S NODE=$G(^PSRX(JJ,0)) Q:NODE']""
        ..S STATUS=+$P(^PSRX(JJ,"STA"),"^",1) Q:STATUS'=5!(STATUS>10)
        ..Q:$D(^PSX(550.2,PSXBAT,15,"B",JJ))    ;built in PSXRPPL  PSX*2*42
        ..S ERX=$P(NODE,U)
        ..S IEN50=$P(NODE,"^",6),NAME=$P(^PSDRUG(IEN50,0),U)
        ..I '$D(^PSDRUG(IEN50,"ND")) G S2
        ..S IENDF=$P($G(^PSDRUG(IEN50,"ND")),U),ZD1=$P($G(^("ND")),U,3)
        ..I $G(IENDF),($G(ZD1)) S ZX=$$PROD2^PSNAPIS(IENDF,ZD1),ZNDF=$P($G(ZX),"^")
S2      ..S ZPRT=$S($G(ZNDF):ZNDF,1:NAME)
        ..S ZPRT=$E(ZPRT,1,30)
        ..S PSXORD("E",CT)="NTE|6||"_ERX_"\F\"_ZPRT
        ..K NODE,STATUS,ERX,IEN50,IENDF,ZD1,ZNDF,ZPRT,NAME,ZX
        K I,J,NODE,STATUS,JJ,ZPRT,NAME,IENDF,IEN50,CT,RX
        Q
DIV     ;NTE|1||Site #\S\Div Name\S\Facility #\F\Street Add 1\S\Street Add 2\S\City\S\State Abbrev\S\Zip Code\F\Area Code & Phone #
        S PSXERFLG=0,PSXER=3
        S TNODE=$G(^PS(59,PSOSITE,0))
        ;Set site address to refill div if selected in system parameters
        I $P($G(^PS(59.7,1,40.1)),"^",4) S REFDIV=$P(^(40.1),"^",4) D
        .S TNODE1=$G(^PS(59,REFDIV,0)),TNODE=TNODE1 K TNODE1
        S PSXFAC=$P($G(PSXSYS),U,2)
        S STATE=$P(TNODE,"^",8),SITE=$P(TNODE,U,6) S (TEMP,Y)=TNODE
        S:STATE="" PSXER=PSXER_"^"_1,PSXERFLG=1
        S:SITE="" PSXER=PSXER_"^"_2,PSXERFLG=1
        S:$P(TNODE,U,1)="" PSXER=PSXER_"^"_3,PSXERFLG=1
        S:$P(TNODE,U,2)="" PSXER=PSXER_"^"_4,PSXERFLG=1
        S:$P(TNODE,U,7)="" PSXER=PSXER_"^"_5,PSXERFLG=1
        S:$P(TNODE,U,5)="" PSXER=PSXER_"^"_6,PSXERFLG=1
        S:$P(TNODE,U,3)="" PSXER=PSXER_"^"_7,PSXERFLG=1
        S:$P(TNODE,U,4)="" PSXER=PSXER_"^"_8,PSXERFLG=1
        ;VMP OIFO BAY PINES;ELR;PSX*2*57  SET PSXERFLG=0 NEXT LINE AND LINE AFTER THAT
        I PSXERFLG=1 D ER1^PSXERR S PSXERFLG=0,PSXDIVER=1 Q
        Q:$G(PSXPRECK)=1
        S SZIP=$P(TNODE,U,5) I $L(SZIP)>5 S SZIP=$E(SZIP,1,5)_"-"_$E(SZIP,6,9)
        S PSXORD("A")="NTE|1||"_SITE_"\S\"_$P(TNODE,U,1)_"\S\"_PSXFAC_"\F\"_$P(TNODE,U,2)_"\S\\S\"_$P(TNODE,U,7)_"\S\"_$P(^DIC(5,STATE,0),U,2)_"\S\"_SZIP_"\F\"_"("_$P(TNODE,U,3)_") "_$P(TNODE,U,4)
        K SZIP
ORD     ;
        S DIWL=1,DIWR=45,DIWF="C45"
        F NODE=6,7,4 K ^UTILITY($J,"W") S (RECL,REC)=0 F  S REC=$O(^PS(59,PSOSITE,NODE,REC)) Q:REC'>0  S X=^(REC,0),NODE=NODE D
        . I REC'>7 S Y=X D STRIP^PSXBLD S X=Y D ^DIWP,SET I 1
        . E  S WARN(NODE)=REC
        D:$D(WARN) WARN
        K DIWF,DIWL,DIWR,I,NODE,STATE,SITE,TNODE,NUM,REC,Y,Y,X,Z,^UTILITY($J,"W")
        Q
WARN    ;send msg
        S XMSUB=">>WARNING<< CMOP Pharmacy Site Prescription Instructions"
        ;N TXT,XT
        S XT(6)="NARRATIVE REFILLABLE RX"
        S XT(7)="NARRATIVE NON REFILLABLE RX"
        S XT(4)="NARRATIVE FOR COPAY DOCUMENT"
        S TXT(1)="The following Pharmacy Site instruction(s) exceed seven lines."
        S TXT(2)="This exceeds CMOP limits."
        S TXT(3)="Lines beyond seven are not being sent to the CMOP."
        S TXT(4)=" ",TXT(5)="Pharmacy Site: "_$$GET1^DIQ(59,PSOSITE,.01),L=5
        F NODE=6,7,4 I $DATA(WARN(NODE)) S L=L+1,TXT(L)=XT(NODE)_"     "_WARN(NODE)_" lines"
        S XMTEXT="TXT("
        D GRP1^PSXNOTE
        S XMY(DUZ)=""
        D ^XMD
        Q
SET     ;
        K PSXORDD S NUM=0
        F  S NUM=$O(^UTILITY($J,"W",1,NUM)) Q:NUM'>0  S PSXORDD(NUM)=$G(^UTILITY($J,"W",1,NUM,0)) S PSXORDD(NUM)=$S(NODE=4:"NTE|4||"_PSXORDD(NUM),NODE=6:"NTE|2||"_PSXORDD(NUM),NODE=7:"NTE|3||"_PSXORDD(NUM),1:0)
        ;F CNT=1:2 S CNT=$O(PSXORDD(CNT)) Q:CNT=""  S XX=$L(PSXORDD(CNT)),PSXORDD(CNT-1)=PSXORDD(CNT-1)_"\R\"_$E(PSXORDD(CNT),8,XX) K PSXORDD(CNT)
        S %X="PSXORDD(",%Y=$S(NODE=4:"PSXORD(""D"",",NODE=6:"PSXORD(""B"",",NODE=7:"PSXORD(""C"",",1:0) D %XY^%RCR K %X,%Y,TEMP
        Q
