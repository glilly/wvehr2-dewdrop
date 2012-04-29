HLOSITE ;ALB/CJM/OAK/PIJ-HL7 - API for getting site parameters ;07/21/2008
        ;;1.6;HEALTH LEVEL SEVEN;**126,138**;Oct 13, 1995;Build 34
        ;
SYSPARMS(SYSTEM)        ;Gets system parameters from file 779.1
        ;Input: none
        ;Output:
        ;
        N NODE,LINK
        S NODE=$G(^HLD(779.1,1,0))
        S SYSTEM("DOMAIN")=$P(NODE,"^")
        S SYSTEM("STATION")=$P(NODE,"^",2)
        S SYSTEM("PROCESSING ID")=$P(NODE,"^",3)
        S SYSTEM("MAXSTRING")=$P(NODE,"^",4)
        I 'SYSTEM("MAXSTRING") D
        .N OS S OS=^%ZOSF("OS")
        .S SYSTEM("MAXSTRING")=$S(OS["OpenM":512,OS["DSM":512,1:256)
        S SYSTEM("HL7 BUFFER")=$P(NODE,"^",5)
        S:'SYSTEM("HL7 BUFFER") SYSTEM("HL7 BUFFER")=15000
        S SYSTEM("USER BUFFER")=$P(NODE,"^",6)
        S:'SYSTEM("USER BUFFER") SYSTEM("USER BUFFER")=5000
        S SYSTEM("NORMAL PURGE")=$P(NODE,"^",7)
        I 'SYSTEM("NORMAL PURGE") S SYSTEM("NORMAL PURGE")=36
        S SYSTEM("ERROR PURGE")=$P(NODE,"^",8)
        I 'SYSTEM("ERROR PURGE") S SYSTEM("ERROR PURGE")=7
        S LINK=$P(NODE,"^",10)
        S:LINK SYSTEM("PORT")=$$PORT^HLOTLNK(LINK)
        S:'$G(SYSTEM("PORT")) SYSTEM("PORT")=$S(SYSTEM("PROCESSING ID")="P":5001,1:5026)
        Q
        ;
INC(VARIABLE,AMOUNT)    ;
        ;Increments VARIABLE by AMOUNT, using $I if available, otherwise by locking.
        ;
        N OS
        ;if HLCSTATE has been defined, then we have already checked the OS, so use it.
        I $D(HLCSTATE("SYSTEM","OS")) D
        .S OS=HLCSTATE("SYSTEM","OS")
        E  D
        .S OS=^%ZOSF("OS")
        I '$G(AMOUNT) S AMOUNT=1
        I (OS["OpenM")!(OS["DSM")!(OS["CACHE") Q $I(@VARIABLE,AMOUNT)
        L +VARIABLE:100
        S @VARIABLE=@VARIABLE+AMOUNT
        L -VARIABLE
        Q @VARIABLE
        ;
COUNT778()      ;
        ;This function returns the # of records in file 778.
        N COUNT,IEN
        S (COUNT,IEN)=0
        F  S IEN=$O(^HLB(IEN)) Q:'IEN  S COUNT=COUNT+1
        Q COUNT
COUNT777()      ;
        ;This function returns the # of records in file 777.
        N COUNT,IEN
        S (COUNT,IEN)=0
        F  S IEN=$O(^HLA(IEN)) Q:'IEN  S COUNT=COUNT+1
        Q COUNT
        ;
UPDCNTS ;update the record counts for file 777,778
        N COUNT
        S COUNT=$$COUNT777^HLOSITE
        S $P(^HLA(0),"^",4)=COUNT
        S ^HLTMP("FILE 777 RECORD COUNT")=COUNT_"^"_$$NOW^XLFDT
        S COUNT=$$COUNT778^HLOSITE
        S $P(^HLB(0),"^",4)=COUNT
        S ^HLTMP("FILE 778 RECORD COUNT")=COUNT_"^"_$$NOW^XLFDT
        Q
        ;;HL*1.6*138 start PIJ 10/26/2007
RCNT(ST)        ;This section sets or reads the recount flag.
        ;; When ST="S" Flag is set
        ;; When ST="U" Flag is unset
        I $G(ST)="S" S $P(^HLD(779.1,1,0),"^",11)=1
        I $G(ST)="U" S $P(^HLD(779.1,1,0),"^",11)=0
        Q $P($G(^HLD(779.1,1,0)),"^",11)
        ;;HL*1.6*138 end
OLDPURGE()      ;returns the retention time in days for unsent messages
        N TIME
        S TIME=$P($G(^HLD(779.1,1,0)),"^",12)
        Q $S(TIME:TIME,1:45)
