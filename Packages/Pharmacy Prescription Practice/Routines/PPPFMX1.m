PPPFMX1 ;ALB/JP - XREF CODES FOR PPP;01-DEC-92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
AC(IFN,SET,FNUM,OLDX)        ;AC* XREF FOR FFX file (#1020.2)
 ;INPUT  : IFN - Internal file number of record
 ;         SET - If 1, set cross reference
 ;               If 0, kill cross reference (DEFAULT)
 ;         FNUM - Only valid for KILLS
 ;                The field number that was changed
 ;         OLDX - Only valid for KILLS
 ;                The previous value
 ;OUTPUT : 0 - Cross reference was set/killed
 ;        -1 - Cross reference not set/killed
 ;        -2 - Bad input
 ;
 ; -- CHECK INPUT & RECORD EXISTANCE
 Q:($G(IFN)="") -2
 S SET=+$G(SET)
 Q:('$D(^PPP(1020.2,IFN))) -2
 Q:(('SET)&('$D(FNUM))&('$D(OLDX))) -2
 ; -- DECLARE VARIABLES
 N PATPTR,DOMAIN,ZERO,ONE
 ; -- GET INFO FOR XREF & QUIT IF ANY PART IS NULL
 S ZERO=$G(^PPP(1020.2,IFN,0))
 Q:(ZERO="") -1
 ;
 S ONE=$G(^PPP(1020.2,IFN,1))
 Q:(ONE="") -1
 ;
 S PATPTR=$P(ZERO,"^",1)
 I ('SET) S:(FNUM=.01) PATPTR=OLDX
 Q:(PATPTR="") -1
 ;
 S DOMAIN=$P(ONE,"^",5)
 I ('SET) S:(FNUM=1.5) DOMAIN=OLDX
 Q:(DOMAIN="") -1
 ;
 ; -- SET XREF
 S:(SET) ^PPP(1020.2,"AC",PATPTR,DOMAIN,IFN)=""
 ; -- KILL X-REF
 K:('SET) ^PPP(1020.2,"AC",PATPTR,DOMAIN,IFN)
 Q 0
 ;
