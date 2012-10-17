LRCAPBV ;DALOI/FHS - PROCESS VBECS WORKLOAD API ; 4/17/07 3:53am
        ;;5.2;LAB SERVICE;**325**;Sep 27, 1994;Build 34
        ;Reference to $$FIND1^DIC supported by IA #2051
        ;Reference to FILE^DID supported by IA #2052
        ;Reference to FILE^DIE supported by IA #2053
        ;Reference to GETS^DIQ supported by IA #2056
        ;Reference to $$GET^XUA4A72 supported by IA #1625
        ;Reference to $$WKLDCAP^VBECA7 supported by IA #4767
        ;Reference to UPDTWKLD^VBECA7 supported by IA #4767
EN      ;Will only run if VBECS BUNDLE 1.0 is installed.
        Q:'($D(^VBEC(6002.01,0)))
BBLOOK  ;
LOCK    L +^XTMP("BVEC WKLD"):10 G:'$T LOCK
        Q:$G(^XTMP("BVEC WKLD",0))=+$H  S ^XTMP("BVEC WKLD",0)=+$H
        N ANS,ANX
        N D1,D2,DFN,ERR,FILE,IEN,LRAA,LRACC,LRADT,LRAN,LRACPABV,LRCC
        N LRCDT,LRCNT,LRCTM,LRD65,LRDAA,LRDFN,LRDIV,LRDLOC,LRDPRO,LRDSUF
        N LRE655,LREDT,LRERR,LRESCPT,LRFDA,LRFILE,LRFNUM,LRIDT
        N LRII,LRIN,LRLD,LRLOG,LRLSS,LRMA,LRNLT,LROA,LROAD,LROAD1,LROAD2
        N LROL,LRPKG,LRREC,LRRRL,LRRRL1,LRRRL3,LRRRL4,LRSUF,LRTEC,LRTS
        N LRTST,LRTSTP,LRTYPE,LRUG,LRUID,LRUNIT,LRWA,LRWKLAA,LRZCNT,X,Y
        N LRCAPBV,LRDPF,LRNP,LRUA,LRRRL2,LRSN,LRSPEC,LRSTATUS,LRVSITN
        N LRTSTU,LRTSQA,LRTSTD
GET     ;Call VBECS 6002.01 data populating API
        S ANS=$$WKLDCAP^VBECA7
        G:ANS'=1 END
        S LRCAPBV=1,LRESCPT=0
DLOC    ;Get default location and provider
        D GETS^DIQ(69.9,"1,",".8;617","I","ANS","ERR")
        S LRDLOC=$G(ANS(69.9,"1,",.8,"I"))
        S LRDPRO=$G(ANS(69.9,"1,",617,"I"))
        I $$GET^XUA4A72(LRDPRO)<1 G END
        S:'$G(LRIEN) LRIEN=0
LK1     ;Set default values
        S LRPKG=$$FIND1^DIC(9.4,"","O","LAB SERVICE","B","","ANS")
        I LRPKG<1 S ERR=9.4
        S LRDAA=$$FIND1^DIC(68,"","O","BLOOD BANK","B","","ANS")
        S:'LRDAA LRDAA=29
        S LRD65=$$FIND1^DIC(65,"","B","VBECS1","B","","ANS")
        S LRDSUF=$$FIND1^DIC(64.2,"","O","GENERIC","B","","ANS")
        I '$G(LRD65) S LRSTATUS="LRD(65 missing",LRERR="Failed lookup" D  G END
        . S ERR=65 D EUPDATE
TST     ;Get default tests names
        S LRTSTQA=$$FIND1^DIC(60,,"B","VBEC QA/QC","B",,"ANS")
        S LRTSTU=$$FIND1^DIC(60,,"B","VBEC UNIT PROCESSING","B",,"ANS")
        S LRTSTD=$$FIND1^DIC(60,,"B","VBEC DONOR","B",,"ANS")
        I $S('LRTSTQA:1,'LRTSTU:1,'LRTSTD:1,1:0) D  G END
        . S ERR=$S('LRTSTQA:"VBEC QA/QC ",'LRTSTU:"VBEC UNIT PROCESSING",1:"VBEC DONOR") D EUPDATE
        Q:$G(LRDBUG)
DPROV   ;Set default PCE Provider
LOOP    ;Find entries with the status of pending.
        F  S LRIEN=$O(^VBEC(6002.01,"AC","P",LRIEN)) Q:LRIEN<1  D BBDIQ
        Q:$G(LRDBUG)
        I $D(ZTQUEUED) S ZTREQ="@"
END     ;
        L -^XTMP("BVEC WKLD")
        ;Call VBECS update API
        D UPDTWKLD^VBECA7
        K LRIEN
        Q
BBDIQ   ;Gather entry info
        I $G(LRDBUG) W !,LRIEN
        K ANS,ANX,ERR,FILE,LRFDA
        K ^VBEC(6002.01,LRIEN,"ERR")
        S FILE=6002.01,IEN=LRIEN_","
        D GETS^DIQ(FILE,IEN,"**","IN","ANS","ERR")
        D ERR Q:$G(ERR)
        S LRFDA(6002.01,LRIEN_",",5)="I"
        D FILE^DIE("S","LRFDA","ERR")
        D LRAA
        Q:$G(ERR)
        S:$G(LRWKLAA) (LRMA,LRWA,LRLSS)=LRWKLAA
        S LRCDT=$P(ANS(6002.01,LRIEN_",",3,"I"),".")
        S LRCTM=$P(ANS(6002.01,LRIEN_",",3,"I"),".",2)
        D ^LRCAPV3
        K LRFDA S LRFDA(6002.01,LRIEN_",",5)="S"
        S LRFDA(6002.01,LRIEN_",",4)=$$NOW^XLFDT
        D FILE^DIE("S","LRFDA","ERR")
PCEFILE ;File PCE if outpatient location
        Q:$S(LRRRL4="W":0,LRRRL4="O":0,1:1)
        I $G(DFN) D
        . D EN^LRCAPBV1(LRADT,LRTEC,LRTST,LRDSSLOC,LRDSSID,LRIN,DFN,LRPRO,LRCNT)
        Q
ERR     ;Check entry for critical data
        I $G(ERR) S LRERR="Failed lookup",LRSTATUS="E" D EUPDATE Q
        D INIT^LRCAPBB S LRLD="CP"
        S ERR=0
TYPE    S LRTYPE=$G(ANS(6002.01,IEN,1,"I")) D  Q:$G(ERR)
        . I '$L(LRTYPE) S ERR=1 D EUPDATE
DIV     S LRDIV=+$G(ANS(6002.01,IEN,2,"I")) D  Q:$G(ERR)
        . I '$D(^DIC(4,+LRDIV,0)) S ERR=2 D EUPDATE
        . S LRIN=LRDIV
ADT     S (LRADT,LREDT)=$G(ANS(6002.01,IEN,3,"I")) D  Q:$G(ERR)
        . I LRADT'?7N1"."1N.E S ERR=3 D EUPDATE
        . S LRCDT=$P(LRADT,"."),LRCTM=$P(LRADT,".",2)
NLT     S LRNLT=$G(ANS(6002.01,IEN,6,"I")) D  Q:$G(ERR)
        . I '$D(^LAM(LRNLT,0)) S ERR=6 D EUPDATE
SUF     S LRSUF=$G(ANS(6002.01,IEN,7,"I")) D  Q:$G(ERR)
        . S:'LRSUF LRSUF=LRDSUF
        . S LRCC=$$NLT^LRCAPBV1(LRNLT,LRSUF) ;Lookup or create NLT code
        . D GETS^DIQ(64.2,LRSUF_",",1,"I","ANS","ERR")
        . S LRSUF=$P($G(ANS(64.2,LRSUF_",",1,"I")),".",2)
        S LRCNT=$G(ANS(6002.01,IEN,8,"I")) I 'LRCNT S LRCNT=1
DFN     S DFN=$G(ANS(6002.01,IEN,9,"I")) D  I $G(ERR) D EUPDATE Q
        . S LRDFN=""
        . Q:LRTYPE'="P"
        . S LRDFN=$G(^DPT(+DFN,"LR"))
        . ;I 'LRDFN S ERR=9 ;RLM 6/12/08 This isn't always an error and the data is evaluated in VBECS prior to transmission
FILE    I LRTYPE="U"!(LRTYPE="M") S LRFILE=LRD65_";LRD(65,"
        I LRTYPE="D" S LRFILE=LRE655_";LRE("
        I LRTYPE="P" S LRFILE=DFN_";DPT("
TEC     S LRTEC=$G(ANS(6002.01,IEN,10,"I")) D  Q:$G(ERR)
        . I '$D(^VA(200,LRTEC,0)) S ERR=10 D EUPDATE
        S LRAA=$S($G(LRDAA):LRDAA,1:29),LRAN=""
UID     S LRUID=$G(ANS(6002.01,IEN,11,"I")) D  Q:$G(ERR)
        . I '$L(LRUID) Q
        . S LRAA=+$O(^LRO(68,"C",LRUID,0)) Q:LRAA<1
        . S LRCDT=$O(^LRO(68,"C",LRUID,LRAA,0))
        . S LRAN=$O(^LRO(68,"C",LRUID,LRAA,LRCDT,0))
        . S ERR=$S('LRAA:11,'LRAA:11,'LRAN:11,'$D(^LRO(68,LRAA,1,LRCDT,1,LRAN,0)):11,1:0)
        . I ERR D EUPDATE
TS      K LRTS,LRTST,LRTSTP S LRTS=0
        I $G(ANS(6002.01,IEN,12,"I")) S (LRTS,LRTST,LRTSTP)=+$G(ANS(6002.01,IEN,12,"I"))
        I 'LRTS D
        . I LRTYPE="U" S (LRTS,LRTST,LRTSTP)=LRTSTU
        . I LRTYPE="M" S (LRTS,LRTST,LRTSTP)=LRTSTQA
        . I LRTYPE="D" S (LRTS,LRTST,LRTSTP)=LRTSTD
        ; I 'LRTS,$G(LRAA),$G(LRCDT),$G(LRAN) S (LRTS,LRTST,LRTSTP)=$O(^LRO(68,LRAA,1,LRCDT,1,LRAN,4,0))
        D  Q:$G(ERR)
        . S ERR=0
        . ;I '$D(^LAB(60,LRTS,0)) S ERR=12 D EUPDATE ;;RLM 6/12/08 This isn't always an error and the data is evaluated in VBECS prior to transmission
UNIT    S LRUNIT=$G(ANS(6002.01,IEN,13,"I")) D  Q:ERR
        . I LRTYPE="U" S LRFILE=LRD65_";LRD(65," I '$L(LRUNIT) S ERR=13 D EUPDATE
LRDAA   S LRWKLAA=$G(ANS(6002.01,IEN,14,"I"))
        Q
EUPDATE ;Set error codes into entry
        I $D(LRDBUG) W !,ERR
        K LRFDA(1)
        S:'$G(LRIEN) LRIEN=$O(^VBEC(6002.01,0))
        S LRFDA(1,6002.01,LRIEN_",",5)="E"
        I $G(ERR) S LRFDA(1,6002.01,LRIEN_",",20)="Field "_ERR_" has an error"
        I '$G(ERR) S LRFDA(1,6002.01,LRIEN_",",20)=ERR_" Error"
        D FILE^DIE("S","LRFDA(1)","ERRX")
        Q
LRAA    ;Get accession data
        S LRAA=$G(ANS(6002.01,LRIEN_",",14,"I"))
        S LRAA=$S($G(LRAA):LRAA,1:LRDAA)
        K ANX,ERX
        D GETS^DIQ(68,LRAA_",",.19,"I","ANX","ERR")
        S LRLD=$G(ANX(68,LRAA_",",.19,"I"))
AA      ;Accession Area Information
        S (LRMA,LRWA,LRLSS)=LRAA,LRUG=9
        I $G(LRAN),$G(LRCDT),$G(LRAA) D
        . Q:'$D(^LRO(68,LRAA,1,LRCDT,1,LRAN,0))
        . S IEN=LRAN_","_LRCDT_","_LRAA_","
        . D GETS^DIQ(68,LRAA_",",.8,"I","ANX","ERX")
        . S LRDSSLOC=$G(ANX(68,LRAA_",",.8,"I"))
        . S:'LRDSSLOC LRDSSLOC=LRDLOC
        . D GETS^DIQ(44,LRDSSLOC_",",8,"I","ANX","ERX")
        . S LRDSSID=$G(ANX(44,LRDSSLOC_",",8,"I"))
        . S FLD=".01;.02;2;3;4;6;6.5;6.6;6.7;15;92;94"
        . D GETS^DIQ(68.02,IEN,FLD,"IN","ANX","ERX")
        . D GETS^DIQ(68.05,1_","_IEN,.01,"IN","ANX","ERX")
        . D GETS^DIQ(68.04,LRTS_","_IEN,1,"IN","ANX","ERX")
LRAA1   . ;Parse variables
        . S LRFILE=$P($G(^LRO(68,LRAA,1,LRCDT,1,LRAN,0)),U,2)
        . S LRDFN=$G(ANX(68.02,IEN,.01,"I"))
        . D GETS^DIQ(63,LRDFN_",",".02;.03","I","ANX","ERX")
DPF     . S LRDPF=$G(ANX(63,LRDFN_",",.02,"I"))
        . S DFN=$G(ANX(63,LRDFN_",",.03,"I"))
        . D FILE^DID(LRFILE,"","GLOBAL NAME","ANX","ERX")
        . I $G(LRDFN),$G(DFN) S LRFILE=DFN_";"_$P(ANX("GLOBAL NAME"),U,2)
ACCES   . S LROAD=$G(ANX(68.02,IEN,2,"I"))
        . S LROAD1=$G(ANX(68.02,IEN,3,"I"))
        . S (LRSN,LROAD2)=$G(ANX(68.02,IEN,4,"I"))
        . S LRSPEC=$G(ANX(68.05,1_","_IEN,.01,"I"))
        . S LRRRL=$G(ANX(68.02,IEN,6,"I"))
        . S (LRPRO,LRRRL1)=$G(ANX(68.02,IEN,6.5,"I"))
        . S LRRRL3=$G(ANX(68.02,IEN,6.7,"I"))
        . S LRACC=$G(ANX(68.02,IEN,15,"I"))
        . S LROL=$G(ANX(68.02,IEN,94,"I"))
        . D GETS^DIQ(44,LROL_",","2;9.5","IN","ANX","ERX")
        . S LRRRL2=$G(ANX(44,LROL_",",9.5,"I"))
        . S LRRRL4=$G(ANX(44,LROL_",",2,"I"))
        . S LRIDT=""
URG     . S LRUG=$G(ANX(68.04,LRTS_","_IEN,1,"I"))
        Q
