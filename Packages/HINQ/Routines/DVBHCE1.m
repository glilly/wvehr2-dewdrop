DVBHCE1 ; ;09/24/12
 S X=DE(42),DIC=DIE
 ;
 S X=DE(42),DIC=DIE
 X ^DD(2,.32945,1,2,2.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.32)):^(.32),1:"") S X=$P(Y(1),U,15),X=X S DIU=X K Y S X="" S DIH=$G(^DPT(DIV(0),.32)),DIV=X S $P(^(.32),U,15)=DIV,DIH=2,DIG=.3296 D ^DICR
