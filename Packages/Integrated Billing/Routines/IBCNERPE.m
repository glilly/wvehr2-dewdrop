IBCNERPE        ;DAOU/BHS - IBCNE eIV RESPONSE REPORT (cont'd);03-JUN-2002
        ;;2.0;INTEGRATED BILLING;**271,300,416**;21-MAR-94;Build 58
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; Must call at tag
        Q
        ;
        ; This tag is only called from IBCNERP2
        ;
GETDATA(IEN,RPTDATA)    ; Retrieve response data
        ; Init
        N %,CNCT,CNPTR,DIW,DIWI,DIWT,DIWTC,DIWX,DN,ERRTEXT,FUTDT,IBERR,II,PC,TQIEN
        ;
        ; Insured Info from eIV Response #365
        S RPTDATA(0)=$G(^IBCN(365,IEN,0)),TQIEN=$P(RPTDATA(0),U,5)
        ; Trans dates to ext format
        S $P(RPTDATA(0),U,7)=$$FMTE^XLFDT($P(RPTDATA(0),U,7)\1,"5Z")
        S RPTDATA(1)=$G(^IBCN(365,IEN,1))
        ; Trans ext values for SET of CODES values
        S $P(RPTDATA(1),U,8)=$$GET1^DIQ(365,IEN_",",1.08,"E")   ; Whose Ins
        S $P(RPTDATA(1),U,9)=$$GET1^DIQ(365,IEN_",",1.09,"E")   ; Pt Rel to Sub
        S $P(RPTDATA(1),U,13)=$$GET1^DIQ(365,IEN_",",1.13,"E")  ; COB
        ; Trans err actions/codes to ext
        S $P(RPTDATA(1),U,14)=$$X12^IBCNERP2(365.017,$P(RPTDATA(1),U,14))
        S $P(RPTDATA(1),U,15)=$$X12^IBCNERP2(365.018,$P(RPTDATA(1),U,15))
        ; Trans dates to ext format - check format
        F PC=2,9:1:12,16,17,19 S $P(RPTDATA(1),U,PC)=$$FMTE^XLFDT($P(RPTDATA(1),U,PC),"5Z")
        ;
        ; Loop thru mult Contact segs
        S CNCT=0
        F  S CNCT=$O(^IBCN(365,IEN,3,CNCT)) Q:'CNCT  D
        .  S RPTDATA(3,CNCT)=$G(^IBCN(365,IEN,3,CNCT,0))
        .  ; Disp. blank if NOT SPECIFIED
        .  I $P(RPTDATA(3,CNCT),U)="NOT SPECIFIED" S $P(RPTDATA(3,CNCT),U)=""
        .  ; Comm Qual #1-3
        .  F II=1:1:3 D
        .  . S CNPTR=$$X12^IBCNERP2(365.021,$P(RPTDATA(3,CNCT),U,II*2))
        .  . I CNPTR'="" S $P(RPTDATA(3,CNCT),U,II*2)=CNPTR_": "_$P(RPTDATA(3,CNCT),U,II*2+1),$P(RPTDATA(3,CNCT),U,II*2+1)=""
        ;
        ; Error Txt
        S ERRTEXT=$G(^IBCN(365,IEN,4))
        I ERRTEXT="" G FUTDT
        D FSTRNG^IBJU1(ERRTEXT,60,.IBERR)
        ; Loop thru text (60 chars)
        S II=0
        F  S II=$O(IBERR(II)) Q:'II  I $G(IBERR(II))'="" D
        .  S RPTDATA(4,II)=$G(IBERR(II))
FUTDT   I TQIEN D  ; If there is a future date, display it
        . S FUTDT=$P($G(^IBCN(365.1,TQIEN,0)),U,9) Q:FUTDT=""
        . S II=$O(RPTDATA(5,""),-1)+1
        . S RPTDATA(5,II)=" ",II=II+1
        . S RPTDATA(5,II)="Inquiry will be automatically resubmitted on "_$$FMTE^XLFDT(FUTDT,"5Z")_"."
        ; 
GETDATX ; GETDATA exit point
        Q
        ;
        ; This tag is only called from IBCNERP3
        ;
DATA(DISPDATA)   ;  Build disp lines
        N LCT,CT,SEGCT,ITEM,CT2,NTCT,CNCT,ERCT,RPTDATA
        ; Merge into local array
        M RPTDATA=^TMP($J,RTN,SORT1,SORT2,CNT)
        ; Build
        S LCT=1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.01),17,"R")_$P(RPTDATA(1),U,1)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.05),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(1),U,5),20)_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.02),22,"R")_$P(RPTDATA(1),U,2)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.03),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(1),U,3),20)_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.04),22,"R")_$P(RPTDATA(1),U,4)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.06),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(1),U,6),20)_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.07),22,"R")_$P(RPTDATA(1),U,7)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.08),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(1),U,8),20)_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.09),22,"R")_$P(RPTDATA(1),U,9)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.18),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(1),U,18),20)_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.13),22,"R")_$P(RPTDATA(1),U,13)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.1),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(1),U,10),20)_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.16),22,"R")_$P(RPTDATA(1),U,16)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.11),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(1),U,11),20)_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.17),22,"R")_$P(RPTDATA(1),U,17)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.12),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(1),U,12),20)_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.19),22,"R")_$P(RPTDATA(1),U,19)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,.07),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(0),U,7),20)_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,.09),22,"R")_$P(RPTDATA(0),U,9)
        S LCT=LCT+1,DISPDATA(LCT)=$$FO^IBCNEUT1($$LBL^IBCNERP2(365,1.2),17,"R")_$$FO^IBCNEUT1($P(RPTDATA(1),U,20),20)
        ;
        ; Contacts
CONT    S CNCT=+$O(RPTDATA(3,""),-1) I 'CNCT G ERR
        S DISPDATA(LCT)="",LCT=LCT+1,DISPDATA(LCT)="Contact Information:",LCT=LCT+1
        ; Build
        F CT=1:1:CNCT D
        . S DISPDATA(LCT)="",LCT=LCT+1,DISPDATA(LCT)=" "
        . S SEGCT=$L(RPTDATA(3,CT),U)
        . F CT2=1:1:SEGCT S ITEM=$P(RPTDATA(3,CT),U,CT2) I $L(ITEM)>0 D
        . . I $L(ITEM)+$L(DISPDATA(LCT))>74 S LCT=LCT+1,DISPDATA(LCT)=" "_ITEM Q
        . . I DISPDATA(LCT)'=" " S DISPDATA(LCT)=DISPDATA(LCT)_",  "_ITEM Q
        . . S DISPDATA(LCT)=" "_ITEM
        . S LCT=LCT+1
        ; Err Info
ERR     I $P(RPTDATA(1),U,14)="",$P(RPTDATA(1),U,15)="",'$O(RPTDATA(4,""),-1) G DATAX
        S DISPDATA(LCT)="",LCT=LCT+1
        S DISPDATA(LCT)="Error Information:",LCT=LCT+1
        S DISPDATA(LCT)="",LCT=LCT+1
        I $P(RPTDATA(1),U,14)'="" D
        . ; Split text, if necessary
        . N IBERR,IBTOT,IBCT
        . D FSTRNG^IBJU1($P(RPTDATA(1),U,14),60,.IBERR)
        . S IBTOT=$O(IBERR(""),-1)
        . F IBCT=1:1:IBTOT S DISPDATA(LCT)=" "_$$FO^IBCNEUT1($S(IBCT=1:$$LBL^IBCNERP2(365,1.14),1:" "),17,"R")_$G(IBERR(IBCT)),LCT=LCT+1
        I $P(RPTDATA(1),U,15)'="" D
        . ; Split text, if necessary
        . N IBERR,IBTOT,IBCT
        . D FSTRNG^IBJU1($P(RPTDATA(1),U,15),60,.IBERR)
        . S IBTOT=$O(IBERR(""),-1)
        . F IBCT=1:1:IBTOT S DISPDATA(LCT)=" "_$$FO^IBCNEUT1($S(IBCT=1:$$LBL^IBCNERP2(365,1.15),1:" "),17,"R")_$G(IBERR(IBCT)),LCT=LCT+1
        ; Disp Err Txt
        F CT=1:1:+$O(RPTDATA(4,""),-1) D
        . I CT=1 S DISPDATA(LCT)=" "_$$FO^IBCNEUT1($$LBL^IBCNERP2(365,4.01),17,"R")_$G(RPTDATA(4,CT)),LCT=LCT+1 Q
        . S DISPDATA(LCT)=" "_$$FO^IBCNEUT1("",17,"R")_$G(RPTDATA(4,CT)),LCT=LCT+1
DATAX   ;
        ; Disp Future Date and Misc. Comments
        I $O(RPTDATA(5,0))'="" D
        . F CT=1:1:+$O(RPTDATA(5,""),-1) D
        .. S DISPDATA(LCT)=" "_$$FO^IBCNEUT1("",7,"R")_$G(RPTDATA(5,CT)),LCT=LCT+1
        ;
        Q
