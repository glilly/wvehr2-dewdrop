ONCOCOM ;Hines OIFO/GWB - 'COMPUTED-FIELD' expressions; 06/23/10
        ;;2.11;ONCOLOGY;**1,6,11,12,13,14,16,17,19,25,36,42,43,44,46,47,48,51**;Mar 07, 1995;Build 65
        ;
SDA     ;List all primaries for a patient
        S XD0=$P(^ONCO(165.5,D0,0),U,2) G CX
        ;
SDP     ;List all primaries except current primary
        S XD0=$P(^ONCO(165.5,D0,0),U,2) G:XD0="" EX
        N J S J=0
        F XD1=0:0 S XD1=$O(^ONCO(165.5,"C",XD0,XD1)) Q:XD1'>0  I $$DIV^ONCFUNC(XD1)=DUZ(2),$D(^ONCO(165.5,XD1,0)),XD1'=D0 S J=J+1 D ^ONCOCOML
        G:J>0 EX W ?24,"None" G EX
        ;
SDD     ;List all primaries for a patient 
        Q:'$D(^ONCO(160,D0))  S XD0=D0
CX      ;Entry point with XD0 defined, not D0
        N J,XD1 W !
        S J=0,XD1=0 F  S XD1=$O(^ONCO(165.5,"C",XD0,XD1)) Q:XD1'>0  I $D(^ONCO(165.5,XD1,0)),$$DIV^ONCFUNC(XD1)=DUZ(2) S J=J+1 D ^ONCOCOML
        Q
        ;
CLS     ;CLass of Case (ANALYTIC/NON-ANALYTIC)
        ;Computed field (165.5, .042) CASE-CLASS
        S XD0=D0,X=$S($D(^ONCO(165.5,XD0,0)):$P(^(0),U,4),1:""),X=$S(X="":"",X<23:"Analytic",1:"Non-Analytic")
        K XD0 Q
        ;
DFC     ;'COMPUTED-FIELD' EXPRESSION for FIRST COURSE OF TREATMENT DATE (165.5,49)
        I '$D(^ONCO(165.5,"ATX",D0)) S X="" Q
        S TDT=0 F  S TDT=$O(^ONCO(165.5,"ATX",D0,TDT)) Q:TDT=""  Q:($E(TDT,1,7)'="0000000")&($E(TDT,1,7)'=9999999)&($E(TDT,1,7)'=8888888)&($E(TDT,8,9)'="S2")&($E(TDT,8,9)'="S3")
        I TDT="" S TDT=0 F  S TDT=$O(^ONCO(165.5,"ATX",D0,TDT)) Q:TDT=""  Q:$E(TDT,1,7)=9999999
        I TDT="" S TDT=0 F  S TDT=$O(^ONCO(165.5,"ATX",D0,TDT)) Q:TDT=""  Q:$E(TDT,1,7)="0000000"
        I TDT="" S TDT="9999999X"
        S X=$E(TDT,1,7)
        D DATEOT^ONCOES
        K TDT Q
        ;
DSTS    ;DATE SYSTEMIC TREATMENT STARTED (165.5,152)
        S DSTS=""
        K DSTSDT
        S X=$$GET1^DIQ(165.5,D0,53,"I") I X'="" S DSTSDT(X)=""
        S X=$$GET1^DIQ(165.5,D0,54,"I") I X'="" S DSTSDT(X)=""
        S X=$$GET1^DIQ(165.5,D0,55,"I") I X'="" S DSTSDT(X)=""
        S X=$$GET1^DIQ(165.5,D0,153.1,"I") I X'="" S DSTSDT(X)=""
        S DSTS=0 F  S DSTS=$O(DSTSDT(DSTS)) Q:DSTS=""  Q:($E(DSTS,1,7)'="0000000")&($E(DSTS,1,7)'=9999999)
        I DSTS="" S DSTS=0 F  S DSTS=$O(DSTSDT(DSTS)) Q:DSTS=""  Q:$E(DSTS,1,7)=9999999
        I DSTS="" S DSTS=0 F  S DSTS=$O(DSTSDT(DSTS)) Q:DSTS=""  Q:$E(DSTS,1,7)="0000000"
        S X=DSTS
        D DATEOT^ONCOES
        K DSTS,DSTSDT
        Q
        ;
DD      ;Y=date in FM format (2yrmoda); convert to da/mo/yr
        S Y=$S(Y="":"",1:$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_(1700+$E(Y,1,3))) ;_$S(Y#1:" "_$E(Y_0,9,10)_":"_$E(Y_"0000",11,12),1:"")
        Q
        ;
AGE     ;AGE AT DIAGNOSIS
        S DOD=$P(^ONCO(165.5,D0,0),U,16)
        I DOD="" S AGE="" G AGEOUT
        I ($E(DOD,1,3)="000")!($E(DOD,1,3)=888)!($E(DOD,1,3)=999) S AGE=999 G AGEOUT
        S XD0=D0,D0=$P(^ONCO(165.5,XD0,0),U,2) D DOB1^ONCOES S DOB=X,D0=XD0
        I DOB="" S AGE="" G AGEOUT
        S AGE=$E(DOD,1,3)-$E(DOB,1,3)-($E(DOD,4,7)<$E(DOB,4,7))
        ;
AGEOUT  S X=AGE K DOD,XD0,DOB,AGE
        Q
        ;
DEC     ;AGE DX DECADE
        D AGE Q:X=""  S AG=X,X=$S(AG<20:"0-20",AG<30:"20-29",AG<40:"30-39",AG<50:"40-49",AG<60:"50-59",AG<70:"60-69",AG<80:"70-79",1:"80-99")
        K AG Q
XD0     S XD0=$S($D(^ONCO(165.5,D0,0)):$P(^(0),U,2),1:"") ;XD0=internal 160
        Q
        ;
PID     ;PATIENT NAME,SSN,DOB
        S X="" D PAT G EX:OD0="" S ONCONM=$P(VP0,U),SN=$P(VP0,U,9),XD=$P(VP0,U,3),ONCOPID=$E(ONCONM)_$E(SN,6,9)
        Q
SID     ;PID# (A1234)
PID5    S XD0=$P(^ONCO(165.5,D0,0),U,2) D PAT,PID S X=$E(ONCONM)_$E(SN,6,9) G EX
        ;
PID0    S XD0=D0 D PAT,PID S X=$E(ONCONM)_$E(SN,6,9) G EX
        ;
MS      ;Derive MARITAL STATUS AT DX (165.5,11) from MARITAL STATUS (2,.05)
        S XD0=$P(^ONCO(165.5,D0,0),U,2) G:XD0="" EX
        D PAT G:OD0="" EX
        S MS=$P(VP0,U,5) G:MS="" ADX
        S MC=+MS
        S X1=$S(MC=3:1,MC=6:1,MC=2:2,MC=5:3,MC=1:4,MC=4:5,1:9)
        S $P(^ONCO(165.5,D0,1),U,5)=X1
        ;
ADX     ;Derive PATIENT ADDRESS AT DX (165.5,8) from STREET ADDRESS 1 (2,.111)
        ;Derive PATIENT ADDRESS AT DX (165.5,8) from STREET ADDRESS [LINE 1]
        ;(2,.111) and STREET ADDRESS [LINE 2] (2,.112)
        ;Derive PATIENT ADDRESS AT DX - SUPP (165.5,8.2) from STREET ADDRESS
        ;[LINE 3] (2,.113)
        ;Derive CITY/TOWN AT DX (165.5,8.1) from CITY (2,.114)
        ;Derive STATE AT DX (165.5,16) from STATE (2,.115)
        ;Derive POSTAL CODE AT DX (165.5,9) from ZIP CODE (2,.116)
        ;Derive COUNTY AT DX (165.5,10) from STATE (2,.116)_COUNTY (2,.117)
        S X11=$G(@(GLR_".11)"))
        S ADX=$P(X11,U,1)
        S:$P(X11,U,2)'="" ADX=ADX_" "_$P(X11,U,2)
        S ADXSUPP=$P(X11,U,3)
        S $P(^ONCO(165.5,D0,1),U,1)=ADX
        S $P(^ONCO(165.5,D0,1),U,13)=ADXSUPP
        S CITY=$P(X11,U,4)
        S STATE=$P(X11,U,5)
        S ZIP=$P(X11,U,6)
        S COUNTYPNT=$P(X11,U,7)
        S COUNTY=""
        I STATE'="",COUNTYPNT'="" S COUNTY=$P(^DIC(5,STATE,1,COUNTYPNT,0),U,3)
        S:CITY'="" $P(^ONCO(165.5,D0,1),U,12)=CITY
        S:STATE'="" $P(^ONCO(165.5,D0,1),U,4)=STATE
        S:ZIP'="" $P(^ONCO(165.5,D0,1),U,2)=ZIP
        S:(STATE'="")&(COUNTY'="") $P(^ONCO(165.5,D0,1),U,3)=STATE_COUNTY
        K ADX,ADXSUPP,CITY,COUNTY,COUNTYPNT,GLR,MS,OD0,OF,STATE,VP0,VPR,X1,X11
        K XD0,ZIP
        Q
        ;
PAT     ;Patient pointer
        S OD0=$S($D(^ONCO(160,XD0,0)):$P(^(0),U),1:"") Q:OD0=""
        S OF=$P(OD0,";",2)
        S OD0=$P(OD0,";",1)
        S GLR=U_OF_OD0_","
        S VPR=U_OF_OD0_",0)"
        S VP0=$S($D(@VPR):^(0),1:"")
        Q
        ;
ONCPRI  ;ICD0-TOPOGRAPHY LIST (160,49)
        S XD0=0
        F  S XD0=$O(^ONCO(165.5,"C",D0,XD0)) Q:XD0'>0  I $$DIV^ONCFUNC(XD0)=DUZ(2) D
        .Q:'$D(^ONCO(165.5,XD0,2))
        .S TOPIEN=$P(^ONCO(165.5,XD0,2),U,1)
        .Q:TOPIEN=""
        .S TOPNAME=$P(^ONCO(164,TOPIEN,0),U,1)
        .S TOPCODE=$P(^ONCO(164,TOPIEN,0),U,2)
        .S TOP(TOPCODE)=TOPNAME
        I $D(TOP) S TOPCODE="" W ! F  S TOPCODE=$O(TOP(TOPCODE)) Q:TOPCODE=""  W ?5,TOP(TOPCODE),!
        S X="" K XD0,TOPIEN,TOP,TOPCODE Q
ACOS    ;'COMPUTED-FIELD' EXPRESSION for ACOS # (165.5,67)
        S OSP=$O(^ONCO(160.1,"C",DUZ(2),0))
        I OSP="" S OSP=$O(^ONCO(160.1,0))
        S ACOS=$P(^ONCO(160.1,OSP,0),U,4)
        S ACOS=$$GET1^DIQ(160.19,ACOS,.01,"I")
        S X=ACOS K OSP,ACOS
        Q
        ;
HM      ;'COMPUTED-FIELD' EXPRESSION for HISTO-MORPHOLOGY (165.5,27)
        N MO,GRADE
        S X=""
        S MO=$$GET1^DIQ(165.5,D0,22.3,"I")
        I MO'="" D
        .S GRADE=$$GET1^DIQ(165.5,D0,24,"I")
        .S X=$E(MO,1,4)_"/"_$E(MO,5)_GRADE
        Q
        ;
ET      ;'COMPUTED-FIELD' EXPRESSION for ELAPSED DAYS TO COMPLETION (165.5,157)
        N AS,DATE1,DATE2
        S AS=$P($G(^ONCO(165.5,D0,7)),U,2)
        I AS="A" S X="NA (Accession only)" Q
        S DATE1=$P($G(^ONCO(165.5,D0,7)),U,1)
        S DATE2=$P($G(^ONCO(165.5,D0,0)),U,35)
        I (DATE2="")!(DATE2="0000000")!(DATE2=9999999) S X="Unknown (No Date of First Contact)" Q
        I (DATE1="")!(DATE1="0000000")!(DATE1=9999999)!(DATE1=8888888) S X="Unknown (No Date Case Completed)" Q
        I DATE1<DATE2 S X="Unknown (Dt 1st Cont > Dt Case Complt)" Q
        S X1=DATE1
        S X2=DATE2
        D ^%DTC
        I %Y=0 S X="Unknown (Dates imprecise)" Q
        Q
        ;
EM      ;'COMPUTED-FIELD' EXPRESSION for ELAPSED MONTHS TO COMPLETION (165.5,157.1)
        N AS,DATE1,DATE2
        S AS=$P($G(^ONCO(165.5,D0,7)),U,2)
        I AS="A" S X="NA (Accession only)" Q
        S DATE1=$P($G(^ONCO(165.5,D0,7)),U,1),DAYS1=$E(DATE1,6,7)
        S DATE2=$P($G(^ONCO(165.5,D0,0)),U,35),DAYS2=$E(DATE2,6,7)
        I (DATE2="")!(DATE2="0000000")!(DATE2=9999999) S X="Unknown (No Date of First Contact)" Q
        I (DATE1="")!(DATE1="0000000")!(DATE1=9999999)!(DATE1=8888888) S X="Unknown (No Date Case Completed)" Q
        I DATE1<DATE2 S X="Unknown (Dt 1st Cont > Dt Case Complt)" Q
        D DTDIFF^ONCDTUTL(DATE1,DATE2,.DAYS,.MONTHS,.YEARS)
        S MONTHYEAR=YEARS*12
        S X=MONTHS+MONTHYEAR
        S:+DAYS2>+DAYS1 X=X+1
        ;S X=YEARS_$S(YEARS=1:" Year/",1:" Years/")_MONTHS_$S(MONTHS=1:" Month/",1:" Months/")_DAYS_$S(DAYS=1:" Day",1:" Days")
        Q
        ;
DCD     ;INPUT TRANSFORM for DATE OF CONCLUSIVE DX (165.5,193)
        N DCDX,X1,X2,%Y
        S DCDX=X
        S X2=$P($G(^ONCO(165.5,D0,0)),U,16)
        S X1=X
        I (X2="")!(X2="0000000")!(X2=8888888)!(X2=9999999) Q
        I X2>X1 W !!,"DATE DX after DATE OF CONCLUSIVE DX",! K X Q
        D ^%DTC
        I %Y=0 G DCDEX
        I X<61 W !!," DATE OF CONCLUSIVE DX must be greater than 60 days after DATE DX",! K X Q
DCDEX   S X=DCDX
        Q
        ;
EX      ;Exit
        K OD0,X1,X2,XD0,XD1,VP0,Y
        Q
        ;
CLEANUP ;Cleanup
        K D0,DAYS,DAYS1,DAYS2,MC,MONTHS,MONTHYEAR,ONCONM,ONCOPID,SN,TOPNAME,XD
        K YEARS
