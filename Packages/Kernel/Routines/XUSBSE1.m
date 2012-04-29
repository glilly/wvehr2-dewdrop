XUSBSE1 ;JLI/OAK-OIFO - MODIFICATIONS FOR BSE ;3/19/07  16:27
 ;;8.0;KERNEL;**404,439**;Jul 10, 1995;Build 12
 ; SETVISIT - returns a BSE token
SETVISIT(RES) ; .RPC
 N TOKEN
 S TOKEN=$$HANDLE^XUSRB4("XUSBSE",1)
 S ^XTMP(TOKEN,1)=$$GET^XUESSO1(DUZ)
 S RES=TOKEN
 Q
 ;
 ; GETVISIT - returns demographics for user indicated by TOKEN
 ;   output - RES - passed by reference, contains global location on return
 ;   input  - TOKEN - token value returned by remote site
GETVISIT(RES,TOKEN) ; .RPC
 S RES=$G(^XTMP(TOKEN,1))
 K ^XTMP(TOKEN)
 Q
 ;
RPUT(RET,VALUE) ;Put Token and data on new system
 S RET=1 ;Needs more work.
 Q
 ;
OLDCAPRI(XWBUSRNM) ;The OLD CAPRI code, Remove next patch
 ; Return 1 if a valid user, else 0.
 N XVAL,XUCNTXT
 S XVAL=$$PUT^XUESSO1($P(XWBUSRNM,U,3,99)) ; Sign in as Visitor
 I XVAL D
 . S XUCNTXT=$$FIND1^DIC(19,"","X","DVBA CAPRI GUI")
 . D SETCNTXT(XUCNTXT)
 Q $S(XVAL>0:1,1:0)
 ;
 ; CHKUSER - determines if a BSE sign-on is valid
 ;   INPUTSTR - input - String of characters from client
 ;   return value - 1 if a valid user, else 0
 ; called from XUSRB
CHKUSER(INPUTSTR) ;
 N XUCODE,XUENTRY,XUSTR,XUTOKEN
 I +INPUTSTR=-31,INPUTSTR["DVBA_",$$OLDCAPRI(INPUTSTR) Q 1
 I +INPUTSTR'=-35 Q 0
 S INPUTSTR=$P(INPUTSTR,U,2,99)
 K ^TMP("XUSBSE1",$J)
 S XUCODE=$$DECRYP^XUSRB1(INPUTSTR) ;TMP
 S XUCODE=$$EN^XUSHSH($P(XUCODE,U))
 S XUENTRY=$$FIND1^DIC(8994.5,"","X",XUCODE,"ACODE") D:XUENTRY>0
 . S XUTOKEN=$P($$DECRYP^XUSRB1(INPUTSTR),U,2)
 . S XUSTR=$P($$DECRYP^XUSRB1(INPUTSTR),U,3,4)
 . S XUENTRY=$$BSEUSER(XUENTRY,XUTOKEN,XUSTR)
 . Q
 Q $S(XUENTRY'>0:0,1:XUENTRY)
 ;
 ; BSEUSER - returns internal entry number for authenicated user or 0
 ;   ENTRY - input - internal entry number in REMOTE APPLICATION file
 ;   TOKEN - input - token from authenticaing site
 ;   STR   - input - remainder of input string (2 pieces)
BSEUSER(ENTRY,TOKEN,STR) ;
 N XUIEN,XUCONTXT,XUDEMOG,XCNT,XVAL
 S XUIEN=0,XUDEMOG=""
 S XCNT=0 F  S XCNT=$O(^XWB(8994.5,ENTRY,1,XCNT)) Q:XCNT'>0  S XVAL=^(XCNT,0) D  Q:XUDEMOG'=""
 . ; INSERT CODE TO HANDLE CONNECTION TYPE AND CONNECTIONS
 . I $P(XVAL,U)="M" S XUDEMOG=$$M2M($P(XVAL,U,3),$P(XVAL,U,2),TOKEN) D CLOSE^XWBM2MC() Q
 . I $P(XVAL,U)="R" S XUDEMOG=$$XWB($P(XVAL,U,3),$P(XVAL,U,2),TOKEN) Q
 . I $P(XVAL,U)="H" S XUDEMOG=$$POST^XUSBSE2($P(XVAL,U,3),$P(XVAL,U,2),$P(XVAL,U,4),"xVAL="_TOKEN) Q
 . Q
 I XUDEMOG="" D
 . N SERVER,PORT
 . S XUDEMOG=""
 . S SERVER=$P(STR,U),PORT=$P(STR,U,2)
 . I SERVER'="",PORT>0 S XUDEMOG=$$GETDEMOG(SERVER,PORT,TOKEN)
 . Q
 I XUDEMOG'="" D
 . S XUCONTXT=$P($G(^XWB(8994.5,ENTRY,0)),U,2)
 . S XUIEN=$$SETUP(XUDEMOG,XUCONTXT)
 Q $S(XUIEN'>0:0,1:XUIEN)
 ;
XWB(SERVER,PORT,TOKEN) ;Special Broker service
 N DEMOSTR,IO,XWBTDEV,XWBRBUF
 ;TEST CODE
 Q $$CALLBSE^XWBTCPM2(SERVER,PORT,TOKEN)
 ;
M2M(SERVER,PORT,TOKEN) ;
 N DEMOGSTR,XWBCRLFL,RETRNVAL,XUSBSARR
 S DEMOGSTR=""
 N XWBSTAT,XWBPARMS,XWBTDEV,XWBNULL
 S XWBPARMS("ADDRESS")=SERVER,XWBPARMS("PORT")=PORT
 S XWBPARMS("RETRIES")=3 ;Retries 3 times to open
 ;
 I '$$OPEN^XWBRL(.XWBPARMS) Q "NO OPEN"
 S XWBPARMS("URI")="XUS GET VISITOR"
 D CLEARP^XWBM2MEZ
 D SETPARAM^XWBM2MEZ(1,"STRING",TOKEN)
 S XWBPARMS("URI")="XUS GET VISITOR"
 S XWBPARMS("RESULTS")=$NA(^TMP("XUSBSE1",$J))
 S XWBCRLFL=0
 D REQUEST^XWBRPCC(.XWBPARMS)
 I XWBCRLFL S RETRNVAL="XWBCRLFL IS TRUE" G M2MEXIT ; S @M2MLOC="XWBCRLFL IS TRUE" Q  ; Q 0
 ;
 I '$$EXECUTE^XWBVLC(.XWBPARMS) S RETRNVAL="FAILURE ON EXECUTE" G M2MEXIT ; S @M2MLOC="failure on execute" Q  ;Run RPC and place raw XML results in ^TMP("XWBM2MVLC"
 D PARSE^XWBRPC(.XWBPARMS,"XUSBSARR") ;Parse out raw XML and place results in ^TMP("XWBM2MRPC"
 S RETRNVAL=$G(XUSBSARR(1))
M2MEXIT ;
 D CLOSE^XWBM2MEZ
 Q RETRNVAL
 ;
 ; GETDEMOG - return value = string of demographic characteristics
 ;   input SERVER - server address
 ;   input PORT   - port number for connection
 ;   input TOKEN  - token to identify user to authenticating server
GETDEMOG(SERVER,PORT,TOKEN) ;
 N DEMOGSTR
 S DEMOGSTR=""
 Q DEMOGSTR
 ;
 ; SETUP - setup user as visitor, add context option
 ; return value = internal entry number for user, or 0
 ;   input XUDEMOG  - string of demographic characteristics
 ;   input XUCONTXT - context option to be given to user
SETUP(XUDEMOG,XUCONTXT) ;
 I '$$PUT^XUESSO1(XUDEMOG) Q 0
 I $G(DUZ)'>0 Q 0
 D SETCNTXT(XUCONTXT)
 Q DUZ
 ;
SETCNTXT(XOPT) ;
 N OPT,XUCONTXT
 S XUCONTXT="`"_XOPT
 I $$FIND1^DIC(19,"","X",XUCONTXT)'>0 Q  ; context option not in option file
 ;Have to use $D because of screen in 200.03 keeps FIND1^DIC from working.
 I '$D(^VA(200,DUZ,203,"B",XOPT)) D
 . ; Have to give the user a delegated option
 . N XARR S XARR(200.19,"+1,"_DUZ_",",.01)=XUCONTXT
 . D UPDATE^DIE("E","XARR")
 . ; And now she can give himself the context option
 . K XARR S XARR(200.03,"+1,"_DUZ_",",.01)=XUCONTXT
 . D UPDATE^DIE("E","XARR") ; Give context option as a secondary menu item
 . S ^XUTL("XQ",$J,"DUZ(BSE)")=XUCONTXT
 . ; But now we have to remove the delegated option
 . S OPT=$$FIND1^DIC(200.19,","_DUZ_",","X",XUCONTXT)
 . I OPT>0 D
 . . K XARR S XARR(200.19,(OPT_","_DUZ_","),.01)="@"
 . . D FILE^DIE("E","XARR")
 . . Q
 . Q
 Q
 ;
