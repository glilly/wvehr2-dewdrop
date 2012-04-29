PXRMDLR1        ; SLC/AGP - DIALOG ORPHAN REPORT. ; 07/31/2009
        ;;2.0;CLINICAL REMINDERS;**6,12**;Feb 04, 2005;Build 73
        ;
        ;=======================================================================
START(NUM)      ;
        N DIR,POP,ZTDESC,ZTRTN,ZTSAVE
        S %ZIS="M"
        I NUM=1 S ZTDESC="Dialog Orphan Report" S ZTRTN="ORPHAN^PXRMDLR1"
        I NUM=2 S ZTDESC="Empty Reminder Dialogs Report" S ZTRTN="EMPTY^PXRMDLR1"
        S ZTSAVE("*")=""
        D EN^XUTMDEVQ(ZTRTN,ZTDESC,.ZTSAVE,.%ZIS)
        Q
        ;
ORPHAN  ;
        N NAME,IEN,TYPE
        K ^TMP("PXRMDLR1",$J)
        S IEN=0
        S NAME="" F  S NAME=$O(^PXRMD(801.41,"B",NAME)) Q:NAME=""  D
        . S IEN=$O(^PXRMD(801.41,"B",NAME,"")) Q:IEN'>0
        . S TYPE=$P($G(^PXRMD(801.41,IEN,0)),U,4)
        . I $G(TYPE)=""!($G(TYPE)="R") Q
        . I $D(^PXRMD(801.41,"R",IEN)) Q
        . I $D(^PXRMD(801.41,"AD",IEN)) Q
        . I $D(^PXRMD(801.41,"RG",IEN)) Q
        . S TYPE=$S(TYPE="P":"VPROMPT",TYPE="E":"ELEMENT",TYPE="F":"VVALUE",TYPE="G":"GROUP",TYPE="S":"RGROUP",TYPE="T":"RELEMENT")
        . S ^TMP("PXRMDLR1",$J,TYPE,NAME)=IEN
        I $D(^TMP("PXRMDLR1",$J))>0 D OUTPUT
        Q
        ;
EMPTY   ;
        N DONE,FOUND,NAME,IEN,TITLE,TYPE
        W @IOF
        S PCNT=0,PAGE=1,DONE=0,FOUND=0
        S TITLE="Empty Reminder Dialogs Report"
        D HEADER(.PCNT,PAGE,TITLE)
        S IEN=0
        S NAME="" F  S NAME=$O(^PXRMD(801.41,"B",NAME)) Q:NAME=""!(DONE=1)  D
        . S IEN=$O(^PXRMD(801.41,"B",NAME,"")) Q:IEN'>0
        . S TYPE=$P($G(^PXRMD(801.41,IEN,0)),U,4)
        . I ($G(TYPE)'="R") Q
        . I $D(^PXRMD(801.41,IEN,10))'=0 Q
        . S FOUND=1
        . I (PCNT+1)'<IOSL D PAGE(.PCNT,.PAGE) I $G(DONE)=1 Q
        . W !,"  "_$G(NAME) S PCNT=PCNT+1 I (PCNT+1)'<IOSL D PAGE(.PCNT,.PAGE) I $G(DONE)=1 Q
        I FOUND=0 W !,"No empty dialog found"
        I ($E(IOST,1,2)="C-")&(IO=IO(0)) D
        . W !
        . S DIR(0)="E" D ^DIR K DIR
        Q
        ;
OUTPUT  ;
        N CAT,DONE,LENGTH,NAME,OCAT,PAGE,PCNT,TITLE,TYPE,X
        W @IOF
        S PCNT=0,PAGE=1,DONE=0
        S TITLE="Reminder Dialog Elements Orphan Report"
        D HEADER(.PCNT,PAGE,TITLE)
        W !
        F CAT="ELEMENT","GROUP","RELEMENT","RGROUP","VPROMPT","VVALUE" D
        . I DONE=1 Q
        . I $D(^TMP("PXRMDLR1",$J,CAT))'>0 Q
        . S TYPE=$S(CAT="VPROMPT":"Additional Prompts",CAT="ELEMENT":"Dialog Elements",CAT="VVALUE":"Force Values",CAT="GROUP":"Dialog Groups",CAT="RGROUP":"Result Groups",CAT="RELEMENT":"Result Elements")
        . I (PCNT+4)'<IOSL D PAGE(.PCNT,.PAGE) I $G(DONE)=1 Q
        . S LENGTH=$L(TYPE) W !!,TYPE,! F X=1:1:LENGTH W "="
        . S PCNT=PCNT+4
        . I (PCNT+1)'<IOSL D PAGE(.PCNT,.PAGE) I $G(DONE)=1 Q
        . S NAME="" F  S NAME=$O(^TMP("PXRMDLR1",$J,CAT,NAME)) Q:NAME=""!(DONE=1)  D
        . .W !,$$LJ^XLFSTR("",4)_NAME S PCNT=PCNT+1
        . .I (PCNT+1)'<IOSL D PAGE(.PCNT,.PAGE) I $G(DONE)=1 Q
        K ^TMP("PXRMDLR1",$J)
        I ($E(IOST,1,2)="C-")&(IO=IO(0)) D
        . W !
        . S DIR(0)="E" D ^DIR K DIR
        Q
        ;
HEADER(PCNT,PAGE,TITLE) ;
        W $$LJ^XLFSTR(TITLE,70)_"Page: "_PAGE,!
        F X=1:1:80 W "="
        S PCNT=PCNT+3
        Q
        ;
PAGE(PCNT,PAGE) ;
        N DUOUT,DTOUT,DIROUT,DIR
        I ($E(IOST,1,2)="C-")&(IO=IO(0)) D
        .S DIR(0)="E"
        .W !
        .D ^DIR K DIR
        I $D(DUOUT)!($D(DTOUT))!($D(DIROUT)) S DONE=1 Q
        W:$D(IOF) @IOF
        S PAGE=PAGE+1,PCNT=0
        I ($E(IOST,1,2)="C-")&(IO=IO(0)) W @IOF D HEADER(.PCNT,PAGE,TITLE)
        Q
STAND   ;
        Q
