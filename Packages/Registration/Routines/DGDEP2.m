DGDEP2  ;ALB/CAW,JAN - Dependent Utilities ; 4/4/06 9:30am
        ;;5.3;Registration;**45,60,395,624,688**;Aug 13, 1993;Build 29
        ;624: DGMTDPCH=flag to force recalc of adj med exp when deps change
        ;
EN1     ; Add dependent to means test
        ;
        N DGSAVE,DGMTD,DGSAVE1
        I '$G(DGMTI) W !,"Not a means test - use means test options." H 2 G EN1Q
        I $G(DGMTACT)="VEW" W !,"Cannot edit when viewing a means test." H 2 G EN1Q
        S VALMBCK="",DGSAVE=VALMLST,DGSAVE1=VALMBG
        S VALMBG=1,VALMLST=DGCNT D SEL^VALM2 S VALMBG=DGSAVE1,VALMLST=DGSAVE G EN1Q:'$O(VALMY(0))
        N CTR S CTR=0 F  S CTR=$O(VALMY(CTR)) Q:'CTR  D
        . D ADD(DFN,DGDEP(CTR),$G(DGMTI))
        S DGMTD=$S($G(DGMTI):$P(^DGMT(408.31,DGMTI,0),U),1:DT)
        D ALL^DGMTU21(DFN,"VSC",DGMTD,"IPR",DGMTI)
        K DGDEP D INIT^DGDEP
        S DGMTDPCH=1
EN1Q    S VALMBCK="R" Q
        ;
ADD(DFN,DGDEP,DGMTI)    ;Add
        N DA,DR,DIE,DGMTD,DGIRI
        I '$G(DGMTI) W !,"Not a means test - use means test options." H 2 G ADDQ
        I $G(DGMTACT)="VEW" W !,"Cannot edit when viewing a means test." G ADDQ
        S DGMTR=$O(^DG(408.11,"B",$P(DGDEP,U,2),"")) I '$P(^DG(408.11,DGMTR,0),U,4) D  G ADDQ
        . W !,"Cannot add a "_$P(DGDEP,U,2)_" as a dependent to the means test." H 2
        S DGMTD=$S($G(DGMTI):$P($G(^DGMT(408.31,DGMTI,0)),U),1:DT)
        D GETIENS^DGMTU2(DFN,$P(DGDEP,U,20),DGMTD)
        S DA=DGIRI
        S DIE="^DGMT(408.22,",DR="31////"_DGMTI
        D ^DIE
        S DGMTDPCH=1
ADDQ    Q
        ;
EN2     ; Remove dependent from means test
        ;
        N DGSAVE1,DGSAVE2,DGMTD
        I '$G(DGMTI) W !,"Not a means test - use means test options." H 2 G EN2Q
        I $G(DGMTACT)="VEW" W !,"Cannot edit when viewing a means test." H 2 G EN2Q
        S VALMBCK="",DGSAVE1=VALMBG,DGSAVE2=VALMLST,VALMBG=2
        S VALMLST=DGCNT D SEL^VALM2 S VALMBG=DGSAVE1,VALMLST=DGSAVE2 G EN1Q:'$O(VALMY(0))
        N CTR S CTR=0 F  S CTR=$O(VALMY(CTR)) Q:'CTR  D
        . D REMOVE(DFN,DGDEP(CTR),$G(DGMTI))
        S DGMTD=$S($G(DGMTI):$P(^DGMT(408.31,DGMTI,0),U),1:DT)
        D ALL^DGMTU21(DFN,"VSC",DGMTD,"IPR",DGMTI)
        S DGMTDPCH=1
EN2Q    S VALMBCK="R" Q
        ;
REMOVE(DFN,DGDEP,DGMTI) ;Remove
        N DA,DR,DIE,DGMTD
        I '$G(DGMTI) W !,"Not a means test - use means test options." H 2 G REMOVEQ
        I $G(DGMTACT)="VEW" W !,"Cannot edit when viewing a means test." H 2 G EN2Q
        S DGMTD=$S($G(DGMTI):$P($G(^DGMT(408.31,DGMTI,0)),U),1:DT)
        D GETIENS^DGMTU2(DFN,$P(DGDEP,U,20),DGMTD)
        S DA=DGIRI
        S DIE="^DGMT(408.22,",DR="31////@"
        D ^DIE S DGREMOVE=1
        K DGDEP D INIT^DGDEP
        S DGMTDPCH=1
REMOVEQ K DGREMOVE Q
        ;
EN3     ; Edit dependent demo
        ;
        S VALMBCK=""
        N DGSAVE1,DGSAVE2,DGMTD,DGBEG,I
        I $G(DGMTACT)="VEW" W !,"Cannot edit when viewing a means test." H 2 G EN3Q
        I '$D(DGMTI),$G(DGRPV)=1 W !,"Not while viewing" H 2 G EN3Q
        S VALMBCK="",DGSAVE1=VALMBG,DGSAVE2=VALMLST,VALMBG=1
        S VALMLST=DGCNT D SEL^VALM2 S VALMBG=DGSAVE1,VALMLST=DGSAVE2 G EN1Q:'$O(VALMY(0))
        N CTR S CTR=0 F  S CTR=$O(VALMY(CTR)) Q:'CTR  D
        . D EDITD(DFN,DGDEP(CTR),CTR,$G(DGMTI))
        S VALMBCK="R"
        K DGDEP D INIT^DGDEP
EN3Q    Q
        ;
EDITD(DFN,DGDEP,DGW,DGMTI)      ; Edit
        N DA,DR,DIE,DGMTDT,SPOUSE,DGREL,DGDR,CNT,RELATION,MTVER
        I $G(DGMTACT)="VEW" W !,"Cannot edit when viewing a means test." H 2 G EDITDQ
        W !!,$P(DGDEP,U)
        I '$G(DGMTI),$P(DGDEP,U,2)="SELF" D  G EDITDQ
        . S DGREL("V")=$P(DGDEP,U,20) D SPOUSE^DGRPEIS2
        I '$G(DGMTI) W !,"Can only input information for veteran." H 2 G EN3Q
        S DGMTDT=$P(^DGMT(408.31,DGMTI,0),U)
        S MTVER=$P($G(^DGMT(408.31,DGMTI,2)),U,11)
        I $P(DGDEP,U,2)="SPOUSE" W !,"Married information is entered under the veteran." H 2 G EDITDQ
        I $P(DGDEP,U,2)="SELF" D  G EDITDQ
        . S DGDR=101
        . D GETREL^DGMTU11(DFN,"S",$$LYR^DGMTSCU1($S($G(DGMTDT):DGMTDT,1:DT)))
        . D GETIENS^DGMTU2(DFN,DGPRI,DGMTDT) S DGVIRI=DGIRI
        . I DGVIRI<0 W !,"No information in Income Relation file." H 2 G EDITDQ
        . S DA=DGVIRI,DIE="^DGMT(408.22,",DR="[DGMT ENTER/EDIT MARITAL STATUS]" D ^DIE K DA,DIE,DR
        . I $G(DGMTI),$G(DGREL("S")) D
        . . S SPOUSE=+DGREL("S")
        . . D INIT^DGDEP
        . . S CNT=0 F  S CNT=$O(DGDEP(CNT)) Q:'CNT  I $P(DGDEP(CNT),U,20)=SPOUSE D ADD(DFN,DGDEP(CNT),DGMTI)
        S RELATION=$O(^DG(408.11,"B",$P(DGDEP,U,2),""))
        I '$P(^DG(408.11,+RELATION,0),U,4) W !,"Not applicable for means test" H 2 G EDITDQ
        S DGPRI=$P(DGDEP,U,20)
        D EDTV1^DGMTSC11(MTVER)
        I $G(DGFL)'<0 D ADD(DFN,DGDEP,DGMTI)
EDITDQ  ;
        Q
