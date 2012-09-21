DVBCUTIL        ;ALB/GTS-557/THM;C&P UTILITY ROUTINE ; 9/28/2009  11:16 AM
        ;;2.7;AMIE;**17,126,143**;Apr 10, 1995;Build 4
        ;
KILL    ;common exit
        D ^%ZISC I $D(FF),'$D(ZTQUEUED) W @FF,!!
        K %DT,ADR1,ADR2,ADR3,BDTRQ,BUSPHON,CITY,CNDCT,CNUM,DFN,DIW,DIWF,DIWL,DIWR,DIWT,DN,DOB,DTA,DTRQ,DX,DXCOD,DXNUM,EDTRQ,HOMPHON,I,LINE,MDTRM,NAME,OTHDIS,PCT,PG,PGHD,POP,PRINT,REQN,RO,ROHD,RONAME,RQ,SC,D,DIE,ONE,DVBCNEW,LN,FEXM,PRIO,DTB
        K SEX,SSN,STATE,TST,X,Y,Z,JI,JII,ZIP,JJ,KJX,D0,D1,DA,DI,DIC,DIPGM,DLAYGO,DQ,DWLW,HD,HD1,HD2,J,ONFILE,CTIM,JJ,C,DIZ,DPTSZ,STAT,JDT,JY,TSTDT,DIYS,EXAM,DR,REQDT,ELIG,INCMP,PRDSV,WARD,ADD1,ADD2,CNTY,PG,OLDDA,DIRUT,DUOUT
        K DVBCCNT,TNAM,DIR,TEMP,SWITCH,EDTA,RAD,EOD,%T,STATUS,XX,XDD,OLDA,OLDA1
        K DTTRNSC,ZIP4,DVBAINSF,DTT,TAD1,TAD2,TAD3,TCITY,TST,TZIP,TPHONE
        K COUNTY,PROVINCE,POSTALCD,COUNTRY
        G KILL^DVBCUTL2
        ;
DICW    ;used on ^DIC lookups only
        W ! S TSTDT=$P(^(0),U,2),RO=$P(^(0),U,3),STAT=$P(^(0),U,18),RONAME=$S($D(^DIC(4,+RO,0)):$P(^(0),U,1),1:"Unknown RO") D DICW1
        W ! Q
        ;
DICW1   F JY=0:0 S JY=$O(^DVB(396.4,"C",+Y,JY)) Q:JY=""  S EXAM=$P(^DVB(396.4,+JY,0),U,3),EXAM=$S($D(^DVB(396.6,EXAM,0)):$P(^(0),U,1),1:"Unknown exam") D DICW2
        Q
        ;
DICW2   W ?3,EXAM," (",$$FMTE^XLFDT(TSTDT,"5DZ")," by ",RONAME,")",!
        Q
        ;
VARS    S DTA=^DVB(396.3,DA,0),DFN=$P(DTA,U,1),(NAME,PNAM)=$P(^DPT(DFN,0),U,1),DOB=$P(^(0),U,3),SEX=$P(^(0),U,2),SSN=$P(^(0),U,9),CNUM=$S($D(^DPT(DFN,.31)):$P(^(.31),U,3),1:"Unknown"),DTRQ=$P(DTA,U,2)
        S RO=$P(DTA,U,3),FEXM=$P(DTA,U,9) S:RO="" RO=0 S RONAME=$S($D(^DIC(4,RO,0)):$P(^(0),U,1),1:"Unknown")
        S REQN=$P(DTA,U,4),REQN=$S($D(^VA(200,+REQN,0)):$P(^(0),U,1),1:"Unknown"),OTHDIS=$P(DTA,U,11) I $D(^DVB(396.3,DA,1)) S OTHDIS1=$P(^(1),U,9),OTHDIS2=$P(^(1),U,10)
        S ZPR=$P(DTA,U,10),PRIO=$S(ZPR="T":"Terminal",ZPR="P":"Prisoner of war",ZPR="OS":"Original SC",ZPR="ON":"Original NSC",ZPR="I":"Increase",ZPR="R":"Review",ZPR="OTR":"Other",ZPR="E":"Inadequate exam",1:"Unknown")
        K DVBAINSF S:ZPR="E" DVBAINSF=""
        S (ADR1,ADR2,ADR3,CITY,STATE,ZIP)=""
        I $D(^DPT(DFN,.11)) D
        .S DTA=^DPT(DFN,.11)
        .S ADR1=$P(DTA,U,1),ADR2=$P(DTA,U,2),ADR3=$P(DTA,U,3),CITY=$P(DTA,U,4)
        .S ZIP=$P(DTA,U,12) S:ZIP'="" ZIP=$S($L(ZIP)>5:$E(ZIP,1,5)_"-"_$E(ZIP,6,9),1:ZIP) I ZIP="" S ZIP="No Zip"
        .S CITY=$S(CITY]"":CITY,1:"Unknown") S STATE=$P(DTA,U,5) I STATE]"" S STATE=$S($D(^DIC(5,STATE,0)):$P(^(0),U,1),1:"Unknown")
        .S (HOMPHON,BUSPHON)="Unknown" I $D(^DPT(DFN,.13)) S HOMPHON=$P(^(.13),U,1),BUSPHON=$P(^(.13),U,2)
        .S COUNTY=$P(DTA,U,7),PROVINCE=$P(DTA,U,8),POSTALCD=$P(DTA,U,9)
        .S COUNTRY=$P(DTA,U,10)
        I $D(^DPT(DFN,.121)) D   ;DVBA/126 added
        .S (DTT,TAD1,TAD2,TAD3,TCITY,TST,TZIP,TPHONE)=""
        .S DTT=^DPT(DFN,.121)
        .S TAD1=$P(DTT,U,1),TAD2=$P(DTT,U,2),TAD3=$P(DTT,U,3),TCITY=$P(DTT,U,4)
        .S TZIP=$P(DTT,U,12) S:TZIP'="" TZIP=$S($L(TZIP)>5:$E(TZIP,1,5)_"-"_$E(TZIP,6,9),1:TZIP) I TZIP="" S TZIP="No Zip"
        .S TCITY=$S(TCITY]"":TCITY,1:"Unknown") S TST=$P(DTT,U,5) I TST]"" S TST=$S($D(^DIC(5,TST,0)):$P(^(0),U,1),1:"Unknown")
        .S TPHONE=$P(DTT,U,10) S:TPHONE="" TPHONE="Unknown"
        S EDTA=$S($D(^DPT(DFN,.32)):^(.32),1:""),EOD=$P(EDTA,U,6),RAD=$P(EDTA,U,7),Y=$S($D(^DVB(396.3,DA,1)):$P(^(1),U,7),1:"") X ^DD("DD") S LREXMDT=Y
        Q
        ;
HDR     W @FF,?(IOM-$L(HD2)\2),HD2,!!!?5,"Veteran name: ",PNAM,?45,"SSN: ",SSN,!?40,"C-NUMBER: ",CNUM,!!,"Exams on this request:",!!
        S JII=""
        F JIJ=0:0 S JII=$O(^TMP($J,JII)) Q:JII=""  S XST=$P(^TMP($J,JII),U,1) W JII,", ",$S(XST="C":"Completed",XST="RX":"Cancelled by RO",XST="X":"Cancelled by MAS",XST="T":"Transferred",1:"Open"),", " I $X>30 W !
        Q
        ;
ADDR    S (ADD1,ADD2,CITY,CNTY,STATE,ZIP)=""
        I $D(^DPT(DFN,.11)) S DTA=^(.11),ADD1=$P(DTA,U,1),ADD2=$P(DTA,U,2),CITY=$P(DTA,U,4),STATE=$P(DTA,U,5),ZIP=$P(DTA,U,12),CNTY=$P(DTA,U,7)
        S:ZIP'="" ZIP=$S($L(ZIP)>5:$E(ZIP,1,5)_"-"_$E(ZIP,6,9),1:ZIP)
        S CNTY=$S($D(^DIC(5,+STATE,1,+CNTY,0)):$P(^(0),U,1),1:"Unknown")
        S STATE=$S($D(^DIC(5,+STATE,0)):$P(^(0),U,1),1:"Unknown")
        W !!?0,"Address: ",?9,ADD1,! W:ADD2]"" ?9,ADD2,! W ?0,"City:",?9,CITY,"  ",STATE,"  ",ZIP,!?0,"County:",?9,CNTY,!!
        S PRDSV=$S($D(^DPT(DFN,.32)):$P(^(.32),U,3),1:"") I PRDSV]"" S PRDSV=$P(^DIC(21,PRDSV,0),U,1)
        W "Period of service: ",PRDSV,!
        S ELIG="",INCMP=0
        W ?0,"Eligibility data:" I $D(^DPT(DFN,.36)),$P(^(.36),U,1)]"" S ELIG=$S($D(^DIC(8,+^(.36),0)):$P(^(0),U,6),1:"")
        I ELIG]"",$D(^DPT(DFN,.361)),^(.361)]"" S ELIG=ELIG_" ("_$S($P(^(.361),U,1)="P":"Pend ver",$P(^(.361),U,1)="R":"Pend re-verif",$P(^(.361),U,1)="V":"Verified",1:"Not verified")_")"
        I $D(^DPT(DFN,.29)),$P(^(.29),U,1)]"" S INCMP=1
        I $D(^DPT(DA,.293)),$P(^(.293),U,1)=1 S INCMP=1
        W ?19,ELIG_$S(ELIG]"":", ",1:"")_$S(INCMP=1:"Incompetent",1:""),!
        Q
        ;
SSNSHRT ;  ** Set SSN in the Format '123 45 6789' **
        K DVBCSSNO
        S DVBCSSNO=$E(SSN,1,3)_" "_$E(SSN,4,5)_" "_$E(SSN,6,9)
        Q
        ;
SSNOUT  ;  ** Set SSN in the Format '123 45 6789 (Z6789) **
        D SSNSHRT
        S DVBCSSNO=DVBCSSNO_" ("_$E(PNAM)_$E(SSN,6,9)_")"
        Q
        ;
ISFORGN(DVBIEN)  ;  ** Is country entry foreign? **
        ;  Input:  DVBIEN - IEN of COUNTRY CODE file
        ;
        ;  Output:  Return 1 when country is foreign
        ;           Return 0 when country is not foreign
        ;           Return -1 on error
        ;
        N DVBCNTRY
        N DVBERR
        Q:$G(DVBIEN)="" -1
        S DVBCNTRY=$$GET1^DIQ(779.004,DVBIEN_",",".01","","","DVBERR")
        Q $S($D(DVBERR):-1,DVBCNTRY="USA":0,1:1)
        ;
GETCNTRY(DVBIEN)         ;  ** Get POSTAL NAME for country code **
        ;  Input:  DVBIEN - IEN of COUNTRY CODE file
        ;
        ;  Output:  Return POSTAL NAME field on success or
        ;           DESCRIPTION field when POSTAL NAME = "<NULL>";
        ;           Otherwise, return "" on failure.
        ;
        N DVBCNTRY
        N DVBERR
        N DVBIENS
        N DVBNAME
        S DVBNAME=""
        I $G(DVBIEN)'="" D
        . S DVBIENS=DVBIEN_","
        . D GETS^DIQ(779.004,DVBIENS,"1.3;2","E","DVBCNTRY","DVBERR")
        . I '$D(DVBERR) D
        . . S DVBNAME=$G(DVBCNTRY(779.004,DVBIENS,1.3,"E"))
        . . I DVBNAME="<NULL>" S DVBNAME=$$UP^XLFSTR($G(DVBCNTRY(779.004,DVBIENS,2,"E")))
        Q DVBNAME
