YSXRAF1 ; COMPILED XREF FOR FILE #602 ; 09/19/10
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^YSA(602,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^YSA(602,"B",$E(X,1,30),DA)
END G ^YSXRAF2
