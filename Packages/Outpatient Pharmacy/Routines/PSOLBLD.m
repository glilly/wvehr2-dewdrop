PSOLBLD ;BHAM ISC/RTR - PRINTS LABEL ; 4/14/93
 ;;7.0;OUTPATIENT PHARMACY;**117**;DEC 1997
 ;External reference to ^PS(56 supported by DBIA 2229
 ;External reference to ^PSDRUG supported by DBIA 221
 S HOLDCOPY=COPIES
START ;
 K PSOSERV
 S COPIES=COPIES-1,Y=$P(^PSRX(RX,2),"^",6) X ^DD("DD") S EXPDT=Y,Y=$P(^PSRX(RX,0),"^",13) X ^DD("DD") S ISD=Y
 S Y=DATE X ^DD("DD") S DATE1=Y D NOW^%DTC S Y=% X ^DD("DD") S NOW=Y
 S:'$P($G(^PS(59,+$G(PSOSITE),1)),"^",28) TB1=38,TB2=50,TB3=83 S:$P($G(^PS(59,+$G(PSOSITE),1)),"^",28) TB1=54,TB2=66,TB3=102
 I '$D(^PS(52.4,RX,0)),$P(^PSRX(RX,"STA"),"^")=4 D UNKNOWN D  Q
 .I $P(PSOPAR,"^",31),$P($G(^PSRX(RX,"STA")),"^")=4 D BLANK W @IOF
L1 W !,"***********************************",?TB3 W:$G(RXRP(RX)) "(REPRINT)" I '$G(RXRP(RX)) W $P(PS2,"^",2)," ","("_$P(RXY,"^",16)_"/"_$S(+$G(VRPH):VRPH,1:" ")_")"_" ",$P(NOW,":",1,2)
L2 W !,"* THIS PRESCRIPTION HAS CAUSED A  *",?TB1,"PRESCRIPTION # "_RXN_" HAS",?TB3,RXN,"  ",DATE1,"  Fill ",RXF+1," of ",1+$P(RXY,"^",9)
L3 W !,"*     DRUG-DRUG INTERACTION       *",?TB1,"CAUSED A DRUG-DRUG INTERACTION",?TB3,PNM,"  ",SSNP
L4 W !,"***********************************",?TB1,"WITH THE FOLLOWING PRESCRIPTION(S):",?TB3,$S($G(OSGY(1))]"":OSGY(1),1:$G(SGY(1)))
L5 W !,?TB3,$S($G(OSGY(2))]"":OSGY(2),1:$G(SGY(2)))
 I $G(SGY(3))'="" F SSG=3:1 Q:$G(SGY(SSG))=""  W !,?TB3,$S($G(OSGY(SSG))]"":OSGY(SSG),1:$G(SGY(SSG)))
L6 I $D(^PS(52.4,RX,0)) S SCRIPT=$P(^PS(52.4,RX,0),"^",10),SEV=$P(^PS(52.4,RX,0),"^",9) F X=1:1 S RXX(X)=$P(SCRIPT,",",X),SEV(X)=$P(SEV,",",X) Q:RXX(X)=""  D
 .S SER=$P(^PS(56,SEV(X),0),"^",4) S:$G(SER)=1 PSOSERV=1 W !?TB1,$P($G(^PSRX(RXX(X),0)),"^"),?TB2,$S(SER=1:"CRITICAL",SER=2:"SIGNIFICANT",1:"UNKNOWN")," INTERACTION",!?TB1,"  ",$P(^PSDRUG($P(^PSRX(RXX(X),0),"^",6),0),"^")
 I '$D(^PS(52.4,RX,0)),$D(^PSRX(RX,"DRI")) S SCRIPT=$P(^PSRX(RX,"DRI"),"^",2),SEV=$P(^PSRX(RX,"DRI"),"^") F X=1:1 S RXX(X)=$P(SCRIPT,",",X),SEV(X)=$P(SEV,",",X) Q:RXX(X)=""  D
 .S SER=$P(^PS(56,SEV(X),0),"^",4) W !,?TB1,$P($G(^PSRX(RXX(X),0)),"^"),?TB2,$S(SER=1:"CRITICAL",SER=2:"SIGNIFICANT",1:"UNKNOWN")," INTERACTION",!?TB1,"  ",$P(^PSDRUG($P(^PSRX(RXX(X),0),"^",6),0),"^")
L7 W !
L8 W !,?TB1,"THIS PRESCRIPTION WAS ENTERED BY: ",?TB3,"Qty: "_$G(QTY),"   ",$G(PHYS)
L9 W !,?TB1,TECH,?TB3,"Tech__________RPh__________"
L10 W !,?TB1,"THIS PRESCRIPTION ",$S('$G(PSOSERV):"MAY REQUIRE",1:"REQUIRES"),?TB3,DRUG
L11 W !,?TB1,$S('$G(PSOSERV):"REVIEWING BY A PHARMACIST",1:"INTERVENTION BY A PHARMACIST"),?TB3,"Routing: "_$S("W"[$E(MW):MW,1:MW_" MAIL")
L12 W !,?TB3,"Days supply: ",$G(DAYS)," Cap: "_$S(PSCAP:"**NON-SFTY**",1:"SAFETY")
L13 W !,?TB3,"Isd: ",ISD," Exp: ",EXPDT
L14 W !,?TB3,"Last Fill: ",$G(PSOLASTF)
L15 W !,?TB3,"Pat. Stat ",PATST," Clinic: ",PSCLN
L16 W !,@IOF
 I COPIES>0 G START
 S COPIES=HOLDCOPY K HOLDCOPY
STORE ;LABEL PRINT NODE
 D NOW^%DTC S NOW=% K %,%H,%I I $G(RXF)="" S RXF=0 F I=0:0 S I=$O(^PSRX(RX,1,I)) Q:'I  S RXF=I
 F IR=0 F FDA=0:0 S FDA=$O(^PSRX(RX,"L",FDA)) Q:'FDA  S IR=FDA
 S IR=IR+1,^PSRX(RX,"L",0)="^52.032DA^"_IR_"^"_IR,^PSRX(RX,"L",IR,0)=NOW_"^"_RXF_"^"_$S($G(PCOMX)]"":$G(PCOMX),1:"From RX number "_$P(^PSRX(RX,0),"^"))_" Drug-Drug interaction"_$S($G(RXRP(RX)):" (Reprint)",1:"")_"^"_PDUZ_"^1"
 K:$D(^PS(52.4,RX,0)) RXF,IR,FDA,NOW,I
 I '$D(PSSPND),$P(PSOPAR,"^",18),$D(^PS(52.4,RX,0)) D CHCK2^PSOTRLBL
 I $P(PSOPAR,"^",31),$P($G(^PSRX(RX,"STA")),"^")=4 D BLANK W @IOF
END K:$D(^PS(52.4,RX,0)) PSCLN,DATE1,DRUG,RFLMSG,COPIES,DRUG,LMI,LINE,PS,PS1,PS2,INT,ISD,I1,MW,STATE,SIDE,SGY,PATST,PRTFL,PHYS,SGC,VRPH,NLWS,X1,X2,X,Y,TECH,EXPDT,NURSE,SEV,SCRIPT,RXX,SGY,SER,SSG,RXY,SIGPH,PS55,PS55X K TB1,TB2,TB3,PSOSERV
 Q
UNKNOWN W !!!,"***********************************",?TB1,"PRESCRIPTION # ",$P(^PSRX(RX,0),"^")
 W !,"* THIS PRESCRIPTION HAS CAUSED A  *",?TB1,"  ",$P(^PSDRUG($P(^PSRX(RX,0),"^",6),0),"^"),?TB3,$P(PS2,"^",2)_" ("_$P(RXY,"^",16)_"/"_$S(+$G(VRPH):VRPH,1:" ")_")"_" ",$P($P(NOW,":",1,2),"@")
 W !,"*     DRUG-DRUG INTERACTION       *",?TB3,RXN,"  ",DATE1," Fill ",RXF+1," of ",1+$P(RXY,"^",9)
 W !,"***********************************",?TB1,"The above prescription has a status",?TB3,PNM,"  ",SSNP
 W !,?TB1,"of PENDING due to a DRUG-DRUG INTERACTION.",?TB3,$S($G(OSGY(1))]"":OSGY(1),1:$G(SGY(1)))
 I $G(SGY(2))'="" F SSG=2:1 Q:$G(SGY(SSG))=""  W !,?TB3,$S($G(OSGY(SSG))]"":OSGY(SSG),1:$G(SGY(SSG)))
 W !,?TB1,"Please review printouts of all labels"
 W !,?TB1,"for this patient that follow." D STORE
 W @IOF K PSCLN,DATE1,DRUG,RFLMSG,COPIES,DRUG,LMI,LINE,PS,PS1,PS2,INT,ISD,I1,MW,STATE,SIDE,SIGPH,SGY,PATST,PRTFL,PHYS,SGC,VRPH,NLWS,X1,X2,X,Y,TECH,EXPDT,NURSE,SEV,SCRIPT,RXX,SGY,SER,SSG,RXY,TB1,TB2,TB3,PSOSERV Q
 ;
BLANK ;label between patients
 F ZBLANK=1:1:10 W !
 W !,"**********************NEXT PATIENT*************",?54,"*********NEXT PATIENT***********NEXT PATIENT***"
 K ZBLANK Q
