ORCHECK ;SLC/MKB-Order checking calls ; 08 May 2002  2:12 PM [8/16/05 5:28am]
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**7,56,70,94,141,215,243**;Dec 17, 1997;Build 242
        ;;Per VHA Directive 2004-038, this routine should not be modified.
DISPLAY ; -- DISPLAY event [called from ORCDLG,ORCACT4,ORCMED]
        ;    Expects ORVP, ORNMSP, ORTAB, [ORWARD]
        Q:$$GET^XPAR("DIV^SYS^PKG","ORK SYSTEM ENABLE/DISABLE")'="E"
        N ORX,ORY,I
        I ORNMSP="PS" D  ;reset to PSJ, PSJI, or PSO
        . I $G(ORDG) S I=$P($G(^ORD(100.98,+ORDG,0)),U,3),I=$P(I," ") Q:'$L(I)  S ORNMSP="PS"_$S(I="UD":"I",1:I) Q
        . I $G(ORXFER) S I=$P($P(^TMP("OR",$J,ORTAB,0),U,3),";",3) S:I="" I=$G(ORWARD) S ORNMSP="PS"_$S(I:"O",1:"I") ;opposite of list
        S ORX(1)="|"_ORNMSP,ORX=1
        D EN^ORKCHK(.ORY,+ORVP,.ORX,"DISPLAY") Q:'$D(ORY)
        S I=0 F  S I=$O(ORY(I)) Q:I'>0  W !,$P(ORY(I),U,4) ; display only
        Q
        ;
SELECT  ; -- SELECT event
        ;    Expects ORVP, ORDAILOG(PROMPT,ORI), ORNMSP
        Q:$$GET^XPAR("DIV^SYS^PKG","ORK SYSTEM ENABLE/DISABLE")'="E"
        N ORX,ORY,OI
        S OI=+$G(ORDIALOG(PROMPT,ORI))
        S ORX=1,ORX(1)=OI_"|"_ORNMSP_"|"_$$USID^ORMBLD(OI)
        D EN^ORKCHK(.ORY,+ORVP,.ORX,"SELECT"),RETURN:$D(ORY)
        Q
        ;
ACCEPT(MODE)    ; -- ACCEPT event [called from ORCDLG,ORCACT4,ORCMED]
        ;    Expects ORVP, ORDIALOG(), ORNMSP
        Q:$$GET^XPAR("DIV^SYS^PKG","ORK SYSTEM ENABLE/DISABLE")'="E"
        N ORX,ORY,ORZ,OI,ORSTRT,ORI,ORIT,ORID,ORSP
        S:'$L($G(MODE)) MODE="ACCEPT"
        S OI=$$PTR^ORCD("OR GTX ORDERABLE ITEM"),ORSTRT=$$START,ORX=0
        S ORI=0 F  S ORI=$O(ORDIALOG(OI,ORI)) Q:ORI'>0  D STUF
        I $G(ORDG)=+$O(^ORD(100.98,"B","IV RX",0)) S OI=$$PTR^ORCD("OR GTX ADDITIVE"),ORI=0 F  S ORI=$O(ORDIALOG(OI,ORI)) Q:ORI'>0  D STUF
        D EN^ORKCHK(.ORY,+ORVP,.ORX,MODE),RETURN:$D(ORY)
        Q
STUF    S ORIT=ORDIALOG(OI,ORI),ORSP=""
        S:ORNMSP="LR" ORSP=+$G(ORDIALOG($$PTR^ORCD("OR GTX SPECIMEN"),ORI))
        S ORID=$S($E(ORNMSP,1,2)="PS":$$DRUG(ORIT,OI),1:$$USID^ORMBLD(ORIT))
        S ORZ=1,ORZ(1)=ORIT_"|"_ORNMSP_"|"_ORID
        I MODE'="ALL" D EN^ORKCHK(.ORY,+ORVP,.ORZ,"SELECT"),RETURN:$D(ORY)
        S ORX=ORX+1,ORX(ORX)=ORZ(1)_"|"_ORSTRT_"||"_ORSP K ORY,ORZ
        Q
        ;
DELAY(MODE)     ; -- Delayed ACCEPT event [called from ORMEVNT]
        ;    Expects ORVP, ORIFN
        Q:$$GET^XPAR("DIV^SYS^PKG","ORK SYSTEM ENABLE/DISABLE")'="E"
        N ORX,ORY,ORCHECK S:'$L($G(MODE)) MODE="NOTIF"
        D BLD(+ORIFN),EN^ORKCHK(.ORY,+ORVP,.ORX,MODE) Q:'$D(ORY)
        D RETURN I MODE="NOTIF" S ORCHECK("OK")="Notification sent to provider" D OC^ORCSAVE2 Q  ; silent
        Q
        ;
SESSION ; -- SESSION event [called from ORCSIGN]
        ;    Expects ORVP, ORES()
        Q:$$GET^XPAR("DIV^SYS^PKG","ORK SYSTEM ENABLE/DISABLE")'="E"
        N ORX,ORY,ORIFN,I,X,Y
        S ORIFN=0 F  S ORIFN=$O(ORES(ORIFN)) Q:ORIFN'>0  I +$P(ORIFN,";",2)'>1 D
        . I "^5^6^10^11^"'[(U_$P($G(^OR(100,+ORIFN,3)),U,3)_U) Q  ;unreleased
        . D BLD(+ORIFN) Q:'$D(^OR(100,+ORIFN,9))
        . S ORCHECK("IFN")=+$G(ORCHECK("IFN"))+1
        . S I=0 F  S I=$O(^OR(100,+ORIFN,9,I)) Q:I'>0  S X=$G(^(I,0)),Y=$G(^(1)),ORCHECK=+$G(ORCHECK)+1,ORCHECK(+ORIFN,$S($P(X,U,2):$P(X,U,2),1:99),ORCHECK)=$P(X,U,1,2)_U_Y
        I $D(ORX) D EN^ORKCHK(.ORY,+ORVP,.ORX,"SESSION"),RETURN:$D(ORY),REMDUPS
        Q
        ;
BLD(ORDER)      ; -- Build new ORX(#) for ORDER
        Q:'$G(ORDER)  Q:'$D(^OR(100,ORDER,0))  ;Q:$P($G(^(3)),U,11)  ;edit/renew
        N PKG,START,ORI,ITEM,USID,SPEC,ORDG,PTR,INST
        S ORDG=$P(^OR(100,ORDER,0),U,11),PKG=$$GET1^DIQ(9.4,$P(^(0),U,14)_",",1)
        I PKG="PS",$G(ORDG) S ORI=$P($G(^ORD(100.98,+ORDG,0)),U,3),ORI=$P(ORI," "),PKG=PKG_$S(ORI="UD":"I",1:ORI)
        S START=$$START(ORDER),ORI=0
        F  S ORI=$O(^OR(100,ORDER,4.5,"ID","ORDERABLE",ORI)) Q:ORI'>0  D
        . S INST=$P($G(^OR(100,ORDER,4.5,ORI,0)),U,3),PTR=$P($G(^(0)),U,2),ITEM=+$G(^(1))
        . S USID=$S(PKG?1"PS".E:$$DRUG(ITEM,PTR,ORDER),1:$$USID^ORMBLD(ITEM))
        . S SPEC=$S(PKG="LR":$$VALUE^ORCSAVE2(ORDER,"SPECIMEN",INST),1:"")
        . S ORX=+$G(ORX)+1,ORX(ORX)=ITEM_"|"_PKG_"|"_USID_"|"_START_"|"_ORDER_"|"_SPEC
        Q
        ;
RETURN  ; -- Return checks in ORCHECK(ORIFN,CDL,#)
        N I,IFN,CDL S I=0 F  S I=$O(ORY(I)) Q:I'>0  D
        . S IFN=+$P(ORY(I),U) S:'IFN IFN="NEW"
        . S CDL=+$P(ORY(I),U,3) S:'CDL CDL=99
        . S:'$D(ORCHECK(IFN)) ORCHECK("IFN")=+$G(ORCHECK("IFN"))+1 ; count
        . S ORCHECK=+$G(ORCHECK)+1,ORCHECK(IFN,CDL,ORCHECK)=$P(ORY(I),U,2,4)
        Q
        ;
REMDUPS ;
        N IFN,CDL,I
        S IFN=0 F  S IFN=$O(ORCHECK(IFN)) Q:'IFN  D
        . S CDL=0 F  S CDL=$O(ORCHECK(IFN,CDL)) Q:'CDL  D
        . . S I=0 F  S I=$O(ORCHECK(IFN,CDL,I)) Q:'I  D
        . . . S J=I F  S J=$O(ORCHECK(IFN,CDL,J)) Q:'J  I $G(ORCHECK(IFN,CDL,I))=$G(ORCHECK(IFN,CDL,J)) K ORCHECK(IFN,CDL,J) S ORCHECK=$G(ORCHECK)-1
        Q
START(DA)       ; -- Returns start date/time
        N I,X,Y,%DT S Y=""
        I $G(DA) S X=$O(^OR(100,DA,4.5,"ID","START",0)),X=$G(^OR(100,DA,4.5,+X,1))
        E  D  ; look in ORDIALOG instead
        . S I=0 F  S I=$O(ORDIALOG(I)) Q:I'>0  Q:$P(ORDIALOG(I),U,2)="START"
        . S X=$S(I:$G(ORDIALOG(I,1)),1:"")
        D AM^ORCSAVE2:X="AM",NEXT^ORCSAVE2:X="NEXT"
        D ADMIN^ORCSAVE2("NEXT"):X="NEXTA",ADMIN^ORCSAVE2("CLOSEST"):X="CLOSEST"
        I $L(X) S %DT="TX" D ^%DT S:Y'>0 Y=""
        Q Y
        ;
DRUG(OI,PTR,IFN)        ; -- Returns 6 ^-piece identifier for Dispense Drug
        N ORDD,ORNDF,Y
        I ORDG=+$O(^ORD(100.98,"B","IV RX",0)) S ORDD=$$IV G D1
        I $G(IFN) S ORDD=$O(^OR(100,IFN,4.5,"ID","DRUG",0)),ORDD=+$G(^OR(100,IFN,4.5,+ORDD,1))
        E  S ORDD=+$G(ORDIALOG($$PTR^ORCD("OR GTX DISPENSE DRUG"),1))
D1      Q:'ORDD "" S ORNDF=$$ENDCM^PSJORUTL(ORDD)
        S Y=$P(ORNDF,U,3)_"^^99NDF^"_ORDD_U_$$NAME50^ORPEAPI(ORDD)_"^99PSD"
        Q Y
        ;
IV()    ; -- Get Dispense Drug for IV orderable
        N PSOI,TYPE,VOL,ORY
        S PSOI=+$P($G(^ORD(101.43,+OI,0)),U,2),VOL=""
        S TYPE=$S(PTR=$$PTR^ORCD("OR GTX ADDITIVE"):"A",1:"B")
        S:TYPE="B" VOL=$S($G(IFN):$$VALUE^ORCSAVE2(IFN,"VOLUME"),1:+$G(ORDIALOG($$PTR^ORCD("OR GTX VOLUME"),1)))
        D ENDDIV^PSJORUTL(PSOI,TYPE,VOL,.ORY)
        Q +$G(ORY)
        ;
LIST(IFN)       ; -- Displays list of ORCHECK(IFN) checks
        N ORI,ORJ,ORZ,ORMAX,ORTX,ON,OFF
        S ORZ=0 F  S ORZ=$O(ORCHECK(IFN,ORZ)) Q:ORZ'>0  D
        . S:ORZ=1 ON=IOINHI,OFF=IOINORM S:ORZ'=1 (ON,OFF)="" ; use bold if High
        . S ORI=0 F  S ORI=$O(ORCHECK(IFN,ORZ,ORI)) Q:ORI'>0  D
        . . S X=$P(ORCHECK(IFN,ORZ,ORI),U,3) I $L(X)<75 W !,ON_">>>  "_X_OFF Q
        . . S ORMAX=74 K ORTX D TXT^ORCHTAB Q:'$G(ORTX)  ; wrap
        . . F ORJ=1:1:ORTX W !,ON_$S(ORJ=1:">>>  ",1:"      ")_ORTX(ORJ)_OFF
        W !
        Q
        ;
CANCEL()        ; -- Returns 1 or 0: Cancel order(s)?
        N X,Y,DIR,NUM
        S NUM=+$G(ORCHECK("IFN")),DIR(0)="YA"
        S DIR("A")="Do you want to cancel "_$S(NUM>1:"any of the new orders? ",1:"the new order? ")
        S DIR("?",1)="Enter YES to cancel "_$S(NUM>1:"an",1:"the")_" order.  If you wish to override these order checks"
        S DIR("?",2)="and release "_$S(NUM>1:"these orders",1:"this order")_", enter NO; you will be prompted for a justification",DIR("?")="if there are any highlighted critical order checks."
        D ^DIR
        Q +Y
        ;
REASON()        ; -- Reason for overriding order checks
        ; I '$D(^XUSEC("ORES",DUZ)),'$D(^XUSEC("ORELSE",DUZ)) Q  ??
        N X,Y,DIR
        S DIR(0)="FA^2:80^K:X?1."" "" X",DIR("A")="REASON FOR OVERRIDE: "
        S DIR("?")="Enter a justification for overriding these order checks, up to 80 characters"
        D ^DIR I $D(DTOUT)!$D(DUOUT) S Y="^"
        Q Y
OCAPI(IFN,ORPLACE)      ;IA #4859
        ;API to get the order checking info for a specific order (IFN)
        ;info is stored in ^TMP($J,ORPLACE)
        ;               ^TMP($J,ORPLACE,D0,"OC LEVEL")="order check level"
        ;                                                 ,"OC TEXT")="order check text"
        ;                                                 ,"OR REASON")="over ride reason text"
        ;                                                 ,"OR PROVIDER")="provider DUZ who entered over ride reason"
        ;                                                 ,"OR DT")="date/time over ride reason was entered"
        ; NOTE on OC LEVEL: 1 is HIGH, 2 is MODERATE, 3 is LOW
        I '$D(^OR(100,IFN,9)) Q
        N I
        S I=0 F  S I=$O(^OR(100,IFN,9,I)) Q:'I  D
        .S ^TMP($J,ORPLACE,I,"OC LEVEL")=$P($G(^OR(100,IFN,9,I,0)),U,2)
        .S ^TMP($J,ORPLACE,I,"OC TEXT")=$G(^OR(100,IFN,9,I,1))
        .S ^TMP($J,ORPLACE,I,"OR REASON")=$P($G(^OR(100,IFN,9,I,0)),U,4)
        .S ^TMP($J,ORPLACE,I,"OR PROVIDER")=$P($G(^OR(100,IFN,9,I,0)),U,5)
        .S ^TMP($J,ORPLACE,I,"OR DT")=$P($G(^OR(100,IFN,9,I,0)),U,6)
        Q
