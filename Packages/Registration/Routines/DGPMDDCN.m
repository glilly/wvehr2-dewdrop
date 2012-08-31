DGPMDDCN        ;ALB/MRL - DETERMINE INPATIENT X-REF'S ;3/04/08 8:54am
        ;;5.3;Registration;**54,498,671**;Aug 13, 1993;Build 27
        ;
1       ; 
        I $S($D(DGPMT):1,('$D(DA)#2):1,'$D(DGPMDDF):1,'$D(DGPMDDT):1,1:0) G KX
        N DFN S DFN=+$P(^DGPM(+DA,0),"^",3) I '$D(^DPT(DFN,0)) G KX
        I 'DGPMDDT D @("K"_+DGPMDDF) G Q
        D INPTCK
        I $S('VAWD:1,1:$P(VAWD,"^",2)="") D  G Q
        . N DGWD
        . D FIND^DGPMDDLD
        . I DGWD,($P(DGWD,"^",2)]"") D EN^DGPMDDLD Q
        . K X
        D @("S"_+DGPMDDF) G Q
        ;
KX      K X
Q       D KVAR^VADPT30 K DGPMX,DGPMX1,DGFLD,DGPMDD,DGPMDDF,DGPMDDT,I Q
        ;
S6      ; -- ward x-ref
        S DGFLD=.1 I $D(^DPT(DFN,.1)) S DGPMX=^(.1) K:$D(^(.105)) ^DGPM("CN",DGPMX,+^(.105)) D KILL
        S DGPMX=$P(VAWD,"^",2),^DGPM("CN",DGPMX,+$P(^DGPM(+VAMV,0),"^",14))=""
        D SET
        S DGFLD=.102 I $D(^DPT(DFN,.102)) S DGPMX=^(.102) D KILL
        S DGPMX=+VAMV D SET:DGPMX
        S DGFLD=.105 I $D(^DPT(DFN,.105)) S DGPMX=^(.105) D KILL
        S DGPMX=+$P(^DGPM(+VAMV,0),"^",14) D SET:DGPMX
        Q
        ;
K6      ;
        I X S W=$S($D(^DIC(42,+X,0)):$P(^(0),"^",1),1:"") I W]"" K ^DGPM("CN",W,+$P(^DGPM(DA,0),"^",14)) I $D(^DPT(DFN,.1)),^(.1)=W S DGPMX=W,DGFLD=.1 D KILL
        K W
        I $D(^DPT(DFN,.102)),^(.102)=DA S DGPMX=DA,DGFLD=.102 D KILL
        I $D(^DPT(DFN,.105)),^(.105)=$P(^DGPM(DA,0),"^",14) S DGPMX=$P(^DGPM(DA,0),"^",14),DGFLD=.105 D KILL
        Q
        ;
S7      ; -- room-bed x-ref
        I $D(^DPT(DFN,.108)) S DGPMX=^(.108),DGFLD=.108 D KILL F DGPMX1=0:0 S DGPMX1=+$O(^DGPM("ARM",DGPMX,DGPMX1)) D CHK I $T K ^DGPM("ARM",DGPMX,DGPMX1) Q
        S DGFLD=.101 I $D(^DPT(DFN,.101)) S DGPMX=^(.101) D KILL
        S DGPMX=$P(VARM,"^",2) D SET
        I +VARM S DGFLD=.108,DGPMX=+VARM,^DGPM("ARM",DGPMX,VAWDA)=0 D SET
        Q
        ;
K7      ;
        I $D(^DPT(DFN,.108)),X=+^(.108) S DGPMX=X I $D(^DGPM("ARM",DGPMX,DA)) K ^(DA) S DGFLD=.108 D KILL
        I X S R=$S($D(^DG(405.4,+X,0)):$P(^(0),"^",1),1:"") I R]"",$D(^DPT(DFN,.101)),^(.101)=R S DGPMX=R,DGFLD=.101 D KILL
        Q
        ;
CHK     ;
        I '$D(^DGPM(DGPMX1,0)) Q
        I $P(^DGPM(DGPMX1,0),"^",3)=DFN Q
        Q
        ;
S8      ; -- doc x-ref
        I $D(^DPT(DFN,.104)) S DGPMX=+^(.104) D KILL
        S DGPMX=+VAPP I DGPMX D
        . N DA,DR,DIE,DIC,D,%H,%T,D0,DIK,DK,DL,X,DQ,Y
        . S DIE="^DPT(",DA=DFN,DR=".104////"_DGPMX D ^DIE
        Q
        ;
K8      ;
        I X,$D(^DPT(DFN,.104)),^(.104)=X S DGPMX=X,DGFLD=.104 D KILL
        Q
        ;
S9      ; -- tr. spec x-ref
        S DGFLD=.103 I $D(^DPT(DFN,.103)) S DGPMX=+^(.103) D KILL
        S DGPMX=+VATS D SET:DGPMX
        Q
        ;
K9      ;
        I X,$D(^DPT(DFN,.103)),^(.103)=X S DGPMX=X,DGFLD=.103 D KILL
        Q
        ;
S19     ; -- attend x-ref
        S DGFLD=.1041 I $D(^DPT(DFN,.1041)) S DGPMX=+^(.1041) D KILL
        S DGPMX=+VAAP D SET:DGPMX
        Q
        ;
K19     ;
        I X,$D(^DPT(DFN,.1041)),^(.1041)=X S DGPMX=X,DGFLD=.1041 D KILL
        Q
        ;
S41     ; -- fac dir x-ref (AFD)
        S DGFLD=.109 S DGPMX=$P($G(^DPT(DFN,.109)),"^",1) D KILL:(DGPMX'="")
        S DGPMX=$P(VAFD,"^",1) D SET:(DGPMX'="")
        Q
        ;
K41     ;
        I X'="",$P($G(^DPT(DFN,.109)),"^",1)=X S DGPMX=X,DGFLD=.109 D KILL
        Q
        ;
SET     ; -- generic set x-ref logic
        Q:DGPMX']""
        N X,DA S DA=DFN,(^DPT(DA,DGFLD),X)=DGPMX
        F DGIX=0:0 S DGIX=$O(^DD(2,DGFLD,1,DGIX)) Q:'DGIX  X ^(DGIX,1) S X=DGPMX
        K DGIX Q
        ;
KILL    ; -- generic kill x-ref logic
        Q:DGPMX']""
        N X,DA S DA=DFN,X=DGPMX
        F DGIX=0:0 S DGIX=$O(^DD(2,DGFLD,1,DGIX)) Q:'DGIX  X ^(DGIX,2) S X=DGPMX
        K DGIX,^DPT(DA,DGFLD) Q
        ;
CN      ; -- set "CN" x-ref for file #2 equal to corresp adm mv
        N DFN,VAMV0,VAMV,VAMT,VAID,DGX
        S DGX=X D NOW^%DTC S VAID=9999999.999999-%,DFN=DA D MV^VADPT30
        I $P(VAMV0,U,2),$P(VAMV0,U,2)'=3 S ^DPT("CN",DGX,DA)=$P(VAMV0,"^",14)
        Q
        ;
RESET   ; -- reset ^DPT nodes and x-refs
        ;    input: DFN
        ;
        ; -- kill data and x-refs
        I $D(^DPT(DFN,.105)),$D(^(.1)),^(.1)]"" K ^DGPM("CN",^(.1),+^(.105))
        I $D(^DPT(DFN,.108)) S DGPMX=^(.108),DGFLD=.108 D KILL F DGPMX1=0:0 S DGPMX1=+$O(^DGPM("ARM",DGPMX,DGPMX1)) D CHK I $T K ^DGPM("ARM",DGPMX,DGPMX1) Q
        F DGFLD=.1,.101,.102,.103,.104,.1041,.105,.109 I $D(^DPT(DFN,DGFLD)) S DGPMX=^(DGFLD) D KILL
        ; -- reset data and x-refs
        D INPTCK
        I $S('VAWD:1,1:$P(VAWD,"^",2)="") D  G RESETQ
        . N DGWD
        . D FIND^DGPMDDLD
        . I DGWD,($P(DGWD,"^",2)]"") D RESET^DGPMDDLD
        D SETALL
RESETQ  D KVAR^VADPT30 K DGPMX,DGPMX1,DGFLD,I Q
        ;
SETALL  D S6,S7,S8,S9,S19,S41 Q
        ;
XREF    I $D(^DGPM(DA,0)),$P(^(0),"^",2)=4!($P(^(0),"^",2)=5) G XREF^DGPMDDLD
        Q:$D(DGPMT)
        I $D(^DGPM(DA,0)) N DFN S DFN=+$P(^(0),U,3) D RESET
        Q
        ;
INPTCK  ; check to see if patient is current inpatient
        D NOW^%DTC S VAPRT=0,VATD=9999999.999999-%,(VACN,VAPRC)=1
        S VA200="" D VAR^VADPT30 K VA200
        Q
