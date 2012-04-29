ONCOTN0 ;Hines OIFO/GWB - AUTOMATIC STAGING ;6/11/93
 ;;2.11;ONCOLOGY;**1,15,28,35**;Mar 07, 1995
 ;
PART2 ;HEAD AND NECK SITES
 ;
3 ;Lip and Oral Cavity
 D @$S(ONCOED=6:"LIP6^ONCSG0",ONCOED=5:"LIP5^ONCSG0",ONCOED>2:"LIP34^ONCSG0",1:"LIP12^ONCSG0")
 Q
 ;
4 ;Pharynx
 D @$S(ONCOED=6:"PHA6",ONCOED=5:"PHA5",ONCOED>2:"PHA34^ONCSG0",1:"PHA12^ONCSG0")
 Q
 ;
PHA5 ;Pharynx - 5th edition
 I SP=67110 D PHAN56^ONCSG0 Q  ;C11.0 Superior wall of nasopharynx
 E  D PHAOH5^ONCSG0 Q
 ;
PHA6 ;Pharynx - 6th edition
 I SP=67110 D PHAN56^ONCSG0 Q  ;C11.0 Superior wall of nasopharynx
 E  D PHAOH6^ONCSG0 Q
 ;
5 ;Larynx
 D @$S(ONCOED=6:"LAR6^ONCSG0",ONCOED=5:"LAR5^ONCSG0",ONCOED>2:"LAR34^ONCSG0",1:"LAR12^ONCSG0")
 Q
 ;
6 ;Nasal Cavity and Paranasal Sinuses
 D @$S(ONCOED=6:"PAR6^ONCSG0A",5:"PAR5^ONCSG0A",ONCOED>2:"PAR34^ONCSG0A",1:"PAR12^ONCSG0A")
 Q
 ;
7 ;Major Salivary Glands
 D @$S(ONCOED=6:"SAL6^ONCSG0A",ONCOED=5:"SAL5^ONCSG0A",ONCOED>2:"SAL34^ONCSG0A",1:"SAL12^ONCSG0A")
 Q
 ;
8 ;Thyroid
 D @$S(ONCOED=6:"THY6^ONCSG0A",1:"THY15^ONCSG0A")
 Q
 ;
PART3 ;DIGESTIVE SYSTEM
 ;
9 ;Esophogus
 D @$S(ONCOED>4:"ESO56^ONCSG1",1:"ESO1234^ONCSG1")
 Q
 ;
10 ;Stomach
 D @$S(ONCOED=6:"STO6^ONCSG1",ONCOED=5:"STO5^ONCSG1",1:"STO34^ONCSG1")
 Q
 ;
1 ;Small Intestine
 I ONCOED<4 D  Q
 .W !!?12,"NO AJCC TNM Coding Schema for this edition."
 .S SG=88
 D SI^ONCSG1
 Q
 ;
11 ;Colon and Rectum
 D @$S(ONCOED=6:"COL6^ONCSG1",ONCOED=5:"COL5^ONCSG1",1:"COL34^ONCSG1")
 Q
 ;
12 ;Anal Canal
 D AC^ONCSG1
 Q
 ;
13 ;Liver
 D @$S(ONCOED=6:"LIV6^ONCSG1A",ONCOED=5:"LIV5^ONCSG1A",1:"LIV34^ONCSG1A")
 Q
 ;
14 ;Gallbladder
 D @$S(ONCOED=6:"GB6^ONCSG1A",ONCOED=5:"GB45^ONCSG1A",ONCOED=4:"GB45^ONCSG1A",1:"GB3^ONCSG1A")
 Q
 ;
15 ;Extrahepatic Bile Ducts
 D @$S(ONCOED=6:"EBD6^ONCSG1A",ONCOED>3:"EBD45^ONCSG1A",1:"EBD3^ONCSG1A")
 Q
 ;
16 ;Ampulla of Vater
 D @$S(ONCOED=6:"AV6^ONCSG1A",1:"AV345^ONCSG1A")
 Q
 ;
17 ;Exocrine Pancreas
 D @$S(ONCOED=6:"EXO6^ONCSG1A",ONCOED=5:"EXO5^ONCSG1A",1:"EXO34^ONCSG1A")
 Q
 ;
PART4 ;THORAX
 ;
18 ;Lung
 D @$S(ONCOED>4:"LUN56^ONCSG2",1:"LUN34^ONCSG2")
 Q
 ;
2 ;Pleural Mesothelioma
 D @$S(ONCOED=6:"PM6^ONCSG2",1:"PM45^ONCSG2")
 Q
 ;
PART5 ;MUSCULOSKELETAL SITES
 ;
19 ;Bone
 D @$S(ONCOED=6:"BONE6^ONCSG2",1:"BONE345^ONCSG2")
 Q
 ;
20 ;Soft Tissue Sarcoma
 D @$S(ONCOED=6:"STS6^ONCSG2",ONCOED=5:"STS5^ONCSG2",1:"STS34^ONCSG2")
 Q
 ;
PART6 ;SKIN
 ;
21 ;Carcinoma of the Skin
 D CS^ONCSG3
 Q
 ;
22 ;Melanoma of the Skin
 D @$S(ONCOED=6:"MMS6^ONCSG3",ONCOED=5:"MMS5^ONCSG3",ONCOED=4:"MMS4^ONCSG3",1:"MMS3^ONCSG3")
 Q
 ;
PART7 ;BREAST
 ;
23 ;Breast
 D @$S(ONCOED=6:"BRST6^ONCSG3",1:"BRST345^ONCSG3")
 Q
 ;
PART8 ;GYNECOLOGIC SITES
 ;
28 ;Vulva
 D @$S(ONCOED>4:"VU56^ONCSG4",ONCOED=4:"VU4^ONCSG4",1:"VU3^ONCSG4")
 Q
 ;
27 ;Vagina
 D @$S(ONCOED>4:"VA56^ONCSG4",1:"VA34^ONCSG4")
 Q
 ;
24 ;Cervix Uteri
 D @$S(ONCOED>4:"CEU56^ONCSG4",1:"CEU34^ONCSG4")
 Q
 ;
25 ;Corpus Uteri
 D @$S(ONCOED=6:"COU6^ONCSG4",ONCOED>3:"COU45^ONCSG4",1:"COU3^ONCSG4")
 Q
 ;
26 ;Ovary
 D @$S(ONCOED=6:"OVA6^ONCSG4A",1:"OVA345^ONCSG4A")
 Q
 ;
53 ;Fallopian Tube
 D @$S(ONCOED=6:"FT6^ONCSG4A",1:"FT5^ONCSG4A")
 Q
 ;
54 ;Gestational Trophoblastic Tumors
 D @$S(ONCOED=6:"GTT6^ONCSG4A",1:"GTT5^ONCSG4A")
 Q
 ;
PART9 ;GENITOURINARY SITES
 ;
31 ;Penis
 D PENIS^ONCSG5
 Q
 ;
29 ;Prostate
 D @$S(ONCOED>4:"PROS56^ONCSG5",ONCOED=4:"PROS4^ONCSG5",1:"PROS3^ONCSG5")
 Q
 ;
30 ;Testis
 D @$S(ONCOED>4:"TES56^ONCSG5",ONCOED=4:"TES4^ONCSG5",1:"TES3^ONCSG5")
 Q
 ;
33 ;Kidney
 D @$S(ONCOED=6:"KID6^ONCSG5",ONCOED=5:"KID5^ONCSG5",1:"KID34^ONCSG5")
 Q
 ;
34 ;Renal Pelvis and Ureter
 D @$S(ONCOED>3:"RPU456^ONCSG5A",1:"RPU3^ONCSG5A")
 Q
 ;
32 ;Urinary Bladder
 D @$S(ONCOED>4:"UB56^ONCSG5A",ONCOED=4:"UB4^ONCSG5A",1:"UB3^ONCSG5A")
 Q
 ;
35 ;Urethra
 D @$S(ONCOED>4:"U56^ONCSG5A",ONCOED=4:"U4^ONCSG5A",1:"U3^ONCSG5A")
 Q
 ;
PART10 ;OPHTHALMIC SITES
 ;
36 ;Carcinoma of the Eyelid
 W !!?12,"No stage grouping is presently recommended."
 S SG=88 Q
 ;
37 ;Malignant Melanoma of the Eyelid
 I STGIND="C" D  Q
 .W !!?12,"No stage grouping is presently recommended."
 .S SG=88
 D MME34^ONCSG5A
 Q
 ;
38 ;Carcinoma of the Conjunctiva
 W !!?12,"No stage grouping is presently recommended."
 S SG=88 Q
 ;
39 ;Malignant Melanoma of the Conjunctiva
 W !!?12,"No stage grouping is presently recommended."
 S SG=88 Q
 ;
40 ;Malignant Melanoma of the uvea
 I TX=67693 D @$S(ONCOED=6:"MMU6^ONCSG5A",1:"CHO345^ONCSG5A") Q
 I TX=67694 D @$S(ONCOED=6:"MMU6^ONCSG5A",1:"CBI345^ONCSG5A") Q
 Q
 ;
41 ;Retinoblastoma
 I ONCOED=6 D  Q
 .W !!?12,"No stage grouping applies."
 .S SG=88
 D RET345^ONCSG5A
 Q
 ;
43 ;Carcinoma of the Lacrimal Gland
 W !!?12,"No stage grouping is presently recommended."
 S SG=88 Q
 ;
42 ;Sarcoma of the orbit
 W !!?12,"No stage grouping is presently recommended."
 S SG=88 Q
 ;
PART11 ;CENTRAL NERVOUS SYSTEM
 ;
44 ;Brain and Spinal Cord
 D BSC34^ONCSG5A
 Q
 ;
PART12 ;LYMPHOID NEOPLASMS
 ;
55 ;Mycosis fungoides
 D MF6^ONCSG5A
 Q
