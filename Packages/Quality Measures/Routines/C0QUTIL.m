C0QUTIL ;JJOH/ZAG/GPL - Utilities for C0Q Package ; 7/31/12 7:42am
        ;;1.0;C0Q;;May 21, 2012;Build 68
        ;
        ;2011 Licensed under the terms of the GNU General Public License
        ;See attached copy of the License.
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
AGE(DFN)        ; return current age in years and months
        ;
        Q:'$G(DFN)  ;quit if no there is no patient
        N DOB S DOB=$P(^DPT(+DFN,0),U,3) ;date of birth
        N YRS
        N DOD S DOD=+$G(^DPT(9,.35)) ;check for date of death
        I 'DOD D
        . N CDTE S CDTE=DT ;current date
        . S YRS=$E(CDTE,1,3)-$E(DOB,1,3)-($E(CDTE,4,7)<$E(DOB,4,7))
        E  D
        . S YRS=$E(DOD,1,3)-$E(DOB,1,3)-($E(DOD,4,7)<$E(DOB,4,7))
        ;
        ;Come back here and fix MONTHS and DAYS
        ;N CM S CM=+$E(DT,4,5) ;current month
        ;N CD S CD=+$E(DT,6,7) ;current day
        ;N BM S BM=+$E(DOB,4,5) ;birth month
        ;N BD S BD=+$E(DOB,6,7) ;birth day
        ;
        ;N DAYS S DAYS=""
        ;
        Q YRS ;_"y" gpl ..just want the number
        ;
        ;
DTDIFF(ZD1,ZT1,ZD2,ZT2,SHOW)    ; extrinsic which returns the number of minutes
        ; between 2 dates. ZD1 and ZD2 are fileman dates
        ; ZT1 AND ZT2 are valid times (military time) ie 20:10
        ; IF SHOW=1 DEBUGGING INTERMEDIATE VALUES WILL BE DISPLAYED
        I '$D(SHOW) S SHOW=0
        N GT1,GT2,GDT1,GDT2
        I ZT1[":" D  ;
        . S GT1=($P(ZT1,":",1)*3600)+($P(ZT1,":",2)*60) ; SECONDS
        . S GT2=($P(ZT2,":",1)*3600)+($P(ZT2,":",2)*60) ; SECONDS
        E  D  ;
        . S GT1=($E(ZT1,1,2)*3600)+($E(ZT1,3,4)*60)
        . S GT2=($E(ZT2,1,2)*3600)+($E(ZT2,3,4)*60)
        ;W:SHOW !,"SECONDS: ",GT1," ",GT2
        ;S %=GT1 D S^%DTC ; FILEMAN TIME
        ;S GDT1=ZD1_% ; FILEMAN DATE AND TIME
        ;S %=GT2 D S^%DTC ; FILEMAN TIME
        ;S GDT2=ZD2_% ; FILEMAN DATE AND TIME
        S GDT1=ZD1_"."_ZT1
        S GDT2=ZD2_"."_ZT2
        W:SHOW !,"FILEMAN: ",GDT1," ",GDT2
        N ZH1,ZH2
        S ZH1=$$FMTH^XLFDT(GDT1) ; $H FORMAT 
        S ZH2=$$FMTH^XLFDT(GDT2) ; $H FORMAT 
        W:SHOW !,"$H: ",ZH1," ",ZH2
        N ZSECS,ZMIN
        S ZSECS=$$HDIFF^XLFDT(ZH1,ZH2,2) ; DIFFERENCE IN $H
        W:SHOW !,"DIFF: ",ZSECS
        S ZMIN=ZSECS/60 ; DIFFERENCE IN MINUTES
        W:SHOW !,"MIN: ",ZMIN
        Q ZMIN
        ;
DT(X)   ; -- Returns FM date for X
        N Y,%DT S %DT="T",Y="" D:X'="" ^%DT
        Q Y
            ;
ZWRITE(NAME)    ; Replacement for ZWRITE ; Public Proc
        ; Pass NAME by name as a closed reference. lvn and gvn are both supported.
        ; : syntax is not supported (yet)
        N L S L=$L(NAME) ; Name length
        I $E(NAME,L-2,L)=",*)" S NAME=$E(NAME,1,L-3)_")" ; If last sub is *, remove it and close the ref
        N ORIGLAST S ORIGLAST=$QS(NAME,$QL(NAME))       ; Get last subscript upon which we can't loop further
        N ORIGQL S ORIGQL=$QL(NAME)         ; Number of subscripts in the original name
        I $D(@NAME)#2 W NAME,"=",$$FORMAT(@NAME),!        ; Write base if it exists
        ; $QUERY through the name. 
        ; Stop when we are out.
        ; Stop when the last subscript of the original name isn't the same as 
        ; the last subscript of the Name. 
        F  S NAME=$Q(@NAME) Q:NAME=""  Q:$QS(NAME,ORIGQL)'=ORIGLAST  W NAME,"=",$$FORMAT(@NAME),!
        QUIT
FORMAT(V)       ; Add quotes, replace control characters if necessary; Public $$
        ;If numeric, nothing to do.
        ;If no encoding required, then return as quoted string.
        ;Otherwise, return as an expression with $C()'s and strings.
        I +V=V Q V ; If numeric, just return the value.
        N QT S QT="""" ; Quote
        I $F(V,QT) D     ;chk if V contains any Quotes
        . S P=0          ;position pointer into V
        . F  S P=$F(V,QT,P) Q:'P  D  ;find next "
        . . S $E(V,P-1)=QT_QT        ;double each "
        . . S P=P+1                  ;skip over new "
        I $$CCC(V) D  Q V  ; If control character is present do this and quit
        . S V=$$RCC(QT_V_QT)  ; Replace control characters in "V"
        . S:$E(V,1,3)="""""_" $E(V,1,3)="" ; Replace doubled up quotes at start
        . S L=$L(V) S:$E(V,L-2,L)="_""""" $E(V,L-2,L)="" ; Replace doubled up quotes at end
        Q QT_V_QT ; If no control charactrrs, quit with "V"
        ;
CCC(S)  ;test if S Contains a Control Character or $C(255); Public $$
        Q:S?.E1C.E 1
        Q:$F(S,$C(255)) 1
        Q 0
RCC(NA) ;Replace control chars in NA with $C( ). Returns encoded string; Public $$
        Q:'$$CCC(NA) NA                         ;No embedded ctrl chars
        N OUT S OUT=""                          ;holds output name
        N CC S CC=0                             ;count ctrl chars in $C(
        N C                                     ;temp hold each char
        F I=1:1:$L(NA) S C=$E(NA,I) D           ;for each char C in NA
        . I C'?1C,C'=C255 D  S OUT=OUT_C Q      ;not a ctrl char
        . . I CC S OUT=OUT_")_""",CC=0          ;close up $C(... if one is open
        . I CC D
        . . I CC=256 S OUT=OUT_")_$C("_$A(C),CC=0  ;max args in one $C(
        . . E  S OUT=OUT_","_$A(C)              ;add next ctrl char to $C(
        . E  S OUT=OUT_"""_$C("_$A(C)
        . S CC=CC+1
        . Q
        Q OUT
END     ;end of C0QUTIL
