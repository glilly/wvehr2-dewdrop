XTIDTRM ;BPFO/JRP - API set for VUID-Term/Concepts in VistA ;05/16/2008
        ;;7.3;TOOLKIT;**111**;Apr 25, 1995;Build 2
        ; Per VHA Directive 2004-038, this routine should not be modified.
        ; IA #5078 governs the APIs in this routine
        ; IA #5067 allows this routine to check and traverse ^DD(.
        ;
SETRPLC(FILE,IEN,RPLCMNT)       ; Set replacement term
        N NEXTFILE,NEXTROOT,XTFDA,XTMSG
        I RPLCMNT="" S RPLCMNT="@"
        S NEXTFILE=$$PTR2FILE(FILE)
        I 'NEXTFILE Q 0
        I NEXTFILE=FILE,IEN=RPLCMNT Q 0  ; Don't store ptr to self
        S NEXTROOT=$$ROOT^DILFD(NEXTFILE,"",1)
        I NEXTROOT="" Q 0
        I RPLCMNT'="@",'$D(@NEXTROOT@(RPLCMNT)) Q 0
        S XTFDA(FILE,IEN_",",99.97)=RPLCMNT
        D FILE^DIE("","XTFDA","XTMSG")
        I $D(XTMSG) Q 0
        Q 1
        ;
GETRPLC(FILE,IEN)       ; Get replacement term
        N NEXTIEN,NEXTFILE
        S NEXTFILE=$$PTR2FILE(FILE)
        I 'NEXTFILE Q IEN_";"_FILE
        S NEXTIEN=$$PTR2IEN(FILE,IEN)
        I 'NEXTIEN Q IEN_";"_FILE
        Q NEXTIEN_";"_NEXTFILE
        ;
RPLCMNT(FILE,IEN)       ; Follow pointer trail until it ends
        N NEXTIEN,NEXTFILE
        S NEXTFILE=$$PTR2FILE(FILE)
        I 'NEXTFILE Q IEN_";"_FILE
        S NEXTIEN=$$PTR2IEN(FILE,IEN)
        I 'NEXTIEN Q IEN_";"_FILE
        I NEXTFILE=FILE,NEXTIEN=IEN Q IEN_";"_FILE  ; Trail leads back to self
        Q $$RPLCMNT(NEXTFILE,NEXTIEN)
        ;
RPLCVALS(FILE,IEN,FIELD,FLAGS,OUTARR)   ; Return inherited values for entry
        N RPLCMNT,XTMSG
        S RPLCMNT=$$RPLCMNT(FILE,IEN)
        I RPLCMNT="" Q ""
        D GETS^DIQ(+$P(RPLCMNT,";",2),+RPLCMNT_",",FIELD,FLAGS,OUTARR,"XTMSG")
        I $D(XTMSG) K @OUTARR
        Q RPLCMNT
        ;
RPLCTRL(FILE,IEN,DRCTN,OUTARR)  ; Return replacement trail for entry
        N NEXTIEN,NEXTFILE,RPLCMNT,TERMREF,SCRAP,NEXTROOT
        S DRCTN=$S($G(DRCTN)="":"F",DRCTN="*":"FB",1:DRCTN)
        S TERMREF=IEN_";"_FILE
        I DRCTN["F" D
        . S NEXTFILE=$$PTR2FILE(FILE)
        . I 'NEXTFILE D  Q
        . . S @OUTARR@("BY",TERMREF)=""
        . S NEXTIEN=$$PTR2IEN(FILE,IEN)
        . I 'NEXTIEN D  Q
        . . S @OUTARR@("BY",TERMREF)=""
        . S RPLCMNT=NEXTIEN_";"_NEXTFILE
        . Q:$D(@OUTARR@("BY",TERMREF))
        . S @OUTARR@("BY",TERMREF)=RPLCMNT
        . S @OUTARR@("FOR",RPLCMNT,TERMREF)=""
        . S SCRAP=$$RPLCTRL(NEXTFILE,NEXTIEN,DRCTN,OUTARR)
        I DRCTN["B" D
        . S NEXTFILE=""
        . F  S NEXTFILE=$O(^DD(FILE,0,"PT",NEXTFILE)) Q:'NEXTFILE  D
        . . Q:'$D(^DD(FILE,0,"PT",NEXTFILE,99.97))
        . . S NEXTROOT=$$ROOT^DILFD(NEXTFILE,"",1)
        . . Q:NEXTROOT=""
        . . S NEXTIEN=""
        . . F  S NEXTIEN=$O(@NEXTROOT@("AREPLACETERM",IEN,NEXTIEN)) Q:'NEXTIEN  D
        . . . S RPLCMNT=NEXTIEN_";"_NEXTFILE
        . . . Q:$D(@OUTARR@("BY",RPLCMNT))
        . . . S @OUTARR@("BY",RPLCMNT)=TERMREF
        . . . S @OUTARR@("FOR",TERMREF,RPLCMNT)=""
        . . . S SCRAP=$$RPLCTRL(NEXTFILE,NEXTIEN,DRCTN,OUTARR)
        Q $$RPLCMNT(FILE,IEN)
        ;
RPLCLST(FILE,IEN,DRCTN,STATDATE,STATHST,OUTARR) ; Return replacement list for entry
        N NEXTIEN,NEXTFILE,RPLCMNT,TERMREF,SCRAP,NEXTROOT,COUNTER
        S DRCTN=$S($G(DRCTN)="":"F",DRCTN="*":"FB",1:DRCTN)
        S STATDATE=$S($G(STATDATE)="":$$NOW^XLFDT(),1:STATDATE)
        S STATHST=+$G(STATHST)
        S TERMREF=IEN_";"_FILE
        I DRCTN["F" D
        . S NEXTFILE=$$PTR2FILE(FILE)
        . I 'NEXTFILE D  Q
        . . S SCRAP=$$GETSTAT^XTID(FILE,.01,IEN_",",STATDATE)
        . . S COUNTER=1+$O(@OUTARR@("INDEX"),-1)
        . . S @OUTARR@(COUNTER)=TERMREF_U_$P(SCRAP,U,1)
        . . S @OUTARR@("INDEX",TERMREF)=COUNTER
        . . D STATHIST(FILE,IEN,$NAME(@OUTARR@(COUNTER)))
        . S NEXTIEN=$$PTR2IEN(FILE,IEN)
        . I 'NEXTIEN D  Q
        . . S SCRAP=$$GETSTAT^XTID(FILE,.01,IEN_",",STATDATE)
        . . S COUNTER=1+$O(@OUTARR@("INDEX"),-1)
        . . S @OUTARR@(COUNTER)=TERMREF_U_$P(SCRAP,U,1)
        . . S @OUTARR@("INDEX",TERMREF)=COUNTER
        . . D STATHIST(FILE,IEN,$NAME(@OUTARR@(COUNTER)))
        . S RPLCMNT=NEXTIEN_";"_NEXTFILE
        . Q:$D(@OUTARR@("INDEX",TERMREF))
        . S SCRAP=$$GETSTAT^XTID(FILE,.01,IEN_",",STATDATE)
        . S COUNTER=1+$O(@OUTARR@("INDEX"),-1)
        . S @OUTARR@(COUNTER)=TERMREF_U_$P(SCRAP,U,1)
        . S @OUTARR@("INDEX",TERMREF)=COUNTER
        . D STATHIST(FILE,IEN,$NAME(@OUTARR@(COUNTER)))
        . S SCRAP=$$RPLCLST(NEXTFILE,NEXTIEN,DRCTN,STATDATE,STATHST,OUTARR)
        I DRCTN["B" D
        . S NEXTFILE=""
        . F  S NEXTFILE=$O(^DD(FILE,0,"PT",NEXTFILE)) Q:'NEXTFILE  D
        . . Q:'$D(^DD(FILE,0,"PT",NEXTFILE,99.97))
        . . S NEXTROOT=$$ROOT^DILFD(NEXTFILE,"",1)
        . . Q:NEXTROOT=""
        . . S NEXTIEN=""
        . . F  S NEXTIEN=$O(@NEXTROOT@("AREPLACETERM",IEN,NEXTIEN)) Q:'NEXTIEN  D
        . . . S RPLCMNT=NEXTIEN_";"_NEXTFILE
        . . . Q:$D(@OUTARR@("INDEX",RPLCMNT))
        . . . S SCRAP=$$GETSTAT^XTID(NEXTFILE,.01,NEXTIEN_",",STATDATE)
        . . . S COUNTER=1+$O(@OUTARR@("INDEX"),-1)
        . . . S @OUTARR@(COUNTER)=RPLCMNT_U_$P(SCRAP,U,1)
        . . . S @OUTARR@("INDEX",RPLCMNT)=COUNTER
        . . . D STATHIST(NEXTFILE,NEXTIEN,$NAME(@OUTARR@(COUNTER)))
        . . . S SCRAP=$$RPLCLST(NEXTFILE,NEXTIEN,DRCTN,STATDATE,STATHST,OUTARR)
        Q $$RPLCMNT(FILE,IEN)
        ;
STATHIST(FILE,IEN,OUTARR)       ; Return status history for entry
        N SUBFILE,XTHIST,XTMSG,ID,STATDATE
        S SUBFILE=$$SUBFILE(FILE,99.991)
        Q:'SUBFILE
        D LIST^DIC(SUBFILE,","_IEN_",",".01;.02","I","*","","","","","","XTHIST","XTMSG")
        I $D(XTMSG) Q 0
        S ID=0
        F  S ID=$O(XTHIST("DILIST","ID",ID)) Q:'ID  D
        . S STATDATE=$G(XTHIST("DILIST","ID",ID,.01))
        . Q:'STATDATE
        . S @OUTARR@(STATDATE)=$G(XTHIST("DILIST","ID",ID,.02))
        Q
        ;
PTR2FILE(FILE)  ; Return file number that field points to
        N OTHER,XTMSG
        S OTHER=$$GET1^DID(FILE,99.97,"","SPECIFIER","","XTMSG")
        I $D(XTMSG) Q 0
        Q +$P(OTHER,"P",2)
        ;
PTR2IEN(FILE,PTR)       ; Return entry that field points to
        N VALUE,XTMSG
        S VALUE=$$GET1^DIQ(FILE,PTR_",",99.97,"I","","XTMSG")
        I $D(XTMSG) Q 0
        Q VALUE
        ;
SUBFILE(FILE,FIELD)     ; Return subfile number for a multiple
        N VALUE,XTMSG
        S VALUE=$$GET1^DID(FILE,FIELD,"","SPECIFIER","","XTMSG")
        I $D(XTMSG) Q 0
        Q +VALUE
