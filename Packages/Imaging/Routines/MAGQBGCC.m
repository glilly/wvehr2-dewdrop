MAGQBGCC ;WOIFO/RMP - Export an image file to a remote location  [ 06/20/2001 08:57 ]
 ;;3.0;IMAGING;**8,48,20**;Apr 12, 2006
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
ENTRY(RESULT,QPTR) ; entry point from ^MAGQBTM
 ; RESULT=STATUS^IMAGE PTR^FROM FILE^TO FILE^QUEUE PTR^REMOTELOC PTR^QSN
 ; QSN=QUEUE SEQUENCE NUMBER
 N CWL,IMGPTR,L,FILE,MAGREF,TOFILE,QNODE,QSN,ZNODE,SOURCE,FTYPE,MSG,EXT,ALTDEST,ALTTYPE
 S QNODE=$G(^MAGQUEUE(2006.03,QPTR,0)),RESULT="1"
 S IMGPTR=$P(QNODE,U,7),QSN=+$P(QNODE,U,9),ALTDEST=+$P(QNODE,U,10),ALTTYPE=$P(QNODE,U,11)
 S ZNODE=$G(^MAG(2005,IMGPTR,0))
 I ZNODE="" D  Q  ;RESULT ;!!!!
 . S RESULT="-101^"_QPTR_"^MAG Global Node #"_IMGPTR_" not present"
 S FILE=$P(ZNODE,U,2)
 I FILE="" D  Q  ;RESULT ;!!!
 . I +$P($G(^MAG(2005,IMGPTR,1,0)),U,4)>0 D
 . . S MSG="Image group parent"
 . E  S MSG="Does not have an image file specified"
 . S RESULT="-5"_U_QPTR_U_MSG
 S FTYPE=$S(ALTTYPE="":"FULL",1:$$FTYPE^MAGQBPRG(ALTTYPE))
 D @(FTYPE_"(.RESULT,.MAGREF,IMGPTR)")
 Q:$P(RESULT,"^")<0
 S SOURCE=$$WPATH(FILE,MAGREF)_FILE
 S L=+$P(QNODE,"^",10)
 S CWL=$S(L>0:L,1:$$CEL())
 I $P(^MAG(2005.2,CWL,0),"^",6)'="1" D  Q
 . S RESULT="-4"_U_QPTR_U_"Export Network Location is set Off-Line"
 S TOFILE=$$WPATH(FILE,CWL)_FILE
 S RESULT="1^"_IMGPTR_U_SOURCE_U_TOFILE_U_QPTR_U_CWL_U_QSN_U_$P(QNODE,U,11)
 Q
CEL() ; Current Export Pointer
 Q $S($P(^MAG(2006.1,$$PLACE^MAGBAPI(+$G(DUZ(2))),0),"^",7)>1:$P(^(0),"^",7),1:1)
WPATH(FILE,LOC) ; Write path of location (CWP)
 Q $P(^MAG(2005.2,LOC,0),"^",2)_$$DIRHASH^MAGFILEB(FILE,LOC)
FULL(RESULT,MAGREF,MAGIFN) ; copy a full-size image
 S MAGREF=$$LINE(+$P(^MAG(2005,MAGIFN,0),"^",3))
 I 'MAGREF S MAGREF=$$LINE(+$P(^MAG(2005,MAGIFN,0),"^",5))
 S:('MAGREF) RESULT="-3"_U_QPTR_U_"File not on-line"
 Q 
 ;
ABS(RESULT,MAGREF,MAGIFN) ; copy an image abstract
 S MAGREF=$$LINE(+$P(^MAG(2005,MAGIFN,0),"^",4))
 I 'MAGREF S MAGREF=$$LINE(+$P(^MAG(2005,MAGIFN,0),"^",5))
 S:('MAGREF) RESULT="-3"_U_QPTR_U_"Abstract File not on-line"
 Q 
 ;
BIG(RESULT,MAGREF,MAGIFN) ; copy a big image
 S MAGREF=$$LINE(+$P(^MAG(2005,MAGIFN,"FBIG"),"^",1))
 I 'MAGREF S MAGREF=$$LINE(+$P(^MAG(2005,MAGIFN,"FBIG"),"^",2))
 S:('MAGREF) RESULT="-3"_U_QPTR_U_"Big File not on-line"
 Q
LINE(PTR) ;Check if the share is online
 Q:PTR<1 ""
 Q $S($P($G(^MAG(2005.2,PTR,0)),U,6)=1:PTR,1:"")
 ;
