PSGOE4  ;BIR/CML3 - REGULAR ORDER ENTRY ;02/06/01 4:31 PM
        ;;5.0;INPATIENT MEDICATIONS;**2,50,64,58,111,113,245**;16 DEC, 1997;Build 3
        ;
        ; Reference to ^PS(51.2 is supported by DBIA 2178.
        ; Reference to ^PS(51.1 is supported by DBIA 2177.
        ;
        K PSGOES S PSGMR=$S($P(PSGNEDFD,"^",2):$P(PSGNEDFD,"^",2),1:PSGOEDMR),PSGSCH=$P(PSGNEDFD,"^",4),PSGPR=PSGOEPR,(PSGSD,PSGFD,PSGSM,PSGHSM,PSGUD,PSGSI,PSGOROE1,PSGNEFD,PSGMRN)=""
        S:PSGMR PSGMRN=$S('$P(PSGNEDFD,"^",2):"ORAL",'$D(^PS(51.2,PSGMR,0)):PSGMR,$P(^(0),"^")]"":$P(^(0),"^"),1:PSGMR) I PSGPR S PSGPRN=$P($G(^VA(200,PSGPR,0)),"^") S:PSGPRN="" PSGPRN=PSGPR
        S PSGST=$S($P(PSGNEDFD,"^",3)]"":$P(PSGNEDFD,"^",3),1:"C"),PSGSTN=$$ENSTN^PSGMI(PSGST),F1=53.1 K PSGFOK S PSGFOK(2)=""
        S:$P(PSJSYSU,";",4) PSGFOK(2)="" K ^PS(53.45,PSJSYSP,1),^(2) I PSGDRG S ^(2,0)="^53.4502P^"_PSGDRG_"^1",^(1,0)=PSGDRG,^PS(53.45,PSJSYSP,2,"B",PSGDRG,1)=""
        ;
109     ; dosage ordered
        I $P(PSJSYSU,";",4) D GETDOSE^PSJDOSE(PSGDRG) G:PSGOROE1 DONE G:'$G(PSGOE3) 3
        W !,"DOSAGE ORDERED: ",$S(PSGDO]"":PSGDO_"// ",1:"") R X:DTIME I X="^"!'$T W:'$T $C(7) S PSGOROE1=1 G DONE
        I X="" S X=PSGDO ;I X="" W $C(7),"  (Required)" G 109
        S PSGF2=109 I X="@" S PSGDO="" ;W $C(7),"  (Required)" G 109
        I X="@" D DEL G:%'=1 109 S (PSGDO,PSGFOK(109),PSGUD)="" G 3
        I X?1."?" D ENHLP^PSGOEM(53.1,109) G 109
        I $E(X)="^" D FF G:Y>0 @Y G 109
        I $E(X,$L(X))=" " F  S X=$E(X,1,$L(X)-1) Q:$E(X,$L(X))'=" "
        I $S(X="":0,X?.E1C.E:1,$L(X)>20:1,X="":1,X["^":1,X?1.P:1,1:X=+X) W $C(7),"  ",$S(X?1.P!(X=""):"(Required)",1:"??") D ENHLP^PSGOEM(53.1,109) G 109
        S PSGDO=X,PSGFOK(109)=""
        ;
13      ; units per dose
        ;/** NO LONGER USE WITH POE
        Q:$G(PSGOE3)
        G:'$P(PSJSYSU,";",4) 3 I $D(PSGFOK(13)) S PSGFOK(13)=1 D 2^PSGOE42 S PSGFOK(13)="" G 3
        ;
A13     ;
        W !,"UNITS PER DOSE: ",$S(PSGUD:PSGUD_"// ",1:"") R X:DTIME I X="^"!'$T S PSGOROE1=1 G DONE
        I X="" W:'PSGUD "  (1)" G S13
        S PSGF2=13 I X="@",'PSGUD W $C(7),"  ??" S X="?" D ENHLP^PSGOEM(53.1,13) G A13
        I X="@" D DEL G:%'=1 13 S PSGUD="" G S13
        I X?1."?" D ENHLP^PSGOEM(53.1,13) G A13
        I $E(X)="^" D FF G:Y>0 @Y G A13
        I X?1.2N1"/"1.2N S X=+$J(+X/$P(X,"/",2),0,2) W "  ("_$E("0",X<1)_X_")"
        I $S($L(X)>12:1,X'=+X:1,X>50:1,X<0:1,1:X?.N1"."3.N) W $C(7),"  ??" S X="?" D ENHLP^PSGOEM(53.1,13) G 13
        S PSGUD=X W:'X "  (1)"
        ;
S13     ;
        S PSGFOK(13)="" I PSGDRG S $P(^PS(53.45,PSJSYSP,2,1,0),"^",2)=PSGUD
        ;
3       ; med route
        W !,"MED ROUTE: ",$S(PSGMR:PSGMRN_"// ",1:"") R X:DTIME I X="^"!'$T W:'$T $C(7) S PSGOROE1=1 G DONE
        I X="",PSGMR S X=PSGMRN I PSGMR'=PSGMRN,$D(^PS(51.2,PSGMR,0)) W "  "_$P(^(0),"^",3) S PSGFOK(3)=""
        S PSGF2=3 I $S(X="@":1,X]"":0,1:'PSGMR) W $C(7),"  (Required)" S X="?" D ENHLP^PSGOEM(53.1,2) G 3
        I X?1."?" D ENHLP^PSGOEM(53.1,3)
        I $E(X)="^" D FF G:Y>0 @Y G 3
        K DIC S DIC="^PS(51.2,",DIC(0)="EMQZ",DIC("S")="I $P(^(0),""^"",4)" D ^DIC K DIC I Y'>0 G 3
        S PSGMR=+Y,PSGMRN=$P(Y(0),"^") S PSGFOK(3)=""
        Q:$G(PSGOE3)
        ;
26      ; schedule
        W !,"SCHEDULE: ",$S(PSGSCH]"":PSGSCH_"// ",1:"") R X:DTIME I X="^"!'$T W:'$T $C(7) S PSGOROE1=1 G DONE
        S PSGF2=26 S:X="" X=PSGSCH,PSGSCH="" I "@"[X W $C(7),"  (Required)" S X="?" D ENHLP^PSGOEM(53.1,26) G 26
        I X?1."?" D ENHLP^PSGOEM(53.1,26) G 26
        I $E(X)="^" D FF G:Y>0 @Y G 26
        S DOW=0 I $$DOW^PSIVUTL(X) S DOW=1,PSGST="C",PSGSTN=$$ENSTN^PSGMI(PSGST),PSGS0Y=$P(X,"@",2)
        N PSJSLUP S PSJSLUP=1 D EN^PSGS0 I '$D(X) W $C(7),"  ??" S X="?" D ENHLP^PSGOEM(53.1,26) G 26
        I PSGSCH[" PRN",$$PRNOK^PSGS0(PSGSCH) S PSGST="P",PSGSTN=$$ENSTN^PSGMI(PSGST)
        S PSGSCH=X,$P(PSGNEDFD,"^",4)=X,PSGFOK(26)="" I PSGS0XT="O" S $P(PSGNEDFD,"^",3)="O",PSGST="O",PSGSTN=$$ENSTN^PSGMI(PSGST)
        I $G(PSGOE3) D  Q
        . S PSGSCH=X,PSGST=$S($G(DOW):"C",PSGS0XT="O":"O",PSGST="R":"R",X["PRN":"P",X="ON CALL":"OC",PSGST]"":PSGST,1:"C"),PSGFOK(26)=""
        . S $P(PSGNEDFD,"^",3)=PSGST S:PSGSCH=""!(X?1." ") PSGSCH="PRN"
        . S PSGSTN=$$ENSTN^PSGMI(PSGST)
        ;
7       ; schedule type
        Q:$G(PSGOE3)
        D  ;Default Schedule Type from Schedule file - PSJ*5*113 - DRF
        . N XX
        . I $$DOW^PSIVUTL(PSGSCH) S PSGST="C",PSGSTN=$$ENSTN^PSGMI(PSGST) Q
        . I PSGSCH[" PRN",$$PRNOK^PSGS0(PSGSCH) S PSGST="P",PSGSTN=$$ENSTN^PSGMI(PSGST) Q
        . I PSGSCH]"" D
        .. S XX=+$O(^PS(51.1,"AC","PSJ",PSGSCH,0))
        .. S PSGST=$P($G(^PS(51.1,XX,0)),"^",5) I PSGST="D" S PSGST="C"
        .. S PSGSTN=$$ENSTN^PSGMI(PSGST)
        W !,"SCHEDULE TYPE: "_$S(PSGSTN]"":PSGSTN_"// ",1:"") R X:DTIME S X=$TR(X,"coprocf","COPROCF") I X="^"!'$T S PSGOROE1=1 W $C(7) G DONE
        I X="" S:PSGST="OC" PSGSCH=PSGSTN,(PSGS0Y,PSGS0XT)="" W "  "_PSGSTN S PSGFOK(7)="" S $P(PSGNEDFD,"^",3)=PSGST G ^PSGOE41
        S PSGF2=7 I X="@"!(X?1."?") W:X="@" $C(7),"  ??  (Required)" S:X="@" X="?" D ENHLP^PSGOEM(53.1,7) G 7
        I $E(X)="^" D FF G:Y>0 @Y G 7
        S:X="F" X="R"
        I X="OC"!(X="R")!(X="P") S PSGST=X,$P(PSGNEDFD,"^",3)=X,PSGSTN=$S(X="P":"PRN",X="R":"FILL on REQUEST",1:"ON CALL") W "  "_PSGSTN S PSGFOK(7)="" G:X="R" 8^PSGOE41 S PSGSCH=PSGSTN,(PSGS0Y,PSGS0XT)="" G 8^PSGOE41
        F Y="C^CONTINUOUS","O^ONE TIME","OC^ON CALL","P^PRN","R^FILL on REQUEST" I $P($P(Y,"^",2),X)="" W $P($P(Y,"^",2),X,2) S PSGST=$P(Y,"^"),PSGSTN=$P(Y,"^",2),$P(PSGNEDFD,"^",3)=PSGST Q
        E  W $C(7),"  ??" S X="?" D ENHLP^PSGOEM(53.1,7) G 7
        I PSGST="OC"!(PSGST="R") S PSGFOK(7)="" G:PSGST="R" 8^PSGOE41 S PSGSCH=PSGSTN,(PSGS0Y,PSGS0XT)="" G 8^PSGOE41
        S PSGFOK(7)=""
        ;
        G ^PSGOE41
        ;
DONE    ;
        I PSGOROE1 K Y W $C(7),"  ...order not entered..."
        K F,F0,F1,PSGF2,F3,PSG,PSGSD,SDT Q
        ;
FF      ; up-arrow to another field
        D ENFF^PSGOEM I Y>0,Y'=109,Y'=13,Y'=3,Y'=7,Y'=26 S:Y=2 FB=PSGF2_"^PSGOE4" S Y=Y_"^PSGOE4"_$S("^39^8^10^25^"[("^"_Y_"^"):1,1:2)
        Q
        ;
DEL     ; delete entry
        W !?3,"SURE YOU WANT TO DELETE" S %=0 D YN^DICN I %'=1 W $C(7),"  <NOTHING DELETED>"
        Q
