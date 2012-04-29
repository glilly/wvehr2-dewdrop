ORCMED  ;SLC/MKB-Medication actions ;03/19/07
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**4,7,38,48,94,141,178,190,195,243**;Dec 17, 1997;Build 242
XFER    ; -- transfer to in/outpt meds
        N ORPTLK,ORTYPE,ORXFER,ORSRC,ORCAT,OREVENT,X,ORINPT,ORIDLG,ORODLG,ORIVDLG,ORNMSP,ORCNT,ORI,NMBR,ORIFN,OLDIFN,ORDIALOG,ORDG,ORCHECK,ORQUIT,ORDUZ,ORLOG,FIRST,ORDITM,ORD,ORERR
        S ORPTLK=$$LOCK^ORX2(+ORVP) I 'ORPTLK D  G XFQ ; lock pt chart
        . W !!,$C(7),$P(ORPTLK,U,2) H 2
        . S:'$D(VALMBCK) VALMBCK=""
        I '$G(ORNMBR) S ORNMBR=$$ORDERS^ORCHART("transfer") G:'ORNMBR XFQ
        D FULL^VALM1 S VALMBCK="R",ORTYPE="Q",ORXFER=1,ORDUZ=DUZ,ORSRC="X"
        S X=$P($P($G(^TMP("OR",$J,"CURRENT",0)),U,3),";",3) S:X="" X=$G(ORWARD)
        S ORCAT=$S(X:"O",1:"I") I ORCAT="I"!$G(ORWARD) D  Q:$G(OREVENT)="^"
        . W !!,$$CURRENT^OREVNT
        . S X=$$DELAY^ORCACT I X="^" S OREVENT="^" Q
        . S:X OREVENT=+$$PTEVENT^OREVNT(+ORVP,1)
        I '$G(ORL) S ORL=$S($G(OREVENT):$$LOC^OREVNTX(OREVENT),1:$$LOCATION^ORCMENU1) G:ORL="^" XFQ
        S ORINPT=$$INPT^ORCD,ORNP=$$PROVIDER^ORCMENU1 G:ORNP="^" XFQ
        I 'ORINPT,ORCAT="I" D IMOLOC^ORIMO(.ORINPT,+ORL,+ORVP) S:ORINPT<0 ORINPT=0 ;allow inpt meds at this location?
        S ORIDLG=+$O(^ORD(101.41,"AB","PSJ OR PAT OE",0))
        S ORODLG=+$O(^ORD(101.41,"AB","PSO OERR",0))
        S ORIVDLG=+$O(^ORD(101.41,"AB","PSJI OR PAT FLUID OE",0))
        D PROVIDER^ORCDPSIV G:$G(ORQUIT) XFQ ;X:$D(^ORD(101.41,ORDIALOG,3)) ^(3)
        S ORNMSP="PS" D DISPLAY^ORCHECK
        S ORCNT=$L(ORNMBR,",") S:$P(ORNMBR,",",ORCNT)'>0 ORCNT=ORCNT-1
XF1     F ORI=1:1:ORCNT S NMBR=$P(ORNMBR,",",ORI) D:NMBR  I $D(ORQUIT),ORI<ORCNT Q:'$$CONT  ;if not last one, ask
        . K ORIFN,ORDIALOG,ORDG,ORDOSE,ORCHECK,ORQUIT,ORERR
        . K ^TMP("PSJMR",$J),^TMP("ORWORD",$J),^TMP("ORSIG",$J)
        . S OLDIFN=+$P($G(^TMP("OR",$J,ORTAB,"IDX",NMBR)),U,4)
        . S ORDITM=$$ORDITEM^ORCACT(OLDIFN) D SUBHDR^ORCACT(ORDITM)
        . I '$$VALID^ORCACT0(OLDIFN,"XFR",.ORERR) W !,ORERR H 2 Q
        . S ORD=$P($G(^OR(100,OLDIFN,0)),U,5) Q:ORD'["101.41"  ;error msg?
        . S ORDIALOG=$S(+ORD=ORIVDLG:ORIVDLG,ORCAT="I":ORIDLG,1:ORODLG)
        . S ORDG=+$P($G(^ORD(101.41,ORDIALOG,0)),U,5)
        . D GETDLG^ORCD(ORDIALOG),GETORDER^ORCD(OLDIFN)
        . I ORDIALOG'=ORIVDLG D OUT:ORCAT="I",IN:ORCAT="O" ;convert data
        . K ORDIALOG($$PTR^ORCD("OR GTX START DATE/TIME"),1)
        . K ORDIALOG($$PTR^ORCD("OR GTX NOW"),1)
        . S ORLOG=+$E($$NOW^XLFDT,1,12),FIRST=1
XF2     . D DIALOG^ORCDLG Q:$G(ORQUIT)&FIRST  K ORQUIT
        . D ACCEPT^ORCHECK(),DISPLAY^ORCDLG S X=$$OK^ORCDLG I X="^" S ORQUIT=1 Q
        . I X="E" K ORCHECK S FIRST=0 G XF2
        . I X="C" W !?10,"... order cancelled.",! Q
        . I X="P" D
        . . D EN^ORCSAVE W !?10,$S(ORIFN:"... order placed.",1:"ERROR"),!
        . . S:$G(ORIFN) ^TMP("ORNEW",$J,ORIFN,1)=""
        . . I '$D(^TMP("ORECALL",$J,ORDIALOG)) M ^(ORDIALOG)=ORDIALOG M:$D(^TMP("ORWORD",$J)) ^TMP("ORECALL",$J,ORDIALOG)=^TMP("ORWORD",$J) ;save 1st values
XFQ     D EXIT^ORCDPS1 ;X:$D(^ORD(101.41,ORDIALOG,4)) ^(4)
        K ^TMP("ORWORD",$J),^TMP("ORSIG",$J)
        D:'$D(^TMP("ORNEW",$J)) UNLOCK^ORX2(+ORVP) ;unlock if no new orders
        Q
        ;
IN      ; -- Kill extra values, Reset ID's/DD from Inpt dialog
        N P F P="START DATE/TIME","NOW" K ORDIALOG($$PTR(P),1)
        D DOSES("O")
        Q
        ;
OUT     ; -- Kill extra values, Reset ID's/DD from Outpt dialog
        N P I '$O(ORDIALOG($$PTR("INSTRUCTIONS"),0)) D  ;old sig in comments
        . N WP S WP=$$PTR("WORD PROCESSING 1") K ^TMP("ORSIG",$J)
        . M ^TMP("ORSIG",$J)=^TMP("ORWORD",$J,WP,1)
        . K ORDIALOG(WP,1),^TMP("ORWORD",$J,WP,1)
        F P="PATIENT INSTRUCTIONS","START DATE/TIME","DAYS SUPPLY","QUANTITY","REFILLS","ROUTING","SERVICE CONNECTED" K ORDIALOG($$PTR(P),1)
        I $G(ORDIALOG($$PTR("URGENCY"),1))=99 K ORDIALOG($$PTR("URGENCY"),1)
        D DOSES("I")
        Q
        ;
DOSES(TYPE)         ; -- Convert doses to new TYPE, reset ID strings
        N PSOI,ORMED,PROMPT,DOSE,DRUG,I,X,DD,DRUG0,STR
        F I="DISPENSE DRUG","STRENGTH","DRUG NAME","SIG" K ORDIALOG($$PTR(I),1)
        S PSOI=+$P($G(^ORD(101.43,+$G(ORDIALOG($$PTR("ORDERABLE ITEM"),1)),0)),U,2),ORMED=$P($G(^(0)),U)
        D DOSE^PSSORUTL(.ORDOSE,PSOI,TYPE,+ORVP) I $G(ORDOSE(1))=-1 K ORDOSE
        S PROMPT=$$PTR("INSTRUCTIONS"),DOSE=$$PTR("DOSE")
        S DRUG=$$PTR("DISPENSE DRUG") D D1^ORCDPS2
        S I=0 F  S I=$O(ORDIALOG(PROMPT,I)) Q:I'>0  D
        . K ORDIALOG(DOSE,I) S X=$G(ORDIALOG(PROMPT,I)) Q:'$L(X)
        . S X=$$UP^XLFSTR(X),DD=+$G(ORDIALOG(PROMPT,"LIST","D",X)) Q:'DD
        . S ORDIALOG(DOSE,I)=$TR($G(ORDOSE("DD",DD,X)),"^","&")
        . S ORDIALOG(DRUG,I)=DD,DRUG0=$G(ORDOSE("DD",DD))
        . S STR=$P(DRUG0,U,5)_$P(DRUG0,U,6)
        . I STR'>0 S:'$G(ORDOSE(1)) ORDIALOG($$PTR("DRUG NAME"),1)=$P(DRUG0,U) Q
        . I ORMED'[STR,TYPE="O"!'$G(ORDOSE(1)) S ORDIALOG($$PTR("STRENGTH"),1)=STR
        Q
        ;
CONT()  ; -- Want to continue processing orders?
        N X,Y,DIR
        S DIR(0)="YA",DIR("A")="Do you want to continue transferring orders? ",DIR("B")="YES"
        S DIR("?")="Enter YES to continue transferring the remaining orders selected, or NO to quit this option."
        D ^DIR
        Q +Y
        ;
SHOWSIG ; -- Show old sig for transfer in ^TMP("ORSIG",$J)
        N ORTX,I,X,ORMAX S ORMAX=72
        S I=0 F  S I=$O(^TMP("ORSIG",$J,I)) Q:I'>0  S X=$G(^(I,0)) D:$L(X) TXT^ORCHTAB
        S I=0 F  S I=$O(ORTX(I)) Q:I'>0  W !,$S(I=1:"(Sig: ",1:"      ")_ORTX(I)
        W ")"
        Q
        ;
PTR(NAME)       ; -- Returns pointer to OR GTX NAME
        Q +$O(^ORD(101.41,"AB",$E("OR GTX "_NAME,1,63),0))
        ;
REFILLS ; -- Request a refill for med orders
        ;    ORNMBR = #,#,...,# of selected orders
        ;
        N ORLK,ORI,NMBR,IDX,ORIFN,ORDITM,ORERR,ORQUIT,OROUT
        I '$G(ORNMBR) S ORNMBR=$$ORDERS^ORCHART("") G:'ORNMBR RFQ
        D FREEZE^ORCMENU S VALMBCK="R"
        S ORNP=$$PROVIDER^ORCMENU1 G:ORNP="^" RFQ
        S:'$G(ORL) ORL=$$LOCATION^ORCMENU1 G:ORL="^" RFQ
        S OROUT=$$ROUTING G:OROUT="^" RFQ
        F ORI=1:1:$L(ORNMBR,",") S NMBR=$P(ORNMBR,",",ORI) D:NMBR  Q:$D(ORQUIT)
        . S IDX=$G(^TMP("OR",$J,"CURRENT","IDX",NMBR)),ORIFN=+$P(IDX,U,4)
        . Q:'ORIFN  I '$D(^OR(100,ORIFN,0)) W !,"Invalid order number!" H 2 Q
        . S ORDITM=$$ORDITEM^ORCACT(ORIFN) D SUBHDR^ORCACT(ORDITM)
        . I '$$VALID^ORCACT0(ORIFN,"RF",.ORERR) W !,ORERR H 2 Q
        . S ORLK=$$LOCK1^ORX2(+ORIFN) I 'ORLK W !,$P(ORLK,U,2) H 2 Q
        . D REF^ORMBLDPS(ORIFN,OROUT),UNLK1^ORX2(+ORIFN)
        . W !?10,"... refill requested.",$$RETURN
RFQ     Q
        ;
RETURN()        ; -- press return to cont
        N X W !,"Press <return> to continue ..." R X:DTIME
        Q ""
        ;
ROUTING()       ; -- Routing for refill
        N X,Y,DIR S DIR(0)="SAM^W:WINDOW;M:MAIL;C:ADMINISTERED IN CLINIC;"
        S DIR("A")="Routing: ",DIR("B")=$S($D(^PSX(550,"C")):"MAIL",1:"WINDOW")
        S DIR("?")="Select how the patient is to receive this refill, by mail or at the window or in the clinic"
        D ^DIR S:$D(DTOUT)!(X["^") Y="^"
        Q Y
        ;
NW      ; -- Order New Medication from Meds tab
        ;    Requires ORDIALOG      = name of pkg dialog
        ;             OREVENT       = event, if delaying orders
        ;             OREVENT("TS") = treating spec, if admission or transfer
        N ORPTLK G:'$L($G(ORDIALOG)) NWQ
        S ORPTLK=$$LOCK^ORX2(+ORVP) I 'ORPTLK W !!,$C(7),$P(ORPTLK,U,2) H 2 Q
        D FREEZE^ORCMENU S VALMBCK="R"
        S ORNP=$$PROVIDER^ORCMENU1 G:ORNP="^" NWQ
        I '$G(ORL) S ORL=$S($G(OREVENT):$$LOC^OREVNTX(OREVENT),1:$$LOCATION^ORCMENU1) G:ORL["^" NWQ
        S ORDIALOG=$O(^ORD(101.41,"AB",$E(ORDIALOG,1,63),0)) G:'ORDIALOG NWQ
        D ADD^ORCDLG,REBLD^ORCMENU:$D(^TMP("ORNEW",$J))
        K ORDIALOG,^TMP("ORWORD",$J),^TMP("ORECALL",$J) S VALMBCK="R"
NWQ     D:'$D(^TMP("ORNEW",$J)) UNLOCK^ORX2(+ORVP) ;unlock if no new orders
        Q
