RCXVDC4 ;DAOU/ALA-AR Data Extraction Data Creation ;02-JUL-03
        ;;4.5;Accounts Receivable;**201,227,228,248,251,256**;Mar 20, 1995;Build 6
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; Procedures
        Q
D399PC  ;
        I RCXVD0="" Q
        N RCXVD,RCXVDA,RCXVB,RCXVPC,RCXVP1,RCXVP2,RCXVP3,RCXVMULT
        N RCXVDT3,RCXVCP,RCXVPCDT,RCXVPS1,RCXVPS2,RCXVPS,RCXVPSER,RCXVNPI,RCXVCNT,RCXVMH
        ;RCXVPC=PROC. CODE IEN, RCXVCP=CPT CODE IEN
        ; LOOP THRU PROC.
        S RCXVMH="",(RCXVPC,RCXVCNT)=0
        F  S RCXVPC=$O(^DGCR(399,RCXVD0,"CP",RCXVPC)) Q:'RCXVPC  D D399PCA
        S RCXVPC=0
        F  S RCXVPC=$O(^DGCR(399,RCXVD0,"RC",RCXVPC)) Q:'RCXVPC  D D39942
        Q
D399PCA ;
        S RCXVD=$G(^DGCR(399,RCXVD0,"CP",RCXVPC,0)) Q:RCXVD=""
        S RCXVP1=$P(RCXVD,U,1),RCXVVP="",RCXVVP1=""
        I RCXVP1'="" S RCXVVP="^"_$P(RCXVP1,";",2)_$P(RCXVP1,";",1)_",0)"
        I RCXVVP'="" S RCXVVP1=$P($G(@RCXVVP),U,1) I RCXVVP1="" D
        . NEW CT
        . S CT=$G(^TMP("RCXVBREC",$J,0))+1,^TMP("RCXVBREC",$J,0)=CT
        . S ^TMP("RCXVBREC",$J,CT,0)="Bill # "_$P($G(^DGCR(399,RCXVD0,0)),"^",1)_" has a bad CPT code at IEN # "_RCXVPC_" check ^DGCR(399,"_RCXVD0_",""CP"","_RCXVPC_",0)"
        S RCXVDA=RCXVBLNA_RCXVU_RCXVVP1 ; PROC.
        S RCXVDT=$P(RCXVD,U,2)
        S RCXVPCDT=$E($$HLDATE^HLFNC(RCXVDT),1,8)
        S RCXVDA=RCXVDA_RCXVU_RCXVPCDT ; DT
        S RCXVP1=$P(RCXVD,U,11),RCXVP2=""
        I RCXVP1'="" S RCXVP1=$P($G(^IBA(362.3,RCXVP1,0)),U,1)
        I RCXVP1'="" S RCXVP2=$P($G(^ICD9(RCXVP1,0)),U,1)
        S RCXVDA=RCXVDA_RCXVU_RCXVP2 ; ASSOC DXN (1)
        S RCXVP1=$P(RCXVD,U,7),RCXVP2=""
        I RCXVP1'="" S RCXVP2=$P($G(^SC(RCXVP1,0)),U,1)
        S RCXVDA=RCXVDA_RCXVU_RCXVP2 ; ASSC. CLNC (P)
        S RCXVP1=$P(RCXVD,U,18),(RCXVP2,RCXVPS,RCXVPSER,RCXVNPI)=""
        I RCXVP1'="" S RCXVP2=$$GET1^DIQ(200,RCXVP1_",",.01,"E"),RCXVNPI=$P($$NPI^XUSNPI("Individual_ID",RCXVP1),RCXVU,1) S:+RCXVNPI<1 RCXVNPI="" D
        . S RCXVPS=$$GET^XUA4A72(RCXVP1,RCXVDT)
        . S RCXVPS=$P(RCXVPS,U,3)
        . S RCXVPSER=$$GET1^DIQ(200,RCXVP1_",",29,"E")
        . Q
        ;provider^provider npi^specialty^service/section
        S RCXVDA=RCXVDA_RCXVU_RCXVP2_RCXVU_RCXVNPI_RCXVU_RCXVPS_RCXVU_RCXVPSER
        S RCXVCNT=RCXVCNT+1,^TMP($J,RCXVBLN,"4-399A",RCXVCNT)=RCXVDA
        ; LOOP THRU CPT
        S RCXVCP=0,RCXVMULT=0
        F  S RCXVCP=$O(^DGCR(399,RCXVD0,"CP",RCXVPC,"MOD",RCXVCP)) Q:'RCXVCP  D
        .  Q:'($D(^DGCR(399,RCXVD0,"CP",RCXVPC,"MOD",RCXVCP,0)))
        . ; ^DGCR(399,D0,CP,D1,MOD,D2,0)= (#.01) CPT MODIFIER SEQUENCE [1N]
        . ; (#.02) CPT ==>MODIFIER [2P:81.3]
        . S RCXVP1=$P($G(^DGCR(399,RCXVD0,"CP",RCXVPC,"MOD",RCXVCP,0)),U,2)
        . Q:RCXVP1=""
        . S RCXVMULT=RCXVMULT+1
        . S RCXVP2=$P($G(^DIC(81.3,RCXVP1,0)),U,1)
        . S ^TMP($J,RCXVBLN,"4-399A",RCXVCNT,RCXVMULT)=RCXVP2
        . Q
        ;
        ; *256 - loop through 399.042 to find CPT procedure
MATCH   N RCXVCPT1,RCXVFND,X
        S RCXVCPT1=$P(RCXVD,";",1)  ;proc
        S (RCXVFND,RCXVCP)=0
        F  S RCXVCP=$O(^DGCR(399,RCXVD0,"RC",RCXVCP)) Q:'RCXVCP!RCXVFND  D
        . Q:$F(RCXVMH,";"_RCXVCP)  ;quit if CPT proc match
        . S RCXVD1=$G(^DGCR(399,RCXVD0,"RC",RCXVCP,0))
        . Q:RCXVD1=""
        . S X=$P(RCXVD1,U,6)  ;CPT proc
        . I RCXVCPT1'="",X'="",RCXVCPT1=X D
        .. S RCXVFND=1
        .. S X=$P(RCXVD1,U)
        .. S RCXVDB=RCXVBLNA_RCXVU_$$GET1^DIQ(399.2,X_",",.01,"E") ; Revenue Code
        .. S X=$P(RCXVD1,U,6)
        .. S RCXVDB=RCXVDB_RCXVU_$$GET1^DIQ(81,X_",",.01,"E") ; Procedures [P]
        .. S RCXVDB=RCXVDB_RCXVU_RCXVPCDT ; PROC. DT
        .. S RCXVDB=RCXVDB_RCXVU_$P(RCXVD1,U,2) ; Charges
        .. S ^TMP($J,RCXVBLN,"4-399B",RCXVCNT)=RCXVDB
        .. S RCXVMH=RCXVMH_";"_RCXVCP
        I 'RCXVFND S ^TMP($J,RCXVBLN,"4-399B",RCXVCNT)=""
        Q
        ;
D39942  ; charge
        N X
        Q:$F(RCXVMH,";"_RCXVPC)
        S RCXVD1=$G(^DGCR(399,RCXVD0,"RC",RCXVPC,0))
        Q:RCXVD1=""
        S X=$P(RCXVD1,U)
        S RCXVDB=RCXVBLNA_RCXVU_$$GET1^DIQ(399.2,X_",",.01,"E") ; Revenue Code
        S RCXVDB=RCXVDB_RCXVU_""  ;No CPT proc
        S RCXVDB=RCXVDB_RCXVU_"" ; No proc dt
        S RCXVDB=RCXVDB_RCXVU_$P(RCXVD1,U,2) ; Charges
        S RCXVCNT=RCXVCNT+1
        S ^TMP($J,RCXVBLN,"4-399A",RCXVCNT)=""
        S ^TMP($J,RCXVBLN,"4-399B",RCXVCNT)=RCXVDB
        Q
        ;
