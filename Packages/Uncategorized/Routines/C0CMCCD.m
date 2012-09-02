C0CMCCD   ; GPL - MXML based CCD utilities;12/04/09  17:05
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
        ;
PARSCCD(DOC,OPTION)     ; THIS WAS COPIED FROM EN^MXMLDOM TO CUSTIMIZE FOR 
        ; PROCESSING CCDS 
        N CBK,SUCCESS,LEVEL,NODE,HANDLE
        K ^TMP("MXMLERR",$J)
        L +^TMP("MXMLDOM",$J):5
        E  Q 0
        S HANDLE=$O(^TMP("MXMLDOM",$J,""),-1)+1,^(HANDLE)=""
        L -^TMP("MXMLDOM",$J)
        S CBK("STARTELEMENT")="STARTELE^C0CMCCD" ; ONLY THIS ONE IS CHANGED ;GPL
        S CBK("ENDELEMENT")="ENDELE^MXMLDOM"
        S CBK("COMMENT")="COMMENT^MXMLDOM"
        S CBK("CHARACTERS")="CHAR^MXMLDOM"
        S CBK("ENDDOCUMENT")="ENDDOC^MXMLDOM"
        S CBK("ERROR")="ERROR^MXMLDOM"
        S (SUCCESS,LEVEL,LEVEL(0),NODE)=0,OPTION=$G(OPTION,"V1")
        D EN^MXMLPRSE(DOC,.CBK,OPTION)
        D:'SUCCESS DELETE^MXMLDOM(HANDLE)
        Q $S(SUCCESS:HANDLE,1:0)
        ; Start element
        ; Create new child node and push info on stack
STARTELE(ELE,ATTR)      ; COPIED FROM STARTELE^MXMLDOM AND MODIFIED TO TREAT
        ; ATTRIBUTES AS SUBELEMENTS TO MAKE CCD XPATH PROCESSING EASIER
        N PARENT
        S PARENT=LEVEL(LEVEL),NODE=NODE+1
        S:PARENT ^TMP("MXMLDOM",$J,HANDLE,PARENT,"C",NODE)=ELE
        S LEVEL=LEVEL+1,LEVEL(LEVEL)=NODE,LEVEL(LEVEL,0)=ELE
        S ^TMP("MXMLDOM",$J,HANDLE,NODE)=ELE,^(NODE,"P")=PARENT
        ;M ^("A")=ATTR
        N ZI S ZI="" ; INDEX FOR ATTR
        F  S ZI=$O(ATTR(ZI)) Q:ZI=""  D  ; FOR EACH ATTRIBUTE
        . N ELE,TXT ; ABOUT TO RECURSE
        . S ELE=ZI ; TAG
        . S TXT=ATTR(ZI) ; DATA
        . D STARTELE(ELE,"") ; CREATE A NEW SUBNODE
        . D TXT^MXMLDOM("T") ; INSERT DATA TO TAG
        . D ENDELE^MXMLDOM(ELE) ; POP BACK UP A LEVEL
        Q
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
CLEANARY(OUTARY,INARY)  ; GOES THROUGH AN ARRAY AND CALLS CLEAN ON EACH NODE
        ; INARY AND OUTARY PASSED BY NAME
        N ZI S ZI=""
        F  S ZI=$O(@INARY@(ZI)) Q:ZI=""  D  ; FOR EACH NODE
        . S @OUTARY@(ZI)=$$CLEAN(@INARY@(ZI)) ; CLEAN THE NODE
        Q
        ;
CLEAN(STR)      ; extrinsic function; returns string
        ;; Removes all non printable characters from a string.
        ;; STR by Value
        N TR,I
        F I=0:1:31 S TR=$G(TR)_$C(I)
        S TR=TR_$C(127)
        QUIT $TR(STR,TR)
        ;
STRIPTXT(OUTARY,ZARY)   ; STRIPS THE "TEXT" PORTION OUT OF AN XML FILE
        ; THIS IS USED TO DELETE THE NARATIVE HTML OUT OF THE CCD XML FILES BECAUSE
        ; THEY DO NOT WORK RIGHT WITH THE PARSER
        ;N ZWRK,ZBLD,ZI ; WORK ARRAY,BUILD ARRAY, AND COUNTER
        S ZI=$O(@ZARY@("")) ; GET FIRST LINE NUMBER
        D C0CBEGIN("ZWRK",ZI) ; INSERT FIRST LINE IN WORK ARRAY
        F  S ZI=$O(@ZARY@(ZI)) Q:ZI=""  D  ; FOR EACH LINE OF THE ARRAY
        . I $O(@ZARY@(ZI))="" D  Q  ; AT THE END 
        . . D C0CEND("ZWRK",ZI) ; INCLUDE LAST LINE IN WORK ARRAY
        . I ZI=1 D C0CBEGIN("ZWRK",ZI) ; START WITH FIRST LINE
        . I @ZARY@(ZI)["<text" D C0CEND("ZWRK",ZI-1) ;PREV LINE IS AN END
        . I @ZARY@(ZI)["</text>" D C0CBEGIN("ZWRK",ZI+1) ;NEXT LINE IS A BEGIN
        S ZI=""
        F  S ZI=$O(ZWRK(ZI)) Q:ZI=""  D  ; MAKE A BUILD LIST FROM THE WORK ARRAY
        . D QUEUE^C0CXPATH("ZBLD",ZARY,$P(ZWRK(ZI),"^",1),$P(ZWRK(ZI),"^",2))
        D BUILD^C0CXPATH("ZBLD",OUTARY) ; BUILD NEW ARRAY WITHOUT TEXT SECTIONS
        K @OUTARY@(0) ; GET RID OF THE LINE COUNT
        Q
        ;
C0CBEGIN(ZA,LN) ; INSERTS A BEGIN LINE LN INTO ARRAY ZWRK, PASSED BY NAME
        N ZI
        S ZI=$O(@ZA@(""),-1)
        I ZI="" S ZI=1
        E  S ZI=ZI+1 ; INCREMENT COUNT IN WORK ARRAY
        S $P(@ZA@(ZI),"^",1)=LN
        Q
        ;
C0CEND(ZB,LN)   ; INSERTS AN END LINE LN INTO ARRAY ZWRK, PASSED BY NAME
        N ZI
        S ZI=$O(@ZB@(""),-1)
        I ZI="" S ZI=1
        S $P(@ZB@(ZI),"^",2)=LN
        Q
        ;
SEPARATE(OUTARY,INARY)  ; SEPARATES XPATH VARIABLES ACCORDING TO THEIR
        ; ROOT ; /Problems/etc/etc goes to @OUTARY@("Problems","/Problems/etc/etc")
        S ZI=""
        F  S ZI=$O(@INARY@(ZI)) Q:ZI=""  D  ; FOR EACH ELEMENT OF THE ARRAY
        . I $P(ZI,"//",2)'="" D  ; FOR NON-BODY ENTRIES
        . . S ZJ=$P(ZI,"/",4) ; things like From Patient Actor
        . E  D  ; FOR BODY PARTS
        . . S ZJ=$P(ZI,"/",2) ;
        . . I ZJ="" S ZJ=$P(ZI,"/",3) ;
        . S @OUTARY@(ZJ,ZI)=$G(@INARY@(ZI)) ;FIX THIS FOR MULTILINE COMMENTS
        Q
        ;
FINDTID ; FIND TEMPLATE IDS IN DOM 1
        S C0CDOCID=1
        S ZD=$NA(^TMP("MXMLDOM",$J,C0CDOCID))
        S ZN=""
        S CURSEC=""
        S TID=""
        F  S ZN=$O(@ZD@(ZN)) Q:ZN=""  D  ;
        . I $$TAG(ZN)="root" D  ;
        . . I $$TAG($$PARENT(ZN))="templateId" D  ; ONLY LOOKING FOR TEMPLATES
        . . . S ZG=$$PARENT($$PARENT(ZN))
        . . . S ZG2=$$PARENT(ZG) ;COMPONENT THAT HOLDS THIS SECTION
        . . . S CMT=$G(@ZD@(ZG,"X",1))
        . . . I CMT="" S CMT="?"
        . . . I $$TAG(ZG)="section" D  ;START OF A SECTION
        . . . . S CURSEC=$$PARENT(ZG)
        . . . . S SECCMT=$G(@ZD@(CURSEC,"X",1))
        . . . . I SECCMT="" S SECCMT="?"
        . . . . S SECTID=$G(@ZD@(ZN,"T",1)) ;SECTION TEMPLATE ID
        . . . S TID=$G(@ZD@(ZN,"T",1)) ;TEMPLATE ID
        . . . I CURSEC'="" D  ; IF WE ARE IN A SECTION
        . . . . S CCDDIR(ZG2,CURSEC,$$TAG(ZG2),CMT,SECCMT)=TID
        . . . . S DOMMAP(ZG2)=CURSEC_U_$$TAG(ZG2)_U_TID_U_SECTID
        . . . W !,$$TAG(ZG2)," ",$G(@ZD@(ZG,"X",1))
        . . . W " root ",ZN," ",@ZD@(ZN,"T",1)
        Q
        ;
FINDALT ; PROCESS THE DOMMAP AND FIND THE ALT TAGS FOR COMPONENTS
        ;
        S ZI=""
        F  S ZI=$O(DOMMAP(ZI)) Q:ZI=""  D  ; FOR EACH NODE IN THE MAP
        . S ZJ=DOMMAP(ZI) ;
        . S PARNODE=$P(ZJ,U,1) ;PARENT NODE
        . S TAG=$P(ZJ,U,2) ;THIS TAG
        . S TID=$P(ZJ,U,3) ;THIS TEMPLATE ID
        . S PARTID=$P(ZJ,U,4) ;PARENT TEMPLATE ID
        . S ZIEN=$O(^C0CXDS(178.101,"TID",TID,"")) ;THIS NODE IEN
        . S PARIEN=$O(^C0CXDS(178.101,"TID",PARTID,"")) ;PARENT NODE IEN
        . I ZI=PARNODE D  ; IF THIS IS A SECTION NODE
        . . S ALTTAG=$$GET1^DIQ(178.101,PARIEN_",",.03) ;ALT TAG FIELD FOR PARENT
        . . S NAME=$$GET1^DIQ(178.101,ZIEN_",",.01) ;NAME OF THIS NODE'S TEMPLATE
        . . W ZI," ",TAG," ",ALTTAG," ",NAME,!
        . . S C0CTAGS(ZI)=ALTTAG
        . E  D  ; NOT A SECTION NODE
        . . N ZJ S ZJ=""
        . . S ZJ=$O(^C0CXDS(178.101,"D",PARIEN,ZIEN,"")) ;A WHEREUSED POINTER?
        . . I ZJ'="" D  ; THERE IS A NEW LABEL FOR THIS NODE
        . . . N ZK
        . . . S ZK=$$GET1^DIQ(178.111,ZJ_","_ZIEN_",",2)
        . . . I ZK'="" D  ;
        . . . . W "FOUND ",ZK,!
        . . . . S C0CTAGS(ZI)=ZK ; NEW TAG FOR INTERSECTION
        Q
        ;
ALTTAG(NODE)    ; SET Y EQUAL TO THE ALT TAG FOUND IN C0CTAGS IF NODE IF FOUND
        ;
        S Y=$G(C0CTAGS(NODE))
        Q
        ;
SETCBK  ; SET THE TAG CALLBACK FOR XPATH PROCESSSING OF THE CCD
        S C0CCBK("TAG")="D ALTTAG^C0CMCCD(ZOID)"
        Q
        ;
OUTCCD(GARYIN)  ; OUTPUT THE PARSED CCD TO A TEXT FILE
        ;D TEST3^C0CMXML
        N ZT S ZT=$NA(^TMP("CCDOUT",$J))
        N ZI,ZJ
        S ZI=1 S ZJ=""
        K @ZT
        F  S ZJ=$O(GARYIN(ZJ)) Q:ZJ=""  D  ;
        . S @ZT@(ZI)=ZJ_"^"_GARYIN(ZJ)
        . S ZI=ZI+1
        S ONAME=$NA(@ZT@(1))
        W $$OUTPUT^C0CXPATH(ONAME,"CCDOUT.txt","/home/vademo2/CCR")
        K @ZT
        Q
        ;
GENXDS(ZD)      ; GENERATE THE XDS PROTOTYPE RECORDS FROM A CCDDIR ARRAY
        ; ARRAY ELEMENTS LOOK LIKE:
        ; CCDDIR(1659,1634,"observation"," Result observaion template "," Vital signs section template ")="2.16.840.1.113883.10.20.1.31"
        ;or CCDDIR(cur node,section node,cur tag,cur name,sec name)=templateId
        S ZF=178.101 ; FILE NUMBER FOR THE C0C XDS PROTOTYPE FILE
        S ZI=$Q(@ZD@("")) ;FIRST ARRAY ELEMENT
        S DONE=0
        F  Q:DONE  D  ;
        . W @ZI,!
        . S ZJ=$QS(ZI,5)
        . S ZJ=$E(ZJ,2,$L(ZJ)) ;STRIP THE LEADING SPACE
        . S C0CFDA(ZF,"?+1,",.01)=ZJ
        . S C0CFDA(ZF,"?+1,",.02)=$QS(ZI,4) ; TAG FOR THIS TEMPLATE
        . S C0CFDA(ZF,"?+1,",1)=@ZI
        . D UPDIE
        . S ZI=$Q(@ZI)
        . I ZI="" S DONE=1
        Q
        ;
WHRUSD(ZD)      ; UPDATE THE C0C XDS FILE WITH WHERE USED DATA FROM
        ; CCDDIR PASS BY NAME
        ; ARRAY ELEMENTS LOOK LIKE:
        ; CCDDIR(1634," Vital signs section template ",1659,"observation"," Result observaion template ")="2.16.840.1.113883.10.20.1.31"
        ;or CCDDIR(section node,sec name, cur node,cur tag,cur name)=templateId
        S ZF=178.101 ; FILE NUMBER FOR THE C0C XDS PROTOTYPE FILE
        S ZSF=178.111 ; WHERE USED SUBFILE OF C0C XDS PROTOTYPE FILE
        S ZI=$Q(@ZD@("")) ;FIRST ARRAY ELEMENT
        S DONE=0
        F  Q:DONE  D  ;
        . W @ZI
        . S ZIEN=$O(^C0CXDS(178.101,"TID",@ZI,"")) ; IEN FOR THIS NODE'S TEMPLATE
        . W " IEN:",ZIEN
        . S ZJ=$QS(ZI,2)
        . S ZJ=$E(ZJ,2,$L(ZJ)) ;STRIP THE LEADING SPACE
        . S ZPIEN=$O(^C0CXDS(178.101,"B",ZJ,"")) ; PARENT IEN
        . W " PARENT IEN:",ZPIEN
        . S ZTAG=$QS(ZI,4) ; TAG FOR THIS TEMPLATE
        . W " TAG:",ZTAG,!
        . I ZIEN'=ZPIEN D  ; ONLY FOR CHILD TEMPLATES
        . . S C0CFDA(ZSF,"?+1,"_ZIEN_",",.01)=ZPIEN ; NEW SUBFILE ENTRY WITH PAR PTR
        . . S C0CFDA(ZSF,"?+1,"_ZIEN_",",1)=ZTAG ; TAG FOR NEW ENTRY
        . . D UPDIE
        . ;S C0CFDA(ZF,"?+1,",1)=@ZI
        . ;D UPDIE
        . S ZI=$Q(@ZI)
        . I ZI="" S DONE=1
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
