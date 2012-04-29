MAGJUTL3        ;WIRMFO/JHC VistARad subrtns & RPCs ; 29 Jul 2003  10:03 AM
        ;;3.0;IMAGING;**16,9,22,18,65,76**;Jun 22, 2007;Build 19
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
        ;RPC Entry points:
        ; LISTINF--Custom list info
        ; LOGOFF--update session file
        ; CACHEQ--init session data
        ; PINF1--Patient info
        ; USERINF2--P18 inits for the session
        ;Subrtn EPs:
        ; LOG--Upd image access log
        ; MAGJOBNC--inits for non-client sessions
        ; USERKEYS--user key info
        ; USERINF--user info
        ;
LISTINF(MAGGRY) ; RPC: MAGJ CUSTOM LISTS
        ;  get Exam List data
        ; Return in ^TMP($J,"MAGJLSTINF",0:N)
        ;     0)= # Entries below (0:n)
        ;   1:n)= Button Label^List #^Button Hints^List Type
        ;
        ; MAGGRY holds $NA ref to ^TMP for return message
        ;   all refs to MAGGRY use SS indirection
        ;
        ; GLB has $NA ref to ^MAG(2006.631), Custom Lists
        ;   refs to GLB use SS indirection to get data from this file
        ;
        S X="ERR1^MAGJUTL3",@^%ZOSF("TRAP")
        N D0,GLB,INF,MAGLST,NAM,T
        S MAGLST="MAGJLSTINF"
        K MAGGRY S MAGGRY=$NA(^TMP($J,MAGLST)) K @MAGGRY S @MAGGRY@(0)=0
        S GLB=$NA(^MAG(2006.631)),NAM=""
        F  S NAM=$O(@GLB@("B",NAM)) Q:NAM=""  S D0="" D
        . S D0=$O(@GLB@("B",NAM,D0)) Q:'D0  D
        . . S X=$G(@GLB@(D0,0)) Q:($P(X,U,2)>9000)!'$P(X,U,6)  ; List Active & User-defined
        . . S INF="" F I=1:1 S T=$P("7^2^1^3",U,I) Q:T=""  S Y=$P(X,U,T) Q:Y=""  S $P(INF,U,I)=Y
        . . Q:T'=""  ; req'd fields not all there
        . . S T=@MAGGRY@(0)+1,^(0)=T,^(T)=INF ; add entry to reply
        Q
        ;
LOG(ACTION,LOGDATA)     ; Log exam access
        N PTCT,TXT,RADFN,MAGIEN,NIMGS,REMOTE
        S RADFN=$P(LOGDATA,U),MAGIEN=$P(LOGDATA,U,2),NIMGS=$P(LOGDATA,U,3),REMOTE=$P(LOGDATA,U,4)
        I ACTION="" S ACTION="UNKNOWN"  ; Should never happen
        S PTCT=RADFN'=$G(MAGJOB("LASTPT",ACTION))
        I PTCT S MAGJOB("LASTPT",ACTION)=RADFN
        S TXT=ACTION_U_RADFN_U_MAGIEN_U_U_U_NIMGS
        S TXT=TXT_U_PTCT_U_$S(+MAGJOB("USER",1):1,1:0)_U_REMOTE
        ; Session Log
        D ACTION^MAGGTAU(TXT,1)
        ; Mag Log
        I REMOTE S ACTION=ACTION_"/REM"
        D ENTRY^MAGLOG(ACTION,+DUZ,MAGIEN,"VRAD:"_MAGJOB("VRVERSION"),RADFN,NIMGS)
        Q
        ;
LOGOFF(MAGGRY,DATA)     ; RPC: MAGJ LOGOFF
        ; update session file: logoff time & session entry closed
        D LOGOFF^MAGGTAU(.MAGGRY)
        Q
        ;
CACHEQ(MAGGRY,DATA)     ; RPC: MAGJ CACHELOCATION
        ; some logon inits & get alternate paths for Remote Reading
        ; input in DATA:
        ;  - WSLOC   = WS Loc'n
        ;  - VRADVER = Client Vs -- p32 ONLY
        ;  - OSVER   = Client OS Vs -- p32 ONLY
        ; Return in ^TMP($J,"MAGJCACHE",0:N) (@MAGGRY)
        ;     0)= # Entries below (0:n)
        ;   1:n)= PhysName^Subdirectory^HashFlag^Username^Password^AltPath_IEN
        ;
        ; MAGGRY holds $NA reference to ^TMP for return message
        ;   refs to MAGGRY use SS indirection
        ;
        ; Also builds local array:  p32/p18 compatibility: Some of this is moved to userinf2 below
        ;  MAGJOB("LOC",NetworkLocnIEN)=Site Abbrev
        ;     ("REMOTE")=1/0  (T/F for "User is Remote")
        ;     ("REMOTESCREEN")=0/1  (init User-switchable Remote Screening--P18 use only)
        ;     ("WSLOC")=WS Loc'n String
        ;     ("WSLOCTYP")=WS Loc'n Type
        ;     ("WSNAME")=WS ID
        ;     ("VRVERSION")=VRAD Vs
        ;     ("OSVER")=O/S Vs
        ;     ("ALTPATH")=1/0 ^ 1/0 (T/F Alt Paths are defined
        ;               ^ Alt Paths Enabled/Disabled for most recent exam)
        ;
        S X="ERR1^MAGJUTL3",@^%ZOSF("TRAP")
        ;
        N I,MAGLST,REPLY,TMP,WSLOC,XX,VRADVER,OSVER,DIQUIET,ALTIEN
        S DIQUIET=1 D DT^DICRW
        S REPLY=0,MAGLST="MAGJCACHE"
        K MAGGRY S MAGGRY=$NA(^TMP($J,MAGLST)) K @MAGGRY
        S WSLOC=$P(DATA,U),VRADVER=$P(DATA,U,2),OSVER=$P(DATA,U,3)
        I '$D(MAGJOB("OSVER")) D  ; ID p32 initialization
        . S MAGJOB("OSVER")=$S(OSVER]"":OSVER,1:"UNK")
        . S MAGJOB("VRVERSION")=$S(VRADVER]"":VRADVER,1:"UNK")
        . D MAGJOB ; p32 init of VRAD
        ; get alt paths location info
        S MAGJOB("WSLOC")=WSLOC,MAGJOB("REMOTE")=0
        S MAGJOB("REMOTESCREEN")=+$P($G(^MAG(2006.69,1,0)),U,10)
        I WSLOC]"" D
        . S X=$P($G(^MAG(2006.1,+MAGJOB("SITEP"),0)),U,9)
        . I X]"",(X'=WSLOC) S MAGJOB("REMOTE")=1
        . E  Q
        . D LIST^MAGBRTLD(WSLOC,.TMP)
        . I TMP S REPLY=TMP,MAGJOB("ALTPATH")=$G(MAGJOB("ALTPATH"),"1^1") F I=1:1:TMP D
        . . S ALTIEN=$P(TMP(I),U,7)
        . . S XX=$P(TMP(I),U,1,5),X=$P(XX,U,3),$P(XX,U,3)=$S(X="Y":1,1:0)
        . . S X=$P(XX,U,4),$P(XX,U,4)=$P(XX,U,5),$P(XX,U,5)=X,$P(XX,U,6)=ALTIEN
        . . S @MAGGRY@(I)=XX,MAGJOB("LOC",ALTIEN)=$P(TMP(I),U,6)
        I '$D(MAGJOB("ALTPATH")) S MAGJOB("ALTPATH")="0^0"
        S @MAGGRY@(0)=REPLY
CACHEQZ Q
        ;
MAGJOBNC        ; EP for Prefetch/Bkgnd calls (NOT a Vrad Client)
        N NOTCLIEN S NOTCLIEN=1
        D MAGJOB
        Q
        ;
MAGJOB  ; Init magjob array
        N T,RIST
        I $G(MAGJOB("VRVERSION")) S X=MAGJOB("VRVERSION")
        E  S X="" ; non-client processes assume post-P32 logic
        S MAGJOB("P32")=(X="3.0.41.17") ; P32 Client?
        I MAGJOB("P32") D P32STOP^MAGJUTL5(.X) S MAGJOB("P32STOP")=X  ; STOP support when P76 releases
        D USERKEYS
        S MAGJOB("CONSOLIDATED")=($G(^MAG(2006.1,"CONSOLIDATED"))="YES")
        S MAGJOB("SITEP")=$$IMGSIT^MAGJUTL1(DUZ(2),1)  ; Site Param ien
        S RIST="" F X="S","R" I $D(^VA(200,"ARC",X,DUZ)) S RIST=X Q
        S RIST=$S(RIST="S":15,RIST="R":12,1:0) ; Staff/Resident/Non rist
        S MAGJOB("USER",1)=RIST_U_$$USERINF(+DUZ,".01;1") ; RIST_Type^NAME^INI
        S X=$P($G(IO("CLNM")),"."),MAGJOB("WSNAME")=$S(X]"":X,1:"VistaradWS")
        K MAGJOB("DIVSCRN") I MAGJOB("CONSOLIDATED") D
        . ; include logon DIV, other DIVs to screen Unread Lists & Locking
        . I $G(DUZ(2))]"" S MAGJOB("DIVSCRN",DUZ(2))=""
        . S DIV=""
        . I DUZ(2)'=$P(MAGJOB("SITEP"),U,3) D  ; Assoc DIV
        . . S IEN=$O(^MAG(2006.1,+MAGJOB("SITEP"),"INSTS","B",DUZ(2),0))
        . . I IEN F  S DIV=$O(^MAG(2006.1,+MAGJOB("SITEP"),"INSTS",IEN,201,"B",DIV)) Q:'DIV  S MAGJOB("DIVSCRN",DIV)=""
        . E  D  ; Parent DIV
        . . F  S DIV=$O(^MAG(2006.1,+MAGJOB("SITEP"),201,"B",DIV)) Q:'DIV  S MAGJOB("DIVSCRN",DIV)=""
        S MAGJOB("WSLOCTYP")=$S(+MAGJOB("USER",1):"RAD",1:"Non-Rad") ; USer is Rist/Not
        I '$D(MAGJOB("WRKSIEN")) D
        . Q:+$G(NOTCLIEN)  ; proceed only if Vrad Client is attached
        . S X=MAGJOB("WSNAME")_"^^^"_MAGJOB("WSLOCTYP")_U_U_U_U_1_U_MAGJOB("OSVER")_U_MAGJOB("VRVERSION")
        . D UPD^MAGGTAU(.Y,X)
        . D REMLOCK^MAGJEX1B ; put here to only run 1x/ login
        Q
        ;
USERINF(DUZ,FLDS)       ; get data from user file
        I FLDS=""!'DUZ Q ""
        N I,RSL,T S RSL=""
        D GETS^DIQ(200,+DUZ,FLDS,"E","T")
        S T=+DUZ_","
        F I=1:1:$L(FLDS,";") S RSL=RSL_$S(RSL="":"",1:U)_T(200,T,$P(FLDS,";",I),"E")
        Q RSL
        ;
USERKEYS        ; Store Security Keys in MagJob
        N I,X,Y
        N MAGKS ; keys to send to XUS KEY CHECK
        N MAGKG ; returned
        K MAGJOB("KEYS")
        S X="MAGJ",I=0
        F  S X=$O(^XUSEC(X)) Q:$E(X,1,4)'="MAGJ"  D
        . S I=I+1,MAGKS(I)=X
        I '$D(MAGKS) Q
        D OWNSKEY^XUSRB(.MAGKG,.MAGKS)
        S I=0 F  S I=$O(MAGKG(I)) Q:'I  I MAGKG(I) S MAGJOB("KEYS",MAGKS(I))=""
        Q
        ;
PINF1(MAGGRY,MAGDFN)    ;RPC Call MAGJ PT INFO -- Get pt info
        S X="ERR3^MAGJUTL3",@^%ZOSF("TRAP")
        D INFO^MAGGTPT1(.MAGGRY,MAGDFN_"^1") ; 1=Don't log to session file
        Q
        ;
USERINF2(MAGGRY,DATA)   ; rpc: MAGJ USER2--get user info
        ; Input= unused ^ Client Vs ^ Client O/S Vs
        ; Reply=
        ; 0) = 1/0^code~Msg |  DUZ ^ NAME ^ INITIALS ^ REQFLAG
        ; 1)= Net UserName ^ PSW ^ UserType ^ SYSADMIN
        ;     1/0=Success/Fail flag for vs chk
        ;     code=4 if fail
        ;     Msg=Disp msg if fail
        ;     REQFLAG = 1/0 (Ena/Disa Requisition for non-rad staff)
        ;     UserType = 3: Staff R'ist; 2: Resident R'ist; 1: Rad Tech; 0: Non-Rad
        ;     SYSADMIN = 1/0 1=user has System User privileges
        ; 2:N)=Sec Keys
        ;
        S X="ERR2^MAGJUTL3",@^%ZOSF("TRAP")
        K MAGGRY S MAGGRY(0)="",MAGGRY(1)=""
        I +$G(DUZ)=0 S MAGGRY(0)="0^4~DUZ Undefined, Null or Zero|" Q
        N I,J,K,Y,REQ,VRADVER,OSVER,RADTECH,PLACE,REPLY
        S VRADVER=$P(DATA,U,2),OSVER=$P(DATA,U,3)
        D CHKVER^MAGJUTL5(.REPLY,VRADVER,.PLACE,.SVERSION)
        I 'REPLY S MAGGRY(0)=REPLY_"|^^^^",MAGGRY(1)="^^^" G USERIN2Z ; Version check or PLACE failed
        S RADTECH=""
        S MAGJOB("OSVER")=$S(OSVER]"":OSVER,1:"UNK")   ; IDs P18 initialization; cf cacheq ep above
        S MAGJOB("VRVERSION")=$S(VRADVER]"":VRADVER,1:"UNK")
        S MAGJOB("VSVERSION")=SVERSION
        D MAGJOB
        ; Enable/Disable Requisition if not a radiology user
        S REQ=1
        I 'MAGJOB("USER",1) D  ; not a rist
        . I $D(^VA(200,"ARC","T",+DUZ)) S RADTECH=1 Q  ; Rad Tech OK
        . S X=+$P($G(^MAG(2006.69,1,0)),U,16)
        . I X S REQ=0 ; Disable Req
        S MAGGRY(0)=REPLY_"|"_DUZ_U_$$GET1^DIQ(200,DUZ_",",.01)_U_$$GET1^DIQ(200,DUZ_",",1)_U_REQ_U_SVERSION
        ; Network UserName and PSW
        S MAGGRY(1)=$P($G(^MAG(2006.1,PLACE,"NET")),U,1,2)
        S X=+MAGJOB("USER",1),X=$S(X=15:3,X=12:2,+RADTECH:1,1:0)
        S MAGGRY(1)=MAGGRY(1)_U_X_U_$D(MAGJOB("KEYS","MAGJ SYSTEM USER"))
        S MAGGRY(2)="*KEYS",X="" F I=3:1 S X=$O(MAGJOB("KEYS",X)) Q:X=""  S MAGGRY(I)=X
        S MAGGRY(I)="*END"
USERIN2Z        Q
        ;
ERR1    N ERR S ERR=$$EC^%ZOSV S @MAGGRY@(0)="0^4~"_ERR G ERR
ERR2    N ERR S ERR=$$EC^%ZOSV S MAGGRY(0)="0^4~"_ERR G ERR
ERR3    N ERR S ERR=$$EC^%ZOSV S MAGGRY="0^4~"_ERR
ERR     D @^%ZOSF("ERRTN")
        Q:$Q 1  Q
        ;
END     Q  ;
