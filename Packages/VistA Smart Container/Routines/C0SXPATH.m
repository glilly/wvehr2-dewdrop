        C0SXPATH   ; CCDCCR/GPL - XPATH XML manipulation utilities; 6/1/08
        ;;1.0;C0S;;May 19, 2009;Build 1
        ;Copyright 2008-2012 George Lilly.  Licensed under the terms of the GNU
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
        W "This is an XML XPATH utility library",!
        W !
        Q
        ;
OUTPUT(OUTARY,OUTNAME,OUTDIR)     ; WRITE AN ARRAY TO A FILE
        ;
        N Y
        S Y=$$GTF^%ZISH(OUTARY,$QL(OUTARY),OUTDIR,OUTNAME)
        I Y Q 1_U_"WROTE FILE: "_OUTNAME_" TO "_OUTDIR
        I 'Y Q 0_U_"ERROR WRITING FILE"_OUTNAME_" TO "_OUTDIR
        Q
        ;
PUSH(STK,VAL)     ; pushs VAL onto STK and updates STK(0)
        ;  VAL IS A STRING AND STK IS PASSED BY NAME
        ;
        I '$D(@STK@(0)) S @STK@(0)=0 ; IF THE ARRAY IS EMPTY, INITIALIZE
        S @STK@(0)=@STK@(0)+1 ; INCREMENT ARRAY DEPTH
        S @STK@(@STK@(0))=VAL ; PUT VAL A THE END OF THE ARRAY
        Q
        ;
POP(STK,VAL)       ; POPS THE LAST VALUE OFF THE STK AND RETURNS IT IN VAL
        ; VAL AND STK ARE PASSED BY REFERENCE
        ;
        I @STK@(0)<1 D  ; IF ARRAY IS EMPTY
        . S VAL=""
        . S @STK@(0)=0
        I @STK@(0)>0  D  ;
        . S VAL=@STK@(@STK@(0))
        . K @STK@(@STK@(0))
        . S @STK@(0)=@STK@(0)-1 ; NEW DEPTH OF THE ARRAY
        Q
        ;
PUSHA(ADEST,ASRC)       ; PUSH ASRC ONTO ADEST, BOTH PASSED BY NAME
        ;
        N ZGI
        F ZGI=1:1:@ASRC@(0) D  ; FOR ALL OF THE SOURCE ARRAY
        . D PUSH(ADEST,@ASRC@(ZGI)) ; PUSH ONE ELEMENT
        Q
        ;
MKMDX(STK,RTN,INREDUX)   ; MAKES A MUMPS INDEX FROM THE ARRAY STK
        ; RTN IS SET TO //FIRST/SECOND/THIRD FOR THREE ARRAY ELEMENTS
        ; REDUX IS A STRING TO REMOVE FROM THE RESULT
        S RTN=""
        N I
        ; W "STK= ",STK,!
        I @STK@(0)>0  D  ; IF THE ARRAY IS NOT EMPTY
        . S RTN="//"_@STK@(1) ; FIRST ELEMENT NEEDS NO SEMICOLON
        . I @STK@(0)>1  D  ; SUBSEQUENT ELEMENTS NEED A SEMICOLON
        . . F I=2:1:@STK@(0) S RTN=RTN_"/"_@STK@(I)
        I $G(INREDUX)'="" S RTN=$P(RTN,INREDUX,1)_$P(RTN,INREDUX,2)
        Q
        ;
XNAME(ISTR)         ; FUNCTION TO EXTRACT A NAME FROM AN XML FRAG
        ;  </NAME> AND <NAME ID=XNAME> WILL RETURN NAME
        ; ISTR IS PASSED BY VALUE
        N CUR,TMP
        I ISTR?.E1"<".E  D  ; STRIP OFF LEFT BRACKET
        . S TMP=$P(ISTR,"<",2)
        I TMP?1"/".E  D  ; ALSO STRIP OFF SLASH IF PRESENT IE </NAME>
        . S TMP=$P(TMP,"/",2)
        S CUR=$P(TMP,">",1) ; EXTRACT THE NAME
        ; W "CUR= ",CUR,!
        I CUR?.1"_"1.A1" ".E  D  ; CONTAINS A BLANK IE NAME ID=TEST>
        . S CUR=$P(CUR," ",1) ; STRIP OUT BLANK AND AFTER
        ; W "CUR2= ",CUR,!
        Q CUR
        ;
XVAL(ISTR)      ; EXTRACTS THE VALUE FROM A FRAGMENT OF XML
        ; <NAME>VALUE</NAME> WILL RETURN VALUE
        N G
        S G=$P(ISTR,">",2) ;STRIP OFF <NAME>
        Q $P(G,"<",1) ; STRIP OFF </NAME> LEAVING VALUE
        ;
VDX2VDV(OUTVDV,INVDX)   ; CONVERT AN VDX ARRAY TO VDV
        ; VDX: @INVDX@(XPATH)=VALUE
        ; VDV: @OUTVDV@(X1X2X3X4)=VALUE
        ; THE VDV DATANAMES MIGHT BE MORE CONVENIENT FOR USE IN CODE
        ; AN INDEX IS PROVIDED TO GO BACK TO VDX FOR CONVERSIONS
        ; @VDV@("XPATH",X1X2X3X4)="XPATH"
        N ZA,ZI,ZW
        S ZI=""
        F  S ZI=$O(@INVDX@(ZI)) Q:ZI=""  D  ;
        . S ZW=$TR(ZI,"/","") ; ELIMINATE ALL SLASHES - CAMEL CASE VARIABLE NAME
        . W ZW,!
        . S @OUTVDV@(ZW)=@INVDX@(ZI)
        . S @OUTVDV@("XPATH",ZW)=ZI
        Q
        ;
VDX2XPG(OUTXPG,INVDX)   ; CONVERT AN VDX ARRAY TO XPG
        ; VDX: @VDX@(XPATH)=VALUE
        ; XPG: @(VDX(X1,X2,X3,X4))@=VALUE
        ; THIS IS A STEP TOWARD GENERATING XML FROM A VDX
        N ZA,ZI,ZW
        S ZI=""
        F  S ZI=$O(@INVDX@(ZI)) Q:ZI=""  D  ;
        . S ZW=$E(ZI,3,$L(ZI)) ; STRIP OFF INITIAL //
        . S ZW2=$P(ZW,"/",1)
        . F ZK=1:1:$L(ZW,"/") D PUSH("ZA",$P(ZW,"/",ZK))
        . ;ZWR ZA
        . S ZW2=ZA(1)
        . F ZK=2:1:ZA(0) D  ;
        . . S ZW2=ZW2_""","""_ZA(ZK)
        . K ZA
        . S ZW2=""""_ZW2_""""
        . W ZW2,!
        . S ZN=OUTXPG_"("_ZW2_")"
        . S @ZN=@INVDX@(ZI)
        Q
        ;
XML2XPG(OUTXPG,INXML)   ; CONVERT AN XML ARRAY, PASSED BY NAME TO AN XPG ARRAY
        ; XPG MEANS XPATH GLOBAL AND HAS THE FORM @OUTXPG@("X1","X2","X3")=VALUE
        ;
        ;N G1
        D INDEX(INXML,"G1",1) ; PRODUCES A VDX ARRAY IN G1, NO INDEX IS PRODUCED
        D VDX2XPG(OUTXPG,"G1") ; CONVERTS THE VDX ARRAY TO XPG FORM
        Q
        ;
DO      
        D XPG2XML("^GPL2B","^GPL2A")
        Q
        ;
T1      ; TEST OUT THESE ROUTINES 
        D XML2XPG("G2","^GPL")
        D XPG2XML("G3","G2")
        K ^GPLOUT
        M ^GPLOUT=G3
        W $$OUTPUT^C0CXPATH("^GPLOUT(1)","GPLTEST.xml","/home/vademo2/EHR/p")
        Q
        ;
XPG2XML(OUTXML,INXPG)   ;
        N C0CN,FWD,ZA,G,GA,ZQ
        S ZQ=0 ; QUIT FLAG
        F  Q:ZQ=1  D  ; LOOP THROUGH EVERYTHING
        . I '$D(C0CN) D  ; FIRST TIME THROUGH
        . . K @OUTXML ; MAKE SURE OUTPUT ARRAY IS CLEAR
        . . S FWD=1 ; START OUT GOING FORWARD THROUGH SUBSCRIPTS
        . . S G=$Q(@INXPG) ; THIS ONE
        . . S GN=$Q(@G) ; NEXT ONE
        . . S C0CN=1 ; SUBSCRIPT COUNT
        . . S ZQ=0 ; QUIT FLAG
        . . D ZXO("?xml version=""1.0"" encoding=""UTF-8""?") ;MAKE IT REAL XML
        . . I $QS(G,1)="ContinuityOfCareRecord" D  ;
        . . . D ZXO("?xml-stylesheet type=""text/xsl"" href=""ccr.xsl""?") ; HACK TO MAKE THE CCR STYLESHEET WORK
        . I FWD D  ; GOING FORWARDS 
        . . I C0CN<$QL(G) D  ; NOT A DATA NODE
        . . . S ZA=$QS(G,C0CN) ; PULL OUT THE SUBSCRIPT
        . . . D ZXO(ZA) ; AND OPEN AN XML ELEMENT
        . . . I @OUTXML@(@OUTXML@(0))="<ContinuityOfCareRecord>" D  ;
        . . . . S @OUTXML@(@OUTXML@(0))="<ContinuityOfCareRecord xmlns=""urn:astm-org:CCR"">"
        . . . S C0CN=C0CN+1 ; MOVE TO THE NEXT ONE
        . . E  D  ; AT THE DATA NODE
        . . . S ZA=$QS(G,C0CN) ; PULL OUT THE SUBSCRIPT
        . . . D ZXVAL(ZA,@G) ; OUTPUT <X>VAL</X> FOR DATA NODE
        . . . S FWD=0 ; GO BACKWARDS
        . I 'FWD D  ;GOING BACKWARDS
        . . S GN=$Q(@G) ;NEXT XPATH
        . . ;W "NEXT!",GN,!
        . . S C0CN=C0CN-1 ; PREVIOUS SUBSCRIPT
        . . I GN'="" D  ;
        . . . I $QS(G,C0CN)'=$QS(GN,C0CN) D  ; NEED TO CLOSE OFF ELEMENT
        . . . . D ZXC($QS(G,C0CN)) ;
        . . . E  I GN'="" D  ; MORE ELEMENTS AT THIS LEVEL
        . . . . S G=$Q(@G) ; ADVANCE TO NEW XPATH
        . . . . S C0CN=C0CN+1 ; GET READY TO PROCESS NEXT SUBSCRIPT
        . . . . S FWD=1 ; GOING FORWARD NOW
        . I (GN="")&(C0CN=1) D  Q  ; WHEN WE ARE ALL DONE
        . . D ZXC($QS(G,C0CN)) ; LAST ONE
        . . S ZQ=1 ; QUIT NOW
        Q
        ;
ZXO(WHAT)       
        D PUSH("GA",WHAT)
        D PUSH(OUTXML,"<"_WHAT_">")
        Q
        ;
ZXC(WHAT)       
        D POP("GA",.TMP)
        D PUSH(OUTXML,"</"_WHAT_">")
        Q
        ;
ZXVAL(WHAT,VAL) 
        D PUSH(OUTXML,"<"_WHAT_">"_VAL_"</"_WHAT_">")
        Q
        ;
INDEX(IZXML,VDX,NOINX,TEMPLATE,REDUX)   ; parse XML in IZXML and produce 
        ; an XPATH index; REDUX is a string to be removed from each xpath
        ; GPL 7/14/09 OPTIONALLY GENERATE AN XML TEMPLATE IF PASSED BY NAME
        ; TEMPLATE IS IDENTICAL TO THE PARSED XML LINE BY LINE
        ; EXCEPT THAT DATA VALUES ARE REPLACED WITH @@XPATH@@ FOR THE XPATH OF THE TAG
        ; GPL 5/24/09 AND OPTIONALLY PRODUCE THE VDX ARRAY PASSED BY NAME
        ; @VDX@("XPATH")=VALUE
        ; ex. @IZXML@("XPATH")=FIRSTLINE^LASTLINE
        ; WHERE FIRSTLINE AND LASTLINE ARE THE BEGINNING AND ENDING OF THE
        ; XML SECTION
        ; IZXML IS PASSED BY NAME
        ; IF NOINX IS SET TO 1, NO INDEX WILL BE GENERATED, BUT THE VDX WILL BE
        N I,LINE,FIRST,LAST,CUR,TMP,MDX,FOUND,CURVAL,DVDX,LCNT
        N C0CSTK ; LEAVE OUT FOR DEBUGGING
        I '$D(REDUX) S REDUX=""
        I '$D(NOINX) S NOINX=0 ; IF NOT PASSED, GENERATE AN INDEX
        N ZXML
        I NOINX S ZXML=$NA(^TMP("C0CINDEX",$J)) ; TEMP PLACE FOR INDEX TO DISCARD
        E  S ZXML=IZXML ; PLACE FOR INDEX TO KEEP
        I '$D(@IZXML@(0)) D  ; IF COUNT NOT IN NODE 0 COUNT THEM
        . S I="",LCNT=0
        . F  S I=$O(@IZXML@(I)) Q:I=""  S LCNT=LCNT+1
        E  S LCNT=@IZXML@(0) ; LINE COUNT PASSED IN ARRAY
        I LCNT=0  D  Q  ; NO XML PASSED
        . W "ERROR IN XML FILE",!
        S DVDX=0 ; DEFAULT DO NOT PRODUCE VDX INDEX
        I $D(VDX) S DVDX=1 ; IF NAME PASSED, DO VDX
        S C0CSTK(0)=0 ; INITIALIZE STACK
        K LKASD ; KILL LOOKASIDE ARRAY
        D MKLASD(.LKASD,IZXML) ;MAKE LOOK ASIDE BUFFER FOR MULTIPLES
        F I=1:1:LCNT  D  ; PROCESS THE ENTIRE ARRAY
        . S LINE=@IZXML@(I)
        . I $D(TEMPLATE) D  ;IF TEMPLATE IS REQUESTED
        . . S @TEMPLATE@(I)=$$CLEAN(LINE) 
        . ;W LINE,!
        . S FOUND=0  ; INTIALIZED FOUND FLAG
        . I LINE?.E1"<!".E S FOUND=1 ; SKIP OVER COMMENTS
        . I FOUND'=1  D
        . . I (LINE?.E1"<"1.E1"</".E)!(LINE?.E1"<"1.E1"/>".E)  D
        . . . ; THIS IS THE CASE THERE SECTION BEGINS AND ENDS
        . . . ; ON THE SAME LINE
        . . . ; W "FOUND ",LINE,!
        . . . S FOUND=1  ; SET FOUND FLAG
        . . . S CUR=$$XNAME(LINE) ; EXTRACT THE NAME
        . . . S CUR=CUR_$G(LKASD(CUR,I)) ; HANDLE MULTIPLES
        . . . D PUSH("C0CSTK",CUR) ; ADD TO THE STACK
        . . . D MKMDX("C0CSTK",.MDX,REDUX) ; GENERATE THE M INDEX
        . . . ; W "MDX=",MDX,!
        . . . I $D(@ZXML@(MDX))  D  ; IN THE INDEX, IS A MULTIPLE
        . . . . ;I '$D(ZDUP(MDX)) S ZDUP(MDX)=2
        . . . . ;E  S ZDUP(MDX)=ZDUP(MDX)+1
        . . . . ;W "DUP:",MDX,!
        . . . . ;I '$D(CURVAL) S CURVAL=""
        . . . . ;I DVDX S @VDX@(MDX_"["_ZDUP(MDX)_"]")=CURVAL
        . . . . S $P(@ZXML@(MDX),"^",2)=I ; UPDATE LAST LINE NUMBER
        . . . I '$D(@ZXML@(MDX))  D  ; NOT IN THE INDEX, NOT A MULTIPLE
        . . . . S @ZXML@(MDX)=I_"^"_I  ; ADD INDEX ENTRY-FIRST AND LAST
        . . . . S CURVAL=$$XVAL(LINE) ; VALUE
        . . . . S $P(@ZXML@(MDX),"^",3)=CURVAL ; THIRD PIECE
        . . . . I DVDX S @VDX@(MDX)=CURVAL ; FILL IN VDX ARRAY IF REQUESTED
        . . . . I $D(TEMPLATE) D  ; IF TEMPLATE IS REQUESTED
        . . . . . S LINE=$$CLEAN(LINE) ; CLEAN OUT CONTROL CHARACTERS
        . . . . . S @TEMPLATE@(I)=$P(LINE,">",1)_">@@"_MDX_"@@</"_$P(LINE,"</",2)
        . . . D POP("C0CSTK",.TMP) ; REMOVE FROM STACK
        . I FOUND'=1  D  ; THE LINE DOESN'T CONTAIN THE START AND END
        . . I LINE?.E1"</"1.E  D  ; LINE CONTAINS END OF A SECTION
        . . . ; W "FOUND ",LINE,!
        . . . S FOUND=1  ; SET FOUND FLAG
        . . . S CUR=$$XNAME(LINE) ; EXTRACT THE NAME
        . . . D MKMDX("C0CSTK",.MDX) ; GENERATE THE M INDEX
        . . . S $P(@ZXML@(MDX),"^",2)=I ; UPDATE LAST LINE NUMBER
        . . . D POP("C0CSTK",.TMP) ; REMOVE FROM STACK
        . . . S TMP=$P(TMP,"[",1) ; REMOVE [X] FROM MULTIPLE
        . . . I TMP'=CUR  D  ; MALFORMED XML, END MUST MATCH START
        . . . . W "MALFORMED XML ",CUR,"LINE "_I_LINE,!
        . . . . D PARY("C0CSTK") ; PRINT OUT THE STACK FOR DEBUGING
        . . . . Q
        . I FOUND'=1  D  ; THE LINE MIGHT CONTAIN A SECTION BEGINNING
        . . I (LINE?.E1"<"1.E)&(LINE'["?>")  D  ; BEGINNING OF A SECTION
        . . . ; W "FOUND ",LINE,!
        . . . S FOUND=1  ; SET FOUND FLAG
        . . . S CUR=$$XNAME(LINE) ; EXTRACT THE NAME
        . . . S CUR=CUR_$G(LKASD(CUR,I)) ; HANDLE MULTIPLES
        . . . D PUSH("C0CSTK",CUR) ; ADD TO THE STACK
        . . . D MKMDX("C0CSTK",.MDX) ; GENERATE THE M INDEX
        . . . ; W "MDX=",MDX,!
        . . . I $D(@ZXML@(MDX))  D  ; IN THE INDEX, IS A MULTIPLE
        . . . . S $P(@ZXML@(MDX),"^",2)=I ; UPDATE LAST LINE NUMBER
        . . . . ;B
        . . . I '$D(@ZXML@(MDX))  D  ; NOT IN THE INDEX, NOT A MULTIPLE
        . . . . S @ZXML@(MDX)=I_"^" ; INSERT INTO THE INDEX
        S @ZXML@("INDEXED")=""
        S @ZXML@("//")="1^"_LCNT ; ROOT XPATH
        I NOINX K @ZXML ; DELETE UNWANTED INDEX
        Q
        ;
MKLASD(OUTBUF,INARY)    ; CREATE A LOOKASIDE BUFFER FOR MULTILPLES
        ;
        N ZI,ZN,ZA,ZLINE,ZLINE2,CUR,CUR2
        F ZI=1:1:LCNT-1  D  ; PROCESS THE ENTIRE ARRAY 
        . S ZLINE=@IZXML@(ZI)
        . I ZI<LCNT S ZLINE2=@IZXML@(ZI+1)
        . I ZLINE?.E1"</"1.E  D  ; NEXT LINE CONTAINS END OF A SECTION
        . . S CUR=$$XNAME(ZLINE) ; EXTRACT THE NAME
        . . I (ZLINE2?.E1"<"1.E)&(ZLINE'["?>")  D  ; BEGINNING OF A SECTION
        . . . S CUR2=$$XNAME(ZLINE2) ; EXTRACT THE NAME 
        . . . I CUR=CUR2 D  ; IF THIS IS A MULTIPLE
        . . . . S OUTBUF(CUR,ZI+1)=""
        ;ZWR OUTBUF
        S ZI=""
        F  S ZI=$O(OUTBUF(ZI)) Q:ZI=""  D  ; FOR EACH KIND OF MULTIPLE
        . S ZN=$O(OUTBUF(ZI,"")) ; LINE NUMBER OF SECOND MULTIPLE
        . F  S ZN=$O(@IZXML@(ZN),-1) Q:ZN=""  I $E($P(@IZXML@(ZN),"<"_ZI,2),1,1)=">" Q  ;
        . S OUTBUF(ZI,ZN)=""
        S ZA=1,ZI="",ZN=""
        F  S ZI=$O(OUTBUF(ZI)) Q:ZI=""  D  ; ADDING THE COUNT FOR THE MULIPLES [x]
        . S ZN="",ZA=1
        . F  S ZN=$O(OUTBUF(ZI,ZN)) Q:ZN=""  D  ;
        . . S OUTBUF(ZI,ZN)="["_ZA_"]"
        . . S ZA=ZA+1
        Q
        ;
CLEAN(STR,TR)   ; extrinsic function; returns string
        ;; Removes all non printable characters from a string.
        ;; STR by Value
        ;; TR IS OPTIONAL TO IMPROVE PERFORMANCE
        N TR,I
        I '$D(TR) D  ;
        . F I=0:1:31 S TR=$G(TR)_$C(I)
        . S TR=TR_$C(127)
        QUIT $TR(STR,TR)
        ;
QUERY(IARY,XPATH,OARY)   ; RETURNS THE XML ARRAY MATCHING THE XPATH EXPRESSION
        ; XPATH IS OF THE FORM "//FIRST/SECOND/THIRD"
        ; IARY AND OARY ARE PASSED BY NAME
        I '$D(@IARY@("INDEXED"))  D  ; INDEX IS NOT PRESENT IN IARY
        . D INDEX(IARY) ; GENERATE AN INDEX FOR THE XML
        N FIRST,LAST ; FIRST AND LAST LINES OF ARRAY TO RETURN
        N TMP,I,J,QXPATH
        S FIRST=1
        I '$D(@IARY@(0)) D  ; LINE COUNT NOT IN ZERO NODE
        . S @IARY@(0)=$O(@IARY@("//"),-1) ; THIS SHOULD USUALLY WORK
        S LAST=@IARY@(0) ; FIRST AND LAST DEFAULT TO ROOT
        I XPATH'="//" D  ; NOT A ROOT QUERY
        . S TMP=@IARY@(XPATH) ; LOOK UP LINE VALUES
        . S FIRST=$P(TMP,"^",1)
        . S LAST=$P(TMP,"^",2)
        K @OARY
        S @OARY@(0)=+LAST-FIRST+1
        S J=1
        FOR I=FIRST:1:LAST  D
        . S @OARY@(J)=@IARY@(I) ; COPY THE LINE TO OARY
        . S J=J+1
        ; ZWR OARY
        Q
        ;
XF(IDX,XPATH)     ; EXTRINSIC TO RETURN THE STARTING LINE FROM AN XPATH
        ; INDEX WITH TWO PIECES START^FINISH
        ; IDX IS PASSED BY NAME
        Q $P(@IDX@(XPATH),"^",1)
        ;
XL(IDX,XPATH)     ; EXTRINSIC TO RETURN THE LAST LINE FROM AN XPATH
        ; INDEX WITH TWO PIECES START^FINISH
        ; IDX IS PASSED BY NAME
        Q $P(@IDX@(XPATH),"^",2)
        ;
START(ISTR)         ; EXTRINSIC TO RETURN THE STARTING LINE FROM AN INDEX
        ; TYPE STRING WITH THREE PIECES ARRAY;START;FINISH
        ; COMPANION TO FINISH ; IDX IS PASSED BY NAME
        Q $P(ISTR,";",2)
        ;
FINISH(ISTR)       ; EXTRINSIC TO RETURN THE LAST LINE FROM AN INDEX
        ; TYPE STRING WITH THREE PIECES ARRAY;START;FINISH
        Q $P(ISTR,";",3)
        ;
ARRAY(ISTR)         ; EXTRINSIC TO RETURN THE ARRAY REFERENCE FROM AN INDEX
        ; TYPE STRING WITH THREE PIECES ARRAY;START;FINISH
        Q $P(ISTR,";",1)
        ;
BUILD(BLIST,BDEST)           ; A COPY MACHINE THAT TAKE INSTRUCTIONS IN ARRAY BLIST
        ; WHICH HAVE ARRAY;START;FINISH AND COPIES THEM TO DEST
        ; DEST IS CLEARED TO START
        ; USES PUSH TO DO THE COPY
        N I
        K @BDEST
        F I=1:1:@BLIST@(0) D  ; FOR EACH INSTRUCTION IN BLIST
        . N J,ATMP
        . S ATMP=$$ARRAY(@BLIST@(I))
        . I $G(DEBUG) W "ATMP=",ATMP,!
        . I $G(DEBUG) W @BLIST@(I),!
        . F J=$$START(@BLIST@(I)):1:$$FINISH(@BLIST@(I)) D  ;
        . . ; FOR EACH LINE IN THIS INSTR
        . . I $G(DEBUG) W "BDEST= ",BDEST,!
        . . I $G(DEBUG) W "ATMP= ",@ATMP@(J),!
        . . D PUSH(BDEST,@ATMP@(J))
        Q
        ;
QUEUE(BLST,ARRAY,FIRST,LAST)       ; ADD AN ENTRY TO A BLIST
        ;
        I $G(DEBUG) W "QUEUEING ",BLST,!
        D PUSH(BLST,ARRAY_";"_FIRST_";"_LAST)
        Q
        ;
CP(CPSRC,CPDEST)               ; COPIES CPSRC TO CPDEST BOTH PASSED BY NAME
        ; KILLS CPDEST FIRST
        N CPINSTR
        I $G(DEBUG) W "MADE IT TO COPY",CPSRC,CPDEST,!
        I @CPSRC@(0)<1 D  ; BAD LENGTH
        . W "ERROR IN COPY BAD SOURCE LENGTH: ",CPSRC,!
        . Q
        ; I '$D(@CPDEST@(0)) S @CPDEST@(0)=0 ; IF THE DEST IS EMPTY, INIT
        D QUEUE("CPINSTR",CPSRC,1,@CPSRC@(0)) ; BLIST FOR ENTIRE ARRAY
        D BUILD("CPINSTR",CPDEST)
        Q
        ;
QOPEN(QOBLIST,QOXML,QOXPATH)       ; ADD ALL BUT THE LAST LINE OF QOXML TO QOBLIST
        ; WARNING NEED TO DO QCLOSE FOR SAME XML BEFORE CALLING BUILD
        ; QOXPATH IS OPTIONAL - WILL OPEN INSIDE THE XPATH POINT
        ; USED TO INSERT CHILDREN NODES
        I @QOXML@(0)<1 D  ; MALFORMED XML
        . W "MALFORMED XML PASSED TO QOPEN: ",QOXML,!
        . Q
        I $G(DEBUG) W "DOING QOPEN",!
        N S1,E1,QOT,QOTMP
        S S1=1 ; OPEN FROM THE BEGINNING OF THE XML
        I $D(QOXPATH) D  ; XPATH PROVIDED
        . D QUERY(QOXML,QOXPATH,"QOT") ; INSURE INDEX
        . S E1=$P(@QOXML@(QOXPATH),"^",2)-1
        I '$D(QOXPATH) D  ; NO XPATH PROVIDED, OPEN AT ROOT
        . S E1=@QOXML@(0)-1
        D QUEUE(QOBLIST,QOXML,S1,E1)
        ; S QOTMP=QOXML_"^"_S1_"^"_E1
        ; D PUSH(QOBLIST,QOTMP)
        Q
        ;
QCLOSE(QCBLIST,QCXML,QCXPATH)     ; CLOSE XML AFTER A QOPEN
        ; ADDS THE LIST LINE OF QCXML TO QCBLIST
        ; USED TO FINISH INSERTING CHILDERN NODES
        ; QCXPATH IS OPTIONAL - IF PROVIDED, WILL CLOSE UNTIL THE END
        ; IF QOPEN WAS CALLED WITH XPATH, QCLOSE SHOULD BE TOO
        I @QCXML@(0)<1 D  ; MALFORMED XML
        . W "MALFORMED XML PASSED TO QCLOSE: ",QCXML,!
        I $G(DEBUG) W "GOING TO CLOSE",!
        N S1,E1,QCT,QCTMP
        S E1=@QCXML@(0) ; CLOSE UNTIL THE END OF THE XML
        I $D(QCXPATH) D  ; XPATH PROVIDED
        . D QUERY(QCXML,QCXPATH,"QCT") ; INSURE INDEX
        . S S1=$P(@QCXML@(QCXPATH),"^",2) ; REMAINING XML
        I '$D(QCXPATH) D  ; NO XPATH PROVIDED, CLOSE AT ROOT
        . S S1=@QCXML@(0)
        D QUEUE(QCBLIST,QCXML,S1,E1)
        ; D PUSH(QCBLIST,QCXML_";"_S1_";"_E1)
        Q
        ;
INSERT(INSXML,INSNEW,INSXPATH)   ; INSERT INSNEW INTO INSXML AT THE
        ; INSXPATH XPATH POINT INSXPATH IS OPTIONAL - IF IT IS
        ; OMITTED, INSERTION WILL BE AT THE ROOT
        ; NOTE INSERT IS NON DESTRUCTIVE AND WILL ADD THE NEW
        ; XML AT THE END OF THE XPATH POINT
        ; INSXML AND INSNEW ARE PASSED BY NAME INSXPATH IS A VALUE
        N INSBLD,INSTMP
        I $G(DEBUG) W "DOING INSERT ",INSXML,INSNEW,INSXPATH,!
        I $G(DEBUG) F G1=1:1:@INSXML@(0) W @INSXML@(G1),!
        I '$D(@INSXML@(1)) D  ; INSERT INTO AN EMPTY ARRAY
        . D CP^C0CXPATH(INSNEW,INSXML) ; JUST COPY INTO THE OUTPUT
        I $D(@INSXML@(1)) D  ; IF ORIGINAL ARRAY IS NOT EMPTY
        . I '$D(@INSXML@(0)) S @INSXML@(0)=$O(@INSXML@(""),-1) ;SET LENGTH
        . I $D(INSXPATH) D  ; XPATH PROVIDED
        . . D QOPEN("INSBLD",INSXML,INSXPATH) ; COPY THE BEFORE
        . . I $G(DEBUG) D PARY^C0CXPATH("INSBLD")
        . I '$D(INSXPATH) D  ; NO XPATH PROVIDED, OPEN AT ROOT
        . . D QOPEN("INSBLD",INSXML,"//") ; OPEN WITH ROOT XPATH
        . I '$D(@INSNEW@(0)) S @INSNEW@(0)=$O(@INSNEW@(""),-1) ;SIZE OF XML
        . D QUEUE("INSBLD",INSNEW,1,@INSNEW@(0)) ; COPY IN NEW XML
        . I $D(INSXPATH) D  ; XPATH PROVIDED
        . . D QCLOSE("INSBLD",INSXML,INSXPATH) ; CLOSE WITH XPATH
        . I '$D(INSXPATH) D  ; NO XPATH PROVIDED, CLOSE AT ROOT
        . . D QCLOSE("INSBLD",INSXML,"//") ; CLOSE WITH ROOT XPATH
        . D BUILD("INSBLD","INSTMP") ; PUT RESULTS IN INDEST
        . D CP^C0CXPATH("INSTMP",INSXML) ; COPY BUFFER TO SOURCE
        Q
        ;
INSINNER(INNXML,INNNEW,INNXPATH)               ; INSERT THE INNER XML OF INNNEW
        ; INTO INNXML AT THE INNXPATH XPATH POINT
        ;
        N INNBLD,UXPATH
        N INNTBUF
        S INNTBUF=$NA(^TMP($J,"INNTBUF"))
        I '$D(INNXPATH) D  ; XPATH NOT PASSED
        . S UXPATH="//" ; USE ROOT XPATH
        I $D(INNXPATH) S UXPATH=INNXPATH ; USE THE XPATH THAT'S PASSED
        I '$D(@INNXML@(0)) D  ; INNXML IS EMPTY
        . D QUEUE^C0CXPATH("INNBLD",INNNEW,2,@INNNEW@(0)-1) ; JUST INNER
        . D BUILD("INNBLD",INNXML)
        I @INNXML@(0)>0  D  ; NOT EMPTY
        . D QOPEN("INNBLD",INNXML,UXPATH) ;
        . D QUEUE("INNBLD",INNNEW,2,@INNNEW@(0)-1) ; JUST INNER XML
        . D QCLOSE("INNBLD",INNXML,UXPATH)
        . D BUILD("INNBLD",INNTBUF) ; BUILD TO BUFFER
        . D CP(INNTBUF,INNXML) ; COPY BUFFER TO DEST
        Q
        ;
INSB4(XDEST,XNEW)       ; INSERT XNEW AT THE BEGINNING OF XDEST
        ; BUT XDEST AN XNEW ARE PASSED BY NAME
        N XBLD,XTMP
        D QUEUE("XBLD",XDEST,1,1) ; NEED TO PRESERVE SECTION ROOT
        D QUEUE("XBLD",XNEW,1,@XNEW@(0)) ; ALL OF NEW XML FIRST
        D QUEUE("XBLD",XDEST,2,@XDEST@(0)) ; FOLLOWED BY THE REST OF SECTION
        D BUILD("XBLD","XTMP") ; BUILD THE RESULT
        D CP("XTMP",XDEST) ; COPY TO THE DESTINATION
        I $G(DEBUG) D PARY("XDEST")
        Q
        ;
REPLACE(REXML,RENEW,REXPATH)       ; REPLACE THE XML AT THE XPATH POINT
        ; WITH RENEW - NOTE THIS WILL DELETE WHAT WAS THERE BEFORE
        ; REXML AND RENEW ARE PASSED BY NAME XPATH IS A VALUE
        ; THE DELETED XML IS PUT IN ^TMP($J,"REPLACE_OLD")
        N REBLD,XFIRST,XLAST,OLD,XNODE,RETMP
        S OLD=$NA(^TMP($J,"REPLACE_OLD"))
        D QUERY(REXML,REXPATH,OLD) ; CREATE INDEX, TEST XPATH, MAKE OLD
        S XNODE=@REXML@(REXPATH) ; PULL OUT FIRST AND LAST LINE PTRS
        S XFIRST=$P(XNODE,"^",1)
        S XLAST=$P(XNODE,"^",2)
        I RENEW="" D  ; WE ARE DELETING A SECTION, MUST SAVE THE TAG
        . D QUEUE("REBLD",REXML,1,XFIRST) ; THE BEFORE
        . D QUEUE("REBLD",REXML,XLAST,@REXML@(0)) ; THE REST
        I RENEW'="" D  ; NEW XML IS NOT NULL
        . D QUEUE("REBLD",REXML,1,XFIRST-1) ; THE BEFORE
        . D QUEUE("REBLD",RENEW,1,@RENEW@(0)) ; THE NEW
        . D QUEUE("REBLD",REXML,XLAST+1,@REXML@(0)) ; THE REST
        I $G(DEBUG) W "REPLACE PREBUILD",!
        I $G(DEBUG) D PARY("REBLD")
        D BUILD("REBLD","RTMP")
        K @REXML ; KILL WHAT WAS THERE
        D CP("RTMP",REXML) ; COPY IN THE RESULT
        Q
        ;
DELETE(REXML,REXPATH)      ; DELETE THE XML AT THE XPATH POINT
        ; REXML IS PASSED BY NAME XPATH IS A VALUE
        N REBLD,XFIRST,XLAST,OLD,XNODE,RETMP
        S OLD=$NA(^TMP($J,"REPLACE_OLD"))
        D QUERY(REXML,REXPATH,OLD) ; CREATE INDEX, TEST XPATH, MAKE OLD
        S XNODE=@REXML@(REXPATH) ; PULL OUT FIRST AND LAST LINE PTRS
        S XFIRST=$P(XNODE,"^",1)
        S XLAST=$P(XNODE,"^",2)
        D QUEUE("REBLD",REXML,1,XFIRST-1) ; THE BEFORE
        D QUEUE("REBLD",REXML,XLAST+1,@REXML@(0)) ; THE REST
        I $G(DEBUG) D PARY("REBLD")
        D BUILD("REBLD","RTMP")
        K @REXML ; KILL WHAT WAS THERE
        D CP("RTMP",REXML) ; COPY IN THE RESULT
        Q
        ;
MISSING(IXML,OARY)           ; SEARTH THROUGH INXLM AND PUT ANY @@X@@ VARS IN OARY
        ; W "Reporting on the missing",!
        ; W OARY
        I '$D(@IXML@(0)) W "MALFORMED XML PASSED TO MISSING",! Q
        N I
        S @OARY@(0)=0 ; INITIALIZED MISSING COUNT
        F I=1:1:@IXML@(0)  D   ; LOOP THROUGH WHOLE ARRAY
        . I @IXML@(I)?.E1"@@".E D  ; MISSING VARIABLE HERE
        . . D PUSH^C0CXPATH(OARY,$P(@IXML@(I),"@@",2)) ; ADD TO OUTARY
        . . Q
        Q
        ;
MAP(IXML,INARY,OXML)    ; SUBSTITUTE MULTIPLE @@X@@ VARS WITH VALUES IN INARY
        ; AND PUT THE RESULTS IN OXML
        N XCNT
        I '$D(DEBUG) S DEBUG=0
        I '$D(IXML) W "MALFORMED XML PASSED TO MAP",! Q
        I '$D(@IXML@(0)) D  ; INITIALIZE COUNT
        . S XCNT=$O(@IXML@(""),-1)
        E  S XCNT=@IXML@(0) ;COUNT
        I $O(@INARY@(""))="" W "EMPTY ARRAY PASSED TO MAP",! Q
        N I,J,TNAM,TVAL,TSTR
        S @OXML@(0)=XCNT ; TOTAL LINES IN OUTPUT
        F I=1:1:XCNT  D   ; LOOP THROUGH WHOLE ARRAY
        . S @OXML@(I)=@IXML@(I) ; COPY THE LINE TO OUTPUT
        . I @OXML@(I)?.E1"@@".E D  ; IS THERE A VARIABLE HERE?
        . . S TSTR=$P(@IXML@(I),"@@",1) ; INIT TO PART BEFORE VARS
        . . F J=2:2:10  D  Q:$P(@IXML@(I),"@@",J+2)=""  ; QUIT IF NO MORE VARS
        . . . I DEBUG W "IN MAPPING LOOP: ",TSTR,!
        . . . S TNAM=$P(@OXML@(I),"@@",J) ; EXTRACT THE VARIABLE NAME
        . . . S TVAL="@@"_$P(@IXML@(I),"@@",J)_"@@" ; DEFAULT UNCHANGED
        . . . I $D(@INARY@(TNAM))  D  ; IS THE VARIABLE IN THE MAP?
        . . . . I '$D(@INARY@(TNAM,"F")) D  ; NOT A SPECIAL FIELD
        . . . . . S TVAL=@INARY@(TNAM) ; PULL OUT MAPPED VALUE
        . . . . E  D DOFLD ; PROCESS A FIELD
        . . . S TVAL=$$SYMENC^MXMLUTL(TVAL) ;MAKE SURE THE VALUE IS XML SAFE
        . . . S TSTR=TSTR_TVAL_$P(@IXML@(I),"@@",J+1) ; ADD VAR AND PART AFTER
        . . S @OXML@(I)=TSTR ; COPY LINE WITH MAPPED VALUES
        . . I DEBUG W TSTR
        I DEBUG W "MAPPED",!
        Q
        ;
DOFLD   ; PROCESS A FILEMAN FIELD REFERENCED BY A VARIABLE
        ;
        Q
        ;
TRIM(THEXML)    ; TAKES OUT ALL NULL ELEMENTS
        ; THEXML IS PASSED BY NAME
        N I,J,TMPXML,DEL,FOUND,INTXT
        S FOUND=0
        S INTXT=0
        I $G(DEBUG) W "DELETING EMPTY ELEMENTS",!
        F I=1:1:(@THEXML@(0)-1) D  ; LOOP THROUGH ENTIRE ARRAY
        . S J=@THEXML@(I)
        . I J["<text>" D
        . . S INTXT=1 ; IN HTML SECTION, DON'T TRIM
        . . I $G(DEBUG) W "IN HTML SECTION",!
        . N JM,JP,JPX ; JMINUS AND JPLUS
        . S JM=@THEXML@(I-1) ; LINE BEFORE
        . I JM["</text>" S INTXT=0 ; LEFT HTML SECTION,START TRIM
        . S JP=@THEXML@(I+1) ; LINE AFTER
        . I INTXT=0 D  ; IF NOT IN AN HTML SECTION
        . . S JPX=$TR(JP,"/","") ; REMOVE THE SLASH
        . . I J=JPX D  ; AN EMPTY ELEMENT ON TWO LINES
        . . . I $G(DEBUG) W I,J,JP,!
        . . . S FOUND=1 ; FOUND SOMETHING TO BE DELETED
        . . . S DEL(I)="" ; SET LINE TO DELETE
        . . . S DEL(I+1)="" ; SET NEXT LINE TO DELETE
        . . I J["><" D  ; AN EMPTY ELEMENT ON ONE LINE
        . . . I $G(DEBUG) W I,J,!
        . . . S FOUND=1 ; FOUND SOMETHING TO BE DELETED
        . . . S DEL(I)="" ; SET THE EMPTY LINE UP TO BE DELETED
        . . . I JM=JPX D  ;
        . . . . I $G(DEBUG) W I,JM_J_JPX,!
        . . . . S DEL(I-1)=""
        . . . . S DEL(I+1)="" ; SET THE SURROUNDING LINES FOR DEL
        ; . I J'["><" D PUSH("TMPXML",J)
        I FOUND D  ; NEED TO DELETE THINGS
        . F I=1:1:@THEXML@(0) D  ; COPY ARRAY LEAVING OUT DELELTED LINES
        . . I '$D(DEL(I)) D  ; IF THE LINE IS NOT DELETED
        . . . D PUSH("TMPXML",@THEXML@(I)) ; COPY TO TMPXML ARRAY
        . D CP("TMPXML",THEXML) ; REPLACE THE XML WITH THE COPY
        Q FOUND
        ;
UNMARK(XSEC)    ; REMOVE MARKUP FROM FIRST AND LAST LINE OF XML
        ; XSEC IS A SECTION PASSED BY NAME
        N XBLD,XTMP
        D QUEUE("XBLD",XSEC,2,@XSEC@(0)-1) ; BUILD LIST FOR INNER XML
        D BUILD("XBLD","XTMP") ; BUILD THE RESULT
        D CP("XTMP",XSEC) ; REPLACE PASSED XML
        Q
        ;
PARY(GLO,ZN)          ;PRINT AN ARRAY
        ; IF ZN=-1 NO LINE NUMBERS
        N I
        F I=1:1:@GLO@(0) D  ;
        . I $G(ZN)=-1 W @GLO@(I),!
        . E  W I_" "_@GLO@(I),!
        Q
        ;
H2ARY(IARYRTN,IHASH,IPRE)       ; CONVERT IHASH TO RETURN ARRAY
        ; IPRE IS OPTIONAL PREFIX FOR THE ELEMENTS. USED FOR MUPTIPLES 1^"VAR"^VALUE
        I '$D(IPRE) S IPRE=""
        N H2I S H2I=""
        ; W $O(@IHASH@(H2I)),!
        F  S H2I=$O(@IHASH@(H2I)) Q:H2I=""  D  ; FOR EACH ELEMENT OF THE HASH
        . I $QS(H2I,$QL(H2I))="M" D  Q  ; SPECIAL CASE FOR MULTIPLES
        . . ;W H2I_"^"_@IHASH@(H2I),!
        . . N IH,IHI
        . . S IH=$NA(@IHASH@(H2I)) ;
        . . S IH2A=$O(@IH@("")) ; SKIP OVER MULTIPLE DISCRIPTOR
        . . S IH2=$NA(@IH@(IH2A)) ; PAST THE "M","DIRETIONS" FOR EXAMPLE
        . . S IHI="" ; INDEX INTO "M" MULTIPLES
        . . F  S IHI=$O(@IH2@(IHI)) Q:IHI=""  D  ; FOR EACH SUB-MULTIPLE
        . . . ; W @IH@(IHI)
        . . . S IH3=$NA(@IH2@(IHI))
        . . . ; W "HEY",IH3,!
        . . . D H2ARY(.IARYRTN,IH3,IPRE_";"_IHI) ; RECURSIVE CALL - INDENTED ELEMENTS
        . . ; W IH,!
        . . ; W "C0CZZ",!
        . . ; W $NA(@IHASH@(H2I)),!
        . . Q  ;
        . D PUSH(IARYRTN,IPRE_"^"_H2I_"^"_@IHASH@(H2I))
        . ; W @IARYRTN@(0),!
        Q
        ;
XVARS(XVRTN,XVIXML)     ; RETURNS AN ARRAY XVRTN OF ALL UNIQUE VARIABLES
        ; DEFINED IN INPUT XML XVIXML BY @@VAR@@
        ; XVRTN AND XVIXML ARE PASSED BY NAME
        ;
        N XVI,XVTMP,XVT
        F XVI=1:1:@XVIXML@(0) D  ; FOR ALL LINES OF THE XML
        . S XVT=@XVIXML@(XVI)
        . I XVT["@@" S XVTMP($P(XVT,"@@",2))=XVI
        D H2ARY(XVRTN,"XVTMP")
        Q
        ;
DXVARS(DXIN)    ;DISPLAY ALL VARIABLES IN A TEMPLATE
        ; IF PARAMETERS ARE NULL, DEFAULTS TO CCR TEMPLATE
        ;
        N DXUSE,DTMP ; DXUSE IS NAME OF VARIABLE, DTMP IS VARIABLE IF NOT SUPPLIED
        I DXIN="CCR" D  ; NEED TO GO GET CCR TEMPLATE
        . D LOAD^C0CCCR0("DTMP") ; LOAD CCR TEMPLATE INTO DXTMP
        . S DXUSE="DTMP" ; DXUSE IS NAME
        E  I DXIN="CCD" D  ; NEED TO GO GET CCD TEMPLATE
        . D LOAD^C0CCCD1("DTMP") ; LOAD CCR TEMPLATE INTO DXTMP
        . S DXUSE="DTMP" ; DXUSE IS NAME
        E  S DXUSE=DXIN ; IF PASSED THE TEMPLATE TO USE
        N DVARS ; PUT VARIABLE NAME RESULTS IN ARRAY HERE
        D XVARS("DVARS",DXUSE) ; PULL OUT VARS
        D PARY^C0CXPATH("DVARS") ;AND DISPLAY THEM
        Q
        ;
TEST        ; Run all the test cases
        D TESTALL^C0CUNIT("C0CXPAT0")
        Q
        ;
ZTEST(WHICH)       ; RUN ONE SET OF TESTS
        N ZTMP
        S DEBUG=1
        D ZLOAD^C0CUNIT("ZTMP","C0CXPAT0")
        D ZTEST^C0CUNIT(.ZTMP,WHICH)
        Q
        ;
TLIST     ; LIST THE TESTS
        N ZTMP
        D ZLOAD^C0CUNIT("ZTMP","C0CXPAT0")
        D TLIST^C0CUNIT(.ZTMP)
        Q
        ;
