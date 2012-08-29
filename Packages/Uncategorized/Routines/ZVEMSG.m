ZVEMSG ;DJB,VSHL**Global Loader ; 8/29/02 9:15pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 Q
ALL ;Load entire ^%ZVEMS global
 NEW I,RTN,TAG,TXT
 D INIT
 S RTN="ZVEMSGC" D ENTRY,A,C,K,O,Q
 S RTN="ZVEMSGD" D R,S,SY,T
 ;
 ;Build System QWIKs
 D ^ZVEMSGS
 D ^ZVEMSGT
 D ^ZVEMSGU
 ;
 ;Load ZOSF nodes
 ;D ^ZVEMSGR
 ;
 ;Load Help and other text
 D TEXT^ZVEMSGH
 Q
 ;
ENTRY ;Load ^%ZVEMS Global entry point
 S ^%ZVEMS="NEW FLAGQ,VEE S FLAGQ=0 D ^%ZVEMSY Q:FLAGQ  KILL FLAGQ X ^%ZVEMS(""ZS"",1) NEW VEESHC,VEESHL S VEESHL=""RUN"" F  X ^%ZVEMS(""ZA"",1) I $G(VEESHC)=""^"" X:$D(^%ZVEMS(""ZK"",1)) ^(1) Q:VEESHC'=""NO EXIT"""
 Q
 ;
BUILD ;Build ^%ZVEMS global
 W "."
 X "F I=1:1 S TXT=$T("_TAG_"+I^"_RTN_") Q:TXT']""""  S TXT=$P(TXT,"" "",2,999) Q:TXT="";;;***""  S ^%ZVEMS("""_TAG_""",I)=TXT"
 Q
 ;
A ;
 KILL ^%ZVEMS("ZA")
 S ^%ZVEMS("ZA")="Main Section"
 S TAG="ZA" D BUILD
 Q
 ;
C ;
 KILL ^%ZVEMS("ZC")
 S ^%ZVEMS("ZC")="Check for global KILL"
 S TAG="ZC" D BUILD
 Q
 ;
K ;
 KILL ^%ZVEMS("ZK")
 S ^%ZVEMS("ZK")="Kill ^%ZVEMS(""%"") on exit, VA KERNEL interface"
 S TAG="ZK" D BUILD
 Q
 ;
O ;
 KILL ^%ZVEMS("ZO")
 S ^%ZVEMS("ZO")="Other"
 S TAG="ZO" D BUILD
 Q
 ;
Q ;
 KILL ^%ZVEMS("ZQ")
 S ^%ZVEMS("ZQ")="Process QWIKs. VEEWARN turns off glb kill warning."
 S TAG="ZQ" D BUILD
 Q
 ;
R ;
 KILL ^%ZVEMS("ZR")
 S ^%ZVEMS("ZR")="Single Character READ"
 S TAG="ZR" D BUILD
 Q
 ;
S ;
 KILL ^%ZVEMS("ZS")
 S ^%ZVEMS("ZS")="Save/Restore Variables"
 S TAG="ZS" D BUILD
 Q
 ;
SY ;Use to guarantee unique subscript - $J_$G(^%ZVEMS("SY"))
 ;Necessary because not all systems support $SY.
 S ^%ZVEMS("SY")=""
 ;Set error trap to test if vendor supports $SY
 D  ;
 . NEW X
 . S X="ERROR^ZVEMSG",@($$TRAP^%ZVEMKU1)
 . I $SY]"" S ^%ZVEMS("SY")="-"_$SY
 Q
 ;
T ;
 KILL ^%ZVEMS("ZT")
 S ^%ZVEMS("ZT")="Session timed out"
 S TAG="ZT" D BUILD
 Q
 ;
INIT ;
 S U="^"
 S ^%ZVEMS("%")="Scratch area"
 S ^%ZVEMS("CLH")="Command line history"
 S ^%ZVEMS("ID")="User IDs"
 S ^%ZVEMS("PARAM")="Shell parameters"
 Q
 ;
ERROR ;
 Q
