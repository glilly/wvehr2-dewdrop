MDWORSR ; HOIFO/NCA - Daily Schedule Studies;7/2/04  12:39 ;5/17/07  16:09
        ;;1.0;CLINICAL PROCEDURES;**14**;Apr 01,2004;Build 20
        ; Reference IA# 2263 [Supported] XPAR calls
        ;               3067 [Private] Read fields in Consult file (#123) w/FM
        ;               3468 [Subscription] Call GMRCCP
        ;               3869 [Subscription] SDAMA202 calls
        ;               10035 [Supported] Patient File Access
        ;               10103 [Supported] XLFDT calls
        ;
EN1     ; Entry Point to process scheduled studies
        N MDCON,MDERR,MDFDA,MDHOLD,MDL,MDL1,MDMAXD,MDNOW,MDSTAT,MDX,MDXY
        S MDMAXD=DT+.24
        S MDL=DT F  S MDL=$O(^MDD(702,"ASD",MDL)) Q:MDL<1!(MDL>MDMAXD)  F MDL1=0:0 S MDL1=$O(^MDD(702,"ASD",MDL,MDL1)) Q:MDL1<1  S MDX=$G(^MDD(702,MDL1,0)) D
        .K MDFDA
        .S MDCON=+$P(MDX,"^",5) Q:'MDCON
        .S MDSTAT=$$GET1^DIQ(123,MDCON_",",8,"E")
        .Q:MDSTAT="DISCONTINUED"!(MDSTAT="CANCELLED")
        .Q:+$P(MDX,"^",9)>0
        .S MDIENS=MDL1_",",MDXY=+$P(MDX,"^",4),MDHOLD="" I MDXY D
        ..Q:$P(^MDS(702.01,MDXY,0),U,6)'=2
        ..S MDHOLD=$P($G(^MDD(702,+MDL1,0)),"^",7),MDNOW=$$NOW^XLFDT()
        ..S $P(^MDD(702,+MDL1,0),"^",7)=$S(MDNOW>MDL:MDL,1:MDNOW)
        .S MDHL7=$$SUB^MDHL7B(MDL1)
        .I +MDHL7=-1 S MDFDA(702,MDIENS,.09)=2,MDFDA(702,MDIENS,.08)=$P(MDHL7,U,2)
        .I +MDHL7=1 S MDFDA(702,MDIENS,.02)=$$NOW^XLFDT(),MDFDA(702,MDIENS,.09)=5,MDFDA(702,MDIENS,.08)=""
        .D:$D(MDFDA) FILE^DIE("","MDFDA","MDERR")
        .S MDXY=+$P(MDX,"^",4) Q:'MDXY
        .I $P(^MDS(702.01,MDXY,0),U,6)=2 D  Q  ; Renal Check-In
        ..D CP^MDKUTL(+MDIENS)
        ..S:$G(MDHOLD)'="" MDFDA(702,MDIENS,.07)=MDHOLD
        ..S MDFDA(702,MDIENS,.09)=5
        ..D FILE^DIE("","MDFDA","MDERR")
        Q
CLINICPT        ; Check-in CP study with multiple results
        N MD,MDCDT,MDCL,MDCOM,MDCON,MDDT,MDDX,MDEND,MDERR,MDFDA,MDHEMO,MDHL7,MDIEN,MDIENS,MDK,MDLP,MDLST,MDMULT,MDNODE,MDNUM,MDPT,MDRET,MDSCHD,MDVSTR,MDY,MDY1,MDYR,X,X1,X2
        N MDHOLD,MDLST1,MDLST2,MDNEW S MDDT=DT\1,MDEND=DT+.24 N MDINP K ^TMP($J,"SDAMA202","GETPLIST"),^TMP("MDSTATUS",$J) S MDCOM=0,MDHOLD=""
        S MDNUM=$$GET^XPAR("SYS","MD COMPL PROC DISPLAY DAYS",1)
        I +MDNUM>0 S X1=DT,X2=-MDNUM D C^%DTC S MDCOM=X
        D GETLST^XPAR(.MDLST,"SYS","MD CLINIC QUICK LIST")
        D GETLST^XPAR(.MDLST1,"SYS","MD CLINICS WITH MULT PROC")
        F MDLP=0:0 S MDLP=$O(^MDD(702,"AS",0,MDLP)) Q:MDLP<1  D
        .S MDY=$G(^MDD(702,MDLP,0)) Q:+$P(MDY,"^",9)>0
        .Q:$P(MDY,"^",7)'=""
        .Q:'+$P(MDY,"^",5)!($P(MDY,"^",6)'="")
        .Q:'+MDY
        .I '+$G(^TMP("MDSTATUS",$J,+MDY,+$P(MDY,"^",4))) S ^TMP("MDSTATUS",$J,+MDY,+$P(MDY,"^",4))=+MDLP
        .Q
        ; Combine clinics with multiple procedures to regular clinics
        S MDLST2=$S(+MDLST>0:MDLST,1:0)
        I MDLST1>0 K MDY F MDK=0:0 S MDK=$O(MDLST1(MDK)) Q:MDK<1  I $G(MDLST1(MDK))'="" S MDY=$P($G(MDLST1(MDK)),"^",2)_"^"_+$G(MDLST1(MDK)),MDLST2=MDLST2+1,MDLST(MDLST2)=MDY
        ; Match new studies with 0 status to appointments
        N MDXX K MDY F MDK=0:0 S MDK=$O(MDLST(MDK)) Q:MDK<1  S MDY=$G(MDLST(MDK)) I +$P(MDY,"^",2)>0 S MDCL=+MDY D
        .K ^TMP($J,"SDAMA202","GETPLIST")
        .D GETPLIST^SDAMA202(+MDY,"1;4;","R",MDDT,MDEND,.MDRET,"")
        .F MD=0:0 S MD=$O(^TMP($J,"SDAMA202","GETPLIST",MD)) Q:'MD  D
        ..S MDY1=+$G(^TMP($J,"SDAMA202","GETPLIST",MD,4)) Q:MDY1<1
        ..S MDSCHD=+$G(^TMP($J,"SDAMA202","GETPLIST",MD,1))
        ..S MDDX=+$G(^TMP("MDSTATUS",$J,MDY1,+$P(MDY,"^",2))) Q:'MDDX
        ..S MDMULT=+$$GET1^DIQ(702,+MDDX,".04:.12","I")
        ..S MDHEMO=+$$GET1^DIQ(702,+MDDX,".04:.06","I"),MDIENS=+MDDX_","
        ..S MDFDA(702,MDIENS,.02)=$$NOW^XLFDT()
        ..S MDFDA(702,MDIENS,.07)="A;"_MDSCHD_";"_MDCL
        ..S MDFDA(702,MDIENS,.14)=MDSCHD
        ..D:$D(MDFDA) FILE^DIE("","MDFDA","MDERR") K MDFDA
        ..I MDHEMO=2 S MDHOLD=$P($G(^MDD(702,+MDIENS,0)),"^",7),MDNEW=$$NOW^XLFDT(),$P(^MDD(702,+MDIENS,0),"^",7)=$S(MDNEW>MDSCHD:MDSCHD,1:MDNEW)
        ..S MDHL7=$$SUB^MDHL7B(+MDIENS)
        ..I +MDHL7=-1 S MDFDA(702,MDIENS,.09)=2,MDFDA(702,MDIENS,.08)=$P(MDHL7,U,2)
        ..I +MDHL7=1 S MDFDA(702,MDIENS,.09)=5,MDFDA(702,MDIENS,.08)=""
        ..D:$D(MDFDA) FILE^DIE("","MDFDA","MDERR")
        ..Q:'+$G(MDIENS)
        ..I MDHEMO=2 D CP^MDKUTL(+MDIENS) S:$G(MDHOLD)'="" MDFDA(702,+MDIENS_",",.07)=MDHOLD S MDFDA(702,+MDIENS_",",.09)=5 D FILE^DIE("","MDFDA","MDERR") K MDFDA
        ..Q
        .Q
        ; Match the rest of appointments with previous studies
        N MDGET,MDINST S X1=DT,X2=-365 D C^%DTC S MDCDT=X
        F MDK=0:0 S MDK=$O(MDLST(MDK)) Q:MDK<1  S MDY=$G(MDLST(MDK)) I +$P(MDY,"^",2)>0 S MDCL=+MDY D
        .K ^TMP($J,"SDAMA202","GETPLIST")
        .D GETPLIST^SDAMA202(+MDY,"1;4;","R",MDDT,MDEND,.MDRET,"")
        .F MD=0:0 S MD=$O(^TMP($J,"SDAMA202","GETPLIST",MD)) Q:'MD  D
        ..S MDINP=0
        ..S MDY1=+$G(^TMP($J,"SDAMA202","GETPLIST",MD,4)) Q:MDY1<1
        ..S MDSCHD=+$G(^TMP($J,"SDAMA202","GETPLIST",MD,1))
        ..S MDPT=MDY1 Q:+$$GSTUDY(MDPT,MDSCHD)
        ..S MDDX=$$GETC(MDPT,+$P(MDY,"^",2)) Q:'+MDDX
        ..S MDNODE=$G(^MDD(702,+MDDX,0))
        ..S:$G(^DPT(MDY1,.105))'="" MDINP=1
        ..S MDCON=$P(MDNODE,"^",5) Q:'MDCON
        ..S MDVSTR=$P(MDNODE,"^",7) Q:MDVSTR=""
        ..S MDMULT=+$$GET1^DIQ(702,+MDDX,".04:.12","I")
        ..S MDHEMO=+$$GET1^DIQ(702,+MDDX,".04:.06","I")
        ..S MDYR=$S(MDMULT<1:MDCOM,1:MDCDT)
        ..Q:$P(MDNODE,"^",2)<MDYR
        ..Q:'+$P(MDNODE,"^",6)
        ..Q:'$P(MDNODE,"^",9)
        ..Q:$P(MDNODE,"^",9)>3
        ..Q:MDMULT'=1&(MDHEMO<2)
        ..Q:$P(MDVSTR,";",2)=MDSCHD
        ..S MDINST=+$$GINST(+$P(MDNODE,"^",4)) Q:'MDINST
        ..K MDFDA,MDERR,MDIEN
        ..S MDFDA(702,"+1,",.01)=MDY1
        ..S MDFDA(702,"+1,",.02)=$$NOW^XLFDT()
        ..S MDFDA(702,"+1,",.03)=$P(MDNODE,"^",3)
        ..S MDFDA(702,"+1,",.04)=$P(MDNODE,"^",4)
        ..S MDFDA(702,"+1,",.05)=MDCON
        ..S MDFDA(702,"+1,",.07)="A;"_MDSCHD_";"_MDCL
        ..S MDFDA(702,"+1,",.11)=+MDINST
        ..S MDFDA(702,"+1,",.14)=MDSCHD
        ..D UPDATE^DIE("","MDFDA","MDIEN","MDERR") Q:$D(MDERR)  K MDFDA
        ..S MDIENS=MDIEN(1)_"," I MDHEMO=2 S MDHOLD=$P($G(^MDD(702,MDIEN(1),0)),"^",7),MDNOW=$$NOW^XLFDT(),$P(^MDD(702,MDIEN(1),0),"^",7)=$S(MDNOW>MDSCHD:MDSCHD,1:MDNOW)
        ..S MDHL7=$$SUB^MDHL7B(MDIEN(1))
        ..I +MDHL7=-1 S MDFDA(702,MDIENS,.09)=2,MDFDA(702,MDIENS,.08)=$P(MDHL7,U,2)
        ..I +MDHL7=1 S MDFDA(702,MDIENS,.09)=5,MDFDA(702,MDIENS,.08)=""
        ..D:$D(MDFDA) FILE^DIE("","MDFDA","MDERR")
        ..Q:'+$G(MDIENS)
        ..I MDHEMO=2 D CP^MDKUTL(+MDIENS) K MDFDA S:$G(MDHOLD)'="" MDFDA(702,+MDIENS_",",.07)=MDHOLD S MDFDA(702,+MDIENS_",",.09)=5 D FILE^DIE("","MDFDA","MDERR")
        K ^TMP($J,"SDAMA202","GETPLIST"),^TMP("MDSTATUS",$J),MDFDA
        Q
GETC(MDPAT,MDDA)        ; Get consult date
        N MDX,MDCF S MDCF=0 K ^TMP("MDTMP",$J) D CPLIST^GMRCCP(MDPAT,+MDDA,$NA(^TMP("MDTMP",$J)))
        S MDX=$O(^TMP("MDTMP",$J,""),-1) Q:'+MDX 0
        I "saprc"'[$P($G(^TMP("MDTMP",$J,MDX)),U,4) S MDX=$O(^TMP("MDTMP",$J,MDX),-1) Q:'+MDX 0
        I "saprc"[$P($G(^TMP("MDTMP",$J,MDX)),U,4) S MDCF=$P($G(^TMP("MDTMP",$J,MDX)),U,5)_"^"_$P($G(^TMP("MDTMP",$J,MDX)),U,1)
        K ^TMP("MDTMP",$J)
        Q $S(+MDCF:+$O(^MDD(702,"ACON",+MDCF,""),-1)_"^"_$P(MDCF,"^",2),1:0)
GINST(MDDA)     ; Get instrument from CP Definition
        N MDIN,MDINT,Y1 S (MDINT,Y1)=0
        F MDIN=0:0 S MDIN=$O(^MDS(702.01,+MDDA,.1,MDIN)) Q:MDIN<1!(+Y1)  S MDINT=+$G(^(MDIN,0)) I +$$GET1^DIQ(702.09,MDINT,".13","I") S Y1=MDINT
        Q Y1
GSTUDY(MDPAT,MDDA)      ;Get study for scheduled date/time
        N MDIN,Y1 S Y1=0
        F MDIN=0:0 S MDIN=$O(^MDD(702,"ASD",MDDA,MDIN)) Q:MDIN<1!(Y1>0)  D
        .S:$P($G(^MDD(702,MDIN,0)),"^")=MDPAT Y1=1
        Q Y1
