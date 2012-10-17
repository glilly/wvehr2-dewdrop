SPNJRPP1        ;BP/JAS - Returns Prosthetic Utilization info ;May 15, 2008
        ;;3.0;Spinal Cord Dysfunction;;OCT 01, 2006;Build 39
        ;
        ; References to ^RMPR(660 supported by IA# 4975
        ; Reference to file 4 supported by IA# 10090
        ; Reference to API DEM^VADPT supported by IA# 10061
        ; Reference to API PSASHCPC^RMPOPF supported by IA# 4975
        ; API $$FLIP^SPNRPCIC is part of Spinal Cord Version 3.0
        ;
        ; Parm values:
        ;     RETURN  is the sorted data from the earliest date of listing
        ;     ICNLST  is the list of patient ICNs to process
        ;     FDATE   is the delivery starting date
        ;     TDATE   is the delivery ending date
        ;
        ; Returns: ^TMP($J)
        ;
COL(RETURN,ICNLST,FDATE,TDATE)  ;
        ;
        ;***************************
        S RETURN=$NA(^TMP($J)),RETCNT=1
        S X=FDATE S %DT="T" D ^%DT S SPNSTRT=Y
        S X=TDATE S %DT="T" D ^%DT S SPNEND=Y_.2359
        ;***************************
        K ^TMP($J),^TMP("SPN",$J),CARRY
        F ICNNM=1:1:$L(ICNLST,"^") S ICN=$P(ICNLST,"^",ICNNM) D IN
        D OUT,CLNUP
        Q
IN      Q:$G(ICN)=""
        S DFN=$$FLIP^SPNRPCIC(ICN)
        Q:$G(DFN)=""
        ;***************************
        Q:'$D(^RMPR(660,"C",DFN))
        S ^TMP("SPN",$J,"1ST",DFN)=0
        ;JAS - 05/15/08 - DEFECT 1090
        ;S PDA=""
        S PDA=0
        F  S PDA=$O(^RMPR(660,"C",DFN,PDA)) Q:PDA=""  D
        . Q:'$D(^RMPR(660,PDA,0))
        . S DEDAT=$P($G(^RMPR(660,PDA,0)),"^",12)
        . Q:DEDAT=""
        . Q:DEDAT<SPNSTRT!(DEDAT>SPNEND)
        . S STAT=$P(^RMPR(660,PDA,0),"^",10)
        . S STAT=$$GET1^DIQ(4,STAT_",",.01)
        . S RMPRHCDT=$P(^RMPR(660,PDA,0),"^",1)
        . Q:'$D(^RMPR(660,PDA,1))
        . S RMPRHCPC=$P(^RMPR(660,PDA,1),"^",4)
        . Q:RMPRHCPC=""
        . D PSASHCPC^RMPOPF
        . Q:RMPREHC=""
        . S ITEM=RMPREHC
        . S IDESC=RMPRTHC
        . D DEM^VADPT
        . S IQTY=$P(^RMPR(660,PDA,0),"^",7)
        . S ITYP=$P(^RMPR(660,PDA,0),"^",4)
        . S ITYP=$S(ITYP="I":"INITIAL ISSUE",ITYP="X":"REPAIR",ITYP="S":"SPARE",ITYP="R":"REPLACE",ITYP=5:"RENTAL",1:"")
        . S ICOST=$P(^RMPR(660,PDA,0),"^",16)
        . S IHCP=IDESC
        . S DEDAT=$$FMTE^XLFDT(DEDAT,"5DZP")
        . S ^TMP("SPN",$J,"3RD",STAT,VADM(1),ITEM,IHCP,PDA)=STAT_"^"_VADM(1)_"^"_VA("PID")_"^"_ITEM_"^"_IHCP_"^"_IQTY_"^"_ICOST_"^"_ITYP_"^"_DEDAT
        . S ^TMP("SPN",$J,"1ST",DFN)=^TMP("SPN",$J,"1ST",DFN)+IQTY
        . I $D(^TMP("SPN",$J,"2ND-A",ITEM,IHCP)) D
        . . S TQTY=$P(^TMP("SPN",$J,"2ND-A",ITEM,IHCP),"^",1)
        . . S TQTY=TQTY+IQTY
        . . S TCOST=$P(^TMP("SPN",$J,"2ND-A",ITEM,IHCP),"^",2)
        . . S TCOST=TCOST+ICOST
        . . Q
        . E  S TQTY=IQTY,TCOST=ICOST
        . S ^TMP("SPN",$J,"2ND-A",ITEM,IHCP)=TQTY_"^"_TCOST
        . S ^TMP("SPN",$J,"2ND-B",ITEM,IHCP,DFN)=""
        . Q
        Q
OUT     ;
        S ^TMP($J,RETCNT)="HDR999^PATIENTS^ITEMS^EOL999"
        S RETCNT=RETCNT+1
        S DFN=""
        F  S DFN=$O(^TMP("SPN",$J,"1ST",DFN)) Q:DFN=""  D
        . S TQTY=^TMP("SPN",$J,"1ST",DFN)
        . I $D(CARRY(TQTY)) S CARRY(TQTY)=CARRY(TQTY)+1
        . E  S CARRY(TQTY)=1
        S TQTY=""
        F  S TQTY=$O(CARRY(TQTY),-1) Q:TQTY=""  D
        . S ^TMP($J,RETCNT)=CARRY(TQTY)_"^"_TQTY_"^EOL999"
        . S RETCNT=RETCNT+1
        ;;;
        S ^TMP($J,RETCNT)="HDR999^PSAS HCPC^BRIEF DESCRIPTION^QUANTITY^TOTAL COSTS^PATIENTS^EOL999"
        S RETCNT=RETCNT+1
        S PINUM=""
        F  S PINUM=$O(^TMP("SPN",$J,"2ND-A",PINUM)) Q:PINUM=""  D
        . S ITEM=""
        . F  S ITEM=$O(^TMP("SPN",$J,"2ND-A",PINUM,ITEM)) Q:ITEM=""  D
        . . S TQTY=$P(^TMP("SPN",$J,"2ND-A",PINUM,ITEM),"^",1)
        . . S TCOST=$P(^TMP("SPN",$J,"2ND-A",PINUM,ITEM),"^",2)
        . . I $D(^TMP("SPN",$J,"2ND-B",PINUM,ITEM)) D
        . . . S DFN="",PACNT=0
        . . . F  S DFN=$O(^TMP("SPN",$J,"2ND-B",PINUM,ITEM,DFN)) Q:DFN=""  D
        . . . . S PACNT=PACNT+1
        . . S ^TMP($J,RETCNT)=PINUM_"^"_ITEM_"^"_TQTY_"^"_TCOST_"^"_PACNT_"^EOL999"
        . . S RETCNT=RETCNT+1
        ;;;
        S ^TMP($J,RETCNT)="HDR999^STATION^NAME^SSN^PSAS HCPC^BRIEF DESCRIPTION^QUANTITY^TOTAL COST^TRANSACTION TYPE^DATE DELIVERED^EOL999"
        S RETCNT=RETCNT+1
        S STAT=""
        F  S STAT=$O(^TMP("SPN",$J,"3RD",STAT)) Q:STAT=""  D
        . S NAM="",PATCNT=0,TQTY=0,TCOST=0
        . F  S NAM=$O(^TMP("SPN",$J,"3RD",STAT,NAM)) Q:NAM=""  D
        . . S PINUM="",PATCNT=PATCNT+1
        . . F  S PINUM=$O(^TMP("SPN",$J,"3RD",STAT,NAM,PINUM)) Q:PINUM=""  D
        . . . S ITEM=""
        . . . F  S ITEM=$O(^TMP("SPN",$J,"3RD",STAT,NAM,PINUM,ITEM)) Q:ITEM=""  D
        . . . . S PDA=""
        . . . . F  S PDA=$O(^TMP("SPN",$J,"3RD",STAT,NAM,PINUM,ITEM,PDA)) Q:PDA=""  D
        . . . . . S ^TMP($J,RETCNT)=^TMP("SPN",$J,"3RD",STAT,NAM,PINUM,ITEM,PDA)_"^EOL999"
        . . . . . S RETCNT=RETCNT+1
        K ^TMP("SPN",$J)
        Q
CLNUP   ;
        K %DT,DEDAT,DFN,HCPREF,ICN,ICNNM,ICOST,IDESC,IHCP,IQTY,IREC0,IREC2
        K ITDA,ITEM,ITYP,NAM,PACNT,PATCNT,PDA,PINUM,RETCNT,SPNEND
        K SPNSTRT,STAT,TCOST,TQTY,VA,VADM,X,Y,RMPRHCDT,RMPRHCPC,RMPREHC,RMPRTHC
        Q
