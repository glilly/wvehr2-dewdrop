PSARDCRD        ;BIRM/JMC - Return Drug Credit Report - Detailed ;06/04/08
        ;;3.0;DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**69**;10/24/97;Build 9
        ;References to ORDER UNIT file (#51.5) supported by IA #1931
        ;
        ;
        N PSARDST,PSAOUT,PRINTFLG
        S PSAOUT=0
        K PAG,^TMP("PSARDCRD1",$J),^TMP("PSARDCRD",$J)
        D STATUS I '$D(PSABASTS) G EXIT
        I $G(PSAEXCEL)=1 S FIRSTHD=1
        S PSARDST="" F  S PSARDST=$O(PSABASTS(PSARDST)) Q:PSARDST=""  D  Q:PSAOUT
        . S PSAPHLC1=$P($G(PSAPHLOC),"^",2)
        . S (PRINTFLG,PSAOUT)=0,(PSABTCH,PSARDCMF)=""
        . U IO D GETDATA Q:PSAOUT 
        . I '$G(PSAEXCEL),'$G(PRINTFLG) D
        . . D HDR W:'$G(PRINTFLG) !!,"*** NO BATCHES FOUND ***",!!! S PRINTFLG=0
        D EXIT
        Q
        ;
HDR     ; - Prints the Header
        N X,DIR,SS,JJ
        S PAG=$G(PAG)+1
        I PAG>1,$E(IOST)="C" D  Q:PSAOUT
        . S SS=22-$Y F JJ=1:1:SS W !
        . S DIR(0)="E",DIR("A")=" Press ENTER to Continue or ^ to Exit" D ^DIR
        . S PSAOUT=$S($D(DIRUT):1,Y:0,1:1)
        W @IOF,"Return Drug Credit Report (DETAILED)",?71,"Page: ",$J(PAG,3)
        W !,"PHARM LOCATION: ",$E($P(PSAPHLOC,"^",2),1,40),?63,"BATCH #: "_$G(PSABTCH)
        W !,"RTN CONTRACTOR: ",$E($G(PSARDCMF),1,31),?$S(PSARDST="AP":57,1:63),"STATUS: ",$G(PSABASTS(PSARDST))
        I PSARDST="CA",$G(PSABATCH) D
        . W !,"CANCELLED CMTS: ",$E($P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^",3),1,31)
        . W ?48,$J("CANCELLED BY: "_$E($P($G(^VA(200,+$P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^",2),0)),"^"),1,18),32)
        W !,"Date Range: "_$$FMTE^XLFDT(PSARDRBD,"2Z")_" THRU "_$$FMTE^XLFDT(PSARDRED,"2Z")
        W ?53,"Run Date: "_$$FMTE^XLFDT($$NOW^XLFDT(),"2Z")
        I PSARDST="PU"!(PSARDST="CO") W !,"Total Batch Credit: $"_$J($S(PSARDST="PU":$G(CREDTOT),PSARDST="CO":$G(CRDTOTCO),1:0),0,2)
        S X="",$P(X,"-",80)="-" W !,X
        Q
        ;
STATUS  ;Create local array of statuses.
        F I=1:1:$L(PSABASTS,",") D
        . S PSARDST=$P(PSABASTS,",",I)
        . S PSABASTS(PSARDST)=$S(PSARDST="AP":"AWAITING PICKUP",PSARDST="PU":"PICKED UP",PSARDST="CA":"CANCELLED",1:"COMPLETED")
        Q
        ;
EXIT    ; KILL VARIABLES AND EXIT
        D ^%ZISC
        K PSABASTS,CREDTOT,CREDTOT1,DRUGTOT,DRUGTOT1,CRDTOTCO,PSARDST,PSABATCH,PSAPHLOC
        K BATTOT,PSARDRBD,PSARDRED,PSARDCMF,CRED,I,DIR,X,PAG,PSADTRNG,PSARDRTP,PSAPHLC1
        K PSABTCH,J,XX,MFR,UPC,UPDINV,CREATEBY,CREATEON,CREDSTAT,RTRNRSN,CRED1,X1,X2,X3
        K DIRUT,^TMP("PSARDCRD1",$J),^TMP("PSARDCRD",$J),FIRSTHD,PSAEXCEL
        Q
        ;
GETDATA ;  Retrieve data for printing
        N PSABATCH S PSABATCH="",PSAPHLC1=$P(PSAPHLOC,"^")
        F  S PSABATCH=$O(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH)) Q:PSABATCH=""  D  Q:PSAOUT
        . Q:'$D(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH))
        . I $$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,1,"I")'=PSARDST  Q
        . I PSARDST'="CA",$P($$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,$S(PSARDST="AP":3,PSARDST="CO":9,PSARDST="PU":2,1:3),"I"),".")<PSARDRBD Q
        . I PSARDST'="CA",$P($$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,$S(PSARDST="AP":3,PSARDST="CO":9,PSARDST="PU":2,1:3),"I"),".")>PSARDRED Q
        . I PSARDST="CA",$P($P(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN"),"^"),".")<PSARDRBD Q
        . I PSARDST="CA",$P($P(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN"),"^"),".")>PSARDRED Q
        . S PSABTCH=$$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,.01)
        . S PSARDCMF=$$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,4)
        . D ITEMS Q:PSAOUT
        . I $G(PSAEXCEL)=0,$D(^TMP("PSARDCRD1",$J)) D HDR Q:PSAOUT  D PRINT
        . I $G(PSAEXCEL)=1,$D(^TMP("PSARDCRD1",$J)) D HDR2,PRINT2 Q:PSAOUT
        Q
        ;
ITEMS   ; Retrieve individual drug entries that match the criteria for the report.
        I $G(PSAPHLC1)=""!($G(PSABATCH)="") Q
        N I,J,DRUGNAM,X,XX S (DRUGNAM,I,J,X,XX)="",$P(X," ",80)=" ",$P(XX,"-",80)="-"
        F  S I=$O(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"ITM",I)) Q:I=""  D
        . S DRUGNAM=$$GET1^DIQ(58.3511,I_","_PSABATCH_","_PSAPHLC1,.01) I DRUGNAM="" Q
        . S ^TMP("PSARDCRD",$J,DRUGNAM,I)=""
        S DRUGNAM="",(SEQ,ITEM,CREDTOT,CRDTOTCO)=0
        F  S DRUGNAM=$O(^TMP("PSARDCRD",$J,DRUGNAM)) Q:DRUGNAM=""  D
        . F  S ITEM=$O(^TMP("PSARDCRD",$J,DRUGNAM,ITEM)) Q:ITEM=""  D
        . . S SEQ=SEQ+1
        . . D GETS^DIQ(58.3511,ITEM_","_PSABATCH_","_PSAPHLC1_",","*","IE","FLDS")
        . . M DATA=FLDS(58.3511,ITEM_","_PSABATCH_","_PSAPHLC1_",")
        . . S DRUG=$E(DATA(.01,"E"),1,25),NDC=DATA(3,"E"),QTY=DATA(6,"E"),RTNQTY=DATA(17,"E")
        . . S MFR=DATA(2,"E"),EXPDAT=$$FMTE^XLFDT(DATA(9,"I"),"2Z")
        . . S ORDUNT=DATA(5,"I") I ORDUNT'="" S ORDUNT=$$GET1^DIQ(51.5,ORDUNT,.02,"I")
        . . S UPC=DATA(4,"E"),CREATEBY=$E(DATA(16,"E"),1,21),CREATEON=$$FMTE^XLFDT($P(DATA(1,"I"),"."),"2Z")
        . . S UPDINV=DATA(14,"E") I UPDINV="" S UPDINV="NO"
        . . S RTRNRSN=$E(DATA(15,"E"),1,21)
        . . S DISPUNT=$E(DATA(8,"E"),1,15)
        . . S CREDSTAT=DATA(10,"E") I CREDSTAT="" S CREDSTAT="**N/A**"
        . . S CRED=$TR($S(CREDSTAT="ACTUAL":DATA(12,"I"),PSARDST="CO":DATA(12,"I"),PSARDST="PU":DATA(11,"I"),1:""),",")
        . . I $G(PSAEXCEL)=0 D
        . . . S $E(LINE1,1)=$J("Drug: ",15)_DRUG,$E(LINE1,45)=$J("Credit Status: ",15)_CREDSTAT
        . . . S $E(LINE2,1)=$J("Manufacturer: ",15)_MFR,$E(LINE2,45)=$J("Credit Amount: "_$S(CRED="":"",1:"$"),15)_$S(CRED="":"",1:$J(CRED,0,2))_$S(CRED="":"",CREDSTAT="ACTUAL":" (ACTUAL)",PSARDST="CO":" (ACTUAL)",PSARDST="PU":" (ESTIMATED)",1:"")
        . . . S $E(LINE3,1)=$J("NDC: ",15)_NDC,$E(LINE3,45)=$J("Exp. Date: ",15)_EXPDAT
        . . . S $E(LINE4,1)=$J("Rtrn Ord Qty: ",15)_QTY_" "_ORDUNT,$E(LINE4,45)=$J("Created By: ",15)_CREATEBY
        . . . S $E(LINE5,1)=$J("Rtrn Disp Qty: ",15)_RTNQTY_" "_DISPUNT,$E(LINE5,45)=$J("Created On: ",15)_CREATEON
        . . . S $E(LINE6,1)=$J("UPC: ",15)_UPC,$E(LINE6,45)=$J("Upd Inventory: ",15)_UPDINV
        . . . S $E(LINE7,1)=$J("Return Rsn: ",15)_RTRNRSN
        . . . S $E(LINE8,1)=XX
        . . . S LINE(PSARDST,SEQ,1)=LINE1
        . . . S LINE(PSARDST,SEQ,2)=LINE2
        . . . S LINE(PSARDST,SEQ,3)=LINE3
        . . . S LINE(PSARDST,SEQ,4)=LINE4
        . . . S LINE(PSARDST,SEQ,5)=LINE5
        . . . S LINE(PSARDST,SEQ,6)=LINE6
        . . . S LINE(PSARDST,SEQ,7)=LINE7
        . . . S LINE(PSARDST,SEQ,8)=LINE8
        . . . I PSARDST="CO" S CRDTOTCO=CRDTOTCO+$G(CRED)
        . . . I PSARDST="PU" S CREDTOT=CREDTOT+$G(CRED)
        . . I $G(PSAEXCEL)=1 D
        . . . I PSARDST'="CA" S EXPDAT1=$$FMTE^XLFDT($P($$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,$S(PSARDST="PU":2,PSARDST="CO":9,1:3),"I"),"."),"2Z")
        . . . I PSARDST="CA" S EXPDAT1=$$FMTE^XLFDT($P($P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^"),"."),"2Z")
        . . . S CREATEON=$$FMTE^XLFDT(DATA(1,"I"),"2ZP")
        . . . S LINE(SEQ)=$P(PSAPHLOC,"^",2)_"^"_PSABTCH_"^"_PSABASTS(PSARDST)_"^"_EXPDAT1_"^"_PSARDCMF_"^"_DRUG_"^"_NDC_"^"_QTY_" "_ORDUNT_"^"_RTNQTY_" "_DISPUNT_"^"_UPDINV_"^"_$S(CRED="":"",1:$J(CRED,0,2))_"^"
        . . . S LINE(SEQ)=LINE(SEQ)_MFR_"^"_UPC_"^"_RTRNRSN_"^"_CREDSTAT_"^"_$S(DATA(11,"I")="":"",1:$J(DATA(11,"I"),0,2))_"^"_EXPDAT_"^"_CREATEBY_"^"_CREATEON
        . . . I PSARDST="CA" S LINE(SEQ)=LINE(SEQ)_"^"_$E($P($G(^VA(200,+$P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^",2),0)),"^"),1,18)_"^"_$E($P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^",3),1,25)
        . . M ^TMP("PSARDCRD1",$J)=LINE
        . . K LINE,LINE1,LINE2,LINE3,LINE4,LINE5,LINE6,LINE7,LINE8,DATA
        K LINE,DATA,FLDS,^TMP("PSARDCRD",$J),LINE1,SEQ,DRUGNAM,ITEM,DRUG,NDC,QTY,DSPUNT,EXPDAT,ORDUNT,UPDINV,EXPDAT1,RTNQTY,DISPUNT
        Q
        ;
PRINT   ; Print the individual drug entries that match the criteria for the report.
        Q:PSAOUT
        N X1,X2,X3
        S X1="",(X2,X3)=0
        F  S X1=$O(^TMP("PSARDCRD1",$J,X1)) Q:X1=""  D  Q:PSAOUT
        . F  S X2=$O(^TMP("PSARDCRD1",$J,X1,X2)) Q:X2=""  D  Q:PSAOUT
        . . I $Y>(IOSL-9) D HDR Q:PSAOUT
        . . F  S X3=$O(^TMP("PSARDCRD1",$J,X1,X2,X3)) Q:X3=""  D  Q:PSAOUT
        . . . W !,^TMP("PSARDCRD1",$J,X1,X2,X3)
        . . . K ^TMP("PSARDCRD1",$J,X1,X2,X3)
        S PRINTFLG=1
        W !
        Q
HDR2    ;
        I $G(FIRSTHD)=1 D  S FIRSTHD=0
        . W "PHARM LOC^BATCH #^BATCH STAT^DATE COMPLETED/CANCELLED/PICKED UP^RETURN CONTRACTOR^"
        . W "DRUG^NDC^RTRN ORD QTY^RTRN DISP QTY^UPD INVENTORY^ACTUAL CRED^DRUG MFR^DRUG UPC^RTRN RSN^"
        . W "CRED STAT^ESTD CRED^DRUG EXPIRE DATE^CREATED BY^CREATED ON^CANCELELD BY^CANCELLED CMTS"
        Q
PRINT2  ; Spreadsheet format
        Q:PSAOUT
        N X1
        S X1=""
        F  S X1=$O(^TMP("PSARDCRD1",$J,X1)) Q:X1=""  D  Q:PSAOUT
        . W !,^TMP("PSARDCRD1",$J,X1)
        . K ^TMP("PSARDCRD1",$J,X1)
        Q
