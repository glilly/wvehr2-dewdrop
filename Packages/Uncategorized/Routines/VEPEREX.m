VEPEREX  ; MRM/DAOU - Computed findings for DOQIT extracts. ; 6/4/05 1:58pm
 ;;2.0;CLINICAL REMINDERS;;Feb 04, 2005
 ;
 ;======================================================
VISIT(DFN,NGET,BDAT,EDT,NFOUND,TEST,DATE,DATA,TEXT) ;
 ; Check to see if the patient has 2 or more visits after 18th
 ; birthday and diagnosis.
 N FIELDS,PAT,DOB,NAM,YR18,ALL,ERR,N,IDX,DAT
 S FIELDS=".01;.03"
 D GETS^DIQ(2,DFN,FIELDS,"I","PAT")
 S DOB=PAT(2,DFN_",",.03,"I")
 ;The calculation is to determine that the visit occurs on or
 ;after the 18th bithday.
 S YR18=DOB+180000-1
 D LIST^DIC(9000010,,"","I",,,,,,,"ALL(1)","ERR")
 I $D(ERR) S TEST(1)=0 Q
 S N="",IDX=0 F  S N=$O(ALL(1,"DILIST","ID",N)) Q:(N="")!(IDX=NGET)  D
 . Q:ALL(1,"DILIST","ID",N,.05)'=DFN
 . S DAT=ALL(1,"DILIST",1,N)
 . Q:YR18>DAT!(DAT<BDAT)!(DAT>EDT)
 . S IDX=IDX+1,DATA(IDX)=ALL(1,"DILIST",2,N),TEST(IDX)=1,DATE(IDX)=DAT
 . Q
 S NFOUND=IDX S:'IDX TEST(1)=0
 Q
 ;
CADPAT(DFN,TEST,DATE,DATA,TEXT) ;
 ;Check to see if patient registered with DOQ-IT
 N TYPE,FIELD
 S TYPE="CAD",FIELD=.02 D PATREG
 Q
 ;
DMPAT(DFN,TEST,DATE,DATA,TEXT) ;
 ;Check to see if patient is registered for diabetes (DM) diagnosis
 ;DOQIT topic.
 N TYPE,FIELD
 S TYPE="DM",FIELD=.03 D PATREG
 Q
 ;
PCPAT(DFN,TEST,DATE,DATA,TEXT) ;
 N TYPE,FIELD
 S TYPE="PC",FIELD=.06 D PATREG
 Q
 ;
HTNPAT(DFN,TEST,DATE,DATA,TEXT) ;
 ;Chck to see if patient is registered for hypertension (HTN)
 ;diagnosis DOQIT topic.
 N TYPE,FIELD
 S TYPE="HTN",FIELD=.04 D PATREG
 Q
 ;
HFPAT(DFN,TEST,DATE,DATA,TEXT) ;
 ;Check to see if a patient is registered for a heart failure (HF)
 ;diagnosis DOQIT topic.
 N TYPE,FIELD
 S TYPE="HF",FIELD=.05 D PATREG
 Q
PATREG ;Get DOQ-IT registration or cancelation for clients.
 S DATE=DT
 D GETS^DIQ(19904.4,DFN,FIELD,"I","ARY","ERR")
 I $D(ERR) S TEST=0,TEXT=$G(ERR("DIERR",1,"TEXT",1)) Q
 S TEST=$S(ARY(19904.4,DFN_",",FIELD,"I")="R":1,1:0)
 S DATA="",TEXT=""
 Q
CADLIST(NGET,BDT,EDT,PLIST,PARAM) ;
 N TYPE,FIELD
 S TYPE="CAD",FIELD=".01;.02" D PATLIST
 Q
HTNLIST(NGET,BDT,EDT,PLIST,PARAM) ;
 N TYPE,FIELD
 S TYPE="HTN",FIELD=".01;.04" D PATLIST
 Q
DMLIST(NGET,BDT,EDT,PLIST,PARAM) ;
 N TYPE,FIELD
 S TYPE="DM",FIELD=".01;.03" D PATLIST
 Q
HFLIST(NGET,BDT,EDT,PLIST,PARAM) ;
 N TYPE,FIELD
 S TYPE="HF",FIELD=".01;.05" D PATLIST
 Q
PCLIST(NGET,BDT,EDT,PLIST,PARAM) ;
 N TYPE,FIELD
 S TYPE="PC",FIELD=".01;.06" D PATLIST
 Q
PATLIST ;LIST OF PATIENTS REGISTERED FOR A PARTICULAR DIAGNOSIS
 N ALL,ERR
 S FLD=$P(FIELD,";",2)
 D LIST^DIC(19904.4,,FIELD,"I",,,,,,,"ALL(1)","ERR")
 I $D(ERR) S NGET=0 Q
 S IDX=0,NGET=0
 F  S IDX=$O(ALL(1,"DILIST","ID",IDX)) Q:IDX=""  D:($G(ALL(1,"DILIST","ID",IDX,FLD))'="")
 . S NGET=NGET+1,DFN=ALL(1,"DILIST","ID",IDX,.01)
 . S ^TMP($J,PLIST,DFN,1)="^^19904.4^.02^"_ALL(1,"DILIST","ID",IDX,FLD)
 Q
