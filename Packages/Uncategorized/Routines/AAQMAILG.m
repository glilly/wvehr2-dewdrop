AAQMAILG ;FGO/JHS;FOR PRINT TEMPLATE XUSERINQFGO ;10-23-92 [5/23/01 4:58pm]
 ;;8.0;KERNEL;**L11**;Jul 10, 1995
 ;;Display user's Keys, Mail Groups, and Menu Templates
 D ^XQDATE X ^%ZOSF("UCI") S AAQUCI=Y
 I IOST["C-" D CONX G:AAQX="^" EXIT D HDR
 I IOST["P-",$Y>(IOSL-4) D HDR
 I $D(^VA(200,D0,51,0)) W !,"Keys Held",!,"---------" S Y=-1 F %=0:0 S %=$O(^VA(200,D0,51,%)),Y=Y+1 Q:'%  I $D(^DIC(19.1,%,0))#2 D KEYS
 I IOST["C-" D CONX G:AAQX="^" EXIT
 G CHKMG
KEYS W:'(Y#3) ! W ?(Y#3*27+2),$P(^DIC(19.1,%,0),U,1)
 I IOST["C-",$Y>(IOSL-4),$X>51 D CON,HDR
 I IOST["P-",$Y>(IOSL-4),$X>51 D HDR
 Q
CHKMG I IOST["C-",$Y>(IOSL-4) D CON,HDR
 I IOST["P-",$Y>(IOSL-4) D HDR
 I $D(^XMB(3.8,"AB",D0)) W !!,"Mail Groups",!,"-----------" F X=0:0 S X=$O(^XMB(3.8,"AB",D0,X)) Q:'X  I $D(^XMB(3.8,X,0)) S I=^(0),J=$P(I,U,2) I J'="PE"!$D(^XMB(3.8,"AB",D0,X)) D AAQORG
 G:'$D(^VA(200,D0,19.8)) EXIT
 W !!,"Menu Templates",!,"--------------",!
SHO ;Show a user his or her template names
 S XQUSER=$P($P(^VA(200,D0,0),U),",",2)_" "_$P($P(^(0),U),",")
 S U="^",(XQI,XQN,XQV)=0
 S XQN=$O(^VA(200,D0,19.8,"B",XQN)) I XQN="" W !,XQUSER," doesn't have any Menu Templates stored in the Person File." G EXIT
 D HOME^%ZIS:'$D(IOF),^XQDATE
 W !,?10,"The menu templates of ",XQUSER," ",%Y S XQV=2
 D SHO1 F XQI=0:0 S XQN=$O(^VA(200,D0,19.8,"B",XQN)) Q:XQN=""  D SHO1
 G EXIT
SHO1 ;Write out template name and the first two options in it
 I IOST["C-",$Y>(IOSL-4) D CON,HDR
 S XQI=0,XQI=$O(^VA(200,D0,19.8,"B",XQN,XQI)) Q:'$D(^VA(200,D0,19.8,XQI,1,1,0))
 S %=^VA(200,D0,19.8,XQI,1,1,0),%=$P(%,U,2,999),%1=+$P(%,U,1),%2=+$P(%,U,2)
 I IOST["C-",'$D(ZTQUEUED),XQV+5>21 S XQV=0 W @IOF
 W !!,"Template name: ",XQN S XQV=XQV+2
 I %1 W !,?3,"1st option: ",$S($D(^DIC(19,%1,0))#2:$P(^(0),U,2),1:"*** Missing Option ***") S XQV=XQV+1
 I %2 W !,?6,"2nd option: ",$S($D(^DIC(19,%2,0))#2:$P(^(0),U,2),1:"*** Missing Option ***") S XQV=XQV+1
 I $L($P(%,U,3)) W !,?9,"Etc." S XQV=XQV+1
 Q
AAQORG I IOST["C-",$Y>(IOSL-4) D CON,HDR
 I IOST["P-",$Y>(IOSL-4) D HDR
 W !,?4,$P(I,U) I $D(^XMB(3.8,X,3)) W:^(3)=D0 ?33," (Organizer)"
 W ?47,$S((J="PR"):"(Private)",1:"(Public)")
 Q
CON R !!,"Press RETURN to Continue - No Exit Here: ",AAQX:20
 Q
CONX R !!,"Press RETURN to Continue or '^' to Exit: ",AAQX:20 Q:AAQX="^"
 Q
HDR W @IOF S $X=1,$Y=1 W "User Inquiry   ",%Y,"   (UCI: ",AAQUCI,")",!!
 W $P(^VA(200,D0,0),U),"  (#",D0,")",!! Q
EXIT ;
 ; Added the following for data collection by ADPACs.-05-23-2001/JFW
 S AAQSPLR=$P($G(^VA(200,D0,"SPL")),U,1)  ; -05-23-2001/JFW
 I AAQSPLR="y"!(AAQSPLR="Y") S AAQSPLR="Yes"  ;-05-23-2001/JFW
 S:AAQSPLR'="Yes" AAQSPLR="No"
 W !!,"Allowed to Use Spooler : ",AAQSPLR,!  ;-05-23-2001/JFW
 I IOST["P-" W @IOF
 K %,%1,%2,%Y,AAQX,AAQUCI,I,J,X,XQI,XQLN,XQN,XQUSER,XQV,Y,ZTQUEUED
 K AAQSPLR  ; -05-23-2001/JFW
 ; D0 cannot be killed here or FileMan will error out when
 ; returning to the Print Template [XUSERINQFGO].
 Q
