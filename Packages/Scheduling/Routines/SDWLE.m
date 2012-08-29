SDWLE   ;BPOI/TEH - WAITING LIST-ENTER/EDIT;06/12/2002
        ;;5.3;scheduling;**263,415,446,524**;08/13/93;Build 29
        ;
        ;
        ;******************************************************************
        ;                             CHANGE LOG
        ;                                               
        ;   DATE                        PATCH                   DESCRIPTION
        ;   ----                        -----                   -----------
        ;   09JUN2005                   446                     Inter-Facility Transfer.
        ;   
        ;   
EN      ;ENTRY POINT - INTIALIZE VARIABLES
        N DTOUT,%
        I $D(SDWLOPT),SDWLOPT G OPT
        I $D(SDWLLIST),SDWLLIST,$D(DFN),DFN<0 K SDWLLIST
        I $D(SDWLLIST),SDWLLIST,$D(DFN),DFN'="" S SDWLDFN=DFN D 1^VADPT S (SDWLTEM,SDWLPOS)=0 D HD,SB1 G EN1:'$D(DUOUT) W !,"PATIENT: ",VADM(1),?40,VA("PID") W !,*7,"PATIENT'S DATE OF DEATH HAS BEEN RECORDED" S DIR(0)="E" D ^DIR G END
        K ^TMP("SDWLD",$J) D HD
        D PAT G END:DFN<0
OPT     S SDWLPCMM=0,SDWLERR=0 I $D(SDWLOPT),SDWLOPT D
        .S %=2 W !,"DO YOU WISH TO PLACE THIS PATIENT ON A WAITING LIST " D YN^DICN
        .I %=-1!(%=2) S SDWLERR=1 Q
        I $D(SDWLOPT),SDWLOPT,SDWLERR Q
        S SDWLDFN=DFN
        D 1^VADPT
        S (SDWLTEM,SDWLPOS)=0
EN1     N SDWLNEW,SDWLERR,SDWLCN,SDWLWTE S SDWLNEW=0,SDWLERR=0,SDWLCN=0,SDWLWTE=0
        G:$$EN^SDWLE6(SDWLDFN,.SDWLERR) EN2  ; OG ; SD*5.3*446 ; Inter-facility transfer
        D DIS
        I $D(^SDWL(409.3,"B",DFN)),'SDWLCN W !!,"PATIENT: ",VADM(1),?40,VA("PID")
        S SDWLPS=$S(SDWLCN>1:1,SDWLCN=1:2,1:3)
        I $D(SDWLOPT),SDWLOPT,SDWLPS=3 S X="Y" G ENO
        I SDWLPS=1 S DIR(0)="FOA^^" S DIR("A")="Select Wait List (1-"_SDWLCN_") or Enter 'N' for New or '^' to Quit ? ",DIR("?")="Enter a Valid Number or 'N' for New."
        I SDWLPS=2 S DIR(0)="FOA^^" S DIR("A")="Select Wait List (1) or Enter 'N' for New or '^' to Quit ? ",DIR("?")="Enter a '1' or 'N' for New."
        I SDWLPS=3 S DIR(0)="YAO^^S X=""Y""" S DIR("A")="Patient is not on Waiting List. Do you wish to Add Patient? Yes// "
        W ! D ^DIR W ! K DIR
        G END:$D(DUOUT),END:$D(DTOUT)
        I SDWLPS=1 D  G EN3:SDWLERR=1 I SDWLERR=2 W *7," ??" G EN1
        .S SDWLERR=$S(X?1"N".E:0,X?1"n".E:0,X="":2,$D(DUOUT):1,X["^":1,$D(^TMP("SDWLD",$J,DFN,+X)):0,1:2) Q
        I SDWLPS=2 D  G EN3:SDWLERR=1 I SDWLERR=2 W *7," ??" G EN1
        .S SDWLERR=$S(X?1"N".E:0,X?1"n".E:0,X="":2,$D(DUOUT):1,X["^":1,$D(^TMP("SDWLD",$J,DFN,+X)):0,1:2) Q
ENO     I SDWLPS=3 D  G EN3:SDWLERR=1 I SDWLERR=2 W *7," ??" G EN1
        .S SDWLERR=$S(X?1"N".E:1,X?1"n".E:1,X="":0,X?1"Y".E:0,X?1"y".E:0,$D(DUOUT):1,X["^":1,1:2) Q
        I SDWLPS=1!(SDWLPS=2),X?1N.N D
        .N DA,SDWLDA S (DA,SDWLDA)=$P($G(^TMP("SDWLD",$J,DFN,+X)),"~",2),SDWLEDIT=""
        .;
        .;LOCK DATA FILE
        .;
        .L +^SDWL(409.3,DA):5 I '$T W !,"ANOTHER TERMINAL IS EDITING THIS ENTRY. TRY LATER." S DUOUT=1
        .I $D(DUOUT) Q
        .N SDWLINNM,SDWLSTN  ; OG ; This and the following six lines added for patch 415
        .I $$GETTRN^SDWLIFT1(SDWLDA,.SDWLINNM,.SDWLSTN) D  S DUOUT=1 Q
        ..N SDWLMSG,SDWLI
        ..S SDWLMSG(0)=1,SDWLMSG(SDWLMSG(0),0)="This entry is the subject of a transfer to "_SDWLINNM_" ("_SDWLSTN_"). Editing inhibited."
        ..I $L(SDWLMSG(SDWLMSG(0),0))>80 D COL80^SDWLIFT(.SDWLMSG)
        ..F SDWLI=1:1:SDWLMSG(0) W !,SDWLMSG(SDWLI,0)
        ..Q
        .D EN^SDWLE10
        .D EDIT W !!,"Editing is Completed" S SDWLERR=1 K SDWLEDIT
        G END:SDWLERR
        I SDWLPS=1!(SDWLPS=2),X?1"N".E!(X?1"n".E) D NEW,EDIT S SDWLNEW="" G EN2
        I SDWLPS=3 D NEW,EDIT S SDWLNEW=""
EN2     I $D(SDWLNEW),'$D(DUOUT),'SDWLERR W !!,?15,"*** Patient has been added to Wait List ***",!
        K SDWLNEW,DUOUT
        ;
        ;UNLOCK FILE AND KILL LOCAL VARIABLES
        ;
        I $D(SDWLDA) L -^SDWL(409.3,SDWLDA)
        ;-exit logic
EN3     D END^SDWLE113
        Q
END     D END^SDWLE113
        D EN^SDWLKIL
        Q 
        ;
        ;
PAT     ;SELECT PATIENT
        ;
        S DIC(0)="EMNZAQ",DIC=2 D ^DIC S (SDWLDFN,DFN)=$P(Y,U,1) G PAT1:DFN<0
        S X=$$GET1^DIQ(2,DFN_",",".351") I X'="" W !,*7,"PATIENT'S DATE OF DEATH HAS BEEN RECORDED" G PAT
        S SDWLSSN=$G(VA("PID")),SDWLNAM=$G(VA(1))
PAT1    K VADM,VAIN,VAERR,VA Q
        ;
DIS     ;DISPLAY DATA FOR PATIENT
        ;
        S SDWLHDR="Wait List Enter/Edit"
        D EN^SDWLD(DFN,VA("PID"),VADM(1))
        D PCM^SDWLE1,PCMD^SDWLE1
        Q
        ;
NEW     ;
        D NEW^SDWLE11
        Q
        ;
EDIT    ;
        D EN^SDWLE111 I $D(DUOUT) D END^SDWLE113:'$D(SDWLEDIT) Q
        I SDWLTYE=4 D ED4 K DIR,DIE,DIC,DR Q
        I SDWLTYE=3 D ED3 K DIR,DIE,DIC,DR Q
        I SDWLTYE=2 D ED2 K DIR,DIE,DIC,DR Q
        I SDWLTYE=1 D ED1 K DIR,DIE,DIC,DR Q
        Q
ED1     ;-team       
        I $D(DUOUT) D END^SDWLE113:'$D(SDWLEDIT) Q
        D EN^SDWLE3 I '$D(DUOUT) D EN^SDWLE113 Q
        Q
ED2     ;-position
        I $D(DUOUT) D END^SDWLE113:'$D(SDWLEDIT) Q
        D EN^SDWLE5 I '$D(DUOUT) D EN^SDWLE113 Q
        Q
ED3     ;-specialty  
        D EN^SDWLE2 I $D(DUOUT) D END^SDWLE113:'$D(SDWLEDIT) Q
        D EN^SDWLE110 I $D(DUOUT) D END^SDWLE113:'$D(SDWLEDIT) Q
        I '$D(DUOUT) D EN^SDWLE113
        D END^SDWLE113
        Q
ED4     ;-clinic
        D EN^SDWLE4 I $D(DUOUT) D END^SDWLE113:'$D(SDWLEDIT) Q
        D EN^SDWLE110 I $D(DUOUT) D END^SDWLE113:'$D(SDWLEDIT) Q
        I '$D(DUOUT) D EN^SDWLE113
        D END^SDWLE113
        Q
        ;
ED5     D END^SDWLE113
        Q
SB1     S X=$$GET1^DIQ(2,DFN_",",".351") I X'="" S DUOUT=""
        Q
HD      W:$D(IOF) @IOF W !,?80-$L("Scheduling/PCMM Enter/Edit Wait List")\2,"Scheduling/PCMM Enter/Edit Wait List",!!
        I $D(DFN),DFN'="",'$D(^SDWL(409.3,"B",DFN)),$D(SDWLLIST),SDWLLIST D
        .W !!,"PATIENT: ",VADM(1),?40,VA("PID")
        Q
