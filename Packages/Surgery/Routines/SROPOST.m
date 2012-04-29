SROPOST ;B'HAM ISC/MAM - POST INIT FOR V3 ; 16 JAN 1990  10:35 AM
 ;;3.0; Surgery ;**6**;24 Jun 93
 S SRVER=1,SRSITE=$O(^SRO(133,0)) I 'SRSITE D NEW^SROPOST2
 I SRSITE S Z=$P(^SRO(133,SRSITE,0),"^",3) I Z["3.0" S SRVER=0
 I SRVER D SEC
 I SRVER K ^SRF("AC"),^SRF("ADT"),DIK S DIK="^SRF(",DIK(1)=".09^AC^ADT" D ENALL^DIK K DIK
 I SRVER S DIK="^SRF(",DIK(1)="11^AMM" D ENALL^DIK K DIK
ADDSUB I SRVER F SRROOM=0:0 S SRROOM=$O(^SRS(SRROOM)) Q:SRROOM'>0  K:$P($G(^SRS(SRROOM,4,0)),"^",2)=131.177 ^SRS(SRROOM,4) S:'$D(^SRS(SRROOM,4,0)) ^SRS(SRROOM,4,0)="^131.711S^^" D DAY
 D ^SROPOST0,^SROPOST1,^SROPOST2
 I 'SRVER K DIK S DIK="^SRO(137.45,",DIK(1)=".01^B1" D ENALL^DIK K DIK
 S X=0 F I=0:0 S X=$O(^SRO(133,X)) Q:'X  S $P(^SRO(133,X,0),"^",3)="3.0"
 W !!,"Installation of Surgery Version 3.0 is finished.",! K SRVER,SRSITE,SRINST
 Q
SEC W !!,"Updating security keys based on User Title for use with the Anestesia AMIS..."
 K ^TMP("SR CORRUPT",$J) S SRK7=$S($D(^DD(19.12)):0,1:1),SHEMP=0 F  S SHEMP=$O(^VA(200,SHEMP)) Q:'SHEMP  D KEY
 I $O(^TMP("SR CORRUPT",$J,0)) D CORRUPT
 D ^SRONIT
 K CHECK,DA,DD,DIC,DIE,DO,MOE,SHEMP,SRK7
 Q
KEY ; update security keys
 I '$D(^VA(200,SHEMP,0)) S ^TMP("SR CORRUPT",$J,SHEMP)="" Q
 S X=$P(^VA(200,SHEMP,0),"^",9) Q:'X  Q:'$D(^DIC(3.1,X,0))  S DIC(0)="N",DIC=3.1 D ^DIC K DIC Q:Y<0  S MOE=$P(Y,"^",2)
 S CHECK=0 I MOE["NURSE ANE" S CURLEY="SR NURSE ANESTHETIST",CHECK=1
 I MOE["ANESTHESIOLOGIST" S CURLEY="SR ANESTHESIOLOGIST",CHECK=1
 I MOE["PHYSICIAN" S CURLEY="SR SURGEON",CHECK=1
 I CHECK,$D(^XUSEC(CURLEY,SHEMP)) S CHECK=0
 I 'CHECK Q
 S MOE=$O(^DIC(19.1,"B",CURLEY,0)) I 'MOE Q
 I SRK7 D K7 Q
 I '$D(^DIC(19.1,MOE,2,0)) S ^DIC(19.1,MOE,2,0)="^19.12^^"
 K DA,DIC,DINUM,DD,DO S DIC(0)="L",DLAYGO=19.12,DIC="^DIC(19.1,"_MOE_",2,",X=SHEMP,DA(1)=MOE D FILE^DICN K DIC,DLAYGO,Y
 Q
K7 ; update key if Kernel 7 or greater
 K DA,DIC I '$D(^VA(200,SHEMP,51,0)) S ^VA(200,SHEMP,51,0)="^"_$P(^DD(200,51,0),"^",2)
 S DA(1)=SHEMP,DIC="^VA(200,"_SHEMP_",51,",DIC(0)="LM",DLAYGO=200.051,(DINUM,X)=MOE D FILE^DICN K DIC,DLAYGO,Y
 Q
CORRUPT ; send message regarding corrupted entries in ^VA(200
 S XMDUZ="SURGERY POST-INIT",XMSUB="Missing Zero Nodes in NEW PERSON file (200)",XMTEXT="CURLEY(",XMY(DUZ)=""
 S CURLEY(1)="The information provided in this message was determined by the post-init",CURLEY(2)="routine for Surgery Version 3.0.",CURLEY(3)="  "
 S CURLEY(4)="The following list contains entries in the NEW PERSON file (200) that do not",CURLEY(5)="have zero nodes.  The cause of this corruption cannot be determined by this "
 S CURLEY(6)="process.  You should review the global and kill any nodes that do not have a",CURLEY(7)="zero node associated with them.  If you are not sure how to clean up this file"
 S CURLEY(8)="please contact your local ISC.",CURLEY(9)="  ",CURLEY(10)="The following entries in ^VA(200) are missing the zero node."
 S CNT=10,X=0 F  S X=$O(^TMP("SR CORRUPT",$J,X)) Q:'X  S CNT=CNT+1,CURLEY(CNT)="  Internal Entry Number: "_X
 D ^XMD K CURLEY,X
 Q
DAY ; add days of the week that do not exist
 Q:SRROOM=0
 F SRDAY=0:1:6 I '$D(^SRS(SRROOM,4,"B",SRDAY)) K DD,DO,DIC S DIC="^SRS("_SRROOM_",4,",DIC(0)="LMZ",DA(1)=SRROOM,X=SRDAY D FILE^DICN K DD,DO,DIC
 Q
