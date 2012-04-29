ONCSG1 ;Hines OIFO/GWB - AUTOMATIC STAGING TABLES ;6/20/02
 ;;2.11;ONCOLOGY;**35**;Mar 07, 1995
 ;
 ;DIGESTIVE SYSTEM
 ;
ESO1234 ;Esophagus - 1st, 2nd, 3rd and 4th editions
 I M[1 S SG=4
 E  I T["IS",N[0,M[0 S SG=0
 E  I T[1,N[0,M[0 S SG=1
 E  I (T[2)!(T[3),N[0,M[0 S SG="2A"
 E  I (T[1)!(T[2),N[1,M[0 S SG="2B"
 E  I T[3,N[1,M[0 S SG=3
 E  I T[4,M[0 S SG=3
 E  S SG=99
 Q
 ;
ESO56 ;Esophagus - 5th and 6th editions
 S TNM=T_N_M D  K TNM Q
 .I TNM="IS00" S SG=0 Q        ;0    Tis   N0    M0
 .I TNM=100 S SG=1 Q           ;I    T1    N0    M0
 .I TNM=200 S SG="2A" Q        ;IIA  T2    N0    M0
 .I TNM=300 S SG="2A" Q        ;     T3    N0    M0
 .I TNM=110 S SG="2B" Q        ;IIB  T1    N1    M0
 .I TNM=210 S SG="2B" Q        ;     T2    N1    M0
 .I TNM=310 S SG=3 Q           ;III  T3    N1    M0
 .I T=4,M=0 S SG=3 Q           ;     T4    Any N M0
 .I M=1 S SG=4 Q               ;IV   Any T Any N M1
 .I M="1A" S SG="4A" Q         ;IVA  Any T Any N M1a
 .I M="1B" S SG="4B" Q         ;IVB  Any T Any N M1b
 ;
STO34 ;Stomach - 3rd and 4th editions
 S TNM=T_N_M D  K TNM Q
 .I TNM="IS00" S SG=0 Q     ;0    Tis   N0    M0
 .I TNM=100 S SG="1A" Q     ;IA   T1    N0    M0
 .I TNM=110 S SG="1B" Q     ;IB   T1    N1    M0
 .I TNM=200 S SG="1B" Q     ;     T2    N0    M0
 .I TNM=120 S SG=2 Q        ;II   T1    N2    M0
 .I TNM=210 S SG=2 Q        ;     T2    N1    M0
 .I TNM=300 S SG=2 Q        ;     T3    N0    M0
 .I TNM=220 S SG="3A" Q     ;IIIA T2    N2    M0
 .I TNM=310 S SG="3A" Q     ;     T3    N1    M0
 .I TNM=400 S SG="3A" Q     ;     T4    N0    M0
 .I TNM=320 S SG="3B" Q     ;IIIB T3    N2    M0
 .I TNM=410 S SG="3B" Q     ;     T4    N1    M0
 .I TNM=420 S SG=4 Q        ;IV   T4    N2    M0
 .I M=1 S SG=4 Q            ;     Any T Any N M1
 ;
STO5 ;Stomach - 5th edition
 S TNM=T_N_M D  K TNM Q
 .I TNM="IS00" S SG=0 Q     ;0    Tis   N0    M0
 .I TNM=100 S SG="1A" Q     ;IA   T1    N0    M0
 .I TNM=110 S SG="1B" Q     ;IB   T1    N1    M0
 .I TNM=200 S SG="1B" Q     ;     T2    N0    M0
 .I TNM=120 S SG=2 Q        ;II   T1    N2    M0
 .I TNM=210 S SG=2 Q        ;     T2    N1    M0
 .I TNM=300 S SG=2 Q        ;     T3    N0    M0
 .I TNM=220 S SG="3A" Q     ;IIIA T2    N2    M0
 .I TNM=310 S SG="3A" Q     ;     T3    N1    M0
 .I TNM=400 S SG="3A" Q     ;     T4    N0    M0
 .I TNM=320 S SG="3B" Q     ;IIIB T3    N2    M0
 .I TNM=410 S SG=4 Q        ;IV   T4    N1    M0
 .I TNM=130 S SG=4 Q        ;     T1    N3    M0
 .I TNM=230 S SG=4 Q        ;     T2    N3    M0
 .I TNM=330 S SG=4 Q        ;     T3    N3    M0
 .I TNM=420 S SG=4 Q        ;     T4    N2    M0
 .I TNM=430 S SG=4 Q        ;     T4    N3    M0
 .I M=1 S SG=4 Q            ;     Any T Any N M1
 ;
STO6 ;Stomach - 6th edition
 S TNM=T_N_M D  K TNM Q
 .I TNM="IS00" S SG=0 Q     ;0    Tis   N0    M0
 .I TNM=100 S SG="1A" Q     ;IA   T1    N0    M0
 .I TNM=110 S SG="1B" Q     ;IB   T1    N1    M0
 .I TNM="2A00" S SG="1B" Q  ;     T2a   N0    M0
 .I TNM="2B00" S SG="1B" Q  ;     T2b   N0    M0
 .I TNM=120 S SG=2 Q        ;II   T1    N2    M0
 .I TNM="2A10" S SG=2 Q     ;     T2a   N1    M0
 .I TNM="2B10" S SG=2 Q     ;     T2b   N1    M0
 .I TNM=300 S SG=2 Q        ;     T3    N0    M0
 .I TNM="2A20" S SG="3A" Q  ;IIIA T2a   N2    M0
 .I TNM="2B20" S SG="3A" Q  ;     T2b   N2    M0
 .I TNM=310 S SG="3A" Q     ;     T3    N1    M0
 .I TNM=400 S SG="3A" Q     ;     T4    N0    M0
 .I TNM=320 S SG="3B" Q     ;IIIB T3    N2    M0
 .I TNM=410 S SG=4 Q        ;IV   T4    N1    M0
 .I TNM=130 S SG=4 Q        ;     T1    N3    M0
 .I TNM="2A30" S SG=4 Q     ;     T2a   N3    M0
 .I TNM="2B30" S SG=4 Q     ;     T2b   N3    M0
 .I TNM=330 S SG=4 Q        ;     T3    N3    M0
 .I TNM=420 S SG=4 Q        ;     T4    N2    M0
 .I TNM=430 S SG=4 Q        ;     T4    N3    M0
 .I M=1 S SG=4 Q            ;     Any T Any N M1
 ;
SI ;Small Intestine - 4th, 5th and 6th editions
 I M S SG=4
 E  I T["IS",N[0,M[0 S SG=0
 E  I (T[1)!(T[2),N[0,M[0 S SG=1
 E  I (T[3)!(T[4),N[0,M[0 S SG=2
 E  I N[1,M[0 S SG=3
 E  S SG=99
 Q
 ;
COL34 ;Colon and Rectum - 3rd and 4th editions
 S TNM=T_N_M D  K TNM Q
 .I TNM="IS00" S SG=0 Q     ;0    Tis   N0    M0
 .I TNM=100 S SG=1 Q        ;I    T1    N0    M0
 .I TNM=200 S SG=1 Q        ;     T2    N0    M0
 .I TNM=300 S SG=2 Q        ;II   T3    N0    M0
 .I TNM=400 S SG=2 Q        ;     T4    N0    M0
 .I N=1,M=0 S SG=3 Q        ;III  Any T N1    M0
 .I N=2,M=0 S SG=3 Q        ;     Any T N2    M0
 .I N=3,M=0 S SG=3 Q        ;     Any T N3    M0
 .I M=1 S SG=4 Q            ;IV   Any T Any N M1
 ;
COL5 ;Colon and Rectum - 5th edition
 S TNM=T_N_M D  K TNM Q
 .I TNM="IS00" S SG=0 Q     ;0    Tis   N0    M0
 .I TNM=100 S SG=1 Q        ;I    T1    N0    M0
 .I TNM=200 S SG=1 Q        ;     T2    N0    M0
 .I TNM=300 S SG=2 Q        ;II   T3    N0    M0
 .I TNM=400 S SG=2 Q        ;     T4    N0    M0
 .I N=1,M=0 S SG=3 Q        ;III  Any T N1    M0
 .I N=2,M=0 S SG=3 Q        ;     Any T N2    M0
 .I M=1 S SG=4 Q            ;IV   Any T Any N M1
 ;
COL6 ;Colon and Rectum - 6th edition
 S TNM=T_N_M D  K TNM Q
 .I TNM="IS00" S SG=0 Q     ;0    Tis   N0    M0
 .I TNM=100 S SG=1 Q        ;I    T1    N0    M0
 .I TNM=200 S SG=1 Q        ;     T2    N0    M0
 .I TNM=300 S SG="2A" Q     ;IIA  T3    N0    M0
 .I TNM=400 S SG="2B" Q     ;IIB  T4    N0    M0
 .I TNM=110 S SG="3A" Q     ;IIIA T1    N1    M0
 .I TNM=210 S SG="3A" Q     ;     T2    N1    M0
 .I TNM=310 S SG="3B" Q     ;IIIB T3    N1    M0
 .I TNM=410 S SG="3B" Q     ;     T4    N1    M0
 .I N=2,M=0 S SG="3C" Q     ;IIIC Any T N2    M0
 .I M=1 S SG=4 Q            ;IV   Any T Any N M1
 ;
AC ;Anal Canal - all editions
 S TNM=T_N_M D  K TNM Q
 .I TNM="IS00" S SG=0 Q     ;0    Tis   N0    M0
 .I TNM=100 S SG=1 Q        ;I    T1    N0    M0
 .I TNM=200 S SG=2 Q        ;II   T2    N0    M0
 .I TNM=300 S SG=2 Q        ;     T3    N0    M0
 .I TNM=110 S SG="3A" Q     ;IIIA T1    N1    M0
 .I TNM=210 S SG="3A" Q     ;     T2    N1    M0
 .I TNM=310 S SG="3A" Q     ;     T3    N1    M0
 .I TNM=400 S SG="3A" Q     ;     T4    N0    M0
 .I TNM=410 S SG="3B" Q     ;IIIB T4    N1    M0
 .I N=2,M=0 S SG="3B" Q     ;     Any T N2    M0
 .I N=3,M=0 S SG="3B" Q     ;     Any T N3    M0
 .I M=1 S SG=4 Q            ;IV   Any T Any N M1
