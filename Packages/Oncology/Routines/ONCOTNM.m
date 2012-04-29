ONCOTNM ;Hines OIFO/GWB - TNM CODING ;8/17/93
 ;;2.11;ONCOLOGY;**1,6,15,22,25,28,30,33,35,36,41,42,43**;Mar 07, 1995
 ;INPUT TRANSFORM, OUTPUT TRANSFORM and HELP for:
 ;CLINICAL T   (165.5,37.1)
 ;CLINICAL N   (165.5,37.2)
 ;CLINICAL M   (165.5,37.3)
 ;PATHOLOGIC T (165.5,85)
 ;PATHOLOGIC N (165.5,86)
 ;PATHOLOGIC M (165.5,87)
 ;OTHER T      (165.5,93)
 ;OTHER N      (165.5,98)
 ;OTHER M      (165.5,99)
IN ;INPUT TRANSFORM
 D SETVAR
 G EX:(ST="")!(TX="")
 S X=$TR(X,"abcdilmopsuvx","ABCDILMOPSUVX")
 I (X="X")!(X="IS")!(X="A") G IN1
 S XX=$E(X)
 S X=$S(XX?1.A:$E(X,2,$L(X)),1:X) I X="" K X G EX
IN1 S TRANSFRM="INPUT" D FILSC
 I ($P($G(^ONCO(164,TX,0)),U,14)="N")!(ST=35)!(ST>65&(ST<71)) W !?3,"No TNM coding or staging available for this site.",! G EX
 I $D(^ONCO(FIL,SC,ONCOX_ONCOED)) S ONCOX=ONCOX_ONCOED G CKIN
 I $D(^ONCO(FIL,SC,ONCOX_(ONCOED-1))) S ONCOX=ONCOX_(ONCOED-1)
CKIN D CK I 'XD0 S X=$TR(X,"abcd","ABCD") D CK
 I 'XD0 K X
 E  D
 .S TD=$P(^ONCO(FIL,SC,ONCOX,XD0,0),U,1)
 .I ONCOX["T" S T=$S(TD="CBA":"Primary tumor cannot be assessed",TD="NET":"No evidence of primary tumor",TD="CIS":"Carcinoma 'in situ'",TD="TIAS":"Tumor invades adjacent structures",TD="TIAO":"Tumor invades adjacent organs",1:TD)
 .I ONCOX["N" S T=$S(TD="NCA":"Regional lymph nodes cannot be assessed",TD="NRN":"No regional lymph node metastasis",TD="MET":"Metastasis in regional lymph node(s)",1:TD)
 .I ONCOX["M" S T=TD
 .W "  ",T
 D EX
 Q
 ;
CK ;Check for existence of code
 I '$D(^ONCO(FIL,SC,ONCOX,"X")) W !!?5,"Code not valid for this site"
 S XD0=$G(^ONCO(FIL,SC,ONCOX,"X",X))
 Q
 ;
OT ;OUTPUT TRANSFORM
 D SETVAR
 G EX:(ST="")!(TX="")
 D @$S(ONCOED<3:"OT12",1:"OT3456")
 Q
 ;
OT12 ;1st and 2nd editions
 S:Y'="" Y=$E(ONCOX)_Y
 Q
 ;
OT3456 ;3rd, 4th, 5th and 6th editions
 S TRANSFRM="OUTPUT" D FILSC
 I Y="" G EX
 I $D(^ONCO(FIL,SC,ONCOX_ONCOED)) S ONCOX=ONCOX_ONCOED G CKOT
 I $D(^ONCO(FIL,SC,ONCOX_(ONCOED-1))) S ONCOX=ONCOX_(ONCOED-1)
CKOT S XD0=$G(^ONCO(FIL,SC,ONCOX,"X",Y)) G EX:XD0=""
 S TC=^ONCO(FIL,SC,ONCOX,XD0,0),MM=""
 D TC
 S Y=$E(ONCOX)_$P(TC,U,2)_MM_" "_TT
 G EX
 ;
TC I $E(ONCOX)="T" D
 .S TT=$S(Y="X":"Primary tumor cannot be assessed",Y=0:"No evidence of primary tumor",1:$P(TC,U))
 .S TT=$S(TT="TIAS":"Tumor invades adjacent structures",1:TT)
 .N MM S MM=$P($G(^ONCO(165.5,D0,2)),U,31) ;69;MULTIPLE TUMORS
 .I MM'="" S MM=$S(MM>1:"m"_MM,1:"m")
 E  I $E(ONCOX)="N" S TT=$S($P(TC,U,1)="NCA":"Regional lymph nodes cannot be assessed",$P(TC,U,1)="NRN":"No regional lymph node metastasis",ST=58:"NA",1:$P(TC,U)),TT=$S(TT="MET":"Metastasis in regional lymph node(s)",1:TT)
 E  I $E(ONCOX)="M" S TT=$P(TC,U) Q
 Q
 ;
HP ;HELP
 D SETVAR
 G EX:(ST="")!(TX="")
 D @$S(ONCOED<3:"P12",1:"P3456")
 Q
 ;
P12 ;1st and 2nd edition
 W !!,"Enter the appropriate TNM code."
 Q
 ;
P3456 ;3rd, 4th, 5th and 6th editions
 S TRANSFRM="HELP" D FILSC
 I $D(^ONCO(FIL,SC,ONCOX_ONCOED)) S ONCOX=ONCOX_ONCOED
 I ONCOED>5,FIL=164.33,(SC=22)!(SC=23)!(SC=25)!(SC=29)!(SC=30)!(SC=35)!(SC=39)!(SC=41)!(SC=50)!(SC=51)!(SC=55) S SUB=$S($E(ONCOX,1)="T":4,$E(ONCOX,1)="N":5,1:6) I $D(^ONCO(164.33,SC,SUB)) D  W ! K SUB Q  ;Full text help from 164.33
 .S HIEN=0 F  S HIEN=$O(^ONCO(164.33,SC,SUB,HIEN)) Q:HIEN'>0  W !?1,^ONCO(164.33,SC,SUB,HIEN,0)
 I ONCOED>4,FIL=164.33,(SC=22)!(SC=23)!(SC=25)!(SC=29)!(SC=30)!(SC=35)!(SC=39)!(SC=41)!(SC=50)!(SC=51) S SUB=$S($E(ONCOX,1)="T":1,$E(ONCOX,1)="N":2,1:3) I $D(^ONCO(164.33,SC,SUB)) D  W ! K SUB Q  ;Full text help from 164.33
 .S HIEN=0 F  S HIEN=$O(^ONCO(164.33,SC,SUB,HIEN)) Q:HIEN'>0  W !?1,^ONCO(164.33,SC,SUB,HIEN,0)
 I ONCOED>5 S SUB=$S($E(ONCOX,1)="T":8,$E(ONCOX,1)="N":9,1:10) I $D(^ONCO(164,SC,SUB)) D  W ! K SUB Q  ;Full text help from 6th edition
 .S HIEN=0 F  S HIEN=$O(^ONCO(164,SC,SUB,HIEN)) Q:HIEN'>0  W !?1,^ONCO(164,SC,SUB,HIEN,0)
 I ONCOED>4 S SUB=$S($E(ONCOX,1)="T":5,$E(ONCOX,1)="N":6,1:7) I $D(^ONCO(164,SC,SUB)) D  W ! K SUB Q  ;Full text help from 5th edition
 .S HIEN=0 F  S HIEN=$O(^ONCO(164,SC,SUB,HIEN)) Q:HIEN'>0  W !?1,^ONCO(164,SC,SUB,HIEN,0)
 S XD0=0
 W !,$S(ONCOX["T":" Primary Tumor (T)",ONCOX["N":" Regional Lymph Nodes (N)",ONCOX["M":" Distant Metastasis (M)",1:""),!
 F  S XD0=$O(^ONCO(FIL,SC,ONCOX,XD0)) Q:XD0'>0  D
 .N Y,T
 .S Y=^(XD0,0),T=$P(Y,U)
 .I ONCOX["T" D
 ..W:$P(Y,U,2)'=88 !?1,"T"_$P(Y,U,2),?12
 ..W $S(T="CBA":"Primary tumor cannot be assessed",T="NET":"No evidence of primary tumor",T="CIS":"Carcinoma 'in situ'",T="TIAS":"Tumor invades adjacent structures",T="TIAO":"Tumor invades adjacent organs",1:T)
 .E  I ONCOX["N" W:$P(Y,U,2)'=88 !?1,"N"_$P(Y,U,2),?13,$S(T="NCA":"Regional lymph nodes cannot be assessed",T="NRN":"No regional lymph node metastasis",T="MET":"Metastasis in regional lymph node(s)",1:T)
 .E  I ONCOX["M" W:$P(Y,U,2)'=88 !?1,"M"_$P(Y,U,2),?6,T
 W ! Q
 ;
SETVAR ;Set variables
 N T,N,M
 S ST=$P(^ONCO(165.5,D0,0),U)        ;SITE/GP
 S TX=$P($G(^ONCO(165.5,D0,2)),U,1)  ;ICDO-TOPOGRAPHY
 Q:(ST="")!(TX="")
 S HT=$$HIST^ONCFUNC(D0)             ;HISTOLOGY
 S SC=$P(^ONCO(164,TX,0),U,11)       ;T & N CODES
 S DATEDX=$P(^ONCO(165.5,D0,0),U,16) ;DATE DX
 N YR S YR=$E($P($G(^ONCO(165.5,D0,0)),U,16),1,3)
 S ONCOED=$S(YR<283:1,YR<288:2,YR<292:3,YR<298:4,YR<303:5,1:6)
 ;S ONCOED=$$TNMED^ONCOU55(D0)        ;STAGING EDITION
 S FIL=164
 Q
 ;
FILSC ;Get file (FIL) and IEN (SC) for appropriate TNM list
 ;
 ;PART III: DIGESTIVE SYSTEM
 ;Esophagus - Upper 3rd, Middle 3rd, Lower 3rd
 I ONCOED>4,TX=67151,ONCOX="M" S FIL=164,SC=67154 Q
 I ONCOED>4,TX=67152,ONCOX="M" S FIL=164,SC=67155 Q
 I ONCOED>4,TX=67153,ONCOX="M" S FIL=164,SC=67153 Q
 I ONCOED>4,TX=67154,ONCOX="M" S FIL=164,SC=67154 Q
 I ONCOED>4,TX=67155,ONCOX="M" S FIL=164,SC=67155 Q
 ;
 ;Extraheptic Bile Ducts
 I ((TX=67240)!(TX=67248)!(67249)),ONCOED=3,ONCOX="N" S FIL=164.33,SC=15 Q
 ;
 ;PART VI: SKIN
 ;Melanoma of the Skin
 I $$MELANOMA^ONCOU55(D0),(($E(TX,3,4)=44)!($E(TX,3,4)=51)!($E(TX,3,4)=60)!(TX=67632)) S FIL=164.33,SC=22 Q
 ;
 ;PART VII: BREAST
 ;Breast
 I $E(TX,1,4)=6750,ONCOX="N" D  Q
 .I STGIND="C" Q
 .I STGIND="P" S FIL=164.33,SC=23
 ;
 ;PART VIII: GYNECOLOGIC SITES
 ;Vulva
 I ONCOED>4,$E(TX,3,4)=51,ONCOX="M" S FIL=164,SC=67518 Q
 ;
 ;Vagina - 3rd and 4th editions
 I TX=67529,ONCOX="N",ONCOED<5 D  Q
 .S ONCUL=$P($G(^ONCO(165.5,D0,24)),U,4)
 .I ONCUL="U" Q
 .I ONCUL="L" S FIL=164.33,SC=52 Q
 ;
 ;Gestational Trophoblastic Tumors - 5th and 6th editions
 ;I ONCOED>4,TX=67589,ONCOX="M" S FIL=164,SC=67540 Q
 ;I $$GTT^ONCOU55(D0),ONCOED>4,ONCOX="M" S FIL=164,SC=67540 Q
 ;I ONCOED=5,(($E(TX,3,4)=54)!($E(TX,3,4)=55)) S ONCOED=4
 ;
 ;PART IX: GENITOURINARY SITES
 ;Prostate
 I TX=67619,ONCOED>4,ONCOX="T",STGIND="P" S FIL=164.33,SC=29 Q
 I TX=67619,ONCOED=6,ONCOX="N",STGIND="P" S FIL=164.33,SC=29 Q
 I TX=67619,ONCOX="M" S FIL=164.33,SC=$S(ONCOED>3:29,1:3) Q
 ;
 ;Testis - 5th and 6th editions
 I $E(TX,3,4)=62,ONCOED>4,ONCOX="N",STGIND="P" S FIL=164.33,SC=30 Q
 I $E(TX,3,4)=62,ONCOED>4,ONCOX="M" S FIL=164,SC=67620 Q
 ;
 ;Urethra - Urothelial (Transitional Cell) Carcinoma of the Prostate
 I ONCOED>4,TX=67619,(HT=81203)!(HT=81303)!(HT=81223)!(HT=81202) D  Q
 .I ONCOX="T" S FIL=164.33,SC=35
 .I ONCOX="N" S FIL=164,SC=67680
 .I ONCOX="M" S FIL=164.33,SC=3
 ;
 ;PART X: OPHTHALMIC SITES
 ;Malignant Melanoma of the Eyelid -3rd and 4th editions
 I TX=67441,ONCOED<5,$$MELANOMA^ONCOU55(D0) S FIL=164.33,SC=37 Q
 ;
 ;Malignant Melanoma of the Conjunctiva
 I $$MELANOMA^ONCOU55(D0),TX=67690 S FIL=164.33,SC=$S(STGIND="P":50,1:39) Q
 ;
 ;Malignant Melanoma of the Uvea
 I TX=67694,$$IRISCIL^ONCOU55(D0)="C" S FIL=164.33,SC=51 Q
 ;
 ;Retinoblastoma
 I TX=67692,STGIND="P" S FIL=164.33,SC=41 Q
 ;
 ;PART XI: CENTRAL NERVOUS SYSTEM
 ;Brain - 3rd and 4th editions
 I ((TX=67700)!($E(TX,3,4)=71)),ONCOED<5 D
 .I ONCOX="T" S SC=$S($P($G(^ONCO(165.5,D0,2)),U,7)="I":67710,1:67700) Q
 .I TRANSFRM'="OUTPUT",ONCOX="N" W ?12," This category does not apply to this site."
 ;
 ;PART XII: LYMPHOID NEOPLASMS
 ;Mycosis fungoides and Sezary Disease of Skin, Vulva, Penis, Scrotum
 ;9700/3 and 9701/3
 ;C44.0-C44.9, C51.0-C51.2, C51.8-C51.9, C60.0-C60.2, C60.8-C60.9, C63.2
 I (HT=97003)!(HT=97013),($E(TX,3,4)=44)!($E(TX,3,4)=51)!($E(TX,3,4)=60)!(TX=67632),ONCOED>5 S FIL=164.33,SC=55 Q
 ;
 I ONCOX="M",'$D(^ONCO(FIL,SC,"M"_ONCOED)) S FIL=164.33,SC=3
 ;
 Q
 ;
EX ;Exit
 K MM,XX,TC,SC,TT,OG,OS,OT,OP,ONCOX,YY,CC,ER,WFLG,TRANSFRM
 Q
