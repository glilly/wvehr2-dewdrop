DGPATN  ;ALB/MRL - NEW PATIENT ENTRY ; 22 MAY 87
        ;;5.3;Registration;**41,278,671**;Aug 13, 1993;Build 27
        ;Name Changed/Patient Deleted Bulletin
        I $S('$D(DFN):1,'$D(X):1,1:0) Q
        I $D(DGNEWVAL),(DGNEWVAL=X) Q  ; edit and edited to same value
        S DGDATA=X D ^DGPATV S DGB=$S(DGNAME'=X:3,1:9) G Q:'DGB S XMSUB="PATIENT "_$S(DGB=3:"NAME CHANGED",1:"DELETED")
        ;
        ;Delete entries in PT/IHS file when entries deleted from PT file.
        I XMSUB="PATIENT DELETED" D
        . N DA,DIK
        . S DA=DFN,DIK="^AUPNPAT(" D ^DIK
        ;
        S DGTEXT(1,0)="NAME:  "_DGNAME,DGTEXT(2,0)="SSN :  "_$P(SSN,"^",2),DGTEXT(3,0)="DOB :  "_$P(DOB,"^",2),DGTEXT(4,0)="" I DGB=3 S DGTEXT(5,0)="Previous name was '"_DGDATA_"'."
        G T
        ;
S       ;SSN Changed/New Patient Added Bulletin
        I $S('$D(DFN):1,'$D(X):1,1:0) Q
        S DGDATA=X D ^DGPATV S DGB=$S(SSN=X:2,SSN="UNSPECIFIED":2,DGDATA'=$P(SSN,"^",1):4,1:0) I 'DGB G Q
        S XMSUB=$S(DGB=2:"NEW PATIENT ADDED TO SYSTEM",1:"SSN CHANGED"),DGTEXT(1,0)="NAME:  "_DGNAME,DGTEXT(2,0)="SSN :  "_$E(DGDATA,1,3)_"-"_$E(DGDATA,4,5)_"-"_$E(DGDATA,6,10),DGTEXT(3,0)="DOB :  "_$P(DOB,"^",2)
        I DGB=4 S DGTEXT(4,0)="",DGTEXT(5,0)="Previous SSN was '"_$P(SSN,"^",2)_"'."
        I DGB=2 D H^DGUTL D       ;New patient Who & When
        . N DR,DIE,DA,D,D0,DI,DIC,DQ,PRIOR,X,Y,%,%DT,%I,DB,DC,DE,DH,DIEL,DIER,DIETMP,DIFLD,DIP,DK,DL,DM,DP,DU,DW,DZ,DV
        . S DIE="^DPT(",DA=DFN,DR=".097///"_DGDATE
        . S:$G(DUZ)>0 DR=DR_";.096///"_DUZ
        . D ^DIE
T       K XMTEXT D ^DGBUL
Q       S X=DGDATA D KILL^DGPATV K DGDATA,DGTIME,DGDATE Q
