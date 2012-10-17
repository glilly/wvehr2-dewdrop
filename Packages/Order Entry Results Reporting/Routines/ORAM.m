ORAM    ;POR/RSF - ANTICOAGULATION MANAGEMENT RPCS (1 of 4) ;08/03/10  09:50
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**307,330**;Dec 17, 1997;Build 2
        ;;Per VHA Directive 2004-038, this routine should not be modified
        Q
        ;
PATIENT(RESULT,ORAMDFN) ;Returns current Patient info as:
        ;DFN^NAME^GENDER^ADMISSION^CURRENT DT/TIME (internal)^SSN^CURRENT DT/TIME (external)^CLINIC LOCATION^DTIME
        ;RPC=ORAM PATIENT
        N CURADM,PTNAME,GENDER,ORAMNOW,ORAMRD,ORAMSSN,ORAMPLOC,ORAMVDT
        I '$G(ORAMDFN) D
        . N DIC,X,Y
        . S DIC="^DPT(",DIC(0)="Z",X=" "
        . D ^DIC
        . S ORAMDFN=+$G(Y)
        I ORAMDFN<1 S ORAMDFN=0 G PATIENTQ
        S CURADM=$G(^DPT(ORAMDFN,.105))   ;CHECKS IF PATIENT IS ADMITTED
        S PTNAME=$P(^DPT(ORAMDFN,0),U)
        I $L(PTNAME)>19 D
        . N ORFMT
        . F ORFMT="LAST,FIRST MI","LAST,FI MI" S PTNAME=$$NAME^ORAMX(PTNAME,ORFMT) Q:$L(PTNAME)'>19
        S GENDER=$P(^DPT(ORAMDFN,0),U,2)
        S ORAMSSN=$P(^DPT(ORAMDFN,0),U,9)
        S ORAMNOW=$$NOW^XLFDT S ORAMRD=$$FMTE^XLFDT($E(ORAMNOW,1,12),2)
        S ORAMPLOC=$P($G(^ORAM(103,ORAMDFN,6)),U,2)
        S:+ORAMPLOC>0 ORAMPLOC=ORAMPLOC_";SC("
        S ORAMVDT=$$GETAPPT(ORAMDFN,+ORAMPLOC)
        S:$L($P(ORAMRD,"/",1))=1 $P(ORAMRD,"/",1)="0"_$P(ORAMRD,"/",1)
        S:$L($P(ORAMRD,"/",2))=1 $P(ORAMRD,"/",2)="0"_$P(ORAMRD,"/",2)
        S RESULT=$G(ORAMDFN)_U_$G(PTNAME)_U_$G(GENDER)_U_$G(CURADM)_U_ORAMNOW_U_$G(ORAMSSN)_U_$G(ORAMRD)_U_ORAMPLOC_U_$G(DTIME)_U_ORAMVDT
PATIENTQ        Q
        ;
APPTMTCH(RESULT,ORAMDFN,ORAMCL) ; Find appt match on clinic change
        S RESULT=$$GETAPPT(ORAMDFN,+ORAMCL)
        Q
        ;
GETAPPT(ORAMDFN,ORAMCL) ; Find most recent appointment to Clinic from t-1 to t+1 days
        N ORAMC,ORAMEDT,ORAMLDT,ORAMOK,ORAMY,ORAMDIFF,ORAMTCL,ORAMVCL,ORAMLAD,ORAMLBD,ORAMFLTR,ORAMAPPT
        S ORAMOK=0
        S ORAMY=$$NOW^XLFDT
        I +ORAMCL'>0 G GETAPPX
        S ORAMLBD=$$GET^XPAR(ORAMCL_";SC(^ALL","ORAM APPT MATCH LOOK-BACK",1,"I")
        S ORAMDIFF=$S(ORAMLBD]"":-ORAMLBD,1:-1)
        S ORAMEDT=$$FMADD^XLFDT(DT,ORAMDIFF)
        S ORAMLAD=$$GET^XPAR(ORAMCL_";SC(^ALL","ORAM APPT MATCH LOOK-AHEAD",1,"I")
        S ORAMDIFF=$S(ORAMLAD]"":ORAMLAD,1:1)
        S ORAMLDT=$$FMADD^XLFDT(DT,ORAMDIFF)_".2359"
        S ORAMVCL=$$GET^XPAR(ORAMCL_";SC(","ORAM VISIT LOCATION",1,"I")
        S ORAMTCL=$$GET^XPAR(ORAMCL_";SC(","ORAM PHONE CLINIC",1,"I")
        F ORAMC=ORAMVCL,ORAMTCL D
        . N ORAMOK
        . S ORAMFLTR(1)=ORAMEDT_";"_ORAMLDT
        . S ORAMFLTR(2)=ORAMC
        . S ORAMFLTR(3)="R;I;NT"
        . S ORAMFLTR(4)=ORAMDFN
        . S ORAMFLTR("MAX")=-3
        . S ORAMFLTR("FLDS")="1;2;4"
        . S ORAMOK=$$SDAPI^SDAMA301(.ORAMFLTR)
        . I +ORAMOK>0 M ORAMAPPT=^TMP($J,"SDAMA301")
        I +$D(ORAMAPPT)>9 S ORAMY=$$NEAREST($NA(ORAMAPPT(ORAMDFN)))
        K ^TMP($J,"SDAMA301")
GETAPPX Q ORAMY
        ;
NEAREST(APPTS)  ; Find the nearest appointment to NOW
        N ORC,ORI,ORY,ORNOW,ORDIFFS S (ORC,ORY)=0,ORNOW=$$NOW^XLFDT
        F  S ORC=$O(@APPTS@(ORC)) Q:+ORC'>0  D
        . N ORDT S ORDT=0
        . F  S ORDT=$O(@APPTS@(ORC,ORDT)) Q:+ORDT'>0  S ORDIFFS($$ABS^XLFMTH($$FMDIFF^XLFDT(ORNOW,ORDT,2)))=ORDT
        S ORI=$O(ORDIFFS(0))
        S:+ORI>0 ORY=ORDIFFS(ORI)
        Q ORY
        ;
PROVIDER(RESULT)        ;GETS DUZ/NAME OF PROVIDER WHO IS SIGNED IN
        ;;RPC=ORAM PROVIDER
        N PN,INIT
        S DUZ=$G(DUZ)
        S PN=$P(^VA(200,DUZ,0),U)
        S INIT=$P(^VA(200,DUZ,0),U,2)
        S RESULT=$G(DUZ)_U_PN_U_$G(INIT)
        Q
        ;
INRCHK(ORAMQO)  ; Resolve Lab Test id from Quick Order
        N TST,N,ORAM60,ORAMT2,ORAMTT,ORAMPP,ORAMTST,ORAMTSTN,ORAMNEW,ORAML,ORAMT60,ORAMORD,ORY
        S ORAMORD=$$QOORD(ORAMQO),ORY=""
        I +$G(ORAMQO) D
        . N ORAMC
        . S ORAM60=+$P(^ORD(101.43,ORAMORD,0),U,2) Q:'+$G(ORAM60)
        . S ORAMT60=$P($P($G(^LAB(60,ORAM60,0)),U,5),";",2) I +$G(ORAMT60) S ORY=ORAMT60 Q
        . I '$G(ORAMT60),$D(^LAB(60,ORAM60,2,0)) S ORAMC=0 F  S ORAMC=$O(^LAB(60,ORAM60,2,ORAMC)) Q:'+$G(ORAMC)!(+$G(ORY))  D
        .. S ORAMNEW=^LAB(60,ORAM60,2,ORAMC,0) I +ORAMNEW>0,$$ISINR(ORAMNEW) S ORY=$P($P($G(^LAB(60,ORAMNEW,0)),U,5),";",2) Q
        Q ORY
        ;
ISINR(ORTEST)   ; Is the lab test an INR?
        N ORY,ORNM S ORY=0
        S ORNM=$P($G(^LAB(60,ORTEST,0)),U)
        S ORY=$S(ORNM["INR":1,(ORNM["INT")&(ORNM["NORM")&(ORNM["RAT"):1,1:0)
        Q ORY
        ;
LABCHK(RESULT)  ;
        ;;RPC=ORAM ORDERABLES
        N ORAMINR,ORAMCBC,C,Y S (C,Y)=0,RESULT="0|0"
        S ORAMINR=0 F  S ORAMINR=$O(^ORD(101.43,"B","INR",ORAMINR)) Q:'+$G(ORAMINR)!(+$G(C))  I +$G(ORAMINR) S $P(RESULT,"|")=ORAMINR,C=1
        I $G(ORAMINR)="" S ORAMINR=0 F  S ORAMINR=$O(^ORD(101.43,"B","INR ",ORAMINR)) Q:'+$G(ORAMINR)!(+$G(C))  I +$G(ORAMINR) S $P(RESULT,"|")=ORAMINR,C=1
        I $G(ORAMINR)="" S ORAMINR=0 F  S ORAMINR=$O(^ORD(101.43,"B","INR/PT",ORAMINR)) Q:'+$G(ORAMINR)!(+$G(C))  I +$G(ORAMINR) S $P(RESULT,"|")=ORAMINR,C=1
        I $G(ORAMINR)="" S ORAMINR=0 F  S ORAMINR=$O(^ORD(101.43,"B","PT",ORAMINR)) Q:'+$G(ORAMINR)!(+$G(C))  I +$G(ORAMINR) S $P(RESULT,"|")=ORAMINR,C=1
        S ORAMCBC=0 F  S ORAMCBC=$O(^ORD(101.43,"B","CBC",ORAMCBC)) Q:'+$G(ORAMCBC)!(+$G(Y))  I +$G(ORAMCBC) S $P(RESULT,"|",2)=ORAMCBC,Y=1
        I $G(ORAMCBC)="" S ORAMCBC=$O(^ORD(101.43,"B","CBC ",ORAMCBC)) Q:'+$G(ORAMCBC)!(+$G(Y))  I +$G(ORAMCBC) S $P(RESULT,"|",2)=ORAMCBC,Y=1
        Q
        ;
SIGCHECK(RESULT,ESCODE) ;
        ;;CHECKS SIG CODE
        ;;RPC=ORAM SIGCHECK
        N SUCCESS,X
        S SUCCESS=0
        Q:ESCODE=""
        S X=ESCODE D HASH^XUSHSHP
        I $P($G(^VA(200,DUZ,20)),U,4)=X S SUCCESS=1 ;SIG CODE CORRECT
        S RESULT=$G(SUCCESS)
SIGQ    Q
        ;
HCT(RESULT,ORAMDFN)     ;GET HCT
        ;;GETS MOST RECENT HCT
        ;;RPC=ORAM HCT
        N HCT,LDATE,HCTDATE,LOOPCNT,HCTDIFF,LRDFN,ORAMS,ORAMHCT,ORAMDNM,OHCT,OHCTD,ORAMFM,ORAMHCTN
        I '$G(ORAMDFN) S RESULT="" Q  ;IF DFN IS NOT PASSED, EXIT
        S LRDFN=$$LAB($G(ORAMDFN)) Q:'+LRDFN
        S ORAMHCT=$$GET^XPAR("ALL","ORAM HCT/HGB REFERENCE",1,"B")
        I +$G(ORAMHCT)'>0 S RESULT="HCT Param not set." Q
        S ORAMHCTN=$P(ORAMHCT,U,2),ORAMHCT=$P(ORAMHCT,U)
        ; Get Lab Data Name based on IEN in ^LAB(60,
        S ORAMDNM=$P($P(^LAB(60,+ORAMHCT,0),U,5),";",2) Q:ORAMDNM']""
        S LDATE=0 F  SET LDATE=$O(^LR(LRDFN,"CH",LDATE)) S LOOPCNT=0 Q:LDATE=""!(+$G(HCT))  D  Q:LOOPCNT
        . S RESULT=$G(^LR(LRDFN,"CH",LDATE,ORAMDNM))
        . Q:RESULT=""
        . Q:$P(RESULT,U,1)=""  ;QUIT IF NO HCT DATA
        . S HCT=$P(RESULT,U,1)  ;HCT
        . S HCTDATE=9999999-LDATE
        . S LOOPCNT=1
        . Q:+HCT
        I LDATE="" S RESULT="NONE"
        I $D(^ORAM(103,ORAMDFN,6)),($L($P(^ORAM(103,ORAMDFN,6),U,4),"|")=3) D
        . S OHCT=$P($P(^ORAM(103,ORAMDFN,6),U,4),"|"),OHCTD=$P($P(^ORAM(103,ORAMDFN,6),U,4),"|",2)
        . I +$G(OHCT) D DT^DILF(,OHCTD,.ORAMFM)
        I +$G(HCTDATE),$G(ORAMFM)>HCTDATE S HCT=OHCT_" (Outside Lab)",HCTDATE=ORAMFM,ORAMHCTN="HCT"
        I '+$G(HCTDATE) S:+$G(OHCT) HCT=OHCT_" (Outside Lab)",ORAMHCTN="HCT" S:$G(ORAMFM)'="" HCTDATE=ORAMFM
        I +$G(HCTDATE) S HCTDATE=$$FMTE^XLFDT($E(HCTDATE,1,7),2)
        S RESULT=$G(HCT)_U_$G(HCTDATE)_U_ORAMHCTN
        Q
        ;
INR(RESULT,ORAMDFN)     ; Gets most recent INR
        ;;RPC=ORAM INR
        N LDATE,INR,INRFD,LRDFN,HDATE,TDIFF,SIXMON,COUNT,SCORE,ORAMITST,INRHD,INRRD
        N ORAMQO
        S RESULT=""
        I '$G(ORAMDFN) Q  ;IF DFN IS NOT PASSED, EXIT
        S LRDFN=$$LAB($G(ORAMDFN)) Q:'+$G(LRDFN)
        S ORAMQO=$$GET^XPAR("ALL","ORAM INR QUICK ORDER",1,"I") S ORAMITST=$$INRCHK(ORAMQO)
        I +ORAMITST'>0 Q
        S (LDATE,COUNT)=0,SIXMON=$$FMADD^XLFDT(DT,-180)
        F  S LDATE=$O(^LR(LRDFN,"CH",LDATE)) Q:+LDATE'>0!(LDATE>(9999999-SIXMON))  D
        . N SCORE,INR,INRFD,INRHD,INRRD,XDT
        . S SCORE=$G(^LR(LRDFN,"CH",LDATE,ORAMITST))
        . Q:SCORE=""  ;QUIT IF NO INR TEST
        . S INR=$P(SCORE,U)  ;INR
        . Q:INR=""  ;QUIT IF NO INR DATA
        . S INRFD=9999999-LDATE
        . S XDT=$P(INRFD,".") S INRHD=$$FMTH^XLFDT(XDT,1),INRRD=$$FMTE^XLFDT(XDT,"2P")
        . S RESULT(COUNT)=$G(INR)_"^^"_$G(INRRD)_U_$G(INRHD)
        . Q:INRFD<SIXMON  ;Q WHEN SEARCHED LAST 6 MONTHS
        . S COUNT=COUNT+1
        Q
        ;
CONCOMP(RESULT,ORAMCNUM,ORAMNNUM,ORAMDUZ)       ;
        ;;BRINGS IN CONSULT NUMBER(ORAMCNUM)
        ;;BRINGS IN NOTE NUMBER(ORAMNNUM), COMPLETES CONSULT
        ;;RPC=ORAM CONCOMP
        N ORAMCST
        S RESULT=0
        S ORAMCST=$S($$STATUS^TIULC(ORAMNNUM)="completed":"COMPLETE",1:"INCOMPLETE")
        D GET^GMRCTIU(ORAMCNUM,ORAMNNUM,ORAMCST,ORAMDUZ)
        S RESULT=1
        Q
        ;
LAB(DFN)        ;GET LAB NUMBER
        N LRDFN
        IF 'DFN S LRDFN="" G LABQ ;IF DFN IS NOT PASSED, EXIT
        S LRDFN=$G(^DPT(DFN,"LR"))
LABQ    Q LRDFN
        ;
ORDER(ORESULT,DFN,ORNP,ORLOC,ORQO,ORCDT)        ; Place Quick Order for INR or CBC
        ; RPC ORAM ORDER
        ;  in: DFN   - pt id file 2
        ;      ORNP  - ordering provider id file 200
        ;      ORLOC - location id file 42
        ;      ORQO  - quick order id file 101.41
        ;      ORCDT - collection date/time
        N ORANS,ORDIALOG,ORDG,ORDLG
        I +$G(DFN)'>0 S ORESULT="0^invalid Patient id" Q
        I +$G(ORNP)'>0 S ORESULT="0^invalid Provider id" Q
        I +$G(ORLOC)'>0 S ORESULT="0^invalid Location id" Q
        I +$G(ORQO)'>0 S ORESULT="0^invalid Quick Order id" Q
        I $G(ORCDT)']"" S ORESULT="0^invalid Collection Date/Time" Q
        D GETQDLG^ORCD(ORQO)
        I '$D(ORDIALOG) S ORESULT="0^invalid Quick Order id" Q
        S ORDLG=$$GET1^DIQ(101.41,+ORDIALOG_",",.01)
        I ORDLG']"" S ORESULT="0^invalid Quick Order id" Q
        S ORDG=$$GET1^DIQ(101.41,ORQO_",",5,"I")
        I +ORDG'>0 S ORESULT="0^invalid Quick Order id - no Display Group" Q
        S ORDIALOG(6,1)=$$IDATE(ORCDT)
        D SAVE^ORWDX(.ORESULT,DFN,ORNP,ORLOC,ORDLG,ORDG,ORQO,"",.ORDIALOG) ; Place the order
        ; if the order is placed, call UNOTIF^ORCSIGN to avoid duplicate alerts,
        ; then call NOTIF^ORCSIGN to generate an unsigned order notification
        I +ORESULT D
        . N ORVP,ORIFN,Y
        . S ORVP=DFN_";DPT(",ORIFN=$P($P($G(ORESULT(1)),"~",2),";")
        . D UNOTIF^ORCSIGN
        . D NOTIF^ORCSIGN
        Q
IDATE(ORX)      ; Convert External Date/time to FM Internal format
        N ORY S ORY=""
        D DT^DILF("T",ORX,.ORY) S:+ORY'>0 ORY=""
        Q ORY
QOORD(ORQO)     ; Given Quick Order, find the IEN of the Orderable Item
        N ORI,ORDIALOG,ORY S ORY=0
        D GETQDLG^ORCD(+$G(ORQO))
        I '$D(ORDIALOG) G QOORDX
        S ORI=0
        F  S ORI=$O(ORDIALOG(ORI)) Q:ORI'>0!+ORY>0  D
        . I $G(ORDIALOG(ORI))["ORDERABLE" S ORY=$G(ORDIALOG(ORI,1))
QOORDX  Q ORY
