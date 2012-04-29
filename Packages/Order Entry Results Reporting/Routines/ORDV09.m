ORDV09 ; slc/dcm - OE/RR Report Extracts ;3/15/03  08:12
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**191**;Dec 17,1997
CONSLT(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT) ;Consult Report
 I $L($T(GCPR^OMGCOAS1)) D  Q  ; Call if FHIE station 200
 . D GCPR^OMGCOAS1(DFN,"CONS",ORDBEG,ORDEND,ORMAX)
 . S ROOT=$NA(^TMP("ORDATA",$J))
 Q  ;Possible extract when VA Consult report is finalized.
CONX ;
 ;By Patient Name, Date and or Occurrence
 Q  ;Possible extract when VA Consult is finalized
