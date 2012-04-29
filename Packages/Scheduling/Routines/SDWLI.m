SDWLI   ;BPOI/TEH - DISPLAY PENDING APPOINTMENTS;6/1/05
        ;;5.3;scheduling;**263,327,394,446,524,505**;08/13/93;Build 20
        ;
        ;
        ;******************************************************************
        ;                             CHANGE LOG
        ;
        ;   DATE               PATCH          DESCRIPTION
        ;   ----             -----             -----------
        ;   04/22/2005      SD*5.3*327  DISPLAY APPOINTMENT INFORMATION
        ;   04/22/2005      SD*5.3*327  UNDEFINED ERROR HD+1
        ;   08/07/2006      SD*5.3*446  proceed only when DFN defined
        ;   04/14/2006      SD*5.3*446  INTER-FACILITY TRANSFER
        ;
        ;
EN      ;NEW AND INITIALIZE VARIABLES
        S SDWLERR=0 N %DT,DD
        I $D(SDWLLIST),SDWLLIST D  Q:SDWLERR
        .I '$G(DFN) S SDWLERR=1 Q
        .I $D(DFN),DFN'="",'$D(^SDWL(409.3,"B",DFN)) D HD W *7,!,"This Patient has NO entries on the Electronic Wait List." S DIR(0)="E" D ^DIR S DUOUT=1 Q
        I $D(DUOUT) G END
        I 'SDWLERR,$D(SDWLLIST),SDWLLIST D 1^VADPT,DEM^VADPT S SDWLDFN=DFN D HD,SEL G END:$D(DUOUT) K DIR,DIC,DR,DIE,VADM S (SDWLBDT,SDWLEDT)="" K ^TMP("SDWLI",$J) G EN1
        K DIR,DIC,DR,DIE,VADM
        S (SDWLBDT,SDWLEDT)="" K ^TMP("SDWLI",$J)
        ;
        ;OPTION HEADER
        ;
        D HD
        ;
        ;PATIENT LOOK-UP FROM WAIT LIST PATIENT FILE (^SDWL(409.3,IEN,0).
        ;
        D SEL G EN:$D(DUOUT)
        D PAT Q:'$D(SDWLDFN)
        G END:SDWLDFN<0,END:SDWLDFN=""
        Q:$D(DUOUT)
EN1     K DIR,DIC,DR,DIE,SDWLDRG
        D GETFILE
        D DISP G EN:'$D(DUOUT)
        D END
        Q
PAT     ;PATIENT LOOK-UP
        ;PATCH SD*5.3*524 - SET DIC("S") FOR SCREEN OF OPEN/CLOSED ENTRIES
        K DIC,DIC("S")
        I $D(SDWLY),SDWLY S DIC("S")="I $P(^SDWL(409.3,+Y,0),U,17)=""O"""
        S DIC(0)="EMNQA",DIC=409.3 D ^DIC S (SDWLDFN,DFN)=$P(Y,U,2)
        G PATEND:SDWLDFN=""
        Q:Y<0
        Q:$D(DUOUT)
        D 1^VADPT
PATEND  Q
        ;
        ;PROMPT FOR DISPLAY 'OPEN' WAITING LIST ONLY OR PROMPT FOR BEGINNING AND ENDING DATES
        ;
SEL     K SDWLDRG S DIR(0)="Y" S DIR("A")="Do You Want to View Only 'OPEN' Wait Lists",DIR("B")="YES"
        S DIR("?")="'Yes' for 'Open' and these Patient Record have not been dispositioned and 'No' for all Records."
        W ! D ^DIR S SDWLY=Y W !
        I X["^" S DUOUT=1 Q
        I SDWLY=0 D SEL1
        Q
SEL1    K DIR,%DT(0) S SDWLDISC="",%DT="AE",%DT("A")="Start with Date Entered: " D ^%DT G SEL:Y<1 S SDWLBDT=Y
        S %DT(0)=SDWLBDT,%DT("A")="End with Date Entered: " D ^%DT G SEL1:Y<1 S SDWLEDT=Y,SDWLDRG="" K %DT(0),%DT("A")
        Q
        ;
GETFILE ;GET DATA - OPTIONAL DATE RANGE IF SDWLDBT AND SDWLEDT VALID DATE RANGE
        ;
        K ^TMP("SDWLI",$J),SDWLDISX S SDWLDA=0,SDWLCNT=0 F  S SDWLDA=$O(^SDWL(409.3,"B",SDWLDFN,SDWLDA)) Q:SDWLDA=""  D
        .S SDWLDATA=$G(^SDWL(409.3,SDWLDA,0)) I '$D(SDWLDRG),SDWLY,$P(SDWLDATA,U,17)["C" Q
        .I '$P(SDWLDATA,U,3) Q
        .N SDWLAPP S SDWLAPP="" I $D(^SDWL(409.3,SDWLDA,"SDAPT")) S SDWLAPP=^("SDAPT") D  ;app data
        ..S SDWLAPP=SDWLAPP_"~"_$P(SDWLDATA,U,23)
        .N SDOP,SDOP1 S SDOP="" I $D(^SDWL(409.3,SDWLDA,1)) S SDOP=^(1),SDOP1=$$GET1^DIQ(409.3,SDWLDA_",",29),$P(SDOP,U)=SDOP1
        .I $D(^SDWL(409.3,SDWLDA,"DIS")) D
        ..S SDWLDISX=$G(^SDWL(409.3,SDWLDA,"DIS")),SDWLDIS=$P(SDWLDISX,U,3),SDWLDDUZ=$P(SDWLDISX,U,2)
        ..S SDWLDDT=$P(^SDWL(409.3,SDWLDA,"DIS"),U,1)
        ..S SDWLDIDT="" I SDWLDDT'="" S SDWLDIDT=$E(SDWLDDT,4,5)_"/"_$E(SDWLDDT,6,7)_"/"_$E(SDWLDDT,2,3)
        .I $D(^SDWL(409.3,SDWLDA,"DNR")) D
        ..S SDREM=$G(^SDWL(409.3,SDWLDA,"DNR")) S SDREMD=$P(SDWLDATA,U,14),SDREMU=$P(SDWLDATA,U,15)
        ..S SDREMDD="" I SDREMD'="" S SDREMDD=$E(SDREMD,4,5)_"/"_$E(SDREMD,6,7)_"/"_$E(SDREMD,2,3)
        ..S SDREMR=$$GET1^DIQ(409.3,SDWLDA_",",18),SDREMRC=$$GET1^DIQ(409.3,SDWLDA_",",18.1,"I")
        .S SDWLST=$P(SDWLDATA,U,6),SDWLSP=$P(SDWLDATA,U,7),SDWLSS=$P(SDWLDATA,U,8),SDWLSC=$P(SDWLDATA,U,9),SDWLDT=$P(SDWLDATA,U,2)
        .S SDWLPROV=$P(SDWLDATA,U,13) I $D(SDWLDRG) D  I SDNOK Q
        ..S SDNOK=0
        ..I SDWLDT<SDWLBDT!(SDWLDT>SDWLEDT) S SDNOK=1 Q
        .;
        .;IF STATUS IS CLOSED DO NOT DISPLAY RECORD
        .;
        .S SDWLCNT=SDWLCNT+1,^TMP("SDWLI",$J,SDWLCNT)=SDWLDATA_"~"_SDWLDA
        .I $D(SDWLDISX) D
        ..S ^TMP("SDWLI",$J,SDWLCNT,"DIS")=SDWLDIS_"^"_SDWLDDUZ_"^"_SDWLDIDT
        ..I SDWLAPP>0 S ^TMP("SDWLI",$J,SDWLCNT,"SDAPT")=SDWLAPP
        ..I SDOP'="" S ^TMP("SDWLI",$J,SDWLCNT,"SDOP")=SDOP
        .I $D(SDREM) D
        ..S ^TMP("SDWLI",$J,SDWLCNT,"REM")=SDREMR_U_SDREMRC_U_SDREMU_U_SDREMDD
        .S ^TMP("SDWLI",$J)=SDWLCNT
        .K SDWLDISX,SDREM
        Q
        ;
DISP    ;Display Wait List Data
        S (SDWLDT,SDWLCNT,SDWLCN)="",SDWLCT=$G(^TMP("SDWLI",$J)) I 'SDWLCT W !!,"No 'OPEN' Wait List Records to Display.",!! K DIR S DIR(0)="E" D ^DIR S DUOUT="" Q
        F  S SDWLCNT=$O(^TMP("SDWLI",$J,SDWLCNT)) Q:SDWLCNT=""  D  I $D(DUOUT) Q
        .N SDWLDISX,SDWLR,SDWLCLPT
        .I $D(^TMP("SDWLI",$J,SDWLCNT,"DIS")) S SDWLDISX=$G(^TMP("SDWLI",$J,SDWLCNT,"DIS"))
        .I $D(^TMP("SDWLI",$J,SDWLCNT,"REM")) S SDWLR=$G(^TMP("SDWLI",$J,SDWLCNT,"REM")) D
        ..S SDREMR=$P(SDWLR,U),SDREMRC=$P(SDWLR,U,2),SDREMU=$P(SDWLR,U,3),SDREMDD=$P(SDWLR,U,4)
        .S X=$G(^TMP("SDWLI",$J,SDWLCNT)),SDWLDA=$P(X,"~",2),SDWLIN=$P(X,U,3),SDWLCL=$P(X,U,4),SDWLTY=$P(X,U,5),SDWLPRI=$P(X,U,11)
        .S SDWLTYP=$S(SDWLTY=1:$P(X,U,6),SDWLTY=2:$P(X,U,7),SDWLTY=3:$P(X,U,8),SDWLTY=4:$P(X,U,9),1:"")
        .S SDWLTYN=$S(SDWLTY=1:5,SDWLTY=2:6,SDWLTY=3:7,SDWLTY=4:8),SDWLCOM=$P($P(X,U,18),"~",1)
        .S SDWLDUZ=$P(X,U,10),SDWLPRV=$P(X,U,12),SDWLPROV=$P(X,U,13),SDWLX=$P(X,"~",3) D
        ..I $D(SDWLDISX) S SDWLDIS=$P(SDWLDISX,U,1),SDWLDDUZ=$P(SDWLDISX,U,2),SDWLDIDT=$P(SDWLDISX,U,3)
        .S SDWLDT=$P(X,U,2),YY=$E(SDWLDT,1,3)+1700,YY=$E(YY,3,4),MM=$E(SDWLDT,4,5),DD=$E(SDWLDT,6,7),SDWLDTP=MM_"/"_DD_"/"_YY
        .S SDWLDTD=$P(X,U,16),YY=$E(SDWLDTD,1,3)+1700,YY=$E(YY,3,4),MM=$E(SDWLDTD,4,5),DD=$E(SDWLDTD,6,7),SDWLDTD=MM_"/"_DD_"/"_YY
        .;PATCH SD*5.3*394 See Note.
        .N SDWLSCP
        .S SDWLSCP=+$P($G(^SDWL(409.3,SDWLDA,"SC")),U,2)
        .W !,"# ",$J(SDWLCNT,3),!
        .W !,"Wait List - ",$$EXTERNAL^DILFD(409.3,4,,SDWLTY),?55,"Date Entered - ",SDWLDTP
        .W !,?15 S X=$$EXTERNAL^DILFD(409.3,SDWLTYN,,SDWLTYP) W X
        .S SDWLP=0 I SDWLPRI W !,"Priority - ",$$EXTERNAL^DILFD(409.3,10,,SDWLPRI) S SDWLP=1
        .I $D(SDWLSCP) W !,"Service Connected Priority - ",$$EXTERNAL^DILFD(409.3,15,,SDWLSCP)
        .W:SDWLP ?15 W:'SDWLP ! W "Institution - ",$$EXTERNAL^DILFD(409.3,2,,SDWLIN)
        .W !,"Entered by - " S X=$$EXTERNAL^DILFD(409.3,9,,SDWLDUZ) W X
        .S SDWRB=0 I SDWLPRV W !,"Requested By - ",$$EXTERNAL^DILFD(409.3,11,,SDWLPRV),?55,"Date Desired - ",SDWLDTD
        .I SDWLPRV=1 W !,"Provider - ",$$EXTERNAL^DILFD(409.3,12,,SDWLPROV)
        .I $D(SDWLCOM),SDWLCOM'="" W !,"Comments - ",SDWLCOM
        .I $D(^TMP("SDWLI",$J,SDWLCNT,"SDOP")) N SDOP S SDOP=^("SDOP") W !,"Reopen Reason: ",$P(SDOP,U) D
        ..I $P(SDOP,U,2)'="" W !,"Reopen comment: ",$P(SDOP,U,2)
        .I $D(^TMP("SDWLI",$J,SDWLCNT,"REM")) W !,"Non Removal Reason - ",SDREMR,!,"Non Remove Reason entered by - ",$$GET1^DIQ(200,SDREMU_",",.01,"I") D
        ..I $L(SDREMRC)>0 W !,"Non Removal Comment - ",SDREMRC
        ..W !,"Non Removal entry date - ",SDREMDD
        .I $D(^TMP("SDWLI",$J,SDWLCNT,"DIS")) W !,"Disposition - ",$$EXTERNAL^DILFD(409.3,21,,SDWLDIS),?51,"Disposition Date - ",SDWLDIDT D
        ..W !,"Dispositioned by - ",$$EXTERNAL^DILFD(409.3,20,,SDWLDDUZ)
        .I $D(^TMP("SDWLI",$J,SDWLCNT,"SDAPT")) N SDAP S SDAP=^("SDAPT") D
        ..W !,"Appointment scheduled for " S Y=$P(SDAP,"~",2) D DD^%DT W Y
        ..W !?3,"Made on: " S Y=+SDAP D DD^%DT W Y,?30,"For clinic: " N SDC S SDC=$P(SDAP,U,2) S SDC=$$GET1^DIQ(44,SDC_",",.01) W SDC
        ..N SDAIN S SDAIN=$P(SDAP,U,3),SDAIN=$$GET1^DIQ(4,SDAIN_",",.01)
        ..W !?3,"Appt Institution: ",SDAIN
        ..N SDCR S SDCR=$P(SDAP,U,4),SDCR=$$GET1^DIQ(40.7,SDCR_",",.01)
        ..W ?40,"Appt Specialty: ",SDCR
        ..N SAPS S SAPS=$P(SDAP,U,8),SAPS=$P(SAPS,"~") I SAPS="CC" W !,"Appointment Status: Canceled by Clinic"
        .S SDWLCLPT=$$GET1^DIQ(409.3,SDWLDA,37,"I")  ; SD*5.3*446
        .D:SDWLCLPT  ; SD*5.3*446
        ..W !,"Clinic changed from: ",$$GET1^DIQ(409.3,SDWLCLPT,8)
        ..W:SDWLIN'=$$GET1^DIQ(409.3,SDWLCLPT,2,"I") " (",$$GET1^DIQ(409.3,SDWLCLPT,2),")"
        ..Q
        .; Inter-facility Transfer. SD*5.3*446
        .I $$GETTRN^SDWLIFT1(SDWLDA,.SDWLINNM,.SDWLSTN) D ENS^%ZISS W !,IOINHI,"In transfer to ",SDWLINNM," (",SDWLSTN,")",IOINORM D KILL^%ZISS
        .D GETS^DIQ(409.3,SDWLDA,"32;33;34;36;38;39","TMP")
        .K SDWLIN,SDWLCL,SDWLTY,SDWLPRI,SDWLDUZ,SDWLPRV,SDWLDT,SDWLDTD,SDWLDIS,SDWLDIDT,SDWLTYN,SDWLCOM,SDWLPROV,SDWLDISX,DIR,DIE,DR,SDWLINNM,SDWLSTN
        .W !,"*****",! K DIR S DIR(0)="E" D ^DIR  D
        ..I X["^" S DUOUT=1 Q
        ..I 'Y S DUOUT=1 Q
        ..;I '$G(SDWLLIST) D HD
        Q
HD      ;Header
        W:$D(IOF) @IOF W !!,?80-$L("Wait List - Inquiry")\2,"Wait List - Inquiry ",!
        ;SD*5.3*327 - Correct undefined.
        I '$D(SDWLDFN) W !! Q
        N DFN S DFN=SDWLDFN D DEM^VADPT
        W:$D(VADM) !,VADM(1),?40 I $D(VA("PID")) W VA("PID")
        W !!
        K DUOUT
        Q
END     ;
        K DIR,DIC,DR,DIE,SDWLDFN,DUOUT
        K SDNOK,SDWLBDT,SDWLCL,SDWLCN,SDWLCNT,SDWLCOM,SDWLCT,SDWLDA,SDWLDATA,SDWLDDT,SDWLDDUZ,SDWLDFN,SDWLDIDT,SDWLDIS,SDWLDISX
        K SDWLDRG,SDWLDT,SDWLDTD,SDWLDTP,SDWLDUZ,SDLWEDT,SDWLIN,SDLWP,SDWLPRI,SDWLPROV,SDLWPRV,SDWLSC,SDWLSP,SDWLSS,SDLWST,SDWLTY
        K SDWLTYN,SDSWLTYP,SDLWX,SDWLY,SDWRB,SDWLBDT,SDWLDISC,SDWLERR,SDWLPRON,SDXSCAT,SDWLP,SDWLTYP
        K SDREMD,SDREMDD,SDREMR,SDREMRC,SDREMU,MM,SDWLEDT,SDWLLIST,SDWLST,SDWLX,VA,X,Y,YY
        Q
