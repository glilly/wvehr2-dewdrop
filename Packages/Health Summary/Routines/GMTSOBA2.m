GMTSOBA2        ; SLC/KER - HS Object - Ask               ; 05/22/2008
        ;;2.7;Health Summary;**58,89**;Oct 20, 1995;Build 61
        ;
        ; External References
        ;   DBIA  10018  ^DIE  (file #142)
        ;   DBIA  10026  ^DIR        
        ;   DBIA  10006  ^DIC  (file #142)
        ;   DBIA  10010  EN1^DIP
        ;   DBIA  10076  ^XUSEC(
        ;   DBIA  10076  ^XUSEC("GMTSMGR")
        ;             
CH      ;   Component Header
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF,GMTSE
        S GMTSOBJ("COMPONENT HEADER")="",DIR("A")="   Print the standard Component Header?  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(GMTSDA)),0)),U,12),GMTSE=0
        S GMTSDEF=$S(+GMTSDEF>0:"Y",GMTSDEF="":"Y",1:"N")
        S DIR("B")=GMTSDEF,DIR(0)="YAO",(DIR("?"),DIR("??"))="^D CH^GMTSOBH"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1
        S:Y["^"!(X["^") GMTSE=1,GMTSQ=1,GMTSDES=0
        K:+($G(GMTSQ))>0 GMTSOBJ("COMPONENT HEADER") Q:+($G(GMTSQ))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("COMPONENT HEADER")
        D:$D(GMTSOBJ("COMPONENT HEADER"))&(GMTSE'>0) LM Q:+($G(GMTSQ))>0  Q:+($G(GMTSE))>0
        D:$D(GMTSOBJ("COMPONENT HEADER"))&(GMTSE'>0) UD Q:+($G(GMTSQ))>0  Q:+($G(GMTSE))>0
        D:$D(GMTSOBJ("COMPONENT HEADER"))&(GMTSE'>0) BL Q:+($G(GMTSQ))>0  Q:+($G(GMTSE))>0
        Q
LM      ;     Time/Occurence Limits
        Q:+($G(GMTSQ))>0  Q:+($G(GMTSE))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF
        S GMTSOBJ("LIMITS")="",DIR("A")="     Use report time/occurence limits?  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(GMTSDA)),0)),U,14)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N")
        S (DIR("?"),DIR("??"))="^D LM^GMTSOBH",DIR("B")=GMTSDEF,DIR(0)="YAO"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSE=1
        S:Y["^"!(X["^") GMTSE=1,GMTSQ=1,GMTSDES=0
        K:+($G(GMTSE))>0 GMTSOBJ("LIMITS") Q:+($G(GMTSE))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("LIMITS") Q
UD      ;     Underline Header
        Q:+($G(GMTSQ))>0  Q:+($G(GMTSE))>0
        N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF
        S GMTSOBJ("UNDERLINE")="",DIR("A")="     Underline Component Header?  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(GMTSDA)),0)),U,13)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N")
        S (DIR("?"),DIR("??"))="^D CHU^GMTSOBH",DIR("B")=GMTSDEF,DIR(0)="YAO"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSE=1
        S:Y["^"!(X["^") GMTSE=1,GMTSQ=1,GMTSDES=0
        K:+($G(GMTSE))>0 GMTSOBJ("UNDERLINE") Q:+($G(GMTSE))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("UNDERLINE") Q
BL      ;     Blank Line after Header
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF
        S GMTSOBJ("BLANK LINE")="",DIR("A")="     Add a Blank Line after the Component Header?  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(GMTSDA)),0)),U,15)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N")
        S (DIR("?"),DIR("??"))="^D BL^GMTSOBH",DIR("B")=GMTSDEF,DIR(0)="YAO"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1
        K:+($G(GMTSQ))>0 GMTSOBJ("BLANK LINE") Q:+($G(GMTSQ))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("BLANK LINE") Q
DE      ;   Deceased
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF
        S GMTSOBJ("DECEASED")="",DIR("A")="   Print the date a patient was deceased?  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(GMTSDA)),0)),U,16)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N")
        S (DIR("?"),DIR("??"))="^D DE^GMTSOBH",DIR("B")=GMTSDEF,DIR(0)="YAO"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1
        K:+($G(GMTSQ))>0 GMTSOBJ("DECEASED") Q:+($G(GMTSQ))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("DECEASED") Q
LBL     ; Label
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDLD,GMTSDEF
        K GMTSOBJ("USE LABEL"),GMTSOBJ("LABEL"),GMTSOBJ("LABEL BLANK LINE")
        S DIR("A")=" Print a LABEL before the Health Summary Object?  "
        S GMTSDEF=$S(+($G(GMTSDA))>0:$P($G(^GMT(142.5,+($G(GMTSDA)),0)),"^",7),1:0)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N"),(DIR("?"),DIR("??"))="^D PLB^GMTSOBH",DIR("B")=GMTSDEF,DIR(0)="YAO"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1 S:Y["^"!(X["^") GMTSQ=1
        K:+($G(GMTSQ))>0 GMTSOBJ("USE LABEL") Q:+($G(GMTSQ))>0
        S GMTSOBJ("USE LABEL")=$S(+Y>0:1,1:0)
        S X=+($G(Y)) D:+X LB Q
LB      ;   Object Label
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF,GMTSE
        S GMTSOBJ("LABEL")="",DIR("A")="   Enter LABEL:  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(DA)),0)),"^",2) S:$L(GMTSDEF) DIR("B")=GMTSDEF
        S (DIR("?"),DIR("??"))="^D LBH^GMTSOBH",DIR(0)="FAO^3:60"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSE=1 S:Y["^"!(X["^") GMTSE=1
        K:+($G(GMTSE))>0 GMTSOBJ("USE LABEL"),GMTSOBJ("LABEL"),GMTSOBJ("LABEL BLANK LINE")
        Q:+($G(GMTSE))>0  S X=$G(Y) K:'$L(X) GMTSOBJ("USE LABEL"),GMTSOBJ("LABEL"),GMTSOBJ("LABEL BLANK LINE")
        S:$L(X) GMTSOBJ("LABEL")=X_" " D:$L($G(GMTSOBJ("LABEL"))) LBB Q
LBB     ;   Label Blank Line
        Q:+($G(GMTSE))>0  Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF,GMTSE
        S GMTSOBJ("LABEL BLANK LINE")="",DIR("A")="   Print a blank line after the Object Label?  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(DA)),0)),"^",8)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N") S DIR("B")=GMTSDEF
        S (DIR("?"),DIR("??"))="^D LBLH^GMTSOBH",DIR(0)="YAO"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSE=1 S:Y["^"!(X["^") GMTSE=1
        K:+($G(GMTSE))>0 GMTSOBJ("LABEL BLANK LINE") Q:+($G(GMTSE))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("LABEL BLANK LINE") Q
SC      ; Suppress Components w/o Data
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDLD,GMTSDEF
        S GMTSOBJ("SUPPRESS COMPONENTS")="",DIR("A")=" Suppress Components without Data?  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(GMTSDA)),0)),U,5)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N")
        S (DIR("?"),DIR("??"))="^D SC^GMTSOBH",DIR("B")=GMTSDEF,DIR(0)="YAO"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1
        K:+($G(GMTSQ))>0 GMTSOBJ("SUPPRESS COMPONENTS") Q:+($G(GMTSQ))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("SUPPRESS COMPONENTS")
        Q
NODATA  ; Override No Data Available output
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDLD,GMTSDEF
        S GMTSOBJ("NO DATA")="",DIR("A")=" Overwrite No Data Available Message  "
        S GMTSDEF=$G(^GMT(142.5,+($G(GMTSDA)),2))
        S (DIR("?"),DIR("??"))="^D NODATA^GMTSOBH",DIR("B")=GMTSDEF,DIR(0)="FO^3:60"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1
        I +($G(GMTSQ))>0 S GMTSOBJ("NO DATA")="" Q
        S GMTSOBJ("NO DATA")=Y
        Q
        ;
ET(X)   ; Edit Type X
        Q:+($G(DUZ))'>0  N ADEL,B,BY,CHANGE,CNT,DA,DHD,DIC,DIE,DIK,DIR,DIROUT,DLAYGO,DR,DTOUT
        N DUOUT,EXISTS,FLDS,FR,GMTSEG,GMTSIEN,GMTSDEF,GMTSIFN,GMTSMGR,GNTSN
        N GMTSNEW,GMTSQIT,GMTSUM,GMTSV,GMTSAL,D,D0,D1,DQ,Y,L,LCNT,LI
        N NXTCMP,SELCNT,SOACTION,TO,TWEENER S EXISTS=0,U="^",GMTSAL=1,GMTSQIT=0,X=$G(X) Q:'$L(X)  Q:$L(X)>30
        S DIC="^GMT(142,",DIC(0)="XMZ" K DLAYGO D ^DIC
        S GMTSN=$P($G(^GMT(142,+Y,0)),"^",1) Q:'$L(GMTSN)
        S GMTSUM=$P(Y,U,2) Q:'$L(GMTSUM)  S:$D(DIROUT)!($D(DTOUT)) Y=-1 Q:+Y'>0
        S GMTSNEW=+($P(Y,"^",3)),GMTSV=$$VTE^GMTSOBV(+Y) Q:+GMTSV'>0
        S GMTSMGR=$S($D(^XUSEC("GMTSMGR",DUZ)):1,1:0)
        S DIE="^GMT(142,",(GMTSIFN,DA)=+Y
        S DR="[GMTS EDIT EXIST HS TYPE]"
        W !!,"Editing Health Summary Type '",GMTSN,"'",!
        D ^DIE
        S EXISTS=0 S:($O(^GMT(142,+GMTSIFN,1,0))) EXISTS=1
        D LIST:EXISTS,EXISTS
        Q
EXISTS  ;   Edit an existing health summary type
        N GMTSAL,CNT,NXTCMP Q:$D(DUOUT)  S NXTCMP=0,NXTCMP(0)=0,GMTSAL=0
        F CNT=$$GETCNT(GMTSIFN):0 D NXTCMP^GMTSRM1,LIST:GMTSQIT Q:GMTSQIT!($D(DUOUT))  K GMTSQIT,GMTSNEW,TWEENER,SOACTION
        I NXTCMP>0 W !,"Please hold on while I resequence the summary order" D COPY^GMTSRN,RNMBR^GMTSRN:CHANGE
        Q
LIST    ;   Lists existing summary parameters
        N B,DIC,DIR,IOP,Y,FR,TO,BY,DHD,FLDS,L I GMTSQIT'=2 Q:($D(DUOUT)!(GMTSQIT=1))
        I GMTSQIT=2,(NXTCMP=0) S GMTSQIT=0 Q
        I 'GMTSNEW,'GMTSAL W ! S DIC=142,DIR(0)="Y",DIR("A")="Do you wish to review the Summary Type structure before continuing",DIR("B")="NO" D ^DIR K DIR I 'Y S:GMTSQIT=2 DUOUT="" S:GMTSQIT=2 GMTSQIT="D" S:$D(DUOUT) GMTSQIT=1 Q
        I $D(GMTSQIT),GMTSQIT=2 S GMTSQIT=0
        S IOP="HOME",DIC=142,(FR,TO)=GMTSUM,BY=".01",DHD="[GMTS TYPE INQ HEADER]-[GMTS TYPE INQ FOOTER]",FLDS="[GMTS TYPE INQ]",L=0 D EN1^DIP
        Q
GETCNT(GMTSIFN) ;   Determine default summary order for new component
        N LI,LCNT S LI=0,LCNT=5 F  S LI=$O(^GMT(142,+GMTSIFN,1,LI)) Q:+LI'>0  S LCNT=$P(LI,".")+5
        Q LCNT
