PSOREJP3        ;ALB/SS - Third Party Reject Display Screen - Comments ;10/27/06
        ;;7.0;OUTPATIENT PHARMACY;**260,287**;DEC 1997;Build 77
        ;
COM     ; Builds the Comments section in the Reject Display Screen
        I +$O(^PSRX(RX,"REJ",REJ,"COM",0))=0 Q
        D SETLN^PSOREJP1()
        D SETLN^PSOREJP1("COMMENTS",1,1)
        N DIWL,DIWR,LNCNT,MAXLN,PSL
        N I,X,PSI,Y,LAST,PSOCOM,TXTLN
        S PSI=999999
        F  S PSI=$O(^PSRX(RX,"REJ",REJ,"COM",PSI),-1) Q:+PSI=0  D
        . S PSCOM=$$GET1^DIQ(52.2551,PSI_","_REJ_","_RX,.01)_" - "
        . S PSCOM=PSCOM_$$GET1^DIQ(52.2551,PSI_","_REJ_","_RX,2)
        . S PSCOM=PSCOM_" ("_$$GET1^DIQ(52.2551,PSI_","_REJ_","_RX,1)_")"
        . ;display comment
        . K ^UTILITY($J,"W") S X=PSCOM,DIWL=1,DIWR=78 D ^DIWP
        . F PSL=1:1 Q:('$D(^UTILITY($J,"W",1,PSL,0)))  D
        . . S LAST=0 I '$D(^UTILITY($J,"W",1,PSL+1)),'$O(^PSRX(RX,"REJ",REJ,"COM",PSI),-1) S LAST=1
        . . S TXTLN=$G(^UTILITY($J,"W",1,PSL,0))
        . . D SETLN^PSOREJP1($S(PSL=1:"- ",1:"  ")_TXTLN,0,$S(LAST:1,1:0),1)
        K ^UTILITY($J,"W")
        Q
        ;
ADDCOM  ; - Add comment worklist action
        N PSCOM
        D FULL^VALM1
        S PSCOM=$$COMMENT("Comment: ",150)
        I $L(PSCOM)>0,PSCOM'["^" D
        . D SAVECOM(RX,REJ,PSCOM) ;save the comment
        . D INIT^PSOREJP1 ;update screen
        S VALMBCK="R"
        Q
        ;
        ;Enter a comment
        ;PSOTR  -prompt string
        ;PSMLEN -maxlen
        ;returns:
        ; "^" - if user chose to quit
        ; "" - nothing entered or input has been discarded
        ; otherwise - comment's text
COMMENT(PSOTR,PSMLEN)   ;*/
        N DIR,DTOUT,DUOUT,PSQ
        I '$D(PSOTR) S PSOTR="Comment "
        I '$D(PSMLEN) S PSMLEN=150
        S DIR(0)="FA^1:150"
        S DIR("A")=PSOTR
        S DIR("?")="Enter a free text comment up to 150 characters long."
        S PSQ=0
        F  D  Q:+PSQ'=0
        . W ! D ^DIR
        . I $D(DUOUT)!($D(DTOUT)) S PSQ=-1 Q
        . I $L(Y)'>PSMLEN S PSQ=1 Q
        . W !!,"Enter a free text comment up to 150 characters long.",!
        . S DIR("B")=$E(Y,1,PSMLEN)
        Q:PSQ<0 "^"
        Q:$L(Y)=0 ""
        S PSQ=$$YESNO("Confirm","YES")
        I PSQ=-1 Q "^"
        I PSQ=0 Q ""
        Q Y
        ;
        ; Ask
        ; Input:
        ;  PSQSTR - question
        ;  PSDFL - default answer
        ; Output:
        ; 1 YES
        ; 0 NO
        ; -1 if cancelled
YESNO(PSQSTR,PSDFL)     ; Default - YES
        N DIR,Y,DUOUT
        S DIR(0)="Y"
        S DIR("A")=PSQSTR
        S:$L($G(PSDFL)) DIR("B")=PSDFL
        W ! D ^DIR
        Q $S($G(DUOUT)!$G(DUOUT)!(Y="^"):-1,1:Y)
        ;
        ;Save comment
SAVECOM(PSRXIEN,PSREJIEN,PSCOMNT,DATETIME,USER) ;
        N PSREC,PSDA,PSERR
        I '$G(DATETIME) D NOW^%DTC S DATETIME=%
        I '$G(USER) S USER=DUZ
        D INSITEM(52.2551,PSRXIEN,PSREJIEN,DATETIME)
        S PSREC=$O(^PSRX(PSRXIEN,"REJ",PSREJIEN,"COM","B",DATETIME,0))
        I PSREC>0 D
        . S PSDA(52.2551,PSREC_","_PSREJIEN_","_PSRXIEN_",",1)=USER
        . S PSDA(52.2551,PSREC_","_PSREJIEN_","_PSRXIEN_",",2)=$G(PSCOMNT)
        . D FILE^DIE("","PSDA","PSERR")
        Q
        ;
        ;/**
        ;PSSFILE - subfile# (52.2551) for comment
        ;PSIEN - ien for file in which the new subfile entry will be inserted
        ;PSVAL01 - .01 value for the new entry
INSITEM(PSSFILE,PSIEN0,PSIEN1,PSVAL01)  ;*/
        N PSSSI,PSIENS,PSFDA,PSER
        S PSIENS="+1,"_PSIEN1_","_PSIEN0_","
        S PSFDA(PSSFILE,PSIENS,.01)=PSVAL01
        D UPDATE^DIE("","PSFDA","PSSSI","PSER")
        I $D(PSER) D BMES^XPDUTL(PSER("DIERR",1,"TEXT",1))
        Q
        ;
PRINT(RX,RFL)   ; Print Label for specific Rx/Fill
        N PPL,PSOSITE,PSOPAR,PSOSYS,PSOLAP,PSOBARS,PSOBAR0,PSOBAR1,PSOIOS,PSOBFLAG
        N POP,DFN,PDUZ,RXFL
        ;
        S PSOSITE=$$RXSITE^PSOBPSUT(RX,RFL),PSOPAR=^PS(59,PSOSITE,1)
        S DFN=$$GET1^DIQ(52,RX,2,"I"),PDUZ=DUZ,PSOSYS=$G(^PS(59.7,1,40.1))
        S PPL=RX I RFL S RXFL(RX)=RFL
        W ! S PSOBFLAG=1 D LBL^PSOLSET I $G(PSOQUIT) Q
        ;
        S IOP=PSOLAP D ^%ZIS,DQ^PSOLBL,^%ZISC
        Q
        ;
RXINFO(RX,FILL,LINE)    ; Returns header displayable Rx Information
        N TXT,RXINFO,LBL,CMOP,DRG
        I LINE=1 D
        . S RXINFO="Rx#      : "_$$GET1^DIQ(52,RX,.01)_"/"_FILL
        . S $E(RXINFO,30)="ECME#: "_$E(10000000+RX,2,8)
        . S $E(RXINFO,55)="Fill Date: "_$$FMTE^XLFDT($$RXFLDT^PSOBPSUT(RX,FILL))
        I LINE=2 D
        . S DRG=$$GET1^DIQ(52,RX,6,"I"),CMOP=$S($D(^PSDRUG("AQ",DRG)):1,1:0)
        . S RXINFO=$S(CMOP:"CMOP ",1:"")_"Drug",$E(RXINFO,10)=": "_$E($$GET1^DIQ(52,RX,6),1,43)
        . S $E(RXINFO,56)="NDC Code: "_$$GETNDC^PSONDCUT(RX,FILL)
        Q $G(RXINFO)
        ;
SEND(COD1,COD2,COD3,CLA,PA)     ; - Sends Claim to ECME and closes Rejec
        N DIR,OVRC,RESP,ALTXT,COM
        S DIR(0)="Y",DIR("A")="     Confirm",DIR("B")="YES"
        S DIR("A",1)="     When you confirm, a new claim will be submitted for"
        S DIR("A",2)="     the prescription and this REJECT will be marked"
        S DIR("A",3)="     resolved."
        S DIR("A",4)=" "
        W ! D ^DIR I $G(Y)=0!$D(DIRUT) S VALMBCK="R" Q
        I $G(COD1)'="" S OVRC=$G(COD2)_"^"_$G(COD1)_"^"_$G(COD3)
        S ALTXT="REJECT WORKLIST"
        S:$G(OVRC)'="" ALTXT=ALTXT_"-DUR OVERRIDE CODES("_$G(COD1)_"/"_$G(COD2)_"/"_$G(COD3)_")"
        S:$G(CLA) ALTXT=ALTXT_"(CLARIF. CODE="_CLA_")"
        S:$G(PA) ALTXT=ALTXT_"(PRIOR AUTH.="_$TR(PA,"^","/")_")"
        D ECMESND^PSOBPSU1(RX,FILL,,"ED",$$GETNDC^PSONDCUT(RX,FILL),,,$G(OVRC),,.RESP,,ALTXT,$G(CLA),$G(PA))
        I $G(RESP) D  Q
        . W !!?10,"Claim could not be submitted. Please try again later!"
        . W !,?10,"Reason: ",$S($P(RESP,"^",2)="":"UNKNOWN",1:$P(RESP,"^",2)),$C(7) H 2
        ;
        I $$PTLBL^PSOREJP2(RX,FILL) D PRINT(RX,FILL)
        ;
        N PSOTRIC S PSOTRIC="",PSOTRIC=$$TRIC^PSOREJP1(RX,FILL,PSOTRIC)
        I $$GET1^DIQ(52,RX,100,"I")=5&(PSOTRIC) D
        . Q:$$STATUS^PSOBPSUT(RX,RFL)'["PAYABLE"
        . N XXX S XXX=""
        . W !,"This prescription can be pulled early from suspense or the label will print"
        . W !,"when PRINT FROM SUSPENSE occurs.",!
        . R !,"Press enter to continue... ",XXX:60
        ;
        I $D(PSOSTFLT),PSOSTFLT'="B" S CHANGE=1
        Q
        ;
FILL    ;Fill payable TRICARE Rx
        N COM,OPNREJ,OPNREJ2,OPNREJ3
        D FULL^VALM1
        I $$CLOSED^PSOREJP1(RX,REJ) D  Q
        . S VALMSG="This Reject is marked resolved!",VALMBCK="R"
        I $$STATUS^PSOBPSUT(RX,FILL)'["PAYABLE" S VALMSG="Only Rxs with an E PAYABLE status may be filled.",VALMBCK="R" Q
        S COM="AUTOMATICALLY CLOSED"
        S (OPNREJ,OPNREJ2,OPNREJ3)=""
        S OPNREJ2=0 F  S OPNREJ2=$O(^PSRX(RX,"REJ",OPNREJ2)) Q:OPNREJ2=""!(OPNREJ2'?1N.N)  S OPNREJ=OPNREJ_","_OPNREJ2
        S OPNREJ=$E(OPNREJ,2,999),OPNREJ2=""
        W !?20,"[Closing all rejections for prescription "_$$GET1^DIQ(52,RX,".01")_":"
        F I=1:1 S OPNREJ2=$P(OPNREJ,",",I) Q:OPNREJ2=""  D
        . S OPNREJ3="",OPNREJ3=$$GET1^DIQ(52.25,OPNREJ2_","_RX,".01")
        . W !?25,OPNREJ3_" - "_$$GET1^DIQ(9002313.93,OPNREJ3,".02")_"..."
        . D CLOSE^PSOREJUT(RX,FILL,OPNREJ2,DUZ,1,COM) W "OK]",!,$C(7) H 1
        I $$PTLBL^PSOREJP2(RX,FILL) D PRINT(RX,FILL)
        S VALMBCK="R",CHANGE=1
        Q
        ;
DC      ;Discontinue TRICARE Rx
        N ACTION S ACTION="D"
        D FULL^VALM1
        S ACTION=$$DC^PSOREJU1(RX,ACTION)
        I ACTION="Q"!(ACTION="^")!('$G(PSORX("DFLG"))) S VALMSG="NO ACTION TAKEN.",VALMBCK="R" Q
        S CHANGE=1
        Q
        ;
