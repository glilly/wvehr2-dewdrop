DGPTXX8 ; COMPILED XREF FOR FILE #45.01 ; 09/19/10
 ;
 S DA(1)=DA S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^DGPT(DA(1),"S",DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^DGPT(DA(1),"S",DA,0))
 S X=$P(DIKZ(0),U,8)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,9)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,10)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,11)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,12)
 I X'="" S ^DGPT(DA(1),"S","AO",$E(X,1,30),DA)=""
CR1 S DIXR=437
 K X
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,8)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"S",1)
CR2 S DIXR=438
 K X
 S DIKZ(0)=$G(^DGPT(DA(1),"S",DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,9)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"S",2)
CR3 S DIXR=439
 K X
 S DIKZ(0)=$G(^DGPT(DA(1),"S",DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,10)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"S",3)
CR4 S DIXR=440
 K X
 S DIKZ(0)=$G(^DGPT(DA(1),"S",DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,11)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"S",4)
CR5 S DIXR=441
 K X
 S DIKZ(0)=$G(^DGPT(DA(1),"S",DA,0))
 S X(1)=$P(DIKZ(0),U,1)
 S X(2)=$P(DIKZ(0),U,12)
 S X=$G(X(1))
 I $G(X(1))]"",$G(X(2))]"" D
 . K X1,X2 M X1=X,X2=X
 . D SDGPT0^DGPTDDCR(.X,.DA,"S",5)
CR6 K X
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^DGPTXX9
