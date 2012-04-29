ORCXPND3        ; SLC/MKB,dcm - Expanded display of Reports ;2/21/01  14:07
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**25,30,43,85,172,243**;Dec 17, 1997;Build 242
        ;
AP      ; -- Retrieve AP results for a specific date/time specimen taken
        ; [alert follow-up, from LABS^ORCXPND1]
        N ORACCNO,ORDTSTKN S ORACCNO=$P(ID,"-"),ORDTSTKN=$P(ID,"-",2)
        I (ORACCNO["CY"!(ORACCNO["SP")!(ORACCNO["EM")!(ORACCNO["AU"))&($L(ORACCNO)>0) D  ;check for valid accession #
        . N ORLRDFN,ORLRSS S ORLRDFN=$$LRDFN^LR7OR1(DFN),ORLRSS=$P($G(XQADATA),U) ;DBIA/ICR #2503
        . K ^TMP("ORAP",$J) D EN^LR7OSAP4("^TMP(""ORAP"",$J)",ORLRDFN,ORLRSS,ORDTSTKN)
        . I '$O(^TMP("ORAP",$J,0)) S ^TMP("ORAP",$J,1,0)="",^TMP("ORAP",$J,2,0)="No Anatomic Pathology report available..."
        . N I S I=0 F  S I=$O(^TMP("ORAP",$J,I)) Q:I<1  S X=^(I,0),LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=X
        . K ^TMP("ORAP",$J)
        Q
        ;
LRA     ; -- Anatomic Pathology Report
        N DFN,Y,I,LRLLOC,LRQ
        D TIT^ORCXPNDR("Anatomic Path Report") Q:$$OS^ORCXPNDR()
        D PREP^ORCXPNDR
        D RPT^ORWRP(.Y,ID,3)
        D ITEM^ORCXPND("Anatomic Path Report")
        S I=3 F  S I=$O(^TMP("ORDATA",$J,1,I)) Q:I<1  S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=^TMP("ORDATA",$J,1,I)
        K ^TMP("ORDATA",$J)
        Q
        ;
LRAA    ; -- Alternate Anatomic Path Report
        N DFN,Y,I,LRLLOC,LRQ
        D TIT^ORCXPNDR("Alternate Anatomic Path Report") Q:$$OS^ORCXPNDR()
        D PREP^ORCXPNDR I $$OS^ORCXPNDR() Q
        D AP^LR7OSUM(ID)
        D ITEM^ORCXPND("Anatomic Pathology Report")
        I '$O(^TMP("LRC",$J,0)) S ^TMP("LRC",$J,1,0)="No Anatomic Pathology reports available..."
        S I=0 F  S I=$O(^TMP("LRC",$J,I)) Q:I<1  S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=^TMP("LRC",$J,I,0)
        K ^TMP("LRC",$J)
        Q
        ;
LRB1    ; -- Blood Bank Report
        N DFN,Y,I,LRBLOOD,LRCAPA,LRDT0,LRLABKY,LRLLOC,LRO,LRPCEVSO,LRPLASMA,LRSERUM,LRT,LRUNKNOW,LRURINE,LRVIDO,LRVIDOF
        D TIT^ORCXPNDR("Blood Bank Report") Q:$$OS^ORCXPNDR()
        D PREP^ORCXPNDR
        D RPT^ORWRP(.Y,ID,2)
        D ITEM^ORCXPND("Blood Bank Report")
        S I=5 F  S I=$O(^TMP("ORDATA",$J,1,I)) Q:I<1  S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=^TMP("ORDATA",$J,1,I)
        K ^TMP("ORDATA",$J)
        Q
        ;
LRB     ; -- A better Blood Bank Report
        N DFN,ORY,I,SUBHEAD
        D TIT^ORCXPNDR("Blood Bank Report")
        S DFN=ID
        D PREP^ORCXPNDR
        I $$GET^XPAR("DIV^SYS^PKG","OR VBECS ON",1,"Q"),$L($T(EN^ORWLR1)),$L($T(CPRS^VBECA3B)) D  Q  ;Transition to VBEC's interface
        . K ^TMP("ORLRC",$J)
        . D EN^ORWLR1(DFN)
        . I '$O(^TMP("ORLRC",$J,0)) S ^TMP("ORLRC",$J,1,0)="",^TMP("ORLRC",$J,2,0)="No Blood Bank report available..."
        . D ITEM^ORCXPND("Blood Bank Report"),BLANK^ORCXPND
        . S I=0 F  S I=$O(^TMP("ORLRC",$J,I)) Q:I'>0  S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=^TMP("ORLRC",$J,I,0)
        . K ^TMP("ORLRC",$J)
        S SUBHEAD("BLOOD BANK")=""
        D EN^LR7OSUM(.ORY,DFN,,,,,.SUBHEAD)
        I '$O(^TMP("LRC",$J,0)) S ^TMP("LRC",$J,1,0)="No Blood Bank report available..."
        D ITEM^ORCXPND("Blood Bank Report"),BLANK^ORCXPND
        S I=0 F  S I=$O(^TMP("LRC",$J,I)) Q:I'>0  S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=^TMP("LRC",$J,I,0)
        K ^TMP("LRC",$J),^TMP("LRH",$J)
        Q
        ;
LRC     ; -- Lab Cumulative
        N DFN,ORY,I,BEG,END,OREND,ORSSTRT,ORSSTOP
        D TIT^ORCXPNDR("Lab Cumulative")
        S DFN=ID
        D RANGE($S($G(ORWARD):7,1:180)) Q:OREND  S BEG=+ORSSTRT,END=+ORSSTOP
        D PREP^ORCXPNDR
        D EN^LR7OSUM(.ORY,DFN,BEG,END)
        D ITEM^ORCXPND("Lab Cumulative"),BLANK^ORCXPND
        S I=0 F  S I=$O(^TMP("LRC",$J,I)) Q:I'>0  S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=^TMP("LRC",$J,I,0)
        K ^TMP("LRC",$J),^TMP("LRH",$J)
        Q
        ;
LRG     ; -- Graph Lab Tests
        N DFN,Y,I,X,BCNT,LRSS,LRCW,LRFLAG,LRCTRL,LRNSET,N,LOW,LRPCEVSO,LRPRAC,LRRB,LRTREA,LRVIDO,LRVIDOF,OREND,ORSSTRT,ORSSTOP
        D TIT^ORCXPNDR("Graph Lab Tests") Q:$$OS^ORCXPNDR()
        D RANGE($S($G(ORWARD):7,1:180)) Q:OREND
        S LRSS="CH",LRCW=8,LRFLAG="",LRCTRL=0,(LRNSET,N)=80
        D L2^LRDIST4 Q:'$D(LRTEST)
        D PREP^ORCXPNDR
        D RPT^ORWRP(.Y,ID,8,,,,+ORSSTRT,+ORSSTOP)
        D ITEM^ORCXPND("Lab Graph")
        S I=4,BCNT=0
        F  S I=$O(^TMP("ORDATA",$J,1,I)) Q:I<1  S X=^(I) D
        . I '$L(X) S BCNT=BCNT+1 I BCNT>1 Q
        . S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=X S:$L(X) BCNT=0
        K ^TMP("ORDATA",$J)
        Q
        ;
LRI     ; -- Interim Lab Results
        N ORX,DFN,Y,I,X,BCNT,LREDT,LRIDT,LRLLT,LRPCEVSO,LRPRAC,LRRB,LRTREA,LRVIDO,LRVIDOF,OREND,ORSSTRT,ORSSTOP
        D TIT^ORCXPNDR("Lab Interim Results") Q:$$OS^ORCXPNDR()
        D RANGE($S($G(ORWARD):7,1:180)) Q:OREND
        D SET^LRRP4
        D PREP^ORCXPNDR
        D RPT^ORWRP(.Y,ID,3,,,,+ORSSTRT,+ORSSTOP)
        D ITEM^ORCXPND("Lab Interim Report")
        S I=0,BCNT=0
        F  S I=$O(^TMP("ORDATA",$J,1,I)) Q:I<1  S X=^(I) D
        . I '$L(X) S BCNT=BCNT+1 I BCNT>1 Q
        . S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=X S:$L(X) BCNT=0
        K ^TMP("ORDATA",$J)
        Q
        ;
LRGEN   ;Lab Results by Test
        N DFN,Y,I,II,X,BCNT,LRPRETTY,LREDT,LRLLT,LRPCEVSO,LRPRAC,LRRB,LRTREA,LRVIDO,LRVIDOF,LRCW,LREND,LRTP,LRIX,LRWPL,LRIDT,LRSC,DIC,LRTSTS,LRORD,LRTEST,LRSUB,LRHDR,LRSSP,LRHI,LRLO
        N LBL,LRBLOOD,LRDAT,LRDFN,LRDPF,LRDT0,LREX,LRFFLG,LRFOOT,LRLAB,LRLABKY,LRND,LRNG,LRNOP,LRNOTE,LRODT0,LRONESPC,LRONETST,LRPAGE,LRPARAM,LRPLASMA,LRPP,LRSERUM,LRPS,LRTN,LRUNKNOW,LRURINE,LRWRD,LRX,LRY
        N AGE,I,INC,LRIDT1,LRSV,OREND,ORSSTRT,ORSSTOP
        K ^TMP("LR",$J)
        D TIT^ORCXPNDR("Lab Results by Test") Q:$$OS^ORCXPNDR()
        D RANGE($S($G(ORWARD):7,1:180)) Q:OREND
        D SET^LRGEN
        Q:LREND!'LRTSTS
        D PREP^ORCXPNDR
        D RPT^ORWRP(.Y,ID,16,,,,+ORSSTRT,+ORSSTOP)
        D ITEM^ORCXPND("Lab Results by Test")
        S I=1,BCNT=0
        F  S I=$O(^TMP("ORDATA",$J,1,I)) Q:I<1  S X=^(I) D
        . I '$L(X) S BCNT=BCNT+1 I BCNT>1 Q
        . S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=X S:$L(X) BCNT=0
        K ^TMP("ORDATA",$J)
        Q
        ;
STAT    ; -- Lab test status
        N DFN,Y,I,X,BCNT,OREND,ORSSTRT,ORSSTOP
        D TIT^ORCXPNDR("Lab Test Status") Q:$$OS^ORCXPNDR()
        D RANGE($S($G(ORWARD):7,1:180)) Q:$G(OREND)
        D PREP^ORCXPNDR
        D RPT^ORWRP(.Y,ID,9,,,,+ORSSTRT,+ORSSTOP)
        D ITEM^ORCXPND("Lab Test Status")
        S I=0,BCNT=0
        F  S I=$O(^TMP("ORDATA",$J,1,I)) Q:I<1  S X=$S($D(^(I))#2:^(I),$D(^(I,0))#2:^(0),1:"") D
        . I '$L(X) S BCNT=BCNT+1 I BCNT>1 Q
        . S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=X S:$L(X) BCNT=0
        K ^TMP("ORDATA",$J)
        Q
        ;
RANGE(BEG)      ;Get date range for report
        ;BEG=# of days (T-BEG) for start default
        ;Output: ORSSTRT=Start date/time
        ;        ORSSTOP=Stop date/time
        ;        OREND=1 if user '^'s out, so look for it!
        S BEG=$$FMADD^XLFDT(DT,-$G(BEG)),END=$$NOW^XLFDT
        D RANGE^ORPRS01(BEG,END)
        Q
        ;
MED(MED)        ; -- Medicine Summary of Patient Procedures
        N DFN,Y,I,X,BCNT,OREND,PROCID
        D TIT^ORCXPNDR("Summary of Patient Procedures") Q:$$OS^ORCXPNDR()
        D PREP^ORCXPNDR
        S DFN=+ID,PROCID=$P(MED,"~",2)
        D RPT^ORWRP(.Y,DFN,19,,,PROCID)
        D ITEM^ORCXPND("Summary of Patient Procedures")
        S I=4,BCNT=0
        F  S I=$O(^TMP("ORDATA",$J,1,I)) Q:I<1  S X=^(I) D
        . I '$L(X) S BCNT=BCNT+1 I BCNT>1 Q
        . I $E(X,1,4)="Pg. " Q
        . I X["PHYSICIANS' SIGNATURE" Q
        . S LCNT=LCNT+1,^TMP("ORXPND",$J,LCNT,0)=X S:$L(X) BCNT=0
        K ^TMP("ORDATA",$J)
        Q
