LBRYX23 ; COMPILED XREF FOR FILE #681 ; 09/19/10
 ;
 S DIKZK=1
 S DIKZ(0)=$G(^LBRY(681,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^LBRY(681,"B",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,2)
 I X'="" S ^LBRY(681,"C",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,2)
 I X'="" S:$P($G(^LBRY(681,DA,1)),U)'="" ^LBRY(681,"AC",$E(X,1,30),$P(^LBRY(681,DA,1),U),DA)=""
 S X=$P(DIKZ(0),U,4)
 I X'="" S ^LBRY(681,"E",$E(X,1,30),DA)=""
 S DIKZ(1)=$G(^LBRY(681,DA,1))
 S X=$P(DIKZ(1),U,1)
 I X'="" S:$P($G(^LBRY(681,DA,0)),U,2)'="" ^LBRY(681,"AC",$P(^LBRY(681,DA,0),U,2),$E(X,1,30),DA)=""
 S X=$P(DIKZ(1),U,5)
 I X'="" S ^LBRY(681,"AD",$E(X,1,30),DA)=""
END G ^LBRYX24
