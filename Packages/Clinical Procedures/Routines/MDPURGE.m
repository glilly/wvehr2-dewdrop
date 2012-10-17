MDPURGE ;HOIFO/NCA - Study Clean-Up process ;6/18/08  10:15
        ;;1.0;CLINICAL PROCEDURES;**11**;Apr 01, 2004;Build 67
        ; Reference IA #2263 [Supported] XPAR calls
        ; Reference IA #3468 [Subscription] Call GMRCCP
EN1     ; Clean up process entry point
        N MDARRY,MDFN,MDK,MDLP,MDPRO,MDET,MDLST,MDX,MDY,X,Y,DTOUT,DUOUT
        D GETLST^XPAR(.MDLST,"SYS","MD CLINIC ASSOCIATION")
        F MDK=0:0 S MDK=$O(MDLST(MDK)) Q:MDK<1  S MDY=$P($G(MDLST(MDK)),"^",2) I +$P(MDY,";",2)>0 S MDPRO=+$P(MDY,";",2) D
        .Q:+$$GET1^DIQ(702.01,+MDPRO_",",.06,"I")=2
        .Q:+$$GET1^DIQ(702.01,+MDPRO_",",.12,"I")=1
        .S MDARRY(+MDPRO)=+MDPRO
        S MDLP=0 F  S MDLP=$O(^MDD(702,"AS",5,MDLP)) Q:MDLP<1  S MDX=$G(^MDD(702,MDLP,0)) D
        .S MDET=$P(MDX,"^",4) Q:$G(MDARRY(MDET))=""
        .S MDFN=+$P(MDX,"^")
        .S MDCN=$P(MDX,"^",5) Q:'MDCN
        .I +$$GETC(MDFN,MDET,+MDCN) D PURG(+MDLP)
        .Q
        S MDLP=0 F  S MDLP=$O(^MDD(702,"AS",0,MDLP)) Q:MDLP<1  S MDX=$G(^MDD(702,MDLP,0)) D
        .S MDET=$P(MDX,"^",4) Q:$G(MDARRY(MDET))=""
        .S MDFN=+$P(MDX,"^")
        .S MDCN=$P(MDX,"^",5) Q:'MDCN
        .I +$$GETC(MDFN,MDET,+MDCN) D PURG(+MDLP)
        .Q
        Q
GETC(MDPAT,MDDA,MDCNS)  ; Get consult date
        N MDJ,MDCF S MDCF=0 K ^TMP("MDTMP",$J) D CPLIST^GMRCCP(MDPAT,+MDDA,$NA(^TMP("MDTMP",$J)))
        S MDJ=0 F  S MDJ=$O(^TMP("MDTMP",$J,MDJ)) Q:'MDJ!(+MDCF)  D
        .I $P($G(^TMP("MDTMP",$J,MDJ)),U,4)="c"&(MDCNS=$P($G(^TMP("MDTMP",$J,MDJ)),U,5)) S MDCF=1 Q
        K ^TMP("MDTMP",$J)
        Q MDCF
PURG(MDI)       ; [Procedure] Delete Study
        N MDAST,MDFDA,MDHOLD,MDNOTE,MDRES,MDSIEN,BODY,SUBJECT,DEVIEN
        S (MDHOLD,MDSIEN)=+MDI,MDRES=0,MDNOTE=""
        ;D ALERT^MDHL7U3(MDSIEN) ; Builds the body of the mail message
        I $G(^MDD(702,+MDSIEN,0))="" Q
        S:+$P(^MDD(702,MDSIEN,0),U,6) MDNOTE=$P(^MDD(702,MDSIEN,0),U,6)
        S MDCANR=$$CANCEL^MDHL7B(MDHOLD) I +MDCANR<1 Q
        Q:+MDNOTE
        S MDAST=$$HL7CHK^MDHL7U3(+MDSIEN) I +MDAST<1 Q
        ;D NOTICE^MDHL7U3(SUBJECT,.BODY,DEVIEN,DUZ) ; delete message
        ;S MDFDA(702,DATA_",",.01)=""
        ; Check for renal study to delete as well
        S:$D(^MDK(704.202,+MDI)) MDFDA(704.202,+MDI_",",.01)=""
        D FILE^DIE("","MDFDA")
        N DA,DIK S DA=+MDSIEN,DIK="^MDD(702," D ^DIK
        Q
