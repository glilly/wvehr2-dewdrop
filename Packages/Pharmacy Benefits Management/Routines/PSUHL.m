PSUHL ;BIR/RDC - DYNAMIC CAPTURE OF PATIENT DEMOGRAPHICS ; 05 MAR 2004
 ;;4.0;PHARMACY BENEFITS MANAGEMENT;;MARCH, 2005
 ;
 ;DBIA's
 ; Reference to file 55      supported by DBIA 3502
 ; Reference to file 2       supported by DBIA 3344
 ;
CHNG ; THIS TAG WILL EXECUTE UPON ANY MODIFICATION TO THE PATIENT FILE #2
 ; CHANGES TO ANY FIELDS OTHER THAN THOSE INHERANT TO THE 
 ; PATIENT DEMOGRAPHIC EXTRACT (^PSUDEM1) WILL BE IGNORED
 ; SUCCESSFUL EXECUTION OF THIS TAG WILL RESULT IN THE DATE AND
 ; DFN BEING LOGGED IN THE PBM PATIENT DEMOGRAPHICS file #59.9
 ;
 Q:DGFILE'=2          ;The modified file is not the PATIENT file(#2)
 N FIELD,CHANGED
 S CHANGED=0
 ;                               ; ** loop thru pertinent fields **
 ;
 F FIELD=.351,.03,.06,.02,.361,.14,27.01,.09,991.01,.104,.097,2.02,2.06 I $G(DGFIELD)=FIELD S CHANGED=1 Q      ; flag if one of our fields changes
 ;
 Q:'CHANGED                      ; irrelevant field changed - quit
 D LOGDFN(DGDA)                  ; log demographic change in ^PSUDEM 
 Q
 ;
LOGDFN(DFN)            ; This tag will log the date & dfn to file #59.9
 ;
 Q:+$G(DFN)=0                    ; no patient pointer to log ***
 Q:$D(^PSUDEM("C",DFN,DT))       ; patient already logged for today
 S X=DT                          ; load date into .01 field
 S DIC("DR")=".02///"_DFN        ; stuff dfn into .02 field
 S DLAYGO=59.9                   ; override no new entry flag
 S DIC="^PSUDEM("                ; point to global for #59.9
 S DIC(0)="LF"                   ; set laygo & forget flags
 D FILE^DICN                     ; call Fileman to build file
 K DIC,DLAYGO,X,DFN
 Q
 ; 
PHARM ;
 ; THIS TAG IS TRIGGERED BY A CROSS REFERENCE ON THE 
 ; PHARMACY PATIENT FILE (#55); FIRST SERVICE DATE (#.07)
 ;
 D LOGDFN(DA)              ;log change of patient demographics
 Q
 ;
CLEANUP ;  THIS TAG CLEANS UP DATA IN ^PSUDEM >75 DAYS
 ;
 N MIN,DAY,DFN
 S X1=DT,X2=-75
 D C^%DTC S MIN=X                                      ;today-75 days
 S DIK="^PSUDEM("                                 ;file root to kill
 S DAY=""
 F  S DAY=$O(^PSUDEM("B",DAY)) Q:DAY>MIN  D       ;loop thru days
 . S DFN=""                                       ;older than 75 days
 . F  S DFN=$O(^PSUDEM("B",DAY,DFN)) Q:DFN=""  D  ;get the dfn
 .. S DA=DFN D ^DIK                     ; and have Fileman kill the dfn
 ;
 K DIK
 Q
 ;
