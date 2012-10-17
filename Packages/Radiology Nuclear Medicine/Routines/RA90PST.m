RA90PST ;HCIOFO/SG - PATCH RA*5*90 INSTALLATION CODE ; 4/3/08 10:10am
        ;;5.0;Radiology/Nuclear Medicine;**90**;Mar 16, 1998;Build 20
        ;
        Q
        ;
POST    ;
        N IEN,IN,MSG,NAME,RAFDA,RAMSG
        D BMES^RAKIDS("Updating records of file #79.7...")
        F NAME="RA-PSCRIBE-TCP","RA-TALKLINK-TCP","RA-SCIMAGE-TCP","RA-RADWHERE-TCP"  D  D MES^RAKIDS(MSG)
        . S MSG=$$LJ^XLFSTR(NAME,20)
        . S IEN=$$FIND1^DIC(79.7,,"X",NAME,"B",,"RAMSG")
        . I IEN'>0  S MSG=MSG_$S(IEN=0:"Not found",1:"Error (FIND1^DIC)")  Q
        . S RAFDA(79.7,IEN_",",1.3)="S"  ; APPLICATION TYPE
        . D FILE^DIE(,"RAFDA","RAMSG")
        . S MSG=MSG_$S($G(DIERR):"Error (FILE^DIE)",1:"Ok")
        Q
