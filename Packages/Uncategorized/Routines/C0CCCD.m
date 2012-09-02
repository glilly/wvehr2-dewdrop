C0CCCD    ; CCDCCR/GPL - CCD MAIN PROCESSING; 6/6/08
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;Copyright 2008,2009 George Lilly, University of Minnesota.
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
        ; EXPORT A CCR
        ;
EXPORT    ; EXPORT ENTRY POINT FOR CCR
              ; Select a patient.
              S DIC=2,DIC(0)="AEMQ" D ^DIC
              I Y<1 Q  ; EXIT
              S DFN=$P(Y,U,1) ; SET THE PATIENT
              D XPAT(DFN,"","") ; EXPORT TO A FILE
              Q
              ;
XPAT(DFN,DIR,FN)        ; EXPORT ONE PATIENT TO A FILE
              ; DIR IS THE DIRECTORY, DEFAULTS IF NULL TO ^TMP("C0CCCR","ODIR")
              ; FN IS FILE NAME, DEFAULTS IF NULL
              ; N CCDGLO
              D CCDRPC(.CCDGLO,DFN,"CCD","","","")
              S OARY=$NA(^TMP("C0CCCR",$J,DFN,"CCD",1))
              S ONAM=FN
              I FN="" S ONAM="PAT_"_DFN_"_CCD_V1.xml"
              S ODIRGLB=$NA(^TMP("C0CCCR","ODIR"))
              I '$D(@ODIRGLB) D  ; IF NOT ODIR HAS BEEN SET
              . S @ODIRGLB="/home/glilly/CCROUT"
              . ;S @ODIRGLB="/home/cedwards/"
              . ;S @ODIRGLB="/opt/wv/p/"
              S ODIR=DIR
              I DIR="" S ODIR=@ODIRGLB
              N ZY
              S ZY=$$OUTPUT^C0CXPATH(OARY,ONAM,ODIR)
              W $P(ZY,U,2)
              Q
              ;
CCDRPC(CCRGRTN,DFN,CCRPART,TIME1,TIME2,HDRARY)   ;RPC ENTRY POINT FOR CCR OUTPUT
           ; CCRGRTN IS RETURN ARRAY PASSED BY NAME
           ; DFN IS PATIENT IEN
           ; CCRPART IS "CCR" FOR ENTIRE CCR, OR SECTION NAME FOR A PART
           ;   OF THE CCR BODY.. PARTS INCLUDE "PROBLEMS" "VITALS" ETC
           ; TIME1 IS STARTING TIME TO INCLUDE - NULL MEANS ALL
           ; TIME2 IS ENDING TIME TO INCLUDE TIME IS FILEMAN TIME
           ; - NULL MEANS NOW
           ; HDRARY IS THE HEADER ARRAY DEFINING THE "FROM" AND
           ;    "TO" VARIABLES
           ;    IF NULL WILL DEFAULT TO "FROM" ORGANIZATION AND "TO" DFN
           I '$D(DEBUG) S DEBUG=0
           N CCD S CCD=0 ; FLAG FOR PROCESSING A CCD
           I CCRPART="CCD" S CCD=1 ; WE ARE PROCESSING A CCD
           S TGLOBAL=$NA(^TMP("C0CCCR",$J,"TEMPLATE")) ; GLOBAL FOR STORING TEMPLATE
           I CCD S CCDGLO=$NA(^TMP("C0CCCR",$J,DFN,"CCD")) ; GLOBAL FOR THE CCD
           E  S CCDGLO=$NA(^TMP("C0CCCR",$J,DFN,"CCR")) ; GLOBAL FOR BUILDING THE CCR
           S ACTGLO=$NA(^TMP("C0CCCR",$J,DFN,"ACTORS")) ; GLOBAL FOR ALL ACTORS
           ; TO GET PART OF THE CCR RETURNED, PASS CCRPART="PROBLEMS" ETC
           S CCRGRTN=$NA(^TMP("C0CCCR",$J,DFN,CCRPART)) ; RTN GLO NM OF PART OR ALL
           I CCD D LOAD^C0CCCD1(TGLOBAL)  ; LOAD THE CCR TEMPLATE
           E  D LOAD^C0CCCR0(TGLOBAL)  ; LOAD THE CCR TEMPLATE
           D CP^C0CXPATH(TGLOBAL,CCDGLO) ; COPY THE TEMPLATE TO CCR GLOBAL
           N CAPSAVE,CAPSAVE2 ; FOR HOLDING THE CCD ROOT LINES
           S CAPSAVE=@TGLOBAL@(3) ; SAVE THE CCD ROOT
           S CAPSAVE2=@TGLOBAL@(@TGLOBAL@(0)) ; SAVE LAST LINE OF CCD
           S @CCDGLO@(3)="<ContinuityOfCareRecord>" ; CAP WITH CCR ROOT
           S @TGLOBAL@(3)=@CCDGLO@(3) ; CAP THE TEMPLATE TOO
           S @CCDGLO@(@CCDGLO@(0))="</ContinuityOfCareRecord>" ; FINISH CAP
           S @TGLOBAL@(@TGLOBAL@(0))="</ContinuityOfCareRecord>" ; FINISH CAP TEMP
           ;
           ; DELETE THE BODY, ACTORS AND SIGNATURES SECTIONS FROM GLOBAL
           ; THESE WILL BE POPULATED AFTER CALLS TO THE XPATH ROUTINES
           D REPLACE^C0CXPATH(CCDGLO,"","//ContinuityOfCareRecord/Body")
           D REPLACE^C0CXPATH(CCDGLO,"","//ContinuityOfCareRecord/Actors")
           I 'CCD D REPLACE^C0CXPATH(CCDGLO,"","//ContinuityOfCareRecord/Signatures")
           I DEBUG F I=1:1:@CCDGLO@(0) W @CCDGLO@(I),!
           ;
           I 'CCD D HDRMAP(CCDGLO,DFN,HDRARY) ; MAP HEADER VARIABLES
           ; MAPPING THE PATIENT PORTION OF THE CDA HEADER
           S ZZX="//ContinuityOfCareRecord/recordTarget/patientRole/patient"
           D QUERY^C0CXPATH(CCDGLO,ZZX,"ACTT1")
           D PATIENT^C0CACTOR("ACTT1",DFN,"ACTORPATIENT_"_DFN,"ACTT2") ; MAP PATIENT
           I DEBUG D PARY^C0CXPATH("ACTT2")
           D REPLACE^C0CXPATH(CCDGLO,"ACTT2",ZZX)
           I DEBUG D PARY^C0CXPATH(CCDGLO)
           K ACTT1 K ACCT2
           ; MAPPING THE PROVIDER ORGANIZATION,AUTHOR,INFORMANT,CUSTODIAN CDA HEADER
           ; FOR NOW, THEY ARE ALL THE SAME AND RESOLVE TO ORGANIZATION
           D ORG^C0CACTOR(CCDGLO,DFN,"ACTORPATIENTORGANIZATION","ACTT2") ; MAP ORG
           D CP^C0CXPATH("ACTT2",CCDGLO)
           ;
           K ^TMP("C0CCCR",$J,"CCRSTEP") ; KILL GLOBAL PRIOR TO ADDING TO IT
           S CCRXTAB=$NA(^TMP("C0CCCR",$J,"CCRSTEP")) ; GLOBAL TO STORE CCR STEPS
           D INITSTPS(CCRXTAB) ; INITIALIZED CCR PROCESSING STEPS
           N I,XI,TAG,RTN,CALL,XPATH,IXML,OXML,INXML,CCRBLD
           F I=1:1:@CCRXTAB@(0)  D  ; PROCESS THE CCR BODY SECTIONS
           . S XI=@CCRXTAB@(I) ; CALL COPONENTS TO PARSE
           . S RTN=$P(XI,";",2) ; NAME OF ROUTINE TO CALL
           . S TAG=$P(XI,";",1) ; LABEL INSIDE ROUTINE TO CALL
           . S XPATH=$P(XI,";",3) ; XPATH TO XML TO PASS TO ROUTINE
           . D QUERY^C0CXPATH(TGLOBAL,XPATH,"INXML") ; EXTRACT XML TO PASS
           . S IXML="INXML"
           . I CCD D SHAVE(IXML) ; REMOVE ALL BUT REPEATING PARTS OF TEMPLATE SECTION
           . S OXML=$P(XI,";",4) ; ARRAY FOR SECTION VALUES
           . ; W OXML,!
           . S CALL="D "_TAG_"^"_RTN_"(IXML,DFN,OXML)" ; SETUP THE CALL
           . W "RUNNING ",CALL,!
           . X CALL
           . I @OXML@(0)'=0 D  ; THERE IS A RESULT
           . . I CCD D QUERY^C0CXPATH(TGLOBAL,XPATH,"ITMP") ; XML TO UNSHAVE WITH
           . . I CCD D UNSHAVE("ITMP",OXML)
           . . I CCD D UNMARK^C0CXPATH(OXML) ; REMOVE THE CCR MARKUP FROM SECTION
           . ; NOW INSERT THE RESULTS IN THE CCR BUFFER
           . D INSERT^C0CXPATH(CCDGLO,OXML,"//ContinuityOfCareRecord/Body")
           . I DEBUG F C0CI=1:1:@OXML@(0) W @OXML@(C0CI),!
           ; NEED TO ADD BACK IN ACTOR PROCESSING AFTER WE FIGURE OUT LINKAGE
           ; D ACTLST^C0CCCR(CCDGLO,ACTGLO) ; GEN THE ACTOR LIST
           ; D QUERY^C0CXPATH(TGLOBAL,"//ContinuityOfCareRecord/Actors","ACTT")
           ; D EXTRACT^C0CACTOR("ACTT",ACTGLO,"ACTT2")
           ; D INSINNER^C0CXPATH(CCDGLO,"ACTT2","//ContinuityOfCareRecord/Actors")
           N I,J,DONE S DONE=0
           F I=0:0 D  Q:DONE  ; DELETE UNTIL ALL EMPTY ELEMENTS ARE GONE
           . S J=$$TRIM^C0CXPATH(CCDGLO) ; DELETE EMPTY ELEMENTS
           . W "TRIMMED",J,!
           . I J=0 S DONE=1 ; DONE WHEN TRIM RETURNS FALSE
           I CCD D  ; TURN THE BODY INTO A CCD COMPONENT
           . N I
           . F I=1:1:@CCDGLO@(0) D  ; SEARCH THROUGH THE ENTIRE ARRAY
           . . I @CCDGLO@(I)["<Body>" D  ; REPLACE BODY MARKUP
           . . . S @CCDGLO@(I)="<component><structuredBody>" ; WITH CCD EQ
           . . I @CCDGLO@(I)["</Body>" D  ; REPLACE BODY MARKUP
           . . . S @CCDGLO@(I)="</structuredBody></component>"
           S @CCDGLO@(3)=CAPSAVE ; UNCAP - TURN IT BACK INTO A CCD
           S @CCDGLO@(@CCDGLO@(0))=CAPSAVE2 ; UNCAP LAST LINE
           Q
           ;
INITSTPS(TAB)    ; INITIALIZE CCR PROCESSING STEPS
           ; TAB IS PASSED BY NAME
           W "TAB= ",TAB,!
           ; ORDER FOR CCR IS PROBLEMS,FAMILYHISTORY,SOCIALHISTORY,MEDICATIONS,VITALSIGNS,RESULTS,HEALTHCAREPROVIDERS
           D PUSH^C0CXPATH(TAB,"EXTRACT;C0CPROBS;//ContinuityOfCareRecord/Body/Problems;^TMP(""C0CCCR"",$J,DFN,""PROBLEMS"")")
           ;D PUSH^C0CXPATH(TAB,"EXTRACT;C0CMED;//ContinuityOfCareRecord/Body/Medications;^TMP(""C0CCCR"",$J,DFN,""MEDICATIONS"")")
           I 'CCD D PUSH^C0CXPATH(TAB,"EXTRACT;C0CVITAL;//ContinuityOfCareRecord/Body/VitalSigns;^TMP(""C0CCCR"",$J,DFN,""VITALS"")")
           Q
           ;
SHAVE(SHXML)    ; REMOVES THE 2-6 AND N-1 AND N-2 LINES FROM A COMPONENT
           ; NEEDED TO EXPOSE THE REPEATING PARTS FOR GENERATION
           N SHTMP,SHBLD ; TEMP ARRAY AND BUILD LIST
           W SHXML,!
           W @SHXML@(1),!
           D QUEUE^C0CXPATH("SHBLD",SHXML,1,1) ; THE FIRST LINE IS NEEDED
           D QUEUE^C0CXPATH("SHBLD",SHXML,7,@SHXML@(0)-3) ; REPEATING PART
           D QUEUE^C0CXPATH("SHBLD",SHXML,@SHXML@(0),@SHXML@(0)) ; LAST LINE
           D PARY^C0CXPATH("SHBLD") ; PRINT BUILD LIST
           D BUILD^C0CXPATH("SHBLD","SHTMP") ; BUILD EDITED SECTION
           D CP^C0CXPATH("SHTMP",SHXML) ; COPY RESULT TO PASSED ARRAY
           Q
           ;
UNSHAVE(ORIGXML,SHXML)  ; REPLACES THE 2-6 AND N-1 AND N-2 LINES FROM TEMPLATE
           ; NEEDED TO RESTORM FIXED TOP AND BOTTOM OF THE COMPONENT XML
           N SHTMP,SHBLD ; TEMP ARRAY AND BUILD LIST
           W SHXML,!
           W @SHXML@(1),!
           D QUEUE^C0CXPATH("SHBLD",ORIGXML,1,6) ; FIRST 6 LINES OF TEMPLATE
           D QUEUE^C0CXPATH("SHBLD",SHXML,2,@SHXML@(0)-1) ; INS ALL BUT FIRST/LAST
           D QUEUE^C0CXPATH("SHBLD",ORIGXML,@ORIGXML@(0)-2,@ORIGXML@(0)) ; FROM TEMP
           D PARY^C0CXPATH("SHBLD") ; PRINT BUILD LIST
           D BUILD^C0CXPATH("SHBLD","SHTMP") ; BUILD EDITED SECTION
           D CP^C0CXPATH("SHTMP",SHXML) ; COPY RESULT TO PASSED ARRAY
           Q
           ;
HDRMAP(CXML,DFN,IHDR)     ; MAP HEADER VARIABLES: FROM, TO ECT
           N VMAP S VMAP=$NA(^TMP("C0CCCR",$J,DFN,"HEADER"))
           ; K @VMAP
           S @VMAP@("DATETIME")=$$FMDTOUTC^C0CUTIL($$NOW^XLFDT,"DT")
           I IHDR="" D  ; HEADER ARRAY IS NOT PROVIDED, USE DEFAULTS
           . S @VMAP@("ACTORPATIENT")="ACTORPATIENT_"_DFN
           . S @VMAP@("ACTORFROM")="ACTORORGANIZATION_"_DUZ ; FROM DUZ - ???
           . S @VMAP@("ACTORFROM2")="ACTORSYSTEM_1" ; SECOND FROM IS THE SYSTEM
           . S @VMAP@("ACTORTO")="ACTORPATIENT_"_DFN  ; FOR TEST PURPOSES
           . S @VMAP@("PURPOSEDESCRIPTION")="CEND PHR"  ; FOR TEST PURPOSES
           . S @VMAP@("ACTORTOTEXT")="Patient"  ; FOR TEST PURPOSES
           . ; THIS IS THE USE CASE FOR THE PHR WHERE "TO" IS THE PATIENT
           I IHDR'="" D  ; HEADER VALUES ARE PROVIDED
           . D CP^C0CXPATH(IHDR,VMAP) ; COPY HEADER VARIABLES TO MAP ARRAY
           N CTMP
           D MAP^C0CXPATH(CXML,VMAP,"CTMP")
           D CP^C0CXPATH("CTMP",CXML)
           Q
           ;
ACTLST(AXML,ACTRTN)     ; RETURN THE ACTOR LIST FOR THE XML IN AXML
           ; AXML AND ACTRTN ARE PASSED BY NAME
           ; EACH ACTOR RECORD HAS 3 PARTS - IE IF OBJECTID=ACTORPATIENT_2
           ; P1= OBJECTID - ACTORPATIENT_2
           ; P2= OBJECT TYPE - PATIENT OR PROVIDER OR SOFTWARE
           ;OR INSTITUTION
           ;  OR PERSON(IN PATIENT FILE IE NOK)
           ; P3= IEN RECORD NUMBER FOR ACTOR - 2
           N I,J,K,L
           K @ACTRTN ; CLEAR RETURN ARRAY
           F I=1:1:@AXML@(0) D  ; SCAN ALL LINES
           . I @AXML@(I)?.E1"<ActorID>".E D  ; THERE IS AN ACTOR THIS LINE
           . . S J=$P($P(@AXML@(I),"<ActorID>",2),"</ActorID>",1)
           . . W "<ActorID>=>",J,!
           . . I J'="" S K(J)="" ; HASHING ACTOR
           . . ;  TO GET RID OF DUPLICATES
           S I="" ; GOING TO $O THROUGH THE HASH
           F J=0:0 D  Q:$O(K(I))=""  ;
           . S I=$O(K(I)) ; WALK THROUGH THE HASH OF ACTORS
           . S $P(L,U,1)=I ; FIRST PIECE IS THE OBJECT ID
           . S $P(L,U,2)=$P($P(I,"ACTOR",2),"_",1) ; ACTOR TYPE
           . S $P(L,U,3)=$P(I,"_",2) ; IEN RECORD NUMBER FOR ACTOR
           . D PUSH^C0CXPATH(ACTRTN,L) ; ADD THE ACTOR TO THE RETURN ARRAY
           Q
           ;
TEST    ; RUN ALL THE TEST CASES
         D TESTALL^C0CUNIT("C0CCCR")
         Q
         ;
ZTEST(WHICH)     ; RUN ONE SET OF TESTS
         N ZTMP
         D ZLOAD^C0CUNIT("ZTMP","C0CCCR")
         D ZTEST^C0CUNIT(.ZTMP,WHICH)
         Q
         ;
TLIST    ; LIST THE TESTS
         N ZTMP
         D ZLOAD^C0CUNIT("ZTMP","C0CCCR")
         D TLIST^C0CUNIT(.ZTMP)
         Q
         ;
        ;;><TEST>
        ;;><PROBLEMS>
        ;;>>>K C0C S C0C=""
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","PROBLEMS","","","")
        ;;>>?@C0C@(@C0C@(0))["</Problems>"
        ;;><VITALS>
        ;;>>>K C0C S C0C=""
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","VITALS","","","")
        ;;>>?@C0C@(@C0C@(0))["</VitalSigns>"
        ;;><CCR>
        ;;>>>K C0C S C0C=""
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","CCR","","","")
        ;;>>?@C0C@(@C0C@(0))["</ContinuityOfCareRecord>"
        ;;><ACTLST>
        ;;>>>K C0C S C0C=""
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","CCR","","","")
        ;;>>>D ACTLST^C0CCCR(C0C,"ACTTEST")
        ;;><ACTORS>
        ;;>>>D ZTEST^C0CCCR("ACTLST")
        ;;>>>D QUERY^C0CXPATH(TGLOBAL,"//ContinuityOfCareRecord/Actors","G2")
        ;;>>>D EXTRACT^C0CACTOR("G2","ACTTEST","G3")
        ;;>>?G3(G3(0))["</Actors>"
        ;;><TRIM>
        ;;>>>D ZTEST^C0CCCR("CCR")
        ;;>>>W $$TRIM^C0CXPATH(CCDGLO)
        ;;><CCD>
        ;;>>>K C0C S C0C=""
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","CCD","","","")
        ;;>>?@C0C@(@C0C@(0))["</ContinuityOfCareRecord>"
        ;;></TEST>
