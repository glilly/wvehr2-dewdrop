XUSER1 ;ISF/RWF - User file Utilities ;10/24/2002  15:57
 ;;8.0;KERNEL;**169,210,222**;Jul 10, 1995
 Q
 ;
PAGE() ;Do a page break; Return 0 if ok to continue, 1 if to abort
 N DIR
 S DIR(0)="E" D ^DIR:($E(IOST,1,2)["C-")
 Q:$D(DIRUT) 1 W @IOF S ($X,$Y)=0
 Q 0
 ;
GKEYS(IE,XUA) ;Get the keys held. IE=user
 N %,V,XUB
 S %=0 ;Sort list alphabetical
 F  S %=$O(^VA(200,IE,51,%)) Q:(%'>0)  S V=$P($G(^DIC(19.1,%,0)),U,1) I $L(V) S XUB(V)=""
 S V="" ;return to user
 F %=1:1 S V=$O(XUB(V)) Q:'$L(V)  S XUA(%)=V
 Q
 ;
SHLIST(ARRAY,LM,SP) ; Show a list, Array=list, LM=Left Margin, SP=spacing
 ;Set DN=0 to get FM22 to stop the print
 N %,Y2,Y4,Y5,Y6,DIR
 I $Y+4>IOSL,$$PAGE S DN=0 Q
 S Y4=-1,%=0,Y2=IOM-LM\SP,Y5=0
 F  S %=$O(ARRAY(%)),Y4=Y4+1 Q:(%'>0)!$D(DIRUT)  S Y6=$G(ARRAY(%)) D:$L(Y6)
 . S:Y4'<SP Y4=0 S Y5=(Y4*Y2+LM)
 . I $X>0,Y5+$L(Y6)'<IOM S Y4=0,Y5=(Y4*Y2+LM)
 . I 'Y4 W ! I $Y+3>IOSL S Y4=0,Y5=(Y4*Y2+LM) I $$PAGE S DN=0 Q
 . W ?Y5,Y6 S:(($X+1)>(Y5+Y2)) Y4=Y4+1
 . Q
 Q
 ;
SHPC(IE) ;Show the Person Class
 N %,Y S:'$D(DT) DT=$$DT^XLFDT
 S %=$X,Y=$$GET^XUA4A72(IE,DT)
 I $L(Y) W $P(Y,U,2) I $L($P(Y,U,3)) W !,?(%+2),$P(Y,U,3) I $L($P(Y,U,4)) W !,?(%+4),$P(Y,U,4)
 Q
GMG(IE,XUA) ;Get mail groups
 N %,Y,XUI,Y4,Y2,XUK
 S %=0
 F  S %=$O(^XMB(3.8,"AB",IE,%)) Q:%'>0  S XUA(%)=$P($G(^XMB(3.8,%,0)),U,1)
 Q
GPARAM(IE,PRAM,XUA) ;Get an entry from the Parameter tool
 ;IE is the user to get the list for. PARAM what parameter, XUA return array.
 N XUENT,XUX,XUERR,XU1
 S XUENT=IE_";VA(200,"_$S($G(^VA(200,IE,5)):"^SRV.`"_+$G(^(5)),1:""),XUA=""
 D GETLST^XPAR(.XUX,XUENT,PRAM,"E",.XUERR)
 Q:XUX'>0
 S XUA(.5)=PRAM_":"
 F %=1:1:XUX S XUA(%)=$P(XUX(%),U,2)
 Q
 ;
DIVCHG ;Allow user to change Division [DUZ(2)] value
 ;Called from option: XUSER DIV CHG
 N Y,X,DIC,I,CD
 I '$D(^VA(200,+$G(DUZ),0))#2 W !,"You are not a valid user.",!!,$C(7) Q
 I $G(DUZ(2))="" D  ;Should not happen
 . N XOPT D XOPT^XUS1A S DUZ(2)=$P(XOPT,U,17)
 S CD=$$NS^XUAF4(DUZ(2))
 W !,"Your current Division is ",$P(CD,U)_"  "_$P(CD,U,2)
 S X=+$O(^VA(200,DUZ,2,0)),Y=+$O(^(X))
 I 'Y W !,"You do not have any choices. ",!," Change is not possible.",!! Q
 K DIC S DIC="^VA(200,DUZ,2,",DIC(0)="AEMNQ"
 S DIC("S")="I $G(^DIC(4,+Y,99))"
 ;Check if user has a default
 S X=$O(^VA(200,DUZ,2,"AX1",1,0)) S:X>0 DIC("B")=$P($$NS^XUAF4(X),U)
 D ^DIC K DIC
 I Y'>0 D  Q
 .W !,$C(7),"Division Unchanged - Currently you are assigned to "
 .W $P(CD,U)_"  "_$P(CD,U,2),!
 S DUZ(2)=+Y,CD=$$NS^XUAF4(DUZ(2))
 W !?5,"Division is now set to [ ",$P(CD,U)_"  "_$P(CD,U,2)," ]",!
 Q
