HBHCRP29        ; LR VAMC(IRMS)/MJT-HBHC Medical Foster Home (MFH) license expiration e-mail reminder or report; e-mail due in 3 months, report due in 6 months, based on month only ; Jan 2008
        ;;1.0;HOSPITAL BASED HOME CARE;**24**;NOV 01, 1993;Build 201
        ; Calls:  DATE3L^HBHCUTL3, DATE6L^HBHCUTL3, TODAY^HBHCUTL, & ENDRPT^HBHCUTL1; e-mail entry point: DQ ;
        ; Set MFH Report flag
        S HBHCMFHR=1
        S %ZIS="Q" K IOP,ZTIO,ZTSAVE D ^%ZIS G:POP EXIT
        I $D(IO("Q")) S ZTRTN="DQ^HBHCRP29",ZTDESC="HBPC MFH License Expiration Report",ZTSAVE("HBHC*")="" D ^%ZTLOAD G EXIT
DQ      ; De-queue
        I $D(HBHCMFHR) U IO
        D TODAY^HBHCUTL
        S HBHCCC=0,HBHCCNT=1,HBHCTYPE="License",$P(HBHCSP15," ",16)="",$P(HBHCSP39," ",40)="",HBHCTXT="No MFH License currently due."
        I $D(HBHCMFHR) S HBHCPAGE=0,HBHCHEAD="Medical Foster Home (MFH) License Due",HBHCCOLM=(80-(30+$L(HBHCHEAD))\2) S:HBHCCOLM'>0 HBHCCOLM=1 S HBHCHDR="W ""Medical Foster Home Name"",?40,""License Expiration Date"""
LOOP    ; Loop thru HBHC Medical Foster Home file: ^HBHC(633.2; License = Y & Expiration Date in 3 months for e-mail, 6 months for report; based on month only
        ; DATE3L^HBHCUTL3 & DATE6L^HBHCUTL3 calls return HBHCDATE
        S HBHCI=0 F  S HBHCI=$O(^HBHC(633.2,HBHCI)) Q:HBHCI'>0  S HBHCNOD0=^HBHC(633.2,HBHCI,0) I $P(HBHCNOD0,U,6)="" I $P(HBHCNOD0,U,12)="Y" D:'$D(HBHCMFHR) DATE3L^HBHCUTL3 D:$D(HBHCMFHR) DATE6L^HBHCUTL3 D SET
        I $D(HBHCMFHR) D:IO'=IO(0)!($D(IO("S"))) HDRPAGE^HBHCUTL I '$D(IO("S")),(IO=IO(0)) S HBHCCC=HBHCCC+1 D HDRPAGE^HBHCUTL
        I $D(^TMP("HBHC",$J)) D PRTLOOP
        I '$D(^TMP("HBHC",$J)) I $D(HBHCMFHR) W !!,HBHCTXT
        D:$D(HBHCMFHR) ENDRPT^HBHCUTL1
EXIT    ; Exit module
        D ^%ZISC
        K DIR,HBHCCC,HBHCCNT,HBHCCOLM,HBHCDAT,HBHCDATE,HBHCHDR,HBHCHEAD,HBHCI,HBHCMFHN,HBHCMFHR,HBHCMO,HBHCMRDT,HBHCNOD0,HBHCPAGE,HBHCSP15,HBHCSP39,HBHCTDY,HBHCTXT,HBHCTYPE,HBHCZ,X,XMDUZ,XMSUB,XMY,XMTEXT,XMZ,Y
        K ^TMP("HBHC",$J),^TMP("HBHCMFH",$J)
        Q
SET     ; Set ^TMP node for valid record
        Q:$P(HBHCNOD0,U,13)'<HBHCDATE
        S HBHCDAT=$P(HBHCNOD0,U,13),HBHCMRDT=$E(HBHCDAT,4,5)_"-"_$E(HBHCDAT,6,7)_"-"_$S($E(HBHCDAT)=3:20,1:19)_$E(HBHCDAT,2,3)
        S ^TMP("HBHC",$J,$P(HBHCNOD0,U),HBHCI)=HBHCMRDT
        Q
PRTLOOP ; Print loop
        I '$D(HBHCMFHR) D LHDR
        S HBHCMFHN="" F  S HBHCMFHN=$O(^TMP("HBHC",$J,HBHCMFHN)) Q:HBHCMFHN=""  S HBHCI=0 F  S HBHCI=$O(^TMP("HBHC",$J,HBHCMFHN,HBHCI)) Q:HBHCI=""  D:'$D(HBHCMFHR) MAIL D:$D(HBHCMFHR) PRINT
        I '$D(HBHCMFHR) D SEND K ^TMP("HBHCMFH",$J)
        Q
LHDR    ; Write License header
        S ^TMP("HBHCMFH",$J,HBHCCNT)="Medical Foster Home Name"_HBHCSP15_"License Expiration Date" D COUNT
        D BLANK
        Q
BLANK   ; Set blank line
        S ^TMP("HBHCMFH",$J,HBHCCNT)="" D COUNT
        Q
MAIL    ; Write mail message
        S ^TMP("HBHCMFH",$J,HBHCCNT)="   "_HBHCMFHN_$E(HBHCSP39,($L(HBHCMFHN)+1),39)_$P(^TMP("HBHC",$J,HBHCMFHN,HBHCI),U) D COUNT
        Q
COUNT   ; Update count variable
        S HBHCCNT=HBHCCNT+1
        Q
SEND    ; Send Mail
        I '$D(^TMP("HBHCMFH",$J)) D BLANK S ^TMP("HBHCMFH",$J,HBHCCNT)=HBHCTXT
        S XMDUZ="HBHC MFH "_HBHCTYPE_" Reminder Mail Group",XMSUB=HBHCTDY_" MFH "_HBHCTYPE_" Due Reminder",XMY("G.HBHC MEDICAL FOSTER HOME")="",XMTEXT="^TMP(""HBHCMFH"",$J," D ^XMD
        Q
PRINT   ; Print report
        I ($D(ZTRTN)!(HBHCCC=0))&((IOSL-$Y)<5) W @IOF D HDRPAGE^HBHCUTL
        W !,HBHCMFHN,?40,$P(^TMP("HBHC",$J,HBHCMFHN,HBHCI),U)
