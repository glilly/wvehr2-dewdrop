PSOLLL5 ;BIR/RJS - LASER LABEL CONTINUED ;11/14/05 10:09am
        ;;7.0;OUTPATIENT PHARMACY;**120,161,230,200,326**;DEC 1997;Build 11
        ;
START   ;
        N TEXT,BLNKLIN
        S $P(BLNKLIN,"_",90)="_"
        D MAIL^PSOLLL7
        I $G(PSOIO("ACI"))]"" X PSOIO("ACI")
        S TEXT="HAS YOUR ADDRESS CHANGED?" D STRT^PSOLLU1("SEC2",TEXT,.L)
        S OPSOX=PSOX,PSOX=4.2-L($E(PSOHFONT,2,99))*300/2+OPSOX
        S OFONT=PSOFONT,PSOFONT=$G(PSOHFONT,OFONT) D PRINT(TEXT,1) S PSOX=OPSOX,PSOY=PSOY+10,PSOFONT=OFONT
        S TEXT="Write address changes in the blanks, sign the form, and return to" D PRINT(TEXT,0)
        S TEXT="your pharmacy." D PRINT(TEXT,0)
        S X=$S($D(^DPT(DFN,0))#2:^(0),1:""),PNM=$P(X,"^")
        D PID^VADPT6,ADD^VADPT S SSNP=""
        S PSOY=PSOY+PSOYI,TEXT=PNM_"  "_SSNP D PRINT(TEXT,0)
        I $G(VAPA(1))="" G ALLERGY
        F I=1:1:3 I $G(VAPA(I))]"" S TEXT=$G(VAPA(I))_$E(BLNKLIN,1,80-$L(VAPA(I))) D PRINT(TEXT,0)
        S A=+$G(VAPA(5)) I A S A=$S($D(^DIC(5,A,0)):$P(^(0),"^",2),1:"UNKNOWN")
        S B=$G(VAPA(4))_", "_A_"  "_$S($G(VAPA(11)):$P(VAPA(11),"^",2),1:$G(VAPA(6)))
        S TEXT=B_$E(BLNKLIN,1,80-$L(B)) D PRINT(TEXT,0)
        S B=VAPA(8)
        S TEXT=B_$E(BLNKLIN,1,80-$L(B)) D PRINT(TEXT,0)
        S:$G(VAPA(3))="" PSOY=PSOY+PSOYI
        S TEXT="[   ] Permanent                     [   ] Temporary until ____/____/____" D PRINT(TEXT,0)
        S PSOY=$G(PSOFY),TEXT="Signature "_$E(BLNKLIN,1,45) D PRINT(TEXT,0)
        ;
ALLERGY ;ALLERGIES & REACTIONS
        K ^TMP($J,"PSOALWA")
        S GMRA="0^0^111" D ^GMRADPT
        I $G(GMRAL) S PSORY=0 F  S PSORY=$O(GMRAL(PSORY)) Q:'PSORY  S ^TMP($J,"PSOALWA",$S($P(GMRAL(PSORY),"^",4):1,1:2),$S('$P(GMRAL(PSORY),"^",5):1,1:2),$P(GMRAL(PSORY),"^",7),$P(GMRAL(PSORY),"^",2))=""
        S ^TMP($J,"PSOAPT",1)=$G(PNM)_"  "_$G(SSNP),^(2)="Verified Allergies"
        S ALCNT=0,EEE=0,(PSOLG,PSOLGA)="" F  S PSOLG=$O(^TMP($J,"PSOALWA",1,1,PSOLG)) Q:PSOLG=""  F  S PSOLGA=$O(^TMP($J,"PSOALWA",1,1,PSOLG,PSOLGA)) Q:PSOLGA=""  S EEE=1,ALCNT=ALCNT+1,^TMP($J,"PSOAPT",2,ALCNT)=PSOLGA
        I 'EEE,$G(GMRAL)=0 S ALCNT=ALCNT+1,^TMP($J,"PSOAPT",2,ALCNT)="NKA"
        S ALCNT=0,^TMP($J,"PSOAPT",3)="Non-Verified Allergies"
        S EEE=0,(PSOLG,PSOLGA)="" F  S PSOLG=$O(^TMP($J,"PSOALWA",2,1,PSOLG)) Q:PSOLG=""  F  S PSOLGA=$O(^TMP($J,"PSOALWA",2,1,PSOLG,PSOLGA)) Q:PSOLGA=""  S EEE=EEE+1,ALCNT=ALCNT+1,^TMP($J,"PSOAPT",3,ALCNT)=PSOLGA
        I 'EEE,$G(GMRAL)=0 S ALCNT=ALCNT+1,^TMP($J,"PSOAPT",3,ALCNT)="NKA"
        S ALCNT=0,^TMP($J,"PSOAPT",4)="Verified Adverse Reactions"
        S (PSOLG,PSOLGA)="" F  S PSOLG=$O(^TMP($J,"PSOALWA",1,2,PSOLG)) Q:PSOLG=""  F  S PSOLGA=$O(^TMP($J,"PSOALWA",1,2,PSOLG,PSOLGA)) Q:PSOLGA=""  S ALCNT=ALCNT+1,^TMP($J,"PSOAPT",4,ALCNT)=PSOLGA
        S ALCNT=0,^TMP($J,"PSOAPT",5)="Non-Verified Adverse Reactions"
        S (PSOLG,PSOLGA)="" F  S PSOLG=$O(^TMP($J,"PSOALWA",2,2,PSOLG)) Q:PSOLG=""  F  S PSOLGA=$O(^TMP($J,"PSOALWA",2,2,PSOLG,PSOLGA)) Q:PSOLGA=""  S ALCNT=ALCNT+1,^TMP($J,"PSOAPT",5,ALCNT)=PSOLGA
        I $G(PSOIO("ALI"))]"" X PSOIO("ALI")
        S XFONT=$E($G(PSOFONT),2,99)
        S OFONT=PSOFONT,PSOFONT=$G(PSOHFONT,PSOFONT) S TEXT=^TMP($J,"PSOAPT",1) D PRINT(TEXT,1) S PSOFONT=OFONT
        I $$GET1^DIQ(44,$P(RXY,"^",5),2,"I")="W" S TEXT="INPATIENT" D PRINT(TEXT,0)
        F CCC=3,4,5 I '$O(^TMP($J,"PSOAPT",CCC,0)) K ^TMP($J,"PSOAPT",CCC)
        D ASSESS
        I CCC="NKA" S ^TMP($J,"PSOAPT",2,1)="No Known Allergies" K ^TMP($J,"PSOAPT",3)
        S CCC=1,OUT=0
        F  S CCC=$O(^TMP($J,"PSOAPT",CCC)) Q:CCC=""  D  Q:OUT
        .S TEXT=$G(^TMP($J,"PSOAPT",CCC))
        .I $G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
        .S PSOY=PSOY+PSOYI D PRINT(TEXT,0,1)
        .I TEXT="No Assessment Made" Q
        .I PSOY>PSOYM S OUT=1 Q
        .S (TEXT,PTEXT,CCC2)="",LENGTH=0
        .F  S CCC2=$O(^TMP($J,"PSOAPT",CCC,CCC2)) Q:CCC2=""  S TEXT=^(CCC2) D  Q:OUT
        ..D STRT^PSOLLU1("SEC2",TEXT,.L)
        ..I LENGTH+L(XFONT)<3.7 S PTEXT=PTEXT_TEXT_",",LENGTH=LENGTH+L(XFONT) Q
        ..I PTEXT="" D  Q
        ... F JJ=$L(TEXT):-1 S PTEXT=$E(TEXT,1,JJ) D STRT^PSOLLU1("SEC2",PTEXT,.L) I L(XFONT)<3.7 D PRINT(PTEXT,0) S PTEXT=$E(TEXT,JJ+1,512)_"," Q
        ... D STRT^PSOLLU1("SEC2",PTEXT,.L) S LENGTH=L(XFONT)
        ..S LENGTH=0,CCC2=CCC2-1
        ..I PSOY>PSOYM S OUT=1 Q
        ..D PRINT(PTEXT,0) S PTEXT=""
        .I 'OUT,PTEXT]"" D PRINT($P(PTEXT,",",1,$L(PTEXT,",")-1),0)
        I OUT S T="Additional Allergies or Adverse Reactions Exist." D PRINT(T,0) S T="Talk to your Physician or Pharmacist." D PRINT(T,0)
        K ^TMP($J,"PSOALWA"),^TMP($J,"PSOAPT"),PSONKA,PSONULL,WWW,GMRA,GMRAL,JJJ,WCNT,RRR,ALG,ALCNT,EEE,FFF,PSOLG,PSOLGA,PSORY,CCC,CCC2,FNTFLG,TEXT,TEXT2
SUSPEN  S PSODFN=DFN,(SPPL,RXX,STA)="",XXS=1
        I $G(PSODTCUT)']"" S X1=DT,X2=-120 D C^%DTC S PSODTCUT=X
        D ^PSOBUILD S (STA,RXX)=""
        F  S STA=$O(PSOSD(STA)) Q:STA=""  F  S RXX=$O(PSOSD(STA,RXX)) Q:RXX=""  I $P(PSOSD(STA,RXX),"^",2)=5 S SPPL=$P(PSOSD(STA,RXX),"^")_","_SPPL
        I SPPL="" Q
SUSP1   I $G(PSOIO("SPI"))]"" X PSOIO("SPI")
        S TOF=0,TEXT=PNM_" "_SSNP_" "_$G(PSONOW) D PRINT(TEXT,0)
        S TEXT="The following prescription(s) have been requested and will be" D PRINT(TEXT,0)
        S TEXT="mailed to you on or after the date indicated." D PRINT(TEXT,0)
        S PSOY=PSOY+PSOYI,TEXT="Rx#                                          Date                                        "
        D PRINT(TEXT,0,1)
        F XX=XXS:1 Q:$P(SPPL,",",XX)=""  S RX=$P(SPPL,",",XX) D  Q:TOF
        . S SPNUM=$O(^PS(52.5,"B",RX,0)) I SPNUM S SPDATE=$P($G(^PS(52.5,SPNUM,0)),"^",2) S Y=SPDATE X ^DD("DD") S SPDATE=Y
        . S T=$P(^PSRX(RX,0),"^") D PRINT(T,0)
        . S PSOY=PSOY-PSOYI,OPSOX=PSOX,PSOX=PSOCX,T=$G(SPDATE) D PRINT(T,0)
        . S PSOX=OPSOX+20,T=$$ZZ^PSOSUTL(RX) D PRINT(T,0) K SPNUM,SPDATE,Y,ZDRUG
        . S PSOX=OPSOX,PSOY=PSOY+PSOYI
        . I PSOY>PSOYM S XXS=XX+1,TOF=1 W:$P(SPPL,",",XXS)]"" @IOF Q
        I TOF,$P(SPPL,",",XXS)]"" G SUSP1
        Q
PRINT(T,B,UL)   ;
        S BOLD=$G(B),UL=$G(UL)
        I 'BOLD,$G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
        I BOLD,$G(PSOIO(PSOFONT_"B"))]"" X PSOIO(PSOFONT_"B")
        I $G(PSOIO("ST"))]"" X PSOIO("ST")
        I UL,$G(PSOIO("FWU"))]"" X PSOIO("FWU")
        W T,!
        I UL,$G(PSOIO("FDU"))]"" X PSOIO("FDU")
        I $G(PSOIO("ET"))]"" X PSOIO("ET")
        I BOLD,$G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT) ;TURN OFF BOLDING
        Q
ASSESS  ;
        N FLG3,FLG4,FLG5
        S CCC=$G(^TMP($J,"PSOAPT",2,1))
        S FLG3=$G(^TMP($J,"PSOAPT",3,1))
        S FLG4=$G(^TMP($J,"PSOAPT",4,1))
        S FLG5=$G(^TMP($J,"PSOAPT",5,1))
        I CCC="",FLG3="",FLG4="",FLG5="" S ^TMP($J,"PSOAPT",2,1)="No Assessment Made" K ^TMP($J,"PSOAPT",3)
        Q
