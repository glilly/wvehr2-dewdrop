RMPRPIY7        ;HINCIO/ODJ - PIP EDIT - PROMPTS ;9/18/02  15:17
        ;;3.0;PROSTHETICS;**61,118,139**;Feb 09, 1996;Build 4
        ;
        ;DBIA # 800 - FILEMAN read of file #440.
        Q
        ; The following subroutines are a series of prompts called
        ; by Edit LOCATION/HCPCS/ITEM option (EI^RMPRPIY6)
        ;
        ;***** LOCNM - Prompt for location
        ;              must be in 661.5 and active
LOCNM(RMPRSTN,RMPR5,RMPREXC)    ;
        N RMPRERR,DIR,X,Y,DA,DUOUT,DTOUT,DIROUT,RMPRYN,RMPRTDT
        D NOW^%DTC S RMPRTDT=X ;today's date
        S RMPREXC=""
        S RMPRERR=0
        S DIR(0)="FOA"
        S DIR("A")="Enter Pros Location: "
        I $G(RMPR5("NAME"))'="" S DIR("B")=RMPR5("NAME")
        S DIR("?")="^D QM^RMPRPIYB"
        S DIR("??")="^D QM2^RMPRPIYB"
        S RMPR5("IEN")=""
LOCNM1  D ^DIR
        ;Patch *139 removes upper case translation to allow access to lower
        ;case entries used in location creation option
        ;S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        I $G(RMPR5("IEN"))'="" S RMPREXC="" G LOCNMX
        I $D(DTOUT) S RMPREXC="T" G LOCNMX
        I $D(DIROUT) S RMPREXC="P" G LOCNMX
        I X=""!(X["^") S RMPREXC="^" G LOCNMX
        K RMPR5
        S RMPR5("STATION")=RMPRSTN
        S RMPR5("STATION IEN")=RMPRSTN
        D LIKE^RMPRPIYB(RMPRSTN,X,.RMPREXC,.RMPR5)
        I RMPREXC'="" G LOCNM1
        I $G(RMPR5("IEN"))="" D  G LOCNM1
        . W !,"Please enter a valid Location"
        . Q
        ;
        ; exit
LOCNMX  Q
        ;
        ;***** OK - Prompt for an OK
OK(RMPRYN,RMPREXC)      ;
        N DIR,X,Y,DA,DUOUT,DTOUT,DIROUT,DIRUT
        S RMPREXC=""
        S RMPRYN="N"
        S DIR("A")="         ...OK"
        S DIR("B")="Yes"
        S DIR(0)="Y"
        D ^DIR
        I $D(DTOUT) S RMPREXC="T" G OKX
        I $D(DIROUT) S RMPREXC="P" G OKX
        I X=""!(X["^") S RMPREXC="^" G OKX
        S RMPRYN="N" S:Y RMPRYN="Y"
OKX     Q
        ;
        ;***** HCPCS - Prompt for HCPCS
HCPCS(RMPRSTN,RMPRHPTX,RMPR1,RMPR11,RMPREXC)    ;
        N RMPRERR,DIR,X,Y,DUOUT,DTOUT,DIROUT,DIRUT,DIC,DA,RMPR1N,RMSTN
        N RM6610
        S DIR("A")="Select HCPCS: ",RMSTN=RMPRSTN
        S DIR("S")="I $P(^RMPR(661.11,+Y,0),U,4)=RMSTN"
        S RMPRERR=0
        S RMPREXC=""
        S RMPRHPTX=$G(RMPRHPTX)
        I RMPRHPTX'="" S DIR("B")=RMPRHPTX
        S DIR(0)="FOA"
        S DIR("?")="^D QM2^RMPRPIYC"
        S DIR("??")="^D QM2^RMPRPIYC"
        S DIR("???")="^D QM2^RMPRPIYC"
HCPCS1  K RMPR1N D ^DIR
        I $G(RMPR1N("IEN"))'="" S RMPRHPTX=RMPR1N("HCPCS") G CHECK
        I $D(DTOUT) S RMPREXC="T" G HCPCSX
        I $D(DIROUT) S RMPREXC="P" G HCPCSX
        I X=""!(X["^")!($D(DUOUT)) S RMPREXC="^" G HCPCSX
        D LIKE^RMPRPIYC(RMPRSTN,X,.RMPREXC,.RMPR1N,.RMPR11)
        I RMPREXC'="" G HCPCS1
        I $G(RMPR1N("IEN"))'="",$G(RMPR1("REMOVE")) G HCPCSU
CHECK   I $G(RMPR1N("IEN")),$D(^RMPR(661.1,$G(RMPR1N("IEN")),0)),'($P(^RMPR(661.1,RMPR1N("IEN"),0),U,5)) W !,"** No HCPCS Selected or Unable to Select Inactive HCPCS..." G HCPCS1
        I $G(RMPR1N("IEN"))'="" G HCPCSU
        G HCPCS1
HCPCSU  K RMPR1 M RMPR1=RMPR1N
HCPCSX  Q
        ;
        ;***** ITEM - Prompt for Item - restrict choice to Location and HCPC
ITEM(RMPRSTN,RMPRLCN,RMPRHCPC,RMPR11,RMPR4,RMPREXC)     ;
        N RMPRERR,DIR,X,Y,DUOUT,DTOUT,DIROUT,DA,RMPRSRC,RMPRYN
        S RMPRERR=0
        S RMPREXC=""
        I $G(RMPRSTN)="" S RMPRERR=1 G ITEMX
        I $G(RMPRLCN)="" S RMPRERR=2 G ITEMX
        I $G(RMPRHCPC)="" S RMPRERR=3 G ITEMX
        K RMPR11,RMPR4
        S DIR(0)="FOA^1:50"
        S DIR("A")="Enter PSAS Item to Edit: "
        S DIR("?")="^D QM^RMPRPIY8"
        S DIR("??")="^D QQM^RMPRPIY8"
ITEMA1  D ^DIR
        I $D(DTOUT) S RMPREXC="T" G ITEMX
        I $D(DIROUT) S RMPREXC="P" G ITEMX
        I X=""!(X["^")!$D(DUOUT) S RMPREXC="^" G ITEMX
        D LIKE^RMPRPIY8(RMPRSTN,RMPRLCN,RMPRHCPC,X,.RMPREXC,.RMPR11,.RMPR4)
        I RMPREXC="T" G ITEMX
        I RMPREXC="P" G ITEMX
        I RMPREXC="^" G ITEMA1
        I RMPR4("IEN")="" D  G ITEMA1
        . W !,"Cannot locate ITEM with this sequence NUMBER"
        . Q
        W "  ",RMPR11("HCPCS-ITEM"),"  ",RMPR11("DESCRIPTION")
        D OK(.RMPRYN,.RMPREXC)
        I RMPRYN'="Y" G ITEMA1
        G ITEMX
ITEMX   Q RMPRERR
        ;
        ;***** QTY - Prompt for Quantity
QTY(RMPRQTY,RMPREXC)    ;
        N RMPRERR,DIR,X,Y,DUOUT,DTOUT,DIROUT,DIRUT,DA
        S RMPRQTY=$G(RMPRQTY)
        S RMPRERR=0
        S DIR(0)="NA^1:99999:0"
        S DIR("A")="QUANTITY: "
        S:RMPRQTY'="" DIR("B")=RMPRQTY
        D ^DIR
        I $D(DTOUT) S RMPREXC="T" G QTYX
        I $D(DIROUT) S RMPREXC="P" G QTYX
        I X=""!(X["^") S RMPREXC="^" G QTYX
        S RMPRQTY=Y
QTYX    Q RMPRERR
        ;
        ;***** TVAL - Prompt for total $ value
TVAL(RMPRTVAL,RMPREXC)  ;
        N RMPRERR,DIR,X,Y,DUOUT,DTOUT,DIROUT,DIRUT,DA
        S RMPRTVAL=$G(RMPRTVAL)
        S RMPRERR=0
        S DIR(0)="NOA^0:999999:2"
        S DIR("A")="TOTAL COST OF QUANTITY: "
        S:RMPRTVAL'="" DIR("B")=RMPRTVAL
        D ^DIR
        I $D(DTOUT) S RMPREXC="T" G TVALX
        I $D(DIROUT) S RMPREXC="P" G TVALX
        I X["^" S RMPREXC="^" G TVALX
        I X="" G TVALX
        S RMPRTVAL=Y
TVALX   Q RMPRERR
        ;
        ;***** REO - Prompt for Re-Order Level
REO(RMPRREO,RMPREXC)    ;
        N RMPRERR,DIR,X,Y,DUOUT,DTOUT,DIROUT,DIRUT,DA
        S RMPRREO=$G(RMPRREO)
        S RMPRERR=0
        S DIR(0)="NOA^0::0"
        S DIR("A")="RE-ORDER LEVEL: "
        S:RMPRREO'="" DIR("B")=RMPRREO
        D ^DIR
        I $D(DTOUT) S RMPREXC="T" G REOX
        I $D(DIROUT) S RMPREXC="P" G REOX
        I X=""!(X["^")!$D(DUOUT) S RMPREXC="^" G REOX
        S RMPRREO=Y
REOX    Q RMPRERR
        ;
        ;***** VEND - Prompt for Vendor
VEND(RMPRVEND,RMPREXC)  ;
        N RMPRERR,DIR,X,Y,DUOUT,DTOUT,DIROUT,DIRUT,DA
        S RMPRVEND=$G(RMPRVEND("IEN"))
        S RMPRERR=0
        S DIR(0)="P^440:EMZ"
        S DIR("A")="VENDOR"
        S:RMPRVEND'="" DIR("B")=RMPRVEND("NAME")
        D ^DIR
        I $D(DTOUT) S RMPREXC="T" G VENDX
        I $D(DIROUT) S RMPREXC="P" G VENDX
        I X=""!(X["^")!$D(DUOUT) S RMPREXC="^" G VENDX
        S RMPRVEND("IEN")=$P(Y,"^",1)
        S RMPRVEND("NAME")=$P(Y,"^",2)
VENDX   Q RMPRERR
        ;
        ;***** PVEN - Pick the current stock record to edit
PVEN(RMPRSTN,RMPRLCN,RMPRHCPC,RMPRITM,RMPR6,RMPR7,RMPREXC)      ;
        N DIR,X,Y,DA,RMPRGBL,RMPRLIN,RMPRA,RMPRERR,RMPRX,RMPRY,RMPRB
        N RMPR7I
        S RMPREXC=""
        S RMPRX="",RMPRY=0
        S RMPRLIN=0
        S RMPRGBL=$Q(^RMPR(661.7,"XSLHIDS",RMPRSTN,RMPRLCN,RMPRHCPC,RMPRITM))
        G PVEN1A
PVEN1   S RMPRGBL=$Q(@RMPRGBL)
PVEN1A  I $QS(RMPRGBL,1)'=661.7 G PVEN2
        I $QS(RMPRGBL,2)'="XSLHIDS" G PVEN2
        I $QS(RMPRGBL,3)'=RMPRSTN G PVEN2
        I $QS(RMPRGBL,4)'=RMPRLCN G PVEN2
        I $QS(RMPRGBL,5)'=RMPRHCPC G PVEN2
        I $QS(RMPRGBL,6)'=RMPRITM G PVEN2
        S RMPRLIN=RMPRLIN+1
        S RMPRA(RMPRLIN)=$QS(RMPRGBL,9)
        G PVEN1
PVEN2   I RMPRLIN=0 G PVENX
        I RMPRLIN=1 S X=1 G PVEN3
        W !,"Select a current Stock Record to edit...",!
        W !,?7,"Date",?21,"Quantity",?35,"Value",?42,"Vendor"
        S RMPRX="",RMPRLIN=0
        F  S RMPRX=$O(RMPRA(RMPRX)) Q:RMPRX=""  D
        . S RMPRLIN=RMPRLIN+1
        . K RMPR7
        . S RMPR7("IEN")=RMPRA(RMPRX)
        . S RMPRERR=$$GET^RMPRPIX7(.RMPR7)
        . W !,?2,$J(RMPRLIN,2)
        . W ?7,$P(RMPR7("DATE&TIME"),"@",1)
        . W ?21,$J(RMPR7("QUANTITY"),8,0)
        . W ?30,$J(RMPR7("VALUE"),10,2)
        . K RMPR7I
        . S RMPRERR=$$ETOI^RMPRPIX7(.RMPR7,.RMPR7I)
        . K RMPR6
        . S RMPR6("DATE&TIME")=RMPR7I("DATE&TIME")
        . S RMPR6("HCPCS")=RMPRHCPC
        . S RMPRERR=$$GET^RMPRPIX6(.RMPR6)
        . W ?42,RMPR6("VENDOR")
        . Q
        K RMPR7,RMPR6
        S DIR(0)="NAO^1:"_RMPRLIN_": "
        S DIR("A")="CHOOSE 1-"_RMPRLIN_": "
        D ^DIR
        I $D(DTOUT) S RMPREXC="T" G PVENX
        I $D(DIROUT) S RMPREXC="P" G PVENX
        I X=""!(X["^")!$D(DUOUT) S RMPREXC="^" G PVENX
PVEN3   S RMPR7("IEN")=RMPRA(X)
        S RMPRERR=$$GET^RMPRPIX7(.RMPR7)
        K RMPR7I
        S RMPRERR=$$ETOI^RMPRPIX7(.RMPR7,.RMPR7I)
        S RMPR6("DATE&TIME")=RMPR7I("DATE&TIME")
        S RMPR6("HCPCS")=RMPRHCPC
        S RMPRERR=$$GET^RMPRPIX6(.RMPR6)
PVENX   Q
