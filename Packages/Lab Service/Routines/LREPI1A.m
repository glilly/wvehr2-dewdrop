LREPI1A ;DALOI/SED-EMERGING PATHOGENS HL7 BUILDER ;5/1/98
        ;;5.2;LAB SERVICE;**175,260,315**;Sep 27, 1994;Build 25
        ; Reference to ^ICD9 supported by IA #10082
        ; Reference to ^XLFSTR supported by IA #10104
        ;
EN(LRDFN,SS,IVDT,SEQ)   ;Entry to build the HL7 Segment
        ;LRDFN=Patient ID
        ;SS=Subscripts in file 63  for results
        ;IVDT=Inverted Date and Time
        ;SEQ=Sequence Number
        ;S LRCS=$E(HL("ECH"))
        K ^TMP("HL7",$J)
        S:+$G(SEQ)'>0 SEQ=1
        S CNT=1
        Q:'$G(LRDFN)!('$G(IVDT))!('$L($G(SS)))
        I $L($T(@SS)) D @SS
EXIT    ;KILL THEN EXIT
        K CNT,IND,LRAND,LRANT,LRDATA,LRES,LRINLT,LRNT,LRRDTE,LRREF,LRTST,LRUNIT
        K ND,NLT,NLTP,ORGNB,ORGPT,SEQX,SITE,TYPE
        Q SEQ
CY      ;BUILD HL7 MSG FOR CY SUBSCRIPT
        ;TO BUILD OBR SEGMENT FOR CY
        I '$D(^LR(LRDFN,SS,IVDT,0)) Q
        ;Look at ICD9 codes
        I $O(^LR(LRDFN,SS,IVDT,3,0))>0 D
        .K LRDATA
        .S $P(LRDATA,HLFS,1)=$G(SEQ)
        .S $P(LRDATA,HLFS,4)="88056.0000"_LRCS_"CY SPECIMEN"_LRCS_"VANLT"
        .S $P(LRDATA,HLFS,18)=$P(^LR(LRDFN,SS,IVDT,0),U,6)
        .S $P(LRDATA,HLFS,7)=$$HLDATE^HLFNC(9999999-IVDT)
        .S LRSI=$O(^LR(LRDFN,SS,IVDT,.1,0)),SITE=""
        .S:+LRSI>0 SITE=$P($G(^LR(LRDFN,SS,IVDT,.1,LRSI,0)),U,1)
        .S $P(LRDATA,HLFS,15)=LRCS_LRCS_SITE
        .S ^TMP("HL7",$J,CNT)="OBR"_HLFS_$$UP^XLFSTR(LRDATA),CNT=CNT+1,SEQ=SEQ+1
        .S LRIC=0 F  S LRIC=$O(^LR(LRDFN,SS,IVDT,3,LRIC)) Q:+LRIC'>0  D
        ..Q:'$D(^LR(LRDFN,SS,IVDT,3,LRIC,0))
        ..S:'$D(DGCNT) DGCNT=1
        ..S ICD9=$P(^LR(LRDFN,SS,IVDT,3,LRIC,0),U,1)
        ..N LRTMP
        ..S LRTMP=$$ICDDX^ICDCODE(ICD9,,,1)
        ..K LRDATA
        ..S LRDATA="DG1"_HLFS_DGCNT_HLFS_HLFS_$P(LRTMP,U,2)
        ..S LRDATA=LRDATA_LRCS_$P(LRTMP,U,4)_LRCS_"I9"
        ..S ^TMP("HL7",$J,CNT)=$$UP^XLFSTR(LRDATA),DGCNT=DGCNT+1,CNT=CNT+1
        K LRDATA,DGCNT
        ;Look to see in there is a workload code.
        S LRWKI=0 F  S LRWKI=$O(^LR(LRDFN,SS,IVDT,.1,LRWKI)) Q:+LRWKI'>0  D
        .S LRWKDT=$G(^LR(LRDFN,SS,IVDT,.1,LRWKI,0))
        .Q:+$P(LRWKDT,U,2)'>0
        .Q:'$D(^LAB(60,$P(LRWKDT,U,2)))
        .S LRTST=$P(LRWKDT,U,2)
        .S LRNLT="88056.0000"_LRCS_"CY SPECIMEN"_LRCS_"VANLT"
        .S LRINLT=+$G(^LAB(60,$P(LRWKDT,U,2),64))
        .I LRINLT'="",$D(^LAM(LRINLT,0)) D
        ..S $P(LRNLT,LRCS,2)=$P(^LAM(LRINLT,0),U,1)
        ..S $P(LRNLT,LRCS,1)=$P(^LAM(LRINLT,0),U,2)
        ..S $P(LRNLT,LRCS,3)="VANLT"
        .K LRDATA
        .S $P(LRDATA,HLFS,1)=$G(SEQ)
        .S $P(LRDATA,HLFS,4)=LRNLT_LRCS_LRTST_LRCS_$P(^LAB(60,LRTST,0),U)_LRCS_"VA60"
        .S $P(LRDATA,HLFS,18)=$P(^LR(LRDFN,SS,IVDT,0),U,6)
        .S $P(LRDATA,HLFS,7)=$$HLDATE^HLFNC(9999999-IVDT)
        .S LRRDTE=$P($G(^LR(LRDFN,SS,IVDT,0)),U,3)
        .S:+LRRDTE>0 LRRDTE=$$HLDATE^HLFNC(LRRDTE)
        .S SITE=$P(LRWKDT,U,1)
        .S $P(LRDATA,HLFS,15)=LRCS_LRCS_SITE
        .S ^TMP("HL7",$J,CNT)="OBR"_HLFS_$$UP^XLFSTR(LRDATA),CNT=CNT+1,SEQ=SEQ+1
        K LRDATA,DGCNT,LRTST,LRWKDT,LRINLT,LRNLT
        ;Look into Multiple CYTOPATH ORGAN/TISSUE sub file
        S LRTOP=0 F  S LRTOP=$O(^LR(LRDFN,SS,IVDT,2,LRTOP)) Q:+LRTOP'>0  D
        .K LRDATA
        .S $P(LRDATA,HLFS,1)=$G(SEQ)
        .S $P(LRDATA,HLFS,4)="88056.0000"_LRCS_"CY SPECIMEN"_LRCS_"VANLT"
        .S $P(LRDATA,HLFS,18)=$P(^LR(LRDFN,SS,IVDT,0),U,6)
        .S $P(LRDATA,HLFS,7)=$$HLDATE^HLFNC(9999999-IVDT)
        .S LRRDTE=$P($G(^LR(LRDFN,SS,IVDT,0)),U,3)
        .S:+LRRDTE>0 LRRDTE=$$HLDATE^HLFNC(LRRDTE)
        .S SITE=$P(^LR(LRDFN,SS,IVDT,2,LRTOP,0),U,1)
        .D SITECD^LREPI1
        .S $P(LRDATA,HLFS,15)=LRCODE_LRCS_LRCS_$P($G(^LAB(61,SITE,0)),U)
        .S ^TMP("HL7",$J,CNT)="OBR"_HLFS_$$UP^XLFSTR(LRDATA),CNT=CNT+1,SEQ=SEQ+1
        .;NOW DO THE OBX(s) FOR TO SITE
        .S ND="61.4,61.1,61.3,61.5"
        .S SEQX=1
        .F LRSUB=1,2,3,4 D
        ..Q:'$D(^LR(LRDFN,SS,IVDT,2,LRTOP,LRSUB,0))
        ..S LRNX=0
        ..F  S LRNX=$O(^LR(LRDFN,SS,IVDT,2,LRTOP,LRSUB,LRNX)) Q:+LRNX'>0  D
        ...K LRDATA
        ...S LRI=$P(^LR(LRDFN,SS,IVDT,2,LRTOP,LRSUB,LRNX,0),U,1)
        ...Q:'$D(^LAB($P(ND,",",LRSUB),+LRI,0))
        ...S LRO=^LAB($P(ND,",",LRSUB),+LRI,0)
        ...S $P(LRDATA,HLFS,1)=$G(SEQX)
        ...S $P(LRDATA,HLFS,2)="ST"
        ...S $P(LRDATA,HLFS,3)=$P(LRO,U,2)_LRCS_$P(LRO,U,1)_LRCS_"SNM3"_LRCS_$P(LRO,U,2)_LRCS_$E($P(LRO,U,1),1,25)_LRCS_"SNM3"
        ...S $P(LRDATA,HLFS,14)=LRRDTE
        ...S LRRES=""
        ...S:LRSUB=4 LRRES=$P(^LR(LRDFN,SS,IVDT,2,LRTOP,LRSUB,LRNX,0),U,2)
        ...S:LRRES'="" $P(LRDATA,HLFS,5)=$S(LRRES:"Positive",1:"Negative")
        ...S ^TMP("HL7",$J,CNT)="OBX"_HLFS_$$UP^XLFSTR(LRDATA),CNT=CNT+1,SEQX=SEQX+1
        Q
