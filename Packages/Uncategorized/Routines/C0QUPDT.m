C0QUPDT ; GPL - Quality Reporting List Update Routines ;8/29/11  17:05
        ;;0.1;C0Q;nopatch;noreleasedate;Build 23
        ;Copyright 2009 George Lilly.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        Q
        ;
C0QQFN()        Q 1130580001.101 ; FILE NUMBER FOR C0Q QUALITY MEASURE FILE
C0QMFN()        Q 1130580001.201 ; FILE NUMBER FOR C0Q MEASUREMENT FILE
C0QMMFN()       Q 1130580001.2011 ; FN FOR MEASURE SUBFILE
C0QMMNFN()      Q 1130580001.20111 ; FN FOR NUMERATOR SUBFILE
C0QMMDFN()      Q 1130580001.20112 ; FN FOR DENOMINATOR SUBFILE
RLSTFN()        Q 810.5 ; FN FOR REMINDER PATIENT LIST FILE
RLSTPFN()       Q 810.53 ; FN FOR REMINDER PATIENT LIST PATIENT SUBFILE
C0QPLF()        Q 1130580001.301 ; C0Q PATIENT LIST FILE
C0QALFN()       Q 1130580001.311 ; FILE NUMBER FOR C0Q PATIENT LIST PATIENT SUBFILE ;
        ;
UPDATE(RNT,MSET)        ; UPDATE A MEASURE SET BY ADDING NEW ENTRIES TO PATIENT
        ; LISTS AND DELETING ENTRIES THAT ARE NO LONGER VALID. ALSO UPDATE
        ; NUMERATOR AND DENOMINATOR COUNTS
        ; MAKES HEAVY USE OF UNITY^C0QSET TO DETERMINE WHAT TO ADD AND DELETE
        ;
        ; THIS IS A REPLACEMENT FOR C0QRPC^C0QMAIN WHICH DELETES THE PATIENT
        ; LISTS AND RECREATES THEM, WHICH IS A LOT OF UNNECESSARY PROCESSING
        ;
        N ZI S ZI=""
        N C0QM ; FOR HOLDING THE MEASURES IN THE SET
        I $$GET1^DIQ($$C0QMFN,MSET_",",.05,"I")="Y" D  Q  ; IS IT LOCKED?
        . W !,"ERROR MEASURE SET IS LOCKED, EXITING"
        D LIST^DIC($$C0QMMFN,","_MSET_",",".01I;1.2I;2.2I") ; GET ALL THE MEASURES
        D DELIST("C0QM")
        N ZII S ZII=""
        F  S ZII=$O(C0QM(ZII)) Q:ZII=""  D  ; FOR EACH MEASURE
        . N C0QNL,C0QDL,C0QFLTN,C0QFLTD
        . S C0QFLTN=$P(C0QM(ZII),U,3) ;IEN OF NUMERATOR FILTER LIST
        . S C0QFLTD=$P(C0QM(ZII),U,4) ; IEN OF DENOMINATOR FILTER LIST
        . S ZI=$P(C0QM(ZII),U,1) ; IEN OF THE MEASURE IN THE C0Q QUALITY MEAS FILE
        . S C0QNL=$$GET1^DIQ($$C0QQFN,ZI_",",1,"I") ; NUMERATOR POINTER
        . I C0QNL="" D  ; CHECK ALTERNATE LIST
        . . S C0QNL=$$GET1^DIQ($$C0QQFN,ZI_",",1.1,"I") ; NUMERATOR POINTER
        . . I C0QNL'="" S C0QNALT=1
        . S C0QDL=$$GET1^DIQ($$C0QQFN,ZI_",",2,"I") ; DENOMINATOR POINTER
        . I C0QDL="" D  ; CHECK ALTERNATE LIST
        . . S C0QDL=$$GET1^DIQ($$C0QQFN,ZI_",",2.1,"I") ; DENOMINATOR POINTER
        . . I C0QDL'="" S C0QDALT=1
        . ;
        . ; FIRST PROCESS THE NUMERATOR
        . ;
        . N C0QNEW ; REFERENCE TO NEW NUMBERATOR LIST B INDEX
        . I $G(C0QNALT)=1 D  ; USING ALTERNATE LIST FOR NUMERATOR
        . . S C0QNEW=$NA(^C0Q(301,C0QNL,1,"B")) ; B INDEX FOR THIS LIST
        . E  D  ; USE THE REMINDER PACKAGE PATIENT LISTS
        . . S C0QNEW=$NA(^PXRMXP(810.5,C0QNL,30,"B")) ; REMINDER LIST PATIENTS
        . I C0QFLTN'="" D  ; USE A NUMERATOR FILTER LIST
        . . N ZNEW
        . . S ZNEW=$NA(^C0Q(301,C0QFLTN,1,"B")) ; B INDEX OF FILTER LIST
        . . K C0QFLTRD
        . . D AND^C0QSET("C0QFLTRD",ZNEW,C0QNEW)
        . . S C0QNEW="C0QFLTRD"
        . N C0QOLD ; REFERENCE FOR OLD PATIENT LIST
        . S C0QOLD=$NA(^C0Q(201,MSET,5,ZII,1,"B")) ; NUMERATOR LIST IN MEASURE SET
        . N C0QRSLT ; ARRAY FOR THE UNITY DIFFERENCES
        . D UNITY^C0QSET("C0QRSLT",C0QNEW,C0QOLD) ; FIND THE DIFFERENCES
        . N C0QCNT
        . S C0QNCNT=$G(C0QRSLT("COUNT"))
        . I C0QNCNT="" D  ;
        . . S C0QNCNT=0 ; DEFAULT COUNT IS ZERO
        . . N GZZ S GZZ=""
        . . F  S GZZ=$O(C0QRSLT(0,GZZ)) Q:GZZ=""  D  ; EVERY ADD ENTRY
        . . . S C0QNCNT=C0QNCNT+1
        . . F  S GZZ=$O(C0QRSLT(1,GZZ)) Q:GZZ=""  D  ; EVERY EQUAL ENTRY
        . . . S C0QNCNT=C0QNCNT+1
        . K C0QFDA ; CLEAR THE FDA
        . N C0QONCNT ; OLD COUNT
        . S C0QONCNT=$$GET1^DIQ($$C0QMMFN(),ZII_","_MSET_",",1.1)
        . I C0QNCNT'=C0QONCNT D  ; COUNT HAS CHANGED
        . . S C0QFDA($$C0QMMFN(),ZII_","_MSET_",",1.1)=C0QNCNT ; NUMERATOR COUNT
        . . D UPDIE ; UPDATE THE NUMERATOR COUNT
        . I $D(C0QRSLT) D  ;B  ;
        . . ;ZWR C0QRSLT
        . ; FIRST PROCESS DELETIONS
        . K C0QFDA ; CLEAR OUT THE FDA
        . N ZG,ZIEN S ZG=""
        . F  S ZG=$O(C0QRSLT(2,ZG)) Q:ZG=""  D  ; FOR EACH DELETION
        . . S ZIEN=$O(@C0QOLD@(ZG,"")) ; IEN OF THE ENTRY
        . . I ZIEN="" D  Q  ; OOPS
        . . . W !,"ERROR DELETING ENTRY!! ",ZG
        . . S C0QFDA($$C0QMMNFN(),ZIEN_","_ZII_","_MSET_",",.01)="@" ; DELETE
        . I $D(C0QFDA) D UPDIE ; PROCESS
        . ; SECOND, PROCESS ADDITIONS
        . K C0QFDA ; CLEAR OUT THE FDA
        . N ZG,ZC S ZG="" S ZC=1
        . F  S ZG=$O(C0QRSLT(0,ZG)) Q:ZG=""  D  ; FOR EACH ADDITION
        . . S C0QFDA($$C0QMMNFN(),"+"_ZC_","_ZII_","_MSET_",",.01)=ZG ; ADD THE ENTRY
        . . S ZC=ZC+1
        . I $D(C0QFDA) D UPDIE ; PROCESS
        . ;
        . ; PROCESS THE DENOMINATOR
        . ;
        . N C0QNEW ; REFERENCE TO NEW NUMBERATOR LIST B INDEX
        . I $G(C0QNALT)=1 D  ; USING ALTERNATE LIST FOR NUMERATOR
        . . S C0QNEW=$NA(^C0Q(301,C0QDL,1,"B")) ; B INDEX FOR THIS LIST
        . E  D  ; USE THE REMINDER PACKAGE PATIENT LISTS
        . . S C0QNEW=$NA(^PXRMXP(810.5,C0QDL,30,"B")) ; REMINDER LIST PATIENTS
        . I C0QFLTD'="" D  ; USE A DENOMINATOR FILTER LIST
        . . N ZNEW
        . . S ZNEW=$NA(^C0Q(301,C0QFLTD,1,"B")) ; B INDEX OF FILTER LIST
        . . K C0QFLTRD
        . . D AND^C0QSET("C0QFLTRD",ZNEW,C0QNEW)
        . . S C0QNEW="C0QFLTRD"
        . N C0QOLD ; REFERENCE FOR OLD PATIENT LIST
        . S C0QOLD=$NA(^C0Q(201,MSET,5,ZII,3,"B")) ; DENOMINATOR LIST IN MEASURE SET
        . N C0QRSLT ; ARRAY FOR THE UNITY DIFFERENCES
        . D UNITY^C0QSET("C0QRSLT",C0QNEW,C0QOLD) ; FIND THE DIFFERENCES
        . N C0QDCNT
        . S C0QDCNT=$G(C0QRSLT("COUNT"))
        . I C0QDCNT="" D  ;
        . . S C0QDCNT=0 ; DEFAULT COUNT IS ZERO
        . . N GZZ S GZZ=""
        . . F  S GZZ=$O(C0QRSLT(0,GZZ)) Q:GZZ=""  D  ; EVERY ADD ENTRY
        . . . S C0QDCNT=C0QDCNT+1
        . . F  S GZZ=$O(C0QRSLT(1,GZZ)) Q:GZZ=""  D  ; EVERY EQUAL ENTRY
        . . . S C0QDCNT=C0QDCNT+1
        . K C0QFDA ; CLEAR THE FDA
        . N C0QODCNT ; OLD COUNT
        . S C0QODCNT=$$GET1^DIQ($$C0QMMFN(),ZII_","_MSET_",",2.1)
        . I C0QDCNT'=C0QODCNT D  ; COUNT HAS CHANGED
        . . S C0QFDA($$C0QMMFN(),ZII_","_MSET_",",2.1)=C0QDCNT ; DENOMINATOR COUNT
        . . D UPDIE ; UPDATE THE DENOMINATOR COUNT
        . I $D(C0QRSLT) D  ;B  ;
        . . ;ZWR C0QRSLT
        . I '$D(C0QRSLT) Q  ; NO RESULTS TO USE
        . ; FIRST PROCESS DELETIONS
        . K C0QFDA ; CLEAR OUT THE FDA
        . N ZG,ZIEN S ZG=""
        . F  S ZG=$O(C0QRSLT(2,ZG)) Q:ZG=""  D  ; FOR EACH DELETION
        . . S ZIEN=$O(@C0QOLD@(ZG,"")) ; IEN OF THE ENTRY
        . . I ZIEN="" D  Q  ; OOPS
        . . . W !,"ERROR DELETING ENTRY!! ",ZG
        . . S C0QFDA($$C0QMMDFN(),ZIEN_","_ZII_","_MSET_",",.01)="@" ; DELETE
        . I $D(C0QFDA) D UPDIE ; PROCESS
        . ; SECOND, PROCESS ADDITIONS
        . K C0QFDA ; CLEAR OUT THE FDA
        . N ZG,ZC S ZG="" S ZC=1
        . F  S ZG=$O(C0QRSLT(0,ZG)) Q:ZG=""  D  ; FOR EACH ADDITION
        . . S C0QFDA($$C0QMMDFN(),"+"_ZC_","_ZII_","_MSET_",",.01)=ZG ; ADD THE ENTRY
        . . S ZC=ZC+1
        . I $D(C0QFDA) D UPDIE ; PROCESS
        . N C0QPCT ; PERCENT
        . D  ;
               . . I C0QDCNT>0 D  ;
        . . . S C0QPCT=$J(100*C0QNCNT/C0QDCNT,0,0)
               . . E  S C0QPCT=0
        . . K C0QFDA
        . . S C0QFDA($$C0QMMFN(),ZII_","_MSET_",",3)=C0QPCT ; PERCENT
        . . D UPDIE
        Q
        ;
DELIST(RTN)     ; DECODES ^TMP("DILIST",$J) INTO
        ; @RTN@(IEN)=INTERNAL VALUE^EXTERNAL VALUE
        ; ADDED A B INDEX @RTN@("B",INTERNAL VALUE,IEN)=EXTERNAL VALUE
        N ZI,IV,EV,ZDI,ZIEN,FLTN,FLTD
        S ZI=""
        S ZDI=$NA(^TMP("DILIST",$J))
        K @RTN
        F  S ZI=$O(@ZDI@(1,ZI)) Q:ZI=""  D  ;
        . S EV=@ZDI@(1,ZI) ;EXTERNAL VALUE
        . S IV=$G(@ZDI@("ID",ZI,.01)) ; INTERNAL VALUE
        . S FLTN=$G(@ZDI@("ID",ZI,1.2)) ; NUMERATOR FILTER LIST
        . S FLTD=$G(@ZDI@("ID",ZI,2.2)) ; DENOMINATOR FILTER LIST
        . S ZIEN=@ZDI@(2,ZI) ; IEN
        . S @RTN@(ZIEN)=IV_"^"_EV_"^"_FLTN_"^"_FLTD
        . ;S @RTN@("B",IV,ZIEN)=EV
        Q
        ;
UPDIE   ; INTERNAL ROUTINE TO CALL UPDATE^DIE AND CHECK FOR ERRORS
        K ZERR
        D CLEAN^DILF
        ZWR C0QFDA
        D UPDATE^DIE("","C0QFDA","","ZERR")
        I $D(ZERR) S ZZERR=ZZERR ; ZZERR DOESN'T EXIST, INVOKE THE ERROR TRAP IF TASKED
        ;. W "ERROR",!
        ;. ZWR ZERR
        ;. B
        K C0QFDA
        Q
        ;
