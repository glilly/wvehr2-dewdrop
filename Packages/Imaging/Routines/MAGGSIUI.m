MAGGSIUI        ;WOIFO/GEK - Utilities for Image Import API
        ;;3.0;IMAGING;**7,8,48,20,85,59**;Nov 27, 2007;Build 20
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
REMOTE(MAGRY,MAGDATA)   ;RPC [MAG4 REMOTE IMPORT]
        ; Import Images from a Windows App, by sending an array.
        I ($D(MAGDATA)<10) S MAGRY(0)="0^Missing Data Array !." Q
        N I,J,ICT,DCT,MAGIX,IMAGES,ERR,X,Z
        S (ERR,ICT,DCT)=0
        S I="" F  S I=$O(MAGDATA(I)) Q:I=""  S X=MAGDATA(I) D  Q:ERR
        . S Z=$P(X,U)
        . I (X="")!(Z="") S MAGRY(0)="0^INVALID Data in Input Array: Node "_I_"="""_X_"",ERR=1 Q
        . I Z="IMAGE" S ICT=ICT+1,IMAGES(ICT)=$P(X,U,2,99) Q
        . S DCT=DCT+1,MAGIX(Z)=$P(X,U,2,99)
        I 'ERR D IMPORT(.MAGRY,.IMAGES,.MAGIX)
        Q
        ;
IMPORT(MAGRY,IMAGES,MAGIX)      ;
        ; "IDFN","PXPKG","PXIEN","PXDT","TRKID","ACQD","ACQS","ACQL","STSCB","ITYPE",
        ;        "CMTH","CDUZ","USERNAME","PASSWORD","GDESC","DFLG","TRTYPE","DOCCTG","DOCDT",
        ;        "IXTYPE","IXSPEC","IXPROC","IXORIGIN    ;Patch 8: Added Index fields
        ;
        ;Index fields Package, Class ("IXPKG" and "IXCLS") aren't accepted
        ;    they are computed values.
        ; - Convert field codes into an Input Data Array,
        ;   validate, then set the Import Queue
        ;
        N $ETRAP,$ESTACK S $ETRAP="D ERR^"_$T(+0)
        K MAGRY S MAGRY(0)="0^Importing data..."
        N APISESS,MWIN
        S MWIN=$$BROKER^XWBLIB
        N PRM,CT,MAGA,MAGY,MAGTN,TNODE
        N IDFN,PXPKG,PXIEN,PXDT,TRKID,ACQD,ACQS,ACQN,ACQL,STSCB,ITYPE,CMTH,CDUZ,USERNAME,PASSWORD
        N GDESC,DFLG,TRTYPE,DOCCTG,DOCDT,IXPKG,IXCLS,IXTYPE,IXSPEC,IXPROC,IXORIGIN,MAX,SITEPLC
        N ERR,MAGTM,QTIME,MAGIXZ
        S CT=0,ERR=0
        M MAGIXZ=MAGIX
        ;  DON'T CONVERT ACQS(really a ACQN) to a REAL ACQS, leave it ACQS to be converted by MAGGSIV
        ;
        F PRM="IDFN","PXPKG","PXIEN","PXDT","TRKID","ACQD","ACQS","ACQN","ACQL","STSCB","ITYPE","CMTH","CDUZ","USERNAME","PASSWORD","GDESC","DFLG","TRTYPE","DOCCTG","DOCDT","IXTYPE","IXSPEC","IXPROC","IXORIGIN" D
        . S @PRM=$G(MAGIX(PRM)) K MAGIX(PRM) ; P8T14 added K.. and next line to account for field numbers later.
        . Q
        S PRM="" F  S PRM=$O(MAGIX(PRM)) Q:PRM=""  D SA(PRM,$G(MAGIX(PRM)))
        ;
        S MAGTM=$$NOW^XLFDT
        I '$G(DUZ) S MAGRY(0)="0^DUZ is undefined." Q  ;D ERRTRK Q
        ; DATATRK sets Global var. APISESS  = IEN of Session File.
        D DATATRK
        I '$$REQPARAM^MAGGSIU2() D ERRTRK Q
        S MAX=$P(TRKID,";",1)="MAX"
        ;I 'MWIN W !,"----------------" ZW  W !,"---------------------"
        ; Workaround VIC (Maximus) is sending Station Number
        ; we'll convert to Institution IEN
        I MAX&(ACQS]"") D  Q:ERR
        . S X=$O(^DIC(4,"D",ACQS,""))
        . I X="" S MAGRY(0)="0^Invalid Station Number:(Maximus ACQS): "_ACQS,ERR=1 Q
        . S SITEPLC=X ; We need the Place for the Queue
        . ;S ACQS=X  Out in 85. Don't change to ACQS, that's done in VAL^MAGGSIV
        . Q
        ; Change to Allow ACQN - STATION NUMBER from INSTITUTION File.
        I $L(ACQN) D  Q:ERR
        . S ACQS=$O(^DIC(4,"D",ACQN,""))
        . I ACQS="" S MAGRY(0)="0^Invalid STATION NUMBER: (ACQN): "_ACQN,ERR=1 Q
        . ; VAL^MAGGSIV Will fail if ACQS is real and this is Maximus
        . I MAX S ACQS=ACQN K ACQN Q
        . S ACQN="" ;We converted to ACQS, lets make "" so no confusion later.
        . Q
        ;
        ; Set the input data array
        D SA(5,IDFN)    ;PATIENT
        D SA(16,PXPKG)   ;PARENT DATA FILE
        D SA(17,PXIEN) ;PARENT GLOBAL ROOT
        D SA(15,PXDT)   ; PROCEDURE/EXAM DATE/TIME
        D SA(108,TRKID) ; TRACKING ID (new)
        D SA("ACQD",ACQD)  ; ACQUISTION DEVICE ( new )
        I 'MAX S SITEPLC=ACQS D SA(.05,ACQS) ; this used to be fld 105
        D SA(101,ACQL)
        D SA("STATUSCB",STSCB)  ; STATUS CALLBACK  (was referred to as ExceptionHandler)
        D SA(3,ITYPE)   ; OBJECT TYPE
        D SA("CALLMTH",CMTH)     ; CALL METHOD
        D SA(8,CDUZ)    ; IMAGE SAVE BY
        D SA("USERNAME",USERNAME)
        D SA("PASSWORD",PASSWORD)
        D SA(10,GDESC)  ; SHORT DESCRIPTION
        D SA("DELFLAG",DFLG)    ; DELETE FLAG
        D SA("TRNSTYP",TRTYPE)  ; TRANSACTION TYPE
        D SA(100,DOCCTG) ;  document Main category
        D SA(110,DOCDT)     ;  document date
        ; Patch 8 allows Index fields to be imported.
        ;"IXTYPE","IXSPEC","IXPROC","IXORIGIN"
        D SA(42,IXTYPE)     ;  Index Type
        D SA(43,IXPROC)     ;  Index Proc/Event
        D SA(44,IXSPEC)     ;  Index Spec/SubSpec
        D SA(45,IXORIGIN)         ;  Index Origin
        ;
        D VAL^MAGGSIV(.MAGRY,.MAGA,1) I 'MAGRY(0) D ERRTRK Q
        I MAX D SA(.05,ACQS) ; this used to be fld 105
        ; Also Done in MAGGSIA when image is being Saved.
        I '$$VALINDEX^MAGGSIV1(.MAGRY,IXTYPE,IXSPEC,IXPROC) D ERRTRK Q
        ;   Array of Images to Import
        D SI("IMAGES",.IMAGES) I 'MAGRY(0) D ERRTRK Q
        K MAGRY
        ;
        I TRTYPE="NOQUEUE" M MAGRY=MAGA S MAGRY(0)="1^" Q
        ; This call is for BP
        S QTIME=$$NOW^XLFDT
        ; p85 use ACQS instead of DUZ(2)
        S MAGY=$$IMPORT^MAGBAPI(.MAGA,STSCB,TRKID,$$PLACE^MAGBAPI(SITEPLC))
        ; Return Queue Number
        I 'MAGY S MAGRY(0)="0^Error Setting Queue: "_$P(MAGY,U,2),MAGY=TRKID
        E  S MAGRY(0)=MAGY_"^Data has been Queued.",MAGY=+MAGY
        ; for Testing, we'll track input array, and results array by Queue number.
        I 'MAGRY(0) D ERRTRK Q
        D LOGRES^MAGGSIU3(.MAGRY,0,APISESS)
        ;
        Q
        ;
SA(FLD,VAL)     ;Set the data array with Fld,Value
        Q:VAL=""
        S CT=CT+1,MAGA(CT)=FLD_U_VAL
        Q
SI(FLD,ARR)     ;Set the images into the data array
        ; 'CT' is a global variable.
        S MAGRY(0)="1^Valid Image file Extensions."
        N I,MAGEXT,MAGFN
        S I="" F  S I=$O(ARR(I)) Q:I=""  D  Q:'MAGRY(0)
        . S CT=CT+1
        . I ($L($P(ARR(I),U),".")<2) S MAGRY(0)="0^Invalid file name: "_ARR(I) Q
        . S MAGFN=$P(ARR(I),"^")
        . S MAGEXT=$$UP^XLFSTR($P(MAGFN,".",$L(MAGFN,".")))
        . I '$D(^MAG(2005.021,"B",MAGEXT)) S MAGRY(0)="0^Unsupported File Type:'."_MAGEXT Q
        . S MAGA(CT)="IMAGE"_U_ARR(I)
        Q
GETARR(ARR,QNUM)        ;RPC [MAG4 DATA FROM IMPORT QUEUE]
        ; Get the Input Array from Queue Number
        I '$G(QNUM) S ARR(0)="0^INVALID QUEUE Number: "_$G(QNUM) Q
        D IMPAR^MAGQBUT2(.ARR,QNUM)
        Q
STATUSCB(MAGRY,STAT,TAGRTN,DOCB)        ;RPC [MAG4 STATUS CALLBACK]
        ; Report Status to calling application
        ; Now the IAPI and OCX make this call.  Not BP
        ; STAT(0)= "0^message" or "1^message"
        ; STAT(1)=TRKID,
        ;        (2)=QNUM
        ;        (3..N)=warnings
        ;TAGRTN                 : The TAG^RTN to call with Status Array
        ;DOCB                   : (1|0) to suppress execution of Status Callback
        ;
        N APISESS,TRKID,CBMSG
        S DOCB=$S($G(DOCB)="":1,1:+$G(DOCB)) ;  Default to TRUE
        ; Old Import API and BP that made this call, will work : DOCB defaults to 1
        S CBMSG=$S(DOCB:"Status Callback was called",1:"Status Callback was NOT called")
        I DOCB D @(TAGRTN_"(.STAT)")
        S MAGRY="1^"_CBMSG
        S STAT($O(STAT(""),-1)+1)=MAGRY
        S TRKID=$G(STAT(1))
        ; Log Results. Always.
        I $L(TRKID) D
        . S APISESS=$$SES4TRK^MAGGSIU3(TRKID) ;
        . I APISESS D LOGRES^MAGGSIU3(.STAT,0,APISESS) ;gek/send Tracking ID to log status
        Q
TESTCB(STATARR) ;TESTING.  This is the Status Callback for testing.
        ; the STATUSCB property must have a Valid "M" TAG^ROUTINE
        ; TAG TESTCB exists so that STATUSCB validates successfully
        Q
ERRTRK  ;Track bad data and Quit
        N I
        D LOGERR^MAGGSERR("---- New Error ----",APISESS)
        S I="" F  S I=$O(MAGRY(I)) Q:I=""  D LOGERR^MAGGSERR(MAGRY(I),APISESS)
        Q
DATATRK ; Track the raw data being sent to the Import API.
        ; Log the data being imported.  Results are logged later.
        N XY
        S APISESS=$$LOG^MAGGSIU3(.XY,.MAGIXZ,.IMAGES,IDFN,ACQD,TRKID)
        Q
ERR     ; ERROR TRAP FOR Import API
        N ERR S ERR=$$EC^%ZOSV
        S MAGRY(0)="0^ETRAP: "_ERR
        D @^%ZOSF("ERRTN")
        I $G(APISESS) D ERRTRK
        Q
