GMRVUTL ;HIRMFO/RM,MD-CALLABLE ENTRY POINTS FOR PROGRAMMER UTILITIES ;12/7/90
 ;;4.0;Vitals/Measurements;;Apr 25, 1997
EN1 ; CALL TO CONVERT TEMPERATURE (F) IN VARIABLE X TO TEMPERATURE (C)
 ; IN VARIABLE Y
 S Y=$J(X-32*5/9,0,1)
 Q
EN2 ; CALL TO CONVERT AN INCHES MEASUREMENT IN X TO A CENTIMETER 
 ; MEASUREMENT IN Y
 S Y=$J(2.54*X,0,2)
 Q
EN3 ; CALL TO CONVERT A WEIGHT (LBS) IN VARIABLE X TO A WEIGHT (KG)
 ; IN VARIABLE Y
 S Y=$J(X/2.2,0,2)
 Q
EN4 ; CALL TO RETURN PATIENTS LATEST WEIGHT READING
 ; PATIENT DEFINED BY DFN, WEIGHT RETURNED IN X
 Q:'$D(DFN)  S X="",GMRVIT=$O(^GMRD(120.51,"B","WEIGHT",0)) I GMRVIT'>0 K GMRVIT Q
 F GMRX=0:0 S GMRX=$O(^GMR(120.5,"AA",DFN,GMRVIT,GMRX)) Q:GMRX'>0!(X'="")  F GMRY=0:0 S GMRY=$O(^GMR(120.5,"AA",DFN,GMRVIT,GMRX,GMRY)) Q:GMRY'>0  D
 . I $S('$D(^GMR(120.5,GMRY,2)):1,$P(^(2),"^")="":1,1:0) S X=$S($D(^(0))&($P(^(0),"^",8)>0):$P(^(0),"^",8),1:"")
 K GMRVIT,GMRX,GMRY,GMRZ
 Q
 ;Q
EN6 ; ENTRY TO GET LATEST PATIENT VITAL/MEASURMENT DATA
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
 S GMRVSTR("TDA")=$O(^GMRD(120.51,"C",GMRVSTR,0)) G Q6:GMRVSTR("TDA")'>0
 F GMRVSTR("R")=0:0 S GMRVSTR("R")=$O(^GMR(120.5,"AA",DFN,GMRVSTR("TDA"),GMRVSTR("R"))) Q:GMRVSTR("R")'>0!(X'="")  D C6
Q6 K GMRVSTR
 Q
C6 ;
 F GMRVSTR("IEN")=0:0 S GMRVSTR("IEN")=$O(^GMR(120.5,"AA",DFN,GMRVSTR("TDA"),GMRVSTR("R"),GMRVSTR("IEN"))) Q:GMRVSTR("IEN")'>0  I $S('$D(^GMR(120.5,GMRVSTR("IEN"),2)):1,'$P(^(2),"^"):1,1:0) D
 . S X=$S($D(^(0))&($P(^(0),"^",8)>0):^(0),1:"")
 . F GMRVSTR("QUAL")=0:0 S GMRVSTR("QUAL")=$O(^GMR(120.5,GMRVSTR("IEN"),5,GMRVSTR("QUAL"))) Q:GMRVSTR("QUAL")'>0  S X(GMRVSTR("QUAL"))=$G(^GMRD(120.52,+^GMR(120.5,GMRVSTR("IEN"),5,GMRVSTR("QUAL"),0),0))
 Q
