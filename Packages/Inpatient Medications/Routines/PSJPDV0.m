PSJPDV0 ;BIR/KKA-LIST PATIENTS ON SPECIFIC DRUGS (CONT.) ; 7/6/09 2:20pm
        ;;5.0; INPATIENT MEDICATIONS ;**12,22,33,214**;16 DEC 97;Build 8
        ;
        ;Reference to ^PS(52.6 is supported by DBIA 1231
        ;Reference to ^PS(52.7 is supported by DBIA 2173
        ;Reference to ^PS(55 is supported by DBIA 2191
        ;Reference to ^SC is supported by DBIA 10040
        ;Reference to ^DG(40.8 is supported by DBIA 728
        ;Reference to ^DIC(42 is supported by DBIA 1377
        ;
ENQ     N TMPWD,TMPRB D NOW^%DTC S PSGDT=%,DT=$$DT^XLFDT
        K ^TMP("PSJ",$J),^TMP("PSJPDV",$J)
        D:CHOICE'="IV" UDORD D:CHOICE'="UD" IVORD
        I $D(PMATCH) S PSGP=0 F  S PSGP=$O(PMATCH(PSGP)) Q:'PSGP  D GETMAT I MATCHES'<PSJMAT&($D(^TMP("PSJPDV",$J,+PSGP))) D
        .S PSJACNWP=1 D ^PSJAC S TMPWD=PSJPWDN,TMPRB=PSJPRB,NM=PSGP(0),PSJJORD=0 F  S PSJJORD=$O(^TMP("PSJPDV",$J,PSGP,PSJJORD)) Q:'PSJJORD  D:PSJJORD'["V"&$$DIVWARD UDSET D:PSJJORD["V"&$$DIVWARD IVSET
        D ^PSJPDV1
        ;
DONE    K ^TMP("PSJ",$J),^TMP("PSJPDV",$J),%,ADD,CHOICE,CLS,DFN,DO,DRG,IVDO,IVDRG,IVIR,IVMR,IVND,IVORD,IVPSGP,IVSCH,IVSPD,IVSTD,MR,ND,ND2,NM,PATDRG,PDRG,PMATCH,PSGDT,PSGP,PSJJORD,SCH,SOL,SPD,SPPDRG,STD,VA,VADM,VAIN
        Q
        ;
DIVWARD()       ;DIVISION/WARD MATCH FOR PATIENT (PSJ*5*214)
        N PSJV,PSJVA,PSJVC
        I $G(VAUTD) I $G(VAUTW) Q 1  ;ALL DIVISIONS/ALL WARDS
        I $D(VAUTW(PSJPWD)) Q 1  ;SPECIFIC WARD MATCHES
        I $G(VAUTW) S PSJVC=0 D  Q $G(PSJVA,0)  ;SPECIFIC DIVISION MATCHES
        . F  S PSJVC=$O(VAUTD(PSJVC)) Q:PSJVC'=+PSJVC  S PSJV=VAUTD(PSJVC) I PSJV=$P($G(^DG(40.8,+$P($G(^DIC(42,(+PSJPWD),0)),"^",11),0)),U,1) S PSJVA=1
        Q 0
        ;
UDORD   ;find all Unit Dose orders with specified dispense drugs
        S SPD=$P(PSJREPS,".")-.0001 F  S SPD=$O(^PS(55,"AUD",SPD)) Q:'SPD  S PSGP=0 F  S PSGP=$O(^PS(55,"AUD",SPD,PSGP)) Q:'PSGP  D
        .S PSJJORD=0 F  S PSJJORD=$O(^PS(55,"AUD",SPD,PSGP,PSJJORD)) Q:'PSJJORD  D
        ..S ND=$G(^PS(55,PSGP,5,PSJJORD,2)) I +$P(ND,U,2)=0!(+$P(ND,U,2)>PSJREPF) Q
        ..Q:'$O(^PS(55,PSGP,5,PSJJORD,1,0))
        ..S PDRG=0 F  S PDRG=$O(^PS(55,PSGP,5,PSJJORD,1,PDRG)) Q:+PDRG=0  S SPPDRG=+$P(^(PDRG,0),"^") I $D(PSJISP(SPPDRG_"D")) S ^TMP("PSJPDV",$J,PSGP,PSJJORD)=SPD,CLS=PSJISP(SPPDRG_"D"),$P(PMATCH(PSGP),U,+CLS)=+CLS
        Q
        ;
UDSET   ;get patient and order information and set in global
        S ND=$G(^PS(55,PSGP,5,PSJJORD,0)),MR=$P(ND,"^",3),MR=$$ENMRN^PSGMI(MR)
        S ND=$G(^PS(55,PSGP,5,PSJJORD,2)),DRG=$G(^(.2)),SCH=$P(ND,"^"),SPD=^TMP("PSJPDV",$J,PSGP,PSJJORD),STD=$S($P(ND,"^",2):$P(ND,"^",2),1:"NOT FOUND"),DO=$P(DRG,"^",2),DRG=$$ENPDN^PSGMI($P(DRG,"^")) I DO]"",$E(DO,$L(DO))'=" " S DO=DO_" "
        N X,PSJ
        D DRGDISP^PSJLMUT1(PSGP,PSJJORD_"U",30,0,.PSJ,1)
        S DRG=PSJ(1)
        S ^TMP("PSJ",$J,$S(PSJSRT="P":NM_";"_DFN,1:+$G(STD)),$S(PSJSRT="P":+$G(STD),1:NM_";"_DFN),PSJJORD)=VA("PID")_"^"_PSJPWDN_"^"_PSJPRB_"^"_DRG_"^"_DO_MR_" "_SCH_"^"_SPD
        Q
IVORD   ;get IV orders matching the requested drug
        S IVSPD=$P(PSJREPS,".")-.0001 F  S IVSPD=$O(^PS(55,"AIV",IVSPD)) Q:'IVSPD  S IVPSGP=0 F  S IVPSGP=$O(^PS(55,"AIV",IVSPD,IVPSGP)) Q:'IVPSGP  D
        .S IVORD=0 F  S IVORD=$O(^PS(55,"AIV",IVSPD,IVPSGP,IVORD)) Q:'IVORD  D
        ..S ND=$G(^PS(55,IVPSGP,"IV",IVORD,0)) I +$P(ND,U,2)=0!(+$P(ND,U,2)>PSJREPF) Q
        ..D MATADD,MATSOL
        Q
MATADD  ;see if additives of the order match the drug
        Q:'$O(^PS(55,IVPSGP,"IV",IVORD,"AD",0))
        S ADD=0 F  S ADD=$O(^PS(55,IVPSGP,"IV",IVORD,"AD",ADD)) Q:'ADD  S ND=$G(^(ADD,0)),ND2=$G(^PS(52.6,+$P(ND,"^"),0)) D
        .I ND2]"" I $D(PSJISP($S(PSJSL="O":+$P($G(ND2),U,11)_"O",1:+$P($G(ND2),U,2)_"D"))) S CLS=PSJISP($S(PSJSL="O":$P(ND2,"^",11)_"O",1:$P(ND2,"^",2)_"D")),$P(PMATCH(IVPSGP),U,+CLS)=+CLS,^TMP("PSJPDV",$J,IVPSGP,IVORD_"V")=IVSPD
        Q
MATSOL  ;see if solutions of the order match the drug
        Q:'$O(^PS(55,IVPSGP,"IV",IVORD,"SOL",0))
        S SOL=0 F  S SOL=$O(^PS(55,IVPSGP,"IV",IVORD,"SOL",SOL)) Q:'SOL  S ND=$G(^(SOL,0)),ND2=$G(^PS(52.7,+$P(ND,"^"),0))  D
        .I ND2]"" I $D(PSJISP($S(PSJSL="O":+$P($G(ND2),U,11)_"O",1:+$P($G(ND2),U,2)_"D"))) S CLS=PSJISP($S(PSJSL="O":$P(ND2,"^",11)_"O",1:$P(ND2,"^",2)_"D")),$P(PMATCH(IVPSGP),U,+CLS)=+CLS,^TMP("PSJPDV",$J,IVPSGP,IVORD_"V")=IVSPD
        Q
        ;
IVSET   ;S IVND=$G(^PS(55,PSGP,"IV",+PSJJORD,0)),IVSCH=$P(IVND,"^",9),IVSTD=$P(IVND,"^",2),IVSPD=^TMP("PSJPDV",$J,PSGP,PSJJORD),IVMR=$P($G(^PS(55,PSGP,"IV",+PSJJORD,6)),"^",3),IVIR=$P(IVND,"^",8)
        ;S IVMR=$$ENMRN^PSGMI(IVMR)
        ;S IVDRG=$G(^PS(55,PSGP,"IV",+PSJJORD,6)),IVDO=$P(IVDRG,"^",2),IVDRG=$$ENPDN^PSGMI($P(IVDRG,"^")) I IVDO]"",$E(IVDO,$L(IVDO))'=" " S IVDO=IVDO_" "
        N X,ON55 S DFN=PSGP,ON=PSJJORD D GT55^PSIVORFB
        S DRG=$S($D(DRG("AD",1)):$P(DRG("AD",1),U,2),1:$P(DRG("SOL",1),U,2)),IVSCH=P(9),IVSTD=P(2),IVSPD=^TMP("PSJPDV",$J,PSGP,PSJJORD),IVMR=$P(P("MR"),U,2),IVIR=P(8),IVDRG=DRG
        S PSJPWDN=$S($G(^PS(55,PSGP,"IV",+ON,"DSS")):$P($G(^SC(+$G(^PS(55,PSGP,"IV",+ON,"DSS")),0)),"^"),($G(PSJPDD)]""&(IVSTD>+PSJPDD)):"",1:TMPWD),PSJPRB=$S($G(^PS(55,PSGP,"IV",+ON,"DSS")):"",($G(PSJPDD)]""&(IVSTD>+PSJPDD)):"",1:TMPRB)
        S ^TMP("PSJ",$J,$S(PSJSRT="P":NM_";"_DFN,1:+$G(IVSTD)),$S(PSJSRT="P":+$G(IVSTD),1:NM_";"_DFN),PSJJORD)=VA("PID")_"^"_PSJPWDN_"^"_PSJPRB_"^"_IVDRG_"^"_IVMR_" "_IVSCH_" "_IVIR_"^"_IVSPD
        ;
GETMAT  ;see if the patient has the number of drugs necessary to be printed on
        ;the report
        S MATCHES=0 F GG=1:1:$L(PMATCH(PSGP),"^") S GGG=$P(PMATCH(PSGP),"^",GG) S:GGG MATCHES=MATCHES+1
        Q
