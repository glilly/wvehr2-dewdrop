SDWLFUL ;;IOFO BAY PINES/TEH - REPAIR/RE-CAL ENROLLE STATUS;06/12/2002 ; 20 Aug 20022:10 PM
        ;;5.3;scheduling;**525**;AUG 13 1993;Build 47
        ;
        ;
        ;
        ;
        ;
        ;
        ;=========================================================================================================
        ;
        ;Foreign file upload utility for KLF data.
        ;
        ;
        ;
        Q
EN      ;Initial variables
        ;
        I '$D(^XTMP("SDWLFULSTAT",$J,"1B")) W !,"You must run a BACK-UP before running this option." Q
        I $D(^XTMP("SDWLFULSTAT",$J,2)) W !,"You have already run this option." D  I 'Y Q
        .S DIR(0)="Y",DIR("A")="Are you absolutely sure you want to continue",DIR("B")="N" D ^DIR D
        ..I X["^" S Y=0 Q
        ..I X["N"!(X["n") S Y=0 Q
        S STIME=$H,SDWLCNT=0
        S SDHAN="VSSCFILE",SDFILNM="FLAK9.CSV;1",SDPATH="USER$:[TEMP]",SDMOD="R"
        S DIR("A")="PATH: ",DIR("B")=SDPATH,DIR(0)="F" D ^DIR
        S SDPATH=Y
        K ^XTMP("SDWLFUL")
        D OPEN^%ZISH(SDHAN,SDPATH,SDFILNM,SDMOD)
        Q:POP  S L=0
        F I=1:1 U IO R X:DTIME Q:X=""  D EN0,DOT
END     S ETIME=$H
        D CLOSE^%ZISH(SDHAN) S:$D(ZTQUEUED) ZTREQ="@" W !,"Transfer Complete"
        K DIR,I,POP,SDFILNM,SDHAN,SDMOD,SDPATH,SDWLCNT,SDWLCTD,SDWLICN,SDWLINS
        K SDWLLD,SDWLLDT,SDWLOD,SDWLODT,SDWLSSN,STIME,X,Y,ZTQUEUED,ZTREQ,ETIME,L
        S ^XTMP("SDWLFULSTAT",$J,2)=""
        Q
EN0     ;
        S SDWLICN=$P(X,",",1),SDWLODT=$P(X,",",2),SDWLLDT=$P(X,",",3),SDWLSSN=$P(X,",",4),SDWLINS=$P(X,",",5) D
        .I '$D(^DPT("SSN",SDWLSSN)) Q
        .S X=SDWLODT D ^%DT S SDWLOD=Y,X=SDWLLDT D ^%DT S SDWLLD=Y
        .I '$D(^XTMP("SDWLFUL",$J,SDWLSSN,SDWLOD)) S ^XTMP("SDWLFUL",$J,SDWLSSN,SDWLOD)=SDWLLD_"^"_SDWLINS Q
        .I $D(^XTMP("SDWLFUL",$J,SDWLSSN,SDWLOD)) I SDWLLD'>SDWLOD D
        ..S SDWLCTD=$P($G(^XTMP("SDWLFUL",$J,SDWLSSN,SDWLOD)),U) D
        ...I SDWLLD>SDWLCTD&(SDWLLD'>SDWLOD) S ^XTMP("SDWLFUL",$J,SDWLSSN,SDWLOD)=SDWLLD_"^"_SDWLINS
        Q
DOT     S SDWLCNT=SDWLCNT+1 I SDWLCNT#10000=0 U $P W SDWLCNT,! U IO
        Q
