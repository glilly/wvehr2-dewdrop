MAGDIR9B ;WOIFO/PMK - Read a DICOM image file ; 12 Oct 2005  8:21 AM
 ;;3.0;IMAGING;**11,51,50**;26-May-2006
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
 ; M2MB server
 ;
 ; Create an image entry in ^MAG(2005)
 ;
IMAGE() ; entry point from ^MAGDIR81 to create an image entry in ^MAG(2005)
 N IMAGE ;---- image array for ^MAGGTIA
 N IMAGECNT ;- counter of image in the group
 N IMAGEPTR ;- value returned by ^MAGGTIA
 ;
 ; check that the group has right object type and is for the same person
 I $P($G(^MAG(2005,MAGGP,0)),"^",6)'=11 D  Q -101 ; fatal error
 . D OBJECT^MAGDIRVE($T(+0),MAGGP)
 . Q
 ;
 ; check that the group patient DFN matches the image patient DFN
 I $P(^MAG(2005,MAGGP,0),"^",7)'=DFN D  Q -102 ; fatal error
 . D MISMATCH^MAGDIRVE($T(+0),DFN,MAGGP)
 . Q
 ;
 ; get the next file number and create the entry for this image
 ;
 S IMAGECNT=$P($G(^MAG(2005,MAGGP,1,0)),"^",4)+1 ; next image # in group
 ;
 K IMAGE
 S IMAGE(1)=".01^"_PNAMEVAH_"  "_DCMPID_"  "_PROCDESC ; used in ^MAGDIR8
 S IMAGE(2)="5^"_DFN
 I $D(FILEDATA("SHORT DESCRIPTION")) D  ; set in ^MAGDIR7F
 . S IMAGE(3)="10^"_FILEDATA("SHORT DESCRIPTION")
 . Q
 E  S IMAGE(3)="10^"_PROCDESC_" (#"_IMAGECNT_")" ; used in ^MAGDIR81
 S IMAGE(4)="14^"_MAGGP
 S IMAGE(5)="15^"_DATETIME
 S IMAGE(6)="60^"_IMAGEUID
 S IMAGE(7)=FILEDATA("EXTENSION") ; specify the image file extension
 I $D(FILEDATA("ABSTRACT")) S IMAGE(8)=FILEDATA("ABSTRACT")
 S IMAGE(9)="WRITE^PACS" ; select the PACS image write location
 S IMAGE(10)="3^"_FILEDATA("OBJECT TYPE")
 S IMAGE(11)="6^"_FILEDATA("MODALITY")
 S IMAGE(12)="16^"_FILEDATA("PARENT FILE")
 S IMAGE(13)="17^"_FILEDATA("PARENT IEN")
 I $D(FILEDATA("PARENT FILE PTR")) S IMAGE(14)="18^"_FILEDATA("PARENT FILE PTR")
 I $D(FILEDATA("RAD REPORT")) S IMAGE(15)="61^"_FILEDATA("RAD REPORT")
 I $D(FILEDATA("RAD PROC PTR")) S IMAGE(16)="62^"_FILEDATA("RAD PROC PTR")
 I MODPARMS["/" S IMAGE(17)="BIG^1" ; big file will be output
 S IMAGE(18)="DICOMSN^"_SERINUMB ; series number
 S IMAGE(19)="DICOMIN^"_IMAGNUMB ; image number
 S IMAGE(20)=".05^"_INSTLOC
 S IMAGE(21)="40^"_FILEDATA("PACKAGE")
 S IMAGE(22)="41^"_$O(^MAG(2005.82,"B","CLIN",""))
 S IMAGE(23)="42^"_FILEDATA("TYPE")
 S IMAGE(24)="43^"_FILEDATA("PROC/EVENT")
 S IMAGE(25)="44^"_FILEDATA("SPEC/SUBSPEC")
 S IMAGE(26)="107^"_FILEDATA("ACQUISITION DEVICE")
 S IMAGE(27)="251^"_FILEDATA("SOP CLASS POINTER")
 S IMAGE(28)="253^"_SERIEUID
 D ADD^MAGGTIA(.RETURN,.IMAGE)
 ;
 S IMAGEPTR=+RETURN
 I 'IMAGEPTR D  Q -103 ; fatal error
 . K MSG
 . S MSG(1)="IMAGE FILE CREATION ERROR:"
 . S MSG(2)=$P(RETURN,"^",2,999)
 . D BADERROR^MAGDIRVE($T(+0),"DICOM IMAGE PROCESSING ERROR",.MSG)
 . Q
 ;
 I IMAGEPTR<LASTIMG D  Q -104 ; fatal last image pointer error
 . D IMAGEPTR^MAGDIRVE($T(+0),IMAGEPTR,LASTIMG)
 . Q
 ;
 S $P(RETURN,"^",4)=$$CHKPATH() ; hierarchal file patch check
 ;
 Q 0
 ;
CHKPATH() ; determine if the path is hierarchal (true) or not (false)
 N D0,PATH
 S D0="",PATH=$P(RETURN,"^",2)
 I $D(^MAG(2005.2,"AC")) S D0=$O(^MAG(2005.2,"AC",PATH,""))
 E  D
 . N PLACE
 . S PLACE=""
 . F  S PLACE=$O(^MAG(2005.2,"E",PLACE)) Q:PLACE=""  D  Q:D0
 . . S D0=$O(^MAG(2005.2,"E",PLACE,PATH,""))
 . . Q
 . Q
 Q 'D0 ; network location file
 ;
