BPSUSCR2        ;ALB ISC/SS - UNSTRANDED ;02-MAY-2008
        ;;1.0;E CLAIMS MGMT ENGINE;**7**;JUN 2004;Build 46
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
        ;Stranded requests with BPS TRANSACTION record
        ;   Input:
        ;     BPARR - Date Range
        ;   Output:
        ;     ^TMP("BPSUSCR",$J)
        ;     ^TMP($J,2)
COLACTRQ(BPARR) ;
        N BPRXIEN,BPRREF,BPDATE,BPQUIT,BPIEN77
        N TFILE,CFILE,STATUS,IEN59,VART,LSTUDT,CD0
        N BPRX,REFILL,NAME,SSN,INSCO,FILLDT
        K BPBDT,BPEDT
        S TFILE=9002313.59,CFILE=9002313.02
        S BPBDT=BPARR("BDT") ;start date and time
        S BPEDT=BPARR("EDT") ;end date and time
        S BPRXIEN=0
        F  S BPRXIEN=$O(^BPS(9002313.77,"AC",2,BPRXIEN)) Q:+BPRXIEN=0  D
        .S BPRREF=""
        .F  S BPRREF=$O(^BPS(9002313.77,"AC",2,BPRXIEN,BPRREF)) Q:BPRREF=""  D
        .. S BPIEN77=+$O(^BPS(9002313.77,"AC",2,BPRXIEN,BPRREF,0))
        .. S IEN59=$$IEN59^BPSOSRX(BPRXIEN,BPRREF)
        .. S BPRX=$$RXAPI1^BPSUTIL1(BPRXIEN,.01,"E")
        .. S VART=$G(^BPST(IEN59,0)) I VART="" D REQSTTMP Q
        .. S STATUS=-96
        .. S STATUS=$P(VART,"^",2)
        .. S LSTUDT=$$GET1^DIQ(TFILE,IEN59,7,"I")
        .. I $D(^TMP("BPSUSCR-1",$J,+(LSTUDT\1),+IEN59)) Q  ;already has it
        .. I LSTUDT<BPBDT!(LSTUDT>BPEDT) Q
        .. S LSTUDT=$P(LSTUDT,".",1)
        .. I LSTUDT="" Q
        .. S CD0=$$GET1^DIQ(TFILE,IEN59,3,"I")
        .. I CD0'="" D
        ... S FILLDT=$$GET1^DIQ(CFILE,CD0,401),FILLDT=$$HL7TFM^XLFDT(FILLDT)
        .. I CD0="" D
        ... S FILLDT=$P($G(^BPST(IEN59,12)),"^",2)
        .. S NAME=$$GET1^DIQ(TFILE,IEN59,5,"E")
        .. S SSN="",VART=$G(^BPST(IEN59,0))
        .. I $P(VART,"^",6)]"" S SSN=$P($G(^DPT($P(VART,"^",6),0)),"^",9),SSN=$E(SSN,$L(SSN)-3,$L(SSN))
        .. S INSCO=$P($G(^BPST(IEN59,10,1,0)),"^",7)
        .. S ^TMP("BPSUSCR-1",$J,LSTUDT,IEN59)=NAME_U_SSN_U_BPRX_U_BPRREF_U_FILLDT_U_INSCO_U_STATUS
        Q
        ;
        ;Stranded requests without BPS TRANSACTION record
        ;Note the IEN59 here is a calculated ien only - the record doesn't exist
REQSTTMP        ;
        N BPDFN,BPIEN78,BPX
        I BPIEN77=0 Q
        S STATUS=-96
        S LSTUDT=$$GET1^DIQ(9002313.77,BPIEN77,6.05,"I")
        I LSTUDT<BPBDT!(LSTUDT>BPEDT) Q
        S LSTUDT=$P(LSTUDT,".",1)
        I LSTUDT="" Q
        I BPRREF=0 S FILLDT=+$$RXAPI1^BPSUTIL1(BPRXIEN,22,"I")
        I BPRREF>0 S FILLDT=+$$RXSUBF1^BPSUTIL1(BPRXIEN,52,52.1,BPRREF,.01,"I")
        S NAME=$$RXAPI1^BPSUTIL1(BPRXIEN,2,"E")
        S BPDFN=+$$RXAPI1^BPSUTIL1(BPRXIEN,2,"I")
        S SSN=""
        I BPDFN>0 S SSN=$P($G(^DPT(BPDFN,0)),"^",9),SSN=$E(SSN,$L(SSN)-3,$L(SSN))
        S BPX=$O(^BPS(9002313.77,BPIEN77,5,0))
        I BPX>0 S BPIEN78=+$P($G(^BPS(9002313.77,BPIEN77,5,BPX,0)),U,3),INSCO=$$GET1^DIQ(9002313.78,BPIEN78,.07,"E")
        E  S INSCO="UNKNOWN"
        S ^TMP("BPSUSCR-1",$J,LSTUDT,IEN59)=NAME_U_SSN_U_BPRX_U_BPRREF_U_FILLDT_U_INSCO_U_STATUS_U_BPIEN77
        Q
