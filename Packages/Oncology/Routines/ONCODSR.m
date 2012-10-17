ONCODSR ;Hines OIFO/GWB - Surgery of Primary Site ;06/23/10
        ;;2.11;ONCOLOGY;**1,5,6,7,11,13,15,16,18,27,36,37,42,46,47,48,50,51**;Mar 07, 1995;Build 65
        ;
        ;^ONCO(164.2,9,"S",1-10) hold SURGICAL DX/STAGING PROC codes 0-9
        ;^ONCO(164.2,SITE/GP,"S",11-100) holds surgery coes 10-99
        ;
CDSIT   ;SURGERY OF PRIMARY SITE (165.5,58.2) INPUT TRANSFORM
        N T,TOPGRPHY,SS
        K:$L(X)>2!(X'?1.N) X G EX:'$D(X)
        I X="00" W "  00 No surgical procedure" G EX
        S TOPGRPHY=$$TOPGRPHY(D0) G ER:TOPGRPHY=""
        S SS=+$P($G(^ONCO(164,TOPGRPHY,"SR")),U,$$EDITION^ONCOU55(D0))
        I '$D(^ONCO(164.5,SS,1,X+1,0)) K X G EX
        I ($P(^ONCO(165.5,D0,0),U,16)>2951231),$E(X,2)=8 K X G EX
        W "  ",^ONCO(164.5,SS,1,X+1,0) G EX
        ;
NCDSIT  ;SURGICAL DX/STAGING PROC (165.5,58.1) INPUT TRANSFORM
        I '$D(^ONCO(160.14,"B",X)) K X G EX
        I $L(X)'=2 K X G EX
        S NCDSIEN=$O(^ONCO(160.14,"B",X,0))
        W "  ",$P(^ONCO(160.14,NCDSIEN,0),U,2)
        K NCDSIEN Q
        ;
NCDSOT  ;SURGICAL DX/STAGING PROC (165.5,58.1) OUTPUT TRANSFORM
        Q:Y=""
        S NCDSIEN=$O(^ONCO(160.14,"B",Y,0))
        I NCDSIEN'="" S Y=Y_" "_$P(^ONCO(160.14,NCDSIEN,0),U,2)
        G EX
        ;
HP0     ;SURGICAL DX/STAGING PROC (165.5,58.1) HELP
        F XX="00","01","02","03","04","05","06","07","09" S NCDSIEN=$O(^ONCO(160.14,"B",XX,0)) W !," ",$P(^ONCO(160.14,NCDSIEN,0),U,1),"  ",$P(^ONCO(160.14,NCDSIEN,0),U,2)
        W !
        K NCDSIEN G EX
        ;
CDSOT   ;SURGERY OF PRIMARY SITE (165.5,58.2) OUTPUT TRANSFORM
        I Y="00" S Y="00 No surgical procedure" G EX
        N TOPGRPHY,SS
        S TOPGRPHY=$$TOPGRPHY(D0) G EX:TOPGRPHY=""
        S SS=+$P($G(^ONCO(164,TOPGRPHY,"SR")),U,$$EDITION^ONCOU55(D0))
        S Y=Y_" "_$G(^ONCO(164.5,SS,1,Y+1,0)) G EX
        ;
HP1     ;SURGERY OF PRIMARY SITE (165.5,58.2) HELP
        N TOPGRPHY,TPGRPHYR,SS,XX,XXX
        S TOPGRPHY=$$TOPGRPHY(D0) G:TOPGRPHY="" ER
        S TPGRPHYR=^ONCO(164,TOPGRPHY,0)
        S SS=$P($G(^ONCO(164,TOPGRPHY,"SR")),U,$$EDITION^ONCOU55(D0))
        W !?5,"SURGERY OF PRIMARY SITE Codes for site ",$P(TPGRPHYR,U,2)," "
        W $P(TPGRPHYR,U),!?5,"(",$P(^ONCO(164.5,SS,0),U),")",!!
        W " ","00  No surgical procedure",!
        S XX=10 F  S XX=$O(^ONCO(164.5,SS,1,XX)) Q:XX'=+XX  D
        .S XXX=XX-1
        .I ($P(^ONCO(165.5,D0,0),U,16)<2960000)!($E(XXX,2)'=8) W " ",(XX-1)_"  "_^ONCO(164.5,SS,1,XX,0),!
        G EX
        ;
ER      ;ERROR
        W !!,?10,"ICDO CODE NOT defined!! - cannot continue",! G EX
        ;
EX      ;EXIT
        K AN,SS,ONCOSR
        Q
        ;
TOPGRPHY(PRIMIX)        ; returns ICDO-2 topography code for primary site PRIMIX
        Q $P($G(^ONCO(165.5,PRIMIX,2)),U)
        ;
ESSPIT  ;INPUT TRANSFORM FOR EXTRANODAL SITE SURGICAL PROCEDURE #856
        N T,TOPGRPHY,SS
        K:$L(X)>2!(X'?1.N) X G EX:'$D(X)
        I X="00" W "  No additional surgical procedure" G EX
        S TOPGRPHY=$P($G(^ONCO(165.5,D0,"NHL2")),U,10) G ER:TOPGRPHY=""
        I TOPGRPHY="C888"!(TOPGRPHY="C999") K X G EX
        S TOPGRPHY="67"_$E(TOPGRPHY,2,4)
        S SS=+$P($G(^ONCO(164,TOPGRPHY,"SR")),U,$$EDITION^ONCOU55(D0))
        I '$D(^ONCO(164.5,SS,1,X+1,0)) K X G EX
        I ($P(^ONCO(165.5,D0,0),U,16)>2951231),$E(X,2)=8 K X G EX
        W "  ",^ONCO(164.5,SS,1,X+1,0) G EX
        ;
ESSPOT  ;OUTPUT TRANSFORM FOR EXTRANODAL SITE SURGICAL PROCEDURE #856
        I Y="00" S Y=Y_"  No additional surgical procedure" G EX
        N TOPGRPHY,SS
        S TOPGRPHY=$P($G(^ONCO(165.5,D0,"NHL2")),U,10) G EX:TOPGRPHY=""
        I TOPGRPHY="C888"!(TOPGRPHY="C999") G EX
        S TOPGRPHY="67"_$E(TOPGRPHY,2,4)
        S SS=+$P($G(^ONCO(164,TOPGRPHY,"SR")),U,$$EDITION^ONCOU55(D0))
        S Y=Y_" "_$G(^ONCO(164.5,SS,1,Y+1,0)) G EX
        ;
ESSHP   ;EXECUTABLE HELP FOR EXTRANODAL SITE SURGICAL PROCEDURE #856
        N TOPGRPHY,TPGRPHYR,SS,XX
        S TOPGRPHY=$P($G(^ONCO(165.5,D0,"NHL2")),U,10) G ER:TOPGRPHY=""
        I TOPGRPHY="C888"!(TOPGRPHY="C999") W !,?5,"No extranodal site or unknown extranodal site!!",!!,?5,"00 No additional surgical procedure",! G EX
        S TOPGRPHY="67"_$E(TOPGRPHY,2,4)
        S TPGRPHYR=^ONCO(164,TOPGRPHY,0)
        S SS=$P($G(^ONCO(164,TOPGRPHY,"SR")),U,$$EDITION^ONCOU55(D0))
        W !!,"SURGERY OF PRIMARY SITE Codes for site ",$P(TPGRPHYR,U,2)," "
        W $P(TPGRPHYR,U),!,"(",$P(^ONCO(164.5,SS,0),U),")",!!
        W " ","00 No additional surgical procedure",!
        S XX=10 F  S XX=$O(^ONCO(164.5,SS,1,XX)) Q:XX'=+XX  D
        .S XXX=XX-1
        .I ($P(^ONCO(165.5,D0,0),U,16)<2960000)!($E(XXX,2)'=8) W " ",(XX-1)_" "_^ONCO(164.5,SS,1,XX,0),!
        W !,"Enter a code from the above list." G EX
        Q
        ;
FADIT   ;DATE OF FIRST CONTACT (165.5,155) Input Transform
        D NINES Q:'$D(X)  Q:X=9999999
        I $D(X) S %DT="EP",%DT(0)="-NOW" D ^%DT S X=Y K:Y<1 X K %DT
        Q
        ;
DSDTIT  ;DATE OF INPATIENT DISCHARGE (165.5,1.1) Input Transform
        ;Must be >= DATE OF INPATIENT ADMISSION (165.5,1)
        N FAD
        D ZS9S Q:'$D(X)  Q:(X="0000000")!(X=9999999)
        I $D(X) S %DT="EP",%DT(0)="-NOW" D ^%DT S X=Y K:Y<1 X I $D(X) S FAD=$P($G(^ONCO(165.5,D0,0)),U,8) I FAD'="" K:X<FAD X K %DT
        Q
        ;
DFSPIT  ;DATE FIRST SURGICAL PROCEDURE (165.5,170) Input Transform
        D ZS9S Q:'$D(X)  Q:(X="0000000")!(X=9999999)
        I $D(X) S %DT="EP",%DT(0)="-NOW" D ^%DT S X=Y K:Y<1 X K %DT
        I $D(X) S SDT=$P($G(^ONCO(165.5,D0,3)),U,1) I SDT'="",SDT'="0000000",SDT'="9999999" I X>SDT K X W !!?3,"DATE FIRST SURGICAL PROCEDURE later than MOST DEFINITIVE SURG DATE",! K %DT,SDT Q
        I $D(X) S SDT=$P($G(^ONCO(165.5,D0,3.1)),U,8) I SDT'="",SDT'="0000000",SDT'="9999999" I X>SDT K X W !!,"DATE FIRST SURGICAL PROCEDURE later than MOST DEFINITIVE SURG @FAC DATE",! K %DT,SDT Q
        I $D(X) S SDT=$P($G(^ONCO(165.5,D0,3.1)),U,22) I SDT'="",SDT'="0000000",SDT'="9999999" I X>SDT K X W !!,"DATE FIRST SURGICAL PROCEDURE later than SCOPE OF LN SURGERY DATE",! K %DT,SDT Q
        I $D(X) S SDT=$P($G(^ONCO(165.5,D0,3.1)),U,23) I SDT'="",SDT'="0000000",SDT'="9999999" I X>SDT K X W !!,"DATE FIRST SURGICAL PROCEDURE later than SCOPE OF LN SURGERY @FAC DATE",! K %DT,SDT Q
        I $D(X) S SDT=$P($G(^ONCO(165.5,D0,3.1)),U,24) I SDT'="",SDT'="0000000",SDT'="9999999" I X>SDT K X W !!,"DATE FIRST SURGICAL PROCEDURE later than SURG PROC/OTHER SITE DATE",!
        I $D(X) S SDT=$P($G(^ONCO(165.5,D0,3.1)),U,25) I SDT'="",SDT'="0000000",SDT'="9999999" I X>SDT K X W !!,"DATE FIRST SURGICAL PROCEDURE later than SURG PROC/OTHER SITE @FAC DATE",!
        K %DT,SDT
        Q
        ;
DFIT    ;INPUT TRANSFORM for date fields
        ;No future dates and date must be > or = DATE DX (165.5,3)
        N DFSP,DTDXE,DTDXI,FAIL,ZS9S
        I $G(DIFLD)=124 S NTDD=""
        D ZS9S Q:ZS9S=1 
        S %DT="EP",%DT(0)="-NOW" D ^%DT
        S X=Y I Y<1 K X W !!?5,"Future dates are not allowed.",! K %DT Q
        S X=X
        S DTDXI=$$GET1^DIQ(165.5,D0,3,"I")
        I DTDXI=8888888!9999999 Q
        S DTDXE=$$GET1^DIQ(165.5,D0,3,"E")
        S FAIL=""
        I X<DTDXI S FAIL=FAIL_"X"
        I FAIL'="" D  Q
        .K X
        .W !!?5,"The date entered must be later than or equal to the"
        .I FAIL["X" W !?5,"DATE DX which is ",DTDXE,$S(FAIL["A":" and the",1:".")
        .W !
        S DFSP=$P($G(^ONCO(165.5,D0,3.1)),U,38)
        I $D(X),$G(DIFLD)=50 D  Q
        .I DFSP'="",DFSP'="0000000",DFSP'="9999999" I X<DFSP K X W !!?3,"MOST DEFINITIVE SURG DATE earlier than DATE FIRST SURGICAL PROCEDURE",!
        I $D(X),$G(DIFLD)=50.3 D  Q
        .I DFSP'="",DFSP'="0000000",DFSP'="9999999" I X<DFSP K X W !!?3,"MOST DEFINITIVE SURG @FAC DATE earlier than DATE FIRST SURGICAL PROCEDURE",!
        I $D(X),$G(DIFLD)=138.2 D  Q
        .I DFSP'="",DFSP'="0000000",DFSP'="9999999" I X<DFSP K X W !!?3,"SCOPE OF LN SURGERY DATE earlier than DATE FIRST SURGICAL PROCEDURE",!
        I $D(X),$G(DIFLD)=138.3 D  Q
        .I DFSP'="",DFSP'="0000000",DFSP'="9999999" I X<DFSP K X W !!?3,"SCOPE OF LN SURGERY @FAC DATE earlier than DATE FIRST SURGICAL PROCEDURE",!
        I $D(X),$G(DIFLD)=139.2 D  Q
        .I DFSP'="",DFSP'="0000000",DFSP'="9999999" I X<DFSP K X W !!?3,"SURG PROC/OTHER SITE DATE earlier than DATE FIRST SURGICAL PROCEDURE",!
        I $D(X),$G(DIFLD)=139.3 D  Q
        .I DFSP'="",DFSP'="0000000",DFSP'="9999999" I X<DFSP K X W !!?3,"SURG PROC/OTHER SITE @FAC DATE earlier than DATE FIRST SURGICAL PROCEDURE",!
        Q
        ;
NTIT    ;DATE OF NO TREATMENT (165.5,124) INPUT TRANSFORM
        ;(NO FUTURE DATES AND >= DATE DX)
        N DTDX
        S NTDD=""
        I (X="00/00/00")!(X="00/00/0000")!(X="00000000") K X Q
        I (X="99/99/99")!(X="99/99/9999")!(X="99999999") K X Q
        S %DT="EP",%DT(0)="-NOW" D ^%DT S X=Y I Y<1 K X W !!?5,"Future dates are not allowed.",! K %DT Q
        S DTDX=$P($G(^ONCO(165.5,D0,0)),U,16)
        I DTDX=8888888!9999999 Q
        I DTDX'="" I X<DTDX K X W !!?5,"This date must be later than or equal to the DATE DX of ",$E(DTDX,4,5)_"/"_$E(DTDX,6,7)_"/"_($E(DTDX,1,3)+1700)_".",! K DTDX Q
        Q
        ;
NT      ;DATE OF NO TREATMENT (Input transform for treatment fields)
        S NTDD=$P($G(^ONCO(165.5,D0,2.1)),U,11)
        I (NTDD'="")&(X'=V) K X W !!?5,"This primary has a DATE OF NO TREATMENT of ",$E(NTDD,4,5)_"/"_$E(NTDD,6,7)_"/"_($E(NTDD,1,3)+1700)_".",!?5,"Treatments are not allowed unless the DATE OF NO TREATMENT is deleted.",!
        K NTDD,V Q
        ;
CHKTS   ;Check TREATMENT STATUS (165.5,235)
        N TS,TSI
        S TS=$$GET1^DIQ(165.5,D0,235)
        S TSI=$$GET1^DIQ(165.5,D0,235,"I")
        I (TSI=0)!(TSI=2) D
        .W !!?5,"TREATMENT STATUS = ",TS
        .W !?5,"DATE OF NO TREATMENT cannot be blank.",!
        .S Y=124
        E  S Y="@41"
        Q
        ;
DBTS    ;DATE BRACHYTHERAPY STARTED INPUT TRANSFORM (NOT FUTURE, DX<=DBS<=DBE)
        N DBE
        S %DT="EP",%DT(0)="-NOW" D ^%DT S X=Y K:Y<1 X Q:'$D(X)
        S DBE=$P($G(^ONCO(165.5,D0,"STS2")),U,13),DTDX=$P($G(^ONCO(165.5,D0,0)),U,16)
        I DBE'="" K:X>DBE X Q:'$D(X)
        I DTDX'="" K:X<DTDX X K %DT
        Q
        ;
DBTE    ;DATE BRACHYTHERAPY ENDED INPUT TRANSFORM (NOT FUTURE, DBS<=DBE)
        N DBS
        S %DT="EP",%DT(0)="-NOW" D ^%DT S X=Y K:Y<1 X I $D(X) S DBS=$P($G(^ONCO(165.5,D0,"STS2")),U,12) I DBS'="" K:X<DBS X K %DT
        Q
        ;
ZS9S    ;00/00/0000, 88/88/8888 and 99/99/9999 INPUT TRANSFORMS
        S ZS9S=1
        I X="00/00/00" D EN^DDIOL("00/00/00 is ambiguous.  Enter a 4 digit year. ",,"!?5") K X Q
        I X="00/00/0000" S X="0000000" Q
        I X="00000000" S X="0000000" Q
        ;
NINES   ;99/99/9999 INPUT TRANSFORM
        I X="99/99/99" D EN^DDIOL("99/99/99 is ambiguous.  Enter a 4 digit year. ",,"!?5") K X Q
        I X="99/99/9999" S X=9999999 Q
        I X="99999999" S X=9999999 Q
        ;
EIGHTS  ;88/88/8888 INPUT TRANSFORM
        I $G(DIFLD)'=58.3,$G(DIFLD)'=58.5,$G(DIFLD)'=50,$G(DIFLD)'=50.3,$G(DIFLD)'=138.2,$G(DIFLD)'=138.3,$G(DIFLD)'=139.2,$G(DIFLD)'=139.3,$G(DIFLD)'=435 D  K FLD Q:X=8888888
        .I X="88/88/88" D EN^DDIOL("88/88/88 is ambiguous.  Enter a 4 digit year. ",,"!?5") K X Q
        .I X="88/88/8888" S X=8888888
        .I X="88888888" S X=8888888
        S ZS9S=0
        Q
        ;
CLEANUP ;Cleanup
        K D0,DIFLD,Y
