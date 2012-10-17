PSGNE3  ;BIR/CML3,MLM-DETERMINE DEFAULT FOR START & STOP TIMES ; 1/21/09 10:58am
        ;;5.0; INPATIENT MEDICATIONS ;**4,26,47,50,63,69,105,80,111,183,193**;16 DEC 97;Build 16
        ;
        ; Reference to ^PS(51.1 is supported by DBIA 2177
        ; Reference to ^PS(55 is supported by DBIA 2191
        ;
        N X1,X2,Y
NOW     ;
        ;D NOW^%DTC S PSGDT=+$E(%,1,12),PSGNESD=$$ENSD(PSGSCH,PSGS0Y,PSGDT,PSGDT)
        S:'$D(PSGST) PSGST=""
        S PSGDT=$$DATE^PSJUTL2(),PSGNESD=$$ENSD($S(PSGST["P":"PRN",1:PSGSCH),PSGS0Y,PSGDT,PSGDT)
        ;
STOP    ; exit when start date found
        K ET,F,FT,LT,NT,PSGNE3,TT G:$D(PSGOES)!$D(PSGODF) SF S PSGNESDO=$$ENDD^PSGMI(PSGNESD)
        Q
        ;
ENFD(PSGDT)     ; find default stop date
        N X1,X2,X3DMIN,Y
SF      I '$O(^PS(55,PSGP,5,"AUS",PSGDT)),'$D(^PS(53.1,"AC",PSGP)),+$G(^PS(55,PSGP,5.1)) S $P(^PS(55,PSGP,5.1),U)=""
        I $G(PSGOEA)="R",$P(PSJSYSW0,"^",4) D ENWALL(%,0,PSGP)
        S PSGNEFD="",PSGNEW=$S('$P(PSJSYSW0,U,4):0,+$G(^PS(55,PSGP,5.1))'>PSGDT:0,1:+$G(^PS(55,PSGP,5.1))) S:PSGNEW<PSGNESD PSGNEW=0
        I PSGNEW,($G(PSGOEA)="R") S X1=$P(%,"."),X2=3 D C^%DTC S PSGNEW=$S($P(X,".")_(PSGNESD#1)'>PSGNEW:PSGNEW,1:0)
        I PSGST="O" S PSGNEFD=$$ENOSD^PSJDCU(PSJSYSW0,PSGNESD,PSGP) I PSGNEFD]"" G OUT
        I PSGST'="O",PSGSCH]"",$S(PSGSCH="ONCE":1,PSGSCH="STAT":1,PSGSCH="ONE TIME":1,1:0)!($P($G(^PS(51.1,+$O(^PS(51.1,"B",PSGSCH,0)),0)),"^",5)="O") S PSGNEFD=$$ENOSD^PSJDCU(PSJSYSW0,PSGNESD,PSGP) I PSGNEFD]"" G OUT
        S X1=$P(PSGNESD,"."),X2=$S($P(PSJSYSW0,"^",3):+$P(PSJSYSW0,"^",3),1:14)
        D
         . ; *** ADDED VARIABLE AA TO CHECK FOR APPOINTMENT and CLINIC
         . ; *** psi 06 082 - RDC 08/2006
        . N A,AA,B
        . Q:'$D(PSGORD)  S A=""
        . I PSGORD["P" S A=$G(^PS(53.1,+PSGORD,"DSS"))
        . I PSGORD["U" S A=$G(^PS(55,PSGP,5,+PSGORD,8))
        . I PSGORD["I" S A=$G(^PS(55,PSGP,"IV",+PSGORD,"DSS"))
        . S A=$P(A,"^"),AA=$P(A,"^",2) I A,AA S X2=14 I $D(^PS(53.46,"B",A)) S B=$O(^PS(53.46,"B",A,"")),X2=$P(^PS(53.46,B,0),"^",2) I X2="" S X2=14
        D C^%DTC
        I $G(PSGNEDFD) I $S($P(PSGNEDFD,"^")["L":PSGS0XT!PSGS0Y,1:1) D DFD
        ;I PSGNEW S PSGNEFD=PSGNEW G OUT
        I $G(PSGORD),$G(PSGFD) S X3DMIN=$$GETDUR^PSJLIVMD(PSGP,+$G(PSGORD),$S($G(PSGORD)["P":"P",$G(PSGORD)["V":"IV",1:5),1) I X3DMIN]"" D  I PSGNEFD]"" G OUT
        . S X3DMIN=$$DURMIN^PSJLIVMD(X3DMIN) I $G(X3DMIN) S PSGNEFD=$$FMADD^XLFDT(PSGNESD,,,X3DMIN)
        S X=+(X_$S($P(PSJSYSW0,"^",7):"."_$P(PSJSYSW0,"^",7),1:(PSGNESD#1)))
        S PSGNEFD=$S('PSGNEFD:X,X<PSGNEFD:X,1:PSGNEFD) I PSGNEW,(PSGNEW<PSGNEFD),$P(PSJSYSW0,U,4) D
        . I $G(PSGORD),$G(PSGRDTX) I PSGORD=$P(PSGRDTX,U,4),PSGNEW<PSGRDTX Q   ; Requested Start is after Stop
        . S PSGNEFD=PSGNEW
        ;
OUT     ;
        S:$G(PSGSDX) PSGNESD=PSGSDX S:$G(PSGFDX) PSGNEFD=PSGFDX
        I '$D(PSGODF),'$D(PSGOES) S PSGNEFDO=$$ENDD^PSGMI(PSGNEFD)
        K PSGDL,PSGNEW Q
        ;
DFD     ;
        I $P(PSGNEDFD,"^")["D" S X1=$P(PSGNESD,"."),X2=+PSGNEDFD D C^%DTC S X=+(X_"."_$S($P(PSJSYSW0,"^",7):$P(PSJSYSW0,"^",7),1:$P(PSGNESD,".",2)))
        I $P(PSGNEDFD,"^")["L" S PSGDL=+PSGNEDFD D EN1^PSGDL
        S PSGNEFD=$S(PSGNEW<X&PSGNEW:PSGNEW,1:X) Q:$P(PSGNEDFD,"^")'["D"!'$P(PSJSYSW0,"^",4)!PSGNEW
        Q
        ;
ENOR    ;
        K PSGOES,PSGODF S X=$P($G(^PS(53.1,DA,2)),"^")
        S $P(^PS(53.1,DA,0),"^",7)=$S(X="PRN":"P",X="ONCE":"O",X="STAT":"O",X="ONE TIME":"O",X="ON CALL":"OC",$P(PSGNEDFD,"^",3)]"":$P(PSGNEDFD,"^",3),1:"C") D PSGNE3 S X=PSGNESD
        Q
        ;
ENSET0(DFN)     ; Set "0" node and build xrefs for entries found without one.
        N DA,DIK S ^PS(55,DFN,0)=DFN,DIK="^PS(55,",DIK(1)=.01,DA=DFN D EN^DIK
        S $P(^PS(55,DFN,5.1),"^",11)=2 ; Mark as converted for POE
        Q
        ;
ENWALL(SD,FD,DFN)       ; Update default stop date if appropriate.
        N WALL,NWALL,X1,X2,X3
        D NOW^%DTC S X3=%
        S WALL=+$G(^PS(55,DFN,5.1)),X1=$P(SD,"."),X2=3 D C^%DTC I +(X_"."_$P(SD,".",2))'>+WALL Q
        S X1=$P(X3,"."),X2=$S($P(PSJSYSW0,U,3):+$P(PSJSYSW0,U,3),1:14) D C^%DTC
        S NWALL=X_$S($P(PSJSYSW0,U,7):"."_$P(PSJSYSW0,U,7),1:SD#1)
        S $P(^PS(55,DFN,5.1),U)=+$S(FD>NWALL:FD,1:NWALL)
        Q
        ;
ENSD(SCH,AT,LI,OSD)     ;Find start date/time for orders.
        ;SCH=schedule,AT=admin times,LI=login date/time,OSD=Renewed orders start
        I $G(APPT),$G(PSGORD)["P" S XD=$$DATE2^PSJUTL2(APPT) Q XD
        N X,OSDLI D
        .I $L(LI)<13 S X=LI Q
        .I $L(LI)=14 S X=$E(LI,13,14) S:X>29 X=$E(LI,1,12)_5 S:X'>29 X=$E(LI,1,12)_1 Q
        .I $L(LI)=13 S X=$E(LI,13)_0 S:X>29 X=$E(LI,1,12)_5 S:X'>29 X=$E(LI,1,12)_1 Q
        I $G(LI) S:(LI=$G(OSD)) OSDLI=1
        S LI=+$FN(X,"",4) I '$P(LI,".",2) S LI=$$FMADD^XLFDT(LI,-1,0,0,0)_.24
        I $G(OSDLI) S OSD=LI K OSDLI
        ;S LI=+$E(LI,1,12) I '$P(LI,".",2) S LI=$$FMADD^XLFDT(LI,-1,0,0,0)_.24
        I $G(PSJSYSW0)=""!($P(PSJSYSW0,U,5)=2) Q LI
        S:SCH["PRN" AT=""
        N INT,PSG S:(SCH'["PRN"&(SCH'?1"Q".N1"H")&(LI'=OSD)&('AT)&($G(PSGST)'="O")) AT=$E(OSD,9,10) S OSD=$E(OSD,1,10)
        S INT=$S(SCH="QD":24,SCH="QOD":48,SCH="QH":1,SCH?1"Q".N1"D":(+$P(SCH,"Q",2)*24),SCH?1"Q".N1"H":+$P(SCH,"Q",2),LI=OSD:24,1:24)
        S:INT=24 OSD=$$FMADD^XLFDT(LI,0,-INT,0,0)
        I 'AT,INT>23 S:$P(PSJSYSW0,U,5)!($E(LI,11,12)>30) AT=$E($$FMADD^XLFDT(LI,0,1,0,0),9,10) S:AT="00" AT=24 S:'AT AT=$E(LI,9,10)
        I SCH?1"Q".N1"H",'AT S ND=OSD,PSG(+ND)="" S:(INT>24)&('$G(PSJREN)) INT=24 S DAYS=INT\24,HRS=(-INT\24*24+INT) F  S ND=$$FMADD^XLFDT(ND,DAYS,HRS),PSG(+ND)="" Q:ND>LI
        Q:INT=24&'$L(AT,"-") $E(LI,1,8)_AT
        ;Q:$P(PSJSYSW0,U,5)&(AT=23) $E(LI,1,8)_24
        I '$O(PSG(LI)) S X=$S(OSD>1:OSD,LI>1:LI,1:$$DATE^PSJUTL2) D
        .F  S ND=X D  Q:ND>LI  S:(INT>24)&('$G(PSJREN)) INT=24 S DAYS=INT\24,HRS=(-INT\24*24+INT) S X=$$FMADD^XLFDT($S($P(ND,".",2)=24:$P(ND,".")_".23",1:ND),DAYS,HRS) S:$P(X,".")'>$P(ND,".") X=$$FMADD^XLFDT(X,1,0,0,0)
        ..F Y=1:1 S AT1=$P(AT,"-",Y) Q:'AT1  S ND=ND\1_"."_AT1,PSG(+ND)=""
        Q:$P(PSJSYSW0,U,5) $O(PSG(LI))
        S INT="" F ND=0:0 S ND=$O(PSG(ND)) S X=$$FMDIFF^XLFDT(LI,ND,2) S:X<0 X=-X Q:INT&(X'<INT)  S INT=+X,OND=ND Q:INT=0
        Q $S($G(OND):OND,1:LI)  ;Use login time if OND is null PSJ*5*193
