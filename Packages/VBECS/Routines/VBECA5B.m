VBECA5B ;HIOFO/BNT/RLM - VBECS COMPONENT CLASS LOOKUP FOR SURGERY ;11/24/2004
        ;;1.0;VBECS;;Apr 14, 2005;Build 35
        ;
        ; Note: This routine supports data exchange with an FDA registered
        ; medical device. As such, it may not be changed in any way without
        ; prior written approval from the medical device manufacturer.
        ; 
        ; Integration Agreements:
        ; Reference DIBA 4622 for VBECS Blood Products
        ; Reference to EN^MXMLPRSE supported by IA #4149
        ; Reference to CHKNAME^XQ5 supported by IA #????
        ; 
        QUIT
        ;
COMPCL   ; -- Retrieves XML from VBECS
        Q:'$D(X)
        K ^TMP("VBECA5B",$J),^TMP("VBECA5B1",$J) S VBECX=X
        D INITV^VBECRPCC("VBECS Blood Products")
        S VBECY="^TMP(""VBECA5B"",$J)",VBECPRMS("RESULTS")="^TMP(""VBECA5B1"",$J)"
        S VBECSTAT=$$EXECUTE^VBECRPCC(.VBECPRMS)
        D PARSE^VBECRPC1(.VBECPRMS,VBECY)
        D EN(.ARR,VBECY)
SEL     ;
        K C,DIR S X=VBECX
        ;S DIR("A")="",DIR(0)="FA^2:40",DIR("?")="^D LIST^VBECA5B",DIR("??")="^D LIST^VBECA5B" D ^DIR I $D(DIRUT) S X="" Q  ;Uncomment for testing
        I $D(^TMP("VBEC_BP_DATA",$J,"BLOOD PRODUCT","B",X)) Q
        S A=X F I=1:1 S A=$O(^TMP("VBEC_BP_DATA",$J,"BLOOD PRODUCT","B",A)) Q:$E(A,1,$L(X))'=X  D
         . S B="" F  S B=$O(^TMP("VBEC_BP_DATA",$J,"BLOOD PRODUCT","B",A,B)) Q:B=""  S C(I,A)=B
        I I=2 S Y=$O(C(1,"")) W $E(Y,$L(X)+1,999) S X=Y Q
        S (A,B)="" F  S A=$O(C(A)) Q:'A  W !?5,A,?9 F  S B=$O(C(A,B)) Q:B=""  W B
SEL1    K DIR S DIR("A")="CHOOSE 1-"_(I-1)_":",DIR(0)="LA^1:"_(I-1),DIR("?")="^D LIST^VBECA5B",DIR("??")="^D LIST^VBECA5B"
        D ^DIR I $D(DIRUT) S X="" Q
        S X=$O(C(X,""))
EXIT    ;
        K A,B,DIRUT,EVT,I,OPTION,VBECABHC,VBECLN,VBECMSBC,VBECPRMS,VBECRES
        K VBECL,VBECSRC,VBECSTAT,VBECTRHC,VBECTSTC,VBECUNA,VBECUNC,VBECUND
        K VBECUNS,VBECY,Y
        Q
LIST    ;Lists components for ? or ??.  Also replaces LIST66 and OUT66
        S A=""  F VBECL=1:1 S A=$O(^TMP("VBEC_BP_DATA",$J,"BLOOD PRODUCT",A)) Q:'A  D  I '(VBECL#5) S DIR(0)="E" D ^DIR Q:$D(DIRUT)
         . W !,$P(^TMP("VBEC_BP_DATA",$J,"BLOOD PRODUCT",A),"^"),"   ",$P(^TMP("VBEC_BP_DATA",$J,"BLOOD PRODUCT",A),"^",2)
        Q
EN(ARR,DOC)     ;
        N CBK,CNT
        S OPTION="",VBECRES=$NA(^TMP("VBEC_BP_DATA",$J))
        K @VBECRES
        S (VBECLN,VBECTRHC,VBECABHC,VBECTSTC,VBECMSBC,VBECSRC,VBECUNC,VBECUNS,VBECUNA,VBECUND)=0
        D SET(.CBK)
        D EN^MXMLPRSE(DOC,.CBK,.OPTION)
        M ARR=@VBECRES
        Q
SET(CBK)        ;
        K CBK
        S CBK("STARTELEMENT")="STELE^VBECA5B"
        S CBK("ENDELEMENT")="ENELE^VBECA5B"
        S CBK("CHARACTERS")="CHAR^VBECA5B"
        Q
        ;
STELE(ELE,ATR)  ; -- element start event handler
        I ELE="ComponentClass" D
         . S VBECLN=VBECLN+1,@VBECRES@("BLOOD PRODUCT",VBECLN)=$G(ATR("name"))_"^"_$G(ATR("shortName"))
         . S @VBECRES@("BLOOD PRODUCT","B",$G(ATR("name")),VBECLN)=""
         . S @VBECRES@("BLOOD PRODUCT","B",$G(ATR("shortName")),VBECLN)=""
        Q
ENELE(ELE)      ; -- element end event handler
        Q
        ;
CHAR(TEXT)      ;
        Q
ZEOR    ;VBECA5B
