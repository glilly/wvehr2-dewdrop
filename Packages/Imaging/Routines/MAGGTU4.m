MAGGTU4 ;WOIFO/GEK - Imaging Client- Version checking routine; [ 06/20/2001 08:57 ]
        ;;3.0;IMAGING;**8,48,63,45,46,59,96**;April 29, 2008;Build 9
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
GETVER(SVRVER,SVRTVER,A)        ;
        ; We Can't compute the Server's current version
        ; KIDS installs aren't all related to the Delphi Client.
        ; The Server Version SVRVER needs hardcoded to match the Delphi Client.
        ; and This Routine must be distributed whenever a new Client is
        S SVRVER="3.0.96"
        S SVRTVER="4" ; This is the T version that the server expects
        ; released Client will have the T version that the server expects
        S A("3.0.24")=5         ;Sept 2003
        S A("3.0.33")=11        ;June 2004
        S A("3.0.8")=49         ;Sept 2004
        S A("3.0.42")=1         ;n/a
        S A("3.0.48")=6         ;Mar  2005
        S A("3.0.63")=4         ;June 2005
        S A("3.0.45")=8         ;Sept 2005
        S A("3.0.46")=28        ;Mar  2007
        S A("3.0.59")=31        ;Jul  2007
        S A("3.0.72")=21        ;Jan  2008
        S A("3.0.83")=24        ;Mar  2008
        S A("3.0.95")=5         ;Mar  2008
        S A("3.0.96")=4         ;Apr  2008
        Q
        ;
CHKVER(MAGRY,CLVER)     ;RPC [MAG4 VERSION CHECK]
        ; CLVER is the version of the Delphi Client.
        ; CLVER format = Major.Minor.Patch.T-version
        ; example : for Version 3.0 Patch 8 T 21 -->  CLVER=3.0.8.21
        ; Ver 2.5P9 (2.5.24.1) is first Delphi Ver that makes this call.
        ; CLVER may have Parameters attached to it in '|' pieces.
        ;           "CLVER|RIV"      this is a remote image view client
        ;           "CLVER|CAPTURE"  this is a Capture Client
        ;           "CLVER|DISPLAY"  this is a Display Client
        ; 3 possible return codes in 1st '^' piece of MAGRY(0).
        ; 0^message :   The Client will display the message and continue.
        ; 1^message :   The Client will continue without displaying any message.
        ; 2^message :   The Client will display the message and then Abort. (Terminate)
        ;    The message displayed is the 2nd '^' piece of (0) node
        ;    and all text of any other nodes. i.e. MAGRY(1..n)
        ;
        S CLVER=$G(CLVER)
        ; Bug in 42.  the Version comes in as 30.5.42.x  (42 wasn't released)
        I $P(CLVER,".",1)="30" S CLVER="3.0."_$P(CLVER,".",3,99)
        ;
        N PLC,SV,ST,SVSTAT,CV,CP,CT,OKVER,WARN,I,BETA
        ; PLC = Entry in 2006.1
        ; SV = Server Version -> (3.0.8) from (3.0.8.43) Hard coded to Sync with Delphi Clients
        ; ST = Server T Version -> 43 from full version (3.0.8.43)
        ; CV = Client Version sent from Client 3.0.8 same format as SV
        ; CT = Client T Version sent from Client i.e. 43 same format as ST
        ; OKVER = Array of Supported Versions, and Released T Version OKVER(3.0.48)=6
        ; WARN = 1|0 Boolean value determines if client needs EKG Warning.
        ;
        S PLC=$$PLACE^MAGBAPI($G(DUZ(2)))
        ;      Quit if we don't have a valid DUZ(2) or valid PLACE: ^MAG(2006.1,PLC)
        I 'PLC D BADPLC^MAGGTU41(.MAGRY) Q
        ;
        ;      Set up local variables.
        D GETVER(.SV,.ST,.OKVER)
        F I=2:1:$L(CLVER,"|") I $P(CLVER,"|",I)]"" S MAGJOB($P(CLVER,"|",I))=1
        S CLVER=$P(CLVER,"|",1)
        S CV=$P(CLVER,".",1,3),CP=$P(CLVER,".",3),CT=$P(CLVER,".",4)
        I CT="" S $P(CLVER,".",4)=0,CT=0
        ;      set WARN to indicate if Warning is needed or not.
        ;
        D NEEDWARN(.WARN)
        ;      Quit if site has VERSION CHECKING=0 (OFF) in Imaging Site Params File.
        I '$$VERCHKON(PLC) D  Q
        . S MAGRY(0)="1^Version Checking is OFF. Allowing All Versions"
        . ;      But, need to Display the warning, even if Version Checking is OFF
        . I WARN S MAGRY(0)="0^      =========== WARNING ===============" D WARNING
        . Q
        ;      If Remote Connection , allow it.
        I $D(MAGJOB("RIV")) S MAGRY(0)="1^Allowing Remote Image Connection" Q
        ;      Is this Server Version Alpha/Beta or Released.
        D VERSTAT(.SVSTAT,SV)
        I 'SVSTAT S MAGRY(0)="2^"_$P(SVSTAT,"^",2) Q  ; There is not record of a KIDS for this Server.
        ; Set Alpha Beta Flag
        S BETA=(+SVSTAT=2)
        ;      If Client isn't one of the Supported Clients.
        I (CV'=SV),'$D(OKVER(CV)) D  Q
        . I BETA D NOTOKB^MAGGTU41(.MAGRY) Q
        . D NOTOK^MAGGTU41(.MAGRY) Q
        . Q
        ;
        ;      Client is Supported. Only Warn if we are Not In ALPHA/BETA Testing.
        I (CV'=SV) D  Q
        . I CT<$G(OKVER(CV)) D  Q
        . . I BETA DO OKBADTB^MAGGTU41(.MAGRY) Q
        . . DO OKBADT^MAGGTU41(.MAGRY) Q
        . . Q
        . I BETA D OKB^MAGGTU41(.MAGRY)
        . E  D OK^MAGGTU41(.MAGRY)
        . I WARN D WARNING
        . Q
        ;
        ; At this point, Versions are the Same: If T versions are not, warn the Client.
        I CT,(CT'=ST) D  Q
        . I BETA D TNOTOKB^MAGGTU41(.MAGRY) Q
        . D TNOTOK^MAGGTU41(.MAGRY) Q
        . Q
        ; Client and Server Versions are the same, to the T. (Ha, get it)
        S MAGRY(0)="1^Version Check OK. Server: "_SV_" Client: "_CV Q
        Q
        ;
VERCHKON(PLC)   ; Is Version checking on for the site (Place)
        Q +$P(^MAG(2006.1,PLC,"KEYS"),"^",5)
        ;
NEEDWARN(WARN)  ; This call determines if Client needs the warning.
        S WARN=0 Q  ; we don't need warning anymore.
        I $P($G(^MAG(2006.1,PLC,"USERPREF")),U,2)="" S WARN=0 Q  ; Not a MUSE Site.
        I $D(MAGJOB("CAPTURE")) S WARN=0 Q  ;Not needed for Capture Clients
        I CV="3.0.59"    S WARN=0 Q  ; Client 59 has 63.
        I CV="3.0.45"    S WARN=0 Q  ; Client 45 has 63.
        I CV="3.0.41"    S WARN=0 Q  ; It is fixed in 41
        I CV="3.0.63"    S WARN=0 Q  ; It is fixed in 63
        I $P(CV,".",1)=2 S WARN=0 Q  ;Older Clients don't have the EKG Problem.
        I '$D(OKVER(CV)) S WARN=0 Q  ; Patch 3.0.7, 3.0.2 don't have EKG problem.
        S WARN=1 ; This means to Show the EKG Warning.
        Q
        ;
WARNING ; This is hard coded for the EKG Warning.
        ; Put Warning at the End of any Return Message.
        S MAGRY(1000)=" "
        S MAGRY(1010)="!*************************************************!"
        S MAGRY(1015)=" "
        S MAGRY(1020)="  PATIENT SAFETY NOTIFICATION"
        S MAGRY(1025)=" "
        S MAGRY(1030)="      Under certain circumstances, the EKG window will not"
        S MAGRY(1040)="refresh properly when you select a new patient in CPRS; "
        S MAGRY(1050)="instead of showing the new patient, the EKG window will "
        S MAGRY(1060)="continue to show the previous patient.   "
        S MAGRY(1065)="   "
        S MAGRY(1070)="To prevent this problem:"
        S MAGRY(1075)=" "
        S MAGRY(1080)="     Verify that the 'Show MUSE EKGs' option under"
        S MAGRY(1085)="     Options > View Preferences is checked;"
        S MAGRY(1090)="     OR"
        S MAGRY(1100)="     Do not minimize the Imaging Display window while viewing EKGs."
        S MAGRY(1110)="   "
        S MAGRY(1115)="This problem will be corrected shortly by Imaging Patch 63."
        S MAGRY(1120)="!*************************************************!"
        Q
VERSTAT(MAGRY,MAGVER)   ;RPC - [MAG4 VERSION STATUS]
        ; Returns the status of an Imaging Version
        ; Input :
        ;       MAGVER - Version number
        ;          in the format  MAG*3.0*59
        ;          or the format  3.0.59
        ; Return:
        ;       MAGRY =  0^There is No KIDs Install record
        ;                1^Unknown Release Status
        ;                2^Alpha/Beta Version
        ;                3^Released Version
        ;
        N VERI,TVER,MAGERR
        I +MAGVER S MAGVER="MAG*"_$P(MAGVER,".",1,2)_"*"_$P(MAGVER,".",3)
        S VERI=$$FIND1^DIC(9.6,"","MO",MAGVER,"","","MAGERR")
        I 'VERI S MAGRY="0^There is No KIDs Install record for """_MAGVER_"""." Q
        S TVER=$$GET1^DIQ(9.6,VERI_",","ALPHA/BETA TESTING")
        I TVER="YES" S MAGRY="2^Alpha/Beta Version." Q
        I TVER="NO" S MAGRY="3^Released Version." Q
        S MAGRY="1^Unknown Release Status."
        Q
ABSJB(MAGRY,MAGIN)      ;RPC [MAG ABSJB] SET ABSTRACT AND/OR JUKEBOX QUEUES
        D ABSJB^MAGGTU71(.MAGRY,.MAGIN)
        Q
