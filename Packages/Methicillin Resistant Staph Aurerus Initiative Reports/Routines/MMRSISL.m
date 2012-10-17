MMRSISL ;MIA/LMT - Print census list and MDRO history ;02-01-07 
        ;;1.0;MRSA PROGRAM TOOLS;;Mar 22, 2009;Build 35
        ;
MAIN    ;
        N EXTFLG,MMRSLOC,MMRSDIV
        D CHECK^MMRSIPC
        D CHECK2^MMRSIPC
        I $D(EXTFLG) W ! H 2 Q
        W !
        S MMRSDIV=$$GETDIV^MMRSIPC Q:$D(EXTFLG)!(MMRSDIV="")
        W !
        D CHECK3^MMRSIPC
        I $D(EXTFLG) W ! H 2 Q
        D PROMPT Q:$D(EXTFLG)
        D ASKDVC Q:$D(EXTFLG)
        Q
MAIN2   ; Entry for queuing
        N USEISLT,MRSAMDRO,MRSADIV,MRSADAYS,IMPMDRO,IMPDIV,IMPDAYS,VREMDRO,VREDIV,VREDAYS,CDIFMDRO,CDIFDIV,CDIFDAYS
        N ESBLMDRO,ESBLDIV,ESBLDAYS
        D CLEAN
        Q:'$D(MMRSDIV)!('$D(MMRSLOC))
        D GETPARAM^MMRSIPC ; Load parameters in temp global
        S USEISLT=+$O(^MMRS(104,MMRSDIV,1,0))
        S MRSAMDRO=1
        S MRSADIV=$O(^MMRS(104.2,MRSAMDRO,1,"B",MMRSDIV,0))
        S MRSADAYS=$P($G(^MMRS(104.2,MRSAMDRO,1,+MRSADIV,0)),U,2)
        S IMPMDRO=2
        S IMPDIV=$O(^MMRS(104.2,IMPMDRO,1,"B",MMRSDIV,0))
        S IMPDAYS=$P($G(^MMRS(104.2,IMPMDRO,1,+IMPDIV,0)),U,2)
        S VREMDRO=3
        S VREDIV=$O(^MMRS(104.2,VREMDRO,1,"B",MMRSDIV,0))
        S VREDAYS=$P($G(^MMRS(104.2,VREMDRO,1,+VREDIV,0)),U,2)
        S CDIFMDRO=4
        S CDIFDIV=$O(^MMRS(104.2,CDIFMDRO,1,"B",MMRSDIV,0))
        S CDIFDAYS=$P($G(^MMRS(104.2,CDIFMDRO,1,+CDIFDIV,0)),U,2)
        S ESBLMDRO=5
        S ESBLDIV=$O(^MMRS(104.2,ESBLMDRO,1,"B",MMRSDIV,0))
        S ESBLDAYS=$P($G(^MMRS(104.2,ESBLMDRO,1,+ESBLDIV,0)),U,2)
        D SETDATA
        D PRT
        D CLEAN
        Q
CLEAN   ;
        K ^TMP($J,"MMRSIPC")
        K ^TMP($J,"MMRSISL")
        Q
PROMPT  ;
        N DIR,Y,DIRUT
        S DIR(0)="YA",DIR("A")="Do you want to select all locations? ",DIR("B")="NO"
        D ^DIR
        I $D(DIRUT) S EXTFLG=1 Q
        I Y=1 S MMRSLOC="ALL" Q
        ;PROMPT FOR WARDS
        N DIC,DLAYGO,Y,DTOUT,DUOUT
        W !
        S DIC("A")="Select Geographical Location: "
        S DIC("S")="I $P($G(^MMRS(104.3,Y,0)),U,2)="_MMRSDIV
        S DIC="^MMRS(104.3,",DIC(0)="QEAM" D ^DIC
        I (Y=-1)!($D(DTOUT))!($D(DUOUT)) S EXTFLG=1 Q
        S MMRSLOC(+Y)=""
        S DIC("A")="Select another Location: " F  D ^DIC Q:Y=-1  S MMRSLOC(+Y)=""
        K DIC
        I ($D(DTOUT))!($D(DUOUT)) S EXTFLG=1 Q
        Q
ASKDVC  ;Prompts user for device of output (allows queuing)
        N MMRSVAR,ZTSK
        W !!!,"This report is designed for a 176 column format (landscape).",!
        S MMRSVAR("MMRSLOC")="",MMRSVAR("MMRSLOC(")="",MMRSVAR("MMRSDIV")=""
        D EN^XUTMDEVQ("MAIN2^MMRSISL","Print isolation report (MMRSISL)",.MMRSVAR,"QM",1)
        W:$D(ZTSK) !,"Report Queued to Print ("_ZTSK_").",!
        Q
SETDATA ;
        N LOCATION,LOCNAME,DFN,LOCTYPE,MMRSI,SDRESULT,Y,WLOC,WARD,WARDNAME
        I $G(MMRSLOC)="ALL" D  Q
        .S LOCATION=0 F  S LOCATION=$O(^MMRS(104.3,LOCATION)) Q:'LOCATION  I $P($G(^MMRS(104.3,LOCATION,0)),U,2)=MMRSDIV D
        ..S LOCNAME=$P($G(^MMRS(104.3,LOCATION,0)),U,1)
        ..S WLOC=0 F  S WLOC=$O(^MMRS(104.3,LOCATION,1,WLOC)) Q:'WLOC  D
        ...S WARD=$P($G(^MMRS(104.3,LOCATION,1,WLOC,0)),U,1)
        ...Q:'WARD
        ...;S WARDNAME=$P($G(^DIC(42,WARD,44)),U,1)
        ...;S WARDNAME=$P($G(^SC(+WARDNAME,0)),U,1)
        ...S WARDNAME=$P($G(^DIC(42,WARD,0)),U,1)
        ...Q:WARDNAME=""
        ...;S LOCNAME="" F  S LOCNAME=$O(^DPT("CN",LOCNAME)) Q:LOCNAME=""  D
        ...S DFN=0 F  S DFN=$O(^DPT("CN",WARDNAME,DFN)) Q:'DFN  D SETDATA2(DFN,LOCNAME)
        S LOCATION=0 F  S LOCATION=$O(MMRSLOC(LOCATION)) Q:'LOCATION  D
        .S LOCNAME=$P($G(^MMRS(104.3,LOCATION,0)),U,1) ;$P($G(^SC(LOCATION,0)),U,1)
        .;S LOCTYPE=$P($G(^SC(LOCATION,0)),U,3)
        .;I LOCTYPE="W" D
        .S WLOC=0 F  S WLOC=$O(^MMRS(104.3,LOCATION,1,WLOC)) Q:'WLOC  D
        ..S WARD=$P($G(^MMRS(104.3,LOCATION,1,WLOC,0)),U,1)
        ..Q:'WARD
        ..;S WARDNAME=$P($G(^DIC(42,WARD,44)),U,1)
        ..;S WARDNAME=$P($G(^SC(+WARDNAME,0)),U,1)
        ..S WARDNAME=$P($G(^DIC(42,WARD,0)),U,1)
        ..Q:WARDNAME=""
        ..S DFN=0 F  S DFN=$O(^DPT("CN",WARDNAME,DFN)) Q:'DFN  D SETDATA2(DFN,LOCNAME)
        .;I LOCTYPE'="W" D
        .;.K ^TMP($J,"SDAMA202")
        .;.D GETPLIST^SDAMA202(LOCATION,"4",,DT,DT_".24",.SDRESULT)
        .;.S MMRSI=0 F  S MMRSI=$O(^TMP($J,"SDAMA202","GETPLIST",MMRSI)) Q:'MMRSI  D
        .;..S DFN=+$G(^TMP($J,"SDAMA202","GETPLIST",MMRSI,4))
        .;..I DFN D SETDATA2(DFN,LOCNAME)
        .;.K ^TMP($J,"SDAMA202")
        Q
SETDATA2(DFN,LOCNAME)   ;
        N NOW,PATNM,MRSA,MRSACULT,IMP,VRE,CDIF,ESBL,VADM,LAST4
        S NOW=$$NOW^XLFDT
        D KVA^VADPT
        D DEM^VADPT
        S PATNM=VADM(1)
        S LAST4=$E($P(VADM(2),U),6,9)
        D KVA^VADPT
        S (MRSA,IMP,VRE,CDIF,ESBL)=""
        I MRSADAYS D
        .S MRSA=$P($$GETLAB^MMRSIPC3(DFN,MRSAMDRO,$$FMADD^XLFDT(NOW,-MRSADAYS),NOW,"CD"),U,2)
        I IMPDAYS S IMP=$P($$GETLAB^MMRSIPC3(DFN,IMPMDRO,$$FMADD^XLFDT(NOW,-IMPDAYS),NOW,"CD"),U,2)
        I VREDAYS S VRE=$P($$GETLAB^MMRSIPC3(DFN,VREMDRO,$$FMADD^XLFDT(NOW,-VREDAYS),NOW,"CD"),U,2)
        I CDIFDAYS S CDIF=$P($$GETLAB^MMRSIPC3(DFN,CDIFMDRO,$$FMADD^XLFDT(NOW,-CDIFDAYS),NOW,"CD"),U,2)
        I ESBLDAYS S ESBL=$P($$GETLAB^MMRSIPC3(DFN,ESBLMDRO,$$FMADD^XLFDT(NOW,-ESBLDAYS),NOW,"CD"),U,2)
        S ^TMP($J,"MMRSISL",LOCNAME,PATNM,DFN)=MRSA_"^"_LAST4_"^"_IMP_"^"_ESBL_"^"_VRE_"^"_CDIF
        I USEISLT D SETISLT(DFN) ;GET ISOLATION ORDERS
        Q
PRT     ;
        N LN,PG,LOCNAME,PATNM,DFN,NODE,MRSA,IMP,ESBL,VRE,CDIFF,MMRSNOW
        S $P(LN,"-",158)=""
        S MMRSNOW=$$NOW^XLFDT()
        S PG=1
        S LOCNAME="" F  S LOCNAME=$O(^TMP($J,"MMRSISL",LOCNAME)) Q:LOCNAME=""  D
        .D PRTHDRS S PATNM="" F  S PATNM=$O(^TMP($J,"MMRSISL",LOCNAME,PATNM)) Q:PATNM=""  D
        ..S DFN=0 F  S DFN=$O(^TMP($J,"MMRSISL",LOCNAME,PATNM,DFN)) Q:'DFN  D
        ...S NODE=$G(^TMP($J,"MMRSISL",LOCNAME,PATNM,DFN))
        ...S MRSA=$S($P($P(NODE,"^",1),";",1)["POS":$$FMTE^XLFDT(9999999-$P($P(NODE,"^",1),";",3),"2M"),1:"")
        ...S IMP=$S($P($P(NODE,"^",3),";",1)["POS":$$FMTE^XLFDT(9999999-$P($P(NODE,"^",3),";",3),"2M"),1:"")
        ...S ESBL=$S($P($P(NODE,"^",4),";",1)["POS":$$FMTE^XLFDT(9999999-$P($P(NODE,"^",4),";",3),"2M"),1:"")
        ...S VRE=$S($P($P(NODE,"^",5),";",1)["POS":$$FMTE^XLFDT(9999999-$P($P(NODE,"^",5),";",3),"2M"),1:"")
        ...S CDIFF=$S($P($P(NODE,"^",6),";",1)["POS":$$FMTE^XLFDT(9999999-$P($P(NODE,"^",6),";",3),"2M"),1:"")
        ...W !,$E(PATNM,1,24),?25,$P(NODE,"^",2),?32,MRSA,?48,IMP,?64,ESBL,?80,VRE,?96,CDIFF
        ...I $Y+2>IOSL D PRTHDRS
        ...I USEISLT D PRTISLT
        Q
PRTISLT ;Print report
        N MMRSI,ISLTNODE
        S MMRSI=0 F  S MMRSI=$O(^TMP($J,"MMRSISL",LOCNAME,PATNM,DFN,MMRSI)) Q:'MMRSI  D
        .I MMRSI>1 W !,$E(PATNM,1,24),?25,$P(NODE,"^",2),?32,MRSA,?48,IMP,?64,ESBL,?80,VRE,?96,CDIFF
        .S ISLTNODE=$G(^TMP($J,"MMRSISL",LOCNAME,PATNM,DFN,MMRSI))
        .W ?112,$P(ISLTNODE,U,1),?142,$P(ISLTNODE,U,2)
        .I $Y+2>IOSL D PRTHDRS
        Q
PRTHDRS ; Helper Function for PRT - Prints report headers
        W @IOF
        W ?13,"CENSUS LIST AND MDRO HISTORY"
        W !,?13,"Geographical Location: ",LOCNAME
        W !,?13,"Report printed on: ",$$FMTE^XLFDT(MMRSNOW),?110,"PAGE: ",PG
        W !!
        W:MRSADAYS ?32,"LAST MRSA POS"
        W:IMPDAYS ?48,"LAST CRB-R POS"
        W:ESBLDAYS ?64,"LAST ESBL POS"
        W:VREDAYS ?80,"LAST VRE POS"
        W:CDIFDAYS ?96,"LAST CDF POS"
        W !,"PATIENT",?25,"SSN"
        W:MRSADAYS ?32,"IN "_MRSADAYS_" DAYS"
        W:IMPDAYS ?48,"IN "_IMPDAYS_" DAYS"
        W:ESBLDAYS ?64,"IN "_ESBLDAYS_" DAYS"
        W:VREDAYS ?80,"IN "_VREDAYS_" DAYS"
        W:CDIFDAYS ?96,"IN "_CDIFDAYS_" DAYS"
        W:USEISLT ?112,"ISOLATION ORDER",?142,"START DATE"
        W !,LN
        S PG=PG+1
        Q
SETISLT(DFN)    ;
        N MMRSI,ISLTIEN,ISLTORD,PRECTYPE
        S MMRSI=1
        S ISLTIEN=0 F  S ISLTIEN=$O(^MMRS(104,MMRSDIV,1,ISLTIEN)) Q:'ISLTIEN  D
        .S ISLTORD=$P($G(^MMRS(104,MMRSDIV,1,ISLTIEN,0)),U,1)
        .S PRECTYPE=$P($G(^MMRS(104,MMRSDIV,1,ISLTIEN,0)),U,2)
        .S PRECTYPE=$$EXTERNAL^DILFD("104.05","1",,PRECTYPE)
        .D SETISLT2(DFN,ISLTORD,PRECTYPE)
        Q
SETISLT2(DFN,ISLTORD,PRECTYPE)  ;
        N ODATE,ORDNUM
        Q:'$D(^OR(100,"AOI",ISLTORD,DFN_";DPT("))
        S ODATE="" F  S ODATE=$O(^OR(100,"AOI",ISLTORD,DFN_";DPT(",ODATE)) Q:ODATE=""  D
        .S ORDNUM="" F  S ORDNUM=$O(^OR(100,"AOI",ISLTORD,DFN_";DPT(",ODATE,ORDNUM)) Q:ORDNUM=""  D
        ..I $P($G(^OR(100,ORDNUM,3)),"^",3)=6  D
        ...S ^TMP($J,"MMRSISL",LOCNAME,PATNM,DFN,MMRSI)=PRECTYPE_U_$$FMTE^XLFDT($P($G(^OR(100,ORDNUM,0)),"^",8),"2D")
        ...S MMRSI=MMRSI+1
        Q
