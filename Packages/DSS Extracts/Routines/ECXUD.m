ECXUD   ;ALB/JAP,BIR/DMA,PTD-Extract from UNIT DOSE EXTRACT DATA File (#728.904) ; 10/31/07 1:58pm
        ;;3.0;DSS EXTRACTS;**10,8,24,33,39,46,49,71,84,92,107,105**;Dec 22, 1997;Build 70
BEG     ;entry point from option
        I '$O(^ECX(728.904,"A",0)) W !,"There are no unit dose orders to extract",!! R X:5 K X Q
        D SETUP I ECFILE="" Q
        D ^ECXTRAC,^ECXKILL
        Q
        ;
START   ;start package specific extract
        S QFLG=0
        S ECED=ECED+.3
        F ECD=ECSD1:0 S ECD=$O(^ECX(728.904,"A",ECD)) Q:'ECD  Q:ECD>ECED  Q:QFLG  D
        .S ECXJ=0 F  S ECXJ=$O(^ECX(728.904,"A",ECD,ECXJ)) Q:'ECXJ  Q:QFLG  I $D(^ECX(728.904,ECXJ,0)) D
        ..S DATA=^ECX(728.904,ECXJ,0),^(1)=$P(EC23,U,2),^ECX(728.904,"AC",$P(EC23,U,2),ECXJ)="" D STUFF
        K ^TMP($J,"ECXP")
        Q
        ;
STUFF   ;get data
        N X,W,OK,P1,P3,PSTAT,PT,ECXPHA,ON,ECDRG
        S ECXDFN=$P(DATA,U,2),ECDRG=$P(DATA,U,4)
        ;
        ;get patient specific data
        S ECXERR="" D PAT(ECXDFN,ECD,.ECXERR)
        Q:ECXERR
        ;
        S ECXPRO=$P(DATA,U,7),ECPROIEN=+ECXPRO,ECXPRO=$E($P(ECXPRO,";",2))_$P(ECXPRO,";")
        S ECXPRNPI=$$NPI^XUSNPI("Individual_ID",ECPROIEN,ECD)
        S:+ECXPRNPI'>0 ECXPRNPI="" S ECXPRNPI=$P(ECXPRNPI,U)
        S W=$P(DATA,U,6)
        S ECXDIV=$P($G(^DIC(42,+W,0)),U,11),ECXW=$P($G(^DIC(42,+W,44)),U)
        S ECXUDDT=$$ECXDATE^ECXUTL($P(DATA,U,3),ECXYM)
        S ECXUDTM=$E($P($P(DATA,U,3),".",2)_"000000",1,6)
        S ECXQTY=$P(DATA,U,5),ECXCOST=$P(DATA,U,8),ON=$P(DATA,U,10)
        ;call pharmacy drug file (#50) api via ecxutl5
        S ECXPHA=$$PHAAPI^ECXUTL5(ECDRG)
        S ECCAT=$P(ECXPHA,U,2),ECINV=$P(ECXPHA,U,4)
        S ECINV=$S(ECINV["I":"I",1:"")
        S ECNDC=$P(ECXPHA,U,3)
        S ECNFC=$$RJ^XLFSTR($P(ECNDC,"-"),6,0)_$$RJ^XLFSTR($P(ECNDC,"-",2),4,0)_$$RJ^XLFSTR($P(ECNDC,"-",3),2,0),ECNFC=$TR(ECNFC,"*",0)
        S P1=$P(ECXPHA,U,5),P3=$P(ECXPHA,U,6),X="PSNAPIS"
        X ^%ZOSF("TEST") I $T S ECNFC=$$DSS^PSNAPIS(P1,P3,ECXYM)_ECNFC
        I $L(ECNFC)=12 S ECNFC=$$RJ^XLFSTR(P1,4,0)_$$RJ^XLFSTR(P3,3,0)_ECNFC
        ; - Department and National Production Division
        ;- Use of DSS Department postponed [S ECXDSSD=$$UDP^ECXDEPT(ECXDIV)]
        S ECXDSSD=""
        S ECXPDIV=$$GETDIV^ECXDEPT(ECXDIV)
        ;- Observation patient indicator (YES/NO)
        S ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXTS)
        ;- Ordering Date, Ordering Stop Code
        S ECXORDDT=$TR($$FMTE^XLFDT($P(DATA,U,9),"7DF")," /","0")
        S ECXORDST="" I ECXA="O" D
        .;Get ordering stop code based on FY 2006 logic for outpatient
        .S ECXORDST=$$DOUDO^ECXUTL5(ECXDFN,ON)
        ;Ordering Provider Person Class
        S ECXOPPC=$$PRVCLASS^ECXUTL($E(ECXPRO,2,999),$P(DATA,U,9))
        ;BCMA data (place holder)
        S (ECXBCDD,ECXBCDG,ECXBCUA,ECXBCIF)=""
        ;- Set national patient record flag if exist
        D NPRF^ECXUTL5
        ;- If no encounter number don't file record
        S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADM,$P(DATA,U,3),ECXTS,ECXOBS,ECHEAD,,)
        D:ECXENC'="" FILE
        Q
        ;
PAT(ECXDFN,ECXDATE,ECXERR)      ;get demographics from patient file
        ;init variables
        S (ECXCAT,ECXSTAT,ECXPRIOR,ECXSBGRP,ECXOEF,ECXOEFDT)=""
        ;get patient data if saved
        I $D(^TMP($J,"ECXP",ECXDFN)) D
        .S PT=^TMP($J,"ECXP",ECXDFN),ECXPNM=$P(PT,U),ECXSSN=$P(PT,U,2)
        .S ECXMPI=$P(PT,U,3),ECXDOB=$P(PT,U,4)
        .S ECXELIG=$P(PT,U,5),ECXSEX=$P(PT,U,6)
        .S ECXSTATE=$P(PT,U,7),ECXCNTY=$P(PT,U,8),ECXZIP=$P(PT,U,9)
        .S ECXVET=$P(PT,U,10),ECXPOS=$P(PT,U,11),ECXPST=$P(PT,U,12)
        .S ECXPLOC=$P(PT,U,13),ECXRST=$P(PT,U,14),ECXAST=$P(PT,U,15)
        .S ECXAOL=$P(PT,U,16),ECXPHI=$P(PT,U,17),ECXMST=$P(PT,U,18)
        .S ECXENRL=$P(PT,U,19),ECXCNHU=$P(PT,U,20),ECXCAT=$P(PT,U,21)
        .S ECXSTAT=$P(PT,U,22),ECXPRIOR=$P(PT,U,23),ECXHNCI=$P(PT,U,24)
        .S ECXETH=$P(PT,U,25),ECXRC1=$P(PT,U,26),ECXMTST=$P(PT,U,27)
        .S PT1=$G(^TMP($J,"ECXP",ECXDFN,1)),ECXERI=$P(PT1,U),ECXEST=$P(PT1,U,2),ECXOEF=$P(PT1,U,3),ECXOEFDT=$P(PT1,U,4)
        .I $$ENROLLM^ECXUTL2(ECXDFN)
        ;set patient data
        I '$D(^TMP($J,"ECXP",ECXDFN)) D  Q:'OK
        .K ECXPAT S OK=$$PAT^ECXUTL3(ECXDFN,$P(ECXDATE,"."),"1;2;3;5",.ECXPAT)
        .I 'OK K ECXPAT S ECXERR=1 Q
        .S ECXPNM=ECXPAT("NAME"),ECXSSN=ECXPAT("SSN"),ECXMPI=ECXPAT("MPI")
        .S ECXDOB=ECXPAT("DOB"),ECXELIG=ECXPAT("ELIG"),ECXSEX=ECXPAT("SEX")
        .S ECXSTATE=ECXPAT("STATE"),ECXCNTY=ECXPAT("COUNTY")
        .S ECXZIP=ECXPAT("ZIP"),ECXVET=ECXPAT("VET")
        .S ECXPOS=ECXPAT("POS"),ECXPST=ECXPAT("POW STAT")
        .S ECXPLOC=ECXPAT("POW LOC"),ECXRST=ECXPAT("IR STAT")
        .S ECXAST=ECXPAT("AO STAT"),ECXAOL=ECXPAT("AOL")
        .S ECXPHI=ECXPAT("PHI"),ECXMST=ECXPAT("MST STAT")
        .S ECXENRL=ECXPAT("ENROLL LOC"),ECXMTST=ECXPAT("MEANS")
        .;OEF/OIF data
        .S ECXOEF=ECXPAT("ECXOEF")
        .S ECXOEFDT=ECXPAT("ECXOEFDT")
        .;get CNHU status
        .S ECXCNHU=$$CNHSTAT^ECXUTL4(ECXDFN)
        .;get enrollment data (category, status and priority)
        .I $$ENROLLM^ECXUTL2(ECXDFN)
        .; - Head and Neck Cancer Indicator
        .S ECXHNCI=$$HNCI^ECXUTL4(ECXDFN)
        .; - Race and Ethnicity
        .S ECXETH=ECXPAT("ETHNIC")
        .S ECXRC1=ECXPAT("RACE1")
        .;get emergency response indicator (FEMA)
        .S ECXERI=ECXPAT("ERI")
        .S ECXEST=ECXPAT("EC STAT")
        .;save for later
        .S ^TMP($J,"ECXP",ECXDFN)=ECXPNM_U_ECXSSN_U_ECXMPI_U_ECXDOB_U_ECXELIG_U_ECXSEX_U_ECXSTATE_U_ECXCNTY_U_ECXZIP_U_ECXVET_U_ECXPOS_U_ECXPST_U_ECXPLOC_U_ECXRST_U_ECXAST
        .S ^TMP($J,"ECXP",ECXDFN)=^TMP($J,"ECXP",ECXDFN)_U_ECXAOL_U_ECXPHI_U_ECXMST_U_ECXENRL_U_ECXCNHU_U_ECXCAT_U_ECXSTAT_U_ECXPRIOR_U_ECXHNCI_U_ECXETH_U_ECXRC1_U_ECXMTST
        .S ^TMP($J,"ECXP",ECXDFN,1)=ECXERI_U_ECXEST_U_ECXOEF_U_ECXOEFDT
        ;
        ;get inpatient data
        S X=$$INP^ECXUTL2(ECXDFN,ECXDATE),ECXA=$P(X,U),ECXMN=$P(X,U,2)
        S ECXTS=$P(X,U,3),ECXADM=$P(X,U,4),ECXDOM=$P(X,U,10)
        ;
        ;get primary care data
        S X=$$PRIMARY^ECXUTL2(ECXDFN,$P(ECXDATE,"."))
        S ECPTTM=$P(X,U),ECPTPR=$P(X,U,2),ECCLAS=$P(X,U,3),ECPTNPI=$P(X,U,4)
        S ECASPR=$P(X,U,5),ECCLAS2=$P(X,U,6),ECASNPI=$P(X,U,7)
        Q
        ;
FILE    ;file record
        ;node0
        ;facility^dfn^ssn^name^in/out^day^drug category^quantity^ward^
        ;provider^cost^mov #^treat spec^ndc^new feeder key^investigational^
        ;udp time^adm date^adm time
        ;node1
        ;mpi^dss dept^provider npi^dom^observ pat ind^encounter num^
        ;prod div code^means tst^elig^dob^sex^state^county^zip+4^vet^
        ;period of svc^pow stat^pow loc^ir status^ao status^ao loc^
        ;purple heart ind.^mst status^cnh/sh status^enrollment loc^
        ;enrollment cat^enrollment status^enrollment priority^pc team^
        ;pc provider^pc provider npi^pc provider p.class^assoc. pc provider^
        ;assoc. pc provider npi^assoc. pc provider p.class
        ;node2
        ;ordering date^ordering stop code^head & neck cancer ind.^ethnicity^
        ;race1^bcma drug dispensed^bcma dose given^bcma unit of
        ;administration^bcma icu flag^ordering provider person class^
        ;^enrollment priority ECXPRIOR_enrollment subgroup
        ;ECXSBGRP^user enrollee ECXUESTA^patient type ECXPTYPE^combat vet
        ;elig ECXCVE^combat vet elig end date ECXCVEDT^enc cv eligible
        ;ECXCVENC^national patient record flag ECXNPRFI^emerg resp indic(FEMA) 
        ;ECXERI^environ contamin ECXEST^OEF/OIF ECXOEF^OEF/OIF return date ECXOEFDT^associate pc provider npi ECASNPI^primary care provider npi ECPTNPI^provider npi ECXPRNPI
        N DA,DIK
        S EC7=$O(^ECX(ECFILE,999999999),-1),EC7=EC7+1
        S ECODE=EC7_U_EC23_U_ECXDIV_U_ECXDFN_U_ECXSSN_U_ECXPNM_U_ECXA_U
        S ECODE=ECODE_ECXUDDT_U_ECCAT_U_ECXQTY_U_ECXW_U_ECXPRO_U_ECXCOST_U
        S ECODE=ECODE_ECXMN_U_ECXTS_U_ECNDC_U_ECNFC_U_ECINV_U_ECXUDTM_U
        ;convert specialty to PTF Code for transmission
        N ECXDATA
        S ECXDATA=$$TSDATA^DGACT(42.4,+ECXTS,.ECXDATA)
        S ECXTS=$G(ECXDATA(7))
        ;done
        S ECODE=ECODE_$$ECXDATE^ECXUTL(ECXADM,ECXYM)_U
        S ECODE=ECODE_$$ECXTIME^ECXUTL(ECXADM)_U
        S ECODE1=ECXMPI_U_ECXDSSD_U_U_ECXDOM_U_ECXOBS_U_ECXENC_U
        S ECODE1=ECODE1_ECXPDIV_U_ECXMTST_U_ECXELIG_U_ECXDOB_U_ECXSEX_U
        S ECODE1=ECODE1_ECXSTATE_U_ECXCNTY_U_ECXZIP_U_ECXVET_U_ECXPOS_U
        S ECODE1=ECODE1_ECXPST_U_ECXPLOC_U_ECXRST_U_ECXAST_U
        S ECODE1=ECODE1_ECXAOL_U_ECXPHI_U_ECXMST_U_ECXCNHU_U_ECXENRL_U
        S ECODE1=ECODE1_ECXCAT_U_ECXSTAT_U_$S(ECXLOGIC<2005:ECXPRIOR,1:"")_U_ECPTTM_U_ECPTPR_U
        S ECODE1=ECODE1_U_ECCLAS_U_ECASPR_U_U_ECCLAS2_U
        S ECODE2=ECXORDDT_U_ECXORDST_U_ECXHNCI_U_ECXETH_U_ECXRC1
        I ECXLOGIC>2003 S ECODE2=ECODE2_U_ECXBCDD_U_ECXBCDG_U_ECXBCUA_U_ECXBCIF_U_ECXOPPC
        I ECXLOGIC>2004 S ECODE2=ECODE2_U_U_ECXPRIOR_ECXSBGRP_U_ECXUESTA_U_ECXPTYPE_U_ECXCVE_U_ECXCVEDT_U_ECXCVENC_U_ECXNPRFI
        I ECXLOGIC>2006 S ECODE2=ECODE2_U_ECXERI_U_ECXEST
        I ECXLOGIC>2007 S ECODE2=ECODE2_U_ECXOEF_U_ECXOEFDT_U_ECASNPI_U_ECPTNPI_U_ECXPRNPI
        S ^ECX(ECFILE,EC7,0)=ECODE,^ECX(ECFILE,EC7,1)=ECODE1
        S ^ECX(ECFILE,EC7,2)=ECODE2,ECRN=ECRN+1
        S DA=EC7,DIK="^ECX("_ECFILE_"," D IX1^DIK K DIK,DA
        I $D(ZTQUEUED),$$S^%ZTLOAD S QFLG=1
        Q
        ;
SETUP   ;Set required input for ECXTRAC
        S ECHEAD="UDP"
        D ECXDEF^ECXUTL2(ECHEAD,.ECPACK,.ECGRP,.ECFILE,.ECRTN,.ECPIECE,.ECVER)
        Q
        ;
QUE     ; entry point for the background requeuing handled by ECXTAUTO
        D SETUP,QUE^ECXTAUTO,^ECXKILL
        Q
