PRCHLO6 ;WOIFO/AS-EXTRACT ROUTINE (cont.)CLO REPORT SERVER ;5/17/09  23:45
        ;;5.1;IFCAP;**130,140**;Oct 20, 2000;Build 4
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ; DBIA 10093 - Read file 49 via FileMan.
        ; Continuation of PRCHLO1. This program builds the extracts for
        ; the Master PO Table and the associated multiples
GET410  ; get file 410 record
        S U="^"
        N PRCND,PRCIEN,PRCDT,PRCTMP,PRCTMB,PRCTR,PRCFR,PRCDAT,PRCDATO,PRCDATA,D0,X
        N PRCDUZ
        ; loop through file 410
        S PRCIEN=0,PRCDT=""
        F  S PRCIEN=$O(^PRCS(410,PRCIEN)) Q:'PRCIEN  D
        . S PRCND=$G(^PRCS(410,PRCIEN,0))       ;NODE 0
        . S PRCTR=$P(PRCND,U,2)                       ;TRANSACTION TYPE
        . S PRCFR=$P(PRCND,U,4)                       ;FORM TYPE
        . S PRCDAT=$P($G(^PRCS(410,PRCIEN,1)),U,1)    ;DATE OF REQUEST
        . S PRCDATO=$P($G(^PRCS(410,PRCIEN,4)),U,4)   ;DATE OBLIGATED
        . S PRCDATA=$P($G(^PRCS(410,PRCIEN,4)),U,7)   ;DATE OBLIGATED ADJ
        . ;TRANS TYPE IS ADJUSTMENT, FORM TYPE IS NOT NULL NOT ISSUE BOOK
        . I PRCTR="A",PRCFR,PRCFR'=5,PRCDAT>CLOBGN,PRCDAT<CLOEND D DAT410 Q
        . ;TRANS TYPE IS ADJUSTMENT, FORM TYPE ISSUE BOOK
        . I PRCTR="A",PRCFR=5,PRCDATO>CLOBGN,PRCDATO<CLOEND D DAT410 Q
        . ;TRANS TYPE IS OBLIGATION, WITH ANY FORM TYPE
        . I PRCTR="O",PRCFR,PRCDAT>CLOBGN,PRCDAT<CLOEND D DAT410 Q
        . ;TRANS TYPE IS CEILING, WITHOUT FORM TYPE
        . I PRCTR="C",PRCDATO>CLOBGN,PRCDATO<CLOEND D DAT410 Q
        . ;TRANS TYPE IS ADJUSTMENT, WITHOUT FORM TYPE
        . I PRCTR="A",'PRCFR,PRCDATA>CLOBGN,PRCDATA<CLOEND D DAT410 Q
        . Q
        Q
DAT410  ;
        S PRCDT=$P(PRCND,U,1)_U               ;TRANSACTION NUMBER
        S PRCDT=PRCDT_PRCIEN_U       ;TRANSACTION IEN
        S PRCDT=PRCDT_$P(PRCND,U,5)_U               ;STATION NUMBER
        S PRCDT=PRCDT_MNTHYR_U               ;Month,Year of extract
        S PRCDT=PRCDT_$$GET1^DIQ(410,PRCIEN_",",1)_U      ;TRANSACTION TYPE
        S PRCDT=PRCDT_$S(PRCFR>0:$P($G(^PRCS(410.5,PRCFR,0)),U),1:"")_U   ;FORM TYPE
        S X=$P(PRCND,U,10),PRCDT=PRCDT_X_U_$S(X>0:$P($G(^PRC(411,X,0)),U),1:"")_U              ;SUBSTATION -internal and external
        S X=$P(PRCND,U,11),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U   ;RUNNING BAL QTR DATE
        S PRCDT=PRCDT_$$GET1^DIQ(410,PRCIEN_",",450)_U     ;RUNNING BAL STATUS
        S PRCND=$G(^PRCS(410,PRCIEN,1))       ;NODE 1
        S X=$P(PRCND,U,1),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U    ;DATE OF REQUEST
        S PRCDT=PRCDT_$P(PRCND,U,5)_U               ;CLASS OF REQUEST IEN
        S PRCTMP=$P($G(^PRCS(410.2,+$P(PRCND,U,5),0)),U)
        S PRCDT=PRCDT_PRCTMP_U                      ;CLASS OF REQUEST EXT
        S PRCND=$G(^PRCS(410,PRCIEN,2))       ;NODE 2
        S PRCDT=PRCDT_$P(PRCND,U,1)_U               ;VENDOR
        S PRCDT=PRCDT_$P(PRCND,U,2)_U               ;VENDOR ADDRESS1
        S PRCDT=PRCDT_$P(PRCND,U,3)_U               ;VENDOR ADDRESS2
        S PRCDT=PRCDT_$P(PRCND,U,4)_U               ;VENDOR ADDRESS3
        S PRCDT=PRCDT_$P(PRCND,U,5)_U               ;VENDOR ADDRESS4
        S PRCDT=PRCDT_$P(PRCND,U,6)_U               ;VENDOR CITY
        S X=$P(PRCND,U,7),PRCDT=PRCDT_$S(X>0:$$GET1^DIQ(5,X_",",1),1:"")_U   ;VENDOR STATE
        S PRCDT=PRCDT_$P(PRCND,U,8)_U               ;VENDOR ZIP CODE
        S PRCDT=PRCDT_$P(PRCND,U,9)_U               ;VENDOR CONTACT
        S PRCDT=PRCDT_$P(PRCND,U,10)_U              ;VENDOR PHONE NO.
        S PRCND=$G(^PRCS(410,PRCIEN,3))       ;NODE 3
        S PRCTMP=$P(PRCND,U,4)
        S PRCDT=PRCDT_PRCTMP_U,PRCTMP=+PRCTMP           ;VENDOR IEN
        S PRCTMB=$P($G(^PRC(440,PRCTMP,0)),U,1)     ;
        S PRCDT=PRCDT_PRCTMB_U                      ;VENDOR NAME
        S PRCTMB=$P($G(^PRC(440,PRCTMP,3)),U,4)     ;
        S PRCDT=PRCDT_PRCTMB_U                      ;VENDOR FMS CODE
        S PRCTMB=$P($G(^PRC(440,PRCTMP,3)),U,5)
        S PRCDT=PRCDT_PRCTMB_U                      ;VENDOR ALT-ADDR-IND
        S PRCTMB=$P($G(^PRC(440,PRCTMP,7)),U,12)
        S PRCDT=PRCDT_PRCTMB_U                      ;VENDOR D & B
        S PRCDT=PRCDT_$P(PRCND,U,10)_U              ;VENDOR CONTRACT NUMBER
        S PRCDT=PRCDT_$P(PRCND,U,1)_U               ;CONTROL POINT
        S PRCDT=PRCDT_$P(PRCND,U,3)_U               ;COST CENTER
        S PRCDT=PRCDT_$P(PRCND,U,6)_U               ;BOC1
        S PRCDT=PRCDT_$P(PRCND,U,7)_U               ;BOC1 $ AMOUNT
        S PRCDT=PRCDT_$P(PRCND,U,2)_U               ;ACCOUNTING DATA
        S PRCDT=PRCDT_$P(PRCND,U,12)_U              ;FCP/PRJ
        S X=$P(PRCND,U,11),PRCDT=PRCDT_$S(X>0:$E(X+17000000,1,4),1:"")_U    ;BBFY
        S PRCND=$G(^PRCS(410,PRCIEN,4))       ;NODE 4
        S PRCDT=PRCDT_$P(PRCND,U,1)_U               ;COMMITTED (EST.) COST
        S X=$P(PRCND,U,2),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U  ;DATE COMMITTED
        S PRCDT=PRCDT_$P(PRCND,U,3)_U               ;OBLIGATED ACTUAL COST
        S X=$P(PRCND,U,4),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U   ;DATE OBLIGATED
        S PRCDT=PRCDT_$P(PRCND,U,5)_U               ;PO / OBLIGATION NO
        S PRCDT=PRCDT_$P(PRCND,U,6)_U               ;ADJUSTMENT AMOUNT
        S X=$P(PRCND,U,7),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U   ;DATE OBL ADJUSTED
        S PRCDT=PRCDT_$P(PRCND,U,8)_U               ;TRANSACTION AMOUNT
        S PRCDUZ=$P(PRCND,U,9),PRCTMP=$P($G(^VA(200,+PRCDUZ,0)),U)
        S PRCDT=PRCDT_PRCDUZ_U                      ;OBLIGATED BY DUZ
        S PRCDT=PRCDT_PRCTMP_U                      ;OBLIGATED BY NAME
        S PRCDUZ=$P($G(^VA(200,+PRCDUZ,5)),U)
        S PRCTMP=$S(PRCDUZ="":"",1:$$GET1^DIQ(49,+PRCDUZ_",",.01))
        S PRCDT=PRCDT_PRCDUZ_U_PRCTMP_U             ;OBLIGATED SERVICE INT/EXT
        S X=$P(PRCND,U,13),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U ;OBL VAL CODE DATE/TIME
        S PRCND=$G(^PRCS(410,PRCIEN,7))       ;NODE 7
        S PRCDUZ=$P(PRCND,U,1),PRCTMP=$P($G(^VA(200,+PRCDUZ,0)),U)
        S PRCDT=PRCDT_PRCDUZ_U                      ;REQUESTOR DUZ
        S PRCDT=PRCDT_PRCTMP_U                      ;REQUESTOR NAME
        S PRCDUZ=$P($G(^VA(200,+PRCDUZ,5)),U)
        S PRCTMP=$S(PRCDUZ="":"",1:$$GET1^DIQ(49,+PRCDUZ_",",.01))
        S PRCDT=PRCDT_PRCDUZ_U_PRCTMP_U             ;REQUESTOR SERVICE INT/EXT
        S PRCDT=PRCDT_$P(PRCND,U,2)_U               ;REQUESTOR'S TITLE
        S PRCDUZ=$P(PRCND,U,3),PRCTMP=$P($G(^VA(200,+PRCDUZ,0)),U)
        S PRCDT=PRCDT_PRCDUZ_U                      ;APPROVING OFFICIAL DUZ
        S PRCDT=PRCDT_PRCTMP_U                      ;APPROVING OFFICIAL NAME
        S PRCDUZ=$P($G(^VA(200,+PRCDUZ,5)),U)
        S PRCTMP=$S(PRCDUZ="":"",1:$$GET1^DIQ(49,+PRCDUZ_",",.01))
        S PRCDT=PRCDT_PRCDUZ_U_PRCTMP_U             ;APPROVING OFFICIAL SERVICE INT/EXT
        S PRCDT=PRCDT_$P(PRCND,U,4)_U               ;APPROVING OFFICIAL TITLE
        S X=$P(PRCND,U,5),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U  ;DATE SIGNED (APPROVED)
        S X=$P(PRCND,U,7),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U   ;ES CODE DATE/TIME
        S ^TMP($J,"CONTRP",PRCIEN,1)=PRCDT,PRCDT=""
        S PRCTMB=8 D WORDFLD                  ;NODE 8
        S PRCDT=PRCDT_PRCTMP_U                      ;JUSTIFICATION
        S ^TMP($J,"CONTRP",PRCIEN,2)=PRCDT,PRCDT=""
        S PRCND=$G(^PRCS(410,PRCIEN,11))      ;NODE 11
        S PRCTMP=$P(PRCND,U) I PRCTMP'="" D
        . S PRCTMB=$P(PRCTMP,";",2),PRCTMP=$P(PRCTMP,";")
        . S PRCTMP=$P($G(@("^"_PRCTMB_+PRCTMP_",0)")),U)
        S PRCDT=PRCDT_PRCTMP_U                      ;SORT GROUP EXTERNAL
        S PRCND=$G(^PRCS(410,PRCIEN,10))      ;NODE 10
        S PRCTMP=$P(PRCND,U,3),PRCTMB=$P($G(^PRC(442,+PRCTMP,0)),U)
        S PRCDT=PRCDT_PRCTMP_U                      ;STATION NO - P.O.NO IEN
        S PRCDT=PRCDT_PRCTMB_U                      ;STATION NO - P.O.NO EXT
        S PRCDT=PRCDT_$$PODATE(PRCTMP)_U            ;PO DATE
        S D0=PRCIEN D STATUS^PRCSES
        S PRCDT=PRCDT_X_U                           ;STATUS
        S PRCTMB="CO" D WORDFLD               ;NODE CO
        S PRCDT=PRCDT_PRCTMP_U                      ;COMMENTS
        S ^TMP($J,"CONTRP",PRCIEN,3)=PRCDT,PRCDT=""
        S PRCTMB=13 D WORDFLD                 ;NODE 13
        S PRCDT=PRCDT_PRCTMP                        ;REASON FOR RETURN
        S ^TMP($J,"CONTRP",PRCIEN,4)=PRCDT
        D GET4104
        Q
GET4104 ; GET DATA FROM SUBFILE 410.04
        N PRCX S PRCX=$P(^PRCS(410,PRCIEN,0),U)_U_PRCIEN_U_$P(^(0),U,5)_U
        S X=$P($G(^PRCS(410,PRCIEN,10)),U,3),PRCX=PRCX_$S(X>0:X_U_$P($G(^PRC(442,X,0)),U),1:U)_U_$$PODATE(X)_U_MNTHYR_U
        N PRCTMI
        S PRCTMI=0 F  S PRCTMI=$O(^PRCS(410,PRCIEN,12,PRCTMI)) Q:'PRCTMI  D
        . S PRCDT=PRCX
        . S PRCND=$G(^PRCS(410,PRCIEN,12,PRCTMI,0))
        . S PRCDT=PRCDT_$P($G(^PRCS(410.4,+$P(PRCND,U,1),0)),U)_U  ;SUB-CONTROL POINT
        . S PRCDT=PRCDT_$P(PRCND,U,2)_U              ;AMOUNT
        . S PRCTMB=$$GET1^DIQ(410.04,PRCTMI_","_PRCIEN_",",2)
        . S PRCDT=PRCDT_PRCTMB                       ;SCP AMOUNT
        . S ^TMP($J,"SUBCP",PRCIEN,PRCTMI)=PRCDT
        Q
WORDFLD ; PROCESS WORD FIELD
        N PRCTMI,PRCTMJ,PRCTMQ
        S PRCTMI=$P($G(^PRCS(410,PRCIEN,PRCTMB,0)),U,3),PRCTMP="",PRCTMQ=0
        I PRCTMI D
        . F PRCTMI=1:1:PRCTMI D  Q:PRCTMQ
        .. S PRCTMJ=$G(^PRCS(410,PRCIEN,PRCTMB,PRCTMI,0))_" "
        .. I $F(PRCTMJ,"^") S PRCTMJ=$TR(PRCTMJ,"^","*")    ;CONVERT ^ TO *
        .. I $L(PRCTMJ)+$L(PRCTMP)>200 S PRCTMP=$E(PRCTMP_PRCTMJ,1,200) S PRCTMQ=1 Q  ; CANNOT ALLOW STRING 'PRCDT' TO EXCEED 256 BYTES, SO LIMITING WORD PROC FIELD TO 200 CHARS
        .. S PRCTMP=PRCTMP_PRCTMJ
        Q
        ;
GET424  ;
        S U="^"
        N PRCND,PRCIEN,PRCDT,PRCTMP,PRCTMB,PRCC,X
        ; loop through file 424, "C" Cross Reference
        S PRCC=0
        F  S PRCC=$O(^PRC(424,"C",PRCC)) Q:'PRCC  D
        . I $D(^TMP($J,"POMAST",PRCC)) D DAT424
        D GET4241
        Q
DAT424  ;
        N PRCPOID
        S PRCIEN=0
        F  S PRCIEN=$O(^PRC(424,"C",PRCC,PRCIEN)) Q:'PRCIEN  D
        . S PRCDT=""
        . S PRCND=$G(^PRC(424,PRCIEN,0))          ;NODE 0
        . S (PRCPOID,X,Y)=$P(PRCND,U,2),PRCDT=PRCDT_X_U       ;OBLIGATION INT
        . S X=$S(X>0:$P($G(^PRC(442,X,0)),U),1:""),PRCDT=PRCDT_X_U  ; OBL EXT
        . S PRCDT=PRCDT_$$PODATE(PRCPOID)_U           ;PO DATE
        . S PRCDT=PRCDT_MNTHYR_U                      ;Month,Year of extract
        . S PRCDT=PRCDT_$P(X,"-")_U                   ;STATION #
        . S PRCDT=PRCDT_$P(PRCND,U,1)_U               ;AUTHORIZATION #
        . S PRCDT=PRCDT_$$GET1^DIQ(424,PRCIEN_",",.03)_U     ;TRANSACTION TYPE
        . S PRCDT=PRCDT_$P(PRCND,U,4)_U               ;LIQUIDATION AMOUNT
        . S PRCDT=PRCDT_$P(PRCND,U,5)_U               ;AUTHORIZATION BALANCE
        . S PRCDT=PRCDT_$P(PRCND,U,6)_U               ;OBLIGATION AMOUNT
        . S X=$P(PRCND,U,7),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U  ;DATE/TIME
        . S PRCDUZ=$P(PRCND,U,8),PRCTMP=$P($G(^VA(200,+PRCDUZ,0)),U)
        . S PRCDT=PRCDT_PRCDUZ_U                      ;USER DUZ
        . S PRCDT=PRCDT_PRCTMP_U                      ;USER NAME
        . S PRCDUZ=$P($G(^VA(200,+PRCDUZ,5)),U)
        . S PRCTMP=$S(PRCDUZ="":"",1:$$GET1^DIQ(49,+PRCDUZ_",",.01))
        . S PRCDT=PRCDT_PRCDUZ_U_PRCTMP_U             ;USER SERVICE INT/EXT
        . S PRCDT=PRCDT_$$GET1^DIQ(424,PRCIEN_",",.09)_U    ;COMPLETED FLAG
        . S PRCDT=PRCDT_$P(PRCND,U,10)_U              ;REFERENCE
        . S PRCDT=PRCDT_$P(PRCND,U,11)_U              ;LAST SEQUENCE USED
        . S PRCDT=PRCDT_$P(PRCND,U,12)_U              ;AUTHORIZATION AMOUNT
        . S PRCDT=PRCDT_$P(PRCND,U,13)_U              ;ORIGINAL AUTH. AMOUNT
        . S PRCDUZ=$P(PRCND,U,14),PRCTMP=$P($G(^VA(200,+PRCDUZ,0)),U)
        . S PRCDT=PRCDT_PRCDUZ_U                      ;LAST EDITED BY DUZ
        . S PRCDT=PRCDT_PRCTMP_U                      ;LAST EDITED BY NAME
        . S PRCDUZ=$P($G(^VA(200,+PRCDUZ,5)),U)
        . S PRCTMP=$S(PRCDUZ="":"",1:$$GET1^DIQ(49,+PRCDUZ_",",.01))
        . S PRCDT=PRCDT_PRCDUZ_U_PRCTMP_U             ;LAST EDITED BY SERVICE INT/EXT
        . S PRCTMP=$P(PRCND,U,15),PRCTMP=$P($G(^PRCS(410,+PRCTMP,0)),U)
        . S PRCDT=PRCDT_$P(PRCND,U,15)_U              ;CPA POINTER IEN
        . S PRCDT=PRCDT_PRCTMP_U                      ;CPA POINTER EXT
        . S PRCND=$G(^PRC(424,PRCIEN,1))       ;NODE 1
        . S PRCDT=PRCDT_$P(PRCND,U,1)_U               ;COMMENTS
        . S PRCND=$G(^PRC(424,PRCIEN,2))       ;NODE 2
        . S PRCDT=PRCDT_$P(PRCND,U,2)                 ;INTERFACE ID
        . S ^TMP($J,"DR1358",PRCIEN,1)=PRCDT
        Q
GET4241 ;
        ; loop through file 424.1
        S PRCC=0
        F  S PRCC=$O(^PRC(424.1,"C",PRCC)) Q:'PRCC  D
        . I $D(^TMP($J,"DR1358",PRCC)) D DAT4241
        Q
DAT4241 ;
        N Y,PRCSTN
        S PRCIEN=0 F  S PRCIEN=$O(^PRC(424.1,"C",PRCC,PRCIEN)) Q:'PRCIEN  D
        . S PRCDT=""
        . S PRCND=$G(^PRC(424.1,PRCIEN,0))       ;NODE 0
        . S X=$P(PRCND,U,2)
        . S (X,PRCPOID)=$P($G(^PRC(424,+X,0)),U,2),PRCDT=PRCDT_X_U  ;PO# INT
        . S X=$S(X>0:$P($G(^PRC(442,X,0)),U),1:""),PRCDT=PRCDT_X_U  ;PO# EXT
        . S PRCSTN=$P(X,"-") S:PRCPOID="" PRCPOID=PRCIEN
        . S PRCDT=PRCDT_$$PODATE(PRCPOID)_U           ;PO DATE
        . S PRCDT=PRCDT_MNTHYR_U                      ;Month,Year of extract
        . S PRCDT=PRCDT_PRCSTN_U                      ;STATION
        . S PRCDT=PRCDT_$P(PRCND,U,1)_U               ;BILL NUMBER
        . S PRCDT=PRCDT_$$GET1^DIQ(424.1,PRCIEN_",",.011)_U    ;RECORD TYPE
        . S PRCTMP=$P(PRCND,U,2),PRCTMP=$P($G(^PRC(424,+PRCTMP,0)),U)
        . S PRCDT=PRCDT_$P(PRCND,U,2)_U               ;AUTH. POINTER IEN
        . S PRCDT=PRCDT_PRCTMP_U                      ;AUTH. POINTER EXT
        . S PRCDT=PRCDT_$P(PRCND,U,3)_U               ;AUTH. AMOUNT
        . S X=$P(PRCND,U,4),PRCDT=PRCDT_$S(X>0:$$FMTE^XLFDT($P(X,".")),1:"")_U  ;DATE/TIME
        . S PRCDUZ=$P(PRCND,U,5),PRCTMP=$P($G(^VA(200,+PRCDUZ,0)),U)
        . S PRCDT=PRCDT_PRCDUZ_U                      ;USER DUZ
        . S PRCDT=PRCDT_PRCTMP_U                      ;USER NAME
        . S PRCDUZ=$P($G(^VA(200,+PRCDUZ,5)),U)
        . S PRCTMP=$S(PRCDUZ="":"",1:$$GET1^DIQ(49,+PRCDUZ_",",.01))
        . S PRCDT=PRCDT_PRCDUZ_U_PRCTMP_U             ;USER SERVICE INT/EXT
        . S PRCDT=PRCDT_$P(PRCND,U,6)_U               ;VENDOR INVOICE NUMBER
        . S PRCDT=PRCDT_$$GET1^DIQ(424.1,PRCIEN_",",.07)_U        ;FINAL BILL
        . S PRCDT=PRCDT_$P(PRCND,U,8)_U               ;REFERENCE
        . S PRCDUZ=$P(PRCND,U,10),PRCTMP=$P($G(^VA(200,+PRCDUZ,0)),U)
        . S PRCDT=PRCDT_PRCDUZ_U                      ;LAST EDITED BY DUZ
        . S PRCDT=PRCDT_PRCTMP_U                      ;LAST EDITED BY NAME
        . S PRCDUZ=$P($G(^VA(200,+PRCDUZ,5)),U)
        . S PRCTMP=$S(PRCDUZ="":"",1:$$GET1^DIQ(49,+PRCDUZ_",",.01))
        . S PRCDT=PRCDT_PRCDUZ_U_PRCTMP_U             ;LAST EDITED BY SERVICE INT/EXT
        . S PRCND=$G(^PRC(424.1,PRCIEN,1))            ;NODE 1
        . S PRCDT=PRCDT_$P(PRCND,U,1)                 ;DESCRIPTION
        . S ^TMP($J,"AD1358",PRCIEN,1)=PRCDT
        Q
PODATE(PRCPOIEN)        ;input PO's ien, output external form PO Date
        N X
        S X=$S(PRCPOIEN>0:$P($G(^PRC(442,PRCPOIEN,1)),U,15),1:"")
        S:X'="" X=$$FMTE^XLFDT(X,"D")
        Q X
