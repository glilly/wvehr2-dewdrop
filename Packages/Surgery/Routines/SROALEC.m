SROALEC ;BIR/ADM - LIST OF ELIGIBLE CASES ;02/04/08
        ;;3.0; Surgery ;**160,166**;24 Jun 93;Build 7
        S (GRAND,SRNEW,SRSOUT,TOT)=0,(SRHDR,SRPAGE)=1,SRTITLE="CASES ELIGIBLE FOR ASSESSMENT" K ^TMP("SRA",$J)
        I SRFLG,SRASP S SRSPEC=$P(^SRO(137.45,SRASP,0),"^")
        F  S SRSD=$O(^SRF("AC",SRSD)) Q:'SRSD!(SRSD>SRED)!SRSOUT  S SRTN=0 F  S SRTN=$O(^SRF("AC",SRSD,SRTN)) Q:'SRTN!SRSOUT  I $D(^SRF(SRTN,0)),$$MANDIV^SROUTL0(SRINSTP,SRTN) D UTL
        I SRSP S SRSS="" F  S SRSS=$O(^TMP("SRA",$J,SRSS)) Q:SRSS=""  D SRSD Q:SRSOUT  D:TOT TOT
        I 'SRSP S SRNEW=1,(SRSD,TOT)=0 F  S SRSD=$O(^TMP("SRA",$J,SRSD)) Q:'SRSD!SRSOUT  S SRTN=0 F  S SRTN=$O(^TMP("SRA",$J,SRSD,SRTN)) Q:'SRTN  S SRA=^(SRTN) D CASE Q:SRSOUT
        Q:SRSOUT  I SRSP,'SRFLG,GRAND D GRAND
        I SRFLG,'GRAND S SRSS=SRSPEC D HDR,GRAND
        I SRSP,'SRFLG,'GRAND S SRSS="" D HDR,GRAND
        I 'SRSP,'GRAND S SRSS="" D HDR,GRAND
        I 'SRSP,GRAND S SRSS="" D GRAND
        Q
UTL     ; set up TMP global
        N SRCPLT
        I '$P($G(^SRF(SRTN,.2)),"^",3)&'$P($G(^SRF(SRTN,.2)),"^",12) Q
        I $P($G(^SRF(SRTN,30)),"^") Q
        I SRFLG,$P(^SRF(SRTN,0),"^",4)'=SRASP Q
        S SRCPLT=$P($G(^SRO(136,SRTN,10)),"^") I SRCPLT,'$$XL^SROAX(SRTN) Q
        S SRA=$G(^SRF(SRTN,"RA"))
        I SRAST=1 Q:'($P(SRA,"^",2)="N"!($P(SRA,"^",2)="C"))!'($P(SRA,"^",6)="Y")
        I SRAST=2 Q:'($P(SRA,"^",2)="N"!($P(SRA,"^",2)="C"))!'($P(SRA,"^",6)="N")
        I SRAST=3 Q:$P(SRA,"^",2)'=""
        I SRSP S SRSS=$P(^SRF(SRTN,0),"^",4),SRSS=$S(SRSS:$P(^SRO(137.45,SRSS,0),"^"),1:"SPECIALTY NOT ENTERED"),^TMP("SRA",$J,SRSS,SRSD,SRTN)=SRA Q
        S ^TMP("SRA",$J,SRSD,SRTN)=SRA
        Q
SRSD    S SRNEW=1,(SRSD,TOT)=0 F  S SRSD=$O(^TMP("SRA",$J,SRSS,SRSD)) Q:'SRSD!SRSOUT  S SRTN=0 F  S SRTN=$O(^TMP("SRA",$J,SRSS,SRSD,SRTN)) Q:'SRTN  S SRA=^(SRTN) D CASE Q:SRSOUT
        Q
CASE    N SRA2 S SRA2=$P(SRA,"^",2) D
        .I SRA2="" S SRATYPE="NOT LOGGED" Q
        .I SRA2="N" D  Q
        .. I $P(SRA,"^",6)="N" S SRATYPE="EXCLUDED" Q
        .. S SRATYPE="NON-CARDIAC"
        .I SRA2="C" S SRATYPE="CARDIAC"
        S TOT=TOT+1,GRAND=GRAND+1 D PRINT
        Q
PRINT   ; print case info
        N SRDA,SRPROCS,SRSP1,SRY S SRPROCS=""
        I $Y+8>IOSL!SRNEW D PAGE I SRSOUT Q
        S SRA(0)=^SRF(SRTN,0),DFN=$P(SRA(0),"^") N I D DEM^VADPT S SRANM=VADM(1),SRASSN=VA("PID") K VADM
        I $L(SRANM)>19 S SRANM=$P(SRANM,",")_","_$E($P(SRANM,",",2))_"."
        S SRSP1="",X=$P(SRA(0),"^",4) S:X SRSP1=$P(^SRO(137.45,X,0),"^")
        S SROPER=$P(^SRF(SRTN,"OP"),"^") I $O(^SRF(SRTN,13,0)) S SROTHER=0 F I=0:0 S SROTHER=$O(^SRF(SRTN,13,SROTHER)) Q:'SROTHER  D OTHER
        K SROPS,MM,MMM S:$L(SROPER)<63 SROPS(1)=SROPER I $L(SROPER)>62 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
        S X=$P(SRA,"^"),SRSTATUS=$S(X="T":"TRANSMITTED",X="C":"COMPLETE",X="I":"INCOMPLETE",1:"NO ASSESSMENT"),Y=SRSD D D^DIQ S SRDT=$P(Y,"@")
        I $Y+7>IOSL D PAGE I SRSOUT Q
        W !,SRTN,?18,SRANM_" "_VA("PID"),?53,SRATYPE,?67,SRSTATUS,!,SRDT,?18,SROPS(1),! D
        .I 'SRSP W $E(SRSP1,1,17) F I=2:1 W:$D(SROPS(I)) ?18,SROPS(I),! I '$D(SROPS(I)) W ! Q
        .I SRSP F I=2:1 Q:'$D(SROPS(I))  W ?18,SROPS(I),!
        S SRY=$P($G(^SRO(136,SRTN,0)),"^",2) I SRY D CPT S SRPROCS=SRCODE
        S SRDA=0 F  S SRDA=$O(^SRO(136,SRTN,3,SRDA)) Q:'SRDA  S SRY=$P($G(^SRO(136,SRTN,3,SRDA,0)),"^") I SRY D CPT D
        .S SRPROCS=SRPROCS_", "_SRCODE
        I '$P($G(^SRO(136,SRTN,10)),"^"),$L(SRPROCS) W !,">>> Final CPT Coding is not complete."
        S:SRPROCS="" SRPROCS="NOT ENTERED" W !,"CPT Codes: ",SRPROCS
        I 'SRSOUT W ! F LINE=1:1:80 W "-"
        Q
CPT     ; check code for exclusion and get output value
        N Y,SREX S (SRCODE,SREX)=""
        S Y=$$CPT^ICPTCOD(SRY,$P(SRSD,".")),SRCODE=$P(Y,"^",2)
        S SREX="" I '$D(^SRO(137,SRY,0)) S SREX="*"
        S SRCODE=SREX_SRCODE
        Q
OTHER   ; other operations
        S SRLONG=1 I $L(SROPER)+$L($P(^SRF(SRTN,13,SROTHER,0),"^"))>125 S SRLONG=0,SROTHER=999,SROPERS=" ..."
        I SRLONG S SROPERS=$P(^SRF(SRTN,13,SROTHER,0),"^")
        S SROPER=SROPER_$S(SROPERS'=" ...":", "_SROPERS,1:SROPERS)
        Q
LOOP    ; break procedures
        S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<63  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
        Q
PAGE    I $E(IOST)="P"!SRHDR G HDR
        W !!,"Press <RET> to continue, or '^' to quit  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
        I X["?" W !!,"If you want to continue the listing, press the 'Enter' key.",!,"Type '^' to return to the menu." G PAGE
HDR     ; print heading
        W @IOF,!,?(80-$L(SRTITLE)\2),SRTITLE,?70,$J("PAGE "_SRPAGE,9) W:$E(IOST)="P" !,?(80-$L(SRINST)\2),SRINST W !,?(80-$L(SRFRTO)\2),SRFRTO
        W:$E(IOST)="P" !,?(80-$L(SRPRINT)\2),SRPRINT
        W !!,?50,"'*' Denotes Eligible CPT Code" I SRSP,SRSS'="" W !,">>> "_SRSS
        W !!,"CASE #",?18,"PATIENT",?53,"TYPE",?67,"STATUS",!,"OP DATE",?18,"OPERATION(S)",! W:'SRSP "SURG SPECIALTY",! F LINE=1:1:80 W "="
        S SRHDR=0,SRNEW=0,SRPAGE=SRPAGE+1
        Q
TOT     W !!,"TOTAL FOR "_SRSS_": ",TOT
        Q
GRAND   I 'SRSP W !!,"TOTAL: ",GRAND Q
        I SRSP,'SRFLG W !!,"TOTAL FOR ALL SPECIALTIES: ",GRAND Q
        I SRSP,SRFLG S SRSS=SRSPEC D TOT
        Q
