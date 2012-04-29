C0QNOTES        ;GPL - Utility to look up patient notes  ;9/5/11 8:50pm
        ;;1.0;MU PACKAGE;;;Build 23
        ;
        ;2011 George Lilly <glilly@glilly.net> - Licensed under the terms of the GNU
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
HASNTYN(ZNTYP,DFN)      ; EXTRINSIC 1 YES 0 NO DOES THE PATIENT DFN HAVE
        ; NOTE TYPE ZNTYP
        N C0QN,C0QO
        S C0QO=$NA(^TIU(8925.1,"B",ZNTYP)) ; ALL DOCUMENT DEFS FOR THIS NAME
        S C0QN=$NA(^TIU(8925,"AA",DFN)) ; NOTES THE PATIENT HAS
        N C0QR
        D UNITY^C0QSET("C0QR",C0QN,C0QO) ; DOES PATIENT HAVE THE NOTE?
        N ZR
        I $D(C0QR(1)) S ZR=1
        E  S ZR=0
        Q ZR
        ;
TESTNT(DFN)     ; TEST THE NTTXT ROUTINE
        W !,"MEDICATION RECON IN ER NURSE NOTE"
        I $$NTTXT("ER NURSE NOTE","MEDICATION RECONCILIATION COMPLET",DFN) W " FOUND"
        E  W " NOT FOUND"
        W !,"Medication Recon in MED/SURG NURSING ADMISSION ASSESSMENT"
        I $$NTTXT("MED/SURG NURSING ADMISSION ASSESSMENT","Medication Reconcilation complete",DFN) W "FOUND"
        E  W " NOT FOUND"
        Q
        ;
NTTXT(NTTITLE,NTTXT,DFN)        ; EXTRINSIC 1 YES 0 NO DOES PATIENT HAVE
        ; TEXT NTTXT IN NOTE TITLE NTTITLE
        N C0QNTA,C0QTYP
        S C0QDFMT=$O(^TIU(8925.1,"B",NTTITLE,"")) ; DOCUMENT FORMAT IEN
        S C0QNTA=$NA(^TIU(8925,"AA",DFN,C0QDFMT)) ; ARRAY OF NOTES OF THIS TYPE FOR
        ;^TIU(8925,"AA",15393,1808,6889171,375262)=""
        N ZI,ZN,ZD,ZL
        S ZD="" ; DATE OF THE THE NOTE
        N FOUND S FOUND=0
        F  S ZD=$O(@C0QNTA@(ZD)) Q:FOUND  Q:ZD=""  D  ; FOR EACH DATE
        . S ZN=""
        . F  S ZN=$O(@C0QNTA@(ZD,ZN)) Q:FOUND  Q:ZN=""  D  ; EACH NOTE
        . . W !,"NOTE ",ZN," ",$G(^TIU(8925,ZN,"TEXT",1,0))
        . . S ZI=0 ; WANT TO STAR ON LINE 1
        . . S ZL=$NA(^TIU(8925,ZN,"TEXT"))
        . . F  S ZI=$O(@ZL@(ZI)) Q:+ZI=0  D  ;
        . . . I $P($G(@ZL@(ZI,0)),NTTXT,2)'="" S FOUND=1 D  ;
        . . . . W "**********",$G(@ZL@(ZI,0)),!
        Q FOUND ; IT'S THAT SIMPLE... PLEASE LEAVE SOME TEXT AT THE END OF WHAT
        ; YOU SEARCH FOR...gpl ... for example is this is the note title:
        ;   MED/SURG NURSING ADMISSION ASSESSMENT
        ;and this is the text you want:  Medication Reconcilation completed.
        ; search for: Medication Reconcilation complete
        ; that will leave the "d." in piece two of the line
        ;
        ; or for this note:
        ;ER NURSE NOTE
        ; and this text:
        ;MEDICATION RECONCILIATION COMPLETED
        ; search for MEDICATION RECONCILIATION COMPLET
        ; which will leave the "ED" in piece 2
TXTALL(ZRTN,ZTARY,DFN)  ; EXTRINSIC WHICH SEARCHES ALL OF A PATIENT'S NOTES
        ; FOR AN ARRAY OF TEXT MATCHES. ZRTN IS PASSED BY REFERENCE AND IS LIKE
        ; AN RPC RETURN. ZTARY IS PASSED BY REFERENCE AND HAS THE FORMAT
        ; ZTARY(1,"TEXT1")="" ZTARY(2,"TEXT2")="" ETC
        N C0QTYP,C0QDFMT
        ;S C0QDFMT=$O(^TIU(8925.1,"B",NTTITLE,"")) ; DOCUMENT FORMAT IEN
        S C0QNTA=$NA(^TIU(8925,"AA",DFN)) ; ARRAY OF NOTES FOR
        ;^TIU(8925,"AA",15393,1808,6889171,375262)=""
        N ZI,ZJ,ZN,ZD,ZL,ZT,NTTXT,ZC,ZTYP
        S ZT=""
        F  S ZT=$O(@C0QNTA@(ZT)) Q:ZT=""  D  ;
        . S ZTYP=$$GET1^DIQ(8925.1,ZT_",",.01) ; NAME OF NOTE TITLE
        . S ZD="" ; DATE OF THE THE NOTE
        . N FOUND S FOUND=0
        . F  S ZD=$O(@C0QNTA@(ZT,ZD)) Q:FOUND  Q:ZD=""  D  ; FOR EACH DATE
        . . S ZN=""
        . . F  S ZN=$O(@C0QNTA@(ZT,ZD,ZN)) Q:FOUND  Q:ZN=""  D  ; EACH NOTE
        . . . W !,"NOTE ",ZN," ",$G(^TIU(8925,ZN,"TEXT",1,0))
        . . . S ZI=0 ; WANT TO STAR ON LINE 1
        . . . S ZL=$NA(^TIU(8925,ZN,"TEXT"))
        . . . F  S ZI=$O(@ZL@(ZI)) Q:+ZI=0  D  ;
        . . . . S ZJ="" ; INDEX FOR SEARCH TERMS
        . . . . F  S ZJ=$O(ZTARY(ZJ)) Q:ZJ=""  D   ; FOR EACH SEARCH TERM
        . . . . . S ATTR=$O(ZTARY(ZJ,""))
        . . . . . S NTTXT=$O(ZTARY(ZJ,ATTR,""))
        . . . . . I $P($G(@ZL@(ZI,0)),NTTXT,2)'="" S FOUND=1 D  ;
        . . . . . . W "**********",$G(@ZL@(ZI,0)),!
        . . . . . . S ZC=$O(ZRTN(""),-1) ; NEXT COUNT
        . . . . . . I ZC="" S ZC=1
        . . . . . . E  S ZC=ZC+1
        . . . . . . S ZRTN(ZC,ATTR,ZTYP,ZN,NTTXT)=$G(@ZL@(ZI,0))
        Q $G(FOUND) ; IT'S THAT SIMPLE... PLEASE LEAVE SOME TEXT AT THE END OF WHAT
        ;
TESTALL ;
        S GT(1,"HasSmokingStatus","SMOK")=""
        S GT(2,"HasSmokingStatus","Smok")=""
        S GT(3,"HasSmokingStatus","smok")=""
        S GT(4,"HasMedRecon","MEDICATION RECONCILIATION COMPLET")=""
        S GT(5,"HasMedRecon","Medication Reconcilation Complete")=""
        W $$TXTALL(.G,.GT,2) ; CHECK ALL PATIENT 2'S NOTEST FOR SMOKING
        ZWR G
        Q
        ;
