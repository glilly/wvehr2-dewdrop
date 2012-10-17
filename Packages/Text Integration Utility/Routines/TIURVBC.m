TIURVBC ;ISL/JER - Visible Black Character Line Count Report ;05/20/10  12:43
        ;;1.0;TEXT INTEGRATION UTILITIES;**250**;Jun 20, 1997;Build 14
        ;
        ; ICR #2055     - $$EXTERNAL^DILFD
        ;     #2056     - $$GET1^DIQ
        ;     #3799     - $$FMTE^XLFDT
        ;     #4558     - $$LEAP^XLFDT3
        ;     #4631     - $$NOW^XLFDT
        ;     #10000    - %, %I, %T, %Y Local vars
        ;     #10063    - ^%ZTLOAD
        ;     #10086    - ^%ZIS Routine & IO, IOF, ION, IOSL, & IOST Local Vars
        ;     #10089    - ^%ZISC Routine & IO("Q") Local Var
        ;     #10104    - $$LOW^XLFSTR, $$UP^XLFSTR
        ;     #10112    - $$NAME^VASITE, $$SITE^VASITE
        ;     #10114    - %ZIS Local Var
        ;
MAIN    ; Main subroutine
        N DIC,DIRUT,BADDIV,SELDIV,TIUEDT,TIULDT,TIUDI,VAUTD,ZTRTN,%I,%T,%Y,POP,TIU1TR,TIUTR,TIUSONLY
        S TIUTR=0
        W !!,$$CENTER^TIULS("--- Transcription Billing Verification Report ---"),!
        D SELDIV^TIULA Q:SELDIV=-1
        I +SELDIV=0 D  Q:'$D(TIUDI)
        . W !!,"Inconsistencies found between the MEDICAL CENTER DIVISION FILE, the INSTITUTION"
        . W !,"FILE and/or STATION NUMBER (TIME SENSITIVE) FILE for the:",!!,$S($G(BADDIV)]"":BADDIV_" division"_$S($L(BADDIV,",")>1:"s",1:""),1:"a division you selected"),"."
        . W !!,"Please contact the National Support team."
        . I '$D(TIUDI) W ! S:'$$READ^TIUU("E") DIRUT=1
        I $D(TIUDI) D
        . N TIUK
        . S TIUK=0 F  S TIUK=$O(TIUDI(TIUK)) Q:'TIUK  D
        . . S TIUDI("INST",TIUDI(TIUK))=TIUK
        . . S TIUDI("ENTRIES")=$G(TIUDI("ENTRIES"))_TIUK_";"
        E  S TIUDI("ENTRIES")="ALL DIVISIONS"
        W !
        S TIU1TR=$$READ^TIUU("YA","Specific Transcriptionist(s)? ","NO","Indicate whether you would like to run the report for one or more specific Transcriptionists.")
        I $D(DIRUT) Q
        I +TIU1TR D TRNSEL(.TIUTR) Q:'+$G(TIUTR)!+$G(DIROUT)
        W !
        S TIUSONLY=$$READ^TIUU("YA","Print Summary Page Only? ","NO","Indicate whether you would like to see only the Summary Page (i.e., no Details).")
        I $D(DIRUT) Q
        W !
        S TIUEDT=+$$EDATE^TIULA("Transcription","",$$DFLTDT("E"))
        W !
        I TIUEDT'>0 Q
        S TIULDT=+$$LDATE^TIULA("Transcription","",$$DFLTDT("L"))
        W !
        I TIULDT'>0 Q
        S ZTRTN="ENTRY^TIURVBC"
DEVICE  ; Device handling
        ; Call with: ZTRTN
        N %ZIS
        S %ZIS="Q" D ^%ZIS Q:POP
        G:$D(IO("Q")) QUE
NOQUE   ; Call report directly
        D @ZTRTN
        Q
QUE     ; Queue output
        N %,ZTDTH,ZTIO,ZTSAVE,ZTSK
        Q:'$D(ZTRTN)
        K IO("Q") F %="DA","DFN","TIU*" S ZTSAVE(%)=""
        S:'$D(ZTDESC) ZTDESC="PRINT TRANSCRIPTION BILLING REPORT" S ZTIO=ION
        D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued!",1:"Request Cancelled!")
        K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
        D HOME^%ZIS
        Q
TRNSEL(TIUY)    ; Select Transcriptionists
        N DIRUT,TIUQUIT,TIUPRSN,TIUI,TIUPRMT,TIUVBCUC,TIUSCRN,TIUHLP S (TIUY,TIUI,TIUQUIT)=0
        ; Identify User Class for VBC Line Count
        S TIUVBCUC=$$GET^XPAR("DIV.`"_DUZ(2)_"^SYS","TIU USER CLASS FOR VBC")
        S TIUHLP="Please choose a "_$S(+TIUVBCUC:"KNOWN ",1:"")_"Transcriptionist (Duplicates not allowed)."
        S TIUSCRN="I '$D(TIUY(""I"",+Y))"_$S(+TIUVBCUC:",$$ISA^USRLM(+Y,TIUVBCUC)",1:"")
        W !!,"Select Transcriptionist(s):",!
        F  D  Q:+TIUQUIT
        . S TIUI=TIUI+1,TIUPRMT=$J(TIUI,3)_")  "
        . S TIUPRSN=$$READ^TIUU("PAO^200:AEMQ",TIUPRMT,"",TIUHLP,TIUSCRN)
        . I +TIUPRSN'>0 S TIUQUIT=1 Q
        . S TIUY=TIUI,TIUY(TIUI)=TIUPRSN,TIUY("I",+TIUPRSN)=TIUI
        W !
        Q
ENTRY   ; Build & Print Report
        N TIUA
        S TIUA=$NA(^TMP("TIURVBC",$J)) K @TIUA
        U IO
        D GATHER(.TIUDI,TIUA,TIUEDT,TIULDT,.TIUTR)
        D REPORT(TIUA,TIUEDT,TIULDT,TIUSONLY)
        K @TIUA
        D ^%ZISC
        Q
DFLTDT(EORL)    ; Compute default early or late date
        N DOM,MON,YR,FMDT,DFLTDT
        S YR=$E(DT,1,3),MON=$E(DT,4,5),DOM=$E(DT,6,7)
        I DOM<15 D  I 1
        . I +MON=1 S MON=12,YR=YR-1
        . E  S MON=MON-1 S:$L(MON)=1 MON="0"_MON
        . S DOM=$S(EORL="E":"01",1:$$LDOM(MON,YR))
        . S FMDT=YR_MON_DOM_$S(EORL="L":".2359",1:"")
        E  D
        . I EORL="E" S DOM="01",FMDT=YR_MON_DOM
        . E  S DFLTDT="NOW"
        I $G(DFLTDT)'="NOW" S DFLTDT=$$FMTE^XLFDT(FMDT)
        Q DFLTDT
LDOM(MON,YR)    ; Calculate last day of month MON
        N LEAP,LDOMS S YR=1700+YR,LEAP=$$LEAP^XLFDT3(YR)
        S LDOMS="31^"_(LEAP+28)_"^31^30^31^30^31^31^30^31^30^31"
        Q $P(LDOMS,U,MON)
GATHER(TIUDI,TIUA,TIUEDT,TIULDT,TIUTR)  ; Gather records that satisfy criteria
        N TIUTDT,TIUVBCUC
        ; Insure inclusive early date/time by subtracting one minute before $ORDER
        S TIUTDT=$$FMADD^XLFDT(TIUEDT,0,0,-1)
        ; Insure inclusive end date/time by appending time of 23:59 if time not indicated
        I $L(TIULDT,".")=1 S $P(TIULDT,".",2)="2359"
        F  S TIUTDT=$O(^TIU(8925,"VBC",TIUTDT)) Q:+TIUTDT'>0!(+TIUTDT>TIULDT)  D
        . N TIUVBC S TIUVBC=0
        . F  S TIUVBC=$O(^TIU(8925,"VBC",TIUTDT,TIUVBC)) Q:+TIUVBC'>0  D
        . . N TIUDA S TIUDA=0
        . . F  S TIUDA=$O(^TIU(8925,"VBC",TIUTDT,TIUVBC,TIUDA)) Q:+TIUDA'>0  D
        . . . N TIUAUTH,TIUD0,TIUD12,TIUD13,TIUD14,TIUDIV,TIUEBY,TIUPTNM,TIUTITLE,TIUSVC,TIUPTL4
        . . . S TIUD0=$G(^TIU(8925,TIUDA,0)),TIUD12=$G(^(12)),TIUD13=$G(^(13)),TIUD14=$G(^(14))
        . . . S TIUAUTH=$P(TIUD12,U,2),TIUDIV=$P(TIUD12,U,12),TIUEBY=$P(TIUD13,U,2)
        . . . S TIUSVC=$P(TIUD14,U,4)
        . . . I TIUAUTH=TIUEBY Q
        . . . I +$G(TIUTR),'$D(TIUTR("I",+TIUEBY)) Q
        . . . I $S(TIUDI("ENTRIES")="ALL DIVISIONS":0,$D(TIUDI("INST",+TIUDIV)):0,1:1) Q
        . . . ; Identify User Class for VBC Line Count
        . . . S TIUVBCUC=$$GET^XPAR($S(TIUDIV]"":"DIV.`"_TIUDIV_"^",1:"")_"SYS","TIU USER CLASS FOR VBC")
        . . . ; If User Class defined & document not entered by a member, quit to next document
        . . . I TIUVBCUC]"",'+$$ISA^USRLM(TIUEBY,TIUVBCUC) Q
        . . . S TIUSVC=$S(TIUSVC]"":$E($$EXTERNAL^DILFD(8925,1404,"",TIUSVC),1,8),1:"UNKNOWN")
        . . . S TIUDIV=$S(TIUDIV]"":$$EXTERNAL^DILFD(8925,1212,"",TIUDIV),1:"DIVISION UNKNOWN")
        . . . S TIUEBY=$S(TIUEBY]"":$$LOW^XLFSTR($$INITIALS(TIUEBY)),1:"n/a")
        . . . S TIUTITLE=$E($$PNAME^TIULC1($P(TIUD0,U)),1,23)
        . . . S TIUAUTH=$S(TIUAUTH]"":$$UP^XLFSTR($$INITIALS(TIUAUTH)),1:"N/A")
        . . . S TIUPTL4=$E($$GET1^DIQ(2,$P(TIUD0,U,2),.09),6,9) S:TIUPTL4']"" TIUPTL4="UNKN"
        . . . S TIUPTNM=$E($$NAME^TIULS($$PTNAME^TIULC1($P(TIUD0,U,2)),"LAST,FIRST MI"),1,19)_"|"_TIUPTL4
        . . . S @TIUA@(TIUDIV,TIUEBY,TIUTDT,TIUDA)=TIUTITLE_U_TIUPTNM_U_TIUAUTH_U_TIUVBC_U_TIUSVC
        Q
INITIALS(TIUX)  ; Get Person's initials from file 200
        N TIUY S TIUY=$$GET1^DIQ(200,TIUX,1)
        Q $S($L(TIUY):TIUY,1:$$NAME^TIULS($$PERSNAME^TIULC1(TIUX),"FIMILI"))
REPORT(TIUA,TIUEDT,TIULDT,TIUSONLY)     ; Generate report
        N TIUDIV,TIUDVBC,TIUDCNT,TIUSVBC,TIUSCNT,TIURTM,DIRUT,DTOUT,TIUSITE,TIUCAT,TIUI,TIUPG
        N TIUSHDR,EQLN S $P(EQLN,"-",11)="",TIUPG=0,TIUSONLY=+$G(TIUSONLY)
        I $D(ZTQUEUED) S ZTREQ="@" ; Tell TaskMan to delete Task log entry
        U IO
        S TIURTM=$$NOW^XLFDT,TIUSITE=$S($$NAME^VASITE]"":$$NAME^VASITE,1:$P($$SITE^VASITE,U,2))
        I '$D(@TIUA) D  Q
        . D HEADER("",TIURTM,TIUEDT,TIULDT,.TIUPG)
        . W:$$CONTINUE("",TIURTM,TIUEDT,TIULDT,.TIUPG) !
        . W:$$CONTINUE("",TIURTM,TIUEDT,TIULDT,.TIUPG) "No Documents Transcribed for selected Division(s) & Date Range...",!
        . I ($E(IOST)="C"),($E(IOSL,1,3)'=999) S:'+$$STOP^TIUU("",1) DIRUT=1
        S (TIUDIV,TIUSVBC,TIUSCNT)=0
        F  S TIUDIV=$O(@TIUA@(TIUDIV)) Q:TIUDIV']""  D  Q:$D(DIRUT)
        . N TIUDTVBC,TIUEBY,TIUEBVBC,TIUEBCNT S TIUEBY="",(TIUDVBC,TIUDCNT)=0
        . D:'TIUSONLY HEADER(TIUDIV,TIURTM,TIUEDT,TIULDT,.TIUPG)
        . F  S TIUEBY=$O(@TIUA@(TIUDIV,TIUEBY)) Q:TIUEBY']""  D  Q:$D(DIRUT)
        . . N TIUTDT S (TIUDTVBC,TIUTDT)=0
        . . S TIUEBCNT=+$P($G(@TIUA@(0,"EBY",TIUEBY)),U)
        . . S TIUEBVBC=+$P($G(@TIUA@(0,"EBY",TIUEBY)),U,2)
        . . W:'TIUSONLY&$$CONTINUE(TIUDIV,TIURTM,TIUEDT,TIULDT,.TIUPG) TIUEBY
        . . F  S TIUTDT=$O(@TIUA@(TIUDIV,TIUEBY,TIUTDT)) Q:TIUTDT'>0  D  Q:$D(DIRUT)
        . . . N TIUDA S TIUDA=0
        . . . F  S TIUDA=$O(@TIUA@(TIUDIV,TIUEBY,TIUTDT,TIUDA)) Q:TIUDA'>0  D  Q:$D(DIRUT)
        . . . . N TIUD,TIUTITLE,TIUPTNM,TIUAUTH,TIUVBC,TIUSVC
        . . . . S TIUD=$G(@TIUA@(TIUDIV,TIUEBY,TIUTDT,TIUDA))
        . . . . S TIUTITLE=$P(TIUD,U),TIUPTNM=$P(TIUD,U,2),TIUAUTH=$P(TIUD,U,3),TIUVBC=$P(TIUD,U,4),TIUSVC=$P(TIUD,U,5)
        . . . . S TIUDVBC=TIUDVBC+TIUVBC,TIUDCNT=TIUDCNT+1,@TIUA@(0,"Division",TIUDIV)=TIUDCNT_U_TIUDVBC
        . . . . S TIUEBVBC=TIUEBVBC+TIUVBC,TIUEBCNT=TIUEBCNT+1,@TIUA@(0,"EBY",TIUEBY)=TIUEBCNT_U_TIUEBVBC
        . . . . S TIUSVBC=TIUSVBC+TIUVBC,TIUSCNT=TIUSCNT+1,@TIUA@(0,"Station",TIUSITE)=TIUSCNT_U_TIUSVBC
        . . . . S TIUDTVBC=TIUDTVBC+TIUVBC ; Transcriber total for this division
        . . . . W:'TIUSONLY&$$CONTINUE(TIUDIV,TIURTM,TIUEDT,TIULDT,.TIUPG) ?5,$$DATE^TIULS(TIUTDT,"MM/DD/YY"),?14,TIUTITLE,?39,$P(TIUPTNM,"|"),?59,"(",$P(TIUPTNM,"|",2),")",?66,TIUAUTH,?70,$J(TIUVBC,10,2),!
        . . Q:$D(DIRUT)
        . . W:'TIUSONLY&$$CONTINUE(TIUDIV,TIURTM,TIUEDT,TIULDT,.TIUPG) ?70,EQLN,!
        . . W:'TIUSONLY&$$CONTINUE(TIUDIV,TIURTM,TIUEDT,TIULDT,.TIUPG) ?42,"Total for Transcriber ",$J(TIUEBY,3)," = ",?70,$J(TIUDTVBC,10,2),!
        . . W:'TIUSONLY&$$CONTINUE(TIUDIV,TIURTM,TIUEDT,TIULDT,.TIUPG) !
        . Q:$D(DIRUT)
        . W:'TIUSONLY&$$CONTINUE(TIUDIV,TIURTM,TIUEDT,TIULDT,.TIUPG) ?70,EQLN,!
        . W:'TIUSONLY&$$CONTINUE(TIUDIV,TIURTM,TIUEDT,TIULDT,.TIUPG) ?49,"Total for Division = ",?70,$J(TIUDVBC,10,2),!
        . I 'TIUSONLY,($E(IOST)="C"),($E(IOSL,1,3)'=999) S:'+$$STOP^TIUU("",1) DIRUT=1
        I $D(DIRUT)!'$D(@TIUA@(0)) Q
        ;Summarize
        S TIUCAT="",TIUSHDR="SUMMARY for "_TIUSITE
        D HEADER(TIUSHDR,TIURTM,TIUEDT,TIULDT,.TIUPG)
        F  S TIUCAT=$O(@TIUA@(0,TIUCAT)) Q:TIUCAT']""  D  Q:$D(DIRUT)
        . W:$$CONTINUE(TIUSHDR,TIURTM,TIUEDT,TIULDT,.TIUPG) !,$S(TIUCAT="EBY":"Transcriber",1:TIUCAT)," Totals",!
        . S TIUI="" F  S TIUI=$O(@TIUA@(0,TIUCAT,TIUI)) Q:TIUI']""  D
        . . N TIUR S TIUR=@TIUA@(0,TIUCAT,TIUI)
        . . W:$$CONTINUE(TIUSHDR,TIURTM,TIUEDT,TIULDT,.TIUPG) ?2,TIUI,?48,$P(TIUR,U),?70,$J($P(TIUR,U,2),10,2),!
        I ($E(IOST)="C"),($E(IOSL,1,3)'=999) S:'+$$STOP^TIUU("",1) DIRUT=1
        Q
CONTINUE(TIUDIV,TIURTM,TIUEDT,TIULDT,TIUPG)     ; Evaluate relative page position
        N TIUY S TIUY=1
        I $Y'>(IOSL-3) G CONTX
        I $E(IOST)="C" S TIUY=+$$READ^TIUU("E") I $D(DIRUT)!(TIUY'>0) G CONTX
        D HEADER(TIUDIV,TIURTM,TIUEDT,TIULDT,.TIUPG)
CONTX   Q TIUY
HEADER(DIVISION,TIURTM,TIUEDT,TIULDT,TIUPG)     ; Write Report Header
        N TIULINE,TIUDTR S $P(TIULINE,"=",81)="",TIUDTR=$$DATE^TIULS(TIUEDT,"MM/DD/CCYY")_" to "_$$DATE^TIULS(TIULDT,"MM/DD/CCYY")
        S TIUPG=TIUPG+1
        W @IOF D JUSTIFY^TIUU("Page "_TIUPG,"R") W !
        W TIULINE,! D JUSTIFY^TIUU($$TITLE^TIUU("TRANSCRIPTION BILLING REPORT"),"C") W !
        D JUSTIFY^TIUU(DIVISION,"C")
        W !
        W "for Documents Transcribed: ",TIUDTR,?55,"Printed: ",$$DATE^TIULS(TIURTM,"MM/DD/CCYY HR:MIN"),!
        W !
        I DIVISION'["SUMMARY" W "Tran",?5,"Date",?14,"Title",?39,"Patient",?66,"Aut",?71,"VBC Lines",!
        W TIULINE,!
        E  W "Category",?48,"Documents",?71,"VBC Lines",!,TIULINE
        Q
