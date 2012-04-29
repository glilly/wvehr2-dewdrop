ORWPT2  ; VOE//GT/GOW REV - Patient Lookup Functions ;5:19 PM  21 Jun 2010
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
        ;
        ;;VOE VWPT PACKAGE ENHANCEMENT UPDATES ADDED 11/14/06
        ;GFT PATIENT LOOKUP' RPC CALLS HERE FOR GENERAL PATIENT LOOKUP
        ; Ref. to ^UTILITY via IA 10061
        ;
        Q
        ;VWVOEDPT ;GFT  VOE PATIENT LOOKUP;6OCT2006
        ;;5.3;Registration;VWVF VOE LOCAL
        ;
        ;;Q
        ;
LOOKUP(LST,X1)  ;'GFT PATIENT LOOKUP' RPC CALLS HERE FOR GENERAL PATIENT LOOKUP
        K LST
        N GFTI,I,X,ILEN,IEN2,IENN,TAB,ILENP,X3,IEND,CR,XX
        N IRET
        N IDTMP,AJJTMP,AJJTMP1
        ;
        S X=X1
        I X="" Q
        S IEND=0
        ;UPPERCASE IT
        X "F %=1:1:$L(X) S:$E(X,%)?1L X=$E(X,0,%-1)_$C($A(X,%)-32)_$E(X,%+1,999)"
        S ILEN=$L(X)
        ;CHECK INPUT  TAB POSTION 20, 25, 30 WITH PRECEDING TRAILING BLANKS
        ;CHECK FOR INITITAL LOOKUP BY DFN AS !DFN
        ;CHECK FOR LOOKUP BY DFN AS 3 TAB POSITION FOR CLICKING AFTER PREVIOUS LOOKUP
        S TAB=$C(9)
        S X3=$P(X,TAB,3)
        I X3'="",X3'="OPT" D
        .S X=X3
        .S ILENP=$L(X)
        .S X=$E(X,2,ILENP) ;TAKEOUT !
        .S U="^",(GFTI,I)=0
        .D LISTPOPD(X)
        .S IEND=1
        E  D
        .S X=$P(X,TAB,1)
        I IEND=1 Q
        I $E(X1,1,1)="'" D
        .I ILEN'=1 S X=$E(X1,2,ILEN)
        .;CHECK FOR ENDING "'"
        .S CR=$C(13)
        .I $E(X1,ILEN,ILEN)'="'" S IEND=1
        .S X=$P(X,"'",1)
        S U="^",(GFTI,I)=0
        I IEND=1 Q
        S XX=X    ; NO CR FOR HRN
        F  S IRET=$$CHKX(X) Q:IRET'=1  S I=$O(^AUPNPAT("D",X,I)) Q:'I  I X=$$HRN^DGLBPID(I) D LISTPOPH(I)  ;I X=$P($$HRN^DGLBPID(I),"#",2
        Q:GFTI
        ;
        S X=XX
        ;NOW CHECK FOR B CROSS REFERENCE
        D FIND^DIC(2,,,"MPC",X,,"B") ; ^SSN^BS5")
        F I=0:0 S I=$O(^TMP("DILIST",$J,I)) Q:'I  D LISTPOPB(+^(I,0))
        K ^TMP("DILIST",$J)
        Q:GFTI>0
OVETT   ;
        Q:ILEN<4  ;USE ADOB LOOKUP XXX-
        ;
        ;
        ;
        ; NEW EDITS/GOW 8/12/07 BELOW. CHECK TO PREVENT ASSUMED CURRENT YEAR TRIGGER
        ; SELECTION AUTOMATICALLY WITH JUST MONTH DAY OR MM/DD INPUT. REQUIRE REMAINING YR ( 2 DIGIT MINIMUM)
        ; WE CAN USE NUMERIC ENTRY ( IE 2-3-56, 2/3/56 OR 2.3.56, JUN 12,68, ETC OR 4 DIGIT YEAR FOR EXPLICIT YEAR ENTRY, IE JUNE 1,1903
        S NOCONTIN=0
        D
        .S NOCONTIN=1
        .S IDTMP=$E($TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"),1,30)
        .I IDTMP'=X D
        ..S AJJTMP=$L($TR($P(X,",",2)," ")) I AJJTMP>1 S NOCONTIN=0 Q    ;CASE FOR SPECIFIC DATE ENTRY BY ALPHABETIC MONTH DAY AND "," AND AT LEAST 2 YR DATE
        ..S AJJTMP=$L($TR($P(X," ",2),",")) I AJJTMP>3 S NOCONTIN=0 Q     ;CASE FOR SPECIFIC ( MONTH DAY followed by " " (space) and Year ( 2 or4  digit yr)
        .I IDTMP'=X Q    ; ALPHABETICAL DATE OF SOME KIND WHICH HAS BEEN TESTED ALREADY
        .S AJJTMP=$L($TR($P(X,"-",3)," ")) I AJJTMP>1 S NOCONTIN=0      ;NUMERIC INPUT
        .S AJJTMP=$L($TR($P(X,"/",3)," ")) I AJJTMP>1 S NOCONTIN=0      ; NUMERIC INPUT
        .S AJJTMP=$L($TR($P(X,".",3)," ")) I AJJTMP>1 S NOCONTIN=0      ; NUMERIC INPUT
        I NOCONTIN=1 G TRYPH  ; TRY PHONE #
        ;END EDITS/GOW
        ;
        ;
        D FIND^DIC(2,,,"MPC",X,,"ADOB^B") ;^SSN^BS5")
        F I=0:0 S I=$O(^TMP("DILIST",$J,I)) Q:'I  D LISTPOP(+^(I,0),X1)
        K ^TMP("DILIST",$J)
        Q:GFTI>0
        ;TRY PHONE # WITH TRANSLATE
TRYPH   ;
        Q:ILEN<10
        S X=$E($TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()-_=+[]{}<>,./?:;'\|"),1,30)
        D FIND^DIC(2,,,"MPC",X,,"AZVWVOE^B") ;^SSN^BS5")
        F I=0:0 S I=$O(^TMP("DILIST",$J,I)) Q:'I  D LISTPOPP(+^(I,0),X1)
        K ^TMP("DILIST",$J)
        Q
CHKX(X) ;CHECK TO SEE IF LEGITIMATE HRN EXISTS FOR IHS PATIENT HRN
        N IDX,ILENM1,IFLAG
        S IFLAG=0
        S IDX=X
        ;TO SEE blank char inserts
        S ILENM1=$L(X)-1
        I ILENM1>0 D
        .S IDX=$E(X,1,ILENM1)
        E  D
        .S IDX=""
        F  S IDX=$O(^AUPNPAT("D",IDX)) Q:(IDX="")!(IFLAG=1)  D
        . I IDX=X S IFLAG=1
        Q IFLAG
CHKXB(X1)       ;CHECK TO SEE IF PATIENT NAME ENTERED TO ALLOW LOOKUP EVEN FOR SENSITIVE PATIENT
        N IDX,ILENM1,IFLAG,X
        S IFLAG=0
        S X=X1
        ;CONVERT UPPER CASE
        X "F %=1:1:$L(X) S:$E(X,%)?1L X=$E(X,0,%-1)_$C($A(X,%)-32)_$E(X,%+1,999)"
        S IDX=X
        ;TO SEE blank char inserts
        S ILENM1=$L(X)-1
        I ILENM1>0 D
        .S IDX=$E(X,1,ILENM1)
        E  D
        .S IDX=""
        F  S IDX=$O(^DPT("B",IDX)) Q:(IDX="")!(IFLAG=1)  D
        . I IDX=X S IFLAG=1
        Q IFLAG
LISTPOPB(DFN)   ;PATIENT NAME B X-REF
        N IEN
        N HRN,PHONE,X
        Q:($$SCREEN^DPTLK1(DFN))  ;SCREEN FOR VIP
        Q:GFTI=-1  I GFTI>500 K LST S GFTI=-1 ;WE RETURN 500 VALUES MAX
        S PHONE=$P($G(^DPT(DFN,.13)),U),HRN=$$HRN^DGLBPID(DFN)
        S GFTI=GFTI+1,LST(GFTI)=DFN_U_$P(^DPT(DFN,0),U)_U_$$FMTE^XLFDT($P(^(0),U,3))_TAB_"!"_DFN_U_$$ID^DGLBPID(DFN)_U_"'"_HRN_"'"_U_PHONE
        Q
LISTPOP(DFN,X1) ;DOB
        N IEN
        N HRN,PHONE,X
        S IEN=$$CHKXB(X1) ;ALLOW INPUT BY NAME ON CLICK
        Q:($$SCREEN^DPTLK1(DFN))&(IEN=0)  ;SCREEN FOR VIP
        Q:GFTI=-1  I GFTI>500 K LST S GFTI=-1 ;WE RETURN 500 VALUES MAX
        S PHONE=$P($G(^DPT(DFN,.13)),U),HRN=$$HRN^DGLBPID(DFN)
        S GFTI=GFTI+1,LST(GFTI)=DFN_U_$P(^DPT(DFN,0),U)_U_$$FMTE^XLFDT($P(^(0),U,3))_TAB_"!"_DFN_U_$$ID^DGLBPID(DFN)_U_"'"_HRN_"'"_U_PHONE
        Q
LISTPOPP(DFN,X1)        ;PHONE #
        N IEN
        N HRN,PHONE,X
        S IEN=$$CHKXB(X1) ;ALLOW INPUT BY NAME ON CLICK
        Q:($$SCREEN^DPTLK1(DFN))&(IEN=0)  ;SCREEN FOR VIP
        Q:GFTI=-1  I GFTI>500 K LST S GFTI=-1 ;WE RETURN 500 VALUES MAX
        S PHONE=$P($G(^DPT(DFN,.13)),U),HRN=$$HRN^DGLBPID(DFN)
        S GFTI=GFTI+1,LST(GFTI)=DFN_U_$P(^DPT(DFN,0),U)_U_PHONE_TAB_"!"_DFN_U_$$ID^DGLBPID(DFN)_U_"'"_HRN_"'"_U_PHONE
        Q
        ;
LISTPOPH(DFN)   ;Q:$$SCREEN^DPTLK1(DFN)  ;SCREEN FOR VIP FOR HRN
        N HRN,PHONE
        Q:GFTI=-1  I GFTI>500 K LST S GFTI=-1 ;WE RETURN 500 VALUES MAX
        S PHONE=$P($G(^DPT(DFN,.13)),U),HRN=$$HRN^DGLBPID(DFN)
        S GFTI=GFTI+1,LST(GFTI)=DFN_U_$P(^DPT(DFN,0),U)_U_"'"_HRN_"'"_TAB_"!"_DFN_U_$$FMTE^XLFDT($P(^(0),U,3))_U_$$ID^DGLBPID(DFN)_U_"'"_HRN_"'"_U_PHONE
        Q
LISTPOPD(DFN)   ;
        N IEN
        N HRN,PHONE,X
        ;NO SCREEN FOR VIP
        Q:GFTI=-1  I GFTI>500 K LST S GFTI=-1 ;WE RETURN 500 VALUES MAX
        S PHONE=$P($G(^DPT(DFN,.13)),U),HRN=$$HRN^DGLBPID(DFN)
        S GFTI=GFTI+1,LST(GFTI)=DFN_U_$P(^DPT(DFN,0),U)_U_$$FMTE^XLFDT($P(^(0),U,3))_TAB_"!"_DFN_U_$$ID^DGLBPID(DFN)_U_"'"_HRN_"'"_U_PHONE
        Q
        ;
VWPT1   ;VWPT NEW LOGIC . 4TH PIECE BELOW REPLACE $P(X,U,9)=SSN WITH ID AS $$ID^DGLBPID(DFN)
        ; THEN IF THIS VALUE = HRN AND BOTH '="" THEN PUT SINGLE QUOTES
        ; AROUND 4TH PIECE AS THIS IS SAME AS HRN.
        S ID=$$ID^DGLBPID(DFN) S HRN=$$HRN^DGLBPID(DFN)
        I (ID=HRN)&(HRN'="") S ID="'"_ID_"'"
        ;
        ;VWPT LINE BELOW WITH ID SUBSTITUTED FOR 9TH PIECE OF X
        S X=^DPT(DFN,0),REC=$P(X,U,1,3)_U_ID_U_U_$G(^(.1))_U_$G(^(.101))
        ; End VOE mod
        ;
        ; Following taken from ORWPT call to VWPT1 to save space
        ;
        S X=$P(REC,U,6) I $L(X) S $P(REC,U,5)=+$G(^DIC(42,+$O(^DIC(42,"B",X,0)),44))
        S $P(REC,U,8)=$$CWAD^ORQPT2(DFN)_U_$$EN1^ORQPT2(DFN)
        S X=$G(^DPT(DFN,.105)) I X S $P(REC,U,10)=$P($G(^DGPM(X,0)),U)
        S:'$D(IOST) IOST="P-OTHER"
        ;S $P(REC,U,11)=$$OTF^OR3CONV(DFN,1)
        S $P(REC,U,11)=0 ;06/21/2010
        D ELIG^VADPT S $P(REC,U,12)=$G(VAEL(3)) ;two pieces: SC^SC%
        I $L($T(GETICN^MPIF001)) S X=+$$GETICN^MPIF001(DFN) S:X>0 $P(REC,U,14)=X
        Q
VWPT2   ;VWPT  GET HRN AND ALTERNATE HRN
        S $P(REC,U,17)="'"_$$HRN^DGLBPID(DFN)_"'" ;$$HRN^VWVOEDPT(DFN)
        S $P(REC,U,18)=$$ALTHRN(DFN)
        K VAEL,VAERR ;VADPT call to kill?
        S ^DISV(DUZ,"^DPT(")=DFN
        Q
ALTHRN(DFN)     ;
        Q ""
