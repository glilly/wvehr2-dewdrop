ORWRP2  ; dcm/slc - Health Summary adhoc RPC's
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,109,212**;Dec 17, 1997;Build 24
BB      ;Continuation of Blood Bank Report
        N DFN,ORY,ORSBHEAD,GCNT
        S DFN=ORDFN,GCNT=0
        K ^TMP("LRC",$J)
        S ROOT=$NA(^TMP("LRC",$J))
        I $$GET^XPAR("DIV^SYS^PKG","OR VBECS ON",1,"Q"),$L($T(EN^ORWLR1)),$L($T(CPRS^VBECA3B)) D  Q  ;Transition to VBEC's interface
        . K ^TMP("ORLRC",$J)
        . D EN^ORWLR1(DFN)
        . I '$O(^TMP("ORLRC",$J,0)) S GCNT=GCNT+1,^TMP("ORLRC",$J,GCNT,0)="",GCNT=GCNT+1,^TMP("ORLRC",$J,GCNT,0)="No VBECS Blood Bank report available..."
        . M ^TMP("LRC",$J)=^TMP("ORLRC",$J)
        . K ^TMP("ORLRC",$J)
        . I $$GET^XPAR("DIV^SYS^PKG","OR VBECS LEGACY REPORT",1,"Q") D
        .. S GCNT=$S($O(^TMP("ORLRC",$J,""),-1):$O(^(""),-1),1:1)
        .. D BLEG
        D BLEG
        Q
BLEG    ;Legacy VISTA Blood Bank Report
        S ORSBHEAD("BLOOD BANK")=""
        D EN^LR7OSUM(.ORY,DFN,,,,,.ORSBHEAD)
        I '$O(^TMP("LRC",$J,0)) S GCNT=GCNT+1,^TMP("LRC",$J,GCNT,0)="",GCNT=GCNT+1,^TMP("LRC",$J,GCNT,0)="No Blood Bank report available..."
        Q
COMP(ORY)       ;Get ADHOC sub components (FILE 142.1)
        ;RPC => ORWRP2 HS COMPONENTS
        ;Y(i)=(1)I;IFN^(2)Component Name [Abb]^(3)Occ Limit^(4)Time Limit^(5)Header Name^
        ;     (6)Hosp Loc Disp^(7)ICD Text Disp^(8)Prov Narr Disp^(9)Summary Order
        D COMP^GMTSADH5(.ORY)
        Q
        ;
COMPABV(ORY)    ;Get ADHOD sub components listed by Abbreviation
        N I,X,X1,X2,X3
        D COMP^GMTSADH5(.ORY)
        S I=0
        F  S I=$O(ORY(I)) Q:'I  S X=ORY(I) D
        . S X1=$P($P(X,"^",2),"["),X1=$E(X1,1,$L(X1)-1),X2=$P($P(X,"^",2),"[",2),X2=$E(X2,1,$L(X2)-1)
        . ;S X3=X2_"     - "_X1_" ",$P(ORY(I),"^",2)=X3
        . S X3=X2_"   - "_$P(X,"^",5)_" ",$P(ORY(I),"^",2)=X3
        Q
COMPDISP(ORY)   ;Get ADHOD sub components listed by Display Name
        N I,X,X1,X2,X3
        D COMP^GMTSADH5(.ORY)
        S I=0
        F  S I=$O(ORY(I)) Q:'I  S X=ORY(I) D
        . S X1=$P($P(X,"^",2),"["),X1=$E(X1,1,$L(X1)-1),X2=$P($P(X,"^",2),"[",2),X2=$E(X2,1,$L(X2)-1)
        . S X3=$P(X,"^",5)_"   ["_X2_"]",$P(ORY(I),"^",2)=X3
        Q
COMPSUB(ORY,ORSUB)      ;Get subitems from a predefined Adhoc component
        I '$L($T(COMPSUB^GMTSADH5)) Q
        D COMPSUB^GMTSADH5(.ORY,ORSUB)
        Q
        ;
SAVLKUP(OK,VAL) ;save Adhoc lookup selection
        N ORERR
        S OK=""
        D EN^XPAR(DUZ_";VA(200,","ORWRP ADHOC LOOKUP",1,VAL,.ORERR)
        I ORERR S OK=VAL_":"_ORERR
        Q
GETLKUP(ORY)    ;Get Adhoc lookup selection
        S ORY=$$GET^XPAR("ALL","ORWRP ADHOC LOOKUP",1,"I")
        Q
FILES(ORY,ORCOMP)       ;Get Files to select from for a component
        ;RPC => ORWRP2 HS COMP FILES
        D FILES^GMTSADH5(.ORY,ORCOMP)
        Q
        ;
FILESEL(OROOT,ORFILE,ORFROM,ORDIR)      ;Get file entries for Combobox
        ;RPC => ORWRP2 HS FILE LOOKUP
        D FILESEL^GMTSADH5(.OROOT,ORFILE,ORFROM,ORDIR)
        Q
        ;
REPORT(OROOT,ORCOMPS,ORDFN)     ;Build Report from array of Components passed in COMPS
        ;RPC => ORWRP2 HS REPORT TEXT
        ;ORCOMPS(i)=array of subcomponents chosen, value is pointer at ^GMT(142,DA(1),1,DA)
        Q:'$G(ORDFN)
        N GMTSEGC,GMTSEG,ORGMTSEG,ORSEGC,ORSEGI
        K ^TMP("ORDATA",$J)
        D REPORT^GMTSADH5(.ORGMTSEG,.ORSEGC,.ORSEGI,.ORCOMPS,.ORDFN)
        Q:'$O(ORGMTSEG(0))
        D START^ORWRP(80,"REPORT1^ORWRP2(.ORGMTSEG,.ORSEGC,.ORSEGI,ORDFN)")
        S OROOT=$NA(^TMP("ORDATA",$J,1))
        Q
REPORT1(GMTSEG,GMTSEGC,GMTSEGI,DFN)     ;
        N GMTS,GMTS1,GMTS2,GMTSAGE,GMTSDOB,GMTSDTM,GMTSLO,GMTSLPG,GMTSPHDR,GMTSPNM,GMTSRB,GMTSSN,GMTSWRD
        N CNT,INC,ORVP,ROOT,SEX,VADM,VAERR,VAIN
        S ORVP=DFN
        D ADHOC^ORPRS13
        Q
        ;
SUBITEM(ORY,ORTEST)     ;Get Subitems for a Test Panel
        ;RPC => ORWRP2 HS SUBITEMS
        D SUBITEM^GMTSADH5(.ORY,ORTEST)
        Q
PREPORT(OROOT,ORCOMPS,ORDFN)    ;Build Report & Print
        ;Called from File|Print on Reports Tab after selecting ADHOC Health Summary
        ;COMPS(i)=array of subcomponents chosen, value is pointer at ^GMT(142,DA(1),1,DA)
        Q:'$G(ORDFN)
        N GMTSEGC,GMTSEG,ORGMTSEG,ORSEGC,ORSEGI
        D REPORT^GMTSADH5(.ORGMTSEG,.ORSEGC,.ORSEGI,.ORCOMPS,.ORDFN)
        Q:'$O(ORGMTSEG(0))
        M GMTSEG=ORGMTSEG,GMTSEGC=ORSEGC,GMTSEGI=ORSEGI
        N GMTS,GMTS1,GMTS2,GMTSAGE,GMTSDOB,GMTSDTM,GMTSLO,GMTSLPG,GMTSPHDR,GMTSPNM,GMTSRB,GMTSSN,GMTSWRD
        N CNT,INC,ORVP,ROOT,SEX,VADM,VAERR,VAIN
        S ORVP=ORDFN
        D ADHOC^ORPRS13
        Q
