PRSACED1        ;HISC/REL/FPT,WCIOFO/JAH-T&A Edits (cont) ;02/16/02
        ;;4.0;PAID;**6,24,45,75,121**;Sep 21, 1995;Build 2
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        D STUB^PRSACED6
TK      ; entry point for time keepers
        S FLSA=$P(^PRSPC(DFN,0),U,12),PB=$P(^PRSPC(DFN,0),U,20)
        S PMP=$G(^PRSPC(DFN,"PREMIUM")),PMP=$P(PMP,U,6)
        S CNT=0
        I $E(NOR,1)'?1N S NOR=$F("+ABCDEF",$E(NOR,1))+8_$E(NOR,2)
        S CWK=$P($G(^PRST(458,PPI,"E",DFN,0)),"^",6)
        S HMX=$S(CWK'="C":720,1:800)
        ;
        ; initialize time storage array
        ;
        S (E(1),E(2),E(14),E(15),E(16),E(17))=0
        F K=13:1:23,26:1:28,48:1:60 S X=$P(C0,"^",K) I X'="" S LAB=$P(T0," ",K-12) D @LAB
        F K=1:1:5,8:1:10 S X=$P(C1,"^",K) I X'="" S LAB=$P(T1," ",K) D @LAB
        I E(1)>60!(E(2)>60) S ERR=34 D ERR^PRSACED
        G ^PRSACED2
RT      ;
RL      ;
AN      ;
AL      I X>HMX S ERR=1 D ERR^PRSACED
        I LVG=0 S ERR=10 D ERR^PRSACED
        Q
FA      ;
FB      ;
FC      ;
FD      ;
SK      ;
SL      I X>HMX S ERR=2 D ERR^PRSACED
        I LVG=0 S ERR=11 D ERR^PRSACED
        Q
NO      ;
NP      ;
WD      ;
WP      I X>HMX S ERR=3 D ERR^PRSACED
        I "45"[LVG,$E(X,3) S ERR=12 D ERR^PRSACED
        I DUT=3 S ERR=13 D ERR^PRSACED
        ;
        ;Store NO, NP, WD and WP in E(14), E(15), E(16), and E(17)
        S X1=$S(LAB="NO":14,LAB="NP":15,LAB="WD":16,1:17)
        S E(X1)=E(X1)+$E(X,1,2)+($E(X,3)*.25)
        Q
AD      ;
AF      ;
AU      ;
AB      I X>HMX S ERR=4 D ERR^PRSACED
        Q
CE      ;
CT      ;
CU      ;
CO      I X>HMX S ERR=5 D ERR^PRSACED
        Q:CWK="F"
        I "ABCKMNU0123456789"'[PAY S ERR=14 D ERR^PRSACED
        Q
FE      I X<1!(X>999999) S ERR=172 D ERR^PRSACED
        I PAY'="F" S ERR=172 D ERR^PRSACED
        Q
UN      ;
US      I X>$S(PAY="L"&(DUT=3):500,1:400) S ERR=15 D ERR^PRSACED
        I DUT=2,$P(C1,"^",31)'="" S ERR=16 D ERR^PRSACED
        I DUT=3,$P(C1,"^",31)="" S ERR=17 D ERR^PRSACED
        I PAY="T",DUT=3,NOR="00",X>70!($P(C1,"^",31)>14) S ERR=19 D ERR^PRSACED
        I DUT=1,"ABCGKMNRUY0123456789"'[PAY!($P(C1,"^",31))!(X>200) S ERR=20 D ERR^PRSACED
        Q
NA      ;
NR      Q:"ABCGKMNU0123456789"[PAY  S ERR=21 D ERR^PRSACED Q
NB      ;
NS      Q:"0123456789AGKMU"[PAY  S ERR=22 D ERR^PRSACED Q
SA      ;
SE      S MX=$S("ABCKMN"[PAY:400,1:320) I X>MX S ERR=25 D ERR^PRSACED
        I "ABCGKMNU0123456789"'[PAY S ERR=26 D ERR^PRSACED
        ;S X1=$S("AM"[PAY:"123",1:1) I X1'[DUT S ERR=27 D ERR^PRSACED; PRS*4*121
        S X1=LAB="SE"+1,E(X1)=E(X1)+$E(X,1,2)+($E(X,3)*.25)
        Q
SB      ;
SF      I X>240 S ERR=28 D ERR^PRSACED
        I "BGU0123456789"'[PAY S ERR=29 D ERR^PRSACED
        I DUT'=1 S ERR=30 D ERR^PRSACED
        S X1=LAB="SF"+1,E(X1)=E(X1)+$E(X,1,2)+($E(X,3)*.25)
        Q
SC      ;
SG      I "0123456789GU"'[PAY S ERR=32 D ERR^PRSACED
        I DUT'=1 S ERR=33 D ERR^PRSACED
        I X>240 S ERR=31 D ERR^PRSACED
        S X1=LAB="SG"+1,E(X1)=E(X1)+$E(X,1,2)+($E(X,3)*.25)
        Q
