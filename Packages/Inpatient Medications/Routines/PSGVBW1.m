PSGVBW1 ;BIR/CML3,MV-NON-VERFIED ORDERS UTILITES ; 5/3/10 3:44pm
        ;;5.0; INPATIENT MEDICATIONS ;**5,111,241**;16 DEC 97;Build 10
        ;
        ;Reference to ^PS(55 is supported by DBIA 2191.
        ;
ENPROF  ;
        I +PSJSYSU=1 S PSGOENOF=0 D NOW^%DTC F Q=%:0 S Q=$O(^PS(55,PSGP,5,"AUS",Q)) Q:'Q  F QQ=0:0 S QQ=$O(^PS(55,PSGP,5,"AUS",Q,QQ)) Q:'QQ  I $D(^PS(55,PSGP,5,QQ,4)),$P(^(4),"^",10) S PSGOENOF=1 Q
        W !!,$S($P(PSGP(0),"^")]"":$P(PSGP(0),"^"),1:PSGP_";DPT(") W:PSJPBID "  (",PSJPBID,")"
        D ENL^PSGOU Q:PSGOL["^"
        K ZTSAVE S PSGTIR="^PSJAC,^PSGO",ZTDESC="PATIENT PROFILE",PSGPR=1 F X="PSGP","PSGP(0)","PSGPR","PSGOL","PSGPTMP","PPAGE" S ZTSAVE(X)=""
        Q:PSGOL="N"
        D ENDEV^PSGTI K PSGPR Q:POP!$D(IO("Q"))
        S PSGVBW=IO'=IO(0)!($E(IOST)'="C") D ^PSGO D ^%ZISC Q:PSGVBW
PEND    K DIR S DIR(0)="E" W ! D ^DIR K DIR Q
        ;
OUTPT   ;Set up Outpatient IV for non/ver pending option.
        K ^TMP("PSGVBW",$J)
        NEW PSJSTAT,PSJTOO1,PSJPAC1
        ;I PSJTOO'=2 S PSJSTAT="N" D PSGP
        ;I PSJTOO'=1 S PSJSTAT="P" D PSGP
        S PSJSTAT="N" D PSGP
        S PSJSTAT="P" D PSGP
        N PSJXR,PSJUDIV S PSJXR(1)=$S(+PSJSYSU=3:"APV",1:"ANV"),PSJXR(2)=$S(+PSJSYSU=3:"APIV",1:"ANIV") ;*PSJ*5*241: added block
        F PSJUDIV=1:1:2 F DFN=0:0 S DFN=$O(^PS(55,PSJXR(PSJUDIV),DFN)) Q:'DFN  D
        . NEW VAIN D INP^VADPT
        . I $G(VAIN(4))&(PSGSS="G"&'$D(^PS(57.5,"AB",+VAIN(4)))) D
        .. S PSGP=DFN D ^PSJAC S WDN="ZZ" D IF^PSGVBW
        D ^PSGVBW0
        S Y=-1
        Q
PSGP    ;
        F PSGP=0:0 S PSGP=$O(^PS(53.1,"AS",PSJSTAT,PSGP)) Q:'PSGP  D
        . NEW VAIN S DFN=PSGP D INP^VADPT
        . I '+(VAIN(4))!(PSGSS="G"&'$D(^PS(57.5,"AB",+VAIN(4)))) D
        .. ;I PSJSTAT="N",'+VAIN(4) Q
        .. D ^PSJAC S WDN="ZZ" D IF^PSGVBW
        Q
