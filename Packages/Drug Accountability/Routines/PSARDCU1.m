PSARDCU1        ;BIRM/MFR - Return Drug - Utilities (Cont.) ;07/01/08
        ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;*69*;10/24/97;Build 9
        ;References to DRUG file (#50) supported by IA #2095
        ;References to ORDER UNIT file (#51.5) supported by IA #1931
        ;
ITEM(PHARMLOC,BATCH,ITEM,QUIT)  ; - Add/Edit Item
        N FIELDS,PSAMFR,PSANDC,PSAUPC,PSAORDUN,PSAQTYOU,PSAQTYDU,PSADUOU,PSADSPUN
        N PSADUNAM,PSAESTCR,PSAACTCR,PSACOST,PSAUPINV,PSAREAS,PSAEXPDT,PSADRNAM
        N PSADRUG,PSAUSER,DATA,OLDDATA,NEWDATA,PSAOUNAM,PRPT,EXPDT,DIC,DIR,Y,X
        ;
        D LOAD()
        ;
DRUG    ; - Drug
        K DIC,Y,X
        S DIC="^PSDRUG(",DIC(0)="QEAM",DIC("A")="DRUG: "
        S DIC("B")=$G(PSADRNAM) K:DIC("B")="" DIC("B")
        D ^DIC I $D(DTOUT) G END
        I X=""!('$G(PSADRUG)&(X["^"&(X'="^"))) D  G DRUG
        . W !,"This is a required response. Enter '^' to exit"
        I $D(DUOUT) G @$$GOTO(X,"DRUG")
        S PSADRUG=+Y,PSADRNAM=$$GET1^DIQ(50,PSADRUG,.01)
        I 'PSAORDUN S PSAORDUN=$$GET1^DIQ(50,PSADRUG,12,"I")
        I PSAORDUN S PSAOUNAM=$$GET1^DIQ(51.5,PSAORDUN,.02)
        I PSADSPUN="" S (PSADUNAM,PSADSPUN)=$$GET1^DIQ(50,PSADRUG,14.5)
        I PSADUNAM="" S PSADUNAM="DISP. UNIT"
        I PSADUOU="" S PSADUOU=+$$GET1^DIQ(50,PSADRUG,15)
        ;
MFR     ; - Manufacturer
        K DIR,DIRUT,DIROUT
        S DIR(0)="FAO^3:30",DIR("A")="MFR: "
        S DIR("B")=$G(PSAMFR) K:DIR("B")="" DIR("B")
        S DIR("?")="Enter the drug manufacturer name."
        D ^DIR I X'="",$D(DIRUT)!$D(DIROUT) G @$$GOTO(X,"MFR")
        I X="@" K DIR("B") S PSAMFR="" W "    Deleted!" G MFR
        I X="" S PSAMFR="" G NDC
        S PSAMFR=X
        ;
NDC     ; - NDC
        I $G(PSANDC)["^" S PSANDC=""
        D NDCEDT^PSANDCUT(PSADRUG,.PSANDC)
        I PSANDC["^" S X=PSANDC,PSANDC="" G @$$GOTO(X,"NDC")
        ;
ORDUNT  ; - Order Unit
        K DIC,Y,X
        I $G(PSAORDUN)="" S PSAORDUN=$$GET1^DIQ(50,PSADRUG,12,"I")
        I $G(PSAORDUN) S PSAOUNAM=$$GET1^DIQ(51.5,PSAORDUN,.02)
        I $$GET1^DIQ(50,PSADRUG,12,"I")'="",$G(PSAOUNAM)'="" W !,"ORDER UNIT: ",PSAOUNAM G DSPUNT
        S DIC="^DIC(51.5,",DIC(0)="QEAMZ",DIC("A")="ORDER UNIT: "
        S DIC("B")=$G(PSAOUNAM) K:DIC("B")="" DIC("B")
        D ^DIC I X'="",$D(DTOUT)!$D(DUOUT) G @$$GOTO(X,"ORDUNT")
        I X="" W !,"This is a required response. Enter '^' to exit" G ORDUNT
        I Y>0 S PSAORDUN=+Y,PSAOUNAM=$P(Y(0),"^",2)
        ;
DSPUNT  ; - Dispense Unit
        I $G(PSADSPUN)="" D
        . S (PSADUNAM,PSADSPUN)=$$GET1^DIQ(50,PSADRUG,14.5) I PSADUNAM="" S PSADUNAM="DISPENSE UNIT"
        I $$GET1^DIQ(50,PSADRUG,14.5)'="",$G(PSADSPUN)'="" W !,"DISPENSE UNIT: ",PSADSPUN G DUOU
        K DIR,DIRUT,DIROUT
        S DIR(0)="FAO^1:10",DIR("A")="DISPENSE UNIT: "
        S DIR("B")=$G(PSADSPUN) K:DIR("B")="" DIR("B")
        S DIR("?")="Enter the drug dispense unit."
        D ^DIR I X="@" K DIR("B") S PSADSPUN="" W "    Deleted!" G DSPUNT
        I X'="",$D(DIRUT)!$D(DIROUT) G @$$GOTO(X,"DSPUNT")
        I X="" S PSADSPUN="" G DUOU
        I X?.N W "   ??",$C(7) G DSPUNT
        S (PSADSPUN,PSADUNAM)=X
        ;
DUOU    ; - Number of Dispense Units per Order Unit
        I $G(PSADUOU)="" S PSADUOU=+$$GET1^DIQ(50,PSADRUG,15)
        S:'PSADUOU PSADUOU=""
        K DIR,Y,X,PRPT
        S PRPT=$S($G(PSAOUNAM)'="":PSAOUNAM,1:"ORDER UNIT")
        I $$GET1^DIQ(50,PSADRUG,15),$G(PSADUOU)'="" W !,"NUMBER OF "_PSADUNAM_"(S) PER "_PRPT_": ",PSADUOU G NUMOU
        S DIR(0)="NA^0.01:999999999:2",DIR("A")="NUMBER OF "_PSADUNAM_"(S) PER "_PRPT_": "
        S DIR("B")=$G(PSADUOU) K:'DIR("B") DIR("B")
        S DIR("?")="Enter the number of "_PSADUNAM_"(S) per "_PRPT_" being returned with a maximum of 2 decimal digits."
        D ^DIR I X'="",$D(DIRUT)!$D(DIROUT) G @$$GOTO(X,"DUOU")
        S PSADUOU=Y
        ;
NUMOU   ; - Number of Order Units Returned
        K DIR,Y,X,PRPT
        S PRPT=$S($G(PSAOUNAM)'="":PSAOUNAM,1:"ORDER UNIT")
        S DIR(0)="NAO^0.01:999999999:2",DIR("A")="NUMBER OF "_PRPT_"(S) TO RETURN: "
        S DIR("B")=$G(PSAQTYOU) K:'DIR("B") DIR("B")
        S DIR("?")="Enter the number of "_PRPT_"(S) being returned with a maximum of 2 decimal digits."
        D ^DIR I X'="",$D(DIRUT)!$D(DIROUT) G @$$GOTO(X,"NUMOU")
        I X="" S PSAQTYOU=X G NUMDU
        S PSAQTYOU=Y
        ;
NUMDU   ; - Number of Dispense Units Returned
        K DIR,Y,X,PRPT,DEFQTY
        S DEFQTY=$G(PSAQTYOU)*$G(PSADUOU)\1
        S PRPT=$S($G(PSADUNAM)'="":PSADUNAM,1:"DISPENSE UNIT")
        I PSAQTYDU,(PSAQTYDU'=DEFQTY) W !!,"CURRENT DISPENSE QUANTITY ON FILE: ",PSAQTYDU," ",PRPT_"(S)",!
        S DIR(0)="NA^1:999999999",DIR("A")="NUMBER OF "_PRPT_"(S) TO RETURN: "
        S DIR("B")=$G(DEFQTY) K:'DIR("B") DIR("B")
        S DIR("?")="Enter the number of "_PRPT_"(S) being returned."
        D ^DIR I $D(DIRUT)!$D(DIROUT) G @$$GOTO(X,"NUMOU")
        S PSAQTYDU=Y
        ;
UPC     ; - UPC
        K DIR,Y,X
        S DIR(0)="FAO^1:20",DIR("A")="UPC: "
        S DIR("B")=$G(PSAUPC) K:DIR("B")="" DIR("B")
        S DIR("?")="Enter the drug UPC."
        D ^DIR I X="@" K DIR("B") S PSAUPC="" W "    Deleted!" G UPC
        I X'="",$D(DIRUT)!$D(DIROUT) G @$$GOTO(X,"UPC")
        I X="" S PSAUPC="" G EXPDT
        S PSAUPC=X
        ;
EXPDT   ; - Expiration Date
        K DIR,Y,X
        N %DT,DTOUT,DUOUT
        S DIR(0)="DAO^::AEST",DIR("A")="EXPIRATION DATE: "
        S DIR("B")=$S($G(PSAEXPDT):$$UP^XLFSTR($$FMTE^XLFDT(PSAEXPDT)),1:"") K:DIR("B")="" DIR("B")
        S DIR("?")="Enter the drug expiration date."
        D ^DIR I X="@" K DIR("B") S PSAEXPDT="" W "    Deleted!" G EXPDT
        I X'="",$D(DUOUT)!$D(DTOUT) G @$$GOTO(X,"EXPDT")
        I X="" S PSAEXPDT="" G REASON
        S PSAEXPDT=Y
        ;
REASON  ; - Return Reason 
        K DIR,DIRUT,DIROUT
        S DIR(0)="58.3511,15",DIR("B")=$G(PSAREAS) K:DIR("B")="" DIR("B")
        S DIR("A")="RETURN REASON" D ^DIR I X'="",$D(DIRUT)!$D(DIROUT) G @$$GOTO(X,"REASON")
        I X="" W !,"This is a required response. Enter '^' to exit" G REASON
        S PSAREAS=Y
        ;
UPDINV  ; - Update Inventory? 
        K DIR,DIRUT,DIROUT,PSAUIEXT
        S DIR(0)="SA^Y:YES;N:NO"
        S PSAUIEXT="NO" I $G(PSAUPINV) S PSAUIEXT="YES"
        S DIR("B")=$G(PSAUIEXT) K:DIR("B")="" DIR("B")
        S DIR("A")="UPDATE INVENTORY: " D ^DIR I $D(DIRUT)!$D(DIROUT) G @$$GOTO(X,"UPDINV")
        I Y="Y",'$D(^PSD(58.8,PHARMLOC,1,PSADRUG,0)) D  G UPDINV
        . W !!?5,"Cannot update inventory. There is no inventory"
        . W !?5,"information for this Drug/Pharmacy Location.",!,$C(7)
        . S PSAUPINV=0
        S PSAUPINV=$S(Y="Y":1,1:0)
        ;
CONF    ; - Confirm?
        W ! S DIR(0)="YA",DIR("B")="YES",DIR("A")="Save Item? "
        D ^DIR I $D(DIRUT)!$D(DIROUT)!(Y=0) G @$$GOTO(X,"CONF")
        ;
        I '$$CHKREQ() G @$$GOTO("^DRUG","CONF")
        ;
        D SAVE(),AUDIT()
        ;
END     S QUIT=0 I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) S QUIT=1
        Q
        ;
GOTO(INPUT,HOME)        ; - Directed up-arrow
        N GOTO,TAG,TRGT
        I $P(INPUT,"^",2)="" Q "END"
        S INPUT=$$UP^XLFSTR(INPUT)
        ;
        S TRGT=$P(INPUT,"^",2)
        S TAG("DRUG")="DRUG"
        S TAG("MFR")="MFR"
        S TAG("NDC")="NDC"
        S TAG("ORDER UNIT")="ORDUNT"
        S TAG("DISPENSE UNIT")="DSPUNT"
        S TAG("NUMBER OF "_$G(PSAOUNAM))="NUMOU"
        S TAG("NUMBER OF "_$G(PSADUNAM)_"(S) PER")="DUOU"
        S TAG("NUMBER OF "_$G(PSADUNAM)_"(S) TO RETURN")="NUMDU"
        S TAG("UPC")="UPC"
        S TAG("EXPIRATION DATE")="EXPDT"
        S TAG("RETURN REASON")="REASON"
        S TAG("UPDATE INVENTORY")="UPDINV"
        ;
        S GOTO=HOME
        S TAG="" F  S TAG=$O(TAG(TAG)) Q:TAG=""  I $E(TAG,1,$L(TRGT))=TRGT S GOTO=TAG(TAG) Q
        I GOTO=HOME W "   ??",$C(7)
        ;
        Q GOTO
        ;
LOAD()  ; - Load existing item information
        S FIELDS=".01;1;2;3;4;5;6;7;8;9;14;15;17"
        S (PSADRUG,PSAMFR,PSANDC,PSAUPC,PSAORDUN,PSAQTYOU,PSAQTYDU,PSADUOU,EXPDT)=""
        S (PSADSPUN,PSAESTCR,PSAACTCR,PSACOST,PSAUPINV,PSAREAS,PSAUSER)=""
        ;
        I '$G(ITEM) Q
        ;
        K DATA D GETS^DIQ(58.3511,ITEM_","_BATCH_","_PHARMLOC_",",FIELDS,"IE","DATA")
        K OLDDATA M OLDDATA=DATA(58.3511,ITEM_","_BATCH_","_PHARMLOC_",")
        ;
        S PSADRUG=OLDDATA(.01,"I"),PSADRNAM=OLDDATA(.01,"E"),PSAMFR=OLDDATA(2,"I")
        S PSANDC=OLDDATA(3,"I"),PSAUPC=OLDDATA(4,"I"),PSAORDUN=$G(OLDDATA(5,"I"))
        S PSAQTYOU=OLDDATA(6,"I"),PSADUOU=OLDDATA(7,"I"),PSADSPUN=OLDDATA(8,"I")
        S PSAEXPDT=OLDDATA(9,"I"),PSAUPINV=OLDDATA(14,"I"),PSAREAS=OLDDATA(15,"I")
        S PSAUSER=$G(OLDDATA(16,"I")),PSAQTYDU=OLDDATA(17,"I")
        ;
        I $G(PSAORDUN) S PSAOUNAM=$$GET1^DIQ(51.5,PSAORDUN,.02)
        S PSADUNAM=PSADSPUN I PSADUNAM="" S PSADUNAM="DISP. UNIT"
        Q
        ;
CHKREQ()        ; - Checking for required fields
        I '$G(PSAORDUN)!'$G(PSAQTYDU)!'$G(PSADUOU)!($G(PSAREAS)="") D  Q 0
        . W !!?5,"The following required field(s) are missing:",$C(7),!
        . W:'$G(PSAORDUN) !?10,"ORDER UNIT"
        . W:'$G(PSADUOU) !?10,"NUMBER OF DISPENSE UNITS PER ORDER UNIT"
        . W:'$G(PSAQTYDU) !?10,"NUMBER OF DISPENSE UNITS TO RETURN"
        . W:$G(PSAREAS)="" !?10,"RETURN REASON"
        . W !
        Q 1
        ;
SAVE()  ; - Saves Item
        N DIE,DR,DA,NEWITEM
        ;
        W !!,"Saving..."
        ;
        S NEWITEM=0,DA(2)=PHARMLOC,DA(1)=BATCH
        I '$G(ITEM) D
        . N DIC,DR,X,DINUM,DLAYGO,DD,DO
        . S DIC="^PSD(58.35,"_PHARMLOC_",""BAT"","_BATCH_",""ITM"",",X=PSADRUG,DIC(0)=""
        . S DIC("DR")="1////"_$$NOW^XLFDT()_";10///P;16////"_DUZ
        . K DD,DO D FILE^DICN K DD,DO
        . S ITEM=+Y,NEWITEM=1
        ;
        S DR=".01////"_PSADRUG_";2///^S X=$S(PSAMFR'="""":PSAMFR,1:""@"");3///^S X=$S(PSANDC'="""":PSANDC,1:""@"")"
        S DR=DR_";4///^S X=PSAUPC;5////^S X=PSAORDUN;6///^S X=PSAQTYOU;7///^S X=PSADUOU"
        S DR=DR_";8///^S X=$S(PSADSPUN'="""":PSADSPUN,1:""@"");9///^S X=$S(PSAEXPDT'="""":PSAEXPDT,1:""@"")"
        S DR=DR_";14///^S X=PSAUPINV;15///^S X=PSAREAS;17///^S X=PSAQTYDU"
        ;
        S DIE="^PSD(58.35,"_PHARMLOC_",""BAT"","_BATCH_",""ITM"",",DA=ITEM
        D ^DIE W "OK" H 1
        I NEWITEM,PSAUPINV D UPDINV^PSARDCUT(PHARMLOC,BATCH,ITEM,PSADRUG,-PSAQTYDU)
        Q
        ;
AUDIT() ; - Activity Log/Inventory Update
        I $D(OLDDATA) D
        . N FLD K DATA D GETS^DIQ(58.3511,ITEM_","_BATCH_","_PHARMLOC_",",FIELDS,"IE","DATA")
        . K NEWDATA M NEWDATA=DATA(58.3511,ITEM_","_BATCH_","_PHARMLOC_",")
        . S FLD=""
        . F  S FLD=$O(OLDDATA(FLD)) Q:FLD=""  D
        . . I OLDDATA(FLD,"E")'=NEWDATA(FLD,"E") D
        . . . D LOGACT(FLD,OLDDATA(FLD,"E"),NEWDATA(FLD,"E"),"E")
        . . . ; DRUG changed
        . . . I FLD=.01 D
        . . . . I OLDDATA(14,"I") D UPDINV^PSARDCUT(PHARMLOC,BATCH,ITEM,OLDDATA(.01,"I"),OLDDATA(17,"I"))
        . . . . I NEWDATA(14,"I") D UPDINV^PSARDCUT(PHARMLOC,BATCH,ITEM,NEWDATA(.01,"I"),-NEWDATA(17,"I"))
        . . . I NEWDATA(.01,"I")'=OLDDATA(.01,"I") Q
        . . . ; UPDATE INVENTORY changed
        . . . I FLD=14 D
        . . . . I OLDDATA(14,"I") D UPDINV^PSARDCUT(PHARMLOC,BATCH,ITEM,PSADRUG,OLDDATA(17,"I"))
        . . . . I NEWDATA(14,"I") D UPDINV^PSARDCUT(PHARMLOC,BATCH,ITEM,PSADRUG,-NEWDATA(17,"I"))
        . . . I NEWDATA(14,"I")'=OLDDATA(14,"I") Q
        . . . ; DISPENSE QTY changed
        . . . I FLD=17 D
        . . . . I OLDDATA(14,"I") D UPDINV^PSARDCUT(PHARMLOC,BATCH,ITEM,PSADRUG,(OLDDATA(17,"I")-NEWDATA(17,"I")))
        Q
        ;
LOGACT(FIELD,OLDVALUE,NEWVALUE,TYPE,COMM)       ; - Log an activity for the return item
        I $G(COMM)="" D
        . S COMM=$$GET1^DID(58.3511,FIELD,"","LABEL")_" "
        . S COMM=COMM_"changed from "_$S(OLDVALUE="":"''",1:OLDVALUE)_" to "_$S(NEWVALUE="":"''",1:NEWVALUE)_"."
        D LOGACT^PSARDCUT(PHARMLOC,BATCH,ITEM,TYPE,COMM)
        Q
