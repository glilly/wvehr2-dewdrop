YSCLTST2        ;DALOI/LB/RLM-TRANSMIT RX AND lAB DATA FOR CLOZAPINE ;19 Feb 93
        ;;5.01;MENTAL HEALTH;**18,22,26,47,61,69,74,90,92**;Dec 30, 1994;Build 7
        ; Reference to ^LAB(60 supported by IA #333
        ; Reference to ^PSDRUG supported by IA #25
        ; Reference to ^XMD supported by IA #10070
        ; 
TRANSMIT        ; send remote and local, kill and quit
        K XMZ S %DT="T",X="NOW" D ^%DT S YSCLNOW=$P(Y,".",2),YSCLSITE=$P($$SITE^VASITE,"^",2)
        S $P(YSSTOP,",",7)=7 I $$S^%ZTLOAD D ABORT^YSCLTEST G END
        I YSCLLN D
         . K XMY
         . S XMY("S.RUCLRXLAB@FO-HINES.MED.VA.GOV")=""
         . I YSDEBUG K XMY S XMY("G.CLOZAPINE DEBUG@FO-DALLAS.MED.VA.GOV")="",XMY("G.RUCLRXLAB@FO-DALLAS.MED.VA.GOV")=""
         . S XMDUZ="Clozapine MONITOR",XMTEXT="^TMP($J,",XMSUB=$S(YSDEBUG:"DEBUG ",1:"")_"Clozapine lab data @ "_YSCLSITE_" on "_DT_" at "_YSCLNOW D ^XMD
        K XMY
        S XMY("G.CLOZAPINE ROLL-UP@FORUM.VA.GOV")=""
        I YSDEBUG K XMY S XMY("G.CLOZAPINE DEBUG@FO-DALLAS.MED.VA.GOV")=""
        S XMY("G.PSOCLOZ")=""
        S XMSUB=$S(YSDEBUG:"DEBUG ",1:"")_"Clozapine lab data @ "_YSCLSITE_" on "_DT_" at "_YSCLNOW
        S ^TMP("YSCL",$J,2,0)=" ",^TMP("YSCL",$J,3,0)="In message # "_$S($D(XMZ):XMZ,1:"no data sent")
        K XMZ S XMDUZ="Clozapine MONITOR",^TMP("YSCL",$J,1,0)="Clozapine lab data was transmitted, "_(YSCLLLN-3)_" records were sent",XMTEXT="^TMP(""YSCL"",$J," D ^XMD
        S $P(^YSCL(603.03,1,0),"^",5)=$$NOW^XLFDT
END     ;
        G END1^YSCLTST3
        Q
REXMIT  ; retransmit lab and RX data
        ; must be a tuesday
        S DIR(0)="Y",DIR("A")="Are you sure you wish to retransmit lab data"
        D ^DIR K DIR I Y'=1 K Y Q
DATE    S %DT="AEXP",%DT(0)=-DT,%DT("A")="Ending date for data collection (must be a tuesday )"
        D ^%DT K %DT G END:X="^",END:X="^" I Y=-1 G DATE
SERV    S YSCLED=Y,X=Y D H^%DTC I %H#7'=5 W !,"MUST BE A TUESDAY" G DATE
        S ZTDESC="Server triggered retransmission"
        S ZTSAVE("YSCLED")="",ZTIO="",ZTRTN="REXMIT^YSCLTEST",ZTDTH=$H D ^%ZTLOAD G END
FLSET   ;Set up file 603.02
        W @IOF,"This option specifies the blood tests associated with the Clozapine"
        W !,"reporting software.  Two tests must be defined.  The first is the White"
        W !,"Blood Count.  The second is the Granulocyte (or Neutrophil) percentage."
        K DIR W !! S DIR(0)="PA^64:EMZ",DIR("A",1)="Enter the test that will be used to record the White Blood Count for the",DIR("A")="Clozapine patients: " D ^DIR
        Q:Y=-1!($D(DUOUT))!($D(DTOUT))!($D(DIRUT))!($D(DIROUT))
        S YSCLWBC=+Y
        K DIR W !! S DIR(0)="PA^64:EMZ",DIR("A",1)="Enter the test that will be used to record the Neutrophil Count (percentage)",DIR("A")=" for the Clozapine patients: " D ^DIR
        Q:Y=-1!($D(DUOUT))!($D(DTOUT))!($D(DIRUT))!($D(DIROUT))
        S YSCLGRN=+Y
        I YSCLWBC,YSCLGRN S ^YSCL(603.02,1,0)=YSCLWBC_"^"_YSCLGRN,$P(^YSCL(603.02,0),"^",3,4)="1^1"
        ;Only one entry is allowed.
        K DIR,X,Y,YSCLWBC,YSCLGRN,ZTDESC
        Q
EN(DRG) ;
        K LAB I $P($G(^PSDRUG(DRG,"CLOZ1")),"^")'="PSOCLO1" S LAB("NOT")=0 Q
        I $P($G(^PSDRUG(DRG,"CLOZ1")),"^")="PSOCLO1" D
         . S (CNT,I)=0 F  S I=$O(^PSDRUG(DRG,"CLOZ2",I)) Q:'I  S CNT=$G(CNT)+1
         . I CNT'=2 S LAB("BAD TEST")=0 K CNT Q
         . K CNT F I=0:0 S I=$O(^PSDRUG(DRG,"CLOZ2",I)) Q:'I  D
         . . S LABT=$S($P(^PSDRUG(DRG,"CLOZ2",I,0),"^",4)=1:"WBC",1:"ANC"),LAB(LABT)=$P(^PSDRUG(DRG,"CLOZ2",I,0),"^")_"^"_$P(^(0),"^",3)_"^"_$P(^(0),"^",4)
        K LABT,I
        Q
CL1(DFN,DAYS)   ;The routine was split due to size
        G CL1^YSCLTST4
        Q
        ;
CL(DFN) ;
        K ^TMP("LRRR",$J) N RESULTS,YSCLYWBC,YSCLRANC,YSCLXWBC,YSCLRWBC,YSCLFRQ
        I 'DFN Q "-1^-1^-1^-1^-1^-1^-1"
        S YSCLFRQ=$O(^YSCL(603.01,"C",DFN,"")) I YSCLFRQ]""  S YSCLFRQ=$P(^YSCL(603.01,YSCLFRQ,0),"^",3)
        I $G(^YSCL(603.03,1,1))=1!(YSCLFRQ="")  Q "-1^0^0^0^0^0^"_YSCLFRQ
        S X1=DT,X2="-7" D C^%DTC S YSCLSD=X
        S YSCLA=0 F  S YSCLA=$O(^YSCL(603.04,1,1,YSCLA)) Q:'YSCLA  S YSCLTLS=^YSCL(603.04,1,1,YSCLA,0),YSCLTLS($P(YSCLTLS,"^",2),$P(YSCLTLS,"^",1))=$P(YSCLTLS,"^",3)
        S YSCLTL="" F  S YSCLTL=$O(^YSCL(603.04,1,1,"B",YSCLTL)) Q:'YSCLTL  D
         . D RR^LR7OR1(DFN,,YSCLSD,DT,,YSCLTL,"L")
         . S YSCLSB1="" F  S YSCLSB1=$O(^TMP("LRRR",$J,DFN,YSCLSB1)) Q:YSCLSB1=""  D
         . . S YSCLTDT="" F  S YSCLTDT=$O(^TMP("LRRR",$J,DFN,YSCLSB1,YSCLTDT)) Q:YSCLTDT=""  I $P(YSCLTDT,".",2)]"" D
         . . . S YSCLTA="" F  S YSCLTA=$O(^TMP("LRRR",$J,DFN,YSCLSB1,YSCLTDT,YSCLTA)) Q:YSCLTA=""  I YSCLTA D
         . . . . S RESULTS1=^TMP("LRRR",$J,DFN,YSCLSB1,YSCLTDT,YSCLTA)
         . . . . S RESULTS(YSCLTL,YSCLTDT)=$P(RESULTS1,"^",2)
        ;Find all entries for WBC and sort by inverse date.
        S YSCLA="" F  S YSCLA=$O(YSCLTLS("W",YSCLA)) Q:'YSCLA  S YSCLXWBC(YSCLA)="" D
         . S YSCLA1="" F  S YSCLA1=$O(RESULTS(YSCLA,YSCLA1)) Q:'YSCLA1  S YSCLYWBC(YSCLA1)=RESULTS(YSCLA,YSCLA1)_"^"_$P($G(^LAB(60,YSCLA,0)),"^")_"^"_YSCLTLS("W",YSCLA)
        S YSCLRWBC=$O(YSCLYWBC(0)) I 'YSCLRWBC D KILL Q "0^^^^^^"_YSCLFRQ
        S YSCLMULT=$P(YSCLYWBC(YSCLRWBC),"^",3),YSCLMULT=$S(YSCLMULT:1000,1:1)
        S YSCLRWBC(YSCLRWBC)=($P(YSCLYWBC(YSCLRWBC),"^")*YSCLMULT)_"^"_$P(YSCLYWBC(YSCLRWBC),"^",2)
        ;Scan for Neutrophil count on same day and time as most recent WBC
        S YSCLMTCH=0 F YSCLA="A","N","S","T" S YSCLTPT="" Q:YSCLMTCH  F  S YSCLTPT=$O(YSCLTLS(YSCLA,YSCLTPT)) Q:'YSCLTPT  D  Q:YSCLMTCH
         . S YSCLMULT=YSCLTLS(YSCLA,YSCLTPT),YSCLMULT=$S(YSCLMULT:1000,1:1)
         . I $D(RESULTS(YSCLTPT,YSCLRWBC)),YSCLA="A",RESULTS(YSCLTPT,YSCLRWBC)'?1A.E S YSCLMTCH=1,YSCLRANC(YSCLRWBC)=RESULTS(YSCLTPT,YSCLRWBC)*YSCLMULT_"^"_$P(^LAB(60,YSCLTPT,0),"^") Q
         . I $D(RESULTS(YSCLTPT,YSCLRWBC)),YSCLA="N",RESULTS(YSCLTPT,YSCLRWBC)'?1A.E S YSCLMTCH=1,YSCLRANC(YSCLRWBC)=YSCLRWBC(YSCLRWBC)*((RESULTS(YSCLTPT,YSCLRWBC))*.01)_"^"_$P(^LAB(60,YSCLTPT,0),"^") Q
         . I $D(RESULTS(YSCLTPT,YSCLRWBC)),YSCLA="S",RESULTS(YSCLTPT,YSCLRWBC)'?1A.E D
         . . S YSCLSGS="" F  S YSCLSGS=$O(YSCLTLS("B",YSCLSGS)) D  Q:YSCLMTCH
         . . . S:'YSCLSGS YSCLSGS="Z" I '$D(RESULTS(YSCLSGS,YSCLRWBC)) S RESULTS(YSCLSGS,YSCLRWBC)=0
         . . . S YSCLMTCH=1,YSCLRANC(YSCLRWBC)=YSCLRWBC(YSCLRWBC)*((RESULTS(YSCLTPT,YSCLRWBC)*.01)+(RESULTS(YSCLSGS,YSCLRWBC)*.01))_"^"_$P(^LAB(60,YSCLTPT,0),"^")_"/"_$P($G(^LAB(60,YSCLSGS,0)),"^") Q
         . I $D(RESULTS(YSCLTPT,YSCLRWBC)),YSCLA="C",RESULTS(YSCLTPT,YSCLRWBC)'?1A.E D
         . . S YSCLSGS="" F  S YSCLSGS=$O(YSCLTLS("T",YSCLSGS)) D  Q:YSCLMTCH
         . . . S:'YSCLSGS YSCLSGS="Z" I '$D(RESULTS(YSCLSGS,YSCLRWBC)) S RESULTS(YSCLSGS,YSCLRWBC)=0
         . . . S YSCLMTCH=1,YSCLRANC(YSCLRWBC)=((RESULTS(YSCLTPT,YSCLRWBC)*YSCLMULT)+(RESULTS(YSCLSGS,YSCLRWBC)*YSCLMULT))_"^"_$P(^LAB(60,YSCLTPT,0),"^")_"/"_$P($G(^LAB(60,YSCLSGS,0)),"^") Q
        D KILL
        I $G(YSCLRWBC(YSCLRWBC))<3000!($G(YSCLRANC(YSCLRWBC))<1500) Q "0^"_$G(YSCLRWBC(YSCLRWBC))_"^"_$S($G(YSCLRANC(YSCLRWBC))="":"^",1:$G(YSCLRANC(YSCLRWBC)))_"^"_(9999999-YSCLRWBC)_"^"_YSCLFRQ
        I $G(YSCLRWBC(YSCLRWBC))<3500!($G(YSCLRANC(YSCLRWBC))<2000) Q "2^"_$G(YSCLRWBC(YSCLRWBC))_"^"_$S($G(YSCLRANC(YSCLRWBC))="":"^",1:$G(YSCLRANC(YSCLRWBC)))_"^"_(9999999-YSCLRWBC)_"^"_YSCLFRQ
        Q "1^"_YSCLRWBC(YSCLRWBC)_"^"_YSCLRANC(YSCLRWBC)_"^"_(9999999-YSCLRWBC)_"^"_YSCLFRQ
        ;
KILL    ;
        K FDA,YSCLSGS,Y15,RESULTS,RESULTS1,YSCLA,YSCLA1,YSCLMTCH,YSCLSB1,YSCLSD,YSCLTA,YSCLMULT
        K YSCLTL,YSCLTLS,X1,X2
        Q
        ;
OVERRIDE(DFN)   ;Check for an over-ride.
        S YSCLOVR=$O(^YSCL(603.01,"C",DFN,""))
        Q:YSCLOVR="" 0
        S YSCLOVR=$P(^YSCL(603.01,YSCLOVR,0),"^",4)
        Q YSCLOVR=DT
        ;
ZEOR    ;YSCLTST2
