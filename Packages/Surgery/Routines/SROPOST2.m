SROPOST2 ;B'HAM ISC/MAM - POST INIT TO CONVERT OPERATION TIMES ; 18 JAN 1990  3:40 PM
 ;;3.0; Surgery ;**12**;24 Jun 93
 I 'SRVER Q
B W !!,"Re-indexing 'B' cross references in site configureable files...."
 F SRFILE=131.01,131.9,132,132.05,132.4,133.4,133.6,133.7,135,135.1,135.2,135.3,135.4,138 K ^SRO(SRFILE,"B"),DIK S DIK="^SRO("_SRFILE_",",DIK(1)=".01^B" D ENALL^DIK K DIK
 K SRFILE
 I $O(^SRO(131.25,0)) Q
 W !!,"Version 3.0 of the Surgery software will estimate the average length",!,"of time for a procedure (using CPT code) based on Surgical Specialty ",!,"instead of the individual surgeon.  The data in the Surgeon's Operation Times"
 W !,"file will be converted and stored in the Operation Times file.",!!
AGAIN K ^TMP("SR",$J) S X1=DT,X2=-12 D C^%DTC S SRSTOP=X
 S SRTN=0 F  S SRTN=$O(^SRF(SRTN)) Q:'SRTN  I $D(^SRF(SRTN,0)) S SRSDATE=$E($P($G(^SRF(SRTN,0)),"^",9),1,7) I SRSDATE,SRSDATE<SRSTOP D UTIL
 S SERVICE=0 F  S SERVICE=$O(^TMP("SR",$J,SERVICE)) Q:'SERVICE  D STUFF
 K CPT,I,MIN,SERVICE,SRSDATE,SRSTOP,SRTN,X,X1,^TMP("SR",$J)
 Q
UTIL ; find completed cases
 I '$D(^SRF(SRTN,.2)) Q
 I $P(^SRF(SRTN,0),"^",4)="" Q
 S X=$P(^SRF(SRTN,.2),"^",2),X1=$P(^SRF(SRTN,.2),"^",3) Q:X=""  I X1="" Q
 S CPT=$P(^SRF(SRTN,"OP"),"^",2) I CPT="" Q
MIN S Y=$E(X1_"000",9,10)-$E(X_"000",9,10)*60+$E(X1_"00000",11,12)-$E(X_"00000",11,12),X2=X,X=$P(X,".",1)'=$P(X1,".",1) D ^%DTC:X S MIN=X*1440+Y
 S SERVICE=$P(^SRF(SRTN,0),"^",4) I '$D(^TMP("SR",$J,SERVICE,CPT)) S ^TMP("SR",$J,SERVICE,CPT)=MIN_"^"_1 Q
 S $P(^TMP("SR",$J,SERVICE,CPT),"^",2)=$P(^TMP("SR",$J,SERVICE,CPT),"^",2)+1
 S $P(^TMP("SR",$J,SERVICE,CPT),"^")=$P(^TMP("SR",$J,SERVICE,CPT),"^")+MIN
 Q
STUFF ; stuff entries in file 131.25
 I '$D(^SRO(131.25,SERVICE,0)) K DD,DO S DIC="^SRO(131.25,",DIC(0)="L",DLAYGO=131.25,(X,DINUM)=SERVICE D FILE^DICN K DIC,DLAYGO,DINUM
 S ^SRO(131.25,SERVICE,1,0)="^131.251PA^0^0"
 S CPT=0 F I=0:0 S CPT=$O(^TMP("SR",$J,SERVICE,CPT)) Q:'CPT  D CPT
 Q
CPT ; stuff CPT info
 S ^SRO(131.25,SERVICE,1,CPT,0)=CPT_"^"_^TMP("SR",$J,SERVICE,CPT)
 S $P(^SRO(131.25,SERVICE,1,0),"^",3)=CPT,$P(^(0),"^",4)=$P(^(0),"^",4)+1
 Q
NEW ; create entry in Surgery Site Parameters file
 K DIC,DD,DO,DA,DINUM S DIC="^SRO(133,",DIC(0)="L",DLAYGO=133,X=SRINST D FILE^DICN K DIC,DD,DO,DA,DLAYGO
 Q
TIMES ; convert operation times - SR*3*12
 D WAIT^DICD K ^SRO(131.25) S ^SRO(131.25,0)="OPERATION TIMES^131.25P^^"
 D AGAIN W !!,"Finished"
 Q
