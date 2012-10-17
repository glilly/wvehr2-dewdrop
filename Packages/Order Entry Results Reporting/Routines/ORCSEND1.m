ORCSEND1        ;SLC/MKB-Release cont ;11/22/06
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**4,29,45,61,79,94,116,138,158,149,187,215,243,282,323**;Dec 17, 1997;Build 10
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;Reference to PSJEEU supported by IA #486
        ;Reference to PSJORPOE supported by IA #3167
        ;
PKGSTUFF(PKG)   ; Package code
        S PKG=$$GET1^DIQ(9.4,+PKG_",",1) Q:'$L(PKG)
        D:$L($T(@PKG)) @PKG
        Q
LR      ; Spawn child orders if continuous schedule
        N ORSTRT,ORPARENT,OR0,ORNP,ORDIALOG,ORL,ORX,ORTIME,ORPITEM,ORPSAMP,ORPSPEC,ORPURG,ORPCOMM,ORPTYPE,ORPCOLL,ORS1,ORS2,P,ORCHLD,ORDG,ORLAST,ORDUZ,ORLOG,ORCOLLCT,STS
        S ORPARENT=+ORIFN,OR0=$G(^OR(100,ORIFN,0)),ORL=$P(OR0,U,10)
        D SCHEDULE(ORIFN,"LR",.ORSTRT) I ORSTRT'>1 D  Q
        . N START S START=$O(ORSTRT(0)) Q:START=$P($G(^OR(100,+ORIFN,0)),U,8)
        . D DATES^ORCSAVE2(+ORIFN,START) ;update start date from schedule
        S ORNP=+$P(OR0,U,4),ORDIALOG=+$P(OR0,U,5),ORDUZ=+$P(OR0,U,6),ORLOG=$P(OR0,U,7),ORDG=+$P(OR0,U,11)
        D GETDLG1^ORCD(ORDIALOG),GETORDER(ORIFN),GETIMES^ORCDLR1
        K ORDIALOG($$PTR^ORCD("OR GTX ADMIN SCHEDULE"),1),ORDIALOG($$PTR^ORCD("OR GTX DURATION"),1)
        S ORPITEM=$$PTR^ORCD("OR GTX ORDERABLE ITEM")
        S ORPSAMP=$$PTR^ORCD("OR GTX COLLECTION SAMPLE")
        S ORPSPEC=$$PTR^ORCD("OR GTX SPECIMEN")
        S ORPURG=$$PTR^ORCD("OR GTX LAB URGENCY")
        S ORPCOMM=$$PTR^ORCD("OR GTX WORD PROCESSING 1")
        S ORPTYPE=$$PTR^ORCD("OR GTX COLLECTION TYPE")
        S ORPCOLL=$$PTR^ORCD("OR GTX START DATE/TIME")
LR1     N ORLASTC  S ORS1=0 F  S ORS1=$O(ORX(ORS1)) Q:ORS1'>0  D
        . N ORL S ORL=$P(OR0,U,10) ;protect ORL from calling routine ;DJE/VM *323
        . F P=ORPITEM,ORPSAMP,ORPSPEC,ORPURG,ORPCOMM,ORPTYPE S ORDIALOG(P,1)=$G(ORX(ORS1,P)) ;set values to next instance
        . S ORCOLLCT=$G(ORDIALOG(ORPTYPE,1))
        . S ORS2=0 F  S ORS2=$O(ORSTRT(ORS2)) Q:ORS2'>0  D
        .. S ORDIALOG(ORPCOLL,1)=ORS2 ;,ORDUZ=DUZ,ORLOG=+$E($$NOW^XLFDT,1,12)
        .. I ORCOLLCT="LC" S ORDIALOG(ORPTYPE,1)=$S($$LABCOLL^ORCDLR1(ORS2):"LC",1:"WC")
        .. I ORCOLLCT="I" S ORDIALOG(ORPTYPE,1)=$S($$IMMCOLL^ORCDLR1(ORS2):"I",1:"WC")
        .. D CHILD^ORCSEND3()
        .. S ORLASTC=$P(^OR(100,ORIFN,0),"^",8)
        . D DATES^ORCSAVE2(ORPARENT,,ORLASTC) S $P(^OR(100,ORPARENT,3),"^",8)=1
        S:$G(ORCHLD) ^OR(100,ORPARENT,2,0)="^100.002PA^"_ORLAST_U_ORCHLD
        S ORIFN=ORPARENT,ORQUIT=1,STS=$P(^OR(100,ORIFN,3),U,3)
        I (STS=1)!(STS=13)!(STS=11) S ORERR="1^Unable to release orders"
        D RELEASE^ORCSAVE2(ORPARENT,1,ORNOW,DUZ,$G(NATURE))
        Q
SCHEDULE(IFN,PKG,ORY,STRT)      ; Returns list of start time(s) from schedule
        N I,X,PSJSD,PSJFD,PSJW,PSJNE,PSJPP,PSJX,PSJAT,PSJM,PSJTS,PSJY,PSJAX,PSJSCH,PSJOSD,PSJOFD,PSJC,ORDUR
        S PSJSD=$S(+$G(STRT):STRT,1:$P($G(^OR(100,+IFN,0)),U,8)) I 'PSJSD S ORY=-1 Q
        S ORY=1,ORY(PSJSD)="" ;1st occurrance
        S I=$O(^OR(100,+IFN,4.5,"ID","SCHEDULE",0)) Q:'I  Q:'$L($G(PKG))
        S X=$G(^OR(100,+IFN,4.5,I,1)),PSJX=$S(X:$$GET1^DIQ(51.1,+X_",",.01),1:X)
        S PSJW=+$G(ORL),PSJNE="",PSJPP=PKG D ENSV^PSJEEU Q:'$L($G(PSJX))
        I $G(PSJTS)'="C",$G(PSJTS)'="D" Q  ;not continuous or day-of-week
        S PSJSCH=PSJX,I=$O(^OR(100,+IFN,4.5,"ID","DAYS",0)) Q:'I
        S ORDUR=$G(^OR(100,+IFN,4.5,+I,1))
        S:ORDUR PSJFD=$$FMADD^XLFDT(PSJSD,+ORDUR,,-1)
        I 'ORDUR S X=+$E(ORDUR,2,9) D
        . I PSJM S PSJFD=$$FMADD^XLFDT(PSJSD,,,(PSJM*X)-1) ;X_#times
        . E  D  ;no freq in minutes --> day of week
        .. N DAYS,LOCMX,SCHMX
        .. S LOCMX=$$GET^XPAR("ALL^LOC.`"_+ORL,"LR MAX DAYS CONTINUOUS",1,"Q")
        .. K ^TMP($J,"ORCSEND1 SCHEDULE")
        .. D ZERO^PSS51P1(PSJY,,,,"ORCSEND1 SCHEDULE")
        .. S SCHMX=+$G(^TMP($J,"ORCSEND1 SCHEDULE",PSJY,2.5))
        .. K ^TMP($J,"ORCSEND1 SCHEDULE")
        .. ;S SCHMX=$P(^PS(51.1,PSJY,0),U,7)
        .. S DAYS=$S('SCHMX:LOCMX,LOCMX<SCHMX:LOCMX,1:SCHMX)
        .. S PSJFD=$$FMADD^XLFDT(PSJSD,DAYS,,-1)
        D ENSPU^PSJEEU K ORY
        I ORDUR M ORY=PSJC Q
        S ORY=$S(PSJC<$E(ORDUR,2,9):PSJC,1:$E(ORDUR,2,9))
        N NXT
        S NXT=0 F I=1:1:ORY S NXT=$O(PSJC(NXT)) Q:'NXT  S ORY(NXT)=PSJC(NXT)
        Q
GETORDER(IFN)   ; Set ORX(Inst,Ptr)=Value
        N I,X,Y,PTR,INST,TYPE
        S I=0 F  S I=$O(^OR(100,IFN,4.5,I)) Q:I'>0  S X=$G(^(I,0)),Y=$G(^(1)) D
        . S PTR=+$P(X,U,2),INST=+$P(X,U,3),TYPE=$P($G(^ORD(101.41,PTR,1)),U)
        . I TYPE'="W" S ORX(INST,PTR)=Y Q
        . S ORX(INST,PTR)="^OR(100,"_IFN_",4.5,"_I_",2)"
        Q
PTR(X)  ; Returns ptr of prompt X in Order Dialog file
        Q +$O(^ORD(101.41,"AB",$E("OR GTX "_X,1,63),0))
PS      ; spawn child orders if multiple doses
PSJ     ; (Inpt only)
PSS     ;
        N ORPARENT,OR0,ORNP,ORDIALOG,ORDUZ,ORLOG,ORL,ORDG,ORCAT,ORX,ORP,ORI,STS
        N ORDOSE,ORT,ORSCH,ORDUR,ORSTRT,ORFRST,ORCONJ,ORID,ORDD,ORSTR,ORDGNM
        N ORSTART,ORCHLD,ORLAST,ORSIG,OROI,ID,OR3,ORIG,CODE,ORPKG,ORENEW,I,ORADMIN
        S ORPARENT=+ORIFN,OR0=$G(^OR(100,ORPARENT,0)),OR3=$G(^(3))
        Q:$P(OR0,U,12)'="I"  S ORCAT="I",ORNP=+$P(OR0,U,4)
        S ORDIALOG=+$P(OR0,U,5),ORDUZ=+$P(OR0,U,6),ORLOG=$P(OR0,U,7)
        S ORL=$P(OR0,U,10),ORDG=+$P(OR0,U,11),ORPKG=+$P(OR0,U,14)
        D GETDLG1^ORCD(ORDIALOG),GETORDER(ORPARENT)
        S ORDOSE=$$PTR("INSTRUCTIONS"),ORT=$$PTR("ROUTE")
        S ORSCH=$$PTR("SCHEDULE"),ORDUR=$$PTR("DURATION")
        S ORCONJ=$$PTR("AND/THEN") D STRT S ORSTART=$G(ORSTRT("BEG"))
        S ORADMIN=$$PTR("ADMIN TIMES")
        D DATES^ORCSAVE2(ORPARENT,ORSTART) Q:$$DOSES(ORPARENT)'>1
        S ORFRST=$$PTR("NOW"),ORSIG=$$PTR("SIG")
        S ORID=$$PTR("DOSE"),ORDD=$$PTR("DISPENSE DRUG")
        S ORSTR=$$PTR("STRENGTH"),ORDGNM=$$PTR("DRUG NAME")
        I $P(OR3,U,11)=2,$O(^OR(100,+$P(OR3,U,5),2,0)) D
        . S ORENEW=+$P(OR3,U,5),I=0
        . I $$VALUE^ORX8(ORENEW,"NOW") S I=$O(^OR(100,ORENEW,2,0))
        . F  S I=$O(^OR(100,ORENEW,2,I)) Q:I<1  S ORENEW(I)=""
PS1     F ORP="ORDERABLE ITEM","URGENCY","WORD PROCESSING 1" D
        . N PTR S PTR=$$PTR(ORP) Q:PTR'>0  Q:'$D(ORX(1,PTR))
        . S ORDIALOG(PTR,1)=ORX(1,PTR) S:$E(ORP)="O" OROI=ORX(1,PTR)
        S ORI=$$FRSTDOSE I $G(ORX(1,ORFRST)) D
        . F ORP=ORDOSE,ORT,ORID S:$D(ORX(ORI,ORP)) ORDIALOG(ORP,1)=ORX(ORI,ORP)
        . S ID=$G(ORX(ORI,ORID)) S:$P(ID,"&",6) ORDIALOG(ORDD,1)=$P(ID,"&",6)
        . S ORDIALOG(ORSCH,1)="NOW",ORSTART=$$NOW^XLFDT
        . D SIG,CHILD^ORCSEND3(ORSTART)
        F  D  S ORI=$O(ORX(ORI)) Q:ORI'>0
        . F ORP=ORDOSE,ORT,ORSCH,ORDUR,ORID,ORADMIN S:$D(ORX(ORI,ORP)) ORDIALOG(ORP,1)=ORX(ORI,ORP) K:'$D(ORX(ORI,ORP)) ORDIALOG(ORP,1)
        . K ORDIALOG(ORDD,1) S ID=$G(ORX(ORI,ORID))
        . S:$P(ID,"&",6) ORDIALOG(ORDD,1)=$P(ID,"&",6)
        . S ORSTART=$G(ORSTRT(ORI))
        . D SIG,CHILD^ORCSEND3(ORSTART)
        S:$G(ORCHLD) ^OR(100,ORPARENT,2,0)="^100.002PA^"_ORLAST_U_ORCHLD
        S ORIFN=ORPARENT,ORQUIT=1,OR3=$G(^OR(100,ORIFN,3)),STS=$P(OR3,U,3)
        I (STS=1)!(STS=13)!(STS=11) S ORERR="1^Unable to release orders"
        D RELEASE^ORCSAVE2(ORIFN,1,ORNOW,DUZ,$G(NATURE)) K ^TMP("ORWORD",$J)
        S $P(^OR(100,ORIFN,3),U,8)=1 ;veil parent order - set stop date/time?
        Q:(STS=1)!(STS=13)!(STS=11)  ;unsuccessful
PS2     ; ck if parent is unsigned or edit
        I $P($G(^OR(100,ORIFN,8,1,0)),U,4)=2 S $P(^(0),U,4)="" K ^OR(100,"AS",ORVP,9999999-ORLOG,ORIFN,1) ;clear ES
        Q:$P(OR3,U,11)'=1  S ORIG=$P(OR3,U,5) Q:ORIG'>0
        S CODE=$S($P($G(^OR(100,ORIG,3)),U,3)=5:"CA",1:"DC")
        D MSG^ORMBLD(ORIG,CODE) I "^1^13^"[(U_$P($G(^OR(100,ORIG,3)),U,3)_U) D
        . N NATR S NATR=+$O(^ORD(100.02,"C","C",0))
        . S $P(^OR(100,ORIG,3),U,3)=12,$P(^(3),U,7)=0,^(6)=NATR_U_DUZ_U_ORNOW
        . D CANCEL^ORCSEND(ORIG) ;ck for unrel actions
        Q
DOSES(IFN)      ; count number of doses in order
        N I,CNT S CNT=0
        S I=0 F  S I=$O(^OR(100,+$G(IFN),4.5,"ID","INSTR",I)) Q:I'>0  I $L($G(^OR(100,+$G(IFN),4.5,I,1))) S CNT=CNT+1
        S I=+$O(^OR(100,+$G(IFN),4.5,"ID","NOW",0)) I I,$G(^OR(100,+$G(IFN),4.5,I,1)) S CNT=CNT+1
        Q CNT
FRSTDOSE()      ; Return instance of first dose
        N I,Y S I=0,Y=1
        F  S I=$O(ORX(I)) Q:I'>0  I $D(ORX(I,ORDOSE)) S Y=I Q
        Q Y
SIG     ; Build text of instructions
        N ORDRUG,ID,DOSE,ORI,ORX K ^TMP("ORWORD",$J,ORSIG,1)
        S ORDRUG=$G(ORDIALOG(ORDD,1)),ID=$G(ORDIALOG(ORID,1))
        S DOSE=$G(ORDIALOG(ORDOSE,1)),ORI=1
        S ORX=$$DOSE^ORCDPS2_$$RTE^ORCDPS2_$$SCH^ORCDPS2_$$DUR^ORCDPS2
        S ^TMP("ORWORD",$J,ORSIG,1,0)="^^1^1^"_DT_U,^(1,0)=ORX
        S ORDIALOG(ORSIG,1)=$NA(^TMP("ORWORD",$J,ORSIG,1))
        S ORDIALOG(ORDOSE,"FORMAT")="@"
        K ORDIALOG(ORSTR,1),ORDIALOG(ORDGNM,1)
        I ORDRUG,'ID D  ;set strength or drug name
        . N STR,ITM S STR=$P(ID,"&",7)_$P(ID,"&",8)
        . I STR'>0 S ORDIALOG(ORDGNM,1)=$$GET1^DIQ(50,+ORDRUG_",",.01) Q
        . S ITM=$P($G(^ORD(101.43,+$G(OROI),0)),U)
        . S:ITM'[STR ORDIALOG(ORSTR,1)=STR
        Q
STRT    ; Build ORSTRT(inst)=date.time array of start times by dose
        N OI,PSOI,XD,XH,XM,XS,ORWD,ORI,SCH,ORSD,X,ORD K ORSTRT
        S OI=$G(ORX(1,$$PTR^ORCD("OR GTX ORDERABLE ITEM")))
        S PSOI=+$P($G(^ORD(101.43,+OI,0)),U,2),(XD,XH,XM,XS)=0
        S ORWD=+$G(^SC(+$G(ORL),42)) ;ward
        S ORI=0 F  S ORI=$O(ORX(ORI)) Q:ORI<1  D
        . S SCH=$G(ORX(ORI,ORSCH)),ORSD="" S:'$L(SCH) X=$$NOW^XLFDT
        . S:$L(SCH) ORSD=$$STARTSTP^PSJORPOE(+ORVP,SCH,PSOI,ORWD),X=$P(ORSD,U,4)
        . S ORSTRT(ORI)=$$FMADD^XLFDT(X,XD,XH,XM,XS) ;START+OFFSET
        . ; update OFFSET for next THEN dose
        . D DUR(ORI) I $G(ORX(ORI,ORCONJ))="T" D
        .. I $G(ORD("XD"))<1,$G(ORD("XH"))<1,$G(ORD("XM"))<1,$G(ORD("XS"))<1 S ORD("XD")=+$P(ORSD,U,3) ;default duration
        .. N I,Y F I="XD","XH","XM","XS" S Y=@I,@I=Y+$G(ORD(I))
        .. K ORD
        ; find beginning date.time for parent
        S ORI=0,X=9999999 F  S ORI=$O(ORSTRT(ORI)) Q:ORI<1  I ORSTRT(ORI)<X S X=ORSTRT(ORI)
        S ORSTRT("BEG")=X
        Q
DUR(I)  ; Accumulate duration in ORD("Xt") for offsetting next THEN dose
        N X,Y S X=$$FMDUR^ORCDPS3($G(ORX(I,ORDUR)))
        I X["S",+X>$G(ORD("XS")) S ORD("XS")=+X
        I X["'",+X>$G(ORD("XM")) S ORD("XM")=+X
        I X["H",+X>$G(ORD("XH")) S ORD("XH")=+X
        S Y=$S(X["D":+X,X["W":+X*7,X["M":+X*30,1:0)
        I Y,Y>$G(ORD("XD")) S ORD("XD")=Y
        Q
VBEC    ; Spawn VBECS children
        D:$L($T(EN^ORCSEND2)) EN^ORCSEND2
        Q
