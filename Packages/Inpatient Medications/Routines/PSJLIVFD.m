PSJLIVFD        ;BIR/MV-SETUP LM TEMPLATE FOR IV FLUID ;4 Aug 00 / 2:37 PM
        ;;5.0; INPATIENT MEDICATIONS ;**7,50,63,64,58,81,91,80,116,110,111,180,134**;16 DEC 97;Build 124
        ;
        ; Reference to ^VALM0 is supported by DBIA # 2615.
        ;
        ;NFI changes for FR# 3@AD+4
        ;
EN      ; Build LM template to display IV order.
        K ^TMP("PSJI",$J)
        S UL80="",$P(UL80,"=",80)=""
        S PSJLN=1
AD      ;
        NEW VALMEVL S VALMEVL=1
        S PSJL="" D FLDNO^PSJLIUTL("(1)",1)
        S PSJL=PSJL_"Additives:"
        S:$G(P("PON"))["V"&(P(17)'="N") PSJL=$$SETSTR^VALM1("Order number:",PSJL,30,14)_+P("PON")
        S PSJL=$$SETSTR^VALM1("Type:",PSJL,57,6)_$$TYPE^PSJLIUTL
        NEW PSJVD S PSJVD=$$DINFLIV^PSJDIN(.DRG)
        S PSJL=$$SETSTR^VALM1(PSJVD,PSJL,75,6)
        I '$D(IORVON),$D(IOST(0)) D ENS^%ZISS,TERM^VALM0
        I $D(IORVON),(PSJVD]"") D CNTRL^VALM10(1,76,5,IORVON,IORVOFF,0) K PSJVD
        D SETTMP^PSJLMPRU("PSJI",PSJL)
        D:+$G(PSJLMX) CLRDSPL^PSJLIVMD
        ;PSJLMX count number of lines needed to display the add/sol
        S PSJLMX=0 D WRTDRG^PSJLIUTL("AD")
SOL     ;
        S PSJL="" D FLDNO^PSJLIUTL("(2)",1)
        S PSJL=PSJL_"Solutions:"
        I P("SYRS")]"" D
        . S PSJL=$$SETSTR^VALM1("Syr. Size:",PSJL,52,10)_$E(P("SYRS"),1,13)
        . S:$L(P("SYRS"))>13 PSJL=PSJL_"..."
        D SETTMP^PSJLMPRU("PSJI",PSJL)
        D WRTDRG^PSJLIUTL("SOL")
DUR     ;
        S PSJL=""
        N DUROUT,IVLIMIT S DUROUT=$$GETDUR^PSJLIVMD(PSGP,+PSJORD,$S(PSJORD["P":"P",1:"IV"))
        I $G(PSJORD)["P" N ND25 S ND25=$G(^PS(53.1,+PSJORD,2.5)),IVLIMIT=$P(ND25,"^",4) D
        .S IVLIMIT=$S(IVLIMIT]"":$$FMTDUR^PSJLIVMD(IVLIMIT),1:"") S:IVLIMIT]"" DUROUT=IVLIMIT
        S LABEL=$S($G(IVLIMIT):"IV Limit: ",1:"Duration: ") K IVLIMIT
        S PSJL=$$SETSTR^VALM1(LABEL,PSJL,12,10)
        S PSJL=PSJL_DUROUT
START   ;
        D FLDNO^PSJLIUTL("(4)",47)
        S PSJL=$$SETSTR^VALM1("Start:",PSJL,56,7)_$$STARTDT^PSJLIUTL
        D SETTMP^PSJLMPRU("PSJI",PSJL)
        NEW PSGRSD,PSGRSDN,PSGRFD,PSGRFDN
        S PSJL="" I $G(PSJORD)["P",$G(PSGRDTX) D
        . N RSDLABL,PSJRQB,PSJRQL,PSGRSD,PSGSRSDN
        . S RSDLABL="     REQUESTED START: ",PSJRQB=41,PSJRQL=39,PSGRSD="",PSGRSDN=""
        . I $G(PSGRDTX(+$G(PSJORD),"PSGRSD")),$G(P(2)) S PSJRQB=51,PSJRQL=29 D
        .. S PSGRSD=PSGRDTX(+$G(PSJORD),"PSGRSD"),PSGRSDN=$$ENDTC^PSGMI(+PSGRSD),RSDLABL="Calc Start: "
        . I '$G(P(2)),'$P(PSGRDTX,U,3) S PSGRSD=+PSGRDTX,PSGRSDN=$$ENDTC^PSGMI(PSGRSD)
        . I $G(PSGRSD),($G(PSGRSDN)]"") D DSPLYDT^PSJLIVMD(PSJLMX+5,.PSGRSD,.PSGRSDN,RSDLABL,1,PSJRQB,PSJRQL),SETTMP^PSJLMPRU("PSJI",PSJL)
INFRATE ;
        S PSJL="" D FLDNO^PSJLIUTL("(3)",1)
        S PSJL=$$SETSTR^VALM1("Infusion Rate:",PSJL,7,15)
        D LONG^PSJLIUTL(P(8),22,24)
LASTREN ;
        N PSGRNDT S PSGRNDT=$$LASTREN^PSJLMPRI(DFN,$S($G(PSJORD):PSJORD,1:$G(ON))) I PSGRNDT D
        . S PSGRNDT=$$ENDTC^PSGMI(+PSGRNDT),PSJL=$$SETSTR^VALM1("Renewed: "_PSGRNDT,PSJL,54,32)
        D SETTMP^PSJLMPRU("PSJI",PSJL)
MR      ;
        S PSJL="" D FLDNO^PSJLIUTL("(5)",1)
        S PSJL=$$SETSTR^VALM1("Med Route:",PSJL,11,11)
        S PSJL=PSJL_$P(P("MR"),U,2)
STOP    ;
        D FLDNO^PSJLIUTL("(6)",47)
        ;PSJ*5*180 - If Invalid Duration/Limit - Cannot Calculate Stop Date
        S PSJL=$$SETSTR^VALM1("Stop:",PSJL,57,6)_$S($G(PSJBADD)=1:"CANNOT CALCULATE",1:$$STOPDT^PSJLIUTL)
        D SETTMP^PSJLMPRU("PSJI",PSJL)
        S PSJL=""
        N PSJBCMA S PSJBCMA=$$BCMALG^PSJUTL2(DFN,PSJORD)
        I $G(PSJBCMA)]"" S PSJL=$$SETSTR^VALM1(PSJBCMA,PSJL,1,52)
        I $G(PSGRDTX(+PSJORD,"PSGRFD")) S PSGRFD=PSGRDTX(+PSJORD,"PSGRFD"),PSGRFDN=$$ENDTC^PSGMI(PSGRFD) D
        . D DSPLYDT^PSJLIVMD(PSJLMX+7,.PSGRFD,.PSGRFDN," Calc Stop: ",0,51,29)
        D:($G(PSJBCMA)]"")!($G(PSGRFD)]"") SETTMP^PSJLMPRU("PSJI",PSJL)
SCH     ;
        S PSJL="" D FLDNO^PSJLIUTL("(7)",1)
        S PSJL=$$SETSTR^VALM1("Schedule:",PSJL,12,11)
        D LONG^PSJLIUTL(P(9),22,32) S PSJL=PSJL_$S(P(7):"@0 labels a day",1:"")
LASTFL  ;
        S PSJL=$$SETSTR^VALM1("Last Fill:",PSJL,52,11)
        S PSJL=PSJL_$$ENDTC^PSGMI(P("LF"))
        D SETTMP^PSJLMPRU("PSJI",PSJL)
ADM     ;
        S PSJL="" D FLDNO^PSJLIUTL("(8)",1)
        S PSJL=$$SETSTR^VALM1("Admin Times:",PSJL,9,14)
        D LONG^PSJLIUTL(P(11),22,30)
QTY     ;
        S PSJL=$$SETSTR^VALM1("Quantity:",PSJL,53,10)_+P("LFA")
        D SETTMP^PSJLMPRU("PSJI",PSJL)
PROVIDER        ;
        S PSJL="" D FLDNO^PSJLIUTL("(9)",1)
        S PSJL=$$SETSTR^VALM1("Provider:",PSJL,12,10)_$$PROVIDER^PSJLIUTL
CUMDOSES        ;
        S PSJL=$$SETSTR^VALM1("Cum. Doses:",PSJL,51,12)_P("CUM")
        D SETTMP^PSJLMPRU("PSJI",PSJL)
OPI     ;
        S PSJL="" D FLDNO^PSJLIUTL("(10)",1)
        S PSJL=$$SETSTR^VALM1("Other Print"_$S($P(P("OPI"),"^",2)=1:"!: ",1:": "),PSJL,9,13)_$P(P("OPI"),"^")
        D SETTMP^PSJLMPRU("PSJI",PSJL)
PC      ;
        S PSJL=""
        S PSJL=$$SETSTR^VALM1("Provider Comments:",PSJL,3,18) D WTPC^PSJLIUTL
REMARK  ;
        D SETTMP^PSJLMPRU("PSJI","")
        S PSJL="" D FLDNO^PSJLIUTL("(11)",1)
        S PSJL=$$SETSTR^VALM1("Remarks :",PSJL,8,10)
        D LONG^PSJLIUTL(P("REM"),18,62)
        D SETTMP^PSJLMPRU("PSJI",PSJL)
IVROOM  ;
        S PSJL=""
        S PSJL=$$SETSTR^VALM1("IV Room:",PSJL,9,9)_$P(P("IVRM"),U,2)
        D SETTMP^PSJLMPRU("PSJI",PSJL)
ENTRY   ;
        S PSJL="",PSJL=$$SETSTR^VALM1("Entry By:",PSJL,8,10)
        S PSJL=PSJL_$S($P(P("CLRK"),U,2)]"":$E($P(P("CLRK"),U,2),1,18),1:"*** Undefined")
        S PSJL=$$SETSTR^VALM1("Entry Date:",PSJL,51,12)_$$ENDTC^PSGMI(P("LOG"))
        D SETTMP^PSJLMPRU("PSJI",PSJL)
        S PSJL="" S PSGLRN=$$LASTRNBY^PSJLMPRI(DFN,$S($G(PSJORD):PSJORD,1:$G(ON))) I PSGLRN D
        . S PSJL=$$SETSTR^VALM1("Renewed By: ",PSJL,6,12)_$$ENNPN^PSGMI(PSGLRN) D SETTMP^PSJLMPRU("PSJI",PSJL) K PSGLRN
        S VALM("TITLE")=$$CODES^PSIVUTL(P(17),$S($G(ON)["P":53.1,1:55.01),$S(ON["P":28,1:100))_" IV "
        I $G(P("PRY"))="D"!($G(P("PON"))["P") S VALM("TITLE")=VALM("TITLE")_$S($G(P("PRY"))="":"",1:"("_$$CODES^PSIVUTL(P("PRY"),53.1,.24)_")")
        I $G(P("PON"))["P" D ORDCHK
        S VALMCNT=PSJLN-1,^TMP("PSJI",$J,0)=VALMCNT
        Q
        ;
ORDCHK  ;Display order check for pending order
        Q:'$O(^PS(53.1,+ON,10,0))
        NEW PSJIVX,PSJIVXX
        F PSJIVX=0:0 S PSJIVX=$O(^PS(53.1,+ON,10,PSJIVX)) Q:'PSJIVX  D
        . D SETTMP^PSJLMPRU("PSJI","")
        . S PSJL="Order Checks       :" D LONG^PSJLIUTL($G(^PS(53.1,+ON,10,PSJIVX,0)),22,60)
        . D SETTMP^PSJLMPRU("PSJI",PSJL)
        . S PSJL="Overriding Provider: "_$P($G(^PS(53.1,+ON,10,PSJIVX,1)),U)
        . D SETTMP^PSJLMPRU("PSJI",PSJL)
        . S PSJL="Overriding Reason  : "
        . F PSJIVXX=0:0 S PSJIVXX=$O(^PS(53.1,+ON,10,PSJIVX,2,PSJIVXX)) Q:'PSJIVXX  D
        .. D LONG^PSJLIUTL($G(^PS(53.1,+ON,10,PSJIVX,2,PSJIVXX,0)),22,60)
        .. D SETTMP^PSJLMPRU("PSJI",PSJL) S PSJL=""
        Q
        ;
SCHREQ(IVAR)    ;
        I $G(IVAR(4))="P"!($G(IVAR(23))="P")!($G(IVAR(5))) Q 1
        Q 0
