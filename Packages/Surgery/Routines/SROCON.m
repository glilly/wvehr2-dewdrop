SROCON ;B'HAM ISC/MAM - STUFF ENTRY IN CONCURRENT CASE ;23 AUG 1990  9:15 AM
 ;;3.0;Surgery;**78,119,161**;24 Jun 93;Build 5
 I $D(SRNOCON),SRNOCON=1 Q
 I $D(SRFLAG) S SRCON=$P(^SRF(DA(1),"CON"),"^")
 I '$D(SRFLAG) S SRCON=$P(^SRF(DA,"CON"),"^")
ASK W !!,"Do you want to store this information in the concurrent case ?  YES//  " R SRYN:DTIME I '$T!(SRYN["^") S SRYN="N" Q
 S:SRYN="" SRYN="Y" S SRYN=$E(SRYN) I "YyNn"'[SRYN D HELP G ASK
 I "Yy"'[SRYN W ! Q
STUFF ; concatonate field to SRODR
 W ! I $G(SRFLAG)=1 S SRODR(130.213,DA(2)_","_SRCON_",",SRFLD)=X K SRFLAG Q
 S SRODR(130,SRCON_",",SRFLD)=X
 Q
HELP ;
 S SRMX=X W @IOF S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT S X=SRMX  ;; < RJS *161 >
 W !!,"There is a concurrent surgical case associated with this procedure.  A brief",!,"description of that case is listed below."
 S SROPER=$P(^SRF(SRCON,"OP"),"^") I $O(^SRF(SRCON,13,0)) S SROTHER=0 F I=0:0 S SROTHER=$O(^SRF(SRCON,13,SROTHER)) Q:'SROTHER  D OTHER
 K SROPS,MM,MMM S:$L(SROPER)<65 SROPS(1)=SROPER I $L(SROPER)>64 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 S SRSUR=$S($D(^SRF(SRCON,.1)):$P(^(.1),"^",4),1:"") S:'SRSUR SRSUR="NOT ENTERED" S:SRSUR SRSUR=$P(^VA(200,SRSUR,0),"^")
 S SRSS=$P(^SRF(SRCON,0),"^",4) S:'SRSS SRSS="NOT ENTERED" S:SRSS SRSS=$P(^SRO(137.45,SRSS,0),"^")
 W !!,"Surgeon: "_SRSUR,!,"Surgical Specialty: "_SRSS,!!,"Procedure: ",?12,SROPS(1) I $D(SROPS(2)) W !,?12,SROPS(2) I $D(SROPS(3)) W !,?12,SROPS(3) I $D(SROPS(4)) W !,?12,SROPS(4)
 W !!,"If you answer 'YES', the information you entered for this field will also",!,"be stored for the concurrent case.  If this information is not pertinent for",!,"the concurrent case, enter 'NO'.",!!
 Q
OTHER ; other operations
 S SRLONG=1 I $L(SROPER)+$L($P(^SRF(SRCON,13,SROTHER,0),"^"))>235 S SRLONG=0,SROTHER=999,SROPERS=" ..."
 I SRLONG S SROPERS=$P(^SRF(SRCON,13,SROTHER,0),"^")
 S SROPER=SROPER_$S(SROPERS=" ...":SROPERS,1:", "_SROPERS)
 Q
LOOP ; break procedure
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<65  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
