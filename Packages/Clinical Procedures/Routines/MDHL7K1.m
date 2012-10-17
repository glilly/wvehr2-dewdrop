MDHL7K1 ; HOIFO/WAA-KenitDx Interface ; 06/08/00
        ;;1.0;CLINICAL PROCEDURES;**21**;Apr 01, 2004;Build 30
        N TCNT,ICNT,LN
        S (TCNT,ICNT,LN)=0
OBX     ; Process OBX
        N MDATT,PROC
        D ATT^MDHL7U(DEVIEN,.MDATT) Q:MDATT<1
        S PROC=0
        F  S PROC=$O(MDATT(PROC)) Q:PROC<1  D
        . N PROCESS
        . S PROCESS=$P(MDATT(PROC),";",5)
        . I PROCESS="TEXT^MDHL7U2" D TEXT
        . D @PROCESS
        . Q
        Q:'MDIEN
        D REX^MDHL7U1(MDIEN)
        D GENACK^MDHL7X
        Q
TEXT    ;This subroutine is to parse out the text
        ;
        N CNT,P,LINE2,LINE,CNT2,CO,I,TEXT,DEL,TXT
        S P="|",CNT=0,LINE2="",CNT2=0,CNT3=0
        F  S CNT=$O(^TMP($J,"MDHL7A",CNT)) Q:CNT<1  D
        .S DEL="\.br\",LAST=""
        .S LINE=^TMP($J,"MDHL7A",CNT)
        .I $P(LINE,P,1)'="OBX" Q
        .I $P(LINE,P,3)'="FT" Q
        .S TEXT=$P(LINE,P,6)
        .D LINE(TEXT,DEL)
        .F  S CNT3=$O(^TMP($J,"MDHL7A",CNT,CNT3)) Q:CNT3<1  D
        .. S LINE=^TMP($J,"MDHL7A",CNT,CNT3)
        .. S TEXT=LAST_LINE
        .. D LINE(TEXT,DEL)
        .. Q
        .Q
        Q
LINE(TEXT,DEL)  ;
        S CO=$L(TEXT,DEL)
        I CO F I=1:1:CO D  Q
        . S TXT=$P(TEXT,DEL,I)
        . D LG(TXT)
        . ;D BUILD(TXT)
        . Q
        E  D BUILD(TXT)
        I $O(^TMP($J,"MDHL7A",CNT,CNT3))="" ; S LAST=$P(TXT,DEL,CO)
        Q
        ;
        ;. S TXT=$P(TXT,DEL,CO)
        ;. I $L(TXT)>80 D LG(TXT) Q
        ;. Q
        Q
LG(TXT) ; LARGE LINES
        I $L(TXT)<80 D BUILD(TXT) Q
        N SP,TTEXT,LAST,FIRST,TTTEXT,X
        S TEXTTOT=TXT
        S TXT80=$E(TXT,1,80),SP=$L(TXT80," ")
        S TXT=$P(TXT80," ",1,$S(SP>1:SP-1,1:1))
        D BUILD(TXT) S TXT=$E(TEXTTOT,($L(TXT)+2),$L(TEXTTOT))
        I $L(TXT)>80 D LG(TXT)
        Q
BUILD(TXT)      ;
        S LINE2="OBX||TX|||"
        S $P(LINE2,P,6)=TXT
        S CNT2=CNT2+1
        S ^TMP($J,"MDHL7","TEXT",CNT2)=LINE2
        Q
