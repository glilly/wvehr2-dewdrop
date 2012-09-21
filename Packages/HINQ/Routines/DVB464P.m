DVB464P ;ALB/MJB - DISABILITY FILE UPDATE ; 6/28/10 1:34pm
        ;;4.0;HINQ;**64**;03/25/92;Build 25
        ;
        ;This routine will delete requested
        ;ICD code mappings from the DISABILITY CONDITION (#31) file.
        ;
        ;
        Q  ;no direct entry
        ;
        ;
ENV     ; do environment check
        S XPDABORT=""
        D PROGCHK(.XPDABORT)
        I XPDABORT="" K XPDABORT
        Q
PROGCHK(XPDABORT)       ; checks for necessary programmer variables
        I '$G(DUZ)!($G(DUZ(0))'="@")!('$G(DT))!($G(U)'="^") D
        .D MES^XPDUTL("Your programming variables are not set up properly.")
        .D MES^XPDUTL("Installation aborted.")
        .S XPDABORT=2
        Q
        ;
POST    ;Main entry point for Post-init items.
        ;
        N DVBTOT  ;count of total ICD9 codes filed
        N DVBTMP  ;Closed Root global reference for error reporting
        S DVBTMP=$NA(^TMP("DVB464PD",$J))
        K @DVBTMP
        S @DVBTMP@(0)="PATCH DVB*4*64 POST-INSTALL^"_$$NOW^XLFDT
        S DVBTOT=0
        ;
        ;call to process (#31) file updates
        D POST^DVB464PD(DVBTMP,.DVBTOT)
        ;
        S @DVBTMP@(0)=@DVBTMP@(0)_"^"_$$NOW^XLFDT_"^"_DVBTOT
        ;
        I '$D(@DVBTMP@("ERROR")) D
        . D BMES^XPDUTL("  >>> *** SUCCESS updating the DISABILITY CONDITION (#31) file.")
        . D MES^XPDUTL("          Total RELATED ICD9 CODES filed: "_DVBTOT)
        . ;
        E  D
        . D BMES^XPDUTL("  >>> *** FAILURE updating the DISABILITY CONDITION (#31) file.")
        . D BMES^XPDUTL("      Filing error's have occurred when updating the file.")
        . D MES^XPDUTL("      Resolution is necessary to maintain database integrity.")
        . D BMES^XPDUTL("  A MailMan message has been sent to the installer of this patch")
        . D MES^XPDUTL("  with a listing of the errors.")
        . D BMES^XPDUTL("  Once these errors have been resolved, please re-run")
        . D MES^XPDUTL("  the Post-Installation routine directly from programmer mode")
        . D MES^XPDUTL("  by entering the following command:")
        . D MES^XPDUTL("  ")
        . D MES^XPDUTL("  D POST^DVB4P64")
        . D MES^XPDUTL("  ")
        . D BMES^XPDUTL("  >>> I'm now creating and sending the MailMan message...")
        . ;
        . D SENDMSG(DVBTMP,.DVBTOT)
        . ;
        . D MES^XPDUTL("  >>> All done.")
        ;
        ;cleanup temp file
        K @DVBTMP
        Q
        ;
        ;
SENDMSG(DVBTMP,DVBTOT)  ;send failure MailMan message to installer of patch
        ;
        N DIFROM,DVBMSG
        N XMY,XMDUZ,XMSUB,XMTEXT,XMDUN,XMZ
        S XMSUB="DVB*4.0*64 Patch Post-Install Error Listing"
        S XMTEXT="DVBMSG("
        S XMY(DUZ)="",XMDUZ=.5
        ;S XMDUZ=.5,(XMY(DUZ),XMY(XMDUZ))=""
        S DVBMSG(1)="Patch:  DVB*4.0*64 Automated Service Connected Designation"
        S DVBMSG(2)=""
        S DVBMSG(3)="The post-installation update of the DISABILITY CONDITION (#31) file"
        S DVBMSG(4)="has FAILED to successfully complete.  Errors have occurred when"
        S DVBMSG(5)="attempting to make the changes."
        S DVBMSG(6)=""
        S DVBMSG(7)="Resolution of ALL error's is needed to maintain database integrity."
        S DVBMSG(8)=""
        S DVBMSG(9)="Once these filing error's have been resolved, please re-run"
        S DVBMSG(10)="the Post-Installation routine directly from programmer mode"
        S DVBMSG(11)="by entering the following command:"
        S DVBMSG(12)=""
        S DVBMSG(13)="D POST^DVB4P64"
        S DVBMSG(14)=""
        S DVBMSG(15)="The new update run time should take less than 5 minutes to complete."
        S DVBMSG(16)=""
        S DVBMSG(17)=">>> Please review and resolve the following error's:"
        S DVBMSG(18)=""
        S DVBMSG(19)="*** DISABILITY CONDITION FILE (#31) FILING ERRORS ***"
        S DVBMSG(20)="-----------------------------------------------------"
        ;
        ;loop and list error's
        N DVBICD,DVBHDR,DVBHDR1,DVBIEN,DVBLN,DVBMSS,DVBVBA,DVBDESC
        S DVBHDR="VBA DX CODE: ",DVBHDR1="    ICD DIAGNOSIS CODE: "
        S DVBLN=21,DVBVBA=0
        F  S DVBVBA=$O(@DVBTMP@("ERROR",DVBVBA)) Q:'DVBVBA  D
        . I $D(@DVBTMP@("ERROR",DVBVBA,0)) D  Q
        . . S DVBMSS=DVBHDR_DVBVBA_" - "_$G(@DVBTMP@("ERROR",DVBVBA,0))
        . . S DVBMSG(DVBLN)=DVBMSS,DVBLN=DVBLN+1
        . K DVBDESC D FIND^DIC(31,"","","X",DVBVBA,,"C","","","DVBDESC")
        . S DVBMSS=DVBHDR_DVBVBA_" - "_$E($G(DVBDESC("DILIST",1,1)),1,50)
        . S DVBMSG(DVBLN)=DVBMSS,DVBLN=DVBLN+1
        . S DVBIEN=0
        . F  S DVBIEN=$O(@DVBTMP@("ERROR",DVBVBA,DVBIEN)) Q:'DVBIEN  D
        . . S DVBICD=""
        . . F  S DVBICD=$O(@DVBTMP@("ERROR",DVBVBA,DVBIEN,DVBICD)) Q:DVBICD=""  D
        . . . S DVBMSS=DVBHDR1_DVBICD_" - "_$G(@DVBTMP@("ERROR",DVBVBA,DVBIEN,DVBICD))
        . . . S DVBMSG(DVBLN)=DVBMSS,DVBLN=DVBLN+1
        S DVBMSG(DVBLN)="",DVBLN=DVBLN+1
        S DVBMSG(DVBLN)="<End of Report>"
        ;
        D ^XMD
        Q
        ;
