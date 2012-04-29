DGMTU22 ;ALB/CAW - COPY PRIOR YEAR INCOME INFORMATION; 6/18/92
        ;;5.3;Registration;**33,45,624,688**;Aug 13, 1993;Build 29
        ;
NOBUCKS(DFN,DGDT)       ; Used by Income Screen Checks if BOTH
        ;  NO meaningful Income Data for Prior Year
        ;  AND there is data for Year before Prior Year
        ;  2=YES (but some edit/entry in 408.22),1=YES & 0=NO
        ;  ** REQUIRES DGINR("V")
        N DGCURR,DGPRIEN,DGPRIOR,DGPY,DGLY,DGIAI,DGIR,DGY,DGINP
        I $G(DGNOCOPY) S DGY=0 G QTNB
        S:'$D(DGDT) DGDT=DT
        S DGLY=$E(DGDT,1,3)_"0000"-10000,DGPY=DGLY-10000
        S (DGPRIOR,DGCURR)=0
        F DGPRIEN=0:0 S DGPRIEN=$O(^DGPR(408.12,"B",DFN,DGPRIEN)) Q:'DGPRIEN  D
        .S:$D(^DGMT(408.21,"AI",+DGPRIEN,-DGPY)) DGPRIOR=DGPRIOR+1
        .S DGIAI=$$IAI^DGMTU3(+DGPRIEN,DGLY)
        .I DGIAI]"" D
        ..S DGCURR=DGCURR+$S($P($G(^DGMT(408.21,DGIAI,0)),U,8,18)'?."^":1,($P($G(^(1)),U,1,3)]""):1,($P($G(^(2)),U,1,5)]""):1,1:0)
        ..;S DGINP=$O(^DGMT(408.22,"AIND",+DGIAI,"")) I $P($G(^DGMT(408.22,+DGINP,"MT")),U) S DGCURR=DGCURR+1
        I 'DGPRIOR!DGCURR S DGY=0 G QTNB
        S DGIR=$G(^DGMT(408.22,+$G(DGINR("V")),0))
        S DGY=$S($P(DGIR,U,5)]"":2,($P(DGIR,U,13)]""):2,1:1)
QTNB    Q DGY
