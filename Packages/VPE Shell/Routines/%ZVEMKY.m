%ZVEMKY ;DJB,KRN**Kernel - Basic Init ; 4/5/03 7:35am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
INIT ;Initialize variables
 D TIME
 S U="^"
 S $P(VEELINE,"-",212)=""
 S $P(VEELINE1,"=",212)=""
 S $P(VEELINE2,". ",106)=""
 D IO
 S VEESIZE=(VEE("IOSL")-6)
 S VEEIOST=$S($G(IOST)]"":IOST,1:"C-VT100")
 Q
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TIME ;Set timeout length
 Q:$G(VEE("TIME"))>0
 I $G(VEE("ID"))>0,$G(^%ZVEMS("PARAM",VEE("ID"),"TO"))>0 S VEE("TIME")=^("TO") Q
 S VEE("TIME")=$S($D(DTIME):DTIME,1:300)
 Q
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IO ;Form Feed, Margin, Sheet Length
 I $D(VEE("IOF")),$D(VEE("IOSL")),$D(VEE("IOM")) Q
 D  D PARAM
 . I $G(IOF)]"",$G(IOSL)]"",$G(IOM)]"" D  Q
 . . S VEE("IOF")=IOF,VEE("IOSL")=IOSL,VEE("IOM")=IOM
 . I $D(^%ZIS(1)) D KERN Q
 . D NOKERN
 Q
 ;
PARAM ;Adjust screen length/width to ..PARAM settings
 I $G(VEE("ID"))>0 D  ;
 . S:$D(^%ZVEMS("PARAM",VEE("ID"),"WIDTH")) VEE("IOM")=^("WIDTH")
 . S:$D(^%ZVEMS("PARAM",VEE("ID"),"LENGTH")) VEE("IOSL")=^("LENGTH")
 S VEESIZE=VEE("IOSL")-$S(VEE("IOSL")>6:6,1:"")
 Q
 ;
KERN ;VA KERNEL
 D HOME^%ZIS
 S VEE("IOSL")=IOSL
 S VEE("IOF")=IOF
 S VEE("IOM")=IOM
 Q
 ;
NOKERN ;No VA KERNEL
 S VEE("IOSL")=24
 S VEE("IOF")="#,$C(27),""[2J"",$C(27),""[H"""
 S VEE("IOM")=80
 Q
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OS ;Get Operating System
 ;This subroutine returns FLAGQ=1 if VEE("OS") cannot be set.
 S FLAGQ=0 D  Q:FLAGQ
 . I $D(^%ZOSF("OS")) S VEE("OS")=+$P(^("OS"),"^",2) Q:VEE("OS")>0
 . I $D(^DD("OS")) S VEE("OS")=+^("OS") Q:VEE("OS")>0
 . I $D(^%ZVEMS("OS")) S VEE("OS")=+^("OS") Q:VEE("OS")>0
 . D SET
 I VEE("OS")=9 D  Q
 . X "I $I=1,$ZDEV(""VT"")=0 S FLAGQ=1 D DTMHELP" Q
 Q
 ;
SET ;Get MUMPS System
 NEW NUM
 S NUM=7
 I '$D(^%ZVEMS) D  S FLAGQ=1 Q
 . W $C(7),!!,"Sorry, this software requires that you have either the VA KERNEL,"
 . W !,"FileMan, or the VPE Shell on your system.",!
 NEW X
 W !!,"I need to know what type of Mumps system you are running."
 W !,"Select from the following choices. Selecting a system other"
 W !,"than the one you are running, will cause errors or"
 W !,"unpredictable behavior. DO SET^%ZVEMKY again to correct."
 W !!,"1. MSM",!,"2. DTM",!,"3. DSM",!,"4. VAX DSM",!,"5. CACHE",!,"6. GT.M (VMS)",!,"7. GT.M (Unix)"
 W !
SET1 R !,"Enter number: ",X:300 S:'$T X="^"
 I "^"[X W ! S FLAGQ=1 Q
 I X'?1N!(X<1)!(X>NUM) D  G SET1
 . W "   Enter a number from 1 to "_NUM
 S X=$S(X=1:8,X=2:9,X=3:2,X=4:16,X=5:18,X=6:17,X=7:19,1:"")
 I X']"" Q
 I $D(^%ZVEMS) S (^%ZVEMS("OS"),VEE("OS"))=X
 I $D(^%ZVEMS("E")) S (^%ZVEMS("E","OS"),VEE("OS"))=X
 Q
 ;
DTMHELP ;DataTree users on console device must be in VT220 emulation.
 W !!,"============================================================================="
 W $C(7),!!?2,"If you are using DataTree Mumps on the console device, you must enable"
 W !?2,"the VT220 emulation features. You may set the VT device parameter as"
 W !?2,"follows:"
 W !!?10,"USE 1:VT=1   ;to enable",!?10,"USE 1:VT=0   ;to disable"
 W !!?2,"The $ZDEV(""VT"") variable returns the current value of the VT parameter."
 W !!?2,"If you have the DEVICE and TERMINAL TYPE files from the VA KERNEL on your"
 W !?2,"system, go into the DEVICE file and edit the device whose $I field equals"
 W !?2,"1, and enter ""VT=1"" in the USE PARAMETER field."
 W !!,"=============================================================================",!
 Q
