PSSJXR30 ; COMPILED XREF FOR FILE #55.11 ; 08/30/12
 ; 
 S DA(1)=0 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=2 DIKLM=1 S:DIKM1'=2&'$G(DIKPUSH(2)) DIKPUSH(2)=1,DA(2)=DA(1),DA(1)=DA,DA=0 G @DIKM1
A S DA(1)=$O(^PS(55,DA(2),"IV",DA(1))) I DA(1)'>0 S DA(1)=0 G END
1 ;
B S DA=$O(^PS(55,DA(2),"IV",DA(1),"SOL",DA)) I DA'>0 S DA=0 Q:DIKM1=1  G A
2 ;
 S DIKZ(0)=$G(^PS(55,DA(2),"IV",DA(1),"SOL",DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" X ^DD(55.11,.01,1,1,1)
 S DIKZ(0)=$G(^PS(55,DA(2),"IV",DA(1),"SOL",DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" X ^DD(55.11,1,1,1,1)
 G:'$D(DIKLM) B Q:$D(DISET)
END G ^PSSJXR31
