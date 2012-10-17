RMPR9P21        ;PHX/SPS,HNC,RVD -SEND DATA TO PC TO PRINT PURCHASE CARD ORDER ;4/27/05
        ;;3.0;PROSTHETICS;**90,116,119,133,139,153**;Feb 09, 1996;Build 10
        ;
EN(RMPRA,RMPRSITE,RMPRPTR)      ;ENTRY POINT FOR VISTA ROLL AND SCROLL
        G EN2
        ;
PRT(RESULTS,RMPRA,RMPRSITE,RMPRPTR)     ;GUI ENTRY POINT TO PRINT
EN2     I RMPRPTR'="WINDOWS" Q
        K ^TMP($J,"RMPRPRT"),RESULTS
        D INF^RMPRSIT
        S %X="^RMPR(664,RMPRA,",%Y="R664(" D %XY^%RCR K %X,%Y,^TMP($J,"RMPRPRT")
        S RDUZ=$P(R664(0),U,9),RDUZ=$P(^VA(200,RDUZ,0),U,1),DFN=$P(R664(0),U,2),RTN=$P(R664(0),U,7),CP=$P(R664(0),U,6),RMPRPAGE=2
        D ADD^VADPT,DEM^VADPT,ELIG^VADPT
        S ^TMP($J,"RMPRPRT",0)="                           OMB Number 2900-0188                    PO#: "_$P($G(^RMPR(664,RMPRA,4)),U,5)
        S ^TMP($J,"RMPRPRT",1)="By receiving this purchase order you agree to take appropriate measures to"
        S ^TMP($J,"RMPRPRT",2)="secure the information and ensure the confidentiality of the patient information"
        S ^TMP($J,"RMPRPRT",3)="is maintained. ORIGINAL PO AND INVOICE MUST BE SUBMITTED TO THE VAMC BELOW"
HDR     ;PRINT HEADER FOR 2421 ADDRESS INFO
        S K="" F  S K=$O(^TMP($J,"RMPRPRT",K)) Q:K=""  S CNT=K
        S (RMPRT,RMPRB)="",$P(RMPRT,"_",80)="",$P(RMPRB,"-",80)=""
        S ^TMP($J,"RMPRPRT",CNT+1)=RMPRT
        S ^TMP($J,"RMPRPRT",CNT+2)="Department of Veterans Affairs"_"|"_"Prosthetic Authorization for Items or Services"
        S ^TMP($J,"RMPRPRT",CNT+3)=RMPRB
        S ^TMP($J,"RMPRPRT",CNT+4)="1. Name and Address of Vendor          2. Name and Address of VA Facility"
        S RMPRV=$P(R664(0),U,4),RMPRST=""
        I $D(^PRC(440,RMPRV,0)) S RMPRV=^PRC(440,RMPRV,0) D
        .S RMPRST=$P(RMPRV,U,7),RMPRPHON=$P(RMPRV,U,10)
        .S RMPRAD1=$P(RMPRV,U,2),RMPRAD2=$P(RMPRV,U,3)
        .S RMPRCITY=$P(RMPRV,U,6),RMPR90IP=$P(RMPRV,U,8)
        .S RMPRVACN=$P($G(^PRC(440,$P(R664(0),U,4),2)),U,1)
        I $D(^DIC(5,+RMPRST,0)) S RMPRST=$P(^(0),U,2)
        E  S RMPRST="NO STATE ON FILE"
        S SPACE="",LRMPRV=$L($E($P(RMPRV,U,1),1,30)),$P(SPACE," ",40-LRMPRV)=""
        S ^TMP($J,"RMPRPRT",CNT+5)="    "_$E($P(RMPRV,U,1),1,30)_SPACE_$E(RMPR("NAME"),1,28)_" ,("_$$STA^RMPRUTIL_"/"_$$ROU^RMPRUTIL(RMPRSITE)_")"
        S LRMPRCTY=$L(RMPRCITY),LRMPRST=$L(RMPRST),LRMPRAD1=$L($E(RMPRAD1,1,35))
        S SPACE="",$P(SPACE," ",40-LRMPRAD1)=""
        S ^TMP($J,"RMPRPRT",CNT+6)="    "_$E(RMPRAD1,1,35)_SPACE_$E(RMPR("ADD"),1,39)
        S SPACE="",LRMPRAD2=$L($E(RMPRAD2,1,35)),$P(SPACE," ",45-LRMPRAD1)=""
        I RMPRAD2'="" S ^TMP($J,"RMPRPRT",CNT+7)="    "_$E(RMPRAD2,1,35)_SPACE_RMPR("CITY")
        S SPACE="",$P(SPACE," ",33-LRMPRCTY-LRMPRST)=""
        I RMPRAD2="" S ^TMP($J,"RMPRPRT",CNT+7)="    "_RMPRCITY_","_RMPRST_" "_RMPR90IP_SPACE_RMPR("CITY")
        I RMPRAD2'="" S ^TMP($J,"RMPRPRT",CNT+8)="    "_RMPRCITY_","_RMPRST_" "_RMPR90IP
        S K="" F  S K=$O(^TMP($J,"RMPRPRT",K)) Q:K=""  S CNT=K
        S ^TMP($J,"RMPRPRT",CNT+1)="    "_RMPRPHON_"                          "_$P(^RMPR(669.9,RMPRSITE,0),U,4)
        S ^TMP($J,"RMPRPRT",CNT+2)=RMPRB
        S ^TMP($J,"RMPRPRT",CNT+3)="3. Veterans Name (Last, First, MI)     4. Date of Authorization"
        S SPACE="",VADM1=$L(VADM(1))
        S ^TMP($J,"RMPRPRT",CNT+4)="    "_VADM(1) S Y=$P(R664(0),U,1) D DD^%DT
        S SPACE="",$P(SPACE," ",40-VADM1)=""
        S ^TMP($J,"RMPRPRT",CNT+4)=^TMP($J,"RMPRPRT",CNT+4)_SPACE_Y
        I $D(RMPRMOR) S ^TMP($J,"RMPRPRT",CNT+5)=RMPRB D HDR1 Q
        S ^TMP($J,"RMPRPRT",CNT+5)=RMPRB S RMPRODTE=Y
        S RMPRDELD="" I $D(R664(3)),$P(R664(3),U,2)]"" S Y=$P(R664(3),U,2) D DD^%DT S RMPRDELD=Y
        S ^TMP($J,"RMPRPRT",CNT+6)="5. Veterans Address                    6. Date Required"
        S SPACE="",VAPA1=$L(VAPA(1)),$P(SPACE," ",40-VAPA1)=""
        S ^TMP($J,"RMPRPRT",CNT+7)="    "_VAPA(1)_SPACE_RMPRDELD
        S SPACE="",VAPA4=$L(VAPA(4)),VAPA5=$P($L(VAPA(5)),U,2),VAPA6=$L(VAPA(6)),$P(SPACE," ",27-VAPA4-VAPA5-VAPA6)=""
        I VAPA(2)="" S ^TMP($J,"RMPRPRT",CNT+8)="    "_VAPA(4)_","_$P(VAPA(5),U,2)_" "_VAPA(6)_SPACE_$E(RMPRB,1,40)
        I VAPA(2)="" S ^TMP($J,"RMPRPRT",CNT+9)="                                        9. Authority For Issuance  CFR 17.115"
        S SPACE="",VAPA8=$L(VAPA(8)),$P(SPACE," ",40-VAPA8)=""
        I VAPA(2)="" S ^TMP($J,"RMPRPRT",CNT+10)="    "_VAPA(8)_SPACE_"CHARGE MEDICAL APPROPRIATION"
        S SPACE="",VAPA2=$L(VAPA(2)),$P(SPACE," ",31-VAPA2)=""
        I VAPA(2)'="" S ^TMP($J,"RMPRPRT",CNT+8)="    "_VAPA(2)_SPACE_$E(RMPRB,1,40)
        S SPACE="",$P(SPACE," ",30-VAPA4-VAPA5-VAPA6)=""
        I VAPA(2)'="" S ^TMP($J,"RMPRPRT",CNT+9)="    "_VAPA(4)_","_$P(VAPA(5),U,2)_" "_VAPA(6)_SPACE_"9. Authority For Issuance  CFR 17.115"
        S SPACE="",$P(SPACE," ",40-VAPA8)=""
        I VAPA(2)'="" S ^TMP($J,"RMPRPRT",CNT+10)="    "_VAPA(8)_SPACE_"CHARGE MEDICAL APPROPRIATION"
        S ^TMP($J,"RMPRPRT",CNT+11)=RMPRB
        ;Remove claim number print in *139 since it held SSN at times
        ;Remove field 8.ID # print in *153 which held last 4 digits of SSN
        S ^TMP($J,"RMPRPRT",CNT+12)="7. Claim Number                        8. ID #:"
        S ^TMP($J,"RMPRPRT",CNT+13)=RMPRB
        S ^TMP($J,"RMPRPRT",CNT+14)="10. Statistical Data         11. FOB Point    12. Discount    13. Delivery Time"
        S R664("E")=$O(R664(1,0)),CAT=$P(R664(1,R664("E"),0),U,10)
        S RMPRCAT=$S(CAT=1:"SC/OP",CAT=2:"SC/IP",CAT=3:"NSC/IP",CAT=4:"NSC/OP",1:"")
        S SPE=$P(R664(1,R664("E"),0),U,11)
        S RMPRSCAT=$S(SPE=1:"SPECIAL LEGISLATION",SPE=2:"A&A",SPE=3:"PHC",SPE=4:"ELIGIBILITY REFORM",1:"")
        S ^TMP($J,"RMPRPRT",CNT+15)="    "_RMPRCAT_" "_RMPRSCAT S:+$P(R664(0),U,10) RMPRFOB=$P(R664(0),U,10)
        S SPACE="",LRMPRCAT=$L(RMPRCAT),LRMPSCAT=$L(RMPRSCAT),$P(SPACE," ",29-LRMPRCAT-LRMPSCAT)=""
        S ^TMP($J,"RMPRPRT",CNT+15)=^TMP($J,"RMPRPRT",CNT+15)_SPACE_$S($D(RMPRFOB):"ORIGIN",1:"DEST ")_"              % "
        I $D(R664(2)) S ^TMP($J,"RMPRPRT",CNT+15)=^TMP($J,"RMPRPRT",CNT+15)_$P(R664(2),U,6)
        I $D(R664(3)) S ^TMP($J,"RMPRPRT",CNT+15)=^TMP($J,"RMPRPRT",CNT+15)_"             "_$P(R664(3),U,3)_" Days"
        S ^TMP($J,"RMPRPRT",CNT+16)=RMPRB
        S ^TMP($J,"RMPRPRT",CNT+17)="14. Delivery To: "
        S:$D(R664(3)) ^TMP($J,"RMPRPRT",CNT+17)=^TMP($J,"RMPRPRT",CNT+17)_$P(R664(3),U)
        S ^TMP($J,"RMPRPRT",CNT+18)="      Attention:  "_$P(R664(3),U,4)
        S ^TMP($J,"RMPRPRT",CNT+19)=RMPRB
HDR1    ;HEADER FOR 10-2421
        S K="" F  S K=$O(^TMP($J,"RMPRPRT",K)) Q:K=""  S CNT=K
        S ^TMP($J,"RMPRPRT",CNT+1)="                15. DESCRIPTION OF ITEMS OR SERVICES AUTHORIZED"
        S ^TMP($J,"RMPRPRT",CNT+2)=RMPRB
        S ^TMP($J,"RMPRPRT",CNT+3)="ITEM NUMBER           DESCRIPTION              QUANTITY  UNIT  UNIT     AMOUNT"
        S ^TMP($J,"RMPRPRT",CNT+4)="                                               ORDERED         PRICE"
        S ^TMP($J,"RMPRPRT",CNT+5)=RMPRB
        Q:$D(RMPRMOR)
        S K="" F  S K=$O(^TMP($J,"RMPRPRT",K)) Q:K=""  S CNT=K
        D ^RMPR9P22
        D:'$D(RMPRMOR1) CON^RMPR9P22
        S K="" F  S K=$O(^TMP($J,"RMPRPRT",K)) Q:K=""  S CNT=K
        D ^RMPR9P23
        M RESULTS=^TMP($J,"RMPRPRT")
EX      ;Common Exit Point
        K VADM,CP,DFN,CAT,DIC,R664,RMPRA,RMPACT,RMPRAD1,RMPRAD2,RMPRAMT,RMPRAMT1,RMPRB,RMPRCAT,RMPRCH,RMPRCITY,RMPRDELD,RMPRI,RMPRI1,RMPRIT,RMPRN,RMPRODTE,RMPRST,RMPRPHON,RMPRT,RMPRTOT,RMPRUT,RMPRV,RMPR90IP,RO,RP,J1,RTN,RMPRMOR1,RMPRPRIV
        K SPE,VA,VAEL,VAPA,VAERR,RZZZ,RX,RX1,RDUZ,RC,RMPRACT,RMPRSCAT,RMPRDISC,RMPRAMTN,DIR,DIRUT,RMPRAMT2,RMPRFOB,RMPRDA,RMPRMOR,RMPRPAGE,RMPRPRIV,RMPRX,RMPR90,J,K,N D ^%ZISC Q
