PSSJXR11 ; COMPILED XREF FOR FILE #55.0611 ; 09/19/10
 ; 
 S DA(1)=0 S DA=0
A1 ;
 I $D(DIKILL) K DIKLM S:DIKM1=2 DIKLM=1 S:DIKM1'=2&'$G(DIKPUSH(2)) DIKPUSH(2)=1,DA(2)=DA(1),DA(1)=DA,DA=0 G @DIKM1
A S DA(1)=$O(^PS(55,DA(2),5,DA(1))) I DA(1)'>0 S DA(1)=0 G END
1 ;
B S DA=$O(^PS(55,DA(2),5,DA(1),11,DA)) I DA'>0 S DA=0 Q:DIKM1=1  G A
2 ;
 S DIKZ(0)=$G(^PS(55,DA(2),5,DA(1),11,DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(1102)=X,PSGAL("C")=6000,PSGALFF=.02,PSGALFN=55.0611 D ^PSGAL5
 S X=$P(DIKZ(0),U,3)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(1103)=X,PSGAL("C")=6000,PSGALFF=.03,PSGALFN=55.0611 D ^PSGAL5
 S X=$P(DIKZ(0),U,4)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(1104)=X,PSGAL("C")=6000,PSGALFF=.04,PSGALFN=55.0611 D ^PSGAL5
 S X=$P(DIKZ(0),U,5)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(1105)=X,PSGAL("C")=6000,PSGALFF=.05,PSGALFN=55.0611 D ^PSGAL5
 S X=$P(DIKZ(0),U,6)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(1106)=X,PSGAL("C")=6000,PSGALFF=1106,PSGALFN=55.0611 D ^PSGAL5
 S X=$P(DIKZ(0),U,7)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(1107)=X,PSGAL("C")=6000,PSGALFF=1107,PSGALFN=55.0611 D ^PSGAL5
 S X=$P(DIKZ(0),U,8)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(1108)=X,PSGAL("C")=6000,PSGALFF=1108,PSGALFN=55.0611 D ^PSGAL5
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^PS(55,DA(2),5,DA(1),11,"B",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(1101)=X,PSGAL("C")=6000,PSGALFF=.01,PSGALFN=55.0611 D ^PSGAL5
 G:'$D(DIKLM) B Q:$D(DIKILL)
END G ^PSSJXR12
