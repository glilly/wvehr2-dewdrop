LEX2043D ; ISL/KER - Post Install LEX*2.0*43  ; 09/06/2006
 ;;2.0;LEXICON UTILITY;**43**;Sep 23, 1996;Build 1
 ;
EN ; Main Entry Point
 D C35,C36,C37,C38
 Q
C35 ; HD0000000 142632 - AIDS and Hip Pain
 D MES^XPDUTL(" "),MES^XPDUTL("  Fixes made to ICD-9 in the Lexicon"),MES^XPDUTL(" ")
 D REMI("Problem with 2 codes 042 and  719.45","HD0000000 142632")
 N IEN,DA,DIK
 S ^LEX(757.01,266500,5,0)="^757.18^1^1",^LEX(757.01,266500,5,1,0)="AIDS",^LEX(757.01,266500,5,"B","AIDS",1)="",DA=266500,DIK="^LEX(757.01," D IX1^DIK
 S ^LEX(757.01,304652,5,0)="^757.18^1^1",^LEX(757.01,304652,5,1,0)="AIDS",^LEX(757.01,304652,5,"B","AIDS",1)="",DA=304652,DIK="^LEX(757.01," D IX1^DIK
 S ^LEX(757.02,317464,0)="2244^042.^1^458^0^^0",^LEX(757.02,317464,4,0)="^757.28D^1^1",^LEX(757.02,317464,4,1,0)="2781001^1",DA=317464,DIK="^LEX(757.02," D IX1^DIK
 S ^LEX(757.01,2244,5,0)="^757.18^1^1",^LEX(757.01,2244,5,1,0)="AIDS",^LEX(757.01,2244,5,"B","AIDS",1)="",DA=2244,DIK="^LEX(757.01," D IX1^DIK
 S ^LEX(757.01,272402,5,0)="^757.18^1^1",^LEX(757.01,272402,5,1,0)="HIP",^LEX(757.01,272402,5,"B","HIP",1)="",DA=272402,DIK="^LEX(757.01," D IX1^DIK
 S ^LEX(757.01,272252,5,0)="^757.18^2^2",^LEX(757.01,272252,5,1,0)="HIP",^LEX(757.01,272252,5,2,0)="PAIN" S DA=272252,DIK="^LEX(757.01," D IX1^DIK
 S IEN=60666 K FDA S FDA(757.02,IEN_",",1)="719.45",FDA(757.02,IEN_",",2)="1",FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=269850 K FDA S FDA(757.02,IEN_",",1)="719.45",FDA(757.02,IEN_",",2)="1",FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=267561 K FDA S FDA(757.02,IEN_",",1)="719.45",FDA(757.02,IEN_",",2)="1",FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 Q
C36 ; HD0000000 147490 - ICD Code 567.22 Recognized as CC
 D MES^XPDUTL(" "),MES^XPDUTL("  Fixes made to ICD-9 in file #80"),MES^XPDUTL(" ")
 D REMI("ICD Code 567.22 Recognized as CC","HD0000000 147490")
 N IEN,FDA S IEN=+($$ICDDX^ICDCODE("567.22"))
 I IEN K FDA S FDA(80,IEN_",",70)="1" D FILE^DIE("","FDA")
 Q
C37 ; Fixes made by modifying the logic in ICPTMOD Routine
 D MES^XPDUTL(" ")
 D MES^XPDUTL("  Fixes made by modifying the logic in ICPTMOD Routine")
 D MES^XPDUTL("  or by the re-alignment of the CPT Modifier Ranges"),MES^XPDUTL(" ")
 D REMI("Modifier 47 with 26951","HD0000000 063473")
 D REMI("Modifiers LT & RT with 73500 & 73120","HD0000000 064223")
 D REMI("Modifier P5 with 00910","HD0000000 064495")
 D REMI("Modifier 50 with 92250","HD0000000 084545")
 D REMI("Modifiers 76, 77, 78, and 79 with J8499","HD0000000 097711")
 D REMI("Modifier GT with 90853","HD0000000 110935")
 D REMI("Modifier GW with 99213","HD0000000 118427")
 D REMI("Modifier 53 with G0121","HD0000000 121972")
 D REMI("Modifier GT with 90853","HD0000000 122219")
 D REMI("Modifiers GN, GO and GP with 97760-97762","HD0000000 134404")
 D REMI("Modifiers GN, GO and GP with 97760-97762","HD0000000 150885")
 Q
C38 ; Fixes made to CPT Modifier file
 D MES^XPDUTL(" ")
 D MES^XPDUTL("  Fixes made by data changes to the CPT Modifier file"),MES^XPDUTL(" ")
 D REMI("Modifier BL with P-Codes","HD0000000 131752")
 D REMI("Modifier 66 with Unlisted Procedures","HD0000000 107714")
 D REMI("Modifier GW with Commercial/Medicare bills","HD0000000 138426")
 D REMI("Modifier 51 with 51741 and 51798","HD0000000 141204")
 D REMI("Modifier GT with 99090 and 99091","HD0000000 150470")
 Q
REM(X,Y) ; Remedy Ticket
 N I S X=$G(X),Y=$G(Y) Q:'$L(X)  I $L(Y) S X="  "_X F  Q:$L(X)>48  S X=X_" "
 S X=X_" "_Y S:$E(X,1)'=" " X=" "_X D MES^XPDUTL(X)
REMI(X,Y) ; Remedy Ticket - Indented
 N I S X=$G(X),Y=$G(Y) Q:'$L(X)
 I $L(Y) S X="    "_X F  Q:$L(X)>48  S X=X_" "
 S X=X_" "_Y S:$E(X,1)'=" " X="    "_X D MES^XPDUTL(X)
 Q
IND(X) ; Indent Text
 N I S X=$G(X) Q:'$L(X)  S X="    "_X D MES^XPDUTL(X)
 Q
