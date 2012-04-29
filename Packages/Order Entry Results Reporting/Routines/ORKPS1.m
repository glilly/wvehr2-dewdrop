ORKPS1 ; slc/CLA - Order checking support procedures for medications ;12/15/97 [8/2/05 7:46am]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**232**;Dec 17, 1997;Build 19
 Q
PROCESS(OI,DFN,ORKDG) ;process data from pharmacy order check API
 Q:'$D(^TMP($J))
 N II,XX,ZZ,ZZD,ORTYPE,ORMTYPE,ORN,ORZ,RCNT
 S II=1,XX=0,ZZ="",ZZD="",RCNT=0
 ;
 ;check to determine if inpatient or outpatient:
 I $L(ORKDG) S ORTYPE=$S($G(ORKDG)="PSI":"I",$G(ORKDG)="PSO":"O",$G(ORKDG)="PSIV":"I",$G(ORKDG)="PSH":"O",1:"")
 I '$L(ORTYPE) D  ;if no display group
 .D ADM^VADPT2
 .S ORTYPE=$S(+$G(VADMVT)>0:"I",1:"O")
 .K VADMVT
 ;
 ; drug-drug interactions:
 F  S XX=$O(^TMP($J,"DI",XX)) Q:XX<1  D
 .S ZZ=$G(^TMP($J,"DI",XX,0))
 .S ORN=$P($P(ZZ,U,7),";"),ORZ=""
 .I '$G(ORN),$L($G(^TMP($J,"DI",XX,1))) D  Q
 ..N ORTXT,ORLEN,ORFAC,END
 ..S RCNT=RCNT+1
 ..S $P(ZZ,U,7)="R"_RCNT
 ..S ORFAC=$P(ZZ,U,9)
 ..S ORTXT=$P(^TMP($J,"DI",XX,1),U)_" "
 ..I $L(ORTXT)<242 S ORLEN=242-$L(ORTXT),ORTXT=ORTXT_$E(^TMP($J,"DI",XX,1,0),1,ORLEN)
 ..S OREND="["_$P(^TMP($J,"DI",XX,1),U,2)_" -   Last Fill: "_$P(^TMP($J,"DI",XX,1),U,3)_"   Quantity Dispensed: "_$P(^TMP($J,"DI",XX,1),U,5)_"] >> "_ORFAC
 ..N ORMAX S ORMAX=250-$L(OREND)-50-$L($P(ZZ,U,4))-$L($P(ZZ,U,5))-$L($P(ZZ,U,6))-$L($P(ZZ,U,7))
 ..I ORTXT'=$E(ORTXT,1,ORMAX) S OREND="..."_OREND
 ..S ORTXT=$E(ORTXT,1,ORMAX)_OREND
 ..S $P(ZZ,U,2)=ORTXT
 ..S YY(II)="DI^"_ZZ,II=II+1
 .I $L(ORN),$D(^OR(100,ORN,8,0)) S ORZ=^OR(100,ORN,8,0)
 .I $L($G(ORZ)),($P(^OR(100,ORN,8,$P(ORZ,U,3),0),U,2)="DC") Q
 .I $L(ORN),$P(^ORD(100.01,$P(^OR(100,ORN,3),U,3),0),U)="DISCONTINUED" Q
 .I ZZ'="" S YY(II)="DI^"_ZZ,II=II+1
 ;
 ; duplicate drugs:
 Q:$$SOLUT^ORKPS(OI)  ;quit if the orderable item is a solution
 ;require that we do not perform dup drug/class OCs for solutions)
 S XX=0,ZZ=""
 F  S XX=$O(^TMP($J,"DD",XX)) Q:XX<1  D
 .S ZZ=$G(^TMP($J,"DD",XX,0)),ORMTYPE=$P($P(ZZ,U,4),";",2)
 .I $G(ORTYPE)'=$G(ORMTYPE),'$L($G(^TMP($J,"DD",XX,1))) Q
 .S ORN=$P($P(ZZ,U,3),";"),ORZ=""
 .I '$G(ORN),$L($G(^TMP($J,"DD",XX,1))) D  Q
 ..Q:$$SUPPLY^ORKPS(OI)  ;quit if the orderable item is a supply and it is against remote data
 ..N ORTXT,ORLEN,ORFAC,OREND
 ..S RCNT=RCNT+1
 ..S $P(ZZ,U,3)="R"_RCNT
 ..S ORFAC=$P(ZZ,U,5)
 ..S ORTXT=$P(^TMP($J,"DD",XX,1),U)_" "
 ..I $L(ORTXT)<242 S ORLEN=242-$L(ORTXT),ORTXT=ORTXT_$E(^TMP($J,"DD",XX,1,0),1,ORLEN)
 ..S OREND="["_$P(^TMP($J,"DD",XX,1),U,2)_" -   Last Fill: "_$P(^TMP($J,"DD",XX,1),U,3)_"   Quantity Dispensed: "_$P(^TMP($J,"DD",XX,1),U,5)_"] >> "_ORFAC
 ..N ORMAX S ORMAX=250-$L(OREND)-40-$L($P(ZZ,U,4))
 ..I ORTXT'=$E(ORTXT,1,ORMAX) S OREND="..."_OREND
 ..S ORTXT=$E(ORTXT,1,ORMAX)_OREND
 ..S $P(ZZ,U,2)=ORTXT
 ..S YY(II)="DD^"_ZZ,II=II+1
 .Q:+$G(ORN)=+$G(ORIFN)  ;QUIT if dup med ord # = current ord #
 .I $L(ORN),$D(^OR(100,ORN,8,0)) S ORZ=^OR(100,ORN,8,0)
 .I $L($G(ORZ)),($P(^OR(100,ORN,8,$P(ORZ,U,3),0),U,2)="DC") Q
 .I $L(ORN),$P(^ORD(100.01,$P(^OR(100,ORN,3),U,3),0),U)="DISCONTINUED" Q
 .I ZZ'="" S YY(II)="DD^"_ZZ,II=II+1
 ;
 ; duplicate classes:
 Q:$$SUPPLY^ORKPS(OI)  ;quit if the orderable item is a supply
 S XX=0,ZZ=""
 F  S XX=$O(^TMP($J,"DC",XX)) Q:XX<1  D
 .S ZZ=$G(^TMP($J,"DC",XX,0)),ORMTYPE=$P($P(ZZ,U,6),";",2)
 .I $G(ORTYPE)'=$G(ORMTYPE),'$L($G(^TMP($J,"DC",XX,1))) Q
 .S ORN=$P($P(ZZ,U,5),";"),ORZ=""
 .I '$G(ORN),$L($G(^TMP($J,"DC",XX,1))) D  Q
 ..N ORTXT,ORLEN,ORFAC,OREND
 ..S RCNT=RCNT+1
 ..S $P(ZZ,U,5)="R"_RCNT
 ..S ORFAC=$P(ZZ,U,7)
 ..S ORTXT=$P(^TMP($J,"DC",XX,1),U)_" "
 ..I $L(ORTXT)<242 S ORLEN=242-$L(ORTXT),ORTXT=ORTXT_$E(^TMP($J,"DC",XX,1,0),1,ORLEN)
 ..S OREND="["_$P(^TMP($J,"DC",XX,1),U,2)_" -   Last Fill: "_$P(^TMP($J,"DC",XX,1),U,3)_"   Quantity Dispensed: "_$P(^TMP($J,"DC",XX,1),U,5)_"] >> "_ORFAC
 ..N ORMAX S ORMAX=250-$L(OREND)-50-$L($P(ZZ,U,2))-$L($P(ZZ,U,5))
 ..I ORTXT'=$E(ORTXT,1,ORMAX) S OREND="..."_OREND
 ..S ORTXT=$E(ORTXT,1,ORMAX)_OREND
 ..S $P(ZZ,U,4)=ORTXT
 ..S YY(II)="DC^"_ZZ,II=II+1
 .Q:+$G(ORN)=+$G(ORIFN)  ;QUIT if dup class ord # = current ord #
 .I $L(ORN),$D(^OR(100,ORN,8,0)) S ORZ=^OR(100,ORN,8,0)
 .I $L($G(ORZ)),($P(^OR(100,ORN,8,$P(ORZ,U,3),0),U,2)="DC") Q
 .I $L(ORN),$P(^ORD(100.01,$P(^OR(100,ORN,3),U,3),0),U)="DISCONTINUED" Q
 .I ZZ'="" S YY(II)="DC^"_ZZ,II=II+1
 Q
