RMPR145P        ;VM/RB - FIX PROBLEM PCE ENCOUNTERS FROM FILE #660 ITEMS ;03/27/08
        ;;3.0;Prosthetics;**145**;13/27/08;Build 6
        ;;
        Q
FIXPCE  ;1. Post install to correct 'action required' PCE Encounters created
        ;   from Prosthetic items via nightly PCE interface and edit/delete
        ;   issues/orders.
        ;
BUILD   K ^XTMP("RMPR145P") D NOW^%DTC S RMSTART=%
        S ^XTMP("RMPR145P","START COMPILE")=RMSTART
        S ^XTMP("RMPR145P","END COMPILE")="RUNNING"
        S ^XTMP("RMPR145P",0)=$$FMADD^XLFDT(RMSTART,90)_"^"_RMSTART
0       ;FIND 660 RECORDS WITH PCE LINKS
        S IEN=0,U="^",XX=0,TOT=0
1       S IEN=$O(^RMPR(660,IEN)) G EXIT:IEN=""!(IEN]"@")
        S R=$G(^RMPR(660,IEN,0)),DFN=$P(R,U,2),R10=$G(^RMPR(660,IEN,10))
        ;I $E($P(R,U),1,3)<306 G 1
        G:DFN="" 1 S PNAME=$P(^DPT(DFN,0),U,1)
        I R=""!(R10="") G 1
        S VISIEN=$P(R10,U,12) I VISIEN="" G 1
        S RV=$G(^AUPNVSIT(VISIEN,0)) I RV="" G 1
        S RV8=$G(^AUPNVSIT(VISIEN,800))
2       ;check for required contaminants in associated encounter
        S PCEIEN=$O(^SCE("AVSIT",VISIEN,0)) I PCEIEN="" G 1
        S PCE0=$G(^SCE(PCEIEN,0)) I PCE0="" G 1
        I $P(PCE0,U,12)'=14 G 1
EVAL    ;beginning of evaluation criteria for 'action required'
        S SDOE=PCEIEN
        S SDOE0=$$GETOE^SDOE(SDOE),SDIV=$P(SDOE0,U,11)
        D DEM^VADPT M SDDPT=VADM
        K SDX D CLASK^SDCO2(PCEIEN,.SDX)
        I '$D(SDX) G 1
        S SDI=0,ERR=0,SDXX="" F  S SDI=$O(SDX(SDI)) Q:'SDI  I $P(SDX(SDI),U,2)="" S SDX="" D  I SDX'="" S ERR=1,^XTMP("RMPR145P",660,IEN,99,SDI)=SDX(SDI)_U_SDX,SDXX=SDXX_U_SDI
        . I '$D(^SD(409.41,SDI,0)) S SDX="Classification required"  S:'$D(TOT(SDI)) TOT(SDI)=0 S TOT(SDI)=TOT(SDI)+1 Q  ;W !,SDX Q
        . S SDX=$P($G(^SD(409.41,SDI,0)),U,1)_" classification required" S:'$D(TOT(SDI)) TOT(SDI)=0 S TOT(SDI)=TOT(SDI)+1 ;W !,SDX
        I ERR=1 S TOT=TOT+1 D
        . S ^XTMP("RMPR145P",660,IEN,10)=R
        . S ^XTMP("RMPR145P",660,IEN,10)=R10
        . S ^XTMP("RMPR145P",660,IEN,11)=RV
        . S ^XTMP("RMPR145P",660,IEN,12)=RV8
        . S ^XTMP("RMPR145P",660,IEN,13)=PCE0
        . ;W !!,IEN,?15,PNAME,!,R,!,R10,!,VISIEN,!,RV,!,RV8,!,PCEIEN,!,PCE0,!,SDXX
        . F I=1:1:7 I $P(RV8,U,I)="" S XX=80000+I,DA=VISIEN,DR=XX_"////^S X=0",DIE="^AUPNVSIT(" D ^DIE
        . S DA=PCEIEN,DR=".12////^S X=2",DIE="^SCE(" D ^DIE
        G 1
EXIT    ;
        ;S II=0 W !
        ;F  S II=$O(TOT(II)) Q:II=""  D
        ;. S ENM=$P($G(^SD(409.41,II,0)),U)
        ;. W !,ENM," classification required",?50,TOT(II)
        ;W !!,"TOTAL 'ACTION REQUIRED' ENCOUNTERS CORRECTED:  ",TOT
        D NOW^%DTC S RMEND=%
        M ^XTMP("RMPR145P","ERRS")=TOT
        S ^XTMP("RMPR145P","END COMPILE")=RMEND
        K RMEND,RMSTART,IEN,XX,TOT,R,R10,DFN,PCEIEN,VISIEN,PNAME,RV,RV8,PCE0,SDOE,SDOE0,SDIV,VADM,SDDPT,SDX,SDI
        K ERR,SDXX,TOT,I,DA,DR,DIE,II,ENM
        Q
