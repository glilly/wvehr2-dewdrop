SPNRPC4 ;SD/WDE - List Recent Diagnoses / Cover Sheet data;JUL 18, 2008
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ; Reference to ^DGPM("B" supported by IA# 92
        ; References to ^DGPM(D0,0 supported by IA# 4942
        ; Reference to file 45 supported by IA# 4942
        ; Reference to ^ICD0 supported by IA# 10083
        ; Reference to ^ICD9 supported by IA# 10082
        ; Reference to ^ICPT supported by IA #2815
        ; References to ^SRF supported by IA# 3615
        ; Reference to ^SRO supported by IA #4872
        ; Reference to API VISIT^PXRHS01 supported by IA# 1238
        ; Reference to API CPT^ICPTCOD supported by IA #1995
        ;
COL(ROOT,ICN,SPNCUTDT)  ;
        ;
        ; return is TMP($J)
        K ^TMP($J)  ;This is the return file
        K RETURN
        S ROOT=$NA(^TMP($J))
        ;*********************************************
        ;  convert icn to dfn
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:DFN=""
        ;*********************************************
        I '$D(^DPT(+$G(DFN))) S RETURN="" Q
        ;             1825= 5 years
        ;S X1=DT,X2=-5000 D C^%DTC S SPNCUTDT=X  ;cut date no codes before
        S X=SPNCUTDT D ^%DT S SPNCUTDT=Y
JUMPIN1 ;CALLED FROM SPNRPC8 WITH TODAY AS THE CUT DATE
        ;CUTDATE IS THE DATE TO GO BACK TO FORWARD
        S CNT=0  ;used to order the icd9's and icd0's
        S CPTCNT=0  ;used to order the cpt's
        S SPNPTFIE=0 F  S SPNPTFIE=$O(^DGPT("B",DFN,SPNPTFIE)) Q:(SPNPTFIE="")!('+SPNPTFIE)  D SET45
        ;
        D VCPT  ;Build visit file cpt's
        D SURG
        D ENTER^SPNRPC4B
        D CREATE
        K ^TMP($J,"UTIL")
        K SPNPTADM,SPNREV,SPNPTRDT,SPNFLD,XYZ,XYZZ,SPNXY,SPNX1,SURCPT,SURCPTX,SURCPTN,%DT
        K CNT,FIELD,OLDCNT,SPNCNUM,SPNPTFIE,SPNSUDT,SPNXXYZ,SUB,SURX,TOT,TYPE,X,XY,Y
        K CPTCNT,DFN
        K CNT,CPT,CPTCNT,CPTCODE,CPTTXT,DFN,DXIEN,ENTRYDT,EXAM
        K ICPTTXT,PRODATE,PROSENT,RADCPT,RADDT,RADIMP,REALDT,REVRADT
        K SPNSCDT,XA,XB,XC,XCCODE,XCODE,XCTEXT,Y
        K ^TMP($J,"UTIL")
        K SPNPTADM,SPNREV,SPNPTRDT,SPNFLD,XYZ,XYZZ,SPNXY,SPNX1,SURCPT,SURCPTX,SURCPTN,%DT
        K CNT,FIELD,OLDCNT,SPNCNUM,SPNPTFIE,SPNSUDT,SPNXXYZ,SUB,SURX,TOT,TYPE,X,XY,Y
        K CPTCNT,DFN
        K CNT,CPT,CPTCNT,CPTCODE,CPTTXT,DFN,DXIEN,ENTRYDT,EXAM
        K ICPTTXT,PRODATE,PROSENT,RADCPT,RADDT,RADIMP,REALDT,REVRADT
        K SPNSCDT,XA,XB,XC,XCCODE,XCODE,XCTEXT,Y
        K SHOWDT,SPNARDT,SPNCUTDT,SPNREDT
        K SPNFIELD
        Q
SET45   ;loop through PTF file and set up in rev date order
        S SPNPTADM=$P($G(^DGPT(SPNPTFIE,0)),U,2)
        Q:SPNPTADM<SPNCUTDT
        S SPNREV=9999999.9999-SPNPTADM
        S SPNPTRDT=$$GET1^DIQ(45,SPNPTFIE_",",2,"E")
        D BLD
        Q
BLD     ;codes from ptf file
        ;get icdo's from ptf file
        F SPNFLD=45.01,45.02,45.03,45.04,45.05 D
        .S XYZ=$$GET1^DIQ(45,SPNPTFIE_",",SPNFLD,"I")
        .Q:XYZ=""
        .S XYZZ=$P($G(^ICD0(XYZ,0)),U,4)
        .S CNT=CNT+1
        .S ^TMP($J,"UTIL","ICD",SPNREV,CNT)=$P($G(^ICD0(XYZ,0)),U,4)_U_$P($G(^ICD0(XYZ,0)),U,1)_U_SPNPTRDT_U_"DGPT"_U_SPNPTFIE_U
        ;---------------------------------------------
        ;get icd9's from ptf file
        F SPNFLD=79,79.16,79.17,79.18,79.19,79.201,79.21,79.22,79.23,79.24,80 D
        .S XYZ=$$GET1^DIQ(45,SPNPTFIE_",",SPNFLD,"I")
        .Q:XYZ=""
        .S XYZZ=$P($G(^ICD9(XYZ,0)),U,3)
        .S CNT=CNT+1
        .S ^TMP($J,"UTIL","ICD",SPNREV,CNT)=$P($G(^ICD9(XYZ,0)),U,3)_U_$P($G(^ICD9(XYZ,0)),U,1)_U_SPNPTRDT_U_"DGPT"_U_SPNPTFIE_U
BLD2    ;get 40 subscript
        S SPNXY=0 F  S SPNXY=$O(^DGPT(SPNPTFIE,"S",SPNXY)) Q:(SPNXY=0)!('+SPNXY)  D
        .S SPNSUDT=$P($G(^DGPT(SPNPTFIE,"S",SPNXY,0)),U,1)
        .Q:SPNSUDT=""
        .S Y=SPNSUDT X ^DD("DD") S SPNXXYZ=Y  ;date time
        .S SPNSUDT=9999999.9999-SPNSUDT  ;rev date time
        .F SPNFLD=8,9,10,11,12 D
        ..S XYZ=$P($G(^DGPT(SPNPTFIE,"S",SPNXY,0)),U,SPNFLD)
        ..Q:XYZ=""
        ..S CNT=CNT+1
        ..S ^TMP($J,"UTIL","ICD",SPNSUDT,CNT)=$P($G(^ICD0(XYZ,0)),U,4)_U_$P($G(^ICD0(XYZ,0)),U,1)_U_SPNXXYZ_U_"DGPT"_U_SPNPTFIE_U
        .Q
        ;get the 60's now
        S SPNXY=0 F  S SPNXY=$O(^DGPT(SPNPTFIE,"P",SPNXY)) Q:(SPNXY=0)!('+SPNXY)  D
        .S SPNSUDT=$P($G(^DGPT(SPNPTFIE,"P",SPNXY,0)),U,1)
        .Q:SPNSUDT=""
        .S Y=SPNSUDT X ^DD("DD") S SPNXXYZ=Y  ;date time
        .S SPNSUDT=9999999.9999-SPNSUDT
        .F SPNFLD=5,6,7,8,9 D
        ..S XYZ=$P($G(^DGPT(SPNPTFIE,"P",SPNXY,0)),U,SPNFLD)
        ..Q:XYZ=""
        ..S CNT=CNT+1
        ..S ^TMP($J,"UTIL","ICD",SPNSUDT,CNT)=$P($G(^ICD0(XYZ,0)),U,4)_U_$P($G(^ICD0(XYZ,0)),U,1)_U_SPNXXYZ_U_"DGPT"_U_SPNPTFIE_U
        Q
VCPT    ;------------------------------------------------------------------
        ;visit file cpt's
        ;JAS 07/18/08 Completely re-wrote this section due to IA Issues found
        ;             during SQA checklist and missing ICD codes
        ;S X=0 F  S X=$O(^AUPNVCPT("C",DFN,X)) Q:(X="")!('+X)  D
        ;.S XY=$$GET1^DIQ(9000010.18,X_",",.03,"I")
        ;.Q:XY=""
        ;.S XY=$P($G(^AUPNVSIT(XY,0)),U,1)  ;visit date
        ;.Q:XY=""
        ;.Q:XY<SPNCUTDT
        ;.S XY=9999999.9999-XY  ;rev visit date
        ;.S XYZ=$$GET1^DIQ(9000010.18,X_",",.01,"I")  ;cpt code
        ;.Q:XYZ=""
        ;.S XYZZ=$P($G(^ICPT(XYZ,0)),U,1)
        ;.S XYZ=$P($G(^ICPT(XYZ,0)),U,2)
        ;.S CPTCNT=CPTCNT+1
        ;.;S ^TMP($J,"UTIL",CNT,XY)=XYZ_U_$$GET1^DIQ(9000010.18,X_",",.03,"E")_U_$$GET1^DIQ(9000010.18,X_",",.01)_U_"Visit file"
        ;.S ^TMP($J,"UTIL","CPT",XY,CPTCNT)=XYZ_U_XYZZ_U_$$GET1^DIQ(9000010.18,X_",",.03,"E")_U_"AUPNVCPT("_U_X_U
        ;.Q
        K ^TMP("PXHSV",$J)
        D VISIT^PXRHS01(DFN,"",SPNCUTDT,"","AHICTNSOERDX","CD",1)
        F CDTYP="C","D" D VCPT2
        K RVDT,COUNT,X,VTMSTMP,MDT,XSTRING,ICPTIEN,CDTYP,CDTYP2
        K ^TMP("PXHSV",$J)
        Q
VCPT2   ;
        S RVDT=""
        F  S RVDT=$O(^TMP("PXHSV",$J,RVDT)) Q:RVDT=""  D
        .S COUNT=""
        .F  S COUNT=$O(^TMP("PXHSV",$J,RVDT,COUNT)) Q:COUNT=""  D
        ..Q:'$D(^TMP("PXHSV",$J,RVDT,COUNT,CDTYP))
        ..S X=""
        ..F  S X=$O(^TMP("PXHSV",$J,RVDT,COUNT,CDTYP,X)) Q:X=""  D
        ...S ICPTIEN=$P(^TMP("PXHSV",$J,RVDT,COUNT,CDTYP,X),"^",1)
        ...S MDT=9999999-$P(RVDT,".",1)
        ...S TMSTMP=MDT_"."_$P(RVDT,".",2)
        ...S Y=TMSTMP X ^DD("DD") S VTMSTMP=Y  ;date time
        ...I MDT<2890101 S MDT=2890101
        ...I CDTYP="C" D
        ....S XSTRING=$$CPT^ICPTCOD(ICPTIEN,MDT,"")
        ....S XYZZ=$P(XSTRING,"^",2)
        ....S XYZ=$P(XSTRING,"^",3)
        ....S CDTYP2="CPT"
        ...I CDTYP="D" D
        ....S XYZZ=$P($G(^ICD9(ICPTIEN,0)),U,1)
        ....S XYZ=$P($G(^ICD9(ICPTIEN,0)),U,3)
        ....S CDTYP2="ICD"
        ...S CPTCNT=CPTCNT+1
        ...S ^TMP($J,"UTIL",CDTYP2,RVDT,CPTCNT)=XYZ_U_XYZZ_U_VTMSTMP_U_"AUPNVCPT("_U_RVDT_U
        Q
SURG    ;------------------------------------------------------------
        ;get surgery icd's
        ;JAS 07/18/08 Rewrote sections of Surgery sections, due to IA issues found in
        ;             SQA checklist and out-of-date code.
        S X=0 F  S X=$O(^SRF("B",DFN,X)) Q:(X="")!('+X)  D
        .S SPNSRDT=$P($G(^SRF(X,0)),U,9)
        .Q:SPNSRDT=""
        .Q:SPNSRDT<SPNCUTDT
        .S SPNSRDT=9999999.9999-SPNSRDT
        .;S FIELD=14 D CHKSUR  ;Rob requested not to include pre op codes
        .;S FIELD=15 D CHKSUR
        . S FIELD=4 D CHKSUR
        .D SURCPT
        .Q
        K SPNSRDT
        Q
CHKSUR  
        ;S SPNX1=0 F  S SPNX1=$O(^SRF(X,FIELD,SPNX1)) Q:(SPNX1="")!('+SPNX1)  D
        ;.S SPNXCODE=$P($G(^SRF(X,FIELD,SPNX1,0)),U,3) Q:SPNXCODE=""
        S SPNX1=0 F  S SPNX1=$O(^SRO(136,X,FIELD,SPNX1)) Q:(SPNX1="")!('+SPNX1)  D
        .S SPNXCODE=$P($G(^SRO(136,X,FIELD,SPNX1,0)),U,1) Q:SPNXCODE=""
        .S SPNCNUM=$P($G(^ICD9(SPNXCODE,0)),U,1)
        .S SPNXCODE=$P($G(^ICD9(SPNXCODE,0)),U,3)
        ;.S SPNSRDT=$P($G(^SRF(X,0)),U,9)
        ;.Q:SPNSRDT=""
        ;.Q:SPNSRDT<SPNCUTDT
        ;.S SPNSRDT=9999999.9999-SPNSRDT
        .S CNT=CNT+1
        ;.S ^TMP($J,"UTIL","ICD",SPNSRDT,CNT)=SPNXCODE_U_SPNCNUM_U_$$GET1^DIQ(130,X_",",.09,"E")_U_"SRF"_U_X_"/"_FIELD_U
        .S ^TMP($J,"UTIL","ICD",SPNSRDT,CNT)=SPNXCODE_U_SPNCNUM_U_$$GET1^DIQ(130,X_",",.09,"E")_U_"SRO(136"_U_U
        ;.K SPNSRDT,SPNXCODE
        .K SPNXCODE
        .Q
        ;SURG CPTS
        Q
SURCPT  ;
        ;S SURX=0 F  S SURX=$O(^SRF(X,13,SURX)) Q:(SURX="")!('+SURX)  D
        ;.S SURCPT=$P($G(^SRF(X,13,SURX,2)),U,1)
         S SURX=0 F  S SURX=$O(^SRO(136,X,3,SURX)) Q:(SURX="")!('+SURX)  D
        .S SURCPT=$P($G(^SRO(136,X,3,SURX,0)),U,1)
        .S SURCPTN=$P($G(^ICPT(SURCPT,0)),U,1)  ;NUMBER
        .S SURCPTX=$P($G(^ICPT(SURCPT,0)),U,2)  ;TEXT
        .S CPTCNT=CPTCNT+1
        ;.S ^TMP($J,"UTIL","CPT",SPNSRDT,CPTCNT)=SURCPTX_U_SURCPTN_U_$$GET1^DIQ(130,X_",",.09,"E")_U_"SRF("_U_X_U
        .S ^TMP($J,"UTIL","CPT",SPNSRDT,CPTCNT)=SURCPTX_U_SURCPTN_U_$$GET1^DIQ(130,X_",",.09,"E")_U_"SRO(136"_U_U
        Q
CREATE  ;
        S (X,CNT,OLDCNT)=0
        S ^TMP($J,"CPT",0)="CPTBREAK^EOL999"
        S ^TMP($J,"ICD",0)="ICDBREAK^EOL999"
        F SUB="CPT","ICD" S X=0 F  S X=$O(^TMP($J,"UTIL",SUB,X)) Q:(X="")!('+X)  S OLDCNT=0 F  S OLDCNT=$O(^TMP($J,"UTIL",SUB,X,OLDCNT)) Q:(OLDCNT="")!('+OLDCNT)  D
        .S CNT=CNT+1
        .S ^TMP($J,SUB,CNT)=$G(^TMP($J,"UTIL",SUB,X,OLDCNT))_"^EOL999"
        .Q
        ;MOVED TO TOP K ^TMP($J,"UTIL")  ;REMOVE SUB TEMP GLOBAL
        Q
DISP    ;just used to print out tmp for validation
        S TOT=0
        S TYPE="" F  S TYPE=$O(^TMP($J,TYPE)) Q:TYPE=""  S CNT=0 F  S CNT=$O(^TMP($J,TYPE,CNT)) Q:(CNT="")!('+CNT)  D
        .W !,$P($G(^TMP($J,TYPE,CNT)),U,1)
        .W ?30,$P($G(^TMP($J,TYPE,CNT)),U,2)
        .W ?40,$P($G(^TMP($J,TYPE,CNT)),U,3)
        .W ?60,$P($G(^TMP($J,TYPE,CNT)),U,4,5)
        .W !,$G(^TMP($J,TYPE,CNT))
        .S TOT=TOT+1
        Q
