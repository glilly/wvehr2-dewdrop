FHDCR1A ; HISC/REL/NCA/RVD - Build Diet Cards ;1/21/99  14:04
        ;;5.5;DIETETICS;**1,5,15**;Jan 28, 2005;Build 2
        ;patch #5 - added the screen for cancelled Guest meal.
        ;patch #15 - added the screen to prevent reprint of outpatient meal diet cards
B1      ; Store wards
        K ^TMP($J),NN,N,P S MFLG=0 D Q1^FHDCR1B D NOW^%DTC S (DTP,TIM)=% D DTP^FH S HD=DTP S:MEAL="A" MFLG=1
        S DTP=D1 D DTP^FH S (MDT,MEALDT)=DTP,MEALDT=$J("",62-$L(MEALDT)\2)_MEALDT
        S FHBOT=$P($G(^FH(119.9,1,4)),"^",1)
        S FHD1=D1-.00001,FHD2=D1+.99999
        S FHDFNSAV="",FHW1SAV=W1,FHFHPSAV=FHP,FHMEALSA=MEAL
        S:$G(FHDFN) FHDFNSAV=FHDFN
        I $G(DFN),'$D(^DPT(DFN,.1)) G OUTALL
        I '$G(DFN),$G(FHDFN) G OUTALL
        ;next process inpatient data
DFN     I $G(DFN),$G(FHDFN) D  Q
        .S ADM=+$G(^DPT(DFN,.105)),W1=+$P($G(^FHPT(FHDFN,"A",+ADM,0)),"^",8)
        .S K1=$G(^FH(119.6,+W1,0)),WRDN=$P(K1,"^",1),SP=$P(K1,"^",5),SP1=$P(K1,"^",6),FHPAR=$P(K1,"^",24),RM=$G(^DPT(DFN,.101))
        .I 'SP Q:FHPAR'="Y"  S SP=SP1 Q:'SP
        .K PP,S,MM S NBR=0
        .I 'TPP D BLD^FHDCR11 D:NBR UPD,PRT^FHDCR1C Q
        .I 'MFLG D BLD^FHDCR1D D:NBR UPD,PRT^FHMTK1C Q
        .F MEAL="B","N","E" D BLD^FHDCR1D
        .D UPD
        .D:NBR PRT^FHMTK1C
        ;if ward, do specific ward/location;otherwise, do all entry for all
        ;wards/locations and all communication offices.
WARD    I W1 S ^TMP($J,"W","01"_$P($G(^FH(119.6,+W1,0)),"^",1))=W1_"^"_$P($G(^FH(119.6,+W1,0)),"^",5,6)_"^"_$P($G(^FH(119.6,+W1,0)),"^",24)
        E  F W1=0:0 S W1=$O(^FH(119.6,W1)) Q:W1<1  D
        .S P0=$G(^FH(119.6,W1,0)),WRDN=$P(P0,"^",1),SP=$P(P0,"^",5,6),D2=$P(P0,"^",8),FHPAR=$P(P0,"^",24),P0=$P(P0,"^",4),P0=$S(P0<1:99,P0<10:"0"_P0,1:P0)
        .I FHP,D2'=FHP Q
        .S ^TMP($J,"W",P0_WRDN)=W1_"^"_SP_"^"_FHPAR Q
        S NX="" F  S NX=$O(^TMP($J,"W",NX)) Q:NX=""  S X1=$G(^(NX)),W1=+X1,FHS=$P(X1,"^",2),SP1=$P(X1,"^",3),FHPAR=$P(X1,"^",4),WRDN=$E(NX,3,99) S:'FHS&(FHPAR="Y") FHS=SP1 I FHS K ^TMP($J,"D") D
        .F FHDFN=0:0 S FHDFN=$O(^FHPT("AW",W1,FHDFN)) Q:FHDFN<1  D
        ..D PATNAME^FHOMUTL Q:'$G(DFN)
        ..S ADM=$G(^FHPT("AW",W1,FHDFN))
        ..I SORT="A" S RM=$P($G(^DPT(DFN,0)),"^",1),DL=0,RMB=$G(^DPT(DFN,.101)) S:RMB="" RMB="***"
        ..E  S RI=$G(^DPT(DFN,.108)),RM=$G(^DPT(DFN,.101)) S:RM="" RM="***" S:RI RE=$O(^FH(119.6,"AR",+RI,W1,0)) S:'RI RE="" S DL=$S(RE:$P($G(^FH(119.6,W1,"R",+RE,0)),"^",2),1:""),RMB=""
        ..S DL=$S(DL<1:99,DL<10:"0"_DL,1:DL)
        ..S ^TMP($J,"D",DL_"~"_RM_"~"_$S(SORT="R":DFN,1:RMB))=DFN_"^"_ADM_"^"_FHDFN Q
        .;
        .K ^TMP($J,"MP"),^TMP($J,0),MM,PP,S S X9="",NBR=0 F  S X9=$O(^TMP($J,"D",X9)) Q:X9=""  S FHX6=$G(^(X9)) S DFN=$P(FHX6,"^",1),ADM=$P(FHX6,"^",2) D
        ..S FHDFN=$P(FHX6,"^",3)
        ..S RM=$S(SORT="R":$P(X9,"~",2),1:$P(X9,"~",3)) S SP=FHS
        ..I TPP D  Q
        ...I 'MFLG D BLD^FHDCR1D,UPD Q
        ...F MEAL="B","N","E" D BLD^FHDCR1D
        ...D UPD
        ...Q
        ..I 'TPP D BLD^FHDCR11 D UPD Q
        .I NBR,TPP D PRT^FHMTK1C Q
        .D:NBR PRT^FHDCR1C
        ;
OUTALL  K ^TMP($J,"D")   ;reset/clean-up tmp global outpatient process.
        ;process outpatient data
        ;next recurring
        F FHK1=FHD1:0 S FHK1=$O(^FHPT("RM",FHK1)) Q:(FHK1'>0)!(FHK1>FHD2)  D
        .F FHDFN=0:0 S FHDFN=$O(^FHPT("RM",FHK1,FHDFN)) Q:FHDFN'>0  D
        ..F FHKD=0:0 S FHKD=$O(^FHPT("RM",FHK1,FHDFN,FHKD)) Q:FHKD'>0  D
        ...S FHKDAT=^FHPT(FHDFN,"OP",FHKD,0)
        ...S (W1,FHW1)=$P(FHKDAT,U,3)
        ...S FHRMB=$P(FHKDAT,U,18)
        ...S FHDIET=$P(FHKDAT,U,2),FHMEAL=$P(FHKDAT,U,4),FHDCLP=$P(FHKDAT,U,14),FHSTAT=$P(FHKDAT,U,15),FHDRMLE=$P(FHKDAT,U,16)
        ...S:FHDIET="" FHDIET=$E(FHKDAT,7,11)
        ...I (FHMEALSA'="A"),(FHMEAL'=FHMEALSA) Q
        ...I FHSTAT="C" Q
        ...I UPD,FHDCLP'="",FHDRMLE="" Q
        ...I UPD,FHDCLP'="",FHDRMLE'="",FHDCLP>FHDRMLE Q
        ...I $G(FHW1SAV),(FHW1'=FHW1SAV) Q
        ...I $G(FHDFNSAV),(FHDFN'=FHDFNSAV) Q
        ...S FHLOC="",FHRGS="OP"
        ...Q:'$G(FHW1)
        ...S:$D(^FH(119.6,FHW1,0)) FHLOC=$P(^FH(119.6,FHW1,0),U,8)
        ...I $G(FHFHPSAV),$G(FHLOC),(FHFHPSAV'=FHLOC) Q
        ...S FHDFN1=$P(^FHPT(FHDFN,0),U,1)
        ...I $G(FHW1SAV)!($G(FHFHPSAV)) D OUTW Q
        ...I $G(FHDFNSAV) D OUTP Q
        ...D OUTW
        ;next guest
        F FHKD=FHD1:0 S FHKD=$O(^FHPT("GM",FHKD)) Q:(FHKD'>0)!(FHKD>FHD2)  D
        .F FHDFN=0:0 S FHDFN=$O(^FHPT("GM",FHKD,FHDFN)) Q:FHDFN'>0  D
        ..S FHKDAT=^FHPT(FHDFN,"GM",FHKD,0)
        ..S (W1,FHW1)=$P(FHKDAT,U,5)
        ..S FHSTAT=$P(FHKDAT,U,9),FHDCLP=$P(FHKDAT,U,8)
        ..Q:FHSTAT="C"
        ..I UPD,FHDCLP'="" Q
        ..S FHRMB=$P(FHKDAT,U,11)
        ..S FHDIET=$P(FHKDAT,U,6),FHMEAL=$P(FHKDAT,U,3)
        ..I (FHMEALSA'="A"),(FHMEAL'=FHMEALSA) Q
        ..I $G(FHW1SAV),(FHW1'=FHW1SAV) Q
        ..I $G(FHDFNSAV),(FHDFN'=FHDFNSAV) Q
        ..S FHLOC="",FHRGS="GM"
        ..Q:'$G(FHW1)
        ..S:$D(^FH(119.6,FHW1,0)) FHLOC=$P(^FH(119.6,FHW1,0),U,8)
        ..I $G(FHFHPSAV),$G(FHLOC),(FHFHPSAV'=FHLOC) Q
        ..S FHDFN1=$P(^FHPT(FHDFN,0),U,1)
        ..I $G(FHW1SAV)!($G(FHFHPSAV)) D OUTW Q
        ..I $G(FHDFNSAV) D OUTP Q
        ..D OUTW
        ;next SPECIAL
        F FHKD=FHD1:0 S FHKD=$O(^FHPT("SM",FHKD)) Q:(FHKD'>0)!(FHKD>FHD2)  D
        .F FHDFN=0:0 S FHDFN=$O(^FHPT("SM",FHKD,FHDFN)) Q:FHDFN'>0  D
        ..S FHKDAT=^FHPT(FHDFN,"SM",FHKD,0)
        ..S (W1,FHW1)=$P(FHKDAT,U,3)
        ..S FHRMB=$P(FHKDAT,U,13)
        ..S FHDFN1=$P(^FHPT(FHDFN,0),U,1)
        ..S FHDIET=$P(FHKDAT,U,4),FHMEAL=$P(FHKDAT,U,9),FHSTAT=$P(FHKDAT,U,2),FHDCLP=$P(FHKDAT,U,11)
        ..I (FHMEALSA'="A"),(FHMEAL'=FHMEALSA) Q
        ..I (FHSTAT="C")!(FHSTAT="D") Q
        ..I UPD,FHDCLP'="" Q
        ..I $G(FHW1SAV),(FHW1'=FHW1SAV) Q
        ..I $G(FHDFNSAV),(FHDFN'=FHDFNSAV) Q
        ..S FHLOC="",FHRGS="SM"
        ..Q:'$G(FHW1)
        ..S:$D(^FH(119.6,FHW1,0)) FHLOC=$P(^FH(119.6,FHW1,0),U,8)
        ..I $G(FHFHPSAV),$G(FHLOC),(FHFHPSAV'=FHLOC) Q
        ..S FHDFN1=$P(^FHPT(FHDFN,0),U,1)
        ..I $G(FHW1SAV)!($G(FHFHPSAV)) D OUTW Q
        ..I $G(FHDFNSAV) D OUTP Q
        ..D OUTW
        ;
        K ^TMP($J,"MP"),^TMP($J,0),MM,PP,S S X9="",NBR=0 F  S X9=$O(^TMP($J,"D",X9)) Q:X9=""  S FHX6=$G(^(X9)) S FHDFN=$P(FHX6,"^",1),ADM=$P(FHX6,"^",2) D
        .S RM=$S(SORT="R":$P(X9,"~",2),1:$P(X9,"~",3)) S SP=FHS
        .S FHDFN=$P(FHX6,"^",1),FHRGS=$P(FHX6,"^",2)
        .D PATNAME^FHOMUTL
        .S FHKD=$P(FHX6,"^",3),W1=$P(FHX6,"^",4)
        .Q:$G(FHRGS)!('$G(FHKD))
        .S FHSTAT="",FHADM=FHKD
        .S FHKDAT=$G(^FHPT(FHDFN,""_FHRGS_"",FHKD,0))
        .I FHRGS="GM" S W1=$P(FHKDAT,U,5),FHDIET=$P(FHKDAT,U,6),FHMEAL=$P(FHKDAT,U,3)
        .I FHRGS="OP" S W1=$P(FHKDAT,U,3),FHDIET=$P(FHKDAT,U,2),FHMEAL=$P(FHKDAT,U,4),FHSTAT=$P(FHKDAT,U,15)
        .I FHRGS="SM" S W1=$P(FHKDAT,U,3),FHDIET=$P(FHKDAT,U,4),FHMEAL=$P(FHKDAT,U,9),FHSTAT=$P(FHKDAT,U,2)
        .;don't process IF STATUS IS cancelled or denied
        .I (FHSTAT="C")!(FHSTAT="D") Q
        .S K1=$G(^FH(119.6,+W1,0)),WRDN=$P(K1,"^",1),SP=$P(K1,"^",5),SP1=$P(K1,"^",6),FHPAR=$P(K1,"^",24)
        .I 'SP Q:FHPAR'="Y"  S SP=SP1 Q:'SP
        .I TPP D  Q
        ..I 'MFLG,'ADM D OUT^FHDCR1D,@FHRGS Q
        ..F MEAL="B","N","E" D:'ADM OUT^FHDCR1D
        ..D:'ADM @FHRGS
        .I 'TPP,'ADM D OUT^FHDCR11 D @FHRGS Q
        I NBR,TPP D PRT^FHMTK1C Q
        D:NBR PRT^FHDCR1C
        Q
        ;
UPD     ; Update Date/Time Diet Card was Printed
        S $P(^FHPT(FHDFN,"A",ADM,0),"^",16)=TIM Q
OUTP    ;process outpatient using patient
        S RM="***"
        S K1=$G(^FH(119.6,+W1,0)),WRDN=$P(K1,"^",1),SP=$P(K1,"^",5),SP1=$P(K1,"^",6),FHPAR=$P(K1,"^",24)
        I 'SP Q:FHPAR'="Y"  S SP=SP1 Q:'SP
        K PP,S,MM S NBR=0,FHADM=FHKD I $G(FHRMB),$D(^DG(405.4,FHRMB,0)) S RM=$P(^DG(405.4,FHRMB,0),U,1)
        I 'TPP D OUT^FHDCR11 D:NBR @FHRGS,PRT^FHDCR1C K ^TMP($J,"MP"),^TMP($J,0),PP,S,TT,SRT Q
        I 'MFLG D OUT^FHDCR1D D:NBR @FHRGS,PRT^FHMTK1C Q
        F MEAL="B","N","E" D OUT^FHDCR1D
        D @FHRGS
        D:NBR PRT^FHMTK1C
        Q
OP      S $P(^FHPT(FHDFN,"OP",FHKD,0),"^",14)=TIM Q
GM      S $P(^FHPT(FHDFN,"GM",FHKD,0),"^",8)=TIM Q
SM      S $P(^FHPT(FHDFN,"SM",FHKD,0),"^",11)=TIM Q
        ;
OUTW    ;process outpatient using all and ward.
        ;F FHDFN=0:0 S FHDFN=$O(^FHPT("AW",W1,FHDFN)) Q:FHDFN<1  D
        D PATNAME^FHOMUTL
        S (RM,RMB)="***"
        I $G(FHRMB),$D(^DG(405.4,FHRMB,0)) S RMB=$P(^DG(405.4,FHRMB,0),U,1)
        I SORT="A" S RM=FHPTNM,DL=0
        E  S (RI,RE,DL)="***",RM=RMB
        S ^TMP($J,"D",DL_"~"_RM_"~"_$S(SORT="R":FHDFN,1:RMB)_FHMEAL)=FHDFN_"^"_FHRGS_"^"_FHKD_"^"_W1
        Q
