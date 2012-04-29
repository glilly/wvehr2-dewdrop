PPPUTL1 ;ALB/JFP - UTILITIES (GENERIC);01MAR93
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
CENTER(LINE,CTR) ; -- Centers text on 80 column screen
 ;              INPUT  : line - line to center in
 ;                     : ctr  - text to center
 ;             OUTPUT  : X    - centered text
 Q:('$D(LINE)) ""
 Q:('$D(CTR)) ""
 N LEN,LNST
 S LEN=$L(CTR)
 S LNST=((80-LEN)\2)+1
 S X=$$INSERT^PPPUTL1(CTR,LINE,LNST,LEN)
 Q X
 ;
INSERT(INSTR,OUTSTR,COLUMN,LENGTH) ;INSERT A STRING INTO ANOTHER
 ;INPUT  : INSTR - String to insert
 ;         OUTSTR - String to insert into
 ;         COLUMN - Where to begin insertion (defaults to end of OUTSTR)
 ;         LENGTH - Number of characters to clear from OUTSTR
 ;                  (defaults to length of INSTR)
 ;OUTPUT : s - INSTR will be placed into OUTSTR starting at COLUMN
 ;             using LENGTH characters
 ;         "" - Error (bad input)
 ;
 ;NOTE : This module is based on $$SETSTR^VALM1
 ;
 ;CHECK INPUT
 Q:('$D(INSTR)) ""
 Q:('$D(OUTSTR)) ""
 S:('$D(COLUMN)) COLUMN=$L(OUTSTR)+1
 S:('$D(LENGTH)) LENGTH=$L(INSTR)
 ;DECLARE VARIABLES
 N FRONT,END
 S FRONT=$E((OUTSTR_$J("",COLUMN-1)),1,(COLUMN-1))
 S END=$E(OUTSTR,(COLUMN+LENGTH),$L(OUTSTR))
 ;INSERT STRING
 Q FRONT_$E((INSTR_$J("",LENGTH)),1,LENGTH)_END
 ;
ONENTRY(USENTRY) ;SCREEN TO ONLY ALLOW ONE ENTRY IN STATISTIC FILE
 ;INPUT  : USENTRY - What user has entered by user
 ;OUTPUT : 1 - Entered may be used
 ;             (there is no entry or it is the existing entry)
 ;         0 - Entered may not be used
 ;             (it is not the existing entry)
 ;NOTES  : Used in screening of field .01
 ;
 ;CHECK INPUT
 Q:('USENTRY) 0
 ;DECLARE VARIABLES
 N IFN,CURENTRY
 ;CURRENTLY NO ENTRY
 S IFN=$O(^PPP(1020.3,0))
 Q:('IFN) 1
 ;CURRENT ENTRY IS ENTERED INSTITUTION
 S CURENTRY=+$G(^PPP(1020.3,IFN,0))
 Q:(USENTRY=CURENTRY) 1
 ;DON'T ALLOW SELECTION
 Q 0
 ;
DTE(IDTE,STYLE) ; -- Returns formatted date
 ;            INPUT  : IDTE  - INTERNAL FILEMAN DATE
 ;                     STYLE - FLAG INDICATING OUTPUT STYLE
 ;                       IF 0, OUTPUT IN MM-DD-YYYY FORMAT (DEFAULT)
 ;                       IF 1, OUTPUT IN MMM DD, YYYY FORMAT
 ;                       (MMM -> FIRST 3 CHARACTERS OF MONTH NAME)
 ;            OUTPUT : EXTERNAL DATE IN SPECIFIED FORMAT
 S STYLE=+$G(STYLE)
 Q:($G(IDTE)="") ""
 ;MM-DD-YYYY
 Q:('STYLE) $E(IDTE,4,5)_"-"_$E(IDTE,6,7)_"-"_($E(IDTE,1,3)+1700)
 ;MMM DD, YYYY
 N Y,%DT
 S Y=$P(IDTE,".",1)
 D DD^%DT
 Q Y
 ;
END ; -- End of code
 QUIT
