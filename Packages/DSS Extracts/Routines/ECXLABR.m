ECXLABR ;ALB/JAP,BIR/CML-LAR Extract for DSS (New Format - With LMIP Codes) ;10/14/10  14:46
        ;;3.0;DSS EXTRACTS;**8,24,33,37,39,46,71,80,107,105,112,127**;Dec 22, 1997;Build 36
BEG     ;entry point from option
        D SETUP I ECFILE="" Q
        D ^ECXTRAC,^ECXKILL
        Q
        ;
START   ; entry when queued
        N X,OK,ECTRS,ECTRANS,ECTRIEN,ECDOC,ECDOCPC
        K ^LAR(64.036) S LRSDT=ECSD,LREDT=ECED
        D ^LRCAPDAR
        ;quit if no completion date for API compile
        I '$P($G(^LAR(64.036,1,2,1,0)),U,4) Q
        ;process temporary lab file #64.036
        S QFLG=0,ECLRN=1
        F  S ECLRN=$O(^LAR(64.036,ECLRN)) Q:('ECLRN)!(QFLG)  D
        .I $D(^LAR(64.036,ECLRN,0))  D
        ..S EC1=^LAR(64.036,ECLRN,0),ECF=$P(EC1,U,2)
        ..Q:ECF=""
        ..S ECXDFN=$P(EC1,U,3),ECPTPR=$P($G(EC1),U,11),ECCLASS=""
        ..S ECXTIME=$S($P(EC1,U,10)="":"000300",1:$P(EC1,U,10))
        ..S ECXDATE=$P(EC1,U,9)_"."_$P(EC1,U,10)
        ..I ECPTPR S ECCLASS=$$PRVCLASS^ECXUTL(ECPTPR,ECXDATE)
        ..I ECPTPR S ECPTNPI=$$NPI^XUSNPI("Individual_ID",ECPTPR,+ECXDATE) D
        ...S:+ECPTNPI'>0 ECPTNPI="" S ECPTNPI=$P(ECPTNPI,U)
        ..S ECORDT=$$ECXDATE^ECXUTL($P(EC1,U,4),ECXYM)
        ..S ECORTM=$$ECXTIME^ECXUTL($P(EC1,U,4)_"."_$P(EC1,U,5))
        ..S ECREDT=$$ECXDATE^ECXUTL($P(EC1,U,6),ECXYM)
        ..S ECRETM=$$ECXTIME^ECXUTL($P(EC1,U,6)_"."_$P(EC1,U,7))
        ..S ECSCDT=$$ECXDATE^ECXUTL($P(EC1,U,9),ECXYM)
        ..S ECSCTM=$$ECXTIME^ECXUTL($P(EC1,U,9)_"."_$P(EC1,U,10))
        ..S (ECXADMDT,ECXDOM,ECXDSSD,ECXPNM,ECXSSN,ECXA,ECXMN,ECXTS)=""
        ..I ECF=2 D  Q:'OK
        ...K ECXPAT S OK=$$PAT^ECXUTL3(ECXDFN,ECXDATE,"1;",.ECXPAT)
        ...Q:'OK
        ...S ECXPNM=ECXPAT("NAME"),ECXSSN=ECXPAT("SSN"),ECXMPI=ECXPAT("MPI")
        ...S X=$$INP^ECXUTL2(ECXDFN,ECXDATE),ECXA=$P(X,U),ECXADMDT=$P(X,U,4)
        ...S ECXMN=$P(X,U,2),ECXTS=$P(X,U,3),ECXDOM=$P(X,U,10)
        ..;allow for referral patients in future??
        ..;I ECF=67 S ECSN="000123456",ECNA="RFRL"
        ..;loop on results multiple
        ..;
        ..;Get production division ECXDIEN added p-80
        ..N ECXPDIV,ECXDIEN S ECXDIEN=$O(^DIC(4,"D",ECINST,"")),ECXPDIV=$$RADDIV^ECXDEPT(ECXDIEN) ;p-46
        ..K ECXDIEN
        ..;- Observation patient indicator (y/n)
        ..S ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXTS)
        ..;
        ..;- If no encounter number don't file record
        ..S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADMDT,$P(EC1,U,9),ECXTS,ECXOBS,ECHEAD,,) Q:ECXENC=""
        ..S ECRES=0
        ..F  S ECRES=$O(^LAR(64.036,ECLRN,1,ECRES)) Q:('ECRES)!(QFLG)  D
        ...I $D(^LAR(64.036,ECLRN,1,ECRES,0)) D  Q:QFLG
        ....S EC2=^LAR(64.036,ECLRN,1,ECRES,0),ECN=$P(EC2,U),ECRS=$P(EC2,U,2)
        ....S ECHL=$E($P(EC2,U,3)),ECWC=+$P(EC2,U,4)
        ....I ECWC S ECWC=$P(^LAM(ECWC,0),U,2)
        ....S ECLNC=$P(EC2,U,5)
        .... ; ******* - PATCH 127, ADD PATCAT CODE
        ....S ECXPATCAT=$$PATCAT^ECXUTL(ECXDFN)
        ....;
        ....; - Free text results translation
        ....S ECTRANS="",ECTRS=ECRS
        ....I +ECTRS S ECTRS=$TR(ECTRS,",","") D
        .....I (ECTRS?.N)!(ECTRS?.N1".".N) S ECRS=ECTRS
        ....F  Q:$E(ECTRS,1)'=" "  S ECTRS=$E(ECTRS,2,$L(ECTRS))
        ....F  Q:$E(ECTRS,$L(ECTRS))'=" "  S ECTRS=$E(ECTRS,1,($L(ECTRS)-1))
        ....I ECTRS]"" I ECTRS'?.N I ECTRS'?.N1".".N D  ;translate
        .....S ECTRS=$TR(ECRS,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        .....S ECTRIEN="",ECTRIEN=$O(^ECX(727.7,"B",ECTRS,ECTRIEN))
        .....S ECTRANS=$S(ECTRIEN:$P(^ECX(727.7,ECTRIEN,0),U,2),1:5)
        ....;
        ....I ECWC]"" D FILE
        K ^LAR(64.036) S ^LAR(64.036,0)="LAB DSS LAR EXTRACT^64.036^"
        Q
        ;
FILE    ;file record
        ;node0
        ;facility (ECINST)^dfn (ECXDFN)^ssn (ECXSSN)^name(ECXPNM)^in/out (ECXA)^
        ;day(ECSCDT)^
        ;lab test code (ECN)^results (ECRS)^hi/lo indicator (ECHL)^
        ;date ordered (ECORDT)^time ordered (ECORTM)^date ready (ECREDT)^
        ;time ready (ECRETM)^
        ;movement file # (ECXMN)^treating specialty (ECXTS)^
        ;workload code(ECWC)^
        ;node1
        ;mpi (ECXMPI)^dss dept (ECXDSSD)^dom (ECXDOM)^time (ECSCTM)^
        ;observ pat ind (ECXOBS)^encounter num (ECXENC)^prod div ECXPDIV^
        ;lab results translation ECXTRANS^ordering provider (ECPTPR)^
        ;ordering provider person class (ECCLASS)^ordering provider npi ECPTNPI^LOINC code ECLNC
        ;Patient Category PATCAT
        N DA,DIK
        S EC7=$O(^ECX(ECFILE,999999999),-1),EC7=EC7+1
        S ECODE=EC7_U_EC23_U_ECINST_U_ECXDFN_U_ECXSSN_U_ECXPNM_U_ECXA_U
        S ECODE=ECODE_ECSCDT_U_$$RJ^XLFSTR(ECN,4,0)_U_ECRS_U_ECHL_U_ECORDT_U
        S ECODE=ECODE_$$LJ^XLFSTR(ECORTM,6,0)_U
        ;convert specialty to PTF Code for transmission
        N ECXDATA,ECXTSC
        S ECXDATA=$$TSDATA^DGACT(42.4,+ECXTS,.ECXDATA)
        S ECXTSC=$G(ECXDATA(7))
        ;done
        S ECODE=ECODE_ECREDT_U_$$LJ^XLFSTR(ECRETM,6,0)_U_ECXMN_U_ECXTSC_U_ECWC_U
        S ECODE1=ECXMPI_U_ECXDSSD_U_ECXDOM_U_ECSCTM_U_ECXOBS_U_ECXENC_U_ECXPDIV_U_ECTRANS
        I ECXLOGIC>2004 S ECODE1=ECODE1_U_2_ECPTPR_U_ECCLASS
        I ECXLOGIC>2007 S ECODE1=ECODE1_U_ECPTNPI
        I ECXLOGIC>2008 S ECODE1=ECODE1_U_ECLNC
        I ECXLOGIC>2010 S ECODE1=ECODE1_U_ECXPATCAT
        S ^ECX(ECFILE,EC7,0)=ECODE,^ECX(ECFILE,EC7,1)=ECODE1,ECRN=ECRN+1
        S DA=EC7,DIK="^ECX("_ECFILE_"," D IX1^DIK K DIK,DA
        I $D(ZTQUEUED),$$S^%ZTLOAD S QFLG=1
        Q
        ;
SETUP   ;Set required input for ECXTRAC
        S ECHEAD="LAR"
        D ECXDEF^ECXUTL2(ECHEAD,.ECPACK,.ECGRP,.ECFILE,.ECRTN,.ECPIECE,.ECVER)
        Q
        ;
QUE     ; entry point for the background requeuing handled by ECXTAUTO
        D SETUP,QUE^ECXTAUTO,^ECXKILL Q
