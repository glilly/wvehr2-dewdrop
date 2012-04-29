ONCOST ;Hines OIFO - STATISTICS TIME FRAME TASKS ;9/28/93  08:52
 ;;2.11;ONCOLOGY;**1,5,23,44**;Mar 07, 1995
 ;
 ;Called from ONCOSC
 ;out: ONCOS("YR") OR Y="^" (exit)
ACT ;ANNUAL CROSS TABS
 W @IOF,!!!?10,"CROSS-TABS for ANNUAL Reports - requires",!?10,"definition of TIME-FRAME (year/range)",!!!
 ;
TF ;Select time frame for statistical routines; callable entry point
 K DIR S DIR("A")="      Select time frame",DIR(0)="SO^1:All years;2:Range of years;3:Particular year" D ^DIR K DIR Q:$D(DIRUT)
Y ;Entry point for determining begining and ending year of Registry
 S TF=Y,BYR=$O(^ONCO(165.5,"AY",0)),BEG=$E(DT,1)+17_$E(DT,2,3) F YR=BEG-1:-1:BYR-1 S EYR=$O(^ONCO(165.5,"AY",YR)) Q:EYR'=""
 ;
DIR ;Three pathways: Al=All years, RG=Range, AN=one year
D D AL:TF=1,RG:TF=2,AN:TF=3 Q:Y[U!(Y="")
 I $D(ONCOT) S ONCOS("AF")=1
 K DIR,BYR,EYR,TF,Y1,Y2,YR Q
AL ;All years
 S ONCOS("YR")="ALL"
 Q
RG ;RANGE OF YEARS FOR SEARCH
 W !!!?10,"Select range of years (from year to year)",!?10,"from which to SEARCH DATA for study",!!
ST K DIR S DIR(0)="LO^"_BYR_":"_EYR,DIR("A")="     Select Range years" D ^DIR Q:$D(DIRUT)  G ST:Y["." S LY=$L(Y,","),Y1=$P(Y,","),Y2=$P(Y,",",LY-1)
 ;TASK RANGE
 W !!?25,"RANGE is "_Y1_" to "_Y2,!! K DIR S DIR("A")="    Range OK",DIR(0)="Y",DIR("B")="Y" D ^DIR Q:$D(DIRUT)  G ST:Y=0 S ONCOS("YR")=Y1_U_Y2
 Q
 ;
AN ;Select ACCESSION YEAR range
 W !!
 S YR=$E(DT,1)+17_$E(DT,2,3)
 K DIR
 S DIR("A")=" Select ACCESSION YEAR"
 S DIR("B")=$S(YR=BYR:YR,1:YR-1)
 S DIR(0)="NO^"_BYR_":"_EYR
 D ^DIR Q:$D(DIRUT)
 G AN:Y>YR,AN:Y'?1.N S ONCOS("YR")=Y_U_Y
 Q
 ;
EX ;Exit
 Q
