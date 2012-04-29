PSJORPOE        ;BIR/MLM,LDT-MISC. PROCEDURE CALLS FOR OE/RR 3.0 ;24 Feb 99 / 10:43 AM
        ;;5.0; INPATIENT MEDICATIONS ;**50,56,92,80,110,127,133,134**;16 DEC 97;Build 124
        ;
        ; Reference to ^PS(50.7 is supported by DBIA# 2180.
        ; Reference to ^PS(51.2 is supported by DBIA# 2178.
        ; Reference to ^PS(55 is supported by DBIA# 2191.
        ; Reference to ^PS(51.1 is supported by DBIA# 2177.
        ; Reference to ^PS(52.6 is supported by DBIA# 1231.
        ; Reference to ^PS(52.7 is supported by DBIA# 2173.
        ; Reference to ^PSDRUG is supported by DBIA# 2192.
        ;
STARTSTP(PSGP,SCH,OI,PSJPWD,PSGORD,PSJADM)      ;
        ; PSGP=Patient IEN
        ; SCH=Schedule
        ; OI=Orderable Item
        ; PSJPWD=Ward Location (Optional)
        ; PSGORD=Pharmacy Order Number if the order being placed is a Renewal (Optional)
        ;
        Q:+PSGP'>0 ""
        Q:SCH']"" ""
        Q:+OI'>0 ""
        I SCH?.E1L.E S SCH=$$ENLU^PSGMI(SCH)
        K DFN,PSGNEFDO,PSGNEFD,PSGST,PSGSCH,PSGNEDFD,PSGNESD,PSJSYSW,PSJSYSW0 N RESULT
        S:'$D(PSGS0XT) PSGS0XT="" S:'$D(PSGS0Y) PSGSOY=""
        I $G(PSJPWD)']"" S DFN=PSGP D IN5^VADPT S:VAIP(5)]"" PSJPWD=+VAIP(5)
        S PSJSYSW0="",PSJSYSW=0 I $G(PSJPWD)]"" S PSJSYSW=+$O(^PS(59.6,"B",PSJPWD,0)) I PSJSYSW S PSJSYSW0=$G(^PS(59.6,PSJSYSW,0))
        S RESULT=$S($P(PSJSYSW0,"^",5)=0:"CLOSEST",$P(PSJSYSW0,"^",5)=1:"NEXT",1:"NOW")
        I OI]"" S PSGST=$S($P($G(^PS(50.7,OI,0)),"^",7)]"":$P($G(^PS(50.7,OI,0)),"^",7),1:"C")
        N %,PSGXSCH D NOW^%DTC S PSGDT=%,DFN=PSGP,(PSGSCH,PSGXSCH)=SCH
        S X=PSGSCH,PSGS0Y="" D ADMIN
        I $G(PSGORD)]"" D
        .S PSGNESD=$$DSTART^PSJDCU(PSGP,PSGORD) I PSGNESD]"" S $P(RESULT,"^",2)=PSGNESD Q
        .S ND=$S(PSGORD["U":$G(^PS(55,PSGP,5,+PSGORD,2)),1:$G(^PS(55,PSGP,"IV",+PSGORD,0)))
        .N PSJADM,PSJSTRT S PSJADM=$S(PSGORD["U":$P(ND,"^",5),1:$P(ND,"^",11)),PSJSTRT=$P(ND,"^",2),PSJREN=1
        S SCH=PSGXSCH
        N PSJTMPW0 S PSJTMPW0=PSJSYSW0 S $P(PSJSYSW0,"^",5)=1
        I $G(PSGNESD)="" S RESULT=RESULT_"^"_$$ENSD^PSGNE3(PSGSCH,$S($G(PSJADM)]"":$G(PSJADM),1:PSGS0Y),PSGDT,$S($G(PSJSTRT)]"":$G(PSJSTRT),1:PSGDT))
        S PSJSYSW0=PSJTMPW0
        S PSGNESD=$P(RESULT,"^",2)
        S PSGNEDFD=$$GTNEDFD^PSGOE7("U",OI)
        K PSGODF,PSGOES,PSJREN
        S SCH=PSGXSCH
        D ENFD^PSGNE3(PSGDT) S RESULT=RESULT_"^"_$G(PSGNEFD) ;_"^"_$G(PSGNEFDO)
        N DATE S DATE=$$FMDIFF^XLFDT($P(RESULT,"^",3),$P(RESULT,"^",2),3)
        S $P(RESULT,"^",3)=$S($G(PSGST)="O":0,+DATE>0:+DATE_"D",$P($P(DATE," ",2),":")>0:$P($P(DATE," ",2),":")_"H",1:0)
        N STRING S STRING=PSGNESD_U_PSGNEFD_U_$G(PSGSCH)_U_$G(PSGST)_U_$G(OI) I ($P($G(ZZND),U,2)]"")&($P($G(ZZND),"^")=$G(PSGSCH)) S STRING=STRING_U_$P(ZZND,U,2)
        I $G(PSGSCH)]"" I $$DOW^PSIVUTL(PSGSCH) S:$G(PSGS0Y) $P(STRING,"^",6)=PSGS0Y
        I $G(PSJADM) S $P(STRING,"^",6)=PSJADM
        S RESULT=RESULT_"^"_$$ENQ^PSJORP2(PSGP,STRING) I ($G(PSGSCH)]"") I $$DOW^PSIVUTL(PSGSCH),(PSGSCH'["@"),'$G(PSGS0Y) S $P(RESULT,"^",4)=$P(RESULT,"^",2)
        I ($G(PSGSCH)]"") I $$PRNOK^PSGS0(PSGSCH) S $P(RESULT,"^",4)=$P(RESULT,"^",2)
        D KVAR^VADPT K LYN,ND,PSGDT,PSGNEDFD,PSGNEFD,PSGNEFDO,PSGNESD,PSGS0Y,PSGSCH,PSGST,PSJSYSW,PSJSYSW0,ZZ
        ;RESULT=WARD PARAMETER^DEFAULT START DATE/TIME^#_D(NUMBER OF DAYS ORDER LASTS) OR #_H(NUMBER OF HOURS ORDER LASTS)^EXPECTED FIRST DOSE
        Q RESULT
        ;
RESOLVE(PSGP,SCH,OI,PCH,PSJPWD,PSJADM)  ;
        ; PSGP=Patient IEN
        ; SCH=Schedule
        ; OI=Orderable Item
        ; PCH=Providers Choice
        ; PSJPWD=Ward Location (Optional)
        ; PSJADM=Admin Times (Optional)
        ;
        N PSJSYSW0,PSJSYSW,PSGSCH,PSGOES,PSGS0Y,DFN,RESULT1
        I $G(PSJPWD)']"" S DFN=PSGP D IN5^VADPT S:VAIP(5)]"" PSJPWD=+VAIP(5)
        S PSJSYSW0="",PSJSYSW=0 I $G(PSJPWD)]"" S PSJSYSW=+$O(^PS(59.6,"B",PSJPWD,0)) I PSJSYSW S PSJSYSW0=$G(^PS(59.6,PSJSYSW,0))
        S $P(PSJSYSW0,"^",5)=$S($$ONE(SCH):2,PCH="NEXT":1,1:0)
        S RESULT1=$S($P(PSJSYSW0,"^",5)=0:"CLOSEST",$P(PSJSYSW0,"^",5)=1:"NEXT",1:"NOW")
        I OI]"" S PSGST=$S($P($G(^PS(50.7,OI,0)),"^",7)]"":$P($G(^PS(50.7,OI,0)),"^",7),1:"C")
        N % D NOW^%DTC S PSGDT=%,DFN=PSGP,PSGSCH=SCH
        S X=PSGSCH,PSGS0Y="" I $D(^PS(51.1,"AC","PSJ",X)) D ADMIN
        S:$G(PSJADM) PSGS0Y=PSJADM
        S RESULT1=RESULT1_"^"_$$ENSD^PSGNE3(SCH,PSGS0Y,PSGDT,PSGDT)
        I $G(PSGSCH)]"" I $$DOW^PSIVUTL(PSGSCH),(PSGSCH'["@"),'$G(PSGS0Y) S $P(RESULT,"^",4)=$P(RESULT,"^",2)
        I $G(PSGSCH)]"" I $$PRNOK^PSGS0(PSGSCH) S $P(RESULT1,"^",4)=$P(RESULT,"^",2)
        D KVAR^VADPT K LYN,PSGDT,PSGNEDFD,PSGNEFD,PSGNEFDO,PSGNESD,PSGS0Y,PSGSCH,PSGST,PSJSYSW,PSJSYSW0,ZZ,PSGS0XT,PSGS0Y
        Q RESULT1
        ;
SCHREQ(MR,OI,DD)         ;
        ; MR=Medication Route from 51.2 (Required)
        ; OI=Orderable Item from 50.7 (Optional)
        ; DD=Dispense Drug from 50 (Optional)
        N ADDITIVE,SOLUTION,REQ S REQ=0,(SOLUTION,ADDITIVE)=""
        I '+$G(MR) S REQ=1 Q REQ
        I '+$G(OI),'+$G(DD) S REQ=1 Q REQ
        I +$G(DD) S:$P($G(^PSDRUG(+DD,2)),U,3)["U" REQ=1 Q REQ
        I '$D(PS(51.2,+MR,0)) S REQ=1 Q REQ
        I $P($G(^PS(51.2,+MR,0)),"^",6)=1 D
        .I +$G(OI) D
        ..I '$D(^PS(50.7,+OI,0)) S REQ=1 Q
        ..F  S SOLUTION=$O(^PS(52.7,"AOI",+OI,SOLUTION)) Q:'SOLUTION  Q:REQ=1  S:$P(^PSDRUG(+$P(^PS(52.7,SOLUTION,0),U,2),2),U,3)["U" REQ=1
        ..F  S ADDITIVE=$O(^PS(52.6,"AOI",+OI,ADDITIVE)) Q:'ADDITIVE  Q:REQ=1  S:$P(^PSDRUG(+$P(^PS(52.6,ADDITIVE,0),U,2),2),U,3)["U" REQ=1
        Q REQ
        ;
ADMIN   ; Get admin times associated with schedule
        S PSGS0Y="",ZZ=0
        I $$DOW^PSIVUTL($P(X,"@")),'$D(^PS(51.1,"AC","PSJ",X)) S PSGST="D" D  Q:$G(PSGS0Y)
        .I $P(X,"@",2) N PSJADBAD D  Q
        ..S PSGS0Y=$S($G(PSJADBAD):"",1:$P(X,"@",2))
        ..N ADMIN,TIME,II S ADMIN=$P(X,"@",2) F II=1:1:$L(ADMIN,"-") S TIME=$P(ADMIN,"-",II) I TIME'?2N&(TIME'?4N) S PSJADBAD=1
        .I $P(X,"@",2)]"",$D(^PS(51.1,"APPSJ",$P(X,"@",2))) S X=$P(X,"@",2)
        D FIND^DIC(51.1,,,,X,,"APPSJ",,,"LYN")
        S ZZ=$O(LYN("DILIST",2,ZZ)) I ZZ S ZZ=+LYN("DILIST",2,ZZ) I ZZ S ZZND=$G(^PS(51.1,ZZ,0)) S PSGST=$P(ZZND,U,5),PSGS0XT=$P(ZZND,U,3) S:$G(PSGSFLG) PSGSCIEN=$G(LYN("DILIST",2,ZZ)) I $G(PSJPWD) D
        . N ZZNDW S ZZNDW=$G(^PS(51.1,ZZ,1,PSJPWD,0)) I $P(ZZNDW,"^",2)]"" S PSGS0Y=$P(ZZNDW,"^",2),$P(ZZND,"^",2)=PSGS0Y I $G(PSGSFLG) S PSGSCIEN=$G(LYN("DILIST",2,ZZ))
        S ZZ=0 F  S ZZ=$O(LYN("DILIST",1,ZZ)) Q:'ZZ  I $G(LYN("DILIST",1,ZZ))'=X K LYN("DILIST",1,ZZ),LYN("DILIST",2,ZZ),LYN("DILIST","ID",ZZ,1)
        I $D(PSJPWD) S ZZ=0 F  S ZZ=$O(LYN("DILIST",2,ZZ)) Q:'ZZ!$G(PSGS0Y)  I $P($G(^PS(51.1,+LYN("DILIST",2,ZZ),1,+PSJPWD,0)),U,2)]"" S PSGS0Y=$P($G(^(0)),U,2) I $G(PSGSFLG) S PSGSCIEN=$G(LYN("DILIST",2,ZZ))
        Q:PSGS0Y]""  S ZZ=0 F  S ZZ=$O(LYN("DILIST",2,ZZ)) Q:'ZZ!$G(PSGS0Y)  I $G(LYN("DILIST","ID",ZZ,1))]"" S PSGS0Y=$G(LYN("DILIST","ID",ZZ,1))
        Q
        ;
ONE(SCH)        ;
        ; SCH=Admin Schedule
        ; Returns 0 = (zero) Not a one time schedule.
        ;         1 =  One time schedule.
        Q:$G(SCH)="" 0
        N X,SCHLST
        S SCHLST=",TODAY,ONCE,NOW,ONE TIME,ONETIME,ONE-TIME,1TIME,1 TIME,1-TIME,STAT,"
        I SCHLST[(","_SCH_",") Q 1
        I $D(^PS(51.1,"AC","PSJ",SCH)) S X=$O(^(SCH,"")) S X=$P(^PS(51.1,X,0),"^",5) Q $S(X="O":1,1:0)
        Q 0
