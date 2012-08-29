PSOREJP0        ;BIRM/MFR - Third Party Rejects Processing Screen ;04/28/05
        ;;7.0;OUTPATIENT PHARMACY;**148,260,287**;DEC 1997;Build 77
        ;
        N PSOREJST,PSORJSRT,PSORJASC,PSOSTFLT,PSODRFLT,PSOPTFLT,PSORXFLT,PSOINFLT,PSOINGRP,PSOTRITG
        N INSLN,HIGHLN,LASTLN,PSOEKEY
        ;
        ; - Division/Site selection
        D SEL^PSOREJU1("DIVISION","^PS(59,",.PSOREJST,$$GET1^DIQ(59,+$G(PSOSITE),.01)) I $G(PSOREJST)="^" G EXIT
        ;
        ; - Initializing global variables
        S PSORJSRT="PA",PSORJASC=1,PSOSTFLT="U",(PSODRFLT,PSOPTFLT,PSORXFLT,PSOINFLT)="ALL"
        S PSOINGRP=0,PSOTRITG=1
        ;
        D LST("W")
        G EXIT
        ;
LST(PSOMENU)    ; - Invokes Listmanager
        W !,"Please wait..."
        I PSOMENU="W" D EN^VALM("PSO REJECTS WORKLIST")
        I PSOMENU="VP" D EN^VALM("PSO REJECTS VIEW/PROCESS")
        D FULL^VALM1
        Q
        ;
HDR          ; - Header code
        N LINE1,LINE2,LINE3
        S LINE1=$$SITES() I $L(LINE1)>80 S $E(LINE1,78,999)="..."
        ;
        S LINE2="Selection : ALL "_$S(PSOSTFLT="U":"UNRESOLVED ",PSOSTFLT="R":"RESOLVED ",1:"")_"REJECTS"
        I $G(PSOPTFLT)'="ALL" S LINE2=LINE2_" FOR "_$$NAME("P")
        I $G(PSODRFLT)'="ALL" S LINE2=LINE2_" FOR "_$$NAME("D")
        I $G(PSOINFLT)'="ALL" S LINE2=LINE2_" FOR "_$$NAME("I")
        I $G(PSOINGRP) S LINE2=LINE2_" GROUPED BY INSURANCE"
        S VALMHDR(1)=LINE1,VALMHDR(2)=LINE2
        I PSOMENU="VP" D
        . I $G(PSORXFLT) S LINE3="Rx#       : "_$$NAME("R")
        . E  D
        . . S LINE3="Date Range: "_$$FMTE^XLFDT(+PSODTRNG,2)
        . . I +PSODTRNG'=$P(PSODTRNG,"^",2) S LINE3=LINE3_" THRU "_$$FMTE^XLFDT($P(PSODTRNG,"^",2),2)
        . S VALMHDR(3)=LINE3
        ;
        D SETHDR()
        Q
        ;
SETHDR()        ; - Displays the Header Line
        N HDR,ORD
        ;
        S HDR="  #",$E(HDR,5)="Rx#",$E(HDR,18)="PATIENT(ID)",$E(HDR,43)="DRUG",$E(HDR,64)="REASON"
        S $E(HDR,81)="" D INSTR^VALM1(IORVON_HDR_IOINORM,1,$S(PSOMENU="W":4,1:5))
        S ORD=$S(PSORJASC=1:"[^]",1:"[v]")
        S:PSORJSRT="RX" POS=9 S:PSORJSRT="PA" POS=30 S:PSORJSRT="DR" POS=48 S:PSORJSRT="RE" POS=71
        D INSTR^VALM1(IOINHI_IORVON_ORD_IOINORM,POS,$S(PSOMENU="W":4,1:5))
        Q
        ;
INIT    ; - Populates the Body section for ListMan
        K ^TMP("PSOREJP0",$J)
        D SETSORT(PSORJSRT),SETLINE
        S VALMSG="Select the entry # to view or ?? for more actions"
        Q
        ;
SETLINE ; - Sets the line to be displayed in ListMan
        N INS,SUB,SEQ,SORTA,LINE,Z,I,X,X1,X2
        I '$D(^TMP("PSOREJSR",$J)) D  Q
        . F I=1:1:7 S ^TMP("PSOREJP0",$J,I,0)=""
        . S ^TMP("PSOREJP0",$J,8,0)="               No Clinical Third Party Payer Rejects found."
        . S VALMCNT=1
        ;
        F I=1:1:$G(LASTLN) D RESTORE^VALM10(I)
        K INSLN,HIGHLN
        ;
        S (SORTA,INS,SUB)="",LINE=0 K ^TMP("PSOREJP0",$J)
        F  S SORTA=$O(^TMP("PSOREJSR",$J,SORTA)) Q:SORTA=""  D
        . F  S INS=$O(^TMP("PSOREJSR",$J,SORTA,INS)) Q:INS=""  D
        .. I INS'="<NULL>" D
        ... D GROUP(INS,.LINE)
        .. F  S SUB=$O(^TMP("PSOREJSR",$J,SORTA,INS,SUB),PSORJASC) Q:SUB=""  D
        ... S Z=$G(^TMP("PSOREJSR",$J,SORTA,INS,SUB))
        ... S X1="",SEQ=$G(SEQ)+1,X1=$J(SEQ,3)
        ... S $E(X1,5)=$P(Z,"^",3),$E(X1,18)=$P(Z,"^",4),$E(X1,43)=$P(Z,"^",5),$E(X1,64)=$P(Z,"^",6)
        ... S LINE=LINE+1,^TMP("PSOREJP0",$J,LINE,0)=X1,HIGHLN(LINE)=""
        ... S X2="",$E(X2,5)="Payer Message: "_$P(Z,"^",7)
        ... S LINE=LINE+1,^TMP("PSOREJP0",$J,LINE,0)=X2
        ... S ^TMP("PSOREJP0",$J,SEQ,"RX")=$P(Z,"^",1,2)
        ;
        I LINE>$G(LASTLN) D
        . F I=($G(LASTLN)+1):1:LINE D SAVE^VALM10(I)
        . S LASTLN=LINE
        ;
        ; - Highlighting the prescription/insurance line
        F LN=1:1:LINE D
        . I $D(HIGHLN(LN)) D  Q
        . . D CNTRL^VALM10(LN,1,80,IOINHI,IOINORM)
        . . D CNTRL^VALM10(LN,64,3,IOUON,IOINORM)
        . . D CNTRL^VALM10(LN,67,80,IOINHI,IOINORM)
        . I $D(INSLN(LN)) D
        . . S LBL=INSLN(LN),POS=41-($L(LBL)/2+.5\1)
        . . D CNTRL^VALM10(LN,1,POS-1,IOUON_IOINHI,IOINORM)
        . . D CNTRL^VALM10(LN,POS,$L(LBL),IORVON_IOINHI,IORVOFF_IOINORM)
        . . D CNTRL^VALM10(LN,POS+$L(LBL),(81-POS-$L(LBL)),IOUON_IOINHI,IOINORM)
        ;
        S VALMCNT=+$G(LINE)
        Q
        ;
GROUP(LBL,LINE) ; Sets an insurance delimiter line
        N X,POS
        S POS=41-($L(LBL)/2+.5\1)
        S X="",$P(X," ",81)="",$E(X,POS,POS-1+$L(LBL))=LBL
        S LINE=LINE+1,^TMP("PSOREJP0",$J,LINE,0)=X,INSLN(LINE)=LBL
        Q
        ;
SETSORT(FIELD)  ; - Sets the data sorted by the FIELD specified
        N RX,REJ,STS,DAT
        K ^TMP("PSOREJSR",$J)
        ;
        ; - Worklist
        I PSOMENU="W" D
        . S RX=0 F  S RX=$O(^PSRX("REJSTS",0,RX)) Q:'RX  D
        . . S REJ=0 F  S REJ=$O(^PSRX("REJSTS",0,RX,REJ)) Q:'REJ  D
        . . . D SETTMP(RX,REJ,FIELD)
        ;
        ; - View/Process
        I PSOMENU="VP" D
        . I $G(PSORXFLT)'="ALL" D  Q
        . . S REJ=0 F  S REJ=$O(^PSRX(+PSORXFLT,"REJ",REJ)) Q:'REJ  D
        . . . I $$FLTSTS(+PSORXFLT,REJ) Q
        . . . D SETTMP(+PSORXFLT,REJ,FIELD)
        . S DAT=$P(PSODTRNG,"^")-0.0000001,(RX,REJ)=0
        . F  S DAT=$O(^PSRX("REJDAT",DAT)) Q:'DAT!(DAT>$$ENDT())  D
        . . F  S RX=$O(^PSRX("REJDAT",DAT,RX)) Q:'RX  D
        . . . I $$FILTER(RX) Q
        . . . F  S REJ=$O(^PSRX("REJDAT",DAT,RX,REJ)) Q:'REJ  D
        . . . . I $$FLTSTS(RX,REJ) Q
        . . . . D SETTMP(RX,REJ,FIELD)
        Q
        ;
SETTMP(RX,REJ,FIELD)    ; - Sets ^TMP global that will be displayed in the body section
        N REJLST,FILL,CODE,RXNUM,PTNAME,DRNAME,MSG,REASON,MSG,X,Z,SORT,I,INS,OREJ,PSOTRIC,SORTA
        I $G(PSORXFLT)="ALL",$$CLOSED^PSOREJP1(RX,REJ),$$REOPN^PSOREJP1(RX,REJ) Q
        S FILL=+$$GET1^DIQ(52.25,REJ_","_RX,5),SORTA=1
        I '$$DIV(RX,FILL) Q
        K REJLST D GET^PSOREJU2(RX,FILL,.REJLST,,1) I '$D(REJLST) Q
        I $$FILTER(,REJLST(REJ,"INSURANCE NAME")) Q
        S CODE=$G(REJLST(REJ,"CODE"))
        S PSOTRIC="",PSOTRIC=$$TRIC^PSOREJP1(RX,FILL,PSOTRIC)
        Q:$G(PSOTRIC)&('$G(PSOTRITG))&(CODE'="79")&(CODE'="88")  ;show/hide non-DUR/RTS Tricare
        S PTNAME=$$PTNAME(RX)
        S DRNAME=$$GET1^DIQ(52,RX,6)
        S RXNUM=$$GET1^DIQ(52,RX,.01)
        S MSG=$G(REJLST(REJ,"PAYER MESSAGE")) I $L(MSG)>60 S MSG=$E(MSG,1,58)_"..."
        S REASON=$S(CODE=88:"DUR:"_$G(REJLST(REJ,"REASON")),CODE=79:"79 :REFILL TOO SOON",1:CODE)
        I CODE'=79&(CODE'=88) S REASON=CODE_" :"_$$EXP^PSOREJP1(CODE)
        S Z="",$P(Z,"^")=RX,$P(Z,"^",2)=REJ,$P(Z,"^",3)=RXNUM,$P(Z,"^",4)=PTNAME
        S $P(Z,"^",5)=$E(DRNAME,1,20),$P(Z,"^",6)=$E(REASON,1,17),$P(Z,"^",7)=MSG
        S SORT=$S(FIELD="PA":PTNAME,FIELD="DR":DRNAME,FIELD="RX":RXNUM_" ",1:REASON)_RX_REJ
        S INS="<NULL>"
        I $G(PSOINGRP) S INS=REJLST(REJ,"INSURANCE NAME") S:INS="" INS="***UNKNOWN***"
        S:$G(PSOTRIC)&(CODE'=79)&(CODE'=88) INS="TRICARE"_" - Non-DUR/RTS",SORTA=2
        S ^TMP("PSOREJSR",$J,SORTA,INS,SORT)=Z
        Q
        ;
PAT     ; - Sort by Patient
        D SORT("PA")
        Q
DRG     ; - Sort by Drug
        D SORT("DR")
        Q
RX      ; - Sort by Rx
        D SORT("RX")
        Q
REA     ; - Sort by Reason
        D SORT("RE")
        Q
SORT(FIELD)     ; - Sort entries by FIELD
        I PSORJSRT=FIELD S PSORJASC=$S(PSORJASC=1:-1,1:1)
        E  S PSORJSRT=FIELD,PSORJASC=1
        D REF
        Q
        ;
REF     ; - Screen Refresh
        W ?52,"Please wait..." D INIT S VALMBCK="R"
        Q
GI      ; - Group by Insurance
        W ?52,"Please wait..." S PSOINGRP=$S($G(PSOINGRP):0,1:1) D INIT,HDR S VALMBCK="R"
        Q
TRICTOG ;  - Toggle Tricare display
        W ?52,"Please wait..." S PSOTRITG=$S($G(PSOTRITG):0,1:1) D INIT,HDR S VALMBCK="R"
        Q
        ;
SEL     ; - Process selection of one entry
        N PSOSEL,XQORM,Z,RX,REJ,PSOCHNG
        S PSOSEL=+$P($P(Y(1),"^",4),"=",2) I 'PSOSEL S VALMSG="Invalid selection!",VALMBCK="R" Q
        S Z=$G(^TMP("PSOREJP0",$J,PSOSEL,"RX"))
        S RX=$P(Z,"^"),REJ=$P(Z,"^",2) I 'RX!'REJ S VALMSG="Invalid selection!",VALMBCK="R" Q
        S PSOCHNG=0 D EN^PSOREJP1(RX,REJ,.PSOCHNG) I $G(PSOCHNG) D REF
        Q
        ;
EXIT    ;
        K ^TMP("PSOREJP0",$J),^TMP("PSOREJSR",$J)
        Q
        ;
HELP    Q
        ;
SITES() ; - Returns the list of sites along with their NCPDP #s
        N CNT,SITE,SITES,NAME
        I '$D(PSOREJST) Q ""
        I $G(PSOREJST)="ALL" Q "Divisions : ALL"
        S SITE=0 F  S SITE=$O(PSOREJST(SITE)) Q:'SITE  D
        . S NAME=$$GET1^DIQ(59,SITE,.01)
        . S SITES=$G(SITES)_", "_NAME
        S $E(SITES,1,2)="",SITES="Division"_$S($L(SITES,",")>1:"s",1:" ")_" : "_SITES
        Q SITES
        ;
DIV(RX,FILL)    ; - Check if the Division for the Prescription/Fill was selected by the user
        ;
        I $G(PSOREJST)="ALL" Q 1
        I $D(PSOREJST($$RXSITE^PSOBPSUT(RX,FILL))) Q 1
        Q 0
        ;
PTNAME(RX)      ; - Returns header displayable - Patient Name (Last 4 SSN)
        N DFN,VADM,PTNAME
        S DFN=$$GET1^DIQ(52,RX,2,"I") D DEM^VADPT
        S PTNAME=$E($G(VADM(1)),1,18)_"("_$P($P($G(VADM(2)),"^",2),"-",3)_")"
        Q PTNAME
        ;
FILTER(RX,INS)  ; - Filter entries based on user's selection
        N FILTER,NAME
        S FILTER=1
        I $G(PSOPTFLT)'="ALL",$D(RX),'$D(PSOPTFLT($$GET1^DIQ(52,RX,2,"I"))) Q FILTER
        I $G(PSODRFLT)'="ALL",$D(RX),'$D(PSODRFLT($$GET1^DIQ(52,RX,6,"I"))) Q FILTER
        I $G(PSOINFLT)'="ALL",$D(INS) D  Q FILTER
        . S NAME="" F  S NAME=$O(PSOINFLT(NAME)) Q:NAME=""  I $$UP^XLFSTR(INS)[$$UP^XLFSTR(NAME) S FILTER=0 Q
        Q 0
        ;
FLTSTS(RX,REJ)  ; - Filter for the Reject Status  
        N STS
        S STS=$$GET1^DIQ(52.25,REJ_","_RX,9,"I")
        I PSOSTFLT="U",STS=1 Q 1
        I PSOSTFLT="R",STS=0 Q 1
        Q 0
        ;
NAME(TYPE)      ; - Returns the name if ONE was selected or "MULTIPLE ..."
        N I,CNT
        ;
        I TYPE="P",$O(PSOPTFLT($O(PSOPTFLT(""))))="" Q $$GET1^DIQ(2,$O(PSOPTFLT("")),.01)
        I TYPE="D",$O(PSODRFLT($O(PSODRFLT(""))))="" Q $$GET1^DIQ(50,$O(PSODRFLT("")),.01)
        I TYPE="I",$O(PSOINFLT($O(PSOINFLT(""))))="" Q $O(PSOINFLT(""))
        I TYPE="R" Q $$GET1^DIQ(52,PSORXFLT,.01)
        Q "MULTIPLE "_$S(TYPE="P":"PATIENTS",TYPE="D":"DRUGS",1:"INSURANCE COMPANIES")
        ;
ENDT()  ; Returns the upper limit for the date range
        N ENDT
        S ENDT=$P(PSODTRNG,"^",2)
        I '$E(ENDT,4,7) Q (ENDT+10000)
        I '$E(ENDT,6,7) Q (ENDT+100)
        I $P(ENDT,"^",2) Q (ENDT+0.0000001)
        Q (ENDT+.25)
