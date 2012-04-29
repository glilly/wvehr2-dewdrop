MAGGTAU ;WOIFO/GEK - RPC Calls to Update the Imaging Windows Workstation file ; [ 03/25/2001 11:20 ]
        ;;3.0;IMAGING;**7,16,8,59**;Nov 27, 2007;Build 20
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
        ;; | a medical device.  As such, it may not be changed             |
        ;; | in any way.  Modifications to this software may result in an  |
        ;; | adulterated medical device under 21CFR820, the use of which   |
        ;; | is considered to be a violation of US Federal Statutes.       |
        ;; +---------------------------------------------------------------+
        ;;
        Q
UPD(MAGRY,DATA) ;RPC [MAGG WRKS UPDATES]
        ; Called after User login. Local and RIV.
        ; Updates information in the IMAGING WINDOWS WORKSTATION
        ;
        ; DATA is '^' delimited piece
        ; 1 Workstation name            2 Date/Time of capture app.
        ; 3 Date/Time of Display App.
        ; 4 Location of workstation      5 Date/Time of MAGSETUP
        ; 6 Version of Display          7 Version of Capture
        ; 8  1=Normal startup 2=Started by CPRS 3=Import API
        ; 9 OS Version                 10 VistaRad Version
        ; 11 RPCBroker Server    12 RPCBroker Port
        N X,Y,Z
        N MAGNAME,MAGCDT,MAGDDT,MAG0,MAGLOC,MAGIEN,MAGSETUP,MAGSTART,MAGSRV
        N MAGVERSD,MAGVERSC,MAGMODE,MAGOSVER,MAGVERVR,MAGPL,MAGVERX
        K MAGGFDA,MAGXERR,MAGXIEN
        S MAGNAME=$P(DATA,U,1)
        S MAGCDT=$P(DATA,U,2)
        S MAGDDT=$P(DATA,U,3)
        S MAGLOC=$P(DATA,U,4)
        S MAGSETUP=$P(DATA,U,5)
        S MAGVERSD=$P(DATA,U,6)
        I MAGVERSD S MAGJOB("DISPLAY")=""
        S MAGVERSC=$P(DATA,U,7)
        I MAGVERSC S MAGJOB("CAPTURE")=""
        S MAGMODE=$P(DATA,U,8)
        S MAGOSVER=$P(DATA,U,9)
        S MAGVERVR=$P(DATA,U,10)
        I $P(DATA,U,11)]"" S MAGJOB("RPCSERVER")=$P(DATA,U,11)
        I $P(DATA,U,12)]"" S MAGJOB("RPCPORT")=$P(DATA,U,12)
        S MAGIEN=0
        I $L(MAGNAME) S MAGIEN=$O(^MAG(2006.81,"B",MAGNAME,""))
        I 'MAGIEN D NEWWRKS(MAGNAME,MAGLOC,.MAGIEN)
        I MAGIEN<1 S MAGRY="0^Workstation Not on file" Q
        ;
        S %DT="T",X=MAGCDT D ^%DT S MAGCDT=Y
        S %DT="T",X=MAGDDT D ^%DT S MAGDDT=Y
        S %DT="T",X=MAGSETUP D ^%DT S MAGSETUP=Y
        S MAG0=^MAG(2006.81,MAGIEN,0) ; '0' node for use later.
        L +^MAG(2006.81,"LOCK",MAGIEN):0
        S MAGIEN=+MAGIEN_","
        S MAGGFDA(2006.81,MAGIEN,.01)=MAGNAME ; Computer Name
        I MAGCDT>-1 S MAGGFDA(2006.81,MAGIEN,4)=MAGCDT ;TELE19N.EXE dttm
        I MAGDDT>-1 S MAGGFDA(2006.81,MAGIEN,5)=MAGDDT ;IMGVWP10.EXE dttm
        I MAGSETUP>-1 S MAGGFDA(2006.81,MAGIEN,7)=MAGSETUP ; MAGSETUP.EXE dttm
        S MAGGFDA(2006.81,MAGIEN,8)=1 ; Active or not.
        S MAGGFDA(2006.81,MAGIEN,6)=MAGLOC ; location free text from .INI
        S MAGGFDA(2006.81,MAGIEN,3)="@" ; delete logoff time for this job.
        S MAGGFDA(2006.81,MAGIEN,10)="@" ; delete session pointer
        S MAGGFDA(2006.81,MAGIEN,11)="@" ; reset the session error count.
        S MAGGFDA(2006.81,MAGIEN,9)=MAGVERSD ; IMGVWP10.EXE Version Info
        S MAGGFDA(2006.81,MAGIEN,9.5)=MAGVERSC ; TELE19N.EXE Version Info
        S MAGGFDA(2006.81,MAGIEN,9.7)=MAGVERVR ; VistARad.EXE Version Info
        S MAGGFDA(2006.81,MAGIEN,13)=MAGOSVER ; Operating System Version.
        ;
        S X=$P(MAG0,U,12)
        S MAGGFDA(2006.81,MAGIEN,12)=X+1 ; Sess count for wrks.
        ; Keep PLACE that this wrks logged in.
        S MAGPL=0 I $D(DUZ(2)) S MAGPL=+$$PLACE^MAGBAPI(DUZ(2)) ; DBI
        I MAGPL S MAGGFDA(2006.81,MAGIEN,.04)=MAGPL ; DBI
        ;
        S X=$$NOW^XLFDT
        S MAGSTART=$E(X,1,12)
        I $G(DUZ) D
        . S MAGGFDA(2006.81,MAGIEN,1)=DUZ
        . S MAGGFDA(2006.81,MAGIEN,2)=MAGSTART
        ;
        D UPDATE^DIE("S","MAGGFDA","MAGXIEN","MAGXERR")
        I $D(DIERR) D RTRNERR(.MAGRY) Q
        ; The MAGJOB( array is used by Imaging routines that are
        ; called from the Delphi App.
        ;
        ; 3.0.8 Whatever App calls this, we'll use that Version number.
        S MAGVERX=$S(MAGVERSD]"":MAGVERSD,MAGVERSC]"":MAGVERSC,MAGVERVR]"":MAGVERVR,1:0)
        S MAGJOB("WRKSIEN")=+MAGIEN
        S MAGJOB("VERSION")=MAGVERX
        S MAGRY="1^"
        ;
        ; SESSION : Create new session entry
        D GETS^DIQ(200,DUZ_",","29","I","Z","") ; service/section
        S MAGSRV=$G(Z(200,DUZ_",",29,"I"))
        ;
        K MAGGFDA,MAGXERR,MAGXIEN
        S MAGGFDA(2006.82,"+1,",.01)=$P(^VA(200,DUZ,0),U,1) ; User
        S MAGGFDA(2006.82,"+1,",1)=DUZ ; USER
        S MAGGFDA(2006.82,"+1,",2)=MAGSTART ; Sess Start Time
        S MAGGFDA(2006.82,"+1,",4)=+MAGIEN ; Wrks
        S MAGGFDA(2006.82,"+1,",7)=+MAGSRV ; User's Service/Section
        S MAGGFDA(2006.82,"+1,",13)=MAGMODE ; 1=normal 2= started by CPRS
        ; DBI - save the logon PLACE in the Session file.
        I MAGPL S MAGGFDA(2006.82,"+1,",.04)=MAGPL ; User's Institution (Imaging site param entry)
        ;
        ;3.0.8  new fields 9 Client Ver, 9.2 Host Version, 9.4 OS Version
        S MAGGFDA(2006.82,"+1,",9)=MAGVERX ;
        S MAGGFDA(2006.82,"+1,",9.2)=$$VERSION^XPDUTL("IMAGING") ;
        S MAGGFDA(2006.82,"+1,",9.4)=MAGOSVER ;
        ;
        D UPDATE^DIE("","MAGGFDA","MAGXIEN","MAGXERR")
        I $D(DIERR) D RTRNERR(.MAGRY) Q
        S MAGRY="1^"
        I '+MAGXIEN(1) S MAGRY="0^" Q
        S MAGJOB("SESSION")=+MAGXIEN(1)
        S MAGRY=MAGJOB("SESSION")_"^Session # "_MAGJOB("SESSION")_" Started."
        S MAGGFDA(2006.81,+MAGIEN_",",10)=+MAGXIEN(1)
        D UPDATE^DIE("","MAGGFDA","MAGXIEN","MAGXERR")
        D ACTION("LOGON^")
        Q
LOGACT(MAGRY,ACTION)    ;RPC [MAG3 LOGACTION]
        ; Call to log actions for Imaging Session from
        ; Delphi interface
        D ACTION(ACTION)
        S MAGRY="1^Action Logged"
        Q
ACTION(TXT,LOGTM,MAGSESS)       ;Call to log actions for Imaging Workstation Session from other M routines
        ; ACTIONS LOGGED
        ; LOGON - Session StartTime     LOGOFF - Session End Time
        ; IMG   - Image accessed        PAT    - Patient Accessed
        ; CAP   - Image Captured
        ; DEL   - Image Deleted         MOD    - Image entry modified
        ; IMPORT - Import API has been called
        ; Data   - a node of data passed to Import API
        ; Result - a node of the Result Array from Import API Processing.
        ; Image  - one of the Images (full path of import directory) that was imported.
        ; PPACT  - A Post processing Action has been processed.
        ; VR-VW  - VistaRad Exam displayed
        ; VR-INT - VistaRad Exam interpreted
        ; API   - parameters sent to CP API, and the API Call i.e. ITIU-MDAPI
        ; DFTINDX- If the index fields have no values, call to Patch 17 code to
        ;               generate the values for the fields.
        ; MOD   - This was intended to log Modifications to Image Entries, it is
        ;         (for now) only called when a group entry has an image added to its multiple.
        ;
        ; TXT is "^" delimited string
        ; $P(1) is code ( see above )   $P(2) is DFN
        ; $P(3) is Image IEN            $P(4) reserved for procedure
        ; $P(5) reserved for time-stamp $P(6) is Vrad Image Count
        ; $P(7) is Vrad Patient Count
        ; $P(8) is Vrad User Type (1/0 = Rad/Non-Rad)
        ; $P(9) is Vrad REMOTE Read flag (1/0; 1=REMOTE)
        ; $P(TXT,"$$",2) is Tracking ID from an Imported Image.  From this we compute Session #, to log actions.
        ; LOGTM   - [1|0] Flag to indicate whether or not to log the time of the Action.  Default = 0
        ; MAGSESS - Session IEN where the action should be logged.  Default to MAGJOB("SESSION")
        ;
        N NODE,SESSIEN,MAGGFDA,MAGXERR,MAGXIEN,MAGPROC,LOGX,TRKID
        S LOGTM=$G(LOGTM)
        I TXT["$$" S TRKID=$P(TXT,"$$",2),TXT=$P(TXT,"$$",1)
        S SESSIEN=$S($G(MAGSESS):MAGSESS,$D(MAGJOB("SESSION")):MAGJOB("SESSION"),$G(TRKID)'="":$O(^MAG(2006.82,"E",TRKID,""),-1),1:0)
        I 'SESSIEN Q
        S NODE="+1,"_SESSIEN_","
        I $P(TXT,U,3) S MAGPROC=$P($G(^MAG(2005,$P(TXT,U,3),0)),U,8)
        ;
        I $P(TXT,U)="PAT" D
        . S Z=+$G(^MAG(2006.82,SESSIEN,1))+1
        . S MAGGFDA(2006.82,SESSIEN_",",10)=Z
        I $P(TXT,U)="IMG" D
        . S Z=+$P($G(^MAG(2006.82,SESSIEN,1)),U,2)+1
        . S MAGGFDA(2006.82,SESSIEN_",",11)=Z
        . D ENTRY^MAGLOG("IMGVW",DUZ,$P(TXT,"^",3),"Wrks",$P(TXT,"^",2),"1")
        . D ACCESS^MAGLOG($P(TXT,"^",3))
        I $E(TXT,1,3)="CAP" D
        . S Z=+$P($G(^MAG(2006.82,SESSIEN,1)),U,3)+1
        . S MAGGFDA(2006.82,SESSIEN_",",12)=Z
        . D ENTRY^MAGLOG("CAP",DUZ,$P(TXT,"^",3),"Wrks",$P(TXT,"^",2),"1")
        I $P(TXT,U,2) D
        . S MAGGFDA(2006.82,SESSIEN_",",5)=$P(TXT,U,2)
        I LOGTM D
        . S X=$$NOW^XLFDT
        . S $P(TXT,U,4)=$G(MAGPROC),$P(TXT,U,5)=$E(X,1,12)
        S MAGGFDA(2006.821,NODE,.01)=$P(TXT,"|",1)
        I $L(TXT,"|")>1 S MAGGFDA(2006.821,NODE,13)=$P(TXT,"|",2,99)
        D UPDATE^DIE("S","MAGGFDA","MAGXIEN","MAGXERR")
        Q
NEWWRKS(MAGNAME,MAGLOC,MAGIEN)  ;
        I $G(MAGNAME)="" Q
        N Y,MAGNFDA,MAGNIEN
        S MAGNFDA(2006.81,"+1,",.01)=MAGNAME
        S MAGNFDA(2006.81,"+1,",6)=$G(MAGLOC)
        D UPDATE^DIE("","MAGNFDA","MAGNIEN")
        S MAGIEN=MAGNIEN(1)
        Q
LOGOFF(MAGRY)   ;RPC [MAGG LOGOFF] Call when session is over.
        ; This updates session file with logoff time
        ;   and marks the session closed.
        ;
        S MAGRY=1
        N MAGGFDA,MAGXERR,MAGXIEN,MAGIEN,MAGSESS,MAGEND,MAGCON
        ; The Imaging Workstation file keeps time of login
        ; We'll enter the logoff time ($$now^xlfdt) here.
        S X=$$NOW^XLFDT
        S MAGEND=$E(X,1,12)
        Q:'+$G(MAGJOB("WRKSIEN"))
        L -^MAG(2006.81,"LOCK",MAGJOB("WRKSIEN"))
        S MAGIEN=+MAGJOB("WRKSIEN")_","
        S MAGGFDA(2006.81,MAGIEN,3)=MAGEND ; logoff dttm
        S MAGGFDA(2006.81,MAGIEN,8)=0 ; Set job number to 0
        D UPDATE^DIE("S","MAGGFDA","MAGXIEN","MAGXERR")
        ;MAGJOB("WRKSIEN")
        Q:(+$G(MAGJOB("SESSION"))=0)
        S MAGSESS=+MAGJOB("SESSION")_","
        K MAGGFDA,MAGXERR,MAGXIEN
        S MAGGFDA(2006.82,MAGSESS,3)=MAGEND
        ; calculate the length of the session
        S MAGCON=""
        S MAGGFDA(2006.82,MAGSESS,14)=MAGCON
        D UPDATE^DIE("S","MAGGFDA","MAGXIEN","MAGXERR")
        D ACTION("LOGOFF^")
        ;
        Q
RTRNERR(ETXT)   ; There was error from UPDATE^DIE quit with error text
        S ETXT="0^ERROR  "_MAGXERR("DIERR",1,"TEXT",1)
        Q
