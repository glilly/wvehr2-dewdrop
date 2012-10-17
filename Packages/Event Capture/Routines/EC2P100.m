EC2P100 ;ALB/MRY - PATCH EC*2.0*100 Post-Init Rtn ;01/07/2009
        ;;2.0; EVENT CAPTURE ;**100**;8 May 96;Build 21
        ;
ENV     ;environment check
        S XPDABORT=""
        D PROGCHK(.XPDABORT) ;checks programmer variables
        I XPDABORT="" K XPDABORT
        Q
        ;
PROGCHK(XPDABORT)       ;checks for necessary programmer variables
        ;
        I '$G(DUZ)!($G(DUZ(0))'="@")!('$G(DT))!($G(U)'="^") DO
        . D BMES^XPDUTL("******")
        . D MES^XPDUTL("Your programming variables are not set up properly.")
        . D MES^XPDUTL("Installation aborted.")
        . D MES^XPDUTL("******")
        . S XPDABORT=2
        Q
        ;
POST    ;
OPTION  ;move [ec night] into [ec pce feed], if exists.  Then, disable.
        D RENOPT("EC NIGHT","EC PCE FEED")
        F ECMENU="EC NIGHT","EC PCE FEED" D DISOPT(ECMENU)
        ;
        ;add users of the ECXMGR security key to ECMGR mailgroup.
        D MAILGP
        ;add Last Used, Table Printer, & Visits objects
        D VOBS
        Q
        ;
RENOPT(ECOLD,ECNEW)     ;rename option
        ;
        ;  Input:
        ;    ECOLD - original option name
        ;    ECNEW - new option name
        ;
        ;
        I +$$LKOPT^XPDMENU(ECNEW)>0 Q  ;quit if new exists
        I '+$$LKOPT^XPDMENU(ECOLD) Q  ;quit if old doesn't exit
        I $G(ECOLD)'="",$G(ECNEW)'="",+$$LKOPT^XPDMENU(ECOLD)>0 D
        . D RENAME^XPDMENU(ECOLD,ECNEW)
        Q
DISOPT(MENU)    ;Disable Options
        I '+$$LKOPT^XPDMENU(MENU) Q
        N ECMSG
        K ECMSG
        S ECMSG(1)=" "
        S ECMSG(2)=">>> Disabling ["_MENU_"] option"
        D MES^XPDUTL(.ECXMSG)
        ;Disable menu option
        D OUT^XPDMENU(MENU,"MENU OPTION NO LONGER USED")
        D BMES^XPDUTL("   "_MENU_"   **  Menu option disabled  **")
        Q
MAILGP  ;add users of ECXMGR key to ECMGR mailgroup
        D BMES^XPDUTL(">>> Adding users with the ECXMGR key to ECMGR Mailgroup...")
        N DIC,X,DA,ECDUZ
        S DIC="^XMB(3.8,",DIC(0)="X",X="ECMGR" D ^DIC
        S DA(1)=+Y,DIC=DIC_DA(1)_",1,",DIC("P")=$P(^DD(3.8,2,0),"^",2),DIC(0)="L"
        S ECDUZ=0 F  S ECDUZ=$O(^XUSEC("ECXMGR",ECDUZ)) Q:'ECDUZ  D
        . S X=$$GET1^DIQ(200,ECDUZ,.01) D ^DIC
        . I +$P(Y,"^",3) D MES^XPDUTL("   "_X_" added.")
        Q
        ;;
        ;;
VOBS    ;;Install utility objects
        D BMES^XPDUTL("Installing Event Capture Object Factory Parameters")
        ;;
        D EN^XPAR("PKG","ECOB CONSTRUCTOR","EC OBU UTILITY","CREATE.ECOBU(NAME)")
        D EN^XPAR("PKG","ECOB DESTRUCTOR","EC OBU UTILITY","DESTROY.ECOBU(HANDLE)")
        D EN^XPAR("PKG","ECOB METHOD","EC OBU UTILITY","METHOD.ECOBU(.RESULT,ARGUMENT)")
        D MES^XPDUTL("EC OBU UTILITY... published")
        ;;
        D EN^XPAR("PKG","ECOB CONSTRUCTOR","EC OBU UTILITY LIST","CREATE.ECOBUL(NAME)")
        D EN^XPAR("PKG","ECOB DESTRUCTOR","EC OBU UTILITY LIST","DESTROY.ECOBUL(HANDLE)")
        D EN^XPAR("PKG","ECOB METHOD","EC OBU UTILITY LIST","METHOD.ECOBUL(.RESULT,ARGUMENT)")
        D MES^XPDUTL("EC OBU UTILITY LIST... published")
        ;;
        D EN^XPAR("PKG","ECOB CONSTRUCTOR","EC OBU LAST USED","CREATE.ECOB31(NAME)")
        D EN^XPAR("PKG","ECOB DESTRUCTOR","EC OBU LAST USED","DESTROY.ECOB31(HANDLE)")
        D EN^XPAR("PKG","ECOB METHOD","EC OBU LAST USED","METHOD.ECOB31(.RESULT,ARGUMENT)")
        D MES^XPDUTL("EC OBU LAST USED... published")
        ;;
        D EN^XPAR("PKG","ECOB CONSTRUCTOR","EC DSS UNIT TABLE","CREATE.ECOB41(NAME)")
        D EN^XPAR("PKG","ECOB DESTRUCTOR","EC DSS UNIT TABLE","DESTROY.ECOB41(HANDLE)")
        D EN^XPAR("PKG","ECOB METHOD","EC DSS UNIT TABLE","METHOD.ECOB41(.RESULT,ARGUMENT)")
        D MES^XPDUTL("EC DSS UNIT TABLE... published")
        ;;
        D EN^XPAR("PKG","ECOB CONSTRUCTOR","EC VISIT","CREATE.ECOBVST(NAME)")
        D EN^XPAR("PKG","ECOB DESTRUCTOR","EC VISIT","DESTROY.ECOBVST(HANDLE)")
        D EN^XPAR("PKG","ECOB METHOD","EC VISIT","METHOD.ECOBVST(.RESULT,ARGUMENT)")
        D MES^XPDUTL("EC VISIT... published")
        ;;
        D EN^XPAR("PKG","ECOB CONSTRUCTOR","EC VISITS","CREATE.ECOBVSTS(NAME)")
        D EN^XPAR("PKG","ECOB DESTRUCTOR","EC VISITS","DESTROY.ECOBVSTS(HANDLE)")
        D EN^XPAR("PKG","ECOB METHOD","EC VISITS","METHOD.ECOBVSTS(.RESULT,ARGUMENT)")
        D MES^XPDUTL("EC VISITS... published")
        ;;
        Q
        ;;
