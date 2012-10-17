SPNJRPIW        ;BP/JAS - List Recent Diagnoses with Rad comments ;JUN 17, 2009
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ; References to file #45/^DGPT supported by IA #92 and IA #4945
        ; RETIRED AND REPLACED WITH IA# 3990 [Reference to ^ICD0 supported by IA #10083]
        ; Reference to API ICDOP^ICDCODE supported by IA #3990
        ; RETIRED AND REPLACED WITH IA# 3990 [Reference to ^ICD9 supported by IA #10082]
        ; Reference to API ICDDX^ICDCODE supported by IA #3990
        ; Reference to API VISIT^PXRHS01 supported by IA #1238
        ; Reference to ^ICPT supported by IA #2815
        ; Reference to API CPT^ICPTCOD supported by IA #1995
        ; References to ^SRF supported by IA #3615
        ; Reference to ^SRO supported by IA #4872
        ; Reference to file 74 supported by IA #2479
        ; API $$FLIP^SPNRPCIC is part of Spinal Cord Version 3.0
        ;
COL(ROOT,ICN,SPNCUTDT)  ;
        ;
        ; return is TMP($J)
        K ^TMP($J)  ;This is the return file
        S ROOT=$NA(^TMP($J))
        ;*********************************************
        ;  convert icn to dfn
        Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:DFN=""
        ;*********************************************
        I '$D(^DPT(+$G(DFN))) Q
        ;             1825= 5 years
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
        K CPTCNT,DFN,LINE,RADLN,RARDA,RARPT
        K CNT,CPT,CPTCNT,CPTCODE,CPTTXT,DFN,DXIEN,ENTRYDT,EXAM
        K ICPTTXT,PRODATE,PROSENT,RADCPT,RADDT,RADIMP,REALDT,REVRADT
        K SPNSCDT,XA,XB,XC,XCCODE,XCODE,XCTEXT,Y
        K TMSTMP  ;WDE
        D KILL^SPNRPC4B
        Q
SET45   ;loop through PTF file and set up in rev date order
        S SPNPTADM=$$GET1^DIQ(45,SPNPTFIE_",",2,"I")
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
        .;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        .;S XYZZ=$P($G(^ICD0(XYZ,0)),U,4)
        .S SPNARY=$$ICDOP^ICDCODE(XYZ,"","","")
        .S XYZZ=$P(SPNARY,"^",5)
        .S CNT=CNT+1
        .;S ^TMP($J,"UTIL","ICD",SPNREV,CNT)=$P($G(^ICD0(XYZ,0)),U,4)_U_$P($G(^ICD0(XYZ,0)),U,1)_U_SPNPTRDT_U_"DGPT"_U_SPNPTFIE_U
        .S ^TMP($J,"UTIL","ICD",SPNREV,CNT)=XYZZ_U_$P(SPNARY,U,2)_U_SPNPTRDT_U_"DGPT"_U_SPNPTFIE_U
        K SPNARY
        ;---------------------------------------------
        ;get icd9's from pft file
        F SPNFLD=79,79.16,79.17,79.18,79.19,79.201,79.21,79.22,79.23,79.24,80 D
        .S XYZ=$$GET1^DIQ(45,SPNPTFIE_",",SPNFLD,"I")
        .Q:XYZ=""
        .;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        .;S XYZZ=$P($G(^ICD9(XYZ,0)),U,3)
        .S SPNARY=$$ICDDX^ICDCODE(XYZ,"","","")
        .S XYZZ=$P(SPNARY,"^",4)
        .S CNT=CNT+1
        .;S ^TMP($J,"UTIL","ICD",SPNREV,CNT)=$P($G(^ICD9(XYZ,0)),U,3)_U_$P($G(^ICD9(XYZ,0)),U,1)_U_SPNPTRDT_U_"DGPT"_U_SPNPTFIE_U
        .S ^TMP($J,"UTIL","ICD",SPNREV,CNT)=XYZZ_U_$P(SPNARY,U,2)_U_SPNPTRDT_U_"DGPT"_U_SPNPTFIE_U
        K SPNARY
BLD2    ;get 40 subscript
        S SPNXY=0 F  S SPNXY=$O(^DGPT(SPNPTFIE,"S",SPNXY)) Q:(SPNXY=0)!('+SPNXY)  D
        .S SPNSUDT=$$GET1^DIQ(45.01,SPNXY_","_SPNPTFIE_",",.01,"I")
        .Q:SPNSUDT=""
        .S Y=SPNSUDT X ^DD("DD") S SPNXXYZ=Y  ;date time
        .S SPNSUDT=9999999.9999-SPNSUDT  ;rev date time
        .F SPNFLD=8,9,10,11,12 D
        ..S XYZ=$$GET1^DIQ(45.01,SPNXY_","_SPNPTFIE_",",SPNFLD,"I")
        ..Q:XYZ=""
        ..;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        ..S SPNARY=$$ICDOP^ICDCODE(XYZ,"","","")
        ..S CNT=CNT+1
        ..;S ^TMP($J,"UTIL","ICD",SPNSUDT,CNT)=$P($G(^ICD0(XYZ,0)),U,4)_U_$P($G(^ICD0(XYZ,0)),U,1)_U_SPNXXYZ_U_"DGPT"_U_SPNPTFIE_U
        ..S ^TMP($J,"UTIL","ICD",SPNSUDT,CNT)=$P(SPNARY,U,5)_U_$P(SPNARY,U,2)_U_SPNXXYZ_U_"DGPT"_U_SPNPTFIE_U
        .Q
        K SPNARY
        ;get the 60's now
        S SPNXY=0 F  S SPNXY=$O(^DGPT(SPNPTFIE,"P",SPNXY)) Q:(SPNXY=0)!('+SPNXY)  D
        .S SPNSUDT=$$GET1^DIQ(45.05,SPNXY_","_SPNPTFIE_",",.01,"I")
        .Q:SPNSUDT=""
        .S Y=SPNSUDT X ^DD("DD") S SPNXXYZ=Y  ;date time
        .S SPNSUDT=9999999.9999-SPNSUDT
        .F SPNFLD=5,6,7,8,9 D
        ..S XYZ=$$GET1^DIQ(45.05,SPNXY_","_SPNPTFIE_",",SPNFLD,"I")
        ..Q:XYZ=""
        ..;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        ..S SPNARY=$$ICDOP^ICDCODE(XYZ,"","","")
        ..S CNT=CNT+1
        ..;S ^TMP($J,"UTIL","ICD",SPNSUDT,CNT)=$P($G(^ICD0(XYZ,0)),U,4)_U_$P($G(^ICD0(XYZ,0)),U,1)_U_SPNXXYZ_U_"DGPT"_U_SPNPTFIE_U
        ..S ^TMP($J,"UTIL","ICD",SPNSUDT,CNT)=$P(SPNARY,U,5)_U_$P(SPNARY,U,2)_U_SPNXXYZ_U_"DGPT"_U_SPNPTFIE_U
        K SPNARY
        Q
VCPT    ;------------------------------------------------------------------
        ;visit file cpt's
        K ^TMP("PXHSV",$J)
        ;02/27/08 JAS DEFECTS 188,191&192 - MODIFIED VCPT/VCPT2 TO INCLUDE ICDS ALONG WITH CPTS
        ;D VISIT^PXRHS01(DFN,"",SPNCUTDT,"","AHICTNSOERDX","C",1)
        D VISIT^PXRHS01(DFN,"",SPNCUTDT,"","AHICTNSOERDX","CD",1)
        F CDTYP="C","D" D VCPT2
        K RVDT,COUNT,X,VTMSTMP,MDT,XSTRING,ICPTIEN,CDTYP,CDTYP2,FTYP
        K ^TMP("PXHSV",$J)
        Q
VCPT2   ;
        ;JAS - 05/15/08 - DEFECT 1090 (MULTIPLE CHANGES BELOW)
        ;S RVDT=""
        S RVDT=0
        F  S RVDT=$O(^TMP("PXHSV",$J,RVDT)) Q:RVDT=""  D
        .;S COUNT=""
        .S COUNT=0
        .F  S COUNT=$O(^TMP("PXHSV",$J,RVDT,COUNT)) Q:COUNT=""  D
        ..;Q:'$D(^TMP("PXHSV",$J,RVDT,COUNT,"C"))
        ..Q:'$D(^TMP("PXHSV",$J,RVDT,COUNT,CDTYP))
        ..;S X=""
        ..S X=0
        ..;F  S X=$O(^TMP("PXHSV",$J,RVDT,COUNT,"C",X)) Q:X=""  D
        ..F  S X=$O(^TMP("PXHSV",$J,RVDT,COUNT,CDTYP,X)) Q:X=""  D
        ...;S ICPTIEN=$P(^TMP("PXHSV",$J,RVDT,COUNT,"C",X),"^",1)
        ...S ICPTIEN=$P(^TMP("PXHSV",$J,RVDT,COUNT,CDTYP,X),"^",1)
        ...S MDT=9999999-$P(RVDT,".",1)
        ...S TMSTMP=MDT_"."_$P(RVDT,".",2)
        ...S Y=TMSTMP X ^DD("DD") S VTMSTMP=Y  ;date time
        ...I MDT<2890101 S MDT=2890101
        ...;S XSTRING=$$CPT^ICPTCOD(ICPTIEN,MDT,"")
        ...;S XYZZ=$P(XSTRING,"^",2)
        ...;S XYZ=$P(XSTRING,"^",3)
        ...I CDTYP="C" D
        ....S XSTRING=$$CPT^ICPTCOD(ICPTIEN,MDT,"")
        ....S XYZZ=$P(XSTRING,"^",2)
        ....S XYZ=$P(XSTRING,"^",3)
        ....S CDTYP2="CPT",FTYP="AUPNVCPT("
        ...I CDTYP="D" D
        ....;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        ....S SPNARY=$$ICDDX^ICDCODE(ICPTIEN,"","","")
        ....;S XYZZ=$P($G(^ICD9(ICPTIEN,0)),U,1)
        ....S XYZZ=$P(SPNARY,"^",2)
        ....;S XYZ=$P($G(^ICD9(ICPTIEN,0)),U,3)
        ....S XYZ=$P(SPNARY,"^",4)
        ....S CDTYP2="ICD",FTYP="AUPNVPOV("
        ...S CPTCNT=CPTCNT+1
        ...;S ^TMP($J,"UTIL","CPT",RVDT,CPTCNT)=XYZ_U_XYZZ_U_VTMSTMP_U_"AUPNVCPT("_U_X_U
        ...S ^TMP($J,"UTIL",CDTYP2,RVDT,CPTCNT)=XYZ_U_XYZZ_U_VTMSTMP_U_FTYP_U_X_U
        ;K RVDT,COUNT,X,VTMSTMP,MDT,XSTRING,ICPTIEN
        ;K ^TMP("PXHSV",$J)
        K SPNARY
        Q
SURG    ;------------------------------------------------------------
        ;get surgery icd's
        S X=0 F  S X=$O(^SRF("B",DFN,X)) Q:(X="")!('+X)  D
        .S SPNSRDT=$P($G(^SRF(X,0)),U,9)
        .Q:SPNSRDT=""
        .Q:SPNSRDT<SPNCUTDT
        .S SPNSRDT=9999999.9999-SPNSRDT
        .;S FIELD=14 D CHKSUR  ;Rob requested not to include pre op codes
        .S FIELD=4 D CHKSUR
        .D SURCPT
        .Q
        ;PUGET ERROR TRAP 12/21/07 - ADDED LINE BELOW
        K SPNSRDT
        Q
CHKSUR  ;
        S SPNX1=0 F  S SPNX1=$O(^SRO(136,X,FIELD,SPNX1)) Q:(SPNX1="")!('+SPNX1)  D
        .S SPNXCODE=$P($G(^SRO(136,X,FIELD,SPNX1,0)),U,1) Q:SPNXCODE=""
        .;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        .S SPNARY=$$ICDDX^ICDCODE(SPNXCODE,"","","")
        .;S SPNCNUM=$P($G(^ICD9(SPNXCODE,0)),U,1)
        .S SPNCNUM=$P(SPNARY,"^",2)
        .;S SPNXCODE=$P($G(^ICD9(SPNXCODE,0)),U,3)
        .S SPNXCODE=$P(SPNARY,"^",4)
        .;PUGET ERROR TRAP 12/21/07
        .;S SPNSRDT=$P($G(^SRF(X,0)),U,9)
        .;Q:SPNSRDT=""
        .;Q:SPNSRDT<SPNCUTDT
        .;S SPNSRDT=9999999.9999-SPNSRDT
        .S CNT=CNT+1
        .S ^TMP($J,"UTIL","ICD",SPNSRDT,CNT)=SPNXCODE_U_SPNCNUM_U_$$GET1^DIQ(130,X_",",.09,"E")_U_"SRF"_U_X_"/"_FIELD_U
        .;PUGET ERROR TRAP 12/21/07
        .;K SPNSRDT,SPNXCODE
        .K SPNXCODE
        .Q
        K SPNARY
        Q
SURCPT  ;SURG CPTS
        S SURX=0 F  S SURX=$O(^SRO(136,X,3,SURX)) Q:(SURX="")!('+SURX)  D
        .S SURCPT=$P($G(^SRO(136,X,3,SURX,0)),U,1)
        .;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        .S SPNARY=$$CPT^ICPTCOD(SURCPT,"","")
        .;S SURCPTN=$P($G(^ICPT(SURCPT,0)),U,1)  ;NUMBER
        .S SURCPTN=$P(SPNARY,"^",2)
        .;S SURCPTX=$P($G(^ICPT(SURCPT,0)),U,2)  ;TEXT
        .S SURCPTX=$P(SPNARY,"^",3)
        .S CPTCNT=CPTCNT+1
        .S ^TMP($J,"UTIL","CPT",SPNSRDT,CPTCNT)=SURCPTX_U_SURCPTN_U_$$GET1^DIQ(130,X_",",.09,"E")_U_"SRF("_U_X_U
        K SPNARY
        Q
CREATE  ;
        S (X,CNT,OLDCNT)=0
        S ^TMP($J,"CPT",0)="CPTBREAK^EOL999"
        S ^TMP($J,"ICD",0)="ICDBREAK^EOL999"
        F SUB="CPT","ICD" S X=0 F  S X=$O(^TMP($J,"UTIL",SUB,X)) Q:(X="")!('+X)  S OLDCNT=0 F  S OLDCNT=$O(^TMP($J,"UTIL",SUB,X,OLDCNT)) Q:(OLDCNT="")!('+OLDCNT)  D
        .S CNT=CNT+1
        .S ^TMP($J,SUB,CNT)=$G(^TMP($J,"UTIL",SUB,X,OLDCNT))_"^EOL999"
        .S RARPT=$P($G(^TMP($J,"UTIL",SUB,X,OLDCNT)),"^",6)
        .I RARPT'=""&($P(RARPT," ",1)="RARPT") D
        ..S RARDA=$P(RARPT," ",2)
        ..F TYPE=200,300,400 D
        ...K WP
        ...S WP=$$GET1^DIQ(74,RARDA_",",TYPE,"","WP")
        ...Q:$D(WP)'=11
        ...S TYPEL=$S(TYPE=200:"R",TYPE=300:"I",TYPE=400:"H")
        ...S LINE="" F  S LINE=$O(WP(LINE)) Q:LINE=""  D
        ....S RADLN=WP(LINE)
        ....I RADLN=""!(RADLN=" ") Q
        ....S CNT=CNT+1
        ....S ^TMP($J,SUB,CNT)="COM-"_TYPEL_"^"_RADLN_U_"EOL999"
        ....Q
        ...K TYPEL,WP
        ...Q
        ..Q
        .Q
        Q
