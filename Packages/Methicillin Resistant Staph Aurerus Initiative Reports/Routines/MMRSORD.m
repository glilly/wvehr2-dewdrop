MMRSORD ;MIA/LMT - Print ward census showing which patients need a nares swab ;02-22-09
        ;;1.0;MRSA PROGRAM TOOLS;;Mar 22, 2009;Build 35
        ;
MAIN    ;
        N EXTFLG,MMRSDIV,MMRSLOC
        D CHECK^MMRSIPC
        D CHECK2^MMRSIPC
        I $D(EXTFLG) W ! H 2 Q
        W !
        S MMRSDIV=$$GETDIV^MMRSIPC Q:$D(EXTFLG)!(MMRSDIV="")
        W !
        D CHECK3^MMRSIPC
        I $D(EXTFLG) W ! H 2 Q
        D PROMPT^MMRSISL Q:$D(EXTFLG)
        D ASKDVC Q:$D(EXTFLG)
        Q
MAIN2   ;
        N MMRSNOW
        D CLEAN
        Q:'$D(MMRSDIV)!('$D(MMRSLOC))
        S MMRSNOW=$$NOW^XLFDT()
        D GETPARAM^MMRSIPC ; Load parameters in temp global
        D SETDATA
        D PRT
        D CLEAN
        Q
CLEAN   ;
        K ^TMP($J,"MMRSIPC")
        K ^TMP($J,"MMRSORD")
        Q
SETDATA ;
        N LOCATION,LOCNAME,DFN,LOCTYPE,MMRSI,SDRESULT,Y,WLOC,WARD,WARDNAME,VAIP
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
        ...S DFN=0 F  S DFN=$O(^DPT("CN",WARDNAME,DFN)) Q:'DFN  D SETDATA2(DFN,LOCATION,LOCNAME)
        S LOCATION=0 F  S LOCATION=$O(MMRSLOC(LOCATION)) Q:'LOCATION  D
        .S LOCNAME=$P($G(^MMRS(104.3,LOCATION,0)),U,1)
        .S WLOC=0 F  S WLOC=$O(^MMRS(104.3,LOCATION,1,WLOC)) Q:'WLOC  D
        ..S WARD=$P($G(^MMRS(104.3,LOCATION,1,WLOC,0)),U,1)
        ..Q:'WARD
        ..;S WARDNAME=$P($G(^DIC(42,WARD,44)),U,1)
        ..;S WARDNAME=$P($G(^SC(+WARDNAME,0)),U,1)
        ..S WARDNAME=$P($G(^DIC(42,WARD,0)),U,1)
        ..Q:WARDNAME=""
        ..S DFN=0 F  S DFN=$O(^DPT("CN",WARDNAME,DFN)) Q:'DFN  D SETDATA2(DFN,LOCATION,LOCNAME)
        Q
SETDATA2(DFN,LOC,LOCNAME)       ;
        N INTT,IEN,INDATE,INIFN,MRSAMDRO,MRSA,MRSACULT,LABORDER,TSTNM,LABTEST,ORDITM,ORDTEMP,PATNM,VADM
        ;Get unit admission date and Transaction Type
        D KVA^VADPT
        S VAIP("D")=MMRSNOW
        D IN5^VADPT
        I 'VAIP(1) Q
        S INTT=$$TRANTYPE^MMRSIPC2(+VAIP(4),+VAIP(2))
        F  Q:(INTT=1)!(INTT=2&$$CNGWARD^MMRSIPC2(LOC,+VAIP(5),+VAIP(15,4)))!(VAIP(15)="")  D
        .S IEN=+VAIP(15)
        .D KVA^VADPT
        .S VAIP("E")=IEN
        .D IN5^VADPT
        .S INTT=$$TRANTYPE^MMRSIPC2(+VAIP(4),+VAIP(2))
        I INTT<1!(INTT>2) Q
        S INDATE=+VAIP(3)
        S INIFN=+VAIP(1)
        I '$G(INIFN) Q
        ;Get MRSA history
        S MRSAMDRO=1
        S MRSA=$P($$GETLAB^MMRSIPC3(DFN,MRSAMDRO,$$FMADD^XLFDT(MMRSNOW,-365),MMRSNOW,"CD"),U,2)
        ;Get Order info
        S LABORDER="^^"
        S TSTNM="MRSA SURVL NARES DN"
        F  S TSTNM=$O(^LAB(60,"B",TSTNM)) Q:TSTNM=""!(TSTNM]"MRSA SURVL NARES DNA~zzz")  D
        .I TSTNM'["MRSA SURVL NARES DNA" Q
        .S LABTEST=0 F  S LABTEST=$O(^LAB(60,"B",TSTNM,LABTEST)) Q:'LABTEST  D
        ..S ORDITM=0 F  S ORDITM=$O(^ORD(101.43,"ID",LABTEST_";99LRT",ORDITM)) Q:'ORDITM  D
        ...S ORDTEMP=$$GETORD(DFN,ORDITM,INDATE)
        ...I $P(LABORDER,U,1)'="YES"!(($P(LABORDER,U,3)'="YES")&($P(ORDTEMP,U,3)="YES")) S LABORDER=ORDTEMP
        S TSTNM="MRSA SURVL NARES AGA"
        F  S TSTNM=$O(^LAB(60,"B",TSTNM)) Q:TSTNM=""!(TSTNM]"MRSA SURVL NARES AGAR~zzz")  D
        .I TSTNM'["MRSA SURVL NARES AGAR" Q
        .S LABTEST=0 F  S LABTEST=$O(^LAB(60,"B",TSTNM,LABTEST)) Q:'LABTEST  D
        ..S ORDITM=0 F  S ORDITM=$O(^ORD(101.43,"ID",LABTEST_";99LRT",ORDITM)) Q:'ORDITM  D
        ...S ORDTEMP=$$GETORD(DFN,ORDITM,INDATE)
        ...I $P(LABORDER,U,1)'="YES"!(($P(LABORDER,U,3)'="YES")&($P(ORDTEMP,U,3)="YES")) S LABORDER=ORDTEMP
        D KVA^VADPT
        D DEM^VADPT
        S PATNM=VADM(1)
        D KVA^VADPT
        S ^TMP($J,"MMRSORD",LOCNAME,PATNM,DFN)=INDATE_U_INTT_U_MRSA_U_LABORDER
        Q
GETORD(DFN,ORDITM,INDATE)       ;
        N RESULT,START,STOP,DAS,STATUS,ORUPCHUK,LABREC
        S RESULT="^^"
        S START=$$FMADD^XLFDT(INDATE,-1)-.0000001
        F  S START=$O(^PXRMINDX(100,"PI",DFN,ORDITM,START)) Q:'START  D
        .S STOP="" F  S STOP=$O(^PXRMINDX(100,"PI",DFN,ORDITM,START,STOP)) Q:STOP=""  D
        ..S DAS="" F  S DAS=$O(^PXRMINDX(100,"PI",DFN,ORDITM,START,STOP,DAS)) Q:DAS=""  D
        ...D EN^ORX8(+DAS)
        ...S STATUS=$P(ORUPCHUK("ORSTS"),U,1)
        ...I STATUS'=2,STATUS'=5,STATUS'=6 Q
        ...S LABREC="NO"
        ...I STATUS=6!(STATUS=2) S LABREC="YES"
        ...I $P(RESULT,U,3)'="YES" S RESULT="YES^"_START_U_LABREC
        Q RESULT
PRT     ;
        N LN,PG,LOCNAME,PATNM,DFN,NODE,LAST4,INTT,ADT,ORDDATE,VADM
        ;^TMP($J,"MMRSORD",LOCNAME,PATNM,DFN)=INDATE_U_INTT_U_MRSA_U_LAB
        S $P(LN,"-",101)=""
        S PG=1
        S LOCNAME="" F  S LOCNAME=$O(^TMP($J,"MMRSORD",LOCNAME)) Q:LOCNAME=""  D
        .D PRTHDRS S PATNM="" F  S PATNM=$O(^TMP($J,"MMRSORD",LOCNAME,PATNM)) Q:PATNM=""  D
        ..S DFN=0 F  S DFN=$O(^TMP($J,"MMRSORD",LOCNAME,PATNM,DFN)) Q:'DFN  D
        ...S NODE=$G(^TMP($J,"MMRSORD",LOCNAME,PATNM,DFN))
        ...D KVA^VADPT
        ...D DEM^VADPT
        ...S LAST4=$E($P(VADM(2),U),6,9)
        ...D KVA^VADPT
        ...S INTT=$P(NODE,U,2)
        ...S ADT=$S(INTT=1:"A",INTT=2:"T",1:"")
        ...S ORDDATE=$P(NODE,"^",5)
        ...I ORDDATE S ORDDATE=$$FMTE^XLFDT(ORDDATE,"2M")
        ...W !,$E(PATNM,1,23),?25,LAST4,?32,$$FMTE^XLFDT($P(NODE,"^",1),"2M"),?48,ADT,?53,$P($P(NODE,"^",3),";",1),?65,$P(NODE,"^",4)
        ...W ?75,ORDDATE,?91,$P(NODE,"^",6)
        ...I $Y+2>IOSL D PRTHDRS
        Q
PRTHDRS ; Helper Function for PRT - Prints report headers
        W @IOF
        W ?13,"NARES SWAB ORDER LIST"
        W !,?13,"Geographical Location: ",LOCNAME
        W !,?13,"Report printed on: ",$$FMTE^XLFDT(MMRSNOW),?75,"PAGE: ",PG
        W !!,?32,"DATE",?53,"MRSA IN",?65,"NARES",?91,"LAB"
        W !,"PATIENT",?25,"SSN",?32,"ENTERED WARD",?48,"ADT",?53,"PAST YEAR",?65,"ORDERED",?75,"ORDER DATE",?91,"RECEIVED"
        W !,LN
        S PG=PG+1
        Q
ASKDVC  ;Prompts user for device of output (allows queuing)
        N MMRSVAR,ZTSK
        W !!!,"This report is designed for a 132 column format (compressed).",!
        S MMRSVAR("MMRSLOC")="",MMRSVAR("MMRSLOC(")="",MMRSVAR("MMRSDIV")=""
        D EN^XUTMDEVQ("MAIN2^MMRSORD","Print nares swab order list (MMRSORD)",.MMRSVAR,"QM",1)
        W:$D(ZTSK) !,"Report Queued to Print ("_ZTSK_").",!
        Q
