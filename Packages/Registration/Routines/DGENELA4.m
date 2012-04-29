DGENELA4        ;ALB/CJM,KCL,RTK,LBD,EG,CKN - Patient Eligibility API ; 6/9/08 2:46pm
        ;;5.3;Registration;**232,275,306,327,314,367,417,437,456,491,451,564,672,659,653,688**;Aug 13,1993;Build 29
        ;
        ;
PRIORITY(DFN,DGELG,DGELGSUB,ENRDATE,APPDATE)    ;
        ; Description: Used to compute the priority group and subgroup for a
        ; patient, also returning the subset of the eligibility data on which
        ; the priority subgroup is based.
        ;
        ;Input:
        ;      DFN - ien of patient
        ;    DGELG - ELIGIBILITY object array (optional, pass by reference)
        ;  ENRDATE - The Enrollment Date. This date is used in the priority
        ;            determination only if the application date is not passed.
        ;  APPDATE - The Enrollment Application Date.  This date is used
        ;            to determine the priority. If the application date
        ;            is not passed then the enrollment date (ENRDATE) is used.
        ;
        ;Output:
        ;  Function Value - returns the priority and subgroup computed by the
        ;    function as a 2 piece string 'PRIORITY^SUBGROUP'
        ;  DGELGSUB - this local array will contain the eligibility data on
        ;    which the priority determination was based, pass by reference
        ;    if needed.
        ;
        N CODE,HICODE,PRI,HIPRI,PRIORITY,SUBGRP,HISUB,SUB,DGPAT
        K DGELGSUB S DGELGSUB=""
        S (HICODE,HIPRI,SUBGRP,HISUB)=""
        D
        .I '$D(DGELG),'$$GET^DGENELA(DFN,.DGELG) Q  ;can not proceed with eligibility
        .; can't proceed without an Enrollment Date or Application Date
        .I '$G(ENRDATE),'$G(APPDATE) Q
        .I $$GET^DGENPTA(DFN,.DGPAT)
        .; determine priority/subgroup based on primary eligibility
        .S HICODE=$$NATCODE^DGENELA(DGELG("ELIG","CODE"))
        .S PRIORITY=$$PRI(HICODE,.DGELG,$G(ENRDATE),$G(APPDATE))
        .S HIPRI=$P(PRIORITY,"^"),HISUB=$P(PRIORITY,"^",2)
        .S CODE=""
        .;
        .; determine if other eligibilities result in higher priority/subgroup
        .F  S CODE=$O(DGELG("ELIG","CODE",CODE)) Q:('CODE!(HIPRI=1))  D
        ..S PRIORITY=$$PRI($$NATCODE^DGENELA(CODE),.DGELG,$G(ENRDATE),$G(APPDATE))
        ..S PRI=$P(PRIORITY,"^"),SUB=$P(PRIORITY,"^",2)
        ..S:((PRI>0)&((PRI<HIPRI)!(HIPRI=""))) HIPRI=PRI,HICODE=$$NATCODE^DGENELA(CODE),HISUB=SUB
        ..S:((PRI=HIPRI)&((SUB>0)&(SUB<HISUB))) HIPRI=PRI,HICODE=$$NATCODE^DGENELA(CODE),HISUB=SUB
        .;
        .;set the DGELGSUB() array with the eligibility information used in the
        .;priority determination
        .S DGELGSUB("CODE")=HICODE,DGELGSUB("SC")=DGELG("SC"),DGELGSUB("SCPER")=DGELG("SCPER"),DGELGSUB("POW")=DGELG("POW"),DGELGSUB("A&A")=DGELG("A&A"),DGELGSUB("HB")=DGELG("HB")
        .S DGELGSUB("VAPEN")=DGELG("VAPEN"),DGELGSUB("VACKAMT")=DGELG("VACKAMT"),DGELGSUB("DISRET")=DGELG("DISRET"),DGELGSUB("DISLOD")=DGELG("DISLOD")
        .S DGELGSUB("MEDICAID")=DGELG("MEDICAID"),DGELGSUB("AO")=DGELG("AO"),DGELGSUB("IR")=DGELG("IR"),DGELGSUB("EC")=DGELG("EC"),DGELGSUB("MTSTA")=DGELG("MTSTA")
        .;Purple Heart Added to DGELGSUB
        .S DGELGSUB("VCD")=DGELG("VCD"),DGELGSUB("PH")=DGELG("PH")
        .;Added for HVE Phase III (DG*5.3*564)
        .S DGELGSUB("UNEMPLOY")=DGELG("UNEMPLOY"),DGELGSUB("CVELEDT")=DGELG("CVELEDT"),DGELGSUB("SHAD")=DGELG("SHAD")
        .;added dg*5.3*659
        .S DGELGSUB("RADEXPM")=DGELG("RADEXPM")
        .S DGELGSUB("AOEXPLOC")=DGELG("AOEXPLOC")
        .I $G(DGPAT("INELDATE"))'="" S (HIPRI,HISUB)=""
        ;
        Q HIPRI_$S(HIPRI:"^"_HISUB,1:"")
        ;
        ;
PRI(CODE,DGELG,ENRDATE,APPDATE) ;
        ; Description: Returns the priority group and subgroup based on a
        ; single eligibility code.
        ;Input -
        ;  CODE - pointer to file #8.1, MAS Eligibility Code
        ;  DGELG - local array obtained by calling $$GET, pass by reference
        ;  ENRDATE - The Enrollment Date. This date is used in the priority
        ;            determination only if the application date is not passed.
        ;  APPDATE - The Enrollment Application Date.  This date is used
        ;            to determine the priority. If the application date
        ;            is not passed then the enrollment date (ENRDATE) is used.
        ;
        ;Output -
        ;  Function Value - returns the priority and subgroup computed by the
        ;   function as a 2 piece string 'PRIORITY^SUBGROUP'
        ;
        N CODENAME,PRIORITY,MTSTA,SUBGRP,DGEGT,PRISUB,DGMTI,MTTHR,GMTTHR
        S SUBGRP=""
        ;
        ; use the Application Date when determining the priority, otherwise use
        ; the Enrollment Date (ESP DG*5,3*491)
        S ENRDATE=$S($G(APPDATE):APPDATE,1:$G(ENRDATE))
        ;
        ;get the name of the national eligibility code
        S CODENAME=$$CODENAME^DGENELA(CODE)
        ;
        ;get the means test code
        S MTSTA=""
        I DGELG("MTSTA") S MTSTA=$P($G(^DG(408.32,DGELG("MTSTA"),0)),"^",2)
        ;
        ;get MT and GMT thresholds
        S DGMTI=$P($$LST^DGMTU(DFN),"^")
        S MTTHR=$P($G(^DGMT(408.31,+DGMTI,0)),"^",12)
        S GMTTHR=$P($G(^DGMT(408.31,+DGMTI,0)),"^",27)
        ;
        ;get the Enrollment Group Threshold (EGT) setting
        S DGEGT=""
        I $$GET^DGENEGT($$FINDCUR^DGENEGT(),.DGEGT)
        ;
        D  ;drops out when priority determined
        .S PRIORITY=""
        .I ((DGELG("SC")="Y")&(DGELG("SCPER")>49))!(CODENAME="SERVICE CONNECTED 50% to 100%") S PRIORITY=1 Q
        .I (DGELG("SC")="Y")&(DGELG("SCPER")>0)&(DGELG("UNEMPLOY")="Y")&(DGELG("VACKAMT")>0)&(DGELG("VAPEN")'="Y")&(DGELG("A&A")'="Y")&(DGELG("HB")'="Y") S PRIORITY=1 Q
        .I ((DGELG("SC")="Y")&(DGELG("SCPER")>29)&(CODENAME="SC LESS THAN 50%")) S PRIORITY=2 Q
        .I ((DGELG("SC")="Y")&(DGELG("SCPER")>9)&(CODENAME="SC LESS THAN 50%"))!(DGELG("POW")="Y")!(CODENAME="PRISONER OF WAR")!(DGELG("DISRET")=1)!(DGELG("DISLOD")=1)!(CODENAME="PURPLE HEART RECIPIENT")!(DGELG("PH")="Y") S PRIORITY=3 Q
        .I (DGELG("A&A")="Y")!(CODENAME="AID & ATTENDANCE")!(DGELG("HB")="Y")!(CODENAME="HOUSEBOUND")!(DGELG("VCD")="Y") S PRIORITY=4 Q
        .I (MTSTA="A")!(DGELG("MEDICAID")=1)!(DGELG("VAPEN")="Y")!(CODENAME="NSC, VA PENSION") S PRIORITY=5 Q
        .I (CODENAME="WORLD WAR I")!(CODENAME="MEXICAN BORDER WAR")!(DGELG("EC")="Y")!(DGELG("VACKAMT")>0)!((DGELG("CVELEDT"))&(DGELG("CVELEDT")'<DT))!(DGELG("SHAD")=1) S PRIORITY=6 Q
        .I DGELG("IR")="Y" I (DGELG("RADEXPM")=2)!(DGELG("RADEXPM")=3)!(DGELG("RADEXPM")=4) S PRIORITY=6 Q
        .I (DGELG("AO")="Y"),(DGELG("AOEXPLOC"))="V" S PRIORITY=6 Q
        .I (MTSTA="G")!((MTSTA="P")&(GMTTHR>MTTHR)) S PRIORITY=7 D  Q
        ..I ((DGELG("SC")="Y")&(DGELG("SCPER")=0)&(DGELG("VACKAMT")<1)&(CODENAME="SC LESS THAN 50%")) S SUBGRP=$$SUBPRI(DFN,.PRIORITY,1) Q
        ..S SUBGRP=$$SUBPRI(DFN,.PRIORITY,3)
        .I ((DGELG("SC")="Y")&(DGELG("SCPER")=0)&(DGELG("VACKAMT")<1)&(CODENAME="SC LESS THAN 50%")) S PRIORITY=8,SUBGRP=$$SUBPRI(DFN,.PRIORITY,1) Q
        .I ((MTSTA="C")!(MTSTA="P")) S PRIORITY=8,SUBGRP=$$SUBPRI(DFN,PRIORITY,3) Q
        ;
        Q PRIORITY_$S(PRIORITY:"^"_SUBGRP,1:"")
        ;
SUBPRI(DFN,PRIORITY,SUBGRP)     ;calculate sub-priority if under EGT
        ;
        N PRVPRI,DONE,PRVENST,ENRDT,DGENRIEN,EGT,DGENRC,TODAY,X
        Q:'$G(DFN)
        S U="^"
        S:$G(PRIORITY)="" PRIORITY=""
        S:$G(SUBGRP)="" SUBGRP=""
        D NOW^%DTC S TODAY=X
        Q:'$$GET^DGENEGT($$FINDCUR^DGENEGT(),.EGT) SUBGRP  ;EGT isn't set
        Q:TODAY<EGT("EFFDATE") SUBGRP  ;EGT is not in effect
        I "^1^3^"[(U_EGT("TYPE")_U) Q SUBGRP
        I EGT("TYPE")=2,(PRIORITY+(SUBGRP*.01))<(EGT("PRIORITY")+(EGT("SUBGRP")*.01)) Q SUBGRP
        I EGT("TYPE")=4 Q:(PRIORITY<EGT("PRIORITY")) SUBGRP  Q:(PRIORITY>EGT("PRIORITY")) $$SUBCNV(SUBGRP)
        ;I $G(ENRDATE) Q:$$ABOVE2^DGENEGT1(ENRDATE,PRIORITY,SUBGRP) SUBGRP
        S DGENRIEN=$$FINDCUR^DGENA(DFN)
        I 'DGENRIEN,$G(ENRDATE),ENRDATE<EGT("EFFDATE") Q SUBGRP
        S DONE=0
        F  Q:DONE  D
        .I 'DGENRIEN S DONE=2 Q
        .I '$$GET^DGENA(DGENRIEN,.DGENRC) S DONE=2 Q
        .S DGENRIEN=$$FINDPRI^DGENA(DGENRIEN)
        .Q:DGENRC("STATUS")=6   ;deceased
        .I $P($G(^DGEN(27.15,+DGENRC("STATUS"),0)),"^",2)="N" S DONE=2 Q
        .S ENRDT=$G(DGENRC("APP")) S:'ENRDT ENRDT=$G(DGENRC("EFFDATE"))
        .I ENRDT,ENRDT<EGT("EFFDATE") S DONE=1 Q
        .; HEC is the authoritative source on continuous enrollment
        .I $$OVRRIDE^DGENEGT1(DFN,.EGT) S DONE=1
        ;
        Q $S(DONE=2:$$SUBCNV(SUBGRP),1:SUBGRP)
        ;
SUBCNV(SUBGRP)  ;return new subgrp
        I SUBGRP=1 Q 5
        I SUBGRP=3 Q 7
        Q SUBGRP
