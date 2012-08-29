%ZVEMKY1 ;DJB,KRN**BS,TRMREAD,ECHO,EXIST,XY,$ZE ; 4/5/03 7:43am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
BS ;Backspace options
 I '$D(VEE("ID")) S VEE("BS")="SAME" Q
 S VEE("BS")=$G(^%ZVEMS("PARAM",VEE("ID"),"BS"))
 I VEE("BS")']"" S VEE("BS")="SAME"
 Q
 ;
ZE ;$ZE Error info
 I VEE("OS")=17!(VEE("OS")=19) S VEE("$ZE")="$ZSTATUS" Q
 S VEE("$ZE")="$ZE"
 Q
 ;
TRMREAD ;Read terminators
 Q:$D(VEE("TRMON"))
 I $D(^%ZOSF("TRMON")) D  Q
 . S VEE("TRMON")=$G(^%ZOSF("TRMON"))
 . S VEE("TRMOFF")=$G(^%ZOSF("TRMOFF"))
 . S VEE("TRMRD")=$G(^%ZOSF("TRMRD"))
 ;
 ;-> DSM
 I VEE("OS")=2 D  Q
 . S VEE("TRMON")="U $I:(::::1572864::::$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31))"
 . S VEE("TRMOFF")="U $I:(:::::1572864:::$C(13,27))"
 . S VEE("TRMRD")="S Y=$ZB"
 ;
 ;-> MSM
 I VEE("OS")=8 D  Q
 . S VEE("TRMON")="U $I:(::::::::$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127))"
 . S VEE("TRMOFF")="U $I:(::::::::$C(13,27))"
 . S VEE("TRMRD")="S Y=$ZB"
 ;
 ;-> DTM
 I VEE("OS")=9 D  Q
 . S VEE("TRMON")="U $I:IXINTERP=2"
 . S VEE("TRMOFF")="U $I:IXINTERP=$S($I>99:1,1:0)"
 . S VEE("TRMRD")="S Y=$S('$ZIOS:$ZIOT,1:0)"
 ;
 ;-> DSM for OpenVMS
 I VEE("OS")=16 D  Q
 . S VEE("TRMON")="U $I:TERM=$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127)"
 . S VEE("TRMOFF")="U $I:TERM="""""
 . S VEE("TRMRD")="S Y=$ZB"
 ;
 ;-> CACHE
 I VEE("OS")=18 D  Q
 . S VEE("TRMON")="U $I:("""":""+I+T"")"
 . S VEE("TRMOFF")="U $I:("""":""-I-T"":$C(13,27))"
 . S VEE("TRMRD")="S Y=$A($ZB),Y=$S(Y<32:Y,Y=127:Y,1:0)"
 ;
 ;-> GTM
 I VEE("OS")=17!(VEE("OS")=19) D  Q
 . S VEE("TRMON")="U $I:(TERMINATOR=$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127))"
 . S VEE("TRMOFF")="U $I:(TERMINATOR="""")"
 . S VEE("TRMRD")="S Y=$A($ZB)"
 ;
 ;-> Default
 S (VEE("TRMON"),VEE("TRMOFF"),VEE("TRMRD"))=""
 W !!,"I'm unable to set READ Terminators for your M system."
 W !,"Edit TRMREAD^%ZVEMKY1 and add code for your system."
 D PAUSE^%ZVEMKU(2)
 Q
 ;
ECHO ;Set up Echo On and Echo Off
 NEW CHK
 Q:$D(VEE("EON"))
 I $D(^%ZOSF("EON")),$D(^%ZOSF("EOFF")) S VEE("EON")=^%ZOSF("EON"),VEE("EOFF")=^%ZOSF("EOFF") D  Q
 . Q:VEE("OS")'=9
 . X "S CHK='$ZDEV(""ECHOA"")" Q:CHK
 . S VEE("EON")="U $I:ECHOA=1",VEE("EOFF")="U $I:ECHOA=0"
 ;
 ;-> DSM
 I VEE("OS")=2 D  Q
 . S VEE("EON")="U $I:(:::::1)",VEE("EOFF")="U $I:(::::1)"
 ;
 ;-> MSM
 I VEE("OS")=8 D  Q
 . S VEE("EON")="U $I:(:::::1)",VEE("EOFF")="U $I:(::::1)"
 ;
 ;-> DTM
 I VEE("OS")=9 D  Q
 . X "S CHK=$ZDEV(""ECHOA"")"
 . I CHK S VEE("EON")="U $I:ECHOA=1",VEE("EOFF")="U $I:ECHOA=0" Q
 . S (VEE("EON"),VEE("EOFF"))=""
 ;
 ;-> VAX DSM
 I VEE("OS")=16 D  Q
 . S VEE("EON")="U $I:ECHO"
 . S VEE("EOFF")="U $I:NOECHO"
 ;
 ;-> CACHE
 I VEE("OS")=18 D  Q
 . S VEE("EON")="U $I:("""":""-S"")"
 . S VEE("EOFF")="U $I:("""":""+S"")"
 . Q
 ;
 ;-> GTM
 I VEE("OS")=17!(VEE("OS")=19) D  Q
 . S VEE("EON")="U $I:(ECHO)"
 . S VEE("EOFF")="U $I:(NOECHO)"
 ;
 ;-> Default
 S (VEE("EON"),VEE("EOFF"))="" D ECHOMSG,PAUSE^%ZVEMKU(2)
 Q
 ;
EXIST ;Set up VEES("EXIST") to test existence of a routine.
 I $D(^%ZOSF("TEST")) S VEES("EXIST")=^("TEST") Q:VEES("EXIST")]""
 I $D(^DD("OS",VEE("OS"),18)) S VEES("EXIST")=^(18) Q:VEES("EXIST")]""
 I VEE("OS")=2 S VEES("EXIST")="I $D(^ (X))" Q
 I VEE("OS")=8 S VEES("EXIST")="I $D(^ (X))" Q
 I VEE("OS")=9 S VEES("EXIST")="I $ZRSTATUS(X)]""""" Q
 I VEE("OS")=16 S VEES("EXIST")="I $D(^ (X))!$D(^!(X))" Q
 I VEE("OS")=18 S VEES("EXIST")="I X?1(1""%"",1A).7AN,$D(^$ROUTINE(X))" Q
 I VEE("OS")=17!(VEE("OS")=19) D  Q
 . S VEES("EXIST")="I X]"""",$T(^@X)]"""""
 ;Default
 S VEES("EXIST")="I @(""$T(^""_X_"")]"""""""""")"
 Q
 ;
XY ;Resetting $X & $Y
 Q:$D(VEES("XY"))
 I $D(^%ZOSF("XY")) S VEES("XY")=^%ZOSF("XY") Q:VEES("XY")]""
 I VEE("OS")=2 S VEES("XY")="U $I:(::::::DY*256+DX)" Q
 I VEE("OS")=8 S VEES("XY")="U $I:(::::::DY*256+DX)" Q
 I VEE("OS")=9 S VEES("XY")="W /C(DX,DY)" Q
 I VEE("OS")=16 S VEES("XY")="U $I:(NOCURSOR,X=DX,Y=DY,CURSOR)" Q
 I VEE("OS")=18 S VEES("XY")="S $X=DX,$Y=DY" Q
 I VEE("OS")=17!(VEE("OS")=19) S VEES("XY")="S $X=DX,$Y=DY" Q
 ;Default
 S VEES("XY")="" D XYMSG,PAUSE^%ZVEMKU(2)
 Q
 ;
ECHOMSG ;Can't set ECHO ON/OFF
 W !!,"I'm unable to set ECHO ON/OFF for your M system."
 W !,"Edit ECHO^%ZVEMKY1 and add code for your system."
 Q
 ;
XYMSG ;Can't reset $X & $Y
 W !!,"I don't know how to reset $X & $Y on your M system. Edit XY^%ZVEMKY1"
 W !,"Edit XY^%ZVEMKY1 and add code for your system."
 Q
