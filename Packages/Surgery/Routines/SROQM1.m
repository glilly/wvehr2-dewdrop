SROQM1 ;BIR/ADM - QUARTERLY REPORT (CONTINUED) ;01/30/07
 ;;3.0; Surgery ;**38,62,70,129,153,160**;24 Jun 93;Build 7
 ;** NOTICE: This routine is part of an implementation of a nationally
 ;**         controlled procedure. Local modifications to this routine
 ;**         are prohibited.
 ;
NDEX ; index procedures
 D BLANK S SRBLANK="" F I=1:1:31 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"INDEX PROCEDURES" D LINE S SRLINE=SRBLANK_"----------------" D LINE
 F I=1:1:22 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"CASES WITH" D LINE S SRBLANK="" F I=1:1:29 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"CASES        DEATHS     OCCURRENCES" D LINE
 S SRLINE=SRBLANK_"-----        ------     -----------" D LINE
 F J=1:1:12 D IXUT
CC ; occurrence categories
 D BLANK S SRBLANK="" F I=1:1:21 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"PERIOPERATIVE OCCURRENCE CATEGORIES" D LINE S SRLINE=SRBLANK_"-----------------------------------" D LINE
WC D BLANK S SRLINE=" Wound Occurrences            Total      Urinary Occurrences          Total" D LINE
 S SRLINE=" A. Superficial Incisional SSI"_$J(SRC(1),5)_"      A. Renal Insufficiency       "_$J(SRC(8),5) D LINE
 S SRLINE=" B. Deep Incisional SSI       "_$J(SRC(2),5)_"      B. Acute Renal Failure       "_$J(SRC(9),5) D LINE
 S SRLINE=" C. Wound Disruption          "_$J(SRC(22),5)_"      C. Urinary Tract Infection   "_$J(SRC(10),5) D LINE
 S SRLINE=" D. Other                     "_$J(SRC(36),5)_"      D. Other                     "_$J(SRC(31),5) D LINE,BLANK
RC S SRLINE=" Respiratory Occurrences      Total      CNS Occurrences              Total" D LINE
 S SRLINE=" A. Pneumonia                 "_$J(SRC(4),5)_"      A. CVA/Stroke                "_$J((SRC(12)+SRC(28)),5) D LINE
 S SRLINE=" B. Unplanned Intubation      "_$J((SRC(7)+SRC(11)),5)_"      B. Coma >24 Hours            "_$J(SRC(13),5) D LINE
 S SRLINE=" C. Pulmonary Embolism        "_$J(SRC(5),5)_"      C. Peripheral Nerve Injury   "_$J(SRC(14),5) D LINE
 S SRLINE=" D. On Ventilator >48 Hours   "_$J(SRC(6),5)_"      D. Other                     "_$J(SRC(30),5) D LINE
 S SRLINE=" E. Tracheostomy              "_$J(SRC(33),5) D LINE
 S SRLINE=" F. Repeat Vent w/in 30 Days  "_$J(SRC(37),5) D LINE
 S SRLINE=" G. Other                     "_$J(SRC(29),5) D LINE
 S SRBLANK="" F I=1:1:41 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"Other Occurrences            Total" D LINE
CARD S SRLINE=" Cardiac Occurrences          Total      A. Organ/Space SSI           "_$J(SRC(35),5) D LINE
 S SRLINE=" A. Cardiac Arrest Req. CPR   "_$J(SRC(16),5)_"      B. Bleeding/Transfusions     "_$J(SRC(15),5) D LINE
 S SRLINE=" B. Myocardial Infarction     "_$J(SRC(17),5)_"      C. Graft/Prosthesis/Flap" D LINE
 S SRLINE=" C. Endocarditis              "_$J(SRC(23),5)_"                          Failure  "_$J(SRC(19),5) D LINE
 S SRLINE=" D. Low Cardiac Output >6 Hrs."_$J(SRC(24),5)_"      D. DVT/Thrombophlebitis      "_$J(SRC(20),5) D LINE
 S SRLINE=" E. Mediastinitis             "_$J(SRC(25),5)_"      E. Systemic Sepsis           "_$J(SRC(3),5) D LINE
 S SRLINE=" F. Repeat Card Surg Proc     "_$J(SRC(27),5)_"      F. Reoperation for Bleeding  "_$J(SRC(26),5) D LINE
 S SRLINE=" G. New Mech Circulatory Sup  "_$J(SRC(34),5)_"      G. C. difficile Colitis      "_$J(SRC(38),5) D LINE
 S SRLINE=" H. Other                     "_$J(SRC(32),5)_"      H. Other                     "_$J(SRC(21),5) D LINE,BLANK
 S:'SRWC SRWC=1 S SRLINE=" Clean Wound Infection Rate: "_$J((SRIN/SRWC*100),5,1)_"%" D LINE
 Q
IXUT ; get index procedure data from ^TMP
 F K=1:1:3 S SRP(K)=$P(^TMP("SRPROC",$J,J),"^",K)
 D IXOUT^SROQ0A D
 .I SROP["," D  S SROP=$P(SROP,",",2)
 ..I J=7 S SRLINE="    "_$P(SROP,",") D LINE
 .S SRLINE="    "_SROP S SRBLANK="" F I=1:1:(28-$L(SRLINE)) S SRBLANK=SRBLANK_" "
 S SRLINE=SRLINE_SRBLANK_$J(SRP(1),6)_"       "_$J(SRP(3),6)_"       "_$J(SRP(2),6) D LINE
 Q
BLANK ; blank line
 S ^TMP("SRMSG",$J,SRCNT)="",SRCNT=SRCNT+1
 Q
LINE ; store line in ^TMP
 S ^TMP("SRMSG",$J,SRCNT)=SRLINE,SRCNT=SRCNT+1
 Q
HAIR ; hair removal methods
 D BLANK,BLANK S SRBLANK="" F I=1:1:19 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"PREOPERATIVE HAIR REMOVAL METHODS SUMMARY" D LINE
 S SRLINE=SRBLANK_"-----------------------------------------" D LINE
 D BLANK F I=1:1:23 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"CASES    % OF TOTAL" D LINE
 S SRLINE=SRBLANK_"-----    ----------" D LINE
 S SRBLANK="" F I=1:1:15 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"   TOTAL CASES PERFORMED:"_$J(SRCASES,6)_"       "
 S:SRCASES SRLINE=SRLINE_"100.0" D LINE,BLANK
 S SRLINE=SRBLANK_SRBLANK_"  CLIPPER:"_$J(SRHAIR("C"),6)_"       "
 S:SRCASES SRLINE=SRLINE_$J(((SRHAIR("C")/SRCASES)*100),5,1) D LINE
 S SRLINE=SRBLANK_"              DEPILATORY:"_$J(SRHAIR("D"),6)_"       "
 S:SRCASES SRLINE=SRLINE_$J(((SRHAIR("D")/SRCASES)*100),5,1) D LINE
 S SRLINE=SRBLANK_"         NO HAIR REMOVED:"_$J(SRHAIR("N"),6)_"       "
 S:SRCASES SRLINE=SRLINE_$J(((SRHAIR("N")/SRCASES)*100),5,1) D LINE
 S SRLINE=SRBLANK_"PATIENT REMOVED OWN HAIR:"_$J(SRHAIR("P"),6)_"       "
 S:SRCASES SRLINE=SRLINE_$J(((SRHAIR("P")/SRCASES)*100),5,1) D LINE
 S SRLINE=SRBLANK_SRBLANK_"  SHAVING:"_$J(SRHAIR("S"),6)_"       "
 S:SRCASES SRLINE=SRLINE_$J(((SRHAIR("S")/SRCASES)*100),5,1) D LINE
 N SRNDOC S SRNDOC=SRHAIR("U")+SRHAIR("ZZ")
 S SRLINE=SRBLANK_"          NOT DOCUMENTED:"_$J(SRNDOC,6)_"       "
 S:SRCASES SRLINE=SRLINE_$J(((SRNDOC/SRCASES)*100),5,1) D LINE
 S SRLINE=SRBLANK_SRBLANK_"    OTHER:"_$J(SRHAIR("O"),6)_"       "
 S:SRCASES SRLINE=SRLINE_$J(((SRHAIR("O")/SRCASES)*100),5,1) D LINE
 Q
