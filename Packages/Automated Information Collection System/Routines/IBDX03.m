IBDX03 ; COMPILED XREF FOR FILE #357 ; 09/19/10
 ; 
 S DIKZK=1
 S DIKZ(0)=$G(^IBE(357,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^IBE(357,"B",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,4)
 I X'="" S ^IBE(357,"D",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,7)
 I X'="" S ^IBE(357,"C",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,13)
 I X'="" S ^IBE(357,"ADEF",$E(X,1,30),DA)=""
END G ^IBDX04
