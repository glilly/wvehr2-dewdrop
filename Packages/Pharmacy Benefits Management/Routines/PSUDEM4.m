PSUDEM4 ;BIR/DAM - Provider Extract ; 4/26/07 4:38pm
        ;;4.0;PHARMACY BENEFITS MANAGEMENT;**8,12**;MARCH, 2005;Build 19
        ;
        ;DBIA'S
        ; Reference to file 200    supported by DBIA 10060
        ; Reference to file 7      supported by DBIA 2495
        ; Reference to file 49     supported by DBIA 432
        ; Reference to file 8932.1 supported by DBIA 2091
        ; Reference to file 4.2    supported by DBIA 2496
        ;
EN      ;Entry point for gathering all provider information from IV, UD, Rx,
        ;and PD modules.
        ;
        N PSUREC
        S ^XTMP("PSU_"_PSUJOB,"PSUFLAG")=""
        ;
        D PULL^PSUCP
        F I=1:1:$L(PSUOPTS,",") S PSUMOD($P(PSUOPTS,",",I))=""
        ;
        I '$D(PSUMOD(7)) D EN^PSUDEM1
        I '$D(PSUMOD(1)) D EN^PSUV0
        I '$D(PSUMOD(2)) D EN^PSUUD0
        I '$D(PSUMOD(4)) D
        .S ^XTMP("PSU_"_PSUJOB,"PSUOPFLG")=""   ;Set flag
        .D EN^PSUOP0
        M ^XTMP("PSU_"_PSUJOB,"PSUPROM")=^XTMP("PSU_"_PSUJOB,"PSUPROV")
        ;
        D XMD
        D EN^PSUSUM1      ;compose provider summary report and mail it.
        K ^XTMP("PSU_"_PSUJOB,"PSUFLAG")
        Q
        ;
PDSSN   ;EN  Called from PSUDEM1
        ;Find provider SSN and IEN present in the patient demographics
        ;extract.  Note that this is the primary care provider.
        ;
        S PSUT=0
        F  S PSUT=$O(^XTMP("PSU_"_PSUJOB,"PSUDM",PSUT)) Q:'PSUT  D
        .N PSUIEN,PSUSSN1
        .S PSUIEN=$P($G(^XTMP("PSU_"_PSUJOB,"PSUDM",PSUT)),U,15) I 'PSUIEN S PSUIEN="UNK"
        .D FAC
        .D PNAM
        .S PSUSSN1=$P($G(^XTMP("PSU_"_PSUJOB,"PSUDM",PSUT)),U,14) I 'PSUSSN1 S PSUSSN1=""
        .S PSUREC=PSUSSN1 D REC^PSUDEM2
        .S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,3)=PSUREC              ;Dem Prov SSN
        .S PSUREC=PSUIEN D REC^PSUDEM2
        .S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,4)=PSUREC D              ;Dem Prov ICN
        ..I PSUREC="UNK" K ^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN)
        Q
        ;
UDSSN   ;EN  Called from PROV^PSUUD1. Find provider SSN and IEN in the unit 
        ;dose extract
        ;
        S PSUIEN=0,PSUVSSN1=0
        F  S PSUVSSN1=$O(^XTMP("PSU_"_PSUJOB,"PSUPDR",PSUVSSN1)) Q:PSUVSSN1=""  D
        .F  S PSUIEN=$O(^XTMP("PSU_"_PSUJOB,"PSUPDR",PSUVSSN1,PSUIEN)) Q:PSUIEN=""  D
        ..D FAC
        ..S PSUREC=PSUVSSN1 D REC^PSUDEM1 D
        ...I PSUREC=999999999 S PSUREC=""
        ...S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,3)=PSUREC   ;UD Prov SSN
        ..S PSUREC=PSUIEN D REC^PSUDEM2
        ..S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,4)=PSUREC    ;UD Prov IEN
        ..D PNAM
        Q
        ;
IVSSN   ;EN Called from PSUIV1. Gives Provider within date range of extract
        ;
        D UDSSN
        Q
        ;
OPSSN   ;EN Called from PSUOP0.  Gives prescription Provider
        ;
        D UDSSN
        Q 
FAC     ;Find provider station number.  Places that info in each record.
        ;
        ;D INST^PSUDEM1
        S $P(^TMP("PSUPROV",$J),U,2)=PSUSNDR
        M ^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN)=^TMP("PSUPROV",$J)
        Q
        ;
PNAM    ;Find the provider's name.
        ;
        N PSUCLP,PSUSS,PSUSP
        ;
        ;Find provider name
        S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,9)=$$GET1^DIQ(200,PSUIEN,.01,"I")
        ;
        S PSUCLP=$$GET1^DIQ(200,PSUIEN,53.5,"I") D CLASS  ;Provider pointer
        S PSUSS=$$GET1^DIQ(200,PSUIEN,29,"I") D SS        ;Service Sctn ptr
        ;
        S PSUD1=999
        S PSUD1=$O(^VA(200,PSUIEN,"USC1",PSUD1),-1)  ;Find last subscript
        I PSUD1'="" D
        .S PSUSP=$$GET1^DIQ(200.05,PSUD1_","_PSUIEN_",",.01,"I")  ;Specialty
        .D SPEC
        I PSUD1="" D
        .S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,7)=""
        .S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,8)=""
        Q
        ;
CLASS   ;Find provider class
        ;
        I '$D(PSUCLP) S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,5)="" Q
        I PSUCLP="" S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,5)=""
        I PSUCLP'="" D
        .N PSUA
        .S PSUA=$P($G(^DIC(7,PSUCLP,0)),U,2)
        .I PSUA']"" S PSUA=$P($G(^DIC(7,PSUCLP,0)),U,1)
        .S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,5)=PSUA  ;Prov class
        .K PSUA
        Q
        ;
SS      ;Find Provider Service/Section
        ;
        N PSUTMP
        ;
        I PSUSS="" S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,6)=""
        I PSUSS'="" S PSUTMP=1 D
        .S:$P($G(^DIC(49,PSUSS,0)),U)["AMBU" PSUTMP="AMB"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["ANESTH" PSUTMP="ANES"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["CARDIO" PSUTMP="CV"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["PHARM" PSUTMP="CPHAR"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["DENT" PSUTMP="DDS"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["MEDIC" PSUTMP="MED"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["INTERMED" PSUTMP="IM"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["NUCLEAR" PSUTMP="NUM"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["NURSING" PSUTMP="RN"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["ORTHOPED" PSUTMP="ORTHO"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["PSYCHIA" PSUTMP="PSY"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["MENTAL" PSUTMP="PSY"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["PRIMARY" PSUTMP="AMB"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["CBOC" PSUTMP="AMB"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["OPHTH" PSUTMP="OPH"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["PULM" PSUTMP="PUL"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["RADIOL" PSUTMP="RAD"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["SURG" PSUTMP="SUR"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["UROLOG" PSUTMP="U"
        .S:$P($G(^DIC(49,PSUSS,0)),U)["NEUROL" PSUTMP="NEUR"
        .S PSUREC=$G(PSUTMP) D REC^PSUDEM2
        .S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,6)=$G(PSUREC)       ;Prov Serv/Sec
        Q
        ;
SPEC    ;Find provider specialty and sub-specialty
        ;
        I PSUSP="" S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,7)=""
        I PSUSP="" S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,8)=""
        I PSUSP'="" D
        .S PSUREC=$P($G(^USC(8932.1,PSUSP,0)),U,2) D REC^PSUDEM2
        .S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,7)=PSUREC D     ;Speclty
        ..I $P(^USC(8932.1,PSUSP,0),U,2)="" S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,7)=""
        .S PSUREC=$P($G(^USC(8932.1,PSUSP,0)),U,3) D REC^PSUDEM2
        .S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,8)=PSUREC D      ;Subspecl
        ..I $P(^USC(8932.1,PSUSP,0),U,3)="" S $P(^XTMP("PSU_"_PSUJOB,"PSUPROV",PSUIEN),U,8)=""
        ;
        Q
        ;
XMD     ;Format mailman message and send.
        ;
        S PSUAA=0
        F  S PSUAA=$O(^XTMP("PSU_"_PSUJOB,"PSUPROM",PSUAA)) Q:PSUAA=""  D
        .S $P(^XTMP("PSU_"_PSUJOB,"PSUPROM",PSUAA),U,9)=""      ;Remove provider name
        ;
        ;Remove space in piece 8
        S PSUAB=0
        F  S PSUAB=$O(^XTMP("PSU_"_PSUJOB,"PSUPROM",PSUAB)) Q:PSUAB=""  D
        .I $P(^XTMP("PSU_"_PSUJOB,"PSUPROM",PSUAB),U,8)=" " D
        ..S $P(^XTMP("PSU_"_PSUJOB,"PSUPROM",PSUAB),U,8)=""
        ;
        S PSUAC=0,PSUPL=1
        F  S PSUAC=$O(^XTMP("PSU_"_PSUJOB,"PSUPROM",PSUAC)) Q:PSUAC=""  D
        .M ^TMP("PSUPROM",$J,PSUPL)=^XTMP("PSU_"_PSUJOB,"PSUPROM",PSUAC)  ;numerical order
        .S PSUPL=PSUPL+1
        ;
        NEW PSUMAX,PSULC,PSUTMC,PSUTLC,PSUMC
        S PSUMAX=$$VAL^PSUTL(4.3,1,8.3)
        S PSUMAX=$S(PSUMAX="":10000,PSUMAX>10000:10000,1:PSUMAX)
        S PSUMC=1,PSUMLC=0
        F PSULC=1:1 S X=$G(^TMP("PSUPROM",$J,PSULC)) Q:X=""  D
        .S PSUMLC=PSUMLC+1
        .I PSUMLC>PSUMAX S PSUMC=PSUMC+1,PSUMLC=0,PSULC=PSULC-1 Q  ; +  message
        .I $L(X)<235 S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=X Q
        .F I=235:-1:1 S Z=$E(X,I) Q:Z="^"
        .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)=$E(X,1,I)
        .S PSUMLC=PSUMLC+1
        .S ^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUMC,PSUMLC)="*"_$E(X,I+1,999)
        ;
        F PSUM=1:1:PSUMC D PROV^PSUDEM5
        D CONF
        Q
CONF    ;Construct globals for confirmation message
        ;
        ;   Count Lines sent
        S PSUTLC=0
        F PSUM=1:1:PSUMC S X=$O(^XTMP("PSU_"_PSUJOB,"PSUXMD",PSUM,""),-1),PSUTLC=PSUTLC+X
        ;
        D INST^PSUDEM1
        N PSUDIVIS
        S PSUDIVIS=$P(^XTMP("PSU_"_PSUJOB,"PSUSITE"),U,1)
        S PSUSUB="PSU_"_PSUJOB
        S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,10,"M")=PSUMC
        S ^XTMP(PSUSUB,"CONFIRM",PSUDIVIS,10,"L")=PSUTLC
        Q
