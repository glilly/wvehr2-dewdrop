LEX2043C ; ISL/KER - Post Install LEX*2.0*43  ; 09/06/2006
 ;;2.0;LEXICON UTILITY;**43**;Sep 23, 1996;Build 1
 ;
EN ; Main Entry Point
 D C29,C30,C31,C32,C33,C34
 Q
 ;
C29 ; Lookup E878.9 returns 998.0
 D IND("Lookup E878.9 returns 998.0") N IEN,DA,DIK
 S IEN=276746 K FDA S FDA(757.01,IEN_",",.01)="Unspecified Surgical Operations and/or Procedure as the cause of Abnormal Reaction of Patient, or Later Complication" D FILE^DIE("","FDA")
 S IEN=97087 K FDA S FDA(757.01,IEN_",",.01)="Postoperative Shock, Not Elsewhere Classified" D FILE^DIE("","FDA")
 S IEN=283759 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=283760 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=102809 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 Q
C30 ; Lookup E930.2 returns 960.3
 D IND("Lookup E930.2 returns 960.3") N IEN,DA,DIK
 S IEN=42332 K FDA S FDA(757.01,IEN_",",.01)="Antibiotics, Chloramphenicol Group causing Adverse Effects in Therapeutic Use" D FILE^DIE("","FDA")
 S IEN=275987 K FDA S FDA(757.01,IEN_",",.01)="Poisoning by Antibiotics, Erythromycin and Other Marcrolides" D FILE^DIE("","FDA")
 S IEN=269328 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=269329 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=282954 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 Q
C31 ; Lookup E946.7 returns 976.9
 D IND("Lookup E946.7 returns 976.9") N IEN,DA,DIK
 S IEN=47058 K FDA S FDA(757.01,IEN_",",.01)="Dental Drugs Topically Applied" D FILE^DIE("","FDA")
 S IEN=276147 K FDA S FDA(757.01,IEN_",",.01)="Poisoning by Unspecified Agent Primarily Affecting Skin and Mucous Membrane" D FILE^DIE("","FDA")
 S IEN=269432 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=269434 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=283114 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 Q
C32 ; Lookup E950.4 returns 964.2
 D IND("Lookup E950.4 returns 964.2") N IEN,DA,DIK
 S IEN=259817 K FDA S FDA(757.01,IEN_",",.01)="Suicide and Self-Inflicted Poisoning by Other Specified Drugs or Medicinal Substances" D FILE^DIE("","FDA")
 S IEN=276028 K FDA S FDA(757.01,IEN_",",.01)="Poisoning by Anticoagulants" D FILE^DIE("","FDA")
 S IEN=269769 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=269771 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S IEN=282995 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 Q
C33 ; Lookup E953.8 returns E958.8
 D IND("Lookup E953.8 returns E958.8") N IEN,DA,DIK
 S IEN=294993 K FDA S FDA(757.01,IEN_",",.01)="Suicide and Self-Inflicted Injury by other Specified Means" D FILE^DIE("","FDA")
 S IEN=305516 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=305578 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S ^LEX(757,155034,0)="295837^" S DA=155034,DIK="^LEX(757," D IX1^DIK
 S ^LEX(757.001,155034,0)="155034^4^4" S DA=155034,DIK="^LEX(757.001," D IX1^DIK
 S ^LEX(757.1,223689,0)="155034^6^33" S DA=223689,DIK="^LEX(757.1," D IX1^DIK
 S ^LEX(757.01,295837,0)="Suicide and Self-Inflicted Injury by other specified means, causing Strangulation or Suffocation"
 S ^LEX(757.01,295837,1)="155034^1^D^1" S DA=295837,DIK="^LEX(757.01," D IX1^DIK
 S DA=305516,DIK="^LEX(757.02," D ^DIK S ^LEX(757.02,305516,0)="295837^E953.8^1^155034^1^^1",^LEX(757.02,305516,4,0)="^757.28D^1^1",^LEX(757.02,305516,4,1,0)="2781001^1" D IX1^DIK
 Q
C34 ; Lookup E958.9 returns E953.9
 D IND("Lookup E958.9 returns E953.9") N IEN,DA,DIK
 S IEN=115521 K FDA S FDA(757.01,IEN_",",.01)="Suicide and Self-Inflicted Injury by other Unspecified Means" D FILE^DIE("","FDA")
 S IEN=122357 K FDA S FDA(757.02,IEN_",",4)="",FDA(757.02,IEN_",",6)="0" D FILE^DIE("","FDA")
 S IEN=122358 K FDA S FDA(757.02,IEN_",",4)="1",FDA(757.02,IEN_",",6)="1" D FILE^DIE("","FDA")
 S ^LEX(757,155035,0)="295841^" S DA=155035,DIK="^LEX(757," D IX1^DIK
 S ^LEX(757.001,155035,0)="155035^4^4" S DA=155035,DIK="^LEX(757.001," D IX1^DIK
 S ^LEX(757.1,223690,0)="155035^6^33" S DA=223690,DIK="^LEX(757.1," D IX1^DIK
 S ^LEX(757.01,295841,0)="Suicide and Self-Inflicted Injury by unspecified means, causing Strangulation or Suffocation"
 S ^LEX(757.01,295841,1)="155035^1^D^1" S DA=295841,DIK="^LEX(757.01," D IX1^DIK
 S DA=122357,DIK="^LEX(757.02," D ^DIK S ^LEX(757.02,122357,0)="295841^E953.9^1^155035^1^^1",^LEX(757.02,122357,4,0)="^757.28D^1^1",^LEX(757.02,122357,4,1,0)="2781001^1" D IX1^DIK
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
