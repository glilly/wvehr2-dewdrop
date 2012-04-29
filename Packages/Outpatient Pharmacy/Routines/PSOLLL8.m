PSOLLL8 ;BIR/JLC - LASER LABEL - CRITICAL INTERACTION ;12/13/02
 ;;7.0;OUTPATIENT PHARMACY;**120**;DEC 1997
 ;
 ;Reference to PS(56 supported by DBIA 2229
 ;Reference to PSDRUG supported by DBIA 221
 ;
 S HOLDCOPY=COPIES
START ;
 I $G(PSOIO("CDII"))]"" X PSOIO("CDII")
 I $G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
 K PSOSERV
 S COPIES=COPIES-1,Y=$P(^PSRX(RX,2),"^",6) X ^DD("DD") S EXPDT=Y,Y=$P(^PSRX(RX,0),"^",13) X ^DD("DD") S ISD=Y
 S Y=DATE X ^DD("DD") S DATE1=Y D NOW^%DTC S Y=% X ^DD("DD") S NOW=Y
 I '$D(^PS(52.4,RX,0)),$P(^PSRX(RX,"STA"),"^")=4 D UNKNOWN Q
 I '$G(RXRP(RX)) S T=$P(PS2,"^",2)_" "_"("_$P(RXY,"^",16)_"/"_$S(+$G(VRPH):VRPH,1:" ")_")"_" "_$P(NOW,":",1,2) D PRINT(T)
2 S PSOY=PSOY+PSOYI,T="This prescription has caused a DRUG-DRUG INTERACTION." D PRINT(T)
 S PSOY=PSOY+PSOYI,T="Rx# "_RXN_" has caused a DRUG-DRUG INTERACTION with the following prescription(s):" D PRINT(T) S PSOY=PSOY+PSOYI
 I $D(^PS(52.4,RX,0)) S SCRIPT=$P(^PS(52.4,RX,0),"^",10),SEV=$P(^PS(52.4,RX,0),"^",9) F X=1:1 S RXX(X)=$P(SCRIPT,",",X),SEV(X)=$P(SEV,",",X) Q:RXX(X)=""  D
 .S SER=$P(^PS(56,SEV(X),0),"^",4) S:$G(SER)=1 PSOSERV=1
 .S T=$P($G(^PSRX(RXX(X),0)),"^")_"     "_$S(SER=1:"CRITICAL",SER=2:"SIGNIFICANT",1:"UNKNOWN")_" INTERACTION    "_$P(^PSDRUG($P(^PSRX(RXX(X),0),"^",6),0),"^") D PRINT(T)
 I '$D(^PS(52.4,RX,0)),$D(^PSRX(RX,"DRI")) S SCRIPT=$P(^PSRX(RX,"DRI"),"^",2),SEV=$P(^PSRX(RX,"DRI"),"^") F X=1:1 S RXX(X)=$P(SCRIPT,",",X),SEV(X)=$P(SEV,",",X) Q:RXX(X)=""  D
 .S SER=$P(^PS(56,SEV(X),0),"^",4)
 .S T=$P($G(^PSRX(RXX(X),0)),"^")_"  "_$S(SER=1:"CRITICAL",SER=2:"SIGNIFICANT",1:"UNKNOWN")_" INTERACTION   "_$P(^PSDRUG($P(^PSRX(RXX(X),0),"^",6),0),"^") D PRINT(T)
 S PSOY=PSOY+PSOYI
 S T="This prescription was entered by: "_TECH D PRINT(T)
 S PSOY=PSOY+PSOYI,T="This prescription "_$S('$G(PSOSERV):"may require",1:"requires")_" "_$S('$G(PSOSERV):"reviewing",1:"intervention")_" by a pharmacist" D PRINT(T)
 S PSOY=PSOY+PSOYI
 S T=DATE1_"  Fill "_(RXF+1)_" of "_(1+$P(RXY,"^",9)) D PRINT(T)
 S T=PNM_"  "_SSNP D PRINT(T)
 F SSG=1:1 Q:$G(SGY(SSG))=""  S T=SGY(SSG) D PRINT(T)
 S T="Qty: "_$G(QTY)_"   "_$G(PHYS) D PRINT(T)
 S T="Tech__________RPh__________" D PRINT(T)
 S T=DRUG D PRINT(T)
 S T="Routing: "_$S("W"[$E(MW):MW,1:MW_" MAIL") D PRINT(T)
 S T="Days supply: "_$G(DAYS)_" Cap: "_$S(PSCAP:"**NON-SFTY**",1:"SAFETY") D PRINT(T)
 S T="Isd: "_ISD_" Exp: "_EXPDT D PRINT(T)
 S T="Last Fill: "_$G(PSOFLAST) D PRINT(T)
 S T="Pat. Stat "_PATST_" Clinic: "_PSCLN D PRINT(T)
 W @IOF
 I COPIES>0 G START
 S COPIES=HOLDCOPY K HOLDCOPY
STORE ;LABEL PRINT NODE
 D NOW^%DTC S NOW=% K %,%H,%I I $G(RXF)="" S RXF=0 F I=0:0 S I=$O(^PSRX(RX,1,I)) Q:'I  S RXF=I
 F IR=0 F FDA=0:0 S FDA=$O(^PSRX(RX,"L",FDA)) Q:'FDA  S IR=FDA
 S IR=IR+1,^PSRX(RX,"L",0)="^52.032DA^"_IR_"^"_IR,^PSRX(RX,"L",IR,0)=NOW_"^"_RXF_"^"_$S($G(PCOMX)]"":$G(PCOMX),1:"From RX number "_$P(^PSRX(RX,0),"^"))_" Drug-Drug interaction"_$S($G(RXRP(RX)):" (Reprint)",1:"")_"^"_PDUZ_"^1"
 K:$D(^PS(52.4,RX,0)) RXF,IR,FDA,NOW,I
END K:$D(^PS(52.4,RX,0)) PSCLN,DATE1,DRUG,RFLMSG,COPIES,DRUG,LMI,LINE,PS,PS1,PS2,INT,ISD,I1,MW,STATE,SIDE,SGY,PATST,PRTFL,PHYS,SGC,VRPH,NLWS,X1,X2,X,Y,TECH,EXPDT,NURSE,SEV,SCRIPT,RXX,SGY,SER,SSG,RXY,SIGPH,PS55,PS55X K PSOSERV
 Q
UNKNOWN S PSOY=PSOY+(3*PSOYI),T="",$P(T,"*",100)="" D PRINT(T)
 S T="THIS PRESCRIPTION HAS CAUSED A DRUG-DRUG INTERACTION " D PRINT(T)
 S T="",$P(T,"*",100)="" D PRINT(T)
 S T="PRESCRIPTION # "_$P(^PSRX(RX,0),"^")_"  "_$P(^PSDRUG($P(^PSRX(RX,0),"^",6),0),"^") D PRINT(T)
 S T="The above prescription has a status of PENDING due to a DRUG-DRUG INTERACTION." D PRINT(T)
 S T=PNM_"  "_SSNP D PRINT(T)
 S T=$P(PS2,"^",2)_" ("_$P(RXY,"^",16)_"/"_$S(+$G(VRPH):VRPH,1:" ")_")"_" "_$P($P(NOW,":",1,2),"@") D PRINT(T)
 S T=RXN_"  "_DATE1_" Fill "_(RXF+1)_" of "_(1+$P(RXY,"^",9)) D PRINT(T)
 F SSG=1:1 Q:$G(SGY(SSG))=""  S T=SGY(SSG) D PRINT(T)
 S PSOY=PSOY+PSOYI,T="Please review printouts of all labels for this patient that follow." D PRINT(T),STORE
 W @IOF K PSCLN,DATE1,DRUG,RFLMSG,COPIES,DRUG,LMI,LINE,PS,PS1,PS2,INT,ISD,I1,MW,STATE,SIDE,SIGPH,SGY,PATST,PRTFL,PHYS,SGC,VRPH,NLWS,X1,X2,X,Y,TECH,EXPDT,NURSE,SEV,SCRIPT,RXX,SGY,SER,SSG,RXY,PSOSERV Q
 ;
PRINT(T) ;
 I $G(PSOIO("ST"))]"" X PSOIO("ST")
 W T,!
 I $G(PSOIO("ET"))]"" X PSOIO("ET")
 Q
