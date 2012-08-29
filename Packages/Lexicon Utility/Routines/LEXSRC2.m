LEXSRC2 ; ISL/KER/FJF Classification Code Source Util ; 01/01/2004
 ;;2.0;LEXICON UTILITY;**25,28**;Sep 23, 1996
 ;
 ; External References
 ;   DBIA  3992  $$STATCHK^ICDAPIU
 ;   DBIA  1997  $$STATCHK^ICPTAPIU
 ;   DBIA 10103  $$DT^XLFDT
 ;                      
 Q
CPT(LEXC,LEXVDT) ; Return Pointer to Active CPT
 ;                 
 ; Input  CPT Code
 ; Output IEN file 81 of Active Codes only
 S LEXC=$G(LEXC) Q:'$L(LEXC) ""  S LEXVDT=$G(LEXVDT) S:+LEXVDT'>0 LEXVDT=$$DT^XLFDT
 S LEXC=$$STATCHK^ICPTAPIU(LEXC,LEXVDT) Q:+LEXC'>0 ""  S LEXC=$P(LEXC,"^",2) Q:+LEXC'>0 ""
 Q +LEXC
 ;                
ICD(LEXC,LEXVDT) ; Return Pointer to Active ICD/ICP
 ;                 
 ; Input ICD9 or ICD0 Code
 ; Output IEN file 80 or 80.1 of Active Codes only
 S LEXC=$G(LEXC) Q:'$L(LEXC) ""  S LEXVDT=$G(LEXVDT) S:+LEXVDT'>0 LEXVDT=$$DT^XLFDT
 S LEXC=$$STATCHK^ICDAPIU(LEXC,LEXVDT) Q:+LEXC'>0 ""  S LEXC=$P(LEXC,"^",2) Q:+LEXC'>0 ""
 Q +LEXC
 ;                
STATCHK(CODE,CDT,LEX) ; Check Status of a Code
 ;                      
 ; Input:
 ;   CODE - Any Code (ICD/CPT/DSM etc)
 ;   CDT  - Date to screen against (default = today)
 ;   LEX  - Output Array, passed by reference
 ;                      
 ; Output:
 ;                      
 ;   2-Piece String containing the code's status
 ;   and the IEN if the code exists, else -1.
 ;   The following are possible outputs:
 ;           1 ^ IEN         Active Code
 ;           0 ^ IEN         Inactive Code
 ;           0 ^ -1          Code not Found
 ;                      
 ;   ASTM Triplet in array LEX passed by reference (optional)
 ;                      
 ;     LEX(0) = <ien 757.02> ^ <code>
 ;              2-Piece String containing the IEN of 
 ;              the code and the code
 ;                      
 ;     LEX(1) = <ien 757.01> ^ <expression>
 ;              2-Piece String containing the IEN of 
 ;              the code's expression and the expression
 ;                      
 ;     LEX(2) = <ien 757.03> ^ <abbr> ^ <nomen> ^ <name>
 ;              4-Piece String containing the IEN of 
 ;              the code's classification system, the 
 ;              source abbreviation, Nomenclature and
 ;              the name of the classification system
 ;                      
 ; This API requires the ACT Cross-Reference
 ;       ^LEX(757.02,"ACT",<code>,<status>,<date>,<ien>)
 ;
 ;
 N LEXC,LEXAIEN,LEXIEN,LEXDT,X,PREVACT,PREVINA,MOSTREC,STATUS
 S LEXC=$G(CODE) I '$L(LEXC) S (LEX,X)="0^-1" D UPD Q X
 S LEXDT=$P($G(CDT),".",1),LEXDT=$S(+LEXDT>0:LEXDT,1:$$DT^XLFDT)
 ;
 ; Find preceding date for active codes
 S PREVACT=+$O(^LEX(757.02,"ACT",LEXC_" ",3,LEXDT+.00001),-1)
 S LEXAIEN=0 S:+PREVACT>0 LEXAIEN=+$O(^LEX(757.02,"ACT",LEXC_" ",3,+PREVACT," "),-1)
 ;
 ; Find preceding date for inactive codes
 S PREVINA=+$O(^LEX(757.02,"ACT",LEXC_" ",2,LEXDT+.00001),-1)
 S:+LEXAIEN>0&(+$O(^LEX(757.02,"ACT",LEXC_" ",2,PREVINA," "),-1)'=LEXAIEN) PREVINA=0
 ;
 ; Check that both are not zero
 I PREVACT=0,PREVINA=0 S (LEX,X)="0^-1" D UPD Q X
 ;
 ; Find the most recent of the two dates and matching status
 S MOSTREC=$S(PREVACT>PREVINA:PREVACT,1:PREVINA)
 S STATUS=$S(PREVACT>PREVINA:1,1:0)
 ;
 ; Now cope with difficulties arising from boundary conditions
 I $$BOUND D
 .S STATUS='STATUS
 .S MOSTREC=$O(^LEX(757.02,"ACT",LEXC_" ",STATUS+2,LEXDT),-1)
 ;
 ; Get code IEN
 S LEXIEN=$O(^LEX(757.02,"ACT",LEXC_" ",STATUS+2,MOSTREC,""))
 ;
 ; Quit with valid status and code IEN
 S (LEX,X)=STATUS_"^"_LEXIEN D UPD
 Q X
 ;
BOUND() ; Do we have a boundary?
 ; Check if we have an entry for the next day of the complementary
 ; status, if so then we need to obtain the status for the 
 ; preceding day
 I $D(^LEX(757.02,"ACT",LEXC_" ",2+'STATUS,$$DPLUS1(MOSTREC))) Q 1
 Q 0
 ;
DPLUS1(DATE)    ; Add a day to the date
 ;
 Q $$HTFM^XLFDT($$FMTH^XLFDT(DATE)+1)
 ;                      
UPD ; Update Array
 N LEXI,LEXC,LEXN,LEXE,LEXS S LEXI=+($P($G(X),"^",2)) Q:+LEXI'>0
 S LEXN=$G(^LEX(757.02,+LEXI,0)),LEXE=+LEXN,LEXC=$P(LEXN,"^",2)
 S LEXS=+($P(LEXN,"^",3)),LEX(0)=+LEXI_"^"_LEXC
 S LEX(1)=LEXE_"^"_$P($G(^LEX(757.01,+LEXE,0)),"^",1)
 S LEX(2)=LEXS_"^"_$P($G(^LEX(757.03,+LEXS,0)),"^",1,3)
 Q
PI(X) ; Preferred IEN for code X
 N LEXE,LEXLA,LEXA,LEXS,LEXC,LEXP,LEXPF,LEXF,LEXI,LEXC,LEXFL
 S LEXC=$G(X) Q:'$L(LEXC) ""  S (LEXP,LEXF,LEXI)=0,LEXPF(0)=LEXC
 F  S LEXI=$O(^LEX(757.02,"CODE",(LEXC_" "),LEXI)) Q:+LEXI=0!(LEXP>0)  D
 . S:+LEXF'>0 LEXF=LEXI S LEXFL=$S(+($P($G(^LEX(757.02,+LEXI,0)),"^",5))>0:1,1:0)
 . S LEXE=0,LEXLA="" F  S LEXE=$O(^LEX(757.02,+LEXI,4,LEXE)) Q:+LEXE=0  D
 . . S LEXS=$P($G(^LEX(757.02,+LEXI,4,LEXE,0)),"^",2) Q:+LEXS'>0
 . . S LEXA=$P($G(^LEX(757.02,+LEXI,4,LEXE,0)),"^",1)
 . . S:+LEXA>+LEXLA LEXLA=+LEXA
 . S:+LEXLA>0 LEXPF(LEXFL,LEXLA,LEXI)=""
 S X="" I $D(LEXPF(1)) S X=$O(LEXPF(1," "),-1),X=$O(LEXPF(1,+X," "),-1)
 I '$D(LEXPF(1)),$D(LEXPF(0)) S X=$O(LEXPF(0," "),-1),X=$O(LEXPF(0,+X," "),-1)
 Q X
 ;                      
HIST(CODE,ARY) ; Activation History
 ;                      
 ; Input:
 ;    CODE - Code - REQUIRED
 ;    .ARY - Array, passed by Reference
 ;                      
 ; Output:
 ;    ARY(0) = Number of Activation History Entries
 ;    ARY(<date>) = status    where: 1 is Active
 ;    ARY("IEN") = <ien>
 ;
 N LEXC,LEXI,LEXN,LEXD,LEXF,LEXO S LEXC=$G(CODE) Q:'$L(LEXC) -1
 S LEXI=$$PI(LEXC),ARY("IEN")=LEXI,LEXO=""
 M LEXO=^LEX(757.02,+LEXI,4) K LEXO("B")
 S ARY(0)=+($P($G(LEXO(0)),U,4))
 S:+ARY(0)=0 ARY(0)=-1 K:ARY(0)=-1 ARY("IEN")
 S (LEXI,LEXC)=0 F  S LEXI=$O(LEXO(LEXI)) Q:+LEXI=0  D
 . S LEXD=$P($G(LEXO(LEXI,0)),U,1) Q:+LEXD=0
 . S LEXF=$P($G(LEXO(LEXI,0)),U,2) Q:'$L(LEXF)
 . S LEXC=LEXC+1,ARY(0)=LEXC,ARY(LEXD)=LEXF
 Q ARY(0)
