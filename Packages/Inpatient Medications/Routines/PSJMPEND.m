PSJMPEND        ;BIR/CML3-MD MARS - GATHER ACK ORDERS INFO (MDWS) ; 6/18/07 12:11pm
        ;;5.0; INPATIENT MEDICATIONS ;**191**;16 DEC 97;Build 9
        ;
PEND    ;*** Only select orders that were acknowledged by nurses and are
        ;*** still having pending status.
        NEW X S X=$O(^PS(59.6,"B",+PSJPWD,0)) Q:'+$P($G(^PS(59.6,+X,0)),U,6)
        NEW ND,ON,TYPE,QST
        F ON=0:0 S ON=$O(^PS(53.1,"AV",PSGP,ON)) Q:'ON  D
        . S ND=$G(^PS(53.1,ON,0)),TYPE=$P(ND,U,4)
        . S ND2=$G(^PS(53.1,ON,2)),PSGLSD=$P(ND2,U,2),PSGLFD=$P(ND2,U,4)
        . I $P(ND,U,7)="P"!($P($G(^PS(53.1,ON,2)),U)["PRN") S QST="PZ"_$S($P(ND,U,4)="F":"V",1:"A")
        . E  S QST="CZ"_$S($P(ND,U,4)="F":"V",1:"A")
        . I PSGMTYPE[1 D:TYPE'="F" SETTMP D:TYPE="F" IV
        . I PSGMTYPE'[1 D
        .. I PSGMTYPE[2,(TYPE="U") D SETTMP Q
        .. I PSGMTYPE'[2,(TYPE="I") D SETTMP Q
        .. I PSGMTYPE[4,(TYPE="F") D IV
        Q
        ;
SETTMP  ;*** Setup ^tmp for pending U/D and Inpatient med IVs.
        ;*** PZ_(V/A) = PRN/One time orders (V=IV).
        ;*** CZ_(V/A) = Continuous orders (A=U/D).
        I 'PSJMPRN,(QST["PZ") Q
        NEW MARX
        D DRGDISP^PSJLMUT1(PSGP,+ON_"P",20,0,.MARX,1) S DRG=MARX(1)_U_ON
        ;*** Set up ^TMP for sort by patients
        S PSJDOS=$P(^PS(53.1,ON,.2),U,2),PSJMR=$E($S($P(ND,U,3)]"":$P(ND,U,3),1:$P(ND,U)),1,5),PSJSCHE=$P($G(^PS(53.1,ON,2)),U)
        S PSJHOLD=$S($P(ND,U,9)["H":1,1:0),PSGLOD=$P(ND,U,14),PSJATME=9999,PSJADT=$S(QST["C":"8999999",1:"9999999")
        D SI
        I PSGSS="P" D  Q
        . S ^TMP($J,PSJADT,PPN_U_PSGP,PSJATME,QST,DRG)=PSGP_U_ON_U_PSJPPID_U_PSJPWDN_U_PSJPRB
        . S ^TMP($J,QST,PSGP,ON)=PSJDOS_U_PSJMR_U_PSJSCHE_U_PSJHOLD_U_PSGLOD
        . S ^TMP($J,QST,PSGP,ON,1)=PSJSI
        ;*** Set up ^TMP when listing by ward
        S:PSGRBADM="A" ^TMP($J,PSJADT,TM,PSJATME,PSJPRB,PPN,QST,DRG)=PSGP_U_ON_U_PSJPPID_U_PSGWN_U_PSJPRB
        S:PSGRBADM="R" ^TMP($J,PSJADT,TM,PSJPRB,PPN,PSJATME,QST,DRG)=PSGP_U_ON_U_PSJPPID_U_PSGWN_U_PSJPRB
        S:PSGRBADM="P" ^TMP($J,PSJADT,TM,PPN_U_PSGP,PSJATME,QST,DRG)=PSGP_U_ON_U_PSJPPID_U_PSGWN_U_PSJPRB
        S ^TMP($J,QST,PSGP,ON)=PSJDOS_U_PSJMR_U_PSJSCHE_U_PSJHOLD_U_PSGLOD_U_PSGLSD_U_PSGLFD
        S ^TMP($J,QST,PSGP,ON,1)=PSJSI
        Q
SI      ;*** Find the Special instructions.
        S X=0,PSJSI="" F  S X=$O(^PS(53.1,ON,12,X)) Q:'X  S Z=$G(^(X,0)),Y=$L(PSJSI) S:Y+$L(Z)'>179 PSJSI=PSJSI_Z_" " I Y+$L(Z)>179 S PSJSI="SEE PROVIDER COMMENTS" Q
        Q
        ;
IV      ;*** Sort IV pending orders for 24 Hrs, 7/14 Day MAR.
        K DRG,P NEW X,ON55,P,PSJLABEL
        S DFN=PSGP,PSJLABEL=1 D GT531^PSIVORFA(DFN,ON)
        S X=$P(P("MR"),U,2)
        S QST=QST_4
        S PSJADT=$S(QST["C":"8999999",1:"9999999")
        I DRG S X=$S($G(DRG("AD",1)):DRG("AD",1),1:$G(DRG("SOL",1))),X=$E($P(X,U,2),1,20)_U_ON D
        . I PSGSS="P" S ^TMP($J,PSJADT,PPN_U_PSGP,"9999",QST,X)=PSGP_U_ON_U_PSJPPID_U_PSJPWDN_U_PSJPRB Q
        . S:PSGRBADM="A" ^TMP($J,PSJADT,TM,"9999",PSJPRB,PPN,QST,DRG)=PSGP_U_ON_U_PSJPPID_U_PSGWN_U_PSJPRB
        . S:PSGRBADM="R" ^TMP($J,PSJADT,TM,PSJPRB,PPN,"9999",QST,DRG)=PSGP_U_ON_U_PSJPPID_U_PSGWN_U_PSJPRB
        . S:PSGRBADM="P" ^TMP($J,PSJADT,TM,PPN_U_PSGP,"9999",QST,DRG)=PSGP_U_ON_U_PSJPPID_U_PSGWN_U_PSJPRB
        Q
