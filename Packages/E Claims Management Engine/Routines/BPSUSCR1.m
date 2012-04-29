BPSUSCR1 ;BHAM ISC/FLS - STRANDED CLAIMS SCREEN ;10-MAR-2005
 ;;1.0;E CLAIMS MGMT ENGINE;**1,5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 Q
 ;
INIT ; -- init variables and list array
 N BPLN,BPLM,BP59,BPSORT,BPDUZ7,BPRET,CONT
 ;get date/time range
 K ^TMP($J),^TMP("BPSUSCR",$J)
 S BPTMPGL="^TMP(""BPSUSCR"",$J)"
 S CONT=1,VALMCNT=0
 D COLLECT^BPSUSCR4(.BPARR)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 K X
 Q
 ;
EXIT ; -- exit code
 Q
 ;
 ; Warning message for 'Transmitting' claims
MESSAGE() ;
 W !!!,"Please be aware that if there are claims appearing on the ECME User Screen"
 W !,"with a status of 'In progress - Transmitting', then there may be a problem"
 W !,"with HL7 or with system connectivity with the Austin Automation Center (AAC)."
 W !,"Please contact your IRM to verify that connectivity to the AAC is working"
 W !,"and the HL7 link BPS NCPDP is processing messages before using this option"
 W !,"to unstrand claims with a status of 'In progress - Transmitting'.",!
 N DIR,X,Y,BPQ
 S BPQ=0
 S DIR(0)="YA",DIR("A")="Do you want to continue? "
 S DIR("B")="NO"
 D ^DIR
 I Y'=1 S BPQ=1
 W !!
 Q BPQ
 ;
GETDTS(BPARR) ; Transaction dates to view.
 N DIR
 K DIRUT,DIROUT,DUOUT,DTOUT,Y
 S DIR(0)="DA^:DT:EX",DIR("A")="FIRST TRANSACTION DATE: "
 S DIR("B")="T-1"
 D ^DIR
 Q:$D(DUOUT)!($D(DTOUT))
 S BPARR("BDT")=Y_".000001"
ENDDT ;
 K DIRUT,DIROUT,DUOUT,DTOUT,Y
 S DIR(0)="DA^"_$P(BPARR("BDT"),".",1)_":DT:EX",DIR("A")="LAST TRANSACTION DATE: "
 S DIR("B")="T"
 D ^DIR
 Q:$D(DUOUT)!($D(DTOUT))
 S BPARR("EDT")=$$EDATE(Y)
 Q
 ;
EDATE(DATE) ;
 N RTN,%,%H
 S RTN=DATE_".235959"
 D NOW^%DTC
 I $P(%,".")=DATE S $P(%H,",",2)=$P(%H,",",2)-1800 D YX^%DTC S RTN=DATE_%
 Q RTN
ALL ; Unstrand all claims currently selected.
 D FULL^VALM1
 N D0,DIR,SEQ,LAST
 S LAST=+$O(^TMP($J,2,""),-1)
 I LAST=0 D  Q
 . W !,"There are no stranded claims in this date range to unstrand"
 . D PRESSANY^BPSOSU5()
 S DIR(0)="Y",DIR("A")="ARE YOU SURE? (YES/NO) ",DIR("B")="YES" D ^DIR Q:'Y
 W !,"PLEASE WAIT"
 S SEQ=0
 F  S SEQ=$O(^TMP($J,2,SEQ)) Q:'SEQ  D
 .  S D0=""
 .  F  S D0=$O(^TMP($J,2,SEQ,D0)) Q:'D0  D
 .  .  D UNSTRAND(D0)
 .  .  Q
 .  Q
 W !,"Done"
 D CLEAN^VALM10
 D COLLECT^BPSUSCR4(.BPARR)
 Q
SELECT ; Select entries from the list and run each through the unstrand function
 N D0,DIR,I,J,VAR,BPTMPGL,PT,POP,LAST
 S LAST=+$O(^TMP($J,2,""),-1)
 I LAST=0 D  Q
 . W !,"There are no stranded claims to select"
 . D PRESSANY^BPSOSU5()
 K DTOUT,DUOUT
 S BPTMPGL="^TMP(""BPSUSCR"",$J)"
 S VAR=""
 S DIR(0)="LO^1:"_LAST
 S DIR("A")="Enter a Selection of Stranded Claims",DIR("B")=""
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q
 S VAR=Y
 F I=1:1:$L(VAR,",") S PT=$P(VAR,",",I) D
 .  Q:PT=""
 .  I PT'["-" S D0=$O(^TMP($J,2,PT,"")) D UNSTRAND(D0) Q
 .  F J=$P(PT,"-"):1:$P(PT,"-",2) S D0=$O(^TMP($J,2,J,"")) D UNSTRAND(D0)
 .  Q
 D CLEAN^VALM10
 D COLLECT^BPSUSCR4(.BPARR)
 Q
PRINT ;
 N %ZIS
 S %ZIS="M"
 S %ZIS("A")="Select Printer: ",%ZIS("B")="" D ^%ZIS
 Q:IOPAR=""
 D PHDR
 D PLINE
 D ^%ZISC
 Q
PHDR ;
 U IO
 W !,"Claims Stranded from ",BPBDT," through ",BPEDT
 ;
 W !!,?4,"TRANS DT",?15,"PATIENT NAME",?36,"ID",?41,"EXTERN RX#",?54,"RF",?57,"FILL DT",?68,"INS CO"
 W !,?4,"--------",?15,"------------",?36,"--",?41,"----------",?54,"--",?57,"-------",?68,"------"
 Q
PLINE ;
 N SEQ,LINE
 S SEQ=0
 F  S SEQ=$O(^TMP("BPSUSCR",$J,SEQ)) Q:'SEQ  D
 .  S LINE=$G(^TMP("BPSUSCR",$J,SEQ,0))
 .  U IO
 .  W !,$E(LINE,1,79)
 .  Q
 Q
 ;
 ; Unstrand the claim
 ; Fileman read of New Person file (VA(200)) is covered by IA# 10600
UNSTRAND(IEN59) ;
 N MES
 S MES="E STRANDED"
 I $P($G(^BPST(IEN59,4)),"^",1)!($P($G(^BPST(IEN59,4)),"^",4)]"") S MES="E REVERSAL STRANDED"
 D SETRESU^BPSOSU(IEN59,99,MES)
 D SETSTAT^BPSOSU(IEN59,99)
 S MES=$T(+0)_"-Unstranded"
 I $G(DUZ) S MES=MES_" by "_$$GET1^DIQ(200,DUZ,.01,"E")
 D LOG^BPSOSL(IEN59,MES)
 Q
