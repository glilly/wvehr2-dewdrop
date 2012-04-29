RMPRPIY6        ;HINES OIFO/ODJ - EI - Edit Locations and Items ;10/7/02  14:46
        ;;3.0;PROSTHETICS;**61,145**;Feb 09, 1996;Build 6
        Q
        ;
        ;***** EI - Edit Inventory ITEM
        ;           option RMPR INV EDIT
        ;           Replaces EI option in old PIP (cf ^RMPR5NEE)
        ;           no inputs required
        ;           other than standard VISTA vars. (DUZ, etc)
        ;
EI      N RMPRERR,RMPRSTN,RMPREXC,RMPR5,RMPR1,RMPR11,RMPRVEND,RMPRTVAL,RMPR9M
        N RMPRQTY,RMPRREO,RMPR4,RMPR6,RMPR7,RMPR7M,RMPR6M,RMPR4M,RMPRGLAM
        N RMPR69,RMPR6I,RMPRGLQ,RMPRLCN,RMPRUCST,RMPROVAL,RMPRHCPC,RMPR5P
        N RMPR11M,RMPR11I,RMPR441,RMPRUNI
        ;
        ;***** STN - call prompt for Site/Station
STN     S RMPROVAL=$G(RMPRSTN("IEN"))
        W @IOF S RMPRERR=$$STN^RMPRPIY1(.RMPRSTN,.RMPREXC)
        I RMPRERR G EIX
        I RMPREXC'="" G EIX
        I RMPROVAL'=RMPRSTN("IEN") K RMPR1,RMPR11,RMPR5,RMPRLCN
        ;
        ;***** HCPCS - call prompts for selecting HCPCS and Item
HCPCS   W !!,"Editing Inventory Items.",!
        S RMPROVAL=$G(RMPR1("IEN"))
        K RMPR1,RMPR11,RMPR5,RMPRLCN,RMPREXC,RMPRERR,RMPRUNI
        D HCPCS^RMPRPIY7(RMPRSTN("IEN"),$G(RMPR1("HCPCS")),.RMPR1,.RMPR11,.RMPREXC)
        I RMPREXC="T" G EIX
        I RMPREXC="P" G STN
        I RMPREXC="^" D  G EIX
        . W !,"** No HCPCS selected." H 1
        . Q
        I $G(RMPR11("IEN"))'="" G HCPCS4
HCPCS3  D ITEM^RMPRPIYP(RMPRSTN("IEN"),$G(RMPR1("HCPCS")),.RMPR11,.RMPREXC)
        I RMPREXC="T" G EIX
        I RMPREXC="P" G HCPCS
        I RMPREXC="^" G HCPCS
        ;
        ; display selected HCPCS and item and continue
HCPCS4  W !!,"HCPCS: "_RMPR1("HCPCS")_" "_RMPR1("SHORT DESC")
        K RMPR11I S RMPRERR=$$ETOI^RMPRPIX1(.RMPR11,.RMPR11I)
HCPCS4A K RMPR441,RMHCC
        S RMPR441("IEN")=RMPR11I("ITEM MASTER IEN")
        S:RMPR11I("ITEM MASTER IEN")'="" RMPRERR=$$GET^RMPRPIXD(.RMPR441)
        D MASIT^RMPRPIY1(.RMPR441,.RMPREXC)
        I RMPREXC="T" G EIX
        I RMPREXC="P" G HCPCS
        I RMPREXC="^" G HCPCS
        I RMPR441("IEN")'=RMPR11I("ITEM MASTER IEN") D
        . K RMPR11M
        . S RMPR11M("IEN")=RMPR11("IEN")
        . S RMPR11M("ITEM MASTER IEN")=RMPR441("IEN")
        . S RMPRERR=$$UPD^RMPRPIX1(.RMPR11M)
        . K RMPR11
        . S RMPR11("IEN")=RMPR11M("IEN")
        . S RMPRERR=$$GET^RMPRPIX1(.RMPR11)
        . S RMPR11I("ITEM MASTER IEN")=RMPR441("IEN")
        . K RMPR441,RMPR11M
        . Q
        ;
        ; edit PIP Item desc.
HCPCS5  D ITED^RMPRPIY1(.RMPR11,.RMPREXC)
        I RMPREXC="T" G EIX
        I RMPREXC="^" G HCPCS
        I RMPREXC="P" G HCPCS4A
        ;
        ; Lock the current stock 661.7 file at HCPCS Item level as we may be
        ; reducing or increasing the quantity on hand
CURSTL  L +^RMPR(661.7,"XSHIDS",RMPRSTN("IEN"),RMPR11("HCPCS"),RMPR11("ITEM")):5 E  W !,"PROSTHETIC CURRENT STOCK record for HCPCS item open by someone else" G LOCN
        ;
        ;***** CURST - call prompt for current stock record
CURST   S RMPRLCN="" K RMPR5
        D PVEN^RMPRPIYR(RMPRSTN("IEN"),.RMPRLCN,RMPR11("HCPCS"),RMPR11("ITEM"),.RMPR6,.RMPR7,.RMPREXC)
        I RMPREXC="T" G EIU
        I RMPREXC="P" D UNLOCK G HCPCS5
        I RMPREXC="^" K RMPR6,RMPR7 G RLOC
        I $G(RMPR7("IEN"))="" G RLOC
        S RMPRQTY=RMPR7("QUANTITY")
        S RMPRTVAL=RMPR7("VALUE")
        I RMPR7("QUANTITY")<1 S RMPRUCST=0
        E  S RMPRUCST=+$J(RMPR7("VALUE")/RMPR7("QUANTITY"),0,6)
        S:$D(RMPR7("UNIT")) RMPRUNI("IEN")=RMPR7("UNIT")
        S:$D(RMPR7("UNIT NAME")) RMPRUNI("NAME")=RMPR7("UNIT NAME")
        S RMPRERR=$$VNDIEN^RMPRPIX6(.RMPR6)
        S RMPRVEND("IEN")=RMPR6("VENDOR IEN")
        S RMPRVEND("NAME")=RMPR6("VENDOR")
        S RMPR5("IEN")=RMPRLCN
        S RMPRERR=$$GET^RMPRPIX5(.RMPR5)
        G LOCN
        ;
        ;***** RLOC - if no receipt selected get def. loc. from reorder file
RLOC    D LOCN^RMPRPIYQ(RMPRSTN("IEN"),.RMPR11,.RMPR5,.RMPREXC)
        I RMPREXC="T" G EIU
        G LOCN
        ;
        ;***** LOCN - call prompt for Location
LOCN    K RMPR5P M RMPR5P=RMPR5
        S RMPRLCN=$$LOC1^RMPRPIYB(RMPRSTN("IEN"))
        I RMPRLCN D  G REO
        . I $G(RMPR5("IEN"))="" D
        .. S RMPR5("IEN")=RMPRLCN
        .. S RMPRERR=$$GET^RMPRPIX5(.RMPR5)
        .. Q
        . W !,"Location: "_RMPR5("NAME")
        . Q
LOCN1   W ! D LOCNM^RMPRPIY7(RMPRSTN("IEN"),.RMPR5,.RMPREXC)
        I RMPREXC="P" D UNLOCK G HCPCS5
        I RMPREXC="^" G EIU
        I RMPREXC="T" G EIU
        S RMPRLCN=RMPR5("IEN")
        ;
        ;***** REO - call prompt for Re-Order Quantity (661.4)
REO     K RMPR4
        S RMPR4("IEN")=$O(^RMPR(661.4,"ASLHI",RMPRSTN("IEN"),RMPRLCN,RMPR11("HCPCS"),RMPR11("ITEM"),""))
        I RMPR4("IEN")="" D
        . S RMPR4("IEN")=$O(^RMPR(661.4,"ASLHI",RMPRSTN("IEN"),RMPR5("IEN"),RMPR11("HCPCS"),RMPR11("ITEM"),""))
        . Q
        I RMPR4("IEN")="" D
        . S RMPR4("RE-ORDER QTY")=0
        . Q
        E  D
        . S RMPRERR=$$GET^RMPRPIX4(.RMPR4)
        . Q
        S RMPRREO=RMPR4("RE-ORDER QTY")
REO1    ;
        I '$D(RMPR5P) K RMPR5P M RMPR5P=RMPR5
        D REO^RMPRPIY5(.RMPRREO,.RMPREXC)
        I RMPREXC="P" D UNLOCK G HCPCS5
        I RMPREXC="^" G EIU
        I RMPREXC="T" G EIU
        I RMPRREO'=RMPR4("RE-ORDER QTY")!(RMPR4("IEN")="")!(RMPR5("IEN")'=RMPR5P("IEN")) D
        . K RMPR4M
        . S RMPR4M("RE-ORDER QTY")=RMPRREO
        . I RMPR4("IEN")="" D
        .. S RMPRERR=$$CRE^RMPRPIX4(.RMPR4M,.RMPR11,.RMPR5)
        .. Q
        . E  D
        .. S RMPR4M("IEN")=RMPR4("IEN")
        .. S RMPRERR=$$UPD^RMPRPIX4(.RMPR4M,,)
        .. Q
        . Q
        I '$D(RMPR6) G TRANSX ;only editing reorder level
        ;
        ;***** SRC - call prompt for SOURCE.
SRC     S (RMPRBCK,RMPRSRC)=$P(^RMPR(661.11,RMPR11("IEN"),0),U,5)
        D SRC^RMPRPIY5(.RMPRSRC,.RMPREXC)
        I RMPREXC="P" G SRC
        I RMPREXC="^" D UNLOCK G HCPCS
        I RMPREXC="T" G EIU
        I RMPRSRC'=RMPRBCK S $P(^RMPR(661.11,RMPR11("IEN"),0),U,5)=RMPRSRC
        ;***** QTY - call prompt for Quantity
QTY     D QTY^RMPRPIY5(.RMPRQTY,.RMPREXC)
        I RMPREXC="P" G REO
        I RMPREXC="^" D UNLOCK G HCPCS
        I RMPREXC="T" G EIU
        S RMPRQTY=+$G(RMPRQTY)
        ;
        ;***** UCST - call prompt for Unit Cost
UCST    D UCST^RMPRPIY5(.RMPRUCST,.RMPREXC)
        I RMPREXC="P" G QTY
        I RMPREXC="^" D UNLOCK G HCPCS
        I RMPREXC="T" G EIU
        S RMPRUCST=$J(RMPRUCST,0,2)
        ;
        ;***** TVAL - Total Value - use if Unit Cost not used
TVAL    I RMPRUCST D  G VEND
        . S RMPRTVAL=$J(RMPRQTY*RMPRUCST,0,2)
        . W !,"TOTAL COST OF QUANTITY: "_RMPRTVAL
        . Q
        D TVAL^RMPRPIY5(.RMPRTVAL,.RMPREXC)
        I RMPREXC="P" G UCST
        I RMPREXC="^" D UNLOCK G HCPCS
        I RMPREXC="T" G EIU
        ;
        ;***** VEND - call prompt for Vendor
        ;VENDOR edit removed 3/1/08 per Karen Blum
VEND    ;D VEND^RMPRPIY5(.RMPRVEND,.RMPREXC)
        ;I RMPREXC="P" G UCST
        ;I RMPREXC="^" D UNLOCK G HCPCS
        ;I RMPREXC="T" G EIU
        ;
        ;
        ;***** UNIT - call prompt for UNIT OF ISSUE
UNIT    D UNIT^RMPRPIY5(.RMPRUNI,.RMPREXC)
        I RMPREXC="P" G UCST
        I RMPREXC="^" D UNLOCK G HCPCS
        I RMPREXC="T" G EIU
        S RMPRUNI("UNIT")=RMPRUNI("IEN")
        ;
        ;***** TRANS - Modify current stock record
TRANS   K RMPR7M,RMPR6M
        ;
        I $G(RMHCC) D TRANS^RMPRPIXF G HAL
        ;
        K RMPR6I
        S RMPRERR=$$ETOI^RMPRPIX6(.RMPR6,.RMPR6I)
        ;
        ;if unit of issue changed
        I RMPRUNI("UNIT")'=RMPR7("UNIT") S RMPR7M("UNIT")=RMPRUNI("UNIT") D
        . S RMPR7M("IEN")=RMPR7("IEN")
        . S RMPRERR=$$UPD^RMPRPIX7(.RMPR7M,)
        ; Modify Location in 661.6 and 661.7 if changed
        I RMPR6I("LOCATION")'=RMPR5("IEN") D
        . S RMPR6M("LOCATION")=RMPR5("IEN")
        . S RMPR6M("IEN")=RMPR6("IEN")
        . S RMPRERR=$$UPD^RMPRPIX6(.RMPR6M,)
        . S RMPR7M("LOCATION")=RMPR5("IEN")
        . S RMPR7M("IEN")=RMPR7("IEN")
        . S RMPRERR=$$UPD^RMPRPIX7(.RMPR7M,)
        . K RMPR6M,RMPR7M
        . Q
        ;
        ; Modify Quantity or Value in current stock 661.7 record, the
        ; transaction record 661.6 and running balance 661.9, if changed
        I +RMPRQTY'=+RMPR7("QUANTITY")!(+RMPRTVAL'=+RMPR7("VALUE")) D
        . K RMPR69,RMPR9M
        . I RMPR6I("TRAN TYPE")=9 D
        .. S RMPR69("TRANS IEN")=RMPR6("IEN")
        .. S RMPRERR=$$GET^RMPRPIXB(.RMPR69)
        .. Q
        . S (RMPR9M("TQTY"),RMPR9M("TCST"),RMPRGLQ,RMPRGLAM)=0
        . I +RMPRQTY'=+RMPR7("QUANTITY") D  Q:RMPR7M("QUANTITY")<0
        .. S RMPR6M("QUANTITY")=RMPRQTY
        .. S RMPRGLQ=RMPRQTY-RMPR7("QUANTITY")
        ..; S RMPR7M("QUANTITY")=RMPR7("QUANTITY")+RMPRGLQ
        .. S RMPR7M("QUANTITY")=RMPRQTY
        .. S RMPR9M("TQTY")=RMPRGLQ
        .. S:$D(RMPR69) RMPR69("GAIN/LOSS")=RMPR69("GAIN/LOSS")+RMPRGLQ
        .. Q
        . I +RMPRTVAL'=+RMPR7("VALUE") D
        .. S RMPR6M("VALUE")=RMPRTVAL
        .. S RMPRGLAM=RMPRTVAL-RMPR7("VALUE")
        .. S RMPR7M("VALUE")=RMPR7("VALUE")+RMPRGLAM,RMPR7M("VALUE")=$J(RMPR7M("VALUE"),0,2)
        .. S RMPR9M("TCST")=RMPRGLAM
        .. S:$D(RMPR69) RMPR69("GAIN/LOSS VALUE")=RMPR69("GAIN/LOSS VALUE")+RMPRGLAM
        .. Q
        . S RMPR7M("IEN")=RMPR7("IEN")
        . S RMPRERR=$$UPD^RMPRPIX7(.RMPR7M,)
        . S RMPR6M("IEN")=RMPR6("IEN")
        . S RMPRERR=$$UPD^RMPRPIX6(.RMPR6M,)
        . I $D(RMPR69) S RMPRERR=$$UPD^RMPRPIXB(.RMPR69)
        . S RMPR9M("STA")=RMPRSTN("IEN")
        . S RMPR9M("HCP")=RMPR11("HCPCS")
        . S RMPR9M("ITE")=RMPR11("ITEM")
        . S RMPRERR=$$DTIEN^RMPRPIX6(.RMPR6)
        . S RMPR9M("RDT")=$P(RMPR6("DATE&TIME"),".",1)
        . S RMPRERR=$$UPCR^RMPRPIXJ(.RMPR9M)
        . K RMPR7M,RMPR6M,RMPR9M
        . Q
        I $D(RMPR7M("QUANTITY")),RMPR7M("QUANTITY")<1 D  G QTY
        . W !,"The quantity cannot be allowed because it would cause a",!
        . W "negative on hand quantity.",!
        . W "Please check your inventory and use the reconciliation option",!
        . W "as needed.",!
        . Q
TRANSX  I 'RMPRERR D
        . W !!,"** Item "
        . W RMPR11("HCPCS-ITEM")
        . W " was "
        . W "Edited by "
        . W $$GETUSR^RMPRPIU0(DUZ)
        . W:$D(RMPRGLQ) ": ("_$S(RMPRGLQ>0:"+",1:"")_RMPRGLQ_")"
        . W " @ Location ",RMPR5("NAME")
        . Q
        E  D
        . W !!,"** The Item could not be modified due to a problem - please contact support"
        . Q
        D UNLOCK
HAL     H 2
        K RMPRTVAL,RMPRUCST,RMPR6,RMPR7,RMPRVEND,RMPRQTY,RMPRREO,RMPRGLQ,RMPRGLAM
        G HCPCS
        ;
        ;***** exit points
EIU     D UNLOCK
EIX     D KILL^XUSCLEAN
        Q
UNLOCK  L -^RMPR(661.7,"XSHIDS",RMPRSTN("IEN"),RMPR11("HCPCS"),RMPR11("ITEM"))
        Q
