TIUHSOLM        ;;SLC/AJB,AGP Display Health Summary Object for TIU Objects;27-MAR-2009
        ;;1.0;TEXT INTEGRATION UTILITIES;**135,249**;Jun 20, 1997;Build 48
        ;
EN(IEN,TIUIEN)  ; -- main entry point for TIUHS OBJ DISPLAY
        D EN^VALM("TIUHS OBJ DISPLAY")
        Q
        ;
HDR     ; -- header code
        N CENTER,HEADER,TIUNAM,HSOBJNOD,TITLE,VALHDR,VALMSG
        ;S HSOBJNOD=$G(^GMT(142.5,IEN,0))
        S TIUNAM=$P($G(^TIU(8925.1,TIUIEN,0)),U)
        S TITLE="Detailed Display for "_TIUNAM
        S CENTER=(IOM-$L(TITLE))/2
        S HEADER=$$SETSTR^VALM1(TITLE,"",CENTER,$L(TITLE))
        S VALMHDR(1)=HEADER
        S VALMSG="?? More Actions"
        D XQORM
        Q
        ;
INIT    ; -- init variables and list array
        N LINE,OBJ,OBJDISP,OBJECT,VAL,VALUE
        S LINE=0
        ;hs object heading
        D EXTRACT^GMTSOBJ(IEN,.OBJ)
        S HSTYNAM=$G(OBJ(IEN,.03,"E"))
        S VALUE=$J("HS Object",25)_": "_$G(OBJ(IEN,.01,"E")),LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        I $G(OBJ(IEN,.02,"E"))'="" D
        . S VALUE=$J($G(OBJ(IEN,.02,"PROMPT")),25)_": "_$G(OBJ(IEN,.02,"E"))
        . S LINE=LINE+1
        . D SET^VALM10(LINE,VALUE)
        S VALUE=$J($G(OBJ(IEN,.03,"PROMPT")),25)_": "_HSTYNAM,LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=$J($G(OBJ(IEN,.04,"PROMPT")),25)_": "_$G(OBJ(IEN,.04,"E")),LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=$J($G(OBJ(IEN,.17,"PROMPT")),25)_": "_$G(OBJ(IEN,.17,"E"))
        S LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=" ",LINE=LINE+1 D SET^VALM10(LINE,VALUE)
        S OBJDISP="HS Object",CENTER=(IOM-$L(OBJDISP))/2
        S VALUE=$$SETSTR^VALM1(OBJDISP,"",CENTER,$L(OBJDISP))
        S LINE=LINE+1 D SET^VALM10(LINE,VALUE)
        S VALUE=" ",LINE=LINE+1 D SET^VALM10(LINE,VALUE)
        S VALUE=$J($G(OBJ(IEN,.07,"PROMPT")),29)_": "_$G(OBJ(IEN,.07,"E"))
        S VAL=$$LJ^XLFSTR(VALUE,40) S VALUE=VAL_$J($G(OBJ(IEN,.09,"PROMPT")),28)_": "_$G(OBJ(IEN,.09,"E"))
        S LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=$J($G(OBJ(IEN,.08,"PROMPT")),29)_": "_$G(OBJ(IEN,.08,"E"))
        S VAL=$$LJ^XLFSTR(VALUE,40) S VALUE=VAL_$J($G(OBJ(IEN,.1,"PROMPT")),28)_": "_$G(OBJ(IEN,.1,"E"))
        S LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=$J("Customized Header",29)_": "_$G(OBJ(IEN,.06,"E"))
        S VAL=$$LJ^XLFSTR(VALUE,40) S VALUE=VAL_$J($G(OBJ(IEN,.09,"PROMPT")),28)_": "_$G(OBJ(IEN,.09,"E"))
        S LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=$J($G(OBJ(IEN,.05,"PROMPT")),29)_": "_$G(OBJ(IEN,.05,"E"))
        S VAL=$$LJ^XLFSTR(VALUE,40) S VALUE=VAL_$J($G(OBJ(IEN,.12,"PROMPT")),28)_": "_$G(OBJ(IEN,.12,"E"))
        S LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=$J($G(OBJ(IEN,.16,"PROMPT")),29)_": "_$G(OBJ(IEN,.16,"E"))
        S VAL=$$LJ^XLFSTR(VALUE,40) S VALUE=VAL_$J($G(OBJ(IEN,.14,"PROMPT")),28)_": "_$G(OBJ(IEN,.14,"E"))
        S LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=$J($G(OBJ(IEN,.2,"PROMPT")),29)_": "_$G(OBJ(IEN,.2,"E"))
        S VAL=$$LJ^XLFSTR(VALUE,40) S VALUE=VAL_$J($G(OBJ(IEN,.13,"PROMPT")),28)_": "_$G(OBJ(IEN,.13,"E"))
        S LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=$$RJ^XLFSTR("Blank Line After Header",68)_": "_$G(OBJ(IEN,.15,"E"))
        S LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALUE=$$RJ^XLFSTR("Overwrite No Data",19)_": "_$G(OBJ(IEN,2,"E"))
        S LINE=LINE+1
        D SET^VALM10(LINE,VALUE)
        S VALMCNT=LINE
        Q
        ;
EHSO    ;
        N HSOBNAM,VALUE
        D FULL^VALM1
        I $P($G(^GMT(142.5,HSOBJ,0)),U,20)=1 W !,"Can't edit this HS Object:  Only the owner can edit this HS Object" H 2 Q
        I $P($G(^GMT(142.5,HSOBJ,0)),U,17)'=DUZ,'$D(^XUSEC("GMTSMGR",DUZ)) W !,"Can't edit this HS Object:  Only the owner or the HS Manager can edit this HS Object" H 2 Q
        S HSOBNAM=$P($G(^GMT(142.5,IEN,0)),U)
        S VALUE=$$CRE^GMTSOBJ(HSOBNAM)
        D CLEAN^VALM10
        D INIT
        Q
        ;
CHST    ;
        N DA,DIC,DIE,DIR,DIROUT,DR,DTOUT,DUOUT,HSIEN,POP,TEXT,X,Y,YESNO
        D FULL^VALM1
        I $P($G(^GMT(142.5,HSOBJ,0)),U,20)=1 W !,"Can't edit this National Object" H 2 Q
        I $P($G(^GMT(142.5,HSOBJ,0)),U,17)'=DUZ,'$D(^XUSEC("GMTSMGR",DUZ)) W !,"Can't edit this HS Object:  Only the owner or the HS Manager can edit this HS Object" H 2 Q
        W !,"***WARNING*** By changing the HS Type this will change the output data."
        S DIR(0)="YA0"
        S DIR("A")="Continue? "
        S DIR("B")="NO"
        S DIR("?")="Enter Y or N. For detailed help type ??"
        D ^DIR
        I $D(DIROUT) S DTOUT=1
        I $D(DTOUT)!($D(DUOUT)) Q
        S YESNO=$E(Y(0))
        I YESNO="Y" D
        .S DIC=142,DIC(0)="AEMQ",DIC("S")="I Y'<1",DIC("A")="Enter HEALTH SUMMARY TYPE: "
        .W ! D ^DIC
        .I Y=-1 K DIC Q
        .S HSIEN=+Y
        .S DIE="^GMT(142.5,",DA=IEN,DR=".03///^S X=HSIEN" D ^DIE
        .D CLEAN^VALM10
        .D INIT
        Q
        ;
CREATEHS        ;
        N POP
        D FULL^VALM1
        D TYPE^GMTSOBJ(HSTYNAM)
        W ! S DIR(0)="E" D ^DIR
        D CLEAN^VALM10
        D INIT
        Q
        ;
HELP    ; -- help code
        S X="?" D DISP^XQORM1 W !!
        Q
        ;
XQORM   ;
        S XQORM("A")="Select Action: "
        Q
        ;
EXIT    ; -- exit code
        Q
        ;
EXPND   ; -- expand code
        Q
        ;
