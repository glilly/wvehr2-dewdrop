AUPNLKID ; IHS/CMI/LAB - IHS IDENTIFIERS FOR FILE 2 ;12/26/06  10:53
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;
START ; EXTERNAL ENTRY POINT -
 D:$X>43 EN^DDIOL("","","!") ;Y2000
 ; VALUE OF THE NAKED INDICATOR TO BE PROVIDED BY CALLING ROUTINE
 ;I $D(DIQUIET) S ^TMP("DILIST",$J,"IHS",DICOUNT)=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_$E($P(^(0),U,3),2,3)_" "_$J($P(^(0),U,9),9) ;IHS/ANMC/LJF 8/7/97 added for Kernel Broker calls-see ^XWBFM ;Y2000
 I $D(DIQUIET) S ^TMP("DILIST",$J,"IHS",DICOUNT)=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$J($P(^(0),U,9),9) ;Y2000
 ;K AUPNA I '$D(DIQUIET) NEW % S %=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_$E($P(^(0),U,3),2,3)_" "_$J($P(^(0),U,9),9) S AUPNA(1)=%,AUPNA(1,"F")="?45" ;Y2000 commented out and replaced with line below
 K AUPNA I '$D(DIQUIET) NEW % S %=$P(^(0),U,2)_" "_$E($P(^(0),U,3),4,5)_"-"_$E($P(^(0),U,3),6,7)_"-"_(1700+$E($P(^(0),U,3),1,3))_" "_$J($P(^(0),U,9),9) S AUPNA(1)=%,AUPNA(1,"F")="?43" ;Y2000 - display 4 digit year
 ;end Y2K for display of  4 digit DOB
 I '$D(DIQUIET) S AUPNA(1)=$$CWAD(Y)_AUPNA(1),AUPNA(1,"F")="?37"
NOTALL I '$G(AUPNLK("ALL")),$G(DUZ(2)),'$D(DIQUIET),$D(^AUPNPAT(Y,41,DUZ(2),0)) NEW % S %=" "_$J($P(^AUTTLOC(DUZ(2),0),U,7),4)_" "_$P(^AUPNPAT(Y,41,DUZ(2),0),U,2) S AUPNA(1)=AUPNA(1)_" "_%
ALL I $G(AUPNLK("ALL")),$D(^AUPNPAT(Y,41)) D CHARTS
 S:$D(DDS) DDSID=1 D EN^DDIOL(.AUPNA) K AUPNA,DDSID
 I @(DIC_"Y,0)") ; reset the naked
 Q
 ;
CHARTS ;
 N C,%,TAB S AUPNLKF=0
 S C=1 F AUPNLKI=0:1 S AUPNLKF=$O(^AUPNPAT(Y,41,AUPNLKF)) Q:AUPNLKF'=+AUPNLKF  D
 .I AUPNLKI S C=C+1
 .S %=$J($P(^AUTTLOC(AUPNLKF,0),U,7),4)_" "_$P(^AUPNPAT(Y,41,AUPNLKF,0),U,2)_$S($P(^(0),U,3)="":"",1:"("_$P(^(0),U,5)_")")
 .S TAB=66 I $L($G(AUPNA(C)))+$L(%)>42 S C=C+1,TAB=79-$L(%)
 .S:'$D(AUPNA(C)) AUPNA(C)=""
 .S AUPNA(C)=AUPNA(C)_" "_% S:'$D(AUPNA(C,"F")) AUPNA(C,"F")="!?"_TAB
 K AUPNLKF,AUPNLKI
 Q
 ;
 ;
 ;
 ;
IHSDUPE ; EXTERNAL ENTRY PONT - FOLLOW MERGE CHAIN
 ; VALUE OF THE NAKED INDICATOR TO BE PROVIDED BY CALLING ROUTINE
 F AUPLKL=0:0 Q:'$P(^(0),U,19)  S AUPMAP=$P(^(0),U,19) D EN^DDIOL("<Merged to "_$P(^DPT(AUPMAP,0),U,1)_">","","!?10") ; Will abort if no ^DPT entry
 K AUPLKL
 I $D(AUPMAP) S AUPMAPY=Y,Y=AUPMAP K AUPMAP
 I @(DIC_"Y,0)") ; reset the naked
 Q
 ;
CWAD(Y) ; -- returns cwad initials;IHS/ANMC/LJF 5/26/98
 NEW X,DFN,GMRPCWAD
 S X="GMRPNOR1" X ^%ZOSF("TEST") I '$T Q "       "
 S X=$$CWAD^GMRPNOR1(+Y) I '$L(X) Q "       "
 S X="<"_X_">",X=$E(X_"    ",1,7)
 Q X
