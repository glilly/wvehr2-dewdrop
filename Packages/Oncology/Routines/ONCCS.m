ONCCS   ;Hines OIFO/GWB - COLLABORATIVE STAGING ;11/20/03
        ;;2.11;ONCOLOGY;**40,43,44,47,48**;Mar 07, 1995;Build 13
        ;
        N DIR,X
        W !
        S DIR("A")=" Compute Collaborative Staging"
        S DIR(0)="Y",DIR("B")="Yes" D ^DIR
        I (Y=0)!(Y="")!(Y[U) S Y=$S(ONCOANS="A":"@4",1:"@0") Q
        ;
        S IEN=D0
        S $P(^ONCO(165.5,IEN,"CS1"),U,1,9)=U_U_U_U_U_U_U_U
        S $P(^ONCO(165.5,IEN,"CS1"),U,11)=""
        ;
        K INPUT,STORE,DISPLAY,STATUS,ONCSAPI
        D CLEAR^ONCSAPIE(1)
        S INPUT("AGE")=$$AGEDX^ONCACDU1(IEN)
        S:$L(INPUT("AGE"))=1 INPUT("AGE")="00"_INPUT("AGE")
        S:$L(INPUT("AGE"))=2 INPUT("AGE")=0_INPUT("AGE")
        S INPUT("BEHAV")=$E($$GET1^DIQ(165.5,IEN,22.3,"I"),5)
        S INPUT("EXT")=$$GET1^DIQ(165.5,IEN,30.2,"I")
        S INPUT("EXTEVAL")=$$GET1^DIQ(165.5,IEN,29.1,"I")
        S INPUT("GRADE")=$$GET1^DIQ(165.5,IEN,24,"I")
        S INPUT("HIST")=$E($$GET1^DIQ(165.5,IEN,22.3,"I"),1,4)
        S INPUT("LNPOS")=$$GET1^DIQ(165.5,IEN,32,"I")
        S:$L(INPUT("LNPOS"))=1 INPUT("LNPOS")=0_INPUT("LNPOS")
        S INPUT("LNEXAM")=$$GET1^DIQ(165.5,IEN,33,"I")
        S:$L(INPUT("LNEXAM"))=1 INPUT("LNEXAM")=0_INPUT("LNEXAM")
        S INPUT("METS")=$$GET1^DIQ(165.5,IEN,34.3,"I")
        S INPUT("METSEVAL")=$$GET1^DIQ(165.5,IEN,34.4,"I")
        S INPUT("NODES")=$$GET1^DIQ(165.5,IEN,31.1,"I")
        S INPUT("NODESEVAL")=$$GET1^DIQ(165.5,IEN,32.1,"I")
        S PS=$$GET1^DIQ(165.5,IEN,20,"I")
        S:PS'="" PS=$TR($$GET1^DIQ(164,PS,1,"I"),".","")
        S INPUT("SITE")=PS
        S INPUT("SIZE")=$$GET1^DIQ(165.5,IEN,29.2,"I")
        S INPUT("SSF1")=$$GET1^DIQ(165.5,IEN,44.1,"I")
        S INPUT("SSF2")=$$GET1^DIQ(165.5,IEN,44.2,"I")
        S INPUT("SSF3")=$$GET1^DIQ(165.5,IEN,44.3,"I")
        S INPUT("SSF4")=$$GET1^DIQ(165.5,IEN,44.4,"I")
        S INPUT("SSF5")=$$GET1^DIQ(165.5,IEN,44.5,"I")
        S INPUT("SSF6")=$$GET1^DIQ(165.5,IEN,44.6,"I")
        ;
        S RC=$$CALC^ONCSAPI3(.ONCSAPI,.INPUT,.STORE,.DISPLAY,.STATUS)
        I RC D PRTERRS^ONCSAPIE() R "Press return to continue",X:DTIME
        ;---
        S $P(^ONCO(165.5,IEN,"CS1"),U,1)=STORE("T")
        S $P(^ONCO(165.5,IEN,"CS1"),U,2)=STORE("TDESCR")
        S $P(^ONCO(165.5,IEN,"CS1"),U,3)=STORE("N")
        S $P(^ONCO(165.5,IEN,"CS1"),U,4)=STORE("NDESCR")
        S $P(^ONCO(165.5,IEN,"CS1"),U,5)=STORE("M")
        S $P(^ONCO(165.5,IEN,"CS1"),U,6)=STORE("MDESCR")
        S $P(^ONCO(165.5,IEN,"CS1"),U,7)=STORE("AJCC")
        S $P(^ONCO(165.5,IEN,"CS1"),U,8)=STORE("SS1977")
        S $P(^ONCO(165.5,IEN,"CS1"),U,9)=STORE("SS2000")
        S $P(^ONCO(165.5,IEN,"CS1"),U,11)=$G(STATUS("APIVER"))
        S:$P(^ONCO(165.5,IEN,"CS1"),U,12)="" $P(^ONCO(165.5,IEN,"CS1"),U,12)=$G(STATUS("APIVER"))
        D ^ONCPCS
        I $P(RC,U,1)=0 W !," Collaborative Staging was successful" Q
        I $P(RC,U,1)=-10 W !," CS server unavailable.  Contact IRM." Q
        I $P(RC,U,1)=-22 W !," Invalid COLLABORATIVE STAGING URL value in ONCOLOGY SITE PARAMETERS" Q
        I $P(RC,U,1)<0 W !," You have encountered a CS error" G CSERR
        I $P(RC,U,1)>0 W !," You have encountered a CS warning" G CSERR
        ;
CSERR   N DIR,X
        S DIR("A")="Do you wish to re-enter the CS input values"
        S DIR(0)="Y",DIR("B")="Yes" D ^DIR
        I Y=1 S Y="@292" Q
        I Y[U S Y="@0" Q
        S Y=$S(ONCOANS="A":"@4",1:"@0")
        Q
        ;
INIT    ;Initialize CS fields when HISTOLOGY (ICD-O-3) (165.5,22.3) changes
        S LNS=$O(^ONCO(164.2,"B","LUNG NOS",0))
        S LSC=$O(^ONCO(164.2,"B","LUNG SMALL CELL",0))
        S MEL=$O(^ONCO(164.2,"B","MELANOMA",0))
        S SITEGRP=$P($G(^ONCO(165.5,D0,0)),U,1)
        S OLDHST=$P($G(^ONCO(165.5,D0,2.2)),U,3)
        I X=OLDHST Q
        I SITEGRP=LNS D
        .I ($E(X,1,4)=8041)!($E(X,1,4)=8042)!($E(X,1,4)=8043)!($E(X,1,4)=8044)!($E(X,1,4)=8045)!($E(X,1,4)=8246) D  W !!," SITE/GP changed to LUNG SMALL CELL",!
        ..S $P(^ONCO(165.5,D0,0),U,1)=LSC
        ..K ^ONCO(165.5,"B",LNS,D0)
        ..S ^ONCO(165.5,"B",LSC,D0)=""
        I SITEGRP=LSC D
        .I ($E(X,1,4)'=8041)&($E(X,1,4)'=8042)&($E(X,1,4)'=8043)&($E(X,1,4)'=8044)&($E(X,1,4)'=8045)&($E(X,1,4)'=8246) D  W !!," SITE/GP changed to LUNG NOS",!
        ..S $P(^ONCO(165.5,D0,0),U,1)=LNS
        ..K ^ONCO(165.5,"B",LSC,D0)
        ..S ^ONCO(165.5,"B",LNS,D0)=""
        I SITEGRP'=MEL D
        .I (X'<87200)&(X<87910) D  W !!," SITE/GP changed to MELANOMA",!
        ..S $P(^ONCO(165.5,D0,0),U,1)=MEL
        ..K ^ONCO(165.5,"B",SITEGRP,D0)
        ..S ^ONCO(165.5,"B",MEL,D0)=""
        I SITEGRP=MEL D
        .I (X<87200)!(X>87900) D
        ..W !
        ..W !," WARNING: SITE/GP and HISTOLOGY discrepancy"
        ..W !,"          SITE/GP   = MELANOMA"
        ..W !,"          HISTOLOGY = ",$P(Y,U,1),"  ",$P(Y,U,2)
        ..W !
        I OLDHST="" Q
        S HSTI=$$HIST^ONCFUNC(D0)
        S TEXT=HISTNAM
        S $P(^ONCO(165.5,D0,8),U,2)=$E(TEXT,1,40)
        I $P($G(^ONCO(165.5,D0,0)),U,16)<3040000 Q
        W !
        W !?3,"You have changed the HISTOLOGY (ICD-O-3).  This change may"
        W !?3,"affect the validity of the COLLABORATIVE STAGING data."
        W !?3,"Therefore, the CS fields have been initialized and need to"
        W !?3,"be re-entered."
        W !
        F PIECE=1:1:12 S $P(^ONCO(165.5,D0,"CS"),U,PIECE)=""
        F PIECE=1:1:11 S $P(^ONCO(165.5,D0,"CS1"),U,PIECE)=""
        Q
