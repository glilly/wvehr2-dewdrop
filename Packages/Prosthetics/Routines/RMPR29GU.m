RMPR29GU        ;HOIFO/SPS-CREATE 2529-3 GUI [ 10/17/05  8:55 AM ]
        ;;3.0;PROSTHETICS;**75,144**;Feb 09, 1996;Build 17
        ;
A1(RMPRDA,RMPRSITE,RMPR668,RMPRPTR)     ;
        D IN
        Q
CR(RESULTS,RMPRDA,RMPRSITE,RMPR668,RMPRPTR)     ;CREATE WORK ORDER
IN      D INF^RMPRSIT
        S SCR=$P(^RMPR(664.1,RMPRDA,0),U,11),RMERR=0
        K RMPRTMP I $P(^RMPR(664.1,RMPRDA,0),U,15)'=RMPR("STA") S RMPRTMP=1
        N DIC,Y,DIR S RMPRWO=1 D FQ^RMPRDT Q:'$D(RMPRFY)!('$D(RMPRQTR))  S:'$D(RMPRTMP) RMPRWO=$$STAN^RMPR31U(RMPR("STA"))_"-"_RMPRFY_"-"_RMPRQTR I $D(RMPRTMP) D
        .S RMPRWO=$$STAN^RMPR31U($P(^RMPR(664.1,RMPRDA,0),U,15))_"T-"_RMPRFY_"-"_RMPRQTR
        I '$D(^RMPR(669.1,"B",RMPRWO)) K DD,D0 S DIC="^RMPR(669.1,",DLAYGO=669.1,DIC(0)="LZ",X=RMPRWO D FILE^DICN K DLAYGO,D0
        S RDA=$O(^RMPR(669.1,"B",RMPRWO,0)) Q:'RDA
        L +^RMPR(669.1,RDA,0):1 I '$T S RESULTS(0)="1^Someone is editing this record!" G EXIT
        S RN=$P(^RMPR(669.1,RDA,0),U,2)+1 F I=1:1:4-$L(RN) S RN="0"_RN
        S RMPRWO=RMPRWO_"-"_SCR_"-"_RN
        S $P(^RMPR(669.1,RDA,0),U,2)=RN L -^RMPR(669.1,RDA,0)
        S $P(^RMPR(664.1,RMPRDA,0),U,13)=$G(RMPRWO)
        ;set no admin count/no lab count
        I $P(^RMPR(664.1,RMPRDA,0),U,15)=RMPR("STA")&($P(^(0),U,4)'=RMPR("STA")) S $P(^(0),U,23)=1
        I $P(^RMPR(664.1,RMPRDA,0),U,15)'=RMPR("STA") S $P(^(0),U,20)=1 S:$D(RMPR25) $P(^RMPR(664.1,RMPRDA,0),U,23)=1 S DIE="^RMPR(664.1,",DA=RMPRDA,DR="16///^S X=""PC""" D ^DIE
        I '$P(^RMPR(664.1,RMPRDA,0),U,20) S DIE="^RMPR(664.1,",DA=RMPRDA,DR="16///^S X=""P""" D ^DIE
        S RMDAT(664.1,RMPRDA_",",13)=DUZ
        S RMDAT(664.1,RMPRDA_",",17)=DT
        S RMDAT(664.1,RMPRDA_",",.05)=RMPR668
        D FILE^DIE("","RMDAT","RMERROR")
        I $D(RMERROR) S RMERR=1 D ERR G EXIT
        D IN5^VADPT S VAINDT=$P($G(VAIP(3)),U) D INP^VADPT
        I VAIN(1) S DR="12//^S X=$P(VAIN(4),U,2)" D ^DIE
        S RMSOP=$S($P(^RMPR(664.1,RMPRDA,0),U,11)="O":11,$P(^(0),U,11)="E":11,$P(^(0),U,11)="R":11,$P(^(0),U,11)="W":11,1:"")
        I +RMSOP>0 D  G:RMERR=1 EXIT
        .L +^RMPR(668,RMPR668):2
        .I $T=0 S RESULTS(0)="1^Someone else is Editing this entry!" S RMERR=1 Q
        .S RMDAT(668,RMPR668_",",9)=RMSOP
        .D FILE^DIE("","RMDAT","RMERROR")
        .L -^RMPR(668,RMPR668)
        .I $D(RMERROR) S RMERR=1 D ERR Q
        D ^RMPR29GA
        S RESULTS(0)=0_"^"_"Work Order Created:  "_RMPRWO
        ;ADD PRINT HERE.
        I RMPRPTR=0 D PRT^RMPR29R
        I +RMPRPTR D EN1^RMPR29R(RMPRPTR)
        Q
ERR     ;QUIT ON ERROR
        S RESULTS(0)="1^The following error has occured "_RMERROR
        Q
EXIT    ;
        K DA,DIE,DR,I,RDA,RMDAT,RMERR,RMERROR,RMPR,RMPR25,RMPRFY,RMPRQTR,RMPRWO
        K RMSOP,RN,SCR,VAIN,VAINDT,VAIP,X
        Q
