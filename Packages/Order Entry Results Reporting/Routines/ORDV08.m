ORDV08  ;DAN/SLC Testing new component ;8/22/01  11:30
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**109,120,243**;Dec 17,1997;Build 242
        ;
RIM(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)            ;Radiology report
        ;External Calls: MAIN^GMTSRAE(2),RPT^ORWRA
        N ORX0,ORCNT,ORSITE,SITE,GO,ORMORE,ORROOT
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        K ^TMP("ORDATA",$J),^TMP("ORXPND",$J)
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        D @GO
        S ORCNT=0
        F  S ORCNT=$O(^TMP($J,"ORAEXAMS",ORCNT)) Q:'ORCNT  D
        . S ORMORE=0
        . S ORX0=$G(^TMP($J,"ORAEXAMS",ORCNT))
        . D RPT^ORWRA(.ORROOT,DFN,$P(ORX0,U))
        . S SITE=$S($L($G(^TMP($J,"ORAEXAMS",ORCNT,"facility"))):^("facility"),1:ORSITE)
        . S ^TMP("ORDATA",$J,ORCNT,"WP",1)="1^"_SITE ;Site ID
        . S ^TMP("ORDATA",$J,ORCNT,"WP",2)="2^"_$$DATE^ORDVU($P(ORX0,U,2)) ;date
        . S ^TMP("ORDATA",$J,ORCNT,"WP",3)="3^"_$P(ORX0,U,3) ;procedure
        . S ^TMP("ORDATA",$J,ORCNT,"WP",4)="4^"_$P(ORX0,U,5) ;report status
        . S ^TMP("ORDATA",$J,ORCNT,"WP",5)="5^"_$P(ORX0,U,4) ;Case #
        . I $O(^TMP("ORXPND",$J,0)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("ORXPND",$J)),$NA(^TMP("ORDATA",$J,ORCNT,"WP",6,1)),6) ;clinical history
        . I ORMORE S ^TMP("ORDATA",$J,ORCNT,"WP",7)="7^[+]" ;flag for detail
        . S ^TMP("ORDATA",$J,ORCNT,"WP",8)="8^"_$P(ORX0,U,14) ;Image available
        . S ^TMP("ORDATA",$J,ORCNT,"WP",9)="9^"_"i"_$P(ORX0,U,1)  ;EXAM ID
        K ^TMP("RAE",$J),^TMP("ORXPND",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
        ;
IGET    ;Get imaging exams
        N ORROOT,ORRADATA,I,ID
        S ORRADATA=$NA(^TMP($J,"RAE1",DFN))
        S ORROOT=$NA(^TMP($J,"ORAEXAMS"))
        K @ORRADATA,@ORROOT
        D EN1^RAO7PC1(DFN,ORDBEG,ORDEND,ORMAX) ;call to Radiology to get exams
        S I=0,ID=""
        F  S ID=$O(@ORRADATA@(ID)) Q:ID=""  D
        . S I=I+1
        . S @ORROOT@(I)=ID_U_(9999999.9999-ID)_U_@ORRADATA@(ID)
        K @ORRADATA
        Q
        ;
MPRO(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)    ;Medicine Procedures
        N ORSITE,ORI,ORREC,ORMORE,ORDATE,SITE,ORARRAY,ORPROC,ORSUM
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        K ^TMP("ORDATA",$J),^TMP("ORTEMP",$J),^TMP("MCAR",$J)
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        D @GO
        S ORI=0
        F  S ORI=$O(^TMP("MCAR",$J,ORI)) Q:'ORI!(ORI>ORMAX)  D
        .K ^TMP("ORTEMP",$J) D GETREC^ORDV08A(ORI,80,20,56,3)
        .S SITE=$S($L($G(^TMP("MCAR",$J,ORI,"facility"))):^("facility"),1:ORSITE)
        .S ^TMP("ORDATA",$J,ORI,"WP",1)="1^"_SITE ;Site ID
        .S ^TMP("ORDATA",$J,ORI,"WP",2)="2^"_$$DATEMMM^ORDVU(ORDATE) ;Procedure date/time
        .S ^TMP("ORDATA",$J,ORI,"WP",3)="3^"_ORPROC ;Procedure Name
        .S ^TMP("ORDATA",$J,ORI,"WP",4)="4^"_$S(ORSUM'="":ORSUM,1:"No Summary") ;Summary
        .I $D(^TMP("ORTEMP",$J)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("ORTEMP",$J)),$NA(^TMP("ORDATA",$J,ORI,"WP",5,1)),5) ;Detailed Report
        .I ORMORE S ^TMP("ORDATA",$J,ORI,"WP",6)="6^[+]" ;Detailed report flag
        .Q
        K ^TMP("ORTEMP",$J),^TMP("MCAR",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
MGET    ;Get medicine results
        D HSUM^GMTSMCMA(DFN,ORDBEG,ORDEND,ORMAX,"","F")
        Q
DIETNS(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)  ;Nutrition assessment
        ;External Calls:SITE^VASITE, NUTR^ORWRP1, LISTNUTR^ORWPR1,FMTE^XLFDT
        N ORSITE,ORARRAY,ORID,ORCNT,ORMORE,GO,ORDT
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        K ^TMP("ORDATA",$J),^TMP("ORXPND",$J)
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        D @GO
        S ORCNT=0,ORDT=OROMEGA
        F  S ORDT=$O(^TMP($J,"FHADT",DFN,ORDT)) Q:(ORDT'>0)!(ORDT>ORALPHA)!(ORCNT>ORMAX)  D
        . S ORID=$$FMTE^XLFDT(9999999-ORDT,2) ;convert inverse date to external date
        . S ORCNT=ORCNT+1,ORMORE=0
        . D NUTR^ORWRP1(.ORARRAY,DFN,ORID)
        . S ORSITE=$S($L($G(^TMP($J,"FHADT",ORDT,"facility"))):^("facility"),1:ORSITE)
        . S ^TMP("ORDATA",$J,ORCNT,"WP",1)="1^"_ORSITE ;Site ID
        . S ^TMP("ORDATA",$J,ORCNT,"WP",2)="2^"_ORID ;assessment date/time
        . I $O(^TMP("ORXPND",$J,0)) S ORMORE=1 D SPMRG^ORDVU($NA(^TMP("ORXPND",$J)),$NA(^TMP("ORDATA",$J,ORCNT,"WP",3,1)),3) ;assessment report
        . I ORMORE S ^TMP("ORDATA",$J,ORCNT,"WP",4)="4^[+]" ;flag for detail
        K ^TMP($J,"FHADT"),^TMP("ORXPND",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
        ;
GETNS   ;Get nutritional assessments
        D LISTNUTR^ORWRP1(.ORARRAY,DFN)
        Q
