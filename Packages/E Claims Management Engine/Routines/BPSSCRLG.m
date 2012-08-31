BPSSCRLG        ;BHAM ISC/SS - ECME LOGINFO ;05-APR-05
        ;;1.0;E CLAIMS MGMT ENGINE;**1,5,7**;JUN 2004;Build 46
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
        ;
EN      ; -- main entry point for BPS LSTMN LOG
        D EN^VALM("BPS LSTMN LOG")
        Q
        ;
HDR     ; -- header code
        S VALMHDR(1)="Claim Log information"
        S VALMHDR(2)=""
        Q
        ;
INIT    ; -- init variables and list array
        N BPSELCLM,LINE
        S BPSELCLM=$G(@VALMAR@("SELLN"))
        ;  piece 2: patient ien #2
        ;  piece 3: insurance ien #36
        ;  piece 4: ptr to #9002313.59
        S LINE=1
        S VALMCNT=$$PREPINFO(.LINE,$P(BPSELCLM,U,2),$P(BPSELCLM,U,3),$P(BPSELCLM,U,4))
        S:VALMCNT>1 VALMCNT=VALMCNT-1
        Q
        ;
HELP    ; -- help code
        S X="?" D DISP^XQORM1 W !!
        K X
        Q
        ;
EXIT    ; -- exit code
        Q
        ;
EXPND   ; -- expand code
        Q
        ;
        ;
LOG     ;entry point for LOG menu option of the main User Screen
        N BPRET,BPSEL
        I '$D(@(VALMAR)) Q
        D FULL^VALM1
        W !,"Enter the line number for which you wish to print claim logs."
        S BPSEL=$$ASKLINE^BPSSCRU4("Select item","C","Please select SINGLE Rx Line.")
        I BPSEL<1 S VALMBCK="R" Q
        D SAVESEL(BPSEL,VALMAR)
        D EN
        S VALMBCK="R"
        Q
        ;
        ;save selection in order to use inside enclosed ListManager copy
        ;BPSEL - selected line
        ;BPVALMR - parent VALMAR 
SAVESEL(BPSEL,BPVALMR)  ;
        D CLEANIT
        S ^TMP("BPSLOG",$J,"VALM","SELLN")=BPSEL
        S ^TMP("BPSLOG",$J,"VALM","PARENT")=BPVALMR
        M ^TMP("BPSLOG",$J,"VALM","VIEWPARAMS")=@BPVALMR@("VIEWPARAMS")
        Q
        ;
CLEANIT ;
        K ^TMP("BPSLOG",$J,"VALM")
        Q
        ;input:
        ; BPDFN: patient ien #2
        ; BP36: insurance ien #36
        ; BP59: ptr to #9002313.59
        ; returns number of lines
PREPINFO(BPLN,BPDFN,BP36,BP59)  ;
        I '$G(BP59) Q 0
        I '$G(BP36) Q 0
        I '$G(BPDFN) Q 0
        N BPSCRLNS S BPSCRLNS=17 ;(see "BPS LSTMN LOG" LM template: Bottom=21, Top = 4, 21-4=17)
        N BPX,BPRXIEN,BPREF,BP1,BPLSTCLM,BPLSTRSP,BPDAT59,BPUSR,BPSTRT,BPHIST,BPQ
        N BPDT,BPLN0,BPCNT
        S BP1=$$RXREF^BPSSCRU2(BP59)
        S BPRXIEN=$P(BP1,U,1)
        S BPREF=$P(BP1,U,2)
        S BPDAT59(0)=$G(^BPST(BP59,0))
        ;create a history
        D MKHIST^BPSSCRU5(BP59,.BPHIST)
        ;
        S BPLN0=BPLN
        D SETLINE(.BPLN,"Pharmacy ECME Log")
        D SETLINE(.BPLN,"")
        S BPX=$$RJ^BPSSCR02("VA Rx #: ",19)_$$LJ^BPSSCR02($$RXNUM^BPSSCRU2(+BPRXIEN),13)
        S BPX=BPX_$$RJ^BPSSCR02("Fill #: ",10)_$$LJ^BPSSCR02(BPREF,4)
        S BPX=BPX_$$RJ^BPSSCR02("ECME Claim Rx #: ",18)_$$LJ^BPSSCR02(BP59,20)
        D SETLINE(.BPLN,BPX)
        S BPX=$$RJ^BPSSCR02("Patient Name: ",19)
        S BPX=BPX_$$LJ^BPSSCR02($$PATNAME^BPSSCRU2(BPDFN)_" "_$$SSN4^BPSSCRU2(BPDFN),30)
        D SETLINE(.BPLN,BPX)
        S BPX=$$RJ^BPSSCR02("Last Submitted: ",19)
        S BPSTRT=$P(BPDAT59(0),U,11) ;@# need to check with analyst if this is a START DATE
        I BPSTRT]"" S BPX=BPX_$$DATETIME^BPSSCRU5(BPSTRT)
        D SETLINE(.BPLN,BPX)
        S BPX=$$RJ^BPSSCR02("Last Submitted By: ",19)
        S BPUSR=$P(BPDAT59(0),U,10)
        I BPUSR]"" S BPX=BPX_$$GETUSRNM^BPSSCRU1(BPUSR)
        D SETLINE(.BPLN,BPX)
        ;
        ;find the latest claim
        S BP1=+$O(BPHIST("C",99999999),-1)
        I BP1=0 D SETLINE(.BPLN,""),SETLINE(.BPLN,"------ No electronic claims ------") Q BPLN
        S BP1=+$O(BPHIST("C",BP1,0))
        S BPX=$$RJ^BPSSCR02("Last VA Claim #: ",19)_$P($G(^BPSC(+BP1,0)),U,1)
        D SETLINE(.BPLN,BPX)
        F BPCNT=BPLN:1:BPLN0+BPSCRLNS D SETLINE(.BPLN,"")
        ;process history
        N BPTYPE,BPIEN,BPIENRS
        S BPDT=99999999
        F  S BPDT=$O(BPHIST("C",BPDT),-1) Q:+BPDT=0  D
        . S BPIEN=+$O(BPHIST("C",BPDT,0)) Q:BPIEN=""
        . D DISPCLM(.BPLN,BP59,BPIEN,+BPHIST("C",BPDT,BPIEN),$P(BPHIST("C",BPDT,BPIEN),U,2),BPDT)
        . S BPIENRS=0
        . F  S BPIENRS=$O(BPHIST("C",BPDT,BPIEN,"R",BPIENRS)) Q:+BPIENRS=0  D
        . . D DISPRSP(.BPLN,BP59,BPIENRS,+BPHIST("C",BPDT,BPIEN,"R",BPIENRS),$P(BPHIST("C",BPDT,BPIEN,"R",BPIENRS),U,2),BPDT)
        Q BPLN
        ;calls SET^VALM10,
        ;increments BPLINE
SETLINE(BPLINE,BPSTR)   ;
        D SET^VALM10(BPLINE,BPSTR)
        S BPLINE=BPLINE+1
        Q
        ;display claim record
DISPCLM(BPLN,BP59,BPIEN02,BP57,BPSTYPE,BPSDTALT)        ;
        N BPSCRLNS S BPSCRLNS=17 ;(see "BPS LSTMN LOG" LM template: Bottom=21, Top = 4, 21-4=17)
        N BPX,BPLN0,BPCNT,BPSTR1,BPSTYP2
        S BPLN0=BPLN
        S BPSTYP2=$S(BPSTYPE="C":"CLAIM REQUEST",BPSTYPE="R":"REVERSAL",1:"")
        S BPSTR1="Transmission Information ("_BPSTYP2_")(#"_BPIEN02_")"
        D SETLINE(.BPLN,BPSTR1_$$LINE^BPSSCRU3(79-$L(BPSTR1),"-"))
        D SETLINE(.BPLN,"")
        D SETLINE(.BPLN,"Created on: "_$$CREATEDT(BPIEN02,BPSDTALT))
        D SETLINE(.BPLN,"VA Claim ID: "_$P($G(^BPSC(+BPIEN02,0)),U,1))
        D SETLINE(.BPLN,"Submitted By: "_$$SUBMTBY(BP57))
        D SETLINE(.BPLN,"Transaction Type: "_$$TRTYPE^BPSSCRU5($$TRCODE(BPIEN02)))
        D SETLINE(.BPLN,"Date of Service: "_$$DOSCLM(BPIEN02))
        D SETLINE(.BPLN,"NDC: "_$$LNDC^BPSSCRU5(BPIEN02))
        D SETLINE(.BPLN,"ECME Pharmacy: "_$$DIVNAME^BPSSCRDS($$LDIV(BP57)))
        D SETLINE(.BPLN,"Days Supply: "_$$DAYSSUPL(BPIEN02))
        S BPX="Qty: "_$$QTY(BP57)
        S BPX=BPX_"     Unit Price: "_$$UNTPRICE(BP57)
        S BPX=BPX_"     Total Price: "_$$TOTPRICE(BP57)
        D SETLINE(.BPLN,BPX)
        D SETLINE(.BPLN,"")
        D SETLINE(.BPLN,"Insurance Name: "_$$INSUR57(BP57))
        D SETLINE(.BPLN,"BIN: "_$$BIN(BPIEN02))
        D SETLINE(.BPLN,"PCN: "_$$PCN(BPIEN02))
        D SETLINE(.BPLN,"Group ID: "_$$GRPID(BPIEN02))
        D SETLINE(.BPLN,"Cardholder ID: "_$$CRDHLDID(BPIEN02))
        D SETLINE(.BPLN,"Patient Relationship Code: "_$$PATRELSH(BPIEN02,BP57))
        D SETLINE(.BPLN,"Cardholder First Name: "_$$CRDHLDFN(BPIEN02,BP57))
        D SETLINE(.BPLN,"Cardholder Last Name: "_$$CRDHLDLN(BPIEN02,BP57))
        F BPCNT=BPLN:1:BPLN0+BPSCRLNS D SETLINE(.BPLN,"")
        S BPLN0=BPLN
        D SETLINE(.BPLN,"Plan ID: "_$$PLANID(BP57))
        D SETLINE(.BPLN,"Payer Sheet IEN: "_$$PYRIEN^BPSSCRU5(BPIEN02))
        D SETLINE(.BPLN,"B2 Payer Sheet IEN: "_$$B2PYRIEN^BPSSCRU5(BPIEN02,BP57))
        D SETLINE(.BPLN,"B3 Rebill Payer Sheet: "_$$B3PYRIEN^BPSSCRU5(BPIEN02,BP59,BP57))
        D SETLINE(.BPLN,"Certify Mode: "_$$CERTMOD(BP57))
        D SETLINE(.BPLN,"Cert IEN: "_$$CERTIEN(BP57))
        F BPCNT=BPLN:1:BPLN0+BPSCRLNS D SETLINE(.BPLN,"")
        Q
        ;Submitted By User from Log of Transactions file
SUBMTBY(BP57)   ;
        N BPIEN,BPUSR
        S BPIEN=$P($G(^BPSTL(BP57,0)),U,10)
        S BPUSR=$$GETUSRNM^BPSSCRU1(BPIEN)
        Q $S(BPUSR']"":"UNKNOWN",1:BPUSR)
        ;
        ;Date os service date in BPS CLAIM file
DOSCLM(BPIEN02) ;
        N BPDT
        S BPDT=$P($G(^BPSC(BPIEN02,400,1,400)),U,1)\1
        Q $E(BPDT,5,6)_"/"_$E(BPDT,7,8)_"/"_$E(BPDT,1,4)
        ;record created on 
CREATEDT(BPIEN02,BPSDTALT)      ;
        N BPSDT
        S BPSDT=+$P($G(^BPSC(BPIEN02,0)),U,6)
        Q $$DATETIME^BPSSCRU5($S(BPSDT>0:BPSDT,1:BPSDTALT))
        Q
        ;Plan ID from #9002313.57
PLANID(BP57)    ;
        Q $P($G(^BPSTL(BP57,10,+$G(^BPSTL(BP57,9)),0)),U,1)
        ;
CERTMOD(BP57)   ;
        Q $P($G(^BPSTL(BP57,10,+$G(^BPSTL(BP57,9)),0)),U,5)
        ;Software Vendor/Cert ID
CERTIEN(BP57)   ;
        Q $P($G(^BPSTL(BP57,10,+$G(^BPSTL(BP57,9)),0)),U,6)
        ;group ID
GRPID(BPIEN02)  ;
        Q $E($P($G(^BPSC(BPIEN02,300)),U,1),3,99)
        ;
        ;Cardholder ID
CRDHLDID(BPIEN02)       ;
        Q $E($P($G(^BPSC(BPIEN02,300)),U,2),3,99)
        ;Cardholder First name
CRDHLDFN(BPIEN02,BP57)  ;
        N Y
        S Y=$P($G(^BPSC(BPIEN02,300)),U,12)
        I $L(Y)=0 S Y=$P($G(^BPSTL(BP57,10,+$G(^BPSTL(BP57,9)),1)),U,6)
        Q Y
        ;Cardholder Last  Name
CRDHLDLN(BPIEN02,BP57)  ;
        N Y
        S Y=$P($G(^BPSC(BPIEN02,300)),U,13)
        I $L(Y)=0 S Y=$P($G(^BPSTL(BP57,10,+$G(^BPSTL(BP57,9)),1)),U,7)
        Q Y
        ;Patient Relationship Code
PATRELSH(BPIEN02,BP57)  ;
        N Y
        S Y=$P($G(^BPSC(BPIEN02,300)),U,6)
        I $L(Y)=0 S Y=$P($G(^BPSTL(BP57,10,+$G(^BPSTL(BP57,9)),1)),U,5)
        Q $S(Y=1:"CARDHOLDER",Y=2:"SPOUSE",Y=3:"CHILD",1:Y)
        ;
PCN(BPIEN02)    ;
        Q $P($G(^BPSC(BPIEN02,100)),U,4)
        ;
BIN(BPIEN02)    ;
        Q $P($G(^BPSC(BPIEN02,100)),U,1)
        ;insurance name by 9002313.57 pointer
INSUR57(BPIEN57)        ;
        N BPINSN
        S BPINSN=+$G(^BPSTL(BPIEN57,9))
        Q $P($G(^BPSTL(BPIEN57,10,BPINSN,0)),U,7)
        ;
QTY(BPIEN57)    ;
        Q +$P($G(^BPSTL(BPIEN57,5)),U,1)
UNTPRICE(BPIEN57)       ;
        Q +$P($G(^BPSTL(BPIEN57,5)),U,2)
TOTPRICE(BPIEN57)       ;
        Q +$P($G(^BPSTL(BPIEN57,5)),U,5)
        ;get ECME pharmacy division ptr for LOG
LDIV(BPIEN57)   ;
        Q +$P($G(^BPSTL(BPIEN57,1)),U,7)
        ;transaction code
TRCODE(BPIEN02) ;
        Q $P($G(^BPSC(BPIEN02,100)),U,3)
        ;days supply
DAYSSUPL(BPIEN02)       ;
        ;format D5NNN -> NNN
        Q +$E($P($G(^BPSC(BPIEN02,400,1,400)),U,5),3,99)
        ;
        ;display response record
DISPRSP(BPLN,BP59,BPIEN03,BP57,BPSTYPE,BPSDTALT)        ;
        N BPSCRLNS S BPSCRLNS=17 ;(see "BPS LSTMN LOG" LM template: Bottom=21, Top = 4, 21-4=17)
        N BPX,BPLN0,BPCNT,BPRJCDS,BPRJ,BPSTR1,BPSTYP2
        S BPLN0=BPLN
        S BPSTYP2=$S(BPSTYPE="C":"CLAIM REQUEST",BPSTYPE="R":"REVERSAL",1:"")
        S BPSTR1="Response Information  ("_BPSTYP2_")(#"_BPIEN03_")"
        D SETLINE(.BPLN,BPSTR1_$$LINE^BPSSCRU3(79-$L(BPSTR1),"-"))
        D SETLINE(.BPLN,"")
        D SETLINE(.BPLN,"Response Received: "_$$RESPREC(BPIEN03,BPSDTALT))
        D SETLINE(.BPLN,"Date of Service: "_$$DOSRSP(BPIEN03))
        D SETLINE(.BPLN,"Transaction Response Status: "_$$RESPSTAT^BPSSCRU5(BPIEN03))
        D SETLINE(.BPLN,"Total Amount Paid: $"_+$$TOTAMNT(BPIEN03,BP59,BP57))
        D SETLINE(.BPLN,"Reject code(s): ")
        D REJCODES^BPSSCRU5(BPIEN03,.BPRJCDS)
        S BPRJ=""
        F  S BPRJ=$O(BPRJCDS(BPRJ)) Q:BPRJ=""  D
        . D SETLINE(.BPLN," "_$$GETRJNAM^BPSSCRU3(BPRJ))
        D WRAPLN^BPSSCRU5(.BPLN,$$MESSAGE(BPIEN03),76,"Message: ",5)
        D WRAPLN^BPSSCRU5(.BPLN,$$ADDMESS(BPIEN03),76,"Additional Message: ",5)
        ;D WRAPLN^BPSSCRU5(.BPLN,$$DUR(BPIEN03),60,"DUR Information: ",5)
        D WRAPLN^BPSSCRU5(.BPLN,$$DURRESP(BPIEN03),76,"DUR Response Info: ",5)
        F BPCNT=BPLN:1:BPLN0+BPSCRLNS D SETLINE(.BPLN,"")
        Q
        ;
RESPREC(BPIEN03,BPSDTALT)       ;
        N BPSDT
        S BPSDT=+$P($G(^BPSR(BPIEN03,0)),U,2)
        Q $$DATETIME^BPSSCRU5($S(BPSDT>0:BPSDT,1:BPSDTALT))
        ;
DOSRSP(BPIEN03) ;
        N BPDT
        S BPDT=$P($G(^BPSR(BPIEN03,400)),U,1)\1
        Q $E(BPDT,5,6)_"/"_$E(BPDT,7,8)_"/"_$E(BPDT,1,4)
        ;
TOTAMNT(BPIEN03,BP59,BP57)      ;
        Q $$DFF2EXT^BPSECFM($P($G(^BPSR(BPIEN03,1000,1,500)),U,9))
        ;
MESSAGE(BPIEN03)        ;
        Q $P($G(^BPSR(BPIEN03,504)),U)
        ;
ADDMESS(BPIEN03)        ;
        Q $P($G(^BPSR(BPIEN03,1000,1,526)),U)
        ;
DUR(BPIEN03)    ;
        Q "???"
        ;
DURRESP(BPIEN03)        ;
        Q $P($G(^BPSR(BPIEN03,1000,1,525)),U)
