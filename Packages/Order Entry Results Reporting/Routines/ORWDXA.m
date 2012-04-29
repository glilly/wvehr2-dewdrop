ORWDXA  ; SLC/KCM/JLI - Utilites for Order Actions; 10/07/2007 ; 2/7/08 11:48am
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,85,116,132,148,141,149,187,213,195,215,243**;Dec 17, 1997;Build 242
        ;
VALID(VAL,ORID,ACTION,ORNP,ORWNAT)      ; Return error message if not valid action for order
        N ORACT,ORVP,ORVER,ORIFN,PRTID S VAL="",PRTID=0
        I +ORID=0 S VAL="This order has been deleted." Q
        I '$D(^OR(100,+ORID,0)) S VAL="This order has been deleted!" Q
        I ACTION="XFR",'$L($T(XFR^ORCACT01)) S ACTION="RW" ; for pre-POE
        N ORNSS S ORNSS=1
        I (ACTION="RN") D VALSCH^ORWNSS(.ORNSS,ORID)
        I ORNSS=0 S VAL="This order contains an invalid administration schedule." Q
        I (ACTION="RN") D ISVALIV^ORWDPS33(.VAL,ORID,ACTION) I $L(VAL)>0 Q
        S ORIFN=ORID,ORVP=$P(^OR(100,+ORID,0),U,2)  ; ORCACT0 expects defined
        I (ACTION="RN") D  Q:$L(VAL)  ; ** There's got to be a better way!
        . N DLG S DLG=$P(^OR(100,+ORID,0),U,5) Q:DLG'[";ORD(101.41,"
        . I $G(^ORD(101.41,+DLG,3))'["PROVIDER^ORCDPSIV" Q
        . D AUTH^ORWDPS32(.VAL,ORNP)
        . I VAL S VAL=$P(VAL,U,2)
        . E  S VAL=""
        S ORVER=$S(ACTION="CR":"R",$D(^XUSEC("ORELSE",DUZ)):"N",$D(^XUSEC("OREMAS",DUZ)):"C",1:"^")
        I ACTION="CR" S ACTION="VR"
        I (ACTION="ES")!(ACTION="OC")!(ACTION="RS") S ORACT=ACTION ; why not defined???
        I (ACTION="VR"),'($D(^XUSEC("ORELSE",DUZ))!$D(^XUSEC("OREMAS",DUZ))) D  Q
        . S VAL="You are not authorized to verify these orders."
        I $L(VAL) Q
        N OIIEN,ISIV,IVOD
        S (ISIV,OIIEN,IVOD)=0
        I (ACTION="RW")!(ACTION="XX")!(ACTION="XFR") D  Q:$L(VAL)
        . S ISIV=$P(^OR(100,+ORID,0),U,11)
        . I ISIV,($P(^ORD(100.98,ISIV,0),U,3)="IV RX") S IVOD=1
        . D:'IVOD GTORITM^ORWDXR(.OIIEN,+ORID)
        . D:OIIEN ISACTOI(.VAL,OIIEN) I $L(VAL)>0 Q
        . N DLG,FRM
        . S DLG=$P(^OR(100,+ORID,0),U,5),FRM=0
        . I $P(DLG,";",2)'="ORD(101.41," S DLG=0
        . I DLG D FORMID^ORWDXM(.FRM,+DLG)
        . I '(DLG&FRM) D
        . . S VAL="Copy & Change are not implemented for this order that predates CPRS."
        N OREBUILD  ; sometimes left defined by $$VALID
        ;I (ACTION="RW")!(ACTION="XFR")!(ACTION="RN") D ISVALIV^ORWDPS33(.VAL,ORID,ACTION) I $L(VAL)>0 Q
        I $$VALID^ORCACT0(ORID,ACTION,.VAL,$G(ORWNAT)) S VAL="" ; VAL=error
        Q
        ;
HOLD(REC,ORID,ORNP)     ; Place an order on hold
        N ACTDA
        S ACTDA=$$ACTION^ORCSAVE("HD",+ORID,ORNP)
        D GETBYIFN^ORWORR(.REC,+ORID_";"_ACTDA)
        Q
UNHOLD(REC,ORID,ORNP)   ; Release an order from hold
        N ACTDA
        S ACTDA=$$ACTION^ORCSAVE("RL",+ORID,ORNP)
        D GETBYIFN^ORWORR(.REC,+ORID_";"_ACTDA)
        Q
DC(REC,ORID,ORNP,ORL,REASON,DCORIG,ISNEWORD)    ; Discontinue/Cancel/Delete an order
        N NATURE,CREATE,PRINT,STATUS,ACTDA,SIGSTS
        N X3,X8,CURRACT
        Q:'+ORID
        I $G(DCORIG)="" S DCORIG=0
        S CURRACT=0
        S ORL(2)=ORL_";SC(",ORL=ORL(2),NATURE=""
        I REASON S NATURE=$P(^ORD(100.02,$P(^ORD(100.03,REASON,0),U,7),0),U,2)
        S:NATURE="" NATURE="W"  ; S:ORNP=DUZ NATURE="E"
        ;change the way create work to support forcing signature for all DC
        ;reasons
        S CREATE=1,PRINT=$$PRINT^ORCACT2(NATURE)
        ;S CREATE=$$CREATE^ORX1(NATURE)
        S X3=$G(^OR(100,+ORID,3))
        S CURRACT=$P(X3,U,7) S:CURRACT<1 CURRACT=+$O(^OR(100,+ORID,8,"?"),-1)
        I '$D(^OR(100,+ORID,8,+$P(ORID,";",2),0)) D
        . S X8=$G(^OR(100,+ORID,8,CURRACT,0))
        . S SIGSTS=$P(X8,U,4)
        . S $P(ORID,";",2)=CURRACT
        E  D
        . S X8=^OR(100,+ORID,8,+$P(ORID,";",2),0)
        . S SIGSTS=$P(X8,U,4)
        I '$D(SIGSTS) S SIGSTS=1
        S STATUS=$P($G(^OR(100,+ORID,8,+$P(ORID,";",2),0)),U,15)
        I (STATUS=10)!(STATUS=11) D  Q   ; delete/cancel unreleased order
        . N RPLORD
        . S RPLORD=$P($G(^OR(100,+ORID,3)),U,5)    ; replaced order
        . D GETBYIFN^ORWORR(.REC,ORID)
        . I STATUS=10,($P(X8,U,4)'=2) D  ; CANCEL signed, delayed, unreleased
        . . ; taken from CLRDLY^ORCACT2
        . . I REASON D SET^ORCACT2(+ORID,NATURE,REASON,,DCORIG)
        . . I 'REASON D SET^ORCACT2(+ORID,"M","","Delayed Order Cancelled",DCORIG)
        . . D STATUS^ORCSAVE2(+ORID,13) S $P(^OR(100,+ORID,8,1,0),U,15)=13
        . E  D                           ; CANCEL OR DELETE unsigned, unreleased
        . . I $P(X8,U,2)="DC" K ^OR(100,+ORID,6)
        . . ; delete fwd ptr to order about to be deleted
        . . I RPLORD,$P(X8,U,2)="NW" S $P(^OR(100,RPLORD,3),U,6)=""
        . . ; delete ptr to order in Patient Event file #100.2
        . . N EVT S EVT=$P($G(^OR(100,+ORID,0)),U,17) I EVT,EVT=+$O(^ORE(100.2,"AO",+ORID,0)) S $P(^ORE(100.2,EVT,0),U,4)="" K ^ORE(100.2,"AO",+ORID,EVT)
        . . I $G(ISNEWORD) D DELETE^ORCSAVE2(ORID)
        . . I '$G(ISNEWORD) D CANCEL^ORCSAVE2(ORID)
        . I RPLORD,'(SIGSTS=1) S ORID=RPLORD  ; for Renews & Changes, show replaced order
        . I '$D(^OR(100,+ORID)) D
        . . S $P(REC(1),U)="~0",REC(2)="tDELETED: "_$E(REC(2),2,245)
        . E  D
        . . K REC
        . . D GETBYIFN^ORWORR(.REC,+ORID_";"_$P($G(^OR(100,+ORID,3)),U,7))
        . S $P(REC(1),U,14)=2 ; DCType = deletion
        S ACTDA=$$ACTION^ORCSAVE("DC",+ORID,ORNP)
        D SET^ORCACT2(+ORID,NATURE,REASON,,DCORIG)
        D GETBYIFN^ORWORR(.REC,+ORID_";"_ACTDA)
        S $P(REC(1),U,14)=$S(CREATE:1,1:3)  ;DCType - 1=NewOrder, 3=NewStatus
        N PKG
        S PKG=$P($G(^OR(100,+ORID,0)),U,14)
        S PKG=$$NMSP^ORCD(PKG)
        I REASON=16&(PKG="PS") D
        . N XMB
        . S XMB="OR DRUG ORDER CANCELLED"
        . S XMB(1)=$P($G(REC(2)),"tDiscontinue",2),XMB(4)=$P($G(^VA(200,DUZ,0)),U)
        . S XMB(2)=+ORID
        . S XMB(3)=+$P($G(^OR(100,+ORID,0)),U,2)
        . S XMB(3)=$P($G(^DPT(XMB(3),0)),U)
        . D ^XMB
        Q
DCREQIEN(VAL)   ; Return the IEN for Requesting Physician Cancelled reason
        S VAL=$O(^ORD(100.03,"S","REQ",0))
        Q
COMPLETE(REC,ORID,ESCODE)       ; Complete an order (generic orders)
        ;N X S X=+$E($$NOW^XLFDT,1,12)
        ;D DATES^ORCSAVE2(+ORID,,X)
        ;D STATUS^ORCSAVE2(+ORID,2)
        ; validate ESCode
        D COMP^ORCSAVE2(ORID)
        D GETBYIFN^ORWORR(.REC,ORID)
        Q
VERIFY(REC,ORID,ESCODE,ORVER)   ; Verify an order
        ; validate ESCode
        S ORVER=$G(ORVER,$S($D(^XUSEC("ORELSE",DUZ)):"N",$D(^XUSEC("OREMAS",DUZ)):"C",1:U))
        I ORVER'=U D
        . N ORIFN,ORES,ORI
        . ; to match 56, need to VERIFY any replaced orders:
        . S ORIFN=ORID,ORES(ORIFN)="" D REPLCD^ORCACT1
        . S ORI="" F  S ORI=$O(ORES(ORI)) Q:ORI=""  D EN^ORCSEND(ORI,"VR","",""),UNLK1^ORX2(+ORI):ORI'=ORID ;ORID locked prior
        D GETBYIFN^ORWORR(.REC,ORID)
        Q
ALERT(DUMMY,ORID,ORDUZ) ;send alert to user (ORDUZ) when order (ORID) resulted
        ;if no user passed from GUI, use ordering provider:
        I $G(ORDUZ)<1 S ORDUZ=+$$ORDERER^ORQOR2(+ORID)
        I $L($G(ORDUZ))<1 S ORDUZ=DUZ
        S DUMMY=1,$P(^OR(100,+ORID,3),U,10)=ORDUZ
        Q
FLAG(REC,ORIFN,OREASON,ORNP)    ; Flag an order
        N ORB,ORVP,DA,ORPS
        D BULLETIN
        S DA=$P(ORIFN,";",2),ORVP=+$P(^OR(100,+ORIFN,0),U,2)
        K ^OR(100,+ORIFN,8,DA,3) S ^(3)="1^"_$G(XMZ)_U_+$E($$NOW^XLFDT,1,12)_U_DUZ_U_OREASON_$S($G(ORNP):"^^^^"_+ORNP,1:"")
        D KILL^XM,MSG^ORCFLAG(ORIFN)
        S $P(^OR(100,+ORIFN,3),U)=$$NOW^XLFDT ; Last Activity
        I +$G(ORNP)<1 S ORNP=+$P($G(^OR(100,+ORIFN,8,DA,0)),U,3)
        S ORB=+ORVP_U_+ORIFN_U_ORNP_"^1" D EN^OCXOERR(ORB) ; notification
        D GETBYIFN^ORWORR(.REC,ORIFN)
        Q
BULLETIN        ; Send flagged order bulletin (USED BY FLAG)
        N OR0,OR3,ORDTXT,XMB,XMY,XMDUZ,ORENT,BULL,ORSRV,ORUSR
        S OR0=$G(^OR(100,+ORIFN,0)),OR3=$G(^(3))
        ;CLA - 3/21/96:
        S ORUSR=+$P(OR0,U,4)
        S ORSRV=$G(^VA(200,ORUSR,5)) I +ORSRV>0 S ORSRV=$P(ORSRV,U)
        S ORENT="USR.`"_ORUSR_"^SRV.`"_$G(ORSRV)_"^DIV^SYS^PKG"
        S BULL=$$GET^XPAR(ORENT,"ORB FLAGGED ORDERS BULLETIN",1,"Q")
        Q:$G(BULL)'="Y"   ;quit if parameter value is not 'Y'es
        ;
        S XMB="OR FLAGGED ORDER",XMDUZ=DUZ,XMY(+$P(OR0,U,4))=""
        S XMB(1)=$P(^DPT(+$P(OR0,U,2),0),U),XMB(2)=$P(^(0),U,9),XMB(3)="" ;sb AGE
        S XMB(4)=$$FMTE^XLFDT($P(OR0,U,7))
        D TEXT^ORQ12(.ORDTXT,+ORIFN,80)
        S XMB(5)=$G(ORDTXT(1)),XMB(6)=$G(ORDTXT(2)),XMB(7)=$G(ORDTXT(3))
        S XMB(8)=$$FMTE^XLFDT($P(OR0,U,8)),XMB(9)=$$FMTE^XLFDT($P(OR0,U,9)),XMB(10)=OREASON
        S XMB(11)=$P($G(^ORD(100.01,+$P(OR3,U,3),0)),U)
        D EN^XMB
        Q
UNFLAG(REC,ORIFN,OREASON)       ; Unflag an order
        N DA,ORB,ORNP,ORVP,ORPS
        S DA=$P(ORIFN,";",2),ORVP=+$P(^OR(100,+ORIFN,0),U,2)
        S $P(^OR(100,+ORIFN,8,DA,3),U)=0,$P(^(3),U,6,8)=+$E($$NOW^XLFDT,1,12)_U_DUZ_U_OREASON D MSG^ORCFLAG(ORIFN)
        S $P(^OR(100,+ORIFN,3),U)=$$NOW^XLFDT  ; Last Activity
        S ORNP=+$P($G(^OR(100,+ORIFN,8,DA,0)),U,3)
        S ORB=+ORVP_U_+ORIFN_U_ORNP_"^0" D EN^OCXOERR(ORB) ; notification
        D GETBYIFN^ORWORR(.REC,ORIFN)
        Q
FLAGTXT(LST,ORID)       ; Return flag reason
        N FLAG
        S FLAG=$G(^OR(100,+ORID,8,$P(ORID,";",2),3))
        S LST(1)="FLAGGED: "_$$FMTE^XLFDT($P(FLAG,U,3))_" by "_$P($G(^VA(200,+$P(FLAG,U,4),0)),U)
        S LST(2)=$P(FLAG,U,5) ; reason
        Q
WCGET(LST,ORID) ; Return ward comments
        N I,ORIFN,ACT S ORIFN=+ORID,ACT=+$P(ORID,";",2)
        S I=0 F  S I=$O(^OR(100,ORIFN,8,ACT,5,I)) Q:'I  S LST(I)=$G(^(I,0))
        Q
WCPUT(ERR,ORID,WCLST)   ; Set ward comments for order
        N DIERR,ERRLST,ORIFN,ACT S ORIFN=+ORID,ACT=+$P(ORID,";",2)
        D WP^DIE(100.008,ACT_","_ORIFN_",",50,"","WCLST","ERRLST")
        S ERR="" I $D(DIERR) S ERR="An error occurred while saving comments."
        Q
OFCPLX(ORY,ORID,PRTORDER)       ;Check if ORID is an child of the PRTORDER
        N NUMCHDS,NOWID,NOWVAL,X3,ORDA,ISNOW
        Q:'$D(^OR(100,+ORID,0))
        S ISNOW=0
        D ISNOW^ORWDXR(.ISNOW,+ORID)
        Q:ISNOW
        N PKG
        S PKG=$P($G(^OR(100,+ORID,0)),U,14)
        S PKG=$$NMSP^ORCD(PKG)
        I PKG'="PS" Q
        I $L($G(^OR(100,+ORID,3))),('$L($P(^(3),U,9))) Q
        S (NUMCHDS,NOWID,NOWVAL,X3,ORDA)=0
        S PRTORDER=+$P(^(3),U,9)
        S X3=$G(^OR(100,PRTORDER,3)),ORDA=$P(X3,U,7)
        S PRTORDER=PRTORDER_";"_ORDA
        S NUMCHDS=$P($G(^OR(100,+PRTORDER,2,0)),U,4)
        I NUMCHDS>2 S ORY="COMPLEX-PSI"_U_PRTORDER
        S:$D(^OR(100,+PRTORDER,4.5,"ID","NOW")) NOWID=$O(^("NOW",0))
        S:NOWID NOWVAL=$G(^OR(100,+PRTORDER,4.5,NOWID,1))
        I NOWVAL=1 Q
        E  S ORY="COMPLEX-PSI"_U_PRTORDER
        Q
ISACTOI(ORY,OI) ;If it's an active orderable item
        I $G(^ORD(101.43,+OI,.1)),^(.1)'>$$NOW^XLFDT D
        . S ORY=$P($G(^ORD(101.43,OI,0)),U)_" has been inactivated and may not be ordered anymore."
        Q
