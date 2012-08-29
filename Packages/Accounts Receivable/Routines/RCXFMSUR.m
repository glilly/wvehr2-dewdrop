RCXFMSUR ;WISC/RFJ-revenue source codes ;1 Oct 97
 ;;4.5;Accounts Receivable;**90,101,170,203,173,220,231**;Mar 20, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 Q
 ;
 ;
CALCRSC(BILLDA,RCEFT) ;  calculate the revenue source code for a bill
 ;  rceft = 1 if processing an EFT deposit
 ;  returns the 4 column (character) rsc
 N CATEGDA,COLUMN1,COLUMN2,COLUMN3,COLUMN4,RSC
 ;  if rsc already calculated, return it
 I $G(RCEFT)=1 S RSC="8NZZ" Q RSC
 S RSC=$P($G(^PRCA(430,BILLDA,11)),"^",23)
 I $L(RSC)=4,RSC'="ARRV" Q RSC
 ;
 ;  calculate it and store it
 S CATEGDA=+$P($G(^PRCA(430,BILLDA,0)),"^",2)
 ;
 ;  if prepayment, send ARRV
 I CATEGDA=26 D STORE(BILLDA,"ARRV") Q "ARRV"
 ;
 S COLUMN1=$$COLUMN1
 S COLUMN2=$$COLUMN2
 ;
 ;  if column2 cannot be determined, return the rsc of ARRV
 I COLUMN2="" D STORE(BILLDA,"ARRV") Q "ARRV"
 ;
 ;  if column2 is not a 5 for reimbursable health insurance,
 ;  return ZZ in columns 3 and 4
 I COLUMN2'=5 D STORE(BILLDA,COLUMN1_COLUMN2_"ZZ") Q COLUMN1_COLUMN2_"ZZ"
 ;
 ;  for reimbursable health insurance, compute columns 3 and 4
 S COLUMN3=$$COLUMN3
 S COLUMN4=$$COLUMN4
 ;
 D STORE(BILLDA,COLUMN1_COLUMN2_COLUMN3_COLUMN4)
 Q COLUMN1_COLUMN2_COLUMN3_COLUMN4
 ;
 ;
STORE(DA,RSC,FUND) ;  store the revenue source code  or fund in the file
 I $G(^PRCA(430,DA,0))="" Q
 N D,D0,DI,DIC,DIE,DQ,DR,X,Y
 S DR=""
 I $G(RSC)'="" S DR="255.1////"_RSC_";"
 I $G(FUND)'="" S DR=DR_"203////"_FUND_";"
 S (DIC,DIE)="^PRCA(430,"
 D ^DIE
 Q
 ;
 ;
COLUMN1() ;  return column 1 number
 Q 8
 ;
 ;
COLUMN2() ;  return column 2 number
 I CATEGDA=5 Q 1     ; hospital care (nsc)
 I CATEGDA=4 Q 2     ; outpatient care (nsc)
 I CATEGDA=3 Q 3     ; nursing home care (nsc)
 I CATEGDA=1 Q 4     ; ineligible hospital
 I CATEGDA=9 Q 5     ; reimbursable health insurance
 I CATEGDA=10 Q 6    ; tort fesor
 I CATEGDA=6 Q 7     ; workmans comp
 I CATEGDA=18 Q 8    ; c (means test)
 I CATEGDA=2 Q 9     ; emergency/humanitarian
 I CATEGDA=7 Q "A"   ; no fault auto accident
 I CATEGDA=22 Q "B"  ; rx copay/sc vet
 I CATEGDA=23 Q "C"  ; rx copay/nsc vet
 I CATEGDA=24 Q "D"  ; nursing home care per diem
 I CATEGDA=25 Q "E"  ; hospital care per diem
 I CATEGDA=21 Q "F"  ; medicare
 I CATEGDA=33 Q "G"  ; adult day health care
 I CATEGDA=34 Q "H"  ; domiciliary
 I CATEGDA=35 Q "I"  ; respite care - institutional
 I CATEGDA=36 Q "J"  ; respite care - non-institutional
 I CATEGDA=37 Q "K"  ; geriatric evaluation - institutional
 I CATEGDA=38 Q "L"  ; geriatric evaluation - non-institutional
 I CATEGDA=39 Q "M"  ; nursing home care - ltc
 Q ""
 ;
 ;
COLUMN3() ;  return the column 3 number
 N AGE,DECIMAL,DFN,IBCNDATA,TYPEAGE,TYPECARE,TYPEMEAN,TYPESERV,VA,VADM,VAERR
 D DIQ399(BILLDA)
 ;
 D TYPECARE
 ;
 ;  compute service connected at time of care (1 digit binary)
 ;  type of service connected is set as follows:
 ;        0 = SC Vet                   1 = NSC Vet
 S TYPESERV=1
 ;  service connected at time of care (.18) = yes (1)
 I $G(IBCNDATA(399,BILLDA,.18,"I"))=1 S TYPESERV=0
 ;
 S DFN=$P($G(^PRCA(430,BILLDA,0)),"^",7)
 D DEM^VADPT
 ;
 ;  compute means test at time of care (1 digit binary)
 ;  type of means test is set as follows:
 ;        0 = Cat A                    1 = Cat C
 S TYPEMEAN=0
 I $$BIL^DGMTUB(DFN,$G(IBCNDATA(399,BILLDA,151,"I")))=1 S TYPEMEAN=1
 ;
 ;  compute patient age at time of care (1 digit binary)
 ;  type of age is set as follows:
 ;        0 = under 65                 1 = 65 and older
 S AGE=$$FMDIFF^XLFDT($G(IBCNDATA(399,BILLDA,151,"I")),$P($G(VADM(3)),"^"))\365.25
 S TYPEAGE=1
 I AGE<65 S TYPEAGE=0
 ;
 ;  convert to decimal  typecare  typeserv  typemean  typeage
 ;             binary=  1   1         1         1         1
 ;            decimal= 16 + 8     +   4     +   2     +   1
 S DECIMAL=$S(TYPECARE="11":24,TYPECARE="10":16,TYPECARE="01":8,1:0)
 I TYPESERV S DECIMAL=DECIMAL+4
 I TYPEMEAN S DECIMAL=DECIMAL+2
 I TYPEAGE S DECIMAL=DECIMAL+1
 I DECIMAL<10 Q DECIMAL
 Q $C(65+DECIMAL-10)
 ;
 ;
COLUMN4() ;  return the column 4 number (reserved for future expansion)
 Q "Z"
 ;
 ;
DIQ399(DA)  ;  get data from file 399
 N D0,DIC,DIQ,DIQ2,DR
 K IBCNDATA
 S DIQ(0)="IE",DIC="^DGCR(399,",DIQ="IBCNDATA",DR=".04;.05;.18;151;" D EN^DIQ1
 Q
 ;
 ;
TYPECARE ;  compute type of care (2 digit binary)
 ;  type of care is set as follows:
 ;      00 = inpatient (hospital)    01 = outpatient
 ;      10 = nursing home            11 = other
 ;  default is other if it cannot be computed
 S TYPECARE="11"
 ;  bill classification (.05) = outpatient (3) or human.emerg(opt) (4)
 I $G(IBCNDATA(399,BILLDA,.05,"I"))=3!($G(IBCNDATA(399,BILLDA,.05,"I"))=4) S TYPECARE="01" Q
 ;  location of care (.04) = hospital inpt or outpt (1)
 I $G(IBCNDATA(399,BILLDA,.04,"I"))=1 S TYPECARE="00" Q
 ;  location of care (.04) = skilled nursing (nhcu) (2)
 I $G(IBCNDATA(399,BILLDA,.04,"I"))=2 S TYPECARE="10"
 Q
 ;
 ;
ADDEDIT ;  enter/edit revenue source codes for fund 0160A1 bills.  These
 ;  bills have the rsc entered by the user.  The user can select
 ;  from rscs in file 347.3
 W !!,"This option should be used with CAUTION.  This option will allow the"
 W !,"user owning the PRCASVC supervisor security key, to add or edit the"
 W !,"Revenue Source Codes selectable for non MCCF bills.  If an invalid"
 W !,"Revenue Source Code is entered or changed, all code sheets sent to"
 W !,"FMS referencing the invalid Revenue Source Code will reject.  Be"
 W !,"cautious when entering new Revenue Source Codes or editing existing"
 W !,"Revenue Source Codes.  New Revenue Source Codes should only be added"
 W !,"after they have been added in FMS."
 ;
 I '$D(^XUSEC("PRCASVC",DUZ)) W !!,"You are not an owner of the PRCASVC security key." Q
 ;
 N %,%Y,C,D,D0,DA,DI,DIC,DIE,DLAYGO,DQ,DR,RCRJFLAG,X,X1,X2,X3,Y
 ;
 F  D  Q:$G(RCRJFLAG)
 . S (DIC,DIE)="^RC(347.3,",DIC(0)="QEL",DLAYGO=347.3
 . R !!,"Select REVENUE SOURCE CODE: ",X:DTIME
 . S X1=X,X=$$UPPER^VALM1(X)
 . I $E(X)="?",X?."?" D ^DIC Q:Y<1
 . I X=""!($E(X)=U) S RCRJFLAG=1 Q
 . I $D(^RC(347.3,"B",X)) S Y=+$O(^(X,0)) W "   ",X,"  ",$P($G(^RC(347.3,Y,0)),U,2) W:$P(^(0),U,3) "  INACTIVE" D UPD Q 
 . S X2=$L(X1),X3=$C($A($E(X1,X2))-1),X3=$E(X1,1,X2-1)_X3,X3=$O(^RC(347.3,"C",X3)) I $E(X3,1,X2)=X1 S X=X1
 . S D="C" D IX^DIC Q:Y<1  D UPD Q
 Q
UPD S DIE="^RC(347.3,",DA=+Y,DR=".02;.03" D ^DIE
 Q
 ;
 ;
RSC ;revenue code (#430/255)
 I $P($G(^RC(347.3,X,0)),"^",3) D EN^DDIOL("THIS REVENUE SOURCE CODE IS INACTIVE.") K X Q
 S X=$P(^RC(347.3,X,0),"^")
 Q
 ;
SHOW ;  show/calculate revenue source code for a selected bill
 W !!,"This option will show the calculated Revenue Source Code for a selected"
 W !,"bill.  The Revenue Source Code is only calculated for accrued bills in"
 I DT'<$$ADDPTEDT^PRCAACC() W !,"funds 528701,528703,528704,528709/4032"
 I DT<$$ADDPTEDT^PRCAACC() W !,"funds 5287.1,5287.3,5287.4,4032"
 ;
 N %,%Y,BILLDA,C,DIC,FUND,I,RCRJFLAG,RSC,X,Y
 ;
 F  D  Q:$G(RCRJFLAG)
 .   S DIC="^PRCA(430,",DIC(0)="QEAM"
 .   W ! D ^DIC
 .   I Y<1 S RCRJFLAG=1 Q
 .   S BILLDA=+Y
 .   S FUND=$$GETFUNDB^RCXFMSUF(BILLDA,1)
 .   W !!,"        Bill Number: ",$P($G(^PRCA(430,BILLDA,0)),"^")
 .   W !,"               Fund: ",FUND
 .   I '$$PTACCT^PRCAACC(FUND),FUND'=4032 D  Q
 .   .   W !,"  The Revenue Source Code cannot be calculated for non-accrued bills."
 .   .   W !,"  The Revenue Source Code for non-accrued bills are input by the user."
 .   .   W !,"  The Revenue Source Code is currently entered as: "
 .   .   S RSC=$P($G(^PRCA(430,BILLDA,11)),"^",6)
 .   .   W $S(RSC="":"<not entered>",1:RSC)
 .   ;
 .   S RSC=$$CALCRSC(BILLDA)
 .   W !,"Revenue Source Code: ",RSC
 Q
