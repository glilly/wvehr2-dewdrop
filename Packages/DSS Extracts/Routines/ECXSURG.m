ECXSURG ;ALB/JA,BIR/DMA,PTD-Surgery Extract for DSS ;9/8/10  16:45
        ;;3.0;DSS EXTRACTS;**1,11,8,13,25,24,33,39,41,42,46,50,71,84,92,99,105,112,128,127**;Dec 22, 1997;Build 36
BEG     ;entry point from option
        D SETUP I ECFILE="" Q
        D ^ECXTRAC,^ECXKILL
        Q
        ;
START   ;
        K ^TMP($J,"ECXS"),^TMP($J,"ECXCL")
        S QFLG=0,ECED=ECED+.3,ECD=ECSD1
        F  S ECD=$O(^SRF("AC",ECD)),ECD0=0 Q:('ECD)!(ECD>ECED)!(QFLG)  D
        .F  S ECD0=$O(^SRF("AC",ECD,ECD0)) Q:'ECD0  D
        ..I $D(^SRF(ECD0,0)) S EC=^SRF(ECD0,0),ECXDFN=+$P(EC,U),ECXVISIT=$P(EC,U,15) D STUFF Q:QFLG
        K ^TMP($J,"ECXS"),^TMP($J,"ECXCL")
        Q
        ;
STUFF   ;gather data
        N J,X,Y,PP,DATA1,DATA2,DATAOP,ARR,ERR,SUB,MOD,ECXNONL,ECXSTOP,TIMEDIF
        N ECPRO,ECXORCT,ECXPTHA,ECXNPRFI,ECXPA,ECXPAPC,ECSRPC,ECATPC,ECSAPC
        N ECXCRST,ECXSTCD,ECXCLIN,EC1A,EC2A,ECPQ,ECQA,EC1APC,EC2APC,ECPQPC
        N ECQAPC,EC1ANPI,EC2ANPI,ECPQNPI,ECQANPI
        N ECXORCET,ECXORCST,ECXTPOOR ;ECX*128
        S ECXDATE=ECD,ECXERR=0,ECXQ=""
        Q:'$$PATDEM^ECXUTL2(ECXDFN,ECXDATE,"1;2;3;5;")
        I ECXADMDT="" S ECXADD=ECXADMDT
        I ECXADMDT'="" S ECXADD=$$ECXDATE^ECXUTL(ECXADMDT,ECXYM)
        S OK=$$PAT^ECXUTL3(ECXDFN,ECXDATE,"1;5",.ECXPAT)
        I 'OK S ECXERR=1 K ECXPAT Q
        ;OEF/OIF DATA
        S ECXOEF=ECXPAT("ECXOEF")
        S ECXOEFDT=ECXPAT("ECXOEFDT")
        S EC0=^SRF(ECD0,0)
        S DATA1=$S($D(^SRF(ECD0,.1)):^(.1),1:"")
        S DATA2=$S($D(^SRF(ECD0,.2)):^(.2),1:"")
        S DATAOP=$S($D(^SRO(136,ECD0,0)):^(0),1:"")
        S ECNO=$G(^SRF(ECD0,"NON"))
        ; if VISIT data exist get encounter data
        ; ECX*112
        S ECXVST=$P(^SRF(ECD0,0),U,15) D:ECXVST'=""
        . Q:'$D(^AUPNVSIT(ECXVST,800))
        . S ECENSC=$P(^AUPNVSIT(ECXVST,800),U,1)
        . S ECENSC=$S(ECENSC=0:"N",ECENSC=1:"Y",1:"")
        ;get data
        S ECSR=$P(DATA1,U,4),(ECATNPI,ECSANPI,ECSRNPI)="",ECAT=$P(DATA1,U,13)
        S ECSRNPI=$$NPI^XUSNPI("Individual_ID",ECSR,ECXDATE)
        S:+ECSRNPI'>0 ECSRNPI="" S ECSRNPI=$P(ECSRNPI,U)
        ;-Time patient in OR room (Nurse Time)
        S ECXTM=$$ECXTIME^ECXUTL($P(DATA2,U,10))
        S ECXDIV=$S($D(^SRF(ECD0,8)):^(8),1:ECINST)
        N ECXPDIV S ECXPDIV=$$RADDIV^ECXDEPT(ECXDIV)  ;Production Division
        S ECSA=$P($G(^SRF(ECD0,.3)),U,4),ECO=$P(EC0,U,2)
        S ECSANPI=$$NPI^XUSNPI("Individual_ID",ECSA,ECXDATE)
        S:+ECSANPI'>0 ECSANPI="" S ECSANPI=$P(ECSANPI,U)
        ;get principle anesthetist and person class DBIA #103
        S ECXPA=$P($G(^SRF(ECD0,.3)),U,1)
        S ECPANPI=$$NPI^XUSNPI("Individual_ID",ECXPA,ECXDATE)
        S:+ECPANPI'>0 ECPANPI="" S ECPANPI=$P(ECPANPI,U)
        S ECXPAPC=$$PRVCLASS^ECXUTL(ECXPA,ECXDATE)
        ;get first asst, 2nd asst, perfusionist, and asst perfusionist
        S EC1A=$P(DATA1,U,5),EC2A=$P(DATA1,U,6),ECPQ=$P(DATA1,U,19),ECQA=$P(DATA1,U,20)
        S EC1ANPI=$$NPI^XUSNPI("Individual_ID",EC1A,ECXDATE)
        S:+EC1ANPI'>0 EC1ANPI="" S EC1ANPI=$P(EC1ANPI,U)
        S EC2ANPI=$$NPI^XUSNPI("Individual_ID",EC2A,ECXDATE)
        S:+EC2ANPI'>0 EC2ANPI="" S EC2ANPI=$P(EC2ANPI,U)
        S ECPQNPI=$$NPI^XUSNPI("Individual_ID",ECPQ,ECXDATE)
        S:+ECPQNPI'>0 ECPQNPI="" S ECPQNPI=$P(ECPQNPI,U)
        S ECQANPI=$$NPI^XUSNPI("Individual_ID",ECQA,ECXDATE)
        S:+ECQANPI'>0 ECQANPI="" S ECQANPI=$P(ECQANPI,U)
        S ECORTY=$P($G(^SRS(+ECO,2)),U),ECO=$P($G(^SRS(+ECO,0)),U)
        S ECSS=$P($G(^SRO(137.45,+$P(EC0,U,4),0)),U,2)
        S ECSS=$$RJ^XLFSTR($P($G(^DIC(45.3,+ECSS,0)),U),3,0)
        S:ECSS="000" ECSS="999"
        ;get classification information
        S (ECXAO,ECXHNC,ECXSHAD,ECXSHADI)="" I ECXVISIT'="" D
        .D VISIT^ECXSCX1(ECXDFN,ECXVISIT,.ECXVIST,.ECXERR) I ECXERR K ECXERR
        .S ECXAO=$G(ECXVIST("AO")),ECXHNC=$G(ECXVIST("HNC"))
        .S ECENRI=$G(ECXVIST("IR")),ECENMST=$G(ECXVIST("MST"))
        .S ECENEC=$G(ECXVIST("PGE")),ECXSHAD=$G(ECXVIST("SHAD"))
        ; - Head and Neck Cancer Indicator
        S ECXHNCI=$$HNCI^ECXUTL4(ECXDFN)
        ; - Shad Encounter Field
        S ECXSHADI=$$SHAD^ECXUTL4(ECXDFN)
        ;look for non-OR
        S (ECNT,ECNL,ECXDSSD,ECXNONL,ECXSTOP)=""
        I $P(ECNO,U)="Y" D
        .S ECSR=$P(ECNO,U,6),ECAT=$P(ECNO,U,7)
        .S ECSRNPI=$$NPI^XUSNPI("Individual_ID",ECSR,ECXDATE)
        .S:+ECSRNPI'>0 ECSRNPI="" S ECSRNPI=$P(ECSRNPI,U)
        .S ECATNPI=$$NPI^XUSNPI("Individual_ID",ECAT,ECXDATE)
        .S:+ECATNPI'>0 ECATNPI="" S ECATNPI=$P(ECATNPI,U)
        .S ECXTM=$$ECXTIME^ECXUTL($P(ECNO,U,4))
        .S A1=$P(ECNO,U,5),A2=$P(ECNO,U,4),TIME="##" D:(A1&A2) TIME S ECNT=TIME
        .S (ECXNONL,ECNL)=+$P(ECNO,U,2),ECNL=$P($G(^ECX(728.44,ECNL,0)),U,9)
        .S:ECNL="" ECNL="UNKNOWN"
        .;
        .;- Get Primary or DSS Stop Code to use in encounter number
        .N P1 ;primary stop
        .D FEEDER^ECXSCX1(+$P(EC0,U,21),ECXDATE,.P1,,,,) S ECXSTOP=$E(P1,1,3)
        .S ECXSTOP=$S(ECXSTOP:ECXSTOP,1:$P($G(^ECX(728.44,ECXNONL,0)),U,4))
        ;
        ;- Get credit stop, stop code and clinic
        I $$SUR^ECXUTL6(.ECXCRST,.ECXSTCD,.ECXCLIN)
        ;
        ;- If surgery cancelled/aborted quit and go to next record
        S ECCAN=$P($G(^SRF(ECD0,30)),U)
        I +ECCAN S ECCAN=$$CANC^ECXUTL4(ECNL,$P(DATA2,U,10))
        ;on hold for ECXDSSD and ECXDSSP I $P($G(^SRF(ECD0,30)),U) Q
        ;get service of attending surgeon
        S ECATSV=$P($G(^DIC(49,+$G(^VA(200,+ECAT,5)),730)),U)
        ;
        ;get surgeon, attending and anesthesia super person classes
        ;get 1st asst, 2nd asst, perfusionist, and asst perfusionst person class
        S ECSRPC=$$PRVCLASS^ECXUTL(ECSR,ECXDATE)
        S ECATPC=$$PRVCLASS^ECXUTL(ECAT,ECXDATE)
        S ECSAPC=$$PRVCLASS^ECXUTL(ECSA,ECXDATE)
        S EC1APC=$$PRVCLASS^ECXUTL(EC1A,ECXDATE)
        S EC2APC=$$PRVCLASS^ECXUTL(EC2A,ECXDATE)
        S ECPQPC=$$PRVCLASS^ECXUTL(ECPQ,ECXDATE)
        S ECQAPC=$$PRVCLASS^ECXUTL(ECQA,ECXDATE)
        ;
        ;add leading 2s for pointer to 200
        S:ECAT ECAT="2"_ECAT S:ECSR ECSR="2"_ECSR S:ECSA ECSA="2"_ECSA
        ;add leading 2 to principle anesthetist IEN
        S:ECXPA ECXPA="2"_ECXPA
        ;add leading 2s for 1st asst, 2nd asst, perfusionist, asst perfusionist
        S:EC1A EC1A="2"_EC1A S:EC2A EC2A="2"_EC2A S:ECPQ ECPQ="2"_ECPQ S:ECQA ECQA="2"_ECQA
        ;anesthesia technique
        S ECANE="",PP=""
        I $D(^SRF(ECD0,6,0)) S ECXJ=0 D
        .F  S ECXJ=$O(^SRF(ECD0,6,ECXJ)) Q:('ECXJ)!(ECANE]"")  D
        ..S PP=$P($G(^(ECXJ,0)),U,3) S:PP="Y" ECANE=$P(^(0),U,1)
        .I ECANE="" S ECXJ=$O(^SRF(ECD0,6,0)) I ECXJ S ECANE=$P(^SRF(ECD0,6,ECXJ,0),U,1)
        ;get primary procedure
        ;ecode0=p^cpt code^^patient time^operation time^anesthesia time
        S ECPT=+$P(DATAOP,U,2),ECXCMOD=""
        K ARR,ERR D FIELD^DID(130,28,,"LABEL","ARR","ERR") I $D(ARR("LABEL")) D
        .K ARR,ERR D FIELD^DID(130,28,,"GLOBAL SUBSCRIPT LOCATION","ARR","ERR")
        .Q:$D(ERR("DIERR"))
        .S SUB=$P(ARR("GLOBAL SUBSCRIPT LOCATION"),";"),MOD=0
        .F  S MOD=$O(^SRF(ECD0,SUB,MOD)) Q:MOD'>0  D
        ..S ECXCMOD=ECXCMOD_$P(^(MOD,0),U)_";"
        S ECXCPT=$$CPT^ECXUTL3(ECPT,ECXCMOD)
        S ECODE0="P"_U_U  ;ECPT_U
        F J="10,12","2,3","1,4" D
        .N ECNTIME,ECSTIME,ECATIME
        .S A2=$P(DATA2,U,$P(J,",")),A1=$P(DATA2,U,$P(J,",",2)),TIME="##"
        .I (A1&A2)&(+J=10) D TIME  S ECNTIME=TIME
        .I (A1&A2)&(+J=1) D TIME  S ECATIME=TIME
        .I (A1&A2)&(+J=2) D
        ..;
        ..;-Operation Time (Surgeon Time)
        ..;-Get time diff (in secs) & set to .5 if < 7.5 minutes (rounds to 1)
        ..S TIMEDIF=$$FMDIFF^XLFDT(A1,A2,2)/900
        ..S TIMEDIF=$S(TIMEDIF>0&(TIMEDIF<.5):.5,1:TIMEDIF)
        ..S TIME=$TR($J(TIMEDIF,4,0)," ")
        ..S:TIME<0 TIME="###"
        ..S:TIME ECSTIME=TIME
        .S ECODE0=ECODE0_U_TIME K TIME
        ; -Recovery Room Time
        S ECRR=""
        I $D(^SRF(ECD0,1.1)) D
        .S A1=$P(^(1.1),U,8),A2=$P(^(1.1),U,7),TIME="##" D:(A1&A2) TIME
        .S ECRR=TIME K TIME
        I ECNL]"" S $P(ECODE0,U,5)=ECNT
        ;
        ; -OR Clean Time in 15 min increments DBIA #103
        ;
        ; ECX*3.0*128 - Correct the calculation of OR Clean Time.
        S ECXORCT=0
        ; Set local variables. ECX*128
        S ECXTPOOR=$P($G(DATA2),U,12),ECXORCST=$P($G(DATA2),U,13),ECXORCET=$P($G(DATA2),U,14)
        I (ECXORCET'=""),(ECXORCST'="") D
        .S ECXORCT=($$FMDIFF^XLFDT(ECXORCET,ECXORCST,2)/60)/15
        I 'ECXORCT,(ECXORCET'=""),(ECXTPOOR'="") D
        .S ECXORCT=($$FMDIFF^XLFDT(ECXORCET,ECXTPOOR,2)/60)/15
        ; Make sure the final OR CLEAN TIME is an integer by rounding
        ; up for any decimal value  ECX*3.0*128
        I ECXORCT>0 S ECXORCT=$J(ECXORCT+.4999,0,0)
        ; -If no OR clean time recorded set it to 2
        I ECXORCT'>0 S ECXORCT=2
        ;
        ; -PT in hold area time in 15 min increments DBIA #103
        I $P($G(DATA2),U,10),$P($G(DATA2),U,15) D
        .S ECXPTHA=($$FMDIFF^XLFDT($P($G(DATA2),U,10),$P($G(DATA2),U,15),2)/60)/15
        .S CON=$P($G(^SRF(ECD0,"CON")),U)
        .I CON S ECXPTHA=ECXPTHA/2
        .S ECXPTHA=$TR($J(ECXPTHA,3,0)," ")
        ; -If hold time is =<0 set it to ""
        S:$G(ECXPTHA)'>0 ECXPTHA=""
        ;
        ;- get ASA CLASS
        S ECASA=$$GET1^DIQ(132.8,$$GET1^DIQ(130,ECD0,1.13,"I"),.01)
        ;
        ;- Observation Patient Indicator (yes/no)
        S ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXTS,ECNL)
        ;
        ; ******* - PATCH 127, ADD PATCAT CODE ********
        S ECXPATCAT=$$PATCAT^ECXUTL(ECXDFN)
        ;- set national patient record flag if exist
        D NPRF^ECXUTL5
        ;
        ;- If no encounter number don't file record
        S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADMDT,ECXDATE,ECXTS,ECXOBS,ECHEAD,ECXSTOP,ECSS) Q:ECXENC=""
        ;
        ;- Get postop diagnosis codes
        I $$SURPODX^ECXUTL6(.ECXPODX,.ECXPODX1,.ECXPODX2,.ECXPODX3,.ECXPODX4,.ECXPODX5)
        ;
        D FILE^ECXSURG1
        ;get secondary procedures
        ;ecode0=s^cpt code
        S ECXJ=0
        F  S ECXJ=$O(^SRO(136,ECD0,3,ECXJ)) Q:'ECXJ  I $D(^(ECXJ,0)),$D(^(0)),$P(^(0),"^")]"" D
        .;S ECPT=$P(^SRF(ECD0,13,ECXJ,2),U),ECXCMOD=""
        .S ECPT=$P(^SRO(136,ECD0,3,ECXJ,0),U),ECXMOD=""
        .S ECPT=$P(^(0),"^"),ECXCMOD=""
        .K ARR,ERR
        .D FIELD^DID(130.16,4,,"LABEL","ARR","ERR") I $D(ARR("LABEL")) D
        ..K ARR,ERR
        ..D FIELD^DID(130.16,4,,"GLOBAL SUBSCRIPT LOCATION","ARR","ERR")
        ..Q:$D(ERR("DIERR"))
        ..S SUB=$P(ARR("GLOBAL SUBSCRIPT LOCATION"),";"),MOD=0
        ..F  S MOD=$O(^SRF(ECD0,13,ECXJ,SUB,MOD)) Q:MOD'>0  S ECXCMOD=ECXCMOD_$P(^(MOD,0),U)_";"
        .S ECXCPT=$$CPT^ECXUTL3(ECPT,ECXCMOD)
        .S ECODE0="S"_U   ;_ECPT
        .D FILE^ECXSURG1
        ;get prostheses
        ;ecode0=i^^^^^^prosthesis^old qty field (null)
        S ECXJ=0
        F  S ECXJ=$O(^SRF(ECD0,1,ECXJ)) Q:'ECXJ  I $D(^(ECXJ,0)) D
        .S ECXP=+^SRF(ECD0,1,ECXJ,0),ECXQ=$P($G(^(1)),U,2) S:'ECXQ ECXQ=1
        .S ECODE0="I"_U_U_U_U_U_U_ECXP_U_U
        .D FILE^ECXSURG1
        Q
        ;
        ;
TIME    ; given date/time get increment
        ;A1=later, A2=earlier, TIME=difference
        N CON,TIMEDIF
        S CON=$P($G(^SRF(ECD0,"CON")),U)
        ;
        ;-Get time diff (in secs) & set to .5 if < 7.5 minutes (rounds to 1)
        S TIMEDIF=$$FMDIFF^XLFDT(A1,A2,2)/900
        S TIMEDIF=$S(TIMEDIF>0&(TIMEDIF<.5):.5,1:TIMEDIF)
        I 'CON D
        .S TIME=$J($TR($J(TIMEDIF,4,0)," "),2,1)
        .S:TIME>"99.0" TIME="99.0"
        I CON D
        .S TIME=$J(($TR($J(TIMEDIF,4,0)," ")/2),2,1)
        .S:TIME>"99.5" TIME="99.5"
        S:TIME<0 TIME="###"
        Q
        ;
SETUP   ;Set required input for ECXTRAC
        S ECHEAD="SUR"
        D ECXDEF^ECXUTL2(ECHEAD,.ECPACK,.ECGRP,.ECFILE,.ECRTN,.ECPIECE,.ECVER)
        Q
        ;
QUE     ; entry point for the background requeuing handled by ECXTAUTO
        D SETUP,QUE^ECXTAUTO,^ECXKILL Q
