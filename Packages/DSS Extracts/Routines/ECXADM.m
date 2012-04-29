ECXADM  ;ALB/JAP,BIR/DMA,CML,PTD-Admissions Extract ; 10/15/07 12:14pm
        ;;3.0;DSS EXTRACTS;**1,4,11,8,13,24,33,39,46,71,84,92,107,105**;Dec 22, 1997;Build 70
BEG     ;entry point from option
        D SETUP I ECFILE="" Q
        D ^ECXTRAC,^ECXKILL
        Q
        ;
START   ; start package specific extract
        S QFLG=0
        S ECED=ECED+.3,ECD=ECSD1
        F  S ECD=$O(^DGPM("ATT1",ECD)),ECDA=0 Q:('ECD)!(ECD>ECED)  D
        .F  S ECDA=$O(^DGPM("ATT1",ECD,ECDA)) Q:ECDA=""  D
        ..I $D(^DGPM(ECDA,0)) D
        ...S EC=^DGPM(ECDA,0),ECXDFN=$P(EC,U,3) D GET
        Q
        ;
GET     ;gather extract data
        N ADM,W,X,ECXNPRFI,ECXATTPC,ECXPRVPC,ECXEST
        ;patient demographics
        S ECXERR=0 D PAT(ECXDFN,ECD,.ECXERR)
        Q:ECXERR
        I $$ENROLLM^ECXUTL2(ECXDFN)
        S ECXFAC=$P($G(^DIC(42,+$P(EC,U,6),0)),U,11)
        S ECXPDIV=$$GETDIV^ECXDEPT(ECXFAC)  ;Get production division
        ;admission data
        S ELGA=$P($G(^DIC(8,+$P(EC,U,20),0)),U,9)
        I ELGA S ELGA=$$ELIG^ECXUTL3(ELGA,ECXSVC)
        S (ECDRG,ECDIA,ECXSADM)="",ECPTF=+$P(EC,U,16) I ECPTF,$D(^DGPT(ECPTF,"M")) D PTF
        ;get encounter classification
        S (ECXAO,ECXECE,ECXIR,ECXMIL,ECXHNC)="",ECXVISIT=$P(EC,U,27)
        I ECXVISIT'="" D
        .D VISIT^ECXSCX1(ECXDFN,ECXVISIT,.ECXVIST,.ECXERR) I ECXERR K ECXERR Q
        .S ECXAO=$G(ECXVIST("AO")),ECXIR=$G(ECXVIST("IR"))
        .S ECXMIL=$G(ECXVIST("MST")),ECXHNC=$G(ECXVIST("HNC"))
        .S ECXECE=$G(ECXVIST("PGE"))
        ;use movement record date & time
        S ADM=$$INP^ECXUTL2(ECXDFN,ECD)
        S ECXA=$P(ADM,U),ECXMN=$P(ADM,U,2),ECXSPC=$P(ADM,U,3)
        S (ECXADMDT,ECXDATE)=$P(ADM,U,4)
        ;if movement# doesn't match cross-ref ien, then quit
        Q:ECXMN'=ECDA
        S ECTM=$$ECXTIME^ECXUTL(ECXDATE)
        S ECXDATE=$$ECXDATE^ECXUTL(ECXDATE,ECXYM)
        S W=$P(ADM,U,9)
        S ECXWRD=$P(W,";",1),ECXFAC=$P(W,";",2),ECXDSSD=$P(W,";",3)
        S ECXPRV=$P(ADM,U,7),ECXPRNPI="",ECXATT=$P(ADM,U,8),ECXATNPI=""
        S ECXDOM=$P(ADM,U,10),ECXATTPC=$P(ADM,U,12),ECXPRVPC=$P(ADM,U,11)
        N ECXUSRTN
        S ECXUSRTN=$$NPI^XUSNPI("Individual_ID",$E(ECXATT,2,$L(ECXATT)),ECD)
        S:+ECXUSRTN'>0 ECXUSRTN=""
        S ECATTNPI=$P(ECXUSRTN,U)
        S ECXUSRTN=$$NPI^XUSNPI("Individual_ID",$E(ECXPRV,2,$L(ECXPRV)),ECD)
        S:+ECXUSRTN'>0 ECXUSRTN=""
        S ECPWNPI=$P(ECXUSRTN,U)
        ;
        ;- Observation patient indicator (YES/NO)
        S ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXSPC)
        ;
        ;- Patient Type
        S ECXPTYPE=$$TYPE^ECXUTL5(ECXDFN)
        ;
        ;- If null encounter number, don't file record
        S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADMDT,,ECXSPC,ECXOBS,ECHEAD,,)
        D:ECXENC'="" FILE
        Q
        ;
PAT(ECXDFN,ECXDATE,ECXERR)      ;get patient demographic data
        N OK,X
        K ECXPAT
        S ECXDATE=$P(ECXDATE,".")
        S OK=$$PAT^ECXUTL3(ECXDFN,ECXDATE,"1;2;3;4;5",.ECXPAT)
        I 'OK S ECXERR=1 K ECXPAT Q
        S ECXSSN=ECXPAT("SSN")
        S ECXPNM=ECXPAT("NAME")
        S ECXMPI=ECXPAT("MPI")
        S ECXSEX=ECXPAT("SEX")
        S ECXDOB=ECXPAT("DOB")
        S ECXELIG=ECXPAT("ELIG")
        S ECXVET=ECXPAT("VET")
        S ECXVNS=ECXPAT("VIETNAM")
        S ECXPOS=ECXPAT("POS")
        S ECXMNS=ECXPAT("MEANS")
        S ECXRACE=ECXPAT("RACE")
        S ECXRELG=ECXPAT("RELIGION")
        S ECXEMP=ECXPAT("EMPLOY")
        S ECXMAR=ECXPAT("MARITAL")
        S ECXPST=ECXPAT("POW STAT")
        S ECXPLOC=ECXPAT("POW LOC")
        S ECXRST=ECXPAT("IR STAT")
        S ECXAST=ECXPAT("AO STAT")
        S ECXMST=ECXPAT("MST STAT")
        S ECXSTATE=ECXPAT("STATE")
        S ECXCNTY=ECXPAT("COUNTY")
        S ECXZIP=ECXPAT("ZIP")
        S ECXENRL=ECXPAT("ENROLL LOC")
        S ECXSVC=ECXPAT("SC%")
        S ECXPHI=ECXPAT("PHI")
        S ECXHI=+$$INSUR^IBBAPI(ECXDFN,ECXDATE)
        S ECXEST=ECXPAT("EC STAT")
        ;
        ;-OEF/OIF Data
        S ECXOEF=ECXPAT("ECXOEF")
        S ECXOEFDT=ECXPAT("ECXOEFDT")
        ;
        ;- Agent Orange location
        S ECXAOL=ECXPAT("AOL")
        ;
        ; - Head and Neck Cancer Indicator
        S ECXHNCI=$$HNCI^ECXUTL4(ECXDFN)
        ; - Race and Ethnicity
        S ECXETH=ECXPAT("ETHNIC")
        S ECXRC1=ECXPAT("RACE1")
        ;
        ;get primary care data
        S X=$$PRIMARY^ECXUTL2(ECXDFN,ECXDATE)
        S ECPTTM=$P(X,U),ECPTPR=$P(X,U,2),ECCLAS=$P(X,U,3),ECPTNPI=$P(X,U,4)
        S ECASPR=$P(X,U,5),ECCLAS2=$P(X,U,6),ECASNPI=$P(X,U,7)
        ;get combat veteran data
        I $$CVEDT^ECXUTL5(ECXDFN,ECD)
        ;get national patient record flag if exist
        D NPRF^ECXUTL5
        ;get emergency response indicator (FEMA)
        S ECXERI=ECXPAT("ERI")
        Q
        ;
PTF     ; get admitting DRG, diagnosis, source of admission from PTF
        ;use number for DRG and .01 for diagnosis
        N EC,EC1,ECX
        S EC=1 I $D(^DGPT(ECPTF,"M",2,0)) S EC=2
        S EC1=+$P(^DGPT(ECPTF,"M",EC,0),U,5)
        S ECDRG=$P($G(^DGPT(ECPTF,"M",EC,"P")),U)
        S ECDIA=$P($G(^ICD9(EC1,0)),U)
        S ECX=+$P($G(^DGPT(ECPTF,101)),U),ECXSADM=$P($G(^DIC(45.1,ECX,0)),U,11)
        Q
        ;
FILE    ;file the extract record
        ;node0
        ;facility^dfn^ssn^name^in/out^day^primary care team^sex^dob^
        ;religion^employment status^health ins^state^county^zip^
        ;eligibility^vet^vietnam^agent orange^radiation^pow^
        ;period of service^means test^marital status^
        ;ward^treating specialty^attending physician^mov #^DRG^diagnosis^
        ;time^primary care provider^race^primary ward provider
        ;node1
        ;mpi^dss dept^attending npi^pc provider npi^ward provider npi^
        ;admission elig^mst status^^sharing payor^
        ;sharing insurance^enrollment location^
        ;pc prov person class^assoc pc provider^assoc pc prov person class^
        ;assoc pc prov npi^dom^enrollment cat^enrollment stat^enrollment
        ;priority^purple heart ind.^obs pat ind^encounter num^agent orange
        ;loc^production div^pow loc^source of admission^head & neck canc. ind
        ;^ethnicity^race1^enrollment priority_sub group^user enrollee^patient
        ;type^combat vet elig^combat vet elig end date^enc cv eligible^
        ;national patient record flag ECXNPRFI^att phy person class ECXATTPC
        ;^primary ward provider person class ECXPRVPC^environ contamin ECXEST
        ;^emergency response indicator(FEMA) ECXERI^agent orange indic ECXAO
        ;^environ contam ECXECE^encoun head/neck ECXHNC^encoun MST ECXMIL^rad
        ;encoun ECXIR^ OEF/OIF ECXOEF^ OEF/OIF return date ECXOEFDT
        ;^associate pc provider npi ECASNPI^attending physician npi ECATNPI^
        ;primary care provider npi ECPTNPI^primary ward provider npi ECPWNPI
        ;
        ;Convert specialty to PTF Code
        ;
        N ECXDATA
        S ECXDATA=$$TSDATA^DGACT(42.4,+ECXSPC,.ECXDATA)
        S ECXSPC=$G(ECXDATA(7))
        ;
        N DA,DIK
        S EC7=$O(^ECX(ECFILE,999999999),-1),EC7=EC7+1
        S ECODE=EC7_U_EC23_U_ECXFAC_U_ECXDFN_U_ECXSSN_U_ECXPNM_U_ECXA_U_ECXDATE_U
        S ECODE=ECODE_ECPTTM_U_ECXSEX_U_ECXDOB_U_ECXRELG_U
        S ECODE=ECODE_ECXEMP_U_ECXHI_U_ECXSTATE_U_ECXCNTY_U_ECXZIP_U
        S ECODE=ECODE_ECXELIG_U_ECXVET_U_ECXVNS_U_ECXAST_U_ECXRST_U_ECXPST_U
        S ECODE=ECODE_ECXPOS_U_ECXMNS_U_ECXMAR_U
        S ECODE=ECODE_ECXWRD_U_ECXSPC_U_ECXATT_U_ECDA_U_ECDRG_U_ECDIA_U
        S ECODE=ECODE_ECTM_U_ECPTPR_U_ECXRACE_U_ECXPRV_U
        S ECODE1=ECXMPI_U_ECXDSSD_U_""_U_""_U_""_U_ELGA_U
        S ECODE1=ECODE1_ECXMST_U_U_U_U_ECXENRL_U_ECCLAS_U
        S ECODE1=ECODE1_ECASPR_U_ECCLAS2_U_U_ECXDOM_U_ECXCAT_U
        S ECODE1=ECODE1_ECXSTAT_U_$S(ECXLOGIC<2005:ECXPRIOR,1:"")_U_ECXPHI_U_ECXOBS_U_ECXENC_U_ECXAOL_U
        S ECODE1=ECODE1_ECXPDIV_U_ECXPLOC_U_ECXSADM_U_ECXHNCI_U_ECXETH_U
        S ECODE1=ECODE1_ECXRC1
        I ECXLOGIC>2004 S ECODE1=ECODE1_U_ECXPRIOR_ECXSBGRP_U_ECXUESTA_U_ECXPTYPE_U_ECXCVE_U_ECXCVEDT_U_ECXCVENC_U_ECXNPRFI
        I ECXLOGIC>2005 S ECODE1=ECODE1_U_ECXATTPC_U_ECXPRVPC_U_ECXEST
        I ECXLOGIC>2006 S ECODE1=ECODE1_U_ECXERI_U_ECXAO_U_ECXECE_U_ECXHNC_U_ECXMIL_U_ECXIR_U
        I ECXLOGIC>2007 S ECODE2=ECXOEF_U_ECXOEFDT_U_ECASNPI_U_ECATTNPI_U_ECPTNPI_U_ECPWNPI
        S ^ECX(ECFILE,EC7,0)=ECODE,^ECX(ECFILE,EC7,1)=ECODE1,^ECX(ECFILE,EC7,2)=$G(ECODE2)
        S ECRN=ECRN+1
        S DA=EC7,DIK="^ECX("_ECFILE_"," D IX1^DIK K DIK,DA
        Q
        ;
SETUP   ;Set required input for ECXTRAC.
        S ECHEAD="ADM"
        D ECXDEF^ECXUTL2(ECHEAD,.ECPACK,.ECGRP,.ECFILE,.ECRTN,.ECPIECE,.ECVER)
        Q
        ;
LOCAL   ; to extract nightly for local use not to be transmitted to TSI
        ; should be queued with a 1D frequency
        D SETUP,^ECXTLOCL,^ECXKILL Q
        ;
QUE     ; entry point for the background requeuing handled by ECXTAUTO
        D SETUP,QUE^ECXTAUTO,^ECXKILL Q
        ;
