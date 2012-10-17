MDWOR   ; HOIFO/NCA - Main Routine to Decode HL7 ;9/8/08  15:20
        ;;1.0;CLINICAL PROCEDURES;**14,11,21,20**;Apr 01,2004;Build 9
        ; Reference IA# 2263 [Supported] XPAR calls
        ;               3468 [Subscription] Call GMRCCP.
        ;               3071 [Subscription] Call $$PKGID^ORX8.
        ;              10035 [Supported] Access DPT("B"
        ;              10040 [Supported] Access SC(
        ;              10061 [Supported] VADPT call
        ;              10103 [Supported] XLFDT calls
EN(MDMSG)       ; Entry Point for CPRS and pass MSG in MDMSG
        N DFN,MDCON,MDCPROC,MDCANC,MDCANR,MDFN,MDIFN,MDINST,MDFLG,MDINT,MDL,MDIN,MDINP,MDINST,MDLOC,MDNAM,MDOBC,MDOBX,MDOPRO,MDPROC,MDPAT
        N MDLL,MDK1,MDPROV,MDREQ,MDQTIM,MDROOT,MDRR,MDSINP,MDVSTD,MDX S MDVSTD=""
        S (MDFLG,MDINP,MDINST,MDCANC,MDOBC)=0 F MDL=0:0 S MDL=$O(MDMSG(MDL)) Q:MDL<1!(+MDFLG>0)  S MDX=$G(MDMSG(MDL)) D
        .I $E(MDX,1,3)="MSH" D MSH Q
        .I $E(MDX,1,3)="PID" D PID Q
        .I $E(MDX,1,3)="PV1" D PV1 Q
        .I $E(MDX,1,3)="ORC" D ORC Q
        .I $E(MDX,1,3)="OBR" D OBR Q
        .I $E(MDX,1,3)="OBX" D:MDOBC<1 OBX Q
        .Q
        D GETLST^XPAR(.MDLL,"SYS","MD CLINIC ASSOCIATION")
        I +MDFLG<1&(+MDCANC<1)&(MDVSTD="") F MDK1=0:0 S MDK1=$O(MDLL(MDK1)) Q:MDK1<1  S MDROOT=$G(MDLL(MDK1)) I +$P(MDROOT,";",2)=MDPROC D  Q:+MDRR
        .S MDRR=0,MDIFN=MDFN,MDRR=$$GETAPPT(MDIFN,+$P(MDROOT,"^",2))
        .S:+MDRR MDVSTD="A"_";"_$P(MDRR,"^",1)_";"_+$P(MDROOT,"^",2)
        I +MDFLG<1&(MDVSTD'="") F MDK1=0:0 S MDK1=$O(MDLL(MDK1)) Q:MDK1<1  S MDROOT=$P($G(MDLL(MDK1)),"^",2) I +$P(MDROOT,";",2)=MDPROC D
        .I +$P(MDVSTD,";",3)>0&(+MDROOT=$P(MDVSTD,";",3)) S MDFLG=0 Q
        .I +$P(MDVSTD,";",3)>0&(+MDROOT'=$P(MDVSTD,";",3)) S MDFLG=1 Q
        I +MDFLG<1&(+MDCANC<1) S MDATA="+1,^"_MDPROC_"^"_+MDCON_"^"_MDINST_"^"_MDVSTD D CHKIN(MDFN,MDREQ,MDPROV,MDATA,MDVSTD)
        Q
MSH     ; Decode MSH
        I $P(MDX,"|",2)'="^~\&" S MDFLG=1 Q
        I $P(MDX,"|",3)'="ORDER ENTRY" S MDFLG=1 Q
        I $P(MDX,"|",9)'="ORM" S MDFLG=1 Q
        Q
PID     ; Check PID
        S MDNAM=$P(MDX,"|",6),DFN=$P(MDX,"|",4)
        I '$D(^DPT("B",$E(MDNAM,1,30),DFN)) S MDFLG=1
        S MDFN=DFN
        Q
PV1     ; Check PV1
        S MDPAT=$P(MDX,"|",3) I MDPAT'?1U!("IO"'[MDPAT) S MDFLG=1 Q
        I MDPAT="I" S MDINP=1
        S MDLOC=+$P(MDX,"|",4) I $G(^SC(MDLOC,0))="" S MDFLG=1 Q
        S:MDINP>0 MDLOC=""
        Q
ORC     ; Check ORC
        I $P(MDX,"|",2)="NW" D NEW Q
        I $P(MDX,"|",2)="DC" D CANCEL Q
        S MDFLG=1
        Q
OBX     ; Check OBX
        N %,ANSWER,MDCV,MDOBX
        S MDOBX=$P(MDX,"|",6)
        I '+$$GET^XPAR("SYS","MD USE APPT WITH PROCEDURE",1) S MDOBC=MDOBC+1 Q
        S MDVSTD=$P(MDOBX,"Visit Date: ",2)
        S MDCV=$P(MDVSTD," ",1,2)
        I MDCV=""!(MDCV["UNKNOWN") S MDFLG=1 Q
        S MDVSTD=$P(MDCV," ")_"@"_$P(MDCV," ",2)
        D DT^DILF("T",MDVSTD,.ANSWER)
        S:ANSWER<0 ANSWER=""
        S MDVSTD=ANSWER I MDVSTD="" S MDFLG=1 Q
        I +MDLOC>0 S MDVSTD="A;"_MDVSTD_";"_MDLOC
        E  D NOW^%DTC S MDVSTD=%
        S MDOBC=MDOBC+1
        Q
NEW     ; New Order Segment
        S MDIFN=+$P(MDX,"|",3) I 'MDIFN S MDFLG=1 Q
        S MDPROV=+$P(MDX,"|",11) I 'MDPROV S MDFLG=1 Q
        S MDQTIM=$P(MDX,"|",8),MDQTIM=$P(MDQTIM,"^",6)
        S MDREQ=$P(MDX,"|",16) S MDREQ=$$FMDTE(MDREQ) I 'MDREQ S MDFLG=1 Q
        S MDREQ=$S(MDQTIM="Z24":$$FMADD^XLFDT(MDREQ,0,24),MDQTIM="Z48":$$FMADD^XLFDT(MDREQ,0,48),MDQTIM="Z72":$$FMADD^XLFDT(MDREQ,0,72),MDQTIM="ZW":$$FMADD^XLFDT(MDREQ,7),MDQTIM="ZM":$$FMADD^XLFDT(MDREQ,30),1:MDREQ)
        ; Retrieve Consult Number
        N MDFDA
        S MDCON=$$PKGID^ORX8(MDIFN) I 'MDCON S MDFLG=1 Q
        Q
OBR     ; Check OBR
        S MDPROC=$P(MDX,"|",5)
        I $E($P(MDPROC,"^",6),3,5)'["PRC" S MDFLG=1 Q
        S MDCPROC=$P(MDPROC,"^",4) I 'MDCPROC S MDFLG=1 Q
        ; Get Procedure for CP IEN
        S MDPROC=$$CPROC^GMRCCP(MDCPROC) I 'MDPROC S MDFLG=1 Q
        S MDSINP=$$HIGHV(MDPROC) I +MDSINP'>1 S MDFLG=1 Q
        S (MDINST,MDINT)=0 F MDIN=0:0 S MDIN=$O(^MDS(702.01,MDPROC,.1,MDIN)) Q:MDIN<1!(+MDINST)  S MDINT=+$G(^(MDIN,0)) D
        .I +$$GET1^DIQ(702.09,+MDINT,".13","I") S MDINST=MDINT Q
        I +$P(MDSINP,"^",2)=2 D  Q
        .I +MDINP S MDVSTD="",MDOBC=MDOBC+1 Q
        .S MDVSTD=MDREQ,MDOBC=MDOBC+1 Q
        I +$P(MDSINP,"^",2)=3 D  Q
        .I +MDINP S MDVSTD="",MDOBC=MDOBC+1 Q
        I +$P(MDSINP,"^",2)=1 D  Q
        .I '+MDINP S MDVSTD="" Q
        .S MDVSTD=MDREQ,MDOBC=MDOBC+1 Q
        ;I +MDINP&('$P(^MDS(702.01,MDPROC,0),"^",5)) S MDFLG=1 Q
        I +MDINP S MDVSTD=MDREQ,MDOBC=MDOBC+1 Q
        S MDVSTD=MDREQ,MDOBC=MDOBC+1 Q
        Q
CANCEL  ; Cancel/Discontinue
        K MDR S MDIFN=+$P(MDX,"|",3),MDCON=+$P(MDX,"|",4),MDCANC=1
        I 'MDIFN S MDFLG=1 Q
        I 'MDCON S MDFLG=1 Q
        S MDPROV=+$P(MDX,"|",13) I 'MDPROV S MDFLG=1 Q
        S MDREQ=$P(MDX,"|",16) I 'MDREQ S MDFLG=1 Q
        S MDINST=$O(^MDD(702,"ACON",MDCON,0)) Q:'MDINST
        Q:$G(^MDD(702,+MDINST,0))=""
        I "5"[$P(^MDD(702,+MDINST,0),U,9) S MDCANR=$$CANCEL^MDHL7B(+MDINST)
        N MDFDA S MDFDA(702,MDINST_",",.09)=6
        D FILE^DIE("K","MDFDA") K MDFDA
        N MDHEMO S MDHEMO=+$$GET1^DIQ(702,+MDINST,".04:.06","I")
        Q:MDHEMO<2
        Q:$G(^MDK(704.202,+MDINST,0))=""
        S MDFDA(704.202,+MDINST_",",.09)=0
        D FILE^DIE("","MDFDA")
        K ^MDK(704.202,"AS",1,+MDINST)
        S ^MDK(704.202,"AS",0,+MDINST)=""
        Q
CHKIN(MDFN,MDREQ,MDPROV,MDATA,MDVSTD)   ; [Procedure] Check In Study
        N MDX1,MDFDA,MDIEN,MDIENS,MDERR,MDHL7,MDHOLD,MDSCHD,MDMAXD,MDXY,MDNOW
        F MDX1=2:1:5 D
        .I $P(MDATA,U,MDX1)]"" S MDFDA(702,$P(MDATA,U,1),$P("^.04^.05^.11^.07",U,MDX1))=$P(MDATA,U,MDX1)
        ; Remove code after instrument testing available
        ; End of code removal after instrument available for testin
        S MDSCHD=$S($L(MDVSTD,";")=1:MDVSTD,1:$P(MDVSTD,";",2)),MDMAXD=DT+.24
        S MDFDA(702,$P(MDATA,U,1),.09)=$S(MDSCHD="":0,MDSCHD>MDMAXD:0,1:5)  ; Status = Checked-In
        I $P(MDATA,U,1)="+1," D
        .S MDFDA(702,"+1,",.01)=MDFN
        .S MDFDA(702,"+1,",.02)=$$NOW^XLFDT()
        .S MDFDA(702,"+1,",.03)=MDPROV
        .S:+MDSCHD MDFDA(702,"+1,",.14)=MDSCHD
        .D UPDATE^DIE("","MDFDA","MDIEN","MDERR") Q:$D(MDERR)
        .Q:MDSCHD>MDMAXD!(MDSCHD="")
        .S MDIENS=MDIEN(1)_",",MDXY=+$P(MDATA,U,2),MDHOLD="" I +MDXY D
        ..Q:$P(^MDS(702.01,MDXY,0),U,6)'=2
        ..S MDHOLD=$P($G(^MDD(702,MDIEN(1),0)),"^",7),MDNOW=$$NOW^XLFDT()
        ..S $P(^MDD(702,MDIEN(1),0),"^",7)=MDSCHD
        .S MDHL7=$$SUB^MDHL7B(MDIEN(1))
        .I +MDHL7=-1 S MDFDA(702,MDIENS,.09)=2,MDFDA(702,MDIENS,.08)=$P(MDHL7,U,2)
        .I +MDHL7=1 S MDFDA(702,MDIENS,.09)=5,MDFDA(702,MDIENS,.08)=""
        .D:$D(MDFDA) FILE^DIE("","MDFDA","MDERR")
        Q:MDSCHD>MDMAXD!(MDSCHD="")
        D:+$G(MDIENS)
        .S MDXY=+$P(MDATA,U,2) Q:'MDXY
        .I $P(^MDS(702.01,MDXY,0),U,6)=2 D  Q  ; Renal Check-In
        ..D CP^MDKUTL(+MDIENS)
        ..S:$G(MDHOLD)'="" MDFDA(702,+MDIENS_",",.07)=MDHOLD
        ..S MDFDA(702,+MDIENS_",",.09)=5
        ..D FILE^DIE("","MDFDA","MDERR")
        Q
FMDTE(DATE)     ; Convert HL-7 formatted date to a Fileman formatted date
        N X
        S X="" I DATE D
        .S X=$$HL7TFM^XLFDT(DATE,"L")
        Q X
HIGHV(MDHV)     ; Return flag indicator whether procedure is use for auto check-in
        N MDANS,MDK,MDKY,MDLST S MDANS=0
        D GETLST^XPAR(.MDLST,"SYS","MD CHECK-IN PROCEDURE LIST")
        F MDK=0:0 S MDK=$O(MDLST(MDK)) Q:MDK<1  S MDKY=$G(MDLST(MDK)) D
        .I MDHV=+$P(MDKY,"^") S MDANS=MDKY
        Q MDANS
GETAPPT(MDDPAT,MDDA)    ; Get appointment
        N DFN,MDALP,MDARES K ^UTILITY("VASD",$J) S DFN=MDDPAT
        S X1=DT,X2=365 D C^%DTC S VASD("T")=X+.24,VASD("F")=DT,VASD("W")="129",VASD("C",+MDDA)=+MDDA D SDA^VADPT
        S MDARES=0 F MDALP=0:0 S MDALP=$O(^UTILITY("VASD",$J,MDALP)) Q:MDALP<1  S MDARES=$G(^(MDALP,"I")) Q
        K ^UTILITY("VASD",$J),VASD,X1,X2,X
        Q MDARES
