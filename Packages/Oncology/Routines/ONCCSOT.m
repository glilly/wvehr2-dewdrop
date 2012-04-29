ONCCSOT ;Hines OIFO/GWB - COLLABORATIVE STAGING OUTPUT;03/04/04
 ;;2.11;ONCOLOGY;**40**;Mar 07, 1995
 ;
TOT ;DERIVED AJCC T (165.5,160) OUTPUT TRANSFORM
 I Y=99 S Y="TX" Q
 I Y="00" S Y="T0" Q
 I Y="01" S Y="Ta" Q
 I Y="05" S Y="Tis" Q
 I Y="06" S Y="Tispu (urethra only)" Q
 I Y="07" S Y="Tispd (urethra only)" Q
 I Y=10 S Y="T1" Q
 I Y=11 S Y="T1mic" Q
 I Y=19 S Y="T1 NOS" Q
 I Y=12 S Y="T1a" Q
 I Y=13 S Y="T1a1" Q
 I Y=14 S Y="T1a2" Q
 I Y=15 S Y="T1b" Q
 I Y=16 S Y="T1b1" Q
 I Y=17 S Y="T1b2" Q
 I Y=18 S Y="T1c" Q
 I Y=20 S Y="T2" Q
 I Y=29 S Y="T2 NOS" Q
 I Y=21 S Y="T2a" Q
 I Y=22 S Y="T2b" Q
 I Y=23 S Y="T2c" Q
 I Y=30 S Y="T3" Q
 I Y=39 S Y="T3 NOS" Q
 I Y=31 S Y="T3a" Q
 I Y=32 S Y="T3b" Q
 I Y=33 S Y="T3c" Q
 I Y=40 S Y="T4" Q
 I Y=49 S Y="T4 NOS" Q
 I Y=41 S Y="T4a" Q
 I Y=42 S Y="T4b" Q
 I Y=43 S Y="T4c" Q
 I Y=44 S Y="T4d" Q
 I Y=88 S Y="Not applicable" Q
 Q
 ;
NOT ;DERIVED AJCC N (165.5,162) OUTPUT TRANSFORM
 I Y=99 S Y="NX" Q
 I Y="00" S Y="N0" Q
 I Y="09" S Y="N0 NOS" Q
 I Y="01" S Y="N0(i-)" Q
 I Y="02" S Y="N0(i+)" Q
 I Y="03" S Y="N0(mol-)" Q
 I Y="04" S Y="N0(mol+)" Q
 I Y=10 S Y="N1" Q
 I Y=19 S Y="N1 NOS" Q
 I Y=11 S Y="N1a" Q
 I Y=12 S Y="N1b" Q
 I Y=13 S Y="N1c" Q
 I Y=18 S Y="N1mi" Q
 I Y=20 S Y="N2" Q
 I Y=29 S Y="N2 NOS" Q
 I Y=21 S Y="N2a" Q
 I Y=22 S Y="N2b" Q
 I Y=23 S Y="N2c" Q
 I Y=30 S Y="N3" Q
 I Y=39 S Y="N3 NOS" Q
 I Y=31 S Y="N3a" Q
 I Y=32 S Y="N3b" Q
 I Y=33 S Y="N3c" Q
 I Y=88 S Y="Not applicable" Q
 Q
 ;
MOT ;DERIVED AJCC M (165.5,164) OUTPUT TRANSFORM
 I Y="00" S Y="M0" Q
 I Y=10 S Y="M1" Q
 I Y=11 S Y="M1a" Q
 I Y=12 S Y="M1b" Q
 I Y=13 S Y="M1c" Q
 I Y=19 S Y="M1 NOS" Q
 I Y=88 S Y="Not applicable" Q
 I Y=99 S Y="MX" Q
 Q
 ;
SGOT ;DERIVED AJCC STAGE GROUP (165.5,166) OUTPUT TRANSFORM
 I Y="00" S Y="Stage 0" Q
 I Y="01" S Y="Stage 0a" Q
 I Y="02" S Y="Stage 0is" Q
 I Y=10 S Y="Stage I" Q
 I Y=11 S Y="Stage I NOS" Q
 I Y=12 S Y="Stage IA" Q
 I Y=13 S Y="Stage IA1" Q
 I Y=14 S Y="Stage IA2" Q
 I Y=15 S Y="Stage IB" Q
 I Y=16 S Y="Stage IB1" Q
 I Y=17 S Y="Stage IB2" Q
 I Y=18 S Y="Stage IC" Q
 I Y=19 S Y="Stage IS" Q
 I Y=23 S Y="Stage ISA (lymphoma only)" Q
 I Y=24 S Y="Stage ISB (lymphoma only)" Q
 I Y=20 S Y="Stage IEA (lymphoma only)" Q
 I Y=21 S Y="Stage IEB (lymphoma only)" Q
 I Y=22 S Y="Stage IE (lymphoma only)" Q
 I Y=30 S Y="Stage II" Q
 I Y=31 S Y="Stage II NOS" Q
 I Y=32 S Y="Stage IIA" Q
 I Y=33 S Y="Stage IIB" Q
 I Y=34 S Y="Stage IIC" Q
 I Y=35 S Y="Stage IIEA (lymphoma only)" Q
 I Y=36 S Y="Stage IIEB (lymphoma only)" Q
 I Y=37 S Y="Stage IIE (lymphoma only)" Q
 I Y=38 S Y="Stage IISA (lymphoma only)" Q
 I Y=39 S Y="Stage IISB (lymphoma only)" Q
 I Y=40 S Y="Stage IIS (lymphoma only)" Q
 I Y=41 S Y="Stage IIESA (lymphoma only)" Q
 I Y=42 S Y="Stage IIESB (lymphoma only)" Q
 I Y=43 S Y="Stage IIES (lymphoma only)" Q
 I Y=50 S Y="Stage III" Q
 I Y=51 S Y="Stage III NOS" Q
 I Y=52 S Y="Stage IIIA" Q
 I Y=53 S Y="Stage IIIB" Q
 I Y=54 S Y="Stage IIIC" Q
 I Y=55 S Y="Stage IIIEA (lymphoma only)" Q
 I Y=56 S Y="Stage IIIEB (lymphoma only)" Q
 I Y=57 S Y="Stage IIIE (lymphoma only)" Q
 I Y=58 S Y="Stage IIISA (lymphoma only)" Q
 I Y=59 S Y="Stage IIISB (lymphoma only)" Q
 I Y=60 S Y="Stage IIIS (lymphoma only)" Q
 I Y=61 S Y="Stage IIIESA (lymphoma only)" Q
 I Y=62 S Y="Stage IIIESB (lymphoma only)" Q
 I Y=63 S Y="Stage IIIES (lymphoma only)" Q
 I Y=70 S Y="Stage IV" Q
 I Y=71 S Y="Stage IV NOS" Q
 I Y=72 S Y="Stage IVA" Q
 I Y=73 S Y="Stage IVB" Q
 I Y=74 S Y="Stage IVC" Q
 I Y=88 S Y="Not applicable" Q
 I Y=90 S Y="Stage Occult" Q
 I Y=99 S Y="Stage Unknown"
 Q
