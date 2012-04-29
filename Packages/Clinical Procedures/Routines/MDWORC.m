MDWORC  ; HOIFO/NCA - Main Routine to Decode HL7 from Consult ;1/8/08  15:00
        ;;1.0;CLINICAL PROCEDURES;**14**;Apr 01,2004;Build 20
        ; Reference IA #10035 [Supported] Access Patient file DPT
        ;               10040 [Supported] Hospital Location File SC
        ;               10103 [Supported] XLFDT calls
EN(MDMSG)       ; Entry Point for Consult and pass MSG in MDMSG
        N DFN,MDCON,MDCPROC,MDCANC,MDCANR,MDFN,MDIFN,MDINST,MDFLG,MDL,MDLOC,MDNAM,MDPROC,MDPAT,MDPROV,MDREQ,MDX
        S (MDFLG,MDCANC)=0 F MDL=0:0 S MDL=$O(MDMSG(MDL)) Q:MDL<1!(MDFLG)  S MDX=$G(MDMSG(MDL)) D
        .I $E(MDX,1,3)="MSH" D MSH Q
        .I $E(MDX,1,3)="PID" D PID Q
        .I $E(MDX,1,3)="PV1" D PV1 Q
        .I $E(MDX,1,3)="ORC" D ORC Q
        .I $E(MDX,1,3)="NTE" Q
        .Q
        Q
MSH     ; Decode MSH
        I $P(MDX,"|",2)'="^~\&" S MDFLG=1 Q
        I $P(MDX,"|",3)'="CONSULTS" S MDFLG=1 Q
        I $P(MDX,"|",9)'="ORM" S MDFLG=1 Q
        Q
PID     ; Check PID
        S MDNAM=$P(MDX,"|",6),DFN=$P(MDX,"|",4)
        I '$D(^DPT("B",$E(MDNAM,1,30),DFN)) S MDFLG=1
        S MDFN=DFN
        Q
PV1     ; Check PV1
        S MDPAT=$P(MDX,"|",3) I MDPAT'?1U!("IO"'[MDPAT) S MDFLG=1 Q
        S MDLOC=+$P(MDX,"|",4) I $G(^SC(MDLOC,0))="" S MDFLG=1 Q
        Q
ORC     ; Check ORC
        I $P(MDX,"|",2)'="OD",($P(MDX,"|",2)'="OC"),($P(MDX,"|",2)'="XX") Q
        I $P(MDX,"|",2)="XX" D RESUBM
        D CANCEL
        Q
CANCEL  ; Cancel/Discontinue
        K MDR S MDIFN=+$P(MDX,"|",3),MDCON=+$P(MDX,"|",4)
        I 'MDIFN S MDFLG=1 Q
        I 'MDCON S MDFLG=1 Q
        I $P(MDX,"|",6)'="CA",($P(MDX,"|",6)'="DC") Q
        S MDPROV=+$P(MDX,"|",13) I 'MDPROV S MDFLG=1 Q
        S MDREQ=$P(MDX,"|",16) I 'MDREQ S MDFLG=1 Q
        S MDINST=$O(^MDD(702,"ACON",MDCON,0)) Q:'MDINST
        Q:$G(^MDD(702,+MDINST,0))=""
        I "5"[$P(^MDD(702,+MDINST,0),U,9) S MDCANR=$$CANCEL^MDHL7B(+MDINST)
        N MDFDA S MDFDA(702,+MDINST_",",.09)=6,MDCANC=1
        D FILE^DIE("K","MDFDA") K MDFDA
        N MDHEMO S MDHEMO=+$$GET1^DIQ(702,+MDINST,".04:.06","I")
        Q:MDHEMO<2
        Q:$G(^MDK(704.202,+MDINST,0))=""
        S MDFDA(704.202,+MDINST_",",.09)=0
        D FILE^DIE("","MDFDA")
        K ^MDK(704.202,"AS",1,+MDINST)
        S ^MDK(704.202,"AS",0,+MDINST)=""
        Q
RESUBM  ; Resubmit a cancelled order
        N MDERR,MDHL7,MDHOLD,MDMAXD,MDNOW,MDSCHD,MDVSTD,MDXY
        Q:$P(MDX,"|",2)'="XX"
        K MDR S MDIFN=+$P(MDX,"|",3),MDCON=+$P(MDX,"|",4)
        I 'MDIFN S MDFLG=1 Q
        I 'MDCON S MDFLG=1 Q
        S MDPROV=+$P(MDX,"|",11) I 'MDPROV S MDFLG=1 Q
        S MDREQ=$P(MDX,"|",16) S:MDREQ MDREQ=$$FMDTE^MDWOR(MDREQ) I 'MDREQ S MDFLG=1 Q
        S MDINST=$O(^MDD(702,"ACON",MDCON,0)) Q:'MDINST
        S MDVSTD=$P($G(^MDD(702,MDINST,0)),"^",7)
        S MDSCHD=$S($L(MDVSTD,";")=1:MDVSTD,1:$P(MDVSTD,";",2)),MDMAXD=DT+.24
        Q:$$GET1^DIQ(702,MDINST_",",.09,"I")'=6
        N MDFDA,MDIENS,MDERR
        S MDFDA(702,MDINST_",",.07)=MDVSTD
        S MDFDA(702,MDINST_",",.09)=$S(MDSCHD>MDMAXD:0,1:5)
        D FILE^DIE("K","MDFDA") S MDHOLD="" K MDFDA
        Q:MDSCHD>MDMAXD
        S MDXY=$P(^MDD(702,MDINST,0),"^",4)
        I $P($G(^MDS(702.01,+MDXY,0)),"^",6)=2 S MDHOLD=$P(^MDD(702,MDINST,0),"^",7),MDNOW=$$NOW^XLFDT(),$P(^MDD(702,MDINST,0),"^",7)=$S(MDNOW>MDSCHD:MDSCHD,1:MDNOW)
        S MDIENS=MDINST_",",MDHL7=$$SUB^MDHL7B(+MDIENS)
        I +MDHL7=-1 S MDFDA(702,MDIENS,.09)=2,MDFDA(702,MDIENS,.08)=$P(MDHL7,U,2)
        I +MDHL7=1 S MDFDA(702,MDIENS,.09)=5,MDFDA(702,MDIENS,.08)=""
        D:$D(MDFDA) FILE^DIE("","MDFDA","MDERR") K MDFDA,MDERR
        N MDHEMO S MDHEMO=+$$GET1^DIQ(702,+MDIENS,".04:.06","I")
        Q:MDHEMO<2
        S:$G(MDHOLD)'="" $P(^MDD(702,MDINST,0),"^",7)=MDHOLD
        Q:$G(^MDK(704.202,+MDINST,0))=""
        S MDFDA(704.202,+MDINST_",",.09)=1
        D:$D(MDFDA) FILE^DIE("","MDFDA","MDERR") K MDFDA,MDERR
        K ^MDK(704.202,"AS",0,+MDINST)
        S ^MDK(704.202,"AS",1,+MDINST)=""
        Q
