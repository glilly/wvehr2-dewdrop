PSGOD ;BIR/CML3-CREATES NEW ORDER FROM OLD ONE ;22 SEP 97 / 2:56 PM 
 ;;5.0; INPATIENT MEDICATIONS ;**67,58,111,133**;16 DEC 97
 ;
 ; Reference to ^PS(55 is supported by DBIA 2191.
 ;
 I $P($G(^PS(55,PSGP,5,+PSJORD,0)),"^",22) D  Q
 .W !,"This order is marked 'Not To Be Given' and can't be copied!" H 2
 F  W !!,"Do you want to copy this order" S %=2 D YN^DICN Q:%  D CH
 G:%'=1 DONE
 ;
 W !!,"...copying..." N OLDON
 N PSGPDRG
 S PSGOEPR=$P($G(^PS(55,PSGP,5.1)),"^",2),OLDON=PSGORD
 ;K PSGODN S F=$S((PSGORD["N")!(PSGORD["P"):"^PS(53.1,"_+PSGORD_",",1:"^PS(55,"_PSGP_",5,"_+PSGORD_",") F N=0,.2,2,6 S PSGODN(N)=$G(@(F_N_")"))
 K PSGODN S F=$S(PSGORD["P":"^PS(53.1,"_+PSGORD_",",1:"^PS(55,"_PSGP_",5,"_+PSGORD_",") F N=0,.2,2,6 S PSGODN(N)=$G(@(F_N_")"))
 S PSGPR=$P(PSGODN(0),"^",2),PSGMR=$P(PSGODN(0),"^",3),PSGSM=$P(PSGODN(0),"^",5),PSGHSM=$P(PSGODN(0),"^",6),PSGST=$P(PSGODN(0),"^",7)
 S PSGPDRG=+PSGODN(.2),PSGDO=$P(PSGODN(.2),"^",2)
 S PSGSI=PSGODN(6)
 ; The naked reference below refers to the full reference inside indirection to ^PS(55,PSGP,5,+PSGORD, or ^PS(55,PSGP,"IV",+PSGORD, or ^PS(53.1,+PSGORD
 S PSGODN(3)=0 F Q=0:0 S Q=$O(@(F_"3,"_Q_")")) Q:'Q  I $D(^(Q,0)) S PSGODN(3,Q)=^(0),PSGODN(3)=PSGODN(3)+1 S ^PS(53.45,PSJSYSP,1,Q,0)=^(0)
 ;S:PSGODN(12)>0 ^PS(53.45,PSJSYSP,4,0)="^53.4504" S:PSGODN(3)>0 ^PS(53.45,PSJSYSP,1,0)="^53.4501"
 S:PSGODN(3)>0 ^PS(53.45,PSJSYSP,1,0)="^53.4501"
 ; The naked reference below refers to the full reference inside indirection to ^PS(55,PSGP,5,+PSGORD, or ^PS(55,PSGP,"IV",+PSGORD, or ^PS(53.1,+PSGORD  
 S (PSGODN(1),Q)=0 F  S Q=$O(@(F_"1,"_Q_")")) Q:'Q  S ND=$G(^(Q,0)) I ND,'$P(ND,"^",3) S PSGODN(1)=PSGODN(1)+1,PSGODN(1,PSGODN(1))=$P(ND,"^",1,2) S ^PS(53.45,PSJSYSP,2,PSGODN(1),0)=^(0)
 S PSGS0Y=$P(PSGODN(2),"^",5),PSGS0XT=$P(PSGODN(2),"^",6),PSGNESD="",PSGSCH=$P(PSGODN(2),U)
 S PSGODF=1,PSGNEDFD=$P($$GTNEDFD^PSGOE7("U",+PSGPDRG),U)_"^^"_PSGST_"^"_PSGSCH
 W "." D ^PSGNE3
 K PSGEFN,PSGOEEF,PSGOEE,PSGOEOS S PSGEFN="1:13" F X=1:1:13 S PSGEFN(X)=""
 S PSGPDN=$$OINAME^PSJLMUTL(PSGPDRG),PSGOINST="",PSGSDN=$$ENDD^PSGMI(PSGNESD)_U_$$ENDTC^PSGMI(PSGNESD),PSGFDN=$$ENDD^PSGMI(PSGNEFD)_U_$$ENDTC^PSGMI(PSGNEFD)
 S PSGAT=PSGS0Y,PSGEBN=DUZ,PSGLIN=$$ENDD^PSGMI(PSGDT)_U_$$ENDTC^PSGMI(PSGDT),PSGEBN=$$ENNPN^PSGMI(DUZ),PSGSTAT=$S(PSGOEAV:"ACTIVE",1:"NON-VERIFIED")
 W "." D CHK^PSGOEV("^^"_PSGMR_"^^^^"_PSGST,PSGPDRG_U_PSGDO,PSGSCH_U_PSGNESD_"^^"_PSGNEFD)
 I $G(PSGSCH)]"" D
 .N X S X=PSGSCH N SWD,SDW,XABB,QX D ENOS^PSGS0 I $G(X)=""!$G(PSJNSS) S CHK=1 K PSJNSS Q
 .I $G(PSGAT)="",$G(PSGS0Y) S PSGAT=PSGS0Y
 .I $G(PSGAT),($G(PSGS0Y)="") S PSGS0Y=PSGAT
 .I $G(PSGS0XT)="D",$G(PSGS0Y)="" S CHK=1 D  K PSJNSS
 ..W ! K DIR S DIR(0)="FOA",DIR("A")="   WARNING - Admin times are required for DAY OF WEEK schedules    " D ^DIR K DIR
 S PSGSD=PSGNESD,PSGFD=PSGNEFD
 K PSJACEPT S VALMBCK="Q" D:$D(Y) EN^VALM("PSJU LM ACCEPT")
 I $G(PSJACEPT)=1 S VALMBCK="",PSJNOO=$$ENNOO^PSJUTL5("N")
 I '$G(PSJACEPT)!($G(PSJNOO)<0) W !!,"Order not copied." D PAUSE^VALM1 G ORIG
 S PSGNESD=PSGSD,PSGNEFD=PSGFD
 K PSGOEE D ^PSGOETO S PSJORD=PSGORD I PSGOEAV D
 .I '$D(PSGOEE),+PSJSYSU=3 D EN^PSGPEN(PSGORD)
 D GETUD^PSJLMGUD(PSGP,PSGORD),ENSFE^PSGOEE0(PSGP,PSGORD),^PSGOE1,EN^VALM("PSJ LM UD ACTION")
 ;
 S PSGCANFL=0,(PSGORD,PSJORD)=OLDON W !!,"You are finished with the new order.",!,"The following ACTION prompt is for the original order."
 K DIR S DIR(0)="E" D ^DIR K DIR
ORIG ;Redisplay original order
 D GETUD^PSJLMGUD(PSGP,OLDON),INIT^PSJLMUDE(PSGP,OLDON)
DONE ;
 K %,%H,%I,DA,F,N,PSGODN,PSGODF,PSGS0XT,PSGS0Y,PSGNESD,PSGTOL,PSGTOO,PSGUOW,X,Y,^PS(53.45,PSJSYSP,1),^PS(53.45,PSJSYSP,2)
 K PSGPR,PSGMR,PSGSM,PSGHSM,PSGST,PSGPDRG,PSGDO,PSGNEDFD,PSGSCH,PSGNEFD
 Q
 ;
CH ;
 W !!?2,"Answer 'YES' to have a new, non-verified order created for this patient,",!,"using the information from this order.  (The START and STOP dates will be",!,"recalculated.)  Enter 'NO' (or '^') to stop now." Q
 ;
WH ;
 W !!?2,"Answer 'YES' to take action on this new order.  Enter 'NO' (or '^') to return",!,"to the original order now." Q
