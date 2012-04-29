PPPBLD2 ;ALB/DMB - BUILD FFX FROM CDROM : 3/4/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
ADD2ERR(ARRYNM,ERRTXT) ; Add an error to the error list
 ;
 N IDX,PARMERR,LKUPERR,TMP
 ;
 S PARMERR=-9001
 S LKUPERR=-9003
 ;
 ; Check Parameters
 ;
 I '$D(ARRYNM) Q PARMERR
 I '$D(ERRTXT) S ERRTXT=""
 ;
 ; Set the array
 ;
 F IDX=1:1 S TMP=$O(@ARRYNM@(IDX)) Q:TMP=""
 S @ARRYNM@(IDX+1)=ERRTXT
 ;
 Q 0
