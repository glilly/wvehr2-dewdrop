IBDX17 ; COMPILED XREF FOR FILE #357.11 ; 09/19/10
 ; 
 S DA(1)=DA S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^IBE(357.1,DA(1),"S",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^IBE(357.1,DA(1),"S",DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^IBE(357.1,DA(1),"S","B",$E(X,1,30),DA)=""
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^IBDX18
