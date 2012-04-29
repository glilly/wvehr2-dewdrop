PSOORRLO        ;BHAM ISC/SJA - returns patient's outpatient meds-original sort ;10/12/06
        ;;7.0;OUTPATIENT PHARMACY;**225**;DEC 1997;Build 29
        ;External reference to ^PS(55 supported by DBIA 2228
        ;External reference to ^PSDRUG supported by DBIA 221
        ;External reference to ^VA(200 supported by DBIA 10060
        ;External reference to(51.2 supported by DBIA 2226
        ;External reference to ^PS(50.7 supported by DBIA 2223
        ;External reference to ^PS(50.606 supported by DBIA 2174
        ;External reference to OCL^PSJORRE supported by DBIA 2383
OCL     ;entry point to return condensed list
        ;BHW;PSO*7*159;New SD* Variables
        N SD,SDT,SDT1,ST,STT,PSEX,PSG,PST,GP,EXDT1
        D:$P($G(^PS(55,DFN,0)),"^",6)'=2 EN^PSOHLUP(DFN)
        K ^TMP("PS",$J),^TMP("PSO",$J),^TMP("PS1",$J)
        S TFN=0,PSBDT=$G(BDT),PSEDT=$G(EDT) I +$G(PSBDT)<1 S X1=DT,X2=-120 D C^%DTC S PSBDT=X
        S EXDT=PSBDT-1,IFN=0
        F  S EXDT=$O(^PS(55,DFN,"P","A",EXDT)) Q:'EXDT  F  S IFN=$O(^PS(55,DFN,"P","A",EXDT,IFN)) Q:'IFN  D:$D(^PSRX(IFN,0))
        .S EXDT1=9999999-EXDT
        .Q:$P($G(^PSRX(IFN,"STA")),"^")=13
        .S TFN=TFN+1,RX0=^PSRX(IFN,0),RX2=$G(^(2)),RX3=$G(^(3)),STA=+$G(^("STA")),TRM=0,LSTFD=$P(RX2,"^",2),LSTRD=$P(RX2,"^",13),LSTDS=$P(RX0,"^",8)
        .F I=0:0 S I=$O(^PSRX(IFN,1,I)) Q:'I  S TRM=TRM+1,LSTFD=$P(^PSRX(IFN,1,I,0),"^"),LSTDS=$P(^(0),"^",10) S:$P(^(0),"^",18)]"" LSTRD=$P(^(0),"^",18)
        .S ST0=$S(STA<12&($P(RX2,"^",6)<DT):11,1:STA)
        .S STT=$P("ERROR^ACTIVE;2:1^NON-VERIFIED;1:1^REFILL FILL;2:3^HOLD;2:7^NON-VERIFIED;1:1^ACTIVE/SUSP;2:6^^^^^DONE;2:9^EXPIRED;3:1^DISCONTINUED;4:3^DISCONTINUED;4:3^DISCONTINUED;4:3^DISCONTINUED (EDIT);4:4^HOLD;2:7^","^",ST0+2)
        .S ST=$P(STT,";"),GP=$P(STT,";",2)
        .;Status Groups: 1-PENDING, 2-ACTIVE, 3-Expired, 4-DISCONTINUED
        .S ^TMP("PSO",$J,GP,EXDT1,TFN,0)=IFN_"R;O"_"^"_$P($G(^PSDRUG(+$P(RX0,"^",6),0)),"^")_"^^"_$P(RX2,"^",6)_"^"_($P(RX0,"^",9)-TRM)_"^^^"_$P($G(^PSRX(IFN,"OR1")),"^",2)
        .S ^TMP("PSO",$J,GP,EXDT1,TFN,"P",0)=$P(RX0,"^",4)_"^"_$P($G(^VA(200,+$P(RX0,"^",4),0)),"^")
        .S ^TMP("PSO",$J,GP,EXDT1,TFN,0)=^TMP("PSO",$J,GP,EXDT1,TFN,0)_"^"_ST_"^"_LSTFD_"^"_$P(RX0,"^",8)_"^"_$P(RX0,"^",7)_"^^^"_$P(RX0,"^",13)_"^"_LSTRD_"^"_LSTDS
        .S ^TMP("PSO",$J,GP,EXDT1,TFN,"SCH",0)=0
        .S (SCH,SC)=0 F  S SC=$O(^PSRX(IFN,"SCH",SC)) Q:'SC  S SCH=SCH+1,^TMP("PSO",$J,GP,EXDT1,TFN,"SCH",SCH,0)=$P(^PSRX(IFN,"SCH",SC,0),"^"),^TMP("PSO",$J,GP,EXDT1,TFN,"SCH",0)=^TMP("PSO",$J,GP,EXDT1,TFN,"SCH",0)+1
        .S ^TMP("PSO",$J,GP,EXDT1,TFN,"MDR",0)=0,(MDR,MR)=0 F  S MR=$O(^PSRX(IFN,"MEDR",MR)) Q:'MR  D
        ..Q:'$D(^PS(51.2,+^PSRX(IFN,"MEDR",MR,0),0))  S MDR=MDR+1
        ..I $P($G(^PS(51.2,+^PSRX(IFN,"MEDR",MR,0),0)),"^",3)]"" S ^TMP("PSO",$J,GP,EXDT1,TFN,"MDR",MDR,0)=$P(^PS(51.2,+^PSRX(IFN,"MEDR",MR,0),0),"^",3)
        ..I $D(^PS(51.2,+^PSRX(IFN,"MEDR",MR,0),0)),$P($G(^(0)),"^",3)']"" S ^TMP("PSO",$J,GP,EXDT1,TFN,"MDR",MDR,0)=$P(^PS(51.2,+^PSRX(IFN,"MEDR",MR,0),0),"^")
        ..S ^TMP("PSO",$J,GP,EXDT1,TFN,"MDR",0)=^TMP("PSO",$J,GP,EXDT1,TFN,"MDR",0)+1
        .S PSOELSE=0 I $D(^PSRX(IFN,"SIG")),'$P(^PSRX(IFN,"SIG"),"^",2) S PSOELSE=1 S X=$P(^PSRX(IFN,"SIG"),"^") D SIG1^PSOORRL1
        .I '$G(PSOELSE) S ITFN=1 D
        ..S ^TMP("PSO",$J,GP,EXDT1,TFN,"SIG",ITFN,0)=$G(^PSRX(IFN,"SIG1",1,0)),^TMP("PSO",$J,GP,EXDT1,TFN,"SIG",0)=+$G(^TMP("PSO",$J,GP,EXDT1,TFN,"SIG",0))+1
        ..F I=1:0 S I=$O(^PSRX(IFN,"SIG1",I)) Q:'I  S ITFN=ITFN+1,^TMP("PSO",$J,GP,EXDT1,TFN,"SIG",ITFN,0)=^PSRX(IFN,"SIG1",I,0),^TMP("PSO",$J,GP,EXDT1,TFN,"SIG",0)=+$G(^TMP("PSO",$J,GP,EXDT1,TFN,"SIG",0))+1
        K PSOELSE
        S IFN=0 F  S IFN=$O(^PS(52.41,"P",DFN,IFN)) Q:'IFN  S PSOR=^PS(52.41,IFN,0) D:$P(PSOR,"^",3)="" WAIT D:$P(PSOR,"^",3)'="DC"&($P(PSOR,"^",3)'="DE")&($P(PSOR,"^",3)'="")
        .S GP="1:3",PSEX="9999999"
        .Q:$P(PSOR,"^",3)="RF"
        .I $P(PSOR,"^",8)="",$P(PSOR,"^",9)="" D WAIT
        .I $P(PSOR,"^",8)="",$P(PSOR,"^",9)="" Q  ; QUIT IF STILL NULL AFTER WAITING
        .S TFN=TFN+1,^TMP("PSO",$J,GP,PSEX,TFN,0)=IFN_"P;O^"_$S($P(PSOR,"^",9):$P($G(^PSDRUG($P(PSOR,"^",9),0)),"^"),1:$P(^PS(50.7,$P(PSOR,"^",8),0),"^")_" "_$P(^PS(50.606,$P(^PS(50.7,$P(PSOR,"^",8),0),"^",2),0),"^"))
        .S ^TMP("PSO",$J,GP,PSEX,TFN,0)=^TMP("PSO",$J,GP,PSEX,TFN,0)_"^^^^^^"_$P(PSOR,"^")_"^"_"PENDING^^^"_$P(PSOR,"^",10)_"^"
        .S ^TMP("PSO",$J,GP,PSEX,TFN,0)=^TMP("PSO",$J,GP,PSEX,TFN,0)_"^"_$S($P(PSOR,"^",3)="RNW":1,1:0)
        .S SD=0 F SCH=0:0 S SCH=$O(^PS(52.41,IFN,1,SCH)) Q:'SCH  S SD=SD+1,^TMP("PSO",$J,GP,PSEX,TFN,"SCH",SD,0)=$P(^PS(52.41,IFN,1,SCH,1),"^"),^TMP("PSO",$J,GP,PSEX,TFN,"SCH",0)=SD
        .S SD=0 F SCH=0:0 S SCH=$O(^PS(52.41,IFN,"SIG",SCH)) Q:'SCH  S SD=SD+1,^TMP("PSO",$J,GP,PSEX,TFN,"SIG",SD,0)=$P(^PS(52.41,IFN,"SIG",SCH,0),"^"),^TMP("PSO",$J,GP,PSEX,TFN,"SIG",0)=SD
        .S (IEN,SD)=1,INST=0 F  S INST=$O(^PS(52.41,IFN,2,INST)) Q:'INST  S (MIG,INST(INST))=^PS(52.41,IFN,2,INST,0),^TMP("PSO",$J,GP,PSEX,TFN,"SIO",0)=SD D
        ..F SG=1:1:$L(MIG," ") S:$L($G(^TMP("PSO",$J,GP,PSEX,TFN,"SIO",IEN,0))_" "_$P(MIG," ",SG))>80 IEN=IEN+1,SD=SD+1,^TMP("PSO",$J,GP,PSEX,TFN,"SIO",0)=SD D
        ...S ^TMP("PSO",$J,GP,PSEX,TFN,"SIO",IEN,0)=$G(^TMP("PSO",$J,GP,PSEX,TFN,"SIO",IEN,0))_" "_$P(MIG," ",SG)
        D NVA
        S PSG=0,J=1 F  S PSG=$O(^TMP("PSO",$J,PSG)) Q:'PSG  S PST="" F  S PST=$O(^TMP("PSO",$J,PSG,PST)) Q:PST=""  S I=0 F  S I=$O(^TMP("PSO",$J,PSG,PST,I)) Q:'I  D
        .M ^TMP("PS",$J,J)=^TMP("PSO",$J,PSG,PST,I) S J=J+1
        S PSG=0 F  S PSG=$O(^TMP("PS1",$J,PSG)) Q:'PSG  S I=0 F  S I=$O(^TMP("PS1",$J,PSG,I)) Q:'I  D
        .M ^TMP("PS",$J,J)=^TMP("PS1",$J,PSG,I) S J=J+1
        K ^TMP("PSO",$J),^TMP("PS1",$J)
        D OCL^PSJORRE(DFN,BDT,EDT,.TFN,+$G(VIEW)) D END^PSOORRL1
        K SDT,SDT1,GP,PSEX,PSG,PST,EDT,EDT1,BDT,DBT1,X
        Q
WAIT    ; IF PENDING ENTRY STILL BEING BUILT SEE IF IT COMPLETES WITHIN ANOTHER SECOND
        H 1 S PSOR=$G(^PS(52.41,IFN,0))
        Q
        ;
NVA     ; Set Non-VA Med Orders in the ^TMP Global
        ;BHW;PSO*7*159;New SDT,SDT1 Variables
        N SDT,SDT1
        F I=0:0 S I=$O(^PS(55,DFN,"NVA",I)) Q:'I  S X=$G(^PS(55,DFN,"NVA",I,0)) D
        .Q:'$P(X,"^")
        .S DRG=$S($P(X,"^",2):$P($G(^PSDRUG($P(X,"^",2),0)),"^"),1:$P(^PS(50.7,$P(X,"^"),0),"^")_" "_$P(^PS(50.606,$P(^PS(50.7,$P(X,"^"),0),"^",2),0),"^"))
        .S SDT=$P(X,"^",9) I 'SDT D TMPBLD Q
        .I $E(SDT,4,5),$E(SDT,6,7) D
        ..;I $P(X,"^",9) D  Q
        ..I $G(BDT),SDT<BDT Q
        ..I $G(EDT),SDT>EDT Q
        ..I $G(BDT),$P(X,"^",7),$P(X,"^",7)<BDT Q
        ..D TMPBLD
        .I $E(SDT,4,5),'$E(SDT,6,7) D
        ..S SDT1=$E(SDT,1,5),BDT1=$E(+$G(BDT),1,5),EDT1=$E(+$G(EDT),1,5)
        ..I $G(BDT1),SDT1<BDT1 Q
        ..I $G(EDT1),SDT1>EDT1 Q
        ..I $G(BDT1),$P(X,"^",7),$E($P(X,"^",7),1,5)<BDT1 Q
        ..D TMPBLD
        .I '$E(SDT,4,5),'$E($P(X,"^",9),6,7) D
        ..;I $P(X,"^",9) D  Q
        ..S SDT1=$E(SDT,1,3),BDT1=$E(+$G(BDT),1,3),EDT1=$E(+$G(EDT),1,3)
        ..I $G(BDT1),SDT1<BDT1 Q
        ..I $G(EDT1),SDT1>EDT1 Q
        ..I $G(BDT1),$P(X,"^",7),$E($P(X,"^",7),1,3)<BDT1 Q
        ..D TMPBLD
        Q
TMPBLD  S TFN=$G(TFN)+1,GP=$S($P(X,"^",7):3,1:2)
        S ^TMP("PS1",$J,GP,TFN,0)=I_"N;O^"_DRG
        S $P(^TMP("PS1",$J,GP,TFN,0),"^",8)=$P(X,"^",8)_"^"_$S($P(X,"^",7):"DISCONTINUED",1:"ACTIVE")
        S ^TMP("PS1",$J,GP,TFN,"SCH",0)=1,^TMP("PS1",$J,GP,TFN,"SCH",1,0)=$P(X,"^",5)
        S ^TMP("PS1",$J,GP,TFN,"SIG",0)=1,^TMP("PS1",$J,GP,TFN,"SIG",1,0)=$P(X,"^",3)_" "_$P(X,"^",4)_" "_$P(X,"^",5)
        Q
