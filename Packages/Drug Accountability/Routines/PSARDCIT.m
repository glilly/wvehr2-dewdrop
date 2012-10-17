PSARDCIT        ;BIRM/JAM - Return Drug Credit Single Item ListMan driver ;06/06/08
        ;;3.0; DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**69**;10/24/97;Build 9
        ;References to ORDER UNIT file (#51.5) supported by IA #1931
        ;
EN(PSAPHLOC,PSABATCH,PSAITEM)   ; - ListManager entry point
        ;
        D EN^VALM("PSA RETURN DRUG BATCH ITEM")
        D FULL^VALM1
        G EXIT
        ;
HDR     ; - Header
        D LMHDR^PSARDCUT(PSAPHLOC,PSABATCH)
        Q
        ;
INIT    ; - Populates the Body section for ListMan
        K ^TMP("PSARDCIT",$J)
        S VALMCNT=0
        D SETLINE
        S VALMSG="Enter ?? for more actions"
        Q
        ;
SETLINE ; - Sets the line to be displayed in ListMan
        N LINE,SEQ,DATA,FLDS
        K ^TMP("PSARDCIT",$J)
        S SEQ=0
        D GETS^DIQ(58.3511,PSAITEM_","_PSABATCH_","_PSAPHLOC_",","*","IE","FLDS")
        K DATA M DATA=FLDS(58.3511,PSAITEM_","_PSABATCH_","_PSAPHLOC_",")
        S LINE="          Drug: "_$E(DATA(.01,"E"),1,26),$E(LINE,44)="Credit Status: "_DATA(10,"E") D SETTMP
        S LINE="  Manufacturer: "_$E(DATA(2,"E"),1,30),$E(LINE,48)="Exp. Date: "_$$FMTE^XLFDT(DATA(9,"I"),"2ZM") D SETTMP
        S LINE="           NDC: "_$E(DATA(3,"E"),1,30),$E(LINE,47)="Created By: "_$E($G(DATA(16,"E")),1,22) D SETTMP
        S LINE="           UPC: "_$E(DATA(4,"E"),1,30),$E(LINE,47)="Created On: "_$$FMTE^XLFDT(DATA(1,"I"),"2ZM") D SETTMP
        S LINE="      Ord Unit: "_$E($$GET1^DIQ(51.5,DATA(5,"I"),.02),1,30),$E(LINE,47)="Est Credit: $"_$J(DATA(11,"E"),0,2) D SETTMP
        S LINE="      Dsp Unit: "_$E(DATA(8,"E"),1,27),$E(LINE,44)="Actual Credit: $"_$J(DATA(12,"E"),0,2) D SETTMP
        S LINE="          DUOU: "_$E(DATA(7,"E"),1,27),$E(LINE,44)="Return Reason: "_DATA(15,"E") D SETTMP
        S LINE="Return Ord Qty: "_DATA(6,"E"),$E(LINE,43)="Upd. Inventory: "_DATA(14,"E") D SETTMP
        S LINE="Return Dsp Qty: "_DATA(17,"E") D SETTMP
        S LINE="" D SETTMP
        S LINE="Activity Log" D SETTMP D CNTRL^VALM10(SEQ,1,80,IOUON,IOINORM)
        S LINE="DATE/TIME",$E(LINE,20)="ACTION",$E(LINE,30)="USER" D SETTMP
        D CNTRL^VALM10(SEQ,1,80,IOUON,IOINORM)
        D ACTLOG
        S VALMCNT=SEQ
        Q
        ;
ACTLOG  ; - Gets lines for activity log
        N LOG,FLDS,LINE,PSALOG,I,COMM
        S LOG=0
        F  S LOG=$O(^PSD(58.35,PSAPHLOC,"BAT",PSABATCH,"ITM",PSAITEM,"LOG",LOG)) Q:'LOG  D
        .D GETS^DIQ(58.35111,LOG_","_PSAITEM_","_PSABATCH_","_PSAPHLOC_",","*","IE","FLDS")
        .M PSALOG=FLDS(58.35111,LOG_","_PSAITEM_","_PSABATCH_","_PSAPHLOC_",")
        .S LINE=$$FMTE^XLFDT(PSALOG(.01,"I"),"2Z"),$E(LINE,20)=PSALOG(2,"E"),$E(LINE,30)=PSALOG(1,"E") D SETTMP
        .S COMM=PSALOG(3,"E") I $L(COMM)>80 D
        ..F I=$L(COMM," "):-1:1 I $L($P(COMM," ",1,I))<80 D  Q
        ...S LINE=$P(COMM," ",1,I) D SETTMP S LINE=$P(COMM," ",I+1,$L(COMM," ")) D SETTMP
        .E  S LINE=COMM D SETTMP
        Q
        ;
SETTMP  ; Set ^TMP("PSARDCIT",$J, array
        S SEQ=SEQ+1,^TMP("PSARDCIT",$J,SEQ,0)=LINE
        Q
        ;
EDT     ; - Single Item Edit
        N PSANODE,PSALCK,BATST
        D FULL^VALM1
        W ! S BATST=$$BATSTA(PSAPHLOC,PSABATCH) I '+BATST D  Q
        .S VALMSG=$P(BATST,"^",2),VALMBCK="R" W $C(7)
        S PSANODE="^PSD(58.35,"_PSAPHLOC_",""BAT"","_PSABATCH_",""ITM"","_PSAITEM_")"
        S PSALCK=$$LK(PSANODE) I 'PSALCK D  W $C(7) Q
        .S VALMSG="Record locked by another user. Try again later!",VALMBCK="R"
        D ITEM^PSARDCU1(PSAPHLOC,PSABATCH,PSAITEM),UNLK(PSANODE),SETLINE
        S VALMBCK="R"
        Q
        ;
CAN     ; - Single Item Cancel
        N BATST,PSANODE,PSALCK,DIR,DIK,DA,X,Y,DRUG,UPINV,DUNTS
        D FULL^VALM1
        W ! S BATST=$$BATSTA(PSAPHLOC,PSABATCH) I '+BATST D  Q
        .S VALMSG=$P(BATST,"^",2),VALMBCK="R" W $C(7)
        I $$GET1^DIQ(58.351,PSABATCH_","_PSAPHLOC,1,"I")="PU" D  W $C(7) Q
        .S VALMSG="Cannot change. This batch has been picked up",VALMBCK="R"
        S PSANODE="^PSD(58.35,"_PSAPHLOC_",""BAT"","_PSABATCH_",""ITM"","_PSAITEM_")"
        S PSALCK=$$LK(PSANODE) I 'PSALCK D  W $C(7) Q
        .S VALMSG="Record locked by another user. Try again later!",VALMBCK="R"
        S DIR(0)="Y",DIR("A")="     Confirm",DIR("B")="N"
        D ^DIR I ($D(DIRUT))!('Y) D  Q
        .S VALMSG="Cancel aborted...",VALMBCK="R" W $C(7) D UNLK(PSANODE)
        S DRUG=$$GET1^DIQ(58.3511,PSAITEM_","_PSABATCH_","_PSAPHLOC,.01,"I")
        S UPINV=$$GET1^DIQ(58.3511,PSAITEM_","_PSABATCH_","_PSAPHLOC,14,"I")
        S DUNTS=$$GET1^DIQ(58.3511,PSAITEM_","_PSABATCH_","_PSAPHLOC,17,"I")
        ;call to update inventory
        I UPINV,+DUNTS>0 D UPDINV^PSARDCUT(PSAPHLOC,PSABATCH,PSAITEM,DRUG,DUNTS)
        ;delete record
        S DA(2)=PSAPHLOC,DA(1)=PSABATCH,DA=PSAITEM
        S DIK="^PSD(58.35,"_DA(2)_",""BAT"","_DA(1)_",""ITM"","
        D ^DIK,UNLK(PSANODE)
        S VALMSG="Item removed!",VALMBCK="Q"
        Q
        ;
CRE     ; - Single Item Credit Update
        N DIR,DIRUT,DA,X,Y,BATST,PSANODE,PSALCK,PSAISTA,PSAIAMT,CREAMT,OISTA
        N FLDD,PSACOM,CRESTA,ACTAMT,ESTAMT
        D FULL^VALM1
        W ! S BATST=$$BATSTA(PSAPHLOC,PSABATCH)
        I $P(BATST,"^",2)'="PU" D  S VALMBCK="R" W $C(7) Q
        .S VALMSG="Batch status must be PICKED UP to update credit!"
        S PSANODE="^PSD(58.35,"_PSAPHLOC_",""BAT"","_PSABATCH_",""ITM"","_PSAITEM_")"
        S PSALCK=$$LK(PSANODE) I 'PSALCK D  W $C(7) Q
        .S VALMSG="Record locked by another user. Try again later!",VALMBCK="R"
        S DIR(0)="58.3511,10",DIR("A")="CREDIT STATUS"
        S OISTA=$$GET1^DIQ(58.3511,PSAITEM_","_PSABATCH_","_PSAPHLOC,10,"I")
        S DIR("B")=$S(OISTA="":"P",1:OISTA)
        D ^DIR I $D(DIRUT) D  Q
        .S VALMSG="Credit Update aborted",VALMBCK="R" D UNLK(PSANODE)
        S PSAISTA=Y,(PSAIAMT,CREAMT)="",CRESTA=$$EXTERNAL^DILFD(58.3511,10,,Y)
        K DIR,X,Y,DA W !
        ;Only ask for amount when status is Actual or Estimated
        I ("^A^E^")[("^"_PSAISTA_"^") D
        .S FLDD=$S(PSAISTA="A":12,1:11) ;,DIR(0)="58.3511,"_FLDD
        .S DIR(0)="NA^0.01:999999999:2",DIR("?")="Type a Dollar amount between 0 and 999999999, 2 Decimal Digits"
        .S CREAMT=$$GET1^DIQ(58.3511,PSAITEM_","_PSABATCH_","_PSAPHLOC,FLDD,"I")
        .I CREAMT'="" S DIR("B")=$J(CREAMT,0,2)
        .S DIR("A")=$$EXTERNAL^DILFD(58.3511,10,,PSAISTA)_" CREDIT AMOUNT: "
        .D ^DIR
        .S PSAIAMT=Y
        I $D(DIRUT) D  Q
        .S VALMSG="Credit Update aborted",VALMBCK="R" W $C(7) D UNLK(PSANODE)
        K DIR,X,Y,DA W !
        S DIR(0)="Y",DIR("A")="  Save Credit",DIR("B")="N"
        D ^DIR I $D(DIRUT)!('Y) D  Q
        .S VALMSG="Credit Update aborted...",VALMBCK="R" W $C(7) D UNLK(PSANODE)
        ; if record unchanged, quit.
        I OISTA=PSAISTA,CREAMT=PSAIAMT S VALMBCK="R" Q
        I OISTA'=PSAISTA D
        .S PSACOM="CREDIT STATUS changed from "_$S(OISTA="":"''",1:$$EXTERNAL^DILFD(58.3511,10,,OISTA))_" to "_$$EXTERNAL^DILFD(58.3511,10,,PSAISTA)_". "
        .D LOGACT^PSARDCUT(PSAPHLOC,PSABATCH,PSAITEM,"E",PSACOM)
        I ("^A^E^")[("^"_PSAISTA_"^") D
        .S PSACOM=$$EXTERNAL^DILFD(58.3511,10,,PSAISTA)_" CREDIT AMOUNT changed from "_$S(CREAMT="":"''",1:"$"_$J(CREAMT,0,2))_" to $"_$J(PSAIAMT,0,2)_"."
        .D LOGACT^PSARDCUT(PSAPHLOC,PSABATCH,PSAITEM,"E",PSACOM)
        I ("^P^D^")[("^"_PSAISTA_"^") D
        .S PSACOM=""
        .S ESTAMT=$$GET1^DIQ(58.3511,PSAITEM_","_PSABATCH_","_PSAPHLOC,11,"I")
        .I ESTAMT'="" S PSACOM="ESTIMATED CREDIT AMOUNT of $"_$J(ESTAMT,0,2)
        .S ACTAMT=$$GET1^DIQ(58.3511,PSAITEM_","_PSABATCH_","_PSAPHLOC,12,"I")
        .I ACTAMT'="" S PSACOM=PSACOM_$S(PSACOM="":"",1:" and ")_"ACTUAL CREDIT AMOUNT of $"_$J(ACTAMT,0,2)
        .I PSACOM'="" S PSACOM=PSACOM_$S(PSACOM["and":" were",1:" was")_" automatically deleted."
        .I PSACOM'="" D LOGACT^PSARDCUT(PSAPHLOC,PSABATCH,PSAITEM,"E",PSACOM)
        D ITMUPD,UNLK(PSANODE),HDR,SETLINE
        S VALMBCK="R"
        Q
        ;
ITMUPD  ; - Single Item File Update
        N PSAIENS,PSARY
        S DA(2)=PSAPHLOC,DA(1)=PSABATCH,DA=PSAITEM
        S PSAIENS=$$IENS^DILF(.DA)
        S PSARY(58.3511,PSAIENS,10)=PSAISTA
        I ("^A^E^")[("^"_PSAISTA_"^") S PSARY(58.3511,PSAIENS,FLDD)=PSAIAMT
        I ("^P^D^")[("^"_PSAISTA_"^") D
        .S PSARY(58.3511,PSAIENS,11)=""
        .S PSARY(58.3511,PSAIENS,12)=""
        D UPDATE^DIE("","PSARY")
        Q
        ;
BATSTA(PSAPHLOC,PSABATCH)       ; - Returns if a batch is editable
        ; Input:   PSAPHLOC - Pharmacy location
        ;          PSABATCH - Batch IEN from ^PSD(58.35,
        ; Output:  1^Batch Status
        ;          0^Error message
        N BATST,MSG
        S BATST=$$GET1^DIQ(58.351,PSABATCH_","_PSAPHLOC,1,"I")
        I "^CO^CA^"[BATST D  Q 0_"^"_MSG
        .S MSG="Cannot change. This batch has been "_$S(BATST="CO":"completed.",1:"cancelled.")
        Q 1_"^"_BATST
        ;
LK(NODE)        ;- Locks node
        L +@NODE:$S($G(DILOCKTM)>0:DILOCKTM,1:3) Q $T
        ;
UNLK(NODE)      ;Unlocks node
        L -@NODE
        Q
EXIT    ;
        K ^TMP("PSARDCIT",$J)
        Q
        ;
HELP    ;
        Q
