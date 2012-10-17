ECXQSR  ;ALB/JAP,BIR/PTD-DSS QUASAR Extract ; 2/5/10 6:50am
        ;;3.0;DSS EXTRACTS;**11,8,13,26,24,34,33,35,39,43,46,49,64,71,84,92,106,105,120,124,127**;Dec 22, 1997;Build 36
BEG     ;entry point from option
        I '$O(^ACK(509850.8,0)) W !,"You must be using the Quality Audiology & Speech Pathology",!,"Audit & Review (QUASAR) software to run this extract.",!! Q
        I '$D(^ACK(509850.8,1,"DSS")) W !,"Linkage has not been established between QUASAR and the DSS UNIT file (#724).",!! Q
        I '$O(^ACK(509850.6,0)) W !,"There is no data in the A&SP CLINIC VISIT file (#509850.6).",!! Q
        D SETUP I ECFILE="" Q
        D ^ECXTRAC,^ECXKILL
        Q
START   ;entry point from tasked job
        N ERR,ECXQDT,ECXNPRFI
        S QFLG=0,ECED=ECED+.9,ECD=ECSD1,ECXQV=""
        D QINST I $D(ERR) Q
        S ECL=+^ACK(509850.8,1,0),ECLINK=^ACK(509850.8,1,"DSS")
        F  S ECD=$O(^ACK(509850.6,"B",ECD)),ECDA=0 Q:(ECD>ECED)!('ECD)!(QFLG)  D
        .I +ECXQV=3,ECD<ECXQDT S ECXQV=2.0
        .F  S ECDA=$O(^ACK(509850.6,"B",ECD,ECDA)) Q:'ECDA  D UPDATE Q:QFLG
        Q
QINST   ;Get installed information for QUASAR
        N ARR,IENS,QVIEN,INTIEN
        S ECXQDT=""
        D FILE^DID(509850.6,,"VERSION","ARR","ERR")
        S ECXQV=$G(ARR("VERSION")) I +ECXQV=0 S ERR=1 Q
        S QVIEN=$$FIND1^DIC(9.4,"","X","QUASAR") I +QVIEN<1 S ERR=1 Q
        S IENS=","_QVIEN_","
        S INTIEN=$$FIND1^DIC(9.49,IENS,"X",ECXQV) I +INTIEN<1 S ERR=1 Q
        S IENS=INTIEN_","_QVIEN,ECXQDT=$$GET1^DIQ(9.49,IENS,2,"I")
        Q
UPDATE  ;create record for each unique CPT code for clinic visit 
        N ARY,ECZNODE,CPT,LOC,MOD,STR,VOL,XX,ECTP,ECV
        Q:'$D(^ACK(509850.6,ECDA,0))
        S ECZNODE=^ACK(509850.6,ECDA,0),EC2NODE=$G(^ACK(509850.6,ECDA,2))
        S ECDT=$P(ECZNODE,U),ECDAY=$$ECXDATE^ECXUTL(ECDT,ECXYM)
        S ECTIME=$$ECXTIME^ECXUTL(ECDT) S:$P(ECDT,".",2)="" ECTIME="000000"
        S ECXDFN=$P(ECZNODE,U,2)
        Q:'$$PATDEM^ECXUTL2(ECXDFN,ECD,"1;3;5")
        S OK=$$PAT^ECXUTL3(ECXDFN,ECDT,"1;5",.ECXPAT)
        I 'OK S ECXERR=1 K ECXPAT Q
        ;OEF/OIF data
        S ECXOEF=ECXPAT("ECXOEF")
        S ECXOEFDT=ECXPAT("ECXOEFDT")
        ;
        S ECHL="",ECXDIV=$P($G(^ACK(509850.6,ECDA,5)),U),ECSTOP=$P(EC2NODE,U)
        S ECXPDIV=$$GETDIV^ECXDEPT(ECXDIV)  ; Get Production Division
        Q:ECSTOP=""
        S (ECHLS,ECHL2S)="000",ECAC=$P($G(ECZNODE),U,6)
        I ECAC D
        .S ECHL=+$P($G(^SC(ECAC,0)),U,7),ECHL2=+$P($G(^(0)),U,18) I ECHL D
        ..S ECHLS=$P($G(^DIC(40.7,+ECHL,0)),U,2),ECHL2S=$P($G(^DIC(40.7,+ECHL2,0)),U,2)
        ..S ECHLS=$$RJ^XLFSTR(ECHLS,3,0),ECHL2S=$$RJ^XLFSTR(ECHL2S,3,0)
        S ECDSS=ECHLS_ECHL2S
        I ECXLOGIC>2003 D
        .I "^18^23^24^41^65^94^108^"[("^"_ECXTS_"^") S ECDSS=$$TSMAP^ECXUTL4(ECXTS)
        S ECDU=$S(ECSTOP["A":$P(ECLINK,U),ECSTOP["S":$P(ECLINK,U,2),1:"")
        Q:'ECDU
        S ECDSSU=$G(^ECD(ECDU,0)),ECCS=+$P(ECDSSU,U,4),(ECO,ECM)=+$P(ECDSSU,U,3),ECXDSSD=$E($P(ECDSSU,U,5),1,10)
        Q:'$O(^ACK(509850.6,ECDA,3,0))
        ;Create local array of procedure codes and # of times each procedure
        ; was performed.
        F I=1:1:4 S @("ECXICD9"_I)=""
        S (ECDIA,ECXPPC,ECXPRV1,ECXPRV2,ECXPRV3,ECUN1NPI)=""
        ;if QUASAR v2
        I +ECXQV=2 D
        .S ECXPRV1=$P(EC2NODE,U,7),ECXPRV2=$P(EC2NODE,U,3),ECXPRV3=$P(EC2NODE,U,5),ECPN=0
        .S ECPR1NPI=$$NPI^XUSNPI("Individual_ID",ECXPRV1,ECD)
        .S:+ECPR1NPI'>0 ECPR1NPI="" S ECPR1NPI=$P(ECPR1NPI,U)
        .S ECPR2NPI=$$NPI^XUSNPI("Individual_ID",ECXPRV2,ECD)
        .S:+ECPR2NPI'>0 ECPR2NPI="" S ECPR2NPI=$P(ECPR2NPI,U)
        .S ECPR3NPI=$$NPI^XUSNPI("Individual_ID",ECXPRV3,ECD)
        .S:+ECPR3NPI'>0 ECPR3NPI="" S ECPR3NPI=$P(ECPR3NPI,U)
        .F  S ECPN=$O(^ACK(509850.6,ECDA,3,ECPN)) Q:'ECPN  D
        ..S XX=^ACK(509850.6,ECDA,3,ECPN,0),XX=$P(XX,U),XX=$P($G(^ACK(509850.4,XX,0)),U),ECXCPT=$E($$CPT^ECXUTL3(XX),1,5)
        ..I ECXCPT]"" D
        ...I '$D(LOC(ECXCPT)) S LOC(ECXCPT)=0_U_ECXPRV1
        ...S $P(LOC(ECXCPT),U)=$P(LOC(ECXCPT),U)+1
        .S ECIEN=$O(^ACK(509850.6,ECDA,1,0)),ECDIA=$P($G(^ICD9(+$G(^ACK(509850.6,ECDA,1,ECIEN,0)),0)),U)
        .F I=1:1:4 S ECIEN=$O(^ACK(509850.6,ECDA,1,ECIEN)) Q:'+ECIEN  D
        ..S @("ECXICD9"_I)=$P($G(^ICD9(+$P(^ACK(509850.6,ECDA,1,ECIEN,0),U),0)),U)
        ;if QUASAR v3
        I +ECXQV=3 D
        .N CPT,DIA,I,J,MOD,MOD1,P,STR,VOL,ECTP,ARY,ECP,ECPN
        .S ECXPRV2=$G(^ACK(509850.6,ECDA,2.7,1,0)),ECXPRV3=$G(^ACK(509850.6,ECDA,2.7,2,0))
        .I $G(ECXPRV2) S ECXPRV2=$$CONVERT1^ACKQUTL4(ECXPRV2)
        .I $G(ECXPRV3) S ECXPRV3=$$CONVERT1^ACKQUTL4(ECXPRV3)
        .S ECPN=0 F  S ECPN=$O(^ACK(509850.6,ECDA,3,ECPN)) Q:'ECPN  D
        ..S CPT=^ACK(509850.6,ECDA,3,ECPN,0),ECXCPT=$P(CPT,U),ECTP=+$P(CPT,U,5),ECV=1,ECP=""
        ..Q:ECXCPT=""
        ..I ECTP D
        ...S CPT=$G(^ACK(509850.6,ECDA,7,ECTP,0)),ECP=$P(CPT,U)
        ...S ECP=$S(ECP<90000:$P($G(^EC(725,+ECP,0)),U,2)_"N",1:$P($G(^EC(725,+ECP,0)),U,2)_"L")
        ...S VOL=+$P(CPT,U,2),ECXPRV1=$P(CPT,U,3)
        ..I 'ECTP S VOL=+$P(CPT,U,3),ECXPRV1=$P(CPT,U,4)
        ..I $G(ECXPRV1) S ECXPRV1=$$CONVERT1^ACKQUTL4(ECXPRV1)
        ..S ECXCPT=$E($$CPT^ECXUTL3(ECXCPT),1,5),ECXMOD="",MOD=0
        ..F  S MOD=$O(^ACK(509850.6,ECDA,3,ECPN,1,MOD)) Q:'MOD  D
        ...S MOD1=+^ACK(509850.6,ECDA,3,ECPN,1,MOD,0) D:MOD1
        ....S ECXMOD=ECXMOD_MOD1_";"
        ..F I=1:1:$L(ECXMOD,";") I $G(ARY(ECXCPT))'[$P(ECXMOD,";",I) D
        ...S ARY(ECXCPT)=$G(ARY(ECXCPT))_$P(ECXMOD,";",I)_";"
        ..S:VOL ECV=VOL
        ..S ECV=ECV+$G(LOC(ECXCPT)),LOC(ECXCPT)=ECV_U_ECXPRV1_U_ECP
        .S ECIEN=0 F  S ECIEN=$O(^ACK(509850.6,ECDA,1,ECIEN)) Q:'ECIEN  D
        ..S DIA=^ACK(509850.6,ECDA,1,ECIEN,0),P=$P(DIA,U,2),P=$S(P=1:"P",1:"S")
        ..S CNT=$G(STR(P))+1,STR(P,CNT)=$P($G(^ICD9(+DIA,0)),U),STR(P)=CNT
        .S ECDIA=$G(STR("P",1))
        .F I=1:1:4 Q:'$D(STR("P",I+1))  S @("ECXICD9"_I)=STR("P",I)
        .S:ECDIA="" ECDIA=$G(STR("S",1)),I=2
        .F J=I:1:4 Q:'$D(STR("S",J))  S @("ECXICD9"_J)=STR("S",J)
        Q:('$D(LOC))!('$O(^ACK(509850.6,ECDA,1,0)))
        ;- Ord Div, Contract St/End Dates, Contract Type placeholders for FY2002
        S (ECXODIV,ECXCSDT,ECXCEDT,ECXCTYP)=""
        ;set up Provider Person class
        S (ECXCPT,ECXPPC1,ECXPPC2,ECXPPC3)=""
        S:ECXPRV2'="" ECXPPC2=$$PRVCLASS^ECXUTL(ECXPRV2,ECD)
        S:ECXPRV3'="" ECXPPC3=$$PRVCLASS^ECXUTL(ECXPRV3,ECD)
        N DA,DIC,DIK,DR,FILEN,DIQ,XVAR,II,DI
        F II=2,3 S XVAR="ECXPRV"_II I @XVAR'="" D
        .S @XVAR=2_@XVAR
        ; -Observation Patient Indicator (yes/no)
        S ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXTS,ECDSS)
        ; -CNH status (YES/NO)
        S ECXCNH=$$CNHSTAT^ECXUTL4(ECXDFN)
        ;get encounter classification
        S (ECXAO,ECXECE,ECXIR,ECXMIL,ECXHNC,ECXSHAD)="",ECXVISIT=$P($G(^ACK(509850.6,ECDA,6)),U,3)
        I ECXVISIT'="" D
        .D VISIT^ECXSCX1(ECXDFN,ECXVISIT,.ECXVIST,.ECXERR) I ECXERR K ECXERR Q
        .S ECXAO=$G(ECXVIST("AO")),ECXECE=$G(ECXVIST("PGE")),ECXSHAD=$G(ECXVIST("SHAD"))
        .S ECXIR=$G(ECXVIST("IR")),ECXMIL=$G(ECXVIST("MST")),ECXHNC=$G(ECXVIST("HNC"))
        ; -Head and Neck Cancer Indicator
        S ECXHNCI=$$HNCI^ECXUTL4(ECXDFN)
        ; -PROJ 112/SHAD Indicator
        S ECXSHADI=$$SHAD^ECXUTL4(ECXDFN)
        ; ******* - PATCH 127, ADD PATCAT CODE - ********
        S ECXPATCAT=$$PATCAT^ECXUTL(ECXDFN)
        ;get enrollment data (category, status and priority)
        I $$ENROLLM^ECXUTL2(ECXDFN)
        ; -Get national patient record flag Indicator if exist
        D NPRF^ECXUTL5
        ; -If no encounter number don't file record
        S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADMDT,ECDT,ECXTS,ECXOBS,ECHEAD,ECDSS,)
        Q:ECXENC=""
        ;Loop through array of unique procedures. Create record in ECODE.
        S CPT="" F  S CPT=$O(LOC(CPT)) Q:CPT=""  D
        .S ECV=+$P(LOC(CPT),U),ECXCPT=$$CPT^ECXUTL3(CPT,$G(ARY(CPT)),ECV)
        .S ECXPRV1=$P(LOC(CPT),U,2)
        .S:ECXPRV1'="" ECXPPC1=$$PRVCLASS^ECXUTL(ECXPRV1,ECD),ECXPRV1=2_ECXPRV1
        .S ECP=$P(LOC(CPT),U,3) I ECP="" S ECP=$$CPT^ECXUTL3(CPT,"",ECV)
        .D FILE^ECXQSR1
        K CPT,LOC
        Q
SETUP   ;Set required input for ECXTRAC
        S ECHEAD="ECQ"
        D ECXDEF^ECXUTL2(ECHEAD,.ECPACK,.ECGRP,.ECFILE,.ECRTN,.ECPIECE,.ECVER)
        Q
QUE     ;Entry point for the background requeuing handled by ECXTAUTO.
        D SETUP,QUE^ECXTAUTO,^ECXKILL Q
