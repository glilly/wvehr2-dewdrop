DGJPDEF2 ;ALB/MAF - PHYSICIAN DEFICIENCY PRINT ROUTINE (CONT) ; NOV 10 1992@300
 ;;1.0;Incomplete Records Tracking;;Jun 25, 2001
 D HEAD F DGJ=0:0 S DGJTDV=$O(^TMP("VAS",$J,DGJTDV)) Q:DGJTDV']""!(DGU)  S DGJTF=1 D @(DGJTL) Q:DGU 
 G:DGU QUIT I DGJTLPG'=1,$D(^TMP("VAS",$J)) D RET G:DGU QUIT D ^DGJPDEF3
 F X=$Y:1:(IOSL-3) W !
 D DIV
QUIT G QUIT^DGJPDEF
 F X=$Y:1:(IOSL-3) W ! D DIV
HD1 W ?88,$J($P(DGJTDL,"^",2),7)
 W ?97,$J($P(DGJTDL,"^",3),7)
 W ?106,$J($P(DGJTDL,"^",4),7)
 W ?116 S X=$P(DGJTDL,"^",2)+$P(DGJTDL,"^",3)+$P(DGJTDL,"^",4)+$P(DGJTDL,"^",1) W $J(X,7)
 W ?128 S X=$S(X-30'>0:0,1:X-30) W $J(X,4)
 Q
SET S DGJTDV1=DGJTDV,DFN=DGJTDL Q
DIV S X=$O(^DG(40.8,"B",DGJTDV1,0)) I $D(^DG(40.8,+X,"DT")) S DGJTDEL=^("DT") W $P(DGJTDEL,"^",9),! Q
 Q
DATE S DGJTX=$$FMTE^XLFDT(DGJTDT,"5DF"),DGJTX=$TR(DGJTX," ","0") W DGJTX K DGJTX Q
DATE1 S X=$$FMTE^XLFDT(X,"5DF"),X=$TR(X," ","0") W X Q
PHY D:'DGJTFF HDR
 F DGJY=0:0 S DGJTPHY=$O(^TMP("VAS",$J,DGJTDV,DGJTPHY)) Q:DGJTPHY']""!(DGU)  D:DGJTFF RET Q:DGU  D:DGJTFF HEAD,HDR D HDR1 S DGJTFF=1 F DGJJ=0:0 S DGJTPT=$O(^TMP("VAS",$J,DGJTDV,DGJTPHY,DGJTPT)) Q:DGJTPT']""!(DGU)  D PHY1 Q:DGU
 Q
PHY1 F DGJADM=-1:0 S DGJADM=$O(^TMP("VAS",$J,DGJTDV,DGJTPHY,DGJTPT,DGJADM)) Q:DGJADM']""!(DGU)  F IFN=0:0 S IFN=$O(^TMP("VAS",$J,DGJTDV,DGJTPHY,DGJTPT,DGJADM,IFN)) Q:'IFN!(DGU)  S DGJTDL=^(IFN) D SET I $D(^VAS(393,IFN,0)) D PRT2 Q:DGU
 Q
SER D:'DGJTFF HDR
 F DGJY=0:0 S DGJTSV=$O(^TMP("VAS",$J,DGJTDV,DGJTSV)) Q:DGJTSV']""!(DGU)  D:DGJTFF RET Q:DGU  D:DGJTFF HEAD,HDR D HDR2 S DGJTFF=1 F DGJJ=0:0 S DGJTSP=$O(^TMP("VAS",$J,DGJTDV,DGJTSV,DGJTSP)) Q:DGJTSP']""!(DGU)  D HDR3,SER1 Q:DGU
 Q
PAT D:'DGJTFF HDR
 F DGJY=0:0 S DGJTPT=$O(^TMP("VAS",$J,DGJTDV,DGJTPT)) Q:DGJTPT']""!(DGU)  D:DGJTFF RET Q:DGU  D:DGJTFF HEAD,HDR D HDR4 S DGJTFF=1 F DGJADM=-1:0 S DGJADM=$O(^TMP("VAS",$J,DGJTDV,DGJTPT,DGJADM)) Q:DGJADM']""!(DGU)  D PAT1 Q:DGU
 Q
PAT1 F DGJJ=0:0 S DGJTPHY=$O(^TMP("VAS",$J,DGJTDV,DGJTPT,DGJADM,DGJTPHY)) Q:DGJTPHY']""!(DGU)  F IFN=0:0 S IFN=$O(^TMP("VAS",$J,DGJTDV,DGJTPT,DGJADM,DGJTPHY,IFN)) Q:'IFN!(DGU)  S DGJTDL=^(IFN) D SET I $D(^VAS(393,IFN,0)) D PRT2 Q:DGU
 Q
SER1 F DGJP=0:0 S DGJTPT=$O(^TMP("VAS",$J,DGJTDV,DGJTSV,DGJTSP,DGJTPT)) Q:DGJTPT']""!(DGU)  D SER2
 Q
SER2 F DFN=0:0 S DFN=$O(^TMP("VAS",$J,DGJTDV,DGJTSV,DGJTSP,DGJTPT,DFN)) Q:'DFN!(DGU)  F IFN=0:0 S IFN=$O(^TMP("VAS",$J,DGJTDV,DGJTSV,DGJTSP,DGJTPT,DFN,IFN)) Q:'IFN!(DGU)  S DGJTDL=^(IFN) D SET I $D(^VAS(393,IFN,0)) D PRT2 Q:DGU
 Q
PRT2 D RELP Q:DGU  S DGJTNODE=^VAS(393,IFN,0)
 I DGJTL="PAT" S X="",X=$S($P(DGJTPHY,"^",2)]"":$E($P($G(^VA(200,$P(DGJTPHY,"^",2),0)),"^",1),1,20),1:"NOT SPECIFIED") W !,$S(X]"":X,1:"NOT SPECIFIED")
 I DGJTL="PHY" W !,$E($P(^DPT($P(DGJTPT,"^",2),0),"^",1),1,20)
 I DGJTL="SER" W !,$E($P(^DPT($P(DGJTPT,"^",2),0),"^",1),1,16)
 D PID^VADPT6 W:DGJTL="SER" ?19 W:DGJTL'="SER" ?23 W VA("BID")
 S DGJTDT=$S($D(^DGPM(+$P(DGJTNODE,"^",4),0)):$P(^DGPM(+$P(DGJTNODE,"^",4),0),"^",1),1:"OUTPATIENT") W:DGJTL="SER" ?27 W:DGJTL'="SER" ?31 D:DGJTDT]""&(DGJTDT'="OUTPATIENT") DATE I DGJTDT="OUTPATIENT" W DGJTDT
 W:DGJTL="SER" ?40 W:DGJTL'="SER" ?44 S X=$P(^VAS(393,IFN,0),"^",2) W $S($D(^VAS(393.3,+X,0)):$E($P(^VAS(393.3,+X,0),"^",1),1,10),1:"NOT SPECIF")
 S X=$P(^VAS(393,IFN,0),"^",12),X=$S(X]""&($D(^VA(200,+X,0))):$P(^VA(200,X,0),"^",1),1:"NOT SPECIFIED") W:DGJTL="SER" ?57,$E(X,1,10)
 S X=IFN I X]"",$D(^VAS(393,+X,0)) S X=$P(^VAS(393,+X,0),"^",3) W ?70 S X=$$FMTE^XLFDT(X,"5DF") S:X]"" X=$TR(X," ","0") W X
 W ?82 S X=$P(DGJTNODE,"^",11) W $S($D(^DG(393.2,+X,0)):$E($P(^DG(393.2,X,0),"^",1),1,10),1:"")
 S DFN=$P(DGJTNODE,"^",1) S RTE=DFN_";DPT(",RTYPE=$$RECTYP^DGJOPRT1(DGJTNODE) D LATEST^RTUTL3
 W ?95,$E($P(RTDATA,"^",2),1,10),?107,$E($P(RTDATA,"^",3),1,10),?121 S X="" S X=$P(RTDATA,"^",4) D:RTDATA]"" DATE1 Q
HEAD D HEAD^DGJPDEF3 Q
RET F X=$Y:1:(IOSL-3) W !
 D DIV Q:IOST'?1"C-".E
 R ?22,"Enter <RET> to continue or ^ to QUIT ",X:DTIME S:X["^"!('$T) DGU=1 Q:DGU  S DGFLAG=1 Q
RELP I $Y+8>IOSL D RET:(IOST?1"C-".E) Q:DGU  D HEAD
 Q
HDR W !?5,"DIVISION: ",$S($D(^DG(40.8,+$P(DGJTDV,"^",2),0)):$P(^DG(40.8,$P(DGJTDV,"^",2),0),"^",1),1:"NOT SPECIFIED") Q
HDR1 W !?6,"PHYSICIAN: ",$S($P(DGJTPHY,"^",2)]""&($D(^VA(200,+$P(DGJTPHY,"^",2),0))):$P(^VA(200,$P(DGJTPHY,"^",2),0),"^",1),1:"NOT SPECIFIED") Q
HDR2 W !?6,"SERVICE: ",$S($P(DGJTSV,"^",2)]"":$P(^DG(393.1,$P(DGJTSV,"^",2),0),"^",1),1:"NOT SPECIFIED") Q
HDR3 W !?7,"SPECIALTY: ",$S($P(DGJTSP,"^",2)]"":$P(^DIC(45.7,$P(DGJTSP,"^",2),0),"^",1),1:"NOT SPECIFIED") Q
HDR4 W !?6,"PATIENT: ",$P(^DPT($P(DGJTPT,"^",2),0),"^",1) Q
SV D SV^DGJPDEF3 Q
