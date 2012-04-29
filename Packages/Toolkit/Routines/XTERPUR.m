XTERPUR ;ISC-SF.SEA/JLI - DELETE ENTRIES FROM ERROR TRAP ; [8/19/02 10:41am]
 ;;8.0;KERNEL;**243**;Jul 10, 1995
 W !!,"To Remove ALL entries except the last N days, simply enter the number N at the",!,"prompt.    OTHERWISE, enter return at the first prompt, and a DATE at the",!,"second prompt.  If no ending date is entered at the third prompt, then only"
 W !,"the date specified will be deleted.  If an ending date is entered that range",!,"of dates INCLUSIVE will be deleted from the error log.",!!
 ;
 R !!,"Number of days to leave in error trap: ",X:DTIME Q:'$T!(X[U)  I X'="",X'=+X W:$E(X)'="?" $C(7),"  ??" W !?5,"Enter a number (zero or greater) of days to be left in the Error Log.",!,"A RETURN will result in a request for dates" G XTERPUR
 I X=+X S X=$H-X F I=0:0 S I=$O(^%ZTER(1,I)) Q:I'<X!(I'>0)  D KILLDAY(I)
 I X=+X W !!?10,"DONE" D COUNT
 R !,"Starting Date to DELETE ERRORS from: ",X:DTIME Q:'$T!(X[U)!(X="")  S %DT="EQXP" D ^%DT G:Y'>0 XTERPUR S XTDAT=Y
 R !,"Ending Date to DELETE ERRORS to: ",X:DTIME I '$T!(X[U) W $C(7),"  ??" Q
 S:X="" X=XTDAT D ^%DT G:Y'>0 XTERPUR S XTDAT1=Y
 S X=XTDAT D H^%DTC S XTDAT=%H S X=XTDAT1 D H^%DTC S XTDAT1=%H I XTDAT1<XTDAT W $C(7)," ??  CAN NOT BE EARLIER" Q
 F I=XTDAT-1:0 S I=$O(^%ZTER(1,I)) Q:I'>0!(I>XTDAT1)  K ^%ZTER(1,I),^%ZTER(1,"B",I)
COUNT S X=0,XTDAT=0 F I=0:0 S I=$O(^%ZTER(1,I)) Q:I'>0  S X=X+1,XTDAT=I
 S $P(^%ZTER(1,0),U,3,4)=$S(X'>0:"",1:XTDAT_U_X)
 F XTDAT=0:0 S XTDAT=$O(^%ZTER(1,"B",XTDAT)) Q:XTDAT'>0  I '$D(^%ZTER(1,XTDAT)) K ^%ZTER(1,"B",XTDAT)
 K I,X,XTDAT,XTDAT1
 Q
TYPE ;To purge a type of error.
 N %DT,XTDAT,XTSTR,IX,Y,CNT
 S %DT="AEX" D ^%DT Q:Y'>1  S XTDAT=+$$FMTH^XLFDT(Y)
 R !,"ERROR STRING TO LOOK FOR: ",XTSTR:DTIME
 Q:'$L(XTSTR)
 S CNT=0 W !
 F IX=0:0 S IX=$O(^%ZTER(1,XTDAT,1,IX)) Q:IX'>0  D
 . I $G(^(IX,"ZE"))[XTSTR K ^%ZTER(1,XTDAT,1,IX) W "-" Q
 . W "." S CNT=CNT+1 Q
 ;Full reference of ^(IX,"ZE") is ^%ZTER(1,XTDAT,1,IX,"ZE")
 S $P(^%ZTER(1,XTDAT,0),"^",2)=CNT ;Reset count
 Q
AUTO ;Auto clean of error over ZTQPARAM days ago.
 S:$G(ZTQPARAM)<1 ZTQPARAM=7 S XTDAT=$H-ZTQPARAM
 F XTDT=0:0 S XTDT=$O(^%ZTER(1,XTDT)) Q:(XTDT'>0)!(XTDT>XTDAT)  D KILLDAY(XTDT)
 Q
KILLDAY(%H) ;Kill all error on one day
 L +^%ZTER(1) K ^%ZTER(1,%H),^%ZTER(1,"B",%H) L -^%ZTER(1)
 Q
