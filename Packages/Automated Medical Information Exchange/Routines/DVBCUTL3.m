DVBCUTL3        ;ALB/GTS-557/THM-DVBCUTL2, CONTINUED ; 5/17/91  11:35 AM
        ;;2.7;AMIE;**132**;Apr 10, 1995;Build 2
        ;
KILL    I $D(LKILL) K LKILL D LKILL
        K C0,DVBCLTR,DVBCNOW,DVBCSORT,LI,LREXMDT,LV,PGRN,ROUT,RT,TSTAT,XMB,XT,EXNAME,OTHDIS1,OTHDIS2,PG,REQRO,RSTAT,TIME,ZI,ZZI,DAYEX,DINUM,DTCAN,ERDAYS,EXMDA,FB,OLDAYS,^TMP("DVBC",$J),^TMP("DVBCLAB",$J),DVBCBDT,DVBCLOC,DVBCN,DVBCRLOC
        K HD4,RONUM,TPRT,DG,LRPARAM,RARPT,SUPER,^TMP($J),^TMP("DVBC","BULL",$J),EXCNT,RTYPE,XD,XLINE,ZC,LY,LZ,MX,MY,WKSNUM,HD7,HD8,HD9,LN1,LN2,DXCMT,CANBY,CANDT,CANREM,CFLOC,CFREQ,CMBN,DVBCI,ELIGCOD,ELIGSDT,ELIGST,DVBCD2
        K EXM,EXMDT,EXMPL,EXPHYS,FREAS,HD5,HD6,HD7,HD8,HD9,LNH,NREQDA,OLREQDA,OTHDOC,OWNER,PDSRV,PFAX,POWSTAT,SITE,SITE1,SRVCON,SRVEDT,SRVPCT,SRVSDT,SUB,TIME,TOT,USER,USERNM,USR,VETST,WRKSHT,XFERDT,XFERSITE,XMER,XMREC,XMRG,ZJ,ZK
        K HD91,CNUM,DFN,DX,DXCOD,DXNUM,I,LINE,DVBCRALC,PCT,SC,SSN,CANCBY,CANCDT,CANCREM,DATRETN,EXST,FA,OWNDOM,REMK,TSTA1,XMFG,YY,ZG,ZH,DVBCAO,XCN,MANUAL
        K DVBCTYPE,HD7,HD8,HD9,HD91,RDATE1,TPRT,XJ,RONAM,PNAM,^TMP($J)
        Q
        ;
LKILL   K LRO,LR0,LRAA,LRAAO,LRCDT,LRCMNT,LRNIDT,LRCW,LRDATA,LRDFN,LRDN,LRDOC,LRDPF,LREDT,LREND,LRFFLG,LRFOOT,LRHF,LRHI,LRIDT,LRLAB,LRLO,LRMNIDT,LROC,LRONESPC,LRONETST,LRORN,LRPC,LRPO,LRSDT,LRSPEC,LRSS,LRSTOP,LRSUB,LRTC,LRCNIDT
        K LRTHER,LRTSTS,LRWRD,RACNI,RAST,RPTR,OK,LRBLOOD,LRPARAM,LRPLASMA,LRSERUM,LRUNKNOW,LRURINE,LRPANEL,LRTM60,LRDT0,LRLABKY
        Q
        ;  **The following routines are called by DVBCREQ1 **
DDIS1   S DXNUM=$P(^DPT(DFN,.372,DVBCXJI,0),U,1),PCT=$P(^(0),U,2)
        S DVBCSC=$P(^(0),U,3)
        S DVBCDX=$S($D(^DIC(31,DXNUM)):$P(^(DXNUM,0),U,1),1:"Unknown")
        S DXCOD=$S($D(^DIC(31,DXNUM)):$P(^(DXNUM,0),U,3),1:"Unknown")
        W ?2,DVBCDX,?37,$J(PCT,3,0)," %",?50,$S(DVBCSC=1:"Yes",1:"No")
        W ?58,DXCOD,!
        I IOST?1"C-".E W !,"VA Form 21-2507" D TERM
        Q
        ;
DDIS    ;display rated disabilities
        I '$D(^DPT(DFN,.372)) W !?25,"No rated disabilities on file",!! Q
        W !?2,"Rated Disability",?37,"Percent",?50,"SC ?",?58,"Dx Code",! W ?2 F LINE=1:1:63 W "-"
        W !!
        F DVBCXJI=0:0 S DVBCXJI=$O(^DPT(DFN,.372,DVBCXJI)) Q:DVBCXJI=""  D DDIS1  Q:($D(GETOUT))
        W !!
        Q
        ;
TST     W ?3
        F DA=0:0 S DA=$O(^DVB(396.4,"C",DA(1),DA)) Q:(DA="")!($D(GETOUT))  D CONTST
        Q
        ;
CONTST  K PRINT S TSTAT=$P(^DVB(396.4,DA,0),U,4)
        S TST=$P(^DVB(396.4,DA,0),U,3)
        S PRTNM=$S($D(^DVB(396.6,TST,0)):$P(^(0),U,2),1:"")
        D TST1
        Q
        ;
TST1    I $Y>(IOSL-3) W !,"VA Form 21-2507" I IOST?1"C-".E D TERM Q:($D(GETOUT))
        S TSTA1=""
        I $D(^DVB(396.4,DA,"CAN")) S TSTA1=$P(^DVB(396.4,DA,"CAN"),U,3)
        I $D(^DVB(396.4,DA,"TRAN")) S X=$P(^DVB(396.4,DA,"TRAN"),U,3)
        S:TSTA1]"" TSTA1=$P(^DVB(396.5,TSTA1,0),U,1) ;tsta1=cancellation reason
        ;DVBA*132 - added Exam Ref# to end of Write command below
        W:(($L(PRTNM)+$L(TSTA1)+$X)>55!($D(DVBAINSF))) !?1 W $S(PRTNM]"":PRTNM,1:"Missing exam name")_$S(TSTA1]"":" - cancelled ("_TSTA1_")",TSTAT="T":" - Transferred",TSTAT="":" (Unknown status)",1:"")," (Exam Ref#: ",DA,")"
        I TSTAT="T" S X=$S($D(^DIC(4.2,+X,0)):$P(^(0),U,1),1:"unknown site") W " to ",$P(X,".",1)
        W "; "
        I $D(DVBAINSF) DO
        .I +$P(^DVB(396.4,DA,0),U,11)>0 DO
        ..I $Y>(IOSL-7) D BOT D:'$D(GETOUT) HDR^DVBCREQ1
        ..I '$D(GETOUT) DO
        ...S TVAR(1,0)="0,3,0,2,0^Insufficient Reason: "_$P(^DVB(396.94,$P(^DVB(396.4,DA,0),U,11),0),U,1)
        ...S TVAR(2,0)="0,3,0,2:1,0^Insufficient Remarks: "
        ...D WR^DVBAUTL4("TVAR")
        ...K TVAR
        ...I $D(^DVB(396.4,DA,"INREM")) DO
        ....K ^UTILITY($J,"W")
        ....S DIWL=5,DIWF="NW"
        ....F LPCNT=0:0 S LPCNT=$O(^DVB(396.4,DA,"INREM",LPCNT)) Q:LPCNT=""!($D(GETOUT))  DO  ;**Loop Insufficient Remarks
        .....S X=^DVB(396.4,DA,"INREM",LPCNT,0)
        .....S:X="<" X=" <"
        .....S X=$P(X,"<",1)
        .....D ^DIWP ;**Print Insufficient Remarks
        .....I $Y>(IOSL-8),$O(^DVB(396.4,DA,"INREM",LPCNT))]"" DO
        ......D BOT D:'$D(GETOUT) HDR^DVBCREQ1,RMRK
        ....D:'$D(GETOUT)&($O(^DVB(396.4,DA,"INREM",0))>0) ^DIWW
        ...W !!
        Q
        ;
TERM    ;  ** If output to CRT, display 'Continue' prompt **
        S DIR(0)="F,O^^",DIR("A")="Enter [Return] to continue or ""^"" to exit"
        K GETOUT D ^DIR S:$D(DTOUT)!($D(DUOUT)) GETOUT=1
        I '$D(GETOUT) W @IOF K DIR,DIRUT
        Q
        ;
BOT     ;**Write form # at bottom
        I IOST?1"C-".E F LPCNT1=$Y:1:(IOSL-6) W !
        I IOST'?1"C-".E F LPCNT1=$Y:1:(IOSL-4) W !
        W !,"VA Form 21-2507"
        I IOST?1"C-".E D TERM
        Q
        ;
RMRK    ;** Write remarks continued at top of page
        W !!?3,"Insufficient remarks, continued",!!
        Q
