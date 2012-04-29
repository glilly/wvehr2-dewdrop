PRSATE1 ; HISC/REL-Display Tour Change ;5/5/93  10:40
 ;;4.0;PAID;;Sep 21, 1995
LST ; Display Change
 W !?34,"Tour Change",!,"    Date",?14,"Scheduled Tour",?45,"Permanent Tour",?75,"Type"
 S ZD=$G(^PRST(458,PPI,2))
 F DAY=0:0 S DAY=$O(^PRST(458,"ATC",DFN,PPI,DAY)) Q:DAY=""  D L1
 Q
L1 W !,$P(ZD,"^",DAY)
 S Y=$G(^PRST(458,PPI,"E",DFN,"D",DAY,0)),TD=$P(Y,"^",2) W ?14,$P($G(^PRST(457.1,+TD,0)),"^",1)
 S TD=$P(Y,"^",4) W ?45,$P($G(^PRST(457.1,+TD,0)),"^",1)
 S TYP=$P(Y,"^",3) W ?75,$S(TYP:"Temp",1:"Perm")
 S TD=$P(Y,"^",13) Q:'TD  W !?14,$P($G(^PRST(457.1,+TD,0)),"^",1),?75,"Temp" Q
