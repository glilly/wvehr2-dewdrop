IMRVLRG ;HCIOFO/FAI-Viral Load and CD4 Test Results Range ;11/13/01  09:00
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5,16**;Feb 09, 1998
BEGIN W !,?10,"####################################################"
 W !,?10,"#",?20,"Local Viral Test and CD4 List By Range",?61,"#"
 W !,?10,"####################################################"
 S IMRPG=0,(RNG,TYPE,SELE,CDHN,CDLN,VLH,VLL,BCDH,BCDL,BVLH,BVLL)=""
ASK D ^IMRDATE
 I $G(IMRHNBEG)="" W !,"**NO DATE RANGE SELECTED**" D KILL Q
TYP K DIR S DIR(0)="S^C:CD4;V:Viral Load;B:Both",DIR("A")="Select Type of Test(s) Results Requested" D ^DIR S TTYPE=Y K DIR
 I $D(DIRUT) D KILL Q
 G:TTYPE="V" VL
 G:TTYPE="B" BCDVL
CD4 ; cd4 high/low range
 W !!,"What range of CD4 # ?" K DIR S DIR(0)="N^0:99999999",DIR("A")="High (enter number)" D ^DIR S CDHN=Y K DIR
 I $D(DIRUT) D KILL Q
 K DIR S DIR(0)="N^0:99999999",DIR("A")="Low (enter number)" D ^DIR S CDLN=Y K DIR
 I $D(DIRUT) D KILL Q
 G DELM
VL ; viral load high/low range
 W !!,"What range of Viral Load?" K DIR S DIR(0)="N^0:99999999",DIR("A")="High (enter number)" D ^DIR S VLH=Y K DIR
 I $D(DIRUT) D KILL Q
 K DIR S DIR(0)="N^0:99999999",DIR("A")="Low (enter number)" D ^DIR S VLL=Y K DIR
 I $D(DIRUT) D KILL Q
 G DELM
BCDVL ; both cd4 and viral load range
 W !!,"What range of CD4 # ?" K DIR S DIR(0)="N^0:99999999",DIR("A")="High (enter number)" D ^DIR S CDHN=Y K DIR
 I $D(DIRUT) D KILL Q
 K DIR S DIR(0)="N^0:99999999",DIR("A")="Low (enter number)" D ^DIR S CDLN=Y K DIR
 I $D(DIRUT) D KILL Q
 W !!,"What range of Viral Load?" K DIR S DIR(0)="N^0:99999999",DIR("A")="High (enter number)" D ^DIR S VLH=Y K DIR
 I $D(DIRUT) D KILL Q
 K DIR S DIR(0)="N^0:99999999",DIR("A")="Low (enter number)" D ^DIR S VLL=Y K DIR
 I $D(DIRUT) D KILL Q
DELM S DELIM="N" R !!,"Do you want the list in delimited format (Y/N)? N// ",X:DTIME S:X="" X="N" I "Yy"[$E(X) S DELIM="Y"
 I "YyNn"'[$E(X) W $C(7),"  ??",!!,"Enter YES or NO" G DELM
DEV D IMRDEV^IMREDIT
 G:POP KILL
 I '$D(IO("Q")) W @IOF D SEARCH Q
 I $D(IO("Q")) D  G KILL
 .S ZTRTN="DQ^IMRVLRG",ZTDESC="Local Viral Load and CD4 Range Lists"
 .S ZTSAVE("*")="",ZTIO=ION_";"_IOM_";"_IOSL
 .D ^%ZTLOAD K ZTRTN,ZTDESC,ZTSAVE,ZTSK
 .Q
 Q
DQ D TYPE,HEAD,SORT,KILL
 Q
SEARCH D TYPE,HEAD,SORT,KILL
 Q
TYPE ; Entry with IMRDFN defined and pointers for local lab test name & NLT
 ; FIND TYPE OF TEST EX:VIRAL LOAD
 K ^TMP($J)
 D ^IMRSDSP
ICRPT F ICR=0:0 S ICR=$O(^IMR(158,ICR)) Q:ICR'>0  S X=+^(ICR,0),IFN=ICR,IMRCAT=$P(^(0),U,42) D ^IMRXOR S (DFN,IMRDFN)=X I $D(^DPT(DFN,0)) D SETLR
 Q
SETLR S PNAM=$P($G(^DPT(DFN,0)),U,1),SSN=$P($G(^DPT(DFN,0)),U,9),IMRTSTLR=$P($G(^DPT(DFN,"LR")),U,1)
 D DATA
 Q
DATA K IMRCD
 Q:$G(IMRTSTLR)=""
 S (IMRTSTI,IMRTSTII)="",ILR=IMRTSTLR
CHEMS S LDT="" F  S LDT=$O(^LR(ILR,"CH",LDT)) Q:LDT=""  D LINK
 Q
LINK S DNAM="" F  S DNAM=$O(IMRVALS(DNAM)),LDR="" Q:DNAM=""  D
 . F  S LDR=$O(IMRVALS(DNAM,LDR)) Q:LDR=""  S GRP=$P(IMRVALS(DNAM,LDR),U,1),TYP=$P(IMRVALS(DNAM,LDR),U,2),LNM=$P(IMRVALS(DNAM,LDR),U,3) D LVAL
 Q
LVAL S LRES=$P($G(^LR(ILR,"CH",LDT,DNAM)),U,1),DTRC=$P($G(^LR(ILR,"CH",LDT,0)),U,1),Y=DTRC D DD^%DT S DTAA=Y D PLBS
 Q
PLBS Q:(DTRC>IMRHNEND)!(DTRC<IMRHNBEG)
 Q:LRES=""
 Q:(LRES["CANC")!(LRES["canc")
 Q:(LRES["COMM")!(LRES["comm")
 Q:(DTRC["CANC")!(DTRC["canc")
 S OYR=$E(DTRC,1,3),ODYR=OYR+1700,ODYR=$E(ODYR,3,4),ODAT=$E(DTRC,4,5)_"/"_$E(DTRC,6,7)_"/"_ODYR
 S DTAA=$E(DTAA,1,18),LDO=$E(LDT,1,7)
 I (GRP="CD4")&(TYP'="CD4 PERCENT") Q:(LRES>CDHN)!(LRES<CDLN)
 I GRP="VIRAL LOAD" S BRES=LRES D CHK I (LRES>VLH)!(LRES<VLL) S LRES=BRES Q
 S ^TMP($J,PNAM,SSN,LDO,TYP,LRES,DNAM)=LNM_U_GRP_U_LDR_U_DTRC_U_ODAT
 Q
CHK S:LRES[" " LRES=$P(LRES," ",1)
 S:LRES[">" LRES=$E(LRES,2,20)
 S:LRES["<" LRES=$E(LRES,2,20)
 S:LRES["," LRES=$P(LRES,",",1)_$P(LRES,",",2)
 Q
SORT I '$D(^TMP($J)) W !,"**NO DATA FOUND**" Q
 S TY=""
SEC S (D,P)=""
 F  S P=$O(^TMP($J,P)) Q:P=""  F  S D=$O(^TMP($J,P,D)),I="" Q:D=""  F I=0:0 S I=$O(^TMP($J,P,D,I)),T="" Q:I=""  F  S T=$O(^TMP($J,P,D,I,T)),G="" Q:T=""  F  S G=$O(^TMP($J,P,D,I,T,G)),H="" Q:G=""  F  S H=$O(^TMP($J,P,D,I,T,G,H)) Q:H=""  D SC
 Q
SC S RC=^TMP($J,P,D,I,T,G,H),LN=$P(RC,U,1),IMDATE=$P(RC,U,5)
 W:DELIM="Y" !,$E(P,1,15)_"^"_$E(D,6,9)_"^"_$E(T,1,14)_"^"_IMDATE_"^"_$E(LN,1,15)_"^"_G
 W:DELIM'="Y" !,$E(P,1,15),?17,$E(D,6,9),?23,$E(T,1,14),?39,IMDATE,?50,$E(LN,1,15),?67,$E(G,1,14)
 S TY=T
 Q
KILL D ^%ZISC
 K ^TMP($J),%,%DT,%I,B,BCDH,BCDL,BRES,BVLH,BVLL,C,CDHN,CDLN,D,DELIM,DNAM,DTAA,DTRC,G,GROUP,GRP,GRPNM,H,ICR,IFN,ILR,IMDATE,DIC,DTOUT,DUOUT,IMRLRC,IMRC,IMRC1,IMRFLG,IMRHNBEG,IMRHNEND
 K IMRVALS,IMRUT,I,J,K,M,N,POP,X,X1,Y,DFN,K1,T,IMRV,VAERR,IMRY,IMRZ,DISYS,IMRDTE,IMRPG,IMRCD,IMRTSTI,IMRSSN,IMRTOT,IMRNODE
 K IMRJ,IMRNAM,IMRSTN,IMRSD,IMRED,IMRX,IMRD,IMRAD,IMRDD,IMRDFN,IMRI,IMRLRFN,IMRCAT,IMRDFN,IMRDTNM,IMRFLG,IMRH1HED,IMRH2HED,IMRHENGD
 K IMRHNBEG,IMRHNEND,IMRHQUIT,IMRHRANG,IMRHTART,IMRSTN,IMRTEST,IMRDATE,IMRDOT
 K IMRTSTII,IMRTSTLR,L,LBNM,LDO,LDR,LDT,LN,LNM,LRES,NODE,ODAT,ODYR,OYR,P,PNAM,RC,RNG,SELE,SSN,TE,TTYPE,TY,TYP,TYPE,VLH,VLL
 Q
EOP ; Check End of Page
 S IMRUT=0
 Q:$D(IO("S"))
 I $E(IOST,1,2)="C-" W ! S DIR(0)="E" D ^DIR K DIR I 'Y S IMRUT=1 Q
 Q
HEAD ; Heading of the Specific Lab Report
 Q:$G(DELIM)="Y"
 W:'($E(IOST,1,2)'="C-"&'IMRPG) @IOF S IMRPG=IMRPG+1
 W:IOST'["C-" !!!
 W !,?65,IMRHENGD,!!,?13,"C D 4 / V I R A L  T E S T  L I S T S  B Y  R A N G E"
 W:$G(CDHN)'="" !!,?26,"CD4 Range: "_CDLN_" - "_CDHN
 W:$G(VLH)'="" !,?26,"Viral Load Range: "_VLL_" - "_VLH
 W !!,?10,"Date "_IMRHRANG,?65,"Page ",IMRPG,!!
 W !,"Name",?17,"SSN",?25,"Type",?41,"Date",?52,"Test",?67,"Result"
 W !,"----",?17,"---",?25,"----",?41,"----",?52,"----",?67,"------"
 Q
