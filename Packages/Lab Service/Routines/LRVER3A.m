LRVER3A ;SLC/CJS/DALOI/FHS - DATA VERIFICATION ;5/27/03  14:49
        ;;5.2;LAB SERVICE;**1,5,42,100,121,153,190,221,254,263,266,274,295,373**;Sep 27, 1994;Build 1
        ;Also contains LRORFLG to restrict multiple OERR alerts (VER+2)
        ; Reference to ^DIC(42 supported by IA #10039
        ; Reference to ^%ZTLOAD supported by DBIA #10063
        ; Reference to IN5^VADPT supported by DBIA #10061
        ; Reference to $$NOW^XLFDT supported by DBIA #10103
        ;
VER     ;Call with L ^LR(LRDFN,LRSS,LRIDT) from LRGV2, LRGVG1, LRSTUF1, LRSTUF2, LRVR3
        Q:'$O(LRSB(0))
        N LRVCHK,LRORTST,LRORFLG,LRT
        S LRORU3=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.3)),(LRAOD,LRACD)=$P(^(0),U,3)
        S LRACD=$S($D(^LRO(68,LRAA,1,LRAD,1,LRAN,9)):^(9),1:LRACD)
        S:'($D(^LRO(68,LRAA,1,LRACD,1,LRAN,0))#2) LRACD=LRAD
        S LRAOD=$S($D(^LRO(68,LRAA,1,LRAOD,1,LRAN,0))#2:LRAOD,1:LRAD)
        I '$G(LRFIX) S LRNOW=$$NOW^XLFDT,$P(^LR(LRDFN,LRSS,LRIDT,0),U,3,4)=LRNOW_U_$S($G(LRDUZ):LRDUZ,1:DUZ)
        K A2 I '$D(PNM) S LRDPF=$P(^LR(LRDFN,0),U,2),DFN=$P(^(0),U,3) D PT^LRX S:PNM="" PNM="NONAME"
        N LRT S LRT=0 F  S LRT=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT)) Q:LRT<.5  S:$P(^(LRT,0),U,5)="" A2(LRT)=1 I $D(^TMP("LR",$J,"VTO",LRT)) S LRVCHK=+^(LRT) D
        . I $S(LRVCHK<1:1,$D(LRSB(LRVCHK))#2:1,1:0) D
        . . I $D(LRSB(LRVCHK)) Q:$P(LRSB(LRVCHK),U)=""
        . . I LRVCHK<1,$L($P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRT,0),U,6)) Q
        . . D
        . . . S $P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,+LRT,0),U,4)=$S($G(LRDUZ):LRDUZ,$G(DUZ):DUZ,1:"")
        . . . S:'$P(^(0),U,5) $P(^(0),U,5)=LRNOW
        . . . S $P(^(0),U,6)="",$P(^(0),U,8)=$G(LRCDEF)
        . . S LRORTST(LRT)=""
        . . I LRACD'=LRAD D
        . . . Q:'$D(^LRO(68,LRAA,1,LRACD,1,LRAN,4,+LRT,0))  D
        . . . . S $P(^LRO(68,LRAA,1,LRACD,1,LRAN,4,+LRT,0),U,4)=$S($G(LRDUZ):LRDUZ,$G(DUZ):DUZ,1:"")
        . . . . S:'$P(^(0),U,5) $P(^(0),U,5)=LRNOW
        . . . . S $P(^(0),U,6)="",$P(^(0),U,8)=$G(LRCDEF)
        . . I $P($G(LRPARAM),U,14),$P($G(^LRO(68,+LRAA,0)),U,16) S ^LRO(68,"AA",LRAA_"|"_LRAD_"|"_LRAN_"|"_LRT)=""
        . . K A2(LRT)
        . . I +$G(LRDPF)=2,$$VER^LR7OU1<3 D
        . . . N I,Y
        . . . S Y=LRNOW,I=LRT D V^LROR ;OE/RR 2.5
        ;-K ZZCARE,ZRECORD I $D(^LR(LRDFN,.3)),^LR(LRDFN,.3)'="" D FCS  ; CJS/MPLS 12-4-91 LINK TO CIS  ; CJS/MPLS 3-16-92 KILL LOCAL VARIABLES
        ;-I $P(^LR(LRDFN,0),U,2)=2 I '$D(ZZCARE) S ZRECORD=0,ZRECORD=$O(^SC("C",LRLLOC,ZRECORD)) I ZRECORD'="",$D(^LRTXFCS(5000024,1,618001,"B",ZRECORD)) D FCS  ; CJS/MPLS 3-16-92 LINE ADDED TO CHECK IF REQUESTING LOCATION IS CAREVUE SUPPORTED  ++RG
        S D1=1,X=0 F  S X=$O(^TMP("LR",$J,"TMP",X)) Q:X<1  S LRT=+^(X) I $D(LRM(X)) D REQ
        I $D(^LRO(69,LRODT,1,LRSN,0)) S ^(3)=$S($D(^(3)):+^(3),1:LRNOW) S:'$P(^(3),U,2) $P(^(3),U,2)=LRNOW
        I D1,'$D(A2) S:'$P(^LRO(68,LRAA,1,LRAD,1,LRAN,3),U,4) $P(^(3),U,4)=LRNOW,^LRO(68,LRAA,1,LRAD,1,"AC",LRNOW,LRAN)=""
        ; Class I CareVue routine TASKED if CareVue ward - pwc/10-2000
        D
        . N I,LR7DLOC D IN5^VADPT S LR7DLOC=$G(^DIC(42,+$P($G(VAIP(5)),"^"),44))
        . Q:'LR7DLOC  D:$D(^LAB(62.487,"C",LR7DLOC))      ;good ward location
        . . S ZTRTN="^LA7DLOC",ZTDESC="LAB AUTOMATION CAREVUE SUPPORTED WARDS"
        . . S ZTIO="",ZTDTH=$H,ZTSAVE("L*")="" D ^%ZTLOAD
        . . K ZTSAVE,ZTSK,ZTRTN,ZTIO,ZTDTH,ZTDESC,ZTREQ,ZTQUEUED
        ;D ^VEICVLOC ;* PLS 6/3/99 -For HL7 interface
        I D1,'$D(A2),LRAD'=LRACD S:'$P(^LRO(68,LRAA,1,LRACD,1,LRAN,3),U,4) $P(^(3),U,4)=LRNOW,^LRO(68,LRAA,1,LRACD,1,"AC",LRNOW,LRAN)=""
        D XREF I $D(^LRO(68,LRAA,.2))'[0 X ^(.2)
        N CORRECT S:$G(LRCORECT) CORRECT=1 D NEW^LR7OB1(LRODT,LRSN,"RE",,.LRORTST)
        L -^LR(LRDFN,LRSS,LRIDT) ;unlock
        Q
XREF    ;from COM1^LRVER4 and VER^LRVER3A
        I +$G(LRDPF)=2,$$VER^LR7OU1<3 D EN^LROR(LRAA,LRAD,LRAN) ;OE/RR 2.5
        I LRDPF=62.3 S ^LRO(68,LRAA,1,LRAD,1,"AD",DT,LRAN)="" Q
        S LRPRAC=$$PRAC^LRX($P(^LR(LRDFN,LRSS,LRIDT,0),U,10)) ;get doc name
        S ^LRO(68,LRAA,1,LRAD,1,"AD",DT,LRAN)=""
        S ^LRO(69,9999999-LRIDT\1,1,"AL",$E(LRLLOC,1,15),$E(PNM,1,20),LRDFN)=""
        S ^LRO(69,9999999-LRIDT\1,1,"AP",LRPRAC,$E(PNM,1,20),LRDFN)=""
        S ^LRO(69,DT,1,"AN",$E(LRLLOC,1,15),LRDFN,LRIDT)=""
        S ^LRO(69,DT,1,"AR",$E(LRLLOC,1,15),$E(PNM,1,20),LRDFN)=""
        S ^LRO(69,"AN",$E(LRLLOC,1,20),LRDFN,LRIDT)=""
        D CHSET^LRPX(LRDFN,LRIDT)
        Q:'$P(LRPARAM,U,3)
TSKM    F KK="LRDFN","LRAA","LRAOD","LRAD","LRAN","LRIDT","LRSS","LRLLOC","LRSN","LRODT" S ZTSAVE(KK)=""
        N %X S ZTRTN="DQ^LRTP",ZTIO="",ZTDTH=$H,ZTDESC="LAB INTERIM REPORTS" D ^%ZTLOAD
        K KK,ZTSK,ZTRTN,ZTDTH,ZTSAVE,ZTIO Q
REQ     ;
        Q:$P($G(LRSB(X)),U)="comment"
        I $D(LRSB(X)),$P(LRSB(X),U)="canc" Q
        I $D(LRSB(X)),$P(LRSB(X),U)'["pending" Q
        I $L($P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,+LRT,0)),U,6)) Q
        S:'$G(LRALERT) LRALERT=$S($G(LROUTINE):LROUTINE,1:9)
        S D1=0 N A,LRPPURG
        I $D(LRSB(X)),LRSB(X)["pending",$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,+LRT,0))#2 D  G REQ1
        . S $P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,+LRT,0),U,4)="",$P(^(0),U,5,6)="^",$P(^(0),U,9)=+$G(LRM(X,"P"))
        I '$D(LRSB(X)),'$L($P($G(^LR(LRDFN,"CH",LRIDT,X)),U)) S $P(^(X),U)="pending"
        I '$D(LRSB(X)),$P($G(^LR(LRDFN,"CH",LRIDT,X)),U)'="pending" Q
        I $D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,+LRT,0))#2 S $P(^(0),U,4,5)="^",A=$P(^(0),U,2) I A>49 S $P(^(0),U,2)=$S(A=50:9,1:A-50)
        I '$D(^LRO(68,LRAA,1,LRAD,1,LRAN,4,+LRT,0))#2 D
        . S ^LRO(68,LRAA,1,LRAD,1,LRAN,4,"B",+LRT,+LRT)=""
        . S LRPPURG=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,+$G(LRM(X,"P")),0)),U,2)
        . S:'LRPPURG LRPPURG=$S($G(LRALERT):+LRALERT,1:9)
        . S ^LRO(68,LRAA,1,LRAD,1,LRAN,4,+LRT,0)=+LRT_U_LRPPURG,$P(^(0),U,9)=+$G(LRM(X,"P"))
        . S $P(^LRO(68,LRAA,1,LRAD,1,LRAN,4,0),U,3)=+LRT,$P(^(0),U,4)=$P(^(0),U,4)+1 Q
REQ1    ;
        Q:LRACD=LRAD  I $D(^LRO(68,LRAA,1,LRACD,1,LRAN,4,+LRT,0))#2,'$L($P(^(0),U,6)) S ^(0)=$P(^(0),U,1,2),$P(^(0),U,7)=1,$P(^(0),U,9)=+$G(LRM(X,"P"))
        K CNT,LRAMC Q
FCS     ; SET UP FOR FOREIGN COMPUTER SYSTEM  ; CJS/MPLS 12-4-91 LINK TO CIS
        ;-S:'$D(ZRECORD) ZZCARE=1 S:$D(ZRECORD) ZTSAVE("LRLLOC")=""   ; CJS/MPLS 3-18-92 SET ZZCARE IF PATIENT IN ICU'S, SET ZTSAVE IF TEST REQUESTED FROM PAR/OR
        ;-F KK="LRDFN","LRIDT","DFN" S ZTSAVE(KK)=""
        ;-S ZTRTN="EN^LAFCCVX2",ZTIO="",ZTDTH=$H D ^%ZTLOAD
        ;-Q
