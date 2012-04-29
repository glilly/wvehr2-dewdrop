SPNLRL1 ;ISC-SF/GB-SCD PHARMACY UTILIZATION REPORT (PRINT PART 1 OF 3) ;4 JUN 94 [ 08/23/94  10:04 AM ]
 ;;2.0;Spinal Cord Dysfunction;;01/02/1997
 ; PAGELEN   Number of lines per page
 ; TITLE     Array of header lines (titles)
P1(TITLE,PAGELEN,ABORT) ;
 ; NDDRUGS   Number of different types of drugs
 ; ZDRUGNR   Internal Entry Number of a drug in ^PSDRUG
 ; FILLS     Number of fills given
 N NDDRUGS,ZDRUGNR,FILLS,OUT,LINE,STARTLIN,COL,NPATS
 S TITLE(4)=""
 S FILLS=+$G(^TMP("SPN",$J,"RX","FILLS"))
 S NPATS=+$G(^TMP("SPN",$J,"RX","PAT"))
 S TITLE(5)=$$CENTER^SPNLRU("Totals:  "_$FN(FILLS,",")_" fill"_$S(FILLS=1:"",1:"s")_" reported for "_$FN(NPATS,",")_" patient"_$S(NPATS=1:"",1:"s"))
 S ZDRUGNR=""
 F NDDRUGS=0:1 S ZDRUGNR=$O(^TMP("SPN",$J,"RX","DRUG",ZDRUGNR)) Q:ZDRUGNR=""
 S:NDDRUGS=1&(FILLS>1) TITLE(6)=$$CENTER^SPNLRU("(This includes just one type of drug)")
 S:NDDRUGS>1 TITLE(6)=$$CENTER^SPNLRU("(These include "_$FN(NDDRUGS,",")_" different drugs)")
 S FILLS=+$O(^TMP("SPN",$J,"RX","FILLS",""))
 F  D  Q:FILLS=""!(ABORT)
 . D HEADER^SPNLRU(.TITLE,.ABORT) Q:ABORT
 . K OUT,TITLE(4),TITLE(5),TITLE(6)
 . S STARTLIN=$Y
 . S OUT(STARTLIN+1)=""
 . F COL=1:1:3 D  Q:FILLS=""
 . . S OUT(STARTLIN)=$G(OUT(STARTLIN))_"   Patients      Fills    "
 . . F LINE=STARTLIN+2:1:PAGELEN D  Q:FILLS=""
 . . . S OUT(LINE)=$G(OUT(LINE))_$J($FN($G(^TMP("SPN",$J,"RX","FILLS",FILLS)),","),10)_$J($FN(-FILLS,","),11)_"     "
 . . . S FILLS=$O(^TMP("SPN",$J,"RX","FILLS",FILLS))
 . S LINE=""
 . F  S LINE=$O(OUT(LINE)) Q:LINE=""  D
 . . W !,OUT(LINE)
 Q
P2(TITLE,PAGELEN,QLIST,ABORT) ;
 N NPATS,ZDRUGNR,FILLS,MAXPATS,MAXFILLS,NAME
 S TITLE(4)=""
 S TITLE(5)=$$CENTER^SPNLRU("Drugs with "_$FN(QLIST("MINFILL"),",")_" or more fills")
 ; TITLE(6)="         1         2         3         4         5         6         7         8"
 S TITLE(6)=""
 S TITLE(7)="                                                                     Max # Fills"
 S TITLE(8)="Drug                                          Fills    Patients     (# patients)"
 D HEADER^SPNLRU(.TITLE,.ABORT) Q:ABORT
 S ZDRUGNR=""
 F  S ZDRUGNR=$O(^TMP("SPN",$J,"RX","DRUG",ZDRUGNR)) Q:ZDRUGNR=""  D
 . S FILLS=^TMP("SPN",$J,"RX","DRUG",ZDRUGNR)
 . Q:FILLS<QLIST("MINFILL")
 . S NPATS=^TMP("SPN",$J,"RX","DRUG",ZDRUGNR,"PAT")
 . S NAME=^TMP("SPN",$J,"RX","DRUG",ZDRUGNR,"NAME")
 . S ^TMP("SPN",$J,"RX","OUT",-FILLS,-NPATS,NAME)=ZDRUGNR
 S FILLS=""
 F  S FILLS=$O(^TMP("SPN",$J,"RX","OUT",FILLS)) Q:FILLS=""  D  Q:ABORT
 . S NPATS=""
 . F  S NPATS=$O(^TMP("SPN",$J,"RX","OUT",FILLS,NPATS)) Q:NPATS=""  D  Q:ABORT
 . . S NAME=""
 . . F  S NAME=$O(^TMP("SPN",$J,"RX","OUT",FILLS,NPATS,NAME)) Q:NAME=""  D  Q:ABORT
 . . . I $Y>PAGELEN D HEADER^SPNLRU(.TITLE,.ABORT) Q:ABORT
 . . . S ZDRUGNR=^TMP("SPN",$J,"RX","OUT",FILLS,NPATS,NAME)
 . . . S MAXFILLS=$O(^TMP("SPN",$J,"RX","DRUG",ZDRUGNR,"FILLS",""))
 . . . S MAXPATS=^TMP("SPN",$J,"RX","DRUG",ZDRUGNR,"FILLS",MAXFILLS)
 . . . W !,NAME,?40,$J($FN(-FILLS,","),10),?52,$J($FN(-NPATS,","),10)
 . . . I FILLS'=NPATS&(-FILLS>1)&(-NPATS>1) W ?65,$J($FN(-MAXFILLS,","),9)," (",MAXPATS,")"
 . . . ; See what IMRWRCP1 does here for national report.
 K ^TMP("SPN",$J,"RX","OUT")
 K TITLE(4),TITLE(5),TITLE(6),TITLE(7),TITLE(8)
 Q
