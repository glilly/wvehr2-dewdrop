IBXX25 ; COMPILED XREF FOR FILE #399.046 ; 08/30/12
 ; 
 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^DGCR(399,DA(1),"R",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^DGCR(399,DA(1),"R",DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^DGCR(399,DA(1),"R","B",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,4)
 I X'="" S ^DGCR(399,DA(1),"R","AC",$E(X,1,30),DA)=""
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^IBXX26
