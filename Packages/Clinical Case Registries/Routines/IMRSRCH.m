IMRSRCH ;ISC-SF/JLI,HCIOFO/FT-CREATE SEARCH LIST FOR IMR MEMBERS IN PT FILE ;10/16/97  16:20
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
 ;[IMR SEARCH TEMPLATE] - Create Search Template Containing Study Members
 I '$D(^XUSEC("IMRA",DUZ)) S IMRLOC="IMRSRCH" D ACESSERR^IMRERR,H^XUS
TOP S IMRTNAM="",IMROUT=0,IMRDONE=0
 F I=0:0 Q:IMROUT!IMRDONE  S IMRTNAM=$O(^DIBT("F158.90",IMRTNAM)) Q:IMRTNAM=""  F J=0:0 S J=$O(^DIBT("F158.90",IMRTNAM,J)) Q:J'>0  I $D(^DIBT(J,0)),$P(^(0),U,5)=DUZ S X=$P(^(0),U,2) D CHEK Q:IMROUT  I "Yy"[X S IMRDONE=1 Q
 G:IMROUT EXIT S DA=$S(IMRTNAM="":-1,1:J)
ASK I DA'>0 W !,"Enter a non-descriptive sort template name that will contain the patient",!,"identities: " R X:DTIME G:'$T!(X[U)!(X="") EXIT S IMRTNAM=X I X["?" D QUERY G ASK
 I $D(^DIBT("F2",IMRTNAM)),'IMRDONE S DA=$O(^DIBT("F2",IMRTNAM,0)) W !,$C(7),"THERE IS ALREADY DATA STORED IN THAT TEMPLATE -- REPLACE ?? NO// " R Y:DTIME G:'$T!(Y[U) EXIT S:Y="" Y="N" S Y=$E(Y),IMRDONE=1 I "Yy"'[Y S DA=-1,IMRDONE=0 G ASK
 I DA'>0 S X=""""_IMRTNAM_"""",DIC=.401,DIC(0)="L",DLAYGO=.401 D ^DIC G:Y'>0 EXIT S DA=+Y
 W:'$D(ZTQUEUED) ! S DIE=.401,DR="2///T;"_$S(IMRDONE:"",1:"4///2;")_"5///"_DUZ_";7///T;" D ^DIE
 K ^DIBT(DA,1) S ^DIBT("F158.90",IMRTNAM,DA)=""
 K DIR S DIR(0)="Y",DIR("A")="Do you want to Queue this task (it may take a while) ",DIR("B")="YES" D ^DIR K DIR
 I Y S ZTRTN="DQSRCH^IMRSRCH",ZTIO="",ZTDESC="Generate Search List",ZTSAVE("DA")="",ZTSAVE("IMRSTN")="",ZTSAVE("IMRTNAM")="" D ^%ZTLOAD K ZTRTN,ZTSK,ZTIO,ZTDESC,ZTSAVE G EXIT
 W !,"Well, All right.... I'm working as fast as I can...",!
DQSRCH ;
 F I=0:0 S I=$O(^IMR(158,I)) Q:I'>0  S X=$P(^(I,0),U) D ^IMRXOR S ^DIBT(DA,1,X)="" W:'$D(ZTQUEUED) "."
 I '$D(ZTQUEUED) W !!,"The entries are now stored in the template [",IMRTNAM,"]",!,"for use with the FileMan PRINT option",!
 ;
EXIT K %,%DT,DQ,DA,DIE,DIC,DR,I,DLAYGO,IMRLOC,IMROUT,IMRDONE,IMRTNAM,DIK,IMRX,J,Y,IMRSTN,D,D0,DI,X,X1,DISYS,POP,DIR,DIROUT,DIRUT,DTOUT,DUOUT
 Q
QUERY ;
 W !!,"Enter a Name by which the search template for the PATIENT file can be",!,"identified.  This should probably not include HIV or other HIV specific",!,"text.",!
 Q
 ;
CHEK ;
 W !!,"You already have the search template [",IMRTNAM,"]",!,"from ",$E(X,4,5),"-",$E(X,6,7),"-",$E(X,2,3),!!,"Do you wish to UPDATE it? YES// "
 S IMROUT=0 R Z:DTIME S:'$T!(Z[U) IMROUT=1 Q:IMROUT  S:Z="" Z="Y" S Z=$E(Z) I "YyNn"'[Z W:Z'="?" $C(7),"  ??" W !?10,"Enter YES to update the template, NO to keep it as is, ^ to exit" G CHEK
 S X=Z K Z
 Q
 ;
SHOW ;[IMR TEMPLATE LIST] - List Search Templates for Package
 ; Show search templates for IMR file, with user, date created,
 ; last date used
 S IMRDONE=0,IMRTNAM="",IMROUT=0
 W:$Y>0 @IOF
 W !,"Template List as of ",$$FMTE^XLFDT($$NOW^XLFDT(),1),!
 F I=0:0 S IMRTNAM=$O(^DIBT("F158.90",IMRTNAM)) Q:IMRTNAM=""!(IMROUT)  F J=0:0 S J=$O(^DIBT("F158.90",IMRTNAM,J)) Q:J'>0!(IMROUT)  D SHOW1
 I 'IMROUT D PRTC
 W ! D EXIT
 Q
 ;
SHOW1 I '$D(^DIBT(J,0)) K ^DIBT(J),^DIBT("F158.90",IMRTNAM,J),^DIBT("F2",IMRTNAM,J) Q
 I 'IMRDONE W !!,"TEMPLATE NAME",?30,"CREATED BY",?60,"CREATED",?69,"LAST USED",! S IMRDONE=1
 S X=^DIBT(J,0),X1=$P(X,U,2),X2=$P(X,U,7),X3=$P(X,U,5),X3=$S('$D(^VA(200,+X3,0)):"UNKNOWN",1:$P(^(0),U))
 I $Y>(IOSL-4) D PRTC Q:IMROUT  W @IOF
 W !,$P(X,U),?30,X3,?60,$E(X1,4,5),"-",$E(X1,6,7),"-",$E(X1,2,3),?70,$E(X2,4,5),"-",$E(X2,6,7),"-",$E(X2,2,3)
 K X,X1,X2,X3
 Q
 ;
DELETE ;[IMR TEMPLATE DELETE] - Delete a Package Search Template
 R !!,"Enter Template Name containing Immunology Study Patients: ",X:DTIME
 G:'$T!(X="")!(X[U) EXIT
 K DA S DA=0
 I $D(^DIBT("F158.90",X)) S DA=DA+1,DA(DA,+$O(^(X,0)))=X
 S X1=X
 F I=0:0 S X=$O(^DIBT("F158.90",X)) Q:X=""!($E(X,1,$L(X1))'=X1)  S DA=DA+1,DA(DA,+$O(^(X,0)))=X
 I DA'>0 W:$E(X1)'="?" $C(7),"  ??" W !,"Select from:" D SHOW G DELETE
 I DA=1 S J=$O(DA(1,0)),X=DA(1,J) S X=$E(X,$L(X1)+1,$L(X)) W:X'="" X,!
ASKDEL I DA>1 W !!,"Select from:" F I=1:1:DA S J=$O(DA(I,0)),X=DA(I,J) W !?10,$J(I,2),"   ",X
 I DA>1 W !!,"Select from 1 to ",DA,":  " R X:DTIME Q:'$T!(X="")!(X[U)  G:X'=+X!(X<1)!(X>DA) ASKDEL S J=$O(DA(X,0)),DA(1,J)=DA(X,J),DA=1
 S J=$O(DA(1,0)),IMRX=DA(1,J)
 W !!,"Ready to DELETE the template ",IMRX," (Y/N)? N//" R X:DTIME
 Q:'$T!(X[U)
 S:X="" X="N" S X=$E(X)
 W:"YyNn"'[X $C(7),!,"Enter YES or NO or '^' to exit"
 G:"YyNn"'[X ASKDEL
 I "Nn"[X W $C(7),!!?20,"NOTHING DELETED" G DELETE
 K DA S DA=J,DIK="^DIBT(" D ^DIK
 K ^DIBT("F158.90",IMRX)
 G DELETE
PRTC ; press return to continue
 Q:$E(IOST)'="C"
 Q:$D(IO("S"))
 K DIR S DIR(0)="E" D ^DIR K DIR S:$D(DIRUT)!(Y=0) IMROUT=1
 Q
