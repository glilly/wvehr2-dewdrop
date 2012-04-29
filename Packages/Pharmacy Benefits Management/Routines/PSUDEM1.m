PSUDEM1 ;BIR/DAM - Patient Demographics Extract ; 20 DEC 2001
        ;;4.0;PHARMACY BENEFITS MANAGEMENT;**12**;MARCH, 2005;Build 19
        ;
        ;DBIA's
        ; Reference to file #27.11  supported by DBIA 2462
        ; Reference to file 2       supported by DBIA 10035, 3504
        ; Reference to file 200     supported by DBIA 10060
        ; Reference to file 55      supported by DBIA 3502
        ; Reference to file 4.3     supported by DBIA 2496, 10091
        ; Reference to file 4       supported by DBIA 10090
        ;
EN      ;EN   Routine control module
        ;
        D DAT
        I $D(^XTMP("PSUMANL")) D DEM     ;Manual entry point  DAM
        I $G(^XTMP("PSU_"_PSUJOB,"PSUPSUMFLAG")) D HL7    ;Auto entry point DAM
        I '$D(^XTMP("PSU_"_PSUJOB,"PSUFLAG")) D XMD
        K ^XTMP("PSU_"_PSUJOB,"PSUXMD")
        ;
        I $G(^XTMP("PSU_"_PSUJOB,"PSUPSUMFLAG"))=1 D
        .S PSUOPTS="1,2,3,4,5,6,7,8,9,10,11"
        .S PSUAUTO=1
        ;
        ;
        D PULL^PSUCP
        F I=1:1:$L(PSUOPTS,",") S PSUMOD($P(PSUOPTS,",",I))=""
        ;
        I $D(PSUMOD(10)) D PDSSN^PSUDEM4  ;pt. demographics provider msg
        ;
        K ^XTMP("PSU_"_PSUJOB,"PSUPDFLAG")
        K ^XTMP("PSU_"_PSUJOB,"PSUDM")
        K ^XTMP("PSU_"_PSUJOB,"PSUDMX")
        K PSUDMDFN,PSURAC,PSURDT
        Q
        ;
HL7     ;This is the Patient Demographics extract that runs only when
        ;the PSU PBM [AUTO] option is executed.  It captures demographic
        ;information ONLY on new or updated patient.
        ;
        ; *** PSU*4.0*12 - BAJ -- added QUIT if NULL
        F  S PSUSDT=$O(^PSUDEM("B",PSUSDT)) Q:PSUSDT=""  Q:PSUSDT>PSUEDT  D
        . S I=""
        . S I=$O(^PSUDEM("B",PSUSDT,I)) Q:I=""
        . S DFN=$P(^PSUDEM(I,0),U,2)
        . S ^XTMP("PSU"_PSUJOB,"REXMT",DFN)=""
        K DFN
        ;
        S DFN=""
        F  S (DFN,PSUDMDFN)=$O(^XTMP("PSU"_PSUJOB,"REXMT",DFN)) Q:DFN=""  D DEM1
        ;
        Q
        ;
DAT     ;Date Module
        ;
        ;Date extract was run
        S %H=$H
        D YMD^%DTC                   ;Converts $H to FileMan format
        ; ** S $P(^TMP("PSUDM",$J),U,3)=X    ;Set extract date in temp global
        S PSURDT=X
        ;
        Q
        ;
INST    ;EN  Place institution code sending report into temp global.
        ;Institution Mailman info is in file 4.3
        ;
        S X=$$VALI^PSUTL(4.3,1,217),PSUSNDR=+$$VAL^PSUTL(4,X,99)
        S $P(^XTMP("PSU_"_PSUJOB,"PSUSITE"),U,1)=PSUSNDR
        S PSUSIT=PSUSNDR
        ;
        S X=PSUSNDR,DIC=40.8,DIC(0)="X",D="C" D IX^DIC ;**1
        S X=+Y S PSUDIVNM=$$VAL^PSUTL(40.8,X,.01)
        S $P(^XTMP("PSU_"_PSUJOB,"PSUSITE"),U,2)=PSUDIVNM
        Q
        ;
DEM     ;PULL PATIENT DEMOGRAPHICS. This is run only when user selects
        ;PSU PBM [MANUAL] option.  It gather patient demographic information
        ;for all patients in the PATIENT file #2.
        ;
        ;N PSUREC    ;DAM TEST NEW CODE
        N PSUREC
        K PSUREC1,PSUREC2,PSUREC3,PSUREC4,PSUREC5,PSUREC6,PSUREC7
        K PSUREC8,PSUREC9,PSUREC10,PSUREC11,PSUREC12,PSUREC13,PSUREC14
        K PSUREC15,PSUDOD,VAEL,VADM
        ;
        S PSUNAM=0
        F  S PSUNAM=$O(^DPT("B",PSUNAM)) Q:PSUNAM=""  D
        .S PSUDMDFN=0
        .F  S (DFN,PSUDMDFN)=$O(^DPT("B",PSUNAM,PSUDMDFN)) Q:PSUDMDFN=""  D DEM1
        Q
        ;
DEM1    ;
        K PSUREC,PSUREC1,PSUREC2,PSUREC3,PSUREC4,PSUREC5,PSUREC6,PSUREC7
        K PSUREC8,PSUREC9,PSUREC10,PSUREC11,PSUREC12,PSUREC13,PSUREC14
        K PSUREC15,PSUDOD,VAEL,VADM
        S PSUDOD=$P($G(^DPT(PSUDMDFN,.35)),U,1) I PSUDOD,PSUDOD<2980701 Q
        Q:'$D(^DPT(PSUDMDFN,0))  S PSUREC1=$G(^DPT(PSUDMDFN,0))
        I $P(PSUREC1,U,21)=1 Q
        I $E($P(PSUREC1,U,9),1,5)="00000" Q
        D DEM^VADPT
        D ELIG^VADPT
        ;RUN DATE
        S $P(PSUREC,U,3)=PSURDT
        ;Gender
        S PSUREC3=$TR($P(PSUREC1,U,2),"^","'"),$P(PSUREC,U,8)=PSUREC3
        ;SSN
        S PSUREC4=$TR($P(PSUREC1,U,9),"^","'"),$P(PSUREC,U,12)=PSUREC4
        ;DOB
        S PSUREC5=$TR($P(PSUREC1,U,3),"^","'"),$P(PSUREC,U,5)=PSUREC5
        ;DT PT ENTERED IN FILE
        S PSUREC6=$TR($P(PSUREC1,U,16),"^","'"),$P(PSUREC,U,16)=PSUREC6
        S PSUREC7=$G(^PS(55,PSUDMDFN,0)),$P(PSUREC,U,17)=$TR($P(PSUREC7,U,7),"^","'")
        ;Service Actual/Historical
        S $P(PSUREC,U,18)=$TR($P(PSUREC7,U,8),"^","'")
        ;PLACE "^" AT END OF RECORD
        S $P(PSUREC,U,30)=""
        ;SITE SENDING DATA
        S $P(PSUREC,U,2)=PSUSNDR
        ;RACE
        S PSUREC8=$P($G(VADM(8)),U,2),$P(PSUREC,U,7)=PSUREC8
        ;PRIMARY ELIG CODE
        S PSUREC9=$P($G(VAEL(1)),U,2),$P(PSUREC,U,9)=PSUREC9
        D PRIO
        ;MEANS TEST STATUS
        S PSUREC11=$P($G(VAEL(9)),U,2),$P(PSUREC,U,10)=PSUREC11
        D MISC
        ;FIND PATIENT ICN-VMP
        D ICN
        ;PATIENT CURRENT AGE
        S PSUREC12=$G(VADM(4)),$P(PSUREC,U,6)=PSUREC12
        D ETH
        S ^XTMP("PSU_"_PSUJOB,"PSUDMX",PSUDMDFN)=$G(PSUREC)
        Q
        ;
PRIO    ;Pull Enrollment Priority
        ;
        S PSUEC=0
        F  S PSUEC=$O(^DGEN(27.11,"C",PSUDMDFN,PSUEC)) Q:PSUEC=""  D
        .S PSUREC10=$TR($P($G(^DGEN(27.11,PSUEC,0)),U,7),"^","'")
        .I PSUREC10'="" S $P(PSUREC,U,11)=PSUREC10
        Q
        ;
MISC    ;Pulls miscellaneous additional info via EN^DIQ1 call
        ;Pulls Date of Death, ICN, Primary Care Provider SSN,
        ;Date patient first provided pharmacy care
        ;
        N PSUDATMP,PSUDDTMP,PSUDTMPA
        ;
        S PSUDTMPA=$$OUTPTPR^SDUTL3(PSUDMDFN)   ;Prov IEN^EXTERNAL VALUE in temp variable
        S PSUDATMP=$P($G(PSUDTMPA),U)       ;Prov IEN
        S $P(PSUREC,U,15)=PSUDATMP
        I '$D(PSUDATMP)!PSUDATMP=0 S PSUDATMP=99999999999
        S $P(PSUREC,U,14)=$$GET1^DIQ(200,PSUDATMP,9,"I")   ;Prov SSN
        S $P(PSUREC,U,4)=$S(PSUDOD:PSUDOD\1,1:"")
        Q
        ;
ICN     ;Find patient ICN
        ;VMP - OIFO BAY PINES;ELR;PSU*3.0*24
        ;
        N PSUICN,PSUICN1
        S PSUICN=$$GETICN^MPIF001(PSUDMDFN) D
        .I PSUICN'[-1 D
        ..S $P(PSUREC,U,13)=PSUICN    ;ICN
        Q
        ;
ETH     ;Ethnicity and multiple race entries
        ;
        S PSUREC14=$P($G(VADM(11,1)),U,2),$P(PSUREC,U,19)=PSUREC14
        ;
        S PSURCE=0,C=20,$P(PSUREC,U,C)=""
        F  S PSURCE=$O(VADM(12,PSURCE)) Q:PSURCE=""  D       ;Race multiple
        .S PSURAC=$P($G(VADM(12,PSURCE)),U,2),$P(PSUREC,U,C)=PSURAC,C=C+1
        Q
        ;
XMD     ;Format mailman message and send.
        ;
        S PSUAB=0,PSUPL=1
        F  S PSUAB=$O(^XTMP("PSU_"_PSUJOB,"PSUDMX",PSUAB)) Q:PSUAB=""  D
        .M ^XTMP("PSU_"_PSUJOB,"PSUDM",PSUPL)=^XTMP("PSU_"_PSUJOB,"PSUDMX",PSUAB)  ;Global numerical order
        .S PSUPL=PSUPL+1
        ;
        NEW PSUMAX,PSULC,PSUTMC,PSUTLC,PSUMC
        S PSUMAX=$$VAL^PSUTL(4.3,1,8.3)
        S PSUMAX=$S(PSUMAX="":10000,PSUMAX>10000:10000,1:PSUMAX)
        S PSUMC=1,PSUMLC=0
        F PSULC=1:1 S X=$G(^XTMP("PSU_"_PSUJOB,"PSUDM",PSULC)) Q:X=""  D
        .S PSUMLC=PSUMLC+1
        .I PSUMLC>PSUMAX S PSUMC=PSUMC+1,PSUMLC=0,PSULC=PSULC-1 Q  ; +  message
        .I $L(X)<235 S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=X Q
        .F I=235:-1:1 S Z=$E(X,I) Q:Z="^"
        .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=$E(X,1,I)
        .S PSUMLC=PSUMLC+1
        .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)="*"_$E(X,I+1,999)
        ;
        ;   Count Lines sent
        S PSUTLC=0
        F PSUM=1:1:PSUMC S X=$O(^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUM,""),-1),PSUTLC=PSUTLC+X
        ;
        F PSUM=1:1:PSUMC D PDMAIL^PSUDEM5
        D CONF
        Q
CONF    ;Construct globals for confirmation message
        ;
        N PSUDIVIS
        D INST
        S PSUDIVIS=$P(^XTMP("PSU_"_PSUJOB,"PSUSITE"),U,1)
        S PSUSUB="PSU_"_PSUJOB
        S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,7,"M")=PSUMC
        S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,7,"L")=PSUTLC
        Q
REC     ;EN If "^" is contained in any record, replace it with "'"
        ;
        I PSUREC["^" S PSUREC=$TR(PSUREC,"^","'")
        Q
