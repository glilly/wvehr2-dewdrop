YSXRAK1 ; COMPILED XREF FOR FILE #615.2 ; 09/19/10
 ;
 S DIKZK=2
 S DIKZ(0)=$G(^YS(615.2,DA,0))
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^YS(615.2,"AC",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^YS(615.2,"C",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,4)
 I X'="" K ^YS(615.2,"AE",$P(^YS(615.2,DA,0),"^",3),$E(X,1,30),DA)
 S DIKZ(25)=$G(^YS(615.2,DA,25))
 S X=$P(DIKZ(25),U,2)
 I X'="" K ^YS(615.2,"AF",$P(^YS(615.2,DA,0),"^",2),DA)
 S DIKZ(40)=$G(^YS(615.2,DA,40))
 S X=$P(DIKZ(40),U,5)
 I X'="" K ^YS(615.2,"AC",$P(^YS(615.2,DA,0),"^",2),DA)
 S X=$P(DIKZ(40),U,5)
 I X'="" K ^YS(615.2,"AD",$P(^YS(615.2,DA,0),"^",2),DA)
 S DIKZ(50)=$G(^YS(615.2,DA,50))
 S X=$P(DIKZ(50),U,5)
 I X'="" K ^YS(615.2,"AD",$P(^YS(615.2,DA,0),"^",2),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^YS(615.2,"B",$E(X,1,30),DA)
END G ^YSXRAK2
