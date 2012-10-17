SDRRCRRP        ;10n20/MAH;Print Clinic Recall List Routine ;Nov 16, 2006
        ;;5.3;Scheduling;**536**;Aug 13, 1993;Build 53
        ;
PRT     U IO S (PAGE,DIV,CLINIC,PROV,MONTH,RDT,PAT)=0
        D HDR
        F  S DIV=$O(^TMP($J,"ONDIV",DIV)) Q:DIV=""  D
        .F  S CLINIC=$O(^TMP($J,"ONDIV",DIV,CLINIC)) Q:CLINIC=""  W !,?1,"Clinic: "_CLINIC D
        ..F  S PROV=$O(^TMP($J,"ONDIV",DIV,CLINIC,PROV)) Q:PROV=""  W !,?1,"Provider: "_PROV D
        ...F  S MONTH=$O(^TMP($J,"ONDIV",DIV,CLINIC,PROV,MONTH)) Q:MONTH=""  D
        ....F  S RDT=$O(^TMP($J,"ONDIV",DIV,CLINIC,PROV,MONTH,RDT)) Q:RDT=""   D
        .....S CNT=0 F  S PAT=$O(^TMP($J,"ONDIV",DIV,CLINIC,PROV,MONTH,RDT,PAT)) Q:PAT=""  S CNT=CNT+1 D
        ......S DTA=$G(^TMP($J,"ONDIV",DIV,CLINIC,PROV,MONTH,RDT,PAT))
        ......S DATE=$P($G(DTA),"^",3),CDT=$P($G(DTA),"^",4),PAT=$P($G(DTA),"^",5),PHONE=$P($G(DTA),"^",6)
        ......S USER1=$P($G(DTA),"^",8),COMMENT=$P($G(DTA),"^",7),LN=$P($G(DTA),"^",9)
        ......I ($Y+3)>IOSL D HDR
        ......W !,?5,DATE,?18,CDT,?34,PAT,?65,LN,?71,PHONE,?88,USER1,!,?5,COMMENT
        .....W !!,"Daily Sub-Total for "_CLINIC_" - ("_CNT_")",!!
        K ^TMP($J,"ONDIV"),DIV,CLINIC,PROV,MONTH,RDT,PAT,CNT,CDT,COMMENT,DATE,DT1,DTA,EDT,EDT1,LN,PAGE,SDT,SDT1,PHONE,USER1
        Q
PRT1    U IO S (PAGE,DIV,CLINIC,PROV,MONTH,RDT,PAT)=0
        D HDR
        F  S DIV=$O(^TMP($J,"ENDIV",DIV)) Q:DIV=""  D
        .I $Y>(IOSL-6) D HDR
        .F  S CLINIC=$O(^TMP($J,"ENDIV",DIV,CLINIC)) Q:CLINIC=""  W !,?1,"Clinic: "_CLINIC D
        ..F  S PROV=$O(^TMP($J,"ENDIV",DIV,CLINIC,PROV)) Q:PROV=""  W !,?1,"Provider: "_PROV D
        ...F  S MONTH=$O(^TMP($J,"ENDIV",DIV,CLINIC,PROV,MONTH)) Q:MONTH=""  D
        ....F  S RDT=$O(^TMP($J,"ENDIV",DIV,CLINIC,PROV,MONTH,RDT)) Q:RDT=""   D
        .....S CNT=0 F  S PAT=$O(^TMP($J,"ENDIV",DIV,CLINIC,PROV,MONTH,RDT,PAT)) Q:PAT=""  S CNT=CNT+1 D
        ......S DTA=$G(^TMP($J,"ENDIV",DIV,CLINIC,PROV,MONTH,RDT,PAT))
        ......S DATE=$P($G(DTA),"^",3),CDT=$P($G(DTA),"^",4),PAT=$P($G(DTA),"^",5),PHONE=$P($G(DTA),"^",6)
        ......S USER1=$P($G(DTA),"^",8),COMMENT=$P($G(DTA),"^",7),LN=$P($G(DTA),"^",9)
        ......I ($Y+3)>IOSL D HDR
        ......W !,?5,DATE,?18,CDT,?34,PAT,?65,LN,?71,PHONE,?88,USER1,!,?5,COMMENT
        .....W !!,"Daily Sub-Total for "_CLINIC_" - ("_CNT_")",!!
        K ^TMP($J,"ENDIV"),DIV,CLINIC,PROV,MONTH,RDT,PAT,CNT,CDT,COMMENT,DATE,DT1,DTA,EDT,EDT1,LN,PAGE,SDT,SDT1,PHONE,USER1
        Q
PRT2    U IO S (PAGE,DIV,CLINIC,PROV,MONTH,RDT,PAT)=0
        D HDR
        F  S DIV=$O(^TMP($J,"ONCLIN",DIV)) Q:DIV=""  D
        .F  S CLINIC=$O(^TMP($J,"ONCLIN",DIV,CLINIC)) Q:CLINIC=""  W !,?1,"Clinic: "_CLINIC D
        ..F  S PROV=$O(^TMP($J,"ONCLIN",DIV,CLINIC,PROV)) Q:PROV=""  W !,?1,"Provider: "_PROV D
        ...F  S MONTH=$O(^TMP($J,"ONCLIN",DIV,CLINIC,PROV,MONTH)) Q:MONTH=""  D
        ....F  S RDT=$O(^TMP($J,"ONCLIN",DIV,CLINIC,PROV,MONTH,RDT)) Q:RDT=""   D
        .....S CNT=0 F  S PAT=$O(^TMP($J,"ONCLIN",DIV,CLINIC,PROV,MONTH,RDT,PAT)) Q:PAT=""  S CNT=CNT+1 D
        ......S DTA=$G(^TMP($J,"ONCLIN",DIV,CLINIC,PROV,MONTH,RDT,PAT))
        ......S DATE=$P($G(DTA),"^",3),CDT=$P($G(DTA),"^",4),PAT=$P($G(DTA),"^",5),PHONE=$P($G(DTA),"^",6)
        ......S USER1=$P($G(DTA),"^",8),COMMENT=$P($G(DTA),"^",7),LN=$P($G(DTA),"^",9)
        ......I ($Y+3)>IOSL D HDR
        ......W !,?5,DATE,?18,CDT,?34,PAT,?65,LN,?71,PHONE,?88,USER1,!,?5,COMMENT
        .....W !!,"Daily Sub-Total for "_CLINIC_" - ("_CNT_")",!!
        K ^TMP($J,"ONCLIN"),DIV,CLINIC,PROV,MONTH,RDT,PAT,CNT,CDT,COMMENT,DATE,DT1,DTA,EDT,EDT1,LN,PAGE,SDT,SDT1,PHONE,USER1
        Q
PRT3    U IO S (PAGE,DIV,CLINIC,PROV,MONTH,RDT,PAT)=0
        D HDR
        F  S DIV=$O(^TMP($J,"ENCLIN",DIV)) Q:DIV=""  D
        .F  S CLINIC=$O(^TMP($J,"ENCLIN",DIV,CLINIC)) Q:CLINIC=""  W !,?1,"Clinic: "_CLINIC D
        ..F  S PROV=$O(^TMP($J,"ENCLIN",DIV,CLINIC,PROV)) Q:PROV=""  W !,?1,"Provider: "_PROV D
        ...F  S MONTH=$O(^TMP($J,"ENCLIN",DIV,CLINIC,PROV,MONTH)) Q:MONTH=""  D
        ....F  S RDT=$O(^TMP($J,"ENCLIN",DIV,CLINIC,PROV,MONTH,RDT)) Q:RDT=""   D
        .....S CNT=0 F  S PAT=$O(^TMP($J,"ENCLIN",DIV,CLINIC,PROV,MONTH,RDT,PAT)) Q:PAT=""  S CNT=CNT+1 D
        ......S DTA=$G(^TMP($J,"ENCLIN",DIV,CLINIC,PROV,MONTH,RDT,PAT))
        ......S DATE=$P($G(DTA),"^",3),CDT=$P($G(DTA),"^",4),PAT=$P($G(DTA),"^",5),PHONE=$P($G(DTA),"^",6)
        ......S USER1=$P($G(DTA),"^",8),COMMENT=$P($G(DTA),"^",7),LN=$P($G(DTA),"^",9)
        ......I ($Y+3)>IOSL D HDR
        ......W !,?5,DATE,?18,CDT,?34,PAT,?65,LN,?71,PHONE,?88,USER1,!,?5,COMMENT
        .....W !!,"Daily Sub-Total for "_CLINIC_" - ("_CNT_")",!!
        K ^TMP($J,"ENCLIN"),DIV,CLINIC,PROV,MONTH,RDT,PAT,CNT,CDT,COMMENT,DATE,DT1,DTA,EDT,EDT1,LN,PAGE,SDT,SDT1,PHONE,USER1
        Q
PRT4    U IO S (PAGE,DIV,CLINIC,PROV,MONTH,RDT,PAT)=0
        D HDR
        F  S DIV=$O(^TMP($J,"ENTEAM",DIV)) Q:DIV=""  W !,?1,"Team: "_DIV D
        .F  S CLINIC=$O(^TMP($J,"ENTEAM",DIV,CLINIC)) Q:CLINIC=""  W !,?1,"Clinic: "_CLINIC D
        ..F  S PROV=$O(^TMP($J,"ENTEAM",DIV,CLINIC,PROV)) Q:PROV=""  W !,?1,"Provider: "_PROV D
        ...F  S MONTH=$O(^TMP($J,"ENTEAM",DIV,CLINIC,PROV,MONTH)) Q:MONTH=""  D
        ....F  S RDT=$O(^TMP($J,"ENTEAM",DIV,CLINIC,PROV,MONTH,RDT)) Q:RDT=""   D
        .....S CNT=0 F  S PAT=$O(^TMP($J,"ENTEAM",DIV,CLINIC,PROV,MONTH,RDT,PAT)) Q:PAT=""  S CNT=CNT+1 D
        ......S DTA=$G(^TMP($J,"ENTEAM",DIV,CLINIC,PROV,MONTH,RDT,PAT))
        ......S DATE=$P($G(DTA),"^",3),CDT=$P($G(DTA),"^",4),PAT=$P($G(DTA),"^",5),PHONE=$P($G(DTA),"^",6)
        ......S USER1=$P($G(DTA),"^",8),COMMENT=$P($G(DTA),"^",7),LN=$P($G(DTA),"^",9)
        ......I ($Y+3)>IOSL D HDR
        ......W !,?5,DATE,?18,CDT,?34,PAT,?65,LN,?71,PHONE,?88,USER1,!,?5,COMMENT
        .....W !!,"Daily Sub-Total for "_CLINIC_" - ("_CNT_")",!!
        K ^TMP($J,"ENTEAM"),DIV,CLINIC,PROV,MONTH,RDT,PAT,CNT,CDT,COMMENT,DATE,DT1,DTA,EDT,EDT1,LN,PAGE,SDT,SDT1,PHONE,USER1
        Q
PRT5    U IO S (PAGE,DIV,CLINIC,PROV,MONTH,RDT,PAT)=0
        D HDR
        F  S DIV=$O(^TMP($J,"ONTEAM",DIV)) Q:DIV=""  W !,?1,"Team: "_DIV D
        .F  S CLINIC=$O(^TMP($J,"ONTEAM",DIV,CLINIC)) Q:CLINIC=""  W !,?1,"Clinic: "_CLINIC D
        ..F  S PROV=$O(^TMP($J,"ONTEAM",DIV,CLINIC,PROV)) Q:PROV=""  W !,?1,"Provider: "_PROV D
        ...F  S MONTH=$O(^TMP($J,"ONTEAM",DIV,CLINIC,PROV,MONTH)) Q:MONTH=""  D
        ....F  S RDT=$O(^TMP($J,"ONTEAM",DIV,CLINIC,PROV,MONTH,RDT)) Q:RDT=""   D
        .....S CNT=0 F  S PAT=$O(^TMP($J,"ONTEAM",DIV,CLINIC,PROV,MONTH,RDT,PAT)) Q:PAT=""  S CNT=CNT+1 D
        ......S DTA=$G(^TMP($J,"ONTEAM",DIV,CLINIC,PROV,MONTH,RDT,PAT))
        ......S DATE=$P($G(DTA),"^",3),CDT=$P($G(DTA),"^",4),PAT=$P($G(DTA),"^",5),PHONE=$P($G(DTA),"^",6)
        ......S USER1=$P($G(DTA),"^",8),COMMENT=$P($G(DTA),"^",7),LN=$P($G(DTA),"^",9)
        ......I ($Y+3)>IOSL D HDR
        ......W !,?5,DATE,?18,CDT,?34,PAT,?65,LN,?71,PHONE,?88,USER1,!,?5,COMMENT
        .....W !!,"Daily Sub-Total for "_CLINIC_" - ("_CNT_")",!!
        K ^TMP($J,"ONTEAM"),DIV,CLINIC,PROV,MONTH,RDT,PAT,CNT,CDT,COMMENT,DATE,DT1,DTA,EDT,EDT1,LN,PAGE,SDT,SDT1,PHONE,USER1
        Q
        ;
HDR     ;
        S PAGE=PAGE+1
        S Y=DT D DD^%DT S DT1=Y K Y
        S Y=SDT D DD^%DT S SDT1=Y K Y
        S Y=EDT D DD^%DT S EDT1=Y K Y
        W @IOF
        W ?30,"OUTPATIENT CLINIC RECALL LIST"
        W !,?25,"For date range: "_SDT1_" to "_EDT1
        W !,?30,"Date printed:  "_DT1_"   Page: ",$J(PAGE,3),!
        W !,"Provider",?5,"Recall Date",?18,"Date CS",?34,"Patient",?65,"1U4N",?71,"Phone",?88,"Entered by"
        W !,?5,"Comments",!
        S $P(LINE,"-",IOM)="-"
        W LINE,! K LINE
        Q
