%ZVEMRLP ;DJB,VRR**RTN LBRY - Print ; 11/20/00 9:53pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;Entry Point
 NEW FLAGQ,PAGE,VEEANS,VEEUSERI,VEEUSERN
 S FLAGQ=0 D INIT G:FLAGQ EX
 W @VEE("IOF"),!?1,"***PRINT ROUTINE LIBRARY***"
 D ASK G:FLAGQ EX
 D DEVICE G:POP!FLAGQ EX U IO
START ;
 NEW FLAGQ
 S FLAGQ=0 D HD,HD1,PRINT
EX ;
 D ^%ZISC
 Q
DEVICE ;Get device
 NEW ZTDESC,ZTRTN,ZTSAVE
 S ZTRTN="START^%ZVEMRLP",ZTDESC="VPE - Print Routine Library"
 S ZTSAVE="VEE*"
 D TASK^%ZVEMKP()
 Q
ASK ;Print what?
 W !!?1,"1. List ALL routines signed out"
 W !?1,"2. List ONLY routines you've signed out"
 W !?1,"3. List all routines EXCEPT those you've signed out"
ASK1 W !!?1,"Select NUMBER: "
 R VEEANS:300 S:'$T VEEANS="^" I "^"[VEEANS S FLAGQ=1 Q
 I ",1,2,3,"'[(","_VEEANS_",") D  G ASK1
 . W "   Enter 1, 2, or 3"
 Q
PRINT ;
 NEW CNT,DATA,DATE,I,ID,IEN,PER,RTN,TMP,VEEBYI,VEEBYN,Y
 S CNT=1,RTN=""
 F  S RTN=$O(^VEE(19200.11,"B",RTN)) Q:RTN']""!FLAGQ  D  ;
 . S IEN=$O(^VEE(19200.11,"B",RTN,"")) Q:IEN'>0
 . S DATA=$G(^VEE(19200.11,IEN,0)) Q:DATA']""
 . D GETBY^%ZVEMRLU(IEN)
 . I VEEANS=2,VEEUSERI'=VEEBYI Q  ;............Current user only
 . I VEEANS=3,VEEUSERI=VEEBYI Q  ;.............All except current user
 . S ID=$P(DATA,U,4) ;.........................Package
 . S (TMP,Y)=$P(DATA,U,12) D DD^%DT ;..........Date signed out
 . S DATE=$$DATEDASH^%ZVEMKU1($P(TMP,"@",1))
 . I Y["@" S DATE=DATE_" "_$P(Y,"@",2)
 . S PER=$P(DATA,U,13) ;.......................Signed out by
 . I PER>0 S PER=$P($G(^VEE(19200.111,PER,0)),U,1)
 . W !,$J(CNT,3),". ",RTN,?15,$E(PER,1,23),?40,DATE,?57,$E(ID,1,22)
 . S CNT=CNT+1
 . I $Y>(IOSL-6) D PAGE
 . Q
 Q:FLAGQ
 F I=$Y:1:IOSL-6 W !
 W !!,?(IOM-($L(PAGE)+6)\2),"PAGE: ",PAGE
 I $E(IOST,1,2)="P-" Q
 D PAUSE^%ZVEMKU(1,"P")
 Q
PAGE ;
 I $O(^VEE(19200.11,"B",RTN))']"" Q
 W !!,?(IOM-($L(PAGE)+6)\2),"PAGE: ",PAGE S PAGE=PAGE+1
 I $E(IOST,1,2)="P-" W @IOF,! D HD1 Q
 D PAUSE^%ZVEMKU(1,"Q") Q:FLAGQ  W @IOF D HD1 Q
 Q
PAGE1 ;Write Page#
 I $E(IOST,1,2)="P-" W !
 W !,?(IOM-($L(PAGE)+6)\2),"PAGE: ",PAGE S PAGE=PAGE+1
 Q
HD ;Heading
 NEW HD
 I $E(IOST,1,2)="C-" W @IOF
 E  W !!
 S HD="R O U T I N E S   S I G N E D   O U T"
 W !?(IOM-$L(HD)\2),HD
 S HD="As of: "_$$DATE^%ZVEMKDT(1)_" "_$$TIME^%ZVEMKDT(2)
 W !?(IOM-24\2),HD
 I $E(IOST,1,2)="P-" W !
 Q
HD1 ;
 W !?5,"ROUTINE",?15,"SIGNED OUT BY",?40,"DATE SIGNED OUT",?57,"IDENTIFIER"
 W !?5,"--------",?15,"-----------------------",?40,"---------------",?57,"----------------------"
 Q
INIT ;
 I '$D(^VEE(19200.11)) S FLAGQ=1 Q  ;.........Invalid UCI
 I '$D(IOF)!('$D(IOST)),$D(^%ZIS) D HOME^%ZIS 
 I '$D(IOF) D MSG^%ZVEMRLU(6) Q  ;............IO variables not defined
 Q:'$$CHKLBRY^%ZVEMRLU()  ;...................Check environment
 D GETUSER^%ZVEMRLU() Q:FLAGQ  ;..............Identify current user
 S PAGE=1,U="^"
 Q
