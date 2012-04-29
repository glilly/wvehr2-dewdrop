C0EPTFL ;KBAZ/ZAG,FWSLC/DLW - CCR/CCD files for a patient ; 10/28/11 6:21pm
 ;
 ; Zach Gonzales <zach@linux.com>
 ;
 ; David Wicksell <dlw@linux.com>
 ; Copyright © 2011 Fourth Watch Software, LC
 ;
 ; This program is free software: you can redistribute it and/or modify
 ; it under the terms of the GNU Affero General Public License (AGPL)
 ; as published by the Free Software Foundation, either version 3 of
 ; the License, or (at your option) any later version.
 ;
 ; This program is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 ; GNU Affero General Public License for more details.
 ;
 ; You should have received a copy of the GNU Affero General Public License
 ; along with this program. If not, see http://www.gnu.org/licenses/.
 ;
 ; display all the patient files a.k.a CCR or CCD documents.
 ;
FILELIST(sessid) ;build a list of available CCRs for a patient
 N U S U="^"
 N C0EDFN S C0EDFN=$$getSessionValue^%zewdAPI("DFN",sessid) ;PT DFN
 N C0ELIST
 N C0EIEN,I S C0EIEN=0 ;CCR ien
 F I=1:1 D  Q:C0EIEN=""
 . S C0EIEN=$O(^C0CIN("B",C0EDFN,C0EIEN)) ;CCR IEN
 . Q:C0EIEN=""  ;exit if no more CCRs
 . N C0EDTE S C0EDTE=$P(^C0CIN(C0EIEN,0),U,2) ;date CCR imported(FM)
 . N C0EFMDTE S C0EFMDTE=$$FMTE^XLFDT(C0EDTE) ;date CCR imported(ext)
 . N C0EDUZ S C0EDUZ=$P(^C0CIN(C0EIEN,0),U,5) ;DUZ of importing user
 . N C0ENAM S C0ENAM=$P(^VA(200,+C0EDUZ,0),U) ;fullname/importing user
 . N C0ETYPE S C0ETYPE=$P(^C0CIN(C0EIEN,0),U,3) ;document type
 . N C0ESMAIL S C0ESMAIL=$P($G(^C0CIN(C0EIEN,5)),U) ;sending email address
 . S C0ESMAIL=$$replaceAll^%zewdAPI(C0ESMAIL,"""","") ;Get rid of quotes
 . N C0ESINST S C0ESINST=$P($G(^C0CIN(C0EIEN,5)),U,2) ;sendinf institution
 . ;112, dr.jones@hospital1.org, Organization, 4/20,2011, GONZALES,ZACH, CCR
 . N C0EDOC S C0EDOC=C0EIEN_": "_C0ESMAIL_", "_C0ESINST_", "_C0EFMDTE_", "_C0ENAM_", "_C0ETYPE ;file list
 . S C0ELIST(I,"text")=C0EDOC ;PT files list formatted for EWD
 ;
 ;reverse the order of patient files, newest to oldest
 N C0ELST,I S SUB=""
 F I=1:1 S SUB=$O(C0ELIST(SUB),-1) Q:SUB=""  D
 . S C0ELST(I,"text")=C0ELIST(SUB,"text")
 ;
 N CNT S CNT=I-1
 N PTFLCNT S PTFLCNT=$S(CNT=1:CNT_" File",1:CNT_" Files")
 D setSessionValue^%zewdAPI("ptflCnt",PTFLCNT,sessid)
 ;
 D saveListToSession^%zewdSTAPI(.C0ELST,"ptFileList",sessid)
 ;
 QUIT ""
 ;
GETXML(sessid) ;CCR from FILELIST selection
 N U S U="^"
 N C0ELST S C0ELST=$$getRequestValue^%zewdAPI("listItemNo",sessid)
 N LIST D mergeArrayFromSession^%zewdAPI(.LIST,"ptFileList",sessid)
 ;
 N C0EXML
 N C0ESEL S C0ESEL=$G(LIST(C0ELST,"text")) ;PT file selected
 N C0EIEN S C0EIEN=$P(C0ESEL,":") ;convert slection to file IEN
 N GBL S GBL=$NA(^C0CIN(C0EIEN,1)) ;set global node
 N XML S XML=""
 N WPSUB S WPSUB=0
 F  D  Q:'WPSUB
 . S WPSUB=$O(@GBL@(WPSUB)) ;WP multiples
 . Q:'WPSUB  ;exit if no WP fields
 . S XML=@GBL@(WPSUB,0) ;build array of WP fields
 . S XML=$$TRIM^XLFSTR(XML) ;remove leading spaces
 . S C0EXML(WPSUB)=XML ;build list of WP fields for EWD
 ;
 M NXML=C0EXML
 K C0EXML
 ;
 ;Set the array up to add important tags that are missing and figure out type
 N I,N,TYPE S N="",TYPE="CCR"
 F I=1:1 S N=$O(NXML(N)) Q:N=""  D
 . ;Figure out a better way to find the type, look at C0CMAIL2
 . I NXML(N)["<ClinicalDocument" S TYPE="CCD"
 . S C0EXML(I)=NXML(N)
 ;
 ;Temporary fix to pass testing
 ;N N S N="" F  S N=$O(C0EXML(N)) Q:N=""  D
 ;. I C0EXML(N)="<" S C0EXML(N)="<"_C0EXML(N+1),C0EXML(N+1)=""
 ;
 D setSessionValue^%zewdAPI("file",TYPE,sessid)
 ;
 K ^CacheTempEWD($J)
 M ^CacheTempEWD($J)=C0EXML
 ;
 N OK
 S OK=$$parseDocument^%zewdHTMLParser("xmlDocument",0)
 I $G(OK)]"" Q OK
 ;
 K ^CacheTempEWD($J)
 ;
 N XSLT,FILE I TYPE="CCR" S XSLT="ccrxsl",FILE="www/css/ccr.xsl"
 E  S XSLT="cdaxsl",FILE="www/css/cda.xsl"
 ;
 D listDOMs^%zewdDOM(.LIST)
 S OK=""
 I '$D(LIST(XSLT)) D
 .; S OK=$$parseXMLFile^%zewdAPI(FILE,XSLT)
 . S OK=$$parseFile^%zewdHTMLParser(FILE,XSLT,,,0) ;Use this one!
 I OK]"" Q OK
 ;
 D setSessionValue^%zewdAPI("xmlDocumentType",TYPE,sessid)
 ;
 QUIT "" ;end of GETXML
 ;
 ;
END ;end of C0EPTFL
