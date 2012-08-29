MAGJPRF1 ;WIRMFO/JHC VistaRad RPCs-User Prefs ; 05 May 2004  10:05 AM
 ;;3.0;IMAGING;**18**;Mar 07, 2006
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
ERR N ERR S ERR=$$EC^%ZOSV S @MAGGRY@(0)="0^4~"_ERR
 D @^%ZOSF("ERRTN")
 Q:$Q 1  Q
 ;
RPCIN(MAGGRY,PARAMS,DATA) ; RPC: MAGJ USER DATA
 ;PARAMS: TXID ^ SYSUPDAT ^ TXDUZ ^ TXDIV
 ;TXID: Req'd--action to take; see below
 ;TXDUZ: Opt; if input, get data for another user
 ;TXDIV: Opt; if input, get data for another div
 ;SYSUPDAT: Opt; if input, save Sys Default data; Sec Key Req'd
 ; DATA--(opt) input array; depends on TXID; see subs by TXID
 ;Pattern for DATA input & reply is:
 ;*LABEL ; Start for one label
 ;Label_Name     ; label name
 ;(1:N lines of XML text follow)
 ;*END           ; end for label
 ;*LABEL ; Start for next label (etc.)
 ;Label_Name_2
 ;*KEY           ; index keys to follow (KEY data is opt)
 ;KeyNam1=nnn     ; 1st key (free-text)
 ;KeyNam2=jjj    ; 2nd key (etc.)
 ;*END_KEY       ; end of keys
 ; (1:N lines of XML text follow)
 ;*END           ; end for label
 ;
 N $ETRAP,$ESTACK S $ETRAP="D ERR^MAGJPRF1"
 N GPREF,MAGLST,PREFIEN,REPLY,TXTYPE,PDIV,TXDUZ,TXID,TXDIV,READONLY,SYSUPDAT
 S TXID=+PARAMS,SYSUPDAT=+$P(PARAMS,U,2),TXDUZ=$P(PARAMS,U,3),TXDIV=+$P(PARAMS,U,4)
 S MAGLST="MAGJRPC" K MAGGRY S MAGGRY=$NA(^TMP($J,MAGLST)) K @MAGGRY
 S DIQUIET=1 D DT^DICRW
 ; no updates allowed if read another user's data, or get data for another logon division
 I 'TXDUZ,(TXDUZ="sysAdmin") S TXDUZ=$$SYSUSER()
 I 'TXDUZ S TXDUZ=DUZ
 I 'TXDIV S TXDIV=DUZ(2)
 S READONLY=(TXDUZ'=DUZ)
 ; I 'READONLY S READONLY=(TXDIV'=DUZ(2)) ; <*> ?? Put this check inside Div-sensitive operations <*>
 I READONLY,$D(MAGJOB("KEYS","MAGJ SYSTEM USER")),SYSUPDAT,(TXDUZ=$$SYSUSER()) S READONLY=0 ; get/update SysDefault data
 S PREFIEN=$$GETPRIEN(TXDUZ,READONLY)
 I 'PREFIEN S REPLY="0~Unable to get/update user data ("_$$USER(TXDUZ)_") for MAGJ USER DATA rpc call." G RPCINZ
 ; set this level based on the TXID
 S TXID=+$G(TXID)
 ;
 S TXTYPE="VR-WS",GPREF=$NA(^MAG(2006.68,PREFIEN,TXTYPE)),PDIV=""
 ; workstation settings, user preferences, etc.
 I TXID=1 G:'READONLY SAVE S REPLY="Access for updating preferences denied." G RPCINZ  ; Store prefs by label
 I TXID=2 G TAGS    ; Get Labels w/ assoc. Keys
 I TXID=3 G PRFDATA ; Get pref data for labels
 I TXID=4 G:'READONLY TAGDEL S REPLY="Access for deleting preferences denied." G RPCINZ  ; Delete labels
 I TXID=6 G USERS  ; Get list of vrad users, including SysAdmin
 ; 
 S TXTYPE="VR-HP",GPREF=$NA(^MAG(2006.68,PREFIEN,TXTYPE)),PDIV=""  ; Hanging Protocols
 I TXID=11 G:'READONLY SAVE S REPLY="Access for updating Hanging Protocols denied." G RPCINZ  ; Store HP by label
 I TXID=12 G TAGS    ; Get HP Labels
 I TXID=13 G PRFDATA ; Get data for HP labels
 I TXID=14 G:'READONLY TAGDEL S REPLY="Access for deleting Hanging Protocol denied." G RPCINZ  ; Delete HP labels
 ; 
 E  S REPLY="0~Invalid transaction (TX="_TXID_") requested by MAGJ USER DATA rpc call."
RPCINZ S @MAGGRY@(0)=0_U_REPLY
 Q
 ;
GETPRIEN(DUZ,READONLY) ; Lookup/create User Pref entry for input DUZ
 ; READONLY: True for lookup-only (no create)
 N T,X,PREFIEN
 S PREFIEN=$O(^MAG(2006.68,"AC",+DUZ,"")) I 'PREFIEN,'READONLY D
 . L +^MAG(2006.68,0):10
 . E  Q
 . S X=$G(^MAG(2006.68,0))
 . S PREFIEN=+$P(X,U,3)
 . F  S PREFIEN=PREFIEN+1 I '$D(^MAG(2006.68,PREFIEN)) Q
 . S T=$P(X,U,4)+1,$P(X,U,3)=PREFIEN,$P(X,U,4)=T
 . S ^MAG(2006.68,0)=X
 . S T=$$USER(+DUZ),^MAG(2006.68,PREFIEN,0)=$P(T,U)_U_+DUZ_U_$P(T,U,3)
 . S ^MAG(2006.68,"B",$P(T,U),PREFIEN)=""
 . S ^MAG(2006.68,"AC",+DUZ,PREFIEN)=""
 . L -^MAG(2006.68,0)
 Q PREFIEN
 ;
SAVE ;  Save User Pref data by Label
 N NEWTAG,STUFF,LINCT,LBLCT,DUMMY,KEYS
 S NEWTAG=0,STUFF=0,LINCT=0,LBLCT=0,DUMMY=0,KEYS=0
 S IDATA=""
 F  S IDATA=$O(DATA(IDATA)) Q:IDATA=""  S LINE=DATA(IDATA) I LINE]"" D
 . I LINE="*LABEL" S NEWTAG=1,STUFF=0 Q
 . I LINE="*END" S NEWTAG=0,STUFF=0 Q
 . I NEWTAG S TAG=LINE D TAGINIT(TAG) Q  ; Init the storage for this tag
 . I 'STUFF S TAG="*DUM" D TAGINIT(TAG) ; got text line w/out prior label; init dummy tag
 . S TAGCT=TAGCT+1,@GPREF@(TAGIEN,1,TAGCT,0)=LINE,LINCT=LINCT+1
 . S $P(@GPREF@(TAGIEN,1,0),U,3,4)=TAGCT_U_TAGCT
 . I TAG="*DUM" S LINCT=LINCT-1 ; don't count dummy lines/labels
 . I LINE="*KEY" S KEYS=1
 . I KEYS D
 . . S KEYCT=+$P($G(@GPREF@(TAGIEN,2,0)),U,4)+1,^(0)="^2006.6823^"_KEYCT_U_KEYCT
 . . S @GPREF@(TAGIEN,2,KEYCT,0)=LINE
 . I LINE="*END_KEY" S KEYS=0
SAVEZ  I LINCT S REPLY=1_"~"_LINCT_" Text line"_$S(LINCT-1:"s",1:"")_" were stored for "_LBLCT_" label"_$S(LBLCT-1:"s.",1:".")
 E  S REPLY="0~No data was stored."
 S @MAGGRY@(0)=0_U_REPLY
 I DUMMY ; n/a
 Q
TAGINIT(TAG) ; Init storage space for a tag; inits some vars for SAVE
 N TAGCTRL
 I PDIV,(TAG'="*DUM") S TAG=PDIV_"*DIV*"_TAG ; tags tracked by division
 S TAGIEN=$O(@GPREF@("B",TAG,"")) I 'TAGIEN D  ; for new tag, create a new LABEL node,
 . L +@GPREF@(0):10
 . E  Q
 . S X=$G(@GPREF@(0)) S:X="" X="^2006.682A^0^0"
 . S TAGIEN=$P(X,U,3)
 . F  S TAGIEN=TAGIEN+1 I '$D(@GPREF@(TAGIEN)) Q
 . S T=$P(X,U,4)+1,$P(X,U,3)=TAGIEN,$P(X,U,4)=T
 . S @GPREF@(0)=X,@GPREF@("B",TAG,TAGIEN)=""
 . L -@GPREF@(0)
 . S $P(@GPREF@(TAGIEN,0),U)=TAG
 I TAG'="*DUM"!((TAG="*DUM")&'DUMMY) D
 . S TAGCTRL=$G(@GPREF@(TAGIEN,1,0)) K @GPREF@(TAGIEN,1),^(2) ; init Data & Keys
 . S $P(TAGCTRL,U,2)=2006.6821,$P(TAGCTRL,U,3,4)=0_U_0
 . S @GPREF@(TAGIEN,1,0)=TAGCTRL
 . S TAGCT=0,LBLCT=LBLCT+1
 I TAG="*DUM" S TAGCT=+$P(@GPREF@(TAGIEN,1,0),U,3),LBLCT=LBLCT-'DUMMY,DUMMY=1 ; don't count dummy label
 S NEWTAG=0,STUFF=1
 Q
 ;
TAGS ; return list of tags stored
 ; don't report *DUM tags
 N TAG,CT,OTAG,TAGCT,TAGIEN
 S TAG=0,CT=0,TAGCT=0
 F  S TAG=$O(@GPREF@("B",TAG)) Q:TAG=""  S TAGIEN=$O(^(TAG,"")) I TAG'="*DUM" D
 . I PDIV Q:PDIV'=+TAG  S OTAG=$P(TAG,"*DIV*",2,99)
 . E  S OTAG=TAG
 . S CT=CT+1,@MAGGRY@(CT)=OTAG,TAGCT=TAGCT+1
 . I $D(@GPREF@(TAGIEN,2)) S KEYCT=0 D
 . . F  S KEYCT=$O(@GPREF@(TAGIEN,2,KEYCT)) Q:'KEYCT  S X=^(KEYCT,0),CT=CT+1,@MAGGRY@(CT)=X
 I TAGCT S REPLY=1_"~"_TAGCT_" tag"_$S(TAGCT-1:"s",1:"")_" returned."
 E  S REPLY="0~No data found."
TAGSZ S @MAGGRY@(0)=CT_U_REPLY
 Q
 ;
SYSUSER(X) ; get System user DUZ value
 S X=.5 ; =Postmaster
 Q:$Q X Q
 ;
USER(DUZ) ; get user name, initials & vrad user type
 N RSL,X S RSL=DUZ
 I DUZ=$$SYSUSER() S RSL="sysAdmin^SYS^9"
 E  I DUZ D
 . S RSL=$$USERINF^MAGJUTL3(DUZ,".01;1")
 . F X="S","R","T" I $D(^VA(200,"ARC",X,DUZ)) Q
 . I  S X=$S(X="S":3,X="R":2,X="T":1,1:0)
 . E  S X=0
 . S RSL=RSL_U_X
 Q:$Q RSL Q
 ;
USERS ; return list of users stored -- Sort: System User/Radiologists/Non-Rists
 ; DUZ ^ FULL NAME ^ INITIALS ^ USER TYPE
 N CT,IEN,INIT,NAME,TOUT,USERTYP
 S IEN=0,CT=0
 F  S IEN=$O(^MAG(2006.68,IEN)) Q:'IEN  S X=^(IEN,0) D
 .  S USERDUZ=$P(X,U,2)
 .  S X=$$USER(USERDUZ),NAME=$P(X,U),INIT=$P(X,U,2),USERTYP=$P(X,U,3)
 .  I NAME="" S NAME="~"
 .  S TOUT(-USERTYP,NAME,USERDUZ)=INIT
 S USERTYP="" F  S USERTYP=$O(TOUT(USERTYP)) Q:USERTYP=""  S NAME="" D
 . F  S NAME=$O(TOUT(USERTYP,NAME)) Q:NAME=""  S USERDUZ="" D
 . . F  S USERDUZ=$O(TOUT(USERTYP,NAME,USERDUZ)) Q:'USERDUZ  D
 . . . S CT=CT+1,@MAGGRY@(CT)=USERDUZ_U_NAME_U_TOUT(USERTYP,NAME,USERDUZ)_U_-USERTYP
 I CT S REPLY=1_"~"_CT_" user"_$S(CT-1:"s",1:"")_" returned."
 E  S REPLY="0~No data found."
USERSZ ;
 S @MAGGRY@(0)=CT_U_REPLY
 Q
 ; 
PRFDATA ; RETURN data stored for input Labels
 N TAGS,IDATA,CT,NTAGS,LINCT,OTAG,TAG,TAGCT,TAGIEN,X
 S IDATA="",CT=0,NTAGS=0,LINCT=0
 F  S IDATA=$O(DATA(IDATA)) Q:IDATA=""  S TAG=DATA(IDATA) I TAG]"" D
 . I PDIV,(TAG'="*DUM") S TAG=PDIV_"*DIV*"_TAG ; tags tracked by div
 . S TAGS(TAG)=""
 S TAG=0
 F  S TAG=$O(TAGS(TAG)) Q:TAG=""  S TAGIEN=$O(@GPREF@("B",TAG,"")),NTAGS=NTAGS+1 D
 . S OTAG=TAG I PDIV S OTAG=$P(TAG,"*DIV*",2,99)
 . S CT=CT+1,@MAGGRY@(CT)="*LABEL",CT=CT+1,@MAGGRY@(CT)=OTAG I TAGIEN S TAGCT=0 D
 . . F  S TAGCT=$O(@GPREF@(TAGIEN,1,TAGCT)) Q:'TAGCT  S X=^(TAGCT,0),CT=CT+1,@MAGGRY@(CT)=X,LINCT=LINCT+1
 . S CT=CT+1,@MAGGRY@(CT)="*END"
 I CT S REPLY=1_"~"_LINCT_" Text line"_$S(LINCT-1:"s",1:"")_" returned for "_NTAGS_" tags."
 E  S REPLY="0~No data found."
PRFZ S @MAGGRY@(0)=CT_U_REPLY
 Q
 ;
TAGDEL ; Delete tags and assoc data
 I READONLY S REPLY="0~No tags deleted; read-only access permitted." G TAGDELZ
 N TAG,CT,IDATA,TAG,TAGIEN,ERR
 S TAG=0,CT=0,IDATA="",ERR=""
 F  S IDATA=$O(DATA(IDATA)) Q:IDATA=""  S TAG=DATA(IDATA) I TAG]"" D
 . I PDIV,(TAG'="*DUM") S TAG=PDIV_"*DIV*"_TAG ; tags tracked by div
 . S TAGIEN=$O(@GPREF@("B",TAG,"")) I TAGIEN D
 . . L +@GPREF@(0):10
 . . E  S ERR="0~Unable to perform Delete operation." Q
 . . K @GPREF@(TAGIEN),@GPREF@("B",TAG)
 . . S X=$G(@GPREF@(0),"^2006.682A^0^0") S T=+$P(X,U,4) S:T T=T-1 S $P(X,U,4)=T,^(0)=X
 . . L -@GPREF@(0)
 . . S CT=CT+1
 I CT S REPLY=1_"~"_CT_" label"_$S(CT-1:"s",1:"")_" deleted."
 E  S REPLY=$S(ERR]"":ERR,1:"0~No label data found.")
TAGDELZ S @MAGGRY@(0)=0_U_REPLY
 Q
 ;
END ;
