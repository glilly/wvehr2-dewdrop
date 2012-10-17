ORCSEND2        ;SLC/MKB - Release cont ;2/11/08  11:04
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**212**;Dec 17, 1997;Build 24
        ;
PTR(NAME)       ; -- Returns ptr value of prompt in Dialog file
        Q +$O(^ORD(101.41,"AB","OR GTX "_NAME,0))
        ;
EN      ; -- Spawn child orders from ORIFN, send to VBECS [from VBEC^ORCSEND1]
        N ORPARENT,OR0,ORDIALOG,ORNP,ORDUZ,ORLOG,ORCAT,ORTS,ORDG,ORPKG,ORPRINT
        N ORESP,ORTIME,ORSTRT,ORI,ORIT,ORITX,ORFLDS,ORP,P,ORCHLD,ORLAST,X,STS,ORLAB,ORLRIFN
        N ORPITEM,ORPRBCM,ORPUNIT,ORPDTW,ORPREAS,ORPMSBS,ORPINFC,ORPURG,ORPTYPE,ORPCOLL,ORPCOMM,ORPRSLT,ORPSPEC,ORPLAB
        S ORPARENT=+ORIFN,OR0=$G(^OR(100,ORIFN,0))
        S ORDIALOG=+$P(OR0,U,5),ORNP=+$P(OR0,U,4),ORDUZ=+$P(OR0,U,6)
        S ORLOG=$P(OR0,U,7),ORCAT=$P(OR0,U,12),ORTS=$P(OR0,U,13)
        S ORDG=+$P(OR0,U,11),ORPKG=$P(OR0,U,14),ORPRINT=0
        D GETDLG1^ORCD(ORDIALOG),GETORDER^ORCD(ORIFN,"ORESP"),GETIMES^ORCDLR1
        M ^TMP($J,"ORVBDLG")=ORDIALOG S ORPITEM=$$PTR("ORDERABLE ITEM")
        S ORPRBCM=$$PTR("RBC MODIFIERS"),ORPUNIT=$$PTR("AMOUNT")
        S ORPDTW=$$PTR("DATE/TIME"),ORPREAS=$$PTR("REASON")
        S ORPMSBS=$$PTR("TEXT"),ORPINFC=$$PTR("YES/NO")
        S ORPTYPE=$$PTR("COLLECTION TYPE"),ORPCOLL=$$PTR("START DATE/TIME")
        S ORPURG=$$PTR("URGENCY"),ORPCOMM=$$PTR("FREE TEXT 1")
        S ORPSPEC=$$PTR("SPECIMEN STATUS"),ORPRSLT=$$PTR("RESULTS")
        S ORPLAB=$$PTR("LAB ORDER") D START ;resolve ORSTRT dates
EN1     S ORI=0 F  S ORI=$O(ORESP(ORPITEM,ORI)) Q:ORI<1  D  Q:$G(ORERR)
        . N ORL S ORL=$P(OR0,U,10) ;protect ORL from calling routine
        . S ORIT=+$G(ORESP(ORPITEM,ORI)),ORITX=$G(^ORD(101.43,ORIT,"VB"))
        . D LABTST I $G(ORERR) D CANCEL(ORPARENT,$P(ORERR,U,2)) Q
        . K ORDIALOG M ORDIALOG=^TMP($J,"ORVBDLG") S ORDIALOG(ORPITEM,1)=ORIT
        . S ORFLDS=$S(ORITX:"ORPRBCM^ORPUNIT^ORPSPEC^ORPDTW^ORPREAS^ORPMSBS^ORPINFC",$P(ORITX,U,2)=1:"ORPDTW^ORPTYPE^ORPCOLL",$P(ORITX,U,2)=2:"ORPDTW^ORPREAS^ORPMSBS^ORPINFC^ORPTYPE^ORPCOLL",1:"")_"^ORPURG^ORPCOMM"
        . F ORP=1:1:$L(ORFLDS,U) S P=$P(ORFLDS,U,ORP) Q:'$L(P)  S ORDIALOG(@P,1)=$S($D(ORESP(@P,ORI)):ORESP(@P,ORI),1:$G(ORESP(@P,1))) ;set values
        . S:$G(ORLRIFN) ORDIALOG(ORPLAB,1)=ORLRIFN
        . K ORIFN,ORIT D EN^ORCSAVE
        . I '$G(ORIFN) S ORERR="1^Unable to create order" Q
        . S X=ORSTRT($S(ORITX:"DTW",1:"COLL")) D DATES^ORCSAVE2(ORIFN,X)
        . D RELEASE^ORCSAVE2(ORIFN,1,ORNOW,DUZ,$G(NATURE)),LINK
        . D NW^ORMBLDVB(ORIFN)
        S:$G(ORCHLD) ^OR(100,ORPARENT,2,0)="^100.002PA^"_ORLAST_U_ORCHLD
        D RELEASE^ORCSAVE2(ORPARENT,1,ORNOW,DUZ,$G(NATURE))
        ;D STATUS^ORCSAVE2(ORPARENT,5) ;testing
        S ORIFN=ORPARENT,ORQUIT=1,STS=$P(^OR(100,ORIFN,3),U,3)
EN2     I STS'=11,STS'=13 D  ;successful
        . D RESULTS^ORMBLDVB(ORPARENT)
        . Q:'$O(ORPRINT(0))  N PAT,LOC,NATR
        . S PAT=$P(OR0,U,2),LOC=$S($G(ORL):ORL,1:$P(OR0,U,10))
        . S NATR=$$WORK^ORCSIGN($G(NATURE))
        . D PRINT^ORPR02(PAT,.ORPRINT,,LOC,"0^1^1^1^"_NATR) ;labels/req's
        I $$UNRL(ORPARENT) S ORERR="1^Unable to release order due to an HL7 network error: queued for delivery to VBECS"
        I STS=13 S ORERR="1^This order was rejected by VBECS and will NOT be acted upon: see the Order Details for more information and contact the Blood Bank for assistance!"
        K ^TMP($J,"ORVBDLG"),^TMP($J,"ORLRDLG")
        Q
        ;
UNRL(DAD)       ; -- ck for any unreleased child orders
        N Y,I,STS S Y=0
        S I=0 F  S I=+$O(^OR(100,+$G(DAD),2,I)) Q:I<1  D  Q:Y
        . S STS=$P($G(^OR(100,I,3)),U,3)
        . I STS=10!(STS=11) S Y=1 Q
        Q Y
        ;
START   ; -- Define ORSTRT(), set Start Date in ORPARENT
        N X,Y,%DT,STRT S ORSTRT("COLL")="",ORSTRT("DTW")="",%DT="TX",STRT=""
        S X=$G(ORESP(ORPDTW,1)) I $L(X) D ^%DT S:Y>0 ORSTRT("DTW")=Y,STRT=Y
        S X=$G(ORESP(ORPCOLL,1)) I $L(X) D
        . D AM^ORCSAVE2:X="AM",NEXT^ORCSAVE2:X="NEXT" ;return X
        . D ^%DT S:Y>0 ORSTRT("COLL")=Y,STRT=Y
        I '$P(OR0,U,8) D DATES^ORCSAVE2(+ORIFN,STRT)
        Q
        ;
LINK    ; -- set up ORPARENT/ORIFN links, ORLAST in ORCHLD()
        ;    Uses ORVP,ORLOG in xref
        S ORCHLD=+$G(ORCHLD)+1,^OR(100,ORPARENT,2,ORIFN,0)=ORIFN,ORLAST=ORIFN
        S $P(^OR(100,ORIFN,3),U,8,9)="1^"_ORPARENT
        S $P(^OR(100,ORIFN,8,1,0),U,4)=8 K ^OR(100,"AS",ORVP,9999999-ORLOG,ORIFN,1) ;signature on parent only
        Q
        ;
LABTST  ; -- Create Lab order for VBECS blood component or test
        ;    Expects var's from above, Returns ORLAB & ORLRIFN
        N ORDIALOG,ORDG,ORPKG,ORIFN,X,P,LRT K ORLAB,ORLRIFN
        I $G(^TMP($J,"ORLRDLG")) M ORDIALOG=^TMP($J,"ORLRDLG")
        E  D  ;build for now, later reuse
        . S ORDIALOG=+$O(^ORD(101.41,"AB","LR OTHER LAB TESTS",0))
        . D GETDLG1^ORCD(ORDIALOG) M ^TMP($J,"ORLRDLG")=ORDIALOG
        S ORDG=+$O(^ORD(100.98,"B","BB",0)),X=$P($G(^ORD(101.43,ORIT,0)),U,8)
        S X=+$$TEST(X) I X<1 S ORERR="1^Missing or invalid Lab workload test" Q
        S ORDIALOG(ORPITEM,1)=X,LRT=+$P($G(^ORD(101.43,X,0)),U,2)
        S ORDIALOG(ORPTYPE,1)=$S($D(ORESP(ORPTYPE,1)):ORESP(ORPTYPE,1),1:"SP")
        S ORDIALOG(ORPCOLL,1)=$S($D(ORESP(ORPCOLL,1)):ORESP(ORPCOLL,1),1:$G(ORESP(ORPDTW,1)))
LT1     ; VALIDATE??
        S X=+$O(^LAB(60,LRT,3,0)),X=+$G(^(X,0)) ;default/unique sample
        S ORDIALOG($$PTR("COLLECTION SAMPLE"),1)=X
        S:'ORITX ORDIALOG($$PTR("SPECIMEN"),1)=$P($G(^LAB(62,X,0)),U,2)
        S X=+$G(ORESP(ORPURG,1)),X=$P($G(^ORD(101.42,X,0)),U)
        S X=$S($L(X):+$O(^LAB(62.05,"B",X,0)),1:9) S:'X X=9
        S ORDIALOG($$PTR("LAB URGENCY"),1)=X
        D EN^ORCSAVE I '$G(ORIFN) S ORERR="1^Unable to create lab order" Q
        S X=$S($D(ORSTRT("COLL")):ORSTRT("COLL"),1:$G(ORSTRT("DTW")))
        D DATES^ORCSAVE2(ORIFN,X),LINK
        D RELEASE^ORCSAVE2(ORIFN,1,ORNOW,DUZ,$G(NATURE)),NEW^ORMBLD(ORIFN)
        S ORLAB=$G(^OR(100,ORIFN,4))_";"_$G(LRT),ORLRIFN=ORIFN ;for VBECS msg
        I '$G(ORLAB) S ORERR="1^"_$$WHY^ORCSEND(ORIFN,1) Q
        S ORPRINT=+$G(ORPRINT)+1,ORPRINT(ORPRINT)=ORIFN_";1"
        ;D STATUS^ORCSAVE2(ORIFN,5) S ORLAB="ORLAB" ;for testing
        ;N ORZTEST S ORZTEST=1 D NEW^ORMBLD(ORIFN) ZW ORZTEST
        Q
        ;
TEST(X) ; -- find corresponding Lab test for VBECS item X, in #101.43
        N NM,I,Y S NM=X_" - LAB",Y=0
        S I=0 F  S I=+$O(^ORD(101.43,"B",$E(NM,1,30),I)) Q:I<1  I $P($G(^ORD(101.43,I,0)),U,8)=NM S Y=I Q
        Q Y
        ;
CANCEL(ORDAD,OREASON)   ; -- Cancel parent order
        Q:'$G(ORDAD)  N NATR,NOW,ORCHLD
        S ORCHLD=0 F  S ORCHLD=+$O(^OR(100,ORDAD,2,ORCHLD)) Q:ORCHLD<1  D
        . Q:"^1^2^13^"[(U_$P($G(^OR(100,ORCHLD,3)),U,3)_U)  ;already done
        . D MSG^ORMBLD(ORCHLD,"CA",OREASON)
        S NATR=+$O(^ORD(100.02,"C","X",0)),NOW=+$E($$NOW^XLFDT,1,12)
        S ^OR(100,ORDAD,6)=NATR_U_U_NOW_U_U_$G(OREASON),$P(^(8,1,0),U,15)=13 S:$L($G(OREASON)) ^(1)=OREASON
        D STATUS^ORCSAVE2(ORDAD,13) ;cancel
        Q
