ORWGAPIU        ; SLC/STAFF - Graph API Utilities ;3/17/08  10:27
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**215,260,243**;Dec 17, 1997;Build 242
        ;
EVALUE(VAL,FILE,FIELD)  ; $$(internal value,file,field) -> external value or ""
        ; from ORWGAPI1, ORWGAPI2, ORWGAPI3, ORWGAPI4, ORWGAPIP, ORWGAPIR
        I VAL="" Q ""
        S FIELD=$G(FIELD,.01)
        I $E(FILE,1,2)=63 Q $$LABNAME^ORWGAPIC(VAL)
        I FILE="63AP;I" Q $$ICD9^ORWGAPIA(VAL)
        I FILE="45DX" Q $$ICD9^ORWGAPIA(VAL)
        I FILE="45OP" Q $$ICD0^ORWGAPIA(VAL)
        I FILE="45;ICD9" Q $$ICD9^ORWGAPIA(VAL)
        I FILE="45;ICD0" Q $$ICD0^ORWGAPIA(VAL)
        I FIELD=.01,'$L(VAL) Q ""
        I FILE=9000010.07 Q $$ICD9^ORWGAPIA(VAL)
        I FILE=9000010.18 Q $$ICPT^ORWGAPIA(VAL)
        I FILE=9000011 Q $$ICD9^ORWGAPIA(VAL)
        I FILE=9999911 Q $$ICD9^ORWGAPIA(VAL)
        I FILE=130 Q $$ICPT^ORWGAPIA(VAL)
        I FILE=120.8 Q $$ALLG^ORWGAPIA(VAL)
        I FILE=50.605 Q $$DC^ORWGAPIC(VAL)
        I FILE=68 Q $$AA^ORWGAPIC(VAL)
        I FILE=811.2 Q $$TAX^ORWGAPIA(VAL)
        D
        . I FILE=52 S FIELD=6 Q
        . I FILE=53.79 S FIELD=.08 Q
        . I FILE=55 S FILE=55.07 Q
        . I FILE="55NVA" S FILE=55.05 Q
        . I FILE=70 S FILE=70.03,FIELD=2 Q
        . I FILE=100 S FILE=100.001 Q
        . I FILE=120.5 S FIELD=.03 Q
        . I FILE=601.2 S FILE=601.21 Q
        Q $$EXT^ORWGAPIX(VAL,FILE,FIELD)
        ;
FILE(FILE,REF,XREF,SCREEN)      ; from ORWGAPI
        S REF="",SCREEN="I 1",XREF="B"
        I FILE="" Q
        D
        . I FILE="45DX" S REF=$$GBLREF(80),XREF="AB" Q
        . I FILE="45OP" S REF=$$GBLREF(80.1),XREF="AB" Q
        . I FILE=50.605 S REF=$$GBLREF(50.605),XREF="C" Q
        . I FILE=52 S REF=$$GBLREF(50) Q
        . I FILE=53.79 S REF=$$GBLREF(50.7),SCREEN="I $P(ZERO,U,10)'=1" Q
        . I FILE=55 S REF=$$GBLREF(50) Q
        . I FILE="55NVA" S REF=$$GBLREF(50.7),SCREEN="I $P(ZERO,U,10)=1" Q
        . I FILE=63 S REF=$$GBLREF(60),SCREEN="I $L($P(ZERO,U,5)),""BO""[$P(ZERO,U,3),$P(ZERO,U,4)=""CH""" Q
        . I FILE="63AP" S REF=$$GBLREF(60),SCREEN="I 0" Q
        . I FILE="63AP;D" S REF=$$GBLREF(61.4) Q
        . I FILE="63AP;E" S REF=$$GBLREF(61.2) Q
        . I FILE="63AP;F" S REF=$$GBLREF(61.3) Q
        . I FILE="63AP;I" S REF=$$GBLREF(80),XREF="AB" Q
        . I FILE="63AP;M" S REF=$$GBLREF(61.1) Q
        . I FILE="63AP;O" S REF=$$GBLREF(61) Q
        . I FILE="63AP;P" S REF=$$GBLREF(61.5) Q
        . I FILE="63AP;T" S REF=$$GBLREF(60),SCREEN="I ""BO""[$P(ZERO,U,3),(($P(ZERO,U,4)=""CY"")!($P(ZERO,U,4)=""SP"")!($P(ZERO,U,4)=""EM"")!($P(ZERO,U,4)=""AU""))" Q
        . I FILE="63BB" S REF=$$GBLREF(66),SCREEN="I $P(ZERO,U,15)=1" Q
        . I FILE="63MI" S REF=$$GBLREF(60),SCREEN="I 0" Q
        . I FILE="63MI;A" S REF=$$GBLREF(62.06) Q
        . I FILE="63MI;M" S REF=$$GBLREF(60) Q  ; mycobacteria not currently used
        . I FILE="63MI;O" S REF=$$GBLREF(61.2),SCREEN="I $L($P(ZERO,U,5)),""BFPMV""[$P(ZERO,U,5)" Q
        . I FILE="63MI;S" S REF=$$GBLREF(61) Q
        . I FILE="63MI;T" S REF=$$GBLREF(60),SCREEN="I ""BO""[$P(ZERO,U,3),$P(ZERO,U,4)=""MI""" Q
        . I FILE=70 S REF=$$GBLREF(71) Q
        . I FILE=100 S REF=$$GBLREF(101.43) Q
        . I FILE=120.5 S REF=$$GBLREF(120.51),SCREEN="I ""BP^P^T^R^P^HT^WT^CVP^CG^PO2^PN""[$P(ZERO,U,2)" Q
        . ;I FILE=120.8 S REF=$$GBLREF(120.83) Q
        . I FILE=130 S REF=$$GBLREF(81),SCREEN="I '$P(ZERO,U,4)" Q
        . I FILE=405 S REF=$$GBLREF(44),SCREEN="I 0" Q
        . I FILE=601.2 S REF=$$GBLREF(601) Q
        . I FILE=690 S REF=$$GBLREF(697.2),XREF="BA" Q
        . I FILE=811.2 S REF=$$GBLREF(811.2),SCREEN="I $P(ZERO,U,6)'=1" Q
        . I FILE=8925 S REF=$$GBLREF(8925.1),SCREEN="I $P(ZERO,U,4)=""DOC""" Q
        . I FILE=9000010 S REF=$$GBLREF(44) Q
        . I FILE=9000010.07 S REF=$$GBLREF(80),XREF="AB" Q
        . I FILE=9000010.11 S REF=$$GBLREF(9999999.14),SCREEN="I $P(ZERO,U,7)'=1" Q
        . I FILE=9000010.12 S REF=$$GBLREF(9999999.28),SCREEN="I $P(ZERO,U,3)'=1" Q
        . I FILE=9000010.13 S REF=$$GBLREF(9999999.15),SCREEN="I $P(ZERO,U,4)'=1" Q
        . I FILE=9000010.16 S REF=$$GBLREF(9999999.09),SCREEN="I $P(ZERO,U,3)'=1" Q
        . I FILE=9000010.18 S REF=$$GBLREF(81),XREF="BA",SCREEN="I '$P(ZERO,U,4)" Q
        . I FILE=9000010.23 S REF=$$GBLREF(9999999.64),SCREEN="I $P(ZERO,U,10)=""F"",$P(ZERO,U,11)'=1" Q
        . I FILE=9000011 S REF=$$GBLREF(80),XREF="AB",SCREEN="I $E(ZERO)'=""E"",'$L($P(ZERO,U,9))" Q
        . I FILE=9999911 S REF=$$GBLREF(80),XREF="AB",SCREEN="I $E(ZERO)'=""E"",'$L($P(ZERO,U,9))" Q
        I $E(REF)'="^" S REF=""
        S REF=REF  ;_""""_XREF_""")"
        Q
        ;
GBLREF(FN)      ; $$(file#) -> global reference
        Q $$GBLREF^ORWGAPIX($G(FN))
        ;
INISET  ; postinit, set initial public graph setting  - from ORY215, ORY243
        D INISET^ORWGAPIP
        D RESOURCE^ORWGTASK
        Q
        ;
ITEMPRFX(ITEM)  ; $$(item) -> item prefix   - from ORWGAPI1
        N ABBREV,PREFIX
        S PREFIX=""
        S ABBREV=$P(ITEM,";",2)
        I $E(ITEM)="A" D  Q PREFIX
        . I ABBREV="T" S PREFIX="TEST" Q
        . I ABBREV="S" S PREFIX="SPECIMEN" Q
        . I ABBREV="O" S PREFIX="ORGAN" Q
        . I ABBREV="M" S PREFIX="MORPHOLOGY" Q
        . I ABBREV="E" S PREFIX="ETIOLOGY" Q
        . I ABBREV="D" S PREFIX="DISEASE" Q
        . I ABBREV="P" S PREFIX="PROCEDURE" Q
        . I ABBREV="F" S PREFIX="FUNCTION" Q
        . I ABBREV="I" S PREFIX="ICD9" Q
        I $E(ITEM)="B" Q "BLOOD COMPONENT"
        I $E(ITEM)="M" D  Q PREFIX
        . I ABBREV="T" S PREFIX="TEST" Q
        . I ABBREV="S" S PREFIX="SPECIMEN" Q
        . I ABBREV="O" S PREFIX="ORGANISM" Q
        . I ABBREV="A" S PREFIX="ANTIBIOTIC" Q
        . I ABBREV="M" S PREFIX="TB ANTIBIOTIC" Q
        Q PREFIX
        ;
