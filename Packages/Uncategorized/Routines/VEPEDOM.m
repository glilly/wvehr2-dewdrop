VEPEDOM ;RED/DAOU ; 5/13/05 11:51am
 ;;1.0;Reset Kernel System Parameters;;;Build 1
 ;
DIC N NUM,SEL,ANS S (SEL,NUM)=0
 W !!,"First I will print out existing entries for you to select from",!
 F  S NUM=$O(^DIC(4.2,NUM)) Q:NUM<1  W !,NUM,?5,$P(^DIC(4.2,NUM,0),"^")
SEL R !,"Please select a number from above: ",SEL:DTIME Q:SEL=""
 I '$D(^DIC(4.2,SEL)) W !,"Incorrect selection, try again",# G DIC
 W !!!,"You have selected '",$P(^DIC(4.2,SEL,0),"^"),"' is this correct? " R ANS:DTIME I ANS'="Y"&(ANS'="y") W !,"Quitting" Q
 W !!,"Okay, changing Kernel System Parameters to: ",$P(^DIC(4.2,SEL,0),"^")
 W !,"completed"
 ;Q
 N IEN,DATA S IEN=0,IEN=$O(^XTV(8989.3,IEN)) Q:IEN=""
 S DATA=^XTV(8989.3,IEN,0),$P(DATA,"^")=SEL
 W !,DATA
 ;K ^XTV(8989.3,"B")
 ;S ^XTV(8989.3,"B",SEL)=""
 ;S $P(^XTV(8989.3,IEN,0),"^")=SEL
 Q
