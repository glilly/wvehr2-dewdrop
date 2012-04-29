ORMLR   ; SLC/MKB - Process Lab ORM msgs ;11:59 AM  26 Jul 2000
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**3,92,153,174,195,243**;Dec 17, 1997;Build 242
EN      ; -- entry point for LR messages
        I '$L($T(@ORDCNTRL)) Q  ;S ORERR="Invalid order control code" Q
        I ORDCNTRL'="SN",ORDCNTRL'="ZC",ORDCNTRL'="ZP" D  Q:$L($G(ORERR))
        . I 'ORIFN!('$D(^OR(100,+ORIFN,0))) S ORERR="Invalid OE/RR order number" Q
        . S ORDUZ=DUZ,ORLOG=+$E($$NOW^XLFDT,1,12)
        S OREASON=$$REASON I 'ORNATR,OREASON S ORNATR=+$P($G(^ORD(100.03,+OREASON,0)),U,7)
        D @ORDCNTRL
        Q
        ;
STATUS(X)       ; -- Returns Order Status for HL7 code X
        N Y S Y=$S(X="DC":1,X="CM":2,X="IP":5,X="SC":6,X="ZS":9,X="CA":13,1:"")
        Q Y
        ;
OK      ; -- Order accepted, LR order # assigned [ack]
        S ^OR(100,+ORIFN,4)=PKGIFN ; LR identifier
        D STATUS^ORCSAVE2(+ORIFN,5) ; pending
        Q
        ;
ZC      ; -- Convert existing 2.5 orders to 3.0 format
        S ORNATR="" I 'ORIFN!('$D(^OR(100,+ORIFN,0))) D  Q  ;create
        . K ORIFN D SN Q:'$G(ORIFN)  S ORDCNTRL="SN"
        . I ORSTOP,ORSTOP<$$NOW^XLFDT S $P(^OR(100,+ORIFN,3),U)=ORSTOP
        N ORDIALOG,I,X,OBR,NTE S ORIFN=+ORIFN
        S I=+ORC F  S I=$O(@ORMSG@(I)) Q:'I  S SEG=$E(@ORMSG@(I),1,3) Q:SEG="ORC"  Q:SEG="MSH"  I SEG="OBR" S OBR=I Q
        I '$G(OBR) S ORERR="Missing OBR segment" Q
        S ORDIALOG=+$O(^ORD(101.41,"AB","LR OTHER LAB TESTS",0))
        D GETDLG1^ORCD(ORDIALOG)
        S X=$$FIND^ORM(OBR,5),X=$$ORDITEM^ORM(X) I 'X S ORERR="Invalid test" Q
        S ORDIALOG($$PTR("ORDERABLE ITEM"),1)=X,X=$$FIND^ORM(OBR,16)
        S ORDIALOG($$PTR("COLLECTION SAMPLE"),1)=$P(X,";",4)
        S ORDIALOG($$PTR("SPECIMEN"),1)=$S($L($P(X,";")):+$O(^LAB(61,"C",$P(X,";"),0)),1:+$P(X,U,4))
        S X=$$FIND^ORM(OBR,28),ORDIALOG($$PTR("LAB URGENCY"),1)=+$P($P(X,U,6),";",2)
        S X=$$FIND^ORM(OBR,12),ORDIALOG($$PTR("COLLECTION TYPE"),1)=$S(X="L":"LC",X="O":"WC",X=2:"I",1:"SP")
ZC1     S NTE=$O(@ORMSG@(OBR)) I NTE,$E(@ORMSG@(NTE),1,3)="NTE" D
        . N LCNT,WP S WP=$$PTR("WORD PROCESSING 1") K ^TMP("ORWORD",$J)
        . S LCNT=1,^TMP("ORWORD",$J,WP,1,LCNT,0)=$P(@ORMSG@(NTE),"|",4)
        . S I=0 F  S I=$O(@ORMSG@(NTE,I)) Q:I'>0  S LCNT=LCNT+1,^TMP("ORWORD",$J,WP,1,LCNT,0)=@ORMSG@(NTE,I)
        . S ^TMP("ORWORD",$J,WP,1,0)="^^"_LCNT_U_LCNT_U_DT_U
        . S ORDIALOG(WP,1)="^TMP(""ORWORD"","_$J_","_WP_",1)"
        S ORDIALOG($$PTR("START DATE/TIME"),1)=ORSTRT
        S ^OR(100,ORIFN,4)=PKGIFN,$P(^(0),U,5)=+ORDIALOG_";ORD(101.41,"
        D RESPONSE^ORCSAVE ; save ORDIALOG() into ^(4.5)
        K ^TMP("ORWORD",$J)
        Q
        ;
SN      ; -- New backdoor order: return NA msg w/ORIFN, or DE msg
        N X,ORDIALOG,ORDG,OBR,NTE,CMMT,OI,LCNT,I,ORSTS,LRSUB,ORNEW,ORP
        I ORDUZ,'$D(^VA(200,+ORDUZ,0)) S ORERR="Invalid entering person" Q
        ; I '$G(ORL) S ORERR="Missing or invalid patient location" Q
        ;S LRSUB=$E($P($P(@ORMSG@(+ORC),"|",4),U,2),3,4),ORDG=$$DGRP(LRSUB)
        S ORDIALOG="LR OTHER LAB TESTS" ; $S(LRSUB="AP",LRSUB="BB")
        S ORDIALOG=$O(^ORD(101.41,"AB",ORDIALOG,0)) D GETDLG1^ORCD(ORDIALOG)
        S ORDIALOG($$PTR("START DATE/TIME"),1)=ORSTRT
        S CMMT=$$PTR("WORD PROCESSING 1") K ^TMP("ORWORD",$J)
SN1     S OBR=$O(@ORMSG@(+ORC)) I 'OBR!($E($G(@ORMSG@(OBR)),1,3)'="OBR") S ORERR="Missing OBR segment" Q
        S X=$$FIND^ORM(OBR,5),OI=$$ORDITEM^ORM(X) I 'OI S ORERR="Invalid test" Q
        S LRSUB=$P(^ORD(101.43,OI,"LR"),U,6),ORDG=$$DGRP(LRSUB)
        S ORDIALOG($$PTR("ORDERABLE ITEM"),1)=OI
        I LRSUB="BB" S ORDIALOG($$PTR("QUANTITY"),1)=+ORQT G SN2
        S X=$$FIND^ORM(OBR,16),ORDIALOG($$PTR("COLLECTION SAMPLE"),1)=$P(X,";",4)
        S ORDIALOG($$PTR("SPECIMEN"),1)=$S($L($P(X,";")):$O(^LAB(61,"C",$P(X,";"),0)),1:+$P(X,U,4))
        S X=+$P($P($$FIND^ORM(OBR,28),U,6),";",2),ORDIALOG($$PTR("LAB URGENCY"),1)=$S(X:X,1:9)
        S X=$$FIND^ORM(OBR,12),ORDIALOG($$PTR("COLLECTION TYPE"),1)=$S(X="L":"LC",X="O":"WC",X=2:"I",1:"SP")
SN2     S NTE=$O(@ORMSG@(+OBR)) I NTE,$E(@ORMSG@(NTE),1,3)="NTE" D
        . S LCNT=1,^TMP("ORWORD",$J,CMMT,1,LCNT,0)=$P(@ORMSG@(NTE),"|",4)
        . I $O(@ORMSG@(NTE,0)) S I=0 F  S I=$O(@ORMSG@(NTE,I)) Q:I'>0  S LCNT=LCNT+1,^TMP("ORWORD",$J,CMMT,1,LCNT,0)=@ORMSG@(NTE,I)
        . S ^TMP("ORWORD",$J,CMMT,1,0)="^^"_LCNT_U_LCNT_U_DT_U,ORDIALOG(CMMT,1)="^TMP(""ORWORD"",$J,"_CMMT_",1)"
SNQ     D EN^ORCSAVE K ^TMP("ORWORD",$J)
        I '$G(ORIFN) S ORERR="Cannot create new order" Q
        ;Save DG1 and ZCL segments of HL7 message from backdoor orders
        D BDOSTR^ORWDBA3
        D RELEASE^ORCSAVE2(ORIFN,1,ORLOG,ORDUZ,ORNATR),SIGSTS^ORCSAVE2(ORIFN,1)
        D:ORSTOP DATES^ORCSAVE2(ORIFN,,ORSTOP) ;Start date in order itself
        S ORSTS=$$STATUS(ORDSTS) D:ORSTS STATUS^ORCSAVE2(ORIFN,ORSTS)
        I ORDCNTRL="SN",$G(ORL) S ORP(1)=ORIFN_";1^1" D PRINTS^ORWD1(.ORP,+ORL)
        S ^OR(100,ORIFN,4)=PKGIFN
        Q
        ;
PTR(NAME)       ; -- Returns ien of prompt NAME in Order Dialog file #101.41
        Q $O(^ORD(101.41,"AB",$E("OR GTX "_NAME,1,63),0))
        ;
DGRP(DG)        ; -- Returns Display Group ptr based on Lab section
        N Y S:'$L($G(DG)) DG="CH" S Y=$O(^ORD(100.98,"B",DG,0))
        S:'Y Y=$O(^ORD(100.98,"B","LAB",0))
        Q Y
        ;
XX      ; -- Changed: NOT IN USE
        D XX^ORMLR1
        Q
        ;
XR      ; -- Changed [ack]: NOT IN USE
        N ORIG
        S ^OR(100,+ORIFN,4)=PKGIFN,ORIG=$P(^(3),U,5)
        D:ORIG STATUS^ORCSAVE2(ORIG,12)
        D STATUS^ORCSAVE2(+ORIFN,5) ; pending
        Q
        ;
ZP      ; -- Purged
        Q:'ORIFN  Q:'$D(^OR(100,+ORIFN,0))
        S $P(^OR(100,+ORIFN,4),";",1,3)=";;" I "^5^6^"[(U_$P($G(^(3)),U,3)_U) D STATUS^ORCSAVE2(+ORIFN,$S($P(^(4),";",5):2,1:14)) ; Remove pkg reference, sts=lapsed if still active
        Q
        ;
ZR      ; -- Purged as requested [ack]
        D DELETE^ORCSAVE2(+ORIFN)
        Q
        ;
ZU      ; -- Unable to purge [ack]
        S $P(^OR(100,+ORIFN,3),U)=$$NOW^XLFDT ; update Last Activity
        Q
        ;
SC      ; -- Status changed (collected)
        N ORSTS D DATES^ORCSAVE2(+ORIFN,ORSTRT,ORSTOP)
        S ORSTS=$$STATUS(ORDSTS) D:ORSTS STATUS^ORCSAVE2(+ORIFN,ORSTS)
        S:$L($P(OREASON,U,2)) ^OR(100,+ORIFN,8,1,1)=$P(OREASON,U,2)
        Q
        ;
RE      ; -- Completed, w/results
        N ORSTS,ORX,I,SEG,DONE,X,Y,ORABN,ORFIND,LRSA,LRSB
        S ORSTS=$$STATUS(ORDSTS) D:ORSTS STATUS^ORCSAVE2(+ORIFN,ORSTS)
        S ^OR(100,+ORIFN,4)=PKGIFN,ORX="" D  ;get Results D/T [from OBR]
        . N OBR S OBR=+$O(@ORMSG@(+ORC)),X=""
        . I OBR,$E($G(@ORMSG@(OBR)),1,3)="OBR" S X=$P(@ORMSG@(OBR),"|",23)
        . S X=$S(X:$$FMDATE^ORM(X),1:+$E($$NOW^XLFDT,1,12))
        . S $P(^OR(100,+ORIFN,7),U)=X,^OR(100,"ARS",ORVP,9999999-X,+ORIFN)=""
        D RR^LR7OR1(DFN,PKGIFN)
        S ORABN="",ORFIND=""
        I $D(^TMP("LRRR",$J)) D
        . N IDT,DNAM,ORSLT
        . S IDT=0 F  S IDT=$O(^TMP("LRRR",$J,DFN,"CH",IDT)) Q:'IDT  D
        .. S DNAM=0 F  S DNAM=$O(^TMP("LRRR",$J,DFN,"CH",IDT,DNAM)) Q:'DNAM  D
        ... S ORSLT=$G(^TMP("LRRR",$J,DFN,"CH",IDT,DNAM))
        ... I '$L($P(ORSLT,U,3)) Q
        ... S ORABN=1,ORFIND=$S($L(ORFIND):(ORFIND_", "),1:"")
        ... S ORFIND=ORFIND_$P(ORSLT,U,15)_"="_$P(ORSLT,U,2)
        . Q
        K ^TMP("LRRR",$J),^TMP("LRX",$J)
        S $P(^OR(100,+ORIFN,7),U,2,3)=ORABN_U_ORFIND
        S:'$G(ORNP) ORNP=+$P($G(^OR(100,+ORIFN,0)),U,4)
        I $L($T(ADD^ORRCACK)) D ADD^ORRCACK(+ORIFN,ORNP) ;Ack stub for prov
        Q
        ;
OC      ; -- Cancelled
        G:ORTYPE="ORR" UA S:ORNATR=+$O(^ORD(100.02,"C","A",0)) ORDUZ=""
        S ^OR(100,+ORIFN,6)=ORNATR_U_ORDUZ_U_ORLOG_U_$P(OREASON,U)_U_$E($P(OREASON,U,2),1,80)
        D UPDATE(1,"DC")
        Q
        ;
CR      ; -- Cancelled [ack]
        D STATUS^ORCSAVE2(+ORIFN,1)
        Q
        ;
UA      ; -- Unable to accept [ack]
UX      ; -- Unable to change [ack]: NOT IN USE
        S:'ORNATR ORNATR=$O(^ORD(100.02,"C","X",0)) ;rejected
        S ^OR(100,+ORIFN,6)=ORNATR_U_U_ORLOG_U_$P(OREASON,U)_U_$E($P(OREASON,U,2),1,80)
        D STATUS^ORCSAVE2(+ORIFN,13)
UC      ; -- Unable to cancel [ack]
DE      ; -- Data Error [ack]
        N DA S DA=$P(ORIFN,";",2) Q:'DA
        S $P(^OR(100,+ORIFN,8,DA,0),U,15)=13 ;request rejected
        S:$L($P(OREASON,U,2)) ^OR(100,+ORIFN,8,DA,1)=$E($P(OREASON,U,2),1,240)
        Q
        ;
UPDATE(ORSTS,ORACT)     ; -- continue processing
        N DA,ORX,ORCMMT,ORP
        D DATES^ORCSAVE2(+ORIFN,ORSTRT,ORSTOP)
        D:$G(ORSTS) STATUS^ORCSAVE2(+ORIFN,ORSTS)
        S ORCMMT=$E($P(OREASON,U,2),1,240),ORX=$$CREATE^ORX1(ORNATR) D:ORX
        . S DA=$$ACTION^ORCSAVE(ORACT,+ORIFN,ORNP,ORCMMT,ORLOG,ORDUZ)
        . I DA'>0 S ORERR="Cannot create new order action" Q
        . D RELEASE^ORCSAVE2(+ORIFN,DA,ORLOG,ORDUZ,ORNATR)
        . D SIGSTS^ORCSAVE2(+ORIFN,DA)
        . I $G(ORL) S ORP(1)=+ORIFN_";"_DA_"^1" D PRINTS^ORWD1(.ORP,+ORL)
        . S $P(^OR(100,+ORIFN,3),U,7)=DA
        I '$$ACTV^ORX1(ORNATR) S $P(^OR(100,+ORIFN,3),U,7)=0
        D:ORACT="DC" CANCEL^ORCSEND(+ORIFN)
        Q
        ;
REASON()        ; -- Get reason from OREASON or NTE segments
        N NTE,CMMT,X,Y,I,L
        S NTE=+$O(@ORMSG@(+ORC)),CMMT=$P(OREASON,U,4,5)
        G:'NTE RQ G:$E(@ORMSG@(NTE),1,3)'="NTE" RQ ; no add'l comments
        S Y=$P(@ORMSG@(NTE),"|",4),I=0
        F  S I=$O(@ORMSG@(NTE,I)) Q:I'>0  S X=$G(@ORMSG@(NTE,I)),L=$L(Y)+1+$L(X) S:L'>240 Y=Y_" "_X I L>240 S Y=Y_" "_$E(X,1,239-$L(Y)) Q
        S $P(CMMT,U,2)=Y
RQ      Q CMMT
