RMPRP21 ;PHX/RFM-PRINT 10-2421 ;8/29/1994
        ;;3.0;PROSTHETICS;**3,19,55,90,129,133,139,153**;Feb 09, 1996;Build 10
        ;
        ; ODJ - patch 55 - 1/29/01 - extrinsic to get mail routing code
        ;                            from site param. replaces hard code 121
        ;                            nois AUG-1097-32118
        ;
        I '$D(RMPR)!'$D(RMPRSITE) D DIV4^RMPRSIT Q:$D(X)
        I +$P(^RMPR(669.9,RMPRSITE,0),U,5) I $D(RMPRA)&($D(^%ZIS(1,$P(^RMPR(669.9,RMPRSITE,0),U,5),0))) S IOP="Q;"_$P(^(0),U,1) S %ZIS="MQ" D ^%ZIS G:POP EX S ZTIO=ION G PT
        I $D(RMPRA)&('$P(^RMPR(669.9,RMPRSITE,0),U,5)) G ZIS
EN      ;ENTRY POINT FOR REPRINTING A 10-2421 FORM
        I '$D(RMPR) D DIV4^RMPRSIT G:$D(X) EX
        S RMPRACT=1,DIC="^RMPR(664,",DIC(0)="AEQM",DIC("A")="Select Transaction or Patient Name: ",RMPRF=2
        S DIC("S")="I $D(^RMPR(664,Y,1)) S RZZZ=$O(^RMPR(664,Y,1,0)) I RZZZ S RX=$P(^(RZZZ,0),U,13) S:$D(^RMPR(660,+RX,0)) RX=$P(^(0),U,13) I RX=2,'$D(^RMPR(664,""AP"",RMPR(""STA""),Y))"
        S DIC("W")="D EN2^RMPRD1" D ^DIC G:Y<0 EX S RMPRA=+Y I $P(^RMPR(664,+Y,0),U,5) D M2^RMPRM
        D PR^RMPR21A I %'>0 G EX
        I +$P(^RMPR(669.9,RMPRSITE,0),U,5) I $D(RMPRA)&($D(^%ZIS(1,$P(^RMPR(669.9,RMPRSITE,0),U,5),0))) S IOP="Q;"_$P(^(0),U,1),%ZIS="Q" D ^%ZIS G:POP EX S ZTIO=ION G PT
ZIS     S %ZIS="QM" D ^%ZIS G:POP EX
        I '$D(IO("Q")) U IO G PRT
        S ZTIO=ION
PT      S ZTDTH=$H,ZTSAVE("RMPRPN")="",ZTSAVE("RMPRA")="",ZTSAVE("RMPRSITE")="",ZTSAVE("RMPR(")="",ZTRTN="PRT^RMPRP21",ZTDESC="2421 FORM"
         S:$D(RMPRPRIV) ZTSAVE("RMPRPRIV")="" D ^%ZTLOAD W !,$S($D(ZTSK):"<REQUEST QUEUED>",1:"<REQUEST NOT QUEUED>") D HOME^%ZIS H 3 G EX
PRT     ;ENTRY POINT TO PRINT 2421S
        S %X="^RMPR(664,RMPRA,",%Y="R664(" D %XY^%RCR K %X,%Y
        S RDUZ=$P(R664(0),U,9),RDUZ=$P(^VA(200,RDUZ,0),U,1),DFN=$P(R664(0),U,2),RTN=$P(R664(0),U,7),CP=$P(R664(0),U,6),CP=$P($G(^PRCS(410,CP,0)),U,1),RMPRPAGE=2
        D ADD^VADPT,DEM^VADPT,ELIG^VADPT
        W:$Y>0 @IOF W ?20,"OMB Number 2900-0188",?50,"PO#: "
        W !,"By receiving this purchase order you agree to take appropriate measures to"
        W !,"secure the information and ensure the confidentiality of the patient information"
        W !,"is maintained. ORIGINAL PO AND INVOICE MUST BE SUBMITTED TO THE VAMC BELOW"
HDR     ;PRINT HEADER FOR 2421 ADDRESS INFO
        I $P($G(R664(4)),U,8) W !,?30,"***WORKING COPY***"
        S (RMPRT,RMPRB)="",$P(RMPRT,"_",IOM)="",$P(RMPRB,"-",IOM)="" W !,RMPRT,!,"Department of Veterans Affairs"_"|"_"Prosthetic Authorization for Items or Services",!,RMPRB
        W !,"1. Name and Address of Vendor",?40,"2. Name and Address of VA Facility"
        S RMPRV=$P(R664(0),U,4),RMPRST=""
        I $D(^PRC(440,RMPRV,0)) S RMPRV=^PRC(440,RMPRV,0) D
        .S RMPRST=$P(RMPRV,U,7),RMPRPHON=$P(RMPRV,U,10)
        .S RMPRAD1=$P(RMPRV,U,2),RMPRAD2=$P(RMPRV,U,3)
        .S RMPRCITY=$P(RMPRV,U,6),RMPR90IP=$P(RMPRV,U,8)
        .S RMPRVACN=$P($G(^PRC(440,$P(R664(0),U,4),2)),U,1)
        I $D(^DIC(5,+RMPRST,0)) S RMPRST=$P(^(0),U,2)
        E  S RMPRST="NO STATE ON FILE"
        W !,?5,$E($P(RMPRV,U,1),1,30),?40
        W $E(RMPR("NAME"),1,28)," ","(",$$STA^RMPRUTIL,"/",$$ROU^RMPRUTIL(RMPRSITE),")"
        W !,?5,$E(RMPRAD1,1,35),?40,$E(RMPR("ADD"),1,39)
        I RMPRAD2'="" W !,?5,$E(RMPRAD2,1,35),?40,RMPR("CITY")
        I RMPRAD2="" W !?5,RMPRCITY_","_RMPRST_" "_RMPR90IP,?40,RMPR("CITY")
        I RMPRAD2'="" W !?5,RMPRCITY_","_RMPRST_" "_RMPR90IP
        W !,?5,RMPRPHON
        ;W:$G(RMPRVACN)'="" ?22,"ACCT # ",RMPRVACN
        W ?40,$P(^RMPR(669.9,RMPRSITE,0),U,4),!,RMPRB
        W !,"3. Veterans Name (Last, First, MI)",?40,"4. Date of Authorization"
        W !,?5,VADM(1) S Y=$P(R664(0),U,1) D DD^%DT W ?45,Y
        I $D(RMPRMOR) W !,RMPRB D HDR1 Q
        W !,RMPRB S RMPRODTE=Y
        S RMPRDELD="" I $D(R664(3)),$P(R664(3),U,2)]"" S Y=$P(R664(3),U,2) D DD^%DT S RMPRDELD=Y
        W !,"5. Veterans Address",?40,"6. Date Required",!,?5,VAPA(1),?45,RMPRDELD,!
        I VAPA(2)="" W ?5,VAPA(4)_","_$P(VAPA(5),U,2)_" "_VAPA(6),?40,$E(RMPRB,1,40),!,?40,"9. Authority For Issuance  CFR 17.115",!,?5,VAPA(8),?43,"CHARGE MEDICAL APPROPRIATION"
        I VAPA(2)'="" W ?5,VAPA(2),?40,$E(RMPRB,1,40),!,?5,VAPA(4)_","_$P(VAPA(5),U,2)_" "_VAPA(6),?40,"9. Authority For Issuance  CFR 17.115",!,?5,VAPA(8),?43,"CHARGE MEDICAL APPROPRIATION"
        W !,RMPRB
        W !,"7. Claim Number",?40,"8. SSN",!,RMPRB,!,"10. Statistical Data",?30,"11. FOB Point",?46,"12. Discount",?61,"13. Delivery Time"
        S R664("E")=$O(R664(1,0)),CAT=$P(R664(1,R664("E"),0),U,10)
        S RMPRCAT=$S(CAT=1:"SC/OP",CAT=2:"SC/IP",CAT=3:"NSC/IP",CAT=4:"NSC/OP",1:"") S SPE=$P(R664(1,R664("E"),0),U,11)
        S RMPRSCAT=$S(SPE=1:"SPECIAL LEGISLATION",SPE=2:"A&A",SPE=3:"PHC",SPE=4:"ELIGIBILITY REFORM",1:"")
        W !,RMPRCAT_" "_RMPRSCAT S:+$P(R664(0),U,10) RMPRFOB=$P(R664(0),U,10) W ?34,$S($D(RMPRFOB):"ORIGIN",1:"DEST"),?49,"% " I $D(R664(2)) W $P(R664(2),U,6)
        I $D(R664(3)) W ?66,$P(R664(3),U,3)_" Days"
        W !,?30,$E(RMPRB,1,50),!,?30,"14. Delivery To: " W:$D(R664(3)) $P(R664(3),U) W !,RMPRB
HDR1    ;HEADER FOR 10-2421
        W !?17,"15. DESCRIPTION OF ITEMS OR SERVICES AUTHORIZED",!,RMPRB,!,"ITEM NUMBER",?23,"DESCRIPTION/NOMENCLATURE",?50,"QUANTITY",?60,"UNIT",?66,"UNIT",?73,"AMOUNT",!,?50,"ORDERED",?66,"PRICE",!,RMPRB Q:$D(RMPRMOR)
        D ^RMPRP22 D:'$D(RMPRMOR1) CON^RMPRP22
        S RMPRK=RMPRA
        D:$D(RMPRPRIV) ^RMPRP23
        W:$G(RMPRPN)=1 @IOF,$$EN^RMPRP24(RMPRK)
EX      ;KILL VARIABLES AND EXIT ROUTINE
        K VADM,CP,DFN,CAT,DIC,R664,RMPRA,RMPACT,RMPRAD1,RMPRAD2,RMPRAMT,RMPRAMT1,RMPRB,RMPRCAT,RMPRCH,RMPRCITY,RMPRDELD,RMPRI,RMPRI1,RMPRIT,RMPRN,RMPRODTE,RMPRST,RMPRPHON,RMPRT,RMPRTOT,RMPRUT,RMPRV,RMPR90IP,RO,RP,J1,RTN,RMPRMOR1,RMPRPRIV
        K SPE,VA,VAEL,VAPA,VAERR,RZZZ,RX,RX1,RDUZ,RC,RMPRACT,RMPRSCAT,RMPRDISC,RMPRAMTN,DIR,DIRUT,RMPRAMT2,RMPRFOB,RMPRDA,RMPRMOR,RMPRPAGE,RMPRPRIV,RMPRX,RMPR90,J,K,N D ^%ZISC Q
