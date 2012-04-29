CWMAILE ;INDPLS/PLS- DELPHI VISTA MAIL SERVER CONT'D ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        Q   ;ROUTINE CAN'T BE CALLED DIRECTLY
        ;
GETPKPM(CWDAT)  ;get package parameters and return in CWDAT
        ;called by CWMAILD
        ;This API uses the PRECEDENCE field of each parameter
        N CWCNT,CWLP
        S CWCNT=2
        S CWDAT(CWCNT)="[Sound]",CWCNT=CWCNT+1
        S CWDAT(CWCNT)="Sound="_+$$GET^XPAR("ALL","CWMA SOUND ENABLED"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="Message Open="_$$GET^XPAR("ALL","CWMA SOUND MESSAGE OPEN"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="Message Close="_$$GET^XPAR("ALL","CWMA SOUND MESSAGE CLOSE"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="New Mail="_$$GET^XPAR("ALL","CWMA SOUND NEW MAIL"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="Priority Mail="_$$GET^XPAR("ALL","CWMA SOUND PRIORITY MAIL"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="[StartUp]",CWCNT=CWCNT+1
        S CWDAT(CWCNT)="StartUpNewMail="_$$GET^XPAR("ALL","CWMA STARTUP NEW MAIL",1,"E"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="StartUpOpenMailBox="_$$GET^XPAR("ALL","CWMA STARTUP OPEN MAIL BOX",1,"E"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="StartUpOpenMailBoxName="_$$GET^XPAR("ALL","CWMA STARTUP MAIL BOX NAME"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="[General]",CWCNT=CWCNT+1
        S CWDAT(CWCNT)="CreateMessageAttributes="_$$GET^XPAR("ALL","CWMA GENERAL CMA STYLE"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="MessagePropertiesDefaultTab="_$$GET^XPAR("ALL","CWMA GENERAL MPD TAB"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="NewMailPollingFrequency="_$$GET^XPAR("ALL","CWMA GENERAL NMP FREQ"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="MessageDisplayCount="_$$GET^XPAR("ALL","CWMA GENERAL MD COUNT"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="DefaultVistaPrinter="_$$GET^XPAR("ALL","CWMA GENERAL VISTA PRT"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="DefaultPrintMode="_+$$GET^XPAR("ALL","CWMA GENERAL PRINTMODE"),CWCNT=CWCNT+1
        S CWDAT(CWCNT)="MessageDisplayColumns="_$$GETCOL,CWCNT=CWCNT+1  ;get column information
        S CWDAT(CWCNT)="AllowAttachments="_$$GET^XPAR("ALL","CWMA ALLOW ATTACHMENTS",1,"E"),CWCNT=CWCNT+1
        S CWDAT(-9900)=CWCNT
        Q $O(CWDAT(1))
        ;
GETCOL()        ;retrieve column information for message display
        N CWLP,CWDAA,CWTMP
        S CWTMP=""
        D GETLST^XPAR(.CWDAA,"ALL","CWMA GENERAL MD COL")
        S CWLP=0 F  S CWLP=$O(CWDAA(CWLP)) Q:CWLP<1  D
        . S CWTMP=CWTMP_$P(CWDAA(CWLP),U,2)_";"
        Q CWTMP
        ;
GETPRM(CWVAR)   ;lookup parameter for a given variable
        ;returns set procedure|parameter
        ; set procedure: 0=single instance, 1=multiple instances
        Q:CWVAR="Sound" "0|CWMA SOUND ENABLED"
        Q:CWVAR="Message Open" "0|CWMA SOUND MESSAGE OPEN"
        Q:CWVAR="Message Close" "0|CWMA SOUND MESSAGE CLOSE"
        Q:CWVAR="Priority Mail" "0|CWMA SOUND PRIORITY MAIL"
        Q:CWVAR="New Mail" "0|CWMA SOUND NEW MAIL"
        Q:CWVAR="StartUpNewMail" "0|CWMA STARTUP NEW MAIL"
        Q:CWVAR="StartUpOpenMailBox" "0|CWMA STARTUP OPEN MAIL BOX"
        Q:CWVAR="StartUpOpenMailBoxName" "0|CWMA STARTUP MAIL BOX NAME"
        Q:CWVAR="CreateMessageAttributes" "0|CWMA GENERAL CMA STYLE"
        Q:CWVAR="MessagePropertiesDefaultTab" "0|CWMA GENERAL MPD TAB"
        Q:CWVAR="NewMailPollingFrequency" "0|CWMA GENERAL NMP FREQ"
        Q:CWVAR="MessageDisplayCount" "0|CWMA GENERAL MD COUNT"
        Q:CWVAR="DefaultVistaPrinter" "0|CWMA GENERAL VISTA PRT"
        Q:CWVAR="DefaultPrintMode" "0|CWMA GENERAL PRINTMODE"
        Q:CWVAR="MessageDisplayColumns" "1|CWMA GENERAL MD COL"
        Q ""
        ;
