ORD210 ; COMPILED XREF FOR FILE #100.002 ; 06/16/11
 ; 
 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^OR(100,DA(1),2,DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^OR(100,DA(1),2,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S P=$P(^OR(100,DA(1),0),"^",2),P2=$P(^(0),"^",8),P1=$S($D(^(3)):$P(^(3),"^",4),1:"") I P,P1,P2 S ^OR(100,"AL",P,P1,P2,DA,DA(1))=""
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^ORD211
