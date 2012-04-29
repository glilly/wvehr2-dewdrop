ECXALAR2        ;ALB/TMD-LAR Extract Report of Untranslatable Results ; 8/9/06 9:45am
        ;;3.0;DSS EXTRACTS;**46,51,112**;Dec 22, 1997;Build 26
        ;
EN      ; entry point
        N COUNT
        K ^TMP($J)
        S COUNT=0
        S ECSD=ECSD1,ECED=ECED+.3
        D PROCESS
        Q
        ;
PROCESS ;
        N QFLG,ECDTST,ECLTST,ECWCDA,ECWC,ECLOC,ECLRN,ECRES,EC2,ECN,ECRS,ECTRS,ECTRANS,ECTRIEN,ECSCDT,ECSCTM,ECXDFN
        K ^LAR(64.036) S LRSDT=$P(ECSD,"."),LREDT=$P(ECED,".")
        D ^LRCAPDAR
        ;quit if no completion date for API compile
        ;I '$P($G(^LAR(64.036,1,2,1,0)),U,4) S ECXERR=1 Q
        ;build local array of workload codes from DSS LOINC codes
        N ECLOINC,ECA K ECLOC,ECA S ECLOINC=0
        S ECA("ALL")="" D LOINC^ECXUTL6(.ECA) ;builds ^tmp
        F  S ECLOINC=$O(^TMP($J,"ECXUTL6",ECLOINC)) Q:(ECLOINC="")  D
        . S ECWCDA=0 F  S ECWCDA=$O(^TMP($J,"ECXUTL6",ECLOINC,ECWCDA)) Q:('ECWCDA)  D
        .. I ECWCDA S ECWC=$P(^LAM(ECWCDA,0),U,2),ECLOC(ECWCDA)=ECWC
        K ECLOINC,ECA
        ;process temporary lab file #64.036
        S QFLG=0,ECLRN=1
        F  S ECLRN=$O(^LAR(64.036,ECLRN)) Q:('ECLRN)!(QFLG)!(ECXERR)  D
        .I $D(^LAR(64.036,ECLRN,0))  D
        ..S EC1=^LAR(64.036,ECLRN,0)
        ..Q:$P(EC1,U,2)=""
        ..S ECXDFN=$P(EC1,U,3)
        ..S ECSCDT=$P(EC1,U,9),ECSCTM=$P(EC1,U,10)
        ..;loop on results multiple
        ..S ECRES=0
        ..F  S ECRES=$O(^LAR(64.036,ECLRN,1,ECRES)) Q:('ECRES)!(QFLG)!(ECXERR)  D
        ...I $D(^LAR(64.036,ECLRN,1,ECRES,0)) D  Q:QFLG
        ....S EC2=^LAR(64.036,ECLRN,1,ECRES,0)
        ....S ECN=$P(EC2,U),ECRS=$P(EC2,U,2),ECWC=+$P(EC2,U,4)
        ....S ECWC=$S($D(ECLOC(ECWC)):ECLOC(ECWC),1:"")
        ....; - Free text results translation
        ....S ECTRANS="",ECTRS=ECRS
        ....I +ECTRS S ECTRS=$TR(ECTRS,",","") D
        .....I (ECTRS?.N)!(ECTRS?.N1".".N) S ECRS=ECTRS
        ....F  Q:$E(ECTRS,1)'=" "  S ECTRS=$E(ECTRS,2,$L(ECTRS))
        ....F  Q:$E(ECTRS,$L(ECTRS))'=" "  S ECTRS=$E(ECTRS,1,($L(ECTRS)-1))
        ....I ECTRS]"" I ECTRS'?.N I ECTRS'?.N1".".N D  ;translate
        .....S ECTRS=$TR(ECRS,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        .....I ("<>"[$E(ECTRS))!($E(ECTRS,1,2)="GT")!($E(ECTRS,1,2)="LT") Q
        .....S ECTRIEN="",ECTRIEN=$O(^ECX(727.7,"B",ECTRS,ECTRIEN))
        .....S ECTRANS=$S(ECTRIEN:$P(^ECX(727.7,ECTRIEN,0),U,2),1:"5~")
        ...I ECTRANS="5~" I ECWC]"" D FILE
        K ^LAR(64.036) S ^LAR(64.036,0)="LAB DSS LAR EXTRACT^64.036^"
        Q
        ;
FILE    ; put records in temp file to print later
        S COUNT=COUNT+1
        S ^TMP($J,"ECXALAR2",COUNT)=ECXDFN_U_ECSCDT_U_ECSCTM_U_ECN_U_ECRS
        Q
