C0QHF   ; GPL - Health Factor Utility Routines ;9/02/11  17:05
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
        ; these routines are for quick lookups on HEALTH FACTOR and V HEALTH FACTOR
        ; files...
        ;
        ; from the DD:
        ;STANDARD DATA DICTIONARY #9000010.23 -- V HEALTH FACTORS FILE
        ;STORED IN ^AUPNVHF(  (6744 ENTRIES)
        ;CROSS REFERENCED BY: PATIENT NAME(AATOO), HEALTH FACTOR(AATOO1), VISIT(AD),
        ;    VISIT(AV10), HEALTH FACTOR(B), PATIENT NAME(C)
        ;
        ;STANDARD DATA DICTIONARY #9999999.64 -- HEALTH FACTORS FILE
        ;STORED IN ^AUTTHF(  (8656 ENTRIES)
        ;CROSS REFERENCED BY: CATEGORY(AC), ENTRY TYPE(AD), FACTOR(B), SYNONYM(D)
        ;
HFYN(DFN,C0QHF) ; EXTRINSIC RETURNS 1 (YES) OR 0 (NO) IF A PATIENT
        ; HAS A HEALTH FACTOR
        N ZI,ZJ,ZR
        S ZI=$O(^AUTTHF("B",C0QHF,"")) ; HEALTH FACTOR IEN
        I ZI="" D  Q 0 ;
        . W !,"BAD HEALTH FACTOR: ",C0QHF
        I $D(^AUPNVHF("AA",DFN,ZI)) S ZR=1
        E  S ZR=0
        Q ZR
        ;
HFIEN(ZHF)      ; EXTRINSIC RETURNS THE IEN OF THE HEALTHFACTOR
        N ZI
        S ZI=$O(^AUTTHF("B",ZHF,"")) ; HEALTH FACTOR IEN
        Q ZI
        ;
VHFIEN(DFN,ZHF) ; EXTRINSIC RETURNS THE LAST IEN OF THIS HEALTH FACTOR
        ; FOR THE PATIENT
        N ZG,ZJ,ZK
        S ZG=$$HFIEN(ZHF)
        I ZG="" Q  ; OPPS HEALTH FACTOR NOT FOUND
        S ZJ=$O(^AUPNVHF("AA",DFN,ZG,""),-1) ;DATE
        S ZK=$O(^AUPNVHF("AA",DFN,ZG,ZJ,"")) ;IEN
        Q ZK
        ;
HFCAT(RTN,DFN,C0QHFCAT) ; C0QFHCAT IS A HEALTH FACTOR CATEGORY
        ; RTN IS PASSED BY REFERENCE AND RETURNS AN ARRAY OF HEALTH FACTORS
        ; THAT THE PATIENT HAS IN THE CATEGORY. RETURNS NULL IF NONE
        ; FORMAT RNT(HEALTH FACTOR IEN,HEALTH FACTOR NAME)=""
        N ZI
        S ZI=$O(^AUTTHF("B",C0QHFCAT,"")) ; HEALTH FACTOR CATEGORY IEN
        N C0QN,C0QO,C0QR
        S C0QO=$NA(^AUPNVHF("AA",DFN)) ; ALL THE PATIENT'S HEALTH FACTORS
        S C0QN=$NA(^AUTTHF("AC",ZI)) ; ALL HEALTH FACTORS IN THIS CATEGORY
        D UNITY^C0QSET("C0QR",C0QN,C0QO) ; THE DIFFERENCE
        K RTN ; CLEAR THE RETURN ARRAY
        N ZJ S ZJ=""
        F  S ZJ=$O(C0QR(1,ZJ)) Q:ZJ=""  D  ; FOR ALL HEALTH FACTOR MATCHES
        . S RTN(ZJ,$P(^AUTTHF(ZJ,0),"^",1))=""
        Q
        ;
HFLCAT(RTN,C0QHFCAT)    ; RETURNS A LIST OF PATIENTS WHO HAVE A HEALTH FACTOR
        ; IN THE C0QHFCAT CATEGORY. RTN IS PASSED BY REFERENCE
        ; THIS WILL BE HARD TO DO WITHOUT SOME NEW INDEXES
        Q
        ;
HFLPAT(RTN,C0QHF)       ; RETURNS A LIST OF PATIENTS WHO HAVE A SPECIFIC HEALTH
        ; FACTOR. RTN IS PASSED BY REFERENCE
        ; THIS ONE ALSO WILL BE HARD TO DO QUICKLY WITHOUT A NEW INDEX
        Q
        ;
INDEXES(DDREF)  ;PRINT THE INDEXES ACTUALLY ON FILE DDREF
        ; IE D INDEXES($NA(^DD))
        N ZI
        S ZI="A"
        F  S ZI=$O(@DDREF@(ZI)) Q:ZI=""  W !,ZI
        Q
        ;
