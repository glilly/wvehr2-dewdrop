DVBAB70 ;ALB/SPH - CAPRI C&P EXAM INQUIRY ;09/08/00
        ;;2.7;AMIE;**35,42,57,136**;Apr 10, 1995;Build 2
        ;
STRT(ZMSG,DFN,ZREQDA)   ;
        S DVBABCNT=0
        K ^TMP($J) S Y=DT X ^DD("DD") S FDT(0)=Y D HOME^%ZIS S FF=IOF
        S DIC="^DVB(396.3,"
        S DIC(0)="M"
        S DIC(1)=ZREQDA
        S Y=ZREQDA
        S JI=$P(Y,U,2),(DA,DA(1),REQDA)=+Y
        S (NAME,SSN,CNUM,ADR1,ADR2,ADR3,CITY,STATE,ZIP,HOMPHON,BUSPHON,OTHDIS)=""
        D VARS^DVBCUTIL
        G START
CON     ;
        I IOST?1"P-".E,$Y>45 W @IOF D HDR
        Q
START   S PGHD="",PG=0
        S ZMSG(DVBABCNT)="                     COMPENSATION AND PENSION EXAM INQUIRY",DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="                     -------------------------------------",DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="",DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="",DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="            Name: "_PNAM,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="             SSN: "_SSN,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="        C-Number: "_CNUM,DVBABCNT=DVBABCNT+1
        S Y=DOB X ^DD("DD")
        S ZMSG(DVBABCNT)="             DOB: "_Y,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="         Address: "_ADR1,DVBABCNT=DVBABCNT+1
        I ADR2'="" S ZMSG(DVBABCNT)="                  "_ADR2,DVBABCNT=DVBABCNT+1
        I ADR3'="" S ZMSG(DVBABCNT)="                  "_ADR3,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="City,State,Zip+4: "_CITY_", "_STATE_" "_ZIP,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="       Res Phone: "_HOMPHON,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="       Bus Phone: "_BUSPHON,DVBABCNT=DVBABCNT+1
        S EDTA=$S($D(^DPT(DFN,.32)):^(.32),1:""),EOD=$P(EDTA,U,6),RAD=$P(EDTA,U,7)
        S Y=EOD X ^DD("DD") S:Y="" Y="Not specified"
        S ZMSG(DVBABCNT)="Entered active service: "_Y,DVBABCNT=DVBABCNT+1
        S Y=RAD X ^DD("DD") S:Y="" Y="Not specified"
        S ZMSG(DVBABCNT)="Released active service: "_Y,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="================================================================================",DVBABCNT=DVBABCNT+1
        W !! D CON Q:$D(OUT)  D ^DVBAB97,CON Q:$D(OUT)  D ^DVBAB68,CON Q:$D(OUT)  S REQDT=$P(^DVB(396.3,REQDA,0),U,2)
        S Y=REQDT X ^DD("DD")
        S ZMSG(DVBABCNT)="This request was initiated on "_$P(Y,"@",1)_" at "_$P(Y,"@",2),DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="Requester: "_REQN,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="Requesting Regional Office: "_RONAME,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="VHA Division Processing Request: "_$P($$SITE^VASITE(,$P(^DVB(396.3,REQDA,1),U,4)),U,2),DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="",DVBABCNT=DVBABCNT+1
        I $D(^DVB(396.4,"C",REQDA)) S ZMSG(DVBABCNT)="Exams on this request: ",DVBABCNT=DVBABCNT+1 D TST^DVBAB96 ;DVBCUTL2 
        I '$D(^DVB(396.4,"C",REQDA)) S ZMSG(DVBABCNT)="(No exams have yet been entered)",DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="",DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="** Status of request: ",DVBABCNT=DVBABCNT+1
        S (XSTAT,STAT)=$P(^DVB(396.3,REQDA,0),U,18)
        S STAT=$S(XSTAT="N":"New",XSTAT="P":"Pending, reported to MAS",XSTAT="T":"Transcribed",XSTAT="S":"Scheduled",XSTAT="R":"Released, not printed",XSTAT="C":"Completed",XSTAT="CT":"Completed, transferred out",XSTAT="NT":"New, transferred in",1:"")
        I STAT]"" S ZMSG(DVBABCNT)=STAT,DVBABCNT=DVBABCNT+1
        I XSTAT="R"!(XSTAT="C") S Y=$P(^DVB(396.3,REQDA,0),U,14) X ^DD("DD") S RELBY=$P(^DVB(396.3,REQDA,0),U,15),RELBY=$S($D(^VA(200,+RELBY,0)):$P(^(0),U,1),1:"Unknown user") S ZMSG(DVBABCNT)="Released on "_Y_" by "_RELBY,DVBABCNT=DVBABCNT+1
        I XSTAT="C" S Y=$P(^DVB(396.3,REQDA,0),U,16) X ^DD("DD") S PRBY=$P(^DVB(396.3,REQDA,0),U,17),PRBY=$S($D(^VA(200,+PRBY,0)):$P(^(0),U,1),1:"Unknown user") S ZMSG(DVBABCNT)="Printed by the RO on "_Y_" by "_PRBY,DVBABCNT=DVBABCNT+1
        I STAT="" S STAT=$S(XSTAT="X":"Cancelled by MAS",XSTAT="RX":"Cancelled by RO",1:"Unknown") S ZMSG(DVBABCNT)=STAT,DVBABCNT=DVBABCNT+1
        I STAT["Cancelled" S CANDT=$P(^DVB(396.3,REQDA,0),U,19) S ZMSG(DVBABCNT)="  (Cancelled on "_$$FMTE^XLFDT(CANDT,"5DZ")_")",DVBABCNT=DVBABCNT+1
        I $D(^DVB(396.3,REQDA,1)),$P(^(1),U,3)="Y" S ZMSG(DVBABCNT)="This request was faxed to the regional office.",DVBABCNT=DVBABCNT+1
        S FEXAM=$P(^DVB(396.3,REQDA,0),U,9) I FEXAM="Y" S ZMSG(DVBABCNT)="*** Exams done on a FEE BASIS ***  ",DVBABCNT=DVBABCNT+1 K FEXAM
        S ZMSG(DVBABCNT)="--------------------------------------------------------------------------------",DVBABCNT=DVBABCNT+1
        D DDIS Q:$D(OUT)  D CON Q:$D(OUT)
        I IOST?1"P-".E,$Y>45 W @IOF D HDR
        S ZMSG(DVBABCNT)="Other Disabilities: "_OTHDIS,DVBABCNT=DVBABCNT+1 I $D(^DVB(396.3,REQDA,1)) S ZMSG(DVBABCNT)="                    "_OTHDIS1,DVBABCNT=DVBABCNT+1 S ZMSG(DVBABCNT)="                    "_OTHDIS2,DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="General Remarks:",DVBABCNT=DVBABCNT+1
        K ^UTILITY($J,"W")
        F LINE=0:0 S LINE=$O(^DVB(396.3,REQDA,2,LINE)) Q:LINE=""  S X=^(LINE,0),DIWL=5,DIWR=75,DIWF=$S(X["|":"NWX",1:"NW") D ^DIWP S ZMSG(DVBABCNT)=X,DVBABCNT=DVBABCNT+1
END        K ^TMP($J),TSTA1,TSTAT,XCNP
        Q
DDIS1   S ZMSG(DVBABCNT)=DX_"  "_$J(PCT,3,0)_" %",DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="    Service-Connected? "_$S(SC=1:"Yes",1:"No")_"  DX Code: "_DXCOD,DVBABCNT=DVBABCNT+1
        I $Y>19 D CON
        Q
DDIS    I $Y>12 D CON Q:$D(OUT)
        I '$D(^DPT(DFN,.372)) S ZMSG(DVBABCNT)="No rated disabilities on file",DVBABCNT=DVBABCNT+1 Q
        S ZMSG(DVBABCNT)="",DVBABCNT=DVBABCNT+1
        S ZMSG(DVBABCNT)="RATED DISABILITIES:",DVBABCNT=DVBABCNT+1
        F JII=0:0 S JII=$O(^DPT(DFN,.372,JII)) Q:JII=""  S DXNUM=$P(^DPT(DFN,.372,JII,0),U,1),PCT=$P(^(0),U,2),SC=$P(^(0),U,3),DX=$S($D(^DIC(31,DXNUM)):$P(^(DXNUM,0),U,1),1:"Unknown"),DXCOD=$S($D(^DIC(31,DXNUM)):$P(^(DXNUM,0),U,3),1:"Unknown") D DDIS1
        S ZMSG(DVBABCNT)="",DVBABCNT=DVBABCNT+1
        Q
HDR     S PG=PG+1 W:(IOST?1"C-".E) @IOF
        S ZMSG(DVBABCNT)="================================================================================",DVBABCNT=DVBABCNT+1
        Q
