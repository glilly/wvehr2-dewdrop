RMPOLF0A        ;HIN CIOFO/RVD-DRIVER FOR HO LETTERS(ALL) ;06/28/99
        ;;3.0;PROSTHETICS;**29,55,115,159**;Feb 09, 1996;Build 2
        ;
        ; ODJ - patch 55 - 29/1/01 - replace 121 hard coded mail code with call
        ;                            to site param. extrinsic (AUG-1097-32118)
        ;
        D HOME^%ZIS S RMPRIN=0
        S RMPRTFLG=1
        S Y=DT D DD^%DT S NAME=Y D TRANS^RMPRUTL1 S (RMPODT,RMPODATE)=RMPRNAME
        K ZTSAVE,^TMP("RL",$J) D FULL^VALM1
        M ^TMP("RL",$J)=^TMP($J) K ^TMP($J)
        ;
QUED    ;
        S (RMBLNK,RMPONAM)="",RMQUIT=0 S:'$D(ZTQUEUED) RMIOST=IOST,RMIO=IO
        F  S RMPONAM=$O(^TMP("RL",$J,RMPOXITE,"RMPOLST",RMPOLCD,RMPONAM)) Q:RMPONAM=""!$G(RMQUIT)  D CUM
        D PRALL^RMPOLF1
        F RI=0:0 S RI=$O(^TMP("RL",$J,1,RI)) Q:RI'>0  S RMDFN=^TMP("RL",$J,1,RI) D
        .I RMPOLCD="A" S $P(^RMPR(665,RMDFN,"RMPOA"),U,9)=DT,$P(^("RMPOA"),U,10)="P" K ^RMPR(669.9,RMPOXITE,"RMPOXBAT1") S ^RMPR(669.9,RMPOXITE,"RMPOXBAT1",0)="^669.9002P^^^"
        .I RMPOLCD="B" S $P(^RMPR(665,RMDFN,"RMPOA"),U,11)=DT,$P(^("RMPOA"),U,12)="P" K ^RMPR(669.9,RMPOXITE,"RMPOXBAT2") S ^RMPR(669.9,RMPOXITE,"RMPOXBAT2",0)="^669.972P^^^"
        .I RMPOLCD="C" S $P(^RMPR(665,RMDFN,"RMPOA"),U,13)=DT,$P(^("RMPOA"),U,14)="P" K ^RMPR(669.9,RMPOXITE,"RMPOXBAT3") S ^RMPR(669.9,RMPOXITE,"RMPOXBAT3",0)="^669.974P^^^"
        ;
EXIT    K LFNS,LFN,ZI,RTN,DIR,RMLET,RMPRTFLG,RMPRIN,RMIO,RMIOST,RMION,RMPONAM
        K RMDAT,DFN,RMDA,RMPRFA,RMDFN,RI
        M ^TMP($J)=^TMP("RL",$J) K ^TMP("RL",$J)
        K ^TMP($J,RMPOXITE,"RMPOLST",RMPOLCD)
        D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" Q:$D(ZTQUEUED)
        D CLEAN^VALM10,INIT^RMPOLT,RE^VALM4
        S VALMBCK="R"
        Q
        ;
CUM     ;
        S RMDAT=^TMP("RL",$J,RMPOXITE,"RMPOLST",RMPOLCD,RMPONAM)
        S RMPOLTR=$P(RMDAT,U,1)
        S DFN=$P(RMDAT,U,2)
        S RMDA=$P(RMDAT,U,3)
        S RMPRFA=RMPOLTR,RMPRTFLG=1
        S RMREC=^TMP("RL",$J,RMPOXITE,"RMPODEMO",DFN)
        S RMPORX=$P(RMREC,U,6) S:RMPORX="" RMPORX="Not on file"
        S RMPORXDT=$P(RMREC,U,4)
        I RMPORXDT="" S RMPORXDT="n/a"
        E  S Y=RMPORXDT X ^DD("DD") S RMPORXDT=Y
        D DEM^VADPT,ADD^VADPT
        F RI=1:1:21 S ^TMP($J,"DW",RI,0)=" "
HEADER1 ;
        S RMPRHED=$G(^TMP("RL",$J,RMPOXITE,"HEADER",RMPOLTR))
        W @IOF I 'RMPRHED G HEADER
        S ^TMP($J,"DW",1,0)="|SETTAB(""C"")|"
        S ^TMP($J,"DW",2,0)="|TAB|Department of Veterans Affairs"
        S NAME=$P(^RMPR(669.9,RMPOXITE,2),U,4) I NAME]"" S NAME=$S($D(^DIC(5,NAME)):$P(^DIC(5,NAME,0),U),1:"STATE") S RMFXN=$$PARS^RMPRUTL1(NAME)
        S ^TMP($J,"DW",3,0)="|TAB|"_$P(^RMPR(669.9,RMPOXITE,0),U)
        S ^TMP($J,"DW",4,0)="|TAB|"_$P(^RMPR(669.9,RMPOXITE,2),U,2)
        S ^TMP($J,"DW",5,0)="|TAB|"_$P(^RMPR(669.9,RMPOXITE,2),U,3)_", "_RMFXN_" "_$P(^RMPR(669.9,RMPOXITE,2),U,5) K RMFXN
HEADER  ;
        S ^TMP($J,"DW",9,0)="|SETTAB(5,50)||TAB|"_RMPODT
        S STATNID=$P(^RMPR(669.9,RMPOXITE,0),U,2) I $D(^DIC(4,STATNID,99)) S STATNID=$P(^DIC(4,STATNID,99),U)
        S ^TMP($J,"DW",11,0)="|TAB|"_$P(VADM(1),",",2)_" "_$P(VADM(1),",",1)_"|TAB|In Reply Refer To: "_STATNID_"/"_$$ROU^RMPRUTIL(RMPOXITE)
        K STATNID
        S ^TMP($J,"DW",12,0)="|TAB|"_VAPA(1)
        I VAPA(2)]"" S ^TMP($J,"DW",13,0)="|TAB|"_VAPA(2)_"|TAB|"_VADM(1),^TMP($J,"DW",14,0)="|TAB|"_VAPA(4)_","_" "_$P(VAPA(5),U,2)_" "_VAPA(6)
        E  S ^TMP($J,"DW",13,0)="|TAB|"_VAPA(4)_","_" "_$P(VAPA(5),U,2)_" "_VAPA(6)_"|TAB|"_VADM(1)
        S ^TMP($J,"DW",15,0)="|TAB|"_RMBLNK_"|TAB|"_DFN
        S ^TMP($J,"DW",16,0)="|TAB|"_RMBLNK_"|TAB|Current Home Oxygen Rx#: "_RMPORX
        S ^TMP($J,"DW",17,0)="|TAB|"_RMBLNK_"|TAB|Rx Expiration Date: "_RMPORXDT
        ;
        S NAME=$P(VADM(1),",")
        I $P(NAME," ",2)?1A.A D
        .S NAME1=NAME,NAME=$P(NAME," ",1) D TRANS^RMPRUTL1 S RMPRNAM1=RMPRNAME,NAME=NAME1,NAME=$P(NAME," ",2) D TRANS^RMPRUTL1 S RMPRNAM2=RMPRNAME,RMPRNAME=RMPRNAM1_" "_RMPRNAM2
        E  D TRANS^RMPRUTL1
        D NAME^RMPOLF1
        Q
