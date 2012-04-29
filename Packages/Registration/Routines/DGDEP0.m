DGDEP0  ;ALB/CAW,JAN,BAJ,ERC - Dependent Driver (con't) ; 8/1/08 1:08pm
        ;;5.3;Registration;**45,60,395,624,653,688**;Aug 13, 1993;Build 29
        ;
RETDEP  ;Return printable data of dependents
        Q:'$D(DGDEP("DGDEP",$J))
        N ACT,ACTIVE,CNT,CNTR,DEP,DGII,DGX,EDATE,INCOME,INCPER,MORE,NAME,RELATE
        F DGII=0:0 S DGII=$O(DGDEP(DGII)) Q:'DGII  K DGDEP(DGII) ; clear dependent array
        S RELATE=0,CNT=1
        ;
        F  S RELATE=$O(DGDEP("DGDEP",$J,RELATE)) Q:'RELATE  D
        .;
        .S MORE=0
        .F  S MORE=$O(DGDEP("DGDEP",$J,RELATE,MORE)) Q:'MORE  S DEP=DGDEP("DGDEP",$J,RELATE,MORE) D  S CNT=CNT+1,DGCNT=CNT-1
        ..;
        ..S $P(DGDEP(CNT),U,2)=$P($G(^DG(408.11,RELATE,0)),U)
        ..S NAME=$P(DEP,U),$P(DGDEP(CNT),U)=$P(DEP,U)
        ..S $P(DGDEP(CNT),U,3)=$S($P(DEP,U,2)="M":"Male",$P(DEP,U,2)="F":"Female",1:"Unknown"),$P(DGDEP(CNT),U,20)=$P(DEP,U,20)
        ..S $P(DGDEP(CNT),U,21)=$P(DEP,U,21),$P(DGDEP(CNT),U,22)=$P(DEP,U,22)
        ..N Y S Y=$P(DEP,U,3) D DD^%DT S $P(DGDEP(CNT),U,4)=Y
        ..;
        ..;SSN and SSN Verification status modifications DG*5.3*688 BAJ 11/22/2005
        ..;format SSN for display
        ..I $P(DEP,U,9) D
        ... N T S $P(DGDEP(CNT),U,5)=$E($P(DEP,U,9),1,3)_"-"_$E($P(DEP,U,9),4,5)_"-"_$E($P(DEP,U,9),6,10)
        ... S T=$P(DEP,U,11)
        ... S $P(DGDEP(CNT),U,9)=$S(T=4:"VERIFIED",T=2:"INVALID",1:"")
        ...;set 10th piece to value of Pseudo SSN Reason, if there is one
        ...;for DG*5.3*653 - ERC
        ...S $P(DGDEP(CNT),U,10)=$S($P(DEP,U,10)="R":"Refused to Provide",$P(DEP,U,10)="S":"SSN Unknown/Follow-up Required",$P(DEP,U,10)="N":"NO SSN ASSIGNED",1:"")
        ..;
        ..S INCOME=$P(DGDEP("DGDEP",$J,RELATE,MORE),U,21)
        ..S INCPER=$P(DGDEP("DGDEP",$J,RELATE,MORE),U,22)
        ..I RELATE>1 S DGDEP(CNT,"MNADD")=$$SPDEPADD(INCPER)
        ..I RELATE=1 D SELF("",NAME,RELATE,"",DGDEP(1),$G(DGMTI),CNT)
        ..S ACT=$O(DGDEP("DGDEP",$J,RELATE,MORE,"")) Q:'ACT  S ACT=DGDEP("DGDEP",$J,RELATE,MORE,+ACT)
        ..I RELATE=1 D SELF(INCPER,NAME,RELATE,ACT,DGDEP(1),$G(DGMTI),CNT)
        ..I RELATE=2 D DEP(INCPER,NAME,RELATE,ACT,DGDEP(CNT),$G(DGMTI),$G(DGMTACT),CNT)
        ..I RELATE>2 D DEP(INCPER,NAME,RELATE,ACT,DGDEP(CNT),$G(DGMTI),$G(DGMTACT),CNT)
        ..S EDATE="",CNTR=0
        ..F  S EDATE=$O(DGDEP("DGDEP",$J,RELATE,MORE,EDATE)) Q:EDATE']""  S ACTIVE=DGDEP("DGDEP",$J,RELATE,MORE,EDATE) D
        ...;
        ...N Y S Y=+ACTIVE D DD^%DT S DGDEP(CNT,EDATE)=Y
        ...S $P(DGDEP(CNT,EDATE),U,2)=$S($P(ACTIVE,U,2)=1:"Active",1:"Inactive")
        ...S $P(DGDEP(CNT,EDATE),U,3)=$P(ACTIVE,U,3)
        K DGDEP("DGDEP",$J)
        Q
        ;
SELF(INCPER,NAME,RELATE,ACT,DGDEP,DGMTI,CNT)    ;
        I $G(DGMTI),$G(DGMTACT)="VEW" G SELFQ
        I $G(DGMTI) D ADD^DGDEP2(DFN,DGDEP,DGMTI)
SELFQ   I INCPER>0 D SELF^DGDEP3(INCPER,NAME,RELATE,ACT,$G(DGMTI),CNT)
        Q
        ;
DEP(INCPER,NAME,RELATE,ACT,DGDEP,DGMTI,DGMTACT,CNT)     ;
        ;
        I $G(DGMTI),$G(DGMTACT)="VEW" G DEP1
        I $G(DGMTI),$P(ACT,U,2),$G(DGMTACT)="ADD",'$G(DGREMOVE) D ADD^DGDEP2(DFN,DGDEP,DGMTI)
DEP1    I RELATE=2 D SELF^DGDEP3(INCPER,NAME,RELATE,ACT,$G(DGMTI),CNT) G DEPQ
        I INCPER>0 D CHILD^DGDEP3(INCPER,NAME,RELATE,ACT,$G(DGMTI),$G(DGMTACT),CNT)
DEPQ    Q
        ;
SPDEPADD(INCPER)        ;Return Spouse/Dependent Maiden Name and Address info
        N ADDCKVAL,INDAIIEN,PRIEN,IPIEN,SPDEPINF
        S INDAIIEN=$P($G(^DGMT(408.22,INCPER,0)),"^",2)
        S PRIEN=$P($G(^DGMT(408.21,INDAIIEN,0)),"^",2)
        S IPIEN=$P($G(^DGPR(408.12,PRIEN,0)),"^",3)
        I IPIEN["DGPR(408.13" DO
        . S IPIEN=$P(IPIEN,";",1)
        . S SPDEPINF=$P($G(^DGPR(408.13,IPIEN,1)),"^",1,8)
        Q SPDEPINF
