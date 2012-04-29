C0CUTIL ;WV/C0C/SMH - Various Utilites for generating the CCR/CCD;06/15/08
 ;;0.1;C0C;;Jun 15, 2008;Build 2
 ;Copyright 2008-2009 Sam Habiel & George Lilly.
 ;Licensed under the terms of the GNU
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
 W "No Entry at Top!"
 Q
 ;
UUID()  ; thanks to Wally for this.
        N R,I,J,N
        S N="",R="" F  S N=N_$R(100000) Q:$L(N)>64
        F I=1:2:64 S R=R_$E("0123456789abcdef",($E(N,I,I+1)#16+1))
        Q $E(R,1,8)_"-"_$E(R,9,12)_"-4"_$E(R,14,16)_"-"_$E("89ab",$E(N,17)#4+1)_$E(R,18,20)_"-"_$E(R,21,32)
 ;
OLDUUID() ; GENERATE A RANDOM UUID (Version 4)
 N I,J,ZS
 S ZS="0123456789abcdef" S J=""
 F I=1:1:36 S J=J_$S((I=9)!(I=14)!(I=19)!(I=24):"-",I=15:4,I=20:"a",1:$E(ZS,$R(16)+1))
 Q J
 ;
FMDTOUTC(DATE,FORMAT) ; Convert Fileman Date to UTC Date Format; PUBLIC; Extrinsic
 ; FORMAT is Format of Date. Can be either D (Day) or DT (Date and Time)
 ; If not passed, or passed incorrectly, it's assumed that it is D.
 ; FM Date format is "YYYMMDD.HHMMSS" HHMMSS may not be supplied.
 ; UTC date is formatted as follows: YYYY-MM-DDThh:mm:ss_offsetfromUTC
 ; UTC, Year, Month, Day, Hours, Minutes, Seconds, Time offset (obtained from Mailman Site Parameters)
 N UTC,Y,M,D,H,MM,S,OFF
 S Y=1700+$E(DATE,1,3)
 S M=$E(DATE,4,5)
 S D=$E(DATE,6,7)
 S H=$E(DATE,9,10)
 I $L(H)=1 S H="0"_H
 S MM=$E(DATE,11,12)
 I $L(MM)=1 S MM="0"_MM
 S S=$E(DATE,13,14)
 I $L(S)=1 S S="0"_S
 S OFF=$$TZ^XLFDT ; See Kernel Manual for documentation.
 S OFFS=$E(OFF,1,1)
 S OFF0=$TR(OFF,"+-")
 S OFF1=$E(OFF0+10000,2,3)
 S OFF2=$E(OFF0+10000,4,5)
 S OFF=OFFS_OFF1_":"_OFF2
 ;S OFF2=$E(OFF,1,2) ;
 ;S OFF2=$E(100+OFF2,2,3) ; GPL 11/08 CHANGED TO -05:00 FORMAT
 ;S OFF3=$E(OFF,3,4) ;MINUTES
 ;S OFF=$S(OFF2="":"00",0:"00",1:OFF2)_"."_$S(OFF3="":"00",1:OFF3)
 ; If H, MM and S are empty, it means that the FM date didn't supply the time.
 ; In this case, set H, MM and S to "00"
 ; S:('$L(H)&'$L(MM)&'$L(S)) (H,MM,S)="00" ; IF ONLY SOME ARE MISSING?
 S:'$L(H) H="00"
 S:'$L(MM) MM="00"
 S:'$L(S) S="00"
 S UTC=Y_"-"_M_"-"_D_"T"_H_":"_MM_$S(S="":":00",1:":"_S)_OFF ; Skip's code to fix hanging colon if no seconds
 I $L($G(FORMAT)),FORMAT="DT" Q UTC ; Date with time.
 E  Q $P(UTC,"T")
 ;
SORTDT(V1,V2,ORDR) ; DATE SORT ARRAY AND RETURN INDEX IN V1 AND COUNT
 ; AS EXTRINSIC ORDR IS 1 OR -1 FOR FORWARD OR REVERSE
 ; DATE AND TIME ORDER. DEFAULT IS FORWARD
 ; V2 IS AN ARRAY OF DATES IN FILEMAN FORMAT
 ; V1 IS RETURNS INDIRECT INDEXES OF V2 IN REVERSE DATE ORDER
 ; SO V2(V1(X)) WILL RETURN THE DATES IN DATE/TIME ORDER
 ; THE COUNT OF THE DATES IS RETURNED AS AN EXTRINSIC
 ; BOTH V1 AND V2 ARE PASSED BY REFERENCE
 N VSRT ; TEMP FOR HASHING DATES
 N ZI,ZJ,ZTMP,ZCNT,ZP1,ZP2
 S ZCNT=V2(0) ; COUNTING NUMBER OF DATES
 F ZI=1:1:ZCNT D  ; FOR EACH DATE IN THE ARRAY
 . I $D(V2(ZI)) D  ; IF THE DATE EXISTS
 . . S ZP1=$P(V2(ZI),".",1) ; THE DATE PIECE
 . . S ZP2=$P(V2(ZI),".",2) ; THE TIME PIECE
 . . ; W "DATE: ",ZP1," TIME: ",ZP2,!
 . . S VSRT(ZP1,ZP2,ZI)=ZI ; INDEX OF DATE, TIME AND COUNT
 N ZG
 S ZG=$Q(VSRT(""))
 F  D  Q:ZG=""  ;
 . ; W ZG,!
 . D PUSH^C0CXPATH("V1",@ZG)
 . S ZG=$Q(@ZG)
 I ORDR=-1 D  ; HAVE TO REVERSE ORDER
 . N ZG2
 . F ZI=1:1:V1(0) D  ; FOR EACH ELELMENT
 . . S ZG2(V1(0)-ZI+1)=V1(ZI) ; SET IN REVERSE ORDER
 . S ZG2(0)=V1(0)
 . D CP^C0CXPATH("ZG2","V1") ; COPY OVER THE NEW ARRAY
 Q ZCNT
 ;
DA2SNO(RTN,DNAME) ; LOOK UP DRUG ALLERGY CODE IN ^LEX
 ; RETURNS AN ARRAY RTN PASSED BY REFERENCE
 ; THIS ROUTINE CAN BE USED AS AN RPC
 ; RTN(0) IS THE NUMBER OF ELEMENTS IN THE ARRAY
 ; RTN(1) IS THE SNOMED CODE FOR THE DRUG ALLERGY
 ;
 N LEXIEN
 I $O(^LEX(757.21,"ADIS",DNAME,""))'="" D  ; IEN FOUND FOR THIS DRUG
 . S LEXIEN=$O(^LEX(757.21,"ADIS",DNAME,"")) ; GET THE IEN IN THE LEXICON
 . W LEXIEN,!
 . S RTN(1)=$P(^LEX(757.02,LEXIEN,0),"^",2) ; SNOMED CODE IN P2
 . S RTN(0)=1 ; ONE THING RETURNED
 E  S RTN(0)=0 ; NOT FOUND
 Q
 ;
DASNO(DANAME) ; PRINTS THE SNOMED CODE FOR ALLERGY TO DRUG DANAME
 ;
 N DARTN
 D DA2SNO(.DARTN,DANAME) ; CALL THE LOOKUP ROUTINE
 I DARTN(0)>0 D  ; GOT RESULTS
 . W !,DARTN(1) ;PRINT THE SNOMED CODE
 E  W !,"NOT FOUND",!
 Q
 ;
DASNALL(WHICH) ; ROUTINE TO EXAMINE THE ADIS INDEX IN LEX AND RETRIEVE ALL
 ; ASSOCIATED SNOMED CODES
 N DASTMP,DASIEN,DASNO
 S DASTMP=""
 F  S DASTMP=$O(^LEX(757.21,WHICH,DASTMP)) Q:DASTMP=""  D  ; NAME OF MED
 . S DASIEN=$O(^LEX(757.21,WHICH,DASTMP,"")) ; IEN OF MED
 . S DASNO=$P(^LEX(757.02,DASIEN,0),"^",2) ; SNOMED CODE FOR ENTRY
 . W DASTMP,"=",DASNO,! ; PRINT IT OUT
 Q
 ;
RXNFN() Q 1130590011.001 ; RxNorm Concepts file number
 ;
CODE(ZVUID) ; EXTRINSIC WHICH RETURNS THE RXNORM CODE IF KNOWN OF
 ; THE VUID - RETURNS CODE^SYSTEM^VERSION TO USE IN THE CCR
 N ZRSLT S ZRSLT=ZVUID_"^"_"VUID"_"^" ; DEFAULT
 I $G(ZVUID)="" Q ""
 I '$D(^C0P("RXN")) Q ZRSLT ; ERX NOT INSTALLED
 N C0PIEN ; S C0PIEN=$$FIND1^DIC($$RXNFN,"","QX",ZVUID,"VUID")
 S C0PIEN=$O(^C0P("RXN","VUID",ZVUID,"")) ;GPL FIX FOR MULTIPLES
 N ZRXN S ZRXN=$$GET1^DIQ($$RXNFN,C0PIEN,.01)
 S ZRXN=$$NISTMAP(ZRXN) ; CHANGE THE CODE IF NEEDED
 I ZRXN'="" S ZRSLT=ZRXN_"^RXNORM^08AB_081201F"
 Q ZRSLT
 ;
NISTMAP(ZRXN) ; EXTRINSIC WHICH MAPS SOME RXNORM NUMBERS TO
 ; CONFORM TO NIST REQUIREMENTS
 ;INPATIENT CERTIFICATION
 I ZRXN=309362 S ZRXN=213169
 I ZRXN=855318 S ZRXN=855320
 I ZRXN=197361 S ZRXN=212549
 ;OUTPATIENT CERTIFICATION
 I ZRXN=310534 S ZRXN=205875
 I ZRXN=617312 S ZRXN=617314
 I ZRXN=310429 S ZRXN=200801
 I ZRXN=628953 S ZRXN=628958
 I ZRXN=745679 S ZRXN=630208
 I ZRXN=311564 S ZRXN=979334
 I ZRXN=836343 S ZRXN=836370
 Q ZRXN
 ;
RPMS() ; Are we running on an RPMS system rather than Vista?
 Q $G(DUZ("AG"))="I" ; If User Agency is Indian Health Service
VISTA() ; Are we running on Vanilla Vista?
 Q $G(DUZ("AG"))="V" ; If User Agency is VA
WV() ; Are we running on WorldVista?
 Q $G(DUZ("AG"))="E" ; Code for WV.
OV() ; Are we running on OpenVista?
 Q $G(DUZ("AG"))="O" ; Code for OpenVista
