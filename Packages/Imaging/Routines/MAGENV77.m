MAGENV77 ;WOIFO/MJK; P77 (Reports) Environment Check ; 06 Jun 2006  7:50 AM
 ;;3.0;IMAGING;**77**;07-December-2006;;Build 982
 ;; Per VHA Directive 2004-038, this routine should not be modified.
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
 ;  Check for the existence of an 'AD' cross reference in the 2005 or 2005.1 file.
 ;  If one exists and it was not created by the VistA Imaging Team,  alert the installer
 ;  and terminate the install.
 ;
 ;  Also check for any cross reference on Field 7 - Date/Time Image Saved.  There should be
 ;  no cross references except the 'AD' cross reference created by this Patch.
 ;
 NEW %,%X,%Y,CTR,D,D0,D1,D2,DA,DG,DIC,DICR,DIK,DIW,IMGFILE,MAILMSG,MESSAGE,SS4,SS5,SS6
 NEW X,XMDUZ,XMERR,XMSUBJ,XMTO,XMZ,Y
 ;
 S CTR=0
 ;
 F IMGFILE=2005,2005.1 U IO(0) W !! D 1,2,3,4
 I $G(XPDQUIT) D XPDQUIT
 Q
1 ;  I started out with the Traditional Type cross reference for the 'AD' xref.  Skip Ormsby suggested that I use 'AD' as the
 ;  xref but use the New Index type.  This code removes the Traditional xref from the DD at those alpha sites that installed
 ;  the earlier p77 't' versions.
 ;
 S SS4=0
 F  S SS4=$O(^DD(IMGFILE,7,1,SS4)) Q:'SS4  D
 . I $P(^DD(IMGFILE,7,1,SS4,0),U,2)="AD",($G(^DD(IMGFILE,7,1,SS4,"%D",1,0))["VistA Imaging Team") D
 . . S DA=SS4,DA(1)=7,DA(2)=IMGFILE,DIK="^DD("_DA(2)_","_DA(1)_",1," D ^DIK
 . . K ^MAG(IMGFILE,"AD")
 . . Q
 . Q
 Q
2 ;  If an 'AD' xref is not defined, there should not be an 'AD' node.
 ;
 I '$D(^DD(IMGFILE,0,"IX","AD"))&('$D(^DD("IX","BB",IMGFILE,"AD"))) D
 . I '$D(^MAG(IMGFILE,"AD")) Q
 . S MESSAGE="File: "_$P(^DIC(IMGFILE,0),U)_" (#"_IMGFILE_") dictionary does not have an 'AD' cross reference defined for any field yet an 'AD' global node exists in global ^MAG("_IMGFILE_","
 . D ABORT(MESSAGE)
 . Q
 Q
3 ;  There should not be a Traditional 'AD' xref.
 ;
 I $D(^DD(IMGFILE,0,"IX","AD")) D
 . S SS5=""
 . F  S SS5=$O(^DD(IMGFILE,0,"IX","AD",SS5)) Q:'SS5  S SS6="" D
 . . F  S SS6=$O(^DD(IMGFILE,0,"IX","AD",SS5,SS6)) Q:'SS6  D
 . . . S MESSAGE="File: "_$P(^DIC(IMGFILE,0),U)_" (#"_IMGFILE_") Field: "_$P(^DD(IMGFILE,SS6,0),U)_" (#"_SS6_") - has an illegal 'AD' cross reference"
 . . . D ABORT(MESSAGE)
 . . . Q
 . . Q
 . Q
 Q
4 ;  Check for 'AD' New Type Index Cross Reference.
 ;  It must have been created by P77 for field 7 (Date/Time Image Saved.)
 ;
 I $D(^DD("IX","BB",IMGFILE,"AD")) D
 . S SS5=""
 . F  S SS5=$O(^DD("IX","BB",IMGFILE,"AD",SS5)) Q:SS5=""  D
 . . I $P(^DD("IX",SS5,0),U,3)["Created by Patch 77" Q
 . . S MESSAGE="File: "_$P(^DIC(IMGFILE,0),U)_" - has an illegal 'AD' 'New Index' type cross reference"
 . . D ABORT(MESSAGE)
 . . Q
 . Q
 Q
ABORT(MESSAGE) ;  Build a mail message.  Set 'Do not install' flag.
 ;
 S XPDQUIT=2
 I CTR=0 D
 . D GETENV^%ZOSV
 . S CTR=CTR+1,MAILMSG(CTR)=$P(Y,U,3)_"     "_$P(Y,U)
 . S CTR=CTR+1,MAILMSG(CTR)=""
 . Q
 S CTR=CTR+1
 S MAILMSG(CTR)=MESSAGE
 D BMES^XPDUTL(MESSAGE)
 Q
XPDQUIT ;
 ;
 U IO(0) W !!!
 S MESSAGE="Please resolve these issues before installing Patch 77"
 D ABORT(MESSAGE)
 U IO(0) W !!!
 S XMDUZ=$G(DUZ) S:'XMDUZ XMDUZ=.5
 S XMSUBJ="Patch 77 Cross Reference Issues"
 S XMTO("G.MAG SERVER")=""
 D SENDMSG^XMXAPI(XMDUZ,XMSUBJ,"MAILMSG",.XMTO,,.XMZ,)
 I $G(XMERR) M XMERR=^TMP("XMERR",$J) S $EC=",U13-Cannot send MailMan message,"
 Q
 ;
