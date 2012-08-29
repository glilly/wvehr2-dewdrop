GMTSOBS ; SLC/KER - HS Object - Show                     ; 01/06/2003
        ;;2.7;Health Summary;**58,89**;Oct 20, 1995;Build 61
        ;
        ; External References
        ;    DBIA 10103  $$FMADD^XLFDT
        ;    DBIA 10103  $$NOW^XLFDT
        ;    DBIA 10103  $$FMTE^XLFDT
        ;    DBIA 10104  $$UP^XLFSTR
        ;    DBIA  2056  $$GET1^DIQ  (file #200)
        ;    DBIA 10060  ^VA(200, (read w/fileman)
        ;    DBIA 10086  ^%ZIS
        ;    DBIA 10086  HOME^%ZIS
        ;    DBIA 10089  ^%ZISC
        ;    DBIA 10088  ENDR^%ZISS
        ;    DBIA 10063  ^%ZTLOAD
        ;                  
        Q
DEF(X,GMTSARY)  ; Extract Object Definition/Example
        N GMTSEXT S GMTSEXT="" D SO($G(X)) Q
SO(X)   ; Show Object
        N GMTSNAM,GMTSLBL,GMTSTYP,GMTSHST,GMTSPER,GMTSNOD,GMTSPLB,GMTSNODA
        N GMTSLBB,GMTSRDT,GMTSCON,GMTSRHD,GMTSCHD,GMTSUND,GMTSLIM,GMTSBLK
        N GMTSDEC,GMTSOWN,GMTSCRE,GMTSMOD,GMTSUNT,GMTSLEN,GMTSTIM,GMTSI
        N GMTSO,GMTSL,GMTSDTM,GMTSDED,GMTSDCH,GMTSDCN,GMTSTIM,GMTSWIN,TXT S U="^"
        S GMTSO=$G(^GMT(142.5,+($G(X)),0))
        S GMTSNAM=$P(GMTSO,U,1) Q:'$L(GMTSNAM)
        S GMTSLBL=$P(GMTSO,U,2) S:'$L(GMTSLBL) GMTSLBL="UNSPECIFIED"
        S (GMTSHST,GMTSTYP)=+($P(GMTSO,U,3)) Q:+GMTSTYP=0
        S GMTSTYP=$P($G(^GMT(142,+GMTSTYP,0)),"^",1) Q:'$L(GMTSTYP)
        S GMTSPER=$P(GMTSO,U,4)
        S GMTSLEN=+GMTSPER
        S GMTSUNT=$E(GMTSPER,$L(GMTSPER))
        S:+GMTSUNT>0 GMTSUNT="D"
        ;
        S GMTSNOD=+($P(GMTSO,U,5))
        S GMTSHDR=+($P(GMTSO,U,6))
        S GMTSPLB=+($P(GMTSO,U,7))
        S GMTSLBB=+($P(GMTSO,U,8))
        S GMTSRDT=+($P(GMTSO,U,9))
        S GMTSCON=+($P(GMTSO,U,10))
        S GMTSRHD=+($P(GMTSO,U,11))
        S GMTSCHD=+($P(GMTSO,U,12))
        S GMTSUND=+($P(GMTSO,U,13))
        S GMTSLIM=+($P(GMTSO,U,14))
        S GMTSBLK=+($P(GMTSO,U,15))
        S GMTSDEC=+($P(GMTSO,U,16))
        S GMTSOWN=+($P(GMTSO,U,17)),GMTSOWN=$$GET1^DIQ(200,(+GMTSOWN_","),.01)
        S GMTSCRE=+($P(GMTSO,U,18)),GMTSCRE=$TR($$FMTE^XLFDT(GMTSCRE,"5ZM"),"@"," ")
        S GMTSMOD=+($P(GMTSO,U,19)),GMTSMOD=$TR($$FMTE^XLFDT(GMTSMOD,"5ZM"),"@"," ")
        S GMTSNODA=$G(^GMT(142.5,+$G(X),2))
        S (GMTSTIM,GMTSPER)=$P(GMTSO,"^",4),GMTSTIM=$S($E(GMTSTIM,$L(GMTSTIM))="Y":" year",$E(GMTSTIM,$L(GMTSTIM))="M":" month",$E(GMTSTIM,$L(GMTSTIM))="W":" week",1:" day")
        S:+GMTSPER>1 GMTSTIM=GMTSTIM_"s" S GMTSTIM=+GMTSPER_GMTSTIM
        I $L(GMTSPER) D
        . N GMTSPX1,GMTSPX2,GMTSLEN,GMTSUNT,GMTSDIF
        . S GMTSPX1=$$NOW^XLFDT,GMTSUNT=$E(GMTSPER,$L(GMTSPER)),GMTSLEN=+GMTSPER
        . I +GMTSLEN=0!($L(GMTSUNT)'=1)!("DWMY"'[GMTSUNT) S GMTSPER="" Q
        . S:GMTSUNT="D" GMTSDIF=GMTSLEN S:GMTSUNT="W" GMTSDIF=GMTSLEN*7
        . S:GMTSUNT="M" GMTSDIF=GMTSLEN*30.4 S:GMTSUNT="Y" GMTSDIF=GMTSLEN*365.25
        . S GMTSDIF=$P(GMTSDIF,".",1),GMTSPX2=$$FMADD^XLFDT(GMTSPX1,-(GMTSDIF))
        . S GMTSPX1=$$UP^XLFSTR($$FMTE^XLFDT(GMTSPX1,"ZD"))
        . S GMTSPX2=$$UP^XLFSTR($$FMTE^XLFDT(GMTSPX2,"ZD"))
        . S GMTSWIN=GMTSPER_"   ("_GMTSPX2_" - "_GMTSPX1_")"
        S:'$L(GMTSPER) GMTSPER="UNSPECIFIED"
        S:$L($G(GMTSTIM))&('$L($G(GMTSWIN))) GMTSWIN=$G(GMTSTIM)
        W:$L($G(GMTSHDR(1))) !,GMTSHDR(1)
        W:$L($G(GMTSHDR(2))) !,GMTSHDR(2)
        ;
        S TXT="  OBJECT NAME: "_$G(GMTSNAM)
        D D(TXT)
        S TXT="  HEALTH SUMMARY TYPE:   "_$G(GMTSTYP)
        D D(TXT)
        ;
        S TXT="    REPORT PERIOD: "_$G(GMTSPER),TXT=TXT_$J(" ",(41-$L(TXT)))_"PRINT REPORT DATE/TIME: "_$S(+GMTSHDR>0&(+GMTSRDT>0):"YES",+GMTSHDR'>0:"YES",1:"NO")
        D D(TXT)
        ;
        S TXT="    LABEL: "_$G(GMTSLBL),TXT=TXT_$J(" ",(41-$L(TXT)))_"PRINT CONFIDENTIALITY BANNER: "_$S(+GMTSHDR>0&(+GMTSCON>0):"YES",+GMTSHDR'>0:"YES",1:"NO")
        D D(TXT)
        ;
        S TXT="      PRINT LABEL: "_$S(+GMTSPLB>0:"YES",1:"NO"),TXT=TXT_$J(" ",(41-$L(TXT)))_"PRINT REPORT HEADER: "_$S(+GMTSHDR>0&(+GMTSRHD>0):"YES",+GMTSHDR'>0:"YES",1:"NO")
        D D(TXT)
        ;
        S TXT="      BLANK LINE AFTER LABEL: "_$S(+GMTSLBB>0:"YES",1:"NO"),TXT=TXT_$J(" ",(41-$L(TXT)))_"PRINT COMPONENT HEADER: "_$S(+GMTSHDR>0&(+GMTSCHD>0):"YES",+GMTSHDR'>0:"YES",1:"NO")
        D D(TXT)
        ;
        S TXT="    SUPPRESS COMPONENTS W/O DATA: "_$S(+GMTSNOD>0:"YES",1:"NO")
        S TXT=TXT_$J(" ",(41-$L(TXT)))_"  PRINT TIME-OCCURRENCE LIMITS: "_$S(+GMTSHDR>0&(+GMTSLIM>0):"YES",+GMTSHDR'>0:"YES",1:"NO")
        D D(TXT)
        ;
        S TXT="    SUPPRESS HEADER: "_$S(+GMTSHDR>0:"YES",1:"NO")
        S TXT=TXT_$J(" ",(41-$L(TXT)))_"  UNDERLINE COMPONENT HEADER: "_$S(+GMTSHDR>0&(+GMTSUND>0):"YES",1:"NO")
        D D(TXT)
        ;
        S TXT="    SUPPRESS DECEASED INFORMATION: "_$S(+GMTSHDR>0&(+GMTSDEC>0):"NO",1:"YES")
        S TXT=TXT_$J(" ",(41-$L(TXT)))_"  BLANK LINE AFTER HEADER: "_$S(+GMTSHDR>0&(+GMTSBLK>0):"YES",+GMTSHDR'>0:"YES",1:"NO")
        D D(TXT)
        ;
        S TXT="    OVERWRITE NO DATA AVAILABLE MESSAGE: "_GMTSNODA
        D D(TXT)
        S TXT="    CREATOR: "_GMTSOWN
        S TXT=TXT_$J(" ",(41-$L(TXT)))_"CREATED: "_GMTSCRE
        D D(TXT)
        ;
        S TXT="",TXT=TXT_$J(" ",(41-$L(TXT)))_"LAST MODIFIED: "_GMTSMOD
        D D(TXT)
        ;
        Q:$D(GMTSABRR)
        ;
        S TXT="    EXAMPLE:" D E(TXT)
        S GMTSDTM=$$NOW^XLFDT,GMTSDED=$$FMADD^XLFDT(GMTSDTM,-2000)
        S GMTSDED=$TR($$FMTE^XLFDT($P(GMTSDED,".",1),"2ZM"),"@"," ")
        S GMTSDTM=$TR($$FMTE^XLFDT(GMTSDTM,"2ZM"),"@"," ")
        S GMTSDCH=$$DCH(+($G(GMTSHST))),GMTSDCN=$P(GMTSDCH,"^",2),GMTSDCH=$P(GMTSDCH,"^",1)
        S:'$L(GMTSDCH) GMTSDCH="PN - Progress Notes" S GMTSTIM=$$TIM($G(GMTSPER))
        D:+GMTSHDR>0 SP^GMTSOBS2
        D:+GMTSHDR'>0 HS^GMTSOBS2
        Q
DCH(X)  ; Default Component Header
        N GMTSABR,GMTSDHD,GMTSDCH,GMTSDCN,GMTSTYP S GMTSTYP=+($G(X)),GMTSABR=$O(^GMT(142,+GMTSTYP,1,0))
        S GMTSABR=$G(^GMT(142,+GMTSTYP,1,+GMTSABR,0)),GMTSABR=+($P(GMTSABR,"^",2))
        S GMTSDCN=$P($G(^GMT(142.1,+GMTSABR,0)),"^",1),GMTSDHD=$P($G(^GMT(142.1,+GMTSABR,0)),"^",9),GMTSABR=$P($G(^GMT(142.1,+GMTSABR,0)),"^",4)
        S GMTSDCH=$S($L(GMTSABR)&($L(GMTSDHD)):(GMTSABR_" - "_GMTSDHD),1:"PN - Progress Notes")
        S X=GMTSDCH_"^"_GMTSDCN Q X
TIM(X)  ; Time
        N GMTSTIM,GMTSPER S (GMTSTIM,GMTSPER)=$G(X) S:'$L(GMTSTIM) (GMTSTIM,GMTSPER)="3M"
        S GMTSTIM=$S($E(GMTSTIM,$L(GMTSTIM))="Y":" year",$E(GMTSTIM,$L(GMTSTIM))="M":" month",$E(GMTSTIM,$L(GMTSTIM))="W":" week",1:" day")
        S:+GMTSPER>1 GMTSTIM=GMTSTIM_"s" S GMTSTIM=+GMTSPER_GMTSTIM
        S X=GMTSTIM Q X
        Q
DEV     ; Device
        I +($G(DFN))=0!('$D(^TMP("GMTSOBJ",$J,DFN))) K ^TMP("GMTSOBJ",$J,DFN) Q
        I $D(CAP) D NODEV K ^TMP("GMTSOBJ",$J,DFN) Q
        N ZTRTN,%ZIS,IOP,POP S %ZIS="PQ" D ^%ZIS Q:POP  I $D(IO("Q")) D QUE Q
NOQUE   ; Print without Queuing
        N ZTRTN S ZTRTN="DSP^GMTSOBS"
        I $D(IOST),$D(IOF) W:IOST["C-"&('$D(GMTSNOI)) @IOF
        D @ZTRTN,^%ZISC K ^TMP("GMTSOBJ",$J,DFN) Q
QUE     ; Queued Print
        N %,ZTDESC,ZTDTH,ZTIO,ZTSAVE,ZTSK,ZTRTN S ZTRTN="DSP^GMTSOBS" K IO("Q"),ZTSAVE
        S ZTSAVE("^TMP(""GMTSOBJ"","_$J_","_DFN_",")="" S ZTSAVE("DFN")=""
        S:$D(GMTSHDR) ZTSAVE("GMTSHDR")=""
        S ZTDESC="Display Health Summary Object" S ZTIO=ION,ZTDTH=$H
        D ^%ZTLOAD I '$D(ZTSK) W !!,"Request Cancelled",! H 3 W:$D(IOF) @IOF
        I $D(ZTSK) W !!,"Request Queued",! H 3 W:$D(IOF) @IOF
        K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE D ^%ZISC Q
        Q
NODEV   ; Print without Device Selection
        W !! N ZTRTN,POP,IOP,%ZIS,IOSL S IOSL=99999999999
        S ZTRTN="DSP^GMTSOBS" D @ZTRTN,^%ZISC K ^TMP("GMTSOBJ",$J,DFN)
        Q
DSP     ; Print Health Summary Type
        Q:+($G(DFN))=0  N GMTST,GMTSI,GMTSC,GMTSP,GMTSL,GMTSEXIT,GMTSCR,GMTSPL D HOME^%ZIS
        S GMTSPL=3,GMTSEXIT=0,GMTSP=$G(IOST),GMTSL=+($G(IOSL)) S:+GMTSL=0 GMTSL=24
        D ATTR W !!,$G(BOLD),"<----------------------------- Break in Document ---------------------------->",$G(NORM) S GMTSPL=GMTSPL+1
        W !,$G(BOLD),"<---------------------------- Beginning of Object --------------------------->",$G(NORM) S GMTSPL=GMTSPL+1 D KATTR
        S GMTSI=0 F  S GMTSI=$O(^TMP("GMTSOBJ",$J,DFN,GMTSI)) Q:+GMTSI=0  D
        . W !,$G(^TMP("GMTSOBJ",$J,DFN,GMTSI,0)) S GMTSPL=+GMTSPL+1 D CONT
        K ^TMP("GMTSOBJ",$J,DFN)
        D ATTR W !,$G(BOLD),"<------------------------------ End of Object ------------------------------->",$G(NORM) S GMTSPL=+GMTSPL+1
        W !,$G(BOLD),"<----------------------------- Document Resumes ----------------------------->",$G(NORM) D KATTR S GMTSPL=+GMTSPL+1 S:+GMTSL>0 IOSL=GMTSL
        S GMTSPL=GMTSL D CONT W:GMTSP["P-"&($D(IOF)) @IOF
        Q
D(X)    ; Display
        I '$D(GMTSEXT) W !,$G(X) Q
        N GMTSC S GMTSC=$G(GMTSARY("D",0))+1,GMTSARY("D",+GMTSC)=$G(X),GMTSARY("D",0)=GMTSC
        Q
E(X)    ; Example
        I '$D(GMTSEXT) W !,$G(X) Q
        N GMTSC S GMTSC=$G(GMTSARY("E",0))+1,GMTSARY("E",+GMTSC)=$G(X),GMTSARY("E",0)=GMTSC
        Q
CONT    ; Press <Return> to Continue
        I GMTSP["P-" W:$L($G(IOF))&($D(IOF)) @IOF Q
        Q:(GMTSP["C-"!(GMTSP=""))&(GMTSPL'>(GMTSL-4))  S GMTSPL=0 Q:GMTSEXIT
        N GMTSCR S GMTSPL=0 W !!,"  Press <Return> to Continue  "
        R GMTSCR:660 I '$T!(GMTSCR["^") S GMTSCR="^",GMTSEXIT=1
        W:GMTSP'["P-"&($D(IOF)) @IOF Q
        Q
ATTR    ; Set Screen Attributes
        N X,IOINHI,IOINORM S X="IOINHI;IOINORM" D ENDR^%ZISS S BOLD=$G(IOINHI),NORM=$G(IOINORM)
        Q
KATTR   ; Kill Screen Attributes
        K NORM,BOLD Q
