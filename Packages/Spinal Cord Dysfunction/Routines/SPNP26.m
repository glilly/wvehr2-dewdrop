SPNP26  ;ALB/CJM; Pre-Install for SPN*2.0*26
        ;;2.0;Spinal Cord Dysfunction;**26**;01/02/97;Build 7
        ;
CHECK   ;
        ;
        I '$O(^DIC(4.2,"B","Q-FMZ.MED.VA.GOV",0)) D ABORT
        Q
ABORT   ;
        S XPDABORT=1
        D BMES^XPDUTL("Please follow the instructions in patch XM*DBA*174 for installing the")
        D MES^XPDUTL("Q-FMZ.MED.VA.GOV domain before installing patch SPN*2.0*26.")
        Q
        ;
RESEED  ;entry point to queue the reseeding
        N ZTIO,COMPLETE
        S COMPLETE=$G(^XTMP("SPN*2.0*26 RESEEDING","COMPLETED"))
        I COMPLETE W !,"The reseeding was already completed on ",COMPLETE,"!" W !,"If you need to reseed again the old results must be cleared first." Q
         
        S ZTIO=""
        S ZTRTN="AUTO^SPNP26",ZTDESC="SPN RESEEDING BY PATCH SPN*2.0*26"
        D ^%ZTLOAD
        W !,$S($D(ZTSK):"REQUEST QUEUED; TASK="_ZTSK,1:"REQUEST CANCELLED")
        Q
        ;
AUTO    ;
        N SPNARY,SPIFN
        S SPARY="^XTMP(""SPN*2.0*26 RESEEDING"")"
        I $G(@SPARY@("COMPLETED")) Q
        S @SPARY@(0)=$$FMADD^XLFDT($$DT^XLFDT,180)_"^"_$$DT^XLFDT_"^Spinal Cord Dysfunction Reseeding Results"
        S SPNIFN=+$G(@SPARY@("LAST IEN"))
        F  S SPNIFN=$O(^SPNL(154,SPNIFN)) Q:(SPNIFN="")!('+SPNIFN)  D
        .N SPNCHK
        .D CHK^SPNHL7(SPNIFN) I $D(SPNCHK) D AUTO^SPNHL71 S @SPARY@("TOTAL")=1+$G(@SPARY@("TOTAL"))
        .S @SPARY@("LAST IEN")=SPNIFN
        S @SPARY@("COMPLETED")=$$NOW^XLFDT
        D ALERT($G(@SPARY@("TOTAL")))
        Q
        ;
ALERT(COUNT)    ;
        N XMY,XMTEXT,XMSUB,SITE,DIFROM,TEXT
        S SITE=$$SITE^VASITE()
        S TEXT(1)="Completed reseeding by patch SPN*2.0*26"
        S TEXT(2)="  Site:   "_$P(SITE,"^",2)_" #"_$P(SITE,"^",3)
        S TEXT(2)="  Total Patient Count: "_COUNT
        S XMSUB="RESEEDING COMPLETED@"_$P(SITE,"^",2)_" #"_$P(SITE,"^",3)
        S XMDUZ=.5
        S XMTEXT="TEXT("
        S XMY("G.TESTINGTESTING@PUGET-SOUND.MED.VA.GOV")=""
        S XMY("G.SPNL SCD COORDINATOR")=""
        D ^XMD
        Q
POST    ; post-install, edits the mail group
        N GROUP,IEN,SUBIEN
        S GROUP="SCD-NAT-DATABASE"
        S IEN=$O(^XMB(3.8,"B",GROUP,0))
        I 'IEN S XPDABORT=1 D BMES^XPDUTL("Failed to add XXX@Q-FMZ.MED.VA.GOV as a remote memeber to the SCD-NAT-DATABASE mail group") Q
        S SUBIEN=$O(^XMB(3.8,IEN,6,"B","XXX@Q-SCD.MED.VA.GOV",0))
        I SUBIEN D
        .N DA
        .S DA=SUBIEN,DA(1)=IEN D DELETE(3.812,.DA)
        S SUBIEN=$O(^XMB(3.8,IEN,6,"B","XXX@Q-FMZ.MED.VA.GOV",0))
        I 'SUBIEN D
        .N DA,DATA,ERROR
        .S DA(1)=IEN
        .S DATA(.01)="XXX@Q-FMZ.MED.VA.GOV"
        .I '$$ADD(3.812,.DA,.DATA,.ERROR) S XPDABORT=1 D BMES^XPDUTL("Failed to add XXX@Q-FMZ.MED.VA.GOV as a remote memeber to the SCD-NAT-DATABASE mail group")
        Q
        ;
ADD(FILE,DA,DATA,ERROR,IEN)     ;
        N FDA,FIELD,IENA,IENS,ERRORS
        S DA="+1"
        S IENS=$$IENS^DILF(.DA)
        S FIELD=0
        F  S FIELD=$O(DATA(FIELD)) Q:'FIELD  D
        .S FDA(FILE,IENS,FIELD)=$G(DATA(FIELD))
        I $G(IEN) S IENA(1)=IEN
        D UPDATE^DIE("","FDA","IENA","ERRORS(1)")
        I +$G(DIERR) D
        .S ERROR=$G(ERRORS(1,"DIERR",1,"TEXT",1))
        .S IEN=""
        E  D
        .S IEN=IENA(1)
        .S ERROR=""
        D CLEAN^DILF
        S DA=IEN
        Q IEN
        ;
DELETE(FILE,DA,ERROR)   ;Delete an existing record.
        N DATA
        S DATA(.01)="@"
        Q $$UPD(FILE,.DA,.DATA,.ERROR)
        Q
UPD(FILE,DA,DATA,ERROR) ;File data into an existing record.
        I '$G(DA) S ERROR="IEN OF RECORD TO BE UPDATED NOT SPECIFIED" Q 0
        S IENS=$$IENS^DILF(.DA)
        S FIELD=0
        F  S FIELD=$O(DATA(FIELD)) Q:'FIELD  D
        .S FDA(FILE,IENS,FIELD)=$G(DATA(FIELD))
        D FILE^DIE("","FDA","ERRORS(1)")
        I +$G(DIERR) D
        .S ERROR=$G(ERRORS(1,"DIERR",1,"TEXT",1))
        E  D
        .S ERROR=""
        ;
        D CLEAN^DILF
        Q $S(+$G(DIERR):0,1:1)
