PSGOECS ;BIR/CML3-CANCEL SELECTED ORDERS ;02 Mar 99 / 9:29 AM
        ;;5.0; INPATIENT MEDICATIONS ;**23,29,44,58,81,110,134**;16 DEC 97;Build 124
        ;
        ; Reference to FULL^VALM1 is supported by DBIA# 10116.
        ; Reference to ^PS(55 is supported by DBIA# 2191.
        ; Reference to ^PSSLOCK is supported by DBIA #2789.
        ;
AM      ;
        W !,"...marking ",$P(X,U),"..." S $P(^PS(55,PSGP,5,DA,4),"^",11,14)="^1^"_DUZ_"^"_PSGDT,PSGAL("C")=13040 W "." D ^PSGAL5 W "."
        I $D(PSJSYSO) S PSGORD=+PSGORD_"A",PSGPOSA="C",PSGPOSD=PSGDT D ENPOS^PSGVDS
        Q
        ;
NM      ;
        W !,"...marking ",$P(X,U),"..." S $P(^PS(53.1,DA,4),"^",11,14)="^1^"_DUZ_"^"_PSGDT W "."
        I $D(PSJSYSO) S PSGORD=+PSGORD_"N",PSGPOSD=PSGDT,PSGPOSA="C" D ENPOS^PSGVDS
        Q
        ;
AC      ; discontinue active order
        K DA S DA(1)=PSGP,DA=+PSGORD
        S X=$G(^PS(55,PSGP,5,DA,.2))
        I $P(X,U,4)="D" W !,$P($$DRUGNAME^PSJLMUTL(DFN,PSGORD),U,1),!,"NO ACTION WAS TAKEN ON DONE ORDER",!,$C(7) HANG 1 Q 
        NEW XX S XX=$P(^PS(55,PSGP,5,DA,0),U,9)
        I $S(XX="E":1,XX="D":1,XX="DE":1,1:0) W !,$P($$DRUGNAME^PSJLMUTL(DFN,PSGORD),U,1),!,"NO ACTION WAS TAKEN ON "_$$CODES^PSIVUTL(XX,55.06,28)_" ORDER",!,$C(7) HANG 1 Q
        S X=$$DRUGNAME^PSJLMUTL(PSGP,PSGORD)
        I '$P(PSJSYSP0,"^",5) D AM Q
        W !,"...discontinuing ",$P(X,U),"...",! S PSGAL("C")=PSJSYSU*10+4000 D ^PSGAL5
        S PSGALR=20,DIE="^PS(55,"_PSGP_",5,",DR="28////D;Q;34////"_PSGDT_$S(PSJSYSU:"",1:";49////1"),DP=55.06,$P(^(2),"^",3)=$P(^PS(55,PSGP,5,DA,2),"^",4) D ^DIE S ^PS(55,"AUE",PSGP,DA)=""
        D EN1^PSJHL2(PSGP,"OD",PSGORD) S DA(1)=PSGP,DA=+PSGORD
        I PSJSYSL S $P(^PS(55,PSGP,5,DA,7),"^",1,2)=PSGDT_"^D",PSGTOL=2,PSGUOW=DUZ,PSGTOO=1 D ENL^PSGVDS
        Q
        ;
NC      ; discontinue non-verifed order
        I $P($G(^PS(53.1,+PSGORD,0)),U,24)="R" S PSJDCTYP=$$PNDRNA^PSGOEC(PSGORD) I $G(PSJDCTYP)'=1 D PNDRN($G(PSJDCTYP)) Q
NC2     ; Called from PNDRN to discontinue both pending renewal and original order
        K DA S DA=+PSGORD,X=$G(^PS(53.1,DA,.2)),X=$$DRUGNAME^PSJLMUTL(PSGP,PSGORD)
        I $S($P(PSJSYSP0,"^",5):0,'$D(^PS(53.1,DA,4)):1,1:$P(^(4),"^",7)'=DUZ) D NM Q
        W !,"...discontinuing ",$P(X,U),"...",! S DIE="^PS(53.1,",DR="28////D"_$S(PSJSYSU:"",1:";42////1") D ^DIE
        D EN1^PSJHL2(PSGP,"OC",PSGORD)
        S DA=+PSGORD I PSJSYSL,PSJSYSL<3 S $P(^PS(53.1,DA,7),"^",1,2)=PSGDT_"^D",PSGTOO=2,PSGUOW=DUZ,PSGTOL=2 D ENL^PSGVDS
        I $G(PSJDCTYP) D UNL^PSSLOCK(DFN,PSGORD)
        Q
        ;
EN      ; enter here
        I $G(PSJIVPRF) D ^PSIVSPDC Q  ;Use for Speed DC in IV Order Profile
        D FULL^VALM1
EN1     ;
        S (PSGONC,PSGLMT)=PSJOCNT,PSGONW="C" D ENWO^PSGON I "^"[X K X G RESET
        D NOW^%DTC S PSGDT=+$E(%,1,12)
        W ! F PSGOECS=1:1:PSGODDD F PSGOECS1=1:1 S PSGOECS2=$P(PSGODDD(PSGOECS),",",PSGOECS1) Q:'PSGOECS2  D
        .S PSGORD=^TMP("PSJON",$J,PSGOECS2) ; I $P($G(@($S((PSGORD["A")!(PSGORD["U"):"^PS(55,"_PSGP_",5,",(PSGORD["V"):"^PS(55,"_PSGP_",""IV"",",1:"^PS(53.1,")_(+PSGORD)_",0)")),"^",21) Q
        S PSJNOO=$$ENNOO^PSJUTL5("D") G:PSJNOO<0 EN1
        ;Prompt for requesting provider
        W ! I '$$REQPROV^PSGOEC G EN1
        W !
        ;
        ;Replaced above line with block structure below.
        N COMFLG,PSJCOM S (EXITLOOP,PSJCOM)=0
        F PSGOECS=1:1:PSGODDD D
        .F PSGOECS1=1:1 D  Q:EXITLOOP=1
        ..S PSGOECS2=$P(PSGODDD(PSGOECS),",",PSGOECS1)
        ..I 'PSGOECS2 S EXITLOOP=1 Q
        ..S (ON,PSGORD)=^TMP("PSJON",$J,PSGOECS2)
        ..I PSGORD=+PSGORD D DCCOM Q
        ..I '$$LS^PSSLOCK(DFN,PSGORD) D  Q
        ... W:PSGORD'["V" !,$P($$DRUGNAME^PSJLMUTL(DFN,PSGORD),"^",1),!,"NO ACTION WAS TAKEN",!,$C(7) HANG 1 Q
        ... W ! I PSGORD["V" N PSJLINE S PSJLINE=1 D DSPLORDV^PSJLMUT1(PSGP,PSGORD) D  W !,"NO ACTION WAS TAKEN",!,$C(7) HANG 1
        ....F X=0:0 S X=$O(PSJOC(ON,X)) Q:'X  D
        .....W !,$G(PSJOC(ON,X))
        ..D CHKCOM I COMFLG  D
        ... I PSGORD'["V" W !,$P($$DRUGNAME^PSJLMUTL(DFN,PSGORD),"^",1),!,"NO ACTION WAS TAKEN",!,$C(7) HANG 1 Q
        ... W ! I PSGORD["V" N PSJLINE S PSJLINE=1 D DSPLORDV^PSJLMUT1(PSGP,PSGORD) D  W !,"NO ACTION WAS TAKEN",!,$C(7) HANG 1
        ....F X=0:0 S X=$O(PSJOC(ON,X)) Q:'X  D
        .....W !,$G(PSJOC(ON,X))
        ..Q:PSJCOM
        ..D:(PSGORD["U") AC
        ..D:(PSGORD["P") NC
        ..D:(PSGORD["V") SPDCIV^PSIVSPDC
        ..; Call the unlock procedure
        ..D UNL^PSSLOCK(DFN,PSGORD)
        S X=""
RESET   ;
        I $G(PSGORD)["V" D INIT^PSJLMHED(3) S VALMBK="R" G DONE
        D INIT^PSJLMHED(1) S VALMBCK="R"
        ;
DONE    ;
        K DA,DIE,DP,DR,PSGAL,PSGALR,PSGLMT,PSGODDD,PSGOECS,PSGOECS1,PSGOECS2,PSGONW,PSGORD,PSGPOSA,PSGPOSD,PSGTOL,PSGTOO,PSGUOW,ORIFN,ORETURN,ORNATR
        Q
        ;
DCOR    ; Create DC order/update stop date in OE/RR.
        S PSOC=$S(PSGORD["P":"OC",PSGORD["N":"OC",1:"OD")
        D EN1^PSJHL2(PSGP,PSOC,PSGORD)
        Q
        ;
ENOR    ;
        K DA S PSGEDIT=$S($D(PSGEDIT):PSGEDIT,1:"D"),CF=1,PSGALR=20,DA=+PSGORD,T="" I PSGORD'["U",(PSGORD'["O") D:CF NSET^PSGOEC D NC^PSGOEC D ENOR2 G DONE^PSGOEC
        S DA(1)=PSGP D:CF ASET^PSGOEC D AC^PSGOEC
        G DONE^PSGOEC
        ;
ENOR2   ;Check to see if order being DC'd is a Pending Renewal and is being DC'd due to edit.
        I PSGEDIT="DE",$P(^PS(53.1,+PSGORD,0),U,25),$P(^PS(53.1,+PSGORD,0),U,24)="R",PSGSD<$P($G(^PS(55,PSGP,5,+$P(^PS(53.1,+PSGORD,0),U,25),2)),U,4) D
        .K DA,DR S DA(1)=PSGP,DA=+$P(^PS(53.1,+PSGORD,0),U,25),DIE="^PS(55,"_PSGP_",5,",DR="34////"_PSGSD_";25////"_$P($G(^PS(55,PSGP,5,+$P(^PS(53.1,+PSGORD,0),U,25),2)),U,4)
        .D ^DIE,EN1^PSJHL2(PSGP,"XX",$P(^PS(53.1,+PSGORD,0),U,25))
        Q
        ;
CHKCOM  ;Check to see if order is part of complex order series.
        S PSJCOM=$S(PSGORD["V":$P($G(^PS(55,PSGP,"IV",+PSGORD,.2)),U,8),PSGORD["U":$P($G(^PS(55,PSGP,5,+PSGORD,.2)),U,8),1:$P($G(^PS(53.1,+PSGORD,.2)),U,8)),COMFLG=0
        N PSJSTAT S PSJSTAT=$S(PSGORD["V":$P($G(^PS(55,PSGP,"IV",+PSGORD,0)),"^",17),PSGORD["U":$P($G(^PS(55,PSGP,5,+PSGORD,0)),"^",9),1:$P($G(^PS(53.1,+PSGORD,0)),"^",9))
        Q:'PSJCOM  I "DE"[PSJSTAT Q
        W ! I PSGORD["V" N PSJLINE S PSJLINE=1 D DSPLORDV^PSJLMUT1(PSGP,PSGORD) D
        .F X=0:0 S X=$O(PSJOC(ON,X)) Q:'X  D
        ..W !,$G(PSJOC(ON,X))
        I PSGORD["U" W !,$P($$DRUGNAME^PSJLMUTL(PSGP,PSGORD),"^",1) D
        .W !!,"is part of a complex order. If you discontinue this order the following orders",!,"will be discontinued too (unless the stop date has already been reached)." D CMPLX^PSJCOM1(PSGP,PSJCOM,PSGORD)
        F  W !!,"Do you want to discontinue this series of complex orders" S %=1 D YN^DICN Q:%
        I %'=1 S COMFLG=1 Q
        N O,OO S O=0,OO="" F  S O=$O(^PS(55,"ACX",PSJCOM,O)) Q:'O  F  S OO=$O(^PS(55,"ACX",PSJCOM,O,OO)) Q:OO=""  D  Q:COMFLG
        .Q:OO=PSGORD  I '$$LS^PSSLOCK(DFN,OO) S COMFLG=1 Q
        Q:COMFLG
        N O,OO S O=0,OO="" F  S O=$O(^PS(55,"ACX",PSJCOM,O)) Q:'O  F  S OO=$O(^PS(55,"ACX",PSJCOM,O,OO)) Q:OO=""  D
        .I (OO["U") N PSGORD S PSGORD=OO D AC
        .I (OO["V") N PSGORD S (ON,PSGORD)=OO D SPDCIV^PSIVSPDC
        .D UNL^PSSLOCK(DFN,PSGORD)
        Q
        ;
DCCOM   ;DC pending/non-verified complex order
        I '$$LOCK^PSJOEA(DFN,PSGORD) W !,"Order # ",PSGOECS2," could not be discontinued.",!,$C(7) HANG 1 Q
        N PSGORD1 S PSGORD1=PSGORD
        N PSJO S PSJO=0 F  S PSJO=$O(^PS(53.1,"ACX",PSGORD1,PSJO)) Q:'PSJO  S PSGORD=PSJO_"P" D NC
        Q
PNDRN(PSJDCTYP) ; Discontinue both pending renewal and original order
        N TMPORD S TMPORD=$G(PSGORD)
        I PSJDCTYP=2 S PSJDCTYP=1 D NC2 Q:'$G(PSJDCTYP)  D
        .I ($G(PSJNOO)<0) Q
        .N ND5310 S ND5310=$G(^PS(53.1,+PSGORD,0))
        .N PSGORD S PSGORD=$P(ND5310,"^",25) I PSGORD S PSJDCTYP=2 D
        ..I '$$LS^PSSLOCK(DFN,PSGORD) K PSJDCTYP Q
        ..D @$S(PSGORD["U":"AC",PSGORD["V":"SPDCIV^PSIVSPDC",1:"")
        S PSGORD=TMPORD
        Q
