VWCPTPRE        ;WorldVistA/Port Clinton/SO- Pre Install for CPT Codes;6:26 PM  13 Apr 2011
        ;;1.0;;;;Build 5
        ;
PRE     ;This is called from the build's Pre-installation
        N DATA
        I ($D(^XTMP("VWCPT",0))#2) K ^XTMP("VWCPT")
        F I=1:1 S DATA=$T(TBL+I) D  Q:$P(DATA,U)="EOD"
        . S DATA=$P(DATA,";;",2)
        . I $P(DATA,U)="EOD" Q  ;No more global roots to process
        . I '($D(^XTMP("VWCPT",0))#2) S ^XTMP("VWCPT",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"WorldVistA CPT Install"
        . N GROOT S GROOT=U_$P(DATA,U)
        . I ($D(@GROOT@(0))#2) N FHDR S FHDR=@GROOT@(0)
        . S ^XTMP("VWCPT",$P(GROOT,U,2),"Z1-BEFORE")=$S($G(FHDR)'="":FHDR,1:$P(DATA,U,2)_" "_$P(DATA,U,3)_" IS A NEW FILE")
        . Q
EXIT    QUIT
        ;
TBL     ;Table of Global Roots; File Number; & File Name
        ;;ICD9^80^ICD DIAGNOSIS
        ;;ICD0^80.1^ICD OPERATION/PROCEDURE
        ;;ICPT^81^CPT
        ;;DIC(81.1)^81.1^CPT CATEGORY
        ;;DIC(81.2)^81.2^CPT COPYRIGHT
        ;;DIC(81.3)^81.3^CPT MODIFIER
        ;;LEX(757.02)^757.02^CODES
        ;;LEX(757.03)^757.03^CODING SYSTEMS
        ;;LEX(757.001)^757.001^CONCEPT USAGE
        ;;LEX(757.31)^757.31^DISPLAYS
        ;;LEX(757.04)^757.04^EXCLUDED WORDS
        ;;LEX(757.014)^757.014^EXPRESSION FORM
        ;;LEX(757.011)^757.011^EXPRESSION TYPE
        ;;LEX(757.01)^757.01^EXPRESSIONS
        ;;LEX(757.3)^757.3^LOOK-UP SCREENS
        ;;LEX(757)^757^MAJOR CONCEPT MAP
        ;;LEX(757.05)^757.05^REPLACEMENT WORDS
        ;;LEX(757.11)^757.11^SEMANTIC CLASS
        ;;LEX(757.1)^757.1^SEMANTIC MAP
        ;;LEX(757.12)^757.12^SEMANTIC TYPE
        ;;LEX(757.41)^757.41^SHORTCUT CONTEXT
        ;;LEX(757.4)^757.4^SHORTCUTS
        ;;LEX(757.14)^757.14^SOURCE
        ;;LEX(757.13)^757.13^SOURCE CATEGORY
        ;;LEX(757.21)^757.21^SUBSETS
        ;;LEX(757.06)^757.06^UNRESOLVED NARRATIVES
        ;;LEXT(757.2)^757.2^SUBSET DEFINITIONS
        ;;EOD^^End Of Data
