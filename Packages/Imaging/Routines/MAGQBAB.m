MAGQBAB ;WOIFO/PMK/RMP - Create an ABSTRACT from an image file [ 06/20/2001 08:57 ]
 ;;3.0;IMAGING;**1,8,20**;Apr 12, 2006
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
ENTRY(RESULT,QPTR) ;
 ; RESULT=STATUS^IMAGE PTR^FROM FILEPATH^ABSTRACT FILEPATH^QPTR^VWP^QSN
 ; VWP=VISTA WRITE LOCATION,QSN=QUEUE SEQUENCE NUMBER
 N IMGPTR,L,X,MAGXX,FILENAME,FILE,ABSNAME,JBPATH
 N MAGNODE,MAGFILE,MAGFILE2,QSN,QNODE,MAGDRIVE,CWL,PLACE
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S U="^",QNODE=$G(^MAGQUEUE(2006.03,QPTR,0))
 S IMGPTR=$P(QNODE,U,7),QSN=+$P(QNODE,U,9)
 S MAGNODE=$G(^MAG(2005,IMGPTR,0))
 I $P(MAGNODE,U,2)="" D  Q
 . S RESULT="-1^"_QPTR_U_"The Image file entry has no file name for IEN: "_IMGPTR_"^^^^"_QSN
 . Q
 I $P(MAGNODE,U,4)?1N.N D  Q
 . S RESULT="-1^"_QPTR_U_$P($P(MAGNODE,U,2),".")_" has an .ABS file already referenced on the Vista cache ^^^^"_QSN
 . Q
 I $P(MAGNODE,U,3)="" D  Q
 . I $P(MAGNODE,U,5)?1N.N D  Q
 . . N QN,TMP
 . . S QN=$$JBTOHD^MAGBAPI(IMGPTR_U_"FULL",PLACE)
 . . S TMP=IMGPTR_" Full File is not on the VC, a JBTOHD queue will retrieve and the ABSTRACT will be requeued"
 . . S RESULT="-15^"_QPTR_U_TMP_"^^"_QPTR_"^^"_QSN
 . . Q
 . S RESULT="-2^"_QPTR_U_IMGPTR_" File not available on the Vista network^^"_QPTR_"^^"_QSN
 ; get the path and file name for this image
 S MAGXX=IMGPTR D VSTNOCP^MAGFILEB I $P(MAGFILE1,U)="-1" D  Q
 . S RESULT="-3^"_QPTR_U_IMGPTR_" File not on-line^^"_QPTR_"^^"_QSN
 S FILENAME=MAGFILE
 S L=$L(FILENAME) I '$A(FILENAME,L) S FILENAME=$E(FILENAME,1,L-1)
 S L=$L(FILENAME,"\") ; parse the file
 S FILE=$P(FILENAME,"\",L)
 K MAGFILE1
 ;
 S JBPATH=$P(MAGNODE,U,5)
 S JBPATH=$S('JBPATH:"",1:$P(^MAG(2005.2,JBPATH,0),U,2)_$$DIRHASH^MAGFILEB(FILE,JBPATH))
 S CWL=$$CWL^MAGBAPI(PLACE),MAGDRIVE=$P(^MAG(2005.2,CWL,0),U,2)
 S ABSNAME=MAGDRIVE_$$DIRHASH^MAGFILEB(FILE,CWL)
 S ABSNAME=ABSNAME_$P(FILE,".")_".ABS"
 S RESULT="1"_U_IMGPTR_U_FILENAME_U_ABSNAME_U_QPTR_U_CWL_U_QSN_U_JBPATH
 Q
