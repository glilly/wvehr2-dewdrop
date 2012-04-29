ECXPIVDN        ;ALB/JAP,BIR/DMA,CML,PTD-Extract from IV EXTRACT DATA File (#728.113) ; 10/31/07 1:38pm
        ;;3.0;DSS EXTRACTS;**10,11,8,13,24,33,39,46,49,71,84,96,92,107,105,112**;Dec 22, 1997;Build 26
BEG     ;entry point from option
        D SETUP I ECFILE="" Q
        D ^ECXTRAC,^ECXKILL
        Q
        ;
START   ; start package specific extract
        N DIC,DA,DR,DIQ,DFN,ECXNPRFI,ECXPHA
        S QFLG=0
        I '$D(ECINST) D
        .S ECINST=+$P(^ECX(728,1,0),U) K ECXDIC S DA=ECINST,DIC="^DIC(4,",DIQ(0)="I",DIQ="ECXDIC",DR=".01;99"
        .D EN^DIQ1 S ECINST=$G(ECXDIC(4,DA,99,"I")) K DIC,DIQ,DA,DR,ECXDIC
        S ECED=ECED+.3
        K ^TMP($J,"A"),^TMP($J,"S")
        S ECD=ECSD1
        F  S ECD=$O(^ECX(728.113,"A",ECD)),DFN=0 Q:'ECD  Q:ECD>ECED  Q:QFLG  F  S DFN=$O(^ECX(728.113,"A",ECD,DFN)),ON=0  Q:'DFN  F  S ON=$O(^ECX(728.113,"A",ECD,DFN,ON)),DA=0 Q:'ON  K ^TMP($J,"A"),^TMP($J,"S") S ECVOL=0 D  Q:QFLG
        .S ECXERR=0 D PAT(DFN,ECD,.ECXERR)
        .Q:ECXERR
        .F  S DA=$O(^ECX(728.113,"A",ECD,DFN,ON,DA)) Q:'DA  Q:QFLG  I $D(^ECX(728.113,DA,0)) S EC=^(0) D  Q:QFLG
        ..S DRG=$P(EC,U,4) I $P(EC,U,8)]"" D
        ...I '$D(^TMP($J,"A",DRG)) S ^(DRG)=$P(EC,U,7,8),^(DRG,1)=0,^(2)=$P(EC,U,12)
        ...S ^(1)=^TMP($J,"A",DRG,1)+$S($P(EC,U,6)=1:1,$P(EC,U,6)=4:0,1:-1)
        ..I $P(EC,U,9) D
        ...I '$D(^TMP($J,"S",DRG)) S ^(DRG)=$P(EC,U,9)_"^ML",^(DRG,1)=0,^(2)=$P(EC,U,12),ECVOL=$P(EC,U,9)+ECVOL
        ...S ^(1)=^TMP($J,"S",DRG,1)+$S($P(EC,U,6)=1:1,$P(EC,U,6)=4:0,1:-1)
        ..S ECTYP=$P(EC,U,11),ECTOTC=0,ECDTTM=$$ECXTIME^ECXUTL($P(EC,U,5))
        .;looped thru all DAs for this order - now put it together
        .;leave the next line in case the decision is made to send volume designations
        .;I ECTYP="H" S ECTYP=ECTYP_$S(ECVOL'>1000:1,ECVOL'>2000:2,1:3)
        .S ECXDSSI=""
        .;loop thru tmp global and call pharmacy drug file (#50) api
        .F SA="S","A" S DRG="" F  S DRG=$O(^TMP($J,SA,DRG)) Q:DRG=""  S ECXPHA="",ECXPHA=$$PHAAPI^ECXUTL5(DRG) I $P(ECXPHA,U)'="" D STUFF Q:QFLG
        K ^TMP($J),CLIN,DA,DFN,DIC,DIK,DRG,ON,SA,X,Y,P1,P3
        Q
STUFF   ;get data
        N ECORDST
        S ECST=^TMP($J,SA,DRG),ECXCNT=^(DRG,1),ECXCOST=^(2),ECXCOST=ECXCOST*ECXCNT,ECVACL=$P(ECXPHA,U,2),ECORDST=""
        ;if outpatient get division from iv rm; get dss identifier for clinic
        I ECXA="O" D
        .;- Only set ward to .5 if outpatient (but NOT observation patient)
        .I $G(ECXW)="" S ECXW=.5
        .I $P(EC,U,15) S ECIVRM=$P(EC,U,15),ECXDIV=$$PSJ59P5^ECXUTL5(ECIVRM)
        .S CLIN=+$P(EC,U,13),(ECXP1,ECXP2)="000",ECXCL=$G(^ECX(728.44,CLIN,0)) Q:ECXCL=""
        .S ECSC=$P(ECXCL,U,4),ECCSC=$P(ECXCL,U,5)
        .I ECSC="" S ECSC=$P(ECXCL,U,2),ECCSC=$P(ECXCL,U,3)
        .I ECSC S ECXP1=$$RJ^XLFSTR(ECSC,3,0),ECXP2=$$RJ^XLFSTR(ECCSC,3,0)
        .I ECSC="" S ECSC=$P($G(^SC(ECXCL,0)),U,7),ECCSC=$P($G(^SC(ECXCL,0)),U,18) I ECSC D
        ..S ECXP1=$P($G(^DIC(40.7,ECSC,0)),U,2) S:ECCSC]"" ECXP2=$P($G(^DIC(40.7,ECCSC,0)),U,2)
        ..S ECXP1=$$RJ^XLFSTR(ECXP1,3,0),ECXP2=$$RJ^XLFSTR(ECXP2,3,0)
        .S ECXDSSI=ECXP1_ECXP2
        .I ECXLOGIC>2003 D
        ..I "^18^23^24^36^41^65^94^"[("^"_ECXTS_"^") S ECXDSSI=$$TSMAP^ECXUTL4(ECXTS)
        S ECINV=$P(ECXPHA,U,4),ECINV=$S(ECINV["I":"I",1:""),ECST=ECXCNT*ECST_" "_$P(ECST,U,2)
        S ECNDC=$P(ECXPHA,U,3),ECNFC=$$RJ^XLFSTR($P(ECNDC,"-"),6,0)_$$RJ^XLFSTR($P(ECNDC,"-",2),4,0)_$$RJ^XLFSTR($P(ECNDC,"-",3),2,0),ECNFC=$TR(ECNFC,"*",0)
        S P1=$P(ECXPHA,U,5),P3=$P(ECXPHA,U,6)
        S X="PSNAPIS" X ^%ZOSF("TEST") I $T S ECNFC=$$DSS^PSNAPIS(P1,P3,ECXYM)_ECNFC
        I $L(ECNFC)=12 S ECNFC=$$RJ^XLFSTR(P1,4,0)_$$RJ^XLFSTR(P3,3,0)_ECNFC
        ;- Ordering provider ("2"_provider)
        S ECXORDPR=$S(+$P(EC,U,10):"2"_$P(EC,U,10),1:"")
        N ECXUSRTN
        S ECXUSRTN=$$NPI^XUSNPI("Individual_ID",$P(EC,U,10),$P(EC,U,16))
        S:+ECXUSRTN'>0 ECXUSRTN="" S ECXOPNPI=$P(ECXUSRTN,U)
        S ECXORDDT=$P(EC,U,16) ;- Ordering date
        ;- Requesting physician (null for FY2002)
        S ECXRPHY=""
        ;- Department and National Prod Division
        S ECXDSSD="" ;dss department use postponed $$IVP^ECXDEPT(ECXDIV)
        N ECXPDIV S ECXPDIV=$$GETDIV^ECXDEPT(ECXDIV)
        ;- Observation patient indicator (yes/no)
        S ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXTS,ECXDSSI)
        ; - Ordering Date, Ordering Stop Code
        S ECXORDST="" I ECXA="O" D
        .S ECXORDST=$$DOIVPO^ECXUTL5(DFN,ON)
        .I ECXOBS="NO" S ECORDST="PHA"
        .I ECXOBS="YES" S ECORDST=$P($G(^ECX(727.831,+ECXTS,0)),U,6)
        ;- If no encounter number don't file record
        S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADM,ECD,ECXTS,ECXOBS,ECHEAD,ECORDST,)
        ;get BCMA data
        S (ECXBCDD,ECXBCDG,ECXBCUA,ECXBCIF)=""
        ;get ordering provider person class
        S ECXOPPC=$$PRVCLASS^ECXUTL($E(ECXORDPR,2,999),ECXORDDT)
        ;set national patient record flag if exist
        S ECXDFN=DFN D NPRF^ECXUTL5 K ECXDFN
        D:ECXENC'="" FILE^ECXPIVD2 K P1,P3
        Q
PAT(ECXDFN,ECXDATE,ECXERR)      ;get patient demographics, primary care, and inpatient data
        N X
        S (ECXCAT,ECXSTAT,ECXPRIOR,ECXSBGRP,ECXOEF,ECXOEFDT)=""
        ;get patient data if saved
        I $D(^TMP($J,"ECXP",ECXDFN)) D
        .S PT=^TMP($J,"ECXP",ECXDFN),ECXPNM=$P(PT,U),ECXSSN=$P(PT,U,2),ECXMPI=$P(PT,U,3)
        .S ECXDOB=$P(PT,U,4),ECXELIG=$P(PT,U,5),ECXSEX=$P(PT,U,6),ECXSTATE=$P(PT,U,7),ECXCNTY=$P(PT,U,8),ECXZIP=$P(PT,U,9)
        .S ECXVET=$P(PT,U,10),ECXPOS=$P(PT,U,11),ECXPST=$P(PT,U,12),ECXPLOC=$P(PT,U,13),ECXRST=$P(PT,U,14),ECXAST=$P(PT,U,15)
        .S ECXAOL=$P(PT,U,16),ECXPHI=$P(PT,U,17),ECXMST=$P(PT,U,18),ECXENRL=$P(PT,U,19),ECXCNHU=$P(PT,U,20),ECXCAT=$P(PT,U,21)
        .S ECXSTAT=$P(PT,U,22),ECXPRIOR=$P(PT,U,23),ECXHNCI=$P(PT,U,24),ECXETH=$P(PT,U,25),ECXRC1=$P(PT,U,26),ECXMTST=$P(PT,U,27)
        .S PT1=$G(^TMP($J,"ECXP",ECXDFN,1)),ECXERI=$P(PT1,U),ECXEST=$P(PT1,U,2),ECXOEF=$P(PT1,U,3),ECXOEFDT=$P(PT1,U,4)
        .I $$ENROLLM^ECXUTL2(ECXDFN)
        ;set patient data
        I '$D(^TMP($J,"ECXP",ECXDFN)) D  Q:'OK
        .K ECXPAT S OK=$$PAT^ECXUTL3(ECXDFN,$P(ECXDATE,"."),"1;2;3;5",.ECXPAT)
        .I 'OK K ECXPAT S ECXERR=1 Q
        .S ECXPNM=ECXPAT("NAME"),ECXSSN=ECXPAT("SSN"),ECXMPI=ECXPAT("MPI"),ECXDOB=ECXPAT("DOB"),ECXELIG=ECXPAT("ELIG"),ECXSEX=ECXPAT("SEX")
        .S ECXSTATE=ECXPAT("STATE"),ECXCNTY=ECXPAT("COUNTY"),ECXZIP=ECXPAT("ZIP"),ECXVET=ECXPAT("VET")
        .S ECXPOS=ECXPAT("POS"),ECXPST=ECXPAT("POW STAT"),ECXPLOC=ECXPAT("POW LOC"),ECXRST=ECXPAT("IR STAT")
        .S ECXAST=ECXPAT("AO STAT"),ECXAOL=ECXPAT("AOL"),ECXPHI=ECXPAT("PHI"),ECXMST=ECXPAT("MST STAT")
        .S ECXENRL=ECXPAT("ENROLL LOC"),ECXMTST=ECXPAT("MEANS"),ECXEST=ECXPAT("EC STAT")
        .S ECXCNHU=$$CNHSTAT^ECXUTL4(ECXDFN) ;get CNHU status
        .;get enrollment data (category, status and priority)
        .I $$ENROLLM^ECXUTL2(ECXDFN)
        .S ECXHNCI=$$HNCI^ECXUTL4(ECXDFN) ;Head and Neck Cancer Indicator
        .; - Race and Ethnicity
        .S ECXETH=ECXPAT("ETHNIC"),ECXRC1=ECXPAT("RACE1")
        .S ECXERI=ECXPAT("ERI") ;emergency response indicator (FEMA)
        .S ECXOEF=ECXPAT("ECXOEF")
        .S ECXOEFDT=ECXPAT("ECXOEFDT")
        .;save for later
        .S ^TMP($J,"ECXP",ECXDFN)=ECXPNM_U_ECXSSN_U_ECXMPI_U_ECXDOB_U_ECXELIG_U_ECXSEX_U_ECXSTATE_U_ECXCNTY_U_ECXZIP_U_ECXVET_U_ECXPOS_U_ECXPST_U_ECXPLOC_U_ECXRST_U_ECXAST
        .S ^TMP($J,"ECXP",ECXDFN)=^TMP($J,"ECXP",ECXDFN)_U_ECXAOL_U_ECXPHI_U_ECXMST_U_ECXENRL_U_ECXCNHU_U_ECXCAT_U_ECXSTAT_U_ECXPRIOR_U_ECXHNCI_U_ECXETH_U_ECXRC1_U_ECXMTST
        .S ^TMP($J,"ECXP",ECXDFN,1)=ECXERI_U_ECXEST_U_ECXOEF_U_ECXOEFDT
        ;get primary care data
        S X=$$PRIMARY^ECXUTL2(ECXDFN,$P(ECXDATE,"."))
        S ECPTTM=$P(X,U,1),ECPTPR=$P(X,U,2),ECCLAS=$P(X,U,3),ECPTNPI=$P(X,U,4),ECASPR=$P(X,U,5),ECCLAS2=$P(X,U,6),ECASNPI=$P(X,U,7)
        ;get inpatient data
        S (ECXA,ECXMN,ECXADM,ECXTS,ECXW,ECXDIV)="",X=$$INP^ECXUTL2(ECXDFN,ECXDATE)
        S ECXA=$P(X,U),ECXMN=$P(X,U,2),ECXTS=$P(X,U,3),ECXADM=$P(X,U,4),W=$P(X,U,9),ECXDOM=$P(X,U,10),ECXW=$P(W,";"),ECXDIV=$P(W,";",2)
        Q
SETUP   ;Set required input for ECXTRAC
        S ECHEAD="IVP"
        D ECXDEF^ECXUTL2(ECHEAD,.ECPACK,.ECGRP,.ECFILE,.ECRTN,.ECPIECE,.ECVER)
        ;variables ecver and ecrtn will be reset in routine ecxtrac if appropriate
        S ECVER=7
        Q
QUE     ; entry point for the background requeuing handled by ECXTAUTO
        D SETUP,QUE^ECXTAUTO,^ECXKILL Q
