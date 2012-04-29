VEPER7S2 ;DOQ-IT HL7 Segment generation routine ; 10/11/05 10:22am
 ;;1.0;VOE;;Nov 16, 2005
 ;
OBXCPT(OBXC) ;
 ;
 ; OBXC - Observation Record Count
 ;
 N REC
 S REC="",OBXC=OBXC+1
 S $P(REC,"|")=OBXC ;SEQUENCE NUMBER
 S OBCODE=$G(VOBX(9000010.18,XAMIEN,.01))
 S OBTXT=$G(VOBX(9000010.18,XAMIEN,.04))
 S $P(REC,"|",3)=OBCODE_"^"_OBTXT_"^C4" ;Observation ID List Code & Sys
 S $P(REC,"|",11)="F"
 S X=$G(VOBX(9000010.18,XAMIEN,.03)),X=$P(X,"@"),%DT="T" I X="" S X=VISITDT
 D ^%DT   ;get date
 S $P(REC,"|",14)=$P($$FMTHL7^XLFDT(Y),"-") ;Observation Date
 S $P(REC,"|",16)=PRIPHN ;Physician Upin
 W "OBX|"_REC
 W !
 Q
 ;
 ;
OBX(OBXC) ;
 ;
 ; OBXC - Observation Record Count
 ;
 N REC,FILENUM,OBCODE,CODSYS
 S REC="",OBCODE="",CODSYS="SNM"
 S FILENUM=$S(EXAM="XAM":9000010.13,EXAM="PED":9000010.16,EXAM="HF":9000010.23,1:"")
 I FILENUM="" Q
 S OBTEXT=$G(VOBX(FILENUM,XAMIEN,.01))
 ;
 ;***CBF***Since the DOQ-IT HL7 tables are not present in VOE, manual mapping was done to properly set this segment.
 ;                      As new exams, patient education topics and health factors are added, this section must be updated.  If the
 ;                      tables are eventually added, this section can be modified appropriately.
 ;
 I EXAM="XAM" S OBCODE=$S(OBTEXT["FOOT PULSE":21224004,OBTEXT["FOOT VISUAL":385954004,OBTEXT["FOOT":385954004,OBTEXT["EYE":282096008,1:"")
 I EXAM="PED" S OBCODE=$S(OBTEXT["HTN":39155009,OBTEXT["CESSATION":384742004,1:311401005)
 I EXAM="PED" S OBTEXT=$S(OBCODE=39155009:"HYPERTENSION EDUCATION",OBCODE=384742004:"SMOKING CESSATION ASSISTANCE",1:"PATIENT EDUCATION")
 I EXAM="HF" S OBCODE=$S(OBTEXT["SMOKELESS":81703003,OBTEXT["CHEWING":81703003,OBTEXT["SMOKE I":229819007,1:"")
 I EXAM="HF" I OBCODE="" S OBCODE=$S(OBTEXT["SMOKER":65568007,OBTEXT["SMOKING":229819007,1:"")
 I EXAM="HF" I OBCODE="" S OBCODE=$S(OBTEXT="HF-MI IMAGING EF FIRST PASS":41466009,OBTEXT="HF-VENT EF PROB TECH":46258004,1:"")
 I EXAM="HF" I OBCODE="" S OBCODE=$S(OBTEXT="HF-CARDIAC EF":70822001,OBTEXT="LEFT VENT EF":250908004,1:"")
 I EXAM="HF" I OBCODE="" S OBCODE=$S(OBTEXT="HF-NORM LV SYST DYS WALL MOTION":371857005,OBTEXT="HF-NO EVIDENCE LV SYST DYS FUNCTION":395172009,1:"")
 I EXAM="HF" S OBTEXT=$S(OBCODE=81703003:"CHEWS TOBACCO",OBCODE=229819007:"TOBACCO USE AND EXPOSURE",OBCODE=65568007:"CIGARETTE SMOKER",1:OBTEXT)
 I EXAM="HF" I OBTEXT["PATIENT REASON"!(OBTEXT["PHYSICIAN REASON") S OBCODE=$E(OBTEXT,1,4),CODSYS="IFMC"
 I OBCODE="" K REC Q
 S OBXC=OBXC+1
 S $P(REC,"|")=OBXC ;SEQUENCE NUMBER
 I CODSYS'="IFMC" S $P(REC,"|",2)="ST" ;Observation Value Type
 S $P(REC,"|",3)=OBCODE_"^"_OBTEXT_"^"_CODSYS ;Observation ID List Code & Sys
 I CODSYS'="IFMC" I EXAM="XAM" S $P(REC,"|",5)=$G(VOBX(FILENUM,XAMIEN,.04)) ;Observation Value
 I CODSYS'="IFMC" I EXAM="HF" S $P(REC,"|",5)=$G(VOBX(FILENUM,XAMIEN,.04))
 I CODSYS'="IFMC" I EXAM="PED" S $P(REC,"|",5)=$G(VOBX(FILENUM,XAMIEN,.06))
 I $P(REC,"|",2)="ST" I $P(REC,"|",5)="" S $P(REC,"|",5)="NONE"
 S $P(REC,"|",6)="" ;Observation Units
 S $P(REC,"|",11)="F"
 S X=$G(VOBX(FILENUM,XAMIEN,.03)) I X="" S X=VISITDT
 S X=$P(X,"@"),%DT="T" D ^%DT
 S $P(REC,"|",14)=$P($$FMTHL7^XLFDT(Y),"-") ;Observation Date
 S $P(REC,"|",16)=PRIPHN ;Physician Upin
 W "OBX|"_REC
 W !
 Q
 ;
 ;
OBXVITAL(OBXC) ;
 ;
 ; OBXC - Observation Record Count
 ;
 N REC
 S REC="",OBXC=OBXC+1
 S $P(REC,"|")=OBXC ;SEQUENCE NUMBER
 S $P(REC,"|",2)="ST" ;Observation Value Type
 S $P(REC,"|",3)=OBCODE_"^"_OBTXT_"^SNM" ;Observation ID List Code & Sys
 S $P(REC,"|",5)=OBVALUE ;Observation Value
 S $P(REC,"|",6)=OBID ;Observation Units - IDENTIFIER^TEXT
 S X=$G(VOBX(120.5,XAMIEN,.01)),X=$P(X,"@"),%DT="T" I X="" S X=VISITDT
 D ^%DT   ;get date
 S $P(REC,"|",11)="F"
 S $P(REC,"|",14)=$P($$FMTHL7^XLFDT(Y),"-") ;Observation Date
 S $P(REC,"|",16)=PRIPHN ;Physician Upin
 W "OBX|"_REC
 W !
 Q
 ;
 ;
OBXLABS(OBXC) ;
 ;
 ; OBXC - Observation Record Count
 ;
 N REC,VOELAB,VOEOBX3,VOEOBX31,VOEOBX32 S (REC,VOELAB,VOEOBX3,VOEOBX31,VOEOBX32)=""
 F  S VOELAB=$O(^VOELABS(VOELAB)) Q:'VOELAB  D
 . I $P($G(^VOELABS(VOELAB)),"|")'="OBX" Q
 . S VOEOBX3=$P($G(^VOELABS(VOELAB)),"|",4)
 . S VOEOBX31=$P(VOEOBX3,"^")
 . I VOEOBX31'["-" Q
 . S VOEOBX32="^"_$P(VOEOBX3,"^",2)_"^LN"
 . S OBXC=OBXC+1
 . S $P(REC,"|")=OBXC ;SEQUENCE NUMBER
 . S $P(REC,"|",2)="ST" ;Observation Value Type
 . S $P(REC,"|",3)=VOEOBX31_VOEOBX32 ;Observation ID List Code & Sys
 . S $P(REC,"|",5)=$P($G(^VOELABS(VOELAB)),"|",6) ;Observation Value
 . S $P(REC,"|",6)=$P($G(^VOELABS(VOELAB)),"|",7) ;Observation Units
 . S $P(REC,"|",11)="F"
 . S $P(REC,"|",14)=$P($$FMTHL7^XLFDT(DTTM),"-") ;Observation Date
 . S $P(REC,"|",16)=PRIPHN ;Physician Upin REUSE PRIPHN - NOT PERFECT, BUT OKAY
 . W "OBX|"_REC
 . W !
 Q
 ;
 ;
