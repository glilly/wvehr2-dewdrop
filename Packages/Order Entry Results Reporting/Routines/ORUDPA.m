ORUDPA  ; slc/dcm,RWF - Object (patient) lookup ;10/7/91  15:21 ; 3/7/08 5:22am
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**16,243**;Dec 17, 1997;Build 242
ENT     ;
        ;Entry: none  Exit: DFN,ORACTION,ORAGE,ORDOB,ORL,ORNP,ORPD,ORPNM,ORPV,ORSEX,ORSSN,ORTS,ORVP,ORWARD,VADPT("V"),VAERR
        D PATIENT^ORU1(.Y)
        Q
EN2     ;
        S (ORVP,X)="",DIC(0)="EMQZI",DIC=2
        R !,"Select PATIENT NAME: ",X:DTIME
        I X=""!(X["^") S Y=-1 G END1
        S:'$D(DIC(0)) DIC(0)="EMQZI"
        S DIC="^DPT(" D ^DIC I $E(X)="^" S:X="^^" DIROUT=1 G END1
        I Y>0 S ORVP=+Y_";DPT(" Q:$D(ORUS)  G END1
        Q
END1    ;
        I Y>0 S ^TMP("OR",$J,"PAT",1)=ORVP,^TMP("OR",$J,"PAT","B",ORVP,1)=""
END     ;from ORUHDR
        Q:Y<0
        I ORVP[";DPT(" D HOMO
        K VA,VAROOT,VA200,VAIN,VAINDT,VAERR,VADM,DIC Q
        ;
GPD     ;
        N GMRVSTR
        K ORPD
        S (ORSEQ,ORPD)=0,DFN=+ORVP
        I $D(^GMRD(120.51)) S X="GMRVUTL",GMRVSTR="WT" X ^%ZOSF("TEST") I $T D EN6^GMRVUTL S ORPD=+$P(X,U,8)\1
        S:ORPD'>0 ORPD="NF"
        K ORSEQ
        Q
HOMO    ;
        N XQORFLG,ORCNV
        S DFN=+Y,VA200=1 K VAINDT
        D OERR^VADPT,GPD
        S ORPNM=VADM(1),ORSSN=VA("PID"),ORDOB=$P(VADM(3),"^",2),ORAGE=VADM(4),ORSEX=$P(VADM(5),"^"),ORTS=+VAIN(3),ORTS=$S(ORTS:ORTS,1:""),(ORATTEND,ORNP)=+VAIN(2),ORWARD=VAIN(4),ORL(1)=VAIN(5),(ORPV,ORL,ORL(0),ORL(2))=""
        I +$P(ORWARD,"^") S X=+ORWARD I $D(^DIC(42,+X,44)) S X=$P(^(44),"^") I X,$D(^SC(X,0)) S ORL=X_";SC(",ORL(0)=$S($L($P(^(0),"^",2)):$P(^(0),"^",2),1:$E($P(^(0),"^"),1,4)),ORL(2)=ORL
        Q
