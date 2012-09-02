C0CCCR    ; CCDCCR/GPL - CCR MAIN PROCESSING; 6/6/08
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
        ;OHUM/RUT 3120109 commented
        ;;OHUM/RUT 3120102 To take inputs from user for date limits and notes
        ;D ^C0CVALID
        ;;OHUM/RUT
        ;OHUM/RUT
        D XPAT(DFN) ; EXPORT TO A FILE
        Q
        ;
XPAT(DFN,XPARMS,DIR,FN) ; EXPORT ONE PATIENT TO A FILE
        ; DIR IS THE DIRECTORY, DEFAULTS IF NULL TO ^TMP("C0CCCR","ODIR")
        ; FN IS FILE NAME, DEFAULTS IF NULL
        N CCRGLO,UDIR,UFN
        S C0CNRPC=1 ; FLAG FOR NOT AN RPC CALL - FOR DEBUGGING THE RPC
        I '$D(DIR) S UDIR=""
        E  S UDIR=DIR
        I '$D(FN) S UFN="" ; IF FILENAME IS NOT PASSED
        E  S UFN=FN
        I '$D(XPARMS) S XPARMS=""
        N C0CRTN  ; RETURN ARRAY
        D CCRRPC(.C0CRTN,DFN,XPARMS,"CCR")
        S OARY=$NA(^TMP("C0CCUR",$J,DFN,"CCR",1))
        S ONAM=UFN
        I UFN="" S ONAM="PAT_"_DFN_"_CCR_V1_0_0.xml"
        S ODIRGLB=$NA(^TMP("C0CCCR","ODIR"))
        S ^TMP("C0CCCR","FNAME",DFN)=ONAM ; FILE NAME FOR BATCH USE
        I $D(^TMP("GPLCCR","ODIR")) S @ODIRGLB=^TMP("GPLCCR","ODIR")
        I '$D(@ODIRGLB) D  ; IF NOT ODIR HAS BEEN SET
        . W "Warning.. please set ^TMP(""C0CCCR"",""ODIR"")=""output path""",! Q
        . ;S @ODIRGLB="/home/glilly/CCROUT"
        . ;S @ODIRGLB="/home/cedwards/"
        . S @ODIRGLB="/opt/wv/p/"
        S ODIR=UDIR
        I UDIR="" S ODIR=@ODIRGLB
        N ZY
        S ZY=$$OUTPUT^C0CXPATH(OARY,ONAM,ODIR)
        W !,$P(ZY,U,2),!
        Q
        ;
DCCR(DFN)       ; DISPLAY A CCR THAT HAS JUST BEEN EXTRACTED
        ;
        N G1
        S G1=$NA(^TMP("C0CCUR",$J,DFN,"CCR"))
        I $D(@G1@(0)) D  ; CCR EXISTS
        . D PARY^C0CXPATH(G1)
        E  W "CCR NOT CREATED, RUN D XPAT^C0CCCR(DFN,"""","""") FIRST",!
        Q
        ;
CCRRPC(CCRGRTN,DFN,CCRPARMS,CCRPART)     ;RPC ENTRY POINT FOR CCR OUTPUT
        ; CCRGRTN IS RETURN ARRAY PASSED BY REFERENCE
        ; DFN IS PATIENT IEN
        ; CCRPART IS "CCR" FOR ENTIRE CCR, OR SECTION NAME FOR A PART
        ;   OF THE CCR BODY.. PARTS INCLUDE "PROBLEMS" "VITALS" ETC
        ; CCRPARMS ARE PARAMETERS THAT AFFECT THE EXTRACTION
        ; IN THE FORM "PARM1:VALUE1^PARM2:VALUE2"
        ; EXAMPLE: "LABLIMIT:T-60" TO LIMIT LAB EXTRACTION TO THE LAST 60 DAYS
        ; SEE C0CPARMS FOR A COMPLETE LIST OF SUPPORTED PARAMETERS
        K ^TMP("C0CCCR",$J) ; CLEAN UP THE GLOBAL BEFORE WE USE IT
        M ^TMP("C0CSAV",$J)=^TMP($J) ; SAVING CALLER'S TMP SETTINGS
        K ^TMP($J) ; START CLEAN
        I '$D(DEBUG) S DEBUG=0
        S CCD=0 ; NEED THIS FLAG TO DISTINGUISH FROM CCD
        I '$D(CCRPARMS) S CCRPARMS=""
        I '$D(CCRPART) S CCRPART="CCR"
        I '$D(C0CNRPC) S ^TMP("C0CRPC",$H,"CALL",DFN)=""
        D SET^C0CPARMS(CCRPARMS) ;SET PARAMETERS WITH CCRPARMS AS OVERRIDES
        I '$D(TESTVIT) S TESTVIT=0 ; FLAG FOR TESTING VITALS
        I '$D(TESTLAB) S TESTLAB=0 ; FLAG FOR TESTING RESULTS SECTION
        I '$D(TESTALERT) S TESTALERT=1 ; FLAG FOR TESTING ALERTS SECTION
        I '$D(TESTMEDS) S TESTMEDS=0 ; FLAG FOR TESTING C0CMED SECTION
        S TGLOBAL=$NA(^TMP("C0CCCR",$J,"TEMPLATE")) ; GLOBAL FOR STORING TEMPLATE
        S CCRGLO=$NA(^TMP("C0CCUR",$J,DFN,"CCR")) ; GLOBAL FOR BUILDING THE CCR
        S ACTGLO=$NA(^TMP("C0CCCR",$J,DFN,"ACTORS")) ; GLOBAL FOR ALL ACTORS
        ; TO GET PART OF THE CCR RETURNED, PASS CCRPART="PROBLEMS" ETC
        ;M CCRGRTN=^TMP("C0CCCR",$J,DFN,CCRPART) ; RTN GLOBAL OF PART OR ALL
        D LOAD^C0CCCR0(TGLOBAL)  ; LOAD THE CCR TEMPLATE
        D CP^C0CXPATH(TGLOBAL,CCRGLO) ; COPY THE TEMPLATE TO CCR GLOBAL
        ;
        ; DELETE THE BODY, ACTORS AND SIGNATURES SECTIONS FROM GLOBAL
        ; THESE WILL BE POPULATED AFTER CALLS TO THE XPATH ROUTINES
        D REPLACE^C0CXPATH(CCRGLO,"","//ContinuityOfCareRecord/Body")
        D REPLACE^C0CXPATH(CCRGLO,"","//ContinuityOfCareRecord/Actors")
        D REPLACE^C0CXPATH(CCRGLO,"","//ContinuityOfCareRecord/Signatures")
        D REPLACE^C0CXPATH(CCRGLO,"","//ContinuityOfCareRecord/Comments")
        I DEBUG F I=1:1:@CCRGLO@(0) W @CCRGLO@(I),!
        ;
        D HDRMAP(CCRGLO,DFN) ; MAP HEADER VARIABLES
        ;
        K ^TMP("C0CCCR",$J,"CCRSTEP") ; KILL GLOBAL PRIOR TO ADDING TO IT
        S CCRXTAB=$NA(^TMP("C0CCCR",$J,"CCRSTEP")) ; GLOBAL TO STORE CCR STEPS
        D INITSTPS(CCRXTAB) ; INITIALIZED CCR PROCESSING STEPS
        N PROCI,XI,TAG,RTN,CALL,XPATH,IXML,OXML,INXML,CCRBLD
        F PROCI=1:1:@CCRXTAB@(0) D  ; PROCESS THE CCR BODY SECTIONS
        . S XI=@CCRXTAB@(PROCI) ; CALL COPONENTS TO PARSE
        . S RTN=$P(XI,";",2) ; NAME OF ROUTINE TO CALL
        . S TAG=$P(XI,";",1) ; LABEL INSIDE ROUTINE TO CALL
        . S XPATH=$P(XI,";",3) ; XPATH TO XML TO PASS TO ROUTINE
        . D QUERY^C0CXPATH(TGLOBAL,XPATH,"INXML") ; EXTRACT XML TO PASS
        . S IXML="INXML"
        . S OXML=$P(XI,";",4) ; ARRAY FOR SECTION VALUES
        . ; K @OXML ; KILL EXPECTED OUTPUT ARRAY
        . ; W OXML,!
        . S CALL="D "_TAG_"^"_RTN_"(IXML,DFN,OXML)" ; SETUP THE CALL
        . W "RUNNING ",CALL,!
        . X CALL
        . ; NOW INSERT THE RESULTS IN THE CCR BUFFER
        . I $G(@OXML@(0))>0 D  ; THERE IS A RESULT
        . . D INSERT^C0CXPATH(CCRGLO,OXML,"//ContinuityOfCareRecord/Body")
        . . I DEBUG F C0CI=1:1:@OXML@(0) W @OXML@(C0CI),!
        N ACTT,ATMP,ACTT2,ATMP2 ; TEMPORARY ARRAY SYMBOLS FOR ACTOR PROCESSING
        D ACTLST^C0CCCR(CCRGLO,ACTGLO) ; GEN THE ACTOR LIST
        D QUERY^C0CXPATH(TGLOBAL,"//ContinuityOfCareRecord/Actors","ACTT")
        D EXTRACT^C0CACTOR("ACTT",ACTGLO,"ACTT2")
        D INSINNER^C0CXPATH(CCRGLO,"ACTT2","//ContinuityOfCareRecord/Actors")
        K ACTT,ACTT2
        ;D QUERY^C0CXPATH(TGLOBAL,"//ContinuityOfCareRecord/Comments","CMTT")
        ;D EXTRACT^C0CCMT("CMTT",DFN,"CMTT2")
        ;D INSINNER^C0CXPATH(CCRGLO,"CMTT2","//ContinuityOfCareRecord/Comments")
        ; gpl - turned off Comments for Certification
        K CMTT,CMTT2
        N TRIMI,J,DONE S DONE=0
        F TRIMI=0:0 D  Q:DONE  ; DELETE UNTIL ALL EMPTY ELEMENTS ARE GONE
        . S J=$$TRIM^C0CXPATH(CCRGLO) ; DELETE EMPTY ELEMENTS
        . I DEBUG W "TRIMMED",J,!
        . I J=0 S DONE=1 ; DONE WHEN TRIM RETURNS FALSE
        ;S CCRGRTN=$NA(^TMP("C0CCCR",$J,DFN,CCRPART)) ; RTN GLOBAL OF PART OR ALL
        I CCRPART="CCR" M CCRGRTN=@CCRGLO ; ENTIRE CCR
        E  M CCRGRTN=^TMP("C0CCCR",$J,DFN,CCRPART) ; RTN GLOBAL OF PART
        I '$D(C0CNRPC) S ^TMP("C0CRPC",$H,"RESULT",CCRGRTN(0))=""
        K ^TMP("C0CCCR",$J) ; BEGIN TO CLEAN UP
        K ^TMP($J) ; REALLY CLEAN UP
        M ^TMP($J)=^TMP("C0CSAV",$J) ; RESTORE CALLER'S $J
        Q
        ;
INITSTPS(TAB)    ; INITIALIZE CCR PROCESSING STEPS
        ; TAB IS PASSED BY NAME
        I DEBUG W "TAB= ",TAB,!
        ; ORDER FOR CCR IS PROBLEMS,FAMILYHISTORY,SOCIALHISTORY,MEDICATIONS,VITALSIGNS,RESULTS,HEALTHCAREPROVIDERS
        D PUSH^C0CXPATH(TAB,"EXTRACT;C0CPROBS;//ContinuityOfCareRecord/Body/Problems;^TMP(""C0CCCR"",$J,DFN,""PROBLEMS"")")
        I TESTALERT D PUSH^C0CXPATH(TAB,"EXTRACT;C0CALERT;//ContinuityOfCareRecord/Body/Alerts;^TMP(""C0CCCR"",$J,DFN,""ALERTS"")")
        D PUSH^C0CXPATH(TAB,"EXTRACT;C0CMED;//ContinuityOfCareRecord/Body/Medications;^TMP(""C0CCCR"",$J,DFN,""MEDICATIONS"")")
        D PUSH^C0CXPATH(TAB,"MAP;C0CIMMU;//ContinuityOfCareRecord/Body/Immunizations;^TMP(""C0CCCR"",$J,DFN,""IMMUNE"")")
        I TESTVIT D PUSH^C0CXPATH(TAB,"EXTRACT;C0CVIT2;//ContinuityOfCareRecord/Body/VitalSigns;^TMP(""C0CCCR"",$J,DFN,""VITALS"")")
        E  D PUSH^C0CXPATH(TAB,"EXTRACT;C0CVITAL;//ContinuityOfCareRecord/Body/VitalSigns;^TMP(""C0CCCR"",$J,DFN,""VITALS"")")
        D PUSH^C0CXPATH(TAB,"MAP;C0CLABS;//ContinuityOfCareRecord/Body/Results;^TMP(""C0CCCR"",$J,DFN,""RESULTS"")")
        D PUSH^C0CXPATH(TAB,"EXTRACT;C0CPROC;//ContinuityOfCareRecord/Body/Procedures;^TMP(""C0CCCR"",$J,DFN,""PROCEDURES"")")
        ;D PUSH^C0CXPATH(TAB,"EXTRACT;C0CENC;//ContinuityOfCareRecord/Body/Encounters;^TMP(""C0CCCR"",$J,DFN,""ENCOUNTERS"")")
        ; gpl - turned off Encounters for Certification
        ;OHUM/RUT 3120109 Changed the condition
        ;;OHUM/RUT 3111228 Condition for Notes ; It should be included or not
        ;;I ^TMP("C0CCCR","TIULIMIT")'="" D PUSH^C0CXPATH(TAB,"EXTRACT;C0CENC;//ContinuityOfCareRecord/Body/Encounters;^TMP(""C0CCCR"",$J,DFN,""ENCOUNTERS"")")
        I $P(^C0CPARM(1,2),"^",3)=1 D PUSH^C0CXPATH(TAB,"EXTRACT;C0CENC;//ContinuityOfCareRecord/Body/Encounters;^TMP(""C0CCCR"",$J,DFN,""ENCOUNTERS"")")
        ;;OHUM/RUT
        ;OHUM/RUT
        Q
        ;
HDRMAP(CXML,DFN)        ; MAP HEADER VARIABLES: FROM, TO ECT
        N VMAP S VMAP=$NA(^TMP("C0CCCR",$J,DFN,"HEADER"))
        ; K @VMAP
        S @VMAP@("DATETIME")=$$FMDTOUTC^C0CUTIL($$NOW^XLFDT,"DT")
        ; I IHDR="" D  ; HEADER ARRAY IS NOT PROVIDED, USE DEFAULTS
        D  ; ALWAYS MAP THESE VARIABLES
        . S @VMAP@("CCRDOCOBJECTID")=$$UUID^C0CUTIL ; UUID FOR THIS CCR
        . S @VMAP@("ACTORPATIENT")="ACTORPATIENT_"_DFN
        . S @VMAP@("ACTORFROM")="ACTORPROVIDER_"_DUZ ; FROM DUZ - FROM PROVIDER
        . ;S @VMAP@("ACTORFROM")="ACTORORGANIZATION_"_DUZ ; FROM DUZ - ???
        . S @VMAP@("ACTORFROM2")="ACTORSYSTEM_1" ; SECOND FROM IS THE SYSTEM
        . S @VMAP@("ACTORTO")="ACTORPATIENT_"_DFN ; FOR TEST PURPOSES
        . S @VMAP@("PURPOSEDESCRIPTION")="CEND PHR"  ; FOR TEST PURPOSES
        . S @VMAP@("ACTORTOTEXT")="Patient"  ; FOR TEST PURPOSES
        . ; THIS IS THE USE CASE FOR THE PHR WHERE "TO" IS THE PATIENT
        ;I IHDR'="" D  ; HEADER VALUES ARE PROVIDED
        ;. D CP^C0CXPATH(IHDR,VMAP) ; COPY HEADER VARIABLES TO MAP ARRAY
        N CTMP
        D MAP^C0CXPATH(CXML,VMAP,"CTMP")
        D CP^C0CXPATH("CTMP",CXML)
        N HRIMVARS ;
        S HRIMVARS=$NA(^TMP("C0CRIM","VARS",DFN,"HEADER")) ; TO PERSIST VARS
        M @HRIMVARS@(1)=@VMAP ; PERSIST THE HEADER VARIABLES IN RIM TABLE
        S @HRIMVARS@(0)=1 ; ONLY ONE SET OF HEADERS PER PATIENT
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
        F I=1:1:@AXML@(0) D  ; FIRST FIX MISSING LINKS
        . I @AXML@(I)?.E1"_<".E D  ;
        . . N ZA,ZB
        . . S ZA=$P(@AXML@(I),">",1)_">"
        . . S ZB="<"_$P(@AXML@(I),"<",3)
        . . S @AXML@(I)=ZA_"ACTORORGANIZATION_1"_ZB
        F I=1:1:@AXML@(0) D  ; SCAN ALL LINES
        . I @AXML@(I)?.E1"<ActorID>".E D  ; THERE IS AN ACTOR THIS LINE
        . . S J=$P($P(@AXML@(I),"<ActorID>",2),"</ActorID>",1)
        . . I $G(LINKDEBUG) W "<ActorID>=>",J,!
        . . I J'="" S K(J)="" ; HASHING ACTOR
        . I @AXML@(I)?.E1"<LinkID>".E D  ; THERE IS AN ACTOR THIS LINE
        . . S J=$P($P(@AXML@(I),"<LinkID>",2),"</LinkID>",1)
        . . I $G(LINKDEBUG) W "<LinkID>=>",J,!
        . . I J'="" S K(J)="" ; HASHING ACTOR
        . . ;  TO GET RID OF DUPLICATES
        S I="" ; GOING TO $O THROUGH THE HASH
        F J=0:0 D  Q:$O(K(I))=""
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
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","PROBLEMS","")
        ;;>>?@C0C@(@C0C@(0))["</Problems>"
        ;;><VITALS>
        ;;>>>K C0C S C0C=""
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","VITALS","")
        ;;>>?@C0C@(@C0C@(0))["</VitalSigns>"
        ;;><CCR>
        ;;>>>K C0C S C0C=""
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","CCR","")
        ;;>>?@C0C@(@C0C@(0))["</ContinuityOfCareRecord>"
        ;;><ACTLST>
        ;;>>>K C0C S C0C=""
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","CCR","")
        ;;>>>D ACTLST^C0CCCR(C0C,"ACTTEST")
        ;;><ACTORS>
        ;;>>>D ZTEST^C0CCCR("ACTLST")
        ;;>>>D QUERY^C0CXPATH(TGLOBAL,"//ContinuityOfCareRecord/Actors","G2")
        ;;>>>D EXTRACT^C0CACTOR("G2","ACTTEST","G3")
        ;;>>?G3(G3(0))["</Actors>"
        ;;><TRIM>
        ;;>>>D ZTEST^C0CCCR("CCR")
        ;;>>>W $$TRIM^C0CXPATH(CCRGLO)
        ;;><ALERTS>
        ;;>>>S TESTALERT=1
        ;;>>>K C0C S C0C=""
        ;;>>>D CCRRPC^C0CCCR(.C0C,"2","ALERTS","")
        ;;>>?@C0C@(@C0C@(0))["</Alerts>"
        
        
