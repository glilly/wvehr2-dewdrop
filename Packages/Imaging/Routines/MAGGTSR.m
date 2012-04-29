MAGGTSR ;WOIFO/GEK - SURGERY CASE LIST ; [ 06/20/2001 08:57 ]
        ;;3.0;IMAGING;**8,59**;Nov 27, 2007;Build 20
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
        Q
GET(MAGRY,MAGDFN,DATA)  ;RPC [MAGGSUR GET]
        ; Call to get list of Patient Surgery procedures
        ;  MAGDFN       =       Patient DFN
        ;  DATA         =       For Future Use.
        N $ETRAP,$ESTACK S $ETRAP="D ERRA^MAGGTERR"
        N Y,NAME,AI,CASES,SDAT,DTX,SRFDA
        K ^TMP($J,"MAGGTSR")
        S NAME=$P($G(^DPT(MAGDFN,0)),U) I NAME="" S MAGRY(0)="0^INVALID Patient ID" Q
        ; This is the Old Call we have always made.  Doesn't have Non-OR
        D GET^SROGTSR(.MAGRY,MAGDFN)
        I 'MAGRY(0) S MAGRY(0)=MAGRY(0)_" for "_NAME G C1
        ; Image count is for future use by Display
        S MAGRY(1)="#^Date^Case description^Case #^Images"
        S I=1 F  S I=$O(MAGRY(I)) Q:'I  D
        . S DTX=$$FMTE^XLFDT($P(MAGRY(I),U,5),"5MZ")
        . S ^TMP($J,"MAGGTSR",$P(MAGRY(I),U,5),$P(MAGRY(I),U,4))=DTX_"^"_$P(MAGRY(I),U,3)_"^"_$P(MAGRY(I),"^",4)_"^"_$P(MAGRY(I),U,6)_U_"|"_$P(MAGRY(I),U,4,5)_U
        ;
        ;This is the New Call, which has Non-OR, but doesn't have (Scheduled) so we merge the two calls.
C1      D LIST^SROESTV(.CASES,MAGDFN)
        I '$D(@CASES)  G E1
        S MAGRY(0)="1^"
        S MAGRY(1)="#^Date^Case description^Case #^Images"
        S I=0 F  S I=$O(@CASES@(I)) Q:'I  D
        . S SDAT=@CASES@(I)
        . ; SDAT = SURIEN  ^ SURDESC  ^ SURDT ^ DFN;NAME ^
        . I $D(^TMP($J,"MAGGTSR",$P(SDAT,U,3),$P(SDAT,U,1))) Q
        . S ^TMP($J,"MAGGTSR",$P(SDAT,U,3),$P(SDAT,U,1))=$$FMTE^XLFDT($P(SDAT,U,3),"5MZ")_U_$P(SDAT,U,2)_U_$P(SDAT,U,1)_U_$$IMGCT($P(SDAT,U,1))_U_"|"_$P(SDAT,U,1)_U_$P(SDAT,U,3)_U
        . Q
        ;
        ; Now Returned the Merged List of the results of Old Call, with Results of New Call.
E1      ;
        I '$D(^TMP($J,"MAGGTSR")) S MAGRY(0)="0^No Cases for "_$G(NAME) Q
        S I=1,DTX=0,SRFDA=0
        F  S DTX=$O(^TMP($J,"MAGGTSR",DTX)) Q:'DTX  D
        . S SRFDA="" F  S SRFDA=$O(^TMP($J,"MAGGTSR",DTX,SRFDA),-1) Q:'SRFDA  D
        . . S I=I+1,MAGRY(I)=I-1_"^"_^TMP($J,"MAGGTSR",DTX,SRFDA)
        . . Q
        . Q
        S $P(MAGRY(0),"^",1)=I-1
        Q
IMGCT(SRFIEN)   ;
        ;  Count of images for this Surgery Case
        ;  If more than one group (or image)
        ;  then return "Group count : total images"  i.e.   "3:134"
        ;  else return count of Images i.e. "4"
        ;
        N CT,GCT,ICT,J
        S J=0,CT=0,GCT=0
        F  S J=$O(^SRF(SRFIEN,2005,"B",J)) Q:'J  D
        . S ICT=+$P($G(^MAG(2005,J,1,0)),U,4)
        . S ICT=$S(ICT:ICT,1:1) ;If no group images, set count =1 (single image)
        . S GCT=GCT+1
        . S CT=CT+ICT
        I (GCT>1) Q GCT_":"_CT
        Q CT
        ;
IMAGE(MAGRY,DATA)       ;
        ;  Called with the IEN of the Surgery package ^SRF(170,x
        ;  We'll return a list of images.
        N SRFIEN,MAGIEN
        S SRFIEN=+DATA
        I '$D(^SRF(SRFIEN)) S MAGRY(0)="0^INVALID Surgery File entry" Q
        I '$O(^SRF(SRFIEN,2005,0)) S MAGRY(0)="0^No Images for this Operation." Q
        D GETLIST
        Q
GETLIST ; called from other points in this routine, when SRFIEN is defined
        ; and returns a list in MAGRY(1..n)
        ; We'll make a tmp list of just the image IEN's
        ;  splitting groups into individual image entries.
        K ^TMP($J,"MAGGX")
        S I=0,CT=1 F  S I=$O(^SRF(SRFIEN,2005,I)) Q:'I  D
        . S MAGIEN=$P(^SRF(SRFIEN,2005,I,0),U,1)
        . Q:'$D(^MAG(2005,MAGIEN,0))
        . I '$O(^MAG(2005,MAGIEN,1,0)) S ^TMP($J,"MAGGX",MAGIEN)=""
        . E  S Z=0 F  S Z=$O(^MAG(2005,MAGIEN,1,Z)) Q:Z=""  S ^TMP($J,"MAGGX",$P(^MAG(2005,MAGIEN,1,Z,0),U,1))=""
        I '$D(^TMP($J,"MAGGX")) S MAGRY(0)="0^Surgery File Entry "_SRFIEN_": has INVALID Image Pointers" Q
        S Z="",CT=0
        S MAGQUIET=1
        F  S Z=$O(^TMP($J,"MAGGX",Z)) Q:Z=""  D
        . S CT=CT+1,MAGXX=Z D INFO^MAGGTII
        . S MAGRY(CT)="B2^"_MAGFILE
        K MAGQUIET
        S MAGRY(0)=CT_"^Images for the selected Surgery File entry"
        K ^TMP("MAGGX")
        Q
