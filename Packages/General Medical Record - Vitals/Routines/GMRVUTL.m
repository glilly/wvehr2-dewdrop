GMRVUTL ;HIOFO/RM,MD,FT-CALLABLE ENTRY POINTS FOR PROGRAMMER UTILITIES ;5/8/07
        ;;5.0;GEN. MED. REC. - VITALS;**23**;Oct 31, 2002;Build 25
        ;
        ; This routine uses the following IAs:
        ;  #4290 - ^PXRMINDX global     (controlled)
        ;
EN1     ; CALL TO CONVERT TEMPERATURE (F) IN VARIABLE X TO TEMPERATURE (C)
        ; IN VARIABLE Y
        S Y=$J(X-32*5/9,0,1)
        Q
EN2     ; CALL TO CONVERT AN INCHES MEASUREMENT IN X TO A CENTIMETER 
        ; MEASUREMENT IN Y
        S Y=$J(2.54*X,0,2)
        Q
EN3     ; CALL TO CONVERT A WEIGHT (LBS) IN VARIABLE X TO A WEIGHT (KG)
        ; IN VARIABLE Y
        S Y=$J(X/2.2,0,2)
        Q
        ;EN4 ; CALL TO RETURN PATIENT'S LATEST WEIGHT READING
        ; PATIENT DEFINED BY DFN, WEIGHT RETURNED IN X
        ;Q:'$D(DFN)  S X="",GMRVIT=$O(^GMRD(120.51,"B","WEIGHT",0)) I GMRVIT'>0 K GMRVIT Q
        ;F GMRX=0:0 S GMRX=$O(^GMR(120.5,"AA",DFN,GMRVIT,GMRX)) Q:GMRX'>0!(X'="")  F GMRY=0:0 S GMRY=$O(^GMR(120.5,"AA",DFN,GMRVIT,GMRX,GMRY)) Q:GMRY'>0  D
        ;. I $S('$D(^GMR(120.5,GMRY,2)):1,$P(^(2),"^")="":1,1:0) S X=$S($D(^(0))&($P(^(0),"^",8)>0):$P(^(0),"^",8),1:"")
        ;K GMRVIT,GMRX,GMRY,GMRZ
        ;Q
        ;Q
EN6     ; ENTRY TO GET LATEST PATIENT VITAL/MEASUREMENT DATA <IA 1120 - SUPPORTED>
        ; INPUT VARIABLES:
        ;    DFN = Patient IEN  (REQUIRED)
        ;    GMRVSTR = Abbreviation of vital type in Vital Type (120.51) file.
        ;              (REQUIRED)
        ; OUTPUT VARIABLES:
        ;    X = ^GMR(120.5,IEN,0) where IEN is entry number of latest V/M.
        ;    X Global contains qualifiers, for example
        ;      X(1)=R ARM, X(2)=LYING for BP
        ; GMRVSTR will be killed.
        S X="" I '$D(DFN)!'$D(GMRVSTR) Q
        S GMRVSTR("TDA")=$O(^GMRD(120.51,"C",GMRVSTR,0))
        G Q6:GMRVSTR("TDA")'>0
        S GMRVSTR("R")=9999999
        F  S GMRVSTR("R")=$O(^PXRMINDX(120.5,"PI",DFN,GMRVSTR("TDA"),GMRVSTR("R")),-1) Q:GMRVSTR("R")'>0!(X'="")  D C6
Q6      K GMRVSTR
        Q
C6      ;
        N GMVCNT,GMVLOOP,GMVQIEN,GMVTEMP
        F GMRVSTR("IEN")=0:0 S GMRVSTR("IEN")=$O(^PXRMINDX(120.5,"PI",DFN,GMRVSTR("TDA"),GMRVSTR("R"),GMRVSTR("IEN"))) Q:$L(GMRVSTR("IEN"))'>0!(X'="")  D
        .I GMRVSTR("IEN")=+GMRVSTR("IEN") D
        ..D F1205^GMVUTL(.GMVTEMP,+GMRVSTR("IEN"),0)
        ..S X=$G(GMVTEMP(0)),GMVTEMP(5)=$G(GMVTEMP(5))
        ..Q
        .I GMRVSTR("IEN")'=+GMRVSTR("IEN") D 
        ..D CLIO^GMVUTL(.GMVTEMP,GMRVSTR("IEN"))
        ..I '$D(GMVTEMP(0)) Q
        ..S X=GMVTEMP(0),GMVTEMP(5)=$G(GMVTEMP(5))
        ..Q
        .Q
        I X="" Q
        I "REFUSEDPASSUNAVAILABLE"[$$UP^XLFSTR($P(X,U,8)) S X="" Q
        S GMVCNT=0
        F GMVLOOP=1:1 Q:$P(GMVTEMP(5),U,GMVLOOP)=""  D
        .S GMVQIEN=$P(GMVTEMP(5),U,GMVLOOP)
        .I GMVQIEN>0 D
        ..S GMVCNT=GMVCNT+1
        ..S X(GMVCNT)=$G(^GMRD(120.52,+GMVQIEN,0))
        ..Q
        .Q
        Q
