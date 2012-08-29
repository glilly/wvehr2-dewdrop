HLOPOST ;IRMFO-ALB/CJM -Post-Install routine for HLO;03/24/2004  14:43 ;07/20/2007
        ;;1.6;HEALTH LEVEL SEVEN;**126,134,136,137**;Oct 13, 1995;Build 21
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        N SYSTEM,DATA,VASITE,OLDSITE
        D IDXLINKS
        D SYSPARMS^HLOSITE(.SYSTEM)
        S VASITE=$$SITE^VASITE
        S OLDSITE=$G(^HLCS(869.3,1,0))
        S DATA(.01)=SYSTEM("DOMAIN")
        I DATA(.01)="" D
        .I $P(OLDSITE,"^",2) S DATA(.01)="HL7."_$P($G(^DIC(4.2,$P(OLDSITE,"^",2),0)),"^")
        I DATA(.01)="" D
        .N INST,DOMAIN
        .S INST=$P(VASITE,"^")
        .Q:'INST
        .S DOMAIN=$P($G(^DIC(4,INST,6)),"^")
        .I DOMAIN S DOMAIN=$P($G(^DIC(4.2,DOMAIN,0)),"^") I DOMAIN'="" S DATA(.01)="HL7."_DOMAIN
        I DATA(.01)="" D BMES^XPDUTL("Post-Install failed, system missing INSTITUTION or DOMAIN file entry") Q
        S DATA(.02)=SYSTEM("STATION")
        I DATA(.02)="",$P(OLDSITE,"^",4) S DATA(.02)=$P($G(^DIC(4,$P(OLDSITE,"^",4),99)),"^")
        I DATA(.02)="" S DATA(.02)=$P(VASITE,"^",3)
        S DATA(.03)=$P(OLDSITE,"^",3)
        S DATA(.04)=SYSTEM("MAXSTRING")
        S DATA(.05)=SYSTEM("HL7 BUFFER")
        S DATA(.06)=SYSTEM("USER BUFFER")
        S DATA(.07)=SYSTEM("NORMAL PURGE")
        S DATA(.08)=SYSTEM("ERROR PURGE")
        I $D(^HLD(779.1,1,0)) D
        .N ERROR
        .I '$$UPD^HLOASUB1(779.1,1,.DATA,.ERROR) D BMES^XPDUTL("Post-Install failed -"_$G(ERROR))
        E  D
        .N ERROR
        .I '$$ADD^HLOASUB1(779.1,,.DATA,.ERROR,1) D BMES^XPDUTL("Post-Install failed -"_$G(ERROR))
        Q
IDXLINKS        ;
        ;set the "AC" and "AD" indicies on the HL Logical Link file
        N DIK
        S DIK="^HLCS(870,"
        S DIK(1)=".01^AC^AD^AD1^AD2"
        D ENALL^DIK
        Q
        ;
P134    ;
        N DAILY,STARTUP,IEN,DATA
        S DAILY=$O(^DIC(19,"B","HLO DAILY STARTUP",0))
        I 'DAILY D BMES^XPDUTL("Failed to schedule the HLO DAILY STARTUP option!")
        S STARTUP=$O(^DIC(19,"B","HLO SYSTEM STARTUP",0))
        I 'STARTUP D BMES^XPDUTL("Failed to schedule the HLO SYSTEM STARTUP option!")
        I STARTUP D
        .S IEN=$O(^DIC(19.2,"B",STARTUP,0))
        .S DATA(.01)=STARTUP
        .S DATA(2)=""
        .S DATA(6)=""
        .S DATA(9)=$S($P($G(^HLD(779.1,1,0)),"^",3)="P":"S",1:"")
        .I IEN D
        ..I '$$UPD^HLOASUB1(19.2,IEN,.DATA) D BMES^XPDUTL("Failed to schedule the HLO SYSTEM STARTUP option!")
        .E  D
        ..I '$$ADD^HLOASUB1(19.2,,.DATA) D BMES^XPDUTL("Failed to schedule the HLO SYSTEM STARTUP option!")
        I DAILY D
        .S IEN=$O(^DIC(19.2,"B",DAILY,0))
        .S DATA(.01)=DAILY
        .S DATA(2)=$$NOW^XLFDT
        .S DATA(6)="1D"
        .S DATA(9)=""
        .I IEN D
        ..I '$$UPD^HLOASUB1(19.2,IEN,.DATA) D BMES^XPDUTL("Failed to schedule the HLO DAILY STARTUP option!")
        .E  D
        ..I '$$ADD^HLOASUB1(19.2,,.DATA) D BMES^XPDUTL("Failed to schedule the HLO DAILY STARTUP option!")
        Q
        ;
P136    ;post-install routine for HL*1.6*136
        N ERROR,DIFROM,IEN
        I $P($G(^HLD(779.1,1,0)),"^",3)="P" D
        .D RESCH^XUTMOPT("HLO DAILY STARTUP",$$FMADD^XLFDT($$NOW^XLFDT,,1),,"1D","L",.ERROR)
        .I $G(ERROR)<0 D BMES^XPDUTL("Failed to schedule the HLO DAILY STARTUP option! Please do so manually")
        ; 
        S IEN=$O(^HLD(779.3,"B","PURGE OLD MESSAGES",0))
        Q:'IEN
        S ^HLD(779.3,IEN,0)="PURGE OLD MESSAGES^1^0^2^20^^5^GETWORK^HLOPURGE^DOWORK^HLOPURGE^1^0"
        Q
        ;
P137    ;
        ;move the existing errros to the new structure
        N TYPE
        K ^TMP($J,"HLO ERRORS")
        F TYPE="TF","SE","AE" D
        .M ^TMP($J,"HLO ERRORS",TYPE)=^HLB("ERRORS",TYPE)
        .M ^HLB("ERRORS")=^TMP($J,"HLO ERRORS",TYPE)
        .K ^TMP($J,"HLO ERRORS",TYPE)
        .K ^HLB("ERRORS",TYPE)
        Q
