ORY243  ;SLCOIFO - Pre and Post-init for patch OR*3*243 ; 3/28/08 5:58am
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
DELDD   ;Delete the old data dictionaries.
        N DIU,TEXT
        D EN^DDIOL("Removing old data dictionaries.")
        S DIU(0)=""
        S DIU=101.43
        S TEXT=" Deleting data dictionary for file # "_DIU
        D EN^DDIOL(TEXT)
        D EN^DIU2
        Q
        ;
PRE     ; initiate pre-init processes
        D DELDD
        D PEOMRPT,B
        D UPDTALRT
        Q
        ;
POST    ; initiate post-init processes
        ;
        D VITREG ;register Vitals RPC
        I +$$PATCH^XPDUTL("MAG*3.0*7") D MAGREG1
        I +$$PATCH^XPDUTL("MAG*3.0*37") D MAGREG2
        D DLGBULL
        D MAIL
        D PARVAL
        D PARAM
        D NOTIF
        D INISET^ORWGAPIU ; graph setting default
        S ^XTMP("ORGRAPH","FORCE")="ON" ; force rebuild of cache for graphing via ORMTIME
        D BULLMG
        D FLAGORD
        D ^ORY243ES ;expert system changes
        D DDEDIT
        D STS
        D MHDLL
        D CLRDFTD
        D INPQCONV^ORY243A
        D IVORCON^ORY243A
        D INSTALL^ORWOD  ;med quick order report
        Q
        ;
PEOMRPT ;Remove new & changed reports from OE/RR REPORTS file (101.24)
        N ORI,ORVIT
        S ORVIT=0
        I $P($G(^ORD(101.24,3,0)),"^",1)="ORRP AP ALL" D
        . S ORVIT=1,DA=3,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,3,0)="ORRP AP ALL",^ORD(101.24,"B","ORRP AP ALL",3)=""
        I $P($G(^ORD(101.24,3,0)),"^",1)="ORRP AP MENU" D
        . S ORVIT=1,DA=3,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,3,0)="ORRP AP ALL",^ORD(101.24,"B","ORRP AP ALL",3)=""
        I $P($G(^ORD(101.24,18,0)),"^",1)="ORL MOST RECENT" D
        . S ORVIT=1,DA=18,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,18,0)="ORL MOST RECENT",^ORD(101.24,"B","ORL MOST RECENT",18)=""
        I $P($G(^ORD(101.24,19,0)),"^",1)="ORL CUMULATIVE" D
        . S ORVIT=1,DA=19,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,19,0)="ORL CUMULATIVE",^ORD(101.24,"B","ORL CUMULATIVE",19)=""
        I $P($G(^ORD(101.24,20,0)),"^",1)="ORL ALL TESTS BY DATE" D
        . S ORVIT=1,DA=20,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,20,0)="ORL ALL TESTS BY DATE",^ORD(101.24,"B","ORL ALL TESTS BY DATE",20)=""
        I $P($G(^ORD(101.24,21,0)),"^",1)="ORL WORKSHEET" D
        . S ORVIT=1,DA=21,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,21,0)="ORL WORKSHEET",^ORD(101.24,"B","ORL WORKSHEET",21)=""
        I $P($G(^ORD(101.24,22,0)),"^",1)="ORL GRAPH" D
        . S ORVIT=1,DA=22,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,22,0)="ORL GRAPH",^ORD(101.24,"B","ORL GRAPH",22)=""
        I $P($G(^ORD(101.24,23,0)),"^",1)="ORL MICROBIOLOGY" D
        . S ORVIT=1,DA=23,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,23,0)="ORL MICROBIOLOGY",^ORD(101.24,"B","ORL MICROBIOLOGY",23)=""
        I $P($G(^ORD(101.24,24,0)),"^",1)="ORL ANATOMIC PATHOLOGY" D
        . S ORVIT=1,DA=24,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,24,0)="ORL ANATOMIC PATHOLOGY",^ORD(101.24,"B","ORL ANATOMIC PATHOLOGY",24)=""
        I $P($G(^ORD(101.24,25,0)),"^",1)="ORL BLOOD BANK" D
        . S ORVIT=1,DA=25,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,25,0)="ORL BLOOD BANK",^ORD(101.24,"B","ORL BLOOD BANK",25)=""
        I $P($G(^ORD(101.24,26,0)),"^",1)="ORL LAB STATUS" D
        . S ORVIT=1,DA=26,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,26,0)="ORL LAB STATUS",^ORD(101.24,"B","ORL LAB STATUS",26)=""
        I $P($G(^ORD(101.24,27,0)),"^",1)="ORL SELECTED TESTS BY DATE" D
        . S ORVIT=1,DA=27,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,27,0)="ORL SELECTED TESTS BY DATE",^ORD(101.24,"B","ORL SELECTED TESTS BY DATE",27)=""
        I $P($G(^ORD(101.24,1032,0)),"^",1)="ORRPW ALLERGIES ADV" D
        . S ORVIT=1,DA=1032,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,1032,0)="ORRPW ALLERGIES ADV",^ORD(101.24,"B","ORRPW ALLERGIES ADV",1032)=""
        I $P($G(^ORD(101.24,1100,0)),"^",1)="ORRPW ORDERS CURRENT" D
        . S ORVIT=1,DA=1100,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,1100,0)="ORRPW ORDERS CURRENT",^ORD(101.24,"B","ORRPW ORDERS CURRENT",1100)=""
        I $P($G(^ORD(101.24,1079,0)),"^",1)="ORRPW PHARMACY ALL OUT" D
        . S ORVIT=1,DA=1079,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,1079,0)="ORRPW PHARMACY ALL OUT",^ORD(101.24,"B","ORRPW PHARMACY ALL OUT",1079)=""
        I $P($G(^ORD(101.24,48,0)),"^",1)="ORRP SURGERIES" D
        . S ORVIT=1,DA=48,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,48,0)="ORRP SURGERIES",^ORD(101.24,"B","ORRP SURGERIES",48)=""
        I $P($G(^ORD(101.24,1137,0)),"^",1)="ORRPW DOD ALLERGIES ADV" D
        . S ORVIT=1,DA=1137,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,1137,0)="ORRPW DOD ALLERGIES ADV",^ORD(101.24,"B","ORRPW DOD ALLERGIES ADV",1137)=""
        I $P($G(^ORD(101.24,1551,0)),"^",1)="ORRPW HDR ALLERGIES" D
        . S ORVIT=1,DA=1551,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,1551,0)="ORRPW HDR ALLERGIES",^ORD(101.24,"B","ORRPW HDR ALLERGIES",1551)=""
        I $P($G(^ORD(101.24,1553,0)),"^",1)="ORRPW HDR PHARMACY OUT" D
        . S ORVIT=1,DA=1553,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,1553,0)="ORRPW HDR PHARMACY OUT",^ORD(101.24,"B","ORRPW HDR PHARMACY OUT",1553)=""
        I $P($G(^ORD(101.24,1105,0)),"^",1)="ORRPW DOD PHARM ALL OUT" D
        . S ORVIT=1,DA=1105,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,1105,0)="ORRPW DOD PHARM ALL OUT",^ORD(101.24,"B","ORRPW DOD PHARM ALL OUT",1105)=""
        I $P($G(^ORD(101.24,1078,0)),"^",1)="ORRPW PHARMACY ACT OUT" D
        . S ORVIT=1,DA=1078,DIK="^ORD(101.24," D ^DIK
        . S ^ORD(101.24,1078,0)="ORRPW PHARMACY ACT OUT",^ORD(101.24,"B","ORRPW PHARMACY ACT OUT",1078)=""
        S ORI=999
        F  S ORI=$O(^ORD(101.24,ORI)) Q:'ORI  I ORI<1110!(ORI>1116) S DA=ORI,DIK="^ORD(101.24," D ^DIK
        Q
MAIL    ; send bulletin of installation time
        N COUNT,DIFROM,I,START,TEXT,XMDUZ,XMSUB,XMTEXT,XMY
        S COUNT=0,XMDUZ="CPRS PACKAGE",XMTEXT="TEXT("
        S XMSUB="Version "_$P($T(VERSION),";;",2)_" Installed"
        F I="G.CPRS GUI INSTALL@ISC-SLC.VA.GOV",DUZ S XMY(I)=""
        ;
        S X=$P($T(VERSION),";;",2)
        D LINE("Version "_X_" has been installed.")
        D LINE(" ")
        D LINE("Install complete:  "_$$FMTE^XLFDT($$NOW^XLFDT()))
        ;
        D ^XMD
        Q
        ;
CLRDFTD ;
        N DA,DR,DIE
        S DA=$O(^ORD(100.98,"B","INPATIENT MEDICATIONS","")) Q:DA'>0
        I +$P($G(^ORD(100.98,DA,0)),U,4)'>0 Q
        S DIE="^ORD(100.98,",DR="4///@" D ^DIE
        Q
VITREG  ; Register Vitals RPC
        D ADDRPCS^GMV3PST ;call tag from vitals patch post init to register
        Q
        ;
MAGREG1 ; Register Imaging RPC if MAG*3.0*7 installed (DBIA 4526)
        D INSERT("OR CPRS GUI CHART","MAG4 REMOTE IMPORT")
        Q
        ;
MAGREG2 ; Register Imaging RPCS if MAG*3.0*37 installed (DBIA 4528/4530)
        D INSERT("OR CPRS GUI CHART","MAG IMPORT CHECK STATUS")
        D INSERT("OR CPRS GUI CHART","MAG IMPORT CLEAR STATUS")
        Q
        ;
LINE(DATA)      ; set text into array
        S COUNT=COUNT+1
        S TEXT(COUNT)=DATA
        Q
        ;
INSERT(OPTION,RPC)      ; Call FM Updater with each RPC
        ; Input  -- OPTION   Option file (#19) Name field (#.01)
        ;           RPC      RPC sub-file (#19.05) RPC field (#.01)
        ; Output -- None
        N FDA,FDAIEN,ERR,DIERR
        S FDA(19,"?1,",.01)=OPTION
        S FDA(19.05,"?+2,?1,",.01)=RPC
        D UPDATE^DIE("E","FDA","FDAIEN","ERR")
        Q
        ;
SENDDLG(ANAME)  ; Return true if the current order dialog should be sent
        I ANAME="LR OTHER LAB TESTS" Q 1
        I ANAME="OR GTX STUDY REASON" Q 1
        I ANAME="RA OERR EXAM" Q 1
        I ANAME="PSH OERR" Q 1
        I ANAME="PSJI OR PAT FLUID OE" Q 1
        I ANAME="OR GTX IV TYPE" Q 1
        I ANAME="PSJ OR PAT OE" Q 1
        I ANAME="PSO OERR" Q 1
        I ANAME="PSO SUPPLY" Q 1
        I ANAME="PS MEDS" Q 1
        I ANAME="OR GTX ADMIN TIMES" Q 1
        I ANAME="OR GTX SCHEDULE TYPE" Q 1
        I ANAME="FHW7" Q 1
        I ANAME="FHW2" Q 1
        I ANAME="FHW1" Q 1
        I ANAME="OR GTX UNITS" Q 1
        Q 0
        ;
DLGBULL ; send bulletin about modified dialogs <on first install>
        N I,ORD
        F I="PSH OERR","PSJI OR PAT FLUID OE","FHW2","FHW7","RA OERR EXAM","LR OTHER LAB TESTS","PSJ OR PAT OE","PSO OERR","PSO SUPPLY","PS MEDS" S ORD(I)=""
        D EN^ORYDLG(243,.ORD)
        Q
        ;
VERSION ;;27.77
        ;
NOTIF   ; DO NOT REMOVE WITH VBECS - rename notif 47 (MEDICATIONS EXPIRING)
        S $P(^ORD(100.9,47,0),U)="MEDICATIONS EXPIRING - INPT"
        K ^ORD(100.9,"B")
        S DIK="^ORD(100.9,",DIK(1)=".01^B" D ENALL^DIK
        K DIK
        Q
        ;
PARAM   ; DO NOT REMOVE WITH VBECS - main (initial) parameter transport routine
        ; MOVED TO ORY243R - ROUTINE MAXED OUT - 10/02/07 - RV
        D PARAM^ORY243R
        Q
BULLMG  ;
        N MGIEN,FDA,ORERR
        S MGIEN=$$FIND1^DIC(3.8,,"MX","OR DRUG ORDER CANCELLED")
        S FDA(3.6,"?1,",.01)="OR DRUG ORDER CANCELLED"
        S FDA(3.62,"+2,?1,",.01)="OR DRUG ORDER CANCELLED"
        D UPDATE^DIE("E","FDA","",.ORERR)
        Q
FLAGORD ;def reasons flagged ords
        N CNT,LST
        D GETLST^XPAR(.LST,"ALL","OR FLAGGED ORD REASONS","I")
        S CNT=$O(LST(""),-1)
        Q:CNT>0
        D EN^XPAR("SYS","OR FLAGGED ORD REASONS",CNT,"Med renewal request")
        S CNT=CNT+1
        D EN^XPAR("SYS","OR FLAGGED ORD REASONS",CNT,"Order request")
        S CNT=CNT+1
        D EN^XPAR("SYS","OR FLAGGED ORD REASONS",CNT,"Order needing clarification")
        Q
MHDLL   ;update MH message parameter
        D EN^XPAR("SYS","OR USE MH DLL",,1)
        Q
DDEDIT  ;Remove field 80 from file 100
        ;call to EN^DIU2 where DIU = the subfile number
        ;DIU(0)="S", The "S" flag indicates subfile DD is to be deleted
        N DIU S DIU=100.04,DIU(0)="S" D EN^DIU2
        Q
STS     ;DC status desc
        K ^ORD(100.01,1,1)
        S ^ORD(100.01,1,1,0)="^^1^1^3070625^^^^",^(1,0)="Orders that have been explicitly stopped."
        Q
        ;
B       ; B xref new-style
        Q:'$O(^ORD(101.41,"B","OR GTX PRE-OP SCHEDULED DATE/T",0))  ;done
        N ORI,ORY,ORX S ORI=0
        F  S ORI=$O(^DD(101.41,.01,1,ORI)) Q:ORI<1  S ORY=$G(^(ORI,0)) I ORY="101.41^B" D DELIX^DDMOD(101.41,.01,ORI,"K") Q  ;DBIA #1412
        S ORX("FILE")=101.41,ORX("ROOT FILE")=101.41,ORX("NAME")="B"
        S ORX("TYPE")="R",ORX("USE")="LS",ORX("EXECUTION")="F",ORX("ACTIVITY")="IR"
        S ORX("SHORT DESCR")="Regular B index using full field length"
        S ORX("VAL",1)=.01,ORX("VAL",1,"SUBSCRIPT")=1,ORX("VAL",1,"LENGTH")=63
        D CREIXN^DDMOD(.ORX,"S",.ORY) ;DBIA #2916
        Q
        ;
UPDTALRT        ; AP Alerts
        N I
        F I=1:1:3  D
        . N DIC,DA,X,DIE,DR
        . S DIC="^ORD(100.9,",DIC(0)="BIXZ"
        . S X=$S(I=1:"MAMMOGRAM RESULTS",I=2:"PAP SMEAR RESULTS",1:"ANATOMIC PATHOLOGY RESULTS")
        . D ^DIC I Y=-1 K DIC Q
        . S DIE=DIC,DR=".06///"_$S(I=1:"RPTRAD2",I=2:"RPTAP",1:"RPTAP")_";5///REPORT",DA=+Y
        . D ^DIE K DIE,DIC,DR,DA,Y
        Q
        ;
ORWOD   ; Med QO Correction
        D INSTALL^ORWOD  ;Run quick order report and send to installers mail box
        Q
PARVAL  ;Set Param Val
        D EN^XPAR("PKG","ORWRP REPORT LAB LIST",42,"@")
        Q
