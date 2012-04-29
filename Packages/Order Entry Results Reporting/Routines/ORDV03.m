ORDV03  ; slc/dcm - OE/RR Report Extracts ;10/8/03  11:17
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**109,208,215,243**;Dec 17, 1997;Build 242
RI(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)           ;Radiology impression
        ;External Calls: MAIN^GMTSRAE(1)
        ;
        ; ^TMP("GMTSRAD",$J) used via DBIA 4333
        ; ^TMP("RAE",$J) used via DBIA 3968
        N ORDT,ORX0,ORJ,ORCNT,GMDATA,GMTSI,GMW,MAX,TEST,GMTSNDM,GMTS1,GMTS2,ORSITE,SITE,GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S IOST=$G(IOST),GMTSNDM=$S(+$G(ORMAX)>0:ORMAX,1:999),GMTS2=ORALPHA,GMTS1=OROMEGA
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        K ^TMP("ORDATA",$J),^TMP("RAE",$J)  ;DBIA 3968
        D @GO
        S ORDT=GMTS1,ORCNT=0
        F  S ORDT=$O(^TMP("RAE",$J,ORDT)) Q:(ORDT'>0)!(ORDT>GMTS2)  D
        . S ORJ=0 F  S ORJ=$O(^TMP("RAE",$J,ORDT,ORJ)) Q:'ORJ  I $G(^(ORJ,0)) S ORX0=^(0) D
        .. S ORCNT=ORCNT+1
        .. S SITE=$S($L($G(^TMP("RAE",$J,ORDT,ORJ,"facility"))):^("facility"),1:ORSITE)
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",1)="1^"_SITE ;Station ID
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",2)="2^"_$$DATE^ORDVU($P(ORX0,U)) ;date
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",3)="3^"_$P(ORX0,U,2) ;procedure
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",4)="4^"_$P(ORX0,U,4) ;report status
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",5)="5^"_$P(ORX0,U,7) ;cpt code
        .. D SPMRG^ORDVU($NA(^TMP("RAE",$J,ORDT,ORJ,"I")),$NA(^TMP("ORDATA",$J,ORCNT,"WP",6)),6) ;impression
        .. I $O(^TMP("RAE",$J,ORDT,ORJ,"I",0)) S ^TMP("ORDATA",$J,ORCNT,"WP",8)="8^[+]" ;flag for detail
        K ^TMP("RAE",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
RR(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)             ;Radiology report
        ;External Calls: MAIN^GMTSRAE(2)
        I $L($T(GCPR^OMGCOAS1)) D  ; Call if FHIE station 200
        . N BEG,END,MAX
        . Q:'$G(ORALPHA)  Q:'$G(OROMEGA)
        . S MAX=$S(+$G(ORMAX)>0:ORMAX,1:999)
        . S BEG=9999999-OROMEGA,END=9999999-ORALPHA
        . D GCPR^OMGCOAS1(DFN,"RR",BEG,END,MAX)
        N ORDT,ORX0,ORJ,ORCNT,GMDATA,GMTSI,GMW,MAX,TEST,GMTSNDM,GMTS1,GMTS2,ORSITE,SITE,GO,ORMORE
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        K ^TMP("ORDATA",$J)
        S GMTSNDM=$S(+$G(ORMAX)>0:ORMAX,1:999),GMTS1=OROMEGA,GMTS2=ORALPHA
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        I '$L($T(GCPR^OMGCOAS1)) D
        . K ^TMP("RAE",$J)
        . D @GO
        S ORDT=GMTS1,ORCNT=0
        F  S ORDT=$O(^TMP("RAE",$J,ORDT)) Q:(ORDT'>0)  D
        . S ORJ=0 F  S ORJ=$O(^TMP("RAE",$J,ORDT,ORJ)) Q:'ORJ  D
        .. S ORCNT=ORCNT+1,ORMORE=0
        .. S ORX0=$G(^TMP("RAE",$J,ORDT,ORJ,0))
        .. S SITE=$S($L($G(^TMP("RAE",$J,ORDT,ORJ,"facility"))):^("facility"),1:ORSITE)
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",1)="1^"_SITE ;Site ID
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",2)="2^"_$$DATE^ORDVU($P(ORX0,U)) ;date
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",3)="3^"_$P(ORX0,U,2) ;procedure
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",4)="4^"_$S($L($P(ORX0,U,4)):$P(ORX0,U,4),1:"No Report") ;report status
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",5)="5^"_$P(ORX0,U,7) ;cpt code
        .. I $O(^TMP("RAE",$J,ORDT,ORJ,"S",0)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("RAE",$J,ORDT,ORJ,"S")),$NA(^TMP("ORDATA",$J,ORCNT,"WP",6,1)),6) ;reason for study
        .. I $O(^TMP("RAE",$J,ORDT,ORJ,"H",0)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("RAE",$J,ORDT,ORJ,"H")),$NA(^TMP("ORDATA",$J,ORCNT,"WP",7,1)),7) ;clinical history
        .. I $O(^TMP("RAE",$J,ORDT,ORJ,"I",0)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("RAE",$J,ORDT,ORJ,"I")),$NA(^TMP("ORDATA",$J,ORCNT,"WP",8,1)),8) ;impression
        .. I $O(^TMP("RAE",$J,ORDT,ORJ,"R",0)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("RAE",$J,ORDT,ORJ,"R")),$NA(^TMP("ORDATA",$J,ORCNT,"WP",9,1)),9) ;report
        .. I ORMORE S ^TMP("ORDATA",$J,ORCNT,"WP",10)="10^[+]" ;flag for detail
        K ^TMP("RAE",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
RRDOD(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)          ;Radiology report
        ;External Calls: MAIN^GMTSRAE(2)
        ;
        I $L($T(GCPR^OMGCOAS1)) D  ; Call if FHIE station 200
        . N BEG,END,MAX
        . Q:'$G(ORALPHA)  Q:'$G(OROMEGA)
        . S MAX=$S(+$G(ORMAX)>0:ORMAX,1:999)
        . S BEG=9999999-OROMEGA,END=9999999-ORALPHA
        . D GCPR^OMGCOAS1(DFN,"RR",BEG,END,MAX)
        ;
        N ORDT,ORX0,ORJ,ORCNT,GMDATA,GMTSI,GMW,MAX,TEST,GMTSNDM,GMTS1,GMTS2,ORSITE,SITE,GO,ORMORE
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        K ^TMP("ORDATA",$J)
        S GMTSNDM=$S(+$G(ORMAX)>0:ORMAX,1:999),GMTS1=OROMEGA,GMTS2=ORALPHA
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        I '$L($T(GCPR^OMGCOAS1)) D
        . K ^TMP("RAE",$J)
        . D @GO
        S ORDT=GMTS1,ORCNT=0
        F  S ORDT=$O(^TMP("RAE",$J,ORDT)) Q:(ORDT'>0)  D
        . S ORJ=0 F  S ORJ=$O(^TMP("RAE",$J,ORDT,ORJ)) Q:'ORJ  D
        .. S ORCNT=ORCNT+1,ORMORE=0
        .. S ORX0=$G(^TMP("RAE",$J,ORDT,ORJ,0))
        .. S SITE=$S($L($G(^TMP("RAE",$J,ORDT,ORJ,"facility"))):^("facility"),1:ORSITE)
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",1)="1^"_SITE ;Site ID
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",2)="2^"_$$DATE^ORDVU($P(ORX0,U)) ;date
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",3)="3^"_$P(ORX0,U,2) ;procedure
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",4)="4^"_$S($L($P(ORX0,U,4)):$P(ORX0,U,4),1:"No Report") ;report status
        .. S ^TMP("ORDATA",$J,ORCNT,"WP",5)="5^"_$P(ORX0,U,7) ;cpt code
        .. I $O(^TMP("RAE",$J,ORDT,ORJ,"H",0)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("RAE",$J,ORDT,ORJ,"H")),$NA(^TMP("ORDATA",$J,ORCNT,"WP",6,1)),6) ;clinical history
        .. I $O(^TMP("RAE",$J,ORDT,ORJ,"I",0)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("RAE",$J,ORDT,ORJ,"I")),$NA(^TMP("ORDATA",$J,ORCNT,"WP",7,1)),7) ;impression
        .. I $O(^TMP("RAE",$J,ORDT,ORJ,"R",0)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("RAE",$J,ORDT,ORJ,"R")),$NA(^TMP("ORDATA",$J,ORCNT,"WP",8,1)),8) ;report
        .. I ORMORE S ^TMP("ORDATA",$J,ORCNT,"WP",9)="9^[+]" ;flag for detail
        K ^TMP("RAE",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
RS(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)      ;Radiology status
        ;External calls: GET^GMTSRAD
        N ORSITE,SITE,CNT,ORDT,ORDA,ORDA2,REC,GMTSEND,GMTSBEG,GO,STAT
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S GMTSBEG=ORDBEG,GMTSEND=ORDEND
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        K ^TMP("GMTSRAD",$J)  ;DBIA 4333
        D @GO
        S CNT=0,ORDT=OROMEGA
        F  S ORDT=$O(^TMP("GMTSRAD",$J,ORDT)) Q:(ORDT'>0)!(ORDT>ORALPHA)!(CNT'<ORMAX)  D
        .S ORDA=0
        .F  S ORDA=$O(^TMP("GMTSRAD",$J,ORDT,ORDA)) Q:'ORDA!(CNT'<ORMAX)  D
        ..S ORDA2=0
        ..F  S ORDA2=$O(^TMP("GMTSRAD",$J,ORDT,ORDA,ORDA2)) Q:'ORDA2!(CNT'<ORMAX)  S REC=^(ORDA2),STAT=$P(REC,"^",2) D
        ...S CNT=CNT+1
        ...S SITE=$S($L($G(^TMP("GMTSRAD",$J,ORDT,ORDA,ORDA2,"facility"))):^("facility"),1:ORSITE)
        ...S ^TMP("ORDATA",$J,ORDT,"WP",1)="1^"_SITE
        ...S ^TMP("ORDATA",$J,ORDT,"WP",2)="2^"_$$DATE^ORDVU($P(REC,"^"))
        ...S ^TMP("ORDATA",$J,ORDT,"WP",3)="3^"_$S(STAT="d":"Discontinued",STAT="c":"Complete",STAT="h":"Hold",STAT="p":"Pending",STAT="a":"Active",STAT="s":"Scheduled",STAT="u":"Unreleased",1:STAT)
        ...S ^TMP("ORDATA",$J,ORDT,"WP",4)="4^"_$P(REC,"^",3)
        ...S ^TMP("ORDATA",$J,ORDT,"WP",5)="5^"_$$DATE^ORDVU($P(REC,"^",4))
        ...S ^TMP("ORDATA",$J,ORDT,"WP",6)="6^"_$P(REC,"^",5)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
RAD1    ;Get radiology impression
        D MAIN^GMTSRAE(1)
        Q
RAD2    ;Get radiology report
        D MAIN^GMTSRAE(2)
        Q
