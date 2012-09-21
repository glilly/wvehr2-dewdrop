PSOLLL4 ;BHAM/JLC - LASER LABELS PRINT PMI ;12/13/02
        ;;7.0;OUTPATIENT PHARMACY;**120,135,161,338**;DEC 1997;Build 3
        ;
        ;Reference to PSNPPIO supported by DBIA 3794
        ;
        S FLAG=$$EN^PSNPPIO(+$P(RXY,"^",6),.MSG)
EN      I $G(PSOIO("PMII"))]"" X PSOIO("PMII")
        I '$G(PMIM) D MOREWARN
        S T=PNM_"  Rx#: "_RXN_"   "_DRUG D PRINT(T,0) S PSOY=PSOY+PSOYI-25
        S CONT=0 I PMIM S CONT=1 D PRINT(PMIF("T"),PMIF("H")) G CONT
        I 'FLAG D PRINT(MSG) Q
        S T=^TMP($J,"PSNPMI",0)_": "_$G(^TMP($J,"PSNPMI","F",1,0)) D PRINT(T,1) S PSOY=PSOY+PSOYI-25
        S T=$G(^TMP($J,"PSNPMI","C",1,0)) I T]"" D PRINT(T,1) S PSOY=PSOY+PSOYI-25
CONT    S XFONT=$E(PSOFONT,2,99),(CNT,OUT,PMIM)=0
        K A F A="W","U","H","S","M","P","I","O","N","D","R" S CNT=CNT+1,A(CNT)=A
        F J=PMIF("A"):1 Q:$G(A(J))=""  S A=A(J) I $D(^TMP($J,"PSNPMI",A,1,0)) S HDR=$S(PMIF("A")=1:1,PMIF("B")=1:1,J=PMIF("A"):0,1:1),LENGTH=0,PTEXT="" D  Q:OUT  S PSOY=PSOY+PSOYI-25
        . F B=PMIF("B"):1 Q:'$D(^TMP($J,"PSNPMI",A,B,0))  S TEXT=^(0) D  Q:OUT
        .. F I=1:1 Q:$E(TEXT,I)'=" "  S TEXT=$E(TEXT,2,255)
        .. F I=PMIF("I"):1:$L(TEXT," ") D STRT^PSOLLU1("FULL",$P(TEXT," ",I)_" ",.L) D  Q:OUT
        ... I LENGTH+L(XFONT)<8.1 S PTEXT=PTEXT_$P(TEXT," ",I)_" ",LENGTH=LENGTH+L(XFONT) Q
        ... S LENGTH=0,I=I-1
        ... I HDR D  Q
        .... I PSOY>PSOYM S PMIF("A")=J,PMIF("I")=I+1,PMIF("B")=B,OUT=1,PMIM=1
        .... D PRINT(PTEXT,1) S PTEXT="",HDR=0
        ... I PSOY>(PSOYM+25) S PMIF("A")=J,PMIF("I")=I+1,PMIF("B")=B,OUT=1,PMIM=1 Q
        ... D PRINT(PTEXT,0) S PTEXT=""
        .. I 'PMIM F I="I","B" S PMIF(I)=1
        . I 'PMIM S PMIF("B")=1
        . I OUT S PMIF("T")=PTEXT,PMIF("H")=HDR
        . Q:OUT  I HDR,PTEXT[":" D  Q
        .. I PSOY>PSOYM S PMIF("A")=J,PMIF("I")=I+1,PMIF("B")=B,OUT=1,PMIM=1,PMIF("T")=PTEXT,PMIF("H")=HDR Q
        .. I PTEXT]"" D PRINT(PTEXT,1)
        . I PTEXT]"",PSOY>PSOYM S PMIF("A")=J,PMIF("I")=I+1,PMIF("B")=B,OUT=1,PMIM=1,PMIF("T")=PTEXT,PMIF("H")=HDR Q
        . I PTEXT]"" D PRINT(PTEXT,0)
        Q
PRINT(T,HDR)    ;
        ; Input: T - text to be printed
        ;        HDR - 0-no / 1-yes
        ;
        S HDR=+$G(HDR)
        I $G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
        I $G(PSOIO("ST"))]"" X PSOIO("ST")
        I HDR,$G(PSOIO(PSOFONT_"B"))]"" X PSOIO(PSOFONT_"B")
        I HDR D  G PRINT2
        . W $P(T,":"),":"
        . I $G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
        . W $P(T,":",2,99)
        W T
PRINT2  I $G(PSOIO("ET"))]"" X PSOIO("ET")
        W ! Q
        ;
MOREWARN        ; SEE ID MORE THAN 5 WARNINGS AND PRINT REMAINDER, IF SO
        N LEN,LEN2,I,J,PSOWARN,NEWWARN,PRE
        S LEN=$L($G(WARN),",") I LEN<6,'$G(PSOWLBL) Q
        S NEWWARN=$G(PSOWLBL)_$P(WARN,",",6,99)
        I $E(NEWWARN,$L(NEWWARN))="," S NEWWARN=$E(NEWWARN,1,$L(NEWWARN)-1) I NEWWARN="" Q
        S T="Additional Warnings:" D PRINT(T,1)
        F I=1:1:$L(NEWWARN,",") S PSOWARN=$P(NEWWARN,",",I) D
        .S PRE=PSOWARN_": ",LEN2=$L(PRE)
        .S TEXT=$$WTEXT^PSSWRNA(PSOWARN,PSOLAN) I TEXT'="" D
        ..I $L(TEXT)<100 S T=PRE_TEXT D PRINT(T) Q
        ..S PTEXT="" F J=1:1:$L(TEXT," ") S PTEXT=PTEXT_$P(TEXT," ",J)_" " D
        ...I $L(PTEXT)>90 D
        ....S T=PRE_PTEXT D PRINT(T) S PRE=$E("      ",1,LEN2),PTEXT=""
        ..I PTEXT'="" S T=$G(PRE)_PTEXT D PRINT(T) S PTEXT=""
        I PTEXT'="" S T=$G(PRE)_PTEXT D PRINT(T) S PTEXT=""
        S PSOY=PSOY+PSOYI
        K PSOWLBL
        Q
        ;
