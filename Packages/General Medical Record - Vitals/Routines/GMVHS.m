GMVHS ;HIOFO/FT-RETURN PATIENT DATA UTILITY ;6/10/05  11:32
 ;;5.0;GEN. MED. REC. - VITALS;**3**;Oct 31, 2002
 ;
 ; This routine uses the following IAs:
 ; #10040 - FILE 44 references     (supported)
 ; #10104 - ^XLFSTR calls          (supported)
 ;
 ; This routine supports the following IAs:
 ; EN1 - 4791                       (private)
 ;
EN1 ; Entry to gather patients vital/measurment data
 ; Input variables
 ;
 ;     DFN = Entry number of patient in Patient file. (Required)
 ; GMRVSTR = types of vital/measurments desired.  Use the abbreviations
 ;           found in the Vital Type (120.51) file.  For multiple
 ;           vitals, use the ; as a delimiter. (Required)
 ; GMRVSTR(0) = GMRVSTDT^GMRVENDT^GMRVOCC^GMRVSORD
 ;         where GMRVSTDT = The start date/time that the utility will
 ;                          use in obtaining patient data.  (Required)
 ;               GMRVENDT = The end date/time that the utility will use
 ;                          to stop the search.  (Required)
 ;               GMRVOCC  = The number of occurrences of the data that
 ;                          is desired by the search.  (Required)
 ;               GMRVSORD = The sort order desired in output. 0 will sort 
 ;                          the data by vital type, then by date/time entered.
 ;                          1 will sort the data by date/time entered, then by 
 ;                          vital type. (REQUIRED)
 ; GMRVSTR("LT") = ^TYP1^[TYP2^...]  (OPTIONAL)
 ;         THIS VARIABLE IS AN ^ DELIMITED LIST OF HOSPITAL LOCATION
 ;         TYPES TO EXTRACT MEASUREMENT DATA FOR.  E.G., ^C^M^, WILL
 ;         EXTRACT DATA FOR ONLY THOSE MEASUREMENTS TAKEN ON CLINICS
 ;         OR MODULES.
 ;
 ; Output variables:
 ;
 ; The utility will create an array with the desired information.  The
 ; array structure will be as follows if '$P(GMRVSTR,"^",4):
 ;      ^UTILITY($J,"GMRVD",GMRVTYP,GMRVRDT,GMRVIEN)=GMRVDATA
 ; or if $P(GMRVSTR,"^",4) then the following will be returned:
 ;      ^UTILITY($J,"GMRVD",GMRVRDT,GMRVTYP,GMRVIEN)=GMRVDATA
 ; where GMRVRDT  = Reverse FileMan date/time.
 ;                  9999999-Date/time vital/measurement was taken.
 ;       GMRVTYP  = The abbreviation used in the GMRVSTR string for the
 ;                  type of vital/measurment taken.
 ;       GMRVIEN  = Entry number in file Vital/Measurement (120.5) file.
 ;       
 ;       $P(GMRVDATA,"^",1) = date/time of the reading (FileMan internal) 
 ;       $P(GMRVDATA,"^",2) = Patient (#2) number (i.e., DFN) 
 ;       $P(GMRVDATA,"^",3) = vital type ien (File 120.51) 
 ;       $P(GMRVDATA,"^",4) = date/time of data entry (FileMan internal) 
 ;       $P(GMRVDATA,"^",5) = hospital location ien (File 44) 
 ;       $P(GMRVDATA,"^",6) = user ien (File 200) 
 ;       $P(GMRVDATA,"^",7) = always null 
 ;       $P(GMRVDATA,"^",8) = reading (e.g., 98.6, Unavailable) 
 ;       $P(GMRVDATA,"^",9) = always null
 ;       $P(GMRVDATA,"^",10) = the first qualifier
 ;       $P(GMRVDATA,"^",11) = the second qualifier
 ;       $P(GMRVDATA,"^",12)= "*" for abnormal measurement, otherwise = ""
 ;       $P(GMRVDATA,"^",13)= values in centigrade for T; kilos for WT; 
 ;                            centimeters for HT and Circumference/Girth;
 ;                            and mmHg for CVP
 ;       $P(GMRVDATA,"^",14)= Body Mass Index
 ;       $P(GMRVDATA,"^",15)= L/Min of supplemental O2
 ;       $P(GMRVDATA,"^",16)= % of supplemental O2
 ;       $P(GMRVDATA,"^",17)= all qualifiers delimited by semi-colons
 ; The variable GMRVSTR will be killed upon exit.
 ;
 Q:'$D(GMRVSTR(0))!'($D(GMRVSTR)#2)!'($D(DFN)#2)
 Q:DFN'>0
 I $G(GMRVSTR("LT"))="" S GMRVSTR("LT")="" ;hospital location list
HSKPING ; Housekeeping
 K ^UTILITY($J,"GMRVD")
 N GMVABNML,GMVDATA,GMVEND,GMVHTIEN,GMVIEN,GMVLOOP,GMVMAX,GMVNODE,GMVOCC,GMVRATE,GMVSORD,GMVSTART,GMVTIEN,GMVTYPE,GMVWTIEN
 D RANGE
 F GMVLOOP=1:1:$L(GMRVSTR,";") D
 .S GMVTYPE=$P(GMRVSTR,";",GMVLOOP)
 .Q:GMVTYPE=""
 .S GMVMAX(GMVTYPE)=0
 .Q
 S GMVOCC=$P(GMRVSTR(0),U,3) ;max # of occurrences
 S GMVSORD=$P(GMRVSTR(0),U,4) ;sort order
 S GMVWTIEN=$$GETTYPEI("WT"),GMVHTIEN=$$GETTYPEI("HT")
 F GMRVSTR(1)=1:1:$L(GMRVSTR,";") S GMVTYPE=$P(GMRVSTR,";",GMRVSTR(1)) I $L(GMVTYPE) S GMVSTART=$S($P(GMRVSTR(0),"^",2):9999999-$P(GMRVSTR(0),"^",2)-.0000001,1:0),GMVEND=9999999-$P(GMRVSTR(0),"^"),GMRVSTR("O")=0 D GETDATE
 K GMRVSTR
 Q
GETDATE ; Loop thru AA xref
 S GMVTIEN=$O(^GMRD(120.51,"C",GMVTYPE,0)) ;vital type ien
 Q:'GMVTIEN
 S GMVLOOP=GMVSTART
 F  S GMVLOOP=$O(^GMR(120.5,"AA",DFN,GMVTIEN,GMVLOOP)) Q:GMVLOOP>GMVEND!(GMVLOOP'>0)  D GETNODE Q:GMVMAX(GMVTYPE)>GMVOCC
 Q
GETNODE ; Get patient record
 S GMVIEN=0
 F  S GMVIEN=$O(^GMR(120.5,"AA",DFN,GMVTIEN,GMVLOOP,GMVIEN)) Q:GMVIEN'>0!(GMVMAX(GMVTYPE)>GMVOCC)  I '$P($G(^GMR(120.5,+GMVIEN,2)),U) D
 .S GMVNODE=$G(^GMR(120.5,+GMVIEN,0))
 .Q:GMVNODE=""!($P(GMVNODE,U,8)="")
 .I $L(GMRVSTR("LT")) Q:$P(GMVNODE,U,5)'>0  Q:GMRVSTR("LT")'[("^"_$$GET1^DIQ(44,$P(GMVNODE,U,5)_",",2,"I")_"^")  ;hospital location check
 .;max # of occurrence check needed
 .S GMVMAX(GMVTYPE)=GMVMAX(GMVTYPE)+1
 .S GMVRATE=$P(GMVNODE,U,8)
 .D ZERONODE
 .D QUALS
 .I GMVTYPE="PO2" D PO2($P(GMVNODE,U,10))
 .D METRIC
 .D:$P(GMVNODE,U,3)=GMVWTIEN BMI ;calculate BMI for weight
 .D:$$TEXT(GMVRATE) ABNORMAL
 .D SET
 .Q
 Q
GETTYPEI(GMVTIEN) ; Return vital type (120.51) ien
 ; GMVTIEN = vital type abbreviation
 S GMVTIEN=$G(GMVTIEN)
 I GMVTIEN="" Q 0
 Q $O(^GMRD(120.51,"C",GMVTIEN,0))
 ;
ZERONODE ; Get zero node data
 S GMVDATA=$P($G(GMVNODE),U,1,8)_"^^^^^^^^^"
 Q
QUALS ; Get qualifiers for record
 N GMVQCNT,GMVQIEN,GMVQLIST,GMVQUALS
 S (GMVQCNT,GMVQIEN)=0,GMVQLIST=""
 F  S GMVQIEN=$O(^GMR(120.5,GMVIEN,5,"B",GMVQIEN)) Q:'GMVQIEN  D
 .S GMVQCNT=GMVQCNT+1
 .S GMVQUALS(GMVQCNT)=$P($G(^GMRD(120.52,+GMVQIEN,0)),U,1)
 .Q
 I $D(GMVQUALS(1)) S $P(GMVDATA,U,10)=GMVQUALS(1)
 I $D(GMVQUALS(2)) S $P(GMVDATA,U,11)=GMVQUALS(2)
 I $O(GMVQUALS(0)) D
 .S GMVQCNT=0
 .F  S GMVQCNT=$O(GMVQUALS(GMVQCNT)) Q:'GMVQCNT  D
 ..S GMVQLIST=GMVQLIST_GMVQUALS(GMVQCNT)_";"
 ..Q
 .Q
 I $G(GMVQLIST)]"" D
 .S GMVQLIST=$E(GMVQLIST,1,$L(GMVQLIST)-1)
 .S $P(GMVDATA,U,17)=GMVQLIST
 .Q
 Q
PO2(X) ; Get flow rate and liters/minute for Pulse Oximetry reading
 N GMVCONC,GMVFLOW
 S (GMVFLOW,GMVCONC)=""
 I X["%" D
 .S GMVCONC=$P(X,"%")
 .I GMVCONC["l/min" S GMVCONC=$P(GMVCONC,"l/min",2)
 I X["l/min" D
 .S GMVFLOW=$P(X,"l/min")
 .I GMVFLOW["%" S GMVFLOW=$P(GMVFLOW,"%",2)
 S GMVFLOW=$$STRIP^XLFSTR(GMVFLOW," ")
 S GMVCONC=$$STRIP^XLFSTR(GMVCONC," ")
 S $P(GMVDATA,U,15)=GMVFLOW
 S $P(GMVDATA,U,16)=GMVCONC
 Q
METRIC ; Calculate metric value for temperature, height, weight and
 ; circumference/girth
 N GMVMETRC
 S GMVMETRC=""
 Q:'$$TEXT(GMVRATE)  ;quit if not a numeric reading
 I GMVTYPE="T" D
 .S GMVMETRC=$J(GMVRATE-32*5/9,0,1)
 .Q
 I GMVTYPE="HT" D
 .S GMVMETRC=$J(2.54*GMVRATE,0,2)
 .Q
 I GMVTYPE="WT" D
 .S GMVMETRC=$J(GMVRATE*.45359237,0,2)
 .Q
 I GMVTYPE="CG" D
 .S GMVMETRC=$J(2.54*GMVRATE,0,2)
 .Q
 I GMVTYPE="CVP" D
 .S GMVMETRC=$J(GMVRATE/1.36,0,2)
 .Q
 I GMVMETRC]"" S $P(GMVDATA,U,13)=GMVMETRC
 Q
ABNORMAL ; Is reading outside of normal range?
 N GMVASTRK,GMVDIA,GMVSYS
 S GMVASTRK=""
 I GMVTYPE="T" D
 .S:GMVRATE>$P(GMVABNML("T"),U,1) GMVASTRK="*"
 .S:GMVRATE<$P(GMVABNML("T"),U,2) GMVASTRK="*"
 .Q
 I GMVTYPE="P" D
 .S:GMVRATE>$P(GMVABNML("P"),U,1) GMVASTRK="*"
 .S:GMVRATE<$P(GMVABNML("P"),U,2) GMVASTRK="*"
 .Q
 I GMVTYPE="R" D
 .S:GMVRATE>$P(GMVABNML("R"),U,1) GMVASTRK="*"
 .S:GMVRATE<$P(GMVABNML("R"),U,2) GMVASTRK="*"
 .Q
 I GMVTYPE="BP" D
 .S GMVSYS=$P(GMVRATE,"/",1)
 .S GMVDIA=$S($P(GMVRATE,"/",3)="":$P(GMVRATE,"/",2),1:$P(GMVRATE,"/",3))
 .S:GMVSYS>$P(GMVABNML("BP"),U,7) GMVASTRK="*"
 .S:GMVSYS<$P(GMVABNML("BP"),U,9) GMVASTRK="*"
 .S:GMVDIA>$P(GMVABNML("BP"),U,8) GMVASTRK="*"
 .S:GMVDIA<$P(GMVABNML("BP"),U,10) GMVASTRK="*"
 .Q
 I GMVTYPE="CVP" D
 .S:GMVRATE>$P(GMVABNML("CVP"),U,1) GMVASTRK="*"
 .S:GMVRATE<$P(GMVABNML("CVP"),U,2) GMVASTRK="*"
 .Q
 I GMVTYPE="PO2" D
 .S:GMVRATE<$P(GMVABNML("PO2"),U,2) GMVASTRK="*"
 .Q
 S $P(GMVDATA,U,12)=GMVASTRK
 Q
BMI ; Calculate Body Mass Index
 N GMVBMI
 S GMVBMI=""
 S GMVBMI=$$CALCBMI^GMVHS1(GMVNODE,GMVLOOP)
 S $P(GMVDATA,U,14)=GMVBMI
 Q
SET ; Set UTILITY($J,"GMRVD") node
 S:'GMVSORD ^UTILITY($J,"GMRVD",GMVTYPE,GMVLOOP,GMVIEN)=GMVDATA
 S:GMVSORD ^UTILITY($J,"GMRVD",GMVLOOP,GMVTYPE,GMVIEN)=GMVDATA
 Q
TEXT(RATE) ; Is rate a text code?
 ; Returns 0 if RATE has a text code and 1 if a numeric reading
 N GMVYES
 S RATE=$G(RATE),GMVYES=1
 I "REFUSEDPASSUNAVAILABLE"[$$UP^XLFSTR(RATE) S GMVYES=0
 Q GMVYES
 ;
RANGE ; Find normal ranges and store in array
 N GMVPIEN,GMVPNODE
 S GMVABNML("T")="0^0" ;high^low
 S GMVABNML("P")="0^0" ;high^low
 S GMVABNML("R")="0^0" ;high^low
 S GMVABNML("CVP")="0^0" ;high^low
 S GMVABNML("PO2")="0^0" ;low
 S GMVABNML("BP")="0^0^0^0" ;sys high^sys low^dia high^dia low
 S GMVPIEN=$O(^GMRD(120.57,0))
 Q:'GMVPIEN
 S GMVPNODE=$G(^GMRD(120.57,GMVPIEN,1))
 S GMVABNML("T")=$P(GMVPNODE,U,1)_U_$P(GMVPNODE,U,2)
 S GMVABNML("P")=$P(GMVPNODE,U,3)_U_$P(GMVPNODE,U,4)
 S GMVABNML("R")=$P(GMVPNODE,U,5)_U_$P(GMVPNODE,U,6)
 S GMVABNML("BP")=$P(GMVPNODE,U,7)_U_$P(GMVPNODE,U,9)_U_$P(GMVPNODE,U,8)_U_$P(GMVPNODE,U,10)
 S GMVABNML("CVP")=$P(GMVPNODE,U,11)_U_$P(GMVPNODE,U,12)
 S GMVABNML("PO2")=""_U_$P(GMVPNODE,U,13)
 Q
