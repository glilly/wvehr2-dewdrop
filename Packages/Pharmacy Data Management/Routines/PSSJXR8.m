PSSJXR8 ; COMPILED XREF FOR FILE #55.06 ; 09/19/10
 ;
 S DIKZ(0)=$G(^PS(55,DA(1),5,DA,0))
 S X(2)=$P(DIKZ(0),U,21)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . S:$D(DIKIL) (X2,X2(1),X2(2))=""
 . N DIKXARR M DIKXARR=X S DIKCOND=1
 . S X=1
 . S DIKCOND=$G(X) K X M X=DIKXARR
 . Q:'DIKCOND
 . K ^PS(55,"ACX",$E(X(1),1,30),$E(X(2),1,30),DA_"U")
CR3 S DIXR=495
 K X
 S DIKZ(2)=$G(^PS(55,DA(1),5,DA,2))
 S X(1)=$P(DIKZ(2),U,4)
 S DIKZ(8)=$G(^PS(55,DA(1),5,DA,8))
 S X(2)=$P(DIKZ(8),U,1)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . S:$D(DIKIL) (X2,X2(1),X2(2))=""
 . K ^PS(55,"AUDC",$E(X(1),1,20),$E(X(2),1,20),DA(1),DA)
CR4 S DIXR=497
 K X
 S DIKZ(2)=$G(^PS(55,DA(1),5,DA,2))
 S X(1)=$P(DIKZ(2),U,4)
 S DIKZ(8)=$G(^PS(55,DA(1),5,DA,8))
 S X(2)=$P(DIKZ(8),U,1)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . S:$D(DIKIL) (X2,X2(1),X2(2))=""
 . K ^PS(55,DA(1),5,"AUN",X(1),X(2),DA)
CR5 K X
 G:'$D(DIKLM) A^PSSJXR7 Q:$D(DIKILL)
END G ^PSSJXR9
