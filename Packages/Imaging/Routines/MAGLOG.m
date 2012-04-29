MAGLOG  ;WOIFO/RED,SRR,MLH - Log image access ; [ 06/20/2001 08:57 ]
        ;;3.0;IMAGING;**17,8,20,59**;Nov 27, 2007;Build 20
        ;;Per VHA Directive 2004-038, this routine should not be modified.
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
        ; CALL WITH:
        ; MAGIMT = TYPE OF ACCESS
        ; DUZ = USER NO.
        ; MAGO = IMAGE SUBSCRIPT NO.
        ; MAGPACK = USER INTERFACE PACKAGE
        ; MAGDFN = PATIENT NO.
        ; MAGCT = TOTAL IMAGE COUNT
        ; MAGAD = ADDITIONAL DATA
ENTRY(MAGIMT,MAGDUZ,MAGO,MAGPACK,MAGDFN,MAGCT,MAGAD)    ;
        I '$D(MAGSYS) S MAGSYS=^%ZOSF("VOL")
        N MAGC,MSYS
        S MSYS=$$UP^XLFSTR(MAGSYS)
        I (MSYS["UNKNOWN"),($D(MAGJOB("WRKSIEN"))) S MSYS=$P(^MAG(2006.81,MAGJOB("WRKSIEN"),0),"^",1)
        L +^MAG(2006.95,0):10 E  Q  ;entries were being overwritten.
        S MAGC=$P(^MAG(2006.95,0),"^",3)+1
        S $P(^MAG(2006.95,0),"^",3,4)=MAGC_"^"_MAGC
        L -^MAG(2006.95,0)
        D NOW^%DTC ;gives us % (now)
        ;   FLD #'s            .01         1                2          3          4             5         6       7          8               9
        S ^MAG(2006.95,MAGC,0)=MAGC_"^"_$G(MAGIMT)_"^"_$G(MAGDUZ)_"^"_MAGO_"^"_MAGPACK_"^"_MSYS_"^"_%_"^"_MAGDFN_"^"_MAGCT_"^"_+$G(MAGJOB("SESSION"))
        I $D(MAGAD) S ^MAG(2006.95,MAGC,100)=MAGAD
        S ^MAG(2006.95,"B",MAGC,MAGC)=""
        D ACCESS(MAGO) ; This should be here.  Can now search 2006.95 from "Last Access Date" to "Capture Date" to
        ; get all Actions logged. We Don't have to search entire Image File.
        I $G(MAGJOB("SESSION")) S ^MAG(2006.95,"AS",+$G(MAGJOB("SESSION")),MAGC)=""
        Q
ACCESS(MAGO)    ; Update Field "Last Access Date" in Image File.
        Q:'$G(MAGO)
        I '$D(^MAG(2005,MAGO,0)) D  Q
        . I $D(^MAG(2005.1,MAGO,0)) S $P(^MAG(2005.1,MAGO,0),"^",9)=$$NOW^XLFDT
        . Q
        S $P(^MAG(2005,MAGO,0),"^",9)=$$NOW^XLFDT
        Q
