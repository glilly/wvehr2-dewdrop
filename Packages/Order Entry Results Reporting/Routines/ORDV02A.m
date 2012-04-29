ORDV02A ; slc/dcm - OE/RR Report Extracts ; 10/8/03 11:18
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;LAB Components
EM(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)           ;Electron Microscopy
        ;External references to ^DPT(DFN,"LR"), ^ORDVX1,
        ;
        S OROMEGA=1,ORALPHA=9999999,ORMAX=9999
        I $L($T(GCPR^OMGCOAS1)) D  ; Call if FHIE station 200
        . N BEG,END
        . Q:'$G(ORALPHA)  Q:'$G(OROMEGA)
        . S ORMAX=$S(+$G(ORMAX)>0:ORMAX,1:999)
        . S BEG=9999999-OROMEGA,END=9999999-ORALPHA
        . D GCPR^OMGCOAS1(DFN,"EM",BEG,END,ORMAX)
        D GET
        Q
CY(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)           ;Cytology
        ;External references to ^DPT(DFN,"LR"), ^ORDVX1,
        ;
        S OROMEGA=1,ORALPHA=9999999,ORMAX=9999
        I $L($T(GCPR^OMGCOAS1)) D  ; Call if FHIE station 200
        . N BEG,END
        . Q:'$G(ORALPHA)  Q:'$G(OROMEGA)
        . S ORMAX=$S(+$G(ORMAX)>0:ORMAX,1:999)
        . S BEG=9999999-OROMEGA,END=9999999-ORALPHA
        . D GCPR^OMGCOAS1(DFN,"CY",BEG,END,ORMAX)
        D GET
        Q
SP(ROOT,ORALPHA,OROMEGA,ORMAX,ORDBEG,ORDEND,OREXT)           ;Surgical Pathology
        ;External references to ^DPT(DFN,"LR"), ^ORDVX1,
        ;
        S OROMEGA=1,ORALPHA=9999999,ORMAX=9999
        I $L($T(GCPR^OMGCOAS1)) D  ; Call if FHIE station 200
        . N BEG,END
        . Q:'$G(ORALPHA)  Q:'$G(OROMEGA)
        . S ORMAX=$S(+$G(ORMAX)>0:ORMAX,1:999)
        . S BEG=9999999-OROMEGA,END=9999999-ORALPHA
        . D GCPR^OMGCOAS1(DFN,"SP",BEG,END,ORMAX)
        D GET
        Q
        ;
GET     ;Get data
        N ORDT,ORX0,ORCNT,GMI,LRDFN,IX,X,IX0,ORSITE,ORSS,SITE,GO
        Q:'$L(OREXT)
        S GO=$P(OREXT,";")_"^"_$P(OREXT,";",2)
        Q:'$L($T(@GO))
        S LRDFN=+$G(^DPT(DFN,"LR"))
        Q:'LRDFN
        S ORMAX=$S(+$G(ORMAX)>0:ORMAX,1:999)
        S ORSITE=$$SITE^VASITE,ORSITE=$P(ORSITE,"^",2)_";"_$P(ORSITE,"^",3)
        K ^TMP("ORDATA",$J)
        I '$L($T(GCPR^OMGCOAS1)) D
        . K ^TMP("OROOT",$J)
        . D @GO
        S ORDT=OROMEGA,ORCNT=0
        F  S ORDT=$O(^TMP("OROOT",$J,ORDT)) Q:(ORDT'>0)!(ORDT>ORALPHA)!(ORCNT>ORMAX)  D
        . S ORSS="" F  S ORSS=$O(^TMP("OROOT",$J,ORDT,ORSS)) Q:ORSS=""!(ORCNT>ORMAX)  S ORX0=^(ORSS,0) D
        .. S SITE=$S($L($G(^TMP("OROOT",$J,ORDT,ORSS,"facility"))):^("facility"),1:ORSITE)
        .. S ^TMP("ORDATA",$J,ORDT_ORSS,"WP",1)="1^"_SITE ;Station ID
        .. S ^TMP("ORDATA",$J,ORDT_ORSS,"WP",2)="2^"_$P(ORX0,U) ;collection date
        .. S ^TMP("ORDATA",$J,ORDT_ORSS,"WP",4)="4^"_$P(ORX0,U,2) ;accession number
        .. D SPMRG^ORDVU("^TMP(""OROOT"","_$J_","_ORDT_","_""""_ORSS_""""_",.1)","^TMP(""ORDATA"","_$J_","_""""_ORDT_ORSS_""""_",""WP"",3)",3) ;specimen
        .. D SPMRG^ORDVU("^TMP(""OROOT"","_$J_","_ORDT_","_""""_ORSS_""""_",.2)","^TMP(""ORDATA"","_$J_","_""""_ORDT_ORSS_""""_",""WP"",5)",5) ;report text
        .. S ^TMP("ORDATA",$J,ORDT_ORSS,"WP",6)="6^[+]",ORCNT=ORCNT+1 ;flag for detail
        K ^TMP("OROOT",$J)
        S ROOT=$NA(^TMP("ORDATA",$J))
        Q
