ONCOPST ;HIRMFO/GWB-POST INIT FOR PATCH ONC*2.11*2  01/04/96
 ;;2.11;ONCOLOGY;**1,4**;Feb 01, 1996
 ;
 ;Replace REPORTING HOSPITAL (165.5,.03) pointer value with INSTITUTION
 ;ID NUMBER (160.1,27) value
 ;
 ;Prefix existing ACCESSION YEAR (165.5,.07) value with "19"
 ;
 ;Convert IMMUNOTHERAPY (165.5,55.2 and 165.51,.08) set-of-codes values
 ;of "0" to pointer values of "6"
 ;
 ;Convert TYPE of FIRST RECURRENCE (165.5,71) and TYPE of SUBSEQUENT
 ;RECURRENCE (165.572,.02) set-of-codes values of "0" to pointer values
 ;of "5"
 ;
 ;If the NON CANCER-DIRECTED SURGERY (165.5.58.1) code is 1-digit, set
 ;the CANCER-DIRECTED SUGERY (165.5,58.2) code to "00"
 ;If the NON CANCER-DIRECTED SURGERY (165.5.58.1) code is 2-digits, move
 ;it to the CANCER-DIRECTED SUGERY (165.5,58.2) field and set the NON
 ;CANCER-DIRECTED SURGERY code to "0"
 ;
 ;Convert STATE AT DIAGNOSIS (165.5,16) pointer values from pointers to
 ;the STATE (5) file to pointers to the new ACOS STATE AT DIAGNOSIS
 ;(160.19) file
 ;
 ;Convert POSTAL CODE AT DIAGNOSIS (165.5,9) pointer values to the
 ;actual postal code value
 ;
 ;Convert AJCC SUMMARY STAGE (165.5,38) values of 9 and O to 99 and 0C
 ;Convert AJCC SUMMARY STAGE (165.5,38) and STAGE GROUPING-AJCC
 ;(165.5,38.5) values of OCCULT to 0C and 0
 ;
 S OSPIEN=$O(^ONCO(160.1,0)),IIN=""
 I OSPIEN'="",$D(^ONCO(160.1,OSPIEN,1)) S IIN=$P(^ONCO(160.1,OSPIEN,1),"^",4)
 ;W !!," Converting the following fields in the Oncology Primary file:",!
 ;W !," REPORTING HOSPITAL                      .03"
 ;W !," POSTAL CODE AT DIAGNOSIS                  9"
 ;W !," STATE AT DIAGNOSIS                       16"
 ;W !," IMMUNOTHERAPY                          55.2"
 ;W !," NON CANCER-DIRECTED SURGERY            58.1"
 ;W !," CANCER-DIRECTED SURGERY                58.2"
 ;W !," TYPE OF FIRST RECURRENCE                 71"
 ;W !," TYPE OF SUBSEQUENT RECURRENCE   165.572,.02"
 ;W !," IMMUNOTHERAPY                    165.51,.08"
 S OPIEN=0 F CNT=1:1 S OPIEN=$O(^ONCO(165.5,OPIEN)) Q:OPIEN'>0  D  W:CNT#100=0 "."
 .S:IIN'="" $P(^ONCO(165.5,OPIEN,0),"^",3)=IIN
 .S AY=$P(^ONCO(165.5,OPIEN,0),"^",7)
 .S:$L(AY)=2 $P(^ONCO(165.5,OPIEN,0),"^",7)="19"_AY
 .I $D(^ONCO(165.5,OPIEN,2)) D
 ..I $P(^ONCO(165.5,OPIEN,2),"^",20)=9 S $P(^ONCO(165.5,OPIEN,2),"^",20)=99
 ..I $P(^ONCO(165.5,OPIEN,2),"^",20)="O" S $P(^ONCO(165.5,OPIEN,2),"^",20)="0C"
 ..I $P(^ONCO(165.5,OPIEN,2),"^",20)="OCCULT" S $P(^ONCO(165.5,OPIEN,2),"^",20)="0C"
 ..I $P(^ONCO(165.5,OPIEN,2),"^",28)="OCCULT" S $P(^ONCO(165.5,OPIEN,2),"^",28)=0
 ..S S=$P(^ONCO(165.5,OPIEN,0),"^",1),N2=$G(^(2)),TOP=$P(N2,"^",1),HIST=$P(N2,"^",3)
 ..I (S=35)!($$LEUKEMIA^ONCOAIP2(OPIEN))!((S>65)&(S<71)) D
 ...S M=$E(HIST,1,4),N=$S(M=9731:"999^10^9",1:"999^80^9")
 ...S N=N_"^99^99^9^0^0^7"
 ...S $P(^ONCO(165.5,OPIEN,2),"^",9,17)=N
 ...S $P(^ONCO(165.5,OPIEN,2),"^",20)=88
 ...S $P(^ONCO(165.5,OPIEN,2),"^",25)=88
 ...S $P(^ONCO(165.5,OPIEN,2),"^",26)=88
 ...S $P(^ONCO(165.5,OPIEN,2),"^",27)=88
 ..I (HIST=91402)!(HIST=91403) D
 ...S $P(^ONCO(165.5,OPIEN,2),"^",20)=88
 ...S $P(^ONCO(165.5,OPIEN,2),"^",25)=88
 ...S $P(^ONCO(165.5,OPIEN,2),"^",26)=88
 ...S $P(^ONCO(165.5,OPIEN,2),"^",27)=88
 ..I (S=65)!(TOP=67690)!(TOP=67695)!(TOP=67696)!(TOP=67698) S $P(^ONCO(165.5,OPIEN,2),"^",20)=88
 ..I TOP=67441 D
 ...Q:(HIST=87203)!(HIST=87443)!(HIST=87303)!(HIST=87223)!(HIST=87453)
 ...Q:(HIST=87713)!(HIST=87703)!(HIST=87202)!(HIST=87700)!(HIST=87423)
 ...Q:(HIST=87613)!(HIST=87403)!(HIST=87413)!(HIST=87233)!(HIST=87213)
 ...Q:(HIST=87723)!(HIST=87433)!(HIST=87412)!(HIST=87422)!(HIST=93630)
 ...Q:(HIST=95410)
 ...S $P(^ONCO(165.5,OPIEN,2),"^",20)=88
 .I $D(^ONCO(165.5,OPIEN,3)),$P(^ONCO(165.5,OPIEN,3),"^",19)=0 S $P(^ONCO(165.5,OPIEN,3),"^",19)=6
 .I $D(^ONCO(165.5,OPIEN,4)) S SCTIEN=0 F  S SCTIEN=$O(^ONCO(165.5,OPIEN,4,SCTIEN)) Q:SCTIEN'>0  I $D(^ONCO(165.5,OPIEN,4,SCTIEN,3)),$P(^ONCO(165.5,OPIEN,4,SCTIEN,3),"^",19)=0 S $P(^ONCO(165.5,OPIEN,4,SCTIEN,3),"^",19)=6
 .I $D(^ONCO(165.5,OPIEN,5)) D
 ..I $P(^ONCO(165.5,OPIEN,5),"^",1)="000000" S $P(^ONCO(165.5,OPIEN,5),"^",1)=2000000
 ..I $P(^ONCO(165.5,OPIEN,5),"^",2)=0 S $P(^ONCO(165.5,OPIEN,5),"^",2)=5
 .I $D(^ONCO(165.5,OPIEN,23)) S SRIEN=0 F  S SRIEN=$O(^ONCO(165.5,OPIEN,23,SRIEN)) Q:SRIEN'>0  I $P(^ONCO(165.5,OPIEN,23,SRIEN,0),"^",2)=0 S $P(^ONCO(165.5,OPIEN,23,SRIEN,0),"^",2)=5
 .I $D(^ONCO(165.5,OPIEN,3)) D
 ..I ($L($P(^ONCO(165.5,OPIEN,3),"^",27))=1)&($P(^ONCO(165.5,OPIEN,3),"^",38)="") S $P(^ONCO(165.5,OPIEN,3),"^",38)="00"
 ..I $L($P(^ONCO(165.5,OPIEN,3),"^",27))=2 S $P(^ONCO(165.5,OPIEN,3),"^",38)=$P(^ONCO(165.5,OPIEN,3),"^",27),$P(^ONCO(165.5,OPIEN,3),"^",27)=0
 .I $G(^ONCO(165.5,OPIEN,25))'="Y",$D(^ONCO(165.5,OPIEN,1)) S STP=$P(^ONCO(165.5,OPIEN,1),"^",4) I STP'="" S STN=$P(^DIC(5,STP,0),"^",1),STC=$P(^DIC(5,STP,0),"^",2) D  S $P(^ONCO(165.5,OPIEN,1),"^",4)=ASPT,$P(^ONCO(165.5,OPIEN,25),"^",1)="Y"
 ..I STC'="",$D(^ONCO(160.15,"B",STC)) S ASPT=$O(^ONCO(160.15,"B",STC,0)) Q
 ..I STN'="",$D(^ONCO(160.15,"D",STN)) S ASPT=$O(^ONCO(160.15,"D",STN,0)) Q
 ..S ASPT=68
 .I $G(^ONCO(165.5,OPIEN,26))'="Y",$D(^ONCO(165.5,OPIEN,1)) S PCADPT=$P(^ONCO(165.5,OPIEN,1),"^",2) I PCADPT'="",$D(^VIC(5.11,PCADPT)) D
 ..S PCAD=$P(^VIC(5.11,PCADPT,0),"^",1),CTAD=$P(^VIC(5.11,PCADPT,0),"^",2),$P(^ONCO(165.5,OPIEN,1),"^",2)=PCAD,$P(^ONCO(165.5,OPIEN,1),"^",12)=CTAD,$P(^ONCO(165.5,OPIEN,26),"^",1)="Y"
 K OSPIEN,IIN,OPIEN,AY,TOFR,STP,STN,STC,ASPT,PCADPT,PCAD,SRIEN,SCTIEN
 ;
 ;Kill the ACCESSION YEAR (165.5,.07) "AY", "AAY" and ""ACAY"
 ;cross-references and reindex them
 ;
 ;W !!," Re-indexing the AY, AAY, and ACAY cross-references on the"
 ;W !," ACCESSION YEAR (165.5,.07) field"
 K ^ONCO(165.5,"AY"),^ONCO(165.5,"AAY"),^ONCO(165.5,"ACAY")
 S DIK="^ONCO(165.5,",DIK(1)=.07 D ENALL^DIK
 K DIK
 ;
 ;Edit the N2 N-CLASS ENCODING (.01) entry in N-CLASS ENCODING (164.0651)
 ;multiple of the PROSTATE record in the ICDO TOPOGRAPHY (164) file
 S PIEN=$O(^ONCO(164,"B","PROSTATE",0))
 I PIEN'="" S DIE="^ONCO(164,PIEN,""N"",",DA(1)=PIEN,DA=4,DR=".01///"_"SINGLE LN>2cm-5cm/ MULT Nn<5cm" D ^DIE
 K PIEN,DIE,DA,DR
 ;Delete the first 10 entries in the CODE/DESCRIPTION (164.54) multiple
 ;of the SG9 ORAL CAVITY record in the SEER CODE SET file
 F NCDS=1:1:10 S DIE="^ONCO(164.5,179,1,",DA(1)=179,DA=NCDS,DR=".01///"_"@" D ^DIE
 K NCDS,DIE,DA,DR
 ;
 ;Call ONCOPST1 ACOS NUMBER file pointer conversion routine
 D ^ONCOPST1
