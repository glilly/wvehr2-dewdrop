RMPRDVN ;HOIFO/SPS - MANDATORY PATIENT NOTIFICATION ; 9/3/08 12:14pm
        ;;3.0;PROSTHETICS;**125**;Feb 09, 1996;Build 21
        ;
        ;***** read in 660 patient 2319 record
MENT    ; Manual single patient entry sets field 19 PATIENT NOTIFICATION FLAG=1
        K ^TMP($J)
        R "Swipe barcode, enter barcode number, or Patient Name, or return to Quit: ",X:DTIME G:'$T EXIT G:X="" EXIT G:X["^" EXIT G:X?.AP ALPHA
        S DIC="^RMPR(660,",DIC(0)="EVQMNZ"
        ;,DIC("A")="Please Swipe the barcode, enter the barcode number, or Patient's Name: "
        D ^DIC G:+Y'>0 EXIT
CONT    S RMPRI=+Y,N=0 K Y
        I $D(^RMPO(665.72,"AC",RMPRI)) W !,"This is a Home Oxygen record, please try a different entry!" G MENT
        I $P(^RMPR(660,RMPRI,0),U,14)'="C" W !,"Not a valid entry, try again!" G MENT
        I $P($G(^RMPR(660,RMPRI,3)),U)'="VETERAN" W !,"Item not being sent to VETERAN, try again!" G MENT
        I $P($G(^RMPR(660,RMPRI,1)),U,4)'>0 W !,"No PSAS HCPCS this record cannot be sent!" G MENT
        S RMDAT(660,RMPRI_",",19)=1
        D FILE^DIE("","RMDAT","RMERROR")
        I $D(RMERROR) G EXIT
        G MENT
        ;
ALPHA   ;
        K ^TMP($J),RMIEN W ! S DIC="^RMPR(665,",DIC(0)="EMQZ"
        D ^DIC G:+Y'>0!($D(DTOUT)) EXIT
        D REV^RMPRUTIL W !
        S RMPRI=RMIEN
        I $D(^RMPO(665.72,"AC",RMPRI)) W !,"This is a Home Oxygen record, pleasetry a different entry!" G MENT
        I $P(^RMPR(660,RMPRI,0),U,14)'="C" W !,"Not a valid entry, try again!" G MENT
        I $P($G(^RMPR(660,RMPRI,3)),U)'="VETERAN" W !,"Item not being sent to VETERAN, try again!" G MENT
        I $P($G(^RMPR(660,RMPRI,1)),U,4)'>0 W !,"No PSAS HCPCS this record cannot be sent!" G MENT
        S RMDAT(660,RMPRI_",",19)=1
        D FILE^DIE("","RMDAT","RMERROR")
        I $D(RMERROR) S RESULT(0)=1_U_RMERROR G EXIT
        G MENT
QUE     ;
        N ZTRTN,ZTDESC,ZTDTH,ZTIO,RMPRPRO,ZTSK,ZTREQ,RMPRMSG
        S ZTRTN="IN^RMPRDVN"
        S ZTDESC="RMPR DELIVERY VERIFICATION NOTIFICATION"
        S ZTDTH=$H
        S ZTREQ="@"
        S ZTIO=""
        D ^%ZTLOAD
        S RMPRPRO=ZTSK
        Q
        ;
IN      ;
        S BDATE=DT
IN1     ;Entry for Server Option to rerun a day
        K ^TMP($J)
        D SFV,DELRUN^RMPRDVN2
        ; S BDATE=3080319 ;Can uncomment out line change date and use to test.
        N RMPRI,RMPRA,RMPRFME,RMPRERR,RMPRLIN,RMPRC
        S RMPRI="",RMPRERR=0,N=0
        F  S RMPRI=$O(^RMPR(660,"B",BDATE,RMPRI)) Q:RMPRI=""  D
        . Q:$P($G(^RMPR(660,RMPRI,0)),U)'=$P(^RMPR(660,RMPRI,0),U,3)
        . Q:$P($G(^RMPR(660,RMPRI,"LB")),U,14)=1
        . Q:$D(^RMPO(665.72,"AC",RMPRI))  ;EXCLUDE HO
        . I $P($G(^RMPR(660,RMPRI,0)),U,14)'="C" Q
        . I $P($G(^RMPR(660,RMPRI,3)),U)'="VETERAN" Q
        . I $P($G(^RMPR(660,RMPRI,0)),U,13)'=14 Q
        . I $P($G(^RMPR(660,RMPRI,1)),U,4)'>0 Q  ;EXCLUDE SHIPPING
        . I $D(^RMPR(660,"DVN",RMPRI)) Q
        . D SET
        S RMPRI=""
        F  S RMPRI=$O(^RMPR(660,"DVN",1,RMPRI)) Q:RMPRI=""  D
        . Q:$P($G(^RMPR(660,RMPRI,"LB")),U,14)=1
        . Q:$D(^RMPO(665.72,"AC",RMPRI))  ;EXCLUDE HO
        . I $P(^RMPR(660,RMPRI,0),U,14)'="C" Q
        . I $P(^RMPR(660,RMPRI,3),U)'="VETERAN" Q
        . I $P(^RMPR(660,RMPRI,0),U,13)'=14 Q
        . S RMDAT(660,RMPRI_",",19)="@"
        . D FILE^DIE("","RMDAT","RMERROR")
        . I $D(RMERROR) S RESULT(0)=1_U_RMERROR G EXIT
        . D SET
        D RUNEXT^RMPRDVN2
        D EXIT
        Q
SET     ;
        N RMPRA
        D GETS^DIQ(660,RMPRI,"*","IE","RMPRA","RMPRFME")
        I $D(RMPRFME) D GETX Q
        S RMPRT=RMPRI,RMPRI=RMPRI_","
        S RMPR60("ENTRY DATE")=RMPRA(660,RMPRI,.01,"I")
        S RMPR60("ENTRY DATE")=$$DAT1^RMPRUTL1(RMPR60("ENTRY DATE"))
        S RMPRBC=RMPRT
        S RMPR60("REQUIRED DATE")=RMPRA(660,RMPRI,26,"I")
        S RMPR60("REQUIRED DATE")=$$DAT1^RMPRUTL1(RMPR60("REQUIRED DATE"))
        S RMPR60("PSAS HCPCS")=RMPRA(660,RMPRI,4.5,"E")
        S RMPR60("PNM")=RMPRA(660,RMPRI,.02,"E")
        S RMPR60("PT ID")=$E($P(RMPR60("PNM"),",",1),1)
        S RMPR60("PATIENT")=$P(RMPR60("PNM"),",",2)_" "_$P(RMPR60("PNM"),",",1)
        S RMPR60("SHORT DESC")=RMPRA(660,RMPRI,24,"E")
        S RMPR60("TYPE OF TRAN")=RMPRA(660,RMPRI,2,"I")
        S RMPR60("VENDOR")=RMPRA(660,RMPRI,7,"E")
        S RMPRPA=RMPRA(660,RMPRI,27,"E")
        S RMPR60("PA")=$P(RMPRPA,",",2)_" "_$P(RMPRPA,",",1)
        S RMPR60("PADUZ")=RMPRA(660,RMPRI,27,"I")
        S DFN=RMPRA(660,RMPRI,.02,"I") D ADD^VADPT,DEM^VADPT
        S RMPR60("PT STATE")=""
        I VAPA(5)'="" S RMPR60("PT STATE")=$P($G(^DIC(5,$P(VAPA(5),U),0)),U,2)
        S RMPR60("PT ID")=RMPR60("PT ID")_"-"_$E(VA("BID"),3,4)_"-"
        S RMPR60("PT ID")=RMPR60("PT ID")_$E(RMPR60("PSAS HCPCS"),1,5)
        S RMPR60("STATION")=RMPRA(660,RMPRI,8,"E")
        S RMPR60("STAIEN")=RMPRA(660,RMPRI,8,"I")
        S RMPRSTA=^DIC(4,RMPR60("STAIEN"),4)
        S RMPRSNUM=$P(^DIC(4,RMPR60("STAIEN"),99),U)
        S RMPR60("STA ADD1")=$P(RMPRSTA,U,1)
        S RMPR60("STA ADD2")=$P(RMPRSTA,U,2)
        S RMPR60("STA CITY")=$P(RMPRSTA,U,3)
        S RMPR60("STA ST")=$P(^DIC(4,RMPR60("STAIEN"),0),U,2)
        S RMPR60("STA ST")=$P(^DIC(5,RMPR60("STA ST"),0),U,2)
        S RMPR60("STA ZIP")=$P(RMPRSTA,U,5)
        ; Get Purchasing Agent PARAM NAME & Phone from 669.9
        S (RMPREND,RMPRA,RMPR69)=""
        F  S RMPR69=$O(^RMPR(669.9,"PA",RMPR60("PADUZ"),RMPR69)) Q:RMPR69=""!RMPREND  D
        . Q:'$D(^RMPR(669.9,RMPR69,0))
        . S RMPRPA=$O(^RMPR(669.9,RMPR69,5,"B",RMPR60("PADUZ"),0))
        . I $P($G(^RMPR(669.9,RMPR69,5,RMPRPA,0)),U,4)="" Q
        . I $P($G(^RMPR(669.9,RMPR69,5,RMPRPA,0)),U,5)="" Q
        . S RMPR60("PA PHONE")=$P(^RMPR(669.9,RMPR69,5,RMPRPA,0),U,4)
        . S RMPR60("PA PT NM")=$P(^RMPR(669.9,RMPR69,5,RMPRPA,0),U,5)
        . S RMPREND=1
        I RMPREND="" Q
        S RMPR60("AMIS GRPR")=RMPRA(660,RMPRI,68,"E")
        S RMPRGPR=RMPR60("AMIS GRPR")
        S ^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)=RMPR60("ENTRY DATE")_"^"_RMPR60("REQUIRED DATE")_"^"_RMPR60("PSAS HCPCS")_"^"_RMPR60("SHORT DESC")_"^"_RMPR60("TYPE OF TRAN")_"^"_RMPR60("VENDOR")
        S ^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)=^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)_"^"_RMPR60("PA PT NM")_"^"_RMPR60("PA PHONE")
        S ^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)=^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)_"^"_RMPR60("PATIENT")_"^"_VAPA(1)_"^"_VAPA(2)_"^"_VAPA(3)_"^"_VAPA(4)_"^"_RMPR60("PT STATE")_"^"_VAPA(6)
        S ^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)=^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)_"^"_RMPRSNUM_"^"_RMPR60("STATION")_"^"_RMPR60("STA ADD1")_"^"_RMPR60("STA ADD2")_"^"_RMPR60("STA CITY")_"^"_RMPR60("STA ST")
        S ^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)=^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)_"^"_RMPR60("STA ZIP")_"^"_RMPRBC_"^"_RMPR60("PT ID")_"^"_RMPR60("AMIS GRPR")
        ; W !,^TMP($J,"RMPRDVN",RMPR60("STAIEN"),DFN,RMPRGPR,N)
        S RMPRI=RMPRT,N=N+1
        Q
SFV     ;Set OS File Variables & Header Record
        ;D NOW^%DTC S RMPRNOW=% K %
        S ^TMP($J,"RMPRDVN",0,0,0,0)="^Date_Ordered^Est_Delivery_Date^HCPC_Code^Description^Type_Of_Transaction^Vendor^Purchasing_Agent^Purchasing_Agent_Contact_Info^"
        S ^TMP($J,"RMPRDVN",0,0,0,0)=^TMP($J,"RMPRDVN",0,0,0,0)_"Patient_Name^Patient_Address1^Patient_Address2^Patient_Address3^Patient_City^Patient_State^"
        S ^TMP($J,"RMPRDVN",0,0,0,0)=^TMP($J,"RMPRDVN",0,0,0,0)_"Patient_Zip^Station_Number^Station_Name^Station_Address1^Station_Address2^Station_City^Station_State^Station_Zip^660_IEN^Patient_BarCode^AMIS_Grpr"
        S RMPR669=$O(^RMPR(669.9,"B",""))
        S RMPR669=$O(^RMPR(669.9,"B",RMPR669,""))
        S STID=$$GET1^DIQ(4,$$KSP^XUPARAM("INST")_",",99)
        S FILEDIR=$P($G(^RMPR(669.9,RMPR669,3)),U,2)
        S ADDR=$P($G(^RMPR(669.9,RMPR669,3)),U,1)
        S RMPRUSR=$P($G(^RMPR(669.9,RMPR669,3)),U,3)
        Q
EXIT    ;
        K ADDR,BDATE,DATE,DFN,DIC,DTOUT,FILEDIR,N,RESULT,RMDAT,RMERROR,RMPR60,RMPR669
        K RMPR69,RMPRA,RMPRBC,RMPRC,RMPREND,RMPRERR,RMPRFME,RMPRGPR,RMPRI,RMPRLIN
        K RMPRMSG,RMPRPA,RMPRPRO,RMPRSTA,RMPRSNUM,RMPRNOW,RMPRT,RMPRUSR,STID,X
        D KVAR^VADPT,KILL^XUSCLEAN
        Q
        ;
GETX    S RMPRMSG(1)=RMPRFME("DIERR",1,"TEXT",1)
        Q
