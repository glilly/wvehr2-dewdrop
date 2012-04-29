SRTPLSTP        ;BIR/SJA - LIST ASSESSMENTS ;04/11/08
        ;;3.0; Surgery ;**167**;24 Jun 93;Build 27
        S (SRPAGE,SRSOUT,SRDFN)=0,$P(LINE,"=",132)="",$P(LINE1,"-",132)=""
        D HDR Q:SRSOUT
        F  S SRSD=$O(^SRT("AC",SRSD)) Q:'SRSD!(SRSD>SRED)!SRSOUT  S SRTPP=0 F  S SRTPP=$O(^SRT("AC",SRSD,SRTPP)) Q:'SRTPP!SRSOUT  S SR("RA")=$G(^SRT(SRTPP,"RA")) D
        .I (SRAST="ALL"!(SRAST[$P(SR("RA"),"^"))),$D(^SRT(SRTPP,0)),$$MANDIV(SRINSTP,SRTPP) D PRT
        Q
PRT     ; print assessments)
        I '$D(^SRT(SRTPP,"RA")) Q
        I SRTYPE'="ALL",(SRTYPE'=$P(^SRT(SRTPP,"RA"),"^",2)) Q
        I $Y+5>IOSL D HDR I SRSOUT Q
        S SRA(0)=^SRT(SRTPP,0),SRVACO=$P(^SRT(SRTPP,.01),"^",11),DFN=$P(SRA(0),"^"),SR("RA")=$G(^SRT(SRTPP,"RA"))
        N I D DEM^VADPT S SRANM=VADM(1),SRASSN=VA("PID") K VADM
        I $L(SRANM)>19 S SRANM=$P(SRANM,",")_","_$E($P(SRANM,",",2))_"."
        S Y=$P(SRA(0),"^",2) D D^DIQ S SRDT=$P(Y,"@")
        S Y=$P(SR("RA"),"^")
        W !,SRVACO,?16,SRANM_" ("_VA("PID")_")",?52,SRDT,?70,$S(Y="T":"TRANSMITTED",Y="C":"COMPLETE",Y="I":"INCOMPLETE",1:""),?87,$S($P(SRA(0),"^",3):$P(SRA(0),"^",3),1:"N/A")
        S Y=$P(SR("RA"),"^",2) W ?107,$S(Y="LI":"LIVER",Y="LU":"LUNG",Y="K":"KIDNEY",Y="H":"HEART",1:"")
        W !,LINE1
        Q
HDR     ; print heading
        I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
        S SRPAGE=SRPAGE+1 W:$Y @IOF W !,?53,"LIST OF TRANSPLANT ASSESSMENTS"
        W ?120,"PAGE "_SRPAGE,!,?(132-$L(SRINST)\2),SRINST,!,?58,"SURGERY SERVICE",?100,"DATE REVIEWED:"
        W !,?(132-$L(SRFRTO)\2),SRFRTO,?100,"REVIEWED BY:"
        W !!,"VACO ID",?16,"PATIENT",?52,"TRANSPLANT DATE",?70,"STATUS",?87,"SURGERY CASE #",?107,"ORGAN TYPE"
        W !,LINE
        Q
MANDIV(SRINST,CASE)     ;a boolean divisional call for managerial reports
        I '$D(^SRT(CASE,0)) Q 0
        I '$O(^SRO(133,1)) Q 1
        I SRINST["ALL" Q 1
        I +SRINST'>0 Q 0
        N SRDIV,SROR
        S SRDIV=$P($G(^SRT(CASE,8)),U)
        Q SRDIV=SRINST
