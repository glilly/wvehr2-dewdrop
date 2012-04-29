VEPERXPR ;DAOU/JLG&MRM - Rx Print ; 4/14/05 9:13am
 ;;1.0;t1;VO Pharmacy; Mar 25, 2005;Build 1
 ;                               -----
INIT ; Set up variables.
 S VEPEIO=""
 N RXNUM,IENS,FIELDS,VEPERX,PROV,PAT,PROVIEN,VEPEPROV,PROVNAM
 N PATIEN,VEPEPAT,PATNAMN
CHK ;Check for Rx interactions.
 S PPL1=1 S:'$G(PPL) PPL=$G(PSORX("PSOL",PPL1))
 G:$G(PPL)']"" D1
CHK2 K SPPL G:$D(DTOUT) D1 S SPPL="" F PI=1:1 Q:$P(PPL,",",PI)=""  D
 .S DA=$P(PPL,",",PI)
 .I $P(^PSRX(DA,"STA"),"^")=4 S SPPL=SPPL_DA_"," Q
 I $G(SPPL)]"" D
 .W !!,$C(7),"Drug Interaction Rx(s) "
 .F I=1:1 Q:$P(SPPL,",",I)=""  W $P(^PSRX($P(SPPL,",",I),0),"^")_", "
 .S PPL=SPPL,DG=1 D Q1 K DG,SPPL
D1 K RXLTOP
 I $G(PPL1),$O(PSORX("PSOL",$G(PPL1))) S PPL1=$O(PSORX("PSOL",PPL1)),PPL=PSORX("PSOL",PPL1) G GETINFO
 I $G(PPL1),$O(PSORX("PSOL",$G(PPL1))) D  Q  G GETINFO
 .S PPL1=$O(PSORX("PSOL",PPL1)),PPL=PSORX("PSOL",PPL1)
Q1 S PPL1=1 G:$G(PPL)']"" D1 S PSNP=0,PSL=1
 D  I $G(PSOFROM)="NEW",$P(PSOPAR,"^",8) S PSNP=1
 .Q:'$P(PSOPAR,"^",8)!($G(PSONOPRT))
 .F SLPPL=0:0 S SLPPL=$O(RXRS(SLPPL)) Q:'SLPPL!($G(PSNP))  I '$O(^PSRX(SLPPL,1,0)),'$D(RXPR(SLPPL)) S PSNP=1
 ;
 ;Apparently the subscripts of RXFL contain the Rx numbers
GETINFO S RXNUM=0
 F  S RXNUM=$O(RXFL(RXNUM)) Q:RXNUM=""  D
 . D RX,PROV,INST,PAT,PRINT
 . K RXFL(RXNUM)
 . S:'$D(RXNUM)&$D(RXIEN) RXNUM=+RXIEN
 D EXIT
 Q
RX S RXIEN=RXNUM
 S FIELDS="1;2;4;6;7;9;10.1;26"
 ;Fields are patient,provider,drug,QTY,#refills,Sig1
 D GETS^DIQ(52,RXIEN,FIELDS,"R","VEPERX")
 S Y=$$GET1^DIQ(52,RXIEN,39.1,"","RXARY")
 S RXIEN=RXIEN_","
 S PAT=VEPERX(52,RXIEN,"PATIENT"),PROV=VEPERX(52,RXIEN,"PROVIDER")
 S DRUG=VEPERX(52,RXIEN,"DRUG"),QTY=VEPERX(52,RXIEN,"QTY")
 S RFL=VEPERX(52,RXIEN,"# OF REFILLS")
 S SIGN=$S(VEPERX(52,RXIEN,"OERR SIG")="YES":1,1:0)
 Q
PROV ;Get provider information
 D FIND^DIC(200,"","","",PROV,"","B","","","VEPEPROV")
 S PROVIEN=VEPEPROV("DILIST",2,1)
 ;ADDRESS, CITY, STATE, ZIP, PHONE, TITLE, DEA #, ELECTRONIC SIG
 K VEPEPROV
 S FIELDS=".01;.132;8;53.2;16*;70"
 D GETS^DIQ(200,PROVIEN,FIELDS,"R","VEPEPROV")
 S PROVNAM=$P(PROV,",",2)_" "_$P(PROV,",",1),PROVIEN=PROVIEN_","
 S DEA=VEPEPROV(200,PROVIEN,"DEA#"),PHONE=VEPEPROV(200,PROVIEN,"OFFICE PHONE")
 S TITLE=VEPEPROV(200,PROVIEN,"TITLE"),N=""
 F  S N=$O(VEPEPROV(200.02,N)) Q:N=""  S:'$D(INST) INST=VEPEPROV(200.02,N,"DIVISION") S:VEPEPROV(200.02,N,"DEFAULT")="Yes" INST=VEPEPROV(200.02,N,"DIVISION")
 Q
INST ;Get institute information
 D FIND^DIC(4,"","","",INST,"","B","","","VEPEINST")
 S INSTIEN=VEPEINST("DILIST",2,1)
 K VEPEINST
 S FIELDS="1.01;1.02;1.03;1.04;4.04"
 D GETS^DIQ(4,INSTIEN,FIELDS,"R","VEPEINST")
 S INSTIEN=INSTIEN_","
 S PROVCITY=VEPEINST(4,INSTIEN,"CITY"),PROVCITY=PROVCITY_", "_VEPEINST(4,INSTIEN,"STATE (MAILING)")
 S PROVCITY=PROVCITY_" "_VEPEINST(4,INSTIEN,"ZIP")
 S:$D(VEPEINST(4,INSTIEN,"STREET ADDR. 1")) PROVADD=VEPEINST(4,INSTIEN,"STREET ADDR. 1")
 S:$D(VEPEINST(4,INSTIEN,"STREET ADDR. 2")) PROVADD=PROVADD_" "_VEPEINST(4,INSTIEN,"STREET ADDR. 2")
 Q
PAT ;Get patient information
 D FIND^DIC(2,"","","",PAT,"","B","","","VEPEPAT")
 S PATIEN=VEPEPAT("DILIST",2,1)
 ;AGE,ADDRESS
 S FIELDS=".033;.111;.112;.113;.114;.115;.116"
 D GETS^DIQ(2,PATIEN,FIELDS,"R","VEPEPAT")
 S PATNAM=$P(PAT,",",2)_" "_$P(PAT,",",1),PATIEN=PATIEN_","
 S AGE=VEPEPAT(2,PATIEN,"AGE")
 S PATADD1=VEPEPAT(2,PATIEN,"STREET ADDRESS [LINE 1]")
 S PATADD2=VEPEPAT(2,PATIEN,"STREET ADDRESS [LINE 2]")
 S PATADD3=VEPEPAT(2,PATIEN,"STREET ADDRESS [LINE 3]")
 S PATADD=$S($D(PATADD1):PATADD1,1:"")_$S($D(PATADD2):PATADD2,1:"")
 S PATADD=PATADD_$S($D(PATADD3):PATADD3,1:"")
 S PATCITY=VEPEPAT(2,PATIEN,"CITY")_", "_VEPEPAT(2,PATIEN,"STATE")
 S PATCITY=PATCITY_VEPEPAT(2,PATIEN,"ZIP CODE")
 Q
PRINT ;Print prescription
 D:PSOPRDEV="F" FAX D:PSOPRDEV="P" PRINTER D:PSOPRDEV="E" EDI
 Q:PSOPRDEV="E"
 Q:POP
 S %DT="T",X="N" D ^%DT S $P(^PSRX(52,92001),U,1)=+Y
 S $P(^PSRX(52,92001),U,2)=PSOPRDEV
 G:'Y EXIT
 U IO
PRINT2 W !,PROVNAM W:$D(TITLE) ", "_TITLE
 W:$D(PROVADD) !,PROVADD
 W !,PROVCITY
 W:$D(PHONE) !,PHONE_"          "
 W:'$D(PHONE) ! W "DEA #:"_DEA
 W !,"__________________________________________________"
 W !,$$FMTE^XLFDT(DT,1)
 W !,PATNAM_"          AGE: "_AGE
 W !,PATADD,PATCITY
 W !!,"    Rx  ",!
 W !,"       "_DRUG
 W !,"       QTY: "_QTY
 I $D(RXARY) S N="" F  S N=$O(RXARY(N)) Q:N=""  W !,RXARY(N)
 W !!!
 W !,"Signature:  ____________________________________"
 W:$D(SIGN) !,"E/S  "_PROVNAM W:'$D(SIGN) !,PROVNAM
 W !,"This prescription will be filled generically"
 W !,"unless prescriber writes 'd a w' in the box below"
 W !,"Refills: "_RFL
 W !,"NR _____ Label _____      __________"
 W !,"                         |          |"
 W !,"                         |          |"
 W !,"                         |          |"
 W !,"                          __________",!
 W !,$P(+PATIEN,",")_"-"_$P(+PROVIEN,",")_"-"_$P(+RXIEN,",")
 W $C(10)
 D ACLOG
 U IO(0)
 Q
FAX S %ZIS="QM",%ZIS("A")="Select fax machine: " D ^%ZIS
 I POP W !,*7,"Prescription was not printed, going to next Prescription",!?10,*7,"Don't forget this prescription" Q
 K %ZIS,IOP G:POP EXIT  S PSOION=ION,PSOPIOST=$G(IOST(0))
 N PSOIOS S PSOIOS=IOS,PSOQUE=$D(IO("Q"))
 S DIC="^VEPER(19904.3,"
 S DIC(0)="AEQMZ"
 S DIC("A")="Enter recipient: "
 D ^DIC
 I Y=-1 W !,*7,"Prescription was not faxed, going on to next Prescription",!?10,*7,"Don't forget this prescription" Q
 S VEPEREC=$P(Y(0),U),VEPENUM=$P(Y(0),U,5)
 S VEPEPHARM=$P(Y,"^"),VEPEPHARM="1"_$E("000000",1,6-$L(VEPEPHARM))_VEPEPHARM
 W !!,"Prescription(s) will be faxed to ",VEPEREC," at number: ",VEPENUM H 2
 D DEV
 Q
PRINTER Q:VEPEIO'=""
 S %ZIS="QM",%ZIS("A")="Select Prescription printer: " D ^%ZIS
 I POP W !,*7,"Prescription was not printed, going to next Prescription",!?10,*7,"Don't forget this prescription" Q
 ; *** Commented out next line for test, remove comment later ***
 ;I IO'["|PRN|" U IO W !!,"Prescriptions will not print to your screen",!! C IO G PRINTER
 S VEPEIO=IO
 K %ZIS,IOP G:POP EXIT S PSOION=ION,PSOPIOST=$G(IOST(0))
 N PSOIOS S PSOIOS=IOS,PSOQUE=$D(IO("Q"))
 ; If desired insert printer alignment here, probably call ^PSOLBLT
 Q
DEV N FIL,DIR,IOP,X,Y,%ZIS W !
 D HOME^%ZIS
 S FIL=$$GET1^DIQ(59,"1,",92001.3)
 S:PSOPRDEV="F" FIL=FIL_"\FAX\"_DT_VEPEPHARM_$P(RXIEN,",")_".DAT"
 S:PSOPRDEV="E" FIL=FIL_"\HL7\"_DT_VEPEPHARM_$P(RXIEN,",")_".DAT"
 S %ZIS="",%ZIS("HFSNAME")=FIL,%ZIS("HFSMODE")="W",IOP="HFS",(XPDSIZ,XPDSIZA)=0,XPDSEQ=1
 D ^%ZIS
 Q
QUE S ZTRTN="PRNT2^VEPERXPR",ZTDESC="Print/Fax Prescription"
 S ZTSAVE("PROVNAM")=PROVNAM,ZTSAVE("PATNAM")=PATNAM
 S ZTSAVE("PROVIEN")=PROVIEN,ZTSAVE("PSOPRDEV")=PSOPRDEV
 S ZTSAVE("PATIEN")=PATIEN,ZTSAVE("RXIEN")=RXIEN
 S ZTSAVE("TITLE")=TITLE
 S ZTSAVE("PROVCITY")=PROVCITY,ZTSAVE("PHONE")=PHONE,ZTSAVE("DEA")=DEA
 S ZTSAVE("PATADD")=PATADD,ZTSAVE("AGE")=AGE,ZTSAVE("PATCITY")=PATCITY
 S ZTSAVE("DRUG")=DRUG,ZTSAVE("QTY")=QTY,ZTSAVE("SIGN")=SIGN
 S ZTSAVE("RFL")=RFL,ZTSAVE("PROVADD")=PROVADD
 S N="" F  S N=$O(RXARY(N)) Q:N=""  S ZTSAVE("RXARY("_N_")")=RXARY(N)
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Prescription has been queued, task # "_ZTSK,1:"Unable to queue prescription"),!!!
 K ZTSK,IO("Q") D HOME^%ZIS
 Q
EDI N MSG,COUNT
 D EN^VEPEHL7($P(RXIEN,","),.COUNT,.MSG)
 S DIC="^VEPER(19904.3,"
 S DIC(0)="AEQMZ"
 S DIC("A")="Enter recipient: "
 D ^DIC
 I Y=-1 W !,*7,"Prescription was not transmitted, going on to next Prescription",!?10,*7,"Don't forget this prescription" Q
 S VEPEREC=$P(Y(0),U),VEPENUM=$P(Y(0),U,5)
 S VEPEPHARM=$P(Y,"^"),VEPEPHARM="1"_$E("000000",1,6-$L(VEPEPHARM))_VEPEPHARM
 W !!,"Prescription(s) will be transmitted to ",VEPEREC H 2
 D DEV
 U IO F I=1:1:COUNT W MSG(I),!
 D ^%ZISC
 D ACLOG
 U IO(0)
 Q
ACLOG    ;Activity log
 N DTTM,HCOM,HCNT,HJJ,HRXIEN,HRXEIN
 S HRXIEN=$P(RXIEN,",")
 S HRXEIN=$P(^PSRX($P(RXIEN,","),0),U)
 D NOW^%DTC S DTTM=%
 S:PSOPRDEV="F" HMSG=" faxed to "_VEPEREC
 S:PSOPRDEV="E" HMSG=" transmitted to "_VEPEREC
 S:PSOPRDEV="P" HMSG=" printed."
 S HCOM="Prescription "_HRXEIN_HMSG
 S HCNT=0
 F HJJ=0:0 S HJJ=$O(^PSRX(HRXIEN,"A",HJJ)) Q:'HJJ  S HCNT=HJJ
 S HCNT=HCNT+1
 S ^PSRX(HRXIEN,"A",0)="^52.3DA^"_HCNT_"^"_HCNT
 S ^PSRX(HRXIEN,"A",HCNT,0)=DTTM_"^G^"_$G(DUZ)_"^0^"_HCOM
 Q
EXIT ;Exit
 K RXNUM,RXIEN,FIELDS,VEPERX,PROV,PAT,PROVIEN,VEPEPROV,PROVNAM
 K PATIEN,VEPEPAT,PATNAMN,VEPEIO
 D ^%ZISC
 Q
