PRSACED6        ; HISC/FPT-T&A Cross-Edits ;11/27/95  10:01
        ;;4.0;PAID;**6,45,112**;Sep 21, 1995;Build 54
        ;;Per VHA Directive 2004-038, this routine should not be modified.
CODES   ; Set variables T0 and T1 with 8B code list
        ;      1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67
        ;
        S T0="AN SK WD NO AU RT CE CU UN NA NB SP DA SA SB SC OA OB OC OK DB OM RA RB RC HA HB HC HD PT PA ON VC EA EB AL SL WP NP AB RL FA FB FC FD AD AF FE",N1=60
        S T1="CT CO US NR NS DC TF SE SF SG OE OF OG OS TA OU RE RF RG HL HM HN HO PH PB CL VS EC ED NL DW IN TL LU LN LD TO LA ML CA PC TC CY RR SQ FF DE DF YA DG TG YD YE TB DT YH TD NT NH RS RN ND NU SR SS SD SH",N2=67
        Q
STUB    ; parse out 'stub' variables from 8b record
        S RECORD=^PRST(458,PPI,"E",DFN,5)
        S STA=$E(RECORD,2,4)
        S SSN=$E(RECORD,5,13)
        S NCODE=$E(RECORD,14,16)
        S DAYNO=$E(RECORD,17,19)
        S TL=$E(RECORD,22,24)
        S LVG=$E(RECORD,25)
        S NOR=$E(RECORD,26,27)
        S PAY=$E(RECORD,28)
        S DUT=$E(RECORD,29)
        S RECORD=$E(RECORD,33,$L(RECORD))
        S (C0,C1)="",EOR=0
        Q:RECORD=""
TYPE    ; parse out type of time from 8b record
        I EOR=1 K EOR,LOOP,MATCH,RECORD,TYPE,VALUE Q
        S TYPE=$E(RECORD,1,2)
        I TYPE="CD" S VALUE=$E(RECORD,3,$L(RECORD)) D CD S EOR=1 G TYPE
        F LOOP=3:1:$L(RECORD) Q:$E(RECORD,LOOP)?1U
        S:LOOP=$L(RECORD) EOR=1
        S VALUE=$S(EOR=1:$E(RECORD,3,LOOP),1:$E(RECORD,3,LOOP-1))
        S:EOR=0 RECORD=$E(RECORD,LOOP,$L(RECORD))
        S MATCH=0
        S Z=$F(T0,TYPE)
        I Z>2 S $P(C0,"^",(Z/3)+12)=VALUE,MATCH=1
        G:MATCH=1 TYPE
        S Z=$F(T1,TYPE)
        I Z>2 S $P(C1,"^",Z/3)=VALUE
        G TYPE
CD      ; calculate/compare cd value
        S END=$L(C0,"^"),CD=0
        F LOOP=13:1:END S CD=CD+$P(C0,"^",LOOP)
        S END=$L(C1,"^")
        F LOOP=1:1:END S CD=CD+$P(C1,"^",LOOP)
        I CD'=+VALUE W !,"THE CD VALUE DID NOT ADD UP CORRECTLY FOR ",$P($G(^PRSPC(DFN,0)),"^",1)
        K CD,END Q
