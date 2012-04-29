PSGOER  ;BIR/CML3-RENEW A SINGLE ORDER ; 12/3/08 10:26am
        ;;5.0; INPATIENT MEDICATIONS ;**11,30,29,35,70,58,95,110,111,133,141,198**;16 DEC 97;Build 7
        ;
        ; Reference to ^PS(51.1 supported by DBIA 2177.
        ; Reference to ^PS(55 supported by DBIA 2191.
        ; Reference to ^PSSLOCK is supported by DBIA 2789.
        ; Reference to ^PSBAPIPM is supported by DBIA 3564.
        ; Reference to ^PS(59.7 is supported by DBIA 2181.
        ; Reference to ^PSDRUG( is supported by DBIA 2192.
        ;
        ; renew a single order
        I $G(PSJCOM) D ^PSJCOMR Q
        N PSJEXPIR S PSJEXPIR=$$EXPIRED(PSGP,PSGORD) I PSJEXPIR D  Q
        .W !!?3,"  THIS ORDER" W:PSJEXPIR'=2 " HAS BEEN INACTIVE FOR ONE OR MORE SCHEDULED",!?8," ADMINISTRATIONS AND"
        .W " CANNOT BE RENEWED!" D PAUSE^VALM1
        I $G(PSGSCH)]"",($G(PSGS0XT)="D"),($G(PSGAT)="") D  Q
        .N SWD,SDW,XABB,X,QX S X=$G(PSGSCH) D DW^PSGS0 Q:($G(X)="")  I $G(PSGS0XT)="" S PSGS0XT="D"
        .Q:((",P,R,")[(","_$G(PSGST)_","))
        .I $G(PSGS0XT)="D",$G(PSGAT)="" S CHK=1 W !!?3,"This order contains a 'DAY OF THE WEEK' schedule without admin times"
        .W !?11," and CANNOT be renewed!" D PAUSE^VALM1
        I $G(PSGSCH)]"",'$$DOW^PSIVUTL(PSGSCH),'$$PRNOK^PSGS0(PSGSCH) I '$D(^PS(51.1,"AC","PSJ",PSGSCH)) D  Q
        .W !!?3,"This order contains an invalid schedule and CANNOT be renewed!" D PAUSE^VALM1
        W !! K DIR S DIR(0)="Y",DIR("A")=$S($P(PSJSYSP0,"^",3):"RENEW THIS ORDER",1:"MARK THIS ORDER FOR RENEWAL"),DIR("B")="YES"
        S DIR("?")="Answer 'YES' to "_$S($P(PSJSYSP0,"^",3):"renew this order",1:"mark this order for renewal")_".  Answer 'NO' (or '^') to stop now." D ^DIR
        I '$D(DIRUT),Y D NEW S PSGCANFL=1 D DONE Q
        I '$D(DIRUT),PSJSYSU S PSGND4=$G(^PS(55,PSGP,5,+PSGORD,4)) I $P(PSGND4,"^",15),$P(PSGND4,"^",16) D UNMARK,DONE Q
        D DONE,ABORT^PSGOEE
        Q
        ;
UNMARK  ;
        W !!,"THIS ORDER HAS BEEN 'MARKED FOR RENEWAL'.",! K DIR S DIR(0)="Y",DIR("A")="DO YOU WANT TO 'UNMARK IT'",DIR("B")="NO"
        S DIR("?",1)="  Answer 'YES' to unmark this order.  Answer 'NO' (or '^') to leave the order",DIR("?")="marked.  (An answer is required.)" D ^DIR
        I 'Y D ABORT^PSGOEE G DONE
        S DA(1)=PSGP,DA=+PSGORD,PSGAL("C")=21180+PSJSYSU D ^PSGAL5 S $P(PSGND4,"^",15,17)="^^",^PS(55,PSGP,5,DA,4)=PSGND4 W "...DONE!"
        ;
DONE    ;
        K %DT,DA,DIE,DIR,DR,FDSD,PSGAL,PSGALR,PSGDL,PSGDLS,PSGFD,PSGFOK,PSGND4,PSGOEE,PSGOER0,PSGOER1,PSGOER2,PSGOERDP,PSGOPR,PSGOSD,PSGPOSA,PSGPOSD,PSGPR,PSGPX,PSGRD,PSGSD,PSGTOL,PSGTOO,PSGUOW,PSGWLL,RF Q
        ;
NEW     ; get info, write record
EXTEND  ; extend stop date on renewal order
        N DUOUT,PSJABT,PSGDRG,PSJREN,PSGOREAS S PSGDRG=$P($G(^PS(55,PSGP,5,+PSGORD,1,1,0)),"^"),PSJREN=1
        I $G(PSGST)="O" N ACT S ACT=$$EN^PSBAPIPM(PSGP,PSGORD) I $P(ACT,"^",2),($P(ACT,"^",3)="G") I $P(ACT,"^",2)>$P($G(^PS(55,PSGP,5,+PSGORD,2)),"^",2) D  Q
        . W !!?5,"THIS ONE-TIME ORDER HAS ALREADY BEEN GIVEN AND CANNOT BE RENEWED",! S (DIRUT,PSGORQF)=1 D READ
        D OC55
        Q:$D(PSGORQF)  ; quit if not to continue
        D NOW^%DTC S PSGDT=%,PSGND4=$G(^PS(55,PSGP,5,+PSGORD,4)) I '$P(PSJSYSP0,"^",3) D MARK Q
        S PSGWLL=$S('$P(PSJSYSW0,"^",4):0,1:+$G(^PS(55,PSGP,5.1))),PSGOEE="R" K PSGOEOS
        K ^PS(53.45,PSJSYSP,1),^(2) D MOVE(3,1),MOVE(1,2)
        D DATE^PSGOER0(PSGP,PSGORD,PSGDT) I ($G(X)="^")!'$D(PSGFOK(106))!$G(DUOUT) D DONE,ABORT^PSGOEE S VALMBCK="R",COMQUIT=1 Q
SPEED   ;
        I +$G(PSJSYSU)=3 D EN^PSGPEN(PSGORD)
        Q:$G(DUOUT)
        N PSGOEAV S PSGOEAV=+PSJSYSU
        W !!,"...updating order..." K DA S DA(1)=PSGP,DA=+PSGORD,PSGAL("C")=PSJSYSU*10+18000 D ^PSGAL5 W "."
        I $$LS^PSSLOCK(PSGP,PSGORD) D UPDREN(PSGORD,PSGDT,PSGOEPR,PSGOFD,PSJNOO),UPDRENOE(PSGP,PSGORD,PSGDT) D UNL^PSSLOCK(PSGP,PSGORD)
        ;
        I 'PSGOERDP,$P(PSJSYSW0,"^",4),PSGFD'<PSGWLL S $P(^PS(55,PSGP,5.1),"^")=+PSGFD
        W ".DONE!" S VALMBCK="Q" Q
        ;
MARK    ;
        I $P(PSGND4,"^",15),$P(PSGND4,"^",16) W $C(7),!!?3,"...THIS ORDER IS ALREADY MARKED FOR RENEWAL!..." Q
        K DA S $P(PSGND4,"^",15,17)="1^"_DUZ_"^"_PSGDT,^PS(55,PSGP,5,+PSGORD,4)=PSGND4,PSGAL("C")=13180,DA(1)=PSGP,DA=+PSGORD W "." D ^PSGAL5
        I $D(PSJSYSO) S PSGORD=+PSGORD_"A",PSGPOSA="R",PSGPOSD=PSGDT D ENPOS^PSGVDS
        Q
MOVE(X,Y)       ; Move comments/dispense drugs from 55 to 53.45.
        S Q=0 F  S Q=$O(^PS(55,PSGP,5,+PSGORD,X,Q)) Q:'Q  S ^PS(53.45,PSJSYSP,Y,Q,0)=$G(^(Q,0))
        S:Q ^PS(53.45,Y,0)="^53.450"_Y_"P^"_Q_U_Q
        Q
OC55    ;* Order checks for Speed finish and regular finish
        N INTERVEN,PSJDDI,PSJIREQ,PSJRXREQ,PSJPDRG
        S Y=1,(PSJIREQ,PSJRXREQ,INTERVEN,X)=""
        K PSGORQF D ENDDC^PSGSICHK(PSGP,+$G(^PS(55,PSGP,5,+PSGORD,1,1,0)))
        I '$D(PSGORQF) K PSGORQF,^TMP($J,"DI") D
        . F PSGDDI=1:0 S PSGDDI=$O(^PS(55,PSGP,5,+PSGORD,1,PSGDDI)) Q:'PSGDDI  S PSJDD=+$G(^PS(55,PSGP,5,+PSGORD,1,PSGDDI,0)) K PSJPDRG D IVSOL^PSGSICHK
        Q
UPDREN(PSGORD,RNWDT,PSGOEPR,PSGOFD,PSJNOO,RDUZ) ; update renewed order
        N DR,DA,DIC,DIE,DD,DO,PSGRZERO,PSGRFOUR,PSGOORD
        S DR="",PSGOEENO=0,PSGOORD=PSGORD,PSGNESD=PSGSD Q:'PSGORD!'RNWDT!'PSGOEPR!'PSGOFD  S PSJNOO=$S($G(PSJNOO)]"":$G(PSJNOO),1:"E")
        S PSGRZERO="^PS(55,"_PSGP_",5,"_+PSGORD_",0)",PSGOEORD=$P(@PSGRZERO,"^",21)
        ; PSJ*5*141 - changed PSGOEPR to PSGPR for field 1 of the DR string below.
        S DA(1)=PSGP,DA=+PSGORD,DIE="^PS(55,"_PSGP_",5," S DR="34////^S X=PSGFD" S:$G(PSGPR) DR=DR_";1////"_PSGPR_";110////"_PSJNOO D ^DIE
        K DR,DA,DIC,DIE,DD,DO S DIC="^PS(55,"_PSGP_",5,"_+PSGORD_",14,",DIC(0)="L",DIC("P")="55.6114DA",ND14=$G(@(DIC_"0)")),DINUM=$P(ND14,"^",3)+1,DA(2)=PSGP,DA(1)=+PSGORD D
        . S DIC("DR")=".01////"_$G(RNWDT)_";1////"_$S($G(RDUZ):RDUZ,1:$G(DUZ))_";2////"_$G(PSGOEPR)_";3////"_$G(PSGOFD)_";4////"_+PSGOEORD,X=$G(RNWDT) D FILE^DICN
        K DR,DA,DIC,DIE,DD,DO S DA(1)=PSGP,DA=+PSGORD,DIE="^PS(55,"_PSGP_",5,",DR="28////A;105////@;107////@"
        ;PSJ*5*198
        S PSGRFOUR="^PS(55,"_PSGP_",5,"_+PSGORD_",4)",PSGRFOUR=@PSGRFOUR I $P(PSGRFOUR,"^",2)<RNWDT S DR=DR_";16////@;17////@" I $G(PSJORD)["P",+PSJSYSU=1 S DR=DR_";18////@;19////@"
        I '$G(PSJSPEED) I $G(PSGAT)]"",$G(PSGAT)'=$P($G(@(DIE_+PSGORD_",2)")),"^",5) S DR=DR_";41////"_PSGAT
        D ^DIE
        Q
UPDRENOE(PSGP,PSGORD,RDATE)     ;
        D EXPOE(PSGP,PSGORD,$G(RDATE)) ; expire original Orders File order
        I PSGORD'["P" K DA,DR,DIE S DA(1)=DFN,DA=+PSGORD,DIE="^PS(55,"_DFN_$S(PSGORD="U":",5,",1:",""IV"","),DR=$S(DIE["IV":110,1:66)_"////@" D ^DIE
        D ENUDTX^PSJOREN(PSGP,PSGORD,"NR")
        D EN1^PSJHL2(PSGP,"SN",PSGORD,"ORDER RENEWED")
        Q
READ    ; hold screen
        I $D(IOST) Q:$E(IOST)'="C"
        W !?5,"Press return to continue  " R X:$S($D(DTIME):DTIME,1:300)
        Q
EXPOE(DFN,PSJORDER,EXPDT)       ; expire old Orders File entry
        I PSJORDER["P" S FILE="^PS(53.1,"_+PSJORDER_",0)",PSJORDER=$P(@FILE,"^",25)
        I (PSJORDER'["U"),(PSJORDER'["V") Q
        N CURDAT D NOW^%DTC S CURDAT=$$DATE2^PSJUTL2(%)
        S PSJEXPOE=$S($G(EXPDT):EXPDT,1:CURDAT) D EN1^PSJHL2(DFN,"SC",PSJORDER) K PSJEXPOE
        Q
EXPIRED(PSJX,PSJY)      ;
        ; INPUT
        ;       PSJX - Pharmacy Patient, pointer to ^PS(55
        ;       PSJY - Inpatient Order Number (appended with "V" or "U")
        ; OUTPUT
        ;   0  -  Order has not exceeded the Expired Time Limit
        ;   1  -  Order has exceeded the Expired Time Limit
        N STOP,STATUS,NOW,CUTOFF,FREQ,LAST,ST,X,DFN,U,PSGDT,SD,WD,PSJPSTO,PSGDW,PSGOC,ZZND,LASTAT,LSTSTR,PSBCNT S DFN=PSJX,U="^",CUTOFF=0
        S STATUS=$S(PSJY["U":$P($G(^PS(55,PSJX,5,+PSJY,0)),"^",9),PSJY["V":$P($G(^PS(55,PSJX,"IV",+PSJY,0)),"^",17),1:"")
        S NOW=$S($G(PSGDT):PSGDT,1:$$DATE^PSJUTL2())
        S STOP=$S(PSJY["U":$P($G(^PS(55,PSJX,5,+PSJY,2)),U,4),1:$P($G(^PS(55,PSJX,"IV",+PSJY,0)),"^",3))
        I NOW<STOP Q 0
        I PSJY["U" N ND2,ND0 S ND0=$G(^PS(55,PSJX,5,+PSJY,0)),ND2=$G(^PS(55,PSJX,5,+PSJY,2)),FREQ=$P(ND2,"^",6) D
        .N SCHED S SCHED=$P($G(^PS(55,PSJX,5,+PSJY,2)),"^") I SCHED["PRN" S FREQ=$$PRNFREQ(SCHED)
        .S LSTSTR=$P(ND2,"^",2)_"^"_$P(ND2,"^",4)_"^"_SCHED_"^"_$P(ND0,"^",7)_"^^"_$P(ND2,"^",5)
        .S LAST=$$EN^PSBAPIPM(PSJX,PSJY) I LAST,($P(ND0,"^",7)="O"),($P(LAST,"^",3)="G") I LAST>$P(ND2,"^",2) S CUTOFF=$$FMADD^XLFDT(NOW,,-1) Q
        .I 'LAST!(LAST>$P(ND2,"^",4)) S LAST=$$LASTAT^PSJORP2(DFN,LSTSTR) S:LAST CUTOFF=$$FMADD^XLFDT(LAST,,,FREQ) Q
        .I SCHED["PRN",($P(LSTSTR,"^",6)="") S CUTOFF=$$FMADD^XLFDT(LAST,,,FREQ) Q
        .I $$DOW^PSIVUTL(SCHED) S CUTOFF=$$NXTDOW(DFN,$P(LSTSTR,"^"),$P(LSTSTR,"^",2),$P(LSTSTR,"^",3),$P(LSTSTR,"^",6)) Q
        .S LAST=$$EN^PSBAPIPM(PSJX,PSJY) I 'LAST!(LAST>$P(ND2,"^",4)) S CUTOFF=$$FMADD^XLFDT(NOW,,-1) Q
        .S $P(LSTSTR,"^")=$$FMADD^XLFDT(LAST,,,,1),$P(LSTSTR,"^",2)=$$FMADD^XLFDT(PSGDT,,,FREQ) S CUTOFF=$$ENQ^PSJORP2(PSJX,LSTSTR)
        I PSJY["V" N LIMIT S LIMIT=$P($G(^PS(59.7,1,31)),"^",4) S LIMIT=$S((LIMIT]""):+LIMIT,1:24) S CUTOFF=$$FMADD^XLFDT(STOP,,LIMIT) D
        .I '($G(P(4))]"") N P,YP,XP S YP=$G(^PS(55,DFN,"IV",+PSJY,0)) F XP=1:1:23 S P(XP)=$P(YP,U,XP)
        .Q:'($G(P(4))]"")
        .Q:'$$SCHREQ^PSJLIVFD(.P)
        .N INTERVAL,LSTSTR,ND0,SCHED,IVSTYP S ND0=$G(^PS(55,PSJX,"IV",+PSJY,0)),INTERVAL=$P(ND0,"^",15),SCHED=$P(ND0,"^",9) Q:SCHED=""
        .S IVSTYP=$S($$DOW^PSIVUTL(SCHED):"D",INTERVAL="O":"O",1:"C"),LSTSTR=$P(ND0,"^",2)_"^"_$P(ND0,"^",3)_"^"_SCHED_"^"_IVSTYP_"^^"_$P(ND0,"^",11)
        .S LAST=$$EN^PSBAPIPM(PSJX,PSJY) I LAST,IVSTYP="O",LAST>$P(ND0,"^",2),($P(LAST,"^",3)="G") S CUTOFF=$$FMADD^XLFDT(NOW,,-1) Q
        .I 'LAST!(LAST>$P(ND0,"^",3))!(LAST&(IVSTYP="O")) S CUTOFF=$$FMADD^XLFDT(NOW,,-1) Q
        .I IVSTYP="D" S CUTOFF=$$NXTDOW(LAST,SCHED,$G(P(2)),$P($G(P(9)),"@"),$G(P(11))) Q
        .I SCHED["PRN" S FREQ=$$PRNFREQ(SCHED) S CUTOFF=$$FMADD^XLFDT(LAST,,,FREQ) Q
        .S LAST=$$EN^PSBAPIPM(PSJX,PSJY) I 'LAST!(LAST>$P(ND0,"^",3)) S CUTOFF=$$FMADD^XLFDT(NOW,,-1) Q
        .S $P(LSTSTR,"^")=$$FMADD^XLFDT(LAST,,,,1),$P(LSTSTR,"^",2)=$$FMADD^XLFDT(PSGDT,31) S CUTOFF=$$ENQ^PSJORP2(PSJX,LSTSTR)
        K LYN,PSBDT,PSBFLAG,PSBSTR
        Q $S(CUTOFF<NOW:1,1:0)
        ;
NXTDOW(DOWDFN,DOWSD,DOWFD,DOWSCH,DOWAT) ;
        N NXTADM,DOWSTR S DOWSTR=$$FMADD^XLFDT(DOWFD,,,,1)_"^"_$$FMADD^XLFDT(DOWFD,7)_"^"_DOWSCH_"^D^^"_DOWAT S NXTADM=$$ENQ^PSJORP2(DOWDFN,DOWSTR)
        Q $S(NXTADM:NXTADM,1:DOWSD)
        ;
PRNFREQ(SCHED)  ;
        N ZZND,D,DA,X,PSGAT,PSGOES,PSGST,PSJNSS,PSJPWD,TEST,VALMBCK,PSGS0XT,PSGS0Y,PSGDT
        F X=$P(SCHED,"PRN"),$P(SCHED,"PRN",2),$P(SCHED," PRN"),$P(SCHED,"PRN ",2) Q:$P($G(ZZND),"^",4)  D ADMIN^PSJORPOE
        Q $S($G(PSGS0XT):PSGS0XT,1:1440)
