GMTSOBA ; SLC/KER - HS Object - Ask               ; 06/24/2009
        ;;2.7;Health Summary;**58,89**;Oct 20, 1995;Build 61
        ;
        ; External References
        ;   DBIA  10018  ^DIE  (file #142.5)
        ;   DBIA  10026  ^DIR        
        ;   DBIA  10103  $$FMTE^XLFDT
        ;   DBIA  10103  $$NOW^XLFDT 
        ;             
OBJ     ; Create/Edit Object
        N DA,X,Y,DIE,DR,GMTSED,GMTSCON,GMTSLBL,GMTSLBB,GMTSULB,GMTSHDR
        N GMTSRDT,GMTSCON,GMTSRHD,GMTSNEW,GMTSNEWO,GMTSDES,GMTSCHD,GMTSLIM
        N GMTSBLK,GMTSQ,GMTSDEC,GMTSNOD,GMTSOWN,GMTSDT,GMTSI,GMTSDA,GMTSUND
        N GMTSTIM,GMTSTI,GMTSOI,GMTSNDAT
        S (GMTSHDR,GMTSRDT,GMTSCON,GMTSRHD,GMTSCHD,GMTSUND,GMTSLIM,GMTSULB,GMTSLBB,GMTSBLK,GMTSDEC,GMTSNOD)=0,GMTSOWN="",GMTSDES=1
        S:'$L($G(GMTSNAM)) DA=$$LK^GMTSOBL Q:+($G(GMTSQ))>0
        S:$L($G(GMTSNAM)) DA=$$HSO^GMTSOBL($G(GMTSNAM)) Q:+($G(GMTSQ))>0  Q:+($G(DA))'>0
        S:$L($G(GMTSNAM)) GMTSNEW=+($P($G(DA),"^",3)),DA=+($P($G(DA),"^",1))
        Q:+($G(DA))'>0  S (GMTSDA,GMTSOI)=+($G(DA)),GMTSTI=$P($G(^GMT(142.5,+GMTSOI,0)),"^",3) Q:+GMTSTI'>0
        S GMTSLBL="" K GMTSOBJ  S GMTSCON=1
        I $L($G(GMTSNAM)),+GMTSNEW'>0,+DA>0 D  Q:+($G(GMTSCON))'>0  Q:+($G(GMTSQ))>0
        . N GMTSOWN S GMTSOWN=$P($G(^GMT(142.5,+DA,0)),"^",17)
        . I +GMTSOWN>0,+($G(DUZ))>0,+GMTSOWN'=+($G(DUZ)),'$D(^XUSEC("GMTSMGR",DUZ)) S GMTSCON=0 Q
        . W !," Object '",GMTSNAM,"' already exist" S GMTSCON=$$CONT Q:+($G(GMTSCON))'>0
        . N X,Y,DIR,DIE,DR,GMTSDEF,GMTSDICA,GMTSNAM,GMTSTYPE
        . W ! S GMTSDEF=+($P($G(^GMT(142.5,+($G(DA)),0)),"^",3))
        . S GMTSDEF=$S(+GMTSDEF>0:+GMTSDEF,1:"")
        . S GMTSDICA=" Enter/Edit HEALTH SUMMARY TYPE:  "
        . K DTOUT,DUOUT,DIRUT,DIROUT
        . S GMTSTYPE=$$TY^GMTSOBL(GMTSDEF)
        . I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) S GMTSQ=1 Q
        . S DR=".03////^S X=$G(GMTSTYPE)"
        . S DIE="^GMT(142.5,",DA=+($G(DA)) S GMTSED=0
        . F GMTSI=1:1:3 Q:GMTSI>3  L +^GMT(142.5,+($G(DA))):0 H:'$T 1 I $T D
        . . D ^DIE S GMTSED=1 S $P(^GMT(142.5,+DA,0),U,19)=$$NOW^XLFDT,GMTSI=4
        . . S:+($G(DUZ))>0 $P(^GMT(142.5,+DA,0),"^",17)=+($G(DUZ))
        . I 'GMTSED S GMTSQ=1 K GMTSOBJ W !,"  Record Locked by another user" Q
        . L -^GMT(142.5,+($G(DA))) S GMTST=+($P($G(^GMT(142.5,+DA,0)),U,3))
        K:+($G(GMTSQ))>0 GMTSOBJ Q:+($G(GMTSQ))>0
        D ALL K:+($G(GMTSQ))>0 GMTSOBJ S:+($G(GMTSQ))>0 GMTSDES=0 Q:+($G(GMTSQ))>0  N DIE,DR
        S GMTSHDR=+($G(GMTSOBJ("HEADER")))
        S GMTSLBL=$G(GMTSLBL) I GMTSHDR>0 D
        . S GMTSRDT=$S($D(GMTSOBJ("DATE LINE")):1,1:0)
        . S GMTSCON=$S($D(GMTSOBJ("CONFIDENTIAL")):1,1:0)
        . S GMTSRHD=$S($D(GMTSOBJ("REPORT HEADER")):1,1:0)
        . S GMTSCHD=$S($D(GMTSOBJ("COMPONENT HEADER")):1,1:0)
        . S GMTSUND=$S($D(GMTSOBJ("UNDERLINE")):1,1:0)
        . S GMTSLIM=$S($D(GMTSOBJ("LIMITS")):1,1:0)
        . S GMTSBLK=$S($D(GMTSOBJ("BLANK LINE")):1,1:0)
        . S GMTSDEC=$S($D(GMTSOBJ("DECEASED")):1,1:0)
        . S GMTSULB=$S($D(GMTSOBJ("USE LABEL")):1,1:0)
        . S GMTSLBB=$S($D(GMTSOBJ("LABEL BLANK LINE")):1,1:0)
        . S GMTSNDAT=$G(GMTSOBJ("NO DATA"))
        I GMTSHDR'>0 S (GMTSRDT,GMTSCON,GMTSRHD,GMTSCHD,GMTSUND,GMTSLIM,GMTSBLK,GMTSDEC,GMTSULB,GMTSLBB)=0,GMTSLBL=""
        S GMTSNOD=$S($D(GMTSOBJ("SUPPRESS COMPONENTS")):1,1:0)
        S:+GMTSCHD'>0 (GMTSLIM,GMTSBLK)=0
        S:'$L($G(GMTSLBL)) GMTSLBL="@",(GMTSULB,GMTSLBB)=0
        N DR S DR=".02////^S X=$G(GMTSLBL);"
        S:$L($G(GMTSTIM))&($G(GMTSTIM)'="@") DR=DR_".04////^S X=$G(GMTSTIM);"
        S DR=DR_".05////^S X=$G(GMTSNOD);",DR=DR_".06////^S X=$G(GMTSHDR);"
        S DR=DR_".07////^S X=$G(GMTSULB);",DR=DR_".08////^S X=$G(GMTSLBB);"
        S DR=DR_".09////^S X=$G(GMTSRDT);",DR=DR_".1////^S X=$G(GMTSCON);"
        S DR=DR_".11////^S X=$G(GMTSRHD);",DR=DR_".12////^S X=$G(GMTSCHD);"
        S DR=DR_".13////^S X=$G(GMTSUND);",DR=DR_".14////^S X=$G(GMTSLIM);"
        S DR=DR_".15////^S X=$G(GMTSBLK);",DR=DR_".16////^S X=$G(GMTSDEC);"
        S DR=DR_"2////^S X=$G(GMTSNDAT);"
        S:+($G(GMTSDES))>0 DR=DR_"1" S:$E(DR,1)=";" DR=$E(DR,2,$L(DR)) S:$E(DR,$L(DR))=";" DR=$E(DR,1,($L(DR)-1))
        S DIE="^GMT(142.5,",DA=+($G(DA)) S GMTSED=0 W:+($G(GMTSDES))>0 !
        F GMTSI=1:1:3 Q:GMTSI>3  L +^GMT(142.5,+($G(DA))):0 H:'$T 1 I $T D
        . D ^DIE S GMTSED=1 S $P(^GMT(142.5,+DA,0),U,19)=$$NOW^XLFDT,GMTSI=4
        . S:$G(GMTSTIM)="@" $P(^GMT(142.5,+DA,0),U,4)=""
        I 'GMTSED S GMTSQ=1 K GMTSOBJ W !,"  Record Locked by another user" Q
        L -^GMT(142.5,+($G(DA))) S GMTST=+($P($G(^GMT(142.5,+DA,0)),U,3))
        K GMTSOBJ Q
        ;          
ALL     ; Print HS Header
        N X,Y,DIR,DIROUT,DUOUT,DTOUT S GMTSOBJ="",GMTSQ=0 D RP Q:+($G(GMTSQ))>0
        S DIR("A")=" Print standard Health Summary Header with the Object?  "
        S DIR("B")="N",DIR(0)="YAO",(DIR("?"),DIR("??"))="^D ALL^GMTSOBH"
        W ! D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1
        S:Y["^"!(X["^") GMTSE=1,GMTSQ=1,GMTSDES=0
        K:+($G(GMTSQ))>0!($D(DUOUT)) GMTSOBJ Q:+($G(GMTSQ))>0!($D(DUOUT))
        S X=+($G(Y)) K:+X>0 GMTSOBJ S:+X'>0 GMTSOBJ=""
        S GMTSOBJ("HEADER")=$S(+X'>0:1,1:0)
        I +X'>0 D
        . W ! D PART Q:+($G(GMTSQ))>1  W ! S GMTSLBL="" D LBL^GMTSOBA2
        . S GMTSLBL=$S($L($G(GMTSOBJ("LABEL"))):$G(GMTSOBJ("LABEL")),1:"@")
        . K:'$L($G(GMTSOBJ("LABEL"))) GMTSLBL,GMTSOBJ("LABEL BLANK LINE"),GMTSOBJ("USE LABEL")
        W ! D SC^GMTSOBA2 K:+($G(GMTSQ))>0 GMTSOBJ
        W ! D NODATA^GMTSOBA2 K:+($G(GMTSQ))>0 GMTSOBJ
        Q
        ;          
RP      ; Report Period
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF
        S GMTSTIM=$$RP^GMTSOBT($G(GMTSTI),$G(GMTSOI)) S:+GMTSTIM<0 GMTSQ=1
        Q
        ;                  
PART    ; Print Partial Header
        K:+($G(GMTSQ))>0 GMTSOBJ Q:+($G(GMTSQ))>0  W !," Partial Header:"
        D:$D(GMTSOBJ) RD,RC,RH,CH^GMTSOBA2,DE^GMTSOBA2 Q
RD      ;   Report Date
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF
        S GMTSDEF=$P($G(^GMT(142.5,+($G(GMTSDA)),0)),U,9)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N")
        S GMTSOBJ("DATE LINE")="",DIR("A")="   Print Report Date?  "
        S DIR("B")=GMTSDEF,DIR(0)="YAO",(DIR("?"),DIR("??"))="^D RD^GMTSOBH"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1
        S:Y["^"!(X["^") GMTSE=1,GMTSQ=1,GMTSDES=0
        K:+($G(GMTSQ))>0 GMTSOBJ("DATE LINE") Q:+($G(GMTSQ))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("DATE LINE") Q
RC      ;   Confidentiality Banner
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF
        S GMTSOBJ("CONFIDENTIAL")="",DIR("A")="   Print Confidentiality Banner?  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(GMTSDA)),0)),U,10)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N")
        S DIR("B")=GMTSDEF,DIR(0)="YAO",(DIR("?"),DIR("??"))="^D RC^GMTSOBH"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1
        S:Y["^"!(X["^") GMTSE=1,GMTSQ=1,GMTSDES=0
        K:+($G(GMTSQ))>0 GMTSOBJ("CONFIDENNTIAL") Q:+($G(GMTSQ))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("CONFIDENTIAL") Q
RH      ;   Report Header
        Q:+($G(GMTSQ))>0  N X,Y,DIR,DIROUT,DUOUT,DTOUT,GMTSDEF
        S GMTSOBJ("REPORT HEADER")="",DIR("A")="   Print Report Header?  "
        S GMTSDEF=$P($G(^GMT(142.5,+($G(GMTSDA)),0)),U,11)
        S GMTSDEF=$S(+GMTSDEF>0:"Y",1:"N")
        S DIR("B")=GMTSDEF,DIR(0)="YAO",(DIR("?"),DIR("??"))="^D RH^GMTSOBH"
        D ^DIR S:$D(DIROUT)!($D(DTOUT)) GMTSQ=1
        S:Y["^"!(X["^") GMTSE=1,GMTSQ=1,GMTSDES=0
        K:+($G(GMTSQ))>0 GMTSOBJ("REPORT HEADER") Q:+($G(GMTSQ))>0
        S X=+($G(Y)) K:+X'>0 GMTSOBJ("REPORT HEADER") Q
        ;          
CONT(X) ; Continue with Edit
        N DIR,DIROUT,DTOUT
        S DIR(0)="YAO",DIR("B")="NO",DIR("A")=" Do you want to edit the object?  Y/N  "
        D ^DIR S X=+($G(Y)) Q X
