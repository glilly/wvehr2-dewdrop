AAQPKCHG ;DRM/438;;6/24/91;;Name change for Packman routines [ 07/31/92  5:06 PM ]
 ;;1.0;From Dan Miller@Sioux Falls;Orginally named ZZDPKCHG;;Build 1
 ;Modified to automatically change uppercase to lowercase
 W !!,"Routine names within the PackMan message will",!,"be changed from uppercase to lowercase.",!,"Lowercase characters will be left unchanged."
EN W !!,"Enter Subj: [Message #]: " R ZMSG:DTIME Q:ZMSG=""!(ZMSG="^")!('$T)  G:'$D(^XMB(3.9,ZMSG,0)) EN W !,$P(^XMB(3.9,ZMSG,0),"^",1),!
 S ZLN=0 F  S ZLN=$O(^XMB(3.9,ZMSG,2,ZLN)) Q:'ZLN  I $E(^(ZLN,0),1,4)="$ROU" D CHNG
 I '$D(ZRTN) W !,"Couldn't find the routine(s)!" K ZMSG,ZLN G EN
 W !,"Done" K ZMSG,ZLN,ZRTN,ZZRTN,ZX,ZXX G EN
 Q
CHNG S ZRTN=$P(^(0)," ",2) W !,"Routine: ",ZRTN,?21,"Change to: " D CHNG2
 S $P(^(0)," ",2)=ZZRTN F  S ZLN=$O(^XMB(3.9,ZMSG,2,ZLN)) Q:$E(^(ZLN,0))="$"!('ZLN)
 I $P(^XMB(3.9,ZMSG,2,$S(+ZLN:ZLN,1:0),0)," ",3)=ZRTN S $P(^(0)," ",3)=ZZRTN Q
 E  G ERR
ERR W !,"Routine: ",ZRTN," is not standard pack routine - Better do this one manually!"
 Q
CHNG2 S ZX=ZRTN,ZXX="" D
 .F KK=1:1:$L(ZX) S:$E(ZX,KK)?1U ZXX=ZXX_$C($A(ZX,KK)+32) S:$E(ZX,KK)'?1U ZXX=ZXX_$E(ZX,KK)
 .W ZXX
 .S ZZRTN=ZXX Q
