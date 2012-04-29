PSJO1 ;BIR/CML3,PR-GET UNIT DOSE/IV ORDERS FOR INPATIENT ;15 May 98 / 9:28 AM
 ;;5.0; INPATIENT MEDICATIONS ;**3,47,56,58,109,110,127,162**;16 DEC 97
 ;
 ; Reference to ^PS(55 is supported by DBIA# 2191.
 ; Reference to ^%DTC is supported by DBIA# 10000.
 ; Reference to ^%ZOSV is supported by DBIA# 10097.
 ; Reference to XLFDT is supported by DBIA# 10103.
 ;
ECHK ;
 S C="A",ON=+O_"U",START=$G(^PS(55,PSGP,5,+O,2)),STOP=$P(START,U,4),START=$P(START,U,2) S:PSJOS START=-START
 I +START>PSGDT,(STOP>PSGDT) G SET
 S ND=$G(^PS(55,PSGP,5,+O,0)) G:$S($P(ND,"^",9)="":1,1:"DE"'[$P(ND,"^",9)) SET S ND4=$G(^PS(55,PSGP,5,+O,4)) I ST'="O",SD'<PSGODT,$S($P(ND,"^",9)="E":$P(ND4,"^",16),1:0)
 E  I ST="O",$P(ND,"^",9)="E",$S('$P(ND4,"^",UDU):1,SD<PSGODT:0,1:$P(ND4,"^",16))
 E  Q:PSJOL="S"  S C="O"
 ;
SET ;
 I ON["P",($D(PRNTON)!($D(P("PRNTON")))) N PSJOK S PSJOK=$$COMCHK($S($G(P("PRNTON"))]"":P("PRNTON"),$G(PRNTON)]"":PRNTON,1:""),PSJPTYP) Q:'PSJOK
 NEW DRUGNAME D DRGDISP^PSJLMUT1(PSGP,ON,40,0,.DRUGNAME,1)
 S DN=DRUGNAME(1),SUB=$S(PSJOS:START,1:$E(DN,1,40))
 I ON["P",$G(P("PRNTON"))]"",$G(PRNTON)=+P("PRNTON") Q
 I ON["P",$G(P("PRNTON"))]"" S PRNTON=+P("PRNTON"),ON=+P("PRNTON")
 S ^TMP("PSJ",$J,C,$S(PSJOS:SUB,1:ST),$S(PSJOS:ST,1:SUB),ON)=DN_"^"_$G(NF),PSJOCNT=PSJOCNT+1 Q
 ;
IVSET ;Set IV data in ^TMP("PSJ",$J,.
 N DRG,DRGT,ON55,ORTX,P,STAT,TYP,X,Y,NAME,ND
 I ON["V" S ON55=ON,Y=$G(^PS(55,DFN,"IV",+ON,0)) F X=2,3,4,9,17 S P(X)=$P(Y,U,X)
 I ON["V",(P(2)=""),(P(3)="") Q
 I ON'["V" S ND=$G(^PS(53.1,+ON,0)) I 'ND K ^PS(53.1,"AS",SD,PSGP,+ON) Q
 I ON'["V",ND S P(17)=$P($G(^PS(53.1,+ON,0)),U,9),Y=$G(^PS(53.1,+ON,2)),P(9)=$P(Y,U),P(2)=$P(Y,U,2),P(3)=$P(Y,U,4),P(4)=$P($G(^PS(53.1,+ON,8)),U),P("PRNTON")=$P($G(^PS(53.1,+ON,.2)),U,8)
 I ON'["V",P("PRNTON")]"" N PSJOK S PSJOK=$$COMCHK(P("PRNTON"),PSJPTYP) Q:'PSJOK
 D @$S(ON["V":"GTDRG^PSIVORFB",1:"GTDRG^PSIVORFA"),GTOT^PSIVUTL(P(4))
 I $G(DRG) S DRGT=$S($G(DRG("AD",1))]"":$P($G(DRG("AD",1)),U,2),1:$P($G(DRG("SOL",1)),U,2)),ORTX=DRGT
 I $G(ORTX)="",(ON'["V") D DRGDISP^PSJLMUT1(PSGP,+ON_"P",40,"",.NAME,1) S ORTX=NAME(1)
 ;* I $G(ORTX)=""!(ON'["V") D DRGDISP^PSJLMUT1(PSGP,+ON_"P",40,"",.NAME,1) S ORTX=NAME(1)
 S:$G(ORTX)="" ORTX="NOT FOUND"
 ;
IVSET1 ;
 ;* S TYP=$S(P(2)=P(3):"O",1:"C"),STAT=$S("ED"[P(17):"O",P(17)="P":"P",1:"A")
 S TYP=$$ONE^PSJBCMA(PSGP,ON,P(9),P(2),P(3)) I TYP'="O" S TYP=$S(ON["P":"z",1:"C")
 S STAT=$S($G(PSJPRI)="D":"A","ED"[P(17):"O",P(17)="P":"P",1:"A")
 I P(17)="P" S STAT="C"_$S($P($G(^PS(53.1,+ON,.2)),U,8)]"":"D",$P($G(^PS(53.1,+ON,.2)),U,4)="S":"A",$P($G(^(0)),U,24)="R":"C",1:"B")
 I ON["P",$G(P("PRNTON"))]"",PRNTON=+P("PRNTON") Q
 I ON["P",$G(P("PRNTON"))]"" S PRNTON=+P("PRNTON"),ON=+P("PRNTON")
 S ^TMP("PSJ",$J,STAT,$S(PSJOS:-P(2),1:TYP),$S(PSJOS:TYP,1:ORTX),ON)="^F",PSJOCNT=PSJOCNT+1
 Q
 ;
ENU ; update status field to reflect expired orders, if necessary
 W !!,"...a few moments, I have some updating to do..."
ENUNM ;
 F Q=+PSJPAD:0 S Q=$O(^PS(55,PSGP,5,"AUS",Q)) Q:'Q!(Q>PSGDT)  S UPD=Q F QQ=0:0 S QQ=$O(^PS(55,PSGP,5,"AUS",Q,QQ)) Q:'QQ  I $D(^PS(55,PSGP,5,QQ,0)),"DEH"'[$E($P(^(0),"^",9)) D
 .; naked ref below refers to line above
 .S $P(^(0),"^",9)="E",ORIFN=$P(^(0),"^",21) D EN1^PSJHL2(PSGP,"SC",QQ_"U")
 K UPD Q
 ;
EN(PSJPTYP) ; enter here
 ; PSJPTYP=1:UD ONLY, 2:IV ONLY, 3:BOTH
 N PSJX,PSJY
 S PSJOL=$G(PSJOL)  ; Initialize if no 'View Profile' option selected
 I PSJOL="L",$D(XRTL) D T0^%ZOSV
 K ^TMP("PSJ",$J) D NOW^%DTC S PSGDT=+$E(%,1,12),DT=$$DT^XLFDT,PSJOS=$P(PSJSYSP0,"^",11),UDU=$S($P(PSJSYSU,";",3)>1:3,1:1)
 S PSJOCNT=0 I PSJPTYP>1 F PSJORD=0:0 S PSJORD=$O(^PS(55,DFN,"IV",PSJORD)) Q:'PSJORD  D
 .S PSJX=$G(^PS(55,DFN,"IV",+PSJORD,0))
 .S PSJY=$P(PSJX,U,17)
 .I $P(PSJX,U,3)<PSGDT,"AR"[PSJY S $P(^PS(55,DFN,"IV",+PSJORD,0),U,17)="E",PSJY="E",ON=+PSJORD D EXPIR^PSIVOE
 .I +PSJSYSU=3,('+$P($G(^PS(55,DFN,"IV",+PSJORD,4)),U,4)),($P($G(^(.2)),U,4)="D") S PSJPRI="D"
 .I $S($G(PSJPRI)="D":1,PSJY="P":0,PSJOL="L":1,1:"DPE"'[PSJY) S ON=+PSJORD_"V" D IVSET K PSJPRI,ON
 D NOW^%DTC S PSJIVOF=PSJOCNT,PSGDT=%,(X1,DT)=$P(%,"."),X2=-2 D C^%DTC S PSGODT=X_(PSGDT#1),HDT=$$ENDTC^PSGMI(PSGDT)
 D ENUNM
 I PSJPTYP'=2 F ST="C","O","OC","P","R" F SD=+PSJPAD:0 S SD=$O(^PS(55,PSGP,5,"AU",ST,SD)) Q:'SD  F O=0:0 S O=$O(^PS(55,PSGP,5,"AU",ST,SD,O)) Q:'O  D ECHK
 Q:$D(PSGONNV)
 ;I PSJPTYP'=2 F SD="I","N" S O=0 F  S O=$O(^PS(53.1,"AS",SD,PSGP,O)) Q:'O  S ON=+O_"P",X=$P($G(^PS(53.1,+O,0)),U,4) I $S(PSJPTYP=3:1,PSJPTYP=1&("FI"[X):0,1:1) D NVSET
 N PRNTON F SD="I","N" S (PRNTON,O)=0 F  S O=$O(^PS(53.1,"AS",SD,PSGP,O)) Q:'O  S ON=+O_"P",X=$P($G(^PS(53.1,+O,0)),U,4) I $S(PSJPTYP=3:1,PSJPTYP=1&("FI"[X):0,1:1) D NVSET
 ;I $S(+PSJSYSU=3:1,1:$D(PSGLPF)) S O=0,SD="P" F  S O=$O(^PS(53.1,"AS",SD,PSGP,O)) Q:'O  S ON=O_"P",X=$P($G(^PS(53.1,+O,0)),U,4) I $S(PSJPTYP=3:1,PSJPTYP=1&("FI"[X):0,1:1) D @$S("FI"[X:"IVSET",1:"NVSET")
 N PRNTON S (PRNTON,O)=0,SD="P" F  S O=$O(^PS(53.1,"AS",SD,PSGP,O)) Q:'O  S ON=O_"P",X=$P($G(^PS(53.1,+O,0)),U,4) I $S(PSJPTYP=3:1,PSJPTYP=1&("FI"[X):0,1:1) D @$S("FI"[X:"IVSET",1:"NVSET")
 I PSJOL="L",$D(XRT0) S XRTN="PSJO1" D T1^%ZOSV
 Q
 ;
NVSET ; Set up orders from 53.1.
 N ND S ND=$G(^PS(53.1,O,0)) I 'ND D  Q
 .K ^PS(53.1,"AS",SD,PSGP,O)
 I $P(ND,U,15),$G(PSGP) I PSGP'=$P(ND,U,15) D  Q
 .K ^PS(53.1,"AS",SD,PSGP,O)
 I $P(ND,U,9)["D" D  Q
 .K ^PS(53.1,"AS",SD,PSGP,O)
 .N ND2 S ND2=$G(^PS(53.1,O,.2)) I $P(ND2,U,8) K ^PS(53.1,"ACX",$P(ND2,U,8))
 S ST=$P($G(^PS(53.1,O,0)),U,7),START=-$P($G(^(2)),U,2),P("PRNTON")=$P($G(^PS(53.1,O,.2)),"^",8) S:ST="" ST="z"
 S C=$S(((SD="N")&($P($G(^PS(53.1,O,.2)),U,8)]"")):"BD",SD="N":"BA",SD="I":"BB",$P($G(^PS(53.1,O,.2)),U,8)]"":"CD",$P($G(^PS(53.1,O,.2)),U,4)="S":"CA",$P($G(^(0)),U,24)="R":"CC",1:"CB")
 ;I C="CC" S C=$$CKPC^PSGOU(PSGP,+$P($G(^PS(53.1,O,0)),U,25),O)
 D SET
 Q
 ;
KILL ;
 K P,STAT,TYP,ORTX,N,JJ
 Q
COMCHK(PSJCOM,PSJPTYP) ;Check complex orders for order type
 S OK=0
 I PSJCOM=0 S OK=1 Q OK
 I PSJCOM=""  Q OK
 I PSJPTYP="" Q OK
 I '$D(^PS(53.1,"ACX",PSJCOM)) Q OK
 S OK=1 I PSJPTYP=3 Q OK
 N PSJON S PSJON=""
 F  S PSJON=$O(^PS(53.1,"ACX",PSJCOM,PSJON)) Q:'PSJON  D  Q:OK=0
 .I $P($G(^PS(53.1,PSJON,0)),"^",9)["D" K ^PS(53.1,"ACX",PSJCOM)
 .I $P($G(^PS(53.1,PSJON,0)),"^",4)'="U",PSJPTYP=1 S OK=0 Q
 .I $P($G(^PS(53.1,PSJON,0)),"^",4)="U",PSJPTYP=2 S OK=0 Q
 Q OK
