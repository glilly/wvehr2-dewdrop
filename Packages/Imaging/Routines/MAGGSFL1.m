MAGGSFL1 ;WOIFO/GEK - Image list Filters utilities ; [ 06/20/2001 08:57 ]
 ;;3.0;IMAGING;**8**;Sep 15, 2004
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
SET(MAGRY,MAGGZ) ;RPC [MAG4 FILTER SAVE]
 ; Enter/Edit a filter.
 ;  Use DUZ for field  #22 Ceated By
 ;  MAGGZ is input array in format
 ;  MAGGZ(n)="field number ^ field value"
 ;                       if field number = "IEN".  User is modifying an existing filter.
 ;                          field number = "USER".  The filter is being saved for that user.
 ;
 K MAGRY
 S MAGRY="0^Starting: Saving Filter..."
 N MAGGDA,MAGGFDA,MFDA2,MAGGIEN,MAGGXE,MAGGFLD,MAGGDAT,MAGOK,FLTIEN,FLTUSER,RES,MAGMOD
 S FLTIEN=0,FLTUSER=0,MAGOK=1,MAGMOD=0
 N $ETRAP,$ESTACK S $ETRAP="D ERR^"_$T(+0)
 I ($D(MAGGZ)<10) S MAGRY="0^No input data, Operation CANCELED" Q
 ;
 S Z="" F  S Z=$O(MAGGZ(Z)) Q:Z=""  D  I 'MAGOK S MAGRY=MAGOK Q
 . N $ETRAP,$ESTACK S $ETRAP="D ERR^"_$T(+0)
 . S MAGGFLD=$P(MAGGZ(Z),U,1),MAGGDAT=$P(MAGGZ(Z),U,2,99)
 . I MAGGFLD=""!(MAGGDAT="") S MAGOK="0^Field and Value are Required" Q
 . I MAGGFLD="IEN" S FLTIEN=+MAGGDAT,MAGMOD=1 Q
 . I MAGGFLD="USER" S FLTUSER=+MAGGDAT S MAGGFLD=20
 . I '$$VALID^MAGGSIV1(2005.87,MAGGFLD,.MAGGDAT,.RES) S MAGOK="0^"_RES Q
 . S MAGGFDA(2005.87,"+1,",MAGGFLD)=MAGGDAT
 I 'MAGOK Q
 ; Data is valid.  If modifying existing entry make sure we clear old values.
 L +(^MAG(2005.87,0)):10 E  S MAGRY="0^The File Image List Filters is locked.  Operation canceled" Q
 I MAGMOD D
 . I '$D(^MAG(2005.87,FLTIEN)) S MAGRY="0^Invalid Filter IEN: "_FLTIEN Q
 . N MAGV F I=1,2,3,4,5,6,7,8,9,20,21 S MAGV(I)="@"
 . M MAGV=MAGGFDA(2005.87,"+1,")
 . K MAGGFDA
 . M MAGGFDA(2005.87,FLTIEN_",")=MAGV
 . ; Here we file the modified entry, killing old values and setting new.
 . ;L// L +(^MAG(2005.87,FLTIEN)):5 E  S MAGRY="0^Filter is locked.  Operation canceled" Q
 . D FILE^DIE("","MAGGFDA","MAGGXE")
 . ;L// L -(^MAG(2005.87,FLTIEN))
 . I $D(DIERR) D RTRNERR(.MAGRY) Q
 . S MAGRY=FLTIEN_"^"_$P(^MAG(2005.87,FLTIEN,0),"^",1)
 . Q
 I 'MAGMOD D
 . S MAGGFDA(2005.87,"+1,",22)=DUZ
 . D UPDATE^DIE("","MAGGFDA","MAGGIEN","MAGGXE")
 . I $D(DIERR) D RTRNERR(.MAGRY) Q
 . S MAGRY=MAGGIEN(1)_"^"_$P(^MAG(2005.87,+MAGGIEN(1),0),"^",1)
 . Q
 L -(^MAG(2005.87,0))
 D CLEAN^DILF
 Q
RTRNERR(ETXT) ; There was error from UPDATE^DIE quit with error text
 N MAGRESA
 D MSG^DIALOG("A",.MAGRESA,245,5,"MAGGXE")
 S ETXT="0^"_MAGRESA(1)
 D CLEAN^DILF
 Q
ERR ;
 ;L// L -(^MAG(2005.87,FLTIEN))
 L -(^MAG(2005.87,0))
 N ERR
 S ERR=$$EC^%ZOSV
 S MAGRY="0^Error Filter Add/Edit: "_ERR
 S MAGOK=MAGRY
 D LOGERR^MAGGTERR(ERR)
 D @^%ZOSF("ERRTN")
 D CLEAN^DILF
 Q
