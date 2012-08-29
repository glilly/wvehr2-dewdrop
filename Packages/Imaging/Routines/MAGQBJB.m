MAGQBJB ;WOIFO/PMK/RMP - Get an image file to copy to the JukeBoX [ 06/20/2001 08:57 ]
 ;;3.0;IMAGING;**8,20**;Apr 12, 2006
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
 ; RESULT=STATUS^IMAGE PTR^FROM FILE^TO FILE^VOLUME NAME^
 ;   JUKEBOX DEVICE^QUEUE PTR^JUKEBOX-NETWORK LOC PTR^QSN
 ; QSN=QUEUE SEQUENCE NUMBER
 N CWP,IMGPTR,L,JBDEVICE,FILENAME,FILE,X,JBPTR,SUBDIR
 N MAGFILE,MAGXX,MAGSTORE,MAGFILE2,PERCENT,SIZERTN,MAGDEV,SRCE
 N TOFILE,TOTAL,QNODE,QSN,ZNODE,BNODE,FULL,ABS,BIG,MSG,PLACE,AGG
 S U="^",QNODE=$G(^MAGQUEUE(2006.03,QPTR,0)),(ZNODE,FULL,ABS,BIG,JBPTR,AGG)=""
 S IMGPTR=$P(QNODE,U,7),QSN=+$P(QNODE,U,9),PLACE=$P(QNODE,U,12)
 I $D(^MAG(2005,IMGPTR,0)) D
 . S ZNODE=$G(^MAG(2005,IMGPTR,0))
 . S BNODE=$G(^MAG(2005,IMGPTR,"FBIG"))
 . Q
 E  I $D(^MAG(2005.1,IMGPTR,0)) D
 . S ZNODE=$G(^MAG(2005.1,IMGPTR,0))
 . S BNODE=$G(^MAG(2005.1,IMGPTR,"FBIG"))
 . Q
 I ZNODE="" D  Q  ;RESULT ;!!!!
 . S RESULT="-101^"_QPTR_"^MAG Global Node #"_IMGPTR_" not present"
 S FILE=$P(ZNODE,U,2)
 I FILE="" D  Q  ;RESULT ;!!!
 . I +$P($G(^MAG(2005,IMGPTR,1,0)),U,4)>0 D
 . . S MSG="Image group parent"
 . E  S MSG="Does not have an image file specified"
 . S RESULT="-5"_U_QPTR_U_MSG
 ;I $P(ZNODE,U,5),$P(BNODE,U,2) D  Q
 ;. S RESULT="-11^"_QPTR_"^Source file is already archived" Q
 ; Establish the current Jukebox location
 S CWP=$$CWP^MAGBAPI($$PLACE^MAGBAPI(+$G(DUZ(2))))
 I $P(^MAG(2005.2,CWP,0),"^",6)'="1" D  Q
 . S RESULT="-4"_U_QPTR_U_"Jukebox Network Location is set Off-Line"
 S JBPTR=$$JBPTR^MAGBAPI($$PLACE^MAGBAPI(+$G(DUZ(2))))
 S JBDEVICE=$$JBDEV(JBPTR)
 ; If the current Jukebox write location differs from the FULL/ABstract Worm or the BIG Worm then aggregate
 S AGG=$S($P(ZNODE,U,5)&($P(ZNODE,U,5)'=CWP):1,$P(BNODE,U,2)&($P(BNODE,U,2)'=CWP):1,1:"")
 ; Check for FULL
 S SRCE=$S($$SLINE(+$P(ZNODE,U,3)):$P(ZNODE,U,3),1:"")
 I 'SRCE,AGG S SRCE=$S($$SLINE(+$P(ZNODE,U,5)):$P(ZNODE,U,5),1:"")
 I SRCE D 
 . S MAGDEV=$P(^MAG(2005.2,SRCE,0),U,2),FULL=MAGDEV_$$DIRHASH^MAGFILEB(FILE,SRCE)_FILE Q 
 ; Check for Abstract
 S SRCE=$S($$SLINE(+$P(ZNODE,U,4)):$P(ZNODE,U,4),1:"")
 I 'SRCE,AGG S SRCE=$S($$SLINE(+$P(ZNODE,U,5)):$P(ZNODE,U,5),1:"")
 I SRCE D 
 . S MAGDEV=$P(^MAG(2005.2,SRCE,0),U,2),ABS=MAGDEV_$$DIRHASH^MAGFILEB(FILE,SRCE)_$P(FILE,".")_".ABS" Q 
 ; Check for Big
 S SRCE=$S($$SLINE(+$P(BNODE,U,1)):$P(BNODE,U,1),1:"")
 I 'SRCE,AGG S SRCE=$S($$SLINE(+$P(BNODE,U,2)):$P(BNODE,U,2),1:"")
 I SRCE D 
 . S MAGDEV=$P(^MAG(2005.2,SRCE,0),U,2),BIG=MAGDEV_$$DIRHASH^MAGFILEB(FILE,SRCE)_$P(FILE,".")_".BIG" Q 
 I FULL="",BIG="",ABS="" D  Q
 . S MSG=$S(('$P(BNODE,U))&('$P(ZNODE,U,4))&('$P(ZNODE,U,4)):"No Vista Cache Source",1:"")
 . S MSG=$S('MSG:"There are no network location references for this image: "_FILE,1:MSG)
 . S RESULT="-11^"_QPTR_"^"_MSG
 . Q
 K MAGFILE1
 S TOFILE=$$WPATH(FILE,CWP)_FILE
 S RESULT="1^"_IMGPTR_U_FULL_U_TOFILE_U
 S RESULT=RESULT_$$VOLNM(JBPTR)_U_JBDEVICE_U_QPTR_U_CWP_U_QSN_U_ABS_U_BIG
 Q  ;RESULT ;!!!
JBLPT(JBPTR) ; Jukebox Ptr to Network Location File
 Q $P(^MAGQUEUE(2006.032,JBPTR,0),U,3)
WPATH(FILE,CWP) ; Write path of Current Write Platter (CWP)
 Q $P(^MAG(2005.2,CWP,0),"^",2)_$$DIRHASH^MAGFILEB(FILE,CWP)
VOLNM(JBPTR) ; Volume name of JBDEVICE
 Q $P($G(^MAGQUEUE(2006.032,JBPTR,0)),"^",9)
JBDEV(JBPTR) ; Jukebox Device (drive spec)
 Q $P($G(^MAGQUEUE(2006.032,JBPTR,0)),"^",2)
JBPLT(PTR) ; FIND 2005.2 REFERENCE
 N I,RESULT
 S (I,RESULT)=0
 F  S I=$O(^MAGQUEUE(2006.032,I)) Q:'I  D  Q:RESULT
 . I $P(^MAGQUEUE(2006.032,I,0),U,3)=PTR S RESULT=I
 . Q
 Q RESULT
SLINE(PTR) ;Check if the share is online
 Q:PTR<1 ""
 Q $S($P($G(^MAG(2005.2,PTR,0)),U,6)=1:1,1:"")
