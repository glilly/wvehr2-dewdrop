CWMAINI ;INDPLS/PLS - KIDS INITS FOR GUIMail INSTALL ;20-Jul-2005 14:46;CLC;
        ;;2.3;CWMAIL;;Jul 19, 2005
        ; Environment Check
EC      D VCHK("RPC BROKER",1.1)  ;RPC Broker
        D PCHK("DI*21.0*34")  ;Fileman/Delphi Components
        D PCHK("XM*7.1*50")  ;MailMan Patch
        D PCHK("XM*7.1*73")  ;MailMan Patch to $$CONVERT^XMXUTIL1
        D PCHK("XU*8.0*71")  ;Kernel date formatting patch
        D PCHK("XT*7.3*26")  ;Kernel Tool-Kit Generic Parameters
        S:$G(XPDENV) XPDDIQ("XPZ1")=0  ;force Disable Options/Protocols prompt to NO
        Q
VCHK(CWP,CWV)   ;CHECK VERSION OF PASSED PACKAGE
        D:$$VERSION^XPDUTL(CWP)<CWV MES("Requires at least version "_CWV_" of the "_CWP_".")
        Q
PCHK(CWPATCH)   ;CHECK PATCH INSTALLATION
        D:'$$PATCH^XPDUTL(CWPATCH) MES("Requires that patch "_CWPATCH_" be installed.")
        Q
MES(X)  D BMES^XPDUTL(X)
        S XPDQUIT=1
        Q
        ;Post Installation
EN      ;entry point for post installation functions
        ;
        D ^CWMAPP  ;populate package parameters
        D EN^CWMACPPI  ;convert CWMAIL1 to Generic Parameter Utility
        D UPCURVER(2.3)     ;make sure current version is updated
        ;D PDEL890  ;prompt for deletion of File 890 CW GUI VISTA MAIL USER
        D MMSG  ;send mail message indicating package installation
        Q
MMSG    ;send mail message to Indianapolis indicating CW GUIMail installation
        ;
        N CWSUBJ,CWRECP,CWBODY
        S CWBODY=$NA(^TMP($J,"CWBODY"))
        S CWSUBJ="GUIMail Installation at "_$G(^XMB("NETNAME"))
        S ^TMP($J,"CWBODY",1)="GUIMail has just been installed at: "_$G(^XMB("NETNAME"))_"."
        S ^TMP($J,"CWBODY",2)="Version #: 2.3"    ;_$$VERSION^XPDUTL("CWMA")  ;set version number
        S ^TMP($J,"CWBODY",3)="Installer: "_$P($G(^VA(200,+$G(DUZ),0)),U)
        S CWRECP("G.GUIMAIL@INDIANAPOLIS.VA.GOV")=""
        D SENDMSG^XMXAPI(DUZ,CWSUBJ,CWBODY,.CWRECP)
        K ^TMP($J,"CWBODY")
        Q
        ;
PDEL890 ;I $$READY("Do you wish to remove the file at this time","NO") D
        ;. N DIU
        ;. S DIU="^CWMAIL1(",DIU(0)="DST" D EN^DIU2
        ;E  D
        ;. W !,"OK. You may delete later by executing D PDEL890^CWMAINI."
        D BMES^XPDUTL("Removing CW GUI VISTA MAIL USER (890) File ...")
        N DIU
        S DIU="^CWMAIL1(",DIU(0)="DST" D EN^DIU2
        Q
UPCURVER(VER)   ;
        N IEN,CWFDA
        S IEN=$$FIND1^DIC(9.4,"","B","CW GUIMail","B","","OUT")
        I IEN D
        .Q:$G(^DIC(9.4,IEN,"VERSION"))=VER
        .S CWFDA(9.4,IEN_",",13)=VER
        .D FILE^DIE("","CWFDA")
        Q
READY(CWPRMPT,CWDEF)    ; Prompts user for input
        ;Input - CWPRMPT - will set DIR("A" to this value
        ;         CWDEF - will set DIR("B" to this value
        ;Output - returns a 1(yes) or 0(no)
        N DIR,X,Y
        W !!,"                   * * * *  WARNING  * * * *"
        W !!,"       You are about to remove file 890. This file held"
        W !!,"    personal preferences for GUIMail v2.0. All of the settings"
        W !!,"       should have been moved to the Generic Parameter File"
        W !!,"                     during installation.",!!
        S DIR("B")=$G(CWDEF,"NO")
        S DIR(0)="Y"
        D ^DIR Q:Y 1  ; answered YES
        Q 0  ; answered NO
