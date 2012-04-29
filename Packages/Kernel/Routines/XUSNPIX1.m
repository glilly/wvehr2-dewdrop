XUSNPIX1        ;OAK_BP/CMW - NPI EXTRACT REPORT ;11:45 AM  28 Jul 2009
        ;;8.0;KERNEL;**438,452,453,481,WV**; Jul 10, 1995;Build 13
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; NPI Extract Report
        ;
        ; Input parameter: N/A
        ;
        ; Other relevant variables:
        ;   XUSRTN="XUSNPIX1" (current routine name, used for ^XTMP and ^TMP
        ;                         storage subscript)
        ; Storage Global:
        ;   ^XTMP("XUSNPIX1",0) = Piece 1^Piece 2^Piece 3^Piece 4^Piece 5^Piece 6
        ;      where:
        ;      Piece 1 => Purge Date - 1 year in future
        ;      Piece 2 => Create Date - Today
        ;      Piece 3 => Description
        ;      Piece 4 => Last Date Compiled
        ;      Piece 5 => $H last run start time
        ;      Piece 6 => $H last run completion time
        ;
        ;   ^XTMP("XUSNPIX1",1) = DATA
        ;
        ;          XUSNPI => Unique NPI of entry
        ;          LDT => Last Date Run, VA Fileman Format
        ;
        ; Entry Point - TASKMAN => Run report in background using TASKMAN
        ;
        Q
        ;
TASKMAN ;TASKMAN ENTRY POINT
        ; Process Report
        N XUSRTN,DTTM,XUSPROD,XUSVER,INSMAIL
        ;
        ; Check for required variables
        I $G(U)=""!($G(DT)="") G EXIT
        S XUSRTN="XUSNPIX1"
        S DTTM=$$HTE^XLFDT($H,"2")
        ; Check to see if report is in use
        L +^XTMP(XUSRTN):5 I '$T G EXIT
        ;
        ;Reset Summary Scratch Globals
        K ^TMP("XUSNPIXS",$J)
        K ^TMP("XUSNPIXT",$J)
        ;
        ; Initialize variables
        D INIT(XUSRTN)
        ;
        ; Pull Station(Institution) data
        D INST(XUSRTN,XUSVER,.INSMAIL)
        ;
        ;Process New Person File
        D PROC1(XUSRTN,XUSPROD,XUSVER,DTTM,INSMAIL)
        ;
        ; Process Institution File
        D ENT^XUSNPIX2(XUSPROD,XUSVER)
        ;
        ; Process Non VA File
        D ENT^XUSNPIX3(XUSPROD,XUSVER)
        ;
        ; Send summary message
        D SMAIL^XUSNPIX5("XUSNPIXT",XUSPROD,XUSVER,DTTM)
        ;
        ;Standard EXIT point
EXIT    ;
        K DTTM,XUSVER,XUSHDR,XUSPROD,INSMAIL
        ;
        ;Kill off Scratch Globals
        K ^TMP("XUSNPIXS",$J)
        K ^TMP("XUSNPIXT",$J)
        K ^TMP("XUSNPIXU",$J)
        ; Log Run Completion Time
        S $P(^XTMP(XUSRTN,0),U,6)=$H
        L -^XTMP(XUSRTN)
        ;
        Q
        ;
INIT(XUSRTN)    ; check/init variables
        N XUSDESC
        ; Set to NEXT release version from NPM
        S XUSVER="481.5"
        ; Get production/test account flag
        S XUSPROD=$S($$PROD^XUPROD(1):"PROD",1:"TEST")
        ;
        ; Reset Temporary Scratch Global
        D INIT^XUSNPIXU
        K ^TMP(XUSRTN)
        S XUSDESC="NPI EXTRACT TYPE 1 - Do Not Delete"
        S ^XTMP(XUSRTN,0)=(DT+10000)_U_DT_U_XUSDESC_U_DT_U_$H
        ; Generate TMP BCBS Array
        D BCBSID^XUSNPIXU
        ;
        Q
        ;
INST(XUSRTN,XUSVER,INSMAIL)     ;Pull station and Institution info
        N INST,SINFO,DIC4
        ; Pull site info
        S SINFO=$$SITE^VASITE
        ; Station Number
        S SITE=$P(SINFO,U,3)
        ; Institution
        S INST=$P(SINFO,U)
        ;
        ; Get institution mailing address
        I INST D
        . S DIC4=$G(^DIC(4,INST,4))
        . S XUSNP(7)=$P(DIC4,U)
        . S XUSNP(8)=$P(DIC4,U,2)
        . S XUSNP(9)=$P(DIC4,U,3)
        . S XUSNP(10)=$P(DIC4,U,4)
        . I XUSNP(10) S XUSNP(10)=$P($G(^DIC(5,XUSNP(10),0)),U,2)
        . S XUSNP(11)=$P(DIC4,U,5)
        . S INSMAIL=XUSNP(7)_U_XUSNP(8)_U_XUSNP(9)_U_XUSNP(10)_U_XUSNP(11)
        S XUSHDR="Station: "_SITE_U_XUSNP(9)_U_XUSNP(10)_U_XUSNP(11)_U_"TYPE 1"_U_XUSVER
        ;
        Q
        ;
PROC1(XUSRTN,XUSPROD,XUSVER,DTTM,INSMAIL)       ;Process all New Person records
        N XUSNPI,XUSDT,XUSNEW,XUSI,XUSDATA,XUSVA0,XUSVA0,XUSVA1,XUSNAME,XUSDOB,XUSDIV,XUSSTL,XUSSTLN,XUSOPN
        N XUSPER,XUSSPC,XUSTAX,XUSTAXID,XUSIZE,NPIEN,DIC4,SPDIV,VA12,VA13,COUNT,MSGCNT,MAXSIZE,TOTREC,XUSEOL
        ;
        ; Set to 300000 for live
        S MAXSIZE=300000
        ;
        ; Set end of line character
        S XUSEOL="~~"
        ;
        ; set counter
        S COUNT=1,(TOTREC,MSGCNT,XUSIZE)=0
        ; Loop through NEW PERSON NPI records NPI cross ref
        S XUSNPI=0
        F  S XUSNPI=$O(^VA(200,"ANPI",XUSNPI)) Q:'XUSNPI  D
        . S NPIEN=$O(^VA(200,"ANPI",XUSNPI,""))
        . ;
        . ; Init columns
        . F XUSI=1:1:29 S XUSNP(XUSI)=""
        . S XUSNP(1)=XUSNPI S XUSDATA1=XUSNP(1)
        . ;
        . S XUSVA0=$G(^VA(200,NPIEN,0))
        . S XUSVA1=$G(^VA(200,NPIEN,1))
        . S XUSNAME=$P(XUSVA0,U)
        . ; BREAK NAME INTO COMPONENTS
        . I XUSNAME'="" D
        . . ;Begin WorldVistA Change; 07/28/2009
        . . ;S XLFNC=XUSNAME D FORMAT^XLFNAME7(.XLFNC,,,,0)
        . . S XLFNC=XUSNAME S XLFNC=$$FORMAT^XLFNAME7(.XLFNC,,,,0)
        . . ;End WorldVistA change
        . . S XUSNP(2)=XLFNC("GIVEN"),XUSNP(3)=XLFNC("MIDDLE"),XUSNP(4)=XLFNC("FAMILY")
        . . I XLFNC("SUFFIX")'="" S XUSNP(4)=XUSNP(4)_" "_XLFNC("SUFFIX")
        . . K XLFNC
        . S XUSDATA1=XUSDATA1_U_XUSNP(2)_U_XUSNP(3)_U_XUSNP(4)
        . S XUSNP(5)=1 ;TYPE
        . S XUSDOB=$P(XUSVA1,U,3)
        . ; dob formatted as mm/dd/yyyy
        . I XUSDOB D
        . . S XUSNP(6)=$$FMTE^XLFDT(XUSDOB,5)
        . S XUSDATA1=XUSDATA1_U_XUSNP(5)_U_XUSNP(6)
        . ;
        . ; Pay to Provider Address Use primary institution mailing address NP7-11
        . S XUSDATA1=XUSDATA1_U_INSMAIL
        . ;
        . ; Servicing Provider Address
        . S (XUSDIV)=0
        . ; Loop through Division multiple
        . F  S XUSDIV=$O(^VA(200,NPIEN,2,XUSDIV)) Q:'XUSDIV  D
        . . S DIC4=$G(^DIC(4,XUSDIV,4))
        . . S XUSNP(12)=$P(DIC4,U)
        . . S XUSNP(13)=$P(DIC4,U,2)
        . . S XUSNP(14)=$P(DIC4,U,3)
        . . S XUSNP(15)=$P(DIC4,U,4)
        . . I XUSNP(15) S XUSNP(15)=$P($G(^DIC(5,XUSNP(15),0)),U,2)
        . . S XUSNP(16)=$P(DIC4,U,5)
        . . S XUSSTA(XUSDIV)=$P($G(^DIC(4,XUSDIV,99)),U)
        . . S SPADR(XUSDIV)=XUSNP(12)_U_XUSNP(13)_U_XUSNP(14)_U_XUSNP(15)_U_XUSNP(16)
        . ; If no divisions found
        . I '$D(SPADR) D
        . . S XUSSTA(9999)="N/A",SPADR(9999)=XUSNP(12)_U_XUSNP(13)_U_XUSNP(14)_U_XUSNP(15)_U_XUSNP(16)
        . ;
        . ; Office Phone number
        . S XUSOPN=$P($G(^VA(200,NPIEN,.13)),U,2)
        . I XUSOPN'="" S XUSNP(17)=XUSOPN
        . ;
        . ; Degree
        . S XUSNP(18)=$P($G(^VA(200,NPIEN,3.1)),U,6)
        . ; Degree Code (place holder)
        . S XUSNP(19)=""
        . ;
        . ; get taxonomy and specialty
        . S XUSPER=0
        . F  S XUSPER=$O(^VA(200,NPIEN,"USC1","B",XUSPER)) Q:'XUSPER  D
        . . S XUSSPC=$P($G(^USC(8932.1,XUSPER,0)),U,9)
        . . S XUSTAX=$P($G(^USC(8932.1,XUSPER,0)),U,7)
        . . I XUSSPC'="" D
        . . . I XUSNP(20)="" S XUSNP(20)=XUSSPC Q
        . . . S XUSNP(20)=XUSNP(20)_";"_XUSSPC
        . . I XUSTAX'="" D
        . . . I XUSNP(21)="" S XUSNP(21)=XUSTAX Q
        . . . S XUSNP(21)=XUSNP(21)_";"_XUSTAX
        . ;
        . ; Tax ID
        . S XUSTAXID=$P($G(^VA(200,NPIEN,"TPB")),U,2)
        . I XUSTAXID="" S XUSTAXID=$P($G(^VA(200,NPIEN,1)),U,9)
        . S XUSNP(22)=XUSTAXID
        . ;
        . S XUSDATA2=XUSNP(17)_U_XUSNP(18)_U_XUSNP(19)_U_XUSNP(20)_U_XUSNP(21)_U_XUSNP(22)
        . ;
        . ; Medicare Part A/B
        . S XUSNP(23)=670899
        . S XUSNP(24)="VA"_$E(SITE+10000,2,5)
        . ;
        . ; State License
        . S XUSSTL=0
        . F  S XUSSTL=$O(^VA(200,NPIEN,"PS1",XUSSTL)) Q:'XUSSTL  D
        . . S XUSSTLN=$P($G(^VA(200,NPIEN,"PS1",XUSSTL,0)),U,2)
        . . I XUSSTLN'="" D
        . . . I XUSNP(25)="" S XUSNP(25)=XUSSTLN Q
        . . . S XUSNP(25)=XUSNP(25)_";"_XUSSTLN
        . ; DEA #
        . S XUSNP(26)=$P($G(^VA(200,NPIEN,"PS")),U,2)
        . ;
        . S XUSDATA2=XUSDATA2_U_XUSNP(23)_U_XUSNP(24)_U_XUSNP(25)_U_XUSNP(26)
        . ;
        . ; Station #
        . S XUSNP(27)=""
        . ;
        . ; Get BCBS Payer ID Array
        . K XUSBXID
        . D PRACID^XUSNPIXU(NPIEN,.XUSBXID)
        . ;
        . ; Save entry to ^TMP and update count
        . N XUSB
        . S XUSDIV=0
        . F  S XUSDIV=$O(SPADR(XUSDIV)) Q:'XUSDIV  D
        . . S COUNT=COUNT+1,TOTREC=TOTREC+1
        . . S ^TMP(XUSRTN,$J,COUNT)=XUSDATA1_U_SPADR(XUSDIV)_U_XUSDATA2_U_XUSSTA(XUSDIV)_U_XUSEOL
        . . S XUSIZE=XUSIZE+$L(^TMP(XUSRTN,$J,COUNT))
        . . ; Check BCBS Id array
        . . I $D(XUSBXID) D
        . . . S XUSB=""
        . . . F  S XUSB=$O(XUSBXID(XUSB)) Q:XUSB=""  D
        . . . . S COUNT=COUNT+1,TOTREC=TOTREC+1
        . . . . S ^TMP(XUSRTN,$J,COUNT)=XUSDATA1_U_SPADR(XUSDIV)_U_XUSDATA2_U_XUSSTA(XUSDIV)_U_XUSB_U_XUSEOL
        . . . . S XUSIZE=XUSIZE+$L(^TMP(XUSRTN,$J,COUNT))
        . K XUSNP,XUSDATA1,XUSDATA2,XUSDATA3,SPADR,XUSBXID,CNT,XUSSTA
        . I XUSIZE>MAXSIZE D
        . . D EOF(XUSRTN)
        . . D EMAIL^XUSNPIX5(XUSRTN)
        . . K ^TMP(XUSRTN,$J)
        . . S ^TMP("XUSNPIXS",$J,1,MSGCNT)="1^"_(COUNT-2)
        . . S ^TMP(XUSRTN,$J,1)=XUSHDR
        . . S COUNT=1,XUSIZE=0
        D EOF(XUSRTN)
        ;
        ; Send the last message (if it has records)
        I $G(COUNT)>1 D
        .D EMAIL^XUSNPIX5(XUSRTN)
        .K ^TMP(XUSRTN,$J)
        .S ^TMP("XUSNPIXS",$J,1,MSGCNT)="1^"_(COUNT-2)
        ;
        ; Set summary totals
        S ^XTMP("XUSNPIXT",0)=(DT+10000)_U_DT_U_"NPI EXTRACT SUMMARY TOTALS"_U_DT_U_$H
        S ^XTMP("XUSNPIXT","H")=$P(XUSHDR,U,1,4)
        S ^XTMP("XUSNPIXT",1)=MSGCNT_U_TOTREC_U_DTTM
        K INSMAIL,SITE
        Q
        ;
EOF(XUSRTN)     ;
        Q:COUNT=1
        S MSGCNT=MSGCNT+1
        S ^TMP(XUSRTN,$J,1)=XUSHDR_U_"Message Number: "_MSGCNT_U_"Line Count: "_COUNT_U_DTTM_U_$G(XUSPROD)_U_XUSEOL
        S COUNT=COUNT+1
        S ^TMP(XUSRTN,$J,COUNT)="END OF FILE"_U_XUSEOL
        Q
