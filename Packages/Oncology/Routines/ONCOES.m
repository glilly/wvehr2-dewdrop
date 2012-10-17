ONCOES  ;Hines OIFO/GWB - ONCOLOGY PATIENT 'COMPUTED-FIELD' EXPRESSIONS ;08/10/00
        ;;2.11;ONCOLOGY;**1,5,6,11,15,16,18,26,27,33,34,35,36,44,46,49,50**;Mar 07, 1995;Build 29
        ;
MNI     ;'COMPUTED-FIELD' EXPRESSION for MIDDLE NAME (160,.015)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S NAME=$$GET1^DIQ(67,PT,.01,"E")
        I $$DPTLRT(D0)="DPT" S NAME=$$GET1^DIQ(2,PT,.01,"E")
        S FNMI=$P(NAME,",",2),MNI=$P(FNMI," ",2)
        I (MNI="JR")!(MNI="JR.")!(MNI="SR")!(MNI="SR.")!(MNI="MD")!(MNI="MD.")!(MNI="NMN")!(MNI="NMN.")!(MNI="NMI")!(MNI="NMI.")!(MNI="II")!(MNI="III")!(MNI="IV") S MNI=""
        I $L(MNI)=2,$E(MNI,2)="." S MNI=$E(MNI,1)
        S X=$E(MNI,1,14)
        G EXIT
        ;
SA1     ;'COMPUTED-FIELD' EXPRESSION for STREET ADDRESS 1 (160,.111)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.111,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.111,"E")
        G EXIT
        ;
SA2     ;'COMPUTED-FIELD' EXPRESSION for STREET ADDRESS 2 (160,.112)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.112,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.112,"E")
        G EXIT
        ;
SA3     ;'COMPUTED-FIELD' EXPRESSION for STREET ADDRESS 3 (160,.113)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.113,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.113,"E")
        G EXIT
        ;
ST      ;'COMPUTED-FIELD' EXPRESSION for STATE (160,.115)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.115,"I")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.115,"I")
        S X=$$GET1^DIQ(5,X,1,"E")
        G EXIT
        ;
ZIP     ;'COMPUTED-FIELD' EXPRESSION for ZIP CODE (160,.116)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.116,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.116,"E")
        G EXIT
        ;
CTY     ;'COMPUTED-FIELD' EXPRESSION for CTY (160,.12) and COUNTY (160,.117)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=""
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.115,"I"),Y=$$GET1^DIQ(2,PT,.117,"I")
        S X=$S(X="":"",Y="":"",1:$P($G(^DIC(5,X,1,Y,0)),U))
        G EXIT
        ;
ZIPCT   ;'COMPUTED-FIELD' EXPRESSION for ZIP-COUNTY (160,.118)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" D
        .S CITY=$$GET1^DIQ(67,PT,.114,"E") S:CITY'="" CITY=CITY_", "
        .S X=$$GET1^DIQ(67,PT,.115,"I")
        .S STATE=$$GET1^DIQ(5,X,1,"E") S:STATE'="" STATE=STATE_" "
        .S ZIP=$$GET1^DIQ(67,PT,.116,"E") S:ZIP'="" ZIP=ZIP_" "
        I $$DPTLRT(D0)="DPT" D
        .S CITY=$$GET1^DIQ(2,PT,.114,"E") S:CITY'="" CITY=CITY_", "
        .S X=$$GET1^DIQ(2,PT,.115,"I")
        .S STATE=$$GET1^DIQ(5,X,1,"E") S:STATE'="" STATE=STATE_" "
        .S ZIP=$$GET1^DIQ(2,PT,.116,"E") S:ZIP'="" ZIP=ZIP_"  "
        .S Y=$$GET1^DIQ(2,PT,.117,"I")
        .S COUNTY=$S(X="":"",Y="":"",1:$P($G(^DIC(5,X,1,Y,0)),U))
        ;S X=CITY_STATE_ZIP_COUNTY
        S X=CITY_STATE_ZIP
        G EXIT
        ;
ADD     ;'COMPUTED-FIELD' EXPRESSION for PATIENT ADDRESS - CURRENT (160,.119)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.111,"E")_" "_$$GET1^DIQ(67,PT,.112,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.111,"E")_" "_$$GET1^DIQ(2,PT,.112,"E")
        S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        G EXIT
        ;
PH      ;'COMPUTED-FIELD' EXPRESSION for TELEPHONE (160,.131)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.131,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.131,"E")
        G EXIT
        ;
ALIAS   ;'COMPUTED-FIELD' EXPRESSION for ALIAS (160,1)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=""
        I $$DPTLRT(D0)="DPT" S ALIAS=0 F  S ALIAS=$O(^DPT(PT,.01,ALIAS)) Q:ALIAS'>0  S X=$P(^DPT(PT,.01,ALIAS,0),U,1)
        G EXIT
        ;
SSN     ;'COMPUTED-FIELD' EXPRESSION' for SSN (160,2)
        S X="",PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.09,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.09,"E")
        I X?9N S X=$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,9)
        G EXIT
        ;
DOB     ;'COMPUTED-FIELD' EXPRESSION for DOB (160,3)
        S X="",PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.03,"I")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.03,"I")
        D DATEOT
        G EXIT
        ;
DOB1    ;DOB (160,3) in internal FileMan format
        S X="",PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.03,"I")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.03,"I")
        G EXIT
        ;
TRM     ;'COMPUTED-FIELD' EXPRESSION for TERMINAL DIGIT (160,4.1)
        S X="",PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.09,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.09,"E")
        I X?9N S X="T"_$E(X,8,9)_$E(X,6,7)_$E(X,4,5)_$E(X,1,3)
        E  S X=""
        G EXIT
        ;
OCC     ;'COMPUTED-FIELD' EXPRESSION for CURRENT OCCUPATION (160,12)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=""
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.07,"E")
        G EXIT
        ;
REL     ;'COMPUTED-FIELD' EXPRESSION for RELIGION (160,13)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.08,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.08,"E")
        G EXIT
        ;
MS      ;'COMPUTED-FIELD' EXPRESSION for MARITAL STATUS (160,14)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,PT,.05,"E")
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.05,"E")
        G EXIT
        ;
EMP     ;'COMPUTED-FIELD' EXPRESSION for EMPLOYMENT STATUS (160,47)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=""
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.31115,"E")
        G EXIT
        ;
BS      ;'COMPUTED-FIELD' EXPRESSION for BRANCH OF SERVICE (160,68)
        S X="" S PT=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=""
        I $$DPTLRT(D0)="DPT" S X=$$GET1^DIQ(2,PT,.325,"E")
        G EXIT
        ;
RACE    ;RACE 1 (160,8) default
        N DFN,VADM
        S X="",DFN=$P($G(^ONCO(160,D0,0)),";",1)
        I $$DPTLRT(D0)="LRT" S X=$$GET1^DIQ(67,DFN,.06,"E") Q
        I $$DPTLRT(D0)="DPT" D DEM^VADPT
        S X=$P($G(VADM(12,1)),U,2)
        I X="" S X=$P($G(VADM(8)),U,2)
        Q
        ;
ENVIRON ;Environmental exposure and service indicator defaults
        ;AGENT ORANGE EXPOSURE       (160,48)
        ;IONIZING RADIATION EXPOSURE (160,50)
        ;PERSIAN GULF SERVICE        (160,51)
        ;LEBANON SERVICE             (160,55)
        ;SOMALIA SERVICE             (160,56)
        ;VIETNAM SERVICE             (160,62)
        ;GRENADA SERVICE             (160,63)
        ;PANAMA SERVICE              (160,64)
        ;YUGOSLAVIA SERVICE          (160,65)
        ;IRAQ (OIF) SERVICE          (160,66)
        ;AFGHANISTAN (OEF) SERVICE   (160,67)
        I $P(^ONCO(160,D0,0),U,1)["LRT(67," D  G EXIT
        .S (AOE,IRE,PGS,SSI,LSI,VSI,GSI,PSI,YSI,OEF,OIF)=""
        S DFN=$P(^ONCO(160,D0,0),";",1)
        S AOE=$$GET1^DIQ(2,DFN,.32102,"E")  ;AGENT ORANGE EXPOS. INDICATED?
        S IRE=$$GET1^DIQ(2,DFN,.32103,"E")  ;RADIATION EXPOSURE INDICATED?
        S PGS=$$GET1^DIQ(2,DFN,.32201,"E")  ;PERSIAN GULF SERVICE?
        S SSI=$$GET1^DIQ(2,DFN,.322016,"E") ;SOMALIA SERVICE INDICATED?
        S LSI=$$GET1^DIQ(2,DFN,.3221,"E")   ;LEBANON SERVICE INDICATED?
        S VSI=$$GET1^DIQ(2,DFN,.32101,"E")  ;VIETNAM SERVICE INDICATED?
        S GSI=$$GET1^DIQ(2,DFN,.3224,"E")   ;GRENADA SERVICE INDICATED?
        S PSI=$$GET1^DIQ(2,DFN,.3227,"E")   ;PANAMA SERVICE INDICATED?
        S YSI=$$GET1^DIQ(2,DFN,.322019,"E") ;YUGOSLAVIA SERVICE INDICATED?
        S (OEF,OIF)="No"
        D SVC^VADPT
        I $G(VASV(11))>0 S OEF="Yes"        ;SERVICE [OEF OR OIF]
        I $G(VASV(12))>0 S OIF="Yes"        ;SERVICE [OEF OR OIF]
        G EXIT
        ;
TLEEOT  ;TUMOR LEVEL-ENDOSCOPIC EXAM (165.5,752) OUTPUT TRANSFORM
        S:$L(Y)=1 Y="0"_Y
        I Y="00" S Y="Endoscopic exam not performed" Q
        I Y=61 S Y="Splenic flexure" Q
        I Y=62 S Y="Transverse colon" Q
        I Y=63 S Y="Hepatic flexure" Q
        I Y=64 S Y="Ascending colon" Q
        I Y=65 S Y="Cecum" Q
        I Y=70 S Y="Endoscopic exam, tumor not visualized" Q
        I Y=80 S Y="Endoscopic exam, results unknown" Q
        I Y=99 S Y="Unknown if exam done" Q
        S Y=Y_" centimeters"
        Q
        ;
ASPIT   ;ADDITIONAL SURGICAL PROCEDURES (165.5,763)INPUT TRANSFORM
        I X<10 K X Q
        I "10^20^30^40^41^42^43^44^50^60^88^99"'[X K X Q
        S Y=X D ASPOT W "  ",Y
        K Y
        Q
        ;
ASPOT   ;ADDITIONAL SURGICAL PROCEDURES (165.5,763) OUTPUT TRANSFORM
        D SETASP
        I Y'="" S Y=ASP(Y)
        K ASP
        Q
        ;
ASPHP   ;ADDITIONAL SURGICAL PROCEDURES (165.5,763) EXECUTABLE HELP
        D SETASP
        F ASPX=0:0 S ASPX=$O(ASP(ASPX)) Q:ASPX'>0  W !,"  ",ASPX,"  ",ASP(ASPX)
        W ! K ASP,ASPX
        Q
        ;
SETASP  ;Build ADDITIONAL SURGICAL PROCEDURES array
        S ASP(10)="Transanal excision"
        S ASP(20)="Posterior sacral"
        S ASP(30)="Anterior resection w/o anastomosis"
        S ASP(40)="Anterior resection w anastomosis, NOS"
        S ASP(41)="Anterior resection w simple anastomosis"
        S ASP(42)="Ant res w colo pouch coloanal anastomosis"
        S ASP(43)="Anterior resection w ilioanal anastomosis"
        S ASP(44)="Anterior resection w coloanal anastomosis"
        S ASP(50)="Colostomy w/o resection"
        S ASP(60)="Abdominoperineal resection (APR)"
        S ASP(88)="NA, none performed"
        S ASP(99)="Unknown if performed"
        Q
        ;
PTRDOT  ;PRIMARY TUMOR RAD DOSE (cGy) (165.5,786) OUTPUT TRANSFORM
        S Y=$S($L(Y)=1:"0000"_Y,$L(Y)=2:"000"_Y,$L(Y)=3:"00"_Y,$L(Y)=4:"0"_Y,1:Y)
        I Y="00000" S Y="No radiation therapy"
        I Y="88888" S Y="Received radiation therapy, dose unknown"
        I Y="99999" S Y="Unknown if received radiation therapy"
        Q
        ;
DPTLRT(D0)      ;Determine if patient resides in PATIENT (2) or REFERRAL PATIENT (67)
        N DPTLRT
        I $P($G(^ONCO(160,D0,0)),U,1)["LRT" S DPTLRT="LRT"
        I $P($G(^ONCO(160,D0,0)),U,1)["DPT" S DPTLRT="DPT"
        Q DPTLRT
        ;
DATEOT  ;Date OUTPUT TRANSFORM
        I X="0000000" D DD Q
        I $E(X,4,5)="00" S $E(X,4,5)=99
        I $E(X,6,7)="00" S $E(X,6,7)=99
        D DD
        Q
        ;
DD      ;Format date values
        S (X,Y)=$S(X="":"",X="0000000":"00/00/0000",X=8888888:"88/88/8888",X=9999999:"99/99/9999",1:$E(X,4,5)_"/"_$E(X,6,7)_"/"_(1700+$E(X,1,3)))
        Q
        ;
EXIT    ;Kill variables
        K ALIAS,CITY,COUNTY,DFN,FNMI,MNI,ONCOX,ONCOX1,NAME,PT,STATE,Z,ZIP
        Q
