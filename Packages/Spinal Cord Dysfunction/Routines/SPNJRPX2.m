SPNJRPX2        ;BP/JAS - CPTS/ICDS CODES & DESCRIPTS ;JUN 17, 2009
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ; References to file #409.68/^SCE supported by IA #2443
        ; RETIRED AND REPLACED WITH IA# 3990 [Reference to ^ICD9 supported by IA #10082]
        ; Reference to API ICDDX^ICDCODE supported by IA #3990
        ; Reference to ^SDD(409.43 supported by IA #4930
        ; References to ^ACK(509850.6 supported by IA #1558
        ; References to file #721/^ECH supported by IA #1873
        ; References to file #70/^RADPT supported by IA #3125 & #118
        ; Reference to ^RAMIS(71 supported by IA #586
        ; References to ^RMPR(660 supported by IA #4975
        ; Reference to ^ICPT supported by IA #2815
        ; Reference to API CPT^ICPTCOD supported by IA #1995
        ; Reference to API PSASHCPC^RMPOPF supported by IA #4975
        ;
ENTER   ;
        D SCE
        D AUDIO
        D ECH
        D RAD
        D PROS
        ;NOTE: SOME VAR'S ARE KILLED IN SPNJRPCX
        D CLNUP
        Q
        ;
SCE     ;loop through the sce file "c" on dfn then to the sdd file for icd9
        S XA=0 F  S XA=$O(^SCE("C",DFN,XA)) Q:(XA="")!('+XA)  D
        .S SPNREDT=9999999.9999-$P($G(^SCE(XA,0)),U,1)
        .Q:$P($G(^SCE(XA,0)),U,1)<SPNCUTDT
        .S SPNSCDT=$$GET1^DIQ(409.68,XA_",",.01,"E")
        .;JAS - 05/15/08 - DEFECT 1090
        .;S XB="" F  S XB=$O(^SDD(409.43,"AO",XA,XB)) Q:(XB="")!('+XB)  D
        .S XB=0 F  S XB=$O(^SDD(409.43,"AO",XA,XB)) Q:(XB="")!('+XB)  D
        ..;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        ..S SPNARY=$$ICDDX^ICDCODE(XB,"","","")
        ..S CNT=CNT+1
        ..;S ^TMP($J,"UTIL","ICD",SPNREDT,CNT)=$P($G(^ICD9(XB,0)),U,3)_U_$P($G(^ICD9(XB,0)),U,1)_U_SPNSCDT_U
        ..S ^TMP($J,"UTIL","ICD",SPNREDT,CNT)=$P(SPNARY,U,4)_U_$P(SPNARY,U,2)_U_SPNSCDT_U
        ..Q
        .K SPNARY
        .Q
        Q
AUDIO   ;get icd9's from audio speech
        S XA=0 F  S XA=$O(^ACK(509850.6,"C",DFN,XA)) Q:(XA="")!('+XA)  D
        .S SPNARDT=$P($G(^ACK(509850.6,XA,0)),U,1)
        .Q:SPNARDT=""
        .Q:SPNARDT<SPNCUTDT
        .S MDT=SPNARDT
        .S SPNARDT=9999999.9999-SPNARDT
        .S SPNFIELD=1 D COL
        .S SPNFIELD=3 D COL
        .Q
        Q
COL     ;
        S XB=0 F  S XB=$O(^ACK(509850.6,XA,SPNFIELD,XB)) Q:(XB="")!('+XB)  D
        .S XC=$P($G(^ACK(509850.6,XA,SPNFIELD,XB,0)),U,1)
        .Q:XC=""
        .;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        .S SPNARY=$$ICDDX^ICDCODE(XC,"","","")
        .;I SPNFIELD=1 S XCCODE=$P($G(^ICD9(XC,0)),U,1)
        .I SPNFIELD=1 S XCCODE=$P(SPNARY,U,2)
        .;I SPNFIELD=1 S XC=$P($G(^ICD9(XC,0)),U,3)
        .I SPNFIELD=1 S XC=$P(SPNARY,U,4)
        .I SPNFIELD=3 D
        ..S XSTRING=$$CPT^ICPTCOD(XC,MDT,"")
        ..S XCCODE=$P(XSTRING,"^",2)
        ..S XC=$P(XSTRING,"^",3)
        .Q:XC=""
        .I SPNFIELD=1 S CNT=CNT+1
        .I SPNFIELD=3 S CPTCNT=CPTCNT+1
        .S ^TMP($J,"UTIL",$S(SPNFIELD=1:"ICD",1:"CPT"),SPNARDT,$S(SPNFIELD=1:CNT,1:CPTCNT))=XC_U_XCCODE_U_$$GET1^DIQ(509850.6,XA_",",.01,"E")_U
        .S XC=""
        .K SPNARY
        .Q
        Q 
ECH     ;
        ;
        ;Event Capture file 721
        ; xa=date.time  xb = ien of ech
        ; xc is the icd9 points to the ICD9 file
        S XA=0 F  S XA=$O(^ECH("APAT",DFN,XA)) Q:(XA="")!('+XA)  S XB=0 F  S XB=$O(^ECH("APAT",DFN,XA,XB)) Q:(XB="")!('+XB)  D
        .S SPNARDT=$P($G(^ECH(XB,0)),U,3)
        .Q:SPNARDT=""
        .Q:SPNARDT<SPNCUTDT
        .S MDT=SPNARDT
        .S SPNARDT=9999999.9999-SPNARDT
        .S XCODE=$P($G(^ECH(XB,"P")),U,2)
        .I XCODE'="" D ECHNIN
        .S XCODE=$P($G(^ECH(XB,"P")),U,1)
        .I XCODE'="" D ECHCPT
        .D ECHSEC
        .Q
        Q
ECHNIN  ;gets the icd9 and sets tmp($j,"util"
        S XC=$$GET1^DIQ(721,XB_",",20,"E")  ;icd9 number
        ;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        ;S XCTEXT=$P($G(^ICD9(XCODE,0)),U,3)  ;text of the icd9
        S XCTEXT=$P($$ICDDX^ICDCODE(XCODE,"","",""),U,4)
        S CNT=CNT+1
        S ^TMP($J,"UTIL","ICD",SPNARDT,CNT)=XCTEXT_U_XC_U_$$GET1^DIQ(721,XB_",",2,"E")_U
        Q
ECHCPT  ;gets the icpt field 20
        S XC=$$GET1^DIQ(721,XB_",",19,"E")   ;icpt number
        S XSTRING=$$CPT^ICPTCOD(XCODE,MDT,"")
        S XCTEXT=$P(XSTRING,"^",3)
        S CPTCNT=CPTCNT+1
        S ^TMP($J,"UTIL","CPT",SPNARDT,CPTCNT)=XCTEXT_U_XC_U_$$GET1^DIQ(721,XB_",",2,"E")_U
        Q
ECHSEC  ;get SECONDARY ICD-9 CODE subscript dx
        S DXIEN=0 F  S DXIEN=$O(^ECH(XB,"DX",DXIEN)) Q:(DXIEN="")!('+DXIEN)  D
        .S XCODE=$P($G(^ECH(XB,"DX",DXIEN,0)),U,1)
        .;JAS 6/17/09 - DEFECT 1137 - Removed direct reads of CPT/ICD files to API usage
        .S SPNARY=$$ICDDX^ICDCODE(XCODE,"","","")
        .;S XC=$P($G(^ICD9(XCODE,0)),U,1)
        .S XC=$P(SPNARY,"^",2)
        .;S XCTEXT=$P($G(^ICD9(XCODE,0)),U,3)
        .S XCTEXT=$P(SPNARY,"^",4)
        .S CNT=CNT+1
        .S ^TMP($J,"UTIL","ICD",SPNARDT,CNT)=XCTEXT_U_XC_U_$$GET1^DIQ(721,XB_",",2,"E")_U
        .K SPNARY
        .Q
        Q
RAD     ;RAD/NUC MED PATIENT
        ;
        S RADDT=0 F  S RADDT=$O(^RADPT(DFN,"DT",RADDT)) Q:(RADDT="")!('+RADDT)  D
        .S REALDT=$$GET1^DIQ(70.02,RADDT_","_DFN_",",.01,"I")
        .Q:REALDT<SPNCUTDT
        .S EXAM=0 F  S EXAM=$O(^RADPT(DFN,"DT",RADDT,"P",EXAM)) Q:(EXAM="")!('+EXAM)  D
        ..S RADCPT=$$GET1^DIQ(70.03,EXAM_","_RADDT_","_DFN_",",2,"I")
        ..Q:RADCPT=""
        ..S RADCPT=$P($G(^RAMIS(71,RADCPT,0)),U,9)
        ..Q:RADCPT=""  ;NOT IN THE RAMIS FILE
        ..S XSTRING=$$CPT^ICPTCOD(RADCPT,REALDT,"")
        ..S ICPTTXT=$P(XSTRING,"^",3)
        ..S CPTCNT=CPTCNT+1
        ..S Y=REALDT D DD^%DT S SHOWDT=Y
        ..S ^TMP($J,"UTIL","CPT",RADDT,CPTCNT)=ICPTTXT_U_RADCPT_U_SHOWDT_U
        Q
PROS    ;Record of Prosthetics Appl Repair
        S PROSENT=0 F  S PROSENT=$O(^RMPR(660,"C",DFN,PROSENT)) Q:(PROSENT=0)!('+PROSENT)  D
        .S ENTRYDT=$P($G(^RMPR(660,PROSENT,0)),U,1)
        .S RMPRHCDT=ENTRYDT
        .Q:ENTRYDT<SPNCUTDT
        .S REVRADT=9999999.9999-ENTRYDT
        .S CPT=$P($G(^RMPR(660,PROSENT,1)),U,4)
        .Q:CPT=""
        .S RMPRHCPC=CPT
        .D PSASHCPC^RMPOPF
        .S CPTCODE=RMPREHC
        .S CPTTXT=RMPRTHC
        .S Y=ENTRYDT D DD^%DT S PRODATE=Y
        .S CPTCNT=CPTCNT+1
        .S ^TMP($J,"UTIL","CPT",REVRADT,CPTCNT)=CPTTXT_U_CPTCODE_U_PRODATE_U
        .Q
        Q
CLNUP   ;
        K CPT,CPTCODE,CPTTXT,DXIEN,ENTRYDT,EXAM,ICPTTXT,PRODATE,PROSENT
        K RADCPT,RADDT,REALDT,REVRADT,SHOWDT,SPNARDT,SPNFIELD
        K SPNREDT,SPNSCDT,XA,XB,XC,XCCODE,XCODE,XCTEXT
        K CNT,CPTCNT,DFN,SPNCUTDT,Y,MDT,XSTRING
        K RMPREHC,RMPRHCDT,RMPRHCPC,RMPRTHC
        Q
