C0CMXML   ; GPL - MXML based XPath utilities;10/13/09  17:05
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
        Q
        ; THIS FILE CONTAINS THE XPATH CREATOR, THE PARSE CALL TO THE MXML PARSER
        ; AND THE OUTXML XML GENERATOR THAT OUTPUTS XML FROM AN MXML DOM
        ; FOR CCD SPECIFIC ROUTINES, SEE C0CMCCD
        ; FOR TEMPLATE FILE RELATED ROUTINES, SEE C0CMXP
        ;
TEST    ;
        S C0CXMLIN=$NA(^TMP("C0CMXML",$J))
        K GARY
        W $$FTG^%ZISH("/home/vademo2/EHR/p/","mxml-test.xml",$NA(@C0CXMLIN@(1)),3)
        S C0CDOCID=$$PARSE(C0CXMLIN) W !,"DocID: ",C0CDOCID
        S REDUX="//ContinuityOfCareRecord/Body"
        D XPATH(1,"/","GIDX","GARY",,REDUX)
        D SEPARATE^C0CMCCD("GARY2","GARY")
        S ZI=""
        F  S ZI=$O(GARY2(ZI)) Q:ZI=""  D  ;
        . N GTMP,G2
        . M G2=GARY2(ZI)
        . D DEMUX2^C0CMXP("GTMP","G2",2)
        . M GARY3(ZI)=GTMP
        Q
        ;
TEST2   ;
        S REDUX="//soap:Envelope/soap:Body/GetPatientFullMedicationHistory5Response/GetPatientFullMedicationHistory5Result/patientDrugDetail"
        D XPATH(1,"/","GIDX","GARY","",REDUX)
        Q
        ;
TEST3   
        S C0CXMLIN=$NA(^TMP("C0CMXML",$J))
        K GARY,GTMP,GIDX
        K @C0CXMLIN
        W $$FTG^%ZISH("/home/vademo2/CCR/","SampleCCDDocument.xml",$NA(@C0CXMLIN@(1)),3)
        D CLEANARY^C0CMCCD("GTMP",C0CXMLIN) ; REMOVE CONTROL CHARACTERS
        K @C0CXMLIN
        M @C0CXMLIN=GTMP
        K GTMP
        D STRIPTXT^C0CMCCD("GTMP",C0CXMLIN)
        K @C0CXMLIN
        M @C0CXMLIN=GTMP
        K GTMP
        S C0CDOCID=$$PARSCCD^C0CMCCD(C0CXMLIN,"W") W !,"DocID: ",C0CDOCID
        S REDUX="//ClinicalDocument/component/structuredBody"
        D FINDTID^C0CMCCD ; FIND THE TEMPLATE IDS
        D FINDALT^C0CMCCD ; FIND ALTERNATE TAGS
        D SETCBK^C0CMCCD ; SET THE CALLBACK ROUTINE FOR TAGS
        D XPATH(1,"/","GIDX","GARY",,REDUX)
        K C0CCBK("TAG")
        D SEPARATE^C0CMCCD("GARY2","GARY") ; SEPARATE FOR EASIER BROWSING
        D TEST3A
        Q
        ;
TEST3A  ; INTERNAL ROUTINE
        S ZI=""
        F  S ZI=$O(GARY2(ZI)) Q:ZI=""  D  ;
        . N GTMP,G2
        . M G2=GARY2(ZI)
        . D DEMUX2^C0CMXP("GTMP","G2",2)
        . M GARY4(ZI)=GTMP
        Q
        ;
TESTQ   ; TEST OF THE QRDA TEMPLATE GPL 7/8/2010
        S C0CXMLIN=$NA(^TMP("C0CMXML",$J))
        K GARY,GTMP,GIDX
        K @C0CXMLIN
        W $$FTG^%ZISH("/home/vademo2/","QRDA_CategoryI_WorldVistA1.xml",$NA(@C0CXMLIN@(1)),3)
        D CLEANARY^C0CMCCD("GTMP",C0CXMLIN) ; REMOVE CONTROL CHARACTERS
        K @C0CXMLIN
        S GTMP(1)="<"_$P(GTMP(1),"<",2)
        M @C0CXMLIN=GTMP
        K GTMP
        D TESTQ2
        Q
        ;
TESTQ2  ; SECOND PART OF TESTQ
        D STRIPTXT^C0CMCCD("GTMP",C0CXMLIN)
        K @C0CXMLIN
        M @C0CXMLIN=GTMP
        K GTMP
        S C0CDOCID=$$PARSCCD^C0CMCCD(C0CXMLIN,"W") W !,"DocID: ",C0CDOCID
        S REDUX="//ClinicalDocument/component/structuredBody"
        D FINDTID^C0CMCCD ; FIND THE TEMPLATE IDS
        D FINDALT^C0CMCCD ; FIND ALTERNATE TAGS
        D SETCBK^C0CMCCD ; SET THE CALLBACK ROUTINE FOR TAGS
        D XPATH(1,"/","GIDX","GARY",,REDUX)
        K C0CCBK("TAG")
        D SEPARATE^C0CMCCD("GARY2","GARY") ; SEPARATE FOR EASIER BROWSING
        D TEST3A
        Q
        ;
TEST4   ; TEST OF OUTPUTING AN XML FILE FROM THE DOM .. this one is the CCR
        ;
        D TEST ; SET UP THE DOM
        D START^C0CMXMLB($$TAG(1),,"G")
        D NDOUT($$FIRST(1))
        D END^C0CMXMLB ;END THE DOCUMENT
        M ZCCR=^TMP("MXMLBLD",$J)
        ZWR ZCCR
        Q
        ;
TEST5   ; SAME AS TEST4, BUT THIS TIME THE CCD
        S C0CXMLIN=$NA(^TMP("C0CMXML",$J))
        K GARY,GTMP,GIDX
        K @C0CXMLIN
        W $$FTG^%ZISH("/home/vademo2/CCR/","SampleCCDDocument.xml",$NA(@C0CXMLIN@(1)),3)
        D CLEANARY^C0CMCCD("GTMP",C0CXMLIN) ; REMOVE CONTROL CHARACTERS
        K @C0CXMLIN
        M @C0CXMLIN=GTMP
        K GTMP
        D STRIPTXT^C0CMCCD("GTMP",C0CXMLIN)
        K @C0CXMLIN
        M @C0CXMLIN=GTMP
        K GTMP
        S C0CDOCID=$$PARSE(C0CXMLIN) W !,"DOCID: ",C0CDOCID  ;CALL REGULAR PARSER
        ;D XPATH(1,"/","GIDX2","GARY2",,REDUX)
        D OUTXML("ZCCD",C0CDOCID)
        ;D START^C0CMXMLB($$TAG(1),,"G")
        ;D NDOUT($$FIRST(1))
        ;D END^C0CMXMLB ;EOND THE DOCUMENT
        ;M ZCCD=^TMP("MXMLBLD",$J)
        ZWR ZCCD(1:30)
        Q
        ; 
XPATH(ZOID,ZPATH,ZXIDX,ZXPARY,ZNUM,ZREDUX)      ; RECURSIVE ROUTINE TO POPULATE
        ; THE XPATH INDEX ZXIDX, PASSED BY NAME
        ; THE XPATH ARRAY XPARY, PASSED BY NAME
        ; ZOID IS THE STARTING OID
        ; ZPATH IS THE STARTING XPATH, USUALLY "/"
        ; ZNUM IS THE MULTIPLE NUMBER [x], USUALLY NULL WHEN ON THE TOP NODE
        ; ZREDUX IS THE XPATH REDUCTION STRING, TAKEN OUT OF EACH XPATH IF PRESENT
        I $G(ZREDUX)="" S ZREDUX=""
        N NEWPATH
        N NEWNUM S NEWNUM=""
        I $G(ZNUM)>0 S NEWNUM="["_ZNUM_"]"
        S NEWPATH=ZPATH_"/"_$$TAG(ZOID)_NEWNUM ; CREATE THE XPATH FOR THIS NODE
        I $G(ZREDUX)'="" D  ; REDUX PROVIDED?
        . N GT S GT=$P(NEWPATH,ZREDUX,2)
        . I GT'="" S NEWPATH=GT
        S @ZXIDX@(NEWPATH)=ZOID ; ADD THE XPATH FOR THIS NODE TO THE XPATH INDEX
        N GD D DATA("GD",ZOID) ; SEE IF THERE IS DATA FOR THIS NODE
        I $D(GD(2)) M @ZXPARY@(NEWPATH)=GD ; IF MULITPLE DATA MERGE TO THE ARRAY
        E  I $D(GD(1)) S @ZXPARY@(NEWPATH)=GD(1) ; IF SINGLE VALUE, ADD TO ARRAY
        N ZFRST S ZFRST=$$FIRST(ZOID) ; SET FIRST CHILD
        I ZFRST'=0 D  ; THERE IS A CHILD
        . N ZNUM
        . N ZMULT S ZMULT=$$ISMULT(ZFRST) ; IS FIRST CHILD A MULTIPLE
        . D XPATH(ZFRST,NEWPATH,ZXIDX,ZXPARY,$S(ZMULT:1,1:""),ZREDUX) ; DO THE CHILD
        N GNXT S GNXT=$$NXTSIB(ZOID)
        I $$TAG(GNXT)'=$$TAG(ZOID) S ZNUM="" ; RESET COUNTING AFTER MULTIPLES
        I GNXT'=0 D  ;
        . N ZMULT S ZMULT=$$ISMULT(GNXT) ; IS THE SIBLING A MULTIPLE?
        . I (ZNUM="")&(ZMULT) D  ; SIBLING IS FIRST OF MULTIPLES
        . . N ZNUM S ZNUM=1 ;
        . . D XPATH(GNXT,ZPATH,ZXIDX,ZXPARY,ZNUM,ZREDUX) ; DO NEXT SIB
        . E  D XPATH(GNXT,ZPATH,ZXIDX,ZXPARY,$S(ZNUM>0:ZNUM+1,1:""),ZREDUX) ; DO NEXT SIB
        Q
        ;
PARSE(INXML,INDOC)      ;CALL THE MXML PARSER ON INXML, PASSED BY NAME
        ; INDOC IS PASSED AS THE DOCUMENT NAME - DON'T KNOW WHERE TO STORE THIS NOW
        ; EXTRINSIC WHICH RETURNS THE DOCID ASSIGNED BY MXML
        ;Q $$EN^MXMLDOM(INXML)
        Q $$EN^MXMLDOM(INXML,"W")
        ;
ISMULT(ZOID)    ; RETURN TRUE IF ZOID IS ONE OF A MULTIPLE
        N ZN
        ;I $$TAG(ZOID)["entry" B
        S ZN=$$NXTSIB(ZOID)
        I ZN'="" Q $$TAG(ZOID)=$$TAG(ZN) ; IF TAG IS THE SAME AS NEXT SIB TAG
        Q 0
        ;
FIRST(ZOID)     ;RETURNS THE OID OF THE FIRST CHILD OF ZOID
        Q $$CHILD^MXMLDOM(C0CDOCID,ZOID)
        ;
PARENT(ZOID)    ;RETURNS THE OID OF THE PARENT OF ZOID
        Q $$PARENT^MXMLDOM(C0CDOCID,ZOID)
        ;
ATT(RTN,NODE)   ;GET ATTRIBUTES FOR ZOID
        S HANDLE=C0CDOCID
        K @RTN
        D GETTXT^MXMLDOM("A")
        Q
        ;
TAG(ZOID)       ; RETURNS THE XML TAG FOR THE NODE
        ;I ZOID=149 B ;GPLTEST
        N X,Y
        S Y=""
        S X=$G(C0CCBK("TAG")) ;IS THERE A CALLBACK FOR THIS ROUTINE
        I X'="" X X ; EXECUTE THE CALLBACK, SHOULD SET Y
        I Y="" S Y=$$NAME^MXMLDOM(C0CDOCID,ZOID)
        Q Y
        ;
NXTSIB(ZOID)    ; RETURNS THE NEXT SIBLING
        Q $$SIBLING^MXMLDOM(C0CDOCID,ZOID)
        ;
DATA(ZT,ZOID)   ; RETURNS DATA FOR THE NODE
        ;N ZT,ZN S ZT=""
        ;S C0CDOM=$NA(^TMP("MXMLDOM",$J,C0CDOCID))
        ;Q $G(@C0CDOM@(ZOID,"T",1))
        S ZN=$$TEXT^MXMLDOM(C0CDOCID,ZOID,ZT)
        Q
        ;
OUTXML(ZRTN,INID)       ; USES C0CMXMLB (MXMLBLD) TO OUTPUT XML FROM AN MXMLDOM
        ;
        S C0CDOCID=INID
        D START^C0CMXMLB($$TAG(1),,"G")
        D NDOUT($$FIRST(1))
        D END^C0CMXMLB ;END THE DOCUMENT
        M @ZRTN=^TMP("MXMLBLD",$J)
        K ^TMP("MXMLBLD",$J)
        Q
        ;
NDOUT(ZOID)     ;CALLBACK ROUTINE - IT IS RECURSIVE
        N ZI S ZI=$$FIRST(ZOID)
        I ZI'=0 D  ; THERE IS A CHILD
        . N ZATT D ATT("ZATT",ZOID) ; THESE ARE THE ATTRIBUTES MOVED TO ZATT
        . D MULTI^C0CMXMLB("",$$TAG(ZOID),.ZATT,"NDOUT^C0CMXML(ZI)") ;HAVE CHILDREN
        E  D  ; NO CHILD - IF NO CHILDREN, A NODE HAS DATA, IS AN ENDPOINT
        . ;W "DOING",ZOID,!
        . N ZD D DATA("ZD",ZOID) ;NODES WITHOUT CHILDREN HAVE DATA
        . N ZATT D ATT("ZATT",ZOID) ;ATTRIBUTES
        . D ITEM^C0CMXMLB("",$$TAG(ZOID),.ZATT,$G(ZD(1))) ;NO CHILDREN
        I $$NXTSIB(ZOID)'=0 D  ; THERE IS A SIBLING
        . D NDOUT($$NXTSIB(ZOID)) ;RECURSE FOR SIBLINGS
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
