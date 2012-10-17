C0CSOAP  ; CCDCCR/GPL - SOAP WEB SERVICE utilities; 8/25/09
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;Copyright 2008 George Lilly.  Licensed under the terms of the GNU
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
        W "This is an SOAP utility library",!
        W !
        Q
        ;
TEST1   
        S url="https://ec2-75-101-247-83.compute-1.amazonaws.com:8181/ccr/CCRService?wsdl"
        D GET1URL^C0CEWD2(url)
        Q
        ;
INITFARY(ARY)   ;initialize the Fileman Field array for SOAP processing
        ; ARY is passed by name
        S @ARY@("XML FILE NUMBER")="178.301"
        S @ARY@("BINDING SUBFILE NUMBER")="178.3014"
        S @ARY@("MIME TYPE")="2.3"
        S @ARY@("PROXY SERVER")="2.4"
        S @ARY@("REPLY TEMPLATE")=".03"
        S @ARY@("TEMPLATE NAME")=".01"
        S @ARY@("TEMPLATE XML")="3"
        S @ARY@("URL")="1"
        S @ARY@("WSDL URL")="2"
        S @ARY@("XML")="2.1"
        S @ARY@("XML HEADER")="2.2"
        S @ARY@("XPATH REDUCTION STRING")="2.5"
        S @ARY@("CCR VARIABLE")="4"
        S @ARY@("FILEMAN FIELD NAME")="1"
        S @ARY@("FILEMAN FIELD NUMBER")="1.2"
        S @ARY@("FILEMAN FILE POINTER")="1.1"
        S @ARY@("INDEXED BY")=".05"
        S @ARY@("SQLI FIELD NAME")="3"
        S @ARY@("VARIABLE NAME")="2"
        Q
        ;
RESTID(INNAM,INFARY)    ;EXTRINSIC TO RESOLVE TEMPLATE PASSED BY NAME
        ; FILE IS IDENTIFIED IN FARY, PASSED BY NAME
        I '$D(INFARY) D  ; NO FILE ARRAY PASSED
        . S INFARY="FARY"
        . D INITFARY(INFARY)
        N ZN,ZREF,ZR
        S ZN=@INFARY@("XML FILE NUMBER")
        S ZREF=$$FILEREF^C0CRNF(ZN)
        S ZR=$O(@ZREF@("B",INNAM,""))
        Q ZR
        ;
TESTSOAP        ;
        ; USING ICD9 WEB SERVICE TO TEST SOAP
        S G("CODE")="E*"
        S G("CODELN")=3
        D SOAP("GPL","ICD9","G")
        Q
        ;
SOAP(C0CRTN,C0CTID,C0CVA,C0CVOR,ALTXML,IFARY)   ; MAKES A SOAP CALL FOR 
        ; TEMPLATE ID C0CTID
        ; RETURNS THE XML RESULT IN C0CRTN, PASSED BY NAME
        ; C0CVA IS PASSED BY NAME AND IS THE VARIABLE ARRAY TO PASS TO BIND
        ; C0CVOR IS THE NAME OF A VARIABLE OVERRIDE ARRAY, WHICH IS APPLIED 
        ; BEFORE MAPPING
        ; IF ALTXML IS PASSED, BIND AND MAP WILL BE SKIPPED AND 
        ; ALTXML WILL BE USED INSTEAD
        ;
        ; ARTIFACTS SECTION
        ; THE FOLLOWING WILL SET UP DEBUGGING ARTIFACTS FOR A POSSIBLE FUTURE
        ; ONLINE DEBUGGER. IF DEBUG=1, VARIABLES CONTAINING INTERMEDIATE RESULTS
        ; WILL NOT BE NEWED.
        I $G(WSDEBUG)="" N C0CV ; CATALOG OF ARTIFACT VARIABLES AND ARRAYS
        S C0CV(100,"C0CXF","XML TEMPLATE FILE NUMBER")=""
        S C0CV(200,"C0CHEAD","SOAP HEADER VARIABLE NAME")=""
        S C0CV(300,"HEADER","SOAP HEADER")=""
        S C0CV(400,"C0CMIME","MIME TYPE")=""
        S C0CV(500,"C0CURL","WS URL")=""
        S C0CV(550,"C0CPURL","PROXY URL")=""
        S C0CV(600,"C0CXML","XML VARIABLE NAME")=""
        S C0CV(700,"XML","OUTBOUND XML")=""
        S C0CV(800,"C0CRSLT","RAW XML RESULT RETURNED FROM WEB SERVICE")=""
        S C0CV(900,"C0CRHDR","RETURNED HEADER")=""
        S C0CV(1000,"C0CRXML","XML RESULT NORMALIZED")=""
        S C0CV(1100,"C0CR","REPLY TEMPLATE")=""
        S C0CV(1200,"C0CREDUX","REDUX STRING")=""
        S C0CV(1300,"C0CIDX","RESULT XPATH INDEX")=""
        S C0CV(1400,"C0CARY","RESULT XPATH ARRAY")=""
        S C0CV(1500,"C0CNOM","RESULT DOM DOCUMENT NAME")=""
        S C0CV(1600,"C0CID","RESULT DOM ID")=""
        I $G(DEBUG)'="" G NOTNEW ; SKIP NEWING THE VARIABLES IF IN DEBUG
        N ZI,ZJ S ZI=""
NEW     
        S ZI=$O(C0CV(ZI))
        S ZJ=$O(C0CV(ZI,"")) ; SET UP NEW COMMAND
        ;W ZJ,!
        N @ZJ ; NEW THE VARIABLE
        I $O(C0CV(ZI))'="" G NEW ;LOOP TO GET NEW IN CONTEXT
NOTNEW  
        ; END ARTIFACTS
        ;
        I '$D(IFARY) D INITFARY("C0CF") ; SET FILE NUMBER AND PARAMATERS 
        E  D  ; 
        . K C0CF
        . M C0CF=@IFARY
        S C0CXF=C0CF("XML FILE NUMBER") ; FILE NUMBER FOR THE XML TEMPLATE FILE
        I +C0CTID=0 D  ; A STRING WAS PASSED FOR THE TEMPLATE NAME
        . S C0CUTID=$$RESTID(C0CTID,"C0CF") ;RESOLVE TEMPLATE IEN FROM NAME
        E  S C0CUTID=C0CTID ; AN IEN WAS PASSED
        N XML,TEMPLATE,HEADER
        N C0CFH S C0CFH=C0CF("XML HEADER")
        S C0CHEAD=$$GET1^DIQ(C0CXF,C0CUTID_",",C0CFH,,"HEADER")
        N C0CFM S C0CFM=C0CF("MIME TYPE")
        S C0CMIME=$$GET1^DIQ(C0CXF,C0CUTID_",",C0CFM)
        N C0CFP S C0CFP=C0CF("PROXY SERVER")
        S C0CPURL=$$GET1^DIQ(C0CXF,C0CUTID_",",C0CFP)
        N C0CFU S C0CFU=C0CF("URL")
        S C0CURL=$$GET1^DIQ(C0CXF,C0CUTID_",",C0CFU)
        N C0CFX S C0CFX=C0CF("XML")
        S C0CXML=$$GET1^DIQ(C0CXF,C0CUTID_",",C0CFX,,"XML")
        N C0CFT S C0CFT=C0CF("TEMPLATE XML")
        S C0CTMPL=$$GET1^DIQ(C0CXF,C0CUTID_",",C0CFT,,"TEMPLATE")
        I C0CTMPL="TEMPLATE" D  ; there is a template to process
        . K XML ; going to replace the xml array
        . N VARS
        . I $D(C0CVOR) M @C0CVA=@C0CVOR ; merge in varible overrides
        . I '$D(ALTXML) D  ; if ALTXML is passed in, don't bind
        . . D BIND("VARS",C0CVA,C0CUTID,"C0CF")
        . . D MAP("XML","VARS",TPTR,"C0CF")
        . . K XML(0)
        . E  M XML=@ALTXML ; use ALTXML instead
        I $G(C0CPROXY) S C0CURL=C0CPURL
        K C0CRSLT,C0CRHDR
        B
        S ok=$$httpPOST^%zewdGTM(C0CURL,.XML,C0CMIME,.C0CRSLT,.HEADER,"",.gpl5,.C0CRHDR)
        K C0CRXML
        D NORMAL("C0CRXML","C0CRSLT(1)") ;RETURN XML IN AN ARRAY
        N C0CFR S C0CFR=$G(C0CF("REPLY TEMPLATE"))
        S C0CR=$$GET1^DIQ(C0CXF,C0CUTID_",",C0CFR,"I") ; REPLY TEMPLATE
        ; reply templates are optional and are specified by populating a
        ; template pointer in field 2.5 of the request template
        ; if specified, the reply template is the source of the REDUX string
        ; used for XPath on the reply, and for UNBIND processing
        ; if no reply template is specified, REDUX is obtained from the request
        ; template and no UNBIND processing is performed. The XPath array is
        ; returned without variable bindings
        I C0CR'="" D  ; REPLY TEMPLATE EXISTS
        . I +$G(DEBUG)'=0 W "REPLY TEMPLATE:",C0CR,!
        . S C0CTID=C0CR ;
        N C0CFRDX S C0CFRDX=C0CF("XPATH REDUCTION STRING")
        S C0CREDUX=$$GET1^DIQ(C0CXF,C0CUTID_",",C0CFRDX) ;XPATH REDUCTION STRING
        K C0CIDX,C0CARY ; XPATH INDEX AND ARRAY VARS
        S C0CNOM="C0CWS"_$J ; DOCUMENT NAME FOR THE DOM
        S C0CID=$$PARSE^C0CXEWD("C0CRXML",C0CNOM) ;CALL THE PARSER
        S C0CID=$$FIRST^C0CXEWD($$ID^C0CXEWD(C0CNOM)) ;ID OF FIRST NODE
        D XPATH^C0CXEWD(C0CID,"/","C0CIDX","C0CARY","",C0CREDUX) ;XPATH GENERATOR
        ; Next, call UNBIND to map the reply XPath array to variables
        ; This is only done if a Reply Template is provided
        D DEMUXARY(C0CRTN,"C0CARY")
        ; M @C0CRTN=C0CARY
        Q
        ;
DEMUXARY(OARY,IARY)     ;CONVERT AN XPATH ARRAY PASSED AS IARY TO
        ; FORMAT @OARY@(x,xpath) where x is the first multiple
        N ZI,ZJ,ZK,ZL S ZI=""
        F  S ZI=$O(@IARY@(ZI)) Q:ZI=""  D  ;
        . D DEMUX^C0CMXP("ZJ",ZI)
        . S ZK=$P(ZJ,"^",3)
        . S ZK=$RE($P($RE(ZK),"/",1))
        . S ZL=$P(ZJ,"^",1)
        . I ZL="" S ZL=1
        . S @OARY@(ZL,ZK)=@IARY@(ZI)
        Q
        ;
NORMAL(OUTXML,INXML)    ;NORMALIZES AN XML STRING PASSED BY NAME IN INXML
        ; INTO AN XML ARRAY RETURNED IN OUTXML, ALSO PASSED BY NAME
        ;
        N ZI,ZN,ZTMP
        S ZN=1
        S @OUTXML@(ZN)=$P(@INXML,"><",ZN)_">"
        S ZN=ZN+1
        F  S @OUTXML@(ZN)="<"_$P(@INXML,"><",ZN) Q:$P(@INXML,"><",ZN+1)=""  D  ;
        . S @OUTXML@(ZN)=@OUTXML@(ZN)_">"
        . S ZN=ZN+1
        Q
        ;
MAP(RARY,IVARS,TPTR,INFARY)     ;RETURNS MAPPED XML IN RARY PASSED BY NAME
        ; IVARS IS AN XPATH ARRAY PASSED BY NAME
        ; TPTR IS A POINT TO THE C0C XML TEMPLATE FILE USED TO RETRIEVE THE TEMPLATE
        ;
        N ZT ;THE TEMPLATE
        K ZT,@RARY
        I '$D(INFARY) D  ;
        . S INFARY="FARY"
        . D INITFARY(INFARY)
        N ZF,ZFT
        S ZF=@INFARY@("XML FILE NUMBER")
        S ZFT=@INFARY@("TEMPLATE XML")
        I $$GET1^DIQ(ZF,TPTR_",",ZFT,,"ZT")'="ZT" D  Q  ; ERROR GETTING TEMPLATE
        . W "ERROR RETRIEVING TEMPLATE",!
        D MAP^C0CXPATH("ZT",IVARS,RARY) ;DO THE MAPPING
        Q
        ;
TESTBIND        ;
        S G1("TESTONE")=1
        S G1("TESTTWO")=2
        D BIND("G","G1","TEST")
        W !
        ZWR G
        Q
        ;
BIND(RARY,IVARS,INTPTR,INFARY)  ;RETURNS AN XPATH ARRAY IN RARY FOR USE WITH MAP
        ; TO BUILD AN INSTANTIATED TEMPLATE
        ; TPTR IS THE IEN OF THE XML TEMPATE IN THE C0C XML TEMPLATE FILE
        ; LOOPS THROUGHT THE BINDING SUBFILE TO PULL OUT XPATHS AND 
        ; EITHER ASSIGNS VARIABLES OR DOES A FILEMAN CALL TO GET VALUES
        ; VARIABLES ARE IN IVARS WHICH IS PASSED BY NAME
        I '$D(INFARY) D  ;
        . S INFARY="FARY"
        . D INITFARY(INFARY) ;INITIALIZE FILE ARRAY IF NOT PASSED
        I +INTPTR>0 S TPTR=INTPTR
        E  S TPTR=$$RESTID(INTPTR,INFARY)
        N C0CFF,C0CBF,C0CXI,C0CFREF,C0CXREF
        S C0CFF=@INFARY@("XML FILE NUMBER") ;fileman file number of XML file
        S C0CFREF=$$FILEREF^C0CRNF(C0CFF) ; closed file reference to the file
        S C0CBF=@INFARY@("BINDING SUBFILE NUMBER") ; BINDING SUBFILE NUMBER
        S C0CXI=$G(@INFARY@("XPATH INDEX")) ; index to the XPath bindings
        I C0CXI="" S C0CXI="XPATH" ; default is the XPATH index
        ; this needs to be a whole file index on the XPath subfile with
        ; the Template IEN perceding the XPath in the index
        N ZI
        S ZI=""
        S C0CXREF=$NA(@C0CFREF@(C0CXI,TPTR)) ; where the xref is
        ;F  S ZI=$O(^C0CX(TPTR,5,"B",ZI)) Q:ZI=""  D  ; FOR EACH XPATH
        F  S ZI=$O(@C0CXREF@(ZI)) Q:ZI=""  D  ; for each XPath in this template
        . ;W !,ZI," ",$O(@C0CXREF@(ZI,TPTR,""))
        . N ZIEN,ZFILE,ZFIELD,ZVAR,ZIDX,ZINDEX ;
        . S ZIEN=$O(@C0CXREF@(ZI,TPTR,"")) ; IEN OF THE BINDING RECORD
        . N ZFF S ZFF=@INFARY@("FILEMAN FILE POINTER")
        . S ZFILE=$$GET1^DIQ(C0CBF,ZIEN_","_TPTR_",",ZFF,"I")
        . N ZFFLD S ZFFLD=@INFARY@("FILEMAN FIELD NUMBER")
        . S ZFIELD=$$GET1^DIQ(C0CBF,ZIEN_","_TPTR_",",ZFFLD,"I")
        . N ZFV S ZFV=@INFARY@("VARIABLE NAME")
        . S ZVAR=$$GET1^DIQ(C0CBF,ZIEN_","_TPTR_",",ZFV,"E")
        . N ZFX S ZFX=("INDEXED BY")
        . S ZIDX=$$GET1^DIQ(C0CBF,ZIEN_","_TPTR_",",ZFX,"I")
        . S ZINDEX=""
        . I ZIDX="DUZ" S ZINDEX=$G(DUZ) ; FILE IS INDEXED BY DUZ
        . I ZIDX="DFN" S ZINDEX=$G(DFN) ; BY DFN
        . E  I ZIDX'="" S ZINDEX=$G(@ZIDX) ; index variable
        . ;I ZIDX="ACCT" S ZINDEX=C0CACCT ; BY ACCOUNT RECORD POINT TO C0C WS ACCT
        . ;I ZIDX="LOC" S ZINDEX=C0CLOC ; BY LOCATION
        . I ZVAR'="" D  ; VARIABLES TAKE PRESCIDENCE OVER FILEMAN FIELDS
        . . S @RARY@(ZI)=@IVARS@(ZVAR) ; 
        . E  D  ; IF NO VARIABLE, TRY ACCESSING FROM FILEMAN
        . . I (ZFILE="")!(ZFIELD="") Q  ;QUIT IF FILE OR FIELD NOT THERE
        . . D CLEAN^DILF
        . . S @RARY@(ZI)=$$GET1^DIQ(ZFILE,ZINDEX_",",ZFIELD) ;GET THE VALUE
        . . I $D(^TMP("DIERR",$J,1)) D  B ;
        . . . W "ERROR!",!
        . . . ZWR ^TMP("DIERR",$J,*)
        Q
        ;
