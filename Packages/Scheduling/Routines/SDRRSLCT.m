SDRRSLCT        ;10N20/MAH;-RECALL REMINDER Generic file entry selector ;12/09/2007  14:26
        ;;5.3;Scheduling;**536**;Aug 13, 1993;Build 53
        ;
        ;
        ;Requires:
        ; SDRRDDIC      = File number or global root
        ; SDRRDDIC(0)   = DIC(0) string
        ; SDRRDUTIL     = Node to store data under in ^TMP($J,SDRRDUTIL,
        ;
        ;Optional:
        ; SDRRDDIC("A") = DIC("A") string
        ; SDRRDDIC("B") = DIC("B") string
        ; SDRRDDIC("S") = DIC("S") string
        ; SDRRDDIC("W") = DIC("W") string
        ; SDRRDROOT     = Closed array reference where data should be stored
        ;                Defaluts to ^TMP($J,SDRRDUTIL)
        ; SDRRDFLD      = Field to sort by if valid data to be stored as
        ;                @Root@(SDRRDUTIL,ExternalValueSDRRDFLD,IEN)=""
        ;                SDRRDFLD must reside on the zero (0) node to be valid
        ;
        ;Returns:
        ; $$EN() = $S(UpArrowOut:0, NothingSelected:0, 1:1)
        ; @SDRRDROOT@(SDRRDUTIL,ExternalFieldData,IEN)=""
        ;
        ;Example:
        ; SET SDRRDDIC=44,SDRRDDIC(0)="EMNQZ",SDRRDDIC("A")="Select CLINIC: "
        ; SET SDRRDDIC("B")="ALL",SDRRDDIC("S")="IF $PIECE(^(0),U,3)=""C"""
        ; IF $$EN^SDRRSLCT(.SDRRDDIC,"ClinicNode","MYARRAY",1)'>0 QUIT
        ;
EN(SDRRDDIC,SDRRDUTIL,SDRRDROOT,SDRRDFLD)       ;
        N %DT,SDRRDDONE,SDRRDDSEL,SDRRDFL01,SDRRDFNAM,SDRRDFNUM,SDRRDFSCR,SDRRDMASK
        N SDRRDNUM,SDRRDQUIT,SDRRDVALU,SDRRDX,DIC,DO,DTOUT,DUOUT,I,X,Y
        S SDRRDFLD=$G(SDRRDFLD)
        I $G(SDRRDROOT)]"" S SDRRDROOT=$NA(@SDRRDROOT@(SDRRDUTIL))
        E  S SDRRDROOT=$NA(^TMP($J,SDRRDUTIL))
        K @SDRRDROOT
        S (SDRRDQUIT,SDRRDDONE)=0
        S SDRRDQUIT=(($G(SDRRDDIC)="")!($G(SDRRDDIC(0))="")!($G(SDRRDUTIL)=""))
        I SDRRDQUIT>0 G EXIT
        S DIC=SDRRDDIC
        I DIC>0 D  I SDRRDQUIT G EXIT
        . S (SDRRDDIC,DIC)=$$GET1^DID(DIC,"","","GLOBAL NAME")
        . S SDRRDQUIT=$S(DIC="":1,1:0)
        . Q
        S (DIC(0),SDRRDDIC(0))=$TR(SDRRDDIC(0),"AL")_$S(SDRRDDIC(0)'["Z":"Z",1:"")
        D FILEATTR(DIC,DIC(0),.SDRRDFNUM,.SDRRDFNAM,.SDRRDFL01,.SDRRDFSCR)
        I SDRRDFLD]"" S SDRRDQUIT=$$FLD(SDRRDFNUM,SDRRDFLD) I SDRRDQUIT G EXIT
        F I="A","B","S","W" S SDRRDDIC(I)=$G(SDRRDDIC(I))
        I SDRRDDIC("A")="" S SDRRDDIC("A")="Select "_SDRRDFNAM_" "_SDRRDFL01_": "
        S SDRRDNUM=1
        D HOME^%ZIS
        F  D  Q:SDRRDQUIT!SDRRDDONE
        . D SETDIC(.SDRRDDIC,.DIC,.DO)
        . W !!,$S(SDRRDNUM>1:"Another one (Select/De-Select): ",1:DIC("A"))
        . W $S((SDRRDNUM=1)&(SDRRDDIC("B")]""):SDRRDDIC("B")_"// ",1:"")
        . R SDRRDX:DTIME S:('$T)!($E(SDRRDX)=U) SDRRDQUIT=1 Q:SDRRDQUIT
        . I (SDRRDNUM=1)&(SDRRDX="")&(SDRRDDIC("B")]"") S SDRRDX=SDRRDDIC("B")
        . I SDRRDX="" S SDRRDDONE=1 Q
        . S SDRRDDSEL=$S(SDRRDX?1"-"1.E:1,1:0)
        . I SDRRDDSEL S SDRRDX=$E(SDRRDX,2,$L(SDRRDX))
        . I SDRRDX?1.ANP1"-"1.ANP D  Q:SDRRDQUIT=1  I SDRRDQUIT=-1 S SDRRDQUIT=0 Q
        .. S SDRRDQUIT=$$RANGE^SDRRSLC1(SDRRDX,.SDRRDDIC,SDRRDUTIL,SDRRDFLD,SDRRDDSEL,.SDRRDNUM)
        .. Q
        . I ($$UP^XLFSTR(SDRRDX)="ALL")!(SDRRDX["*") D  Q:SDRRDQUIT=1  I SDRRDQUIT=-1 S SDRRDQUIT=0 Q
        .. S SDRRDQUIT=$$ALL^SDRRSLC1(SDRRDX,.SDRRDDIC,SDRRDUTIL,SDRRDFLD,SDRRDDSEL,.SDRRDNUM)
        .. Q
        . I $E(SDRRDX)="?" D HELP(.SDRRDDIC,SDRRDUTIL,SDRRDFLD)
        . I $L($G(DIC("S")))<235 D
        .. S DIC("S")=$S($G(DIC("S"))]"":DIC("S")_" ",1:"")
        .. S DIC("S")=DIC("S")_"I $$SEL^SDRRSLCT(Y,"_SDRRDFNUM_","_SDRRDDSEL
        .. S DIC("S")=DIC("S")_$S($G(SDRRDFLD)]"":","_SDRRDFLD,1:"")_")"
        .. Q
        . S X=SDRRDX D ^DIC K DIC I +Y'>0 Q
        . S SDRRDMASK=+Y
        . I $$CHFLD(SDRRDFNUM)["D" D
        .. N %DT,X
        .. S X=Y(0,0),%DT="ST" D ^%DT S Y(0,0)=Y
        .. Q
        . S Y=SDRRDMASK
        . I SDRRDFLD="" D
        .. D SETDATA(Y(0,0),+Y,SDRRDUTIL,SDRRDDSEL,.SDRRDNUM)
        .. Q
        . E  D
        .. S SDRRDVALU=$$FLDSRT(SDRRDFNUM,SDRRDFLD,Y(0))
        .. I SDRRDVALU]"" D SETDATA(SDRRDVALU,+Y,SDRRDUTIL,SDRRDDSEL,.SDRRDNUM)
        .. Q
        . Q
        ;
EXIT    ;
        S SDRRDQUIT=$S(SDRRDQUIT>0:0,$O(@SDRRDROOT@(""))="":0,1:1)
        I SDRRDQUIT'>0 K @SDRRDROOT
        Q SDRRDQUIT
        ;
SETDATA(SDRRDVALU,SDRRD0,SDRRDUTIL,SDRRDDSEL,SDRRDNUM)  ;
        I 'SDRRDDSEL,'$D(@SDRRDROOT@($E(SDRRDVALU,1,63),SDRRD0)) D
        . S @SDRRDROOT@($E(SDRRDVALU,1,63),SDRRD0)=""
        . S SDRRDNUM=SDRRDNUM+1
        . Q
        I SDRRDDSEL,$D(@SDRRDROOT@($E(SDRRDVALU,1,63),SDRRD0)) D
        . K @SDRRDROOT@($E(SDRRDVALU,1,63),SDRRD0)
        . S SDRRDNUM=SDRRDNUM-$S(SDRRDNUM>0:1,1:0)
        . Q
        Q
        ;
HELP(SDRRDDIC,SDRRDUTIL,SDRRDFLD)       ;
        N SDRRD,SDRRD0,SDRRDCASE,SDRRDFL01,SDRRDFNAM,SDRRDFNUM
        N SDRRDFSCR,SDRRDLINE,SDRRDQUIT,DIC,D0,DA,DO,X
        S SDRRDQUIT=0
        D FILEATTR(SDRRDDIC,SDRRDDIC(0),.SDRRDFNUM,.SDRRDFNAM,.SDRRDFL01,.SDRRDFSCR)
        S SDRRDCASE=$$PLURAL(SDRRDFL01)
        W !
        S SDRRD="Select a "_SDRRDFNAM_" "_SDRRDFL01_" from the displayed list."
        D WRAP(SDRRD,.SDRRDLINE)
        S SDRRD=0
        F  S SDRRD=$O(SDRRDLINE(SDRRD)) Q:SDRRD'>0  W !?5,SDRRDLINE(SDRRD)
        W !?5,"To deselect a ",SDRRDFL01," type a minus sign (-)"
        W !?5,"in front of it, e.g.,  -",SDRRDFL01,"."
        W !?5,"To get all ",SDRRDFL01,SDRRDCASE," type ALL."
        W !?5,"Use an asterisk (*) to do a wildcard selection, e.g.,"
        W !?5,"enter ",SDRRDFL01,"* to select all entries that begin"
        W !?5,"with the text '",SDRRDFL01,"'.  Wildcard selection is"
        W !?5,"case sensitive.  A range may be selected by entering"
        W !?5,"'AAA-CCC', i.e., select all records from 'AAA' to"
        W !?5,"'CCC' inclusive."
        W !
        I $O(@SDRRDROOT@(""))]"" D
        . S SDRRDLINE=$Y
        . S SDRRD=""
        . W !,"You have already selected:"
        . F  S SDRRD=$O(@SDRRDROOT@(SDRRD)) Q:SDRRD=""!SDRRDQUIT  D
        .. S SDRRD0=0
        .. F  S SDRRD0=$O(@SDRRDROOT@(SDRRD,SDRRD0)) Q:SDRRD0'>0!SDRRDQUIT  D
        ... I SDRRDFLD]"" S SDRRD(0)=$P($G(@(SDRRDDIC_+SDRRD0_",0)")),U)
        ... E  S SDRRD(0)=SDRRD
        ... I $$CHFLD(SDRRDFNUM)["D" S SDRRD(0)=$$FMTE^XLFDT(SDRRD(0),"5Z")
        ... I SDRRDDIC(0)["N" W !?3,SDRRD0,?15,SDRRD(0)
        ... E  W !?3,SDRRD(0)
        ... D SETDIC(.SDRRDDIC,.DIC,.DO)
        ... I $D(DIC("W"))#2,DIC("W")]"",$D(@(SDRRDDIC_"SDRRD0,0)"))#2 D
        .... S (D0,DA,Y)=SDRRD0
        .... X DIC("W")
        .... Q
        ... I $Y>(IOSL+SDRRDLINE-3) S SDRRDQUIT=$$PAUSE,SDRRDLINE=$Y
        ... Q
        .. Q
        . Q
        Q
        ;
WRAP(X,LINE)    ;
        N I,Y
        K LINE
        S I=0
        F  S Y=$L($E(X,1,IOM-20)," ") D  Q:X=""
        . S I=I+1
        . S LINE(I)=$P(X," ",1,Y)
        . S X=$P(X," ",Y+1,$L(X," "))
        . Q
        Q
        ;
PAUSE() ;
        N DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
        S DIR(0)="E"
        D ^DIR
        Q $S(''$G(Y):0,1:1)
        ;
CHFLD(X)        ;
        N A
        S A=$$GET1^DID(X,.01,"","SPECIFIER")
        I A["P" D
        . F  D  Q:A'["P"
        .. S A=$TR(A,$TR(A,".0123456789"))
        .. S A=$$CHFLD(A)
        .. Q
        . Q
        Q A
        ;
SEL(SDRRD0,SDRRDFNUM,SDRRDDSEL,SDRRDFLD)        ;
        N %DT,SDRRDPNTR,SDRRDXTRN,DA,DIC,DIQ,DR,X,Y
        S SDRRDFLD=$S($G(SDRRDFLD)]"":SDRRDFLD,1:.01)
        S (SDRRDPNTR,DA)=SDRRD0
        S DIC=SDRRDFNUM,DIQ(0)="E",DIQ="SDRRDXTRN(",DR=SDRRDFLD
        D EN^DIQ1
        S SDRRDXTRN=$G(SDRRDXTRN(SDRRDFNUM,SDRRDPNTR,SDRRDFLD,"E"))
        I $$CHFLD(SDRRDFNUM)["D" S X=SDRRDXTRN,%DT="ST" D ^%DT S SDRRDXTRN=Y
        S X=$D(@SDRRDROOT@(SDRRDXTRN,SDRRDPNTR))
        Q $S(X#2&SDRRDDSEL:1,X[0&'SDRRDDSEL:1,1:0)
        ;
FLD(SDRRDFNUM,SDRRDFLD) ; Validate if field can be sorted on i.e, if 
        ; non-multiple and is either a pointer, free text, set of codes,
        ; numeric or a date/time field.
        ; SDRRDFNUM = File #
        ; SDRRDFLD  = Field #
        ; returns SDRRDPASS: 0 if valid, else 1
        N SDRRD,SDRRDPASS,I
        I SDRRDFLD=.01 Q 1 ; .01 field is not valid!
        I $$VFIELD^DILFD(SDRRDFNUM,SDRRDFLD)'>0 Q 1 ; field does not exist
        S SDRRD(2)=$$GET1^DID(SDRRDFNUM,SDRRDFLD,"","SPECIFIER")
        S SDRRD(4)=$$GET1^DID(SDRRDFNUM,SDRRDFLD,"","GLOBAL SUBSCRIPT LOCATION")
        I +SDRRD(2)>0&($$VFIELD^DILFD(+SDRRD(2),.01)>0) Q 1 ; mult field not valid
        I $P(SDRRD(4),";")'=0 Q 1 ; field not on the 0 node not valid
        S SDRRDPASS=1 ; set initially to not valid
        F I="D","F","N","P","S" S:SDRRD(2)[I SDRRDPASS=0 Q:'SDRRDPASS
        Q SDRRDPASS
        ;
FLDSRT(SDRRDFNUM,SDRRDFLD,SDRRDINTR)    ; Converts internal to external value
        ; for sets of codes & pointers.
        ; SDRRDFNUM = File #
        ; SDRRDFLD  = Field #
        ; SDRRDPIEC = piece position on 0 node
        N SDRRDPIEC
        S SDRRDPIEC=$$GET1^DID(SDRRDFNUM,SDRRDFLD,"","GLOBAL SUBSCRIPT LOCATION")
        S SDRRDPIEC=$P(SDRRDPIEC,";",2)
        Q $$EXTERNAL^DILFD(SDRRDFNUM,SDRRDFLD,"",$P(SDRRDINTR,U,SDRRDPIEC))
        ;
SETDIC(SDRRDDIC,DIC,DO) ;
        N I K DIC,DO
        S DIC=SDRRDDIC
        D DO^DIC1
        F I="0","A","B","S","W" I $G(SDRRDDIC(I))]"" S DIC(I)=SDRRDDIC(I)
        Q
        ;
FILEATTR(DIC,DIC0,SDRRDFNUM,SDRRDFNAM,SDRRDFL01,SDRRDFSCR)      ;
        N DO
        S DIC(0)=DIC0
        D DO^DIC1
        S SDRRDFNUM=+DO(2)
        S SDRRDFNAM=$P(DO,U)
        S SDRRDFL01=$$GET1^DID(SDRRDFNUM,.01,"","LABEL")
        S SDRRDFSCR=$G(DO("SCR"))
        Q
        ;
PLURAL(SDRRDFL01)       ;
        Q $S($E(SDRRDFL01,($L(SDRRDFL01)))?1L:"s",1:"S")
