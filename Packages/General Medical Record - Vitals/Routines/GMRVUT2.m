GMRVUT2 ;HIOFO/YH,RM,FT-ENTRY TO GATHER PATIENT VITAL/MEASURMENT DATA ;10/3/07
        ;;5.0;GEN. MED. REC. - VITALS;**23**;Oct 31, 2002;Build 25
        ;
        ; This routine uses the following IAs:
        ;  #1246 - WIN^DGPMDDCF         (supported)
        ;  #4290 - ^PXRMINDX global     (controlled)
        ; #10040 - FILE 44 references   (supported)
        ;
BP      ;ENTRY TO GATHER PATIENT BLOOD PRESSURE/PULSE DATA
        N GMVCLIO
        K ^UTILITY($J,GMRVSTR("T"))
        S (GDT,GMRVSTR("TMO"))=0,GMRVSTR("R")=GMRVSTR("E")
        F  S GMRVSTR("R")=$O(^PXRMINDX(120.5,"PI",DFN,GMRVSTR("TDA"),GMRVSTR("R")),-1) Q:GMRVSTR("R")<GMRVSTR("B")!(GMRVSTR("R")'>0)  D  Q:GMRVSTR("TMO")
        .S GMRVSTR("IEN")=0
        .F  S GMRVSTR("IEN")=$O(^PXRMINDX(120.5,"PI",DFN,GMRVSTR("TDA"),GMRVSTR("R"),GMRVSTR("IEN"))) Q:$L(GMRVSTR("IEN"))'>0  D
        ..S GDT(1)=9999999-$$STRIP100(9999999-GMRVSTR("R")) I GDT'=GDT(1) S GDT=GDT(1),GMRVSTR("O")=$G(GMRVSTR("O"))+1
        ..I GMRVSTR("O")>$P(GMRVSTR(0),"^",3) S GMRVSTR("TMO")=1 Q
        ..S ^UTILITY($J,GMRVSTR("T"),GDT,GMRVSTR("IEN"))=""
        ..Q
        .Q
        S GMRVSTR("R")=0
        F  S GMRVSTR("R")=$O(^UTILITY($J,GMRVSTR("T"),GMRVSTR("R"))) Q:GMRVSTR("R")'>0  S GMRVSTR("IEN")=0 F  S GMRVSTR("IEN")=$O(^UTILITY($J,GMRVSTR("T"),GMRVSTR("R"),GMRVSTR("IEN"))) Q:$L(GMRVSTR("IEN"))'>0  D
        .I GMRVSTR("IEN")=+GMRVSTR("IEN") D
        ..D F1205^GMVUTL(.GMVCLIO,GMRVSTR("IEN"))
        ..Q
        .I GMRVSTR("IEN")'=+GMRVSTR("IEN") D
        ..D CLIO^GMVUTL(.GMVCLIO,GMRVSTR("IEN"))
        ..Q
        .S GMVCLIO(0)=$G(GMVCLIO(0)),GMVCLIO(5)=$G(GMVCLIO(5))
        .I GMVCLIO(0)=""!($P(GMVCLIO(0),U,8)="") Q
        .D SETU2
        .Q
        K ^UTILITY($J,GMRVSTR("T")),GDT
        Q
STRIP100(DATE)  ; This procedure takes DATE and returns that date with
        ; any fractional seconds stripped off.
        Q +($P(DATE,".")_+$E("."_$P(DATE,".",2),1,7))
        ;
SETU2   ; Given the IEN of entry GMRVSTR("IEN") this procedure will set the
        ; extract global.  <<< IA 1447 - NURSING >>>
        N GG,GMVLOOP,GMVQNAME,GMVRECORDID
        S GDATA=$P($G(GMVCLIO(0))_"^^^^^^^^^^^^^","^",1,17)
        S GMRVX(1)=0 ; fix for Remedy 116911
        I GMRVSTR("T")'="CVP",$P(GDATA,"^",8)="" Q
        I GMRVSTR("T")="CVP",+$P(GDATA,"^",8)=0,$E($P(GDATA,"^",8))'="0" Q
        S (GMRINF(1),GMRINF(2))="",GMRINF=$P(GDATA,"^",10)
        I GMRINF'="" D PO2^GMRVLGQU(.GMRINF) S $P(GDATA,"^",15)=GMRINF(1),$P(GDATA,"^",16)=GMRINF(2)
        I $L($G(GMRVSTR("LT"))) Q:$P(GDATA,"^",5)'>0  Q:GMRVSTR("LT")'[("^"_$$GET1^DIQ(44,$P(GDATA,"^",5)_",",2,"I")_"^")
        I GMRVSTR("T")'="BP",GMRVSTR("T")'="P" S GMRVSTR("O")=$G(GMRVSTR("O"))+1,GMRVSTR("TMO")=$S('$P(GMRVSTR(0),"^",3):0,GMRVSTR("O")<$P(GMRVSTR(0),"^",3):0,1:1)
        S GMRVX=GMRVSTR("T"),GMRVX(0)=$P(GDATA,"^",8) D:GMRVX(0)>0 EN1^GMRVSAS0 S $P(GDATA,"^",12)=$S($G(GMRVX(1))>0:"*",1:"")
        S X=GMRVX(0) I X>0 D EN1^GMRVUTL:GMRVSTR("T")="T",EN2^GMRVUTL:GMRVSTR("T")="HT",EN3^GMRVUTL:GMRVSTR("T")="WT" S:GMRVSTR("T")="T"!(GMRVSTR("T")="HT")!(GMRVSTR("T")="WT") $P(GDATA,"^",13)=$S($D(Y):Y,1:"")
        I GMRVSTR("T")="CG" S $P(GDATA,"^",13)=$J(GMRVX(0)/.3937,0,2)
        I GMRVSTR("T")="CVP" S $P(GDATA,"^",13)=$J(GMRVX(0)/1.36,0,1)
        I GMRVSTR("T")="WT",$G(Y)>0 S GMRBMI="",GMRBMI(1)=$P(GDATA,"^"),GMRBMI(2)=+$P(GDATA,"^",8) D CALBMI^GMRVBMI(.GMRBMI) S $P(GDATA,"^",14)=GMRBMI K GMRBMI
        S (GG,GMRSITE,GMRQUAL)=""
        F GMVLOOP=1:1 Q:$P(GMVCLIO(5),U,GMVLOOP)=""  D
        .S GMVQNAME=$$FIELD^GMVGETQL($P(GMVCLIO(5),U,GMVLOOP),1,"E")
        .I GMVQNAME=""!(GMVQNAME=-1) Q
        .S GG=GG_$S(GG="":"",1:";")_GMVQNAME
        .Q
        S GMRSITE=$P(GG,";",1),GMRQUAL=$P(GG,";",2)
        S $P(GDATA,"^",10)=GMRSITE,$P(GDATA,"^",11)=GMRQUAL,$P(GDATA,"^",17)=$G(GG)
        S GMVRECORDID=GMRVSTR("IEN")
        I GMRVSTR("IEN")'=+GMRVSTR("IEN") D
        .S GMVIENGUID=GMVIENGUID+1
        .S GMVRECORDID=GMVIENGUID
        S ^UTILITY($J,"GMRVD",$S('$P(GMRVSTR(0),"^",4):GMRVSTR("T"),1:9999999-GMRVSTR("R")),$S('$P(GMRVSTR(0),"^",4):9999999-GMRVSTR("R"),1:GMRVSTR("T")),GMVRECORDID)=$$STRIP100($P(GDATA,"^"))_"^"_$P(GDATA,"^",2,99)
        Q
INACT42(GMWLOC) ; THIS PROCEDURE WILL CALL SUPPORTED ENTRY POINT WIN^DGPMDDCF
        ; TO DETERMINE IF WARD LOCATION (GMWLOC) IS INACTIVE.
        N X,D0,DGPMOS
        S D0=GMWLOC D WIN^DGPMDDCF
        Q X
        ;QUALIFY ;OBTAIN QUALIFIERS FOR VITAL MEASUREMENT  <<< CALLED FROM SETU2 ABOVE>>
        ;K GMRVARY S GMRVARY=""
        ;I $P($G(^GMR(120.5,+GMRVSTR("IEN"),5,0)),"^",4)>0 D CHAR^GMRVCHAR(+GMRVSTR("IEN"),.GMRVARY,GMRVSTR("TDA")) S GMRSITE=$O(GMRVARY(+GMRVSTR("IEN"),1,"")),GMRQUAL=$O(GMRVARY(+GMRVSTR("IEN"),2,""))
        ;K GG S GG="" I $O(GMRVARY(0)) D
        ;. S GG(1)=0 F  S GG(1)=$O(GMRVARY(GG(1))) Q:GG(1)'>0  S GG(2)=0 F  S GG(2)=$O(GMRVARY(GG(1),GG(2))) Q:GG(2)'>0  S GG(3)="" F  S GG(3)=$O(GMRVARY(GG(1),GG(2),GG(3))) Q:GG(3)=""  S GG=GG_$S(GG="":"",1:";")_GG(3)
        ;I GMRVSTR("T")'="P" Q
        ;I GMRSITE="" S GMRSITE=GMRQUAL,GMRQUAL="" Q
        ;I GMRQUAL="" Q
        ;S GMRSITE=GMRSITE_" "_GMRQUAL,GMRQUAL=""
        ;Q
