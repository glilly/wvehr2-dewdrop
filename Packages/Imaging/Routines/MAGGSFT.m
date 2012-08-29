MAGGSFT ;WOIFO/GEK - Utilities 
 ;;3.0;IMAGING;**7,8**;Sep 15, 2004
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
 Q
LIST(MAGRY) ;RPC [MAG4 GET SUPPORTED EXTENSIONS]
 ;to return a list of supported image file extensions
 N I,Y,CT,MAGN0
 ;NAME [1F] ^ DESCRIPTION [2F] ^VIEWER [3S] ^ 
 ;       Bitmap for Abstract [4F] ^Abstract Created [5S] ^ Default Object Type [6P]
 ;
 ;  2nd "|" piece is system info = Ien of 2005.021 ^ NAME ^ Default Object Type [6P]
 S MAGRY(0)="0^Compiling list of supported extensions..."
 S MAGRY(1)="Ext^Description^Imaging Viewer^Abs Bitmap^Abs Created"
 S CT=1
 S I=0 F  S I=$O(^MAG(2005.021,I)) Q:'I  S MAGN0=^(I,0) D
 . S CT=CT+1
 . S MAGRY(CT)=$P(MAGN0,U,1,5)_"|"_I_U_$P(MAGN0,U)_U_$P(MAGN0,U,6)
 S MAGRY(0)="1^Okay"
 Q
EXTSUPP(MAGRY,MAGEXT) ;
 ;  ? ? AM I MISSING CODE HERE.  DID WE LOSE SOME LIKE BEFORE.
 Q
INFO(MAGRY,MAGEXT) ;RPC [MAG4 GET FILE FORMAT INFO]
 ;IMAGE FILE TYPES FILE ^MAG(2005.021
 ;NAME [1F] ^ DESCRIPTION [2F] ^VIEWER [3S] ^ 
 ;       Bitmap for Abstract [4F] ^Abstract Created [5S] ^ Default Object Type [6P]
 ;
 ;"Ext^Description^Imaging Viewer^Abs Bitmap^Abs Created"
 ;                            "|" IEN ^ NAME ^ Default Object Type [6P] 
 N MAGN0,MAGIEN
 S MAGRY(0)="1^OK"
 S MAGEXT=$$UP^XLFSTR(MAGEXT)
 S MAGIEN=$O(^MAG(2005.021,"B",MAGEXT,""))
 I 'MAGIEN S MAGRY(0)="0^Unsupported File Extension : "_MAGEXT Q
 S MAGN0=^MAG(2005.021,MAGIEN,0)
 S MAGRY(1)=$P(MAGN0,U,1,5)_"|"_MAGIEN_U_$P(MAGN0,U)_U_$P(MAGN0,U,6)
 Q
ABS4IMAG(MAGIEN) ; True, False  If the Image (MAGIEN) has an abstract
 ;  We base this on the Extension of image, in the IMAGE FILE TYPES file.
 N X,FTIEN
 S X=$P($P($G(^MAG(2005,MAGIEN,0)),"^",2),".",2)
 I '$L(X) Q 0
 S FTIEN=$O(^MAG(2005.021,"B",X,""))
 I 'FTIEN Q 0
 Q $P(^MAG(2005.021,FTIEN,0),"^",5)
