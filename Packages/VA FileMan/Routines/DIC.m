DIC     ;SFISC/XAK,TKW,SEA/TOAD-VA FileMan: Lookup, Part 1 ;6/28/2009
        ;;22.0;VA FileMan;**4,17,20,78,164**;Mar 30, 1999;Build 20
        ;Per VHA Directive 2004-038, this routine should not be modified.
        N %,D,DF,DIFILEI,DIENS,DINDEX,DS,DIASKOK K DO S U="^",DIC(0)=$G(DIC(0))
        D GETFILE^DIC0(.DIC,.DIFILEI,.DIENS) I DIFILEI="" S Y=-1 Q
        S %=$P("K^",U,DIC(0)["K"),(D,DINDEX,DINDEX("START"))=$$DINDEX^DICL(DIFILEI,%)
        K %
EN      I $G(DIFILEI)=""!('$D(DINDEX)#2) N DIFILEI,DIENS,DINDEX,DIASKOK,%
        K DO,DICR,DIROUT,DTOUT,DUOUT S U="^"
        D INIT^DIC0 I DIFILEI="" S Y=-1 D Q^DIC2 Q
        S DIC(0)=$G(DIC(0)) D
        . I DIC(0)["T" K ^TMP($J,"DICSEEN") S ^TMP($J,"DICSEEN",DIFILEI)=""
        . I $D(ZTQUEUED),$E($G(IOST),1,2)'="C-" S DIC(0)=$TR(DIC(0),"AEQ")
        . I DIC(0)["X",DIC(0)["O" S DIC(0)=$TR(DIC(0),"O")
        . S:DINDEX("#")>1 DIC(0)=$TR(DIC(0),"M") Q
        N DIPGM S DIPGM=$$PGM^DIC2(.DIC,$G(DF),DIFILEI)
        I DIPGM]"" D KILL1^DIC0 K DIC("W") S DIPGM(0)=1 G @DIPGM
ASK     I $G(DIFILEI)=""!('$D(DINDEX)#2) N DIFILEI,DIENS,DINDEX,DIASKOK,% D INIT^DIC0 I DIFILEI="" S Y=-1 D Q^DIC2 Q
        I '$D(DIVAL) N DIVAL,DIALLVAL
        K DIVAL,DIALLVAL S DIVAL(0)=0,Y=-1,DIALLVAL=1
        I DIC(0)["A" K X W ! D ^DIC1 I $G(DTOUT) D Q^DIC2 Q
        I DIC(0)'["A" D CHKVAL^DIC0,CHKVAL2^DIC0(DINDEX("#"),.DIVAL,DIC(0),.DDS)
A1      I DIVAL(0) D
        . D CHKVAL1^DIC0(DINDEX("#"),.DIVAL,DIC(0),DIC(0),.DIALLVAL) Q:'DIVAL(0)
        . I $D(DIADD),X]"",X'["""" S (X,DIVAL(1))=""""_X_"""" S:DINDEX("#")>1 X(1)=X
        . N DUOUT K DINDEX S (DINDEX,DINDEX("START"))=D,DINDEX("WAY")=1
        . D INDEX^DICUIX(.DIFILEI,"4l",.DINDEX,"",.DIVAL) Q
X       ;
        I $G(DIFILEI)=""!('$D(DINDEX)#2) K DUOUT,DTOUT N DIFILEI,DIENS,DINDEX,DIASKOK,% N:'$D(DIVAL(0)) DIVAL,DIALLVAL D  I DIFILEI="" S Y=-1 D Q^DIC2 Q
        . D INIT^DIC0 Q:$D(DIVAL(0))!(DIFILEI="")
        . D SETVAL^DIC0 Q
        I DIVAL(0),$D(^DD(DIFILEI,.01,7.5)) X ^(7.5) D NODE75^DIC5 I $G(X)="" G:DIC(0)["A" ASK D Q^DIC2 Q
        N DIPGM S DIPGM=$S(DIVAL(0)'>1:$$PGM^DIC2(.DIC,$G(DF),DIFILEI),1:"")
        I DIPGM]"" D KILL2^DIC0 S DIPGM(0)=2 G @DIPGM
RTN     I $G(DIFILEI)=""!('$D(DINDEX)#2) N DIFILEI,DIENS,DINDEX,DIASKOK,% N:'$D(DIVAL(0)) DIVAL,DIALLVAL D  I DIFILEI="" S Y=-1 D Q^DIC2 Q
        . D INIT^DIC0 Q:$D(DIVAL(0))!(DIFILEI="")
        . D SETVAL^DIC0 Q
        I X?1."?" D  Q:$G(DTOUT)  G:DIC(0)["A" ASK Q
        . D DSPHLP^DICQ(.DIC,.DIFILEI,.DINDEX,X)
        . S Y=-1 Q
        I DIVAL(0)=0!($G(DUOUT)) S Y=-1 D Q^DIC2 Q
        D:'$D(DO) GETFA^DIC1(.DIC,.DO)
        I X?1"`".NP S Y=-1 D BYIEN1^DIC5 Q:Y>0  I '$$TRYADD^DIC11(.DIC,DIFILEI) D DING G:DIC(0)["A" ASK D Q^DIC2 Q
        I DIVAL(0)=1,+$P(X,"E")=X,X>0 S Y=-1 N DISKIPIX D BYIEN2^DIC5 Q:Y>0
        I X=" ",$L(DIC)<29,$D(^DISV(DUZ,DIC))#2 S Y=+^(DIC) D SPACEBAR^DIC5 Q:Y>0  D DING G:DIC(0)["A" ASK D Q^DIC2 Q
F       ; Start regular lookup
        N DD,DS,DIX,DIY,DIYX,DIDONE,DISAVDS,%Y,%H,DISYS
        I $G(DIFILEI)=""!('$D(DINDEX)#2) N DIFILEI,DIENS,DINDEX,DIASKOK,% N:'$D(DIVAL(0)) DIVAL,DIALLVAL D
        . D INIT^DIC0 Q:$D(DIVAL(0))
        . D SETVAL^DIC0 Q
F1      S (DD,DS,DS(0),DS("DD"))=0
        D SEARCH^DIC3
        I $G(DTOUT)!(Y'<0) D Q^DIC2 Q
        I $P(DS(0),U,2)="?",(DIC(0)_$G(DICR(1,0)))'["A" D K G F1
        I +DS(0)=2 S X=$P(DS(0),U,2) D K D  G A1
        . K DIVAL,DIALLVAL S DIVAL(0)=0,Y=-1,DIALLVAL=1
        . D CHKVAL^DIC0,CHKVAL2^DIC0(DINDEX("#"),.DIVAL,DIC(0),.DDS)
        . Q
        D  D K I Y<0,DIC(0)["A" D D^DIC0 W:DIC(0)["E" ! K:$D(DIROUT) DIROUT G ASK
        . Q:$G(DIROUT)
        . I DS(0),$P(DS(0),U,2)="" S:DIC(0)["Y"&($O(Y(0))) Y=0 D DING Q
        . Q:'($D(DS)#2)
        . I (DS(0)=0!($P(DS(0),U,2)="U")),DS("DD")=DS,(DO(2)["O"!($G(DIASKOK))!(DIC(0)["T")),DO(2)'["A",DO(2)'["P",DO(2)'["V",DO(2)'["D",DO(2)'["S",DIC(0)["L" D L^DICM
        . Q
        D Q^DIC2 Q
        ;
K       K DD,DS,DIX,DIY,DIYX,DIDONE,DISAVDS
        I '$G(DICR),DIC(0)["T" K ^TMP($J,"DICSEEN") S ^TMP($J,"DICSEEN",DIFILEI)=""
        Q
        ;
DING    Q:DIC(0)'["Q"!(DIC(0)'["E")
        W:'$D(DUOUT) $C(7)_$S('$D(DDS):" ??",1:"") Q
        ;
        ;
IX      N DINDEX,DF
        S (DF,DINDEX,DINDEX("START"))=D
        G EN
        ;
A       K DIY,DIYX,DS I DIC(0)["A" D D^DIC0 Q
NO      S Y=-1 D Q^DIC2 Q
        ;
        ; DBS Entry points
LIST(DIFILE,DIFIEN,DIFIELDS,DIFLAGS,DINUMBER,DIFROM,DIPART,DINDEX,DISCREEN,DIWRITE,DILIST,DIMSGA)       ;
        ;ENTRY POINT--return a list of entries from a file  (SEA/TOAD)
        G IN^DICL
        ;
FIND1(DIFILE,DIFIEN,DIFLAGS,DIVALUE,DIFORCE,DISCREEN,DIMSGA)    ;SEA/TOAD
        ;ENTRY POINT--find a single entry in the file
        I '$D(DIQUIET) N DIQUIET S DIQUIET=1
        I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
        N DICLERR S DICLERR=$G(DIERR) K DIERR
        N DIERN,DIFIND,DIPE,DITARGET
        N DIVALS M DIVALS=DIVALUE I $G(DIVALS)="" S DIVALS=$G(DIVALUE(1))
        D FIND^DICF($G(DIFILE),$G(DIFIEN),"",$G(DIFLAGS)_"f",.DIVALUE,1,$G(DIFORCE),.DISCREEN,"","DITARGET")
        I $D(DIERR) S DIFIND=""
        E  I $P($G(DITARGET(0)),U,3) K DITARGET S DIFIND="" D
        . I $O(DIVALS(1)) N I F I=1:0 S I=$O(DIVALS(I)) Q:'I  D:DIVALS(I)]""  Q:'I
        . . I ($L(DIVALS)+$L(DIVALS(I)))>100 S DIVALS=DIVALS_"...",I="" Q
        . . S DIVALS=DIVALS_$P(", ^",U,DIVALS]"")_DIVALS(I) Q
        . D ERR^DICF4(299,$G(DIFILE),$G(DIFIEN),"",DIVALS)
        . Q
        E  S DIFIND=+$G(DITARGET(1))
        I DICLERR'=""!$G(DIERR) D
        . S DIERR=$G(DIERR)+DICLERR_U_($P($G(DIERR),U,2)+$P(DICLERR,U,2))
        I $G(DIMSGA)'="" D CALLOUT^DIEFU(DIMSGA)
        Q DIFIND
        ;
FIND(DIFILE,DIFIEN,DIFIELDS,DIFLAGS,DIVALUE,DINUMBER,DIFORCE,DISCREEN,DIWRITE,DILIST,DIMSGA)    ;SEA/TOAD
        ;ENTRY POINT--in a file find entries that match a value
        G FINDX^DICF
        ;
        ; Error messages:
        ; 299  More than one entry matches the value(s) '|1|'
        ; 120  The previous error occurred when performing
        ; 8090 Pre-lookup transform (7.5 node)
        ;
