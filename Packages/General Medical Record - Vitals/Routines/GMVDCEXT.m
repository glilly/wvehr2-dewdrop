GMVDCEXT        ;HOIFO/DAD,FT-VITALS COMPONENT: EXTRACT PATIENT DATA ;6/13/07
        ;;5.0;GEN. MED. REC. - VITALS;**23**;Oct 31, 2002;Build 25
        ;
        ; This routine uses the following IAs:
        ;  #4290 - ^PXRMINDX global         (controlled)
        ; #10035 - FILE 2 references        (supported)
        ; #10104 - ^XLFSTR calls            (supported)
        ;
        ; This routine supports the following IAs:
        ; #4251 - EN1 entry point           (private)
        ;
EN1(RESULT,GMVDFN,GMVFMT,GMVABR,GMVALL,GMVBEG,GMVEND,GMVMSYS,GMVEER)    ;
        ; Return patient vitals
        ;
        ; Input:
        ;  RESULT  = Where data is returned (closed array reference) (Required)
        ;  GMVDFN  = A pointer to the Patient file (#2) (Required)
        ;  GMVFMT  = Format of returned data (Optional)
        ;            1 - IENs (default), 2 - Abbreviations, 3 - Full Names
        ;  GMVABR  = Abbreviations of vital types to return (Optional)
        ;            "^T^P^R^PO2^BP^HT^WT^CVP^CG^PN^"  (Default GMVALL = 0)
        ;            "~ALL~" to return all vital types (Default GMVALL = 1)
        ;  GMVALL  = Controls what data is returned (Optional)
        ;            0 - Most recent (default), 1 - All in date range
        ;  GMVBEG  = Beginning date for all vitals (Not used for GMVALL = 0)
        ;  GMVEND  = Ending    date for all vitals (Not used for GMVALL = 0)
        ;  GMVMSYS = Measurement system (Optional)
        ;            M = Metric, C - US Customary (Default)
        ;  GMVEER  = Include entered in error records (Optional)
        ;            (0 - No (Default), 1 - Yes)
        ;
        ; Output:
        ;  RESULT() = VitalMeasurementIEN ^ DateTimeTaken ^ PatientDFN ^
        ;             VitalType ^ DateTimeEntered ^ HospitalLocation ^
        ;             EnteredBy ^ Measurement ^ EnteredInError ^
        ;             EnteredInErrorBy ^
        ;             Qualifier1 ; Qualifier2 ; ... ^
        ;             EnteredInErrorReason1 ; EnteredInErrorReason2 ; ... ^
        ;
        N GMV,GMVABBR,GMVALUE,GMVCAT,GMVCD0,GMVCD1,GMVD0,GMVD1,GMVDATA
        N GMVDATA2,GMVER,GMVFOUND,GMVIDATE,GMVOK,GMVPOR,GMVPULSE,GMVQD0
        N GMVQD1,GMVQUA,GMVQL
        N GMVRATE,GMVRET
        K @RESULT
        S @RESULT@(0)="OK"
        S GMVALL=$S("^0^1^"[(U_$G(GMVALL)_U):GMVALL,1:0)
        S GMVFMT=$S("^1^2^3^"[(U_$G(GMVFMT)_U):GMVFMT,1:1)
        S GMVEER=$S(GMVALL=0:0,"^0^1^"[(U_$G(GMVEER)_U):GMVEER,1:0)
        I $$FIND1^DIC(2,"","","`"_GMVDFN)'=GMVDFN D
        . S @RESULT@(0)="ERROR"
        . S @RESULT@(1)="ERROR: Missing or invalid Patient parameter"
        . Q
        S GMVMSYS=$$MEASYS^GMVDCUTL($G(GMVMSYS))
        K GMVRET
        D DT^DILF("ST",$G(GMVEND),.GMVRET,"-NOW")
        S GMVEND=$G(GMVRET)
        K GMVRET
        D DT^DILF("ST",$G(GMVBEG),.GMVRET,-GMVEND)
        S GMVBEG=$G(GMVRET) S:GMVBEG>0 GMVBEG=GMVBEG-.000001
        I GMVALL&((GMVBEG'>0)!(GMVEND'>0)) D
        . S @RESULT@(0)="ERROR"
        . S @RESULT@(2)="ERROR: Missing or invalid Date Range parameters"
        . Q
        I $G(@RESULT@(0))="ERROR" Q
        S GMVABBR=$S($G(GMVABR)]"":GMVABR,GMVALL=1:"~ALL~",1:"^T^P^R^PO2^BP^HT^WT^CVP^CG^PN^")
        I GMVABBR="~ALL~" D
        . S GMVD0=0,GMVABBR=U
        . F  S GMVD0=$O(^GMRD(120.51,GMVD0)) Q:GMVD0'>0  D
        .. S GMVABBR(0)=$P($G(^GMRD(120.51,GMVD0,0)),U,2)
        .. I GMVABBR(0)]"" S GMVABBR=GMVABBR_GMVABBR(0)_U
        .. Q
        . Q
        S GMVABBR=$S($E(GMVABBR)'=U:U,1:"")_GMVABBR_$S($E(GMVABBR,$L(GMVABBR))'=U:U,1:"")
        F GMV=2:1:$L(GMVABBR,U)-1 S GMVABBR(0)=$P(GMVABBR,U,GMV) D
        . I $S(GMVABBR(0)="":1,$O(^GMRD(120.51,"C",GMVABBR(0),0))>0:1,1:0) Q
        . I GMVABBR(0)'=+GMVABBR(0) S GMVABBR(0)=+$O(^GMRD(120.51,"B",GMVABBR(0),0))
        . S GMVABBR(0)=$P($G(^GMRD(120.51,GMVABBR(0),0)),U,2)
        . S $P(GMVABBR,U,GMV)=GMVABBR(0)
        . Q
        F GMV=1:1 S GMVPULSE=$P($T(PULSE+GMV),";;",2) Q:GMVPULSE=""  D
        . S GMVD0=0
        . F  S GMVD0=$O(^GMRD(120.52,"B",GMVPULSE,GMVD0)) Q:GMVD0'>0  D
        .. I $P($G(^GMRD(120.52,GMVD0,0)),U)=GMVPULSE S GMVPULSE(GMVD0)=GMVPULSE,GMVPULSE(GMVPULSE)=GMVD0
        .. Q
        . Q
        S GMVD0=0
        F  S GMVD0=$O(^GMRD(120.51,GMVD0)) Q:GMVD0'>0  D
        . S GMVABBR(0)=$G(^GMRD(120.51,GMVD0,0))
        . I GMVABBR[(U_$P(GMVABBR(0),U,2)_U) S GMVABBR($P(GMVABBR(0),U,2))=GMVD0_U_$P(GMVABBR(0),U,2)_U_$P(GMVABBR(0),U)
        . Q
        S GMVABBR=""
        F  S GMVABBR=$O(GMVABBR(GMVABBR)) Q:GMVABBR=""  I GMVABBR(GMVABBR)>0 D
        . S GMVFOUND=0
        . S GMVIDATE=$S(GMVALL:GMVBEG,1:0)
        . I GMVALL=1 F  S GMVIDATE=$O(^PXRMINDX(120.5,"PI",GMVDFN,+GMVABBR(GMVABBR),GMVIDATE)) Q:GMVIDATE'>0!$S(GMVALL:GMVIDATE>GMVEND,1:0)!GMVFOUND  D SETDATAR
        . I GMVALL=0 S GMVIDATE=GMVEND+.000001 F  S GMVIDATE=$O(^PXRMINDX(120.5,"PI",GMVDFN,+GMVABBR(GMVABBR),GMVIDATE),-1) Q:GMVIDATE'>0!(GMVFOUND)!(GMVIDATE<GMVBEG)  D SETDATAR
        . Q:GMVEER=0
        . S GMVIDATE=$S(GMVALL:9999999-GMVEND,1:0)
        . F  S GMVIDATE=$O(^GMR(120.5,"AA",GMVDFN,+GMVABBR(GMVABBR),GMVIDATE)) Q:GMVIDATE'>0!$S(GMVALL:(9999999-GMVIDATE)<GMVBEG,1:0)!GMVFOUND  D SETDATA1
        . Q
        Q
        ;
SETDATAR        ;
        N GMVCLIO
        S GMVD0=0
        F  S GMVD0=$O(^PXRMINDX(120.5,"PI",GMVDFN,+GMVABBR(GMVABBR),GMVIDATE,GMVD0)) Q:$L(GMVD0)'>0!GMVFOUND  D
        .I GMVD0=+GMVD0 D
        ..D F1205^GMVUTL(.GMVCLIO,GMVD0)
        .I GMVD0'=+GMVD0 D
        ..D CLIO^GMVUTL(.GMVCLIO,GMVD0)
        .S GMVCLIO(0)=$G(GMVCLIO(0)),GMVCLIO(2)=$G(GMVCLIO(2)),GMVCLIO(5)=$G(GMVCLIO(5))
        .I GMVCLIO(0)=""!($P(GMVCLIO(0),U,8)="") Q
        .D SETNODE
        .Q
        Q
        ;
SETDATA1        ;
        N GMVCLIO
        S GMVD0=0
        F  S GMVD0=$O(^GMR(120.5,"AA",GMVDFN,+GMVABBR(GMVABBR),GMVIDATE,GMVD0)) Q:$L(GMVD0)'>0!GMVFOUND  D
        .I GMVD0=+GMVD0 D
        .I $P($G(^GMR(120.5,GMVD0,2)),U,1)'=1 Q  ;not an error
        .D F1205^GMVUTL(.GMVCLIO,GMVD0,1)
        .S GMVCLIO(0)=$G(GMVCLIO(0)),GMVCLIO(2)=$G(GMVCLIO(2)),GMVCLIO(5)=$G(GMVCLIO(5))
        .I GMVCLIO(0)=""!($P(GMVCLIO(0),U,8)="") Q
        .D SETNODE
        .Q
        Q
SETNODE ;
        S GMVDATA=GMVCLIO(0)
        S GMVDATA2=GMVCLIO(2)
        S GMVRATE=$P(GMVDATA,U,8)
        I GMVALL=0,"^REFUSED^PASS^UNAVAILABLE^"[(U_$$UP^XLFSTR(GMVRATE)_U) Q
        I GMVEER=0,(($P(GMVDATA2,U)>0)!($P(GMVDATA2,U,2)>0)) Q
        I GMVABBR="PO2",$P(GMVDATA,U,10)]"" D
        . ; *** Decode Supplemental O2 field (#1.4) ***
        . N GMVFRATE,GMVPCENT,GMVSUPO2
        . S GMVSUPO2=$$LOW^XLFSTR($TR($P(GMVDATA,U,10)," "))
        . S GMVFRATE=$S(GMVSUPO2["l/min":$P(GMVSUPO2,"l/min"),1:"")
        . S GMVFRATE=$TR(GMVFRATE,$TR(GMVFRATE,".0123456789"))
        . S GMVPCENT=$S(GMVSUPO2["%":$P(GMVSUPO2,"%"),1:"")
        . S GMVPCENT=$S(GMVPCENT["l/min":$P(GMVPCENT,"l/min",2),GMVPCENT=+GMVPCENT:GMVPCENT,1:"")
        . S GMVPCENT=$TR(GMVPCENT,$TR(GMVPCENT,".0123456789"))
        . S GMVRATE=GMVRATE_";"_GMVFRATE_";"_GMVPCENT
        . Q
        I 'GMVALL,GMVABBR="P" D  I 'GMVOK Q
        . ; *** Include selected pulse types (latest vitals only) ***
        . S GMVOK=0
        . F GMVPULSE=1:1 Q:$P(GMVCLIO(5),U,GMVPULSE)=""  D  Q:GMVOK
        .. I $D(GMVPULSE(+$P(GMVCLIO(5),U,GMVPULSE))) S GMVOK=1
        .. Q
        . Q
        I 'GMVALL S GMVFOUND=1
        S GMVALUE=$$CNV^GMVDCCNV(GMVRATE,GMVMSYS,"G",$P(GMVABBR(GMVABBR),U,2))
        S @RESULT@(GMVD0)=GMVD0_U_$P(GMVDATA,U)_U_$P(GMVDATA,U,2)_U_$P(GMVABBR(GMVABBR),U,GMVFMT)_U_$P(GMVDATA,U,4)_U_$P(GMVDATA,U,5)_U_$P(GMVDATA,U,6)_U_GMVALUE_U_$P(GMVDATA2,U)_U_$P(GMVDATA2,U,2)_U
        K GMVQL
        F GMVD1=1:1 Q:$P(GMVCLIO(5),U,GMVD1)=""  D
        . S GMVQD0=$P(GMVCLIO(5),U,GMVD1)
        . S GMVQD1=+$O(^GMRD(120.52,GMVQD0,1,"B",GMVABBR(GMVABBR),0))
        . S GMVCD0=+$P($G(^GMRD(120.52,GMVQD0,1,GMVQD1,0)),U,2)
        . S GMVCAT=$P($G(^GMRD(120.53,GMVCD0,0)),U)
        . S GMVCAT=$S(GMVCAT]"":GMVCAT,1:" ")
        . S GMVQUA=$G(^GMRD(120.52,GMVQD0,0))
        . S GMVQUA(1)=GMVQD0,GMVQUA(2)=$P(GMVQUA,U,2),GMVQUA(3)=$P(GMVQUA,U)
        . S GMVCD1=+$O(^GMRD(120.53,"AA",+GMVABBR(GMVABBR),GMVCAT,GMVCD0,0))
        . S GMVPOR=1+$P($G(^GMRD(120.53,GMVCD0,1,GMVCD1,0)),U,5)
        . I $G(GMVQUA(GMVFMT))]"" D
        .. S GMVQL(GMVPOR,GMVCAT)=$G(GMVQL(GMVPOR,GMVCAT))_GMVQUA(GMVFMT)_";"
        .. Q
        . Q
        S GMVPOR=0
        F  S GMVPOR=$O(GMVQL(GMVPOR)) Q:GMVPOR'>0  D
        . S GMVCAT=""
        . F  S GMVCAT=$O(GMVQL(GMVPOR,GMVCAT)) Q:GMVCAT=""  D
        .. S @RESULT@(GMVD0)=@RESULT@(GMVD0)_GMVQL(GMVPOR,GMVCAT)
        .. Q
        . Q
        S @RESULT@(GMVD0)=$$FIXUP(@RESULT@(GMVD0))
        S GMVER(0)=";"_$$GET1^DID(120.506,.01,"","POINTER")
        F GMVD1=1:1 Q:$P($P(GMVCLIO(2),U,3),"~",GMVD1)=""  D
        . S GMVER=$P($P(GMVCLIO(2),U,3),"~",GMVD1)
        . I GMVER(0)[(";"_GMVER_":") D
        .. I GMVFMT<3 S @RESULT@(GMVD0)=@RESULT@(GMVD0)_GMVER_";"
        .. E  S @RESULT@(GMVD0)=@RESULT@(GMVD0)_$P($P(GMVER(0),";"_GMVER_":",2),";")_";"
        .. Q
        . Q
        S @RESULT@(GMVD0)=$$FIXUP(@RESULT@(GMVD0))
        Q
        ;
FIXUP(X)        ;
        Q $S($E(X,$L(X))=";":$E(X,1,$L(X)-1),1:X)_U
        ;
PULSE   ;;Pulse types to include in the latest vitals extract
        ;;APICAL
        ;;BRACHIAL
        ;;RADIAL
        ;;
