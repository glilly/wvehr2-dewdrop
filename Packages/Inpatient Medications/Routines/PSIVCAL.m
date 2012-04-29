PSIVCAL ;BIR/RGY,PR-CALCULATES START AND STOP DATES ;12 Mar 99 / 12:42 PM
        ;;5.0; INPATIENT MEDICATIONS ;**4,26,41,47,63,67,69,58,94,80,110,111,177,120,134**;16 DEC 97;Build 124
        ;
        ; Reference to ^PS(50.7 is supported by DBIA #2180.
        ; Reference to ^PS(52.6 is supported by DBIA #1231.
        ; Reference to ^PS(55 is supported by DBIA #2191.
        ;
ENT     ;NEEDS PSIVTYPE (P(4))
        I $G(PSJREN) D  Q:P(2)
        . I $G(P("OLDON")) N P2 S P2=$G(@("^PS(55,"_DFN_",""IV"","_+P("OLDON")_",0)")),P2=$P(P2,"^",2) I P2 S P(2)=P2
        I $G(PSJORD)["P",$G(P("APPT"))?7N1"."1.N S START=$$DATE2^PSJUTL2(P("APPT")) G Q
        I $G(PSJSYSW0)=""!($P(PSJSYSW0,U,5)=2) S START=+$E(P("LOG"),1,12) G Q
        S PSIVSN=+P("IVRM"),START="",PSIVTYPE=$G(P(4)) Q:PSIVTYPE=""
        N PSIV X $S($E(PSIVAC)="C":"S X=+$E(P(""LOG""),1,12) D H^%DTC S PSIV=%T",1:"S PSIV=$P($H,"","",2)") G T2:PSIVTYPE'["P"&('P(5))
        I P(11)']"" X $S($E(PSIVAC)="C":"S Y=+$E(P(""LOG""),1,12)",1:"D NOW^%DTC S Y=%") S Y=Y+.007\.01/100 S:'$P(Y,".",2) Y=$$MDNGHT(Y) X ^DD("DD") S START=Y G Q
        S X=P(11) D CHK S PX=Y,X1=PSIV\3600,X2=PSIV#3600\60,X=$E(".0",1,$L(X1)#2+1)_X1_$E("0",X2<10)_X2,START=$S($E(PSIVAC)="C":$P(P("LOG"),"."),1:"T")
        S X1=$P(PX,"-"),X1=$E(".0",1,$L(X1)#2+1)_X1,X2=$P(PX,"-",PSGCNT),X2=$E(".0",1,$L(X2)#2+1)_X2
        S NAT=+$P($G(^PS(59.6,+$O(^PS(59.6,"B",+VAIN(4),0)),0)),U,5)
        I '$D(PSGDT) S PSGDT=$$DATE^PSJUTL2()
        I X<X1,'NAT S START=$$ENSD^PSGNE3(P(9),P(11),+$E(P("LOG"),1,12),PSGDT) G Q
        I X>X2 S START=$$ENSD^PSGNE3(P(9),P(11),+$E(P("LOG"),1,12),PSGDT) G Q
T6      F I=2:1:PSGCNT S X1="."_$P(PX,"-",I-1),X2="."_$P(PX,"-",I) Q:+X1<X&(+X2>X)
        S X1=X-X1,X2=$S(NAT:0,1:X2-X),START=$S(X1<X2:$P(PX,"-",I-1),1:$P(PX,"-",I)) S:START="" START=$P(PX,"-") X $S($E(PSIVAC)="C":"S Y=$P(P(""LOG""),""."") X ^DD(""DD"") S PSIV=Y",1:"S PSIV=""TODAY""") S START=PSIV_"@"_$E("0",$L(START)=3)_START G Q
T2      S X=+("."_$E(10000+(PSIV\3600*100)+(PSIV#3600\60),2,5)),START=$O(^PS(59.5,PSIVSN,3,"AT",X)) S:'START START=$O(^(0)),PSIVTOM=1 I 'START S START=X K PSIVTOM
        S START=$S($E(PSIVAC)="C":$P(P("LOG"),"."),1:DT)_START I $D(PSIVTOM) S X1=$S($E(PSIVAC)="C":$P(P("LOG"),"."),1:DT),X2=1 D C^%DTC S Y=$P(X,".")_START K PSIVTOM
        S X=START,%DT="XRTX" D ^%DT
Q       ;
        I START["@" S X=START,%DT="RTX" D ^%DT S START=+Y
        S P(2)=START
        I $G(PSJORD)["P" D:'$G(PSGRDTX(+PSJORD,"PSGSD")) REQDT^PSJLIVMD(PSJORD) S START=$G(PSGRDTX(+PSJORD,"PSGSD")) S P(2)=$S(START:START,1:P(2))
        K NAT,START,PSIVTYPE,PSIVSTRT,PSGCNT,X1,X2,PX
        Q
CHK     F Y=1:1 Q:$L(X)>240!($P(X,"-",Y)="")  S $P(X,"-",Y)=$P(X,"-",Y)_$E("0000",1,4-$L($P(X,"-",Y)))
        S Y=X,PSGCNT=$L(X,"-") S:X]""&(PSGCNT<1) PSGCNT=1 Q
        ;
ENSTOP  ; WILL CALCULATE STOP DATE FOR ORDER
        ;NEEDS (DFN) & ON
        N WALL,P3,ADX,DDLX,OIX,DRGT,PSIDAY,PSIMIN,LIMDAY S (WALL,P3,PSIDAY,PSIMIN)=0
        D:'$G(PSIVSITE) ^PSIVSET  Q:'P(2)
        I P(23)'="" S PSIVTYPE="C"
        S STOP="",X="",PSIVSTRT=P(2),PSIVTYPE=$G(P(4)) I $G(PSJREN) D
        . N RDT I $G(ON)["P" S RDT=+$$LASTREN^PSJLMPRI(DFN,ON)
        . S PSIVSTRT=$$DATE2^PSJUTL2($S($G(RDT):RDT,1:$G(PSGDT)))
        ;BHW - PSJ*5*177 - Begin Modifications - Reset Start date to Last Renewed date for active orders that have been renewed
        I ('$G(PSJREN))&($G(P(4))="A")&($G(ON)["V") D
        . N RDT S RDT=+$$LASTREN^PSJLMPRI(DFN,ON)
        . I +RDT S PSIVSTRT=RDT
        . Q
        ;BHW - PSJ*5*177 - End Modifications - Resetting PSIVSTRT will recalculate the stop date based on the Last renewed date.
        ;
        I $S("^NOW^STAT^ONCE^ONE-TIME^ONE TIME^ONETIME^1TIME^1-TIME^1 TIME^"[(U_P(9)_U):1,1:0),PSIVTYPE="P"!P(5)!(P(23)="P") S X=$$ENOSD^PSJDCU(PSJSYSW0,PSIVSTRT,DFN) I X]"" S:P(11)=""&($G(ON)["P") PSIVCAL=1 G END
        I '$G(P("OVRIDE")),$G(ON) N DUR,DURMIN,PSJPROV,PSJDNM,A,PSJDAY I $G(ON)["V"!(($G(ON)["P")&($P($G(^PS(53.1,+ON,0)),"^",4)="F")) D
        . S DUR=$$GETDUR^PSJLIVMD(DFN,+ON,"IV",1) I DUR]"" S DURMIN=$$DURMIN^PSJLIVMD(DUR) I DURMIN S PSIMIN=DURMIN
        I $P(PSIVSITE,"^",5) D
        . N Z S Y=0
        . F  S Y=$O(^PS(55,DFN,"IV",Y)) Q:'Y  S Z=^(Y,0) D  Q:X]""
        .. I $P(Z,"^",17)="A",$$ONE^PSJBCMA(DFN,Y_"V",$P(Z,"^",9))'="O" S X=$P(Z,"^",3) Q
        S:$G(X) WALL=X
        S PSIDAY=$S(PSIVTYPE="A":$P(PSIVSITE,"^",4),PSIVTYPE="H":$P(PSIVSITE,"^",17),PSIVTYPE="P":$P(PSIVSITE,"^",18),PSIVTYPE="S":$P(PSIVSITE,"^",20),1:$P(PSIVSITE,"^",21))
        I $G(ON)["P"!($G(ON)["V") I '$G(P("OVRIDE")) N MINS,LIM S PSIVLIM=$$GETLIM(DFN,ON) I $G(PSIVLIM)]"" S MINS=$$GETMIN(PSIVLIM,DFN,ON,.LIMDAY) D
        .I (MINS&(MINS<PSIMIN))!'PSIMIN S PSIMIN=MINS
        S PSJDAY="" D  I PSJDAY]"",PSJDAY<PSIDAY S PSIDAY=PSJDAY
        . N A,B,PSJCLIN
        . Q:'$D(PSJORD)  S A=""
        . I PSJORD["P" S A=$G(^PS(53.1,+PSJORD,"DSS"))
        . I PSJORD["U" S A=$G(^PS(55,PSGP,5,+PSJORD,8))
        . I PSJORD["V" S A=$G(^PS(55,PSGP,"IV",+PSJORD,"DSS"))
        . S (PSJCLIN,A)=$P(A,"^") Q:A=""  S PSJCLIN=$P(^SC(PSJCLIN,0),"^") I $D(^PS(53.46,"B",A)) S B=$O(^PS(53.46,"B",A,"")),PSJDAY=$P(^PS(53.46,B,0),"^",2)
        F X=0:0 S X=$O(DRG("AD",X)) Q:'X  I $P(^PS(52.6,+$P(DRG("AD",+X),U),0),"^",4),($P(^(0),"^",4))<+PSIDAY S PSIDAY=$P(^(0),"^",4)
        I WALL,($$FMADD^XLFDT(PSIVSTRT,PSIDAY,"D"))>WALL S PSIDAY=$$FMDIFF^XLFDT(WALL,PSIVSTRT,1) S:PSIDAY<1 PSIDAY=""
        S DRGT=$S($D(DRG("AD")):"AD",1:"SOL") F ADX=0:0 S ADX=$O(DRG(DRGT,ADX)) Q:'ADX!($G(DRGTMP)&($G(DRGTN)["AD")&(DRGT="SOL"))  D
        . S OIX=+$P(DRG(DRGT,ADX),"^",6),DDLX=$P(^PS(50.7,OIX,0),"^",5) Q:'DDLX  D DDLIM(.PSIDAY,.P3)
        I '$G(DRG("AD",0)),$G(DRGTMP),($G(DRGTN)["SOL") S OIX=$P($G(DRGTMP),"^",6) I OIX S DDLX=$P(^PS(50.7,OIX,0),"^",5) I DDLX  D DDLIM(.PSIDAY,.P3)
        I $G(PSIVLIM)["a",'$G(P("OVRIDE")) S DDLX=$P(PSIVLIM,"a",2)_"L" I $G(DDLX) D DDLIM(.PSIDAY,.P3)
        I $G(P(2)) I P3>P(2) S X=P3
        S:('PSIDAY&'PSIMIN) PSIDAY=1
TIME    S X2=PSIDAY,X1=PSIVSTRT D C^%DTC S X=$P(X,"."),X=X_$S($P(PSIVSITE,"^",14)="":.2359,1:"."_$P(PSIVSITE,"^",14))
        I PSIMIN D
        . I $G(PSIDAY),((PSIDAY*1440)<PSIMIN) K PSIVLIM,P("LIMIT") S P("OVRIDE")=1 Q
        . I (PSIMIN<(PSIDAY*1440)!'$G(PSIDAY)) S X=$$FMADD^XLFDT(PSIVSTRT,,,PSIMIN) D
        .. I '(PSIMIN#1440) S X=$P(X,"."),X=X_$S($P(PSIVSITE,"^",14)="":.2359,1:"."_$P(PSIVSITE,"^",14))
END     ;
        S P(3)=+X
        I $G(PSJORD)["P" D:'$G(PSGRDTX(+PSJORD,"PSGFD")) REQDT^PSJLIVMD(PSJORD) S P(3)=$S($G(PSGRDTX(+PSJORD,"PSGFD")):PSGRDTX(+PSJORD,"PSGFD"),1:P(3))
        S P(3)=$$DATE2^PSJUTL2(P(3)),P(2)=$$DATE2^PSJUTL2(P(2))
        Q
        ;
ENAD    ;Will get last admin. time for order (needs dfn and on)
        N P4,PSIVX,PSIVY
        I $P(PSJSYSW0,U,5)=2 S PSIVADM=$$DATE^PSJUTL2() Q
        I $S($G(PSIVAC)["R":1,P(9)="QOD":1,1:P(9)?1"Q".N1"D") S PSIVADM=$$ENSD^PSGNE3(P(9),P(11),+$E(P("LOG"),1,12),+$P($G(^PS(55,DFN,"IV",+P("OLDON"),0)),U,2)) Q:PSIVADM
        S PSIVX=X,PSIVY=Y,P4=P(4) S:P(4)="C" P4=P(23) S:P4="S" P4=$S(P(5):"P",1:"A") D NOW^%DTC S Y=%,PSIVNOW=Y I (P4="P"&(P(11)="")&'P(15))!("HA"[P4&'P(15)) S Y=Y+.007\.01/100 G QAD
        D P:P4="P"&('P(15)),AH:P(15)
QAD     ;
        S:'$D(PSGSA) PSGSA=""
        S PSIVSD=Y I Y S OD=$L(PSGSA," ") I OD>2 S X=+PSGSA\1 F OD1=2:1:OD-1 I $P(PSGSA," ",OD1)'>$S(OD1>2:$P(PSGSA," ",OD1-1),1:PSGSA#1) S X1=X,X2=1 D C^%DTC
        I PSIVSD,OD>2 S Y=X_PSIVSD
        S PSIVADM=+Y,X=PSIVX,Y=PSIVY K PSGSA,PSIVSD,OD,OD1,PSIVMI,PSIVNOW S:PSIVADM<P(2) PSIVADM=P(2) Q
        ;
P       S CD=PSIVNOW,PSGSA="",(PSIVSD,OD)=DT_.0001,X=P(11) D CHK S P(11)=X D ENP4^PSIVWL
        I PSGSA="" S PSIVSD=DT_.0001,PSIVMIN=-1440 D ENT^PSIVWL S $P(Y,".",2)=$P(P(11),"-",$L(P(11),"-")) Q
        S Y=$P(PSGSA," ",$L(PSGSA," ")-1) Q
AH      F PSIVADM=0:-1 S CD=PSIVNOW,(X,X1)=DT,X2=PSIVADM D:X2 C^%DTC S X=$P(X,".") S (OD1,PSIVSD,OD)=X_.0001,PSIVMIN=P(15) D ENP3^PSIVWL Q:PSIVADM<-4!(PSGSA]"")
        S Y=$P(PSGSA," ",$L(PSGSA," ")-1) Q
MDNGHT(Y)                ;Sets Start Date/Time on orders placed between midnight and 12:30
        S Y=$$FMADD^XLFDT(Y,-1,0,0,0),Y=$P(Y,".")_".24" Q Y
        ;
DDLIM(PSIVDUR,STPDT)    ;  Day Dose Limit
        N P3,NEWDAYS,NEWDUR
        I DDLX["D" D  Q:(STPDT=0)
        .I +DDLX'<+PSIVDUR S STPDT=0 Q
        .S PSIVDUR=+DDLX,X2=PSIVDUR,X1=PSIVSTRT D C^%DTC S X=$P(X,"."),X=X_$S($P(PSIVSITE,"^",14)="":.2359,1:"."_$P(PSIVSITE,"^",14)) I X>P(2) S P(3)=X
        I DDLX["L",($G(P(9))]""),("AH"'[$G(PSIVTYPE)) S LASTD=$$DOSES(DDLX,.P) I LASTD D
        .S NEWDUR=$$FMDIFF^XLFDT(LASTD,P(2),2) I NEWDUR>0 S NEWDAYS=(NEWDUR/86400)
        .I $G(NEWDAYS) I NEWDAYS<PSIVDUR S PSIVDUR=NEWDAYS S P(3)=$$DATE2^PSJUTL2(LASTD)
        S P(3)=$$DATE2^PSJUTL2(P(3)),P(2)=$$DATE2^PSJUTL2(P(2)) S STPDT=P(3)
        Q
        ;
GETLIM(DFN,PSJORD)      ; Convert IV Limits to minutes (only if in 'time' form).
        N ND2P5,F
        S F=$S(PSJORD["P":"^PS(53.1,+PSJORD,",PSJORD["V":"^PS(55,DFN,""IV"",+PSJORD,",1:"")
        S ND2P5=$G(@(F_"2.5)")) S LIM=$P(ND2P5,"^",4) Q:LIM="" 0
        S ND0=$G(@(F_"0)")) I PSJORD["P",$P(ND0,"^",4)="U" Q 0
        N MULT S MULT=$S($E(LIM)="h":60,$E(LIM)="d":1440,$E(LIM)="m":LIM,$E(LIM)="l":LIM,$E(LIM)="a":LIM,1:0) I MULT S LIM=MULT*$E(LIM,2,99)
        Q LIM
        ;
GETMIN(LIM,DFN,PSJORD,DAYS)     ; Return the duration of the IV Limit in minutes (includes IV Limits in volume and doses format)
        S LIM=$$GETMIN^PSIVUTL1(LIM,DFN,PSJORD,.DAYS)
        Q LIM
DOSES(DDLX,PRAY)        ; Find stop date when 'doses' are sent as an IV Limit
        Q:$G(DDLX)'["L" ""
        I $P(DDLX,"L")["." S DDLX=($P(DDLX,".")+1)_"L"
        I '$G(PRAY(15)),$G(PRAY(11)) S PRAY(15)=1440/$L(PRAY(11),"-")
        Q:'$G(PRAY(2))!'$G(OIX) ""
        N FIRST,DOSAR,LAST,TMP9 S LAST="",TMP9=PRAY(9)
        S STRING=PRAY(2)_"^"_$S($G(STPDT):STPDT,1:$$FMADD^XLFDT(PSGDT,30))_"^"_PRAY(9)_"^C^"_OIX S FIRST=$$ENQ^PSJORP2(DFN,STRING)
        S P(9)=TMP9
        S FIRST=$S($G(FIRST):FIRST,1:PRAY(2)) Q:'FIRST  S DSTMP=FIRST,DOSAR(1)=DSTMP D
        .I '$G(PRAY(11)) F I=2:1:DDLX+1 S DOSAR(I)=$$FMADD^XLFDT(DSTMP,,,PRAY(15)),DSTMP=DOSAR(I) Q
        .I $G(PRAY(11)) N ADMS,NXT,LAST,DAY S LAST=$P(DSTMP,".",2),DAY=$P(DSTMP,".") D
        ..F II=1:1:$L(PRAY(11),"-") S ADMS(+$P(PRAY(11),"-",II))=$P(PRAY(11),"-",II)
        ..F IJ=2:1:DDLX+1 S NXT=$O(ADMS(+LAST)),LAST=NXT D
        ...I NXT="" S NXT=$O(ADMS(NXT)),LAST=NXT,DAY=$$FMADD^XLFDT(DAY,1)
        ...S DOSAR(IJ)=DAY_"."_ADMS(NXT),DSTMP=DOSAR(IJ)
        ..I +DDLX=1 S NXT=$O(ADMS(LAST)),LAST=NXT D
        ...I NXT="" S NXT=$O(ADMS(NXT)),LAST=NXT
        I $D(DOSAR) S LAST=$O(DOSAR(""),-1) I LAST S LAST=DOSAR(LAST)
        Q LAST
