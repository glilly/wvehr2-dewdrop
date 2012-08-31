PSUDEM2 ;BIR/DAM - Outpatient Visits Extract ; 1/23/09 3:10pm
        ;;4.0;PHARMACY BENEFITS MANAGEMENT;**15**;MARCH, 2005;Build 2
        ;
        ;DBIA's
        ; Reference to file 2            supported by DBIA 10035
        ; Reference to file 9000010.07   supported by DBIA 3094
        ; Reference to file 9000010      supported by DBIA 3512
        ; Reference to file 4.3          supported by DBIA 2496
        ; Reference to file 80           supported by DBIA 10082
        ; Reference to file 9000010.18   supported by DBIA 3560
        ; Reference to file 81           supported by DBIA 2815
EN      ;EN Called from PSUCP
        K ^XTMP("PSU_"_PSUJOB,"PSUOPV"),^XTMP("PSU_"_PSUJOB,"PSUTMP")
        K NONE
        NEW CPTDA,CPTNM,ICD9DA,ICD9NM,PSUICN,PSUSSN,PSUSUB,PSUTEDT
        NEW PSUVSTDT,PSUX,PSUY,PTSTAT,SEG,VCPTDA,XX,J
        D DAT1
        I '$D(^XTMP("PSU_"_PSUJOB,"PSUTMP")) D NODATA
        D XMD
EX      K ^XTMP("PSU_"_PSUJOB,"PSUPDFLAG")
        K ^XTMP("PSU_"_PSUJOB,"PSUOPV")
        K ^XTMP("PSU_"_PSUJOB,"PSUXMD")
        K ^XTMP("PSU_"_PSUJOB,"PSUTMP")
        Q
        ;
        ;
DAT1    ;Find visits from V POV file that fall within the date range
        S PSUTEDT=PSUEDT
        S PSUDT=PSUSDT-1,PSUX=9999999-PSUDT,PSUY=9999999-PSUEDT N PSUEDT
        S PSUY=PSUSDT-.0001
        F  S PSUY=$O(^AUPNVSIT("B",PSUY)) Q:PSUY'>0  Q:((PSUY\1)>PSUTEDT)  D
        . S PSUVIEN=0 F  S PSUVIEN=$O(^AUPNVSIT("B",PSUY,PSUVIEN)) Q:$G(PSUVIEN)'>0  D
        .. S PSUPT=$$VALI^PSUTL(9000010,PSUVIEN,.05)
        .. D DAT2
        Q
DAT2    ;
        S PSUPOV=0 F  S PSUPOV=$O(^AUPNVPOV("AD",PSUVIEN,PSUPOV)) Q:PSUPOV'>0  D
        .N PSUVIEN
        .S PSUVIEN=$P($G(^AUPNVPOV(PSUPOV,0)),U,3)
        .Q:PSUVIEN=""
        .Q:$D(^XTMP("PSU"_PSUJOB,"PSUOPV",PSUVIEN))  ; quit if visit psuvien already stored
        . D POVS
        .S PSUVSTDT=$P($G(^AUPNVSIT(PSUVIEN,0)),U)\1
        .S PSUSSN=$P(^DPT(PSUPT,0),U,9)
        .S PSUICN=$$GETICN^MPIF001(PSUPT)
        .I PSUICN[-1 S PSUICN=""
        .;PSU*4*15 Protect from empty 150 nodes
        .S PTSTAT=$P($G(^AUPNVSIT(PSUVIEN,150)),U,2),PTSTAT=$S(+PTSTAT:"I",1:"O")
        . D SET
        Q
POVS    ;severl POVs can have same visit, work all when the first is found
        N PSUPOV
        ;PSU*4*15 move kills out of loop.
        K ALLICD9,ALLCPT
        S PSUPOV=0 F  S PSUPOV=$O(^AUPNVPOV("AD",PSUVIEN,PSUPOV)) Q:PSUPOV'>0  D
        .;LOOP CPTs linked by visit
        . S VCPTDA=0 F  S VCPTDA=$O(^AUPNVCPT("AD",PSUVIEN,VCPTDA)) Q:VCPTDA'>0  D
        .. ; get/gather cpts
        ..S CPTDA=$P($G(^AUPNVCPT(VCPTDA,0)),U),CPTNM=$P($G(^ICPT(CPTDA,0)),U) S:$L(CPTNM) ALLCPT(CPTNM)=""
        .. ;get/gather icd9s 
        ..S ICD9DA=$P($G(^AUPNVCPT(VCPTDA,0)),U,5) I ICD9DA S ICD9NM=$P($G(^ICD9(ICD9DA,0)),U) S:$L(ICD9NM) ALLICD9(ICD9NM)=""
        . ;get orig ICD9
        .S ICD9DA=$P($G(^AUPNVPOV(PSUPOV,0)),U) I ICD9DA S ICD9NM=$P($G(^ICD9(ICD9DA,0)),U) S:$L(ICD9NM) ALLICD9(ICD9NM)=""
        Q
SET     ; Set segment
        I '$D(ALLICD9),'$D(ALLCPT) Q  ;insure visit has either CPT or ICD9
        ;assemble elements and set
        S SEG=U_PSUSNDR_U_PTSTAT_U_PSUVSTDT_U_PSUSSN_U_PSUICN_U
        I $D(ALLICD9) S ICD9NM="" F I=7:1:16 S ICD9NM=$O(ALLICD9(ICD9NM)) Q:ICD9NM=""  S $P(SEG,U,I)=ICD9NM
        I $D(ALLCPT) S CPTNM="" F J=17:1:26 S CPTNM=$O(ALLCPT(CPTNM)) Q:CPTNM=""  S $P(SEG,U,J)=CPTNM
        S $P(SEG,U,27)=""
        S ^XTMP("PSU_"_PSUJOB,"PSUTMP",PSUVIEN)=SEG
        Q
        ;
XMD     ;Format mailman message and send.
        S PSUAB=0
        F PSUPL=1:1 S PSUAB=$O(^XTMP("PSU_"_PSUJOB,"PSUTMP",PSUAB)) Q:PSUAB'>0  S XX=^(PSUAB) D
        . S ^XTMP("PSU_"_PSUJOB,"PSUOPV",PSUPL)=XX
        NEW PSUMAX,PSULC,PSUTMC,PSUTLC,PSUMC
        S PSUMAX=$$VAL^PSUTL(4.3,1,8.3)
        S PSUMAX=$S(PSUMAX="":10000,PSUMAX>10000:10000,1:PSUMAX)
        S PSUMC=1,PSUMLC=0
        F PSULC=1:1 S X=$G(^XTMP("PSU_"_PSUJOB,"PSUOPV",PSULC)) Q:X=""  D
        .S PSUMLC=PSUMLC+1
        .I PSUMLC>PSUMAX S PSUMC=PSUMC+1,PSUMLC=0,PSULC=PSULC-1 Q  ; +  message
        .I $L(X)<235 S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=X Q
        .F I=235:-1:1 S Z=$E(X,I) Q:Z="^"
        .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=$E(X,1,I)
        .S PSUMLC=PSUMLC+1
        .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)="*"_$E(X,I+1,999)
        ;
TLC     ;   Count Lines sent
        S PSUTLC=0
        F PSUM=1:1:PSUMC S X=$O(^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUM,""),-1),PSUTLC=PSUTLC+X
        ;
        F PSUM=1:1:PSUMC D OPV^PSUDEM5
        D CONF
        Q
CONF    ;Construct globals for confirmation message
        ;
        I $G(NONE) S PSUTLC=0
        N PSUDIVIS
        S PSUDIVIS=$P(^XTMP("PSU_"_PSUJOB,"PSUSITE"),U,1)
        S PSUSUB="PSU_"_PSUJOB
        S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,8,"M")=PSUMC
        S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,8,"L")=PSUTLC
        Q
        ;
NODATA  ;Generate a 'No data' message if there is no data in the extract
        ;
        S NONE=1
        M PSUXMYH=PSUXMYS1
        S PSUM=1
        S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUM,1)="No data to report"
        Q
REC     ;EN If "^" is contained in any record, replace it with "'"
        ;
        I PSUREC["^" S PSUREC=$TR(PSUREC,"^","'")
        Q
