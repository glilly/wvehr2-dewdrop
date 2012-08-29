LRWLST11        ;DALOI/CJS,RWF/FHS - ACCESSION SETUP ;July 19, 2006
        ;;5.2;LAB SERVICE;**121,128,153,202,286,331,375**;Sep 27, 1994;Build 3
        ;
ST21    ;
        S LRTS="",LRIX=0
        F  S LRIX=$O(LRTSTS(LRWLC,LRUNQ,LRAA,LRIX)) Q:LRIX<1  D SET Q:LRUNQ
        ;
        S LRNT=$$NOW^XLFDT
        D SCDT,SLRSS
        ;
COMMON  ; Setup 'in common' accession if not already setup unless it will be 
        ; when tests are acessioned to the 'in common' area.
        I +LRWLC,+LRWLC'=+LRAA,$G(^LRO(68,LRWLC,1,LRAD,1,LRAN,0))=$G(LRDFN) D
        . I 'LRUNQ,$D(LRTSTS(LRWLC,LRUNQ,LRWLC)) Q
        . Q:$G(^LRO(68,LRWLC,1,LRAD,1,LRAN,.1))
        . N LRAA,LRACC,LRCDTX,LRCOMMON,LREND,LRIDT,LRNODE3,LRORDRR,LRORU3,LRQUIET,LRTJ,LRUID,X,Y
        . S (LRQUIET,LRCOMMON)=1,LRAA=+LRWLC,LRORDRR=""
        . S X=LRSS,LRCDTX=LRCDT
        . N LRCDT,LRSS
        . S LRCDT=LRCDTX,LRSS=X_U_(1+$G(LRLBLBP))
        . D STWLN^LRWLST1 Q:$G(LREND)
        . D ST2^LRWLST1 Q:$G(LREND)
        . D SCDT,SLRSS
        ;
        Q
        ;
        ;
SCDT    ; Set collection, inverse and lab arrival date/times on accession
        N FDA,LR6802,LRDIE
        S LR6802=LRAN_","_LRAD_","_LRAA_","
        S FDA(4,68.02,LR6802,9)=LRCDT
        S FDA(4,68.02,LR6802,10)=LREAL
        I '$D(LRPHSET) S FDA(4,68.02,LR6802,12)=LRNT
        S FDA(4,68.02,LR6802,13.5)=LRIDT
        D FILE^DIE("","FDA(4)","LRDIE(4)")
        I $D(LRDIE(4)) D MAILALRT^LRWLST1
        Q
        ;
        ;
SLRSS   ;
        ;
        S X=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,5,1,0)) ; change for AP
        S H8=$S($D(LRSPEC):LRSPEC,1:X)_U_$S("CYEMSPAU"[LRSS:LRACC,1:LRACC)_U_$S(LRSS="MI":LRPRAC,1:"")_U_$S(LRSS="MI":LRLLOC,1:"")_"^^"_$S(LRSS="CH":LRPRAC,1:"")_"^"_$S(LRSS="MI":$P(LRSAMP,";",1),LRSS="CH":LRLLOC,1:"")
        ;
        I $S(LRSS="CH":1,LRSS="MI":1,1:0) D
        . I $G(LRORDRR)="R",+$G(LRRSITE("RSITE")) S $P(H8,U,9)=+LRRSITE("RSITE")_";DIC(4,"
        . I $G(LROLLOC),$G(LRORDRR)'="R" S $P(H8,U,9)=LROLLOC_";SC("
        . S $P(H8,U,10)=$S($G(LRDUZ(2)):LRDUZ(2),1:$G(DUZ(2)))
        ;
        S ^LR(LRDFN,LRSS,LRIDT,0)=LRCDT_U_LREAL_"^^^"_H8
        I $G(LRORU3)'="" S ^LR(LRDFN,LRSS,LRIDT,"ORU")=LRORU3
        ;
ST3     D ST4:(LRSS="MI"),LRCCOM
        ;
        S LRDPF=$P(^LR(LRDFN,0),U,2),DFN=$P(^(0),U,3),LRPR=1
        S LRRB=0
        I LRDPF=2 S LRRB=$$GET1^DIQ(2,DFN_",",.101),LRRB=$S(LRRB'="":LRRB,1:0)
        ;
        Q:$G(LRORDR)="P"
        ;
        I '$D(LRTJ) D  Q
        . I $G(LRORDRR)="R",LRSS="CH",$G(LRORU3)'="",$P(LRORU3,"^")'=$P(LRORU3,"^",4) Q  ; Don't print, use label from sending facility.
        . I LRLBLBP,'$G(LRCOMMON) S LRLBL(LRAA,LRAN)=LRSN_U_LRAD_U_LRODT_U_LRRB_U_LRLLOC_U_LRACC_U_$S($D(LRORD):LRORD,1:"")
        S I=0
        F  S I=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,I)) Q:I<.5  S LRTS=^(I,0) D Z
        Q
        ;
        ;
ST4     ;
        S $P(^LR(LRDFN,LRSS,LRIDT,0),U,10)=$S($D(LRNT):LRNT,1:""),$P(^(0),U,8)=LRLLOC
        ; Used to be LRSPCDSC,63.05,.9 (Word Processing field) replaces 63.05,.99
        S:$D(LRCCOM) ^LR(LRDFN,LRSS,LRIDT,99)=LRCCOM
        I '$D(LRPHSET) D
        . N DA,DIE,DR
        . S DIE="^LR("_LRDFN_",""MI"",",DA=LRIDT,DA(1)=LRDFN
        . ;S DR=.9
        . ;I '$G(LRQUIET) W:DR'=.9 !!,"Order comment:"
        . S DR=.99_$S($L($G(LRGCOM)):"///"_LRGCOM,$L($G(LRCCOM)):"//"_LRCCOM,1:"")
        . I '$G(LRQUIET) W:DR'=.99 !!,"Order comment:"
        . D ^DIE
        I '$G(LRQUIET),'$D(LRPHSET),'$D(LRGCOM) W !,"Description OK? Y//" D % G ST4:%["N"
        K DR,DIC,DIE
        Q
        ;
        ;
ST5     S I("SUBSC")=$S(I("EDIT")[11.5:26,I("EDIT")[15:27,I("EDIT")[19:28,I("EDIT")[23:29,I("EDIT")[34:30,1:-1) Q:I("SUBSC")=-1
        S I("PNTR")=$S(I("EDIT")[11.5:"^63.061A^",I("EDIT")[15:"^63.361A^",I("EDIT")[19:"^63.111A^",I("EDIT")[23:"^63.181A^",1:"^63.432A^")
        S I("N")=1+$S($D(^LR(LRDFN,"MI",LRIDT,I("SUBSC"),0)):$P(^(0),U,4),1:0),^(0)=I("PNTR")_I("N")_U_I("N"),^(I("N"),0)=I("TEST")
        Q
        ;
        ;
SET     S LRTS=LRTSTS(LRWLC,LRUNQ,LRAA,LRIX),LRIN=$P(LRTS,U,3),LRORIFN=$P(LRTS,U,4),LRTSORU=+$P(LRTS,U,6),LRTS=$P(LRTS,U,1,2),LRBACK=$P(LRTS,U,5)
        ;
        I '$G(LRQUIET),'$D(LRPHSET) D
        . W !,$P(^LAB(60,+LRTS,0),U)
        . I $D(LRSPEC),LRSPEC D
        . . S I=$S($D(^LAB(61,+LRSPEC,0)):$P(^(0),U),1:""),J=$S($D(^LAB(62,+LRSAMP,0)):$P(^(0),U),1:"")
        . . W ?30,J W:I'=J "  ",I
        ;
        I '$G(LRQUIET),'$D(LRPHSET),+LRTS,$O(^LAB(60,+LRTS,7,0))>0 D
        . N S
        . S DIC="^LAB(60,",DA=+LRTS,DR=7
        . D EN^DIQ H 3
        I '$G(LRQUIET),'$D(LRPHSET),+LRTS D
        . N S
        . S DIC="^LAB(60,"_(+LRTS)_",3,"
        . S DA=+$O(^LAB(60,+LRTS,3,"B",+LRSAMP,0)),DR=2
        . I DA>0,$O(^LAB(60,+LRTS,3,DA,2,0))>0 D EN^DIQ H 3
        ;
        D ORUT
        D CAP^LRWLST12
        K LRTSTS(LRWLC,LRUNQ,LRAA,LRIX)
        ;
        S ^LRO(69,LRODT,1,LRSN,2,LRIN,0)=LRTS_U_LRAD_U_LRAA_U_LRAN_"^^"_LRORIFN_"^^IP^L^^^^"_LRBACK
        S ^LRO(69,LRODT,1,LRSN,2,"B",+LRTS,LRIN)=""
        ;
        ; When file 63 is enhanced to accept comments per test comments should
        ; be put there instead of field 99.
        I $O(^LRO(69,LRODT,1,LRSN,2,LRIN,1,0)) D
        . I LRSS'="CH"!($D(^LR(LRDFN,LRSS,LRIDT,0))[0) Q
        . S X=$S($D(^LR(LRDFN,LRSS,LRIDT,1,0)):$P(^(0),"^",3),1:0),I=0
        . F  S I=$O(^LRO(69,LRODT,1,LRSN,2,LRIN,1,I)) Q:I<1  S II=^(I,0) S X=X+1,^LR(LRDFN,LRSS,LRIDT,1,X,0)=II
        . S:X ^LR(LRDFN,LRSS,LRIDT,1,0)="^63.041^"_X_U_X
        ;
RUID    I $G(LRORU3)'="" D
        . N DA,DIE,DIC,DLAYGO,DR,X,Y
        . S DLAYGO=69
        . S DA=LRIN,DA(1)=LRSN,DA(2)=LRODT,DIC="^LRO(69,"_DA(2)_",1,"_DA(1)_",2,"
        . S DIE=DIC,DR="13////"_$P(LRORU3,U)_";14////"_$P(LRORU3,U,2)_";15////"_$P(LRORU3,U,3)_";16////"_$P(LRORU3,U,4)_";17////"_$P(LRORU3,U,5)
        . D ^DIE
        Q
        ;
        ;
%       R %:DTIME Q:%=""!(%["N")!(%["Y")  W !,"Answer 'Y' or 'N': " G %
        ;
        ;
LRCCOM  ;
        N I,LRCCOM,LRTN,X
        S (I,LRTN,LRCCOM)=0 Q:LRSS'="CH"!($D(^LR(LRDFN,LRSS,LRIDT,0))[0)
        F  S I=$O(^LRO(69,LRODT,1,LRSN,6,I)) Q:I<1  I $D(^(I,0)) S X=^(0),LRCCOM=LRCCOM+1,^LR(LRDFN,LRSS,LRIDT,1,LRCCOM,0)=X
        F  S LRTN=$O(^LRO(69,LRODT,1,LRSN,2,LRTN)) Q:'LRTN  I $D(^(LRTN,0)) S X=^(0) I $P(X,"^",8),'$P(X,"^",3),$O(^(1,0)) D  ;Get comments for expanded panels
        . S I=0 F  S I=$O(^LRO(69,LRODT,1,LRSN,2,LRTN,1,I)) Q:'I  I $D(^(I,0)) S X=^(0),LRCCOM=LRCCOM+1,^LR(LRDFN,LRSS,LRIDT,1,LRCCOM,0)=X
        S:LRCCOM ^LR(LRDFN,LRSS,LRIDT,1,0)="^63.041^"_LRCCOM_U_LRCCOM
        Q
        ;
        ;
Z       L +^LRO(69.1,LRTE)
        S LRZ3=$S($D(^LRO(69.1,LRTE,1,0)):$P(^(0),U,3),1:0)
Z1      S LRZ3=LRZ3+1 G:$D(^LRO(69.1,LRTE,1,LRZ3)) Z1
        S LRZO="^LRO(69.1,"_LRTE_",1,",LRZ1="69.11P",LRZB=+LRTS,LRIFN=LRZ3
        D Z^LRWU
        S ^LRO(69.1,LRTE,1,LRIFN,0)=+LRTS_"^"_LRLLOC_"^"_LRRB_"^"_LRDFN_"^"_LRSN_"^"_LRTJ_"^"_LRAD_"^"_LRAA_"^"_LRAN_"^"_+LROLLOC
        S ^LRO(69.1,"LRPH",LRTE,LRLLOC,LRRB,LRDFN,LRSN)=LRTJ_"^"_LRAD_"^"_LRIFN,^(LRSN,LRAA,LRAN,+LRTS)=+LRTS
        L -^LRO(69.1,LRTE)
        Q
        ;
        ;
ORUT    Q:'$G(LRTSORU)!($G(LRSS)'="CH")
        N LRTT,DLAYGO,DIC,DIE,DR,LRTST,DA,LRURG
        S DA=LRIDT,DA(1)=LRDFN
        S LRNLT=$$NLT^LRVER1(+LRTSORU) Q:+LRNLT<1  Q:$D(^LR(DA(1),LRSS,DA,"ORUT","B",LRNLT))
        S DR=".35///^S X=LRNLT",DR(1)=".35"
        S DR(1,63.04)=".35///^S X=LRNLT"
        S DR(1,63.07)=".01///^S X=LRNLT"
        S DIC="^LR("_DA(1)_","""_LRSS_""","
        S DIC(0)="MNL",DIE=DIC W:$G(LRDBUG) !,LRNLT
        D ^DIE
        ;
ORUT2   S LRTST=$P($G(^LAM($O(^LAM("E",LRNLT,0)),0)),U) Q:LRTST=""!('$G(LR696IEN))
        Q:'($D(^LRO(69.6,LR696IEN,0))#2)!($D(^LRO(69.6,LR696IEN,2,"C",LRNLT)))
        S:'$D(^LRO(69.6,LR696IEN,2,0)) ^(0)="^69.64A^"
        S DLAYGO=69.6
        K DIC,DIE,DA,DR,DA
        S DA=LR696IEN
        S LRURG="R",LRURG=$S($L($P($G(^LAB(62.05,+$P(LRTS,U,2),0)),U,4)):$P(^(0),U,4),1:LRURG)
        S (DIE,DIC)="^LRO(69.6,",DIC(0)="LM"
        S DR=20_"///"_LRTST_";",DR(1,69.6)="20///"_LRTST_";"
        S DR(2,69.64)=".01///"_LRTST_";1///"_LRNLT_";4///"_LRURG_";5////160;8///"_LRNT_";9///"_LRUID
        D ^DIE
        Q
        ;
        ;
SICA    ; Check accessions 'in common' and setup reference to this accession
        N FDA,LR6802,LRDIE,LRAA
        S LRX=$P($G(^LRO(68,LRWLC,1,LRAD,1,LRAN,.2)),"^"),LRAA=0
        F  S LRAA=$O(LRTSTS(LRWLC,LRUNQ,LRAA)) Q:LRAA<1  I LRWLC'=LRAA D
        . S LR6802=LRAN_","_LRAD_","_LRAA_","
        . S FDA(5,68.02,LR6802,15.1)=LRX
        . D FILE^DIE("","FDA(5)","LRDIE(5)")
        . I $D(LRDIE(5)) D MAILALRT^LRWLST1
        Q
