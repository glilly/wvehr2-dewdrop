PSOCIDC2        ;BIR/LE-continuation of Copay Correction of erroneous billed copays ;11/8/05 12:50pm
        ;;7.0;OUTPATIENT PHARMACY;**226,225**;DEC 1997;Build 29
        ;External reference to ^XUSEC supported by DBIA 10076
        ;External reference to IBARX supported by DBIA 125
        ;External reference to $$PROD^XUPROD(1) supported by DBIA 4440
        ;
TOTAL   ;
        N COUNT,COUNTED,UCOUNT,UCOUNTED,CCOUNT,CCOUNTED
        I '$D(PSOVETS) S PSOVETS=0
        N I,J
        F I=1:1:3 S (PSOCNT("YR2004",I),PSOCNT("YR2005",I),PSOCNT("YR2006",I))=0
        S PSODFN=0 F  S PSODFN=$O(^XTMP(NAMSP,"TOT REL",PSODFN)) Q:'PSODFN  D
        .S COUNTED=0
        .F J="YR2004","YR2005","YR2006" F I=1:1:3 S COUNT=$G(^XTMP(NAMSP,"TOT REL",PSODFN,J,I)) I COUNT>0 S:'$G(COUNTED) COUNTED=1,PSOVETS=PSOVETS+1 S PSOCNT(J,I)=PSOCNT(J,I)+COUNT
        F I=1:1:3 S PSOCNT=PSOCNT+$G(PSOCNT("YR2004",I))+$G(PSOCNT("YR2005",I))+$G(PSOCNT("YR2006",I))
        ;
        S (I,J)=-""
        I '$D(PSOCVETS) S PSOCVETS=0
        F I=1:1:3 S (PSOCCNT("YR2004",I),PSOCCNT("YR2005",I),PSOCCNT("YR2006",I))=0
        S PSODFN=0 F  S PSODFN=$O(^XTMP(NAMSP,"TOT CAN",PSODFN)) Q:'PSODFN  D
        .S CCOUNTED=0
        .F J="YR2004","YR2005","YR2006" F I=1:1:3 S CCOUNT=$G(^XTMP(NAMSP,"TOT CAN",PSODFN,J,I)) I CCOUNT>0 S:'$G(CCOUNTED) CCOUNTED=1,PSOCVETS=PSOCVETS+1 S PSOCCNT(J,I)=PSOCCNT(J,I)+CCOUNT
        F I=1:1:3 S PSOCCNT=PSOCCNT+$G(PSOCCNT("YR2004",I))+$G(PSOCCNT("YR2005",I))+$G(PSOCCNT("YR2006",I))
        ;
        S (I,J)=""
        I '$D(PSOUVETS) S PSOUVETS=0
        F I=1:1:3 S (PSOUCNT("YR2004",I),PSOUCNT("YR2005",I),PSOUCNT("YR2006",I))=0
        S PSOUDFN=0 F  S PSOUDFN=$O(^XTMP(NAMSP,"TOT UNREL",PSOUDFN)) Q:'PSOUDFN  D
        .S UCOUNTED=0
        .F J="YR2004","YR2005","YR2006" F I=1:1:3 S UCOUNT=$G(^XTMP(NAMSP,"TOT UNREL",PSOUDFN,J,I)) I UCOUNT>0 S:'$G(UCOUNTED) UCOUNTED=1,PSOUVETS=PSOUVETS+1 S PSOUCNT(J,I)=PSOUCNT(J,I)+UCOUNT
        F I=1:1:3 S PSOUCNT=PSOUCNT+$G(PSOUCNT("YR2004",I))+$G(PSOUCNT("YR2005",I))+$G(PSOUCNT("YR2006",I))
        ;
        Q
        ;
CHECK   ;check for ICD and IB nodes
        ;
        N PSOREF,PSOIB,PSOOICD,PSOBILLD
        S PSOREF=YY
        S PSOOICD=$P($G(^PSRX(RXP,"ICD",1,0)),"^",2,8)
        ; see if bill already exists
        I PSOREF=0 D
        . I +$P($G(^PSRX(RXP,"IB")),"^",2)>0 D CHKIB^PSOCP1
        . S PSOREL=$P($G(^PSRX(RXP,2)),"^",13)
        I PSOREF>0 D
        . I +$G(^PSRX(RXP,1,PSOREF,"IB")) D CHKIB^PSOCP1
        . S PSOREL=$P($G(^PSRX(RXP,1,YY,0)),"^",18)
        I $G(PSOIB)=1!($G(PSOIB)=3) S PSOBILLD=1
        ;    if billed/RELEASED and no IBQ node for both sc<50 and nsc
        I $G(PSOBILLD)&('$D(^PSRX(RXP,"IBQ"))) D
        . I $TR(PSOOICD,"^")[1  S ^XTMP(NAMSP,"CANCEL",PSODFN,RXP,YY)=$P(PSOREL,".")_"^"_PSODT_"^"_PSOSCP
        . I $TR(PSOOICD,"^")[0 S ^XTMP(NAMSP,"NOIBQ",PSODFN,RXP,YY)=$P(PSOREL,".")_"^"_PSODT_"^"_PSOSCP
        ;           find unbilled ones with an ICD node and no IBQ node.
        I '$G(PSOBILLD)&('$D(^PSRX(RXP,"IBQ"))) D
        . Q:$TR(PSOOICD,"^")=""
        . S ^XTMP(NAMSP,"NOIBQ",PSODFN,RXP,YY)=$P(PSOREL,".")_"^"_PSODT_"^"_PSOSCP
        I YY S PSOTRF=PSOTRF+1
        Q
        ;
CANCEL  ;Cancel erroneous copays/set IBQ node if not there
        ;released rx's
        N PSOCAP,PSODIV,PSODV,PSOFILL,PSOLOG,PSONAM,PSOOUT,PSOPAR,PSOPAR7,PSOSITE
        N PSOSITE7,PSOSQ,PSOTOT,PSOYEAR,PSOYR,SSN,SAVCPUN,SAVREF,PSOIB,PSOOIBQ,PSONIBQ,PSOOICD,PSOOIB
        N I,IFN,PSOANSQ,PSOTYP,COM,CC,PREA,PSONW,PSOOLD,PSOREL,PSO,PSOCPUN,PSOFLD,PSOTYPE,CANCEL
        S PSOTYPE="CAN"
        S PSODFN=0 F CC=1:1 S PSODFN=$O(^XTMP(NAMSP,"CANCEL",PSODFN)) Q:'PSODFN  D  Q:STOP
        .I CC#100=0,$D(^XTMP(NAMSP,0,"STOP")) D  Q
        .. S $P(^XTMP(NAMSP,0,"LAST"),"^",1,2)="STOP^"_$$NOW^XLFDT,STOP=1
        .S (PSOCAP(304),PSOCAP(305),PSOCAP(306))=0 ; INITIAL ANNUAL CAP FOR 2004 & 2005
        .F RXP=0:0 S RXP=$O(^XTMP(NAMSP,"CANCEL",PSODFN,RXP)) Q:'RXP  D
        ..S (SAVCPUN,PSOCPUN)=($P(^PSRX(RXP,0),"^",8)+29)\30
        ..S YY="" F  S YY=$O(^XTMP(NAMSP,"CANCEL",PSODFN,RXP,YY)) Q:YY=""  D
        ...S (SAVREF,PSOREF)=YY
        ...;  verify again that it was billed and not already cancelled
        ...S PSOBILLD=0
        ...I YY=0,+$P($G(^PSRX(RXP,"IB")),"^",2)>0 D CHKIB^PSOCP1 I $G(PSOIB)=1!($G(PSOIB)=3) S PSOBILLD=1
        ...I YY>0,+$P($G(^PSRX(RXP,1,PSOREF,"IB")),"^")>0 D CHKIB^PSOCP1 I $G(PSOIB)=1!($G(PSOIB)=3) S PSOBILLD=1
        ...Q:'PSOBILLD
        ...S PSOREL=$P($G(^XTMP(NAMSP,"CANCEL",PSODFN,RXP,YY)),"^"),PSOFLD=$P($G(^XTMP(NAMSP,"CANCEL",PSODFN,RXP,YY)),"^",2),PSOSCP=$P($G(^XTMP(NAMSP,"CANCEL",PSODFN,RXP,YY)),"^",3)
        ...S PSO=3 D NOW^%DTC S PSODT=%,PSODA=RXP,PSOCOMM="-BKGD CIDC COPAY CANCEL",PSOOLD="",PSONW="",PREA=""
        ...D CHKACT
        ...S PSOIB="",PSOIB=$S(PSOREF>0:$G(^PSRX(RXP,1,YY,"IB")),'PSOREF:$G(^PSRX(PSODA,"IB")),1:"")
        ...S (PSOOIBQ,PSOOICD,PSOOIB)=""
        ...S PSOOICD=$P($G(^PSRX(RXP,"ICD",1,0)),"^",2,8),PSOOIB=$G(^PSRX(RXP,"IB")),PSOOIBQ=$G(^PSRX(RXP,"IBQ"))
        ...I PSOOIBQ=""&($TR(PSOOICD,"^")[0!($TR(PSOOICD,"^")[1)) D SETIBQ
        ...D SITE S PSOCOMM="-BKGD CIDC COPAY CANCEL" D RXED^PSOCPA S:PSOOICD[1&($D(^PSRX(RXP,"IB"))) $P(^PSRX(RXP,"IB"),"^")=""
        ...S PSOCPUN=SAVCPUN,PSOREF=SAVREF
        ...D ACCUM
        ;
        ;ICD NODES WITHOUT IBQ NODE; set IBQ node but only set 1st piece of IB node if unreleased.
        S PSOTYP="IBQ"
        S PSODFN=0 F CC=1:1 S PSODFN=$O(^XTMP(NAMSP,"NOIBQ",PSODFN)) Q:'PSODFN  D  Q:STOP
        .I CC#100=0,$D(^XTMP(NAMSP,0,"STOP")) D  Q
        .. S $P(^XTMP(NAMSP,0,"LAST"),"^",1,2)="STOP^"_$$NOW^XLFDT,STOP=1
        .S (PSOCAP(304),PSOCAP(305),PSOCAP(306))=0 ; INITIAL ANNUAL CAP FOR 2004 & 2005
        .F RXP=0:0 S RXP=$O(^XTMP(NAMSP,"NOIBQ",PSODFN,RXP)) Q:'RXP  D
        ..S (SAVCPUN,PSOCPUN)=($P(^PSRX(RXP,0),"^",8)+29)\30
        ..S YY="" F  S YY=$O(^XTMP(NAMSP,"NOIBQ",PSODFN,RXP,YY)) Q:YY=""  D
        ...S (SAVREF,PSOREF)=YY
        ...D SITE
        ...S PSOREL=$P($G(^XTMP(NAMSP,"NOIBQ",PSODFN,RXP,YY)),"^"),PSOFLD=$P($G(^XTMP(NAMSP,"NOIBQ",PSODFN,RXP,YY)),"^",2),PSOSCP=$P($G(^XTMP(NAMSP,"NOIBQ",PSODFN,RXP,YY)),"^",3)
        ...S (PSOOIBQ,PSOOICD,PSOOIB)=""
        ...S PSOOICD=$P($G(^PSRX(RXP,"ICD",1,0)),"^",2,8),PSOOIB=$G(^PSRX(RXP,"IB")),PSOOIBQ=$G(^PSRX(RXP,"IBQ"))
        ...I PSOOIBQ=""&($TR(PSOOICD,"^")[0!($TR(PSOOICD,"^")[1)) D SETIBQ D   ;don't want to set again if already did it as part of copay cancel
        ....S I="",IFN=0 F I=0:0 S I=$O(^PSRX(RXP,"A",I)) Q:'I  S IFN=I
        ....S COM=" BKGD CIDC UPDATE"
        ....D NOW^%DTC S IFN=IFN+1,^PSRX(RXP,"A",0)="^52.3DA^"_IFN_"^"_IFN,^PSRX(RXP,"A",IFN,0)=%_"^I^.5^"_YY_"^"_COM
        ....K DA
        ....S:PSOOICD[1&($D(^PSRX(RXP,"IB"))) $P(^PSRX(RXP,"IB"),"^")=""
        ...D:'$G(^XTMP(NAMSP,"CANCEL",PSODFN,RXP,YY)) ACCUM
        ...S PSOCPUN=SAVCPUN,PSOREF=SAVREF
        Q
        ;
CHKACT  ;check activity log for prev entry
        N ZACT,ZPSI,ZACTI
        S ZPSI=0 F  S ZPSI=$O(^PSRX(PSODA,"COPAY",ZPSI)) Q:ZPSI=""  S ZACTI="",ZACTI=$G(^PSRX(PSODA,"COPAY",ZPSI,0)) D  Q:$G(ZACT)
        . I ZACTI["BKGD CIDC COPAY CANCEL"&($P(ZACTI,"^",2)="R") S PSOOLD="",PSONW="",PREA="C",ZACT=1 Q
        I '$G(ZACT) S PSOOLD="Copay",PSONW="No Copay",PREA="R" K PSOREF D ACTLOG^PSOCPA S PSOREF=YY,PSOOLD="",PSONW="",PREA="C"
        Q
        ;
SETIBQ  ; get data from IBQ node, set IBQ node, and 1st piece of IB node
        K PSOANSQ
        N PSONIBQ
        F PSOTYP=1:1:8 D
        . I PSOTYP=1 S PSOANSQ("VEH")=$P(PSOOICD,"^",PSOTYP)
        . I PSOTYP=2 S PSOANSQ("RAD")=$P(PSOOICD,"^",PSOTYP)
        . I PSOTYP=3 S PSOANSQ("SC")=$P(PSOOICD,"^",PSOTYP)
        . I PSOTYP=4 S PSOANSQ("PGW")=$P(PSOOICD,"^",PSOTYP)
        . I PSOTYP=5 S PSOANSQ("MST")=$P(PSOOICD,"^",PSOTYP)
        . I PSOTYP=6 S PSOANSQ("HNC")=$P(PSOOICD,"^",PSOTYP)
        . I PSOTYP=7 S PSOANSQ("CV")=$P(PSOOICD,"^",PSOTYP)
        . I PSOTYP=8 S PSOANSQ("SHAD")=$P(PSOOICD,"^",PSOTYP)
        S ^PSRX(RXP,"IBQ")=PSOANSQ("SC")_"^"_PSOANSQ("MST")_"^"_PSOANSQ("VEH")_"^"_PSOANSQ("RAD")_"^"_PSOANSQ("PGW")_"^"_PSOANSQ("HNC")_"^"_PSOANSQ("CV")_"^"_PSOANSQ("SHAD")
        Q
        ;
ACCUM   ; ACCUMULATE TOTALS
        S (PSOTOT,PSOYR,PSOYEAR,PSOLOG,PSONAM,PSOCHRG)=""
        ; get finished, but unreleased totals
        I PSOREL="" S PSOYR=$E(PSOFLD,1,3) Q:PSOYR=""  D  S PSOYEAR="" Q
        .S PSOYEAR=$S(PSOYR="304":"YR2004",PSOYR="305":"YR2005",PSOYR="306":"YR2006",1:"") Q:PSOYEAR=""
        .S PSOCHRG=7
        .I PSOYEAR="YR2006" S PSOCHRG=8
        .S PSOTOT=$G(^XTMP(NAMSP,"TOT UNREL",PSODFN,PSOYEAR))
        .S ^XTMP(NAMSP,"TOT UNREL",PSODFN,PSOYEAR)=PSOTOT+(PSOCPUN*PSOCHRG)
        .S ^XTMP(NAMSP,"TOT UNREL",PSODFN,PSOYEAR,PSOCPUN)=$G(^XTMP(NAMSP,"TOT UNREL",PSODFN,PSOYEAR,PSOCPUN))+1
        .S PSONAM=$P($G(^DPT(PSODFN,0)),"^"),PSONAM=$P(PSONAM,",")
        .S PSONAM=$E(PSONAM,1,6)
        .S ^XTMP(NAMSP,"IBQ UPD",PSONAM,PSODFN,RXP,PSOREF)=PSOFLD
        ;for released ones
        S PSOYR=$E(PSOREL,1,3)
        S:PSOYR'="" PSOYEAR=$S(PSOYR="304":"YR2004",PSOYR="305":"YR2005",PSOYR="306":"YR2006",1:"")
        Q:PSOYEAR=""
        S PSOCHRG=7
        I PSOYEAR="YR2006" S PSOCHRG=8
        ;
        ;get Xtmp billing amt which would be IBAM tot + any previous refills
        S PSOTOT=$G(^XTMP(NAMSP,"TOT REL",PSODFN,PSOYEAR))
        ;
        ;if none yet then init to the IBAM total for the year
        I 'PSOTOT D
        .F PSOSQ=0:0 S PSOSQ=$O(^IBAM(354.7,PSODFN,1,PSOSQ)) Q:'PSOSQ  D
        ..S PSOLOG=$G(^IBAM(354.7,PSODFN,1,PSOSQ,0))
        ..I $E(PSOLOG,1,3)=PSOYR S PSOTOT=PSOTOT+$P(PSOLOG,"^",2)
        ;
        ;update Xtmp tot nodes with current fill amounts
        ;  note:  cancel copays and updated IBQ node released prescription are collected under TOT REL for the RPT^PSOCIDC3
        ;             routine.  Cancelled copays are denoted with an asterisk.
        S ^XTMP(NAMSP,"TOT REL",PSODFN,PSOYEAR)=PSOTOT+(PSOCPUN*PSOCHRG)
        S ^XTMP(NAMSP,"TOT REL",PSODFN,PSOYEAR,PSOCPUN)=$G(^XTMP(NAMSP,"TOT REL",PSODFN,PSOYEAR,PSOCPUN))+1
        ;
        ;indicate COPAY CANCEL for this fill 
        ;       ;by adding to Xtmp "BILLED"
        S PSONAM=$P($G(^DPT(PSODFN,0)),"^"),PSONAM=$P(PSONAM,",")
        S PSONAM=$E(PSONAM,1,6)
        S ^XTMP(NAMSP,"REL",PSONAM,PSODFN,RXP,PSOREF)=PSOREL
        ;
CAN     I PSOTYPE="CAN"&($G(^XTMP(NAMSP,"CANCEL",PSODFN,RXP,YY))) N PSOFILL S CANCEL="" S PSOFILL=YY D CHK^PSOCIDC3 I CANCEL D
        . S ^XTMP(NAMSP,"TOT CAN",PSODFN,PSOYEAR)=PSOTOT+(PSOCPUN*PSOCHRG)
        . S ^XTMP(NAMSP,"TOT CAN",PSODFN,PSOYEAR,PSOCPUN)=$G(^XTMP(NAMSP,"TOT CAN",PSODFN,PSOYEAR,PSOCPUN))+1
        Q
        ;
SITE    ; SET UP VARIABLES NEEDED BY BILLING
        S PSOSITE=$S(YY=0:$P(^PSRX(RXP,2),"^",9),1:$P($G(^PSRX(RXP,1,YY,0)),"^",9))
        Q:PSOSITE=""
        S PSOPAR=$G(^PS(59,PSOSITE,1))
        S PSOPAR7=$G(^PS(59,PSOSITE,"IB"))
        S PSOSITE7=$P($G(^PS(59,PSOSITE,"IB")),"^")
        Q
        ;
