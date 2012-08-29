ECXAPHA2        ;ALB/TMD-Pharmacy Extracts Unusual Volumes Report ; 6/25/08 5:19pm
        ;;3.0;DSS EXTRACTS;**40,49,84,104,105,113**;Dec 22, 1997;Build 7
        ;
EN      ; entry point
        N COUNT,ECUNIT,LINE,ECDFN,ECD,ECDRG,ECDAY,ECDFN,ECQTY,ECUNIT,ECCOST,ECDS,ECXCOUNT
        K ^TMP($J)
        S (COUNT,ECDS,ECXCOUNT)=0,ECUNIT=""
        S ECD=ECSD1,ECED=ECED+.3
        S LINE=$S(ECXOPT=1:"PRE",ECXOPT=2:"IVP",ECXOPT=3:"UDP",1:"EXIT")
        D @LINE
        Q
        ;
PRE     ; entry point for PRE data
        N ECRFL,ECRX,ECREF,ECDATA,ECDATA1,ECPRC,IEN
        K ^TMP($J,"ECXDSS")
        ;call pharmacy api pso52ex
        D EXTRACT^PSO52EX(ECD,ECED,"ECXDSS")
        S ECREF="RF"
        ;order thru fills and refills; refill values 0 thru 11
        ;     Note:  refill 0 = original fill
        F  S ECD=$O(^TMP($J,"ECXDSS","AL",ECD)),IEN=0 Q:'ECD  Q:ECD>ECED  Q:ECXERR  F  S IEN=$O(^TMP($J,"ECXDSS","AL",ECD,IEN)),ECRFL=""  Q:'IEN  Q:ECXERR  F  S ECRFL=$O(^TMP($J,"ECXDSS","AL",ECD,IEN,ECRFL)) Q:ECRFL=""  Q:ECXERR  D PRE2
        ;
        ;order thru partial fills
        S ECD=ECSD1,ECREF="P"
        F  S ECD=$O(^TMP($J,"ECXDSS","AM",ECD)),IEN=0 Q:'ECD  Q:ECD>ECED  Q:ECXERR  F  S IEN=$O(^(ECD,IEN)),ECRFL=""  Q:'IEN  Q:ECXERR  F  S ECRFL=$O(^(IEN,ECRFL)) Q:'ECRFL  Q:ECXERR  D PRE2
        K ^TMP($J,"ECXDSS")
        Q
        ;
PRE2    ; get Prescription data
        I (ECREF="RF")&(ECRFL) D
        .S ECQTY=+^TMP($J,"ECXDSS",IEN,ECREF,ECRFL,1)
        .S ECDS=+^TMP($J,"ECXDSS",IEN,ECREF,ECRFL,1.1)
        .S ECPRC=^TMP($J,"ECXDSS",IEN,ECREF,ECRFL,1.2)
        I (ECREF="RF")&('ECRFL) D
        .S ECQTY=+^TMP($J,"ECXDSS",IEN,7)
        .S ECDS=+^TMP($J,"ECXDSS",IEN,8)
        .S ECPRC=+^TMP($J,"ECXDSS",IEN,17)
        I ECREF="P" D
        .S ECQTY=+^TMP($J,"ECXDSS",IEN,ECREF,ECRFL,.04)
        .S ECDS=+^TMP($J,"ECXDSS",IEN,ECREF,ECRFL,.041)
        .S ECPRC=+^TMP($J,"ECXDSS",IEN,ECREF,ECRFL,.042)
        ;check to see if quantity>threshold
        I ECQTY>ECTHLD D
        .S ECDAY=ECD
        .S ECDFN=$P(^TMP($J,"ECXDSS",IEN,2),U)
        .S ECDRG=+$P(^TMP($J,"ECXDSS",IEN,6),U)
        .S ECCOST=ECQTY*ECPRC
        .D FILE Q:ECXERR
        Q
        ;
IVP     ; entry point for IVP Data
        N DFN,ON,DA,SA,ECCOUNT
        F  S ECD=$O(^ECX(728.113,"A",ECD)),DFN=0 Q:'ECD  Q:ECD>ECED  Q:ECXERR  F  S DFN=$O(^ECX(728.113,"A",ECD,DFN)),ON=0  Q:'DFN  F  S ON=$O(^ECX(728.113,"A",ECD,DFN,ON)),DA=0 Q:'ON  K ^TMP($J,"A"),^("S") D  Q:ECXERR
        .F  S DA=$O(^ECX(728.113,"A",ECD,DFN,ON,DA)) Q:'DA  Q:ECXERR  I $D(^ECX(728.113,DA,0)) S EC=^(0) Q:ECXERR  D
        ..S ECDRG=$P(EC,U,4)
        ..S SA=$S($P(EC,U,8)]"":"A",$P(EC,U,9):"S",1:"")
        ..; set up new record for first DA for this drug
        ..I '$D(^TMP($J,SA,ECDRG)) D
        ...S ECQTY=+$S(SA="A":+$P(EC,U,7),SA="S":+$P(EC,U,9),1:0)
        ...S ECUNIT=$S(SA="A":$P(EC,U,8),SA="S":"ML",1:"")
        ...S ECCOST=$P(EC,U,12),ECDFN=DFN
        ...S ^TMP($J,SA,ECDRG)=ECUNIT_U_ECD_U_ECDFN_U_ECCOST_U_ECQTY
        ...S ^(ECDRG,1)=0
        ..; add to qty (0,1, or -1) to total
        ..S ^TMP($J,SA,ECDRG,1)=^TMP($J,SA,ECDRG,1)+$S($P(EC,U,6)=1:1,$P(EC,U,6)=4:0,1:-1)
        .; looped thru all DAs for this order - now check for unusual volumes
        .F SA="S","A" S ECDRG="" F  S ECDRG=$O(^TMP($J,SA,ECDRG)) Q:ECDRG=""  Q:ECXERR  D
        ..S ECQTY=$P(^TMP($J,SA,ECDRG),U,5),ECCOUNT=^(ECDRG,1)
        ..S ECQTY=ECQTY*ECCOUNT
        ..; check to see if quantity is outside of threshold range
        ..I (ECQTY>ECTHLD)!(ECQTY<-ECTHLD) D
        ...S ECUNIT=$P(^TMP($J,SA,ECDRG),U)
        ...S ECDAY=$P(^(ECDRG),U,2)
        ...S ECDFN=$P(^(ECDRG),U,3)
        ...S ECCOST=$P(^(ECDRG),U,4)*ECCOUNT
        ...D FILE Q:ECXERR
        K ^TMP($J,"A"),^("S")
        Q
        ;
UDP     ; entry point for UDP data
        N ECXJ,ECDATA
        F  S ECD=$O(^ECX(728.904,"A",ECD)) Q:'ECD  Q:ECD>ECED  Q:ECXERR  D
        .S ECXJ=0 F  S ECXJ=$O(^ECX(728.904,"A",ECD,ECXJ)) Q:'ECXJ  Q:ECXERR  I $D(^ECX(728.904,ECXJ,0)) D
        ..S DATA=^ECX(728.904,ECXJ,0),ECQTY=$P(DATA,U,5)
        ..;check to see if quantity>threshold
        ..I ECQTY>ECTHLD D
        ...S ECDFN=$P(DATA,U,2),ECDRG=$P(DATA,U,4),ECCOST=$P(DATA,U,8),ECDAY=ECD
        ...D FILE Q:ECXERR
        Q
        ;
FILE    ; put records in temp file to print later
        N OK,ECXPAT,ECNAME,ECSSN,ECGNAME,ECNDC,ECPROD,ECFKEY,ECXPHA
        ; get demographics
        S OK=$$PAT^ECXUTL3(ECDFN,$P(ECD,"."),"1;",.ECXPAT)
        I 'OK Q
        S ECNAME=ECXPAT("NAME")
        S ECSSN=ECXPAT("SSN")
        S ECDAY=$E(ECDAY,4,5)_"/"_$E(ECDAY,6,7)
        ; get drug file data
        S ECXPHA="",ECXPHA=$$PHAAPI^ECXUTL5(ECDRG)
        S ECGNAME=$P(ECXPHA,U)
        S ECNDC=$P(ECXPHA,U,3)
        S ECNDC=$$RJ^XLFSTR($P(ECNDC,"-"),6,0)_$$RJ^XLFSTR($P(ECNDC,"-",2),4,0)_$$RJ^XLFSTR($P(ECNDC,"-",3),2,0)
        S ECNDC=$TR(ECNDC,"*",0)
        S ECPROD=$P(ECXPHA,U,6)
        S ECPROD=$$RJ^XLFSTR(ECPROD,5,0)
        S ECFKEY=ECPROD_ECNDC
        I ECXOPT'=2 S ECUNIT=$P(ECXPHA,U,8)
        ; file 
        S ^TMP($J,ECFKEY,-ECQTY,ECDAY,ECXCOUNT,ECSSN)=ECNAME_U_ECSSN_U_ECDAY_U_ECGNAME_U_ECFKEY_U_ECQTY_U_ECUNIT_U_"$"_$FNUMBER(ECCOST,",",2)_U_ECDS
        S COUNT=COUNT+1
        S ECXCOUNT=ECXCOUNT+1
        I COUNT#100=0 I $$S^ZTLOAD S (ZSTOP,ECXERR)=1
        Q
        ;
EXIT    S ECXERR=1 Q
