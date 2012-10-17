IBYPSP  ;ALB/CXW - IB*2.0*427 POST INIT: REASONABLE CHARGES V3.5 ; 01/12/10
        ;;2.0;INTEGRATED BILLING;**427**;21-MAR-94;Build 7
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ; 
        Q
        ;
CPTLK   ; called by IBYP427
        ;
        D RVA ; activate Revenue Codes (399.2,2)
        ;
        D RVD^IBYPSP1 ; delete existing Revenue Code - CPT Links (#363.33)
        D RVL^IBYPSP1 ; add new/updated Revenue Code - CPT Links (#363.33)
        Q
        ;
RVA     ; activate Revenue Codes exported in RV-CPT links (399.2,2), if currently inactive
        N IBA,IBX,IBLN,IBI,IBRV,IBRVFN,IBRVLN,IBACT,IBCNT,IBJ,DD,DO,DIC,DIE,DA,DR,X,Y S IBCNT=0,IBACT=""
        ;
        F IBX=1:1 S IBLN=$P($T(FRVA+IBX),";;",2) Q:IBLN=""  D
        . F IBI=1:1 S IBRV=$P(IBLN,",",IBI) Q:IBRV'?3N  D
        .. ;
        .. S IBRVFN=$O(^DGCR(399.2,"B",IBRV,0)) Q:'IBRVFN
        .. S IBRVLN=$G(^DGCR(399.2,+IBRVFN,0)) Q:IBRVLN=""
        .. I +$P(IBRVLN,U,3) Q
        .. ;
        .. S IBCNT=IBCNT+1,IBACT=IBACT_IBRV_","
        .. S DR="2////1",DIE="^DGCR(399.2,",DA=+IBRVFN D ^DIE K DIE,DIC,DA,DR,X,Y
        ;
        I IBCNT>0 S IBJ=0 F IBI=1:15 S IBJ=IBJ+15 S IBLN=$P(IBACT,",",IBI,IBJ) Q:IBLN=""  D MSG("         "_IBLN)
        ;
RVAQ    S IBA(1)="",IBA(2)="      >> "_IBCNT_" Revenue Codes activated (399.2)..." D MSG(" ")
        D MES^XPDUTL(.IBA)
        Q
        ;
        ;
MSG(X)  ; 
        N IBX S IBX=$O(IBA(999999),-1) S:'IBX IBX=1 S IBX=IBX+1
        S IBA(IBX)=$G(X)
        Q
        ;
FRVA    ;  Revenue Codes to Activate (399.2,2)
        ;;160,251,252,255,258,259,260,264,270,271,272,273,275,276,277,278,279,290,292,294,
        ;;299,321,329,331,335,343,350,361,369,374,381,382,383,384,389,419,421,424,431,444,
        ;;472,483,513,516,519,530,531,540,541,542,544,545,549,551,552,560,561,570,571,580,
        ;;581,589,601,614,618,634,640,649,651,660,720,732,760,820,821,822,823,825,831,835,
        ;;881,903,923,929,940,942,963,974,975,987,
        ;;
