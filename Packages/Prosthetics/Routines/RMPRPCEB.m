RMPRPCEB        ;HIN/RVD-PROS PCE BACKGROUND UTILITY ; 1/23/04 8:09am
        ;;3.0;PROSTHETICS;**62,69,77,82,78,114,120,133,142,145**;Feb 09, 1996;Build 6
        ;
        ;RVD patch #69 - add STATION in the error message.
        ;                QUIT if no data in specified date range.
        ;RVD patch #77 - only create 1 PCE entry for the same pt & same day.
        ;
        ;KAM Patch #82 06/21/2004 - Add more robust text to 'Missing
        ;                           Prosthetics Clinic PCE error message
        ;
        ;WLC Patch #78 02/03/3005 - added NEW statement for error message
        ;                           variables defined for Patch 82.
        ;
        W !,"Invalid Entry Point.....",!
        Q
OPTION  ;entry point for menu option
        Q
TASK    ;entry point for task job to send pros encounters to PCE.
        ;Quit entered below so if site tasks job it will never run
        Q
        N RERRMSG,RERRMSG2  ; correction for patch 82  02/03/05 WLC
        S IO=0,RMAIL=1,SVDUZ=DUZ,DUZ=.5
        S Y=DT D DD^%DT S RMRDAT=Y K RMX,RMXMT,^TMP($J)
        D NOW^%DTC S RMSTDT=%
        S X="T-90" D ^%DT S RM90DAY=Y
        S RMBIEN=$O(^RMPR(660,"B",RM90DAY))
        Q:RMBIEN=""
        S (RMENDT,RFLDAT)=0
        F RS=0:0 S RS=$O(^RMPR(669.9,RS)) Q:RS'>0  D PCEFLG
        S RI=$O(^RMPR(660,"B",RMBIEN,0))-1     ;starts at proper ien RMPR*120
        F  S RI=$O(^RMPR(660,RI)) Q:RI'>0  D
        .S RM600=$G(^RMPR(660,RI,0))
        .I $P(RM600,U,2)="" Q
        .S RM611=$G(^RMPR(660,RI,1))
        .S RM610=$G(^RMPR(660,RI,10))
        .Q:$P(RM600,U,15)
        .Q:$P(RM600,U,17)
        .Q:'$P(RM610,U,8)
        .S RMSTA=$P(RM600,U,10)
        .;quit if already been processed.
        .Q:$P(RM610,U,12)
        .Q:(RMSTA="")!('$D(RSTAFLG(RMSTA)))
        .Q:'$P(RM611,U,4)!'$P(RM600,U,22)
        .S RMDATE=$P(RM600,U,1),RMDFN=$P(RM600,U,2)
        .S RMICD9=$P(RM610,U,8) I RMICD9'="" Q:$P($G(^ICD9(RMICD9,0)),U,9)  ;quit if DX code inactive RMPR*120
        .Q:$D(^TMP($J,RMSTA,RMDATE,RMDFN))
        .S RMPROCF=0
        .F J=0:0 S J=$O(^RMPR(660,"C",RMDFN,J)) Q:J'>0  D
        ..S RMJ60=$G(^RMPR(660,J,0)),RMJDT=$P(RMJ60,U,1),RMJST=$P(RMJ60,U,10)
        ..Q:(RMJST'=RMSTA)!(RMJDT'=RMDATE)
        ..S RMJ610=$G(^RMPR(660,J,10)),RMJ12=$P(RMJ610,U,12)
        ..I $G(RMJ12) S RMPROCF=1
        .;don't process if PCE data was process for the same day.
        .Q:$G(RMPROCF)
        .S ^TMP($J,RMSTA,RMDATE,RMDFN,RI)=""
        ;
        D PROC
        I '$D(^TMP($J,"RMPRERR")) D
        .S ^TMP($J,"RMPR",5)="***** NO ERROR TO REPORT !!!!!"
        S RMSUBI=4 D BUILD D:$D(^XMB(3.8,"B","RMPR PCE")) MES1,MES2
        G EXIT
        ;
PCEFLG  ;
        S:$D(^RMPR(669.9,RS,"PCE")) RFLDAT=$P($G(^RMPR(669.9,RS,"PCE")),U,2)
        S:'$D(^RMPR(669.9,RS,"PCE")) RFLDAT=0
        S RSTAFLG($P(^RMPR(669.9,RS,0),U,2))=RFLDAT
        S $P(^RMPR(669.9,RS,"PCE"),U,1)=RMSTDT
        Q
        ;
PROC    ;process
        F RS=0:0 S RS=$O(^TMP($J,RS)) Q:RS'>0  F RII=0:0 S RII=$O(^TMP($J,RS,RII)) Q:RII'>0  F RJ=0:0 S RJ=$O(^TMP($J,RS,RII,RJ)) Q:RJ'>0  S RK=$O(^TMP($J,RS,RII,RJ,0)) D
        .;call PCE Interface
        .S RMIE60RK=RK
        .S RMC=$$SENDPCE^RMPRPCEA(RK)
        . I RMC<1 D
        ..S RSNAM="        "
        ..I $G(RS),$D(^DIC(4,RS,0)) S RSNAM=$E($P(^DIC(4,RS,0),U,1),1,8)
        ..S ^TMP($J,"RMPRERR",RK)="Station: "_RSNAM_", File #660 IEN="_RK_" - Error in PCE interface!!!"
        ..;Added next line for RMPR*3*82
        ..I '$G(RMLOC) S ^TMP($J,"RMPRERR",RK)=^TMP($J,"RMPRERR",RK)_$G(RERRMSG)_$G(RERRMSG2)
        ..I $D(RMPROB($J,1))!$D(RMPROB($J,2)) D
        ...S (R2,R3,RMMESS)="",R6I=RK,RC=0
        ...F R1=0:0 S R1=$O(RMPROB($J,R1)) Q:R1'>0  S RC=RC+1 F  S R2=$O(RMPROB($J,R1,"ERROR1",R2)) Q:R2=""  F  S R3=$O(RMPROB($J,R1,"ERROR1",R2,R3)) Q:R3=""  D
        ....F R4=0:0 S R4=$O(RMPROB($J,R1,"ERROR1",R2,R3,R4)) Q:R4'>0  D
        .....S RMMESS=RMPROB($J,R1,"ERROR1",R2,R3,R4),RMK=R6I_"."_RC,^TMP($J,"RMPRERR",RMK)="    ???? "_$E(RMMESS,1,999)
        .....K RMPROB($J,R1,"ERROR1",R2,R3,R4)
        K RMPROB
        Q
        ;
MES1    ;
        S XMY("G.RMPR PCE")="",XMDUZ=.5,XMTEXT="^TMP($J,""RMPR"","
        S XMSUB="PROSTHETICS PCE BACKGROUND MESSAGE"
        S ^TMP($J,"RMPR",1)="Run Date: "_RMRDAT
        S ^TMP($J,"RMPR",2)="This is a notification from the Prosthetics Department........"
        S ^TMP($J,"RMPR",3)=""
        S ^TMP($J,"RMPR",4)=""
        Q
MES2    ;
        S ^TMP($J,"RMPR",RMSUBI+2)=""
        I $D(^TMP($J,"RMPRERR")) S ^TMP($J,"RMPR",RMSUBI+3)="*** Please contact your PCE Coordinator or IRM ***"
        I '$D(^TMP($J,"RMPRERR")) S ^TMP($J,"RMPR",RMSUBI+3)=""
        S ^TMP($J,"RMPR",RMSUBI+4)=""
        S ^TMP($J,"RMPR",RMSUBI+5)="Thank You!!!"
        S ^TMP($J,"RMPR",RMSUBI+6)=""
        S ^TMP($J,"RMPR",RMSUBI+7)="PROSTHETICS DEPARTMENT"
        D ^XMD
        D NOW^%DTC
        ;if task finish to completion and;
        ;if no errors, set the PCE end date of the background job in #669.9.
        F RS=0:0 S RS=$O(^RMPR(669.9,RS)) Q:RS'>0  S $P(^RMPR(669.9,RS,"PCE"),U,2)=%
        Q
        ;
BUILD   ;
        F I=0:0 S I=$O(^TMP($J,"RMPRERR",I)) Q:I'>0  D
        .S RMMAIL=^TMP($J,"RMPRERR",I)
        .S RMSUBI=RMSUBI+1
        .S ^TMP($J,"RMPR",RMSUBI)=RMMAIL
        Q
        ;
EXIT    ;MAIN EXIT POINT
        K ^TMP($J)
        S DUZ=SVDUZ
        N RMPRSITE,RMPR D KILL^XUSCLEAN
        Q
