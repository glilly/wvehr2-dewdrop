%ZVEMRLO ;DJB,VRR**RTN LBRY - Sign Out Rtns,Rtn Save ; 11/24/00 8:24am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 NEW FLAGQ,VEEID,VEEUSERI,VEEUSERN
 NEW %,%Y,%DT,D,D0,DA,DDH,DI,DIC,DIE,DQ,DR,DZ,X,Y
 S X="ERROR^%ZVEMRLU",@($$TRAP^%ZVEMKU1) KILL X
 Q:'$D(^VEE(19200.11))  ;...Library file doesn't exist
 S FLAGQ=0
 D INIT^%ZVEMRLU Q:FLAGQ
TOP ;
 W @VEE("IOF"),!,"*** SIGN OUT ROUTINES ***"
 D SELECT^%ZVEMRUS G:'$D(^UTILITY($J)) EX
 D GETID^%ZVEMRLI
 W ! G:$$ASK^%ZVEMKU("SIGN OUT routine(s) now",1)'="Y" TOP
 D LOCK^%ZVEMRLU G:FLAGQ EX
 D LOOP
EX ;
 KILL ^UTILITY($J)
 L -^VEE(19200.11)
 Q
 ;====================================================================
LOOP ;Stuff data into VPE RTN LBRY
 NEW CNT,IEN,NAME,RTN,VEEBYI,VEEBYN,Y
 S CNT=1,RTN=0
 F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""  D  ;
 . I $E(RTN)'?1A,$E(RTN)'?1"%" Q
 . I '$D(^VEE(19200.11,"B",RTN)) D CREATE(RTN) Q
 . W $C(7),!,RTN,?12,"--> Already signed out by "
 . S IEN=$O(^VEE(19200.11,"B",RTN,"")) Q:IEN'>0
 . D GETBY^%ZVEMRLU(IEN) Q:VEEBYN']""  W VEEBYN
 W !!?1,(CNT-1)," routine(s) Signed Out"
 D PAUSE^%ZVEMKU(2,"P")
 Q
CREATE(RTN) ;Create entry and 'stuff' data
 ;X=Routine name. Requires VEEID,VEEUSERI
 Q:$G(RTN)']""
 S X=RTN
 S DIC="^VEE(19200.11,"
 S DIC(0)="QL"
 KILL DD,DO D FILE^DICN Q:$P(Y,U,3)'=1
 S DIE=DIC
 S DA=+Y
 S DR="4///^S X=$G(VEEID);12///NOW;13////^S X=VEEUSERI"
 D ^DIE
 S CNT=$G(CNT)+1
 W !!,RTN," signed out."
 Q
 ;==================================================================
RS(JOB) ;Replace ^UTILITY($J,RTNS) routines with ..LBRY routines.
 ;JOB=Job#
 ;VEE("OS"): 8=MSM 18=OpenM
 ;
 Q:'$G(JOB)
 Q:'$G(VEE("OS"))
 Q:'$D(^VEE(19200.11,"B"))
 ;
 NEW CNT,ID,IEN,RTN
 S ID=$$RSID() Q:ID="^"
 I VEE("OS")=8,'$G(%RSN) KILL ^UTILITY(JOB)
 S CNT=0,RTN=""
 F  S RTN=$O(^VEE(19200.11,"B",RTN)) Q:RTN']""  D  ;
 . S IEN=$O(^VEE(19200.11,"B",RTN,"")) Q:IEN'>0
 . I ID]"",ID'=$P($G(^VEE(19200.11,IEN,0)),"^",4) Q
 . Q:$D(^UTILITY(JOB,RTN))
 . S ^UTILITY(JOB,RTN)=""
 . S CNT=CNT+1
 . I VEE("OS")=18 S %R=$G(%R)+1
 Q:'CNT
 I VEE("OS")=8 S %RSN=1
 W !!?10,CNT," routine",$S(CNT=1:"",1:"s")," added."
 Q
RSID() ;Restrict rtns selected based on IDENTIFIER field.
 NEW ID
RSID1 W !!,"Enter IDENTIFIER: "
 R ID:300 S:'$T ID="^" I "^"[ID Q ID
 I $E(ID)="?" D  G RSID1
 . W !!,"If you want only those routines with a certain IDENTIFIER, enter it now."
 . W !,"Hit <RETURN> for ALL routines, or ^ for NO routines."
 Q ID
