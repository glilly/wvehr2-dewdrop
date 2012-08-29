LEX2056P ;ISL/KER - LEX*2.0*56 Pre/Post Install ;06/06/2007
 ;;2.0;LEXICON UTILITY;**56**;Sep 23, 1996;Build 1
 ;              
 ; Variables NEWed or KILLed Elsewhere
 ;    None
 ;              
 ; Global Variables
 ;    ^LEXM
 ;              
 ; External References
 ;    None
 ;              
 Q
POST ; LEX*2.0*56 Post-Install
 ;            
 ; From IMP^LEX2056
 ;            
 ;      LEXBUILD   Build Name - LEX*2.0*nn
 ;      LEXPTYPE   Patch Type - Remedy or Quarterly
 ;      LEXFY      Fiscal Year - FYnn
 ;      LEXQTR     Quarter - 1st, 2nd, 3rd, or 4th
 ;      LEXIGHF    Name of Host File - LEX_2_nn.GBL
 ;      LEXLREV    Revision - nn
 ;      LEXREQP    Required Builds - build;build;build
 ;            
 N LEXEDT,LEXPTYPE,LEXLREV,LEXREQP,LEXBUILD,LEXIGHF,LEXFY,LEXQTR,LEXB,LEXCD,LEXSTR,LEXLAST D IMP^LEX2056
 S LEXEDT=$G(^LEXM(0,"CREATED")) D LOAD
 Q
LOAD ; Load Data
 ;             
 ;      LEXSHORT   Send Short Message
 ;      LEXMSG     Flag to send Message
 ;            
 N LEXSHORT,LEXMSG S LEXSHORT="",LEXMSG=""
 S LEXSTR=$G(LEXPTYPE) S:$L($G(LEXFY))&($L($G(LEXQTR))) LEXSTR=LEXSTR_" for "_$G(LEXFY)_" "_$G(LEXQTR)_" Quarter"
 S U="^",LEXB=$G(^LEXM(0,"BUILD")) Q:LEXB=""  Q:LEXBUILD=""
 D:LEXB=LEXBUILD EN^LEXXGI
LQ ; Load Quit
 D KLEXM
 Q
 ;             
KLEXM ; Subscripted Kill of ^LEXM
 H 2 N DA S DA=0 F  S DA=$O(^LEXM(DA)) Q:+DA=0  K ^LEXM(DA)
 N LEX S LEX=$G(^LEXM(0,"PRO")) K ^LEXM(0)
 Q
 ;            
PRE ; LEX*2.0*56 Pre-Install   (N/A for patch 56)
 Q
 ;            
CON ; Conversion of data       (N/A for patch 56)
 Q
