PSSJXR12 ; COMPILED XREF FOR FILE #55.07 ; 08/30/12
 ; 
 S DA(1)=0 S DA=0
A1 ;
 I $D(DIKILL) K DIKLM S:DIKM1=2 DIKLM=1 S:DIKM1'=2&'$G(DIKPUSH(2)) DIKPUSH(2)=1,DA(2)=DA(1),DA(1)=DA,DA=0 G @DIKM1
A S DA(1)=$O(^PS(55,DA(2),5,DA(1))) I DA(1)'>0 S DA(1)=0 G END
1 ;
B S DA=$O(^PS(55,DA(2),5,DA(1),1,DA)) I DA'>0 S DA=0 Q:DIKM1=1  G A
2 ;
 S DIKZ(0)=$G(^PS(55,DA(2),5,DA(1),1,DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(702)=X,PSGAL("C")=6000,PSGALFF=.02,PSGALFN=55.07 D ^PSGAL5
 S X=$P(DIKZ(0),U,5)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(705)=X,PSGAL("C")=6000,PSGALFF=.05,PSGALFN=55.07 D ^PSGAL5
 S X=$P(DIKZ(0),U,6)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(706)=X,PSGAL("C")=6000,PSGALFF=.06,PSGALFN=55.07 D ^PSGAL5
 S X=$P(DIKZ(0),U,7)
 I X'="" I '$D(PSGRET),'$D(DIU(0)),'$D(PSGPO) S PSGAL(707)=X,PSGAL("C")=6000,PSGALFF=.07,PSGALFN=55.07 D ^PSGAL5
 S X=$P(DIKZ(0),U,9)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(709)=X,PSGAL("C")=6000,PSGALFF=.09,PSGALFN=55.07 D ^PSGAL5
 S X=$P(DIKZ(0),U,10)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(710)=X,PSGAL("C")=6000,PSGALFF=.1,PSGALFN=55.07 D ^PSGAL5
 S X=$P(DIKZ(0),U,12)
 I X'="" I '$D(PSGPEN),'$D(DIU(0)),'$D(PSGPO) S PSGAL(712)=X,PSGAL("C")=6000,PSGALFF=.12,PSGALFN=55.07 D ^PSGAL5
 S X=$P(DIKZ(0),U,1)
 I X'="" I '$D(DIU(0)),'$D(PSGPO) S PSGAL(701)=X,PSGAL("C")=6000,PSGALFF=.01,PSGALFN=55.07 D ^PSGAL5
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^PS(55,DA(2),5,DA(1),1,"B",$E(X,1,30),DA)
 G:'$D(DIKLM) B Q:$D(DIKILL)
END G ^PSSJXR13
