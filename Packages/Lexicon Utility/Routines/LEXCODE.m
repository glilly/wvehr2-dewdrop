LEXCODE ; ISL/KER Retrieval of IEN^Term based on Code ; 05/14/2003
 ;;2.0;LEXICON UTILITY;**25**;Sep 23, 1996
 ;
 ; External References
 ;   DBIA  10104  $$UP^XLFSTR
 ;                   
 Q
 ; EN^LEXCODE(X,LEXVDT)
 ;                   
 ;   X        Code taken from a classification 
 ;            system listed in Coding Systems
 ;            file #757.03
 ;                   
 ;   LEXVDT   The date against which the codes 
 ;            found by the search will be compared
 ;            in order to determine whether they 
 ;            are active or inactive. If null is 
 ;            passed then it should default to
 ;            the current date.
 ;                   
 ; Returns Local Array
 ;     LEXS(0)=X
 ;     LEXS(SAB,0)=#
 ;     LEXS(SAB,#)=IEN^TERM
 ;                   
 ; 3 character mnemonics for SAB (Source Abbreviation)
 ;                   
 ;     SAB   Nomenclature  Source
 ;     -----------------------------------------------------------
 ;     ICD     ICD-9-CM    Int'l Class of Disease (Diagnosis)
 ;     ICP     ICD-9-CM    Int'l Class of Disease (Procedures)
 ;     CPT     CPT-4       Current Procedural Terminology
 ;     DSM     DSM-IIIR    Diag & Stat Manual of Mental Disorders
 ;     SNM     SNOMED      Systematic Nomenclature for Medicine
 ;     NAN     NANDA       North American Nursing Diagnosis Assoc
 ;     NIC                 Nursing Intervention Classification
 ;     OMA                 Omaha Nursing Diagnosis/Interventions
 ;     ACR                 American College of Radiology (Diag)
 ;     AIR     AI/RHEUM    National Library of Medicine source
 ;     COS     COSTAR      Computer Stored Ambulatory Records
 ;     CST     COSTART     Coding Sym Thes Adverse Reaction Terms
 ;     DXP     DXPLAIN     Diagnostic Prompting System
 ;     MCM                 McMaster University (Epidemiology)
 ;     UMD                 Universal Medical Device Nomemclature
 ;     CSP     CRISP    
 ;     UWA                 University of Washington (Neuronames)
 ;                   
 ; Example returned array using code 309.24
 ;                   
 ;     LEXS(0)=309.24
 ;     LEXS("DSM",0)=1
 ;     LEXS("DSM",1)=3273^Adjustment disorder with anxious mood
 ;     LEXS("ICD",0)=2
 ;     LEXS("ICD",1)=268308^Adjustment reaction with anxious mood
 ;     LEXS("ICD",2)=3273^Adjustment disorder with anxious mood
 ;                   
 Q
EN(LEX,LEXVDT) ; Get terms associated with a Code
 K LEXS S LEX=$$UP^XLFSTR($G(LEX)) Q:'$L(LEX)
 N LEXSRC,LEXSO,LEXO,LEXSAB,LEXDA,LEXPF,LEXINA,LEXSTA
 S LEXS(0)=LEX,LEXO=LEX_" ",LEXDA=0 Q:'$D(^LEX(757.02,"CODE",LEXO))
 F  S LEXDA=$O(^LEX(757.02,"CODE",LEXO,LEXDA)) Q:+LEXDA=0  D CHK
 D ASEM Q
CHK ; Check if Valid
 S LEXSO=$P($G(^LEX(757.02,LEXDA,0)),"^",2) Q:LEXSO'=LEX
 S LEXSTA=$$STATCHK^LEXSRC2(LEXSO,$G(LEXVDT)) Q:+LEXSTA'>0
 S LEXSRC=+($P($G(^LEX(757.02,LEXDA,0)),"^",3)) Q:LEXSRC'>0
 S LEXSAB=$E($G(^LEX(757.03,+LEXSRC,0)),1,3) Q:$L(LEXSAB)'=3
 S LEXPF=+($P($G(^LEX(757.02,LEXDA,0)),"^",5))
 S:LEXPF=1 LEXS(LEXSAB,"PRE")=LEXDA
 S:LEXPF'=1 LEXS(LEXSAB,"OTH",LEXDA)=""
 Q
ASEM ; Assemble List
 Q:'$D(LEXS)
 N LEXSAB,LEXCT,LEXDA,LEXEX,LEXEXP,LEXY S LEXSAB=""
 F  S LEXSAB=$O(LEXS(LEXSAB)) Q:LEXSAB=""  S LEXCT=0 D
 . I $D(LEXS(LEXSAB,"PRE")) D LEXY
 . S LEXDA=0
 . F  S LEXDA=$O(LEXS(LEXSAB,"OTH",LEXDA)) Q:+LEXDA=0  D LEXY
 . S:+LEXSAB'>0&(LEXSAB'="0") LEXS(LEXSAB,0)=LEXCT
 Q
LEXY ; Get IEN^TERM for Code X
 S:$D(LEXS(LEXSAB,"PRE")) LEXDA=LEXS(LEXSAB,"PRE")
 K:'$D(LEXS(LEXSAB,"PRE")) LEXS(LEXSAB,"OTH",LEXDA) K LEXS(LEXSAB,"PRE")
 S LEXY="",LEXEX=+($P($G(^LEX(757.02,LEXDA,0)),"^",1))
 Q:'$L($G(^LEX(757.01,+LEXEX,0)))
 S LEXEXP=$G(^LEX(757.01,+LEXEX,0)),LEXCT=LEXCT+1,LEXY=LEXEX_"^"_LEXEXP
 S LEXS(LEXSAB,LEXCT)=LEXY
 Q
