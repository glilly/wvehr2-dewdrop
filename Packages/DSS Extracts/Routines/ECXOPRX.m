ECXOPRX ;ALB/JAP,BIR/DMA,CML,PTD-Prescription Extract for DSS ; 11/5/07 8:17am
        ;;3.0;DSS EXTRACTS;**10,11,8,13,24,30,33,38,39,46,49,71,81,84,92,105,112**;Dec 22, 1997;Build 26
        ;
BEG     ;entry point from option
        D SETUP I ECFILE="" Q
        D ^ECXTRAC,^ECXKILL
        Q
        ;
START   ;entry when queued
        N X,DA,DIC,DIQ,DR,ECXNPRFI,ECRXPTST,ECNONVAP,ECRXNUM,ECXSCRX
        S QFLG=0
        I '$D(ECINST) D
        .S ECINST=+$P(^ECX(728,1,0),U) K ECXDIC S DA=ECINST,DIC="^DIC(4,",DIQ(0)="I",DIQ="ECXDIC",DR=".01;99"
        .D EN^DIQ1 S ECINST=$G(ECXDIC(4,DA,99,"I")) K DIC,DIQ,DA,DR,ECXDIC
        ;before V6
        S ECPROF=6,ECD=$O(^PSRX("AL",0)) I ECD,ECD<ECSD1 G V6
        S ECED=ECED+.3,ECREF=1,ECD=ECSD1
        F  S ECD=$O(^PSRX("AD",ECD)),ECRX=0 Q:'ECD  Q:ECD>ECED  Q:QFLG  F  S ECRX=$O(^PSRX("AD",ECD,ECRX)),ECRFL="" Q:'ECRX  F  S ECRFL=$O(^PSRX("AD",ECD,ECRX,ECRFL)) Q:ECRFL=""  D STUFF Q:QFLG
        Q
        ;
V6      ;version 6 or better
        K ^TMP($J,"ECXP")
        S ECPROF=2,ECED=ECED+.3,ECREF=1,ECD=ECSD1
        F  S ECD=$O(^PSRX("AL",ECD)),ECRX=0 Q:'ECD  Q:ECD>ECED  Q:QFLG  F  S ECRX=$O(^PSRX("AL",ECD,ECRX)),ECRFL="" Q:'ECRX  F  S ECRFL=$O(^PSRX("AL",ECD,ECRX,ECRFL)) Q:ECRFL=""  D STUFF Q:QFLG
        Q:QFLG
        S ECREF="P",ECD=ECSD1
        F  S ECD=$O(^PSRX("AM",ECD)),ECRX=0 Q:'ECD  Q:ECD>ECED  Q:QFLG  F  S ECRX=$O(^PSRX("AM",ECD,ECRX)),ECRFL="" Q:'ECRX  F  S ECRFL=$O(^PSRX("AM",ECD,ECRX,ECRFL)) Q:ECRFL=""  D STUFF Q:QFLG
        K ^TMP($J,"ECXP")
        Q
        ;
STUFF   ;get data
        N ECXPHA
        S ECDATA=$G(^PSRX(ECRX,0)),ECXPHA=""
        I ECRFL S ECDATA1=$G(^PSRX(ECRX,ECREF,ECRFL,0)) I ECDATA1="" Q
        ;ecref set to 1 in extract+5 and v6+1 and to "P" in v6+2
        ;refill nodes and partial nodes are identical in layout.  Fills
        ;(ie ecrfl=0)& refills (ie ecrfl>0) from "AL" xref, partials from "AM"
        S (ECXDSSD,ECXPROVN,ECXCVE,ECXCVEDT,ECXCVENC,ECRXPTST,ECRXNUM)="",ECXERR=0,ECXDATE=ECD,ECXDFN=$P(ECDATA,U,2),ECDRG=+$P(ECDATA,U,6)
        ;- Get rx patient status & rx number
        S ECRXPTST=$$RXPTST^ECXUTL5($P(ECDATA,U,3)),ECRXNUM=$P(ECDATA,U,1)
        ;- Get provider (either 2_provider or 6_provider depending on version)
        S ECXPROV=$S($P(ECDATA,U,4)'="":ECPROF_$P(ECDATA,U,4),1:""),ECXPROVP=$$PRVCLASS^ECXUTL($P(ECDATA,U,4),ECXDATE)
        S ECPRVNPI=$$NPI^XUSNPI("Individual_ID",$P(ECDATA,U,4),ECXDATE)
        S:+ECPRVNPI'>0 ECPRVNPI="" S ECPRVNPI=$P(ECPRVNPI,U)
        ;get classification data
        S ECXCLS=$G(^PSRX(ECRX,"IBQ")),ECXMIL=$P(ECXCLS,U,2),ECXAO=$P(ECXCLS,U,3),ECXIR=$P(ECXCLS,U,4),ECXECE=$P(ECXCLS,U,5),ECXHNC=$P(ECXCLS,U,6)
        F X="ECXMIL","ECXAO","ECXIR","ECXECE","ECXHNC" S @X=$S(@X:"Y",@X=0:"N",1:"")
        ;- Check non-va provider flag and set to 'Y' if exist
        S ECNONVAP=$$NONVAP^ECXUTL5($E(ECXPROV,2,99))
        ;get patient specific data
        D PAT(ECXDFN,ECXDATE,.ECXERR) Q:ECXERR
        I 'ECRFL D
        .S ECMW=$P(ECDATA,U,11),ECQTY=+$P(ECDATA,U,7),ECXDIV=$S($D(^PSRX(ECRX,2)):$P(^(2),U,9),1:1)
        .S ECPRC=+$P(ECDATA,U,17),ECOPAY=$P($G(^PSRX(ECRX,"IB")),U,2)]""
        I ECRFL D
        .S ECMW=$P(ECDATA1,U,2),ECQTY=+$P(ECDATA1,U,4),ECXDIV=$S(+$P(ECDATA1,U,9):$P(ECDATA1,U,9),1:1)
        .S ECPRC=+$P(ECDATA1,U,11),ECOPAY=$P($G(^PSRX(ECRX,1,ECRFL,"IB")),U)]""
        S ECXCOST=$J((ECQTY*ECPRC),1,2),ECDS=$S(ECRFL:$P(ECDATA1,U,10),1:$P(ECDATA,U,8))
        ;call pharmacy drug file (#50) api
        S ECXPHA=$$PHAAPI^ECXUTL5(ECDRG),ECCAT=$P(ECXPHA,U,2),ECINV=$P(ECXPHA,U,4)["I",ECINV=$S(ECINV:"I",1:""),ECUI=$P(ECXPHA,U,8),ECNDC=$P(ECXPHA,U,3)
        S ECNFC=$$RJ^XLFSTR($P(ECNDC,"-"),6,0)_$$RJ^XLFSTR($P(ECNDC,"-",2),4,0)_$$RJ^XLFSTR($P(ECNDC,"-",3),2,0),ECNFC=$TR(ECNFC,"*",0),P1=$P(ECXPHA,U,5),P3=$P(ECXPHA,U,6)
        S X="PSNAPIS" X ^%ZOSF("TEST") I $T S ECNFC=$$DSS^PSNAPIS(P1,P3,ECXYM)_ECNFC
        I $L(ECNFC)=12 S ECNFC=$$RJ^XLFSTR(P1,4,0)_$$RJ^XLFSTR(P3,3,0)_ECNFC
        I ECMW="M" S ECMW=1 I $D(^PSRX("AR",ECD,ECRX)) S ECMW=2
        I ECMW="W" S ECMW=""
        S ECXNEW="" I ECRFL=0 S ECXNEW=1
        S ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXTS) ;Observation pat indic (YES/NO)
        S ECXORDPH="" ;Ordering physician (null for FY2002)
        ;- Ordering stop code & Ordering date
        S ECXORDST=$P($G(^ECX(728.44,+$P(ECDATA,U,5),0)),U,2),ECXORDDT=$$ECXDATE^ECXUTL(+$P(ECDATA,U,13),ECXYM)
        S ECXCNH=$$CNHSTAT^ECXUTL4(ECXDFN) ;CNH status (YES/NO)
        ;- DSS Dept and National Prod Division
        ;S ECXDSSD=$$PRE^ECXDEPT(ECXDIV,ECMW,ECINST) dss department postponed
        N ECXPDIV S ECXPDIV=$$PREDIV^ECXDEPT(ECXDIV)
        ;- Set national patient record flag if exist
        D NPRF^ECXUTL5
        S ECXSCRX=$$SCRX^ECXUTL5(ECRX) ;Service connected rx
        ;- If no encounter number don't file record
        S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADMDT,ECXDATE,ECXTS,ECXOBS,ECHEAD,,)
        I ECXLOGIC>2003 D
        .I (ECMW=2)!((ECMW=1)&(ECXLOGIC>2006)),ECXSSN'="" D
        .. N TMP
        .. I (ECXLOGIC>2008) S TMP=$$JULDT^ECXUTL4(ECD),ECXENC=$E(ECXSSN,1,9)_TMP_"PHA"
        .. E  S TMP=$$JULDT^ECXUTL4(ECD),ECXENC=$E(ECXSSN,1,9)_TMP_"160"
        .. S ECXA="O"
        I ECXENC'="" D FILE^ECXOPRX1
        Q
        ;
PAT(ECXDFN,ECXDATE,ECXERR)      ;Determine in/outpatient status, movement number, primary care team and provider
        N OK,X,PT
        S (ECXCAT,ECXSTAT,ECXPRIOR,ECXSBGRP,ECXOEF,ECXOEFDT)=""
        ;get patient data if saved
        I $D(^TMP($J,"ECXP",ECXDFN)) D
        .S PT=^TMP($J,"ECXP",ECXDFN),ECXSSN=$P(PT,U),ECXPNM=$P(PT,U,2),ECXMPI=$P(PT,U,3),ECXSEX=$P(PT,U,4),ECXDOB=$P(PT,U,5)
        .S ECXELIG=$P(PT,U,6),ECXVET=$P(PT,U,7),ECXRACE=$P(PT,U,8),ECXPST=$P(PT,U,9),ECXPLOC=$P(PT,U,10),ECXRST=$P(PT,U,11)
        .S ECXAST=$P(PT,U,12),ECXMST=$P(PT,U,13),ECXSTATE=$P(PT,U,14),ECXCNTY=$P(PT,U,15),ECXZIP=$P(PT,U,16),ECXENRL=$P(PT,U,17)
        .S ECXPHI=$P(PT,U,20),ECXCAT=$P(PT,U,21),ECXSTAT=$P(PT,U,22),ECXPRIOR=$P(PT,U,23)
        .S ECXCNHU=$P(PT,U,24),ECXPOS=$P(PT,U,25),ECXAOL=$P(PT,U,26),ECXHNCI=$P(PT,U,27),ECXETH=$P(PT,U,28),ECXRC1=$P(PT,U,29),ECXMTST=$P(PT,U,30)
        .S PT1=$G(^TMP($J,"ECXP",ECXDFN,1)),ECXERI=$P(PT1,U),ECXEST=$P(PT1,U,2),ECXOEF=$P(PT1,U,3),ECXOEFDT=$P(PT1,U,4)
        .I $$ENROLLM^ECXUTL2(ECXDFN)
        ;set patient data
        I '$D(^TMP($J,"ECXP",ECXDFN)) D  Q:'OK
        .K ECXPAT
        .S OK=$$PAT^ECXUTL3(ECXDFN,$P(ECSD1,"."),"1;2;3;5",.ECXPAT)
        .I 'OK S ECXERR=1 Q
        .S ECXSSN=ECXPAT("SSN"),ECXPNM=ECXPAT("NAME"),ECXMPI=ECXPAT("MPI"),ECXSEX=ECXPAT("SEX"),ECXDOB=ECXPAT("DOB"),ECXELIG=ECXPAT("ELIG")
        .S ECXVET=ECXPAT("VET"),ECXRACE=ECXPAT("RACE"),ECXPST=ECXPAT("POW STAT"),ECXPLOC=ECXPAT("POW LOC"),ECXRST=ECXPAT("IR STAT")
        .S ECXAST=ECXPAT("AO STAT"),ECXMST=ECXPAT("MST STAT"),ECXSTATE=ECXPAT("STATE"),ECXCNTY=ECXPAT("COUNTY"),ECXZIP=ECXPAT("ZIP"),ECXENRL=ECXPAT("ENROLL LOC")
        .S ECXERI=ECXPAT("ERI"),ECXEST=ECXPAT("EC STAT")
        .;- CNH Stat (placeholder),Purp Heart Ind,Per of Svce,AO Loc,MT Stat
        .S ECXCNHU="",ECXPHI=ECXPAT("PHI"),ECXPOS=ECXPAT("POS"),ECXAOL=ECXPAT("AOL"),ECXMTST=ECXPAT("MEANS")
        .I $$ENROLLM^ECXUTL2(ECXDFN)
        .S ECXHNCI=$$HNCI^ECXUTL4(ECXDFN) ;Head and Neck Cancer Indicator
        .S ECXETH=ECXPAT("ETHNIC"),ECXRC1=ECXPAT("RACE1") ;Race and Ethnicity
        .; OEF/OIF data
        .S ECXOEF=ECXPAT("ECXOEF")
        .S ECXOEFDT=ECXPAT("ECXOEFDT")
        .S ^TMP($J,"ECXP",ECXDFN)=ECXSSN_U_ECXPNM_U_ECXMPI_U_ECXSEX_U_ECXDOB_U_ECXELIG_U_ECXVET_U_ECXRACE_U_ECXPST_U_ECXPLOC_U_ECXRST_U_ECXAST_U_ECXMST_U_ECXSTATE_U_ECXCNTY_U_ECXZIP_U_ECXENRL_U_U
        .S ^TMP($J,"ECXP",ECXDFN)=^TMP($J,"ECXP",ECXDFN)_U_ECXPHI_U_ECXCAT_U_ECXSTAT_U_ECXPRIOR_U_ECXCNHU_U_ECXPOS_U_ECXAOL_U_ECXHNCI_U_ECXETH_U_ECXRC1_U_ECXMTST
        .S ^TMP($J,"ECXP",ECXDFN,1)=ECXERI_U_ECXEST_U_ECXOEF_U_ECXOEFDT
        ;get inpatient data
        S (ECXA,ECXADMDT,ECXDOM,ECXMN,ECXTS)="",X=$$INP^ECXUTL2(ECXDFN,ECXDATE) D
        .S ECXA=$P(X,U),ECXMN=$P(X,U,2),ECXTS=$P(X,U,3),ECXDOM=$P(X,U,10),ECXADMDT=$P(X,U,4)
        ;get primary care data
        S X=$$PRIMARY^ECXUTL2(ECXDFN,$P(ECXDATE,".")),ECPTTM=$P(X,U),ECPTPR=$P(X,U,2),ECCLAS=$P(X,U,3),ECPTNPI=$P(X,U,4),ECASPR=$P(X,U,5),ECCLAS2=$P(X,U,6),ECASNPI=$P(X,U,7)
        Q
        ;
SETUP   ;Set required input for ECXTRAC
        S ECHEAD="PRE"
        D ECXDEF^ECXUTL2(ECHEAD,.ECPACK,.ECGRP,.ECFILE,.ECRTN,.ECPIECE,.ECVER)
        Q
QUE     ; entry point for the background requeuing handled by ECXTAUTO
        D SETUP,QUE^ECXTAUTO,^ECXKILL Q
