CWMAPP01        ; ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        ;;
LOAD    ; load data into ^TMP (expects ROOT to be defined)
        S I=1 F  S REF=$T(DATA+I) Q:REF=""  S VAL=$T(DATA+I+1) D
        . S I=I+2,REF=$P(REF,";",3,999),VAL=$P(VAL,";",3,999)
        . S @(ROOT_REF)=VAL
        Q
DATA    ; parameter data
        ;;2,"KEY")
        ;;CWMA STARTUP NEW MAIL^1
        ;;2,"VAL")
        ;;True
        ;;4,"KEY")
        ;;CWMA GENERAL MD COL^1
        ;;4,"VAL")
        ;;0,5
        ;;5,"KEY")
        ;;CWMA GENERAL MD COL^2
        ;;5,"VAL")
        ;;1,25
        ;;6,"KEY")
        ;;CWMA GENERAL MD COL^3
        ;;6,"VAL")
        ;;2,60
        ;;7,"KEY")
        ;;CWMA GENERAL MD COL^4
        ;;7,"VAL")
        ;;3,250
        ;;8,"KEY")
        ;;CWMA GENERAL MD COL^5
        ;;8,"VAL")
        ;;4,200
        ;;9,"KEY")
        ;;CWMA GENERAL MD COL^6
        ;;9,"VAL")
        ;;5,47
        ;;18,"KEY")
        ;;CWMA SOUND ENABLED^1
        ;;18,"VAL")
        ;;False
        ;;40,"KEY")
        ;;CWMA GENERAL MD COL^7
        ;;40,"VAL")
        ;;6,38
        ;;42,"KEY")
        ;;CWMA GENERAL CMA STYLE^1
        ;;42,"VAL")
        ;;Use Menu
        ;;43,"KEY")
        ;;CWMA GENERAL MPD TAB^1
        ;;43,"VAL")
        ;;Recipients
        ;;44,"KEY")
        ;;CWMA GENERAL NMP FREQ^1
        ;;44,"VAL")
        ;;5
        ;;45,"KEY")
        ;;CWMA GENERAL MD COUNT^1
        ;;45,"VAL")
        ;;8
        ;;46,"KEY")
        ;;CWMA GENERAL PRINTMODE^1
        ;;46,"VAL")
        ;;Vista
        ;;66,"KEY")
        ;;CWMA ALLOW ATTACHMENTS^1
        ;;66,"VAL")
        ;;True
