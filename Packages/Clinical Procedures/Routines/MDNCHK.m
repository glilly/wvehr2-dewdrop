MDNCHK  ; HOIFO/NCA - CP Multiple Result Check ;4/26/05  15:17
        ;;1.0;CLINICAL PROCEDURES;**11,21**;Apr 01, 2004;Build 30
        ; Reference
        ; IA#  2263 [Supported] Calls to XPAR.
        ; IA# 10103 [Supported] Call to XLFDT
        ;
CHK(MDIEN)      ; RPC call to notify Consult of results
        ; Input parameters
        ;  1. MDIEN [Literal/Required] CP Study
        ;
        N MDDEF,MDERR,MDHLOC,MDIENS,MDION,MDFDA,MDSTAT,MDSTR,MDSUBL
        I '$G(MDIEN) S MDIEN="" Q MDIEN
        S MDDEF=+$$GET1^DIQ(702,MDIEN,.04,"I") I 'MDDEF Q MDIEN
        S MDSTAT=+$$GET1^DIQ(702.01,MDDEF,.12,"I") I 'MDSTAT Q MDIEN
        S MDION=+$$GET1^DIQ(702,MDIEN,.12,"I") I 'MDION Q MDIEN
        I MDSTAT=2 Q MDIEN
        S MDSTR=$G(^MDD(702,MDIEN,0)) I MDSTR="" Q MDIEN
        I $P(MDSTR,"^",9)'=3 Q MDIEN
        I $$GET^XPAR("SYS","MD GET HIGH VOLUME",MDDEF,"I")'="" Q MDIEN
        K ^MDD(702,"AION",+MDION,MDIEN)
        S MDSUBL=$P(MDSTR,U,7)
        S MDHLOC=+$$GET1^DIQ(702.01,MDDEF,.05,"I"),MDSUBL=$P(MDSUBL,";",1,2)_";"_MDHLOC
        S MDFDA(702,"+1,",.01)=$P(MDSTR,U,1)
        S MDFDA(702,"+1,",.02)=$$NOW^XLFDT()
        S MDFDA(702,"+1,",.03)=$P(MDSTR,U,3)
        S MDFDA(702,"+1,",.04)=$P(MDSTR,U,4)
        S MDFDA(702,"+1,",.05)=$P(MDSTR,U,5)
        S MDFDA(702,"+1,",.07)=$P(MDSTR,U,7)
        S MDFDA(702,"+1,",.09)=5
        S MDFDA(702,"+1,",.11)=$P(MDSTR,U,11)
        S MDFDA(702,"+1,",.12)=$P(MDSTR,U,12)
        D UPDATE^DIE("","MDFDA","MDIENS","MDERR")
        S MDIEN=MDIENS(1)
        Q MDIEN
