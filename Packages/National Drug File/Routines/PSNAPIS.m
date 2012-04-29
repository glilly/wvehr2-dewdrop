PSNAPIS ;BIR/DMA-APIs for NDF ; 07/02/03 14:07
        ;;4.0; NATIONAL DRUG FILE;**2,3,47,70,169**; 30 Oct 98;Build 8
        ;
        ;Reference to ^PSDRUG supported by DBIA #2192
        ;Reference to ^PS(50.606 supported by DBIA #2174
        ;
PSA(NDC,LIST)   ;ENTRY FOR DRUG ACCOUNTABILITY
        N Y,PN,PN1,P50,J
        S Y=$Q(^PSNDF(50.67,"NDC",NDC)) I $QS(Y,3)'=NDC Q 0
        S Y=^PSNDF(50.67,$QS(Y,4),0),Y=$P(Y,"^",6),PN=$P(^PSNDF(50.68,Y,0),"^"),PN1=$E(PN,1,30)
        S P50=0,J=0 F  S P50=$O(^PSDRUG("VAPN",PN1,P50)) Q:'P50  I $P(^PSDRUG(P50,"ND"),"^",2)=PN S LIST(P50)=$P(^PSDRUG(P50,0),"^"),J=J+1
        Q J
        ;
PSJING(DA1,K,LIST)      ;ENTRY FOR INGREDIENTS
        N X,CT
        ;DA1 IS SUPERFLUOUS, BUT WE LEAVE IN FOR COMPATABILITY
        I 'K!('$D(^PSNDF(50.68,+K))) Q 0
        S DA=0 F CT=0:1 S DA=$O(^PSNDF(50.68,K,2,DA)) Q:'DA  S X=^(DA,0),LIST(+X)=+X_"^"_$P(^PS(50.416,+X,0),"^")_"^"_$P(X,"^",2)_"^" S:$P(X,"^",3)]"" LIST(+X)=LIST(+X)_$P($G(^PS(50.607,$P(X,"^",3),0)),"^")
        Q CT
        ;
PSJDF(DA,K)     ;GET DOSE FORM
        N X,DF
        ;AGAIN DA IS SUPERFLUOUS
        I 'K!('$D(^PSNDF(50.68,+K))) Q 0
        S X=$P(^PSNDF(50.68,K,0),"^",3),DF=$P($G(^PS(50.606,X,0)),"^")
        Q X_"^"_DF
        ;
PSJST(DA,K)     ;ENTRY FOR STRENGTH
        I 'K!('$D(^PSNDF(50.68,K))) Q 0
        Q 1_"^"_$P(^PSNDF(50.68,K,0),"^",4)
        ;
CLASS(CL)       ;ENTRY FOR OE/RR TO GET CLASS $D
        I CL']"" Q 0
        Q $D(^PS(50.605,"C",CL))>0
        ;
DRUG(DA)        ;ENTRY FOR OE/RR TO GET DRUG $D
        I DA']"" Q 0
        Q $D(^PSNDF(50.6,"B",DA))!$D(^PSNDF(50.67,"T",DA))
        ;
PROD0(P1,P2)    ;GET INFO IN THE FORM OF THE OLD 0 PRODUCT NODE
        N A,B
        ;P1 IS SUPERFLUOUS
        I P2']"" Q ""
        S A=$G(^PSNDF(50.68,P2,0)),B=$G(^(1))
        Q $P(A,"^")_"^"_$P(A,"^",3,5)_"^^^"_$P(B,"^",5,6)
        ;
PROD2(P1,P2)    ;GET OLD 2 NODE
        ;P1 STILL SUPERFLUOUS
        I P2']"" Q ""
        Q $P($G(^PSNDF(50.68,P2,1)),"^",1,3)_"^"_$P($G(^PSNDF(50.64,+$P(^PSNDF(50.68,P2,1),"^",4),0)),"^")
        ;
DCLASS(DA,K)    ;GET CLASS FOR PRODUCT
        I K']"" Q ""
        S X=+$P($G(^PSNDF(50.68,+K,3)),"^"),Y=$P($G(^PS(50.605,X,0)),"^",2)
        Q X_"^"_Y
        ;
DCLCODE(DA,K)   ;RETURN VA CLASS CODE
        I K']"" Q ""
        S X=+$P($G(^PSNDF(50.68,+K,3)),"^"),X=$P($G(^PS(50.605,X,0)),"^")
        Q X
        ;
        ;DA IS SUPERFLUOUS
VAGN(DA)        ;GET VA GENERIC NAME
        I 'DA!'$D(^PSNDF(50.6,+DA,0)) Q 0
        Q $P(^PSNDF(50.6,+DA,0),"^")
        ;
FORMI(DA,K)     ;GET FORMULARY INDICATOR FOR VA PRODUCT
        ;DA IS SUPERFLUOUS
        ;1 if yes, 0 if no, null if not entered
        Q $P($G(^PSNDF(50.68,+K,5)),"^")
        ;
FORMR(DA,K)     ;GET EXISTENCE OF FORMULARY RESTRICTIONS
        ;DA IS SUPERFLUOUS
        Q $O(^PSNDF(50.68,+K,6,0))]""
        ;
DFSU(DA,K)      ;RETURN DOSE FORM, STRENGTH, AND UNITS FOR PDM AND CPRS
        N U1,UN
        I 'K!('$D(^PSNDF(50.68,+K,0))) Q 0
        S U1=+$P(^PSNDF(50.68,+K,0),"^",5),UN=$P($G(^PS(50.607,U1,0)),"^")
        Q $$PSJDF(DA,K)_"^"_$$PSJST(DA,K)_"^"_U1_"^"_UN
        ;
VAP(DA,LIST)    ;GIVEN GENERIC RETURN ARRAY LIST(IEN)=IEN^PRODUCT^DF PTR^DOSE FOMR
        N PR,J,X
        I 'DA!'$D(^PSNDF(50.6,+DA)) Q 0
        S PR=0,J=0 F  S PR=$O(^PSNDF(50.6,"APRO",DA,PR)) Q:'PR  S X=^PSNDF(50.68,PR,0),DAT=$P($G(^(7)),"^",3) D
        .S LIST(PR)=PR_"^"_$P(X,"^")_"^"_$P(X,"^",3)_"^"_$P($G(^PS(50.606,+$P(X,"^",3),0)),"^")_"^"_$P(^PSNDF(50.68,PR,3),"^")_"^"_$P($G(^PS(50.605,+$P(^PSNDF(50.68,PR,3),"^"),0)),"^"),J=J+1 I DAT,(DAT<DT) S LIST(PR)=LIST(PR)_"^I"
        Q J
        ;
PSPT(DA,K,LIST) ;GIVEN PRODUCT K RETURN LIST(INE1^IEN2)=IEN1^PSIZE^IEN1^PTYPE
        N NDC,J,PT,PS
        ;DA SUPERFLUOUS
        I 'K!'$D(^PSNDF(50.68,+K)) Q 0
        S NDC=0 F J=0:1 S NDC=$O(^PSNDF(50.68,"ANDC",K,NDC)) Q:'NDC  S X=^PSNDF(50.67,NDC,0),PS=$P(X,"^",8),PT=$P(X,"^",9),LIST(PS_"^"_PT)=PS_"^"_$P($G(^PS(50.609,PS,0)),"^")_"^"_PT_"^"_$P($G(^PS(50.608,PT,0)),"^")
        Q J
        ;
DSS(DA,K,DATE)  ;RETURN DSS FEEDER KEY
        ;NEW STYLE IF DATE IS MISSING OR NOT LESS THAN 199810
        ;OLD STYLE OTHERWISE
        S DATE=$G(DATE,999999)
        I DATE'<199810 Q $S($D(^PSNDF(50.68,+K)):$$RJ^XLFSTR(K,5,0),1:"00000")
        I $D(^PSNDF(50.6,+DA)),$D(^PSNDF(50.68,+K,7)) Q $$RJ^XLFSTR(DA,4,0)_$$RJ^XLFSTR($P(^PSNDF(50.68,+K,7),"^",9),3,0)
        Q "0000000"
        ;
CPRS(DA,K)      ;CALL FOR CPRS
        N CL,X,DF,ST,UN
        ;RETURNS X=DOSE FORM^CLASS^STRENGTH^UNITS
        I '$D(^PSNDF(50.68,+K)) Q 0
        S CL=$P($G(^PS(50.605,+$P(^PSNDF(50.68,K,3),"^"),0)),"^")
        S X=^PSNDF(50.68,K,0),DF=+$P(X,"^",3),ST=$P(X,"^",4),UN=+$P(X,"^",5)
        Q $P($G(^PS(50.606,DF,0)),"^")_"^"_CL_"^"_ST_"^"_$P($G(^PS(50.607,UN,0)),"^")
        ;
CIRN(NDC,LIST)  ;CALL FOR CIRN
        N DA,X,A
        I NDC["-" S NDC=$$RJ^XLFSTR($P(NDC,"-"),6,0)_$$RJ^XLFSTR($P(NDC,"-",2),4,0)_$$RJ^XLFSTR($P(NDC,"-",3),2,0)
        K LIST S LIST="000000000000" F J=1:1:7 S LIST(J)=""
        S DA=$O(^PSNDF(50.67,"NDC",NDC,0)) Q:'DA  S X=^PSNDF(50.67,DA,0),LIST(7)=$P(X,"^",2)_"^"_$P(X,"^",4,6)_"^",A=0 F  S A=$O(^PSNDF(50.67,DA,1,A)) Q:'A  S LIST(7)=LIST(7)_^(A,0)_" "
        S LIST(6)=$P(X,"^",9),LIST(5)=$P(X,"^",8),A=$P(X,"^",6),X=^PSNDF(50.68,A,0)
         S LIST(2)=$P(X,"^",3)_"^^"_$P(^PSNDF(50.68,A,3),"^"),LIST(3)=$P(X,"^",4),LIST(4)=$P(X,"^",5)
        S LIST(0)=$P(X,"^",2),LIST(1)=^PSNDF(50.6,$P(X,"^",2),0),LIST=NDC
        F J=1:1:7 I LIST(J)="NO DATA" S LIST(J)=""
        Q
        ;
B()     ;RETURNS THE GLOBAL ROOT OF THE "B" CROSSREFERENCE IN NDF
        Q "^PSNDF(50.6,""B"")"
        ;
T()     ;RETURNS THE GLOBAL ROOT OF THE "T" CROSSREFERENCE IN NDF
        Q "^PSNDF(50.67,""T"")"
        ;
TTOG(TRADE,LIST)        ;RETURNS LIST(IEN)=IEN_"^"GENERIC FOR EVERY ENTRY IN 50.6 WHICH MATCHES THE TRADE NAME
        I TRADE="" Q 0
        N X,CT
        I '$O(^PSNDF(50.67,"T",TRADE,0)) Q 0
        S (X,CT)=0 F  S X=$O(^PSNDF(50.67,"T",TRADE,X)) Q:'X  S Y=$P(^PSNDF(50.67,X,0),"^",6),Y=$P(^PSNDF(50.68,Y,0),"^",2) I '$D(LIST(Y)) S LIST(Y)=Y_"^"_$P(^PSNDF(50.6,Y,0),"^"),CT=CT+1
        Q CT
        ;
CLIST(DA,LIST)  ;RETURNS LIST(IEN)=IEN IN 50.605^CLASS CODE
        ;FOR EVERY CLASS IN PSNDF(50.6,DA)
        I 'DA Q 0
        I '$D(^PSNDF(50.6,+DA)) Q 0
        N K,CT S (K,CT)=0 F  S K=$O(^PSNDF(50.6,"APRO",DA,K)) Q:'K  S IEN=$P(^PSNDF(50.68,K,3),"^") I '$D(LIST(IEN)) S LIST(IEN)=IEN_"^"_$P(^PS(50.605,IEN,0),"^"),CT=CT+1
        Q CT
        ;
TGTOG(NAME)     ;GIVEN NAME TRY TO FIND IT IN T OR B CROSS REFERENCE AND RETURN IEN
        N X
        I NAME="" Q 0
        S X=$O(^PSNDF(50.6,"B",NAME,0)) I X Q X
        I '$O(^PSNDF(50.67,"T",NAME,0)) Q 0
        S X=$O(^PSNDF(50.67,"T",NAME,0)),X=$P(^PSNDF(50.67,X,0),"^",6),X=$P(^PSNDF(50.68,X,0),"^",2) Q X
        ;
TGTOG2(NAME,LIST)       ;PARTIAL LOOKUP ON T OR B
        I NAME="" Q
        N NAM,X,Y,CT
        S CT=0
        S NAM=$E(NAME,1,$L(NAME)-1)_$C($A($E(NAME,$L(NAME)))-1)_"z" F  S NAM=$O(^PSNDF(50.6,"B",NAM)),X=0 Q:NAM'[NAME  F  S X=$O(^PSNDF(50.6,"B",NAM,X)) Q:'X  S LIST(X)=X_"^"_$P(^PSNDF(50.6,X,0),"^"),CT=CT+1
        S NAM=$E(NAME,1,$L(NAME)-1)_$C($A($E(NAME,$L(NAME)))-1)_"z" F  S NAM=$O(^PSNDF(50.67,"T",NAM)),X=0 Q:NAM'[NAME  F  S X=$O(^PSNDF(50.67,"T",NAM,X)) Q:'X  S Y=$P(^PSNDF(50.67,X,0),"^",6),Y=$P(^PSNDF(50.68,Y,0),"^",2) D
        .I '$D(LIST(Y)) S LIST(Y)=Y_"^"_$P(^PSNDF(50.6,Y,0),"^"),CT=CT+1
        Q CT
        ;
CIRN2(P1,P3,LIST)       ;RETURN LIST OF NDCS FOR A PRODUCT
        I 'P3 Q 0
        I '$D(^PSNDF(50.68,+P3)) Q 0
        N D,N,J
        S N=0
        F J=0:1 S N=$O(^PSNDF(50.68,"ANDC",P3,N)) Q:'N  S LIST(J)=$P(^PSNDF(50.67,N,0),"^",2)
        Q J
        ;
CLASS2(IEN)     ;RETURNS FIRST 2 PIECES OF ZERO NODE OF 50.605
        Q $P($G(^PS(50.605,+IEN,0)),"^",1,2)
        ;
CMOP(CODE)      ;CODE = 5 CHARACTER CMOP CODE RETURNS PRODUCT NAME
        I CODE="" Q ""
        I '$O(^PSNDF(50.68,"C",CODE,0)) Q ""
        Q $P(^PSNDF(50.68,+$O(^PSNDF(50.68,"C",CODE,0)),0),"^")
        ;
FORMRX(DA,K,LIST)       ;RETURN X=1 FOR RESTRICTIONS, 0 FOR NO
        ;RETURNS LIST=WORD PROCESSING FIELD FOR RESTRICTIONS
        ;
        I '$O(^PSNDF(50.68,+K,6,0)) Q 0
        M LIST=^PSNDF(50.68,+K,6) Q 1
        ;
DDIEX(DA,K)     ;RETURN X=1 FOR EXCLUDE DDI CHECK, 0 FOR CONTINUE DDI CHECK
        ;
        I '$G(^PSNDF(50.68,+K,8)) Q 0
        I $G(^PSNDF(50.68,+K,8)) Q 1
        ;
OVRIDE(PSNPOV1,PSNPOV3) ;Return Override Dose Form Exclusion
        I '$G(PSNPOV3) Q ""
        Q $P($G(^PSNDF(50.68,+PSNPOV3,9)),"^")
