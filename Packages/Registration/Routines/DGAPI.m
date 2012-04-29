DGAPI   ;WASH/DWS - PTF's APIs ;7/29/04 7:33am
        ;;5.3;Registration;**517,594,664**;Aug 13, 1993;Build 15
        Q
        ;
DATA2PTF(DFN,PTF,PSDATE,USER,FLAG,SOURCE)       ;API to pass data for add/edit/delete to PTF
        I $G(PTF) Q:'$D(^DGPT(PTF)) -2
        I '$G(PTF) Q:'$G(PSDATE) -2  D FIND Q:'$G(PTF) -2
        I $P($G(^DGPT(PTF,0)),U,6) S ERR="INPATIENT STAY CLOSED, THE PTF SYSTEM CAN BE USED TO RE-OPEN IT." D  Q -1
        .I +$G(FLAG) W !,ERR Q
        .S ^TMP("PTF",$J,"DIERR")=ERR
        Q:'$D(^TMP("PTF",$J)) -3 S FL=0 D PROV I $G(Y)'>0!FL K FL,Y Q -1
        K ERR,FL Q PTF
CPTINFO(DFN,PTF,PSDATE) ;API to get CPT data from PTF
        I '$G(PTF) Q:'$G(PSDATE)  D FIND Q:'$G(PTF)
        S I=0 F  S I=$O(^DGPT(PTF,"C",I)) Q:I'>0  I +^(I,0)=PSDATE S ^TMP("PTF",$J,46,0)=$P(^(0),U,2,5),(K,K1)=0 D  Q
        .F  S K=$O(^DGCPT(46,"C",PTF,K)) Q:K'>0  I PSDATE=+$G(^DGCPT(46,K,1)),'$G(^(9)) S K1=K1+1,^TMP("PTF",$J,46,K1)=K_U_^(0)
        K I,K,K1 Q
PTFINFOR(DFN,PTF,PSDATE)        ;API to get a list of CPT records from PTF
        I '$G(PTF) Q:'$G(PSDATE)  D FIND Q:'$G(PTF)
        S I=0 F I1=1:1 S I=$O(^DGPT(PTF,"C",I)) Q:I'>0  S ^TMP("PTF",$J,I1)=^(I,0)
        K I,I1 Q
DELCPT(DA)      ;API to delete cpt code from PTF
        S PTF=$P($G(^DGCPT(46,DA,1)),U,3) I $P(^DGPT(PTF,0),U,6) K PTF Q -1
        S REC=DA,DIE="^DGCPT(46,",DR="1////^S X=%" L +^DGCPT(46,REC):2 I  D NOW^%DTC,^DIE K DIE,DR L -^DGCPT(46,REC) K REC Q 1
        K REC Q -1
DELPOV(DA)      ;API to delete a diagnosis from PTF
        S PTF=+$G(^DGICD9(46.1,DA,1)) I $P(^DGPT(PTF,0),U,6) Q -1
        S REC=DA,DIE="^DGICD9(46.1,",DR="9////^S X=%" L +^DGCPT(46.1,REC):2 I  D NOW^%DTC,^DIE K DIE,DR L -^DGCPT(46.1,REC) K REC Q 1
        K REC Q -1
ICDINFO(DFN,PTF,PSDATE,DGI)     ;API to get Diagnosis data from PTF
        I '$G(PTF),'$G(DGI) Q:'$G(PSDATE)  D FIND Q:'$G(PTF)
        I $G(PTF) S I=0 F I1=1:1 S I=$O(^DGICD9(46.1,"C",PTF,I)) Q:I'>0  I '$G(^DGICD9(46.1,I,9)) S ^TMP("PTF",$J,46.1,I1)=I_U_^DGICD9(46.1,I,0)
        I '$G(PTF),$G(DGI) S ^TMP("PTF",$J,46.1,1)=DGI_U_$G(^DGICD9(46.1,DGI,0))
        K I,I1 Q
FIND    ;Find the IEN for the PTF file
        S (I,K)=0 F  S I=$O(^DGPT("B",DFN,I)) Q:'I  I $P(^DGPT(I,0),U,11)=1 S J=$G(^DGPT(I,70)) I J'<PSDATE!'J S L=$P(^(0),"^",2) I L'>PSDATE D
        .Q:L<K  S PTF=I,K=L
        K I,J,K,L Q
PROV    ;FILE PROVIDERS AND CPT CODES
        N DGI,LOC
        I $D(^TMP("PTF",$J,46,0)) S:'$D(^DGPT(PTF,"C",0)) ^(0)="^45.06D^^" D
        .S DIC="^DGPT("_PTF_",""C"",",DIC(0)="LMZ",DA(1)=PTF,DLAYGO=45,X=PSDATE D ^DIC K DIC,DLAYGO,X I Y'>0 Q
        .S DA(1)=PTF,DIE="^DGPT("_PTF_",""C"",",(DA,REC)=+Y,DR="",I=^TMP("PTF",$J,46,0)
        .S REFPROV=+I,PERFPROV=$P(I,U,2) S:REFPROV DR=DR_".02////^S X=REFPROV;" S DR=DR_".03////^S X=PERFPROV;"
        .S DIAG=$P(I,U,3),LOC=$P(I,U,4) K I S DR=DR_".04////^S X=DIAG;" S:LOC DR=DR_".05////^S X=LOC;"
        .L +^DGPT(REC):2 I '$T D ERR(46,"CPT entry is being edited by another user") K DIE,DR,REC Q
        .D ^DIE L -^DGPT(REC) K DIE,DR,REFPROV,PERFPROV,REC S DGI=0 F  S DGI=$O(^TMP("PTF",$J,46,DGI)) Q:'DGI  D CPT
        S DGI=0 F  S DGI=$O(^TMP("PTF",$J,46.1,DGI)) Q:'DGI  D DIAG
        S Y=1 Q
CPT     ;FILE CPT INFORMATION IN ^DGCPT
        S DGJ=0,STR=^TMP("PTF",$J,46,DGI),DLAYGO=46
        I STR S Y=+STR G CPTFL  ;if rec num in DGCPT is passed, overlay without any verification of CPT code passed
        F  S DGJ=$O(^DGCPT(46,"C",PTF,DGJ)) Q:DGJ'>0  I +^DGCPT(46,DGJ,1)=PSDATE,$P(^(0),U)=$P(STR,U,2),'$D(^(9)) S STR=DGJ_STR,Y=DGJ,^TMP("PTF",$J,46,DGI)=STR Q
        I 'STR K DO S DIC="^DGCPT(46,",DIC(0)="F",X=$P(STR,U,2) D FILE^DICN K DIC,X Q:Y'>0  S STR=+Y_STR,^TMP("PTF",$J,46,DGI)=STR
CPTFL   S Y=+Y_"," F I=1:1:13 S CPT(46,Y,I/100)=$P(STR,U,I+1)
        F I=20:1:24 S CPT(46,Y,I/100)=$P(STR,U,I-5)
        S CPT(46,Y,.14)=PSDATE,CPT(46,Y,.16)=PTF
        S CPT(46,Y,.17)=$G(SOURCE),CPT(46,Y,.18)=$G(USER)
        D FILE^DIE("K","CPT","^TMP(""PTF"",$J,46,DGI)")
        I $D(^TMP("PTF",$J,46,DGI,"DIERR")) S FL=1 I +$G(FLAG),$D(^("DIERR",1,"TEXT",1)) W !,^(1)
        K STR,CPT,DGJ,I Q
DIAG    ;FILE DIAGNOSIS INFORMATION IN ^DGCPT
        S DGJ=0,STR=^TMP("PTF",$J,46.1,DGI),DLAYGO=46.1
        I STR S Y=+STR G DIAGFL  ;if rec num in DGICD9 is passed, overlay without any verification of DGN code passed
        F  S DGJ=$O(^DGICD9(46.1,"C",PTF,DGJ)) Q:DGJ'>0  I $P(^DGICD9(46.1,DGJ,0),U)=$P(STR,U,2),'$G(^(9)) S STR=DGJ_STR,Y=DGJ,^TMP("PTF",$J,46.1,DGI)=STR Q
        I 'STR K DO S DIC="^DGICD9(46.1,",DIC(0)="F",X=$P(STR,U,2) D FILE^DICN K DIC,X Q:Y'>0  S STR=+Y_STR,^TMP("PTF",$J,46.1,DGI)=STR
DIAGFL  S Y=+Y_"," F I=1:1:9 S DIAG(46.1,Y,I/100)=$P(STR,U,I+1)
        S DIAG(46.1,Y,1.1)=$G(SOURCE),DIAG(46.1,Y,1.2)=$G(USER)
        S DIAG(46.1,Y,1)=PTF D FILE^DIE("K","DIAG","^TMP(""PTF"",$J,46.1,DGI)")
        I $D(^TMP("PTF",$J,46.1,DGI,"DIERR")) S FL=1 I +$G(FLAG),$D(^("DIERR",1,"TEXT",1)) W !,^(1)
        K STR,CPT,DGJ,DIAG,I Q
ERR(FILE,MESS)  ;DISPLAY OR PRINT ERROR MESSAGES BASED ON FLAG PARAMETER FOR DATA2PTF
        S FL=1 I +$G(FLAG) W !,MESS Q
        S ^TMP("PTF",$J,FILE,DGI,"DIERR")=MESS Q
