MDHL7XXX ; HOIFO/DP - Loopback device for CP ; 22-MAY-2003 13:37:41
 ;;1.0;CLINICAL PROCEDURES;;Apr 01, 2004
 ; IA# 10103 [Supported] Calls to XLFDT
 ;
EN ; [Procedure] Main entry point
 ; wait 10 seconds and then produce some results in the CP RESULTS file
 ; Variables STUDY and INST passed in via taskman
 H 10 ; Wait for the study to update
 N MDFDA,MDIEN,MDERR K ^TMP($J)
 L +(^MDD(703.1,"B")):15 E  Q
 F  D  Q:'$D(^MDD(703.1,"B",X))
 .S X="127001_"_(+$H)_$E($P($H,",",2)_"00000",1,5)
 S MDFDA(703.1,"+1,",.01)=X
 D UPDATE^DIE("","MDFDA","MDIEN","MDERR")
 L -(^MDD(703.1,"B"))
 S MDIEN=+$G(MDIEN(1),-1)_"," Q:+MDIEN<0
 ; Proceed to build the report here using MDIEN in file 703.1
 S MDFDA(703.1,MDIEN,.02)=$P(^MDD(702,STUDY,0),U,1)
 S MDFDA(703.1,MDIEN,.03)=$$NOW^XLFDT()
 S MDFDA(703.1,MDIEN,.04)=INST
 D:+$$GET1^DIQ(702.09,INST_",",.13,"I")  ; Bi-Directional?
 .S MDFDA(703.1,MDIEN,.05)=STUDY
 S MDFDA(703.11,"+2,"_MDIEN,.01)="1"
 D UPDATE^DIE("","MDFDA","MDIEN","MDERR")
 S MDIEN=+MDIEN(2)_","_MDIEN
 S MDFDA(703.11,MDIEN,.2)=$NA(MDFDA(703.11,MDIEN,.2))
 D GETS^DIQ(702,STUDY_",",".01;.011;.02;.03;.04;.05;.06;.07;.08;.09;.091;.1;.11;.12;.991","ENR",$NA(^TMP($J)))
 S X="" F  S X=$O(^TMP($J,702,STUDY_",",X)) Q:X=""  D
 .S Y=$O(MDFDA(703.11,MDIEN,.2,""),-1)+1
 .S MDFDA(703.11,MDIEN,.2,Y)=X_": "_$G(^TMP($J,702,STUDY_",",X,"E"))
 S MDFDA(703.1,$P(MDIEN,",",2,3),.09)="P"
 D UPDATE^DIE("","MDFDA","MDIEN","MDERR")
 K ^TMP($J)
 Q
 ;
TEST ; Queue up the study creator
 N DIC
 S DIC=702,DIC(0)="AEQM",DIC("A")="Select Study to create a report for: "
 D ^DIC Q:+Y<1
 S STUDY=+Y,INST=+$P(^MDD(702,+Y,0),U,11)
 D LOOPBACK(STUDY,INST)
 Q
 ;
LOOPBACK(STUDY,INST) ; Queue up the Loopback process
 N ZTSAVE,ZTRTN,ZTIO,ZTDESC,ZTDTH,ZTSK
 S ZTSAVE("STUDY")=STUDY,ZTSAVE("INST")=INST
 S ZTRTN="EN^MDHL7XXX"
 S ZTIO=""
 S ZTDESC="CP Loopback test"
 S ZTDTH=$$NOW^XLFDT()
 D ^%ZTLOAD
 Q
 ;
