ORWDX   ; SLC/KCM/REV/JLI - Order dialog utilities ;11:02 AM  2 Aug 2011
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,85,125,131,132,141,164,178,187,190,195,215,246,243,283,269**;Dec 17, 1997;Build 34
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;Reference to DIC(9.4 supported by IA #2058
        ;
ORDITM(Y,FROM,DIR,XREF) ; Subset of orderable items
        ; Y(n)=IEN^.01 Name^.01 Name  -or-  IEN^Synonym <.01 Name>^.01 Name
        N I,IEN,CNT,X,DTXT,CURTM,DEFROUTE
        S DEFROUTE=""
        S I=0,CNT=44,CURTM=$$NOW^XLFDT
        F  Q:I'<CNT  S FROM=$O(^ORD(101.43,XREF,FROM),DIR) Q:FROM=""  D
        . S IEN="" F  S IEN=$O(^ORD(101.43,XREF,FROM,IEN),DIR) Q:'IEN  D
        . . S X=^ORD(101.43,XREF,FROM,IEN)
        . . I +$P(X,U,3),$P(X,U,3)<CURTM Q
        . . Q:$P(X,U,5)  S I=I+1
        . . I XREF="S.IVA RX"!(XREF="S.IVB RX") S DEFROUTE=$P($G(^ORD(101.43,IEN,"PS")),U,8)
        . . I 'X S Y(I)=IEN_U_$P(X,U,2)_U_$P(X,U,2)_U_DEFROUTE
        . . E  S Y(I)=IEN_U_$P(X,U,2)_$C(9)_"<"_$P(X,U,4)_">"_U_$P(X,U,4)_U_DEFROUTE
        Q
ODITMBC(Y,XREF,ODLST)   ;
        N CNT,NM,XRF
        S CNT=0,NM=0,XRF=XREF
        F  S CNT=$O(ODLST(CNT)) Q:'CNT  D FNDINFO(.Y,ODLST(CNT))
        Q
FNDINFO(Y,ODIEN)        ;
        D FNDINFO^ORWDX1(.Y,.ODIEN)
        Q
DLGDEF(LST,DLG) ; Format mapping for a dlg
        D DLGDEF^ORWDX1(.LST,.DLG)
        Q
DLGQUIK(LST,QO) ;(NOT USED)
        D LOADRSP(.LST,QO)
        Q
LOADRSP(LST,RSPID,TRANS)        ; Load responses from 101.41 or 100
        ; RSPID:  C123456;1-3243 = cached copy,   134-3234 = cached quick
        ;         X123456;1      = change order,  134      = quick dialog
        N I,J,DLG,INST,ID,VAL,ILST,ROOT,ORLOC S ROOT=""
        I RSPID["-" S ROOT="^TMP(""ORWDXMQ"",$J,"""_RSPID_""")" G XROOT^ORWDX2
        I $E(RSPID)="X" S ROOT="^OR(100,"_+$P(RSPID,"X",2)_",4.5)"  G XROOT^ORWDX2
        I +RSPID=RSPID  S ROOT="^ORD(101.41,"_+RSPID_",6)" G XROOT^ORWDX2
        Q:ROOT=""
        G XROOT^ORWDX2
SAVE(REC,ORVP,ORNP,ORL,DLG,ORDG,ORIT,ORIFN,ORDIALOG,ORDEA,ORAPPT,ORSRC,OREVTDF) ;
        ; ORVP=DFN, ORNP=Provider, ORL=Location, DLG=Order Dialog,
        ; ORDG=Display Group, ORIT=Quick Order Dialog, ORAPPT=Appointment
        N ORDUZ,ORSTS,OREVENT,ORCAT,ORDA,ORTS,ORNEW,ORCHECK,ORLOG,ORLEAD,ORTRAIL,ORPKG,ORWP94,ORCATFN,OREVTYPE,ONPASS
        N XCNT,XCOMM,XDONE,XX  ;SBR
        S (XCOMM,XCNT)=""  ;SBR
        I $G(ORIFN)'="" D  ;SBR problem only occurs on change or renew orders
        . S XCNT=$O(^OR(100,+ORIFN,4.5,"ID","COMMENT",XCNT))  ;SBR
        . I XCNT'="" S XCOMM=$P($G(^OR(100,+ORIFN,4.5,XCNT,0)),"^",2)  ;SBR
        . I XCOMM'="" S XDONE=0,XX="" F  S XX=$O(ORDIALOG("WP",XCOMM,1,XX)) Q:XX=""  D  ;SBR
        . . I ORDIALOG("WP",XCOMM,1,XX,0)'="" S XDONE=1 Q  ;SBR
        . I XCOMM'="",'$G(XDONE),$D(ORDIALOG("WP",XCOMM)) K ORDIALOG("WP",XCOMM)  ;SBR
        S ORCATFN="" I $L($P(DLG,U,2)) S ORCATFN=$P(DLG,U,2),DLG=$P(DLG,U,1)
        ;Remove treating facility if inpatient and IMO order 26.42
        I $G(^DPT(ORVP,.1))'="",$P($G(^ORD(100.98,ORDG,0)),U)="CLINIC ORDERS" K ORDIALOG("ORTS")
        I $G(ORDIALOG("ORTS")) S ORTS=ORDIALOG("ORTS") K ORDIALOG("ORTS")
        I $G(ORDIALOG("ORSLOG")) S ORLOG=ORDIALOG("ORSLOG") K ORDIALOG("ORSLOG")
        I $D(ORDIALOG("OREVENT")) S OREVENT=ORDIALOG("OREVENT") K ORDIALOG("OREVENT")
        ;=====================================================
        ; Changed for v26.27 (RV)
        S ORCAT=$$INPT^ORCD,ORCAT=$S(ORCAT=1:"I",1:"O")
        ;I $L($G(OREVENT)) D
        ;. S ONPASS=0
        ;. S OREVTYPE=$$TYPE^OREVNTX(OREVENT)
        ;. I OREVTYPE="T" D ISPASS^OREVNTX1(.ONPASS,+OREVENT,"T")
        ;. S ORCAT=$S(OREVTYPE="A":"I",OREVTYPE="T":"I",ONPASS=1:"O",1:"O")
        ;E  S ORCAT=$S($L($P($G(^DPT(+ORVP,.1)),U)):"I",1:"O")
        ;=====================================================
        I DLG="PS MEDS" S ORWP94=1 D
        . I ORIT=$O(^ORD(101.41,"AB","PSO SUPPLY",0)) S DLG="PSO SUPPLY"
        . I ORIT=$O(^ORD(101.41,"AB","PSO OERR",0)) S DLG="PSO OERR"
        . I ORIT=$O(^ORD(101.41,"AB","PSJ OR PAT OE",0)) S DLG="PSJ OR PAT OE"
        I DLG="PSO OERR" S ORCAT="O" I $G(OREVENT("EFFECTIVE")) D
        . S ORDIALOG($O(^ORD(101.41,"B","OR GTX START DATE"_$S($G(ORWP94):"/TIME",1:""),0)),1)=OREVENT("EFFECTIVE")
        I DLG="PSJ OR PAT OE" S ORCAT="I"
        S:DLG="FHW1" ORCAT="I" S:DLG?1"FHW "2.7U1" MEAL" ORCAT="O"
        S ORVP=ORVP_";DPT(",ORL(2)=ORL_";SC(",ORL=ORL(2)
        I ORDG=$O(^ORD(100.98,"B","LAB",0)) D  ;use section
        . N OI,SUB S OI=+$G(ORDIALOG($$PTR^ORCD("OR GTX ORDERABLE ITEM"),1))
        . S SUB=$P($G(^ORD(101.43,OI,"LR")),U,6),ORDG=$$DGRP^ORMLR(SUB)
        K:'ORDG ORDG K:'ORIT ORIT ; Dgrp & Quick must be non-zero
        M ORCHECK=ORDIALOG("ORCHECK") K ORDIALOG("ORCHECK")
        S ORDIALOG=$O(^ORD(101.41,"AB",DLG,0))
        I 'ORDIALOG S ORDIALOG=$O(^ORD(101.41,"B",DLG,0))
        I $D(ORDIALOG("ORLEAD")) S ORLEAD=ORDIALOG("ORLEAD")
        I $D(ORDIALOG("ORTRAIL")) S ORTRAIL=ORDIALOG("ORTRAIL")
        D GETDLG1^ORCD(ORDIALOG)
        I $L(ORCATFN) S ORCAT=ORCATFN
        I $G(ORWP94) D
        . N SIGPRMT S SIGPRMT=$O(^ORD(101.41,"B","OR GTX SIG",0))
        . N INSPRMT S INSPRMT=$O(^ORD(101.41,"B","OR GTX INSTRUCTIONS",0))
        . I $L($G(ORDIALOG(SIGPRMT,1))) S ORDIALOG(INSPRMT,"FORMAT")="@"
        . I ORCAT="O" S ORPKG=$O(^DIC(9.4,"C","PSO",0))
        . I ORCAT="I" S ORPKG=$O(^DIC(9.4,"C","PSJ",0))
        S ORSRC=$G(ORSRC)
        D DELPI^ORWDX1 ;delete empty PI
        I $G(ORIFN)="" D  ; new order
        . D EN^ORCSAVE
        . S REC="" I ORIFN D GETBYIFN^ORWORR(.REC,ORIFN)
        . I '$D(^TMP("ORECALL",$J,ORDIALOG)) M ^TMP("ORECALL",$J,ORDIALOG)=ORDIALOG
        E  D
        . N OR0
        . S OR0=$G(^OR(100,+ORIFN,0)),ORSTS=$P($G(^(3)),U,3),ORDG=$P(OR0,U,11)
        . I $L($P(OR0,U,17)),ORSTS=10 S OREVENT=$P(OR0,U,17),OREVENT("TS")=$P(OR0,U,13)
        . D XX^ORCSAVE ; edit order
        . S REC="" S ORIFN=+ORIFN_";"_ORDA D GETBYIFN^ORWORR(.REC,ORIFN)
        Q
SENDED(ORWLST,ORIENS,TS,LOC)    ; Release EDOs to svc
        N OK,ORVP,ORWERR,ORSIGST,ORDA,ORNATURE,ORIX,X,PTEVT,ORIFN,J,EVENT,LOCK,OR3
        S ORWERR="",ORIX=0,LOC=LOC_";SC("
        F  S ORIX=$O(ORIENS(ORIX)) Q:'ORIX  D  Q:ORWERR]""
        . S (ORIFN,ORWLST(ORIX))=ORIENS(ORIX)
        . S PTEVT=$P(^OR(100,+ORIFN,0),U,17)
        . I PTEVT D
        .. I $D(EVENT(PTEVT)) S LOCK=1 Q
        .. S LOCK=$$LCKEVT^ORX2(PTEVT) S:LOCK EVENT(PTEVT)=""
        . I 'LOCK S ORWERR="1^delayed event is locked - another user is processing orders for this event" S ORWLST(ORIX)=ORWLST(ORIX)_"^E^"_ORWERR Q
        . S ORDA=$P(ORIFN,";",2) S:'ORDA ORDA=1
        . S ORVP=$P($G(^OR(100,+ORIFN,0)),U,2)
        . I $D(^OR(100,+ORIFN,8,ORDA,0)) D
        .. S ORSIGST=$P($G(^(0)),U,4),ORNATURE=$P($G(^(0)),U,12) ;naked references refer to OR(100,+ORIFN,8,ORDA on line above
        . S OK=$$LOCK1^ORX2(ORIFN) I 'OK S ORWERR="1^"_$P(OK,U,2)
        . I OK,$G(LOCK) D
        .. S OR3=$G(^OR(100,+ORIFN,3)) I $P(OR3,"^",3)'=10!($P(OR3,"^",9)]"") D UNLK1^ORX2(ORIENS(ORIX)) Q  ;order already released or has a parent
        .. S:$G(LOC) $P(^OR(100,+ORIFN,0),U,10)=LOC ;set location
        .. S:$G(TS) $P(^OR(100,+ORIFN,0),U,13)=TS ;set specialty
        .. D EN2^ORCSEND(ORIENS(ORIX),ORSIGST,ORNATURE,.ORWERR),UNLK1^ORX2(ORIENS(ORIX)) ;add ,LOCK to if statement for 195
        . I $L(ORWERR) S ORWLST(ORIX)=ORWLST(ORIX)_"^E^"_ORWERR Q
        . E  D
        .. S PTEVT=$P($G(^OR(100,+ORIENS(ORIX),0)),U,17)
        .. D:$$TYPE^OREVNTX(PTEVT)="M" SAVE^ORMEVNT1(ORIENS(ORIX),PTEVT,2)
        . S X="RS"
        . S $P(ORWLST(ORIX),U,2)=X
        S J=0 F  S J=$O(EVENT(J)) Q:'+J  D UNLEVT^ORX2(J) ;195
        Q
SEND(ORWLST,DFN,ORNP,ORL,ES,ORWREC)     ; Sign
        ; DFN=Patient, ORNP=Provider, ORL=Location, ES=Encrypted ES code
        ; ORWREC(n)=ORIFN;Action^Signature Sts^Release Sts^Nature of Order
SEND1   N ORVP,ORWI,ORWERR,ORWREL,ORWSIG,ORWNATR,ORDERID,ORBEF,ORLR,ORLAB,X,I
        S ORVP=DFN_";DPT(",ORL=ORL_";SC(",ORL(2)=ORL,ORWLST=0
        F I="LR","VBEC" S X=+$O(^DIC(9.4,"C",I,0)) S:X ORLR(X)=1
        S ORWI=0 F  S ORWI=$O(ORWREC(ORWI)) Q:'ORWI  D
        . S X=ORWREC(ORWI),ORWERR=""
        . S ORDERID=$P(X,U),ORWSIG=$P(X,U,2),ORWREL=$P(X,U,3),ORWNATR=$P(X,U,4)
        . S ORBEF=0
        . I '$D(^OR(100,+ORDERID,0)) Q
        . I $D(^OR(100,+ORDERID,8,+$P(ORDERID,";",2),0)) S ORBEF=$P(^OR(100,+ORDERID,8,+$P(ORDERID,";",2),0),U,15)
        . S:$D(^OR(100,+ORDERID,8,+$P(ORDERID,";",2),0)) ORWNATR=$S($P(^OR(100,+ORDERID,8,+$P(ORDERID,";",2),0),"^",4)=3:"",1:ORWNATR)
        . S ORWERR=$$CHKACT^ORWDXR(ORDERID,ORWSIG,ORWREL,ORWNATR)
        . I $L(ORWERR) S ORWERR="1^"_ORWERR
        . I '$L(ORWERR) D
        .. I $G(ORLR(+$P(^OR(100,+ORDERID,0),U,14))),'$G(ORLAB) D  ; lab batch start
        ... I $L($T(BHS^ORMBLD)) D BHS^ORMBLD(ORVP) S ORLAB=1
        .. N OK S OK=$$LOCK1^ORX2(ORDERID) I 'OK S ORWERR="1^"_$P(OK,U,2)
        .. I OK D EN^ORCSEND(ORDERID,"",ORWSIG,ORWREL,ORWNATR,"",.ORWERR),UNLK1^ORX2(ORDERID)
        .. ;Begin WorldVistA change; OR*3*296 ;07/31/2009
        .. S PSOSITE=$G(^SC(+ORL,"AFRXSITE")) ;+ORL is hospital location from ORWDX
        .. Q:PSOSITE=""  ;Quits with no autofinish if File#44 does not point to File#59
        .. I $P($G(^PS(59,PSOSITE,"RXFIN")),"^",1)="Y",$$GET1^DIQ(100,+ORDERID_",",12)="OUTPATIENT PHARMACY" D EN^PSOAFIN
        .. ;End WorldVistA change
        . S ORWLST(ORWI)=ORDERID,X=""
        . I $L(ORWERR) S ORWLST(ORWI)=ORWLST(ORWI)_"^E^"_ORWERR Q
        . I ORWREL,((ORBEF=10)!(ORBEF=11)),($P(^OR(100,+ORDERID,3),U,3)'=10) S X="R"
        . I ORWSIG'=2 S X=X_"S"
        . S $P(ORWLST(ORWI),U,2)=X
        I $G(ORLAB) D BTS^ORMBLD(ORVP)
        Q
DLGID(VAL,ORIFN)        ; return dlg IEN for order
        S VAL=$P(^OR(100,+ORIFN,0),U,5)
        S VAL=$S($P(VAL,";",2)="ORD(101.41,":+VAL,1:0)
        Q
FORMID(VAL,ORIFN)       ; Base dlg FormID for an order
        N DLG
        S VAL=0,DLG=$P(^OR(100,+ORIFN,0),U,5)
        Q:$P(DLG,";",2)'="ORD(101.41,"
        D FORMID^ORWDXM(.VAL,+DLG)
        Q
AGAIN(VAL,DLG)  ; return true to keep dlg for another order
        S VAL=''$P($G(^ORD(101.41,DLG,0)),U,9)
        Q
DGRP(VAL,DLG)   ; Display grp pointer for a dlg
        S DLG=$S($E(DLG)="`":+$P(DLG,"`",2),1:$O(^ORD(101.41,"AB",DLG,0))) ;kcm
        S VAL=$P($G(^ORD(101.41,DLG,0)),U,5)
        Q
DGNM(VAL,NM)    ; Display grp pointer for name
        S VAL=$O(^ORD(100.98,"B",NM,0))
        Q
WRLST(LST,LOC)  ; List of dlgs for writing orders
        G WRLST1^ORWDX1
MSG(LST,IEN)    ; Msg text for orderable item
        N I
        S I=0 F  S I=$O(^ORD(101.43,IEN,8,I)) Q:I'>0  S LST(I)=^(I,0)
        Q
DISMSG(VAL,IEN) ; Disabled mge for ordering dlg
        S VAL=$P($G(^ORD(101.41,+IEN,0)),U,3)
        Q
LOCK(OK,DFN)    ; Attempt to lock pt for ordering
        S OK=$$LOCK^ORX2(DFN)
        Q
UNLOCK(OK,DFN)  ; Unlock pt for ordering
        D UNLOCK^ORX2(DFN) S OK=1
        Q
LOCKORD(OK,ORIFN)       ; Attempt to lock order
        S OK=$$LOCK1^ORX2(ORIFN)
        Q
UNLKORD(OK,ORIFN)       ; Unlock order
        D UNLK1^ORX2(ORIFN) S OK=1
        Q
UNLKOTH(OK,ORIFN)       ; Unlock pt not by this session
        K ^XTMP("ORPTLK-"_ORIFN)
        Q
