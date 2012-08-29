MAGGNTI ;WOIFO/GEK - Imaging interface to TIU RPC Calls etc. ; 04 Apr 2002  2:37 PM
        ;;3.0;IMAGING;**10,8,59**;Nov 27, 2007;Build 20
        ;;Per VHA Directive 2004-038, this routine should not be modified.
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
        Q
FILE(MAGRY,MAGDA,TIUDA) ;RPC [MAG3 TIU IMAGE]
        ; Call to file TIU and Imaging Pointers
        ; TIU API to add image to TIU
        N X
        I $P(^TIU(8925,TIUDA,0),U,2)'=$P(^MAG(2005,MAGDA,0),U,7) S MAGRY="0^Patient Mismatch." Q
        D PUTIMAGE^TIUSRVPL(.MAGRY,TIUDA,MAGDA) ;
        I 'MAGRY Q
        ; Now SET the Parent fields in the Image File
        S $P(^MAG(2005,MAGDA,2),U,6,8)=8925_U_TIUDA_U_+MAGRY
        ; DONE.
        S MAGRY="1^Image pointer filed successfully"
        ; Now we save the PARENT ASSOCIATION Date/Time 
        D LINKDT^MAGGTU6(.X,MAGDA)
        Q
DATA(MAGRY,TIUDA)       ;RPC [MAG3 TIU DATA FROM DA]
        ; Call to get TIU data from the TIUDA
        ; Return =     TIUDA^Document Type ^Document Date^DFN^Author DUZ
        ;
        S MAGRY=TIUDA_U_$$GET1^DIQ(8925,TIUDA,".01","E")_U_$$GET1^DIQ(8925,TIUDA,"1201","I")_U_$$GET1^DIQ(8925,TIUDA,".02","I")_U_$$GET1^DIQ(8925,TIUDA,"1202","I")_U
        Q
IMAGES(MAGRY,TIUDA)     ;RPC [MAG3 CPRS TIU NOTE]
        ; Call to get all images for a given TIU DA
        ; We first get all Image IEN's breaking groups into separate images
        ; Then get Image Info for each one.
        ; MAGRY    -     Return array of Image Data entries
        ; MAGRY(0)    is   1 ^ message  if successful
        ;                  0 ^ Error message if error;
        ; TIUDA  is IEN in ^TIU(8925
        ;
        ; Call TIU API to get list of Image IEN's
        N MAGARR,CT,TCT,I,J,Z K ^TMP($J,"MAGGX")
        N DA,MAGQI,MAGNCHK,MAGXX,MAGRSLT
        N TIUDFN,MAGQUIT ; MAGQI 8/22/01
        ; MAGFILE is returned from MAGGTII
        ; 
        S MAGQUIT=0 ; MAGQI 8/22/01
        S TIUDFN=$P($G(^TIU(8925,TIUDA,0)),U,2) ;MAGQI 8/22/01
        I 'TIUDFN S MAGRY(0)="0^Invalid Patient DFN for Note ID: '"_TIUDA_"'"
        D GETILST^TIUSRVPL(.MAGARR,TIUDA)
        S CT=0,TCT=0
        ; Now get all images for all groups and single images.
        S I="" F  S I=$O(MAGARR(I)) Q:'I  S DA=MAGARR(I) D  ;Q:MAGQUIT
        . S Z=$$ISDELIMG(DA) I Z S TCT=TCT+1,MAGRY(TCT)="B2^"_Z Q
        . ; Check that array of images from selected TIUDA have 
        . ;     same patient's and valid backward pointers
        . I $P($G(^MAG(2005,DA,0)),U,7)'=TIUDFN S MAGQUIT=1,MAGNCHK="Patient Mismatch. TIU: "_TIUDA
        . I $P($G(^MAG(2005,DA,2)),U,7)'=TIUDA S MAGQUIT=1,MAGNCHK="Pointer Mismatch. TIU: "_TIUDA
        . I MAGQUIT S MAGXX=DA D INFO^MAGGTII D  Q
        . . ; remove the Abstract and Image File Names  ; 2/14/03 p8t14  remove c:\program files.  with   .\bmp\
        . . S $P(MAGFILE,U,2,3)="-1~Questionable Data Integrity^.\bmp\imageQA.bmp"
        . . ;this stops Delphi App from changing Abstract BMP to OFFLINE IMAGE
        . . S $P(MAGFILE,U,6)=$S(($P(MAGFILE,U,6)'=11):"99",1:11)
        . . S $P(MAGFILE,U,10)="M"
        . . ;Send the error message
        . . S $P(MAGFILE,U,17)=MAGNCHK
        . . S TCT=TCT+1,MAGRY(TCT)="B2^"_MAGFILE
        . ;
        . I $O(^MAG(2005,DA,1,0)) D  Q
        . . ; Integrity check, if group is questionable, add it's ien to list, not it's 
        . . ;   children.  Later when list is looped through, it's INFO^MAGGTII will be in 
        . . ;   list.  Have to do this to allow other images in list from TIU to be processed.
        . . D CHK^MAGGSQI(.MAGQI,DA) I 'MAGQI(0) S CT=CT+1,^TMP($J,"MAGGX",CT)=DA Q
        . . S J=0 ; the following line needs to take only the first piece of the node - PMK 4/4/02
        . . F  S J=$O(^MAG(2005,DA,1,J)) Q:'J  S CT=CT+1,^TMP($J,"MAGGX",CT)=$P(^(J,0),"^")
        . S CT=CT+1
        . S ^TMP($J,"MAGGX",CT)=DA
        ; Now get image info for each image
        ;
        S Z=""
        S MAGQUIET=1
        F  S Z=$O(^TMP($J,"MAGGX",Z)) Q:Z=""  D
        . S TCT=TCT+1,MAGXX=^TMP($J,"MAGGX",Z)
        . ;GEK 8/24/00 Stopping the Invalid Image IEN's and Deleted Images
        . I '$D(^MAG(2005,MAGXX)) D  Q
        . . D INVALID^MAGGTIG(MAGXX,.MAGRSLT) S MAGRY(CT)=MAGRSLT
        . D INFO^MAGGTII
        . S MAGRY(TCT)="B2^"_MAGFILE
        K MAGQUIET
        S MAGRY(0)=TCT_"^"_TCT_" Images for the selected TIU NOTE"
        ; Put the Image IEN of the last image into the group IEN field.
        Q:'TCT
        S $P(MAGRY(0),U,3)=TIUDA
        K MAGRSLT
        D DATA(.MAGRSLT,TIUDA)
        S $P(MAGRY(0),U,4)=$$GET1^DIQ(8925,TIUDA,".02","E")_"  "_$P(MAGRSLT,U,2)_"  "_$$FMTE^XLFDT($P(MAGRSLT,U,3),"8")
        ;
        S $P(MAGRY(0),U,5)=$S($P($G(MAGFILE),U):$P(MAGFILE,U),$G(MAGXX):MAGXX,1:0)
        Q
        ;. S Z=ISDELIMG(DA) I Z S TCT=TCT+1,MAGRY(TCT)="B2^"_$P(Z,U,2) Q
ISDELIMG(MAGIEN)        ; Is this a deleted Image.
        N MAGDEL,MAGIMG,MAGR,Z,MAGT
        S MAGDEL=$D(^MAG(2005.1,MAGIEN))
        S MAGIMG=$D(^MAG(2005,MAGIEN))
        I MAGIMG,'MAGDEL S MAGR="0^Valid Image"
        I 'MAGIMG,MAGDEL S MAGR="1^Deleted Image",MAGT=66
        I 'MAGIMG,'MAGDEL S MAGR="1^Invalid Image pointer",MAGT=67
        I MAGIMG,MAGDEL S MAGR="0^Image IEN exists, and is Deleted !"
        I 'MAGR Q MAGR
        S MAGR=$P(MAGR,U,2)
        S $P(Z,U,1,4)=MAGIEN_"^-1~"_MAGR_"^-1~"_MAGR_"^"_MAGR
        S $P(Z,U,6)=MAGT
        ;this stops Delphi App from changing Abstract BMP to OFFLINE IMAGE
        S $P(Z,U,10)="M"
        ;Send the error message
        S $P(Z,U,17)=$P(MAGR,U,2)
        Q Z
ISDOCCL(MAGRY,IEN,TIUFILE,CLASS)        ;RPC [MAGG IS DOC CLASS]
        ;Checks to see if IEN of TIU Files 8925 or 8925.1 is of a certain Doc Class 
        ;MAGRY  = Return String  
        ;                 for Success   "1^message"
        ;                 for Failure   "0^message"
        ;IEN    = Internal Entry Number in the TIUFILE
        ;TIUFILE = either 8925   if we need to see if a Note is of a Document Class 
        ;            or   8925.1 if we need to see if a Title is of a Document Class
        ;CLASS  = Text Name of the Document Class   example: "ADVANCE DIRECTIVE"
        ;
        S MAGRY="0^Unknown Error checking TIU Document Class"
        K MAGTRGT,DEFIEN,DOCCL,RES,DONE,NTTL
        S DONE=0
        ; If we're resolving a Title
        I TIUFILE="8925.1" D  Q:DONE
        . S DEFIEN=IEN,NTTL="Title"
        . I '$D(^TIU(8925.1,DEFIEN,0)) S MAGRY="0^Invalid Title IEN",DONE=1 Q
        . Q
        ; If we're resolving a Note
        I TIUFILE="8925" D  Q:DONE
        . S NTTL="Note"
        . I '$D(^TIU(8925,IEN)) S MAGRY="0^Invalid Note IEN",DONE=1 Q
        . ; Get Title IEN from Note IEN
        . S DEFIEN=$$GET1^DIQ(8925,IEN_",",.01,"I")
        . I DEFIEN="" S MAGRY="0^Error resolving Document Class from Note IEN" S DONE=1 Q
        . Q
        ;
        ; Find the IEN in 8925.1 for Document Class (CLASS) 
        D FIND^DIC(8925.1,"","@;.001","X",CLASS,"","","I $P(^(0),U,4)=""DC""","","MAGTRGT")
        S DOCCL=$G(MAGTRGT("DILIST",2,1))
        ;
        ; See if ^TIU(8925.1,DEFIEN is of Document Class DOCCL
        S RES=$$ISA^TIULX(DEFIEN,DOCCL)
        I RES S MAGRY="1^The "_NTTL_" is of Document Class "_CLASS Q
        S MAGRY="0^The "_NTTL_" is Not of Document Class "_CLASS
        Q
