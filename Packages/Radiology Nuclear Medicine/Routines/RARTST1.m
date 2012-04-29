RARTST1 ;HISC/CAH,FPT,GJC,DAD AISC/MJK,RMO-Reports Distribution ;7/23/97  12:44
        ;;5.0;Radiology/Nuclear Medicine;**56**;Mar 16, 1998;Build 3
        ;Supported IA #10040 ^SC(
        ;Supported IA #10060 and #2056 GET1^DIQ of file 200
        ;Supported IA #10007 DO^DIC1
1       ;;Routing Queue
        N RAOMA S RAOMA="",DIC(0)="AEMQZ"
        S DIC("A")="Select Routing Queue: ",DIC("B")="WARD REPORTS"
        S DIC("S")="I $S('$D(^(""I"")):1,'^(""I""):1,DT'>^(""I""):1,1:0)"
        S DIC="^RABTCH(74.3," D ^DIC K DIC G:Y<1 Q
        S RAB=+Y,RARTST1=$S(Y(0,0)="REQUESTING PHYSICIAN":0,1:1)
        D DIV^RARTST2A G:'$D(RADIV)!('$D(RAIMAG))!('$D(RASRT))!('$D(RAPRT)) Q
        G DIP K RA4,RAF408
        ;
2       ;;Individual Ward Distribution
        N RAOMA S RAOMA=""
        S Y=$O(^RABTCH(74.3,"B","WARD REPORTS",0)) Q:'Y  S RAB=Y
        D DIV^RARTST2A G:'$D(RADIV)!('$D(RAIMAG))!('$D(RASRT))!('$D(RAPRT)) Q
        S RADIC(0)="AEMQ",RADIC="^DIC(42,",RADIC("A")="Select Ward: "
        S RADIC("S")="I $P(^(0),U,11)=RA4(RADIV)"
        D EN1^RASELCT(.RADIC,"WARD/CLIN") K RADIC I RAQUIT G Q
        K RA4,RAF408,RAQUIT S RANGE="^^6" G DIP
        ;
3       ;;Single Clinic Distribution
        N RAOMA S RAOMA=""
        S Y=$O(^RABTCH(74.3,"B","CLINIC REPORTS",0)) Q:'Y  S RAB=Y
        D DIV^RARTST2A G:'$D(RADIV)!('$D(RAIMAG))!('$D(RASRT))!('$D(RAPRT)) Q
        S RADIC(0)="AEMQ",RADIC="^SC(",RADIC("A")="Select Clinic: "
        S RADIC("S")="N RA44 S RA44=$G(^(0)) I $P(RA44,U,3)'=""W"",($P(RA44,U,15)=RA4(RADIV))"
        D EN1^RASELCT(.RADIC,"WARD/CLIN") K RADIC I RAQUIT G Q
        K RA4,RAF408,RAQUIT S RANGE="^^8" G DIP
        ;
4       ;;Distribution File Activity
        S DIC="^RABTCH(74.3,",DIC(0)="AEMQ",DIC("A")="Select Routing Queue: ",DIC("B")="WARD REPORTS" D ^DIC K DIC G:Y<0 Q41 S RAB=+Y,RABN=$P(Y,"^",2)
        S ZTRTN="S4^RARTST1",ZTSAVE("RAB")="",ZTSAVE("RABN")="" D ZIS^RAUTL G Q4:RAPOP
S4      U IO D HD4 F RADTI=0:0 S RADTI=$O(^RABTCH(74.3,RAB,"L",RADTI)) Q:'RADTI  I $D(^(RADTI,0)) S X=^(0),RADTE=$P(X,"^"),RACT=$P(X,"^",2),RADUZ=+$P(X,"^",3),RARTMES=$P(X,"^",4),RARTCNT=+$P(X,"^",5) D P4 Q:"^"[X
Q4      K DIC,RAPOP,RADTI,RAPAGE,RARTCNT,RABN,RAIOM,RAIOSL,RAB,RADTE,RADATE,RADUZ,RACT,RARTMES,X,Y D CLOSE^RAUTL
Q41     K POP,DUOUT,I,RAMES,ZTDESC,ZTRTN,ZTSAVE
        Q
P4      N DIERR
        S Y=RADTE D D^RAUTL S RADATE=Y,RACT=$S(RACT="P":"PRINT",RACT="R":"RE-PRINT",1:"UNKNOWN"),RADUZ=$$GET1^DIQ(200,RADUZ_",",.01) S:RADUZ="" RADUZ="UNKNOWN"
        D HD4:($Y+4)>IOSL Q:"^"[X  W !,RADATE,?20,RACT,?30,$E(RADUZ,1,15),?50,$E(RARTMES,1,20),?72,RARTCNT
        Q
HD4     S RAPAGE=$S($D(RAPAGE):RAPAGE+1,1:1)
        I RAPAGE>1 R !!,"Press RETURN to continue or '^' to stop",X:DTIME I X["^" S X="^" Q
        W @IOF,!,RABN_" Distribution Activity Log",?70,"Page: ",RAPAGE,!,"Run Date: " S X="NOW",%DT="TX" D ^%DT K %DT D D^RAUTL W Y
        W !!,"Log Date",?20,"Activity",?30,"User",?50,"Comment",?72,"Qty",!,"--------",?20,"--------",?30,"----",?50,"-------",?72,"---" Q
        ;
5       ;;Unprinted Reports List
        S DHD="Unprinted Reports List",FLDS="[RA ALL UNPRINTED REPORTS]",BY="[RA ALL UNPRINTED]",RARPTFLG=""
        S DIS(0)="S Y=$G(^RABTCH(74.4,D0,0)) I Y S RARPT=+Y,RAB=$P(Y,U,11),RARDIFN=D0,RAY3=$G(^RABTCH(74.4,RARDIFN,0)) I RAY3]"""" S RADFN=+$P($G(^RARPT(RARPT,0)),U,2) D UPDLOC^RAUTL10 I $D(RAPRTOK)" D DIP^RARTST3
        K DISH,F,O,RARPTFLG,W,I,POP
        Q
6       ;;Clinic Distribution List
        S DIC="^SC(",RAWC="Clinic",Y=$O(^RABTCH(74.3,"B","CLINIC REPORTS",0)) Q:'Y  S RAB=+Y G SELECT^RARTST3
        ;
7       ;;Ward Distribution List
        S RAWC="Ward",DIC="^DIC(42,",Y=$O(^RABTCH(74.3,"B","WARD REPORTS",0)) I 'Y K I,POP Q
        S RAB=+Y G SELECT^RARTST3
        ;
8       ;;Report's Print Status
        S DIC("A")="Select Report: ",DIC="^RARPT(",DIC(0)="AEMQZ"
        S DIC("S")="I $P(^(0),U,5)'=""X"""
        D DICW,^DIC K DIC I Y<0 D 81 Q
        I $P(Y(0),"^",5)'="V" W !!,$C(7),"Report has not been 'verified'." W ! D 81 G 8
        I '$D(^RABTCH(74.4,"B",+Y)) W !!,$C(7),"Report is not in any distribution queue." W ! D 81 G 8
        S RADFN=+$P(Y(0),U,2),(D0,RARPT)=+Y F RAD0=0:0 S RAD0=$O(^RABTCH(74.4,"B",D0,RAD0)) Q:RAD0'>0  S RAB=$S($D(^RABTCH(74.4,RAD0,0)):$P(^(0),"^",11),1:""),RARDIFN=RAD0,RAY3=$G(^RABTCH(74.4,RARDIFN,0)) I RAY3]"" D UPDLOC^RAUTL10
        K DXS D RPTST^RARTST2A(RARPT)
81      K %,C,D,D0,DDH,DILCT,DIPGM,DISTP,DN,DISYS,POP,RASSN,RAY3
        K %,DIXX,DXS,I,RAB,RABTY,RACN,RAD0,RADFN,RAPRTOK,RARDIFN,RARPT,X,X1,Y
        Q
DIP     ;RANGE defined only if prt'g via 'Individual Ward' or 'Single Clinic'
        ;D DIV^RARTST2A G:'$D(RADIV)!('$D(RAIMAG))!('$D(RASRT))!('$D(RAPRT)) Q
        I $D(RANGE) S RANGE=$TR(RANGE,"^","~")
        ;**** NEXT LINE FOR TESTING ONLY ***
        ;D ^%ZIS D START^RARTST2
        W ! S ZTRTN="START^RARTST2",ZTSAVE("RADIV")="",ZTSAVE("RAIMAG(")="",ZTSAVE("RASRT")="",ZTSAVE("RAB")="",ZTSAVE("RALOCSRT")="",IOP="Q"
        S:$D(RABEG) ZTSAVE("RABEG")="",ZTSAVE("RAEND")=""
        S:$D(RA4) ZTSAVE("RA4(")="" S:$D(RAF408) ZTSAVE("RAF408(")=""
        I $D(RANGE) S ZTSAVE("RANGE")="",ZTSAVE("^TMP($J,""WARD/CLIN"",")=""
        D ZIS^RAUTL K IOP
Q       K %,%DT,D,D0,D1,DA,DDH,DIC,DIE,DIR,DIRUT,DIXX,J,POP,RAB,RABEG,RACN,RADIV,RAEND,RAIMAG,RANGE,RAPOP,RAPRT,RAQUIT,RARD,RARTST1,RALOCSRT,RASRT,X,X1,Y,^TMP($J,"WARD/CLIN")
        D CLOSE^RAUTL K DISYS,DUOUT,I,POP,RA4,RAF408,RAMES,ZTDESC,ZTRTN,ZTSAVE
        Q
DICW    ; Build DIC("W") string
        N DO D DO^DIC1
        S DIC("W")=$S($G(DIC("W"))]"":DIC("W")_" ",1:"")_"W ""   "",$$FLD^RARTFLDS(+Y,""PROC"")"
        Q
