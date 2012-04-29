GMRAEF2 ;HIRMFO/WAA-FDA EXCEPTION REPORT ;11/29/95  15:01
        ;;4.0;Adverse Reaction Tracking;**33**;Mar 29, 1996;Build 5
EN1     ; Entry to PRINT ALL FDA EXCEPTIONS WITHIN A D/T RANGE option
        S GMRAOUT=0 K DIR
        S DIR(0)="DO^:DT:ETX",DIR("A")="Select Start Date"
        D ^DIR K DIR
        I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) S GMRAOUT=1 G EXIT
        S (GMRABGDT,GMRASTDT)=Y K Y
        S DIR(0)="DO^"_GMRABGDT_":NOW:ETX",DIR("A")="Select End Date",DIR("B")="T"
        D ^DIR K DIR
        I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) S GMRAOUT=1 G EXIT
        S GMRAEDT=Y,GMRAENDT=((Y+1)-.0000001) K Y
EN2     ;
        S GMRABGDT=GMRABGDT-.0000001
        F  S GMRABGDT=$O(^GMR(120.8,"AODT",GMRABGDT)) Q:GMRABGDT<1  Q:GMRABGDT>GMRAENDT  S GMRAIEN=0 F  S GMRAIEN=$O(^GMR(120.8,"AODT",GMRABGDT,GMRAIEN)) Q:GMRAIEN<1  D
        .S GMRA(0)=$G(^GMR(120.8,GMRAIEN,0))
        .Q:$P(GMRA(0),U,2)=""
        .Q:$D(^GMR(120.8,GMRAIEN,"ER"))
        .I $P(GMRA(0),U,6)'="o"!($P(GMRA(0),U,20)'["D") Q
        .I '$P(GMRA(0),U,12) Q
        .I $$CMPFDA^GMRAEF1(GMRAIEN) Q
        .S GMRDFN=$P(GMRA(0),U)
        .Q:'$$PRDTST^GMRAUTL1(GMRDFN)  ;GMRA*4*33 Exclude test patient from report if production or legacy environment.
        .S ^TMP($J,"GMRAEF",GMRDFN,GMRABGDT)=GMRAIEN
        .Q
        D EN1^GMRAEF
EXIT    ;EXIT OF ROUTINE
        K GMRAY,GMRAX,GMRAIEN,GMRDFN,GMRBGDT,GMRENDT,GMRDT,GMRAOUT
        K GMRA,GMRABGDT,GMRAENDT
        Q
