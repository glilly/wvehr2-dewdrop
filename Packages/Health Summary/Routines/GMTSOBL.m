GMTSOBL ; SLC/KER - HS Object - Lookup                 ; 06/24/2009
        ;;2.7;Health Summary;**58,89**;Oct 20, 1995;Build 61
        ;
        ; External References
        ;   DBIA 10006  ^DIC  (file #142.5)
        ;   DBIA 10018  ^DIE  (file #142 and 142.5)
        ;   DBIA 10013  ^DIK  (file #142 and 142.5)
        ;   DBIA 10026  ^DIR
        ;   DBIA 10010  EN1^DIP
        ;   DBIA 10076  ^XUSEC(
        ;   DBIA 10076  ^XUSEC("GMTSMGR")
        ;   DBIA 10112  $$SITE^VASITE
        ;   DBIA 10103  $$NOW^XLFDT
        ;
        Q
OBJ(X)  ; Lookup HS Object
        Q:+($G(DUZ))'>0 -1  N DIR,DIC,DTOUT,DUOUT,DIROUT,DLAYGO,DA,D,D0,D1,DI,DQ,Y S U="^"
        S DIC="^GMT(142.5,",DIC(0)="AEMQ",DIC("A")=" Select HEALTH SUMMARY OBJECT:  " K DLAYGO D ^DIC
        S:+($$ABT)>0 Y=-1 S X=+($G(Y))
        Q X
HSO(X)  ; Lookup HS Object (by Known Name)
        I +($G(DUZ))'>0 S GMTSQ=1 Q -1
        N GMTSOWN,GMTSDICS,GMTSNAM,GMTSIEN,GMTSNEW
        N DIR,DIC,DTOUT,DUOUT,DIROUT,DLAYGO,DINUM,DA,D,D0,D1,DI,DQ,Y,GMTSL,GMTSH,GMTSS,GMTSTA S U="^"
        S GMTSNAM=$G(X),GMTSNEW=0,GMTSOWN="",GMTSQ=0 I '$L(GMTSNAM) S GMTSQ=1 Q -1
        S X=GMTSNAM I '$L(X) S X=-1,GMTSQ=1 Q X
        S DIC="^GMT(142.5,",DIC(0)="XML",DLAYGO=142.5 S:$L($G(GMTSDICS)) DIC("S")=$G(GMTSDICS)
        S GMTSTA=+($P($$SITE^VASITE,"^",3)) I +GMTSTA'>0 S X=-1,GMTSQ=1 Q X
        S GMTSS=+($G(GMTSTA)) S:$D(GMTSDEV) GMTSS=5000 S GMTSL=GMTSS_"0000"
        S GMTSH=GMTSS_"9999" S GMTSH=($O(^GMT(142.5,+GMTSH),-1)+1)
        S:+GMTSH<+GMTSL GMTSH=+GMTSS_"0001" S:+GMTSH>0 DINUM=+GMTSH
        D ^DIC I +($$ABT)>0 S GMTSQ=1,X=-1 Q X
        S GMTSNEW=+($P(Y,"^",3))
        I +Y'>0 S X=-1 Q X
        S X=+($G(Y))_"^"_$P($G(^GMT(142.5,+($G(Y)),0)),"^",1) S:+GMTSNEW>0 $P(X,"^",3)=+GMTSNEW
        W:GMTSNEW>0 !,"Creating Health Summary Object '",GMTSNAM,"'"
        S:+GMTSNEW>0 X=$$EE(Y) I +($G(GMTSQ))>1 S X=-1 Q
        S:+X'>0 X=-1 I +($G(GMTSQ))=0 D
        . D:+GMTSNEW>0&(+X>0) NEW^GMTSOBL2(+X)
        . D:+GMTSNEW'>0&(+X>0) MOD^GMTSOBL2(+X)
        Q X
LK(X)   ; Lookup HS Object (Learn as you go)
        Q:+($G(DUZ))'>0 -1  N GMTSDICS,GMTSB S GMTSDICS=$G(DIC("S")) K DIC("S") S GMTSDICS=$$DIM^GMTSOBL2(GMTSDICS),GMTSB=$P($$B^GMTSOBL2,"^",2)
        N DIR,DIC,DTOUT,DUOUT,DIROUT,DLAYGO,DA,D,D0,D1,DI,DQ,GMTSNAM,GMTSTA
        N GMTS,GMTSTD,GMTSOBJ,GMTSOBN,GMTSDT,GMTSNEW,GMTSDEF,GMTSDA,Y,X1 S U="^"
        S GMTSNEW=0,GMTSTA=+($P($$SITE^VASITE,"^",3)) Q:+GMTSTA=0 -1
        S DIR(0)="FAO^1:30^S:X="" "" (X,X1)=$G(GMTSB) K:$L(X)<3&(X'="" "") X"
        S DIR("A")=" Select HEALTH SUMMARY OBJECT:  ",(DIR("?"),DIR("??"))="^D NAH^GMTSOBL2"
        D ^DIR Q:'$L(Y)!(Y["^") -1  S GMTSNAM=Y
        S DIC="^GMT(142.5,",DIC(0)="EM" S:$L($G(GMTSDICS)) DIC("S")=$G(GMTSDICS)
        W ! D ^DIC
        I +($$ABT)>0 S GMTSQ=1,Y=-1,X=-1 Q X
        I +Y'>0 D  Q:+Y'>0 -1
        . N X,DIC,DINUM,GMTSL,GMTSH,GMTSS S GMTSS=+($G(GMTSTA)) S:$D(GMTSDEV) GMTSS=5000
        . S X=$G(GMTSNAM) Q:'$L(X)  S GMTSL=GMTSS_"0000"
        . S GMTSH=GMTSS_"9999",GMTSH=($O(^GMT(142.5,+GMTSH),-1)+1)
        . S:+GMTSH<+GMTSL GMTSH=+GMTSS_"0001" S:+GMTSH>0 DINUM=+GMTSH
        . S DIC="^GMT(142.5,",DIC(0)="EML",DLAYGO=142.5
        . S:$L($G(GMTSDICS)) DIC("S")=$G(GMTSDICS) D ^DIC
        . S GMTSNEW=+($P(Y,"^",3))
        . I +($$ABT)>0 S GMTSQ=1
        I +($G(GMTSQ))>0 S Y=-1,X=-1 Q X
        S X=+($G(Y))_"^"_$P($G(^GMT(142.5,+($G(Y)),0)),"^",1)
        S:+GMTSNEW>0 $P(X,"^",3)=+GMTSNEW S X=$$EE(Y) S:+X'>0 X=-1 I +X'>0 S GMTSQ=1,Y=-1,X=-1 Q X
        I +($G(GMTSQ))=0 D:+GMTSNEW>0&(+X>0) NEW^GMTSOBL2(+X) D:+GMTSNEW'>0&(+X>0) MOD^GMTSOBL2(+X)
        Q X
EE(X)   ; Enter/Edit
        N GMTSOBJ,DA,GMTSY,GMTSNAM,GMTSTYP,GMTSDICS,GMTSDICA,GMTSDICB,Y S Y=$G(X) S (GMTSOBJ,DA,X)=+($G(Y)),GMTSY=$G(Y)
        S GMTSTYP=$P($G(^GMT(142.5,+DA,0)),"^",3),GMTSTYP=$P($G(^GMT(142,+GMTSTYP,0)),"^",1)
        S GMTSNEW=$S(+($P($G(Y),U,3))>0:1,1:0) I GMTSNEW>0 D
        . S $P(^GMT(142.5,+DA,0),"^",20)=$S($D(GMTSDEV):1,1:0)
        S GMTSDT=$$NOW^XLFDT,GMTSOBN=$P($G(^GMT(142.5,+X,0)),U,1)
        I $D(GMTSOWN) D  I X'>0 S GMTSQ=1 Q X
        . N GMTSCRE S GMTSCRE=$P($G(^GMT(142.5,+X,0)),"^",17) Q:+GMTSCRE'>0
        . I GMTSNEW'>0,GMTSCRE'=DUZ,'$D(^XUSEC("GMTSMGR",DUZ)) W !!,"    Sorry, you can not edit someone else's object." S X=-1
        I GMTSNEW>0,+DA>0,$D(^GMT(142.5,+DA,0)) D
        . S $P(^GMT(142.5,+DA,0),U,17)=+($G(DUZ)),$P(^GMT(142.5,+DA,0),U,18)=+GMTSDT
        I +X>0 D  Q:$G(X)=-1!($G(DA)=-1)!($G(Y)=-1) -1
        . N DIR,DIC,DTOUT,DUOUT,DIROUT,DLAYGO,X,Y,GMTSDEF,GMTSD,GMTSDA
        . S GMTSDA=+DA,GMTSD=""
        . ; Type
        . S GMTSDEF=$P($G(^GMT(142.5,+DA,0)),U,3),GMTSD=$P($G(^GMT(142,+GMTSDEF,0)),"^",1)
        . S:$L(GMTSD) DIC("B")=GMTSDEF S DIC("A")=" Select HEALTH SUMMARY TYPE:  "
        . S:$D(GMTSDEV) DIC("S")="I +($G(^GMT(142,+Y,""VA"")))>0"
        . D K S GMTS=$$TY(GMTSDEF)
        . I +($$ABT)>0 D  Q
        . . W !,"<<<<<< ABORT >>>>>>"
        . . S GMTSQ=1,X=-1 I +($G(GMTSNEW))>0 S DIK="^GMT(142.5,",DA=GMTSDA D ^DIK
        . I $G(X)="@" S GMTSQ=1 S:$L(GMTSDEF) GMTS=GMTSD_"^"_GMTSDEF D NT^GMTSOBL2(GMTSY) Q
        . I +GMTS'>0,+DA>0,GMTSNEW>0 S GMTSQ=1 D NT^GMTSOBL2(GMTSY) Q
        . I +GMTS>0,+DA>0 D  Q:$G(X)=-1!($G(DA)=-1)!($G(Y)=-1)  Q:+($G(GMTSQ))>0
        . . N GMTSED,DIE,DR,GMTSI,GMTST,GMTSV,GMTSDT S GMTSDT=$$NOW^XLFDT
        . . S GMTSV=+($G(GMTS)),DIE="^GMT(142.5,",DR=".03////^S X=$G(GMTSV)"
        . . S GMTSED=0 F GMTSI=1:1:3 Q:GMTSI>3  L +^GMT(142.5):0 H:'$T 1 I $T D
        . . . D ^DIE S GMTSED=1 S $P(^GMT(142.5,+DA,0),U,19)=$$NOW^XLFDT,GMTSI=4
        . . I 'GMTSED S GMTSQ=1 K GMTSOBJ W !,"  Record Locked by another user" Q
        . . L -^GMT(142.5) S GMTST=+($P($G(^GMT(142.5,+DA,0)),U,3))
        . . I +GMTST'>0,+DA>0 D NT^GMTSOBL2(GMTSY) Q
        S X=+($G(DA))_"^"_$P($G(^GMT(142.5,+($G(DA)),0)),"^",1)
        S:+GMTSNEW>0 X=X_"^"_+GMTSNEW
        S X=$$VER^GMTSOBL2(X)
        Q X
TYPE(GMTS)      ; Lookup HS Type
        F  S GMTS=$$TYPE^GMTSOBT Q:+GMTS>0!(X="@")!(X["^")!(X="")
        S:X["^" X="^" S:X["^"!(X="@")!(X="") GMTS=-1
        Q GMTS
TY(GMTS)        ; Lookup HS Type   (Learn as you go)
        N ADEL,B,BY,CHANGE,CNT,DA,DHD,DIC,DIE,DIK,DIR,DLAYGO,DR
        N EXISTS,FLDS,FR,GMTSEG,GMTSIEN,GMTSDEF,GMTSIFN,GMTSMGR,GNTSN
        N GMTSNEW,GMTSQIT,GMTSUM,L,LCNT,LI,NXTCMP,SELCNT,SOACTION,TO,TWEENER
        N TYPE,Y S EXISTS=0,(GMTSDEF,X)=$G(GMTS),GMTSQIT=0
        W:'$D(GMTSDICA) ! S U="^",DIC="^GMT(142,",DIC(0)="AEMQL"
        S DIC("A")=" Select Health Summary Type: "
        S:$L($G(GMTSDICA)) DIC("A")=$G(GMTSDICA)
        S GMTSDEF=$S(+GMTSDEF>0:$P($G(^GMT(142,+GMTSDEF,0)),"^",1),1:"")
        S:$L($G(GMTSDEF)) DIC("B")=$G(GMTSDEF)
        S DIC("S")="I +($$AHST^GMTSULT(+($G(Y))))"
        S DLAYGO=142,Y=$$TYPE^GMTSULT K DIC I +Y'>0 S X="@" Q -1
        S (GMTSIFN,DA)=+Y,GMTSUM=$P(Y,U,2),GMTSNEW=+$P(Y,U,3)
        S GMTSMGR=$S($D(^XUSEC("GMTSMGR",DUZ)):1,1:0)
        I 'GMTSNEW S X=$S(+Y>0:+Y,1:"@"),GMTS=+Y Q GMTS
        S DIE="^GMT(142,",(GMTSIFN,DA)=+Y,DR="[GMTS EDIT HLTH SUM TYPE]" D ^DIE
        I '$D(^GMT(142,+GMTSIFN,0))!($D(Y))!$D(DUOUT)!$D(DIROUT)!$D(DTOUT) D  Q -1
        . S GMTSQIT=1 D CD S:'$D(^GMT(142,+GMTSIFN,0)) X="@"
        D SELCMP^GMTSRM5 I GMTSQIT D DEL(GMTSIFN) Q -1
        D LIST:EXISTS,EXISTS,CD S X=$S($D(^GMT(142,+($G(GMTSIFN)),0)):+GMTSIFN,1:-1)
        K:+X>0 DTOUT,DUOUT,DIRUT,DIROUT S:+X>0 GMTSQ=0
        Q X
CD      ;   Check for Possible Deletion (New Type without Component)
        Q:+($G(GMTSIFN))'>0  Q:'$D(^GMT(142,+($G(GMTSIFN)),0))
        D:GMTSMGR!(GMTSNEW)!($P(^GMT(142,+GMTSIFN,0),U,3)'=$G(DUZ)) ADEL(+($G(GMTSIFN)))
        Q
EXISTS  ;   Edit an existing health summary type
        N CNT,NXTCMP,GMTSQIT S GMTSQIT=0 Q:$D(DUOUT)  S NXTCMP=0,NXTCMP(0)=0
        F CNT=$$GETCNT(GMTSIFN):0 D NXTCMP^GMTSRM1 D LIST:GMTSQIT Q:GMTSQIT!($D(DUOUT))  K GMTSQIT,GMTSNEW,TWEENER,SOACTION
        I NXTCMP>0 W !,"Please hold on while I resequence the summary order" D COPY^GMTSRN,RNMBR^GMTSRN:CHANGE
        Q
LIST    ;   Lists existing summary parameters
        N B,DIC,DIR,IOP,Y,FR,TO,BY,DHD,FLDS,L I GMTSQIT'=2 Q:($D(DUOUT)!(GMTSQIT=1))
        I GMTSQIT=2,(NXTCMP=0) S GMTSQIT=0 Q
        I 'GMTSNEW W ! S DIC=142,DIR(0)="Y",DIR("A")="Do you wish to review the Summary Type structure before continuing",DIR("B")="NO" D ^DIR K DIR I 'Y S:GMTSQIT=2 DUOUT="" S:GMTSQIT=2 GMTSQIT="D" S:$D(DUOUT) GMTSQIT=1 Q
        I $D(GMTSQIT),GMTSQIT=2 S GMTSQIT=0
        S IOP="HOME",DIC=142,(FR,TO)=GMTSUM,BY=".01",DHD="[GMTS TYPE INQ HEADER]-[GMTS TYPE INQ FOOTER]",FLDS="[GMTS TYPE INQ]",L=0 D EN1^DIP
        Q
GETCNT(GMTSIFN) ;   Determine default summary order for new component
        N LI,LCNT S LI=0,LCNT=5 F  S LI=$O(^GMT(142,+GMTSIFN,1,LI)) Q:+LI'>0  S LCNT=$P(LI,".")+5
        Q LCNT
ADEL(X) ;   Ask to Delete Type
        N GMTSIEN,GMTSN,ADEL,DIR S GMTSIEN=+($G(X)),ADEL=""  Q:GMTSIEN=0  Q:'$D(^GMT(142,GMTSIEN,0))  Q:$D(^GMT(142,GMTSIEN,1,"B"))
        S GMTSN=$P($G(^GMT(142,GMTSIEN,0)),"^",1) Q:'$L(GMTSN)  S DIR("A",1)=" Health Summary Type '"_GMTSN_"' has no Components",DIR("A")=" Do you want to delete this type?  (Y/N)  ",DIR("B")="Yes",DIR(0)="YAO",DIR("?")="     Enter either 'Y' or 'N'."
        W ! D ^DIR D:Y>0 DEL(+($G(GMTSIEN)))
        Q
DEL(X)  ;   Delete Type
        N DIK,DA,GMTSN S DA=+($G(X)) Q:DA=0  Q:'$D(^GMT(142,DA,0))
        S DIK="^GMT(142,",GMTSN=$P($G(^GMT(142,DA,0)),"^",1) Q:'$L(GMTSN)  D ^DIK
        I '$D(^GMT(142,DA,0)) W:$D(ADEL) "  < Health Summary Type deleted >" W:'$D(ADEL) !,?2,GMTSN,"  < deleted >"
        Q
K       ; Kill Common Variables
        K DTOUT,DUOUT,DIRUT,DIROUT
        Q
ABT(X)  ; Abort
        Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) 1
        Q 0
ST      ; Show Type
        N GMTSN,GMTSC S GMTSN="^GMT(142,"_+($G(GMTSIFN))_")",GMTSC="^GMT(142,"_+($G(GMTSIFN))_","
        W ! F  S GMTSN=$Q(@GMTSN) Q:GMTSN=""!(GMTSN'[GMTSC)  W !,GMTSN,"=",@GMTSN
        Q
