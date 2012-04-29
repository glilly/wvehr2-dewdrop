SPNLRL2 ;ISC-SF/GB-SCD PHARMACY UTILIZATION REPORT (PRINT PART 2 OF 3) ;5 JUN 94 [ 08/23/94  10:04 AM ]
 ;;2.0;Spinal Cord Dysfunction;;01/02/1997
 ; PAGELEN   Number of lines per page
 ; TITLE     Array of header lines (titles)
P3(TITLE,PAGELEN,QLIST,ABORT) ;
 N NPATS,ZDRUGNR,NAME,FILLS,LCOST,TCOST,COST,QTY,COSTITLE,COSTNODE
 I QLIST("COST")="ACTUAL" D
 . S COSTITLE(1)=" Actual"
 . S COSTITLE(2)="  Cost "
 . S COSTNODE="COST"
 E  D
 . S COSTITLE(1)="Current"
 . S COSTITLE(2)=" Value "
 . S COSTNODE="VAL"
 S TITLE(4)=""
 S TITLE(5)=$$CENTER^SPNLRU("Drugs with fills totaling $"_$FN(QLIST("MINCOST"),",",2)_" or more")
 ; TITLE(5)="         1         2         3         4 "      "        5         6         7         8"
 S TITLE(6)=""
 S TITLE(7)="                                               "_COSTITLE(1)_"                Qty"
 S TITLE(8)="Drug                                           "_COSTITLE(2)_"    Fills      Disp   Pats"
 D HEADER^SPNLRU(.TITLE,.ABORT) Q:ABORT
 S ZDRUGNR="",(LCOST,TCOST)=0
 F  S ZDRUGNR=$O(^TMP("SPN",$J,"RX","DRUG",ZDRUGNR)) Q:ZDRUGNR=""  D
 . S COST=^TMP("SPN",$J,"RX","DRUG",ZDRUGNR,COSTNODE)
 . S TCOST=TCOST+COST
 . Q:COST<QLIST("MINCOST")
 . S LCOST=LCOST+COST
 . S FILLS=^TMP("SPN",$J,"RX","DRUG",ZDRUGNR)
 . S NPATS=^TMP("SPN",$J,"RX","DRUG",ZDRUGNR,"PAT")
 . S QTY=^TMP("SPN",$J,"RX","DRUG",ZDRUGNR,"QTY")
 . S NAME=^TMP("SPN",$J,"RX","DRUG",ZDRUGNR,"NAME")
 . S ^TMP("SPN",$J,"RX","OUT",-COST,-FILLS,-QTY,-NPATS,NAME)=""
 S COST=""
 F  S COST=$O(^TMP("SPN",$J,"RX","OUT",COST)) Q:COST=""  D  Q:ABORT
 . S FILLS=""
 . F  S FILLS=$O(^TMP("SPN",$J,"RX","OUT",COST,FILLS)) Q:FILLS=""  D  Q:ABORT
 . . S QTY=""
 . . F  S QTY=$O(^TMP("SPN",$J,"RX","OUT",COST,FILLS,QTY)) Q:QTY=""  D  Q:ABORT
 . . . S NPATS=""
 . . . F  S NPATS=$O(^TMP("SPN",$J,"RX","OUT",COST,FILLS,QTY,NPATS)) Q:NPATS=""  D  Q:ABORT
 . . . . S NAME=""
 . . . . F  S NAME=$O(^TMP("SPN",$J,"RX","OUT",COST,FILLS,QTY,NPATS,NAME)) Q:NAME=""  D  Q:ABORT
 . . . . . I $Y>PAGELEN D HEADER^SPNLRU(.TITLE,.ABORT) Q:ABORT
 . . . . . W !,NAME,?40,$J($FN(-COST,",",2),14),?54,$J($FN(-FILLS,","),9),?64,$J($FN(-QTY,","),9),?73,$J($FN(-NPATS,","),7)
 K ^TMP("SPN",$J,"RX","OUT")
 I TCOST=LCOST D
 . I $Y+1>PAGELEN D HEADER^SPNLRU(.TITLE,.ABORT) Q:ABORT
 . W !!,"TOTAL for all drugs",?40,$J($FN(TCOST,",",2),14)
 E  D
 . I $Y+2>PAGELEN D HEADER^SPNLRU(.TITLE,.ABORT) Q:ABORT
 . W !!,"TOTAL for listed drugs",?40,$J($FN(LCOST,",",2),14)
 . W !,"TOTAL (including unlisted drugs)",?40,$J($FN(TCOST,",",2),14)
 K TITLE(4),TITLE(5),TITLE(6),TITLE(7),TITLE(8)
 Q
P4(TITLE,PAGELEN,QLIST,ABORT) ;
 N COST,JD,OUT,LINE,STARTLIN,COL,COSTITLE,COSTNODE
 I QLIST("COST")="ACTUAL" D
 . S COSTITLE="           Dollar Cost    "
 . S COSTNODE="COST"
 E  D
 . S COSTITLE="          Dollar Value    "
 . S COSTNODE="VAL"
 S COST=+$O(^TMP("SPN",$J,"RX",COSTNODE,""))
 F  D  Q:COST=""!(ABORT)
 . D HEADER^SPNLRU(.TITLE,.ABORT) Q:ABORT
 . S STARTLIN=$Y
 . K OUT
 . S OUT(STARTLIN+2)=""
 . F COL=1:1:3 D  Q:COST=""
 . . S OUT(STARTLIN)=$G(OUT(STARTLIN))_COSTITLE
 . . S OUT(STARTLIN+1)=$G(OUT(STARTLIN+1))_"Patients    of Fills      "
 . . S JD=$L($FN(-COST,","))
 . . F LINE=STARTLIN+3:1:PAGELEN D  Q:COST=""
 . . . S NPATS=$G(^TMP("SPN",$J,"RX",COSTNODE,COST))
 . . . S OUT(LINE)=$G(OUT(LINE))_$J($FN(NPATS,","),7)_$J($FN(-COST,","),9)_"-"_$$PAD^SPNLRU($J($FN(-COST+99,","),JD),9-JD)
 . . . S COST=$O(^TMP("SPN",$J,"RX",COSTNODE,COST))
 . S LINE=""
 . F  S LINE=$O(OUT(LINE)) Q:LINE=""  D
 . . W !,OUT(LINE)
 Q
