VWCPTPST        ;WorldVistA/Port Clinton/SO- Post Install for CPT Codes;4:46 AM  14 Apr 2011
        ;;1.0;;;;Build 5
        ;
POST    ;This is called from the build's Post-installation
        N VW S VW=0,VW=+$O(^ICPT(VW))
        I 'VW D  ;No CPT Codes
        .;Remove some data from file 757.02
        . N %
        . S %=$P(^DD(757.02,1,0),U,2) I %'="RF" D MES^XPDUTL("DD 757.02,1 has changed") Q
        . S $P(^DD(757.02,1,0),U,2)="F" ;Remove Required
        . S %=$P(^DD(757.02,2,0),U,2) I %'="RP757.03'" D MES^XPDUTL("DD 757.02,2 has changed") Q
        . S $P(^DD(757.02,2,0),U,2)="P757.03'" ;Remove Required
        . N DA,DIE,DR
        . S DA=0,DIE=757.02,DR="1///@;2///@"
        . F  S DA=$O(^LEX(757.02,DA)) Q:DA'>0  D
        .. S %=$P($G(^LEX(757.02,DA,0)),U,3)
        .. I %=3!(%=4) D ^DIE ;Only if Source is CPC or CPT4
        .. Q
        . S $P(^DD(757.02,1,0),U,2)="RF" ;Make Required Again
        . S $P(^DD(757.02,2,0),U,2)="RP757.03'" ;Make Required Again
        . Q
        ;
        N DATA
        F I=1:1 S DATA=$T(TBL+I) D  Q:$P(DATA,U)="EOD"
        . S DATA=$P(DATA,";;",2)
        . I $P(DATA,U)="EOD" Q  ;No more global roots to process
        . I '($D(^XTMP("VWCPT",0))#2) S ^XTMP("VWCPT",0)=$$FMADD^XLFDT(DT,365)_U
        . N GROOT S GROOT=U_$P(DATA,U)
        . I ($D(@GROOT@(0))#2) N FHDR S FHDR=@GROOT@(0)
        . S ^XTMP("VWCPT",$P(GROOT,U,2),"Z2-AFTER")=$S($G(FHDR)'="":FHDR,1:$P(DATA,U,2)_" "_$P(DATA,U,3)_" FILE HAS BEEN DELETED")
        . Q
        I $G(XPDNM)]"" D DISP
        QUIT
        ;
DISP    ;Display the Before and After Results
        N GROOT S GROOT="#"
        F  S GROOT=$O(^XTMP("VWCPT",GROOT)) Q:GROOT=""  D
        . N X
        . F I="Z1-BEFORE","Z2-AFTER" S X=^XTMP("VWCPT",GROOT,I) D MES^XPDUTL(X)
        . S X=" " D MES^XPDUTL(X)
        . Q
        ;
        I 'VW Q
        ;
INTRO   ;Add AMA Copyright to Kernel Intro
        N IEN S IEN=0
        S IEN=+$O(^XTV(8989.3,IEN))
        I 'IEN D MES^XPDUTL("You are missing your Kernel System Parameter entry!") Q
        D MES^XPDUTL("Adding AMA Copyright to Kernel Intro text...")
        N LN,FLAG S LN=0,FLAG=0
        F  S LN=$O(^XTV(8989.3,IEN,"INTRO",LN)) Q:'LN  D
        .I ^XTV(8989.3,IEN,"INTRO",LN,0)["CPT copyright AMA 2009 American Medical Association." S ^XTV(8989.3,IEN,"INTRO",LN,0)="CPT copyright AMA |NUMYEAR4(TODAY-365)| American Medical Association. All rights reserved.",FLAG=1 Q
        .I ^XTV(8989.3,IEN,"INTRO",LN,0)["|NUMYEAR4(TODAY-365)|" S FLAG=1 Q
        .Q
        I FLAG G EXIT
        ;
ADD     ;Add AMA Copyright
        N TXT,DIERR
        S TXT=""
        S TXT(1)=" "
        S TXT(2)="               **AMA Copyright Notice** **AMA Copyright Notice*"
        S TXT(3)="CPT copyright AMA |NUMYEAR4(TODAY-365)| American Medical Association.  All rights reserved."
        S TXT(4)=" "
        S TXT(5)="Fee schedules, relative value units, conversion factors and/or related"
        S TXT(6)="components are not assigned by the AMA, are not part of CPT, and the AMA is"
        S TXT(7)="not recommending their use.  The AMA does not directly or indirectly practice"
        S TXT(8)="medicine or dispense medical services. The AMA assumes no liability for data"
        S TXT(9)="contained or not contained herein."
        S TXT(10)=" "
        S TXT(11)="CPT is a registered trademark of the American Medical Association."
        D
        . N II S II=0
        . F  S II=$O(TXT(II)) Q:'II  D MES^XPDUTL(TXT(II))
        . Q
        D WP^DIE(8989.3,IEN_",",240,"A","TXT")
        I $G(DIERR)]"" D MES^XPDUTL("Updating error, please contact WorldVistA.") D CLEAN^DILF Q
        D CLEAN^DILF
        D MES^XPDUTL("AMA Copyright has been successfully at to the Kernel Intro text.")
        ;
EXIT    Q
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
