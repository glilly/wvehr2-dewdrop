MDRPCOT1 ; HOIFO/NCA/DP - Object RPCs (TMDTransaction) - Continued ; [08-02-2002 12:55]
 ;;1.0;CLINICAL PROCEDURES;**5**;Apr 01, 2004;Build 1
 ; Integration Agreements:
 ; IA# 3468 [Subscription] GMRCCP API.
 ; IA# 3567 [Subscription] MAGGSIUI API
 ; IA# 10040 [Supported] Hospital Location File Access
 ; IA# 10061 [Supported] Calls to VADPT
 ; IA# 10103 [Supported] Calls to XLFDT.
 ;
DELERR(MDTIEN) ; [Procedure] Delete Imaging Error Messages
 S MDLP=0 F  S MDLP=$O(^MDD(702,MDTIEN,.091,MDLP)) Q:'MDLP  D
 .K DA,DIK
 .S DA=+MDLP,DA(1)=+MDTIEN,DIK="^MDD(702,"_DA(1)_",.091," D ^DIK
 .Q
 Q
 ;
IMGSTAT(STUDY,MDSTAT) ; [Procedure] Update the Image Status.
 N MDL
 S MDL=0 F  S MDL=$O(^MDD(702,STUDY,.1,MDL)) Q:MDL<1  S $P(^(MDL,0),"^",9)=MDSTAT
 Q
 ;
GETVSTR(DFN,MDSSTR,MDPR,MDTR) ; [Function] Check the Visit String
 N MDCLOC,MDLOC,MDINPT,VAIP
 I '$G(MDTR) Q 0
 I '$G(MDPR) Q 0
 I $G(MDSSTR)="" Q 0
 S VAIP("D")=MDTR ; DT of Transaction Created
 D IN5^VADPT S MDINPT=$S(+VAIP(13):1,1:0)
 S MDCLOC=$$GET1^DIQ(702.01,+MDPR_",",.05,"I")
 I 'MDCLOC S MDCLOC=+$P(MDSSTR,";",3) I 'MDCLOC Q 0
 S Y=MDCLOC_";"_$P(MDSSTR,";",2)_";"_$P(MDSSTR,";")
 I $P(Y,";",3)="A" Q Y
 S:$P(Y,";",3)="" $P(Y,";",3)="A"
 S:+MDINPT $P(Y,";",3)="A"
 Q Y
 ;
PDT(STUDY) ; [Function] Loop through the attachments for Date/Time Performed.
 N MDL,MDDT
 S MDL=0,MDDT=""
 F  S MDL=$O(^MDD(702,STUDY,.1,MDL)) Q:'MDL  D  Q:MDDT
 .S MDDT=$P($G(^MDD(702,STUDY,.1,MDL,0)),"^",3)
 I MDDT S MDDT=$P($G(^MDD(703.1,+MDDT,0)),"^",3) ; Get Date/Time Performed
 Q MDDT
 ;
SUBMIT(STUDY) ; [Function] Submit all non-pending/uncomplete images in transaction to Imaging
 N DATA,MDACQ,MDC,MDCRES,MDCTR,MDLOC,MDAR,MDARR,MDDT,MDFDA,MDDEL,MDIEN,MDIENS,MDIMG,MDL,MDMAG,MDR,MDST,MDX,MDY,MDZ
 S MDIEN=+STUDY,MDIENS=MDIEN_","
 S MDST=$$GET1^DIQ(702,MDIEN,.09,"I") I "13"[MDST Q "-1^Study not in proper status"
 D DELERR(+MDIEN)
 I $$GET1^DIQ(702,MDIEN,.01)="" Q "-1^No Entry in file (#702)."
 D NOW^%DTC S MDDT=%
 S MDMAG("IDFN")=+$$GET1^DIQ(702,MDIEN,.01,"I")
 I 'MDMAG("IDFN") Q "-1^No Patient DFN."
 S MDMAG("PXPKG")=8925
 S MDMAG("PXIEN")=+$$GET1^DIQ(702,MDIEN,.06,"I")
 I 'MDMAG("PXIEN") Q "-1^No TIU IEN"
 I '$O(^MDD(702,MDIEN,.1,0)) D  Q $S(+MDR<0:MDR,1:"3^Transaction Complete")
 .S MDC=$$GET1^DIQ(702,MDIEN,.05,"I")
 .S MDR=$$UPDCONS(MDC,MDMAG("PXIEN"))
 S MDMAG("STSCB")="ISTAT^MDAPI"
 S MDMAG("TRKID")="CP;"_MDIEN_"-"_MDDT
 S MDLOC=$$GET1^DIQ(702,MDIEN,.07,"I"),MDLOC=$P(MDLOC,";",3)
 I 'MDLOC Q "-1^No Hospital Location."
 S MDMAG("ACQS")=$S(+$$GET1^DIQ(44,MDLOC_",",3,"I"):+$$GET1^DIQ(44,MDLOC_",",3,"I"),1:+$G(DUZ(2)))
 S MDMAG("ACQL")=MDLOC
 S MDX=$$GET1^DIQ(702,MDIEN,.04,"I")
 S MDZ=$P(^MDS(702.01,+MDX,0),"^",1)
 S (MDACQ,MDX,MDDEL)="",MDCTR=0
 N MDTOT S MDTOT=$$GET1^DIQ(702,MDIENS,.991)
 S MDL=0 F  S MDL=$O(^MDD(702,MDIEN,.1,MDL)) Q:MDL<1  S MDX=$G(^(MDL,0)) D
 .S:'MDDEL MDDEL=$P(MDX,"^",3)
 .S MDY=$G(^MDD(702,MDIEN,.1,MDL,.1)) Q:MDY=""
 .S:MDACQ="" MDACQ=$P($P(MDY,"\\",2),"\")
 .S:"12"[$P(MDX,"^",9) $P(MDX,"^",9)=""
 .I $P(MDX,"^",9)="" S MDCTR=MDCTR+1,MDARR(MDCTR)=MDY_"^"_MDZ_" image "_MDCTR_" out of "_MDTOT
 .Q
 I '$O(MDARR(0)) Q "-1^No UNC."
 S MDMAG("GDESC")=MDZ_" Result"
 I MDDEL S MDY=$P($G(^MDD(703.1,+MDDEL,0)),"^",3,4),MDMAG("PXDT")=$P(MDY,"^",1),MDY=+$P(MDY,"^",2),MDMAG("ACQD")=$P($G(^MDS(702.09,+MDY,0)),"^"),MDMAG("DFLG")=+$P($G(^MDS(702.09,+MDY,0)),"^",5)
 S:$G(MDMAG("ACQD"))="" MDMAG("ACQD")=MDACQ
 S:'$G(MDMAG("PXDT")) MDMAG("PXDT")=MDDT ; If no date, use NOW in MDDT
 S MDMAG("TRTYPE")="NEW"
 D IMPORT^MAGGSIUI(.MDIMG,.MDARR,.MDMAG)
 I '(+$G(MDIMG(0))) D  Q "-1^"_$P(MDIMG(0),"^",2)
 .D IMGSTAT(+MDIENS,1)
 .F MDAR=0:0 S MDAR=$O(MDIMG(MDAR)) Q:'MDAR  I $G(MDIMG(MDAR))'="" D
 ..S DATA("MESSAGE")=$$TRANS^MDAPI(MDIMG(MDAR)) D ADDMSG^MDRPCOT
 D IMGSTAT(+MDIENS,0)
 Q "1^Images Submitted"
 ;
UPDCONS(MDC,MDDOC) ; [Function] Update Consults Procedure Status
 N MDCRES
 S MDCRES=$$CPDOC^GMRCCP(MDC,MDDOC,2)
 I '(+MDCRES) Q "-1^"_$P(MDCRES,"^",2)
 Q 1
 ;
GETIORD(MDIEN) ; [Function] Return the Instrument order number for this study
 ; Called from instrument interface routines
 Q:'$D(^MDD(702,MDIEN,0))#2 -1  ; No such study
 Q:'$P(^MDD(702,MDIEN,0),U,12) $$NEWIORD(MDIEN)  ; Create a new one
 Q $P(^MDD(702,MDIEN,0),U,12)  ; Return the existing one
 ;
NEWIORD(MDIEN) ; [Function] Generate & return new unique instrument order number
 ; Notice: will overwrite existing order number if it exists
 N MDFDA
 Q:'$D(^MDD(702,MDIEN,0))#2 -1  ; No such study
 L +^MDD(702,"AION"):15 E  Q -1  ; Unable to lock and guarantee uniqueness
 F  D  Q:'$D(^MDD(702,"AION",X))  H 1  ; Loop until unique
 . S X=$$NOW^XLFDT() ; Current DateTime
 . S X=$TR($J(X,14,6),".","") ; Pad with 0's and strip the decimal
 . Q
 I $E($G(^MDS(702.09,DEVIEN,0)),1,4)="Muse" D
 . ; Due to current limitation to the Muse can only except 9
 . S X=$E($TR($H,",",""),2,10) ; Using $E($H) only for the MUSE
 . I '$D(^MDD(702,"AION",X)) Q  ; It is unique and quit
 . N I,FLG ; Not unique
 . S FLG=0
 . F I=1:1 D  Q:FLG
 . . S X=X+1
 . . I '$D(^MDD(702,"AION",X)) S FLG=1
 . . Q
 . Q
 S MDFDA(702,MDIEN_",",.12)=X  ; Build FDA
 D FILE^DIE("","MDFDA")  ; File it
 L -(^MDD(702,"AION"))  ; Unlock it
 Q $P(^MDD(702,MDIEN,0),U,12)  ; Return it from the file
 ;
GETSTDY(MDION) ; [Function] Return study from instrument order number
 ; Called from instrument interface routines
 Q:'$D(^MDD(702,"AION",MDION)) -1  ; No such order number
 Q $O(^MDD(702,"AION",MDION,""))  ; Return the 702 ien
 ;
