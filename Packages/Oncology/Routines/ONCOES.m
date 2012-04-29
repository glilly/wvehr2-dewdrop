ONCOES ;Hines OIFO/GWB - ONCOLOGY PATIENT (160) computed fields ;08/10/00
 ;;2.11;ONCOLOGY;**1,5,6,11,15,16,18,26,27,33,34,35,36,44,46**;Mar 07, 1995;Build 39
 ;
SETUP ;SETUP INITIAL PARAMETERS
 S X="",ONCON=^ONCO(160,D0,0),ONCOX=$P(ONCON,U),ONCOX1="^"_$P(ONCOX,";",2)_+ONCOX_",0)"
 Q
SETUP1 I $D(^ONCO(160,D0,0)) D SETUP S ONCOX1=$P(ONCOX,";",2)_+ONCOX_",.11)",ONCOX1=U_ONCOX1
 Q
SETUP2 I $D(^ONCO(160,D0,0)) D SETUP S ONCOX1=$P(ONCOX,";",2)_+ONCOX_",.13)",ONCOX1=U_ONCOX1
 Q
SETUP3 I $D(^ONCO(160,D0,0)) D SETUP S ONCOX1=$P(ONCOX,";",2)_+ONCOX_",.321)",ONCOX1=U_ONCOX1
 Q
SSN ;SSN (160,2)
 S X="" Q:'$D(^ONCO(160,D0,0))  D SETUP
 S X=$S($D(@ONCOX1):$P(@ONCOX1,U,9),1:"") G:X="" END1
 I X?9N S X=$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,9)
 G END1
 ;
TRM ;TERMINAL DIGIT FILING, TO SORT BY FOR MEDICAL RECORDS
 I $D(^ONCO(160,D0,0)) D SETUP S X=$S($D(@ONCOX1):$P(@ONCOX1,U,9),1:"") I X'="" S X="T"_$E(X,8,9)_$E(X,6,7)_$E(X,4,5)_$E(X,1,3)
 G END1
DOB ;DOB
 I $D(^ONCO(160,D0,0)) D SETUP S X=$S($D(@ONCOX1):$P(@ONCOX1,U,3),1:"")
 D DATEOT S Y=X
 G END1
 ;
RACE ;RACE 1 (160,8) default
 I $D(^ONCO(160,D0,0)) D SETUP
 I ONCOX["DPT" S DFN=$P(ONCOX,";",1) D DEM^VADPT
 S X=$P($G(VADM(12,1)),U,2)
 I X="" S X=$P($G(VADM(8)),U,2)
 G END1
 ;
DATEOT ;Date output transform
 I X="0000000" D DD Q
 I $E(X,4,5)="00" S $E(X,4,5)=99
 I $E(X,6,7)="00" S $E(X,6,7)=99
 D DD
 Q
 ;
DOB1 ;date of birth returned in X in File Manager format
 I $D(^ONCO(160,D0,0)) D SETUP S X=$S($D(@ONCOX1):$P(@ONCOX1,U,3),1:"")
 G END
MS ;
 I $D(^ONCO(160,D0,0)) D SETUP S ONCOX2=$S($D(@ONCOX1):$P(@ONCOX1,U,5),1:""),X=$S((ONCOX2>0):$P(^DIC(11,ONCOX2,0),U,1),1:"")
 G END
REL ;
 I $D(^ONCO(160,D0,0)) D SETUP S ONCOX2=$S($D(@ONCOX1):$P(@ONCOX1,U,8),1:""),X=$S((ONCOX2>0):$P(^DIC(13,ONCOX2,0),U,1),1:"")
 G END
 ;
OCC ;Current Occupation from MAS
 I $D(^ONCO(160,D0,0)) D SETUP S X=$S($D(@ONCOX1):$P(@ONCOX1,U,7),1:"")
 G END
 ;
ALIAS ;ALIAS (160,1)
 S X=""
 Q:'$D(^ONCO(160,D0,0))
 D SETUP Q:$P(ONCOX,";",2)'="DPT("  S XD0=$P(ONCOX,";")
 ;S XD1=0 F  S XD1=$O(^DPT(XD0,.01,XD1)) Q:XD1'>0  W !,$P(^(XD1,0),U)
 S XD1=0 F  S XD1=$O(^DPT(XD0,.01,XD1)) Q:XD1'>0  S X=$P(^(XD1,0),U)
 Q
 ;
SA1 ;
 D SETUP1 S X=$S($D(@ONCOX1):$P(@ONCOX1,U,1),1:"")
 G END
SA2 ;
 D SETUP1 S X=$S($D(@ONCOX1):$P(@ONCOX1,U,2),1:"")
 G END
SA3 ;
 D SETUP1 S X=$S($D(@ONCOX1):$P(@ONCOX1,U,3),1:"")
 G END
NOTE ;NONE OF THE COMPUTED FIELDS BELOW USING ZIPCODE FILE CAN BE USED SO LONG AS MAS DOES NOT USE THE ZICODE FILE;THE ZIPCODE PICKED WILL BE THE FIRST IF THE LIST IF MORE THAN ONE SELECTION
ZIPCT ;gets City, State ZIP  County
 D ZIP1 S X=Z_"   "_$P($G(^VIC(5.1,+($P($G(^VIC(5.11,+Y,0)),U,3)),0)),U)
 G END
 ;
ADD ;Address from MAS
 D SETUP1 S X=$G(@ONCOX1),X=$P(X,U)_" "_$P(X,U,2)
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 G END
ZIP ;gets City, State ZIP
 ;get fields from MAS fields
 I $D(^ONCO(160,D0,0)) D SETUP1 S Y=$S($D(@ONCOX1):$P(@ONCOX1,U,4,6),1:""),X=$P(Y,U,2),X=$S(X="":"",1:", "_$P(^DIC(5,X,0),U,2)),X=$P(Y,U)_X_" "_$P(Y,U,3)
 G END
 ;
CTY ;County from MAS (State file)
 I $D(^ONCO(160,D0,0)) D SETUP1 S Y=$S($D(@ONCOX1):$P(@ONCOX1,U,5,7),1:""),X=$P(Y,U),Y=+$P(Y,U,3),X=$S(X="":"",1:$P($G(^DIC(5,X,1,Y,0)),U))
 G END
ZIP1 I $D(^ONCO(160,D0,0)) D SETUP1 S X=$S($D(@ONCOX1):$P(@ONCOX1,U,6),1:"")
 S Y=$O(^VIC(5.11,"B",X_" ",0)),Z=$S(Y="":Y,$D(^VIC(5.11,Y,0))#2:$P(^(0),U,2)_","_$P(^DIC(5,$P(^VIC(5.1,$P(^VIC(5.11,Y,0),U,3),0),U,2),0),U,2)_" "_$P(^VIC(5.11,Y,0),U,1),1:"") Q
 G END
CT ;Get County from Zipcode
 I $D(^ONCO(160,D0,0)) D SETUP1 S X=$S($D(@ONCOX1):$P(@ONCOX1,U,6),1:"") Q:X=""  S X=$O(^VIC(5.11,"B",X_" ",0)) Q:X=""  S X=$P(^VIC(5.1,$P(^VIC(5.11,X,0),U,3),0),U)
 G END
ZCTY ;Gets County from Zipcode
 D ZIP1 S X=$P(^VIC(5.1,$P(^VIC(5.11,Y,0),U,3),0),U)
 G END
ST ;gets State #.11:5
 I $D(^ONCO(160,D0,0)) D SETUP1 S Y=$P($G(@ONCOX1),U,5),X=$P($G(^DIC(5,+Y,0)),U,2)
 G END
PH ;
 S X="" Q:'$D(^ONCO(160,D0,0))  D SETUP2 S X=$S($D(@ONCOX1):$P(@ONCOX1,U,1),1:9999999999)
 G END
 ;
EMP ;Employment Status
 I $D(^ONCO(160,D0,0)) D SETUP S X1=$P(ONCOX1,";",2) G END:X1="LRT(" S X1="^DPT("_$P(ONCOX,";")_",.311)",X=$P($G(@X1),U,15),X=$P($P($P(^DD(2,.31115,0),U,3),";",X),":",2) G END
 ;
ENVIRON ;Environmental exposure defaults
 I $P(^ONCO(160,D0,0),U,1)["LRT(67," S (AOE,IRE,PGS,SS,MES)="" Q
 S DPTIEN=$P(^ONCO(160,D0,0),";",1)
 S AOE=$$GET1^DIQ(2,DPTIEN,.32102,"E") ;Agent Orange Exposure
 S IRE=$$GET1^DIQ(2,DPTIEN,.32103,"E") ;Ionizing Radiation Exposure
 S PGS=$$GET1^DIQ(2,DPTIEN,.32201,"E") ;Persian Gulf Service
 S SS=$$GET1^DIQ(2,DPTIEN,.322016,"E") ;Somalia Service
 S MES=$$GET1^DIQ(2,DPTIEN,.3221,"E")  ;Middle East Service
 K DPTIEN
 Q
 ;
DD S (X,Y)=$S(X="":"",X="0000000":"00/00/0000",X=8888888:"88/88/8888",X=9999999:"99/99/9999",1:$E(X,4,5)_"/"_$E(X,6,7)_"/"_(1700+$E(X,1,3)))
 Q
END ;
 K ONCON,ONCOX,ONCOX1,ONCOX2,ONCODIWL,Z
END1 ;
 K ONCOX1
 Q
EXIT ;
 S X="" G END
AAD ;ADDRESS AT DX
 S PCAD=$P($G(^ONCO(165.5,D0,1)),U,2)
 S SADP=$P($G(^ONCO(165.5,D0,1)),U,4)
 S SAD="" I SADP'="" S SAD=$P($G(^ONCO(160.15,SADP,0)),U,1)
 S CTAD=$P($G(^ONCO(165.5,D0,1)),U,12)
 S AAD=CTAD_" "_SAD_" "_PCAD
 S AAD=$$LCASE^ONCOU(AAD)
 Q
W17AAD W !,?21,AAD G AADEX
W9AAD W !,?9,AAD G AADEX
AADEX K PCAD,SADP,SAD,CTAD,AAD
 Q
TLEEOT ;TUMOR LEVEL FROM ENDOSCOPIC EXAM OUTPUT TRANSFORM
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
 S Y=Y_" centimeters" Q
ASPIT ;ADDITIONAL SURGICAL PROCEDURES INPUT TRANSFORM
 I X<10 K X Q
 I "10^20^30^40^41^42^43^44^50^60^88^99"'[X K X Q
 S Y=X D ASPOT W "  ",Y K Y Q
 ;
ASPOT ;ADDITIONAL SURGICAL PROCEDURES OUTPUT TRANSFORM
 D SETASP
 I Y'="" S Y=ASP(Y) K ASP Q
 Q
 ;
ASPHP D SETASP
 F ASPX=0:0 S ASPX=$O(ASP(ASPX)) Q:ASPX'>0  W !,"  ",ASPX,"  ",ASP(ASPX)
 W ! K ASP,ASPX Q
SETASP ;
 S ASP(10)="Transanal excision"
 S ASP(20)="Posterior sacral"
 S ASP(30)="Anterior resection w/o anastomosis"
 S ASP(40)="Anterior resection w anastomosis, NOS"
 S ASP(41)="Anterior resection w simple anastomosis"
 S ASP(42)="Ant res w colo pouch coloanal anastomosis"
 S ASP(43)="Anterior resection w ilioanal anastomosis"
 S ASP(44)="Anterior resection w coloanal anastomosis"
 S ASP(50)="Colostomy w/o resection"
 S ASP(60)="Abdomino perineal resection (APR)"
 S ASP(88)="NA, none performed"
 S ASP(99)="Unknown if performed" Q
 ;
PTRDOT ;PRIMARY TUMOR RAD DOSE (cGy) OUTPUT TRANSFORM
 S Y=$S($L(Y)=1:"0000"_Y,$L(Y)=2:"000"_Y,$L(Y)=3:"00"_Y,$L(Y)=4:"0"_Y,1:Y)
 I Y="00000" S Y="No radiation therapy"
 I Y="88888" S Y="Received radiation therapy, dose unknown"
 I Y="99999" S Y="Unknown if received radiation therapy"
 Q
