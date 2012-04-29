GMRAUIX0        ;HIRMFO/RM-CROSS REFERENCES FOR FILE 120.8 ;11/16/07  10:35
        ;;4.0;Adverse Reaction Tracking;**14,41**;Mar 29, 1996;Build 8
        ;DBIA Section
        ;PSN50P65 - 4543
EN1     ; ENTRY FROM THE ADRG01 OR ADRG22 XREF [^DD(120.8,.01 and ^DD(120.8,22]
        ; FOR FURTHER INFO ON THESE XREFS SEE INTERNAL RELATIONS SECTION
        ; OF THE ADVERSE REACTION TRACKING TECHNICAL MANUAL.
        S GMRA("DA")=DA N DA S DA(1)=GMRA("DA")
        S GMRA("ER")=$S(+GMRA=22:X,1:+$G(^GMR(120.8,DA(1),"ER"))),GMRA(1)=$S(+GMRA=.01:X,1:$P($G(^GMR(120.8,DA(1),0)),"^"))
        F GMRA("X")=2,3 F DA=0:0 S DA=$O(^GMR(120.8,DA(1),GMRA("X"),DA)) Q:DA'>0  S GMRA("INCL")=$P($G(^GMR(120.8,DA(1),GMRA("X"),DA,0)),"^") D IX
        K GMRA
        Q
EN2     ; ENTRY FROM THE ADRG2 OR ADRG3 XREF [^DD(120.802,.01 & ^DD(120.803,.01]
        ; FOR FURTHER INFO ON THESE XREFS SEE INTERNAL RELATIONS SECTION
        ; OF THE ADVERSE REACTION TRACKING TECHNICAL MANUAL.
        S GMRA("INCL")=X,GMRA("X")=+GMRA,GMRA("ER")=+$G(^GMR(120.8,DA(1),"ER")),GMRA(1)=$P($G(^GMR(120.8,DA(1),0)),"^") D IX
        K GMRA
        Q
IX      ; SET/KILL THE INDEX
        K ^TMP($J,"GMRACLASS") ;41 Clear storage before use
        D C^PSN50P65(+GMRA("INCL"),,"GMRACLASS") ;41 Get drug class data
        S GMRA("INCL")=$S(GMRA("X")=2:GMRA("INCL"),1:$G(^TMP($J,"GMRACLASS",+GMRA("INCL"),.01))) ;41 Get drug class code from ^TMP
        Q:'$L(GMRA("INCL"))!'$L(GMRA(1))
        I $P(GMRA,"^",2)&GMRA("ER")!('$P(GMRA,"^",2)&(+GMRA'=22)) K ^GMR(120.8,$P("API^APC","^",GMRA("X")-1),GMRA(1),GMRA("INCL"),DA(1),DA)
        E  S ^GMR(120.8,$P("API^APC","^",GMRA("X")-1),GMRA(1),GMRA("INCL"),DA(1),DA)=""
        Q
