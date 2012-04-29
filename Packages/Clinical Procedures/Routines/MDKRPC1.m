MDKRPC1 ;HIOFO/FT-RPC to return patient data ;2/19/08  13:13
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ;
        ; This routine uses the following IAs:
        ; #1239  - ^PXRHS03               (controlled)
        ; #1240  - ^PXRHS04               (private)
        ; #1625  - ^XUA4A72               (supported)
        ; #2263  - ^XPAR                  (supported)
        ; #2864  - ^TIUPP3 calls          (controlled)
        ; #3065  - ^XLFNAME               (supported)
        ; #3556  - ^LA7QRY                (controlled)
        ; #10035 - ^DPT global refs       (supported)
        ; #10060 - ^FILE 200 refs         (supported)
        ; #10099 - ^GMRADPT calls         (supported)
        ; #10103 - ^XLFDT calls           (supported)
        ; #4868  - VA(200,"AUSER"         (Private)
        ;
RPC(RESULT,OPTION,DATA) ; RPC to return existing VistA patient data for
        ; renal dialysis data entry.
        ; RPC: [MDK GET VISTA DATA]
        ;
        ; Input parameters
        ;  1. RESULT [Reference/Required] RPC Return array
        ;  2. OPTION [Literal/Required] RPC Option to execute
        ;  3. DATA [Literal/Required] Other data as required for call
        ;
        K RESULT
        D:$T(@OPTION)]"" @OPTION
        S:'$D(RESULT) RESULT(0)="-1^No results returned"
        Q
DEMO    ; demographic
        N DFN,MDKNODE0,MDKSSN
        S DFN=$G(DATA)
        I '$G(DFN) D  Q
        .S RESULT(0)="-1^DFN is not defined"
        .Q
        I '$D(^DPT(DFN,0)) D  Q
        .S RESULT(0)="-1^Patient not found"
        .Q
        S MDKNODE0=$G(^DPT(DFN,0))
        S RESULT(1)=$P(MDKNODE0,U,1) ;name
        S RESULT(2)=$P(MDKNODE0,U,9) ;ssn
        S RESULT(3)=$P(MDKNODE0,U,3) ;date of birth
        S RESULT(0)=3
        Q
ALLERGY ; get allergy data
        ; DATA = DFN
        S DFN=$G(DATA)
        N GMRAL
        N MDKCNT,MDLOOP
        S (MDKCNT,MDKLOOP)=0
        D EN1^GMRADPT
        I $O(GMRAL(0))'>0 D  Q
        .S:$G(GMRAL)="" RESULT(1)="No Allergy Assessment"
        .S:$G(GMRAL)=0 RESULT(1)="No Known Allergies"
        .S RESULT(0)=1
        .Q
        I $O(GMRAL(0))>0 D
        .F  S MDKLOOP=$O(GMRAL(MDKLOOP)) Q:MDKLOOP'>0  D
        ..S MDKCNT=MDKCNT+1
        ..S RESULT(MDKCNT)=$P($G(GMRAL(MDKLOOP)),U,2)
        ..Q
        .S RESULT(0)=MDKCNT
        .Q
        Q
SHOTS   ; get latest vaccination data
        N MDKCNT,MDKDATE,MDKIEN,MDKIMMUM,MDKNAME,MDKNODE
        S DFN=$G(DATA)
        S (MDKCNT,RESULT(0))=0
        S MDKIMMUM("HEP A")="HEPATITIS A"
        S MDKIMMUM("HEP B")="HEPATITIS B"
        S MDKIMMUM("INFLUENZA")="FLU"
        S MDKIMMUM("PNEUMO-VAC")="PNEUMOCOCCAL"
        ;S MDKIMMUM("PNEUMOCOCCAL")="PNEUMONIA"
        S MDKIMMUM("PPD")="PPD"
        D IMMUN^PXRHS03(DFN)
        F MDKNAME="HEP A","HEP B","INFLUENZA","PNEUMO-VAC" D
        .Q:'$D(^TMP("PXI",$J,MDKNAME))
        .S MDKDATE=0
        .F  S MDKDATE=$O(^TMP("PXI",$J,MDKNAME,MDKDATE)) Q:'MDKDATE  D
        ..S MDKIEN=0
        ..F  S MDKIEN=$O(^TMP("PXI",$J,MDKNAME,MDKDATE,MDKIEN)) Q:'MDKIEN  D
        ...S MDKNODE=$G(^TMP("PXI",$J,MDKNAME,MDKDATE,MDKIEN,0))
        ...Q:MDKNODE=""
        ...S MDKCNT=MDKCNT+1
        ...;RESULT(N)=shot name^date^reaction^contraindicated
        ...S RESULT(MDKCNT)=MDKIMMUM(MDKNAME)_U_$P(MDKNODE,U,3)_U_$P(MDKNODE,U,6)_U_$P(MDKNODE,U,7)
        ...Q
        ..Q
        .Q
        S RESULT(0)=MDKCNT
        K ^TMP("PXI",$J)
        ; get PPD (skin) result
        D SKIN^PXRHS04(DFN)
        I $D(^TMP("PXS",$J)) D
        .S MDKDATE=0
        .F  S MDKDATE=$O(^TMP("PXS",$J,"PPD",MDKDATE)) Q:'MDKDATE  D
        ..S MDKIEN=0
        ..F  S MDKIEN=$O(^TMP("PXS",$J,"PPD",MDKDATE,MDKIEN)) Q:'MDKIEN  D
        ...S MDKNODE=$G(^TMP("PXS",$J,"PPD",MDKDATE,MDKIEN,0))
        ...Q:MDKNODE=""
        ...S MDKCNT=MDKCNT+1
        ...;RESULT(N)=skin test^date
        ...S RESULT(MDKCNT)=$P(MDKNODE,U,1)_U_$P(MDKNODE,U,2)
        ...S RESULT(0)=MDKCNT
        ...Q
        ..Q
        .Q
        K ^TMP("PXS",$J)
        Q
LAB     ; get lab results
        ; data = dfn^start date^end date^max # of entires to return
        N LA7PTID,LA7SDT,LA7EDT,LA7SC,LA7SPEC
        N MDK64PTR,MDKARRAY,MDKCNT,MDKCODE,MDKDATE,MDKEDT,MDKFLAG,MDKLOOP,MDKMAX,MDKNLT,MDKNODE,MDKODT,MDKRSULT
        N MDKSC,MDKSDT,MDKSSN,MDKTEST,MDKTOT,MDKUNIT
        S DATA=$G(DATA)
        S DFN=$P(DATA,U,1)
        Q:'DFN
        S MDKSDT=$P(DATA,U,2) ;start date
        S MDKEDT=$P(DATA,U,3) ;end date
        S MDKMAX=+$P(DATA,U,4) ;# of entries per test
        S MDKSSN=$P($G(^DPT(DFN,0)),U,9) ;patient ssn
        I MDKEDT="" S MDKEDT=$$NOW^XLFDT()
        ;I MDKSDT="" S MDKSDT=$$FMADD^XLFDT(DT,-90) ;go back 90 days
        I MDKSDT="" S MDKSDT=$$FMADD^XLFDT(DT,-365) ;<-- TESTING ONLY
        I 'MDKMAX S MDKMAX=3
        ; array(nlt code)=test name
        S MDKSC("84520.")="BUN"
        S MDKSC("82565.")="CREATININE"
        S MDKSC("84295.")="SODIUM"
        S MDKSC("84140.")="POTASSIUM"
        S MDKSC("82435.")="CHLORIDE"
        S MDKSC("82830.")="CARBON DIOXIDE"
        S MDKSC("82310.")="CALCIUM"
        S MDKSC("84100.")="PHOSPHORUS"
        S MDKSC("82040.")="ALBUMIN"
        S MDKSC("84455.")="AST"
        S MDKSC("84465.")="ALT"
        S MDKSC("84075.")="ALKALINE PHOSPHATASE"
        S MDKSC("82250.")="BILIRUBIN"
        S MDKSC("83020.")="HEMOGLOBIN"
        S MDKSC("85055.")="HEMATOCRIT"
        S MDKSC("85569.")="WBC"
        S MDKSC("86806.")="PLATELETS"
        S MDKSC("83057.")="HEMOGLOBIN A1C"
        S MDKSC("82466.")="CHOLESTEROL"
        S MDKSC("84480.")="TRIGLYCERIDES"
        S MDKSC("82370.")="FERRITIN"
        S MDKSC("83540.")="IRON"
        S MDKSC("82060.")="TRANSFERRIN"
        S MDKSC("84012.")="PARATHRYROID HORMONE"
        S MDKSC("81512.")="ALUMINUM"
        S MDKSC("89068.")="HEPATITIS B SURFACE ANTIGEN"
        S MDKSC("89065.")="HEPATITIS B SURFACE ANTIBODY"
        S MDKSC("89067.")="HEPATITIS B SURFACE ANTIBODY"
        S MDKSC("82013.")="HEPATITIS B SURFACE ANTIBODY"
        S MDKSC("89095.")="HEPATITIS B SURFACE ANTIBODY"
        S MDKSC("89127.")="HEPATITIS B SURFACE ANTIBODY"
        S MDKSC("89128.")="HEPATITIS B SURFACE ANTIBODY"
        S MDKSC("87398.")="HEPATITIS B SURFACE ANTIBODY"
        S MDKSC("89699.")="HEPATITIS B SURFACE ANTIBODY"
        S MDKSC("89070.")="HEPATITIS C ANTIBODY"
        S MDKSC("87261.")="FLU"
        K ^TMP("HLS",$J)
        S LA7SDT=MDKSDT_"^RAD" ;start date
        S LA7EDT=MDKEDT_"^RAD" ;end date
        S LA7SC="CH" ;all chemistry tests
        S LA7SPEC="*" ;all specimens
        S LA7PTID=MDKSSN ;patient's ssn
        S MDKARRAY=$$GCPR^LA7QRY(LA7PTID,LA7SDT,LA7EDT,.LA7SC,LA7SPEC,"","","")
        S (MDKCNT,MDKTOT)=0
        F  S MDKCNT=$O(^TMP("HLS",$J,MDKCNT)) Q:'MDKCNT  D
        .S MDKNODE=$G(^TMP("HLS",$J,MDKCNT))
        .Q:$E(MDKNODE,1,3)'="OBX"
        .S MDKFLAG=0
        .S MDKTEST=$P(MDKNODE,"|",4) ;test ids
        .S MDKCODE=""
        .F  S MDKCODE=$O(MDKSC(MDKCODE)) Q:MDKCODE=""!(MDKFLAG=1)  D
        ..I MDKTEST[MDKCODE S MDKFLAG=1,MDKNLT=MDKCODE
        ..Q
        .Q:'MDKFLAG  ;nlt code doesn't match
        .S MDKDATE=$P(MDKNODE,"|",15) ;date
        .S MDKDATE=$P(MDKDATE,"-",1) ;strip off time zone offset
        .S MDKRSULT=$P(MDKNODE,"|",6) ;result
        .S MDKUNIT=$P(MDKNODE,"|",7) ;unit
        .S MDKTOT=MDKTOT+1
        .S RESULT(MDKTOT)=$G(MDKSC(MDKNLT))_U_MDKDATE_U_MDKRSULT_U_MDKUNIT
        .S RESULT(0)=$G(RESULT(0))+1
        .Q
        K ^TMP("HLS",$J)
        Q
AD      ; get advance directives
        ; DATA = DFN
        S DFN=$G(DATA)
        N MDKLOOP
        K ^TMP("TIUPPCV",$J)
        D ENCOVER^TIUPP3(DFN)
        I '$D(^TMP("TIUPPCV",$J)) Q
        S RESULT(1)="No",RESULT(0)=1
        S MDKLOOP=0
        F  S MDKLOOP=$O(^TMP("TIUPPCV",$J,MDKLOOP)) Q:'MDKLOOP  D
        .I $P(^TMP("TIUPPCV",$J,MDKLOOP),U,2)'="D" Q
        .S RESULT(1)="Yes"
        .S RESULT(0)=1
        .Q
        K ^TMP("TIUPPCV",$J)
        Q
        ;
CW      ; get clinical warnings
        ; DATA = DFN
        S DFN=$G(DATA)
        N MDKCNT,MDKLOOP
        K ^TMP("TIUPPCV",$J)
        D ENCOVER^TIUPP3(DFN)
        S RESULT(1)="None",RESULT(0)=1
        I '$D(^TMP("TIUPPCV",$J)) Q
        S (MDKCNT,MDKLOOP)=0
        F  S MDKLOOP=$O(^TMP("TIUPPCV",$J,MDKLOOP)) Q:'MDKLOOP  D
        .I $P(^TMP("TIUPPCV",$J,MDKLOOP),U,2)'="W" Q
        .S MDKCNT=MDKCNT+1
        .S RESULT(MDKCNT)=^TMP("TIUPPCV",$J,MDKLOOP)
        .Q
        S RESULT(0)=MDKCNT
        K ^TMP("TIUPPCV",$J)
        Q
        ;
GETPROV ; Get list of available providers with name starting with P1
        N MDDATE,MDDUP,MDRI,MDI1,MDI2,MDLAST,MDMAX,MDPREV,MDTTL
        S MDRI=0,MDMAX=44,(MDLAST,MDPREV)="",X1=DT,MDFROM=DATA,MDDATE=DT
        F  Q:MDRI'<MDMAX  S MDFROM=$O(^VA(200,"AUSER",MDFROM),1) Q:MDFROM=""  D
        .S MDI1=""
        .F  S MDI1=$O(^VA(200,"AUSER",MDFROM,MDI1),1) Q:'MDI1  D
        ..I MDDATE>0,$$GET^XUA4A72(MDI1,MDDATE)<1 Q    ; Check date?
        ..S MDRI=MDRI+1,RESULT(MDRI)=MDI1_U_$$NAMEFMT^XLFNAME(MDFROM,"F","DcMPC")
        I MDRI<1 S RESULT(0)="-1^No matches found." Q
        S RESULT(0)=MDRI
        Q
        ;
TIME    ; Get time
        S RESULT(0)=$$NOW^XLFDT()
        Q
GETLD   ; Get MDK Application Install Info
        N MDS
        S MDS=$$GET^XPAR("SYS","MDK APPLICATION INSTALL","DATE_TIME_OF_LAUNCH")
        S MDS=MDS_"^"_$$GET^XPAR("SYS","MDK APPLICATION INSTALL","USER")
        S MDS=MDS_"^"_$$GET^XPAR("SYS","MDK APPLICATION INSTALL","OPTION_LOADED")
        S MDS=MDS_"^"_$$GET^XPAR("SYS","MDK APPLICATION INSTALL","WORKSTATION")
        S RESULT(0)=MDS
        Q
SETLD   ; Set MDK Application Install Info
        D EN^XPAR("SYS","MDK APPLICATION INSTALL","DATE_TIME_OF_LAUNCH",$P(DATA,"^"))
        D EN^XPAR("SYS","MDK APPLICATION INSTALL","USER",$P(DATA,"^",2))
        D EN^XPAR("SYS","MDK APPLICATION INSTALL","OPTION_LOADED",$P(DATA,"^",3))
        D EN^XPAR("SYS","MDK APPLICATION INSTALL","WORKSTATION",$P(DATA,"^",4))
        Q
