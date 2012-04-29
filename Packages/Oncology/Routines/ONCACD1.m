ONCACD1 ;Hines OIFO/GWB - Extract NAACCR data; 06/11/01
        ;;2.11;Oncology;**9,12,14,18,20,22,24,25,26,28,29,31,36,37,41,43,47,48**;Mar 07, 1995;Build 13
        ;;
EN1     ;Main entry point
        S EXPORT="YES"
        K ^TMP($J)
        N PAGE,OIEN
        S PAGE=1
        S OIEN=0
        D SETUP
        I DEVICE S:$D(ZTQUEUED) ZTREQ="@"
        I 'DEVICE W $C(26) H 30
        K EXPORT
        Q
        ;
HEAD(IEN,OUT)   ;Header print
        N FLG
        I IEN=OIEN S FLG=0
        I IEN'=OIEN S OIEN=IEN,FLG=1
        I 'FLG Q:$Y+4<IOSL
        I PAGE'=1 D  Q:OUT
        .Q:$E(IOST,1)'="C"
        .N DIR,Y
        .S DIR("A")="Press ENTER to Continue or ""^"" to Quit: "
        .S DIR(0)="EA" D ^DIR
        .I 'Y S OUT=1 Q
        D HEADER
        Q
        ;
HEADER  ;Master header
        I PAGE'=1 W @IOF
        I PAGE=1,$E(IOST,1)="C" W @IOF
        W !,$P(^ONCO(160.16,HDRIEN,0),U),?70,"Page: ",PAGE S PAGE=PAGE+1
        W !,"Patient: ",$$GET1^DIQ(160,ACD160,.01,"E")
        W ?55,"SSN: ",$$GET1^DIQ(160,ACD160,2,"E")
        W !,"Col#",?5,"Data item",?51,"Data Value",!
        F I=1:1:79 W "="
        Q
        ;
SETUP   ;Setup the data to be verified.
        N IEN,BLANK,NINE,ZERO,ZNINE,X
        I 'DEVICE S X=0 X ^%ZOSF("RM") ;disable autowrap
        S BLANK=" "
        S (IEN,ZERO)=0
        S NINE=9
        S ZNINE="09"
        S OUT=$G(OUT,0)
        I STEXT=0 F  S IEN=$O(^ONCO(165.5,"AY",DATE,IEN)) Q:IEN<1  I $$DIV^ONCFUNC(IEN)=DUZ(2) D  Q:OUT
        .Q:$G(^ONCO(165.5,IEN,0))=""
        .I $G(NCDB)=2 S DCLC=$P($G(^ONCO(165.5,IEN,7)),U,21) Q:(DCLC<SDT)!(DCLC>EDT)
        .D LOOP
        I STEXT=1 S SDT=SDT-1 F  S SDT=$O(^ONCO(165.5,"AAD",SDT)) Q:(SDT<1)!(SDT>EDT)!(OUT=1)  F  S IEN=$O(^ONCO(165.5,"AAD",SDT,IEN)) Q:IEN<1  I $$DIV^ONCFUNC(IEN)=DUZ(2) D  Q:OUT
        .Q:$G(^ONCO(165.5,IEN,0))=""
        .D LOOP
        I STEXT=2 S SDT=SDT-1 F  S SDT=$O(^ONCO(165.5,"AAE",SDT)) Q:(SDT<1)!(SDT>EDT)!(OUT=1)  F  S IEN=$O(^ONCO(165.5,"AAE",SDT,IEN)) Q:IEN<1  I $$DIV^ONCFUNC(IEN)=DUZ(2) D  Q:OUT
        .Q:$G(^ONCO(165.5,IEN,0))=""
        .D LOOP
        Q
        ;
LOOP    ;Loop though the data that was given
        N LINE,RULES,VALID,JUMP
        S RULES=0
        F  S RULES=$O(^ONCO(160.16,EXTRACT,"RULES",RULES)) Q:RULES<1  D
        .S LINE=^ONCO(160.16,EXTRACT,"RULES",RULES,0)
        .X LINE
        Q:'VALID
        S ^TMP($J,IEN)=""
        D OUTPUT(IEN,EXTRACT,JUMP,.OUT)
        I 'DEVICE W !
        Q
OUTPUT(IEN,EXTRACT,JUMP,OUT)    ;Output the data
        N POS
        S ACD160=$P(^ONCO(165.5,IEN,0),U,2)
        I DEVICE D HEAD(IEN,.OUT) Q:OUT
        S POS=0
        F  S POS=$O(^ONCO(160.16,EXTRACT,"FIELD","B",POS)) Q:POS<1  D  Q:OUT
        .N NODE
        .S NODE=0
        .F  S NODE=$O(^ONCO(160.16,EXTRACT,"FIELD","B",POS,NODE)) Q:NODE<1  D  Q:OUT
        ..N STRING,DEFAULT,FILL,LEN
        ..Q:$G(^ONCO(160.16,EXTRACT,"FIELD",NODE,0))=""
        ..D DISPLAY(DEVICE,$P(^ONCO(160.16,EXTRACT,"FIELD",NODE,0),U,1)_U_$P(^ONCO(160.16,EXTRACT,"FIELD",NODE,0),U,4),.OUT)
        ..Q:OUT
        ..S STRING=$TR(^ONCO(160.16,EXTRACT,"FIELD",NODE,1),"~","^")
        ..S DEFAULT=^ONCO(160.16,EXTRACT,"FIELD",NODE,2)
        ..S FILL=$P(^ONCO(160.16,EXTRACT,"FIELD",NODE,3),U,1)
        ..S LEN=$P(^ONCO(160.16,EXTRACT,"FIELD",NODE,0),U,2)
        ..D DATA(IEN,ACD160,STRING,DEFAULT,FILL,LEN,JUMP,NODE,POS)
        ..I $G(^ONCO(160.16,EXTRACT,0))["NCDB" D
        ...I $O(^ONCO(160.16,EXTRACT,"FIELD","B",POS))>1 Q  ; Search for last
        ...N EXTRACT,NODE,POS
        ...;============================================
        ...;| This Code is to support the PCE Extract. |
        ...;============================================
        ...S EXTRACT=100,JUMP=0
        ...;S:$D(^ONCO(165.5,"APCE","BLA",IEN)) EXTRACT=1
        ...; ^==== Bladder 95,90,85
        ...;S:$D(^ONCO(165.5,"APCE","THY",IEN)) EXTRACT=2
        ...; ^==== Thyroid 96,91,86
        ...;S:$D(^ONCO(165.5,"APCE","STS",IEN)) EXTRACT=3
        ...; ^==== Soft Tissue 96,91,86
        ...;S:$D(^ONCO(165.5,"APCE","COL",IEN)) EXTRACT=4
        ...; ^==== Colorectal 97,92,87
        ...;S:$D(^ONCO(165.5,"APCE","NHL",IEN)) EXTRACT=5
        ...; ^==== Non-Hodgkins 97,92,87
        ...;S:$D(^ONCO(165.5,"APCE","BRE",IEN)) EXTRACT=6
        ...; ^==== Breast 98,93,88
        ...;S:$D(^ONCO(165.5,"APCE","PRO2",IEN)) EXTRACT=7
        ...; ^==== Prostate 98,93,88
        ...;S:$D(^ONCO(165.5,"APCE","MEL",IEN)) EXTRACT=8
        ...; ^==== Melanoma 99,94,89
        ...;S:$D(^ONCO(165.5,"APCE","HEP",IEN)) EXTRACT=9
        ...; ^==== Hepatocellular Cancers 00,95,90
        ...;S:$D(^ONCO(165.5,"APCE","CNS",IEN)) EXTRACT=10
        ...; ^==== Primary Intracranial/CNS Tumors 00,95,90
        ...;S:$D(^ONCO(165.5,"APCE","LNG",IEN)) EXTRACT=11
        ...; ^==== Lung (NSCLC) 01,96,91
        ...;S:$D(^ONCO(165.5,"APCE","GAS",IEN)) EXTRACT=12
        ...; ^==== Gastric Cancers 01,96,91
        ...S POS=0
        ...F  S POS=$O(^ONCO(160.17,EXTRACT,"FIELD","B",POS)) Q:POS<1  D  Q:OUT
        ....N NODE
        ....S NODE=0
        ....F  S NODE=$O(^ONCO(160.17,EXTRACT,"FIELD","B",POS,NODE)) Q:NODE<1  D  Q:OUT
        .....N STRING,DEFAULT,FILL,LEN
        .....Q:$G(^ONCO(160.17,EXTRACT,"FIELD",NODE,0))=""
        .....D DISPLAY(DEVICE,$P(^ONCO(160.17,EXTRACT,"FIELD",NODE,0),U,1)_U_$P(^ONCO(160.17,EXTRACT,"FIELD",NODE,0),U,4),.OUT)
        .....Q:OUT
        .....S STRING=$TR(^ONCO(160.17,EXTRACT,"FIELD",NODE,1),"~","^")
        .....S DEFAULT=^ONCO(160.17,EXTRACT,"FIELD",NODE,2)
        .....S FILL=^ONCO(160.17,EXTRACT,"FIELD",NODE,3)
        .....S LEN=$P(^ONCO(160.17,EXTRACT,"FIELD",NODE,0),U,2)
        .....D DATA(IEN,ACD160,STRING,DEFAULT,FILL,LEN,JUMP,NODE,POS)
        Q
DISPLAY(DEVICE,WRITE,OUT)       ; Display Data
        Q:'DEVICE
        N DOTS,COL,ITEM
        I DEVICE,($Y+5)>IOSL D HEAD(0,.OUT) Q:OUT
        S COL=$P(WRITE,U,1)
        S COL=$S($L(COL)=1:"   "_COL,$L(COL)=2:"  "_COL,$L(COL)=3:" "_COL,1:COL)
        S ITEM=$P(WRITE,U,2),ITEM=$E(ITEM,1,45)
        S DOTS=(46-$L(ITEM))
        W !,COL,?5,ITEM
        F I=1:1:DOTS W "."
        Q
        ;
DATA(IEN,ACD160,STRING,DEFAULT,FILL,LEN,JUMP,NODE,POS)  ; Data print
        N ACDANS,EXIT
        S EXIT=0
        I JUMP'="0" D
        .I POS<$P(JUMP,U) Q
        .I POS>$P(JUMP,U,2) Q
        .N I
        .S EXIT=1
        .F I=1:1:LEN W BLANK
        Q:EXIT
        X STRING
        I ACDANS="" D  Q
        .N X,I
        .S X=""
        .I DEFAULT=8 D  Q
        ..F I=1:1:LEN W DEFAULT
        .I @DEFAULT="09" W @DEFAULT Q
        .F I=1:1:LEN W @DEFAULT
        I $L(ACDANS)=LEN W ACDANS Q
        I $L(ACDANS)>LEN W $E(ACDANS,1,LEN) Q
        E  D  Q
        .N JUST,STUFF,I,REM,CAL
        .S JUST=$P(FILL,","),STUFF=$P(FILL,",",2)
        .S REM=LEN-$L(ACDANS)
        .I JUST="R" W ACDANS
        .F I=1:1:REM W @STUFF
        .I JUST="L" W ACDANS
        Q
