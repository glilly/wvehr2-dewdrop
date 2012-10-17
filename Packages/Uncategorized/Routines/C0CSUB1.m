C0CSUB1   ; CCDCCR/GPL - CCR SUBSCRIPTION utilities; 12/6/08
        ;;1.2;C0C;;May 11, 2012;Build 50
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
        W "This is the CCR SUBSCRIPTIONN Utility Library ",!
        Q
        ;
CHK1(DFN)       ; ADD THE CHECKSUM FOR ONE PATIENT
        ;
        S C0CCHK=$NA(^TMP("C0CRIM","CHKSUM"))
        S C0CSF=177.101 ; FILE NUMBER FOR SUBSCRIPTION FILE
        S C0CSFS=177.1011 ; FILE NUMBER FOR SUBSCRIPTION SUBFILE
        S C0CSFC=177.1012 ; FILE NUMBER FOR CHECKSUM SUBFILE
        S C0CSFDC=177.10121 ; FILE NUMBER FOR DOMAIN CHECKSUMS
        S C0CPAT=$O(^C0CS("B",DFN,"")) ; IEN OF PAT
        K C0CFDA 
        S C0CALL=$G(@C0CCHK@(DFN,"ALL"))
        I C0CALL'="" S C0CFDA(C0CSFC,"?+1,"_C0CPAT_",",.01)=C0CALL
        E  Q ; NO CHECKSUMS FOR THISPATIENT
        D UPDIE
        N C0CJ S C0CJ=""
        F  S C0CJ=$O(@C0CCHK@(DFN,"DOMAIN",C0CJ)) Q:C0CJ=""  D  ; FOR EACH DOMAIN
        . S C0CD=$O(^C0CDIC(170.101,"B",C0CJ,"")) 
        . W C0CJ," ",C0CD,!
        . S C0CFDA(C0CSFDC,"?+1,1,"_C0CPAT_",",.01)=C0CD
        . S C0CFDA(C0CSFDC,"?+1,1,"_C0CPAT_",",1)=@C0CCHK@(DFN,"DOMAIN",C0CJ)
        . D UPDIE
        Q
        ;
SUBALL  ; SUBSCRIBE ALL PATIENTS IN CCR GLOBALS TO SUBCRIBER 1
        ;
        S C0CGLB=$NA(^TMP("C0CRIM","VARS"))
        S C0CI=""
        F  S C0CI=$O(@C0CGLB@(C0CI)) Q:C0CI=""  D  ; FOR EACH PATIENT
        . D SUB1(C0CI,1) ;SUBSCIRBE THEM TO EPCRN
        Q
        ;
SUB1(DFN,C0CSS) ; SUBSCRIBE ONE PATIENT TO SUBSCRIBER C0CSS
        ;
        S C0CSF=177.101 ; FILE NUMBER FOR SUBSCRIPTION FILE
        S C0CSFS=177.1011 ; FILE NUMBER FOR SUBSCRIPTION SUBFILE
        S C0CSFC=177.10121 ; FILE NUMBER FOR CHECKSUMS
        S C0CSSF=177.201 ; FILE NUMBER FOR SUBSCRIBER FILE
        K C0CFDA
        S C0CFDA(C0CSF,"+1,",.01)=DFN
        D UPDIE ; ADD THE PATIENT
        S C0CPAT=$O(^C0CS("B",DFN,"")) ; IEN OF PAT
        S C0CFDA(C0CSFS,"+1,"_C0CPAT_",",.01)=C0CSS ; C0CSS IS A POINTER
        D UPDIE ; ADD THE SUBSCRIPTION
        D CHK1(DFN) ; ADD THE CHECKSUMS
        Q
        ;
UPDIE   ; INTERNAL ROUTINE TO CALL UPDATE^DIE AND CHECK FOR ERRORS
        K ZERR
        D CLEAN^DILF
        D UPDATE^DIE("","C0CFDA","","ZERR")
        I $D(ZERR) D  ;
        . W "ERROR",!
        . ZWR ZERR
        . B
        K C0CFDA
        Q
        ;
VARPTR(ZVAR,ZTYP)       ;EXTRINSIC WHICH RETURNS THE POINTER TO ZVAR IN THE
        ; CCR DICTIONARY. IT IS LAYGO, AS IT WILL ADD THE VARIABLE TO
        ; THE CCR DICTIONARY IF IT IS NOT THERE. ZTYP IS REQUIRED FOR LAYGO
        ;
        N ZCCRD,ZVARN,C0CFDA2
        S ZCCRD=170 ; FILE NUMBER FOR CCR DICTIONARY
        S ZVARN=$O(^C0CDIC(170,"B",ZVAR,"")) ;FIND IEN OF VARIABLE
        I ZVARN="" D  ; VARIABLE NOT IN CCR DICTIONARY - ADD IT
        . I '$D(ZTYP) D  Q  ; WON'T ADD A VARIABLE WITHOUT A TYPE
        . . W "CANNOT ADD VARIABLE WITHOUT A TYPE: ",ZVAR,!
        . S C0CFDA2(ZCCRD,"?+1,",.01)=ZVAR ; NAME OF NEW VARIABLE
        . S C0CFDA2(ZCCRD,"?+1,",12)=ZTYP ; TYPE EXTERNAL OF NEW VARIABLE
        . D CLEAN^DILF ;MAKE SURE ERRORS ARE CLEAN
        . D UPDATE^DIE("E","C0CFDA2","","ZERR") ;ADD VAR TO CCR DICTIONARY
        . I $D(ZERR) D  ; LAYGO ERROR
        . . W "ERROR ADDING "_ZC0CI_" TO CCR DICTIONARY",!
        . E  D  ;
        . . D CLEAN^DILF ; CLEAN UP
        . . S ZVARN=$O(^C0CDIC(170,"B",ZVAR,"")) ;FIND IEN OF VARIABLE
        . . W "ADDED ",ZVAR," TO CCR DICTIONARY, IEN:",ZVARN,!
        Q ZVARN
        ;
SETFDA(C0CSN,C0CSV)     ; INTERNAL ROUTINE TO MAKE AN FDA ENTRY FOR FIELD C0CSN
        ; TO SET TO VALUE C0CSV.
        ; C0CFDA,C0CC,C0CZX ARE ASSUMED FROM THE CALLING ROUTINE
        ; C0CSN,C0CSV ARE PASSED BY VALUE
        ;
        N C0CSI,C0CSJ
        S C0CSI=$$ZFILE(C0CSN,"C0CC") ; FILE NUMBER
        S C0CSJ=$$ZFIELD(C0CSN,"C0CC") ; FIELD NUMBER
        S C0CFDA(C0CSI,C0CZX_",",C0CSJ)=C0CSV
        Q
ZFILE(ZFN,ZTAB) ; EXTRINSIC TO RETURN FILE NUMBER FOR FIELD NAME PASSED
        ; BY VALUE IN ZFN. FILE NUMBER IS PIECE 1 OF C0CA(ZFN)
        ; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
        I '$D(ZTAB) S ZTAB="C0CA"
        N ZR
        I $D(@ZTAB@(ZFN)) S ZR=$P(@ZTAB@(ZFN),"^",1)
        E  S ZR=""
        Q ZR
ZFIELD(ZFN,ZTAB)        ;EXTRINSIC TO RETURN FIELD NUMBER FOR FIELD NAME PASSED
        ; BY VALUE IN ZFN. FILE NUMBER IS PIECE 2 OF C0CA(ZFN)
        ; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
        I '$D(ZTAB) S ZTAB="C0CA"
        N ZR
        I $D(@ZTAB@(ZFN)) S ZR=$P(@ZTAB@(ZFN),"^",2)
        E  S ZR=""
        Q ZR
        ;
ZVALUE(ZFN,ZTAB)        ;EXTRINSIC TO RETURN VALUE FOR FIELD NAME PASSED
        ; BY VALUE IN ZFN. FILE NUMBER IS PIECE 3 OF C0CA(ZFN)
        ; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
        I '$D(ZTAB) S ZTAB="C0CA"
        N ZR
        I $D(@ZTAB@(ZFN)) S ZR=$P(@ZTAB@(ZFN),"^",3)
        E  S ZR=""
        Q ZR
        ;
