ONCPST51        ;Hines OIFO/GWB - POST-INSTALL ROUTINE FOR PATCH ONC*2.11*51 ;06/23/10
        ;;2.11;ONCOLOGY;**51**;Mar 07, 1995;Build 65
        ;
        ;S IEN=0 F  S IEN=$O(^ONCO(160.1,IEN)) Q:IEN'>0  D
        ;.I $P($G(^ONCO(160.1,IEN,7)),U,1)=1 D
        ;..S ZIP=$P(^ONCO(160.1,IEN,0),U,3) Q:ZIP=""
        ;..S ZIPB=ZIP_" "
        ;..S CITY=$P(^ONCO(160.1,IEN,0),U,12)
        ;..S STATE=$P(^ONCO(160.1,IEN,0),U,13)
        ;..S ZIPIEN=0
        ;..F  S ZIPIEN=$O(^VIC(5.11,"B",ZIPB,ZIPIEN))  Q:ZIPIEN'>0  D
        ;...S ZIPCITY=$P(^VIC(5.11,ZIPIEN,0),U,2)
        ;...S ZIPSTATE=$P(^VIC(5.11,ZIPIEN,0),U,4)
        ;...I CITY=ZIPCITY,STATE=ZIPSTATE S $P(^ONCO(160.1,IEN,0),U,3)=ZIPIEN
        ;..S $P(^ONCO(160.1,IEN,7),U,1)=""
        ;K CITY,IEN,STATE,ZIP,ZIPB,ZIPCITY,ZIPIEN,ZIPSTATE
        ;
        ;S IEN=0 F  S IEN=$O(^ONCO(165,IEN)) Q:IEN'>0  D
        ;.Q:$P(^ONCO(165,IEN,0),U,6)=2
        ;.S ZIP=$P($G(^ONCO(165,IEN,.11)),U,9) Q:ZIP=""
        ;.S ZIPB=ZIP_" "
        ;.S CITY=$P(^ONCO(165,IEN,.11),U,4)
        ;.S STATE=$P(^ONCO(165,IEN,.11),U,5)
        ;.S ZIPIEN=0
        ;.F  S ZIPIEN=$O(^VIC(5.11,"B",ZIPB,ZIPIEN))  Q:ZIPIEN'>0  D
        ;..S ZIPCITY=$P(^VIC(5.11,ZIPIEN,0),U,2)
        ;..S ZIPSTATE=$P(^VIC(5.11,ZIPIEN,0),U,4)
        ;..I CITY=ZIPCITY,STATE=ZIPSTATE S $P(^ONCO(165,IEN,.11),U,9)=ZIPIEN,$P(^ONCO(165,IEN,0),U,6)=2
        ;.I $P(^ONCO(165,IEN,0),U,6)'=2 S $P(^ONCO(165,IEN,.11),U,9)=""
        ;K CITY,IEN,STATE,ZIP,ZIPB,ZIPCITY,ZIPIEN,ZIPSTATE
        ;
        ;Set the COLLABORATIVE STAGING URL (160.1,19) value in all ONCOLOGY
        ;SITE PARAMETERS entries = http://websrv.oncology.med.va.gov/oncsrv.exe
        N RC
        S RC=$$UPDCSURL^ONCSAPIU("http://websrv.oncology.med.va.gov/oncsrv.exe")
        ;For testing purposes. Comment out for final release.
        ;S RC=$$UPDCSURL^ONCSAPIU("http://10.3.17.19:1755/cgi-bin/oncsrv.exe")
        ;S RC=$$UPDCSURL^ONCSAPIU("http://10.3.16.6:1755/cgi-bin/oncsrv.exe")
        ;
ITEM1   ;FORDS Revised for 2010
ITEM1C  ;RACE CODE FOR ONCOLOGY (164.46)
        ;Add codes 15 (Asian Indian or Pakistani, NOS)
        ;          16 (Asian Indian)
        ;          17 (Pakistani)
        ;Convert codes 9 (Asian Indian, Pakistani) to new code 15
        ;Delete code 9
        ;Change code 13 name from "Kampuchean" to "Kampuchean (Cambodian)"
ITEM24  ;Convert USUAL OCCUPATION (160.042,.01) from POINTER TO A FILE to FREE
        ;TEXT
        K DD,DO
        S DIC="^ONCO(164.46,",DIC(0)="L"
        S X="Asian Indian or Pakistani, NOS"
        S DINUM=15
        D FILE^DICN
        K DIC,DINUM,X
        K DD,DO
        ;
        S DIC="^ONCO(164.46,",DIC(0)="L"
        S X="Asian Indian"
        S DINUM=16
        D FILE^DICN
        K DIC,DINUM,X
        K DD,DO
        ;
        S DIC="^ONCO(164.46,",DIC(0)="L"
        S X="Pakistani"
        S DINUM=17
        D FILE^DICN
        K DIC,DINUM,X
        ;
        S IEN=0 F CNT=1:1 S IEN=$O(^ONCO(160,IEN)) Q:IEN'>0  W:CNT#100=0 "." D
        .I $G(^ONCO(160,IEN,0))="" K ^ONCO(160,IEN) Q
        .I $P(^ONCO(160,IEN,0),U,6)=9 S $P(^ONCO(160,IEN,0),U,6)=15
        .I $P(^ONCO(160,IEN,0),U,15)=9 S $P(^ONCO(160,IEN,0),U,15)=15
        .I $P(^ONCO(160,IEN,0),U,16)=9 S $P(^ONCO(160,IEN,0),U,16)=15
        .I $P(^ONCO(160,IEN,0),U,17)=9 S $P(^ONCO(160,IEN,0),U,17)=15
        .I $P(^ONCO(160,IEN,0),U,18)=9 S $P(^ONCO(160,IEN,0),U,18)=15
        .I $D(^ONCO(160,IEN,7,0)) D
        ..N OCCIEN,OCCPTR,OCCTXT
        ..S OCCIEN=0 F  S OCCIEN=$O(^ONCO(160,IEN,7,OCCIEN)) Q:OCCIEN'>0  D
        ...S OCCPTR=$P(^ONCO(160,IEN,7,OCCIEN,0),U,1) Q:OCCPTR'?1.4N
        ...S OCCTXT=$P($G(^LAB(61.6,OCCPTR,0)),U,1)
        ...S OCCTXT=$E(OCCTXT,1,100)
        ...K DIE S DA(1)=IEN,DIE="^ONCO(160,"_DA(1)_",7,"
        ...S DA=OCCIEN
        ...S DR=".01///^S X=OCCTXT" D ^DIE
        ;
        K DA,DIK S DIK="^ONCO(164.46,",DA=9 D ^DIK K DA,DIK
        ;
        K DA,DIE,DR
        S DIE="^ONCO(164.46,",DA=13,DR=".01///Kampuchean (Cambodian)" D ^DIE
        K DA,DIE,DR
        ;
        W !!," Converting CLASS OF CASE, STATE AT DX, COUNTY AT DX and CSv1 cases..."
        K DIC5
        K ^ONCO(165.5,"AG")
        K ^ONCO(165.5,"AGC")
        K ^ONCO(165.5,"AAY")
        F IEN=0:0 S IEN=$O(^DIC(5,IEN)) Q:IEN'>0  D
        .S CODE=$P(^DIC(5,IEN,0),U,3)
        .S:CODE'="" DIC5(CODE)=IEN
        K CODE
        S IEN=0 F CNT=1:1 S IEN=$O(^ONCO(165.5,IEN)) Q:IEN'>0  W:CNT#100=0 "." D
        .S DATEDX=$P($G(^ONCO(165.5,IEN,0)),U,16)
        .S SITE=$P($G(^ONCO(165.5,IEN,2)),U,1)
        .S HIST=$$HIST^ONCFUNC(IEN)
        .S HIST14=$E(HIST,1,4)
        .S CSDERIVED=$P($G(^ONCO(165.5,IEN,"CS1")),U,11)
        .;
ITEM1A  .;Convert CLASS OF CASE (165.5,.04)
        .I $P($G(^ONCO(165.5,IEN,"CONV")),U,1)="" D
        ..I $D(^ONCO(169.3,99753,0)) Q
        ..S COC=$P($G(^ONCO(165.5,IEN,0)),U,4)
        ..I (DATEDX="0000000")!(DATEDX=8888888)!(DATEDX=9999999) S DATEDX=""
        ..I COC=0 S $P(^ONCO(165.5,IEN,0),U,4)=1
        ..I COC=1 S $P(^ONCO(165.5,IEN,0),U,4)=2
        ..I COC=2 S $P(^ONCO(165.5,IEN,0),U,4)=7
        ..I COC=3 S $P(^ONCO(165.5,IEN,0),U,4)=12
        ..I COC=4 S $P(^ONCO(165.5,IEN,0),U,4)=17
        ..I COC=5 S $P(^ONCO(165.5,IEN,0),U,4)=18
        ..I COC=6 S $P(^ONCO(165.5,IEN,0),U,4)=19
        ..I COC=7 S $P(^ONCO(165.5,IEN,0),U,4)=22
        ..I COC=8 S $P(^ONCO(165.5,IEN,0),U,4)=23
        ..I COC=9 S $P(^ONCO(165.5,IEN,0),U,4)=24
        ..I (SITE>67439)&(SITE<67450),(HIST>79999)&(HIST<81104) D COC2
        ..I (SITE>67529)&(SITE<67540),$E(HIST,5)=2 D COC2
        ..I SITE=67619,$E(HIST,1,4)=8148 D COC2
        ..I $E(HIST,1,4)=8077 D COC2
        ..I (SITE<67700)!(SITE>67729),(SITE<67751)!(SITE>67753),HIST'="",$E(HIST,5)<2 D COC2
        ..I (DATEDX="")!(DATEDX<3040000),(SITE>67699)&(SITE<67730),HIST'="",$E(HIST,5)<2 D COC2
        ..S $P(^ONCO(165.5,IEN,"CONV"),U,1)=1
        .;
ITEM5   .;Postal Code, County and State conversions
        .;Convert STATE AT DX (165.5,16) values from pointers to ACOS STATE AT
        .;DX (160.15) to pointers to STATE (5)
        .;Convert COUNTY AT DX (165.5,10) values from pointers to COUNTY file
        .;(5.1) to FIPS codes for lookup in COUNTY CODE file (5.13)
        .;
        .I $P($G(^ONCO(165.5,IEN,"CONV")),U,2)="" D
        ..I $D(^ONCO(169.3,99753,0)) Q
        ..S STATEDX=$P($G(^ONCO(165.5,IEN,1)),U,4) Q:STATEDX=""
        ..S CODE=$P($G(^ONCO(160.15,STATEDX,0)),U,3)
        ..I CODE="" S CODE=99
        ..I $D(DIC5(CODE)) S $P(^ONCO(165.5,IEN,1),U,4)=DIC5(CODE)
        ..S $P(^ONCO(165.5,IEN,"CONV"),U,2)=1
        .S COUNTYDX=$P($G(^ONCO(165.5,IEN,1)),U,3) D
        ..Q:COUNTYDX=""
        ..Q:$L(COUNTYDX)=5
        ..I '$D(^VIC(5.1,COUNTYDX,0)) S $P(^ONCO(165.5,IEN,1),U,3)=99999 Q
        ..S COUNTYNAME=$P($G(^VIC(5.1,COUNTYDX,0)),U,1)
        ..S STATEPNT=$P($G(^VIC(5.1,COUNTYDX,0)),U,2)
        ..S STATECODE=$P($G(^DIC(5,STATEPNT,0)),U,3)
        ..S COUNTYIEN=$O(^DIC(5,STATEPNT,1,"B",COUNTYNAME,0))
        ..I COUNTYIEN="" S $P(^ONCO(165.5,IEN,1),U,3)=99999 Q
        ..S COUNTYCODE=$P($G(^DIC(5,STATEPNT,1,COUNTYIEN,0)),U,3)
        ..S FIPS=STATECODE_COUNTYCODE
        ..K ONCXIPC
        ..D CCODE^XIPUTIL(FIPS,.ONCXIPC)
        ..I ONCXIPC("COUNTY")="" S $P(^ONCO(165.5,IEN,1),U,3)=99999 Q
        ..S $P(^ONCO(165.5,IEN,1),U,3)=FIPS
        .K CODE,COUNTYCODE,COUNTYDX,COUNTYIEN,COUNTYNAME,FIPS,STATECODE,STATEDX
        .K STATEPNT,XIPIEN
        .;
ITEM2A  .;Convert EXTENSION (CS) (165.5,30.2)
        .;Convert LYMPH NODES (CS) (165.5,31.1)
        .N EXTCS,LNCS
        .S EXTCS=$P($G(^ONCO(165.5,IEN,"CS")),U,11) I $L(EXTCS)=2 D
        ..I EXTCS=88 S $P(^ONCO(165.5,IEN,"CS"),U,11)=888 Q
        ..I EXTCS=99 S $P(^ONCO(165.5,IEN,"CS"),U,11)=999 Q
        ..S $P(^ONCO(165.5,IEN,"CS"),U,11)=EXTCS_"0"
        .S LNCS=$P($G(^ONCO(165.5,IEN,"CS")),U,12) I $L(LNCS)=2 D
        ..I LNCS=88 S $P(^ONCO(165.5,IEN,"CS"),U,12)=888 Q
        ..I LNCS=99 S $P(^ONCO(165.5,IEN,"CS"),U,12)=999 Q
        ..S $P(^ONCO(165.5,IEN,"CS"),U,12)=LNCS_"0"
        .;
ITEM2B  .;Stuff pre-2010 SSF 7-24 (165.5,44.7-44.24) with 988
        .I DATEDX>3031231 D
        ..I DATEDX<3100000 F PIECE=1:1:18 S:$P($G(^ONCO(165.5,IEN,"CS2")),U,PIECE)="" $P(^ONCO(165.5,IEN,"CS2"),U,PIECE)=988
        ..I $E(CSDERIVED,2)<2 D ^ONCCSV2,^ONCSSF25
        .;
ITEM1G  .;Convert NUMBER OF TXS TO THIS VOLUME (165.5,56) values of 99 to 999
        .S:$P($G(^ONCO(165.5,IEN,3)),U,20)=99 $P(^ONCO(165.5,IEN,3),U,20)=999
        .;
        .;Recompute checksum
        ;.S D0=IEN
        ;.I $P($G(^ONCO(165.5,D0,7)),U,2)=3 D
        ;..S EDITS="NO" D NAACCR^ONCGENED K EDITS
        ;..S CHECKSUM=$$CRC32^ONCSNACR(.ONCDST)
        ;..I CHECKSUM'=$P($G(^ONCO(165.5,D0,"EDITS")),U,1) D
        ;...S $P(^ONCO(165.5,D0,"EDITS"),U,1)=CHECKSUM
        K CNT,COC,CSDERIVED,DATEDX,DIC5,HIST,HIST14,IEN,PIECE,SITE
        ;
        ;Re-index CLASS OF CASE (165.5,.04)
        S DIK="^ONCO(165.5,",DIK(1)=.04 D ENALL^DIK
        ;
ITEM1H  ;Add new ICD-O-3 MORPHOLOGY (169.3) entries
        S X="PRIMARY CUTANEOUS FOLLICLE CENTRE LYMPHOMA"
        S DIC("DR")="1///9597/3"
        S DINUM=95973
        D ICD3ADD
        ;
        S X="T-CELL/HISTIOCYTE RICH LARGE B-CELL LYMPHOMA"
        S DIC("DR")="1///9688/3"
        S DINUM=96883
        D ICD3ADD
        ;
        S X="INTRAVASCULAR LARGE B-CELL LYMPHOMA"
        S DIC("DR")="1///9712/3"
        S DINUM=97123
        D ICD3ADD
        ;
        S X="SYSTEMIC EBV POSITIVE T-CELL LYMPHOPROLIFERATIVE DISEASE OF CHILDHOOD"
        S DIC("DR")="1///9724/3"
        S DINUM=97243
        D ICD3ADD
        ;
        S X="HYDROA VACCINIFORME-LIKE LYMPHOMA"
        S DIC("DR")="1///9725/3"
        S DINUM=97253
        D ICD3ADD
        ;
        S X="PRIMARY CUTANEOUS GAMMA-DELTA T-CELL LYMPHOMA"
        S DIC("DR")="1///9726/3"
        S DINUM=97263
        D ICD3ADD
        ;
        S X="PLASMABLASTIC LYMPHOMA"
        S DIC("DR")="1///9735/3"
        S DINUM=97353
        D ICD3ADD
        ;
        S X="ALK POSITIVE LARGE B-CELL LYMPHOMA"
        S DIC("DR")="1///9737/3"
        S DINUM=97373
        D ICD3ADD
        ;
        S X="LARGE B-CELL LYMPHOMA ARISING IN HHV8-ASSOCIATED MULTICENTRIC CASTLEMAN DISEASE"
        S DIC("DR")="1///9738/3"
        S DINUM=97383
        D ICD3ADD
        ;
        S X="FIBROBLASTIC RETICULAR CELL TUMOR"
        S DIC("DR")="1///9759/3"
        S DINUM=97593
        D ICD3ADD
        ;
        S X="MIXED PHENOTYPE ACUTE LEUKEMIA WITH T(9;22)(Q34;Q11.2); BCR-ABL1"
        S DIC("DR")="1///9806/3"
        S DINUM=98063
        D ICD3ADD
        ;
        S X="MIXED PHENOTYPE ACUTE LEUKEMIA WITH T(V;11Q23); MLL REARRANGED"
        S DIC("DR")="1///9807/3"
        S DINUM=98073
        D ICD3ADD
        ;
        S X="MIXED PHENOTYPE ACUTE LEUKEMIA, B/MYELOID, NOS"
        S DIC("DR")="1///9808/3"
        S DINUM=98083
        D ICD3ADD
        ;
        S X="MIXED PHENOTYPE ACUTE LEUKEMIA, T/MYELOID, NOS"
        S DIC("DR")="1///9809/3"
        S DINUM=98093
        D ICD3ADD
        ;
        S X="B LYMPHOBLASTIC LEUKEMIA/LYMPHOMA, NOS"
        S DIC("DR")="1///9811/3"
        S DINUM=98113
        D ICD3ADD
        ;
        S X="B LYMPHOBLASTIC LEUKEMIA/LYMPHOMA WITH T(9;22)(Q34;Q11.2); BCR-ABL1"
        S DIC("DR")="1///9812/3"
        S DINUM=98123
        D ICD3ADD
        ;
        S X="B LYMPHOBLASTIC LEUKEMIA/LYMPHOMA WITH T(V;11Q23); MLL REARRANGED"
        S DIC("DR")="1///9813/3"
        S DINUM=98133
        D ICD3ADD
        ;
        S X="B LYMPHOBLASTIC LEUKEMIA/LYMPHOMA WITH T(12;21)(P13;Q22); TEL-AML1 (ETV6-RUNX1)"
        S DIC("DR")="1///9814/3"
        S DINUM=98143
        D ICD3ADD
        ;
        S X="B LYMPHOBLASTIC LEUKEMIA/LYMPHOMA WITH HYPERDIPLOIDY"
        S DIC("DR")="1///9815/3"
        S DINUM=98153
        D ICD3ADD
        ;
        S X="B LYMPHOBLASTIC LEUKEMIA/LYMPHOMA WITH HYPODIPLOIDY (HYPODIPLOID ALL)"
        S DIC("DR")="1///9816/3"
        S DINUM=98163
        D ICD3ADD
        ;
        S X="B LYMPHOBLASTIC LEUKEMIA/LYMPHOMA WITH T(5;14)(Q31;Q32); IL3-IGH"
        S DIC("DR")="1///9817/3"
        S DINUM=98173
        D ICD3ADD
        ;
        S X="B LYMPHOBLASTIC LEUKEMIA/LYMPHOMA WITH T(1;19)(Q23;P13.3); E2A PBX1 (TCF3 PBX1)"
        S DIC("DR")="1///9818/3"
        S DINUM=98183
        D ICD3ADD
        ;
        S DIE="^ONCO(169.3,"
        S DA=98373
        S DR=".01///T LYMPHOBLASTIC LEUKEMIA/LYMPHOMA"
        D ^DIE
        ;
        S X="ACUTE MYELOID LEUKEMIA WITH T(6;9)(P23;Q34) DEK-NUP214"
        S DIC("DR")="1///9865/3"
        S DINUM=98653
        D ICD3ADD
        ;
        S X="ACUTE MYELOID LEUKEMIA WITH INV(3)(Q21Q26.2) OR T(3;3)(Q21;Q26.2); RPN1EVI1"
        S DIC("DR")="1///9869/3"
        S DINUM=98693
        D ICD3ADD
        ;
        S X="MYELOID LEUKEMIA ASSOCIATED WITH DOWN SYNDROME"
        S DIC("DR")="1///9898/3"
        S DINUM=98983
        D ICD3ADD
        ;
        S X="ACUTE MYELOID LEUKEMIA (MEGAKARYOBLASTIC) WITH T(1;22)(P13;Q13); RBM15-MKL1"
        S DIC("DR")="1///9911/3"
        S DINUM=99113
        D ICD3ADD
        ;
        S X="MYELOID AND LYMPHOID NEOPLASMS WITH PDGFRB REARRANGEMENT"
        S DIC("DR")="1///9965/3"
        S DINUM=99653
        D ICD3ADD
        ;
        S X="MYELOID AND LYMPHOID NEOPLASMS WITH PDGFRB ARRANGEMENT"
        S DIC("DR")="1///9966/3"
        S DINUM=99663
        D ICD3ADD
        ;
        S X="MYELOID AND LYMPHOID NEOPLASM WITH FGFR1 ABNORMALITIES"
        S DIC("DR")="1///9967/3"
        S DINUM=99673
        D ICD3ADD
        ;
        S X="POLYMORPHIC PTLD"
        S DIC("DR")="1///9971/3"
        S DINUM=99713
        D ICD3ADD
        ;
        S X="REFRACTORY NEUTROPENIA"
        S DIC("DR")="1///9991/3"
        S DINUM=99913
        D ICD3ADD
        ;
        S X="REFRACTORY THROMBOCYTOPENIA"
        S DIC("DR")="1///9992/3"
        S DINUM=99923
        D ICD3ADD
        ;
        S X="CHRONIC LYMPHOPROLIFERATIVE DISORDER OF NK-CELLS"
        S DIC("DR")="1///9831/3"
        S DINUM=98313
        D ICD3ADD
        ;
        S X="LANGERHANS CELL HISTIOCYTOSIS, NOS (9751/1)"
        S DIC("DR")="1///9751/3"
        S DINUM=97513
        D ICD3ADD
        ;
        S X="MYELODYSPLASTIC/MYELOPROLIFERATIVE NEOPLASM, UNCLASSIFIABLE"
        S DIC("DR")="1///9975/3"
        S DINUM=99753
        D ICD3ADD
        ;
        ;Add "LEUKEMIA" to SYNONYM/EQUIVALENT TERM (169.3,2) multiple for
        ;LEUKEMIAS 980-994
        N ICDIEN,LEUKFLG,SYNIEN
        S ICDIEN=98002
        F  S ICDIEN=$O(^ONCO(169.3,ICDIEN)) Q:ICDIEN>99483  D
        .S (SYNIEN,LEUKFLG)=0
        .F  S SYNIEN=$O(^ONCO(169.3,ICDIEN,1,SYNIEN)) Q:SYNIEN'>0  D
        ..I ^ONCO(169.3,ICDIEN,1,SYNIEN,0)="LEUKEMIA" S LEUKFLG=1
        .Q:LEUKFLG=1
        .S DA(1)=ICDIEN
        .S DIC="^ONCO(169.3,"_DA(1)_",1,"
        .S DIC(0)="L"
        .S X="LEUKEMIA"
        .D FILE^DICN
        ;
        Q
        ;
COC2    ;COC Conversion for CLASS OF CASE (165.5,.04) after Step 1
        N COCPNT
        S COCPNT=$$GET1^DIQ(165.5,IEN,.04,"I")
        Q:COCPNT=""
        S COC=$P($G(^ONCO(165.3,COCPNT,0)),U,1)
        I COC="00" S $P(^ONCO(165.5,IEN,0),U,4)=14
        I COC=10 S $P(^ONCO(165.5,IEN,0),U,4)=14
        I COC=20 S $P(^ONCO(165.5,IEN,0),U,4)=16
        Q
        ;
ICD3ADD ;Add new ICD-O-3 MORPHOLOGY (169.3) entries
        S DIC="^ONCO(169.3,",DIC(0)="L"
        D FILE^DICN
        K DIC,DINUM,X
        Q
