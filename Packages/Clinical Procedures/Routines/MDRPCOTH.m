MDRPCOTH        ; HOIFO/NCA - Process High Volume Procedure Results ;2/27/09  10:08
        ;;1.0;CLINICAL PROCEDURES;**21**;Apr 01, 2004;Build 30
        ; Integration Agreements:
        ; IA# 2263 [Supported] Calls to XPAR.
        ; IA# 3468 [Subscription] GMRCCP API.
        ; IA# 3535 [Subscription] Calls to TIUSRVP.
        ; IA# 4508 [Subscription] Call to TIUSRVPT.
        ; IA# 10060 [Supported] Access to NEW PERSON file (#200).
        ; IA# 10104 [Supported] Routine XLFSTR calls
        ;
ADDMSG  ; [Procedure] Add message to transaction
        N MDIEN,MDIENS,MDRET
        Q:'$G(DATA("TRANSACTION"))
        Q:$G(DATA("MESSAGE"))=""
        S MDIEN=+DATA("TRANSACTION"),MDIENS="+1,"_MDIEN_","
        D NOW^%DTC S DATA("DATE")=% K %
        S MDFDA(702.091,MDIENS,.01)=+$O(^MDD(702,+MDIEN,.091,"A"),-1)+1
        S MDFDA(702.091,MDIENS,.02)=DATA("DATE")
        S MDFDA(702.091,MDIENS,.03)=$G(DATA("PKG"),"UNKNOWN")
        S MDFDA(702.091,MDIENS,.09)=DATA("MESSAGE")
        D UPDATE^DIE("","MDFDA","MDRET")
        Q
FILEMSG(STUDY,MDPKG,MDSTAT,MDMSG)       ; [Procedure] File Study Status and Message.
        N DATA
        S DATA("TRANSACTION")=STUDY,DATA("PKG")=MDPKG
        S DATA("MESSAGE")=$P(MDMSG,"^",2)
        D STATUS(STUDY_",",MDSTAT,$P(MDMSG,"^",2)),ADDMSG
        Q
        ;
NEWSTAT ; [Procedure] RPC Call to set status
        S MDFDA(702,DATA,.09)=TYPE
        D FILE^DIE("","MDFDA")
        I TYPE=3&($G(^MDK(704.202,+DATA,0))'="") K MDFDA S MDFDA(704.202,DATA,.09)=0 D FILE^DIE("","MDFDA") K MDFDA
        Q
        ;
STATUS(MDIENS,MDSTAT,MDMSG)     ; [Procedure] Update transaction status
        S MDFDA(702,MDIENS,.08)=$G(MDMSG)
        S MDFDA(702,MDIENS,.09)=MDSTAT
        D FILE^DIE("","MDFDA")
        Q
        ;
NEWTIUN(STUDY,RECID)    ; [Function] Create a new TIU for transaction
        ; Input: STUDY - IENS of CP study entry
        ; Return: TIU Document IEN
        N CTR,DFN,MDADD,MDCON,MDCONRS,MDCT,MDDAR,MDFDA,MDGST,MDL,MDLOC,MDNOTE,MDPDT,MDPROC,MDRESU,MDTI,MDTCHK,MDTITL,MDTRE,MDTSTR,MDNVST,MDVST,MDVSTR,MDWPA,MDPT,MDR,MDRP,MDRST,MDTX,MDUSR
        N MDHLS,MDHLS1,MDKK,MDX0
        S CTR=0,MDGST=+STUDY,MDRESU=""
        K ^TMP("MDDAR",$J) N MDDAR2,GLOARR,MDMUS S MDMUS=0
        ; Get data for TIU Note Creation
        S (MDTSTR,MDRESU)=$$GETDATA^MDRPCOT(MDGST)
        ; File Error message
        I +MDRESU<0 D FILEMSG(MDGST,"CP",2,MDRESU) Q MDRESU
        I $G(MDTSTR)="" Q "-1^No Data to Create TIU Document"
        F MDL="DFN","MDTITL","MDLOC","MDNOTE","MDCON","MDPROC","MDVSTR","MDNVST" D
        .S CTR=CTR+1,@MDL=$P(MDTSTR,"^",CTR)
        S MDVST=""
        ; If previous TIU document exists, quit
        I MDNOTE Q MDNOTE
        I 'MDLOC Q "-1^No Hospital Location."
        S MDUSR=$$FIND1^DIC(200,,"X","CLINICAL,DEVICE PROXY SERVICE","B")
        ; Create new visit, if no vstring
        S MDPDT=$$PDT^MDRPCOT1(MDGST)
        I 'MDPDT S MDPT=$O(^MDD(703.1,"ASTUDYID",+MDGST,""),-1),MDPDT=$P($G(^MDD(703.1,+MDPT,0)),U,3)
        S:'MDPDT MDPDT=$P(MDVSTR,";",2) ; If No D/T Performed grab visit D/T
        I $P(MDVSTR,";",3)="V" S $P(MDVSTR,";",3)="A"
        ; Build variables for TIU Call
        S MDWPA(.05)=1 ; Undicated Status
        S MDWPA(1405)=+MDCON_";GMR(123," ; Package Reference
        S MDWPA(70201)=5 ; Default Procedure Summary Code "Machine Resulted"
        I MDPDT S MDWPA(70202)=MDPDT ; Date/Time Performed
        ; File PCE Error message
        S MDDAR=$NA(^TMP("MDDAR",$J)),MDDAR2=$NA(GLOARR)
        S MDRP=0 F  S MDRP=$O(^MDD(702,+MDGST,.1,MDRP)) Q:'MDRP  D
        .S MDRST=$P($G(^MDD(702,MDGST,.1,0)),"^",3)
        .I MDRST D CICNV^MDHL7U3(+MDRST,.MDDAR) D SETGLO^MDRPCW1(.MDDAR,.MDDAR2)
        .K ^TMP("MDDAR",$J) Q
        S MDRESU=$$EN1^MDPCE2(.MDDAR2,MDGST,$P(MDVSTR,";",2),MDPROC,$P(MDVSTR,";",3),"P",MDLOC) I +MDRESU S MDVST=+MDRESU
        I MDNVST&(+MDRESU<0) D FILEMSG(MDGST,"PCE",2,$P(MDRESU,"^",2)) Q MDRESU
        ; Create the TIU note stub
        S MDNOTE="" D MAKE^TIUSRVP(.MDNOTE,DFN,MDTITL,$P(MDVSTR,";",2),MDLOC,$S(MDVST:MDVST,1:""),.MDWPA,MDVSTR,1,1)
        I '(+MDNOTE) S $P(MDNOTE,"^")=-1 Q MDNOTE
        ; Finalize the transaction
        S MDFDA(702,STUDY_",",.06)=+MDNOTE
        S MDFDA(702,STUDY_",",.08)=""
        S:MDVST>0 MDFDA(702,STUDY_",",.13)=MDVST
        D FILE^DIE("","MDFDA")
        D UPD^MDKUTLR(STUDY,+MDNOTE)
        S:$$UP^XLFSTR($$GET1^DIQ(702,+STUDY_",",".11","E"))["MUSE" MDMUS=1
        S MDHLS=$P(^MDS(702.01,+$P(^MDD(702,+STUDY,0),"^",4),0),"^")
        S MDHLS1=$$GET^XPAR("SYS","MD GET HIGH VOLUME",MDHLS,"E")
        K MDHLS,MDWPA D GETTXT^MDAR7M(.MDWPA,RECID)
        I $G(MDWPA("TEXT",1,0))="" Q 1
        I $G(MDWPA(1202))=""&('+$P(MDHLS1,";",2)) S MDWPA(1202)=MDUSR,MDWPA(1204)=MDUSR,MDWPA(1302)=MDUSR
        S MDWPA(.05)=5,MDTI=""
        I +$P(MDHLS1,";",2)&('+$$GET^XPAR("SYS","MD USE NOTE",1)) N MDADAR,MDCCN S MDCCN=0 D  Q 1
        .S MDCT=0 F  S MDCT=$O(MDWPA("TEXT",MDCT)) Q:MDCT<1  S MDADAR=$G(MDWPA("TEXT",MDCT,0)) D
        ..Q:'$G(RECID)
        ..S ^MDD(703.1,+RECID,.4,MDCT,0)=MDADAR,MDCCN=MDCCN+1
        ..Q
        .S ^MDD(703.1,+RECID,.4,0)="^^"_MDCCN_"^"_MDCCN_"^"_DT_"^"
        .K MDWPA Q
        D UPDATE^TIUSRVP(.MDTI,+MDNOTE,.MDWPA,1)
        ;I +$$GET^XPAR("SYS","MD NOT ADMN CLOSE MUSE NOTE",1) S MDCONRS=$$CPDOC^GMRCCP(+MDCON,+MDNOTE,2) Q 1
        I +$P(MDHLS1,";",2)&(+$$GET^XPAR("SYS","MD USE NOTE",1)) S MDCONRS=$$CPDOC^GMRCCP(+MDCON,+MDNOTE,2) Q 1
        I +MDNOTE&MDTI'<1 D ADMNCLOS^TIUSRVPT(.MDR,+MDNOTE,"M",MDWPA(1202))
        Q 1
