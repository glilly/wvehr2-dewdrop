PSOTPRX1        ;BIR/MHA-TPB medication procesing driver ;08/21/03
        ;;7.0;OUTPATIENT PHARMACY;**146,182,227,268,300**;DEC 1997;Build 4
        ;External reference ^PS(55 supported by DBIA 2228
        ;External reference ^DIC(31 supported by DBIA 658
        ;External reference EN2^GMRAPEM0 supported by DBIA 190
        Q  ;placed out of order by patch PSO*7*227
START   K PSOQFLG,PSOID,PSOFIN,PSOQUIT,PSODRUG S (PSOBCK,PSOERR)=1 D INIT
        W:'$D(PSOTPBFG) !!,"*** Transitional Pharmacy Benefit Flag Undefined - Quitting ***"
        G:PSORX("QFLG")!('$D(PSOTPBFG)) END
        D PT G:$G(PSORX("QFLG")) END D FULL^VALM1 I $G(NOPROC) K NOPROC G NX
        ;call to add bingo board data to file 52.11
        F SLPPL=0:0 S SLPPL=$O(RXRS(SLPPL)) Q:'SLPPL  D
        .I $P($G(^PSRX(SLPPL,"STA")),"^")'=5 K RXRS(SLPPL) Q
        .S RXREC=SLPPL D WIND^PSOSUPOE I $G(PBINGRTE) D BBADD^PSOSUPOE S (BINGCRT,BINGRTE)=1 S:$G(PSOFROM)'="NEW" PSOFROM="REFILL"
        K TM,TM1 I $G(PSORX("PSOL",1))]""!($D(RXRS)) D ^PSORXL K PSORX S PSOPBM1=1
        G:$G(NOBG) NX
        S TM=$P(^TMP("PSOBB",$J),"^"),TM1=$P(^TMP("PSOBB",$J),"^",2) K ^TMP("PSOBB",$J)
        I $G(PSOFROM)="NEW"!($G(PSOFROM)="REFILL")!($G(PSOFROM)="PARTIAL") D:$D(BINGCRT)&($D(BINGRTE)&($D(DISGROUP))) ^PSOBING1 K BINGCRT,BINGRTE,BBRX,BBFLG
        I $G(PSOPBM),$G(PSOPBM1) S $P(^PS(55,PSODFN,0),"^",7)=PSOPBM,$P(^(0),"^",8)="A" K PSOPBM,PSOPBM1
NX      D:$G(PSODFN) EXFLAG^PSOTPCAN(PSODFN) D EOJ G START
END     Q
        ;---------------------------------------------------------
INIT    ;
        S PSORX("QFLG")=0
        D:'$D(PSOPAR) ^PSOLSET I '$D(PSOPAR) S PSORX("QFLG")=1
        I $P($G(PSOPAR),"^",2),'$D(^XUSEC("PSORPH",DUZ)) S PSORX("VERIFY")=1
INITX   Q
        ;
PT      ;
        K ^TMP("PSORXDC",$J),CLOZPAT,DIC,PSODFN,PSOPBM,PSOPBM1 S PSORX("QFLG")=0
        S DIC("S")="I '$P(^PS(52.91,+Y,0),""^"",3)!($P(^(0),""^"",3)>DT)"
        S DIC=52.91,DIC(0)="QEAM" D ^DIC K DIC,DA
        I +Y'>0 S PSORX("QFLG")=1 G PTX
OERR    N:$G(MEDP) PAT,POERR K PSOXFLG S (DFN,PSODFN)=+Y,PSORX("NAME")=$P($G(^DPT(PSODFN,0)),"^")
        K NPPROC,PSOQFLG,DIC,DR,DIQ S DIC=2,DA=PSODFN,DR=.351,DIQ="PSOPTPST" D EN^DIQ1 K DIC,DA,DR,DIQ D DEAD^PSOPTPST I $G(PSOQFLG) S NOPROC=1 Q
        I $P($G(^PS(55,PSODFN,"LAN")),"^") W !,"Patient has another language preference!",! H 3
        D NOW^%DTC S TM=$E(%,1,12),TM1=$P(TM,".",2) S ^TMP("PSOBB",$J)=TM_"^"_TM1
        S PSOQFLG=0,DIC="^PS(55,",DLAYGO=55
        I $G(PSOFIN) S SSN=$P(^DPT(PSODFN,0),"^",9) W !!?10,$C(7),PSORX("NAME")_" ("_$E(SSN,1,3)_"-"_$E(SSN,4,5)_"-"_$E(SSN,6,9)_")" K SSN
        K PSOPBM ; KILL SO THAT WON'T CARRY OVER PRIOR PATIENT'S VALUE
        I '$D(^PS(55,PSODFN,0)) D
        .S PSOPBM=$P(TM,".")
        .K DD,DO S DIC(0)="L",(DINUM,X)=PSODFN D FILE^DICN D:Y<1  K DIC,DA,DR,DD,DO
        ..S $P(^PS(55,PSODFN,0),"^")=PSODFN K DIK S DA=PSODFN,DIK="^PS(55,",DIK(1)=.01 D EN^DIK K DIK
        S PSOLOUD=1 D:$P($G(^PS(55,PSODFN,0)),"^",6)'=2 EN^PSOHLUP(PSODFN) K PSOLOUD
        I $G(^PS(55,PSODFN,"PS"))']"" D  I $G(POERR("QFLG")) G EOJ
        .L +^PS(55,PSODFN):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3) I '$T W $C(7),!!,"Patient Data is Being Edited by Another User!",! S POERR("QFLG")=1 S:$G(PSOFIN) PSOQUIT=1 Q
        .S PSOXFLG=1,SSN=$P(^DPT(PSODFN,0),"^",9) W !!?10,$C(7),PSORX("NAME")_" ("_$E(SSN,1,3)_"-"_$E(SSN,4,5)_"-"_$E(SSN,6,9)_")",! K SSN
        .S DIE=55,DR=".02;.03;.04;.05;1;D ELIG^PSORX1;@1;3//NON-VA;D CHK^PSOTPRX1;50;106;106.1"
        .S DA=PSODFN W !!,?5,">>PHARMACY PATIENT DATA<<",! D ^DIE L -^PS(55,PSODFN)
        .I $D(Y)!($D(DTOUT)) S PSOX=$G(^PS(55,PSODFN,"PS")) D:+$P(PSOX,"^")
        ..I $$UP^XLFSTR($P(^PS(53,$P(PSOX,"^"),0),"^"))'="NON-VA" S DR="3////@" D ^DIE
        S PSOX=$G(^PS(55,PSODFN,"PS"))
        I PSOX]"" S (X,PSORX("PATIENT STATUS"))=$$UP^XLFSTR($P(^PS(53,$P(PSOX,"^"),0),"^")) D:X'="NON-VA" WRN
        I PSOX']"" D  I $G(POERR("QFLG")) G EOJ
        .W !!,"Patient Status Required!!",! D ELIG
        .W ! K POERR("QFLG"),DIC,DR,DIE S DIC("B")="NON-VA"
        .S DIC("A")="PATIENT STATUS: ",DIC(0)="QEAMZ",DIC=53 D ^DIC K DIC
        .I $D(DIRUT)!(Y=-1) D  Q
        ..W $C(7),"Required Data!",! S POERR("QFLG")=1 S:$G(PSOFIN) PSOQUIT=1
        ..I $G(PSOPBM) D  K PSOPBM
        ...I $O(^PS(55,PSODFN,0))="" S DA=PSODFN,DIK="^PS(55," D ^DIK
        .I $$UP^XLFSTR($P(^PS(53,+Y,0),"^"))'="NON-VA" D MES S POERR("QFLG")=1 Q
        .S ^PS(55,PSODFN,"PS")=+Y,PSORX("PATIENT STATUS")=$P(^PS(53,+Y,0),"^")
        .D KV
        Q:$G(PSOFIN)
PROV    ;
        D ST^PSOTPPRV G:'$G(DA) NX
        S PSORX("PROVIDER NAME")=$P(^VA(200,DA,0),"^")
        D KV S DIR("A")="Do you want to enter allergies or adverse reactions at this time?"
        S DIR("B")="Y",DIR(0)="YN" W !! D ^DIR I Y W !
        D:Y EN2^GMRAPEM0
        I '$G(PSOPBM),'$P(^PS(55,PSODFN,0),"^",7),$P(^(0),"^",8)']"" S PSOPBM=$P(TM,".")
        D ^PSOBUILD
        F PT="GET","DEAD","INP","CNH","ADDRESS","COPAY" S RTN=PT_"^PSOPTPST" D @RTN Q:$G(POERR("DEAD"))!($G(PSOQFLG))
        I $G(POERR("DEAD")) S POERR("QFLG")=1 F II=0:0 S II=$O(^PS(52.41,"P",PSODFN,II)) D:$P($G(^PS(52.41,II,0)),"^",3)'="DC"&($P($G(^(0)),"^",3)'="DE") DC^PSOORFI2
        K PSOERR("DEAD"),II I $G(PSOQFLG) S POERR("QFLG")=1 G EOJ Q
        S (PAT,PSOXXDFN)=PSODFN,POERR=1 D ^PSOORUT2,BLD^PSOORUT1,EN^PSOLMUTL
        D CLEAR^VALM1 G:$G(PSOQUIT) PTX D EN^PSOLMAO
        S (DFN,PSODFN)=PSOXXDFN K DIE,DIC,DLAYGO,DR,DA,PSOX,PSORXED
PTX     ;
        K X,Y,^TMP("PS",$J),C,DEA,PRC,PSCNT,PSOACT,PSOCLC,PSOCS,PSOCT,PSOFINFL,PSOHD,PSOLST,PSOOPT,PSOPF,PSOX,PSOX1,PSOXXDFN,SIGOK,STP,STR
        Q
CHK     ;
        Q:'X
        I $$UP^XLFSTR($P(^PS(53,+X,0),"^"))'="NON-VA" D MES S Y="@1",$P(^PS(55,PSODFN,"PS"),"^")=""
        Q
MES     W $C(7),!!,"Invalid Selection - Only 'NON-VA' patient status can be processed through"
        W !,"this option. For all other statuses use the regular Patient Prescription"
        W !,"Processing option"
        Q
WRN     W $C(7),!!?15,"*** Current RX Patient Status is "_X_" ***"
        W !,"Only 'NON-VA' patient status should be processed through this option."
        W !,"For all other statuses use the regular Patient Prescription Processing option."
        Q
EOJ     ;
        K PSOERR,PSOMED,PSORX,PSOSD,PSODRUG,PSODFN,PSOOPT,PSOBILL,PSOIBQS,PSOCPAY,PSOPF,PSOPI,COMM,DGI,DGS,PT,PTDY,PTRF,RN,RTN,SERS,ST0,STAT,DFN,STOP,SLPPL,RXREC,PSOPBM
        K:'$G(MEDP) PSOQFLG
        D KVA^VADPT,FULL^VALM1 K PSOLST,PSOXFLG,PSCNT,PSDIS,PSOAL,P1,LOG,%,%DT,%I,D0,DAT,DFN,DRG,ORX,PSON,PSOPTPST,PTST,PSOBCK,PSOID,PSOBXPUL
        K INCOM,SIG,SG,STP,RX0,RXN,RX2,RX3,RTS,C,DEAD,PS,PSOCLC,PSOCNT,PSOCT,PSODA,PSOFROM,PSOHD,R3,REA,RF,RFD,RFM,RLD,RXNUM,RXP,RXPR,RXRP,RXRS,STR,POERR,VALMSG
        K ^TMP("PSORXDC",$J),^TMP("PSOAL",$J),^TMP("PSOAO",$J),^TMP("PSOSF",$J),^TMP("PSOPF",$J),^TMP("PSOPI",$J),^TMP("PSOPO",$J),^TMP("PSOHDR",$J) I '$G(MEDP),'$G(PSOQUIT) K PAT
        K RFN,PSOXXDFN,VALM,VALMKEY,PSOBCK,SPOERR,PSOFLAG,VALMBCK,D,GMRA,GMRAL,GMRAREC,PSOSTA,PSODT,RXFL,NOBG,BBRX,BBFLG
KV      K DIR,DIRUT,DTOUT,DUOUT,X,Y
        Q
ELIG    ; shows eligibility and disabilities
        D ELIG^VADPT W !,"Eligibility: "_$P(VAEL(1),"^",2)_$S(+VAEL(3):"     SC%: "_$P(VAEL(3),"^",2),1:"") S N=0 F  S N=$O(VAEL(1,N)) Q:'N  W !,?10,$P(VAEL(1,N),"^",2)
        W !,"Disabilities: " F I=0:0 S I=$O(^DPT(DFN,.372,I)) Q:'I  S I1=$S($D(^DPT(DFN,.372,I,0)):^(0),1:"") D:+I1
        .S PSDIS=$S($P($G(^DIC(31,+I1,0)),"^")]""&($P($G(^(0)),"^",4)']""):$P(^(0),"^"),$P($G(^DIC(31,+I1,0)),"^",4)]"":$P(^(0),"^",4),1:""),PSCNT=$P(I1,"^",2)
        .W:$L(PSDIS_"-"_PSCNT_"% ("_$S($P(I1,"^",3):"SC",1:"NSC")_"), ")>80 !,?15
        .W $S($G(PSDIS)]"":PSDIS_"-",1:"")_PSCNT_"% ("_$S($P(I1,"^",3):"SC",1:"NSC")_"), "
        K N
        Q
PROFILE ;
        S (PSORX("REFILL"),PSORX("RENEW"))=0,PSOX="" D ^PSOBUILD
        I '$G(PSOSD) W !,"This patient has no prescriptions" S:'$D(DFN) DFN=PSODFN D GMRA^PSODEM G PROFILEX
        S (PSODRG,PSOX)="" F  S PSODRG=$O(PSOSD(PSODRG)) Q:PSODRG=""  F  S PSOX=$O(PSOSD(PSODRG,PSOX)) Q:PSOX=""  S:$P(PSOSD(PSODRG,PSOX),"^",3)="" PSORX("RENEW")=1 S:$P(PSOSD(PSODRG,PSOX),"^",4)="" PSORX("REFILL")=1
        K PSOX
PROFILEX        ;
        Q
