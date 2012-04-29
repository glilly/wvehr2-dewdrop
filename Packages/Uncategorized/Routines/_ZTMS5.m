%ZTMS5 ;ISF/RWF - SubManager Utilities ;10/29/2003 ;11/03/2003  13:45
 ;;8.0;KERNEL;**275**;Jul 10, 1995;
 Q
 ;Lock and time are set in EXIT^%ZTMS1.
SUBCHK ;Check for lost submanagers, Update Count
 N %C,%N,%J,ZT2,ZT3
 S %N=""
 F  S %N=$O(^%ZTSCH("SUB",%N)) Q:%N=""  D
 . L +^%ZTSCH("SUB",%N):5
 . S %C=0,%J=0,ZT3=$$H3^%ZTM($H)
 . F  S %J=$O(^%ZTSCH("SUB",%N,%J)) Q:%J'>0  D
 . . S ZT2=$$H3^%ZTM($G(^(%J)))
 . . ;Check for not locked.
 . . L +^%ZTSCH("SUBLK",%N,%J):0 I $T L -^%ZTSCH("SUBLK",%N,%J) K ^%ZTSCH("SUB",%N,%J) Q
 . . ;Check for old
 . . I (ZT2+30)<ZT3 K ^%ZTSCH("SUB",%N,%J) Q
 . . S %C=%C+1
 . . Q
 . S ^%ZTSCH("SUB",%N)=%C
 . L -^%ZTSCH("SUB",%N)
 . Q
 Q
