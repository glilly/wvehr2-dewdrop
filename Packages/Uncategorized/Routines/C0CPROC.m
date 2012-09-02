C0CPROC  ; CCDCCR/GPL - CCR/CCD PROCESSING FOR PROCEDURES ; 01/21/10
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;Copyright 2010 George Lilly, University of Minnesota and others.
        ;Licensed under the terms of the GNU General Public License.
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
        W "NO ENTRY FROM TOP",!
        Q
        ;
SETVARS ; SET UP VARIABLES FOR PROCEDURES, ENCOUNTERS, AND NOTES
        S C0CENC=$NA(^TMP("C0CCCR",$J,"C0CENC",DFN))
        S C0CPRC=$NA(^TMP("C0CCCR",$J,"C0CPRC",DFN))
        S C0CNTE=$NA(^TMP("C0CCCR",$J,"C0CNTE",DFN))
        ; ADDITION FOR CERTIFICATION
        S C0CPRSLT=$NA(^TMP("C0CCCR",$J,"C0CPRSLT",DFN))
        Q
        ;
EXTRACT(PROCXML,DFN,PROCOUT)    ; EXTRACT PROCEDURES INTO  XML TEMPLATE
        ; PROCXML AND PROCOUT ARE PASSED BY NAME SO GLOBALS CAN BE USED
        ;
        D SETVARS ; SET UP VARIABLES
        I '$D(@C0CPRC) D TIUGET(DFN,C0CENC,C0CPRC,C0CNTE) ; GET VARS IF NOT THERE
        D MAP(PROCXML,C0CPRC,PROCOUT) ;MAP RESULTS FOR PROCEDURES
        Q
        ;
TIUGET(DFN,C0CENC,C0CPRC,C0CNTE)        ; CALLS ENTRY^C0CCPT TO GET PROCEDURES, 
        ; ENCOUNTERS AND NOTES. RETURNS THEM IN RNF2 ARRAYS PASSED BY NAME
        ; C0CENC: ENCOUNTERS, C0CPRC: PROCEDURES, C0CNTE: NOTES
        ; READY TO BE MAPPED TO XML BY MAP^C0CENC, MAP^C0CPROC, AND MAP^C0CCMT
        ; THESE RETURN ARRAYS ARE NOT INITIALIZED, BUT ARE ADDED TO IF THEY 
        ; EXIST. THIS IS SO THAT ADDITIONAL PROCEDURES CAN BE OBTAINED FROM
        ; THE SURGERY PACKGE AND ADDITIONAL COMMENTS FROM OTHER CCR SECTIONS
        ;
        K VISIT,LST,NOTE,C0CLPRC
        ; C0CLPRC IS A LOOKUP TABLE FOR USE IN BUILDING ENCOUNTERS
        ; FORMAT C0CLPRC(VISITIEN,CPT)=PROCOBJECTID FOR BUILDING LINKS TO PROCEDURES
        D ENTRY^C0CCPT(DFN,,,1) ; RETURNS ALL RESULTS IN VISIT LOCAL VARIABLE
        ; NEED TO ADD START AND END DATES FROM PARAMETERS
        N ZI S ZI=""
        N PREVCPT,PREVDT S (PREVCPT,PREVDT)=""
        F  S ZI=$O(VISIT(ZI),-1) Q:ZI=""  D  ; REVERSE TIME ORDER - MOST RECENT FIRST
        . N ZDATE
        . S ZDATE=$$DATE(VISIT(ZI,"DATE",0))
        . S ZPRVARY=$NA(VISIT(ZI,"PRV"))
        . N ZPRV
        . S ZPRV=$$PRV(ZPRVARY) ; THE PRIMARY PROVIDER OBJECT IN THE FORM
        . ; ACTORPROVIDER_IEN WHERE IEN IS THE PROVIDER IEN IN NEW PERSON 
        . N ZJ S ZJ=""
        . F  S ZJ=$O(VISIT(ZI,"CPT",ZJ)) Q:ZJ=""  D  ;FOR EACH CPT SEG
        . . N ZRNF
        . . N ZCPT S ZCPT=$$CPT(VISIT(ZI,"CPT",ZJ)) ;GET CPT CODE AND TEXT
        . . I ZCPT'="" D  ;IF CPT CODE IS PRESENT
        . . . I (ZCPT=PREVCPT)&(ZDATE=PREVDT) Q  ; NO DUPS ALLOWED
        . . . W !,ZCPT," ",ZDATE," ",ZPRV
        . . . S ZRNF("PROCACTOROBJID")=ZPRV
        . . . N PROCCODE S PROCCODE=$P(ZCPT,U,1)
        . . . S ZRNF("PROCCODE")=PROCCODE
        . . . S ZRNF("PROCCODESYS")="CPT-4"
        . . . S ZRNF("PROCDATETEXT")="Procedure Date"
        . . . S ZRNF("PROCDATETIME")=ZDATE
        . . . S ZRNF("PROCDESCOBJATTRCODE")="" ;NO PROC ATTRIBUTES YET
        . . . S ZRNF("PROCDESCOBJATTR")=""
        . . . S ZRNF("PROCDESCOBJATTRCODESYS")="" ;WE DON'T HAVE PROC ATTRIBUTES
        . . . S ZRNF("PROCDESCOBJATTRVAL")=""
        . . . S ZRNF("PROCDESCTEXT")=$P(ZCPT,U,3)
        . . . S ZRNF("PROCLINKID")="" ; NO LINKS YET
        . . . S ZRNF("PROCLINKREL")="" ; NO LINKS YET
        . . . ; additions for Certification - need to have EKG in Results
        . . . S ZRNF("PROCTEXT")=$G(VISIT(ZI,"TEXT",1)) ; POTENTIAL RESULT
        . . . S ZRNF("PROCOBJECTID")="PROCEDURE_"_ZI_"_"_ZJ
        . . . S C0CLPRC(ZI,PROCCODE)=ZRNF("PROCOBJECTID") ; LOOKUP TABLE FOR ENCOUNTERS
        . . . S ZRNF("PROCSTATUS")="Completed" ; Is this right?
        . . . S ZRNF("PROCTYPE")=$P(ZCPT,U,2) ; NEED TO ADD THIS TO TEMPLATE
        . . . D RNF1TO2^C0CRNF(C0CPRC,"ZRNF") ; ADD THIS ROW TO THE ARRAY
        . . . ; FOR CERTIFICATION - SAVE EKG RESULTS gpl
        . . . W !,"CPT=",ZCPT
        . . . I ZCPT["93000" D  ; THIS IS AN EKG
        . . . . D RNF1TO2^C0CRNF(C0CPRSLT,"ZRNF") ; SAVE FOR LABS
        . . . . M ^GPL("RNF2")=@C0CPRSLT
        . . . S PREVCPT=ZCPT
        . . . S PREVDT=ZDATE
        N ZRIM S ZRIM=$NA(^TMP("C0CRIM","VARS",DFN,"PROCEDURES"))
        M @ZRIM=@C0CPRC@("V")
        Q
        ;
PRV(IARY)       ; RETURNS THE PRIMARY PROVIDER FROM THE "PRV" ARRAY PASSED BY NAME
        N ZI,ZR,ZRTN S ZI="" S ZR="" S ZRTN=""
        F  S ZI=$O(@IARY@(ZI)) Q:ZI=""  D  ; FOR EACH PRV SEG
        . I ZR'="" Q  ;ONLY WANT THE FIRST PRIMARY PROVIDER
        . I $P(@IARY@(ZI),U,5)=1 S ZR=$P(@IARY@(ZI),U,1)
        I ZR'="" S ZRTN="ACTORPROVIDER_"_ZR
        Q ZRTN
        ;
DATE(ISTR)      ; EXTRINSIC TO RETURN THE DATE IN CCR FORMAT
        Q $$FMDTOUTC^C0CUTIL(ISTR,"DT")
        ;
CPT(ISTR)       ; EXTRINSIC THAT SEARCHES FOR CPT CODES AND RETURNS
        ; CPT^CATEGORY^TEXT
        N Z1,Z2,Z3,ZRTN
        S Z1=$P(ISTR,U,1) 
        I Z1="" D  ;
        . I ISTR["(CPT-4 " S Z1=$P($P(ISTR,"(CPT-4 ",2),")",1)
        I Z1'="" D  ; IF THERE IS A CPT CODE IN THERE
        . ;S Z1=$P(ISTR,U,1)
        . S Z2=$P(ISTR,U,2)
        . S Z3=$P(ISTR,U,3)
        . S ZRTN=Z1_U_Z2_U_Z3
        E  S ZRTN=""
        Q ZRTN
        ;
MAP(PROCXML,C0CPRC,PROCOUT)     ; MAP PROCEDURES XML 
        ;
        N ZTEMP S ZTEMP=$NA(^TMP("C0CCCR",$J,DFN,"PROCTEMP")) ;WORK AREA FOR TEMPLATE
        K @ZTEMP
        N ZBLD
        S ZBLD=$NA(^TMP("C0CCCR",$J,DFN,"PROCBLD")) ; BUILD LIST AREA
        D QUEUE^C0CXPATH(ZBLD,PROCXML,1,1) ; FIRST LINE
        N ZINNER
        D QUERY^C0CXPATH(PROCXML,"//Procedures/Procedure","ZINNER") ;ONE PROC
        N ZTMP,ZVAR,ZI
        S ZI=""
        F  S ZI=$O(@C0CPRC@("V",ZI)) Q:ZI=""  D  ;FOR EACH PROCEDURE
        . S ZTMP=$NA(@ZTEMP@(ZI)) ;THIS PROCEDURE XML
        . S ZVAR=$NA(@C0CPRC@("V",ZI)) ;THIS PROCEDURE VARIABLES
        . D MAP^C0CXPATH("ZINNER",ZVAR,ZTMP) ; MAP THE PROCEDURE
        . D QUEUE^C0CXPATH(ZBLD,ZTMP,1,@ZTMP@(0)) ;QUE FOR BUILD
        D QUEUE^C0CXPATH(ZBLD,PROCXML,@PROCXML@(0),@PROCXML@(0))
        N ZZTMP
        D BUILD^C0CXPATH(ZBLD,PROCOUT) ;BUILD FINAL XML
        K @ZTEMP,@ZBLD,@C0CPRC
        Q
        ;  
