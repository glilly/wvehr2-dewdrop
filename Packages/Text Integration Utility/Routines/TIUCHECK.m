TIUCHECK        ;SLC/AJB,AGP TIU Objects and Templare Fields API;25-MAR-2009
        ;;1.0;TEXT INTEGRATION UTILITIES;**249**;Jun 20, 1997;Build 48
        ;
BLDOBJAR(TIUOUT,TIUIEN) ;
        N TIUNODE
        S TIUNODE=$G(^TIU(8925.1,TIUIEN,0))
        S TIUOUT(TIUIEN,.01)=$P(TIUNODE,U),TIUOUT(TIUIEN,.04)=$P(TIUNODE,U,4)
        S TIUOUT(TIUIEN,.07)=$$GETSTAT(TIUIEN)
        S TIUOUT(TIUIEN,9)=$G(^TIU(8925.1,TIUIEN,9))
        Q
        ;
CANUREMD(TIUIEN)        ;
        N TIUNODE,TIURESLT
        S TIURESLT=0
        I $$PATCH^XPDUTL("PXRM*2.0*12")=0 D  Q TIURESLT
        .S TIUNODE=$G(^PXRMD(801.41,TIUIEN,0))
        .I $P(TIUNODE,U,4)'="R" Q
        .I $P(TIUNODE,U,3)'="" Q
        .S TIURESLT=1
        S TIURESLT=$$ISACTDLG^PXRMDLG6(TIUIEN)
        Q TIURESLT
        ;
GETSTAT(TIUIEN) ;
        N TIUSTIEN
        S TIUSTIEN=$P($G(^TIU(8925.1,TIUIEN,0)),U,7)
        Q $P($G(^TIU(8925.6,TIUSTIEN,0)),U)
        ;
OBJBYIEN(TIUOUT,TIUIEN) ;
        D BLDOBJAR(.TIUOUT,TIUIEN)
        Q
        ;
OBJBYNAM(TIUOUT,TIUNAME)        ;
        I '$D(^TIU(8925.1,"B",TIUNAME)) Q -1
        N TIUIEN
        S TIUIEN=$O(^TIU(8925.1,"B",TIUNAME,"")) I TIUIEN'>0 Q -1
        I '$D(^TIU(8925.1,"AT","O",TIUIEN)) Q -1
        D BLDOBJAR(.TIUOUT,TIUIEN)
        Q TIUIEN
        ;
OBJSTAT(TIUNAME)        ;
        ;Output
        ;   -1 Object does not exist
        ;   0 Object is inactive
        ;   1 Object exist is active
        ;
        I '$D(^TIU(8925.1,"B",TIUNAME)) Q -1
        N TIUIEN
        S TIUIEN=$O(^TIU(8925.1,"B",TIUNAME,"")) I TIUIEN'>0 Q -1
        I '$D(^TIU(8925.1,"AT","O",TIUIEN)) Q -1
        I $$GETSTAT(TIUIEN)="INACTIVE" Q 0
        Q 1
        ;
TEMPSTAT(TIUNAME)       ;
        ;Output
        ;   -1 Template Field does not exist
        ;   0  Template Field is inactive
        ;   1 Template Field exist and is active
        ;
        I '$D(^TIU(8927.1,"B",TIUNAME)) Q -1
        N TIUIEN
        S TIUIEN=$O(^TIU(8927.1,"B",TIUNAME,"")) I TIUIEN'>0 Q -1
        I $P($G(^TIU(8927.1,TIUIEN,0)),U,3)=1 Q 0
        Q 1
        ;
