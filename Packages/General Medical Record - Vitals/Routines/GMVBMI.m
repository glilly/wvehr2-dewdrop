GMVBMI  ;HIOFO/YH,FT-EXTRACT HEIGHT TO CALCULATE BMI FOR WEIGHT; 5/9/07
        ;;5.0;GEN. MED. REC. - VITALS;**3,23**;Oct 31, 2002;Build 25
        ;
        ; This routine uses the following IAs:
        ; <None>
        ;
HT      ;OBTAIN ALL HEIGHTS FOR THE PATIENT
        ; DFN MUST BE DEFINED
        K GHEIGHT
        S GH=0,GI=$O(^GMRD(120.51,"B","HEIGHT",0))
        Q:GI'>0
        F  S GH=$O(^PXRMINDX(120.5,"PI",DFN,GI,GH)) Q:GH'>0  S GH(1)=0 F  S GH(1)=$O(^PXRMINDX(120.5,"PI",DFN,GI,GH,GH(1))) Q:$L(GH(1))'>0  D
        .I GH(1)=+GH(1) D  ;VITALS RECORD
        ..I $D(^GMR(120.5,GH(1),0)),'$D(^GMR(120.5,GH(1),2)),$P(^GMR(120.5,GH(1),0),U,8)'="" D
        ...I $P(^GMR(120.5,GH(1),0),U,8)>0 S GHEIGHT($P(^GMR(120.5,GH(1),0),U,1))=$P(^GMR(120.5,GH(1),0),U,8)
        ...Q
        ..Q
        .I GH(1)'=+GH(1) D
        ..N GMVCLIO
        ..D CLIO^GMVUTL(.GMVCLIO,GH(1))
        ..Q:$P(GMVCLIO(0),U,1)=""
        ..Q:$P(GMVCLIO(0),U,8)'>0
        ..I $P(GMVCLIO(0),U,8)>0 S GHEIGHT($P(GMVCLIO(0),U,1))=$P(GMVCLIO(0),U,8)
        ..Q
        .Q
        Q
CALBMI(GBMI,GMVDEC)     ;OBTAIN HEIGHT TO CALCULATE BMI
        ; GBMI(1)=DATE/TIME WEIGHT WAS TAKEN
        ; GBMI(2)=WEIGHT
        ; GMVDEC = # of decimal places to return (optional)
        ;          Can have 0, 1, 2, or 3.
        ;          Default is 2.
        N GDATE,GMRVHT
        S GMRVHT="",GMVDEC=$G(GMVDEC,2)
        S GMVDEC=$S(GMVDEC=3:3,GMVDEC=1:1,GMVDEC=0:0,1:2)
        D HT
        I '$D(GHEIGHT) K GHEIGHT,GI,GH Q
        ;HEIGHT AND WEIGHT WERE OBTAINED AT THE SAME TIME
        I $D(GHEIGHT(GBMI(1))) D  K GHEIGHT,GH,GI Q
        .S GBMI(2)=GBMI(2)/2.2,GMRVHT=+GHEIGHT(GBMI(1))*2.54/100
        .I +GMRVHT'>0 S GBMI=$J(0,0,0) Q
        .S GBMI=$J(GBMI(2)/(GMRVHT*GMRVHT),0,GMVDEC) S GBMI=GBMI_$S(GBMI>27:"*",1:"")
        ;EXTRACT THE HEIGHT TAKEN BEFORE THE WEIGHT WAS TAKEN
        S GDATE=GBMI(1),GDATE(1)=0
        F  S GDATE=$O(GHEIGHT(GDATE),-1) Q:GDATE'>0!(GDATE(1)>0)  D
        .S GDATE(1)=GDATE
        I GDATE(1)>0,$D(GHEIGHT(GDATE(1))) D  K GHEIGHT,GH,GI Q
        .S GMRVHT=+GHEIGHT(GDATE(1))
        .S GBMI(2)=GBMI(2)/2.2,GMRVHT=GMRVHT*2.54/100
        .I +GMRVHT'>0 S GBMI=$J(0,0,0) Q
        .S GBMI=$J(GBMI(2)/(GMRVHT*GMRVHT),0,GMVDEC),GBMI=GBMI_$S(GBMI>27:"*",1:"")
        ;EXTRACT THE HEIGHT TAKEN AFTER THE WEIGHT WAS TAKEN
        S GDATE=GBMI(1),GDATE(1)=0
        F  S GDATE=$O(GHEIGHT(GDATE)) Q:GDATE'>0!(GDATE(1)>0)  S GDATE(1)=GDATE
        I GDATE(1)>0 D  K GHEIGHT,GH,GI,G Q
        .S GMRVHT=+GHEIGHT(GDATE(1))
        .S GBMI(2)=GBMI(2)/2.2,GMRVHT=GMRVHT*2.54/100
        .I +GMRVHT'>0 S GBMI=$J(0,0,0) Q
        .S GBMI=$J(GBMI(2)/(GMRVHT*GMRVHT),0,GMVDEC),GBMI=GBMI_$S(GBMI>27:"*",1:"")
        K GHEIGHT,GI,GH,G
        Q
