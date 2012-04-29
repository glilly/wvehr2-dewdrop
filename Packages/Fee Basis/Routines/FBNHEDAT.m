FBNHEDAT        ;AISC/GRR-ENTER/EDIT AUTHORIZATION ;02:07 PM  11 Apr 1990;
        ;;3.5;FEE BASIS;**103**;JAN 30, 1995;Build 19
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        D SITEP^FBAAUTL
RD1     S U="^" D GETVET^FBAAUTL1 G:DFN="" END
        S FBPROG="I $P(^(0),U,3)=7" D GETAUTH^FBAAUTL1 G RD1:'CNT!(FTP']"")!($D(DIRUT)) S (FBOLD,FBNEW,FBERR)=""
        K FBAUT,CNT S (DA(1),D0)=DFN,FBOLD=^FBAAA(DFN,1,FTP,0),DA=FTP,FBAAADA=DA,DIE="^FBAAA("_DFN_",1,",FBO=$P(FBOLD,"^"),(FB1,FBAA(2))=$P(FBOLD,"^",2)
        S FBPROG=7 D DATES^FBAAUTL2 S FBAA(1)=$S($G(FBBEGDT):FBBEGDT,1:FBO),FBAA(2)=$S($G(FBENDDT):FBENDDT,1:FB1)
DR      S DR=".01////^S X=FBAA(1);.02////^S X=FBAA(2)"
        ; fb*3.5*103  add REFERRING PROVIDER (161.01,104) to DR string
        S DR(1,161.01,1)="@2;.065;.07;.021;.08;S:X="""" Y=101;.085;S:X="""" Y=101;.086;101;104;.097" D ^DIE
        S FBNEW=$S('$D(DA):"",'$D(^FBAAA(DFN,1,DA,0)):"",1:^(0)) K DR
        I $D(Y)>0,FBNEW=""!(FBNEW=FBOLD) G RD1
        I FBNEW'=FBOLD,$P(FBNEW,"^")>$P(FBNEW,"^",2) S DR=".01////^S X=FBO;.02////^S X=FB1" D ^DIE K DR D ER G DR
        ;
        S FBAA78=FB7078 D ^FBNHEDA1 K FBAA78 I FBERR S DA(1)=DFN,DA=FTP,DIE="^FBAAA("_DA(1)_",1,",DR=".01////^S X=FBO;.02////^S X=FB1" D ^DIE G END
        ; fb*3.5*103  add the REFERRING PROVIDER (162.4,15) to the DR string; stuff with the value stored at 161.01,104
        S DIE="^FB7078(",DA=FB7078,FBAA78=DA,DR="5;6;15////^S X=$$GET1^DIQ(161.01,FBAAADA_"",""_DFN,104,""I"")" I 'DA W !!,*7,"No 7078 on file!",! G END
        D:FBOLD'=FBNEW CHANGED
GO      D ^DIE
        I $O(^FBAAA(DFN,1,FBAAADA,2,0))>0 K ^FB7078(FBAA78,1) S ^FB7078(FBAA78,1,0)=^FBAAA(DFN,1,FBAAADA,2,0) F Z=0:0 S Z=$O(^FBAAA(DFN,1,FBAAADA,2,Z)) Q:Z'>0  S ^FB7078(FBAA78,1,Z,0)=^FBAAA(DFN,1,FBAAADA,2,Z,0)
RD2     S DIR(0)="Y",DIR("A")="Want to Queue 7078 for printing",DIR("B")=$S(FBOLD=FBNEW:"No",1:"Yes") D ^DIR K DIR G:Y'>0 RD1
CHEKP78 S FBNUM=$P(FBSITE(1),"^",5),FBO=$P(FBSITE(1),"^",7),FBT=$P(FBSITE(1),"^",8) D FBO^FBCHP78 G END:$D(DIRUT) S IOP="Q",%ZIS("B")="",FB7078=FBAA78,FB("SITE")=$P(FBSITE(1),"^",3) W !
        S VAR="FB7078^FBNUM^FBO^FBT^FB(""SITE"")",VAL=FB7078_"^"_FBNUM_"^"_FBO_"^"_FBT_"^"_FB("SITE"),PGM="START^FBCHP78" W ! D ZIS^FBAAUTL
        ;
END     K D0,DA,FBAASKV,FBAADDYS,FBAALT,FBAAP79,FBAATT,FBNUM,FBDEV,FBO,FBT,FB7078,FBAA78,FBCOUNTY,FBDX,FBI,FBRR,FBVEN,FBTYPE,FBXX,I,J,K,PI,FBOLD,FBNEW,FBPSADF,FBAADA,FB1,FBERR,FBOUT,FBIFN,FBZ,FBBEGDT,FBENDDT,FBAUT
        K DIE,DIR,FBAAADA,FTP,PGM,VAL,VAR,X,Y,Z,DIC,A,FBAABDT,FBAAEDT,FBAAOUT,FBASSOC,FBLOC,FBPOV,FBPROG,FBPSA,FBPT,FBSITE,FBTT,PTYPE,T,ZZ,FB("SITE"),FBPOP,FBAA,FBBDT,FBTDAYS,HOLDX
        D END^FBNHEAU1
        D CLOSE^FBAAUTL
        Q
        ;
CHANGED S:$P(FBOLD,"^",1)'=$P(FBNEW,"^",1) DR="3////^S X=$P(FBNEW,U,1);"_DR
        S:$P(FBOLD,"^",2)'=$P(FBNEW,"^",2) DR="4////^S X=$P(FBNEW,U,2);"_DR
        Q
        ;
ER      W !,*7,"From Date cannot be greater than the To Date.",!
        Q
        ;
ER1     W !,*7,"This patient has movements after the authorization to date.  You must",!,"edit the patient's movements first.",!
        Q
