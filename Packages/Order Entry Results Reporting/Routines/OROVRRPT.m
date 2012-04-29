OROVRRPT        ;SLC/TC - Order Check Override Reason Report Utility; 8/31/06 1:45pm
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
EN      ;
        N ANS,TMP
        W @IOF
        D ASKUSER^ORSRCHOR(.ANS,"FILTER SEARCH by") Q:$G(ANS("EXIT"))="YES"
        D
        . N POP,ORDESC,ORRTN,ORSAVE
        . S ORDESC="OROVRRPT Override Reason Report",ORRTN="DISPLAY^OROVRRPT",ORSAVE("*")=""
        . W ! D EN^XUTMDEVQ(ORRTN,ORDESC,.ORSAVE) K ^TMP("OROVRRPT",$J)
        Q
        ;
DISPLAY ; Print data in an organized report format.
        ;
        D HEADER^ORSRCHOR
        N ORSUB1,ORSUB2,ORSUB3,ORSUB4,ORDNO,NORECS,ORCONT,LINECNT,RECNO S (ORSUB1,ORSUB2,ORSUB3,ORSUB4,ORDNO,RECNO)=0,NORECS="NO RECORDS FOUND!",ORCONT=1
        S LINECNT=$S(ANS("SORT")="OVRDNBY":12,ANS("SORT")="ORCHK":11,ANS("SORT")="DIV":11,ANS("SORT")="DSPGRP":11,ANS("SORT")="DTORD":12)
        F  S ORSUB1=$O(^TMP("OROVRRPT",$J,ORSUB1)) Q:ORSUB1=""  D  Q:ORCONT=0
        . F  S ORSUB2=$O(^TMP("OROVRRPT",$J,ORSUB1,ORSUB2)) Q:ORSUB2=""  D  Q:ORCONT=0
        . . F  S ORSUB3=$O(^TMP("OROVRRPT",$J,ORSUB1,ORSUB2,ORSUB3)) Q:ORSUB3=""  D  Q:ORCONT=0
        . . . F  S ORSUB4=$O(^TMP("OROVRRPT",$J,ORSUB1,ORSUB2,ORSUB3,ORSUB4)) Q:ORSUB4=""  D  Q:ORCONT=0
        . . . . F  S ORDNO=$O(^TMP("OROVRRPT",$J,ORSUB1,ORSUB2,ORSUB3,ORSUB4,ORDNO)) Q:ORDNO=""  D  Q:ORCONT=0
        . . . . . N DATA,OVRRIDBY,ORDCHK1,ORDCHK2,ORDCHK S DATA=$G(^TMP("OROVRRPT",$J,ORSUB1,ORSUB2,ORSUB3,ORSUB4,ORDNO)),OVRRIDBY=$P($G(^VA(200,+$P(DATA,U,3),0)),U)
        . . . . . I '$L(OVRRIDBY) S OVRRIDBY="NONE SPECIFIED"
        . . . . . S ORDCHK1=$S(ANS("SORT")="OVRDNBY":ORSUB4,ANS("SORT")="ORCHK":ORSUB1,ANS("SORT")="DIV":ORSUB3,ANS("SORT")="DSPGRP":ORSUB3,ANS("SORT")="DTORD":ORSUB4)
        . . . . . S ORDCHK2=$P(DATA,U,5),ORDCHK=$S($L(ORDCHK2)>1:ORDCHK1_ORDCHK2,1:ORDCHK1)
        . . . . . I ANS("DELIMIT")="YES" D      ; Delimited report printout of non-word processing fields
        . . . . . . S RECNO=RECNO+1
        . . . . . . I ANS("SORT")="OVRDNBY" W !,RECNO_TMP("DLMTR")_$$FMTE^XLFDT(ORSUB1,"1P")_TMP("DLMTR")_ORSUB2_TMP("DLMTR")_ORSUB3_TMP("DLMTR")_ORDNO_TMP("DLMTR")_$$FMTE^XLFDT($P(DATA,U,4),"1P")
        . . . . . . I ANS("SORT")="ORCHK" W !,RECNO_TMP("DLMTR")_$$FMTE^XLFDT(ORSUB4,"1P")_TMP("DLMTR")_ORSUB2_TMP("DLMTR")_ORSUB3_TMP("DLMTR")_ORDNO_TMP("DLMTR")_OVRRIDBY_TMP("DLMTR")_$$FMTE^XLFDT($P(DATA,U,4),"1P")
        . . . . . . I ANS("SORT")="DIV" W !,RECNO_TMP("DLMTR")_$$FMTE^XLFDT(ORSUB4,"1P")_TMP("DLMTR")_ORSUB2_TMP("DLMTR")_ORDNO_TMP("DLMTR")_OVRRIDBY_TMP("DLMTR")_$$FMTE^XLFDT($P(DATA,U,4),"1P")
        . . . . . . I ANS("SORT")="DSPGRP" W !,RECNO_TMP("DLMTR")_$$FMTE^XLFDT(ORSUB4,"1P")_TMP("DLMTR")_ORSUB2_TMP("DLMTR")_ORDNO_TMP("DLMTR")_OVRRIDBY_TMP("DLMTR")_$$FMTE^XLFDT($P(DATA,U,4),"1P")
        . . . . . . I ANS("SORT")="DTORD" W !,RECNO_TMP("DLMTR")_$$FMTE^XLFDT(ORSUB1,"1P")_TMP("DLMTR")_ORDNO_TMP("DLMTR")_OVRRIDBY_TMP("DLMTR")_$$FMTE^XLFDT($P(DATA,U,4),"1P")
        . . . . . . S ^TMP(ANS("SORT"),"ORDER TEXT",RECNO)=$P(DATA,U),^TMP(ANS("SORT"),"ORDER CHK",RECNO)=ORDCHK,^TMP(ANS("SORT"),"OVERRIDE REASON",RECNO)=$P(DATA,U,2)
        . . . . . E  D  ; Summary report printout
        . . . . . . I ANS("SORT")="OVRDNBY"&(ORCONT=1) W !,$$FMTE^XLFDT(ORSUB1,"1M"),?21,ORSUB2,?40,ORSUB3,?70,ORDNO
        . . . . . . I ANS("SORT")="ORCHK"&(ORCONT=1) W !,$$FMTE^XLFDT(ORSUB4,"1M"),?21,ORSUB2,?40,ORSUB3,?70,ORDNO
        . . . . . . I ANS("SORT")="DIV"&(ORCONT=1) W !,$$FMTE^XLFDT(ORSUB4,"1M"),?25,ORSUB2,?60,ORDNO
        . . . . . . I ANS("SORT")="DSPGRP"&(ORCONT=1) W !,$$FMTE^XLFDT(ORSUB4,"1M"),?25,ORSUB2,?60,ORDNO
        . . . . . . I ANS("SORT")="DTORD"&(ORCONT=1) W !,$$FMTE^XLFDT(ORSUB1,"1M"),?45,ORDNO
        . . . . . . S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . I ANS("SORT")="OVRDNBY"&(ORCONT=1) W !?3,"D/T Overridden: ",$$FMTE^XLFDT($P(DATA,U,4),"1M")
        . . . . . . E  I ORCONT=1 W !?3,"Overridden by: ",OVRRIDBY,?46,"D/T Overridden: ",$$FMTE^XLFDT($P(DATA,U,4),"1M")
        . . . . . . S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . N CNT,CNT1,CNT2,ORDTXT,OVRRSN S ORDTXT=$P(DATA,U),OVRRSN=$P(DATA,U,2) I ($L(ORDTXT)>65)!($L(OVRRSN)>60)!($L(ORDCHK)>66) D
        . . . . . . . S ORDTXT=$$WRAP^TIULS(ORDTXT,65) I ORCONT=1 W !?3,"Order Text: ",$P(ORDTXT,"|") S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . I $L(ORDTXT,"|")>1 F CNT=2:1:$L(ORDTXT,"|") I ORCONT=1 W !?15,$P(ORDTXT,"|",CNT) S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . S ORDCHK=$$WRAP^TIULS(ORDCHK,66) I ORCONT=1 W !?3,"Order Chk: ",$P(ORDCHK,"|") S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . I $L(ORDCHK,"|")>1 F CNT2=2:1:$L(ORDCHK,"|") I ORCONT=1 W !?14,$P(ORDCHK,"|",CNT2) S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . S OVRRSN=$$WRAP^TIULS(OVRRSN,60) I ORCONT=1 W !?3,"Override Reason: ",$P(OVRRSN,"|") S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . I (ORCONT=1)&($L(OVRRSN,"|")=1) W ! S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . E  I $L(OVRRSN,"|")>1 D
        . . . . . . . . F CNT1=2:1:$L(OVRRSN,"|")  D  Q:ORCONT=0
        . . . . . . . . . W !?20,$P(OVRRSN,"|",CNT1) S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . . . I CNT1=$L(OVRRSN,"|") W ! S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . E  I ORCONT=1 D
        . . . . . . . W !?3,"Order Text: ",ORDTXT S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . W !?3,"Order Chk: ",ORDCHK S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . W !?3,"Override Reason: ",OVRRSN S LINECNT=$$CHK4BRK(LINECNT)
        . . . . . . . W ! S LINECNT=$$CHK4BRK(LINECNT)
        I ANS("DELIMIT")="YES"&($D(^TMP("OROVRRPT",$J))) D      ; Delimited report printout of word-processing fields
        . N ROUND F ROUND=1:1:3 D  Q:ANS("CONT")="NO"
        . . N DIR,DIRUT,Y,FLD S FLD=$S(ROUND=1:"ORDER TEXT",ROUND=2:"ORDER CHK",ROUND=3:"OVERRIDE REASON"),DIR(0)="Y",DIR("A")="Continue to export the "_FLD_" field only",DIR("B")="YES"
        . . S DIR("?",1)="Entering 'YES' will print out a delimited report of the word-processing field.",DIR("?",2)=""
        . . S DIR("?")="Entering 'NO' will complete the report and allow the user to exit the program." W ! D ^DIR K DIR W !
        . . I '$D(DIRUT),Y=1 D
        . . . S ANS("CONT")="YES" W !,"RECNO"_TMP("DLMTR")_FLD
        . . . N RECNO S RECNO="" F  S RECNO=$O(^TMP(ANS("SORT"),FLD,RECNO)) Q:RECNO=""  W !,RECNO_TMP("DLMTR"),$G(^TMP(ANS("SORT"),FLD,RECNO))
        . . E  S ANS("CONT")="NO" Q
        I '$D(^TMP("OROVRRPT",$J)) W !!!?(IOM-$L(NORECS))/2,NORECS,!!
        K ^TMP("OROVRRPT",$J),^TMP(ANS("SORT"))
        I ($E(IOST)="C")&(ORCONT=1) W ! N DIR,DIRUT S DIR(0)="E",DIR("A")="Report Completed. Please Press ENTER to EXIT" D ^DIR Q:$D(DIRUT)
        Q
        ;
PGBRK() ; Executes page breaks for a terminal device.
        ; If ORCONT=1, continue page break.
        ; If ORCONT=0, Quit page break.
        ;
        N DIR,Y,ORCONT,DIRUT S DIR(0)="E" D ^DIR S ORCONT=Y Q ORCONT
        ;
CHK4BRK(LINECNT)        ; Check for page break and display appropriate column headers for terminal screen display.
        ;
        S LINECNT=LINECNT+1
        I ($E(IOST)="C")&(IOSL<98)&(LINECNT=22) W ! S ORCONT=$$PGBRK,LINECNT=2 I ORCONT=1 W @IOF D COLHDR^ORSRCHOR
        Q LINECNT
        ;
