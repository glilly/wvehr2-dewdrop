ORWPT3  ; VOE/GOW /REV - Patient Lookup Functions ;8/13/07  17:49
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**269**;Dec 17, 1997 LOCAL ;Build 33
        ; Copyright (C) 2007 WorldVistA
        ;
        ; This program is free software; you can redistribute it and/or modify
        ; it under the terms of the GNU General Public License as published by
        ; the Free Software Foundation; either version 2 of the License, or
        ; (at your option) any later version.
        ;
        ; This program is distributed in the hope that it will be useful,
        ; but WITHOUT ANY WARRANTY; without even the implied warranty of
        ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ; GNU General Public License for more details.
        ;
        ; You should have received a copy of the GNU General Public License
        ; along with this program; if not, write to the Free Software
        ; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
        ;'Modified' MAS Patient Look-up Check Cross-References June 1987
        ;;VOE VWPT PACKAGE ENHANCEMENT UPDATES ADDED WITH "OTHER" RADIOBUTTON LOOKUPS FOR DOB AND PHONE NO 11/14/06
        ;
        ; Ref. to ^UTILITY via IA 10061
        ;
        Q
        ;
        ;VWPT ENHANCEMENTS folow for "other" RADIO BUTTONlookup
OTHER(LST,IDIN,OTHER)   ; RADIO BUTTON Return a list of patients matching other ID identifier
        N I,ID,IEN,ILENX,XREF,IDM1,ILEN1,ILNM1,ILENM1,IDD1,IPAST1,IDXX,IDSS,IDD2,LEN1,IFDN,IDX,IDS,DATEF,ILEN1,IPAST,ZVW,TEMP,IVAL,IVAR1,IFIND,IFDNS,IVAR,ARRAY,ERRARRAY,IENS
        N IEN2,IENN,TAB,IX
        N ILENP,X3,IEND,IDXS,IENNNN
        N IDTMP,AJJTMP,AJJTMP1
        I IDIN="" Q
        S (I,IEN,IEND)=0
        S ID=IDIN
        S X=ID
        S ILENX=$L(X)
        ;REMOVES TABS
        ;CHECK INPUT  TAB POSTION 20, 25, 30 WITH PRECEDING TRAILING BLANKS
        S TAB=$C(9)
        S IX=$P(X,TAB,3) ; WAS 2ND POS
        I IX'="" D
        .S ILENP=$L(IX)
        .S X=$E(IX,2,ILENP) ; JUMP OVER !
        .S LST(1)=X_U_$P(^DPT(X,0),U)_U_$$FMTE^XLFDT($P(^(0),U,3))_TAB_"!"_X_U_$$ID^DGLBPID(X) ; $$SSN^DPTLK1_U_IVAL  ; RETURN OTHER AS 5TH PIECE
        .;
        .S IEND=1
        E  D
        .;JUST UPPER CASE IT
        .;UPPERCASE IT
        .X "F %=1:1:$L(X) S:$E(X,%)?1L X=$E(X,0,%-1)_$C($A(X,%)-32)_$E(X,%+1,999)"
        I IEND=1 Q
        S ID=X
        ;OTHER IS FIELD NAME
        ;GET THE FIELD NUMBER
        S IFDN=0
        S IFDN=$O(^DD(2,"B",OTHER,IFDN))
        I IFDN="" Q
        ;FOR NOW JUST USE ONE OF TWO CROSS-REFERENCES ,
        ;ONE FOR DOB AS ADOB AND THE OTHER FOR PHONE # AS AZVWVOE
        I OTHER="DATE OF BIRTH" S ICREF="ADOB"
        I OTHER="PHONE NUMBER [RESIDENCE]" D
        .S ICREF="AZVWVOE"
        .S ID=$E($TR(ID,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()-_=+[]{}<>,./?:;'\|"),1,30)
        I ICREF="AZVWVOE" I ILENX<7 Q
        ;
        ; NEW EDITS/GOW 8/12/07 BELOW. RADIO BUTTON HAS SLIGHTLY DIFFERENT FUNCTIONALITY THAN
        ; WITH GENERIC MULTI-SOURCE LOOKUP. ALSO, CHECK TO PREVENT ASSUMED CURRENT YEAR TRIGGER
        ; SELECTION AUTOMATICALLY WITH JUST MONTH DAY OR MM/DD INPUT. REQUIRE REMAINING YR ( 2 DIGIT MINIMUM)
        ; THE LOGIC ALLOWED A FUZZY MONTH ONLY LOOKUP FOR DOB AS A SPECIFIC DOB MAY NOT BE KNOWN ,OR REMEMBERED.
        ; FOR FUZZY LOGIC REQUIRE 4 DIGIT YEAR ON DATE RANGE W/O SPECIFIC DAY(DATE) ENTERED
        ; EXAMPLE, AS MONTH/YEAR ( IE, JUN 2005). NOW, MAKE CHANGE TO ALLOW THIS ONLY BY APHABETIC MONTH AND NUMERIC YEAR (2 OR 4 DIGIT) LOOKUP
        ; THEN FOR SPECIFIC DOB LOOKUP WITH RADIO BUTTON SELECTION, WE CAN USE NUMERIC ENTRY ( IE 2-3-56, 2/3/56 OR 2.3.56
        ; FOR WHICH WAIT FOR SELECTION WILL OCCUR UNTIL AT A TRAILING 2 DIGIT YEAR IS INPUT WITH THE FORMER FORMATS ABOVE
        S NOCONTIN=0
        I ICREF="ADOB" D
        .S NOCONTIN=1
        .S IDTMP=$E($TR(ID,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"),1,30)
        .I IDTMP'=ID D
        ..;ALPHABETIC FUZZY MONTH ALLOWED or a specific date for at least a 4 DIGIT year that must specified after a "," ( ie June 15,1968)
        ..;OTHERWISE CHECK FOR TRAILING YEAR
        ..S AJJTMP=$L($TR($P(ID,",",2)," ")) I AJJTMP>1 S NOCONTIN=0 Q    ;CASE FOR SPECIFIC DATE ENTRY BY ALPHABETIC MONTH DAY AND "," AND AT LEAST 2 YR DATE
        ..S AJJTMP=$L($TR($P(ID," ",2),",")) I AJJTMP>3 S NOCONTIN=0 Q     ;CASE FOR SPECIFIC ( MONTH DAY followed by " " (space) and Year ( 2 or4  digit yr)
        ..S AJJTMP=$L($TR($P(ID," ",2)," ")) I AJJTMP>3 S AJJTMP1=$TR(AJJTMP,",") I AJJTMP1=AJJTMP S NOCONTIN=0 Q     ;CASE FOR FUZZY DATE ( MONTH followed by " " (space) and Year (4  digit yr)
        .I IDTMP'=ID Q    ; ALPHABETICAL DATE OF SOME KIND WHICH HAS BEEN TESTED ALREADY
        .S AJJTMP=$L($TR($P(ID,"-",3)," ")) I AJJTMP>1 S NOCONTIN=0      ;NUMERIC INPUT
        .S AJJTMP=$L($TR($P(ID,"/",3)," ")) I AJJTMP>1 S NOCONTIN=0      ; NUMERIC INPUT
        .S AJJTMP=$L($TR($P(ID,".",3)," ")) I AJJTMP>1 S NOCONTIN=0      ; NUMERIC INPUT
        I NOCONTIN=1 Q
        ;END EDITS/GOW
        ;
        S IDX=ID
        ;TO SEE blank char inserts
        S ILENM1=$L(ID)-1
        I ILENM1>0 D
        .;S IDLC=$E(ID,1,ILENM1)
        .S IDX=$E(ID,1,ILENM1) S IDXS=IDX
        E  D
        .S IDX="" S IDXS=IDX
        Q:ILENX<4  ;USE PHONE NUMBER LOOKUP XXX-
        ;HOWEVER ID DATE OR DATE/TIME FIELD CONVERT ID TO
        ;INTERNAL TIME
        S DATEF=$P($G(^DD(2,IFDN,0)),"^",2)
        I DATEF["D" D
        .;NEW BELOW
        .S X=ID D ^%DT S IDX=Y S IDS=Y
        .I Y'=-1 D
        . . S ILNM1=$L(IDX)-1
        . . S IDX=$E(IDX,1,ILNM1)
        . . ;W !,"IDX=",IDX,"IDS=",IDS
        S IPAST=0
        S IPAST1=0
        S ILEN1=$L(ID)
        F  S IDX=$O(^DPT(ICREF,IDX)) Q:(IDX="")!(IPAST1=1)  D
        . S IEN=0
        . ;EXTRA TO GET TRAILING SPACES
        . I DATEF'["D" D
        . . S IDD1=$E(IDX,1,ILEN1) I $L(IDD1)<ILEN1 Q
        . F  S IEN=$O(^DPT(ICREF,IDX,IEN)) Q:IEN=""  D
        . . S IPAST=0
        . . ;W !,"IDX=",IDX," IDS=",IDS
        . .I DATEF["D" D
        . . .;CHECK FOR MONTH ONLY
        . . .I $E(IDS,6,7)="00" D
        . . . .S IDXX=$E(IDX,1,5) S IDSS=$E(IDS,1,5)
        . . . .;W !,"IDXX=",IDXX," IDSS=",IDSS
        . . . .I IDXX'=IDSS S IPAST=1
        . . . .I IDXX>IDSS S IPAST1=1 Q
        . . . .I IPAST=1 Q
        . . .E  D
        . . . .;W !,"IDX=",IDX
        . . . .I IDX'=IDS S IPAST=1
        . . . .I IDX>IDS S IPAST1=1 Q
        . . . .I IPAST=1 Q
        . .E  D
        . . .S IDD1=$E(IDX,1,ILEN1) S IDD2=$E(ID,1,ILEN1)
        . . .;W !,"IDD1=",IDD1 W !,"IDD2=",IDD2
        . . .I $$ISNUM(IDD2)&$$ISNUM(IDD1) D
        . . . .I IDD1'=IDD2 S IPAST=1
        . . . .I IDD1>IDD2 S IPAST1=1 Q
        . . . .I IPAST=1 Q
        . . . .;
        . . . .;
        . . .E  D
        . . . .;
        . . . .I IDD1'=IDD2 S IPAST=1
        . . . .I IDD1]IDD2 S IPAST1=1 Q
        . . . .I IPAST=1 Q
        . .I IPAST=1 Q
        . .I DATEF["D" D
        . . .S Y=IDX S X=IDX D DD^%DT S IVAL=Y
        . .E  D
        . . .S IVAL=IDX
        . .S I=I+1
        . .I $$SCREEN^DPTLK1(IEN) Q
        . .;IVAL IS NOT HRN NOW
        . .S LST(I)=IEN_U_$P(^DPT(IEN,0),U)_U_IVAL_TAB_"!"_IEN_U_$$FMTE^XLFDT($P(^(0),U,3))_U_$$ID^DGLBPID(IEN) ; _U_IVAL  ; RETURN OTHER AS 5TH PIECE
        Q
ISNUM(XA)       ;
        I XA=+XA Q 1
        Q 0
