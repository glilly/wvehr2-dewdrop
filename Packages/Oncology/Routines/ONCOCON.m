ONCOCON ;Hines OIFO/GWB - VADPT CALLS ;5/22/00
        ;;2.11;ONCOLOGY;**11,16,26,50**;Mar 07, 1995;Build 29
        ;
NOK     ;NEXT OF KIN
        S XD0=D0 D VP G EX:OP="" N I,X D OAD^VADPT G EX:VAERR S ST=$S(VAOA(5)="":"",1:$P(^DIC(5,$P(VAOA(5),U),0),U,2)),CSZ=VAOA(4) I CSZ'="" S CSZ=CSZ_", "
        S CSZ=CSZ_ST_" "_VAOA(6),SP="?25" S:'$D(NOK) NOK="NOK" D WT G EX
        ;
NOK1    ;NEXT OF KIN-1
        S NOK="NOK1" G NOK
        ;
NOK2    ;NEXT OF KIN-2 #.2191
        S VAOA("A")=3,NOK="NOK2" G NOK
CON     ;Retrieve Contacts (NOK1 and NOK@)
        S XD0=D0 D VP G EX:OP="" N I,X D OAD^VADPT F I=1:1:10 S ONCO(I)=VAOA(I)
        K VAOA S VAOA("A")=3 D OAD^VADPT F I=1:1:10 S ONCO(I+10)=VAOA(I)
        G EX
        ;
WT      W !,@SP,NOK,": ",@SP,VAOA(10)
2       ;W !?25,VAOA(10)
3       W !,@SP,$P(VAOA(9),",",2)_" "_$P(VAOA(9),",")
4       W !,@SP,VAOA(1)
5       W:VAOA(2)'="" !,@SP,VAOA(2)
6       W:VAOA(3)'="" !,@SP,VAOA(3)
        W:CSZ'="" !,@SP,CSZ
        Q
        ;
REL2    ;NOK2
        S VAOA("A")=3 G REL
REL     ;NOK relationship and Name
        S XD0=D0 D VP G EX:OP="" N I D OAD^VADPT G EX:VAERR S X=$S(VAOA(9)="":"",1:VAOA(10)_": "_$P(VAOA(9),",",2)_" "_$P(VAOA(9),",",1)_" * "_VAOA(1)) K ONCOD0 G EX:X="" I VAOA(2)'="" S X=X_" "_VAOA(2)
        S:VAOA(3)'="" X=X_" "_VAOA(3) S X=X_"  "_VAOA(4)_", "_$P(VAOA(5),U,2)_"  "_VAOA(6) G EX
        ;
ADM     ;Admission date/Discharge date
        ;FOR NON-DHCP (EAST-ORANGE)
        S (ONCOAD,ONCODD)="" I $G(^DG(43,1,"VERSION"))<4.6 Q  ;FOR NON-DHCP EAST-ORANGE
        S XX=$S($D(^ONCO(165.5,D0,0)):^(0),1:"") Q:XX=""  S XD0=$P(XX,U,2) D VP Q:OP=""  S XD=$P(XX,U,16),VAIP("D")=$S(XD="":"L",1:XD)
A5      I $G(^DG(43,1,"VERSION"))>4.8 N I,X D IN5 G:VAIP(1)'="" SV G:XD="" EX G NO
A4      G:XD="" EX S VAINDT=XD N I,X D INP G:VAIN(1)="" NO G SV
        ;
SV      S ONCOAD=AD,ONCODD=XD
WE      W !!?15,"Admit: ",AD_"  Discharge: "_XD,! G EX
NO      D DD W !,"No admission for ",XD G EX
        ;
INP     ;MAS VERSIONS less than 5.0
        N I,X D INP^VADPT Q:VAIN(1)=""  S XD=$P($P(VAIN(7),U),".") D DD S AD=XD,XD=$S($D(^DPT(DFN,"DA",VAIN(1),1)):$P(^(1),U),1:"") D DD Q
        ;
LST     ;LST ADMISSION
        S XD0=D0 D VP G:OP="" EX
        S VAIP("D")="L" D IN5 Q
        ;
SAD     ;COMPUTED EXPRESSION for SUSPENSE ADMIT DATE (160,33.1)
        D SUS
        S X=$S($D(XAD):XAD,1:"")
        G EX
        ;
SDD     ;COMPUTED EXPRESSION for SUSPENSE DISCHARGE DATE (160,33.2)
        D SUS
        S X=$S($D(XDD):XDD,1:"")
        G EX
        ;
SUS     ;SUSPENSE EPISODE CARE
        S XD0=D0,SD=""
        S SDIEN=$O(^ONCO(160,XD0,"SUS","C",DUZ(2),""))
        I SDIEN'="" S SD=$P($G(^ONCO(160,XD0,"SUS",SDIEN,0)),"^",1)
        Q:SD=""  D VP Q:OP=""
        S VAIP("D")=SD D IN5
        Q
        ;
VP      ;Resolve NAME (160,.01) variable pointer
        S OP=$S($D(^ONCO(160,XD0,0)):$P(^(0),U),1:"")
        S DFN=$P(OP,";",1)
        S OF=$P(OP,";",2)
        S OP=$S(OF="LRT(67,":"",1:OP)
        Q
        ;
IN5     ;Call to IN5^VADPT
        N I,X
        D IN5^VADPT Q:VAIP(1)=""
        S (XAD,XD)=$P(VAIP(13,1),".") D DD S XAD=XD
        S AD=XD,(XDD,XD)=$P(VAIP(17,1),".") D DD S XDD=XD
        Q
        ;
DD      ;Format date as mm/dd/yy
        S XD=$S(XD="":XD,1:$E(XD,4,5)_"/"_$E(XD,6,7)_"/"_$E(XD,2,3))
        Q
        ;
SEC     ;SUSPENSE EPISODE CARE
        D SUS S X="" G:SD="" EX I '$D(AD) S XD=SD G NO
        S XD=$S($D(XD):XD,1:"") G WE
LAD     ;LAST ADMIT DATE
        D LST S X=$S($D(AD):AD,1:"")
        I X'="" S X=($E(X,7,10)-1700)_$E(X,1,2)_$E(X,4,5)
        G EX
LDD     ;LAST DISCHARGE DATE
        D LST S X=$S($D(XD):XD,1:"")
        I X'="" S X=($E(X,7,10)-1700)_$E(X,1,2)_$E(X,4,5)
        G EX
LEC     ;LAST EPISODE of CARE
        D LST S X="" I '$D(AD) W !?15,"No admission data" G EX
        I $D(XD) G:XD'="" WE
        W !?15,"Admission: "_AD_"  active" G EX
NOKEO   ;Print Next of Kin - ONCOX2 East Orange
        I $D(^ONCO(160,D0,0)) S RCDT=^(0) I $P(RCDT,";",2)["DPT",$D(^DPT($P(RCDT,";",1),.21)) W $P(^(.21),U)_" ("_$P(^(.21),U,2)_")"
        ;
EX      ;Exit
        K AD,CSZ,DFN,NOK,OF,ONCO,ONCOAD,ONCODD,OP,RCDT,SD,SDIEN,SP,ST,VAERR
        K VAIN,VAIP,VAINDT,VAOA,XAD,XD,XDD,XX,XD0
        Q
