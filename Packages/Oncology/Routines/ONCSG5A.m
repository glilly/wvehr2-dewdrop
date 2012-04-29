ONCSG5A ;Hines OIFO/GWB - AUTOMATIC STAGING TABLES ;07/15/02
 ;;2.11;ONCOLOGY;**35,37**;Mar 07, 1995
 ;
RPU3 ;Renal Pelvis and Ureter - 3rd edition
 S TNM=T_N_M D  K TNM Q
 .I TNM="IS00" S SG=0 Q
 .I TNM="A00" S SG=0  Q
 .I TNM=100 S SG=1 Q
 .I TNM=200 S SG=2 Q
 .I TNM=300 S SG=3 Q
 .I TNM=400 S SG=4 Q
 .I N=1,M=0 S SG=4 Q
 .I N=2,M=0 S SG=4 Q
 .I N=3,M=0 S SG=4 Q
 .I M=1 S SG=4 Q
 ;
RPU456 ;Renal Pelvis and Ureter - 4th, 5th and 6th editions
 S TNM=T_N_M D  K TNM Q
 .I TNM="A00" S SG="0A" Q    ;0a   Ta    N0    M0
 .I TNM="IS00" S SG="0IS" Q  ;0is  Tis   N0    M0
 .I TNM=100 S SG=1 Q         ;I    T1    N0    M0
 .I TNM=200 S SG=2 Q         ;II   T2    N0    M0
 .I TNM=300 S SG=3 Q         ;III  T3    N0    M0
 .I TNM=400 S SG=4 Q         ;IV   T4    N0    M0
 .I N=1,M=0 S SG=4 Q         ;     Any T N1    M0
 .I N=2,M=0 S SG=4 Q         ;     Any T N2    M0
 .I N=3,M=0 S SG=4 Q         ;     Any T N3    M0
 .I M=1 S SG=4 Q             ;     Any T Any N M1
 ;
UB3 ;Urinary bladder - 3rd edition
 I (M=1)!(N=1)!(N=2)!(N=3) S SG=4
 E  I N=0,M=0 S SG=$S(T="IS":0,T="A":0,T=1:1,T=2:2,T[3:3,T=4:4,1:99)
 Q
 ;
UB4 ;Urinary bladder - 4th edition
 I M!(N=1)!(N=2)!(N=3)!(T="4B") S SG=4
 E  I T="A",N=0,M=0 S SG="0a"
 E  I T="IS",N=0,M=0 S SG="0is"
 E  I T[1,N=0,M=0 S SG=1
 E  I (T[2)!(T["3A"),N=0,M=0 S SG=2
 E  I (T["3B")!(T["4A"),N=0,M=0 S SG=3
 E  S SG=99
 Q
 ;
UB56 ;Urinary bladder - 5th and 6th editions
 S TNM=T_N_M D  K TNM Q
 .I TNM="A00" S SG="0A" Q    ;0a   Ta    N0    M0
 .I TNM="IS00" S SG="0IS" Q  ;0is  Tis   N0    M0
 .I TNM=100 S SG=1 Q         ;I    T1    N0    M0
 .I TNM=200 S SG=2 Q         ;II   T2    N0    M0
 .I TNM="2A00" S SG=2 Q      ;     T2a   N0    M0
 .I TNM="2B00" S SG=2 Q      ;     T2b   N0    M0
 .I TNM=300 S SG=3 Q         ;III  T3    N0    M0
 .I TNM="3A00" S SG=3 Q      ;     T3a   N0    M0
 .I TNM="3B00" S SG=3 Q      ;     T3b   N0    M0
 .I TNM="4A00" S SG=3 Q      ;     T4a   N0    M0
 .I TNM="4B00" S SG=4 Q      ;IV   T4b   N0    M0
 .I N=1,M=0 S SG=4 Q         ;     Any T N1    M0
 .I N=2,M=0 S SG=4 Q         ;     Any T N2    M0
 .I N=3,M=0 S SG=4 Q         ;     Any T N3    M0
 .I M=1 S SG=4 Q             ;     Any T Any N M1
 ;
U3 ;Urethra - 3rd edition
 S SG=99
 I M=1 S SG=4
 E  I M=0 D
 .I (N=2)!(N=3) S SG=4
 .E  I N=1 S SG=$S(T=4:4,(T=1)!(T=2)!(T=3):3,1:9)
 .E  I N=0 S SG=+T
 Q
 ;
U4 ;Urethra - 4th edition
 K SG
 I M=1 S SG=4
 E  I M=0 D UR4NM
 I '$D(SG) S SG=99
 Q
UR4NM I N=0 S SG=T
 E  I N=1 D
 .I (T=1)!(T=2)!(T=3) S SG=3
 .E  I T=4 S SG=4
 E  I (N=2)!(N=3) S SG=4
 Q
 ;
U56 ;Urethra - 5th and 6th editions
 S TNM=T_N_M D  K TNM Q
 .I TNM="A00" S SG="0A" Q       ;0a   Ta     N0    M0
 .I TNM="IS00" S SG="0IS" Q     ;0is  Tis    N0    M0
 .I TNM="IS PU00" S SG="0IS" Q  ;     Tis pu N0    M0
 .I TNM="IS PD00" S SG="0IS" Q  ;     Tis pd N0    M0
 .I TNM=100 S SG=1 Q            ;I    T1     N0    M0
 .I TNM=200 S SG=2 Q            ;II   T2     N0    M0
 .I TNM=110 S SG=3 Q            ;III  T1     N1    M0
 .I TNM=210 S SG=3 Q            ;     T2     N1    M0
 .I TNM=300 S SG=3 Q            ;     T3     N0    M0
 .I TNM=310 S SG=3 Q            ;     T3     N1    M0
 .I TNM=400 S SG=4 Q            ;IV   T4     N0    M0
 .I TNM=410 S SG=4 Q            ;     T4     N1    M0
 .I N=2,M=0 S SG=4 Q            ;     Any T  N2    M0
 .I M=1 S SG=4 Q                ;     Any T  Any N M1
 ;
 ;OPHTHALMIC SITES
 ;
MME34 ;Malignant Melanoma of the Eyelid - 3rd and 4th editions
 S TNM=$E(T,1)_$E(N,1)_$E(M,1) D  K TNM Q
 .I TNM=100 S SG=1 Q         ;I    T1    N0    M0
 .I TNM=200 S SG=1 Q         ;     T2    N0    M0
 .I TNM=300 S SG=2 Q         ;II   T3    N0    M0
 .I TNM=400 S SG=3 Q         ;III  T4    N0    M0
 .I N=1,M=0 S SG=3 Q         ;     Any T N1    M0
 .I N=2,M=0 S SG=3 Q         ;     Any T N2    M0
 .I M=1 S SG=4 Q             ;     Any T Any N M1
 ;
 ;Malignant Melanoma of the Uvea - 3rd, 4th and 5th edtions
CHO345 ;Choroid
 I M=1 S SG="4B"
 E  I M=0 D
 .I N=1 S SG="4B"
 .E  I N=0 S SG=$S(T=4:"4A",T=3:3,T=2:2,T="1B":"1B",T="1A":"1A",1:99)
 Q
 ;
CBI345 ;Ciliary Body and iris
 I M=1 S SG="4B"
 E  I M=0 D
 .I N=1 S SG="4B"
 .E  I N=0 S SG=$S(T=4:"4A",T=3:3,T=2:2,T=1:1,1:99)
 Q
 ;
MMU6 ;Malignant Melanoma of the Uvea - 6th edtion
 S TNM=T_N_M D  K TNM Q
 .I TNM=100 S SG=1 Q            ;I    T1     N0    M0
 .I TNM="1A00" S SG=1 Q         ;     T1a    N0    M0
 .I TNM="1B00" S SG=1 Q         ;     T1b    N0    M0
 .I TNM="1C00" S SG=1 Q         ;     T1c    N0    M0
 .I TNM=200 S SG=2 Q            ;II   T2     N0    M0
 .I TNM="2A00" S SG=2 Q         ;     T2a    N0    M0
 .I TNM="2B00" S SG=2 Q         ;     T2b    N0    M0
 .I TNM="2C00" S SG=2 Q         ;     T2c    N0    M0
 .I TNM=300 S SG=3 Q            ;III  T3     N0    M0
 .I TNM="3A00" S SG=3 Q         ;     T3a    N0    M0
 .I TNM=400 S SG=3 Q            ;     T4     N0    M0
 .I N=1,M=0 S SG=4 Q            ;IV   Any T  N1    M0
 .I M=1 S SG=4 Q                ;     Any T  Any N M1
 ;
RET345 ;Retinoblastoma - 3rd, 4th and 5th editions
 S SG=99
 I M=1 S SG=4
 E  I M=0 D
 .I N=1 S SG=4
 .E  I N=0 S SG=$S(T=1:"1A",T=2:"1B",T="3A":"2A",T="3B":"2B",T="3C":"2C",T="4A":"3A",T="4B":"3B",1:99)
 Q
 ;
 ;CENTRAL NERVOUS SYSTEM
 ;
BSC34 ;Brain and Spincal Cord - 3rd and 4th editions
 S SG=99
 I M=1 S SG=4
 E  I M=0 D BNNM
 Q
BNNM I G=4 S SG=4
 E  I (G=1)!(G=2)!(G=3) D
 .I T=4 S SG=4
 .E  I (T=2)!(T=3) S SG=G_"B"
 .E  I T=1 S SG=G_"A"
 Q
 ;
 ;LYMPHOID NEOPLASMS
 ;
MF6 ;Mycosis fungoides - 6th edition
 S TNM=T_N_M D  K TNM Q
 .I TNM=100 S SG="1A" Q      ;IA   T1    N0    M0
 .I TNM=200 S SG="1B" Q      ;IB   T2    N0    M0
 .I TNM=110 S SG="2A" Q      ;IIA  T1    N1    M0
 .I TNM=210 S SG="2A" Q      ;     T2    N1    M0
 .I TNM=300 S SG="2B" Q      ;IIB  T3    N0    M0
 .I TNM=310 S SG="2B" Q      ;     T3    N1    M0
 .I TNM=400 S SG="3A" Q      ;IIIA T4    N0    M0
 .I TNM=410 S SG="3B" Q      ;IIIB T4    N1    M0
 .I N=2,M=0 S SG="4A" Q      ;IVA  Any T N2    M0
 .I N=3,M=0 S SG="4A" Q      ;     Any T N3    M0
 .I M=1 S SG="4B" Q          ;IVB  Any T Any N M1
