C0CXEWD   ; C0C/GPL - EWD based XPath utilities; 10/11/09
 ;;0.1;C0C;nopatch;noreleasedate;Build 2
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
 ;
TEST ;
 D XPATH($$FIRST($$ID("CCR1")),"/","GIDX","GARY")
 Q
 ;
TEST2 ;
 S REDUX="//soap:Envelope/soap:Body/GetPatientFullMedicationHistory5Response/GetPatientFullMedicationHistory5Result/patientDrugDetail"
 D XPATH($$FIRST($$ID("gpl")),"/","GIDX","GARY","",REDUX)
 Q
 ;
XPATH(ZOID,ZPATH,ZXIDX,ZXPARY,ZNUM,ZREDUX) ; RECURSIVE ROUTINE TO POPULATE
 ; THE XPATH INDEX ZXIDX, PASSED BY NAME
 ; THE XPATH ARRAY XPARY, PASSED BY NAME
 ; ZOID IS THE STARTING OID
 ; ZPATH IS THE STARTING XPATH, USUALLY "/"
 ; ZNUM IS THE MULTIPLE NUMBER [x], USUALLY NULL WHEN ON THE TOP NODE
 ; ZREDUX IS THE XPATH REDUCTION STRING, TAKEN OUT OF EACH XPATH IF PRESENT
 I '$D(ZREDUX) S ZREDUX=""
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
 I GD'="" S @ZXPARY@(NEWPATH)=GD ; IF YES, ADD IT TO THE XPATH ARRAY
 N ZFRST S ZFRST=$$FIRST(ZOID) ; SET FIRST CHILD
 I ZFRST'="" D  ; THERE IS A CHILD
 . N ZMULT S ZMULT=$$ISMULT(ZFRST) ; IS FIRST CHILD A MULTIPLE
 . D XPATH(ZFRST,NEWPATH,ZXIDX,ZXPARY,$S(ZMULT:1,1:""),ZREDUX) ; DO THE CHILD
 N GNXT S GNXT=$$NXTSIB(ZOID)
 I GNXT'="" D  ; MOVE ON TO THE NEXT SIBLING
 . D XPATH(GNXT,ZPATH,ZXIDX,ZXPARY,$S(ZNUM>0:ZNUM+1,1:""),ZREDUX) ; DO NEXT SIB
 Q
 ;
PARSE(INXML,INDOC) ;CALL THE EWD PARSER ON INXML, PASSED BY NAME
 ; INDOC IS PASSED AS THE DOCUMENT NAME TO EWD
 ; EXTRINSIC WHICH RETURNS THE DOCID ASSIGNED BY EWD
 N ZR
 M ^CacheTempEWD($j)=@INXML ;
 S ZR=$$parseDocument^%zewdHTMLParser(INDOC)
 Q ZR
 ;
ISMULT(ZOID) ; RETURN TRUE IF ZOID IS ONE OF A MULTIPLE
 N ZN
 S ZN=$$NXTSIB(ZOID)
 I ZN'="" Q $$TAG(ZOID)=$$TAG(ZN) ; IF TAG IS THE SAME AS NEXT SIB TAG
 Q 0
 ;
DETAIL(ZRTN,ZOID) ; RETURNS DETAIL FOR NODE ZOID IN ZRTN, PASSED BY NAME
 N DET
 D getElementDetails^%zewdXPath(ZOID,.DET)
 M @ZRTN=DET
 Q
 ;
ID(ZNAME) ;RETURNS THE docOID OF THE DOCUMENT NAMED ZNAME
 Q $$getDocumentNode^%zewdDOM(ZNAME)
 ;
NAME(ZOID) ;RETURNS THE NAME OF THE DOCUMENAT WITH docOID ZOID
 Q $$getDocumentName^%zewdDOM(ZOID)
 ;
FIRST(ZOID) ;RETURNS THE OID OF THE FIRST CHILD OF ZOID
 N GOID
 S GOID=ZOID
 S GOID=$$getFirstChild^%zewdDOM(GOID)
 I GOID="" Q ""
 I $$getNodeType^%zewdDOM(GOID)'=1 S GOID=$$NXTCHLD(GOID)
 Q GOID
 ;
HASCHILD(ZOID) ; RETURNS TRUE IF ZOID HAS CHILD NODES
 Q $$hasChildNodes^%zewdDOM(ZOID)
 ;
CHILDREN(ZRTN,ZOID) ;RETURNS CHILDREN OF ZOID IN ARRAY ZRTN, PASSED BY NAME
 N childArray
 d getChildrenInOrder^%zewdDOM(ZOID,.childArray)
 m @ZRTN=childArray
 q
 ;
TAG(ZOID) ; RETURNS THE XML TAG FOR THE NODE
 Q $$getName^%zewdDOM(ZOID)
 ;
NXTSIB(ZOID) ; RETURNS THE NEXT SIBLING
 Q $$getNextSibling^%zewdDOM(ZOID)
 ;
NXTCHLD(ZOID) ; RETURNS THE NEXT CHILD IN PARENT ZPAR
 N GOID
 S GOID=$$getNextChild^%zewdDOM($$PARENT(ZOID),ZOID)
 I GOID="" Q ""
 I $$getNodeType^%zewdDOM(GOID)'=1 S GOID=$$NXTCHLD(GOID)
 Q GOID
 ;
PARENT(ZOID) ; RETURNS PARENT OF ZOID
 Q $$getParentNode^%zewdDOM(ZOID)
 ;
DATA(ZT,ZOID) ; RETURNS DATA FOR THE NODE
 N ZT2
 S ZT2=$$getElementText^%zewdDOM(ZOID,.ZT2)
 M @ZT=ZT2
 Q
 ;Q $$getTextValue^%zewdXPath(ZOID)
 ;Q $$getData^%zewdDOM(ZOID,.ZT)
 ;
