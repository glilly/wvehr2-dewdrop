ORDV04  ; SLC/DAN/dcm - OE/RR ;7/21/04  15:32
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**109,148,160,208,195,241,215,274,256,243**;Dec 17,1997;Build 242
        ;OE/RR COMPONENT
        ;
        ; ^TMP("GMPLHS",$J) DBIA 1183
        ; ^UTILITY & ^TMP("GMRVD") DBIA 10061
        ;
ORC(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)     ; Current Orders
        ;Calls EN^ORQ1, ^OR(100
        N ORCNT,ORJ,ORSITE,SITE,ORX0,ORLIST,GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        K ^TMP("ORR",$J),^TMP("ORDATA",$J)
        D @GO
        I '$D(^TMP("ORR",$J)) Q
        S ORCNT=0,ORJ=0
        F  S ORJ=$O(^TMP("ORR",$J,ORLIST,ORJ)) Q:'+ORJ!(ORCNT'<ORMAX)  S ORX0=^(ORJ) D
        . S ORCNT=ORCNT+1,SITE=$S($L($G(^TMP("ORR",$J,ORLIST,ORJ,"facility"))):^("facility"),1:ORSITE)
        . S ^TMP("ORDATA",$J,ORLIST,ORJ,"WP",1)="1^"_SITE ;Station ID
        . D SPMRG^ORDVU("^TMP(""ORR"","_$J_","""_ORLIST_""","_ORJ_",""TX"")","^TMP(""ORDATA"","_$J_","""_ORLIST_""","_ORJ_",""WP"",2)",2) ;order text
        . S ^TMP("ORDATA",$J,ORLIST,ORJ,"WP",3)="3^"_$P(ORX0,"^",6) ; status
        . S ^TMP("ORDATA",$J,ORLIST,ORJ,"WP",4)="4^"_$$DATE^ORDVU($P(ORX0,"^",4)) ;start date
        . S ^TMP("ORDATA",$J,ORLIST,ORJ,"WP",5)="5^"_$$DATE^ORDVU($P(ORX0,"^",5)) ;stop date
        . S ^TMP("ORDATA",$J,ORLIST,ORJ,"WP",7)="7^"_$P(^TMP("ORR",$J,ORLIST,ORJ),U) ;Order Number
        . I $O(^TMP("ORR",$J,ORLIST,ORJ,"TX",1)) S ^TMP("ORDATA",$J,ORLIST,ORJ,"WP",6)="6^[+]" ;flag for details
        K ^TMP("ORR",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
ORCVA   ;Current Orders
        N ORVP
        S ORVP=DFN_";DPT("
        I '$D(^OR(100,"AC",ORVP)) Q
        D EN^ORQ1(ORVP,,2,,ORDBEG,ORDEND,1) ;get current orders. ORLIST is set in ORQ1
        Q
PLAILALL(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)        ;Problem list API returns ALL problems
        N GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        D PLAIL
        Q
PLALL   ;All Problems
        D GETLIST^GMPLHS(DFN,"ALL")
        Q
PLAILI(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)  ;Problem list API returns INACTIVE problems
        N GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        D PLAIL
        Q
PLI     ;Inactive Problems
        D GETLIST^GMPLHS(DFN,"I")
        Q
PLAILA(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)  ;Problem list API returns ACTIVE problems
        N GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        D PLAIL
        Q
PLA     ;Active Problems
        D GETLIST^GMPLHS(DFN,"A")
        Q
PLAIL   ;problems(active, inactive or all)
        ;External calls to ^GMPLHS
        ; input:
        ;   STATUS = "A"   active problems
        ;   STATUS = "I"   inactive problems
        ;   STATUS = "ALL" all problems
        ;
        I $L($T(GCPR^OMGCOAS1)) D  Q  ; Call if FHIE station 200
        . S ORDBEG=0,ORDEND=9999999,ORMAX=99999
        . D GCPR^OMGCOAS1(DFN,"PLL",ORDBEG,ORDEND,ORMAX)
        . S ROOT=$NA(^TMP("ORDATA",$J))
        N ORPROBNO,ORXREC0,ORLOC,I,K,X,ORSITE,SITE,ORMORE
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        K ^TMP("ORDATA",$J),^TMP("GMPLHS",$J)  ;DBIA #1183
        D @GO
        I '$D(^TMP("GMPLHS",$J)) Q
        S ORPROBNO=0
        F I=1:1 S ORPROBNO=$O(^TMP("GMPLHS",$J,ORPROBNO)) Q:'ORPROBNO  D
        . S ORXREC0=$G(^TMP("GMPLHS",$J,ORPROBNO,0)),ORMORE=0
        . S SITE=$S($L($G(^TMP("GMPLHS",$J,ORPROBNO,"facility"))):^("facility"),1:ORSITE)
        . S ^TMP("ORDATA",$J,ORPROBNO,"WP",1)="1^"_SITE ;Station ID
        . S ^TMP("ORDATA",$J,ORPROBNO,"WP",2)="2^"_$P(ORXREC0,U,5) ;status
        . S ^TMP("ORDATA",$J,ORPROBNO,"WP",3)="3^"_$G(^TMP("GMPLHS",$J,ORPROBNO,"N")) ;provider narrative
        . S ^TMP("ORDATA",$J,ORPROBNO,"WP",4)="4^"_$$DATE^ORDVU($P(ORXREC0,U,6)) ;onset date
        . S ^TMP("ORDATA",$J,ORPROBNO,"WP",5)="5^"_$$DATE^ORDVU($P(ORXREC0,U,2)) ;last modified date
        . S ^TMP("ORDATA",$J,ORPROBNO,"WP",6)="6^"_$P(ORXREC0,U,7) ;provider
        . S ORLOC=0,K=0
        . F  S ORLOC=$O(^TMP("GMPLHS",$J,ORPROBNO,"C",ORLOC)) Q:'ORLOC  D
        .. S X=0
        .. F  S X=$O(^TMP("GMPLHS",$J,ORPROBNO,"C",ORLOC,X)) Q:'X  D
        ... S K=K+1,ORMORE=1
        ... S ^TMP("ORDATA",$J,ORPROBNO,"WP",7,K)="7^"_$P($G(^TMP("GMPLHS",$J,ORPROBNO,"C",ORLOC,X,0)),U) ;note narrative
        . S ^TMP("ORDATA",$J,ORPROBNO,"WP",8)="8^"_$P(ORXREC0,U,14) ;exposures
        . I ORMORE S ^TMP("ORDATA",$J,ORPROBNO,"WP",9)="9^[+]" ;flag for details
        K ^TMP("GMPLHS",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
SR(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)      ;Surgery Report
        ;Call ^ORDV04A
        N ORCNT
        S ORCNT=0
        K ^TMP("ORDATA",$J)
        D ENSR^ORDV04A
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
VS(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)      ; get vital Signs
        D VS^ORDV04A
        Q
TIUPRG(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)  ;  TIU version of progress reports
        ;Calls to TIUSRVLO,TIUSRVR1,VASITE
        I $L($T(GCPR^OMGCOAS1)) D  Q  ; Call if FHIE station 200
        . D GCPR^OMGCOAS1(DFN,"PN",ORDBEG,ORDEND,ORMAX)
        . S ROOT=$NA(^TMP("ORDATA",$J))
        N ORDT,DATE,ORCI,ORGLOB,ORGLOBA,ORTEMP,ORSITE,SITE,I,ORNODE,GO,ORIMAG
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        D @GO
        I '$D(@ORGLOB) Q
        S ORNODE=0,ORCI=0
        K ^TMP("ORDATA",$J)
        F  S ORNODE=$O(@ORGLOB@(ORNODE)) Q:'ORNODE!(ORCI'<ORMAX)  D
        . S ORTEMP=@ORGLOB@(ORNODE)
        . S ORIMAG=$P($$RESOLVE^TIUSRVLO($P(ORTEMP,U)),U,10)
        . S DATE=$P(ORTEMP,U,3)       ;date
        . S SITE=$S($L($G(@ORGLOB@(ORNODE,"facility"))):^("facility"),1:ORSITE)
        . S ^TMP("ORDATA",$J,ORNODE,"WP",1)="1^"_SITE ;Station ID
        . S ^TMP("ORDATA",$J,ORNODE,"WP",2)="2^"_$P(ORTEMP,U) ;TIU ien
        . S ^TMP("ORDATA",$J,ORNODE,"WP",3)="3^"_$$DATE^ORDVU(DATE) ;date
        . S ^TMP("ORDATA",$J,ORNODE,"WP",4)="4^"_$P(ORTEMP,U,2) ;type
        . S ^TMP("ORDATA",$J,ORNODE,"WP",5)="5^"_$P($P(ORTEMP,U,5),";",2) ;author
        . S ORCI=ORCI+1
        . D TGET^TIUSRVR1(.ORGLOBA,$P(ORTEMP,U)) ;Call back to get note text
        . D SPMRG^ORDVU($NA(@ORGLOBA),$NA(^TMP("ORDATA",$J,ORNODE,"WP",6)),6) ;Notes Text
        . I $O(@ORGLOBA@(0)) S ^TMP("ORDATA",$J,ORNODE,"WP",7)="7^[+]"
        . S ^TMP("ORDATA",$J,ORNODE,"WP",8)="8^"_ORIMAG
        . K @ORGLOBA
        K @ORGLOB
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
TPRG    ;TIU Progress Notes
        D CONTEXT^TIUSRVLO(.ORGLOB,3,5,DFN,ORDBEG,ORDEND,,ORMAX)
        Q
TIUDCS(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)  ;  Discharge Summaries
        ;Calls VASITE, DIQ1, TIUSRVLO
        I $L($T(GCPR^OMGCOAS1)) D  Q  ; Call if FHIE station 200
        . D GCPR^OMGCOAS1(DFN,"DS",ORDBEG,ORDEND,ORMAX)
        . S ROOT=$NA(^TMP("ORDATA",$J))
        N ORGLOB,ORGLOBA,ORI,ORNODE,ORICDIEN,ORARRAY,ORTEMP,ORSITE,SITE,DIC,DR,DIQ,DA,GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        D @GO
        I '$D(@ORGLOB) Q
        K ^TMP("ORDATA",$J)
        S ORNODE=0,ORI=0
        F  S ORNODE=$O(@ORGLOB@(ORNODE)) Q:'ORNODE!(ORI'<ORMAX)  D
        . S ORTEMP=@ORGLOB@(ORNODE)
        . S SITE=$S($L($G(@ORGLOB@(ORNODE,"facility"))):^("facility"),1:ORSITE)
        . S ^TMP("ORDATA",$J,ORNODE,"WP",1)="1^"_SITE ;Station ID
        . K ORARRAY S DIC=8925,DA=$P(ORTEMP,U),DR=".05;.07;.08;1202;1502",DIQ="ORARRAY"
        . D EN^DIQ1
        . S DIQ="ORARRAY(8925,"_DA_")"
        . S ^TMP("ORDATA",$J,ORNODE,"WP",2)="2^"_$$DATEMMM^ORDVU($G(@DIQ@(.07))) ;episode begin date/time
        . S ^TMP("ORDATA",$J,ORNODE,"WP",3)="3^"_$$DATEMMM^ORDVU($G(@DIQ@(.08))) ;episode end date/time
        . S ^TMP("ORDATA",$J,ORNODE,"WP",4)="4^"_$G(@DIQ@(1202)) ;author/dicator
        . S ^TMP("ORDATA",$J,ORNODE,"WP",5)="5^"_$G(@DIQ@(1502)) ;signed by
        . S ^TMP("ORDATA",$J,ORNODE,"WP",6)="6^"_$G(@DIQ@(.05)) ;status
        . S ORI=ORI+1
        . D TGET^TIUSRVR1(.ORGLOBA,$P(ORTEMP,U)) ;Call to get summary text
        . D SPMRG^ORDVU($NA(@ORGLOBA),$NA(^TMP("ORDATA",$J,ORNODE,"WP",7)),7) ;summary Text
        . I $O(@ORGLOBA@(0)) S ^TMP("ORDATA",$J,ORNODE,"WP",8)="8^[+]" ;detail flag
        . K @ORGLOBA
        K @ORGLOB
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
TDCS    ;TIU Discharge Summary
        D CONTEXT^TIUSRVLO(.ORGLOB,244,5,DFN,ORDBEG,ORDEND,,ORMAX)
        Q
