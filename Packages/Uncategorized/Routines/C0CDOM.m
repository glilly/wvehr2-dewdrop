C0CDOM   ; GPL - DOM PROCESSING ROUTINES ;6/6/11  17:05
 ;;0.1;C0C;nopatch;noreleasedate;Build 2
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
DOMO(ZOID,ZPATH,ZNARY,ZXIDX,ZXPARY,ZNUM,ZREDUX) ; RECURSIVE ROUTINE TO POPULATE
 ; THE XPATH INDEX ZXIDX, PASSED BY NAME
 ; THE XPATH ARRAY XPARY, PASSED BY NAME
 ; ZOID IS THE STARTING OID
 ; ZPATH IS THE STARTING XPATH, USUALLY "/"
 ; ZNUM IS THE MULTIPLE NUMBER [x], USUALLY NULL WHEN ON THE TOP NODE
 ; ZREDUX IS THE XPATH REDUCTION STRING, TAKEN OUT OF EACH XPATH IF PRESENT
 I $G(ZREDUX)="" S ZREDUX=""
 N NEWPATH,NARY ; NEWPATH IS AN XPATH NARY IS AN NHIN MUMPS ARRAY
 N NEWNUM S NEWNUM=""
 I $G(ZNUM)>0 S NEWNUM="["_ZNUM_"]"
 S NEWPATH=ZPATH_"/"_$$TAG(ZOID)_NEWNUM ; CREATE THE XPATH FOR THIS NODE
 I $G(ZREDUX)'="" D  ; REDUX PROVIDED?
 . N GT S GT=$P(NEWPATH,ZREDUX,2)
 . I GT'="" S NEWPATH=GT
 S @ZXIDX@(NEWPATH)=ZOID ; ADD THE XPATH FOR THIS NODE TO THE XPATH INDEX
 N GA D ATT("GA",ZOID) ; GET ATTRIBUTES FOR THIS NODE
 I $D(GA) D  ; PROCESS THE ATTRIBUTES
 . N ZI S ZI=""
 . F  S ZI=$O(GA(ZI)) Q:ZI=""  D  ; FOR EACH ATTRIBUTE
 . . N ZP S ZP=NEWPATH_"@"_ZI ; PATH FOR ATTRIBUTE
 . . S @ZXPARY@(ZP)=GA(ZI) ; ADD THE ATTRIBUTE XPATH TO THE XP ARRAY
 . . I GA(ZI)'="" D ADDNARY(ZP,GA(ZI)) ; ADD THE NHIN ARRAY VALUE
 N GD D DATA("GD",ZOID) ; SEE IF THERE IS DATA FOR THIS NODE
 I $D(GD(2)) D  ;
 . M @ZXPARY@(NEWPATH)=GD ; IF MULITPLE DATA MERGE TO THE ARRAY
 E  I $D(GD(1)) D  ;
 . S @ZXPARY@(NEWPATH)=GD(1) ; IF SINGLE VALUE, ADD TO ARRAY
 . I GD(1)'="" D ADDNARY(NEWPATH,GD(1)) ; ADD TO NHIN ARRAY
 N ZFRST S ZFRST=$$FIRST(ZOID) ; SET FIRST CHILD
 I ZFRST'=0 D  ; THERE IS A CHILD
 . N ZNUM
 . N ZMULT S ZMULT=$$ISMULT(ZFRST) ; IS FIRST CHILD A MULTIPLE
 . D DOMO(ZFRST,NEWPATH,ZNARY,ZXIDX,ZXPARY,$S(ZMULT:1,1:""),ZREDUX) ; THE CHILD
 N GNXT S GNXT=$$NXTSIB(ZOID)
 I $$TAG(GNXT)'=$$TAG(ZOID) S ZNUM="" ; RESET COUNTING AFTER MULTIPLES
 I GNXT'=0 D  ;
 . N ZMULT S ZMULT=$$ISMULT(GNXT) ; IS THE SIBLING A MULTIPLE?
 . I (ZNUM="")&(ZMULT) D  ; SIBLING IS FIRST OF MULTIPLES
 . . N ZNUM S ZNUM=1 ;
 . . D DOMO(GNXT,ZPATH,ZNARY,ZXIDX,ZXPARY,ZNUM,ZREDUX) ; DO NEXT SIB
 . E  D DOMO(GNXT,ZPATH,ZNARY,ZXIDX,ZXPARY,$S(ZNUM>0:ZNUM+1,1:""),ZREDUX) ; SIB
 Q
 ;
ADDNARY(ZXP,ZVALUE) ; ADD AN NHIN ARRAY VALUE TO ZNARY
 ;
 ; IF ZATT=1 THE ARRAY IS ADDED AS ATTRIBUTES
 ;
 N ZZI,ZZJ,ZZN
 S ZZI=$P(ZXP,"/",1) ; FIRST PIECE OF XPATH ARRAY
 I ZZI="" Q  ; DON'T ADD THIS ONE .. PROBABLY THE //results NODE
 S ZZJ=$P(ZXP,ZZI_"/",2) ; REST OF XPATH ARRAY
 S ZZJ=$TR(ZZJ,"/",".") ; REPLACE / WITH .
 I ZZI'["]" D  ; A SINGLETON
 . S ZZN=1
 E  D  ; THERE IS AN [x] OCCURANCE
 . S ZZN=$P($P(ZZI,"[",2),"]",1) ; PULL OUT THE OCCURANCE
 . S ZZI=$P(ZZI,"[",1) ; TAKE OUT THE [X]
 I ZZJ'="" D  ; TIME TO ADD THE VALUE
 . S @ZNARY@(ZZI,ZZN,ZZJ)=ZVALUE
 Q
 ;
PARSE(INXML,INDOC) ;CALL THE MXML PARSER ON INXML, PASSED BY NAME
 ; INDOC IS PASSED AS THE DOCUMENT NAME - DON'T KNOW WHERE TO STORE THIS NOW
 ; EXTRINSIC WHICH RETURNS THE DOCID ASSIGNED BY MXML
 ;Q $$EN^MXMLDOM(INXML)
 Q $$EN^MXMLDOM(INXML,"W")
 ;
ISMULT(ZOID) ; RETURN TRUE IF ZOID IS ONE OF A MULTIPLE
 N ZN
 ;I $$TAG(ZOID)["entry" B
 S ZN=$$NXTSIB(ZOID)
 I ZN'="" Q $$TAG(ZOID)=$$TAG(ZN) ; IF TAG IS THE SAME AS NEXT SIB TAG
 Q 0
 ;
FIRST(ZOID) ;RETURNS THE OID OF THE FIRST CHILD OF ZOID
 Q $$CHILD^MXMLDOM(C0CDOCID,ZOID)
 ;
PARENT(ZOID) ;RETURNS THE OID OF THE PARENT OF ZOID
 Q $$PARENT^MXMLDOM(C0CDOCID,ZOID)
 ;
ATT(RTN,NODE) ;GET ATTRIBUTES FOR ZOID
 S HANDLE=C0CDOCID
 K @RTN
 D GETTXT^MXMLDOM("A")
 Q
 ;
TAG(ZOID) ; RETURNS THE XML TAG FOR THE NODE
 ;I ZOID=149 B ;GPLTEST
 N X,Y
 S Y=""
 S X=$G(C0CCBK("TAG")) ;IS THERE A CALLBACK FOR THIS ROUTINE
 I X'="" X X ; EXECUTE THE CALLBACK, SHOULD SET Y
 I Y="" S Y=$$NAME^MXMLDOM(C0CDOCID,ZOID)
 Q Y
 ;
NXTSIB(ZOID) ; RETURNS THE NEXT SIBLING
 Q $$SIBLING^MXMLDOM(C0CDOCID,ZOID)
 ;
DATA(ZT,ZOID) ; RETURNS DATA FOR THE NODE
 ;N ZT,ZN S ZT=""
 ;S C0CDOM=$NA(^TMP("MXMLDOM",$J,C0CDOCID))
 ;Q $G(@C0CDOM@(ZOID,"T",1))
 S ZN=$$TEXT^MXMLDOM(C0CDOCID,ZOID,ZT)
 Q
 ;
OUTXML(ZRTN,INID,NO1ST) ; USES C0CMXMLB (MXMLBLD) TO OUTPUT XML FROM AN MXMLDOM
 ;
 S C0CDOCID=INID
 I '$D(NO1ST) S NO1ST=0 ; DO NOT SURPRESS THE <?xml tag generation
 D START^C0CMXMLB($$TAG(1),,"G",NO1ST)
 D NDOUT($$FIRST(1))
 D END^C0CMXMLB ;END THE DOCUMENT
 M @ZRTN=^TMP("MXMLBLD",$J)
 K ^TMP("MXMLBLD",$J)
 Q
 ;
NDOUT(ZOID) ;CALLBACK ROUTINE - IT IS RECURSIVE
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
WNHIN(ZDFN) ; WRITES THE XML OUTPUT OF GET^NHINV TO AN XML FILE
 ;
 N GN,GN2
 D GET^NHINV(.GN,ZDFN) ; EXTRACT THE XML
 S GN2=$NA(@GN@(1))
 W $$OUTPUT^C0CXPATH(GN2,"nhin_"_ZDFN_".xml","/home/wvehr3-09/")
 Q
 ;
NARY2XML(ZGOUT,ZGIN) ; CREATE XML FROM AN NHIN ARRAY
 ; ZGOUT AND ZGIN ARE PASSED BY NAME
 N C0CDOCID
 W !,ZGOUT," ",ZGIN
 S C0CDOCID=$$DOMI(ZGIN) ; PUT IT INTO THE DOM
 D OUTXML(ZGOUT,C0CDOCID)
 Q
 ;
 ; EXAMPLE OF NHIN ARRAY FORMAT - THIS IS AN OUTPUT OF DOMO ABOVE WHEN RUN
 ; AGAINST THE OUTPUT OF THE GET^NHINV ROUTINE. (THIS IS NOT REAL PATIENT DATA)
 ;
 ;GNARY("med",1,"doses.dose@dose")=10
 ;GNARY("med",1,"doses.dose@noun")="TABLET"
 ;GNARY("med",1,"doses.dose@route")="PO"
 ;GNARY("med",1,"doses.dose@schedule")="QD"
 ;GNARY("med",1,"doses.dose@units")="MG"
 ;GNARY("med",1,"doses.dose@unitsPerDose")=1
 ;GNARY("med",1,"facility@code")=100
 ;GNARY("med",1,"facility@name")="VOE OFFICE INSTITUTION"
 ;GNARY("med",1,"form@value")="TAB"
 ;GNARY("med",1,"id@value")="1N;O"
 ;GNARY("med",1,"location@code")=5
 ;GNARY("med",1,"location@name")="3 WEST"
 ;GNARY("med",1,"name@value")="LISINOPRIL TAB"
 ;GNARY("med",1,"orderID@value")=294
 ;GNARY("med",1,"ordered@value")=3110531.001233
 ;GNARY("med",1,"orderingProvider@code")=63
 ;GNARY("med",1,"orderingProvider@name")="KING,MATTHEW MICHAEL"
 ;GNARY("med",1,"products.product.class@code")="ACE INHIBITORS"
 ;GNARY("med",1,"products.product.vaGeneric@code")=1990
 ;GNARY("med",1,"products.product.vaGeneric@name")="LISINOPRIL"
 ;GNARY("med",1,"products.product.vaGeneric@vuid")=4019380
 ;GNARY("med",1,"products.product.vaProduct@code")=8118
 ;GNARY("med",1,"products.product.vaProduct@name")="LISINOPRIL 10MG TAB"
 ;GNARY("med",1,"products.product.vaProduct@vuid")=4008593
 ;GNARY("med",1,"products.product@code")=6174
 ;GNARY("med",1,"products.product@name")="LISINOPRIL 10MG U/D"
 ;GNARY("med",1,"products.product@role")="D"
 ;GNARY("med",1,"sig")="10MG BY MOUTH EVERY DAY"
 ;GNARY("med",1,"sig@xml:space")="preserve"
 ;GNARY("med",1,"status@value")="active"
 ;GNARY("med",1,"type@value")="OTC"
 ;GNARY("med",1,"vaType@value")="N"
 ;
 ; DOMI is an extrinsic to insert NHIN ARRAY FORMAT arrays into the DOM
 ; it returns 0 or 1 based on success.
 ;
 ; INARY is passed by name and has the format shown above
 ; HANDLE is the document number in the DOM (both MXML and EWD DOMs will
 ; be supported eventually - initial implementation is for MXML
 ;
 ; PARENT is the node id or tag of the parent under which the DOM will
 ; be populated. If it is numeric, it is a node. If it is a string, the DOM
 ; will be searched to find the tag. If not found and there is no root,
 ; it will be inserted as the root. If not found and there is a root, it
 ; will be inserted under the root.
 ;
 ; For the above example the call would be OK=$$DOMI("GNARY",0,"results")
 ; because "results" is the root tag. Use OUTXML to render the xml from
 ; the DOM.
 ;
DOMI(INARY,HANDLE,PARENT) ; EXTRINSIC TO INSERT NHIN ARRAYS TO A DOM
 ;
 N ZPARNODE
 S (SUCCESS,LEVEL,LEVEL(0),NODE)=0
 I '$D(INARY) Q 0 ; NO ARRAY PASSED
 I '$D(HANDLE) S HANDLE=$$NEWDOM() ; MAKE A NEW DOM
 ;I PARENT="" S PARENT="root"
 I +$G(PARENT)>0 S ZPARNODE=PARENT ; WE HAVE BEEN PASSED A PARENT NODE ID
 E  I $L($G(PARENT))>0 D  ; TBD FIND THE PARENT IN THE DOM AND SET LEVEL
 . D STARTELE^MXMLDOM(PARENT) ; INSERT THE PARENT NODE
 . S ZPARNODE=1 ;
 ; WE NOW HAVE A HANDLE AND A PARENT NODE AND LEVEL HAS BEEN SET
 N ZEXARY
 D EXPAND("ZEXARY",INARY) ; EXPAND THE NHIN ARRAY
 D MAJOR("ZEXARY") ; PROCESS ALL THE NODES TO BE ADDED
 I $L($G(PARENT))>0 D ENDELE^MXMLDOM(PARENT) ; CLOSE OUT THE PARENT NODE
 Q HANDLE ; SUCCESS
 ;
MAJOR(ZARY) ; RECURSIVE ROUTINE FOR INTERMEDIATE NODES
 N ZI S ZI=""
 N ZTAG
 F  S ZI=$O(@ZARY@(ZI)) Q:ZI=""  D  ; FOR EACH SECTION
 . N ZELEADD S ZELEADD=0
 . I ZI["@" D  ; END NODE HAS NO VALUE, ONLY ATTRIBUTES
 . . S ZTAG=$P(ZI,"@",1) ; PULL OUT THE TAG
 . . K ZATT ; CLEAR OUT LAST ONE
 . . M ZATT=@ZARY@(ZI,1) ; GET ATTRIBUTE ARRAY
 . . D STARTELE^MXMLDOM(ZTAG,.ZATT) ; ADD THE NODE
 . . S ZELEADD=1 ; FLAG TO NOT ADD THE ELEMENT TWICE
 . I $O(@ZARY@(ZI,""))="" D  ;END NODE
 . . S ZTAG=ZI ; USE ZI FOR THE TAG
 . . I 'ZELEADD D STARTELE^MXMLDOM(ZTAG) ; ADD ELEMENT IF NOT THERE
 . . S ZELEADD=1 ; ADDED AN ELEMENT
 . . D CHAR^MXMLDOM($G(@ZARY@(ZI))) ; INSERT THE VALUE
 . I ZELEADD D  Q  ; NO MORE TO DO ON THIS LEVEL
 . . D ENDELE^MXMLDOM(ZTAG) ; CLOSE THE ELEMENT BEFORE LEAVING
 . N NEWARY ; INDENTED ARRAY
 . N ZN S ZN=0
 . F  S ZN=$O(@ZARY@(ZI,ZN)) Q:ZN=""  D  ; FOR EACH MULTIPLE
 . . D STARTELE^MXMLDOM(ZI) ; ADD THE INTERMEDIATE TAG
 . . S NEWARY=$NA(@ZARY@(ZI,ZN)) ; INDENT THE ARRAY
 . . D MAJOR(NEWARY) ; RECURSE FOR INDENTED ARRAY
 . . D ENDELE^MXMLDOM(ZI) ; END THE INTERMEDIATE TAG
 Q
 ;
EXPAND(ZZOUT,ZZIN) ; EXPANDS NHIN ARRAY FORMAT TO AN EXPANDED
 ; CONSISTENT FORMAT
 ; GNARY("patient",1,"facilities[2].facility@code")="050"
 ; becomes G2ARY("patient",1,"facilities",2,"facility@",1,"code")="050"
 ; for easier processing (this is fileman format genius)
 ; basically removes the dot notation from the strings
 ;
 N ZZI
 S ZZI=""
 F  S ZZI=$O(@ZZIN@(ZZI)) Q:ZZI=""  D  ;
 . N ZZN S ZZN=0
 . F  S ZZN=$O(@ZZIN@(ZZI,ZZN)) Q:ZZN=""  D  ;
 . . N ZZS S ZZS=""
 . . N GA ;PUSH STACK
 . . F  S ZZS=$O(@ZZIN@(ZZI,ZZN,ZZS)) Q:ZZS=""  D  ;
 . . . K GA ; NEW STACK
 . . . D PUSH^C0CXPATH("GA",ZZI_"^"_ZZN) ; PUSH PARENT
 . . . N ZZV ; PLACE TO STASH THE VALUE
 . . . S ZZV=@ZZIN@(ZZI,ZZN,ZZS) ; VALUE
 . . . W !,"VALUE:",ZZV
 . . . N GK ; COUNTER
 . . . F GK=1:1:$L(ZZS,".") D  ; FOR EACH INTERMEDIATE NODE
 . . . . N ZZN2 S ZZN2=1 ; DEFAULT IF NO [X]
 . . . . N GM S GM=$P(ZZS,".",GK) ; TAG
 . . . . I GM["[" D  ; IT'S A MULTIPLE
 . . . . . S ZZN2=$P($P(GM,"[",2),"]",1) ; PULL OUT THE NUMBER
 . . . . . S GM=$P(GM,"[",1) ; PULL OUT THE TAG
 . . . . I GM["@" D  ; IT'S GOT ATTRIBUTES
 . . . . . N GM2 S GM2=$P(GM,"@",2) ; PULLOUT THE ATTRIBUTE NAME
 . . . . . D PUSH^C0CXPATH("GA",$P(GM,"@",1)_"@"_"^"_ZZN2) ; PUSH THE TAG
 . . . . . D PUSH^C0CXPATH("GA",GM2_"^"_ZZN2)
 . . . . E  D PUSH^C0CXPATH("GA",GM_"^"_ZZN2) ;
 . . . S GA(GA(0))=$P(GA(GA(0)),"^",1)_"^" ; GET RID OF THE LAST "1"
 . . . N GZI S GZI="" ; STRING FOR THE INDEX
 . . . F GK=1:1:GA(0) D  ; TIME TO REVERSE POP THE TAGS
 . . . . S GM=$P(GA(GK),"^",1) ; THE TAG
 . . . . S ZZN2=$P(GA(GK),"^",2) ; THE NUMBER IF ANY
 . . . . I ZZN2="" S GZI=GZI_""""_GM_"""" ; FOR THE LAST ONE
 . . . . E  S GZI=GZI_""""_GM_""""_","_ZZN2_"," ; FOR THE REST
 . . . S GZI2=ZZOUT_"("_GZI_")" ; INCLUDE THE ARRAY NAME
 . . . W !,GZI
 . . . S @GZI2=ZZV ; REMEMBER THE VALUE?
 Q
 ;
NEWDOM() ; extrinsic which creates a new DOM and returns the HANDLE
 N CBK,SUCCESS,LEVEL,NODE,HANDLE
 K ^TMP("MXMLERR",$J)
 L +^TMP("MXMLDOM",$J):5
 E  Q 0
 S HANDLE=$O(^TMP("MXMLDOM",$J,""),-1)+1,^(HANDLE)=""
 L -^TMP("MXMLDOM",$J)
 Q HANDLE
 ;
