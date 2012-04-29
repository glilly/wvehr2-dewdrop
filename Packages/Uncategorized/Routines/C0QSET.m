C0QSET  ;GPL - SET OPERATIONS ON LISTS ;818/11 8:50pm
        ;;1.0;MU PACKAGE;;;Build 23
        ;
        ;2011 George Lilly glilly@glilly.net - Licensed under the terms of the GNU
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
TEST    ; TEST OF UNITY ROUTINE
        ;
        S A(1)=""
        S A(2)=""
        S A(3)=""
        S B(3)=""
        S B(4)=""
        D UNITY("C","A","B")
        ZWR C
        Q
        ;
TEST2   ; WHICH PATIENTS HAVE MEDICATIONS? WHICH DON'T?
        ; WHAT BAD PATIENT POINTERS ARE IN THE MEDICATIONS FILE?
        S PATS=$NA(^DPT)
        S MEDS=$NA(^PS(55))
        D UNITY("DELTA",PATS,MEDS)
        W !,"PATIENTS WITH NO MEDS",!
        ZWR DELTA(0,*)
        W !,"BAD POINTERS IN THE MEDS FILE",!
        ZWR DELTA(2,*)
        Q
        ;
UNITY(ZRTN,ZNEW,ZOLD)   ; RETURNS THE DELTA BETWEEN THE NEW AND OLD LISTS
        ; ONLY NUMERIC LISTS SUPPORTED. FOR LIST WITH STRINGS SEE UNITYS
        ; ZRTN,ZNEW AND ZOLD ARE ALL PASSED BY NAME
        ; FORMAT OF RETURN ARRAY:
        ; @ZRTN@(0,X)="" ; X IS MISSING FROM OLD
        ; @ZRTN@(1,Y)="" ; Y IS IN BOTH NEW AND OLD - NOT MISSING
        ; @ZRTN@(2,Z)="" ; Z IS EXTRA IN OLD - WOULD BEED TO BE DELETED FOR UNITY
        N C0QD ; TEMP WORK ARRAY
        N ZN S ZN=0 ; COUNT
        N ZI S ZI=0
        F  S ZI=$O(@ZNEW@(ZI)) Q:+ZI=0  D  ; FOR EACH ITEM IN NEW
        . S C0QD(ZI)=0 ; SET THEM ALL AS 0 MEANING NEW
        . S ZN=ZN+1
        S @ZRTN@("COUNT")=ZN ; NEW FILE COUNT
        S ZI=0
        F  S ZI=$O(@ZOLD@(ZI)) Q:+ZI=0  D  ; FOR EACH ITEM IN OLD
        . I $D(C0QD(ZI)) S C0QD(ZI)=1 ; NOT NEW - PRESENT IN NEW AND OLD
        . E  S C0QD(ZI)=2 ; EXTRA IN OLD - WOULD NEED TO BE DELETED
        S ZI=0
        F  S ZI=$O(C0QD(ZI)) Q:+ZI=0  D  ; FOR EACH ITEM
        . S @ZRTN@(C0QD(ZI),ZI)="" ; SET RESULTS IN RETURN ARRAY
        Q
        ;
UNITYS(ZRTN,ZNEW,ZOLD)  ; RETURNS THE DELTA BETWEEN THE NEW AND OLD LISTS
        ; THIS VERSION HAS SUPPORT FOR NUMBERS AND STRINGS IN A LIST
        ; ZRTN,ZNEW AND ZOLD ARE ALL PASSED BY NAME
        ; FORMAT OF RETURN ARRAY:
        ; @ZRTN@(0,X)="" ; X IS MISSING FROM OLD
        ; @ZRTN@(1,Y)="" ; Y IS IN BOTH NEW AND OLD - NOT MISSING
        ; @ZRTN@(2,Z)="" ; Z IS EXTRA IN OLD - WOULD BEED TO BE DELETED FOR UNITY
        N C0QD ; TEMP WORK ARRAY
        N ZI S ZI=""
        F  S ZI=$O(@ZNEW@(ZI)) Q:ZI=""  D  ; FOR EACH ITEM IN NEW
        . S C0QD(ZI)=0 ; SET THEM ALL AS 0 MEANING NEW
        S ZI=""
        F  S ZI=$O(@ZOLD@(ZI)) Q:ZI=""  D  ; FOR EACH ITEM IN OLD
        . I $D(C0QD(ZI)) S C0QD(ZI)=1 ; NOT NEW - PRESENT IN NEW AND OLD
        . E  S C0QD(ZI)=2 ; EXTRA IN OLD - WOULD NEED TO BE DELETED
        S ZI=""
        F  S ZI=$O(C0QD(ZI)) Q:ZI=""  D  ; FOR EACH ITEM
        . S @ZRTN@(C0QD(ZI),ZI)="" ; SET RESULTS IN RETURN ARRAY
        Q
        ;
AND(ZRTN,ZNEW,ZOLD)     ; RETURNS A LIST OF WHAT IS COMMON TO BOTH NEW AND OLD
        N ZD
        D UNITY("ZD",ZNEW,ZOLD)
        M @ZRTN=ZD(1)
        Q
        ;
NAND(ZRTN,ZNEW,ZOLD)    ; RETURNS WHAT IS IN A OR B BUT NOT BOTH
        N ZD
        D UNITY("ZD",ZNEW,ZOLD)
        M @ZRTN=ZD(0)
        M @ZRTN=ZD(2)
        Q
        ;
AMINUSB(ZRTN,ZA,ZB)     ; WHAT'S LEFT IN A AFTER REMOVING B FROM IT
        N ZD
        D UNITY("ZD",ZA,ZB)
        M @ZRTN=ZD(0)
        Q
        ;
OR(ZRTN,ZA,ZB)  ; WHAT'S IN A OR B OR BOTH
        N ZD
        D UNITY("ZD",ZA,ZB)
        M @ZRTN=ZD(0)
        M @ZRTN=ZD(1)
        M @ZRTN=ZD(2)
        Q
        ;
END     ;end of C0QSET;
