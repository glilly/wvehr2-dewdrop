PRPFMR3 ;BAYPINES/MJE  VPFS APP PFUNDS FILES CHANGE ATTRIBUTES ;02/22/06
        ;;3.0;PATIENT FUNDS - POST MIGRATION 1.0;**17**;JUNE 1, 1989
        ;ENTRY AT LINETAG ONLY
        Q
CHGATRB ; CHANGE THE WRITE AND DELETE ATTRIBUTES FOR PATIENT FUNDS FILES
        ;
        N SECURITY,FILE,PRPFATRB,FDA,ERRNUM,ERRLIST
        ;**** CHANGE GLOBAL FILE ATTRIBS FOR PFUNDS FILES
        S SECURITY("LAYGO")="^"
        S SECURITY("WR")="^"
        S SECURITY("DEL")="^"
        F FILE=470,470.1,470.2,470.3,470.5,470.6,470.9 D
        . D FILESEC^DDMOD(FILE,.SECURITY)
        ;**** CHANGE FILEMAN ATTRIBS FOR PFUNDS FILES PER PFUNDS USER IN AFOF NODE
        I $D(^VA(200,"AFOF")) D
        . F FILE=470,470.1,470.2,470.3,470.5,470.6,470.9 D
        .. N WHO
        .. S WHO=0
        .. F  S WHO=$O(^VA(200,"AFOF",FILE,WHO)) Q:'WHO  D
        ... N IENS
        ... S IENS=FILE_","_WHO_","
        ... S FDA(200.032,IENS,2)=0
        ... S FDA(200.032,IENS,3)=0
        ... S FDA(200.032,IENS,5)=0
        ... D FILE^DIE("","FDA","PFERR")
        ;**** CHANGE DATA DICTIONARY .O1 ATTRIB FOR GLOBAL PFUNDS FILES
        F FILE=470,470.1,470.2,470.3,470.5,470.6,470.9 D
        . S ^DD(FILE,.01,"DEL",1,0)="D EN^DDIOL(""Deletions are not allowed due to PFOP Migration!!"","""",""!?5,$C(7)"") I 1"
        . S ^DD(FILE,.01,"LAYGO",1,0)="D:'$G(XUMF) EN^DDIOL(""Additions are not allowed due to PFOP Migration!!"","""",""!?5,$C(7)"") I +$G(XUMF)"
        W !,""
        W !," ************ RESULTS FOR CHANGE ATTRIBUTES PFUNDS FILES **************"
        S PRPFATRB=0
        F FILE=470,470.1,470.2,470.3,470.5,470.6,470.9 D
        . S:^DIC(FILE,0,"WR")="^"&(^DIC(FILE,0,"DEL")="^")&(^DIC(FILE,0,"LAYGO")="^") PRPFATRB=PRPFATRB+1
        I (+PRPFATRB)=7&('$D(PFERR("DIERR"))) D
        . W !," PATIENT FUNDS FILE ACCESS HAS BEEN SUCCESSFULLY UPDATED!"
        I (+PRPFATRB)'=7!($D(PFERR("DIERR"))) D
        . W !," ERROR: PATIENT FUNDS FILE ACCESS HAS -NOT- BEEN SUCCESSFULLY UPDATED!!"
        . I $D(PFERR("DIERR")) D
        .. S ERRNUM=$P(PFERR("DIERR"),"^",1)
        .. F ERRLIST=1:1:ERRNUM W !,PFERR("DIERR",ERRNUM,"TEXT",1)
        W !," **********************************************************************"
        W !,""
        K PRPFATRB,SECURITY,PRPFATRB,FDA,FILE,ERRNUM,ERRLIST
