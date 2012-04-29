C0QMAIN ; GPL - Quality Reporting Main Processing ;10/13/10  17:05
        ;;0.1;C0Q;nopatch;noreleasedate;Build 12
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
C0QALFN()       Q 1130580001.311 ; FILE NUMBER FOR C0Q PATIENT LIST PATIENT SUBFILE     ;
EXPORT    ; EXPORT ENTRY POINT FOR CCR
        ; Select a patient.
        N C0QMS,C0QM,C0QMIEN,C0QNA,C0QNORD
        S C0QNORD=3 ; WE WANT DENOMINATORS USE 1 FOR NUMERATORS
        S DIC=$$C0QMFN,DIC(0)="AEMQ" D ^DIC
        I Y<1 Q  ; EXIT
        S C0QMS=$P(Y,U,1) ; SET THE MEASURE SET
        S DIC=$$C0QQFN,DIC(0)="AEMQ" D ^DIC
        I Y<1 Q  ; EXIT
        S C0QM=$P(Y,U,1) ; SET THE MEASURE IEN
        N C0QMN S C0QMN=$P(Y,U,2) ; SET THE MEASURE NAME
        S C0QMIEN=$O(^C0Q(201,C0QMS,5,"B",C0QM,""))
        S C0QNA=$NA(^C0Q(201,C0QMS,5,C0QMIEN,C0QNORD,"B"))
        N ZI S ZI=""
        F  S ZI=$O(@C0QNA@(ZI)) Q:ZI=""  D  ;
        . W !,ZI
        . N ONAME S ONAME=C0QMN_"_"_ZI_"_CCR_V1_0_0.xml"
        . D XPAT^C0CCCR(ZI,,,ONAME) ; EXPORT TO A FILE
        Q
        ;
NBYP    ; ENTRY POINT FOR COMMAND LINE BY PATIENT MEASURE LISTING
        ;
        S DIC=$$C0QMFN,DIC(0)="AEMQ" D ^DIC
        I Y<1 Q  ; EXIT
        N MSIEN S MSIEN=+Y
        W !,"NUMERATOR PATIENT LIST",!
        N C0QPAT
        D PATS(.C0QPAT,MSIEN,"N") ; GET THE NUMERATOR PATIENT LIST
        I $D(C0QPAT) D  ; LIST RETURNED
        . ;
        Q
        ;
DBYP    ; ENTRY POINT FOR COMMAND LINE BY PATIENT MEASURE LISTING
        ;
        S DIC=$$C0QMFN,DIC(0)="AEMQ" D ^DIC
        I Y<1 Q  ; EXIT
        N MSIEN S MSIEN=+Y
        N C0QPAT
        W !,"DENOMINATOR PATIENT LIST",!
        D PATS(.C0QPAT,MSIEN,"D") ; GET THE NUMERATOR PATIENT LIST
        I $D(C0QPAT) D  ; LIST RETURNED
        . ;
        . ;
        Q
        ;
ENEXP   ; EXTERNAL MENU ENTRY POINT FOR EXP
        ;
        S DIC=$$C0QMFN,DIC(0)="AEMQ" D ^DIC
        I Y<1 Q  ; EXIT
        N MSIEN S MSIEN=+Y
        D EXP(MSIEN)
        Q
        ;
EXP(MSET,NOEX)  ; EXPORT ALL PATIENTS FOR MEASURE SET IEN MSET
        ; ALSO, WRITE OUT THE BY PATIENT MEASURE TEXT FILE
        ; IF NOEX=1, THEN ONLY THE MEASURE TEXT FILE GETS WRITTEN, NO EXPORTS ARE
        ; DONE
        I '$D(NOEX) S NOEX=0
        N ZQI,ZARY,ZFN,ODIR
        S ZQI=""
        D PATS(.ZARY,MSET,"D",1)
        S ZFN="MEASURES-BY-PATIENT.txt"
        S ODIR=^TMP("C0CCCR","ODIR") ; OUTPUT DIRECTORY
        S GARY=$NA(^TMP("C0Q",$J))
        K @GARY
        M @GARY=ZARY
        S GARY1=$NA(@GARY@(1))
        N ZY
        S ZY=$$OUTPUT^C0CXPATH(GARY1,ZFN,ODIR)
        W !,ZY
        I NOEX=1 Q  ; DO NOT EXPORT
        F  S ZQI=$O(ZARY(ZQI)) Q:ZQI=""  D  ; FOR EACH PATIENT
        . D XPAT^C0CCCR(+ZARY(ZQI)) ;
        Q
        ;
PATS(ZRTN,MSIEN,NORD,QT)        ; BUILDS A LIST OF PATIENTS AND THEIR MEASURES
        ; FOR MEASURE SET MSET. NORD="N" (DEFAULT) MEANS NUMERATOR PATIENTS
        ; NORD="D" MEANS DENOMINATOR PATIENTS
        ; QT=1 MEANS QUIET
        I $G(QT)'=1 S QT=0
        N ZI,ZJ,ZK,ZIDX,ZN,ZM
        S ZN=0 ; COUNT OF PATIENTS
        S ZI=""
        ; GOING TO USE THE NUMERATOR BY PATIENT INDEX
        I '$D(NORD) S NORD="N"
        I '((NORD="N")!(NORD="D")) S NORD="N"
        I NORD="N" S ZIDX=$NA(^C0Q(201,"ANBYP"))
        E  S ZIDX=$NA(^C0Q(201,"ADBYP"))
        F  S ZI=$O(@ZIDX@(ZI)) Q:ZI=""  D  ; FOR EACH PATIENT
        . I $O(@ZIDX@(ZI,MSIEN,""))'="" D  ; IF PATIENT IS IN THIS SET
        . . I 'QT W !,$$GET1^DIQ(2,ZI_",",.01) ;PATIENT NAME
        . . S ZN=ZN+1 ; INCREMENT PATIENT COUNT
        . . S ZRTN(ZN)=ZI
        . E  Q  ; NEXT PATIENT
        . S (ZJ,ZK)=""
        . F  S ZJ=$O(@ZIDX@(ZI,MSIEN,ZJ)) Q:ZJ=""  D  ; FOR EACH MEASURE
        . . ;S ZL=$O(@ZIDX@(ZI,MSIEN,ZJ,"")) ; MEASURE IS FOURTH
        . . S ZK=""
        . . S ZK=$$GET1^DIQ($$C0QMMFN,ZJ_","_MSIEN_",",.01,"I")
        . . ;W !,"ZK:",ZK," ZJ:",ZJ," ZI",ZI,!
        . . S ZM=$$GET1^DIQ($$C0QQFN,ZK_",",.01) ; MEASURE NAME
        . . I 'QT W " ",ZM
        . . S ZRTN(ZN)=ZRTN(ZN)_" "_ZM
        Q
        ;
EN      ; ENTRY POINT FOR COMMAND LINE AND MENU ACCESS TO C0QRPC
        ;
        S DIC=$$C0QMFN,DIC(0)="AEMQ" D ^DIC
        I Y<1 Q  ; EXIT
        N MSIEN S MSIEN=+Y
        D C0QRPC(.G,MSIEN)
        Q
        ;
EN2     ; SUMMARY ENTRY POINT FOR COMMAND LINE AND MENU ACCESS TO C0QRPC
        ;
        S DIC=$$C0QMFN,DIC(0)="AEMQ" D ^DIC
        I Y<1 Q  ; EXIT
        N MSIEN S MSIEN=+Y
        S C0QSUM=1
        D C0QRPC(.G,MSIEN)
        ; iterate over the measures
        S MEASURE=0
        F  S MEASURE=$O(^C0Q(201,MSIEN,5,MEASURE)) Q:MEASURE'>0  D
        . S NUMER=0,DENOM=0
        . ; now count the numerator patients
        . S P=0 F  S P=$O(^C0Q(201,MSIEN,5,MEASURE,1,P)) Q:P'>0  S NUMER=NUMER+1
        . S $P(^C0Q(201,MSIEN,5,MEASURE,2),U)=NUMER
        . ; and count the denominator patients
        . S P=0 F  S P=$O(^C0Q(201,MSIEN,5,MEASURE,3,P)) Q:P'>0  S DENOM=DENOM+1
        . Q:DENOM=0
        . ; and stuff the values
        . S $P(^C0Q(201,MSIEN,5,MEASURE,4),U,1,2)=DENOM_U_$J(100*NUMER/DENOM,0,0)
        . Q
        Q
        ;
C0QRPC(RTN,MSET,FMT,NOPURGE)    ; RPC FORMAT
        ; MSET IS THE NAME OR IEN OF THE MEASURE SET
        ; RTN IS THE RETURN ARRAY OF THE RESULTS PASSED BY REFERENCE
        ; FMT IS THE FORMAT OF THE OUTPUT - "ARRAY" OR "HTML" OR "XML"
        ;  NOTE: ARRAY IS DEFAULT AND THE OTHERS ARE NOT IMPLEMENTED YET
        ; IF NOPURGE IS 1, PATIENT LISTS WILL NOT BE DELETED BEFORE ADDING
        ; IF NOPURGE IS 0 OR OMITTED, PATIENT LISTS WILL BE DELETED THEN ADDED
        ;W !,"LOOKING FOR MEASURE SET ",MSET,!
        N ZI S ZI=""
        N C0QM ; FOR HOLDING THE MEASURES IN THE SET
        D LIST^DIC($$C0QMMFN,","_MSET_",",".01I") ; GET ALL THE MEASURES
        D DELIST("C0QM")
        N ZII S ZII=""
        F  S ZII=$O(C0QM(ZII)) Q:ZII=""  D  ; FOR EACH MEASURE
        . D CLEARMEA(MSET,ZII) ; FIRST CLEAR OUT THE MEASURE
        K C0QM
        D CLEAN^DILF
        D LIST^DIC($$C0QMMFN,","_MSET_",",".01I") ; GET ALL THE MEASURES AGAIN
        D DELIST("C0QM")
        F  S ZII=$O(C0QM(ZII)) Q:ZII=""  D  ; FOR EACH MEASURE
        . S ZI=$P(C0QM(ZII),U,1) ; IEN OF THE MEASURE IN THE C0Q QUALITY MEAS FILE
        . ;W $$GET1^DIQ($$C0QQFN,ZI_",","DISPLAY NAME"),!
        . ;N C0QNL,C0QDL ;NUMERATOR AND DENOMINATOR LIST POINTERS
        . ;W !,"MEASURE: ",$$GET1^DIQ($$C0QQFN,ZI_",",.01),! ; PRINT THE MEASURE NAME
        . ; FOLLOW THE POINTERS TO THE C0Q QUALITYM MEASURE FILE AND GET LIST PTRS
        . S C0QNL=$$GET1^DIQ($$C0QQFN,ZI_",",1,"I") ; NUMERATOR POINTER
        . I C0QNL="" D  ; CHECK ALTERNATE LIST
        . . S C0QNL=$$GET1^DIQ($$C0QQFN,ZI_",",1.1,"I") ; NUMERATOR POINTER
        . . I C0QNL'="" S C0QNALT=1
        . S C0QDL=$$GET1^DIQ($$C0QQFN,ZI_",",2,"I") ; DENOMINATOR POINTER
               . I C0QDL="" D  ; CHECK ALTERNATE LIST
               . . S C0QDL=$$GET1^DIQ($$C0QQFN,ZI_",",2.1,"I") ; DENOMINATOR POINTER
               . . I C0QDL'="" S C0QDALT=1
        . ; NOW FOLLOW THE LIST POINTERS TO THE REMINDER PATIENT LIST FILE
        . ;W "NUMERATOR: ",$$GET1^DIQ($$RLSTFN,C0QNL_",","NAME"),!
        . ; FIRST PROCESS THE NUMERATOR
        . K ^TMP("DILIST",$J)
               . N C0QUFN ; FILE NUMBER TO USE
               . I $G(C0QNALT)=1 S C0QUFN=$$C0QALFN()
               . E  S C0QUFN=$$RLSTPFN
        . D LIST^DIC(C0QUFN,","_C0QNL_",",".01I") ; GET THE LIST OF PATIENTS
        . ;D DELIST("G") ;
        . ;I $D(G) ZWR G
        . K C0QNUMP
        . S NCNT=$O(^TMP("DILIST",$J,"ID",""),-1) ; NUMERATOR COUNT
        . N ZJ S ZJ=""
        . F  S ZJ=$O(^TMP("DILIST",$J,"ID",ZJ)) Q:ZJ=""  D  ;
        . . S ZDFN=^TMP("DILIST",$J,"ID",ZJ,.01)
        . . S C0QNUMP("N",ZJ,ZDFN)=""
        . ;I '$G(C0QSUM) ZWR ^TMP("DILIST",$J,1,*) ; LIST THE PATIENT NAMES
        . D ADDPATS(MSET,ZII,"C0QNUMP")
        . ; NEXT PROCESS THE DENOMINATOR
        . ;W "DENOMINATOR: ",$$GET1^DIQ($$RLSTFN,C0QDL_",","NAME"),!
        . K ^TMP("DILIST",$J)
               . I $G(C0QDALT)=1 S C0QUFN=$$C0QALFN()
               . E  S C0QUFN=$$RLSTPFN
        . D LIST^DIC(C0QUFN,","_C0QDL_",",".01I") ; GET THE LIST OF PATIENTS
        . ;D DELIST("G")
        . ;I $D(G) ZWR G
        . ;S ZJ=""
        . S DCNT=$O(^TMP("DILIST",$J,"ID",""),-1) ; DENOMONIATOR COUNT
        . K C0QDEMP
        . F  S ZJ=$O(^TMP("DILIST",$J,"ID",ZJ)) Q:ZJ=""  D  ;
        . . S ZDFN=^TMP("DILIST",$J,"ID",ZJ,.01)
        . . S C0QDEMP("D",ZJ,ZDFN)=""
        . D ADDPATS(MSET,ZII,"C0QDEMP")
        . ;I $G(C0QSUM)'=1 ZWR ^TMP("DILIST",$J,1,*) ; LIST THE PATIENT NAMES
        . ;E  D  ;
        . ;. W "NUM CNT: ",NCNT
        . ;. W "  DEN CNT: ",DCNT,!
        Q
        ;
CLEARMEA(MSET,MEAS)     ; DELETE AND THEN RECREATE AS EMPTY THE
        ; MEASURE MEAS IN MEASURE SET IEN MSET
        ;
        N C0QFDA,MFN,MEASURE
        S MFN=$$C0QMMFN() ; FILE NUMBER FOR MEASURE SUBFILE
        D CLEAN^DILF
        S MEASURE=$$GET1^DIQ(MFN,MEAS_","_MSET_",",.01,"I") ;  MEASURE POINTER
        D CLEAN^DILF
        K ZERR
        S C0QFDA(MFN,MEAS_","_MSET_",",.01)="@" ; GET READY TO DELETE THE MEASURE
        D FILE^DIE(,"C0QFDA","ZERR") ; KILL THE SUBFILE
        I $D(ZERR) S ZZERR=ZZERR ; ZZERR DOESN'T EXIST, INVOKE THE ERROR TRAP IF TASKED
        ;. W "ERROR",!
        ;. ZWR ZERR
        ;. B
        K C0QFDA
        S C0QFDA(MFN,"+1,"_MSET_",",.01)=MEASURE ; GET READY TO RECREATE THE SUBFILE
        D UPDIE ; CREATE THE SUBFILE
        Q
        ;
ADDPATS(MSET,MEAS,PATS) ;ADD PATIENTS TO NUMERATOR AND DENOMINATOR
        ; OF MEASURE SET IEN MSET MEASURE IEN MEAS
        ; PATS IS OF THE FORM @PATS@("N",X,DFN)="" AND @PATS@("D",X,DFN)=""
        ; WHERE N IS FOR NUMERATOR AND D IS FOR DENOMINATOR AND X 1..N
        ; IF PATIENTS ARE ALREADY THERE, THEY WILL NOT BE ADDED AGAIN
        N C0QI,C0QJ
        N C0QFDA
        S C0QI=""
        F  S C0QI=$O(@PATS@("N",C0QI)) Q:C0QI=""  D  ; FOR EACH NUMERATOR PATIENT
        . S C0QFDA($$C0QMMNFN,"?+"_C0QI_","_MEAS_","_MSET_",",.01)=$O(@PATS@("N",C0QI,""))
        ;W "ADDING NUMERATOR",!
        ;I $D(C0QFDA) ZWR C0QFDA
        I $D(C0QFDA) D UPDIE
        K C0QFDA
        S C0QI=""
        F  S C0QI=$O(@PATS@("D",C0QI)) Q:C0QI=""  D  ; FOR EACH NUMERATOR PATIENT
        . S C0QFDA($$C0QMMDFN,"?+"_C0QI_","_MEAS_","_MSET_",",.01)=$O(@PATS@("D",C0QI,""))
        ;W "ADDING DENOMINATOR",!
        ;I $D(C0QFDA) ZWR C0QFDA
        I $D(C0QFDA) D UPDIE
        Q
        ;
DELIST(RTN)     ; DECODES ^TMP("DILIST",$J) INTO
        ; @RTN@(IEN)=INTERNAL VALUE^EXTERNAL VALUE
        N ZI,IV,EV,ZDI,ZIEN
        S ZI=""
        S ZDI=$NA(^TMP("DILIST",$J))
        K @RTN
        F  S ZI=$O(@ZDI@(1,ZI)) Q:ZI=""  D  ;
        . S EV=@ZDI@(1,ZI) ;EXTERNAL VALUE
        . S IV=$G(@ZDI@("ID",ZI,.01)) ; INTERNAL VALUE
        . S ZIEN=@ZDI@(2,ZI) ; IEN
        . S @RTN@(ZIEN)=IV_"^"_EV
        Q
        ;
DELPATS(MSET,MEAS,NDEL) ; DELETE PATIENTS FROM NUMERATOR AND DENOMINATOR
        ; FOR A MEASURE (ONLY AFFECTS THE C0Q MEASURES FILE)
        ; MSET IS THE IEN OF THE MEASURE SET
        ; MEAS IS THE IEN OF THE MEASURE
        ; NDEL IS A LIST OF PATIENTS TO NOT DELETE (NOT IMPLEMENTED YET)
        ;  IN THE FORM @NDEL@("N",IEN,DFN)="" FOR NUMERATOR PATIENTS
        ;  AND @NDEL@("D",IEN,DFN)="" FOR DENOMINATOR PATIENTS WHERE IEN IS
        ;  THE IEN OF THE PATIENT RECORD IN THE SUBFILE
        ;  THIS FEATURE WILL ALLOW EFFICIENCIES FOR LONG PATIENT LISTS
        ;  IN THAT PATIENTS THAT ARE GOING TO BE ADDED ARE NOT FIRST DELETED
        N C0QI,C0QJ
        D LIST^DIC($$C0QMMFN,","_MSET_",")
        K C0QFDA
        ;ZWR ^TMP("DILIST",$J,*)
        ;ZWR ^TMP("DIERR",$J,*)
        ;D
        Q
        ;
UPDIE   ; INTERNAL ROUTINE TO CALL UPDATE^DIE AND CHECK FOR ERRORS
        K ZERR
        D CLEAN^DILF
        D UPDATE^DIE("","C0QFDA","","ZERR")
        I $D(ZERR) S ZZERR=ZZERR ; ZZERR DOESN'T EXIST, INVOKE THE ERROR TRAP IF TASKED
        ;. W "ERROR",!
        ;. ZWR ZERR
        ;. B
        K C0QFDA
        Q
        ;
QUE     ;QUE THE RUN OF THE PATIENT LISTS AND THE BUILD THE LISTS OF THE PATIENTS
        ;AND THEIR MEASURES
        S MSIEN=$$GET^XPAR("DIV."_$P($$SITE^VASITE(),U,2),"C0Q MEASUREMENT TO USE")
        N ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
        S ZTDESC="CREATE PATIENT LIST"
        S ZTRTN="RUN^C0QMAIN"
        S ZTSAVE("MSIEN")=""
        S ZTIO=""
        S ZTDTH=$$NOW^XLFDT
        D ^%ZTLOAD
        Q
        ;
RUN     ; DO THE REAL WORK
        I '$D(MSIEN) S MSIEN=$$GET^XPAR("DIV."_$P($$SITE^VASITE(),U,2),"C0Q MEASUREMENT TO USE")
        S BEG=$P(^C0Q(201,MSIEN,4),U,3) ;Begin date
        S END=$P(^C0Q(201,MSIEN,4),U,4) ;End date
        S PATCREAT="N" ;Secure list - N=No
        S PLISTPUG="N" ;Purge list after 5 years - N=No
        S PXRMDPAT=0 ;Include deceased patients - N=No
        S PXRMTPAT=0 ;Include test patients - N=No
        S PXRMNODE="PXRMRULE" ;Node in ^TMP($J,"PXRMRULE"
        N ZI S ZI=""
        F  S ZI=$O(^C0Q(201,MSIEN,5,"B",ZI)) Q:ZI'>0  D  ; LOOP THROUGH EACH QM
        . S PXRMLSTN=+$P(^C0Q(101,ZI,0),U,2) ; NUMERATOR MEASURE
        . S PXRMLSTD=+$P(^C0Q(101,ZI,0),U,3) ; DENOMINATOR MEASURE
        . S PXRMRULN=+$P(^PXRMXP(810.5,PXRMLSTN,0),U,6) ; RULES FOR THE LIST
        . S PXRMRULD=+$P(^PXRMXP(810.5,PXRMLSTD,0),U,6)
        . D RUN^PXRMLCR(PXRMRULD,PXRMLSTD,PXRMNODE,BEG,END,PXRMDPAT,PXRMTPAT)
        . D RUN^PXRMLCR(PXRMRULN,PXRMLSTN,PXRMNODE,BEG,END,PXRMDPAT,PXRMTPAT)
        D C0QRPC(.G,MSIEN)
        Q
