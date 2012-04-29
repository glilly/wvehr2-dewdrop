C0QINIT ; GPL - Quality Reporting Initialization Routines ;12/01/11  17:05
        ;;0.1;C0Q;nopatch;noreleasedate;Build 23
        ;Copyright 2011 George Lilly.  Licensed under the terms of the GNU
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
C0QALFN()       Q 1130580001.311 ; FILE NUMBER FOR C0Q PATIENT LIST PATIENT SUBFILE ;
        ;
COPYQ   ; INTERACTIVE COPY OF A QUALITY MEASURE
        N FN
        S FN=$$C0QQFN
        S DIC=FN,DIC(0)="AEMQ" D ^DIC
        I Y<1 Q  ; EXIT
        S C0QIEN=$P(Y,U)
        ;N G,ZWP
        D GETS^DIQ(FN,C0QIEN,"**","EI","G")
        M ZWP=G(FN,C0QIEN_",",.61)
        ; GET READY TO CREATE THE NEW COPY
        ; FIRST FIND OUT THE NEW NAME
        N QNAME
        S QNAME=G(FN,C0QIEN_",",.01,"E")
        S DIR(0)="F^3:240"
        S DIR("A")="New Measure Name"
        S DIR("B")=QNAME
        D ^DIR
        I Y="^" Q  ;
        N QNEW
        S QNEW=Y
        K C0QFDA
        N ZI S ZI=""
        F  S ZI=$O(G(FN,C0QIEN_",",ZI)) Q:ZI=""  D  ; FOR EACH FIELD
        . I ZI=.01 D  Q  ; THE NEW NAME
        . . S C0QFDA(FN,"+1,",.01)=QNEW ; NEW MEASURE NAME
        . I ZI=3.1 Q  ; SKIP THE COMPUTED FIELD
        . S C0QFDA(FN,"+1,",ZI)=G(FN,C0QIEN_",",ZI,"I")
        D UPDIE ; CREATE THE NEW RECORD
        S DIE=$$C0QQFN ; GET READY TO EDIT IT
        D EN^DIB ; EDIT THE NEW RECORD
        Q
        ;
UPDIE   ; INTERNAL ROUTINE TO CALL UPDATE^DIE AND CHECK FOR ERRORS
        K ZERR
        D CLEAN^DILF
        ZWR C0QFDA
        D UPDATE^DIE("","C0QFDA","","ZERR")
        I $D(ZERR) S ZZERR=ZZERR ; ZZERR DOESN'T EXIST,
        ; INVOKE THE ERROR TRAP IF TASKED
        K C0QFDA
        Q
        ;
