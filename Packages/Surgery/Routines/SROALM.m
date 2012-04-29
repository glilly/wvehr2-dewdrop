SROALM  ;BIR/ADM - LIST OF ASSESSMENTS MISSING INFORMATION ;12/05/07
        ;;3.0; Surgery ;**38,50,88,142,153,160,166**;24 Jun 93;Build 7
        S (GRAND,SRNEW,SRSOUT,TOT)=0,(SRHDR,SRPAGE)=1,SRTITLE="COMPLETED/TRANSMITTED ASSESSMENTS MISSING INFORMATION" K ^TMP("SRA",$J)
        I SRFLG,SRASP S SRSPEC=$P(^SRO(137.45,SRASP,0),"^")
        F  S SRSD=$O(^SRF("AC",SRSD)) Q:'SRSD!(SRSD>SRED)!SRSOUT  S SRTN=0 F  S SRTN=$O(^SRF("AC",SRSD,SRTN)) Q:'SRTN!SRSOUT  D
        .S SR("RA")=$G(^SRF(SRTN,"RA")) I $P(SR("RA"),"^")="C"!($P(SR("RA"),"^")="T"),$D(^SRF(SRTN,0)),$$MANDIV^SROUTL0(SRINSTP,SRTN) D UTL
        I SRSP S SRSS="" F  S SRSS=$O(^TMP("SRA",$J,SRSS)) Q:SRSS=""  D SRSD Q:SRSOUT  D:TOT TOT
        I 'SRSP S SRNEW=1,(SRSD,TOT)=0 F  S SRSD=$O(^TMP("SRA",$J,SRSD)) Q:'SRSD!SRSOUT  S SRTN=0 F  S SRTN=$O(^TMP("SRA",$J,SRSD,SRTN)) Q:'SRTN  S SRA=^(SRTN) D CASE Q:SRSOUT
        Q:SRSOUT  I SRSP,'SRFLG,GRAND D GRAND
        I SRFLG,'GRAND S SRSS=SRSPEC D HDR,GRAND
        I SRSP,'SRFLG,'GRAND S SRSS="" D HDR,GRAND
        I 'SRSP,'GRAND S SRSS="" D HDR,GRAND
        I 'SRSP,GRAND S SRSS="" D GRAND
        Q
UTL     ; set up TMP global
        I SRFLG,$P(^SRF(SRTN,0),"^",4)'=SRASP Q
        I SRSP S SRSS=$P(^SRF(SRTN,0),"^",4),SRSS=$S(SRSS:$P(^SRO(137.45,SRSS,0),"^"),1:"SPECIALTY NOT ENTERED"),^TMP("SRA",$J,SRSS,SRSD,SRTN)=SR("RA") Q
        S ^TMP("SRA",$J,SRSD,SRTN)=SR("RA")
        Q
SRSD    S SRNEW=1,(SRSD,TOT)=0 F  S SRSD=$O(^TMP("SRA",$J,SRSS,SRSD)) Q:'SRSD!SRSOUT  S SRTN=0 F  S SRTN=$O(^TMP("SRA",$J,SRSS,SRSD,SRTN)) Q:'SRTN  S SRA=^(SRTN) D CASE Q:SRSOUT
        Q
CASE    I $P(SRA,"^",2)="N",$P(SRA,"^",6)="Y" S SRATYPE="NON-CARDIAC" D CHK^SROAUTL
        I $P(SRA,"^",2)="N",$P(SRA,"^",6)="N" S SRATYPE="EXCLUDED" D CHK^SROAUTL3
        I $P(SRA,"^",2)="C" S SRATYPE="CARDIAC" D CHK^SROAUTLC
        S SRFLD="" I $O(SRX(SRFLD))'="" S TOT=TOT+1,GRAND=GRAND+1 D PRINT Q
        I '$P($G(^SRO(136,SRTN,10)),"^")!('$P($G(^SRO(136,SRTN,0)),"^",2))!('$P($G(^SRO(136,SRTN,0)),"^",3)) D PRINT
        Q
PRINT   ; print assessments
        K SRCPTT S SRCPTT="NOT ENTERED"
        I $Y+5>IOSL!SRNEW D PAGE I SRSOUT Q
        S SRA(0)=^SRF(SRTN,0),DFN=$P(SRA(0),"^") N I D DEM^VADPT S SRANM=VADM(1),SRASSN=VA("PID") K VADM
        I $L(SRANM)>19 S SRANM=$P(SRANM,",")_","_$E($P(SRANM,",",2))_"."
        S SROPER=$P(^SRF(SRTN,"OP"),"^") I $O(^SRF(SRTN,13,0)) S SROTHER=0 F I=0:0 S SROTHER=$O(^SRF(SRTN,13,SROTHER)) Q:'SROTHER  D OTHER
        K SROPS,MM,MMM S:$L(SROPER)<63 SROPS(1)=SROPER I $L(SROPER)>62 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
        S SRSTATUS=$S($P(SRA,"^")="T":"TRANSMITTED",1:"COMPLETE"),Y=SRSD D D^DIQ S SRDT=$P(Y,"@")
        I $Y+5>IOSL D PAGE I SRSOUT Q
        W !,SRTN,?18,SRANM_" "_VA("PID"),?53,SRATYPE,?68,SRSTATUS,!,SRDT F I=1:1 Q:'$D(SROPS(I))  W ?18,SROPS(I),!
        N I,SRPROC,SRL S SRL=100 D CPTS^SROAUTL0 W ?18,"CPT Codes: "
        F I=1:1 Q:'$D(SRPROC(I))  W:I=1 ?29,SRPROC(I) W:I'=1 !,?29,SRPROC(I)
        S CNT=1 W !,?5,"Missing information:"
        I '$P($G(^SRO(136,SRTN,10)),"^")!('$P($G(^SRO(136,SRTN,0)),"^",2))!('$P($G(^SRO(136,SRTN,0)),"^",3)) W !,$J(CNT_". ",8),"The final coding for Procedure and Diagnosis is not complete." S CNT=CNT+1
        F  S SRFLD=$O(SRX(SRFLD)) Q:SRFLD=""  D:$Y+5>IOSL PAGE Q:SRSOUT  W !,$J(CNT_". ",8),$P(SRX(SRFLD),":") S CNT=CNT+1
        I 'SRSOUT W ! F LINE=1:1:80 W "-"
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
        I X["?" W !!,"If you want to continue listing incomplete assessments, enter <RET>.  Enter",!,"'^' to return to the menu." G PAGE
HDR     ; print heading
        W @IOF,!,?(80-$L(SRTITLE)\2),SRTITLE,?70,$J("PAGE "_SRPAGE,9) W:$E(IOST)="P" !,?(80-$L(SRINST)\2),SRINST W !,?(80-$L(SRFRTO)\2),SRFRTO
        W:$E(IOST)="P" !,?(80-$L(SRPRINT)\2),SRPRINT I SRSP,SRSS'="" W !!,"** "_SRSS
        W !!,"ASSESSMENT #",?18,"PATIENT",?53,"TYPE",?68,"STATUS",!,"OPERATION DATE",?18,"OPERATION(S)",! F LINE=1:1:80 W "="
        S SRHDR=0,SRNEW=0,SRPAGE=SRPAGE+1
        Q
TOT     W !!,"TOTAL FOR "_SRSS_": ",TOT
        Q
GRAND   I 'SRSP W !!,"TOTAL: ",GRAND Q
        I SRSP,'SRFLG W !!,"TOTAL FOR ALL SPECIALTIES: ",GRAND Q
        I SRSP,SRFLG S SRSS=SRSPEC D TOT
        Q
