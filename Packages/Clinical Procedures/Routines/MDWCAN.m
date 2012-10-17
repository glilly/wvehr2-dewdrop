MDWCAN  ;HOIFO/NCA - Process No-Shows and Cancels ;7/29/08  09:50
        ;;1.0;CLINICAL PROCEDURES;**11**;Apr 01, 2004;Build 67
        ; Reference IA #2263 [Supported] Call to ^XPAR
        ;              #4433 [Supported] Call to SDAPI^SDAMA301
        ;              #10103 [Supported] XLFDT call
EN1     ; Check for No-Shows and Cancels
        N MDARRAY,MDAPAT,MDAPPT,MDCHECK,MDALOC,MDCL,MDCOUNT,MDCLIEN,MDDFN,MDDATE,MDAPPT,MDK,MDLP1,MDLP2,MDLST,MDLIST,MDFIN,MDND,MDSTUDY,MDVST,MDXX,MDY,X1,X2
        S X1=DT,X2=-1 D C^%DTC S MDDATE=X K ^TMP("MDAP",$J),^TMP("MDCAN",$J),^TMP("MDPLST",$J),MDALOC S MDFIN=DT+.24
        D GETLST^XPAR(.MDLIST,"SYS","MD CLINIC ASSOCIATION")
        F MDK=0:0 S MDK=$O(MDLIST(MDK)) Q:MDK<1  S MDND=$P($G(MDLIST(MDK)),"^",2) I +$P(MDND,";",2) S MDCL=+MDND D
        .S:$G(MDALOC(+MDCL))="" MDALOC(+MDCL)=+MDCL
        .S ^TMP("MDPLST",$J,+MDCL,+$P(MDND,";",2))=+$P(MDND,";",2)
        .Q
        S MDLP1=DT F  S MDLP1=$O(^MDD(702,"ASD",MDLP1)) Q:MDLP1<1!(MDLP1>MDFIN)  F MDLP2=0:0 S MDLP2=$O(^MDD(702,"ASD",MDLP1,MDLP2)) Q:MDLP2<1  D
        .S MDXX=$G(^MDD(702,MDLP2,0))
        .Q:$P(MDXX,"^",9)'=5
        .Q:'+MDXX
        .I $G(^TMP("MDAP",$J,+MDXX))="" S ^TMP("MDAP",$J,+MDXX)=+MDXX
        .Q
        F MDLP1=0:0 S MDLP1=$O(^MDD(702,"AS",0,MDLP1)) Q:MDLP1<1  D
        .S MDXX=$G(^MDD(702,MDLP1,0))
        .Q:$P(MDXX,"^",9)>0
        .Q:'+$P(MDXX,"^",5)!($P(MDXX,"^",6)'="")
        .Q:'+MDXX
        .I $G(^TMP("MDAP",$J,+MDXX))="" S ^TMP("MDAP",$J,+MDXX)=+MDXX
        .I '+$G(^TMP("MDCAN",$J,0,+MDXX,+$P(MDXX,"^",4))) S ^TMP("MDCAN",$J,0,+MDXX,+$P(MDXX,"^",4))=MDLP1
        .Q
        F MDK=0:0 S MDK=$O(^TMP("MDAP",$J,MDK)) Q:MDK<1  D
        .K ^TMP($J,"SDAMA301") S MDXX=MDK,MDARRAY(1)=MDDATE_";"_DT
        .S MDARRAY(2)="MDALOC("
        .S MDARRAY(3)="NS;NSR;CP;CPR;CC;CCR",MDARRAY(4)=+MDXX,MDARRAY("FLDS")="1;3;4;25"
        .S MDCOUNT=$$SDAPI^SDAMA301(.MDARRAY)
        .I MDCOUNT>0 D
        ..S MDCL=0 F  S MDCL=$O(^TMP($J,"SDAMA301",+MDXX,MDCL)) Q:MDCL<1  S MDCLIEN=0 F  S MDCLIEN=$O(^TMP($J,"SDAMA301",+MDXX,+MDCL,MDCLIEN)) Q:MDCLIEN<1  D
        ...S MDAPPT=$G(^TMP($J,"SDAMA301",+MDXX,+MDCL,MDCLIEN))
        ...Q:$P(MDAPPT,"^",3)=""
        ...Q:+$P(MDAPPT,"^",4)'=+MDXX
        ...Q:$P(MDAPPT,"^",1)=""
        ...S MDSTUDY=$$GSTUDY(+MDXX,$P(MDAPPT,"^",1),+MDCL) Q:'MDSTUDY
        ...I $G(^MDD(702,+MDSTUDY,3))="" K MDFDA S MDFDA(702,+MDSTUDY_",",.14)=$P(MDAPPT,"^",1) D FILE^DIE("","MDFDA") K MDFDA
        ...D PURG(+MDSTUDY) Q
        ..Q
        .Q
        K ^TMP($J,"SDAMA301"),^TMP("MDAP",$J),^TMP("MDCAN",$J),^TMP("MDPLST",$J),MDAPAT,MDALOC
        Q
GSTUDY(MDPAT,MDDA,MDACL)        ;Get study for scheduled date/time
        N MDDONE,MDIN,MDN,MDV,Y1 S (MDDONE,Y1)=0
        F MDIN=0:0 S MDIN=$O(^MDD(702,"ASD",MDDA,MDIN)) Q:MDIN<1!(Y1>0)!(MDDONE=1)  D
        .I $P($G(^MDD(702,MDIN,0)),"^")=MDPAT D
        ..S MDN=$G(^MDD(702,MDIN,0)),MDV=$P(MDN,"^",7)
        ..I $P(MDV,";",3)'=""&($P(MDV,";",3)'=MDACL) Q
        ..S:$P(MDN,"^",9)'=6 Y1=MDIN S:$P(MDN,"^",9)=6 MDDONE=1
        ..Q
        I +Y1>0 Q Y1
        I +MDDONE>0 Q Y1
        F MDIN=0:0 S MDIN=$O(^TMP("MDCAN",$J,0,MDPAT,MDIN)) Q:MDIN<1!(Y1>0)  D
        .I +$G(^TMP("MDPLST",$J,MDACL,MDIN)) S Y1=+$G(^TMP("MDCAN",$J,0,MDPAT,MDIN))
        Q Y1
PURG(MDI)       ; [Procedure] Delete Study
        N MDAST,MDCANR,MDERR,MDFDA,MDHOLD,MDNOTE,MDRES,MDSIEN,BODY,SUBJECT,DEVIEN,MDORD
        S (MDHOLD,MDSIEN)=+MDI,MDRES=0,MDNOTE=""
        ;D ALERT^MDHL7U3(MDSIEN) ; Builds the body of the mail message
        I $G(^MDD(702,+MDSIEN,0))="" Q
        S:+$P(^MDD(702,+MDSIEN,0),U,6) MDNOTE=$P(^MDD(702,MDSIEN,0),U,6)
        S MDCANR=$$CANCEL^MDHL7B(MDHOLD) I +MDCANR<1 Q
        Q:+MDNOTE
        S MDAST=$$HL7CHK^MDHL7U3(+MDSIEN) I +MDAST<1 Q
        ;D NOTICE^MDHL7U3(SUBJECT,.BODY,DEVIEN,DUZ) ; delete message
        ;S MDFDA(702,DATA_",",.01)=""
        ; Check for renal study to cancel as well
        I $D(^MDK(704.202,+MDI)) K MDFDA S MDFDA(704.202,+MDI_",",.09)=0 D FILE^DIE("","MDFDA")
        K MDFDA
        S MDFDA(702,+MDI_",",.07)=""
        S MDFDA(702,+MDI_",",.09)=6
        D FILE^DIE("","MDFDA")
        S MDORD=+$P($G(^MDD(702,+MDI,0)),"^",12) I +MDORD K ^MDD(702,"AION",+MDORD,+MDI)
        ;N DA,DIK S DA=+MDSIEN,DIK="^MDD(702," D ^DIK
        K MDFDA
        S MDFDA(702,"+1,",.01)=$P($G(^MDD(702,+MDI,0)),"^")
        S MDFDA(702,"+1,",.02)=$$NOW^XLFDT()
        S MDFDA(702,"+1,",.03)=$P($G(^MDD(702,+MDI,0)),"^",3)
        S MDFDA(702,"+1,",.04)=$P($G(^MDD(702,+MDI,0)),"^",4)
        S MDFDA(702,"+1,",.05)=$P($G(^MDD(702,+MDI,0)),"^",5)
        S MDFDA(702,"+1,",.09)=0
        S MDFDA(702,"+1,",.11)=$P($G(^MDD(702,+MDI,0)),"^",11)
        D UPDATE^DIE("","MDFDA","","MDERR") K MDFDA
        Q
