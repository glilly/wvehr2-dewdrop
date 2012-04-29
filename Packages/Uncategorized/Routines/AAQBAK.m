AAQBAK ;FGO/JFW;Make Packman Msgs; [11/17/99 10:21am]
 ;;8.0;KERNEL;**L33**;Nov 16, 1999
 ; New after patch XM*7.1*50 - 11-16-99/L33/JFW
 ; Called by AAQMENU - L33/JFW
EN ;
 ; Make Mailman Packman Message
 D CHECKIN^XM
 D PAKMAN^XMJMS
 D CHECKOUT^XM,KILL^XM
 Q
 ; Backup a Transport Global
EN2 ;
 D ^XPDZIB
 K AAQBAK,AAQROU
 Q
