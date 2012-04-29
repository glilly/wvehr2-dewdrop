LEX2043B ; ISL/KER - Post Install LEX*2.0*43  ; 09/06/2006
 ;;2.0;LEXICON UTILITY;**43**;Sep 23, 1996;Build 1
 ;
EN ; Main Entry Point
 D C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28
 Q
C17 ; Lookup 369.66 returns 369.62
 D IND("Lookup 369.66 returns 369.62") N IEN,DA,DIK
 S ^LEX(757,140128,0)="268891^" S DA=140128,DIK="^LEX(757," D IX1^DIK
 S ^LEX(757.001,140128,0)="140128^4^4" S DA=140128,DIK="^LEX(757.001," D IX1^DIK
 S ^LEX(757.1,206557,0)="140128^6^47" S DA=206557,DIK="^LEX(757.1," D IX1^DIK
 S ^LEX(757.01,268891,0)="One Eye: near total impairment, Other eye: normal vision"
 S ^LEX(757.01,268891,1)="140128^1^D^1" S DA=268891,DIK="^LEX(757.01," D IX1^DIK
 S DA=275719,DIK="^LEX(757.02," D ^DIK S ^LEX(757.02,275719,0)="268891^369.66^1^140128^1^^1",^LEX(757.02,275719,4,0)="^757.28D^1^1",^LEX(757.02,275719,4,1,0)="2781001^1" S DA=275719,DIK="^LEX(757.02," D IX1^DIK
 Q
C18 ; Lookup 414.10 returns 414.19
 D REMI("Lookup 414.10 returns 414.19","HD0000000 149971") N IEN,DA,DIK
 S IEN=57741 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=306564 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=92869 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=54644 K FDA S FDA(757.01,IEN_",",.01)="Aneurysm of Heart (Wall)" D FILE^DIE("","FDA")
 S IEN=87338 K FDA S FDA(757.01,IEN_",",.01)="Other Aneurysm of Heart" D FILE^DIE("","FDA")
 Q
C19 ; Lookup 459.9  returns 443.9
 D IND("Lookup 459.9  returns 443.9") N IEN,DA,DIK
 S IEN=269849 K FDA S FDA(757.01,IEN_",",.01)="Unspecified Circulatory System Disorder" D FILE^DIE("","FDA")
 S IEN=307196 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=132869 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=132871 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=191584 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=184182 K FDA S FDA(757.01,IEN_",",.01)="Peripheral Vascualar Disease, Unspecified" D FILE^DIE("","FDA")
 Q
C20 ; Lookup 519.9  returns 786.00
 D IND("Lookup 519.9  returns 786.00") N IEN,DA,DIK
 S IEN=105137 K FDA S FDA(757.01,IEN_",",.01)="Unspecified Disease of the Respiratory System" D FILE^DIE("","FDA")
 S IEN=111130 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=111135 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=105164 K FDA S FDA(757.01,IEN_",",.01)="Respiratory Abnormality, Unspecified" D FILE^DIE("","FDA")
 S IEN=111152 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 Q
C21 ; Lookup 533.31 returns 533.20
 D IND("Lookup 533.31 returns 533.20") N IEN,DA,DIK
 S IEN=270121 K FDA S FDA(757.01,IEN_",",.01)="Acute Peptic Ulcer without mention of hemorrihage and preforation with obstruction" D FILE^DIE("","FDA")
 S IEN=276983 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=264378 K FDA S FDA(757.01,IEN_",",.01)="Acute peptic ulcer with hemorrhage and perforation, without mention of obstruction" D FILE^DIE("","FDA")
 S DA=307237,DIK="^LEX(757.02," D ^DIK S ^LEX(757.02,307237,0)="264378^533.20^1^130078^1^^1",^LEX(757.02,307237,4,0)="^757.28D^1^1"
 S ^LEX(757.02,307237,4,1,0)="2781001^1" D IX1^DIK
 K ^LEX(757.02,"ACODE","533.20 ",276982),^LEX(757.02,"AMC",134124,276982),^LEX(757.02,"APCODE","533.20 ",276982),^LEX(757.02,"ASRC","ICD",276982)
 K ^LEX(757.02,"B",270121,276982),^LEX(757.02,"CODE","533.20 ",276982),^LEX(757.02,"ACT","533.20 ",1,2781001,276982,1),^LEX(757.02,"ACT","533.20 ",3,2781001,276982,1)
 K ^LEX(757.02,"AVA","533.20 ",270121,"ICD",276982) S ^LEX(757.02,276982,0)="270121^533.20^1^134124^0^^0" S DA=276982,DIK="^LEX(757.02," D IX1^DIK
 Q
C22 ; Lookup 664.14 returns 666.14
 D IND("Lookup 664.14 returns 666.14") N IEN,DA,DIK
 S IEN=271500 K FDA S FDA(757.01,IEN_",",.01)="Other Immediate Postpartum Hemorrhage, Postpartum" D FILE^DIE("","FDA")
 S ^LEX(757,140249,0)="271573^" S DA=140249,DIK="^LEX(757," D IX1^DIK S ^LEX(757.001,140249,0)="140249^4^4" S DA=140249,DIK="^LEX(757.001," D IX1^DIK
 S ^LEX(757.1,201631,0)="140249^6^47" S DA=201631,DIK="^LEX(757.1," D IX1^DIK S ^LEX(757.01,271573,0)="Second Degree Perineal Laceration, Postpartum"
 S ^LEX(757.01,271573,1)="140249^1^D^1" S DA=271573,DIK="^LEX(757.01," D IX1^DIK S DA=278368,DIK="^LEX(757.02," D ^DIK
 S ^LEX(757.02,278368,0)="271573^664.14^1^140249^1^^1",^LEX(757.02,278368,4,0)="^757.28D^1^1",^LEX(757.02,278368,4,1,0)="2781001^1"
 S DA=278368,DIK="^LEX(757.02," D IX1^DIK
 Q
C23 ; Lookup 696.8  returns 696.1
 D IND("Lookup 696.8  returns 696.1") N IEN,DA,DIK
 S IEN=87816 K FDA S FDA(757.01,IEN_",",.01)="Other Psoriasis and Similar Disorders" D FILE^DIE("","FDA")
 S IEN=93101 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=93102 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=271917 K FDA S FDA(757.01,IEN_",",.01)="Other Psoriasis" D FILE^DIE("","FDA")
 S IEN=307565 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 Q
C24 ; Lookup 745.10 returns 745.19
 D IND("Lookup 745.10 returns 745.19") N IEN,DA,DIK
 S IEN=121395 K FDA S FDA(757.01,IEN_",",.01)="Complete Transposition of Great Vessels" D FILE^DIE("","FDA")
 S IEN=306788 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=128688 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=272881 K FDA S FDA(757.01,IEN_",",.01)="Other Transposition of Great Vessels" D FILE^DIE("","FDA")
 S IEN=279792 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 Q
C25 ; Lookup 753.16 returns 753.17
 D IND("Lookup 753.16 returns 753.17") N IEN,DA,DIK
 S IEN=67302 K FDA S FDA(757.01,IEN_",",.01)="Medullary Sponge Kidney" D FILE^DIE("","FDA")
 S IEN=304006 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=67073 K FDA S FDA(757.01,IEN_",",.01)="Medullary Cystic Kidney" D FILE^DIE("","FDA")
 S IEN=67076 K FDA S FDA(757.01,IEN_",",.01)="Cystic Kidney" D FILE^DIE("","FDA")
 S DA=19744,DIK="^LEX(757.1," D ^DIK S ^LEX(757.1,19774,0)="13663^6^47" D IX1^DIK
 S DA=304081,DIK="^LEX(757.02," D ^DIK S ^LEX(757.02,304081,0)="67073^753.16^1^13663^1^^1",^LEX(757.02,304081,4,0)="^757.28D^1^1",^LEX(757.02,304081,4,1,0)="2781001^1" D IX1^DIK
 Q
C26 ; Lookup 755.39 returns 755.29
 D IND("Lookup 755.39 returns 755.29") N IEN,DA,DIK
 S IEN=273036 K FDA S FDA(757.01,IEN_",",.01)="Reduction Deformity of the Lower Limb, Longitudinal Deficiency, Phalanges, complete or partial" D FILE^DIE("","FDA")
 S IEN=279955 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S ^LEX(757,140404,0)="273049^" S DA=140404,DIK="^LEX(757," D IX1^DIK
 S ^LEX(757.001,140404,0)="140404^4^4" S DA=140404,DIK="^LEX(757.001," D IX1^DIK
 S ^LEX(757.1,206697,0)="140404^2^19" S DA=206697,DIK="^LEX(757.1," D IX1^DIK
 S ^LEX(757.01,273049,0)="Reduction Deformity of the Upper Limb, Longitudinal Deficiency, Phalanges, complete or partial"
 S ^LEX(757.01,273049,1)="140404^1^D^1" S DA=273049,DIK="^LEX(757.01," D IX1^DIK
 S DA=279954,DIK="^LEX(757.02," D ^DIK S ^LEX(757.02,279954,0)="273049^755.29^1^140404^1^^1",^LEX(757.02,279954,4,0)="^757.28D^1^1",^LEX(757.02,279954,4,1,0)="2781001^1" D IX1^DIK
 Q
C27 ; Lookup E850.3 returns 965.1
 D IND("Lookup E850.3 returns 965.1") N IEN,DA,DIK
 S IEN=107569 K FDA S FDA(757.01,IEN_",",.01)="Accidental Poisoning by Sallcylates" D FILE^DIE("","FDA")
 S IEN=107571 K FDA S FDA(757.01,IEN_",",.01)="Accidental Poisoning by Salicylic Acid Salts" D FILE^DIE("","FDA")
 S IEN=270025 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=270027 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=276042 K FDA S FDA(757.01,IEN_",",.01)="Poisoning by Salicylates" D FILE^DIE("","FDA")
 S IEN=283009 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 Q
C28 ; Lookup E866.1 returns 985.0
 D IND("Lookup E866.1 returns 985.0") N IEN,DA,DIK
 S IEN=76237 K FDA S FDA(757.01,IEN_",",.01)="Accidental Poisoning by Mercury, its Components and/or Fumes" D FILE^DIE("","FDA")
 S IEN=76238 K FDA S FDA(757.01,IEN_",",.01)="Accidental Poisoning by Mercury" D FILE^DIE("","FDA")
 S IEN=269297 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=269299 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=120633 K FDA S FDA(757.01,IEN_",",.01)="Toxic Effect of Mercury and its Components" D FILE^DIE("","FDA")
 S IEN=127967 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
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
