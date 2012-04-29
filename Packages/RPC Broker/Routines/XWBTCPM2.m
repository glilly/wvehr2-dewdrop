XWBTCPM2 ;ISF/RWF - BROKER Other Service ;08/01/2006  7924986.008072
 ;;1.1;RPC BROKER;**45**;Mar 28, 1997
 Q
OTH ;Check if some other special service.
 S $ETRAP="D ERR^XWBTCPM2"
 I XWB="~EAC~" G EAC
 I XWB="~BSE~" G BSE
 I XWB="~SVR~" G SVR
 D LOG("Prefix not known: "_XWB)
 Q
 ;
SVR ;Handle
 Q
EAC ;Enterprise Access
 Q
 ;
BSE ;Broker Security Enhansment
 D LOG("BSE msg")
 N L,HDL,RET,XWBSBUF
 S XWBSBUF="",RET=""
 S L=$$BREAD^XWBRW(3) I L S HDL=$$BREAD^XWBRW(L)
 ;Check IT
 D GETVISIT^XUSBSE1(.RET,HDL)
 D WRITE(RET),WBF
 Q
 ;
ERR ;Error Trap
 D ^%ZTER
 G H2^XUSCLEAN
 ;
LOG(%) ;Link to logger
 Q:'$G(XWBDEBUG)
 D LOG^XWBTCPM(%)
 Q
 ;
WRITE(M,F) ;Write
 N L S L="" I '$G(F) S L=$E(1000+$L(M),2,4)
 D WRITE^XWBRW(L_M)
 Q
WBF ;Buffer Flush
 D WBF^XWBRW
 Q
 ;
OPEN(P1,P2) ;Open the device and set the variables
 D CALL^%ZISTCP(P1,P2) Q:POP
 S XWBTDEV=IO
 Q
 ;
CALLBSE(SERVER,PORT,TOKEN) ;Special Broker service
 N XWBDEBUG,XWBOS,XWBRBUF,XWBSBUF,XWBT,XWBTIME,IO
 N DEMOSTR,XWBTDEV,RET
 S IO(0)=$P
 D INIT^XWBTCPM,LOG("CALLBSE")
 D OPEN(SERVER,PORT) I POP Q "Didn't open connection." Q
 S XWBSBUF="",XWBRBUF=""
 U XWBTDEV
 D WRITE("~BSE~",1),WRITE(TOKEN),WBF^XWBRW
 S X=$$BREAD^XWBRW(3),RET="No Response" I X S RET=$$BREAD^XWBRW(X)
 D CLOSE^%ZISTCP,LOG("FINISH")
 Q RET
