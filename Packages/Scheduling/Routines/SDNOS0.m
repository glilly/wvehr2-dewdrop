SDNOS0  ;ALB/LDB - NO SHOW REPORT ; 07 May 99 10:21 AM
        ;;5.3;Scheduling;**20,194,410,517,523**;Aug 13, 1993;Build 6
        D END1^SDNOS
        S (SDV1,SDIN,SDNM,SDNM1)=0,SDDIVO=SDDIV
        I $D(^DG(43,1,"GL")),$P(^("GL"),U,2) S SDV1=1
        I SDDIV'="A" S (^UTILITY($J,"SDNO",SDDIV,"***TOT***"),^UTILITY($J,"SDNO",SDDIV,"***N***","***TOT***"),^UTILITY($J,"SDNO",SDDIV,"***NA***","***TOT***"),^UTILITY($J,"SDNO",SDDIV,"***SDNMS***"))=0
        I SDDIV="A" D DIVRPT
        I SDCL(1)="ALL" S SDCL=0 D SDCL
        I SDCL(1)'="ALL" F SDSUB=0:0 S SDSUB=$O(SDCL(SDSUB)) Q:SDSUB=""  S SDCL=SDCL(SDSUB),SDLAB=$S(SDCL?.N1"*".E:"RANGE",1:"SDTST") D @SDLAB
        S (P1,SDTOT,SDTOT1)=0,DGTCH="NO-SHOW REPORT^CLINIC^PAGE#",(SDEND,SDHD)=0
        D ^SDNOS1
        Q
        ;
DIVRPT  F SDDIV=0:0 S SDDIV=$O(^DG(40.8,SDDIV)) Q:'SDDIV  S (^UTILITY($J,"SDNO",SDDIV,"***N***","***TOT***"),^UTILITY($J,"SDNO",SDDIV,"***NA***","***TOT***"),^UTILITY($J,"SDNO",SDDIV,"***TOT***"),^UTILITY($J,"SDNO",SDDIV,"***SDNMS***"))=0
        Q
        ;
SDCL    F SDZ=1:1 S SDCL=$O(^SC(SDCL)) Q:'SDCL  D SDTST
        Q
        ;
SDTST   S SDNM=0,SDCL1=^SC(SDCL,0) I $P(SDCL1,U,3)'="C" Q
        I SDDIVO,SDCL(1),'$D(SDR1) D DATES Q
        I $S((SDDIVO&'SDCL(1)&(SDDIVO=$P(SDCL1,U,15))):1,'SDDIVO:1,$D(SDR1)&SDDIVO&($P(SDCL1,U,15)=SDDIVO):1,'$P(SDCL1,U,15)&(SDDIVO=$P(^DG(43,1,"GL"),U,3)):1,'SDV1:1,1:0) S SDIN=0 D:$D(^SC(SDCL,"I")) INAC^SDNOS1A Q:SDIN  D DATES
        Q
        ;
DATES   S:'SDDIVO SDDIV=$S($P(SDCL1,U,15)&SDV1:$P(SDCL1,U,15),$D(^DG(43,"GL")):$P(^("GL"),U,3),1:$O(^DG(40.8,0)))
        Q:$D(^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***TOT***"))  S ^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***TOT***")=0,^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***SDNMS***")=0
        S (SDEN,SDBEG)=0,SDBEG1=SDBD F SDZ1=1:1 S SDBEG1=$O(^SC(SDCL,"S",SDBEG1)) Q:SDBEG1'>0  D SDED Q:SDBEG!SDEN  D CHK
        S ^UTILITY($J,"SDNO",SDDIV,"***SDNMS***")=SDNM+^UTILITY($J,"SDNO",SDDIV,"***SDNMS***")
        Q
        ;
SDED    S SDBEG=0,SDEN=0 I $D(SDED),(SDBEG1>(SDED+.99999)) S SDEN=1 Q
        I '$D(SDED),(SDBEG1>(SDBD+.99999)) S SDBEG=1 Q
        Q
        ;Added 2nd Quit below SD/517
        ;SD/523 - added Q:SDPAT="" to For loop
CHK     S SDAPP=0 F  S SDAPP=$O(^SC(SDCL,"S",SDBEG1,1,SDAPP)) Q:'SDAPP  Q:'$D(^(SDAPP,0))  I $D(^SC(SDCL,"S",SDBEG1,1,SDAPP))=10,$P(^(SDAPP,0),U,9)'="C" S SDPAT=$P(^SC(SDCL,"S",SDBEG1,1,SDAPP,0),U,1) Q:SDPAT=""  I $D(^DPT(SDPAT,"S",SDBEG1)) D CHK1
        Q
        ;
CHK1    S SD="SD" F SDCHK=1,2,10,12,14 S @(SD_SDCHK)=$P(^DPT(SDPAT,"S",SDBEG1,0),U,SDCHK)
        S:'SDDIVO&$P(SDCL1,U,15) SDDIV=$P(SDCL1,U,15) S:'SDDIVO&'$P(SDCL1,U,15) SDDIV=$O(^DG(40.8,0))
        S:'$D(^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***TOT***")) ^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***TOT***")=0
        I SDFMT=1 D
        .I (SD2="N")!(SD2="NA"),$$NOSHOW(SDPAT,SDBEG1,SDCL,$G(^DPT(SDPAT,"S",SDBEG1,0)),SDAPP) D
        ..D SET,TOTAL Q
        I SDFMT=2 D
        .I (SD2=""&('$D(^SC(SDCL,"S",SDBEG1,1,SDAPP,"C"))))!(SD2="N")!(SD2="NA")!(SD2="NT"),$$NOSHOW(SDPAT,SDBEG1,SDCL,$G(DPT(SDPAT,"S",SDBEG1,0)),SDAPP) D
        ..D SET,TOTAL Q
        I SD2'["C" S SDNM=SDNM+1,^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***SDNMS***")=SDNM
        Q
        ;
SET     S:$P(SDCL1,U,15)&SDDIVO&SDV1 SDDIV=$P(SDCL1,U,15) S ^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),SDBEG1,$P(^DPT(SDPAT,0),U),+$P(^(0),U,9))=SD2_U_SD10_U_SD12
        Q
        ;
TOTAL   S ^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***"_SD2_"***","***TOT***")=$S($D(^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***"_SD2_"***","***TOT***")):^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***"_SD2_"***","***TOT***")+1,1:1)
        S ^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),$P(SDBEG1,"."),"***"_SD2_"***","***TOT***")=$S($D(^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),$P(SDBEG1,"."),"***"_SD2_"***","***TOT***")):^("***TOT***")+1,1:1)
        S ^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***TOT***")=$S($D(^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***TOT***")):^UTILITY($J,"SDNO",SDDIV,$P(SDCL1,U),"***TOT***")+1,1:1)
        S ^("***TOT***")=^UTILITY($J,"SDNO",SDDIV,"***TOT***")+1,^("***TOT***")=$S($D(^UTILITY($J,"SDNO",SDDIV,"***"_SD2_"***","***TOT***")):^UTILITY($J,"SDNO",SDDIV,"***"_SD2_"***","***TOT***")+1,1:1)
        Q
        ;
RANGE   S SDREST=$E(SDCL,$F(SDCL,"*"),$L(SDCL)),SDCL=$E(SDCL,1,($F(SDCL,"*")-2)),SDCL1=^SC(SDCL,0)
        S:'SDDIVO SDDIV=$S($P(SDCL1,U,15):$P(SDCL1,U,15),'$P(SDCL1,U,15)&$D(^DG(43,"GL")):$P(^DG(43,"GL"),U,3),1:$O(^DG(40.8,0)))
        S SDR1=1,SDR=$P(SDCL1,U) D SDTST K SDR1
        S SDREST="1"_""""_SDREST_""""_".E" F SDCXX=1:1 S SDR=$O(^SC("B",SDR)) Q:'(SDR?@SDREST)!(SDR="")  S SDCL=$O(^SC("B",SDR,-1)) S SDR1=1 D RANGE1 K SDR1
        Q
        ;
RANGE1  S:'SDDIVO SDDIV=$S($P(SDCL1,U,15):$P(SDCL1,U,15),'$P(SDCL1,U,15)&$D(^DG(43,"GL")):$P(^DG(43,"GL"),U,3),1:$O(^DG(40.8,0))) D SDTST
        Q
        ;
NOSHOW(DFN,SDT,CIFN,PAT,DA)     ;Input:  DFN=Patient IFN, SDT=Appointment D/T
        ;  CIFN=Clinic IFN, PAT=Zero node of pat. appt., DA=Clinic appt. IFN
        ;                        Output:  1 or 0 for noshow yes/no
        N NSQUERY,NS S NS=1,NSQUERY=$$STATUS^SDAM1(DFN,SDT,CIFN,PAT,DA)
        I $P(NSQUERY,";",3)["ACTION REQ" S NS=0
NOSHOWQ Q NS
