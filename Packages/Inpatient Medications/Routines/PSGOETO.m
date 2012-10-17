PSGOETO ;BIR/CML3-TRANSCRIBE ORDERS ;25 Feb 99 / 1:17 PM
        ;;5.0; INPATIENT MEDICATIONS ;**3,13,25,31,33,50,68,58,85,105,90,117,110,111,112,161**;16 DEC 97;Build 28
        ;
        ; Reference to ^PS(51.2 is supported by DBIA #2178.
        ; Reference to ^PS(55 is supported by DBIA #2191.
        ; Reference to ^PS(59.7 is supported by DBIA #2181.
        ; Reference to ^PSUHL is supported by DBIA 4803.
        ;
        W:'$D(PSGOEE)&'$D(PSGOES) !!,"...transcribing this ",$S($D(PSGOES):"",'PSGOEAV:"non-verified ",1:"active "),"order..." S PSGOETOF=1 S:PSGSM="" PSGSM=0
        I PSGPR'=PSGOEPR D:'$D(^PS(55,PSGP,0)) ENSET0^PSGNE3(PSGP) S $P(^PS(55,PSGP,5.1),U,2)=PSGPR,PSGOEPR=PSGPR
        K ND4,DA D ENGNN:'PSGOEAV,ENGNA:PSGOEAV S PSGDT=$$DATE^PSJUTL2() I $S($D(ORACTION):0,$G(PSGOEE)="R":1,+$G(^PS(55,PSGP,5.1))>PSGDT:0,1:$G(PSGOEE)'="E") D ENWALL^PSGNE3(PSGNESD,PSGNEFD,PSGP)
        I $D(^PS(51.2,+PSGMR,0)),$P(^(0),U,3)]"" S PSGMRN=$P(^(0),U,3)
        S ND=DA_U_PSGPR_U_PSGMR_"^U^"_PSGSM_U_PSGHSM_U_PSGST_"^^"_$S(PSGOEAV:"A",1:"N")_"^^^^^"_PSGDT_U_PSGP_U_PSGDT S:PSGNEDFD $P(ND,U,$P(PSGNEDFD,U)["L"+10)=+PSGNEDFD
        S:$D(PSGOEE) $P(ND,U,24,25)=PSGOEE_U_PSGOORD S:'PSGOEAV $P(ND,U,18)=DA S ND2=PSGSCH_U_$S(+PSGNESD=PSGNESD:+PSGNESD,1:"")_"^^"_+PSGNEFD_U_PSGS0Y_U_PSGS0XT_"^^^^"_+PSJPWD
        ; naked reference below refers to ^PS(55,PSGP,0)
        I PSGOEAV S F=^PS(55,PSGP,0) I $P(F,"^",7)="" S $P(F,"^",7)=$P($P(ND,"^",16),"."),$P(F,"^",8)="A",^(0)=F D LOGDFN^PSUHL(PSGP)
        S $P(ND4,U,7)=DUZ I PSGOEAV,PSJSYSU D
        .S $P(ND4,U,PSJSYSU,PSJSYSU+1)=DUZ_U_PSGDT,$P(ND4,U,+PSJSYSU=1+9)=1,$P(ND4,U,+PSJSYSU=3+9)=0
        .S $P(ND4,U,9,10)=+$P(ND4,U,9)_U_+$P(ND4,U,10)
        .I '$P(ND4,U,9) S ^PS(55,"APV",PSGP,DA)=""
        .I '$P(ND4,U,10) S ^PS(55,"NPV",PSGP,DA)=""
        .I $P(ND4,U,9) K ^PS(55,"APV",PSGP,DA)
        .I $P(ND4,U,10) K ^PS(55,"NPV",PSGP,DA)
        S F="^PS("_$S(PSGOEAV:"55,"_PSGP_",5",1:53.1)_","_DA_",",@(F_"0)")=ND
        ;naked reference below refers to full reference inside indirection @(F_".2)") for either file 53.1 or 55
        S @(F_".2)")=PSGPDRG_U_PSGDO_U_PSJNOO S:$G(PSJDOSE("DO"))]"" $P(^(.2),U,5,6)=$P(PSJDOSE("DO"),U,1,2)
        I '$D(PSJDOSE("DO")),$D(PSGORD),PSGPDRG=$P(@("^PS("_$S(PSGORD["U":"55,"_PSGP_",5",1:53.1)_","_+PSGORD_",.2)"),U) S $P(@(F_".2)"),U,5,6)=$P(@("^PS("_$S(PSGORD["U":"55,"_PSGP_",5",1:53.1)_","_+PSGORD_",.2)"),U,5,6)
        ;naked reference below refers to full reference inside indirection @(F_"2)") for either file 53.1 or 55
        S @(F_"2)")=$S(PSGOEAV:ND2,1:$P(ND2,"^",1,6)),^(4)=ND4 S:PSGSI]"" ^(6)=PSGSI
        S (C,X)=0 F  S X=$O(^PS(53.45,PSJSYSP,2,X)) Q:'X  S D=$G(^(X,0)) I D,$S('$P(D,U,3):1,1:$P(D,U,3)>DT) S C=C+1,@(F_"1,"_C_",0)")=$P(D,U,1,2),@(F_"1,""B"","_+D_","_C_")")=""
        S:C @(F_"1,0)")=U_$S(PSGOEAV:55.07,1:53.11)_"P^"_C_U_C
        S (C,Q)=0 F  S Q=$O(^PS(53.45,PSJSYSP,1,Q)) Q:'Q  S X=$G(^(Q,0)) S:X]"" C=C+1,@(F_"3,"_C_",0)")=X
        S:C @(F_"3,0)")=U_$S(PSGOEAV:55.08,1:53.12)_U_C_U_C
        I $P(ND,U,24)="R" S %X="^PS(55,"_PSGP_",5,"_+PSGORD_",12,",%Y=F_"12," D %XY^%RCR
        W "." D CRN:'PSGOEAV,CRA:PSGOEAV
        ; don't send message to CPRS if from Order Set and autoverify turned off
        S PSGORD=DA_$S(PSGOEAV:"U",1:"P")
        I $G(PSGOORD),$D(PSGOEE) N CLINAPPT S CLINAPPT=$S(PSGOORD["U":$G(^PS(55,PSGP,5,+PSGOORD,8)),PSGOORD["P":$G(^PS(53.1,+PSGOORD,"DSS")),1:"") I CLINAPPT D
        .N DIE,DA,DR
        .I PSGORD["U" S DIE="^PS(55,"_PSGP_",5,",DA=+PSGORD,DA(1)=PSGP,DR="130////"_+CLINAPPT_";" S:$P(CLINAPPT,"^",2) DR=DR_"131////"_$P(CLINAPPT,"^",2)_";"
        .I PSGORD["P" S DIE="^PS(53.1,",DA=+PSGORD,DR="113////"_+CLINAPPT_";" S:$P(CLINAPPT,"^",2) DR=DR_"126////"_$P(CLINAPPT,"^",2)_";"
        .I $G(DR) D ^DIE
        D:('$D(PSGOES))!(($D(PSGOES)&(PSGOEAV))) ORSET^PSGOETO1
        I $D(PSGOES),'$D(PSGOESON) N PSGOESON S PSGOESON=PSGORD D DISACTIO^PSJOE(DFN,PSGORD,0) D:PSGORD["U"&(PSGOESON=PSGORD)&($P(@(PSGOEEWF_"0)"),"^",9)'="D") EN^PSGPEN(PSGORD) G OUT
        D DONE S PSGCANFL="" I '$D(PSGOEE) S PSJLM=1,PSGOEEF=0 D GETUD^PSJLMGUD(PSGP,PSGORD),ENSFE^PSGOEE0(PSGP,PSGORD),EN^VALM("PSJ LM ACCEPT") I PSGCANFL=1 G OUT
        I $D(PSJSYSO) S PSGPOSA="W",PSGPOSD=PSGDT D ENPOS^PSGVDS
        S DA=+PSGORD,X=$P(PSGORD,DA,2) I PSJSYSL,$S(PSGOEAV:1,1:PSJSYSL<3),$S("AOU"[X:'$D(^PS(55,PSGP,5,+PSGORD,7)),1:'$D(^PS(53.1,+PSGORD,7))) D
        .; naked ref below is from line above, ^PS(53.1,+PSGORD,7)
        .S $P(^(7),U,1,2)=PSGDT_"^N"_$G(PSGOEE),PSGUOW=DUZ,PSGTOL=2,PSGTOO=$S("AOU"[X:1,1:2) D ENL^PSGVDS
OUT     ;
        K PSGOETOF
DONE    ;
        I PSGOEAV L -^PS(55,PSGP,5,+PSGORD)
        I 'PSGOEAV L -^PS(53.1,+PSGORD)
        K C,D,ND,ND2,ND4,PSGDO,PSGDRG,PSGDRGN,PSGFOK,PSGHSM,PSGMR,PSGMRN,PSGNEDFD,PSGNEFD,PSGNESD,PSGPDRG,PSGPDRGN,PSGSI,PSGSTN,PSJDOSE
        Q
CRA     ;
        S:PSGPDRG ^PS(55,PSGP,5,"C",PSGPDRG,DA)="" S (^PS(55,"AUE",PSGP,DA),^PS(55,PSGP,5,"AU",PSGST,+PSGNEFD,DA),^PS(55,PSGP,5,"AUS",+PSGNEFD,DA))="",^PS(55,"AUD",+$P(ND2,"^",4),PSGP,DA)="",^PS(55,"AUDS",+$P(ND2,"^",2),PSGP,DA)=""
        I $$PATCH^XPDUTL("PXRM*1.5*12") S X(1)=+PSGNESD,X(2)=+PSGNEFD,DA(1)=PSGP D SPSPA^PSJXRFS(.X,.DA,"UD")
        S DA(1)=PSGP K DIK S DIK="^PS(55,"_DA(1)_",5,",DIK(1)=125 D EN1^DIK K DIK
        K PSGALO,PSGALR S DA(1)=PSGP,PSGAL("C")=PSJSYSU*10+$S('$D(PSGOEE):22500,PSGOEE="E":22600,1:22700) D ^PSGAL5 Q
CRN     ;
        S (^PS(53.1,"AC",PSGP,DA),^PS(53.1,"AS","N",PSGP,DA),^PS(53.1,"B",DA,DA),^PS(53.1,"C",PSGP,DA))="" S:PSGPDRG (^PS(53.1,"AOD",PSGP,PSGPDRG,DA),^PS(53.1,"D",PSGPDRG,DA))="" Q
ENGNA   ;
        F  L +^PS(55,PSGP,5,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) S:'$D(^PS(55,PSGP,0)) ^(0)=PSGP,^PS(55,"B",PSGP,PSGP)="" S ND=$S($D(^PS(55,PSGP,5,0)):^(0),1:"^55.06IA") Q
        N PSGLCK S PSGLCK=0
        F DA=$P(ND,U,3)+1:1 W "." I '$D(^PS(55,PSGP,5,DA)),'$D(^PS(55,PSGP,5,"B",DA)) D  I PSGLCK S ^PS(55,PSGP,5,DA,0)=DA,^PS(55,PSGP,5,"B",DA,DA)="",$P(ND,U,3)=DA,$P(ND,U,4)=$P(ND,U,4)+1,^PS(55,PSGP,5,0)=ND Q
        . L +^PS(55,PSGP,5,DA):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  S PSGLCK=1
        L -^PS(55,PSGP,5,0) Q
ENGNN   ;
        N ND F  L +^PS(59.7,1,25):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  S DA=+$G(^PS(59.7,1,25)) Q
        F DA=DA+1:1 I '$D(^PS(53.1,DA)),'$D(^PS(53.1,"B",DA)) L +^PS(53.1,DA):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  S ^PS(59.7,1,25)=DA,^PS(53.1,DA,0)=DA,^PS(53.1,"B",DA,DA)="" Q
        F  L +^PS(53.1,0):$S($G(DILOCKTM)>0:DILOCKTM,1:3) I  S ND=$G(^PS(53.1,0)),$P(ND,U,3)=DA,$P(ND,U,4)=$P(ND,U,4)+1,^(0)=ND Q
        L -^PS(59.7,1,25),-^PS(53.1,0)
        Q
