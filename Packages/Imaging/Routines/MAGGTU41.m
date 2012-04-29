MAGGTU41        ;WOIFO/GEK - Version Control utilities  ; [ 06/20/2001 08:57 ]
        ;;3.0;IMAGING;**46,59**;Nov 27, 2007;Build 20
        ;; Per VHA Directive 2004-038, this routine should not be modified.
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
NOTOKB(X)       ; Client Not Supported. Server is Beta
        ; Client will not be supported when this version is Released.  Warn Client.
        S X(0)="0^     This site is a test site for Version: "_SV_"."
        S X(5)="     Client is running               Version: "_CV
        S X(7)="    "
        S X(10)="       When Version : "_SV_" is Released,  "
        S X(15)=" Client Version: "_CV_" will no longer be supported."
        S X(17)="  "
        S X(18)=" This Client Application will not work correctly."
        S X(19)=" "
        S X(20)=" Contact the Imaging System Manager to update this workstation."
        S X(30)="  "
        S X(40)="                          APPLICATION Will Continue"
        Q
NOTOK(X)        ; Client Not Supported.
        S X(0)="2^   Server is running Imaging V. "_SV_"      "_$P(SVSTAT,"^",2)
        S X(1)="   "
        S X(5)=" Client is running Imaging V. "_CV
        S X(7)="  "
        S X(10)=" Version "_CV_" is no longer supported."
        S X(15)="  "
        S X(20)=" Contact the Imaging System Manager to update this workstation."
        S X(30)="   "
        S X(40)="                       APPLICATION WILL ABORT !"
        ;  Clients prior to 8, have a 'Cancel' button on Message Dialog (oversight)
        I $P(CV,".",1)=2 S X(50)="(clicking 'Cancel' will not stop the Abort.)"
        Q
OKBADTB(X)      ; Client not Equal, Is supported. Previous Supported Version. Beta
        ;  But it's T isn't the T of it's Released Patch
        S X(0)="0^   Server is running Imaging V. "_SV_"      "_$P(SVSTAT,"^",2)
        S X(3)="   "
        S X(5)="  Client is running Imaging V. "_CLVER
        S X(10)="  The Released Version of Patch "_CP_" is V. "_CV_"."_$G(OKVER(CV))
        S X(12)="  "
        S X(18)="  This Client Application will not work correctly.  You should"
        S X(20)="  update this workstation with the Released Version of Patch "_CP
        S X(21)=" "
        S X(22)="  Contact the Imaging System Manager to update this workstation."
        S X(27)="     "
        S X(30)="                          APPLICATION will Continue  "
        Q
OKBADT(X)       ; Client not Equal, but it is supported.  Previous Supported Version
        ;  But it's T isn't the T of it's Released Patch
        S X(0)="2^   Server is running Imaging V. "_SV_"      "_$P(SVSTAT,"^",2)
        S X(3)="   "
        S X(5)="   Client is running Imaging V. "_CLVER
        S X(10)="  The Released Version of Patch "_CP_" is V. "_CV_"."_$G(OKVER(CV))
        S X(15)=" "
        S X(18)="  Version "_CLVER_" is not supported."
        S X(19)="  "
        S X(20)="  You must update this workstation."
        S X(22)="  "
        S X(25)="  Contact the Imaging System Manager to update this workstation."
        S X(27)="     "
        S X(40)="                       APPLICATION WILL ABORT !"
        Q
OKB(X)  ; Client is Not Equal to server.  Server Version / Beta
        ; Alpha/Beta Version so allow to continue. no message
        S X(0)="1^   Alpha/Beta testing in progress for: "_SV
        Q
OK(X)   ; Client is Not Equal to the server.   Warn
        S X(0)="0^   Server is running Imaging V. "_SV_"      "_$P(SVSTAT,"^",2)
        S X(5)="   Client is running   Imaging V. "_CV
        S X(7)="    "
        S X(10)="  The Client application should be updated "
        S X(15)=" "
        S X(20)="  Contact the Imaging System Manager to update this workstation."
        S X(30)="   "
        S X(40)="                       APPLICATION Will Continue"
        ;  Clients prior to 8, have a 'Cancel' button on Message Dialog (oversight)
        I $P(CV,".",1)=2 S X(50)="(clicking 'Cancel' will not stop the Client.)"
        Q
        ;
        ; Versions are the Same: If T versions are not, warn the Client.
        ; Released Client (of any version) will have the T version that the server expects, and
        ; no warning will be displayed.
TNOTOKB(X)      ; Client T is Not Equal to Server T, Beta Site.
        ;I CT,(CT'=ST) D  Q
        S X(0)="0^   Server is running Imaging V. "_SV_"."_ST_"      "_$P(SVSTAT,"^",2)
        S X(5)="   Client is running   Imaging V. "_CLVER
        S X(10)="     "
        S X(20)="  Test Versions of Patch "_SV_" other than T"_ST_" may not work correctly."
        S X(25)="     "
        S X(30)="                       APPLICATION will Continue  "
        Q
TNOTOK(X)       ; Client T is Not Equal to Server T.
        ;I CT,(CT'=ST) D  Q
        S X(0)="0^   Server is running Imaging V. "_SV_"."_ST_"      "_$P(SVSTAT,"^",2)
        S X(5)="   Client is running Imaging V. "_CLVER
        S X(10)="     "
        S X(12)="  For Patch "_CP_" the released T version is:  "_ST
        S X(20)="  You must update this workstation with the Released Version."
        S X(22)="  "
        S X(25)="  Contact the Imaging System Manager to update this workstation."
        S X(27)="     "
        S X(30)="                       APPLICATION will Continue  "
        Q
BADPLC(X)       ; The call to $$PLACE^MAGBAPI($G(DUZ(2))) Failed, return a message.
        ;
        I '$G(DUZ(2)) S X(0)="2^   Error: Undefined DUZ(2)"
        E  D
        . S X(0)="2^   Error: Division "_$P($G(^DIC(4,DUZ(2),0)),"^",1)_" ["_DUZ(2)_"]"
        . S X(2)="      is not an Imaging Site Parameter."
        . Q
        S X(5)="   Contact IRM.  Application will abort"
        Q
