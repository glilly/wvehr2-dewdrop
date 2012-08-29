%ZVEMRUS ;DJB,VRR**Rtn Selector [5/17/97 7:05am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SELECT ;
 NEW FLAGQ,QUIT
 KILL ^UTILITY($J)
 S FLAGQ=0
 D INIT G:FLAGQ EX
 D @$S($D(^%ZOSF("RSEL")):"ZOSF",1:VEE("OS"))
EX ;
 Q
ZOSF ;Use ^%ZOSF("RSEL")
 NEW %,X
 X ^%ZOSF("RSEL")
 Q
2 ;Rtn Select for DSM Mumps
 D ^%RSEL
 Q
8 ;Rtn Select for MSM Mumps
 D INT^%RSEL
 Q
9 ;Rtn Select for DataTree Mumps
 NEW RTN
 KILL ^%RSET($J)
 W $$^%rselect
 I $O(^%RSET($J,""))="" Q
 S RTN=""
 F  S RTN=$O(^%RSET($J,RTN)) Q:RTN=""  S ^UTILITY($J,RTN)=""
 KILL ^%RSET($J)
 Q
16 ;Rtn Select for VAX DSM Mumps
 NEW %UTILITY
 D ^%RSEL Q:$O(%UTILITY(""))=""
 S RTN=""
 F  S RTN=$O(%UTILITY(RTN)) Q:RTN=""  S ^UTILITY($J,RTN)=""
 Q
18 ;Rtn Select for OpenM
 KILL ^UTILITY($J)
 I $L($T(KERNEL^%RSET)) D KERNEL^%RSET KILL %ST Q  ;VA Kernel rtn
 NEW %JO,%UR,%R
 S %JO=$J,%UR="^ROUTINE",%R=0 D ROU^%RSET
 Q
INIT ;
 I '$D(^%ZOSF("RSEL")),$G(VEE("OS"))="" D OS^%ZVEMKY
 Q
