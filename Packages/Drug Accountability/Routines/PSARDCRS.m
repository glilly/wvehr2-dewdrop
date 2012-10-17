PSARDCRS        ;BIRM/JMC - Return Drug Credit Report - Summary ;06/04/08
        ;;3.0;DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**69**;10/24/97;Build 9
        ;References to ORDER UNIT file (#51.5) supported by IA #1931
        ;
        N PSARDST,PSAOUT,PRINTFLG
        K PAG,^TMP("PSARDCRS",$J),^TMP("PSARDCRS1",$J)
        S PSAOUT=0 I $G(PSAEXCEL)=1 S FIRSTHD=1
        D STATUS I '$D(PSABASTS) G EXIT
        S PSARDST="" F  S PSARDST=$O(PSABASTS(PSARDST)) Q:PSARDST=""  D  Q:PSAOUT
        . S PSAPHLC1=$P($G(PSAPHLOC),"^",2)
        . U IO
        . I $G(PSAEXCEL)=0 D
        . . D HDR Q:PSAOUT
        . . D GETDATA
        . . W:'$G(PRINTFLG) !!,"*** NO BATCHES FOUND ***",!!! S PRINTFLG=0
        . I $G(PSAEXCEL)=1 D GETDATA Q:PSAOUT
        D EXIT
        Q
HDR     ; - Prints the Header
        N X,SS,DIR,JJ
        S PAG=$G(PAG)+1
        ;I PAG>1,'$G(PRINTFLG) D
        ;. W !!,"*** NO BATCHES FOUND ***",!!!
        I PAG>1,$E(IOST)="C" D  I PSAOUT Q
        . S SS=22-$Y F JJ=1:1:SS W !
        . N DIR S DIR(0)="E",DIR("A")=" Press ENTER to Continue or ^ to Exit"
        . D ^DIR
        . S PSAOUT=$S($D(DIRUT):1,Y:0,1:1)
        W @IOF,"Return Drug Credit Report (SUMMARY)",?71,"Page: ",$J(PAG,3)
        W !,"PHARM LOCATION: ",$E($P(PSAPHLOC,"^",2),1,31),?$S(PSARDST="AP":57,1:63),"STATUS: ",$G(PSABASTS(PSARDST))
        W !,"Date Range: "_$$FMTE^XLFDT(PSARDRBD,"2Z")_" THRU "_$$FMTE^XLFDT(PSARDRED,"2Z")
        W ?53,"Run Date: "_$$FMTE^XLFDT($$NOW^XLFDT(),"2Z")
        S X="",$P(X,"-",80)="-" W !,X
        W !,?39,$J("ORD",6),?46,"ORDER",?54,$J("DISP",6),?61,"DISP",?68,"UPD"
        I PSARDST="PU"!(PSARDST="CO") W ?73,"ACTUAL"
        W !,"DRUG (NDC)",?39,$J("QTY",6),?46,"UNIT",?54,$J("QTY",6),?61,"UNIT",?68,"INV"
        I PSARDST="PU"!(PSARDST="CO") W ?73,"CREDIT$"
        W !,X
        S PRINTFLG=0
        Q
STATUS  ;Create local array of statuses.
        F I=1:1:$L(PSABASTS,",") D
        . S PSARDST=$P(PSABASTS,",",I)
        . S PSABASTS(PSARDST)=$S(PSARDST="AP":"AWAITING PICKUP",PSARDST="PU":"PICKED UP",PSARDST="CA":"CANCELLED",1:"COMPLETED")
        Q
EXIT    ; KILL VARIABLES AND EXIT
        D ^%ZISC
        K PSABASTS,CREDTOT,CREDTOT1,DRUGTOT,DRUGTOT1,CRDTOTCO,PSARDST,PSABATCH,PSAPHLOC,EXPDAT,XX,Y,X,TMPBAT,TMPBAT1,TOT
        K BATTOT,PSARDRBD,PSARDRED,PSARDCMF,CRED,I,DIR,X,PAG,PSADTRNG,PSARDRTP,PSAPHLC1
        K PSABTCH,PSASCRL,CRDTOTC1,DIRUT,^TMP("PSARDCRS1",$J),^TMP("PSARDCRS",$J),FIRST,FIRSTHD,PSAEXCEL
        Q
GETDATA ;  Retrieve data for printing
        N PSABATCH S PSABATCH=0,PSAPHLC1=$P(PSAPHLOC,"^"),(BATTOT,CREDTOT1,DRUGTOT1,CRDTOTC1)=0
        F  S PSABATCH=$O(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH)) Q:'PSABATCH  D  Q:PSAOUT
        . Q:'$D(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH))
        . I $$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,1,"I")'=PSARDST  Q
        . I PSARDST'="CA",$P($$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,$S(PSARDST="AP":3,PSARDST="CO":9,PSARDST="PU":2,1:3),"I"),".")<PSARDRBD Q
        . I PSARDST'="CA",$P($$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,$S(PSARDST="AP":3,PSARDST="CO":9,PSARDST="PU":2,1:3),"I"),".")>PSARDRED Q
        . I PSARDST="CA",$P($P(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN"),"^"),".")<PSARDRBD Q
        . I PSARDST="CA",$P($P(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN"),"^"),".")>PSARDRED Q
        . S PSARDCMF=$$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,4)
        . S BATTOT=BATTOT+1
        . D ITEMS I PSAOUT Q
        . ;I '$G(PSAEXCEL),$D(^TMP("PSARDCRS1",$J)) D PRINT S PRINTFLG=1 Q:PSAOUT
        . I '$G(PSAEXCEL) D PRINT S PRINTFLG=1 Q:PSAOUT
        . I $G(PSAEXCEL)=1,$D(^TMP("PSARDCRS1",$J)) D PRINT2 Q:PSAOUT
        . I PSARDST="PU" S DRUGTOT1=DRUGTOT1+DRUGTOT,CREDTOT1=CREDTOT1+CREDTOT
        . I PSARDST="CO" S CRDTOTC1=CRDTOTC1+CRDTOTCO
        Q:PSAOUT
        Q:$G(PSAEXCEL)=1
        I PSARDST="PU",DRUGTOT1>0 W !,"TOTALS: "_$G(BATTOT)_" Batch"_$S($G(BATTOT)>1:"es",1:"")_", "_$G(DRUGTOT1)_" Drug"_$S($G(DRUGTOT1)>1:"s",1:"")
        I (PSARDST="PU"&($G(CREDTOT1)>0))!(PSARDST="CO"&(($G(CRDTOTC1))>0)) W !,"CREDIT TOTAL: $"_$S(PSARDST="CO":$J($G(CRDTOTC1),0,2),PSARDST="PU":$J($G(CREDTOT1),0,2),1:"")
        Q
        ;
ITEMS   ; Retrieve individual drug entries that match the criteria for the report.
        I $G(PSAPHLC1)=""!($G(PSABATCH)="") Q
        N DRUGNAM S (DRUGNAM,I)="",(I,DRUGTOT)=0
        F  S I=$O(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"ITM",I)) Q:'I  D
        . S DRUGNAM=$$GET1^DIQ(58.3511,I_","_PSABATCH_","_PSAPHLC1,.01) I DRUGNAM="" Q
        . S ^TMP("PSARDCRS",$J,DRUGNAM,I)=""
        S DRUGNAM="",(SEQ,ITEM,CREDTOT,CRDTOTCO)=0
        F  S DRUGNAM=$O(^TMP("PSARDCRS",$J,DRUGNAM)) Q:DRUGNAM=""  D
        . F  S ITEM=$O(^TMP("PSARDCRS",$J,DRUGNAM,ITEM)) Q:ITEM=""  D
        . . S SEQ=SEQ+1
        . . D GETS^DIQ(58.3511,ITEM_","_PSABATCH_","_PSAPHLC1_",","*","IE","FLDS")
        . . K DATA M DATA=FLDS(58.3511,ITEM_","_PSABATCH_","_PSAPHLC1_",")
        . . S DRUG=$E(DATA(.01,"E"),1,20),NDC=DATA(3,"E"),QTY=DATA(6,"E")
        . . S DISPUNT=$E(DATA(8,"E"),1,6)
        . . S ORDUNT=DATA(5,"I") I ORDUNT S ORDUNT=$E($$GET1^DIQ(51.5,ORDUNT,.02,"E"),1,6)
        . . S UPDINV=DATA(14,"E") I UPDINV="" S UPDINV="NO"
        . . S RTRNQTY=DATA(17,"E")
        . . S CRED=$TR($S(DATA(10,"E")="ACTUAL":DATA(12,"I"),PSARDST="CO":DATA(12,"I"),PSARDST="PU":DATA(11,"I"),1:""),",")
        . . S $E(LINE,1)=DRUG_" ("_NDC_")"
        . . S $E(LINE,39)=$J(QTY,7),$E(LINE,47)=ORDUNT,$E(LINE,54)=$J(RTRNQTY,7),$E(LINE,62)=DISPUNT
        . . S $E(LINE,69)=UPDINV,$E(LINE,73)=$S(PSARDST'="PU"&(PSARDST'="CO"):"",1:$J($J(+CRED,0,2),8))
        . . I $G(PSAEXCEL)=0 S LINE1(SEQ)=LINE
        . . I $G(PSAEXCEL)=1 D
        . . . I PSARDST'="CA" S EXPDAT=$$FMTE^XLFDT($P($$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,$S(PSARDST="PU":2,PSARDST="CO":9,1:3),"I"),"."),"2Z")
        . . . I PSARDST="CA" S EXPDAT=$$FMTE^XLFDT($P($P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^"),"."),"2Z")
        . . . S TMPBAT=$$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,.01)
        . . . S LINE1(SEQ)=$P(PSAPHLOC,"^",2)_"^"_TMPBAT_"^"_PSABASTS(PSARDST)_"^"_EXPDAT_"^"_PSARDCMF_"^"_DRUG_"^"_NDC_"^"_QTY_"^"_ORDUNT_"^"_RTRNQTY_"^"_DISPUNT_"^"_UPDINV_"^"_$J(+CRED,0,2)
        . . . I PSARDST="CA" S LINE1(SEQ)=LINE1(SEQ)_"^"_$E($P($G(^VA(200,+$P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^",2),0)),"^"),1,18)_"^"_$E($P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^",3),1,25)
        . . I PSARDST="CO" S CRDTOTCO=CRDTOTCO+$G(CRED)
        . . I PSARDST="PU" S CREDTOT=CREDTOT+$G(CRED),DRUGTOT=DRUGTOT+1
        . . K LINE
        . . M ^TMP("PSARDCRS1",$J)=LINE1
        . . S ^TMP("PSARDCRS1",$J,"A")=SEQ
        K LINE,DATA,FLDS,^TMP("PSARDCRS",$J),LINE1,SEQ,DRUGNAM,ITEM,DRUG,NDC,QTY,DISPUNT,EXPDAT,ORDUNT,UPDINV,TMPBAT,RTRNQTY
        Q
PRINT   ; Print the individual drug entries that match the criteria for the report.
        Q:PSAOUT
        N I,FIRST
        S TMPBAT1="",(I,PSASCRL)=0,FIRST=1,TMPBAT=$$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,.01),TOT=$G(^TMP("PSARDCRS1",$J,"A"))
        I PSARDST'="CA" S EXPDAT=$$FMTE^XLFDT($P($$GET1^DIQ(58.351,PSABATCH_","_PSAPHLC1,$S(PSARDST="PU":2,PSARDST="CO":9,1:3),"I"),"."),"2Z")
        I PSARDST="CA" S EXPDAT=$$FMTE^XLFDT($P($P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^"),"."),"2Z")
        I $Y>(IOSL-6) D HDR Q:PSAOUT
        D:'$D(^TMP("PSARDCRS1",$J)) PRTLINE("") ;,PRTFTR()
        F  S I=$O(^TMP("PSARDCRS1",$J,I)) Q:I=""  D  Q:PSAOUT
        . I $Y>(IOSL-6) D HDR Q:PSAOUT  I I<TOT!(I=TOT) S TMPBAT1=TMPBAT_" (Contd.)",PSASCRL=1
        . D PRTLINE(^TMP("PSARDCRS1",$J,I))
        . K ^TMP("PSARDCRS1",$J,I)
        ;W !
        Q:PSAOUT
        D PRTFTR()
        K TMPBAT,TMPBAT1,TOT
        Q
        ;
PRTFTR()        ; Print Footer
        I PSARDST="CO"!(PSARDST="PU") D
        . W !?72,"========"
        . W !?25,"NUMBER OF ITEMS: ",+$G(TOT),?56,"BATCH TOTAL: "
        . W ?72,$J($S(PSARDST="CO":"$"_$J($G(CRDTOTCO),0,2),1:"$"_$J($G(CREDTOT),0,2)),8)
        E  D
        . W !?25,"NUMBER OF ITEMS: ",+$G(TOT)
        W !
        Q
        ;
PRTLINE(LINE)   ; Prints an Item line
        I 'FIRST,PSASCRL D
        . W !,"Batch #: "_TMPBAT1
        . W "   "_$S(PSARDST="CA":"Date Cancelled: ",PSARDST="PU":"Date Picked Up: ",PSARDST="CO":"Date Completed: ",1:"Date Entered: ")_EXPDAT
        . W " - "_$E(PSARDCMF,1,22)
        . K TMPBAT1
        . S PSASCRL=0
        I FIRST D
        . W !,"Batch #: "_TMPBAT S (PSASCRL,FIRST)=0
        . W "     "_$S(PSARDST="CA":"Date Cancelled: ",PSARDST="PU":"Date Picked Up: ",PSARDST="CO":"Date Completed: ",1:"Date Entered: ")_EXPDAT
        . W " - "_$E(PSARDCMF,1,29)
        . I PSARDST="CA" W !,"Cancelled By: "_$E($P($G(^VA(200,+$P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^",2),0)),"^"),1,18)_"  "_"Cancelled Comments: "_$E($P($G(^PSD(58.35,PSAPHLC1,"BAT",PSABATCH,"CAN")),"^",3),1,25)
        I I'="A",LINE'="" W !,LINE
        Q
PRINT2  ; Spreadsheet format
        N I
        S I=""
        I $G(FIRSTHD)=1 D  S FIRSTHD=0
        . W "PHARM LOC^BATCH #^BATCH STATUS^DATE COMPLETED/CANCELLED/PICKED UP"
        . W "^RETURN CONTRACTOR^DRUG^NDC^ORD QTY^ORDER UNIT^DISP QTY^DISP UNIT^UPDATE INVENTORY^ACTUAL CREDIT^CANCELLED BY^CANCELLED CMTS"
        F  S I=$O(^TMP("PSARDCRS1",$J,I)) Q:I=""  D  Q:PSAOUT
        . I I'="A" W !,^TMP("PSARDCRS1",$J,I)
        . K ^TMP("PSARDCRS1",$J,I)
        Q
