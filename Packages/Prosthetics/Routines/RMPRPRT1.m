RMPRPRT1        ;PHX/HNB-CONTINUATION OF PRINT 2319 ;10/19/1993
        ;;3.0;PROSTHETICS;**10,99,137,141**;Feb 09, 1996;Build 5
        ;CALLED BY END^RMPRPRT
        ;VARIABLES REQUIRED: R5 - A STRING ARRAY HOLDING PATIENT'S PROSTHETIC
        ;                         DISABILITY CODE INFORMATION
        N RMPRMERG S RMPRMERG=0
        I $D(^XDRM("B",RMPRDFN_";DPT(")) D
        . S RMPRMERG=$O(^XDRM("B",RMPRDFN_";DPT(",RMPRMERG)) Q:RMPRMERG=""
        . S RMPRMERG=+^XDRM(RMPRMERG,0)
        I $Y>(IOSL-6) W @IOF D HDR^RMPRPRT
        W !!,"PSC Issue Card: " S J=0 W !
        F I=1:1 D  Q:J'>0
        .I $Y>(IOSL-6) W @IOF D HDR^RMPRPRT
        .S J=$O(R5(5,J)) Q:J=""!(J?.A)  Q:$G(J)<1 
        .S L=$P(R5(5,J,0),U,1) ;S L=$P(R5(5,J,0),U,1) 
        .W $E(L,4,5)_"-"_$E(L,6,7)_"-"_$E(L,2,3),?17,"Appl: ",$S($D(^RMPR(661,+$P(R5(5,J,0),U,4),0)):$E($P(^PRC(441,+$P(^(0),U),0),U,2),1,37),1:"UNKNOWN"),?66,"SN: ",$P(R5(5,J,0),U,3),!
        I I=1 W "NONE LISTED",!
        W !,"Clothing Allowance: ",!
        I $D(R5(6)),$O(R5(6,0))>0 D
        .F RI=0:0 S RI=$O(^RMPR(665,RMPRDFN,6,"B",RI)) Q:RI'>0  D
        ..S RA=$O(^RMPR(665,RMPRDFN,6,"B",RI,0))
        ..S RR5=R5(6,RA,0),RR5=RR5
        ..;D  I $Y>(IOSL-6) W @IOF D HDR^RMPRPRT
        ..W ?22,"DATE: ",$E(RR5,4,5)_"-"_$E(RR5,6,7)_"-"_$E(RR5,2,3)
        ..W "  ",$S($P(RR5,U,2)["E":"ELIGIBLE",$P(RR5,U,2)["N":"NOT-ELIGIBLE",1:"")
        ..W "  ",$S($P(RR5,U,3)["S":"STATIC",$P(RR5,U,3)["N":"NON-STATIC",1:"")
        ..I $P(RR5,U,5) S Y=$P(RR5,U,5) D DD^%DT W !,?22,"Date of Exam: ",Y W:$P(RR5,U,6) "  Examiner: ",$E($P(^VA(200,$P(RR5,U,6),0),U,1),1,30)
        ..W !,?22,"Desc: "
        ..W $S($D(R5(6,RA,1)):$P(R5(6,RA,1),U),1:""),!
        ..I $Y>(IOSL-6) W @IOF D HDR^RMPRPRT
        I '$D(R5(6)),$P(R5(0),U,6)="" W "NONE LISTED",!
        S RO=0
        F  S RO=$O(^RMPR(667,"C",RMPRDFN,RO)) Q:RO'>0  D  I $Y>(IOSL-6) W @IOF D HDR^RMPRPRT
        .Q:$P(^RMPR(667,RO,2),U,1)=0
        .W:'$D(RMPRFLG) !,"Automobile(s):",?15,"Make",?27,"Model",?39,"Vehical ID #",?62,"Date Processed"
        .W:'$P(^RMPR(667,RO,0),U,6)'="" !?15,$E($P(^RMPR(667.2,$P(^RMPR(667,RO,0),U,6),0),U,1),1,11),?27,$E($P(^RMPR(667,RO,0),U,7),1,10),?39,$P(^RMPR(667,RO,0),U,1) S Y=$P(^RMPR(667,RO,0),U,8) D DD^%DT W ?64,Y S RMPRFLG=1
        I '$D(RMPRFLG) W !,"Automobile(s): NONE LISTED"
        W !,"Items Returned: "
        I $D(^RMPR(665,RMPRDFN,7,0)) D OLD^RMPRPAT1
        I $D(^RMPR(660.1,"C",RMPRDFN)) S RO=0 F  S RO=$O(^RMPR(660.1,"C",RMPRDFN,RO)) Q:RO'>0  D WRIL^RMPRPAT1
        I '$D(^RMPR(660.1,"C",RMPRDFN)) W "NONE LISTED"
        ;W !!,"Items on loan: " I $D(^RMPR(660.1,"C",RMPRDFN)) S RO=0 F  S RO=$O(^RMPR(660.1,"C",RMPRDFN,RO)) Q:RO=""  D WRIL^RMPRPAT1
        W !!,"Other Data: " S J=0 F I=1:1 S J=$O(R5(4,J)) Q:J=""!(J?.A)  W !?5,R5(4,J,0) I $Y>(IOSL-6) W @IOF D HDR^RMPRPRT
        I I=1 W "NONE LISTED"
        I $Y>(IOSL-6) W @IOF D HDR^RMPRPRT
        W !,"RECORD OF APPLIANCES/REPAIRS: " D HDRH S RC=0,(RA,AN)=""
        S RA=""
        F  S RA=$O(^RMPR(660,"AC",RMPRDFN,RA)) Q:RA'>0  S AN="" F  S AN=$O(^RMPR(660,"AC",RMPRDFN,RA,AN)) Q:AN'>0  S RC=RC+1,Y=^RMPR(660,AN,0) D PRT I $Y>(IOSL-6) W @IOF D HDR^RMPRPRT
        S RA=""
        I RMPRMERG D
        . F  S RA=$O(^RMPR(660,"AC",RMPRMERG,RA)) Q:RA'>0  S AN="" F  S AN=$O(^RMPR(660,"AC",RMPRMERG,RA,AN)) Q:AN'>0  S RC=RC+1,Y=^RMPR(660,AN,0) D PRT I $Y>(IOSL-6) W @IOF D HDR^RMPRPRT
        I RC=0 W !,"No Appliances or Repairs exist for this veteran!",!!
        E  W !!,"End of Appliance/Repair records for this veteran!",!!," *Historical Item"
EXIT    K I,IT,J,L,RC,K,RA,AN,DATE,TYPE,QTY,VEN,TRANS,TRANS1,STA,SN,DEL,CST,FRM,REM,R0,RMPRE,RMPRFLG,RO,Y G EXIT^RMPRPRT
HDRH    W !!?4,"DATE",?13,"QTY",?17," HCPCS DESC",?29,"N R ",?33,"VENDOR",?45,"STA",?50,"SERIAL NBR",?62,"DELIVERED",?72,"COST",!
        F L=1:1:79 W "-"
        Q
PRT     S DATE=$P(Y,U,3),TYPE=$P(Y,U,6),QTY=$P(Y,U,7),VEN=$P(Y,U,9),TRANS=$P(Y,U,4),STA=$P(Y,U,10),SN=$P(Y,U,11),DEL=$P(Y,U,12),AMIS=$P(Y,U,15)
        ;include 2529-3 data
        S CST=$S($P(Y,U,16)'="":$P(Y,U,16),$D(^RMPR(660,AN,"LB")):$P(^RMPR(660,AN,"LB"),U,9),1:"")
        ;vendor 2529-3
        I $D(^RMPR(660,AN,"LB")) S RMPRLPRO=$P(^("LB"),U,3) D
        .I RMPRLPRO="O" S RMPRLPRO="ORTHOTIC" Q
        .I RMPRLPRO="R" S RMPRLPRO="RESTROATION" Q
        .I RMPRLPRO="S" S RMPRLPRO="SHOE" Q
        .I RMPRLPRO="W" S RMPRLPRO="WHEELCHAIR" Q
        .I RMPRLPRO="N" S RMPRLPRO="FOOT CENTER" Q
        .I RMPRLPRO="D" S RMPRLPRO="DDC" Q
        S FRM=$P(Y,U,13),REM=$P(Y,U,18),DATE=$E(DATE,4,5)_"/"_$E(DATE,6,7)_"/"_$E(DATE,2,3)
        ;S TYPE=$S(TYPE="":"",$D(^RMPR(661,TYPE,0)):$P(^(0),U,1),1:"")
        S TYPE=$P($G(^RMPR(660,AN,1)),U,4)
        S VEN=$S(VEN="":"",$D(^PRC(440,VEN,0)):$P(^(0),U,1),1:"")
        S TRANS=$S(TRANS]"":TRANS,1:""),TRANS1="" S:TRANS="X" TRANS1=TRANS,TRANS=""
        S DEL=$E(DEL,4,5)_"/"_$E(DEL,6,7)_"/"_$E(DEL,2,3) S:DEL="//" DEL=""
        W !,RC,". ",DATE,?13,QTY,?17
        W AMIS_$S(TYPE'="":$E($P($G(^RMPR(661.1,TYPE,0)),U,2),1,10),$P(Y,U,26)="D":"DELIVERY",$P(Y,U,26)="P":"PICKUP",$P(Y,U,17):"SHIPPING",1:"")
        ;AMIS_$S(TYPE'="":$E($P(^PRC(441,TYPE,0),U,2),1,10),$P(Y,U,26)="D":"DELIVERY",$P(Y,U,26)="P":"PICKUP",$P(Y,U,17):"SHIPPING",1:"")
        ;I TYPE=""&($D(^RMPR(660,$P(IT(RK),U,1),"HST"))) W $E($P(^("HST"),U,1),1,10)
        W ?29,TRANS,?31,TRANS1
        ;display source of procurement 2529-3 under vendor header
        I $D(RMPRLPRO) W ?33,RMPRLPRO
        K RMPRLPRO
        I VEN'="" W ?33,$E(VEN,1,10)
        W:$G(STA)'="" ?45,$P($G(^DIC(4,STA,99)),U,1) W ?50,$E(SN,1,10),?62,DEL,?72,$J($S(CST'="":CST,$P(Y,U,17):$P(Y,U,17),1:""),0,2)
        W:REM]"" !,?5,"REMARKS: ",REM I $Y+6>IOSL D HDR^RMPRPRT,HDRH
        S (DATE,TYPE,QTY,VEN,TRANS,TRANS1,STA,SN,DEL,CST,FRM,REM)=""
        Q
