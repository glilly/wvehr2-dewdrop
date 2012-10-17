MMRSIPC2        ;MIA/LMT - Print MRSA IPEC Report Cont. (Contains functions to collect patient movements) ;10-20-06
        ;;1.0;MRSA PROGRAM TOOLS;**1**;Mar 22, 2009;Build 3
        ;
GETMOVE ;Collects ward movements for patients that were admitted or discharged in date range.
        N LOC,DUPLOC,MMRSLOC2
        S LOC=0 F  S LOC=$O(MMRSLOC(LOC)) Q:'LOC  D
        .S DUPLOC=$$DUPLOC(LOC,.MMRSLOC)
        .I 'DUPLOC S MMRSLOC2(LOC)=""
        .I DUPLOC D
        ..I BYADM D GETADM(LOC)
        ..I 'BYADM D GETDIS(LOC)
        ..I 'BYADM D GETNODIS(LOC) ;For discharge\transmission report show list of patients that have not been discharged yet
        I '$D(MMRSLOC2) Q
        I BYADM D GETADM(0)
        I 'BYADM D GETDIS(0)
        I 'BYADM D GETNODIS(0) ;For discharge\transmission report show list of patients that have not been discharged yet
        Q
GETADM(LOC)     ;
        N TT,MOVDT,MOVIFN,DFN,TRANTYPE,INWARD,INDATE,INIFN,INTT,OUTDATE,OUTIFN,OUTTT,NEXTIEN,LOCNAME,VAIP,INLOC
        F TT=1,2 S MOVDT=STRTDT-.0000001 F  S MOVDT=$O(^DGPM("ATT"_TT,MOVDT)) Q:(MOVDT>ENDDT)!('MOVDT)  D
        .S MOVIFN="" F  S MOVIFN=$O(^DGPM("ATT"_TT,MOVDT,MOVIFN)) Q:'MOVIFN  D
        ..D KVA^VADPT S DFN=$P($G(^DGPM(MOVIFN,0)),"^",3),VAIP("E")=MOVIFN D IN5^VADPT
        ..S TRANTYPE=$$TRANTYPE(+VAIP(4),+VAIP(2))
        ..I TRANTYPE<1!(TRANTYPE=3) Q
        ..S INWARD=+VAIP(5)
        ..I TRANTYPE=2,'$$CNGWARD(LOC,+VAIP(15,4),INWARD) Q
        ..Q:$$EXCWARD(LOC,INWARD)
        ..;SET GLOBAL
        ..S INDATE=+VAIP(3)
        ..S INIFN=MOVIFN
        ..S INTT=TRANTYPE
        ..S (OUTDATE,OUTIFN,OUTTT)=" "
        ..F  Q:(VAIP(16)="")!(OUTIFN)  D
        ...I $$TRANTYPE(+VAIP(16,3),+VAIP(16,2))=3 S OUTDATE=+VAIP(16,1),OUTIFN=VAIP(16),OUTTT=3
        ...I $$TRANTYPE(+VAIP(16,3),+VAIP(16,2))=2,$$CNGWARD(LOC,INWARD,+VAIP(16,4)) S OUTDATE=+VAIP(16,1),OUTIFN=VAIP(16),OUTTT=2
        ...Q:OUTIFN
        ...S NEXTIEN=VAIP(16)
        ...D KVA^VADPT
        ...S VAIP("E")=NEXTIEN
        ...D IN5^VADPT
        ..S INLOC=$G(LOC)
        ..I +INLOC=0 S INLOC=$$GETLOC(INWARD,.MMRSLOC2)
        ..S LOCNAME=$P($G(^MMRS(104.3,INLOC,0)),U)
        ..S ^TMP($J,"MMRSIPC","D",LOCNAME,INDATE,DFN,OUTDATE)=INLOC_U_DFN_U_INDATE_U_INIFN_U_INTT_U_OUTDATE_U_OUTIFN_U_OUTTT
        D KVA^VADPT
        Q
GETDIS(LOC)     ;
        N TT,MOVDT,MOVIFN,DFN,TRANTYPE,OUTDATE,OUTIFN,OUTTT,INWARD,INDATE,INIFN,INTT,PREVIEN,INLOC,LOCNAME,VAIP
        F TT=2,3 S MOVDT=STRTDT-.0000001 F  S MOVDT=$O(^DGPM("ATT"_TT,MOVDT)) Q:(MOVDT>ENDDT)!('MOVDT)  D
        .S MOVIFN="" F  S MOVIFN=$O(^DGPM("ATT"_TT,MOVDT,MOVIFN)) Q:'MOVIFN  D
        ..D KVA^VADPT S DFN=$P($G(^DGPM(MOVIFN,0)),"^",3),VAIP("E")=MOVIFN D IN5^VADPT
        ..I +VAIP(2)=3,+VAIP(15,3)=2 Q  ;Ignore discharges that are immediate following an Authorized Absence
        ..S TRANTYPE=$$TRANTYPE(+VAIP(4),+VAIP(2))
        ..I TRANTYPE<2 Q
        ..I TRANTYPE=2,'$$CNGWARD(LOC,+VAIP(15,4),+VAIP(5)) Q
        ..I $$EXCWARD(LOC,+VAIP(15,4)) Q
        ..S OUTDATE=+VAIP(3)
        ..S OUTIFN=MOVIFN
        ..S OUTTT=TRANTYPE
        ..S INWARD=+VAIP(15,4)
        ..S (INDATE,INIFN,INTT)=""
        ..F  Q:(VAIP(15)="")!(INIFN)  D
        ...S PREVIEN=VAIP(15)
        ...I $$TRANTYPE(+VAIP(15,3),+VAIP(15,2))=1 S INDATE=+VAIP(15,1),INIFN=VAIP(15),INTT=1 ;,INWARD=+VAIP(15,4)
        ...I $$TRANTYPE(+VAIP(15,3),+VAIP(15,2))=2 D
        ....D KVA^VADPT S VAIP("E")=PREVIEN D IN5^VADPT
        ....I $$CNGWARD(LOC,+VAIP(5),+VAIP(15,4)) S INDATE=+VAIP(3),INIFN=VAIP(1),INTT=2 ;,INWARD=+VAIP(16,4)
        ...Q:INIFN
        ...D KVA^VADPT
        ...S VAIP("E")=PREVIEN
        ...D IN5^VADPT
        ..I '$G(INIFN) Q
        ..S INLOC=$G(LOC)
        ..I +INLOC=0 S INLOC=$$GETLOC(INWARD,.MMRSLOC2)
        ..S LOCNAME=$P($G(^MMRS(104.3,INLOC,0)),U)
        ..S ^TMP($J,"MMRSIPC","D",LOCNAME,INDATE,DFN,OUTDATE)=INLOC_U_DFN_U_INDATE_U_INIFN_U_INTT_U_OUTDATE_U_OUTIFN_U_OUTTT
        D KVA^VADPT
        Q
GETNODIS(LOC)   ;For Discharge/Transmission report, it adds patients that have not been discharged from the wards to the report
        N WARD,DFN,TMP,EDT,TT,SDT,INWARD,IEN,INDATE,INTT,INIFN,INLOC,LOCNAME,VAIP
        S WARD="" F  S WARD=$O(^DPT("CN",WARD)) Q:WARD=""  D
        .S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  S TMP(DFN)=""
        S EDT=$$NOW^XLFDT
        F TT=1:1:3 S SDT=ENDDT F  S SDT=$O(^DGPM("AMV"_TT,SDT)) Q:'SDT!(SDT>EDT)  D
        .S DFN=0 F  S DFN=$O(^DGPM("AMV"_TT,SDT,DFN)) Q:'DFN  S TMP(DFN)=""
        S DFN=0 F  S DFN=$O(TMP(DFN)) Q:'DFN  D
        .D KVA^VADPT
        .S VAIP("D")=ENDDT
        .D IN5^VADPT
        .I 'VAIP(1) Q
        .S INWARD=+VAIP(5)
        .Q:$$EXCWARD(LOC,INWARD)
        .S INTT=$$TRANTYPE(+VAIP(4),+VAIP(2))
        .;F  Q:((+VAIP(2)=1)!(VAIP(15)="")!(+VAIP(5)'=+VAIP(15,4)))  D
        .;F  Q:(((INTT=1)!(INTT=2))&((+VAIP(2)=1)!(VAIP(15)="")!($$CNGWARD(LOC,+VAIP(5),+VAIP(15,4)))))  D
        .F  Q:(INTT=1)!(INTT=2&$$CNGWARD(LOC,+VAIP(5),+VAIP(15,4)))!(VAIP(15)="")  D
        ..S IEN=+VAIP(15)
        ..D KVA^VADPT
        ..S VAIP("E")=IEN
        ..D IN5^VADPT
        ..S INTT=$$TRANTYPE(+VAIP(4),+VAIP(2))
        .I INTT<1!(INTT>2) Q
        .S INDATE=+VAIP(3)
        .S INIFN=+VAIP(1)
        .;S INTT=$$TRANTYPE(+VAIP(4),+VAIP(2))
        .I '$G(INIFN) Q
        .S INLOC=$G(LOC)
        .I +INLOC=0 S INLOC=$$GETLOC(INWARD,.MMRSLOC2)
        .S LOCNAME=$P($G(^MMRS(104.3,INLOC,0)),U)
        .S ^TMP($J,"MMRSIPC","D",LOCNAME,INDATE,DFN," ")=INLOC_U_DFN_U_INDATE_U_INIFN_U_INTT_U_" "_U_"0"_U_" "
        D KVA^VADPT
        Q
CNGWARD(LOC,WARD1,WARD2)        ;Did patient change wards?
        I +$G(LOC)=0 S LOC=$$GETLOC(WARD1,.MMRSLOC2)
        I $D(^MMRS(104.3,LOC,1,"B",WARD1)),$D(^MMRS(104.3,LOC,1,"B",WARD2)) Q 0
        Q 1
EXCWARD(LOC,WARD)       ;Is this ward excluded from the reports?
        I +$G(LOC)=0 S LOC=$$GETLOC(WARD,.MMRSLOC2)
        I LOC=0 Q 1
        I $D(^MMRS(104.3,LOC,1,"B",WARD)) Q 0
        Q 1
DUPLOC(LOC,LCTNS)       ;
        N RSLT,WARD,LOC2
        S RSLT=0
        S WARD=0 F  S WARD=$O(^MMRS(104.3,LOC,1,"B",WARD)) Q:'WARD  D
        .S LOC2=0 F  S LOC2=$O(LCTNS(LOC2)) Q:'LOC2  D
        ..Q:LOC2=LOC
        ..I $D(^MMRS(104.3,LOC2,1,"B",WARD)) S RSLT=1
        Q RSLT
GETLOC(WARD,LCTNS)      ;
        N RSLT,LOC
        S RSLT=0
        S LOC=0 F  S LOC=$O(LCTNS(LOC)) Q:'LOC!(RSLT)  D
        .I $D(^MMRS(104.3,LOC,1,"B",WARD)) S RSLT=LOC
        Q RSLT
TRANTYPE(MOVTYPE,TRANTYPE)      ;
        I MOVTYPE=46!(MOVTYPE=5)!(MOVTYPE=6)!(MOVTYPE=7)!(MOVTYPE=47)!(MOVTYPE=27)!(MOVTYPE=33)!(MOVTYPE=3)!(MOVTYPE=22) Q -1 ;MIA/LMT - Removed MOVTYPE 29 ;4/15/10
        I MOVTYPE=42!(MOVTYPE=20)!(MOVTYPE=1)!(MOVTYPE=45)!(MOVTYPE=23)!(MOVTYPE=25)!(MOVTYPE=26) Q -1
        I MOVTYPE=2!(MOVTYPE=43)!(MOVTYPE=13) Q 3
        I MOVTYPE=14!(MOVTYPE=24)!(MOVTYPE=44) Q 1
        Q TRANTYPE
