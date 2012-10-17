SPNRPCG ;SD/WDE - Returns PROSTHETIC DEVICES ;JUL 28, 2008
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ; References to ^RMPR(660 supported by IA# 4975
        ; Reference to API PSASHCPC^RMPOPF supported by IA# 4975
        ; API $$FLIP^SPNRPCIC is part of Spinal Cord Version 3.0
        ;
        ;     dfn is ien of the pt
        ;     cutdate is the date to start collection data from
        ;     root is the sorted data in latest date of test first
        ; TMP WILL LOOK CONTAIN
        ; HCPCS CODE ^ ITEM DESCRIPTION ^ DATE DELIVERED ^ RMPR(IEN
        ;
COL(ROOT,ICN,CUTDATE)   ;
        S X=CUTDATE S %DT="T" D ^%DT S CUTDATE=Y
        K ^TMP($J)
        S ROOT=$NA(^TMP($J))
        ;*********************************
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:$G(DFN)=""
        ;********************************
        D BLDUTIL
        D RESORT
        K CNT,ORDER,CUTDATE,HCPCS,ITEMNAM,SHOWDT,REVDT
        K %DT,A,OLDCNT,X,Y,DFN,RMPRHCDT,RMPRHCPC,RMPREHC,RMPRTHC
        K ITEMNUM  ;WDE
        Q
        ;
        ;
BLDUTIL ;
        S CNT=1
        ;S ORDER=0 F  S ORDER=$O(^RMPR(664.1,"D",DFN,ORDER)) Q:(ORDER="")!('+ORDER)  D
        S ORDER=0 F  S ORDER=$O(^RMPR(660,"C",DFN,ORDER)) Q:(ORDER="")!('+ORDER)  D
        .;JAS 03-06-07 Sections below were modified to reflect new DBIAs
        .;I $P($G(^RMPR(664.1,ORDER,7)),U,2)<CUTDATE Q
        .;S Y=$P($G(^RMPR(664.1,ORDER,7)),U,2)
        .I $P($G(^RMPR(660,ORDER,0)),U,12)<CUTDATE Q
        .S Y=$P($G(^RMPR(660,ORDER,0)),U,12)
        .Q:Y<CUTDATE
        .S REVDT=9999999-Y
        .D DD^%DT S SHOWDT=Y
        .;JAS 03-06-07 Sections below were modified to reflect new DBIAs
        .;S ITEMIEN=0 F  S ITEMIEN=$O(^RMPR(664.1,ORDER,2,ITEMIEN)) Q:(ITEMIEN=0)!('+ITEMIEN)  D
        .;.S ITEMNUM=$P($G(^RMPR(664.1,ORDER,2,ITEMIEN,0)),U,1)
        .;.Q:ITEMNUM=""
        .;.S IFCAPITM=0 S IFCAPITM=$P($G(^RMPR(661,ITEMNUM,0)),U,1)
        .;.S HCPCS=$P($G(^RMPR(664.1,ORDER,2,ITEMIEN,2)),U,1)
        .;.I HCPCS="" S HCPCS="-----"
        .;.S HCPCS=$P($G(^RMPR(661.1,HCPCS,0)),U,1)
        .;.I HCPCS="" S HCPCS="-----"
        .;.S ITEMNAM="" S ITEMNAM=$P($G(^PRC(441,IFCAPITM,0)),U,2)
        .;.;W !,DFN W !?10,ITEMIEN,?18,ITEMNUM,?28,IFCAPITM,?35,ITEMNAM,!?28,HCPCS
        .;S ^TMP($J,"UTIL",REVDT,CNT)=HCPCS_U_ITEMNAM_U_SHOWDT_U_"RMPR(664.1("_ORDER
        .S RMPRHCDT=$P(^RMPR(660,ORDER,0),"^",1)
        .Q:'$D(^RMPR(660,ORDER,1))
        .S RMPRHCPC=$P(^RMPR(660,ORDER,1),"^",4)
        .Q:RMPRHCPC=""
        .D PSASHCPC^RMPOPF
        .S HCPCS=RMPREHC
        .I HCPCS="" S HCPCS="-----"
        .S ITEMNAM=RMPRTHC
        .S ^TMP($J,"UTIL",REVDT,CNT)=HCPCS_U_ITEMNAM_U_SHOWDT_U_"RMPR(660("_ORDER
        .S (HCPCS,ITEMNAM,ITEMNUM)=""
        .S CNT=CNT+1
        .Q
        Q
RESORT  ;
        S CNT=""
        S REVDT="" F  S REVDT=$O(^TMP($J,"UTIL",REVDT)) Q:(REVDT="")!('+REVDT)  D
        .S OLDCNT="" F  S OLDCNT=$O(^TMP($J,"UTIL",REVDT,OLDCNT)) Q:(OLDCNT="")!('+OLDCNT)  D
        ..S CNT=CNT+1
        ..S ^TMP($J,CNT)=$G(^TMP($J,"UTIL",REVDT,OLDCNT))_"^EOL999"
        ..Q
        .Q
        K ^TMP($J,"UTIL")
        Q
