VEPERPTA ;DAOU/KFK - HL7 ERROR REPORT PRINT ; 6/2/05 6:30pm
 ;;1.0;;;;Build 1
 ; This is the print routine for the Patient Lookup Error Report.
 ; It is called from VEPERIER.  The data is printed from the scratch
 ; global (^TMP($J...)).
 ;
 ; Must call at EN6
 Q
 ;
EN6(HL7ERTN) ;Entry point
 ;Initialize variables
 N CRT,DIR,DTOUT,DUOUT,HL7PGC,LIN,MAXCNT,X,Y
 ;
 ;Determine IO parameters
 I IOST["C-" S MAXCNT=IOSL-3,CRT=1,HL7PGC=0
 E  S MAXCNT=IOSL-6,CRT=0
 ;
 D PRINT(HL7ERTN,MAXCNT,CRT)
 I $G(ZSTOP) G EXIT6
 I CRT,HL7PGC>0,'$D(ZTQUEUED) D
 . I MAXCNT<51 F LIN=1:1:(MAXCNT-$Y) W !
 . S DIR(0)="E" D ^DIR K DIR
 Q
 ;
PRINT(RTN,MAX,CRT) ; Print data
 ;
 N EORMSG,NONEMSG,SORT1,SORT2,SORT3
 S EORMSG="*** END OF REPORT ***"
 S NONEMSG="* * * N O  D A T A  F O U N D * * *"
 ;
 I '$D(^TMP($J,RTN)) D HEADER W !,?(80-$L(NONEMSG)\2),NONEMSG,!!
 I $Y+1>MAX!('HL7PGC) D HEADER
 S SORT1="" F  S SORT1=$O(^TMP($J,RTN,SORT1)) Q:SORT1=""  D
 . S SORT2="" F  S SORT2=$O(^TMP($J,RTN,SORT1,SORT2)) Q:SORT2=""  D
 . . S SORT3="" F  S SORT3=$O(^TMP($J,RTN,SORT1,SORT2,SORT3)) Q:SORT3=""  D
 . . . I $Y+1>MAX!('HL7PGC) D HEADER
 . . . D LINE
 I $G(ZTSTOP) G PRINTX
 W !!,?(80-$L(EORMSG)\2),EORMSG
PRINTX ;
 Q
 ;
HEADER ; Print hdr info
 N DIR,DTOUT,DUOUT,HDR,LIN,OFFSET,X,Y
 I CRT,HL7PGC>0,'$D(ZTQUEUED) D
 . I MAX<51 F LIN=1:1:(MAX-$Y) W !
 . S DIR(0)="E" D ^DIR K DIR
 . I $D(DTOUT)!($D(DUOUT)) Q
 I $D(ZTQUEUED),$$S^%ZTLOAD() S ZTSTOP=1 G HEADERX
 S HL7PGC=HL7PGC+1
 W @IOF,!,?1,"HL7 Error Report"
 S HDR=$$FMTE^XLFDT($$NOW^XLFDT,1)_"  Page: "_HL7PGC,OFFSET=79-$L(HDR)
 W ?OFFSET,HDR
 S SRT=HL7ESPC("SORT"),BDT=HL7ESPC("BEGDT"),EDT=HL7ESPC("ENDDT")
 W !,?1,"Sorted by: "_$S(SRT=1:"Patient ID",SRT=2:"Patient",1:"Error Type")
 W ?OFFSET
 S HDR=$$FMTE^XLFDT(BDT,"5Z")_" - "_$$FMTE^XLFDT(EDT,"5Z")
 S OFFSET=80-$L(HDR)\2
 W !,?OFFSET,HDR
 W !
HEADERX ;
 Q
 ;
LINE ;  Print data
 N ERDT,HL7DT,HL7SRT
 ;
 S HL7SRT=HL7ESPC("SORT")
 I HL7SRT=1!(HL7SRT=3) D
 . W !!,"Patient ID: "_SORT1,?40,"Patient Name: "_SORT2
 I HL7SRT=2 D
 . W !!,"Patient Name: "_SORT1,?40,"Patient ID: "_SORT2
 S ERDT=$$FMTE^XLFDT($P(^TMP($J,RTN,SORT1,SORT2,SORT3),U),"5Z")
 S HL7DT=$$FMTE^XLFDT($P(^TMP($J,RTN,SORT1,SORT2,SORT3),U,3),"5Z")
 W !,"Error Date/Time: "_ERDT,?40,"HL7 Message Date/Time: "_HL7DT
 W !,$P($P(^TMP($J,RTN,SORT1,SORT2,SORT3),U,2)," ",1,11)
 W !,$P($P(^TMP($J,RTN,SORT1,SORT2,SORT3),U,2)," ",12,99)
 Q
EXIT6 ;
 Q
