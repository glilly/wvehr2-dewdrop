BPSRPT5 ;BHAM ISC/BEE - ECME REPORTS ;14-FEB-05
        ;;1.0;E CLAIMS MGMT ENGINE;**1,3,5,7**;JUN 2004;Build 46
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;Routine to Display the Reports
        ;
        ;Print Report Line 1
WRLINE1(BPRTYPE,BPREC,BPDIV,BPGRPLAN,BPDFN,BPRX,BPREF,BPX,BPSRTDT,BPBIL,BPINS,BPCOLL,BPEXCEL)   ;
        ;Excel Output
        I $G(BPEXCEL) D WRLINE1^BPSRPT8(BPRTYPE,.BPREC,BPDIV,BPGRPLAN,BPDFN,BPRX,BPREF,BPX,BPSRTDT,BPBIL,BPINS,BPCOLL) Q
        ;Report Output
        W !,$$PATNAME^BPSRPT6(BPDFN)
        W ?27,"("_$$SSN4^BPSRPT6(BPDFN)_")"
        W ?35,$$RXNUM^BPSRPT6(BPRX)_$$COPAY^BPSRPT6(BPRX)
        W ?47,BPREF,"/",$$ECMENUM^BPSRPT1($P(BPX,U,3))
        I (BPRTYPE=1)!(BPRTYPE=4) D  Q
        . W ?68,$$DATTIM^BPSRPT1(BPSRTDT)
        . W ?78,$J(BPBIL,10,2),?100,$J(BPINS,10,2),?122,$S(BPCOLL]"":$J(BPCOLL,10,2),1:"")
        I BPRTYPE=2 D  Q
        . W ?68,$$DATTIM^BPSRPT1(BPSRTDT)
        . W ?78,$$DATTIM^BPSRPT1(+BPX)
        . W ?91,$$MWC^BPSRPT6(BPRX,BPREF)
        . W ?94,$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))
        . W ?98,$$RXSTATUS^BPSRPT6($P(BPX,U,3))
        . W ?101,$S($P(BPX,U):"/RL",1:"/NR")
        . W ?109,$S($$CLOSED02^BPSSCR03($P(^BPST($P(BPX,U,3),0),U,4))=1:"Closed",1:"Open")
        . W ?124,$S($$ELIGCODE^BPSSCR05($P(BPX,U,3))="V":"Vet",$$ELIGCODE^BPSSCR05($P(BPX,U,3))="T":"Tri",1:"UNK")
        I BPRTYPE=3 D  Q
        . W ?68,$$DATTIM^BPSRPT1(BPSRTDT)
        . W ?100,$J(BPBIL,10,2),?122,$J(BPINS,10,2)
        I BPRTYPE=5 D  Q
        . W ?60,$$DATTIM^BPSRPT1($$TRANDT^BPSRPT2($P(BPX,U,3),1))
        . W ?78,$$TTYPE^BPSRPT7($P(BPX,U,4),$P(BPX,U,5))
        . W ?95,$$RESPONSE^BPSRPT7($P(BPX,U,4),$P(BPX,U,5))
        I BPRTYPE=7 D  Q
        . W ?65,$$MWC^BPSRPT6(BPRX,BPREF)
        . W ?68,$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))
        . W ?72,$$RXSTATUS^BPSRPT6($P(BPX,U,3))
        . W ?75,$S($P(BPX,U):"/RL",1:"/NR")
        . W ?79,$S($P(BPX,U,13):"REJ",1:"")
        . W ?87,$$DRGNAM^BPSRPT6($P(BPX,U,14),30)
        . W ?118,$$GETNDC^BPSRPT6(BPRX,BPREF)
        Q
        ;
        ;Print Report Line 2
WRLINE2(BPRTYPE,BPREC,BPX,BPRX,BPREF,BPBIL,BPGRPLAN,BPEXCEL,BPICNT)     ;
        ;Excel Output
        I $G(BPEXCEL) D WRLINE2^BPSRPT8(BPRTYPE,.BPREC,BPX,BPRX,BPREF,BPBIL,BPGRPLAN) Q
        ;Report Output
        I (BPRTYPE=1)!(BPRTYPE=4) D  Q
        . W !,?4,$$DRGNAM^BPSRPT6($P(BPX,U,14),27),?32,$$GETNDC^BPSRPT6(BPRX,BPREF)
        . I BPRTYPE=1 W ?47,$$DATTIM^BPSRPT1(+BPX)
        . W ?68,$$MWC^BPSRPT6(BPRX,BPREF)
        . W ?71,$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))
        . W ?75,$$RXSTATUS^BPSRPT6($P(BPX,U,3))
        . W ?78,$S($P(BPX,U):"/RL",1:"/NR")
        . W ?82,$S($P(BPX,U,13):"REJ",1:"")
        . I BPRTYPE=1 W ?122,$J($$BILL^BPSRPT6(BPRX,BPREF),10)
        I BPRTYPE=2 D  Q
        . W !,?3,$E($$CRDHLDID^BPSRPT2(+$P(BPX,U,3)),3,23)
        . W ?31,$E($$GRPID^BPSRPT2(+$P(BPX,U,3)),3,10)
        . W ?41,$J(BPBIL,10,2)
        . W ?54,$$QTY^BPSRPT6($P(BPX,U,3))
        . W ?61,$$GETNDC^BPSRPT6(BPRX,BPREF)
        . W ?82,$$DRGNAM^BPSRPT6($P(BPX,U,14),32)
        I BPRTYPE=3 D  Q
        . W !,?4,$$DRGNAM^BPSRPT6($P(BPX,U,14),32)
        . W ?41,$$GETNDC^BPSRPT6(BPRX,BPREF)
        . W ?68,$$MWC^BPSRPT6(BPRX,BPREF)
        . W ?71,$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))
        . W ?74,$$RXSTATUS^BPSRPT6($P(BPX,U,3))
        . W ?77,$S($P(BPX,U):"/RL",1:"/NR")
        . W ?81,$S($P(BPX,U,13):"REJ",1:"")
        I BPRTYPE=5 D  Q
        . W !,?4,$$DRGNAM^BPSRPT6($P(BPX,U,14),23)
        . W ?28,$$GETNDC^BPSRPT6(BPRX,BPREF)
        . W ?47,$$MWC^BPSRPT6(BPRX,BPREF)
        . W ?50,$$RTBCKNAM^BPSRPT1($$RTBCK^BPSRPT1($P(BPX,U,3)))
        . W ?53,$$RXSTATUS^BPSRPT6($P(BPX,U,3))
        . W ?56,$S($P(BPX,U):"/RL",1:"/NR")
        . W ?60,$S($P(BPX,U,13):"REJ",1:"")
        . I $P(BPGRPLAN,U,2)]"" W ?69,$E($P(BPGRPLAN,U,2),1,30)
        . W ?122,$J($$ELAPSE^BPSRPT6($P(BPX,U,3)),10)
        I BPRTYPE=7 D  Q
        . W !,?3,$E($$CRDHLDID^BPSRPT2(+$P(BPX,U,3)),3,23)
        . W ?31,$E($$GRPID^BPSRPT2(+$P(BPX,U,3)),3,10)
        . W ?41,$$DATTIM^BPSRPT1(+$$CLOSEDT^BPSRPT2(+$P(BPX,U,3)))
        . N BPCLBY S BPCLBY=$E($$CLSBY^BPSRPT6(+$P(BPX,U,3)),1,25) S:BPCLBY="" BPCLBY="BLANK"
        . W ?59,BPCLBY S BPCNT(BPCLBY)=$G(BPCNT(BPCLBY))+1,BPGCNT(BPCLBY)=$G(BPGCNT(BPCLBY))+1,BPICNT(BPCLBY)=$G(BPICNT(BPCLBY))+1
        . W ?87,$E($P($$CLRSN^BPSRPT7(+$P(BPX,U,3)),U,2),1,30)
        Q
        ;
        ;Print Report Line 3
WRLINE3(BPRTYPE,BPREC,BPX,BPEXCEL)      N BP59
        S BP59=+$P(BPX,U,3)
        ;Excel Output
        I $G(BPEXCEL) D WRLINE3^BPSRPT8(BPRTYPE,.BPREC,BPX) Q
        ;Report Output
        I BPRTYPE=4 D
        . S NP=$$CHKP(1) Q:BPQ
        . ;Released On
        . W !,?6,$$DATTIM^BPSRPT1(+BPX)
        . ;Method
        . I $$AUTOREV^BPSRPT1(BP59) W ?22,"AUTO/"
        . E  W ?22,"REGULAR/"
        . ;Return Status
        . I $P(BPX,U,15)["ACCEPTED" W "ACCEPTED/"
        . E  W "REJECTED/"
        . ;Reason
        . W $$RVSRSN^BPSRPT7(+$P(BPX,U,3))
        Q
        ;
        ;Display the Report
REPORT(REF,BPEXCEL,BPSCR,BPRPTNAM,BPSUMDET,BPPAGE)      N BPBIL,BPBLINE,BPCOLL,BPDFN,BPDIV,BPELTM,BPGELTM,BPGBIL,BPGINS,BPGCOLL,BPGCNT,BPGRPLAN,BPINS,BPLINES,BPREC,BPREF,BPRX,BPSRTDT,BPSTATUS,BPTBIL,BPTCOLL,BPTINS,BPX,BPSGTOT,NP,BPSDATA
        I '$D(@REF) D HDR^BPSRPT7(BPRTYPE,BPRPTNAM,.BPPAGE) W !,"No data meets the criteria." G XREPORT
        S (BPGBIL,BPGINS,BPGCOLL,BPGCNT,BPGELTM)=0
        S BPDIV="" F  S BPDIV=$O(@REF@(BPDIV)) Q:BPDIV=""  D  Q:BPQ
        .S BPGRPLAN=0 D HDR^BPSRPT7(BPRTYPE,BPRPTNAM,.BPPAGE)
        .N BPCNT S (BPTBIL,BPTINS,BPTCOLL,BPCNT,BPELTM)=0
        .F  S BPGRPLAN=$O(@REF@(BPDIV,BPGRPLAN)) Q:BPGRPLAN=""  D  Q:BPQ
        .. I BPSUMDET=0 D WRPLAN(BPGRPLAN) Q:BPQ
        .. S BPBLINE=""  ;Reset Blank Line Indicator
        .. N BPSCLM,BPREC,BPTOT,BPIBIL,BPICNT,BPICOL,BPIINS
        .. S (BPIBIL,BPICNT,BPICOL,BPIINS)=0
        .. S BPDFN="" F  S BPDFN=$O(@REF@(BPDIV,BPGRPLAN,BPDFN)) Q:BPDFN=""  D  Q:BPQ
        ... S BPSRTDT="" F  S BPSRTDT=$O(@REF@(BPDIV,BPGRPLAN,BPDFN,BPSRTDT)) Q:BPSRTDT=""  D  Q:BPQ
        .... S BPRX="" F  S BPRX=$O(@REF@(BPDIV,BPGRPLAN,BPDFN,BPSRTDT,BPRX)) Q:BPRX=""  D  Q:BPQ
        ..... S BPREF="" F  S BPREF=$O(@REF@(BPDIV,BPGRPLAN,BPDFN,BPSRTDT,BPRX,BPREF)) Q:BPREF=""  D  Q:BPQ
        ...... S BPX=@REF@(BPDIV,BPGRPLAN,BPDFN,BPSRTDT,BPRX,BPREF)
        ...... S BPCNT=BPCNT+1,BPGCNT=BPGCNT+1,BPICNT=BPICNT+1
        ...... I BPRTYPE=5 D
        ....... S BPELTM=BPELTM+$$ELAPSE^BPSRPT6($P(BPX,U,3))
        ....... S BPGELTM=BPGELTM+$$ELAPSE^BPSRPT6($P(BPX,U,3))
        ...... S BPBIL=$$BILLED^BPSRPT7($P(BPX,U,3)),BPTBIL=BPTBIL+BPBIL,BPGBIL=BPGBIL+BPBIL,BPIBIL=BPIBIL+BPBIL
        ...... S BPINS=$$INSPAID^BPSRPT2($P(BPX,U,3)),BPTINS=BPTINS+BPINS,BPGINS=BPGINS+BPINS,BPIINS=BPIINS+BPINS
        ...... S BPCOLL=$$COLLECTD^BPSRPT6(BPRX,BPREF),BPTCOLL=BPTCOLL+BPCOLL,BPGCOLL=BPGCOLL+BPCOLL,BPICOL=BPICOL+BPCOLL
        ...... I BPRTYPE=6 D  Q
        .......S BPSTATUS=$P(BPX,U,7)
        .......I BPSTATUS["REJECT" S $P(BPSCLM(BPSRTDT),U,3)=$P($G(BPSCLM(BPSRTDT)),U,3)+BPBIL
        .......I BPSTATUS["PAYABLE" S $P(BPSCLM(BPSRTDT),U,4)=$P($G(BPSCLM(BPSRTDT)),U,4)+BPBIL
        .......S $P(BPSCLM(BPSRTDT),U,2)=$P($G(BPSCLM(BPSRTDT)),U,2)+BPBIL
        .......S $P(BPSCLM(BPSRTDT),U,5)=$P($G(BPSCLM(BPSRTDT)),U,5)+BPINS
        .......S $P(BPSCLM(BPSRTDT),U)=$P($G(BPSCLM(BPSRTDT)),U)+1
        ...... ;
        ...... ;Display Detail Section
        ...... Q:BPSUMDET=1
        ...... S BPREC=""  ;Reset Excel Display Variable
        ...... I 'BPEXCEL,BPRTYPE=1,BPBLINE=1 S NP=$$CHKP(2) Q:BPQ  I BPBLINE=1 W !  ;Print blank line
        ...... S NP=$$CHKP(1) Q:BPQ  D WRLINE1(BPRTYPE,.BPREC,BPDIV,BPGRPLAN,BPDFN,BPRX,BPREF,BPX,BPSRTDT,BPBIL,BPINS,BPCOLL,BPEXCEL)
        ...... S NP=$$CHKP(1) Q:BPQ  D WRLINE2(BPRTYPE,.BPREC,BPX,BPRX,BPREF,BPBIL,BPGRPLAN,BPEXCEL,.BPICNT)
        ...... D WRLINE3(BPRTYPE,.BPREC,BPX,BPEXCEL)
        ...... I (",2,7,")[BPRTYPE,'BPEXCEL D  Q:BPQ
        ....... D COMMENT(+$P(BPX,U,3)) Q:BPQ
        ....... S NP=$$CHKP(1) Q:BPQ
        ....... W !,?10,"Claim ID: ",$$CLAIMID^BPSRPT2(+$P(BPX,U,3))
        ....... N BPSARR,BPRJCNT,BPZZ S BPRJCNT=$$REJTEXT^BPSRPT2(+$P(BPX,U,3),.BPSARR)
        ....... F BPZZ=1:1:BPRJCNT S NP=$$CHKP(1) Q:BPQ  W !,?10,BPSARR(BPZZ) Q:BPQ
        ...... I 'BPEXCEL,BPRTYPE=1 S BPBLINE=1  ;Set Blank Line Display Indicator
        .. I BPRTYPE=6 D PTBDT^BPSRPT7(BPDIV,BPSUMDET,.BPSCLM,.BPSGTOT)
        .. I 'BPQ,(",1,2,3,4,7,")[BPRTYPE,'BPEXCEL S NP=$$CHKP(5) Q:BPQ  D ITOT^BPSRPT8(BPRTYPE,BPDIV,BPGRPLAN,BPIBIL,BPIINS,BPICOL,.BPICNT)
        .I 'BPEXCEL,'BPQ,BPRTYPE'=6 S NP=$$CHKP(5) Q:BPQ  D TOTALS^BPSRPT7(BPRTYPE,BPDIV,BPTBIL,BPTINS,BPTCOLL,.BPCNT,BPELTM)
        .I 'BPEXCEL,'BPQ,$O(@REF@(BPDIV))]"" D:$G(BPSCR) PAUSE^BPSRPT1 Q:BPQ
        ;Print Grand Totals
        I 'BPEXCEL D
        .I 'BPQ,BPRTYPE=6 D PGTOT6^BPSRPT7($G(BPSGTOT))
        .I 'BPQ,BPRTYPE'=6 S NP=$$CHKP(5) Q:BPQ  D PGTOT^BPSRPT7(BPRTYPE,BPGBIL,BPGINS,BPGCOLL,.BPGCNT,BPGELTM)
        ;
XREPORT Q
        ;
        ;Display Comments
        ;Input Variable: BP59 - Lookup to BPS TRANSACTION (#59)
COMMENT(BP59)   N CNODE,I,J,NP
        S I="" F  S I=$O(^BPST(BP59,11,"B",I),-1) Q:'I  D  Q:BPQ
        .S NP=$$CHKP(1) Q:BPQ
        .S J=$O(^BPST(BP59,11,"B",I,"")) Q:J=""
        .S CNODE=$G(^BPST(BP59,11,J,0))
        .W !,?10,$$DATTIM^BPSRPT1(+$P($P(CNODE,U),"."))," - ",$P(CNODE,U,3)
        Q
        ;
        ;Display the Insurance
        ; Input Variable -> BPSDATA -> if 0, skip page check
        ;                   BPEXCEL -> 1 - Print to Excel/0 Regular Display
WRPLAN(BPGRPLAN)        N INS,NP
        ;
        I BPSUMDET'=0 Q
        I BPEXCEL Q
        ;Skip for Recent Transactions and Totals by Date Reports
        I BPRTYPE=5!(BPRTYPE=6) Q
        I $G(BPSDATA) S NP=$$CHKP(5) Q:BPQ!NP
        ;Get and display the Insurance Name
        S INS=$E(BPGRPLAN,1,90)
        I INS]"" D
        .D ULINE("-")
        .W !,INS
        .D ULINE("-")
        Q
        ;
        ;Check for End of Page
        ; Input variables -> BPLINES -> Number of lines from bottom
        ;                    BPEXCEL -> 1 - Print to Excel/0 Regular Display
        ; Output variable -> BPSDATA -> 0 -> New screen, no data displayed yet
        ;                               1 -> Data displayed on current screen
CHKP(BPLINES)   Q:$G(BPEXCEL) 0
        S BPLINES=BPLINES+1
        I $G(BPSCR) S BPLINES=BPLINES+2
        I $G(BPSCR),'$G(BPSDATA) S BPSDATA=1 Q 0
        S BPSDATA=1
        I $Y>(IOSL-BPLINES) D:$G(BPSCR) PAUSE^BPSRPT1 Q:$G(BPQ) 0 D HDR^BPSRPT7(BPRTYPE,BPRPTNAM,.BPPAGE) Q 1
        Q 0
        ;
        ;Print one line of characters
ULINE(X)        N I
        W ! F I=1:1:132 W $G(X,"-")
        Q
