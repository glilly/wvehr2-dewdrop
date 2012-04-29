PRCHLO3 ;WOIFO/RLL-EXTRACT ROUTINE CLO REPORT SERVER ; 12/19/05 10:25am
V ;;5.1;IFCAP;**83**;; Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ; Continuation of PRCHLO2
 ;
 ; PRCHLO3 routines are used to Write out the Header and data
 ; associated with each of the 19 tables created for the Clinical
 ; logistics Report Server. The files are built from the extracts
 ; located in the ^TMP($J) global.
 ;
 Q
POMASTH ; Po Master Table Header file
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^Primary2237"
 W "^MethodOfProcessing^LocalProcReasonCode^ExpendableNonExpendable"
 W "^SupplyStatus^SupplyStatusOrder^FiscalStatusOrder^FCP"
 W "^Appropriation^CostCenter^SubAccount1^SubAmount1^SubAccount2"
 W "^SubAmount2^Vendor^RequestingService^FobPoint"
 W "^OriginalDeliveryDate^EstCost^SourceCode^EstShipping"
 W "^ShippingLineItemNum^LineItemCount^PaPpmAuthBuyer"
 W "^AgentAssignedPo^DatePoAssigned^Remarks^OldPoRecord^NewPoRecord"
 W "^PcdoVendor^PurchaseCardUser^PurchaseCost^PurchaseCardHolder"
 W "^Pcdo2237^TotalAmount^NetAmount",!
 Q
POMASTW ; Write PO Master table data
 N GPOID,GPOND
 S GPOID=0,GPOND=""
 F  S GPOID=$O(^TMP($J,"POMAST",GPOID)) Q:GPOID=""  D
 . ;  W !  ; new line for each PO
 . F  S GPOND=$O(^TMP($J,"POMAST",GPOID,GPOND)) Q:GPOND=""  D
 . . W $G(^TMP($J,"POMAST",GPOID,GPOND))
 . . Q
 . W !  ; new line for each PO
 . Q
 Q
 ;
POOBHD ; PO Obligation Header
 ;
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "ObDataIdNum^Tdateref^ObligatedBy^TransactionAmount^"
 W "AmendmentNumber^Z1358Adjustment",!
 Q
 ;
POOBW ; Write PO Obligation data
 N POOBID,POOBID1
 S POOBID=0,POOBID1=0
 F  S POOBID=$O(^TMP($J,"POOBLG",POOBID)) Q:POOBID=""  D
 . F  S POOBID1=$O(^TMP($J,"POOBLG",POOBID,POOBID1)) Q:POOBID1=""  D
 . . W $G(^TMP($J,"POOBLG",POOBID,POOBID1)),!
 . . Q
 . Q
 Q
POPMEH ; Purchase Order Purchase Method Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "PurchaseMethodIdNum^PurchaseMethod",!
 Q
POPMEW ; Write Purchase Order Purchase Method Data
 N POMT1,POMT2
 S POMT1=0,POMT2=0
 F  S POMT1=$O(^TMP($J,"POPMETH",POMT1)) Q:POMT1=""  D
 . F  S POMT2=$O(^TMP($J,"POPMETH",POMT1,POMT2)) Q:POMT2=""  D
 . . W $G(^TMP($J,"POPMETH",POMT1,POMT2)),!
 . .Q
 . Q
 Q
 ;
POPART ; PO Partial Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "PartialIdNum^Date^ScheduledDeliveryDate^SubAccount1^Subamount1^"
 W "SubAccount2^SubAmount2^Final^Overage^TotalAmount^"
 W "DiscountPercentDays^Linecount^OriginalPartial^"
 W "AdjustmentAmendmentNumber",!
 Q
POPARTW ; PO Partial Data Write
 N POPR1,POPR2
 S POPR1=0,POPR2=0
 F  S POPR1=$O(^TMP($J,"POPART",POPR1)) Q:POPR1=""  D
 . F  S POPR2=$O(^TMP($J,"POPART",POPR1,POPR2)) Q:POPR2=""  D
 . . W $G(^TMP($J,"POPART",POPR1,POPR2)),!
 . . Q
 . Q
 Q
 ;
PO2237H ; Po 2237 Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "Z2237IdNum^Z2237RefNum^AccountableOfficer^DateSigned^"
 W "PurchasingAgent^TypeOfRequest^SourceOfRequest^InvDistPoint",!
 Q
 ;
PO2237W ; PO 2237 Write Data
 N PO37A,PO37B
 S PO37A=0,PO37B=0
 F  S PO37A=$O(^TMP($J,"PO2237",PO37A)) Q:PO37A=""  D
 . F  S PO37B=$O(^TMP($J,"PO2237",PO37A,PO37B)) Q:PO37B=""  D
 . . W $G(^TMP($J,"PO2237",PO37A,PO37B)),!
 . . Q
 . Q
 Q
POBOCH ; PO BOC Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "BocIdNum^Subaccount^SubAmount",!
 Q
POBOCW ; PO BOC Write Data
 N POBOC,POBOC1
 S POBOC=0,POBOC1=0
 F  S POBOC=$O(^TMP($J,"POBOC",POBOC)) Q:POBOC=""  D
 . F  S POBOC1=$O(^TMP($J,"POBOC",POBOC,POBOC1)) Q:POBOC1=""  D
 . . W $G(^TMP($J,"POBOC",POBOC,POBOC1)),!
 . . Q
 . Q
 Q
POCMTSH ;PO Comments Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "CommentsIdNum^Comments",!
 Q
POCMTSW ; PO Comments Write Data
 N POCMT,POCMT1
 S POCMT=0,POCMT1=0
 F  S POCMT=$O(^TMP($J,"POCOMMENTS",POCMT)) Q:POCMT=""  D
 . W $G(^TMP($J,"POCOMMENTS",POCMT)),!
 . Q
 Q
PORMKH ; PO Remarks Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "RemarksIdNum^Remarks",!
 Q
PORMKW ; PO Remarks Write Data
 N PORMK
 S PORMK=0
 F  S PORMK=$O(^TMP($J,"POREMARKS",PORMK)) Q:PORMK=""  D
 . W $G(^TMP($J,"POREMARKS",PORMK)),!
 . Q
 Q
POPPTH ; Prompt Payment Terms Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "PaymentTermsIdNum^PromptPaymentPercent^DaysTerm^Contract^Astr",!
 Q
POPPTW ; Prompt Payment Terms Write Data
 N POPPT,POPPT1
 S POPPT=0,POPPT1=0
 F  S POPPT=$O(^TMP($J,"POPROMPT",POPPT)) Q:POPPT=""  D
 . F  S POPPT1=$O(^TMP($J,"POPROMPT",POPPT,POPPT1)) Q:POPPT1=""  D
 . . W $G(^TMP($J,"POPROMPT",POPPT,POPPT1,0)),!
 . . Q
 . Q
 Q
POAMTH ; PO Amount Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "AmountIdNum^Amount^TypeCode^CompStatusBusiness^PrefProgram^"
 W "Contract",!
 Q
POAMTW ; PO Amount Write Data
 N POAMT,POAMT1,POAMT2
 S POAMT=0,POAMT1=0
 F  S POAMT=$O(^TMP($J,"POAMT",POAMT)) Q:POAMT=""  D
 . F  S POAMT1=$O(^TMP($J,"POAMT",POAMT,POAMT1)) Q:POAMT1=""  D
 . . W $G(^TMP($J,"POAMT",POAMT,POAMT1,0)),!
 . . Q
 . Q
 Q
PAMTBKH ; PO Amount Breakout Code Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "AmountIdNum^AmountBrkCodeIdNum^BreakoutCode",!
 Q
POAMDH ; PO Amendment Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "AmendmentIdNum^Amendment^EffectiveChange^AmountChanged^"
 W "PappmAuthBuyer^AmendmentAdjStatus",!
 Q
POAMDW ; PO Amendment Write Data
 N POAMD,POAMD1,POAMD2
 S POAMD=0,POAMD1=0
 F  S POAMD=$O(^TMP($J,"POAMMD",POAMD)) Q:POAMD=""  D
 . F  S POAMD1=$O(^TMP($J,"POAMMD",POAMD,POAMD1)) Q:POAMD1=""  D
 . . W $G(^TMP($J,"POAMMD",POAMD,POAMD1,0)),!
 . . Q
 . Q
 Q
 ;
POAMDCH ; PO Amendment Changes Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "AmendmentIdNum^AmendmentChangeIdNum^Changes^AmendmentType",!
 Q
POAMDCW ; PO Amendment Changes Write Data
 N PAMDC,PAMDC1,PAMDC2,PAMDC3,PAMDC4
 S PAMDC=0,PAMDC1=0,PAMDC2=0,PAMDC3=0
 F  S PAMDC=$O(^TMP($J,"POAMMDCH",PAMDC)) Q:PAMDC=""  D
 . F  S PAMDC1=$O(^TMP($J,"POAMMDCH",PAMDC,PAMDC1)) Q:PAMDC1=""  D
 . . F  S PAMDC2=$O(^TMP($J,"POAMMDCH",PAMDC,PAMDC1,PAMDC2)) Q:PAMDC2=""  D
 . . . W $G(^TMP($J,"POAMMDCH",PAMDC,PAMDC1,PAMDC2,0)),!
 . . . Q
 . . Q
 . Q
 Q
PAMDDH ; PO Amendment Description Header
 W "PoIdNum^PurchaseOrderNum^PoDate^MonthYrRun^StationNum^"
 W "AmendmentIdNum^AmendmentDescIdNum^Description",!
 Q
 ;
PAMDDW ; PO Amendment Description Write Data
 N PAMD,PAMD1,PAMD2,PAMD3
 S PAMD=0,PAMD1=0,PAMD2=0
 F  S PAMD=$O(^TMP($J,"POAMMDDES",PAMD)) Q:PAMD=""  D
 . F  S PAMD1=$O(^TMP($J,"POAMMDDES",PAMD,PAMD1)) Q:PAMD1=""  D
 . . F  S PAMD2=$O(^TMP($J,"POAMMDDES",PAMD,PAMD1,PAMD2)) Q:PAMD2=""  D
 . . . W $G(^TMP($J,"POAMMDDES",PAMD,PAMD1,PAMD2,0)),!
 . . . Q
 . . Q
 . Q
 Q
PAMTBKW ; Write Breakout Code data
 N BCD,BCD1,BCD2,BCD3
 S BCD=0,BCD1=0,BCD2=0
 F  S BCD=$O(^TMP($J,"POBKCOD",BCD)) Q:BCD=""  D
 . F  S BCD1=$O(^TMP($J,"POBKCOD",BCD,BCD1)) Q:BCD1=""  D
 . . F  S BCD2=$O(^TMP($J,"POBKCOD",BCD,BCD1,BCD2)) Q:BCD2=""  D
 . . . ;
 . . . W $G(^TMP($J,"POBKCOD",BCD,BCD1,BCD2,0)),!
 . . Q
 . Q
 Q
