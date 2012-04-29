RMPRPIYF        ;PHX/RFM,RVD-EDIT ISSUE FROM STOCK ;8/2/02  07:27
        ;;3.0;PROSTHETICS;**61,117,139**;Feb 09, 1996;Build 4
        ; RVD #61 - phase III of PIP enhancement.
        ;
        ;Per VHA Directive 10-93-142, this routine should not be modified.
COST    ;
        S RMACNT=RMPRCOST*$P(R1(0),U,7),$P(R3("D"),U,16)=RMACNT,$P(R1(0),U,16)=RMACNT
        ;
DATE    S:$P(R1(1),U,8) DIR("B")=$P(R1("D"),U,8) S DIR("A")="DATE OF SERVICE",DIR(0)="660,39" D ^DIR K DIR
        G:X["^" CO^RMPRPIYE G:$D(DTOUT) EXIT I $P(R1(1),U,8)&(X="@") W !,"This field is mandatory!!!",! G DATE
        I X="" W !,"This field is mandatory!!!",! G DATE
        S $P(R1(1),U,8)=Y,Y=$P(R1(1),U,8) D DD^%DT S $P(R1("D"),U,8)=Y
        ;
REQ     S DIR(0)="660,9" S:$P(R1(0),U,11)'="" DIR("B")=$P(R1(0),U,11) D ^DIR G:$D(DUOUT) CO^RMPRPIYE G:$D(DTOUT) EXIT
        I X["^" W !,"Jumping not allowed!" G REQ
        I $P(R1(0),U,11)'=""&(X="@") W !?5,"Deleted..." H 1 S $P(R1(0),U,11)="" G LOT
        S $P(R1(0),U,11)=X
        ;
LOT     K DIR S DIR(0)="660,21" S:$P(R1(0),U,24)'="" DIR("B")=$P(R1(0),U,24) D ^DIR G:$D(DUOUT) CO^RMPRPIYE
        I X["^" W !,"Jumping not allowed!" G LOT
        I $P(R1(0),U,24)'=""&(X="@") W !?5,"Deleted..." H 1 S $P(R1(0),U,24)="" G REMA
        S $P(R1(0),U,24)=X
        ;
REMA    K DIR S DIR(0)="660,16" S:$P(R1(0),U,18)'="" DIR("B")=$P(R1(0),U,18) D ^DIR G:$D(DUOUT) CO^RMPRPIYE G:$D(DTOUT) EXIT
        I X["^" W !,"Jumping not allowed!" G REMA
        I $P(R1(0),U,18)'=""&(X="@") W !?5,"Deleted..." H 1 S $P(R1(0),U,18)="" G CC
        S $P(R1(0),U,18)=X
CC      G CO^RMPRPIYE
        ;
POST    ;POSTS EDITED TRANSACTION TO 660
        W !,"Posting...."
        K RMPR60,RMDTTIM,RMPR63
        S RMPR60("IEN")=RMPRIEN,RMFLG=0
        ;RMPR60 -array of data fields for 660 file record.
        D SET60^RMPRPIYE
        ;get 661.6 & 661.63 patient issue
        S (RMPR6("IEN"),RMIEN6)=$P(R1(1),U,5)
        I $G(RMIEN6),$D(^RMPR(661.6,RMIEN6,0)) D
        .S RMDAT6=$G(^RMPR(661.6,RMIEN6,0))
        .S RMIEN63=$O(^RMPR(661.63,"B",RMIEN6,0))
        .I $G(RMIEN63),$D(^RMPR(661.63,RMIEN63,0)) D
        ..S RMDAT63=$G(^RMPR(661.63,RMIEN63,0)),RMPR63("IEN")=RMIEN63
        ..S (RMPRRET("DATE&TIME"),RMDTTIM)=$P(RMDAT63,U,6)
        ..S RMPRRET("QUANTITY")=$P(RMDAT63,U,12)
        ..S RMPRRET("HCPCS")=$P(RMDAT63,U,4)
        ..S RMPRRET("STATION")=$P(RMDAT63,U,7)
        ..S RMPRRET("ITEM")=$P(RMDAT63,U,5)
        ..S RMPRRET("VALUE")=$P(RMDAT63,U,10)
        ..S RMPRRET("UNIT")=$P(RMDAT63,U,11)
        ..S RMPRRET("VENDOR")=$P(RMDAT63,U,9)
        ..S RMPRRET("LOCATION")=$P(RMDAT63,U,8)
        ;only update 660 if no label scan and quantity the same.
        I '$D(RMPR7I),($P(R1BCK(0),U,7)=RMPR60("QUANTITY")) D UP660 G PCE
        ;set update flags: 1=new item/diff barcode 2=only quantity changed.
        I $G(RMDTTIM),$D(RMPR7I("DATE&TIME")),RMDTTIM'=RMPR7I("DATE&TIME") S RMFLG=1
        I '$G(RMDTTIM),$D(RMPR7I("DATE&TIME")) S RMFLG=1
        I $P(R1BCK(0),U,7)'=RMPR60("QUANTITY"),'$G(RMFLG) S RMFLG=2
        ;
API     ;call API for 660, 661.7, 661.6, 661.63, 661.9
        ;
        ;file #660, 661.6, 661.7, 661.63, 661.9
        I RMFLG=1 D UPDATE
        I RMFLG=2 D QUAN
        D UP660
        I $G(RMPRERR) W !!,"*** ERROR in 2319 UPDATE, Please notify your IRM..IEN = ",$G(RMPR60("IEN")),!! H 3
        ;
PCE     ;update PCE data
        I $D(^RMPR(660,RMPR60("IEN"),10)),$P(^RMPR(660,RMPR60("IEN"),10),U,12) D
        .S RMCHK=0
        .S RMCHK=$$SENDPCE^RMPRPCEA(RMPR60("IEN"))
        .I RMCHK'=1 W !!,"*** ERROR in PCE UPDATE, Please notify your IRM..IEN = ",RMPR60("IEN"),!! H 3
        ;
        ;end posting (edit 2319)
        G EXIT
        ;
DEL1    ;ENTRY POINT TO DELETE AN ISSUE FROM STOCK
        ;** MOVED TO RMPRPIFD DUE TO SIZE CONSTRAINTS
        G DEL1^RMPRPIFD
EXIT    ;KILL VARIABLES AND EXIT ROUTINE
        I $G(RMPRIEN),$D(^RMPR(660,RMPRIEN)) L -^RMPR(660,RMPRIEN)
        K ^TMP($J) N RMPRSITE,RMPR D KILL^XUSCLEAN
        Q
        ;
UP660   ;update 660
        S RMPR60("IEN")=RMPRIEN
        S RMPRERR=0
        S RMPRERR=$$UPD^RMPRPIX2(.RMPR60,.RMPR11I)
        I $G(RMPRERR) W !,"*** Error in API RMPRPIX2, ERROR = ",RMPRERR,!,"*** Please inform your IRM !!",!
        Q
        ;
UPDATE  ;update the new entries AND delete old data
        S RMNEWHC=RMPR11I("HCPCS")
        S RMNEWIT=RMPR11I("ITEM")
        I $G(RMPR6("IEN")) S RMPR60("IEN")=RMPR6("IEN") D
        .S RMPRERR=$$UPD^RMPRPIX6(.RMPR60,.RMPR11I)
        .I $G(RMPR63("IEN")) S RMPRERR=$$UPALL^RMPRPIX3(.RMPR60,.RMPR63,.RMPR11I)
        .I '$G(RMPR63("IEN")) S RMPRERR=$$CRE^RMPRPIX3(.RMPR60,.RMPR6,.RMPR11I)
        I '$G(RMPR6("IEN")) D
        .S RMPRERR=$$CRE^RMPRPIX6(.RMPR60,.RMPR11I)
        .S (RMPR60("IEN6"),RMPR6("IEN"))=$G(RMPR60("IEN"))
        .S RMPRERR=$$CRE^RMPRPIX3(.RMPR60,.RMPR6,.RMPR11I)
        ;create a return stock record
        S RMPR11I("HCPCS")=$G(RMPRRET("HCPCS"))
        S RMPR11I("ITEM")=$G(RMPRRET("ITEM"))
        S RMPRRET("SEQUENCE")=1
        S RMPRRET("TRAN TYPE")=8
        S RMPRRET("COMMENT")="STOCK ISSUE EDIT"
        S RMPRRET("USER")=$G(DUZ)
        I '$D(RMPRRET("QUANTITY")) S RMPRRET("QUANTITY")=RMPR60("QUANTITY")
        I '$D(RMPRRET("VALUE")) S RMPRRET("VALUE")=RMPR60("COST")
        I '$D(RMPRRET("UNIT")) S RMPRRET("UNIT")=RMPR60("UNIT")
        I '$D(RMPRRET("VENDOR")) S RMPRRET("VENDOR")=RMPR60("VENDOR IEN")
        I '$D(RMPRRET("LOCATION")) S RMPRRET("LOCATION")=$G(RMLO1)
        I $D(RMPR11I) D  I $G(RMPRERR) Q
        .S RMPRERR=$$CRE^RMPRPIX6(.RMPRRET,.RMPR11I)
        ;return/update 661.7
        D BACK Q:$G(RMPRERR)
        S RMPR11I("HCPCS")=$G(RMNEWHC)
        S RMPR11I("ITEM")=$G(RMNEWIT)
        S RMPR7I("QUANTITY")=RMPR60("QUANTITY")
        S RMPR7I("VALUE")=RMPR60("COST")
        ;update or create 661.7 entry
        D UP7
        S RMPR9("QUANTITY")=RMPR60("QUANTITY")
        S RMPR9("VALUE")=RMPR60("COST")
        ;return 661.9 entry
        I $D(RMDTTIM) D  D UP9
        .S RMPR11I("HCPCS")=RMPRRET("HCPCS")
        .S RMPR11I("ITEM")=RMPRRET("ITEM")
        .S RMPR9("QUANTITY")=$P(R1BCK(0),U,7)
        .S RMPR9("VALUE")=$P(R1BCK(0),U,16)
        ;deduct the new HCPCS in 661.9
        S RMPR11I("HCPCS")=RMNEWHC
        S RMPR11I("ITEM")=RMPR60("ITEM")
        S RMPR9("QUANTITY")=0-RMPR60("QUANTITY")
        S RMPR9("VALUE")=0-RMPR60("COST")
        D UP9
        Q
        ;
BACK    ; Bring back ITEM into current stock.
        D NOW^%DTC
        S (RMPR7R("STATION"),RMST1)=RMPR11I("STATION")
        S (RMPR7R("HCPCS"),RMHC1)=RMPR11I("HCPCS")
        S (RMPR7R("ITEM"),RMIT1)=RMPR11I("ITEM")
        S (RMPR7R("LOCATION"),RMLO1)=RMPRRET("LOCATION")
        S RMPR7R("VENDOR")=RMPRRET("VENDOR")
        S RMPR7R("DATE&TIME")=% S:$G(RMPRRET("DATE&TIME"))'="" RMPR7R("DATE&TIME")=RMPRRET("DATE&TIME")
        S RMPR7R("SEQUENCE")=1
        S RMPR7R("QUANTITY")=RMPRRET("QUANTITY")
        S RMPR7R("VALUE")=RMPRRET("VALUE")
        S RMPR7R("UNIT")=$G(RMPRRET("UNIT"))
        I $G(RMDTTIM),$D(^RMPR(661.7,"XSLHIDS",RMST1,RMLO1,RMHC1,RMIT1,RMDTTIM)) D  I RMPRERR S RMPRERR=71 Q
        .S RMPR7R("IEN")=$O(^RMPR(661.7,"XSLHIDS",RMST1,RMLO1,RMHC1,RMIT1,RMDTTIM,1,0))
        .I '$G(RMPR7R("IEN")) S RMPRERR=1 Q
        .S RMDA7=$G(^RMPR(661.7,RMPR7R("IEN"),0))
        .S RMDAVAL=$P(RMDA7,U,8),RMDAQUA=$P(RMDA7,U,7)
        .S RMPR7R("QUANTITY")=RMPR7R("QUANTITY")+RMDAQUA
        .S RMPR7R("VALUE")=RMPR7R("VALUE")+RMDAVAL
        .S RMPR7R("DATE&TIME")=RMDTTIM
        .S RMPRERR=$$UPD^RMPRPIX7(.RMPR7R,.RMPR11I)
        I $G(RMDTTIM),'$D(^RMPR(661.7,"XSLHIDS",RMST1,RMLO1,RMHC1,RMIT1,RMDTTIM)) D
        .S RMPR7R("DATE&TIME")=RMDTTIM
        .S RMPRERR=$$CRE^RMPRPIX7(.RMPR7R,.RMPR11I)
        I '$G(RMDTTIM) S RMPRERR=$$CRE^RMPRPIX7(.RMPR7R,.RMPR11I)
        Q
        ;
UP6     ;now update file 661.6
        S RMPR6("IEN")=$G(RMIEN6)
        S RMPR6("QUANTITY")=$G(RMPR60("QUANTITY"))
        S RMPR6("VALUE")=$G(RMPR60("COST"))
        S RMPRERR=$$UPD^RMPRPIX6(.RMPR6,.RMPR11I)
        Q
        ;
        ;
UP63    ;update file 661.63
        S RMPR6("IEN")=$G(RMIEN6)
        S RMPR6("LOCATION")=$G(RMPR5("IEN"))
        S RMPR6("VENDOR")=$G(RMPR60("VENDOR IEN"))
        S RMPR63("IEN")=$G(RMIEN63)
        S RMPRERR=$$UPD^RMPRPIX3(.RMPR60,.RMPR63,.RMPR11I)
        Q
        ;
UP7     ;file #661.7,deduct quantity
        Q:'$G(RMPR11I("STATION"))
        S RMPR7I("STATION IEN")=RMPR11I("STATION")
        S RMPR7I("LOCATION IEN")=$G(RMPR5("IEN"))
        S RMPR7I("HCPCS")=RMPR11I("HCPCS")
        S RMPR7I("ITEM")=RMPR11I("ITEM")
        S:$G(RMPRRET("DATE&TIME")) RMPR7I("DATE&TIME")=RMPRRET("DATE&TIME")
        S RMPR7I("ISSUED QTY")=$G(RMPR7I("QUANTITY"))
        S RMPR7I("ISSUED VALUE")=$G(RMPR7I("VALUE"))
        S RMPRERR=$$FIFO^RMPRPIUB(.RMPR7I)
        Q
UP9     ;file 661.9
        D NOW^%DTC
        S RMPR9("STA")=RMPR11I("STATION")
        S RMPR9("HCP")=RMPR11I("HCPCS")
        S RMPR9("ITE")=RMPR11I("ITEM")
        S RMPR9("RDT")=$P(%,".",1)
        S RMPR9("TQTY")=RMPR9("QUANTITY")
        S RMPR9("TCST")=RMPR9("VALUE")
        S RMPERR=$$UPCR^RMPRPIXJ(.RMPR9)
        Q
        ;
QUAN    ;only update quantity
        ;quit if not in PIP
        Q:'$G(RMIEN6)!'$D(RMDTTIM)!'$D(RMPRRET)
        S RMPR11I("STATION")=RMPRRET("STATION")
        S RMPR11I("HCPCS")=RMPRRET("HCPCS")
        S RMPR11I("ITEM")=RMPRRET("ITEM")
        S RMPR5("IEN")=RMPRRET("LOCATION")
        D UP6,UP63
        I RMPR60("QUANTITY")>($P(R1BCK(0),U,7)) D  D UP7,UP9
        .S RMPR7I("QUANTITY")=RMPR60("QUANTITY")-($P(R1BCK(0),U,7))
        .S RMPR7I("VALUE")=RMPR60("COST")-($P(R1BCK(0),U,16))
        .S RMPR9("QUANTITY")=0-($G(RMPR60("QUANTITY"))-$P(R1BCK(0),U,7))
        .S RMPR9("VALUE")=0-($G(RMPR60("COST"))-$P(R1BCK(0),U,16))
        I RMPR60("QUANTITY")<($P(R1BCK(0),U,7)) D  D BACK,UP9
        .S RMPR9("QUANTITY")=$P(R1BCK(0),U,7)-$G(RMPR60("QUANTITY"))
        .S RMPRRET("QUANTITY")=$P(R1BCK(0),U,7)-$G(RMPR60("QUANTITY"))
        .S RMPR9("VALUE")=$P(R1BCK(0),U,16)-$G(RMPR60("COST"))
        .S RMPRRET("VALUE")=$P(R1BCK(0),U,16)-$G(RMPR60("COST"))
        Q
        ;
ERR     W !!,"Error encountered while posting to PIP.  Patient 10-2319 not deleted!! Please check with your Application Coordinator." H 5 G EXIT
