ECXDRUG2        ;ALB/TMD-Pharmacy Extracts Incomplete Feeder Key Report ; 2/19/08 3:44pm
        ;;3.0;DSS EXTRACTS;**40,68,84,105,111**;Dec 22, 1997;Build 4
        ;
EN      ; entry point
        N ECD,LINE,ECDRG,ECQTY,ECPRC
        K ^TMP($J)
        S ECD=ECSD1,ECED=ECED+.3
        S LINE=$S(ECXOPT=1:"PRE",ECXOPT=2:"IVP",ECXOPT=3:"UDP",1:"EXIT")
        D @LINE
        Q
        ;
PRE     ; entry point for PRE data
        ; order through fills, refills and partial refills
        N ECRFL,ECRX,ECREF,ECDATA,ECDATA1
        K ^TMP($J,"ECXDSS")
        ;call pharmacy api pso52ex
        D EXTRACT^PSO52EX(ECD,ECED,"ECXDSS")
        S ECREF="RF"
        ;order thru fills and refills; refill values 0 thru 11
        ;     Note:  refill 0 = original fill
        F  S ECD=$O(^TMP($J,"ECXDSS","AL",ECD)),IEN=0 Q:'ECD  Q:ECD>ECED  Q:ECXERR  F  S IEN=$O(^(ECD,IEN)),ECRFL=""  Q:'IEN  Q:ECXERR  F  S ECRFL=$O(^(IEN,ECRFL)) Q:ECRFL']""  Q:ECXERR  D PRE2
        ;
        ;order thru partial fills
        S ECD=ECSD1,ECREF="P"
        F  S ECD=$O(^TMP($J,"ECXDSS","AM",ECD)),IEN=0 Q:'ECD  Q:ECD>ECED  Q:ECXERR  F  S IEN=$O(^(ECD,IEN)),ECRFL=""  Q:'IEN  Q:ECXERR  F  S ECRFL=$O(^(IEN,ECRFL)) Q:'ECRFL  Q:ECXERR  D PRE2
        K ^TMP($J,"ECXDSS")
        Q
        ;
PRE2    ; get Prescription data
        S ECDRG=+$P(^TMP($J,"ECXDSS",IEN,6),U)
        I ECRFL>0&(ECREF="RF") D
        .S ECQTY=^TMP($J,"ECXDSS",IEN,ECREF,ECRFL,1),ECPRC=^(1.2)
        I ECRFL>0&(ECREF="P") D
        .S ECQTY=^TMP($J,"ECXDSS",IEN,ECREF,ECRFL,.04),ECPRC=^(.042)
        I 'ECRFL S ECQTY=^TMP($J,"ECXDSS",IEN,7),ECPRC=^(17)
        D TEST
        Q
        ;
IVP     ; entry point for IVP data
        N ON,DFN,DA,SA
        F  S ECD=$O(^ECX(728.113,"A",ECD)),DFN=0 Q:'ECD  Q:ECXERR  Q:ECD>ECED  F  S DFN=$O(^ECX(728.113,"A",ECD,DFN)),ON=0  Q:'DFN  Q:ECXERR  F  S ON=$O(^ECX(728.113,"A",ECD,DFN,ON)),DA=0 Q:'ON  K ^TMP($J,"A"),^("S") D
        .F  S DA=$O(^ECX(728.113,"A",ECD,DFN,ON,DA)) Q:'DA  I $D(^ECX(728.113,DA,0)) S EC=^(0) D
        ..S ECDRG=$P(EC,U,4)
        ..S SA=$S($P(EC,U,8)]"":"A",$P(EC,U,9):"S",1:"")
        ..I SA'="" D
        ...I '$D(^TMP($J,SA,ECDRG)) S ^(ECDRG)=0,$P(^(ECDRG),U,2)=$P(EC,U,12)
        ...S $P(^TMP($J,SA,ECDRG),U)=$P(^TMP($J,SA,ECDRG),U)+$S($P(EC,U,6)=1:1,$P(EC,U,6)=4:0,1:-1)
        .;looped thru all DAs for this order - now put it together
        .F SA="S","A" S ECDRG="" F  S ECDRG=$O(^TMP($J,SA,ECDRG)) Q:ECDRG=""  D
        ..S ECQTY=$P(^TMP($J,SA,ECDRG),U),ECPRC=$P(^(ECDRG),U,2)
        ..D TEST
        K ^TMP($J,"A"),^TMP($J,"S")
        Q
        ;
UDP     ; entry point for UDP data
        N ECXJ,ECDATA
        F  S ECD=$O(^ECX(728.904,"A",ECD)) Q:'ECD  Q:ECD>ECED  Q:ECXERR  D
        .S ECXJ=0 F  S ECXJ=$O(^ECX(728.904,"A",ECD,ECXJ)) Q:'ECXJ  Q:ECXERR  I $D(^ECX(728.904,ECXJ,0)) D
        ..S DATA=^ECX(728.904,ECXJ,0)
        ..S ECDRG=$P(DATA,U,4),ECQTY=$P(DATA,U,5),ECCOST=$P(DATA,U,8)
        ..S ECPRC=ECCOST/ECQTY
        ..D TEST
        Q
        ;
TEST    ; retrieve NDC and PSNDF VA Product Code Entry and test for missing NDC or VA Prod Code
        N ECTYPE,ECNDC,ECZERO,K,ECPROD,ECFCHAR,ECSTOCK,ECXPHA
        S ECTYPE=0,ECXPHA=""
        ; call pharmacy drug file (#50) api via ecxutl5
        S ECXPHA=$$PHAAPI^ECXUTL5(ECDRG)
        S ECNDC=$P(ECXPHA,U,3)
        S ECNDC=$$RJ^XLFSTR($P(ECNDC,"-"),6,0)_$$RJ^XLFSTR($P(ECNDC,"-",2),4,0)_$$RJ^XLFSTR($P(ECNDC,"-",3),2,0),ECNDC=$TR(ECNDC,"*",0)
        S ECZERO=1,ECSTOCK=0 F K=1:1:$L(ECNDC) D  Q:'ECZERO!ECSTOCK
        .S ECFCHAR=$E(ECNDC,K)
        .I ECFCHAR="S" S ECSTOCK=1 Q
        .I ECFCHAR'=0 S ECZERO=0 Q
        I ECZERO!ECSTOCK!(ECNDC["N/A") S ECTYPE=2
        S ECPROD=$P(ECXPHA,U,6),ECPROD=$$RJ^XLFSTR(ECPROD,5,0)
        I ECTYPE,'ECPROD S ECTYPE=3
        I 'ECTYPE,'ECPROD S ECTYPE=1
        I ECTYPE D FILE
        Q
        ;
FILE    ; file record
        N ECFKEY,ECGNAME,STATS,ECCOUNT,QTY,COST,ECCOST
        ; create new record if none exists for this drug
        I '$D(^TMP($J,ECDRG)) D
        .S ECFKEY=ECPROD_ECNDC
        .S ECGNAME=$P($G(^PSDRUG(ECDRG,0)),U)
        .S ^TMP($J,ECDRG)=ECGNAME_U_ECFKEY_U_ECPRC_U_ECTYPE
        .S ^TMP($J,ECDRG,0)="0^0^0"
        ; add stats to record
        S STATS=^TMP($J,ECDRG,0)
        S ECCOUNT=$P(STATS,U),QTY=$P(STATS,U,2),COST=$P(STATS,U,3)
        S ECCOUNT=ECCOUNT+1
        S ECCOST=ECQTY*ECPRC
        S ECQTY=ECQTY+QTY,ECCOST=ECCOST+COST
        S ^TMP($J,ECDRG,0)=ECCOUNT_U_ECQTY_U_ECCOST
        Q
        ;
EXIT    S ECXERR=1 Q
