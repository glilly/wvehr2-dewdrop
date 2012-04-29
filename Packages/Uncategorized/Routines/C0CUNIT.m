C0CUNIT ; CCDCCR/GPL - Unit Testing Library; 5/07/08
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;Copyright 2008 George Lilly. Licensed under the terms of the GNU
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
          W "This is a unit testing library",!
          W !
          Q
          ;
ZT(ZARY,BAT,TST) ; private routine to add a test case to the ZARY array
          ; ZARY IS PASSED BY REFERENCE
          ; BAT is a string identifying the test battery
          ; TST is a test which will evaluate to true or false
          ; I '$G(ZARY) D
          ; . S ZARY(0)=0 ; initially there are no elements
          ; W "GOT HERE LOADING "_TST,!
          N CNT ; count of array elements
          S CNT=ZARY(0) ; contains array count
          S CNT=CNT+1 ; increment count
          S ZARY(CNT)=TST ; put the test in the array
          I $D(ZARY(BAT))  D  ; NOT THE FIRST TEST IN BATTERY
          . N II,TN ; TEMP FOR ENDING TEST IN BATTERY
          . S II=$P(ZARY(BAT),"^",2)
          . S $P(ZARY(BAT),"^",2)=II+1
          I '$D(ZARY(BAT))  D  ; FIRST TEST IN THIS BATTERY
          . S ZARY(BAT)=CNT_"^"_CNT ; FIRST AND LAST TESTS IN BATTERY
          . S ZARY("TESTS",BAT)="" ; PUT THE BATTERY IN THE TESTS INDEX
          . ; S TN=$NA(ZARY("TESTS"))
          . ; D PUSH^C0CXPATH(TN,BAT)
          S ZARY(0)=CNT ; update the array counter
          Q
          ;
ZLOAD(ZARY,ROUTINE)  ; load tests into ZARY which is passed by reference
          ; ZARY IS PASSED BY NAME
          ; ZARY = name of the root, closed array format (e.g., "^TMP($J)")
          ; ROUTINE = NAME OF THE ROUTINE - PASSED BY VALUE
          K @ZARY
          S @ZARY@(0)=0 ; initialize array count
          N LINE,LABEL,BODY
          N INTEST S INTEST=0 ; switch for in the test case section
          N SECTION S SECTION="[anonymous]" ; test case section
          ;
          N NUM F NUM=1:1 S LINE=$T(+NUM^@ROUTINE) Q:LINE=""  D
          . I LINE?." "1";;><TEST>".E S INTEST=1 ; entering test section
          . I LINE?." "1";;><TEMPLATE>".E S INTEST=1 ; entering TEMPLATE section
          . I LINE?." "1";;></TEST>".E S INTEST=0 ; leaving test section
          . I LINE?." "1";;></TEMPLATE>".E S INTEST=0 ; leaving TEMPLATE section
          . I INTEST  D  ; within the testing section
          . . I LINE?." "1";;><".E  D  ; section name found
          . . . S SECTION=$P($P(LINE,";;><",2),">",1) ; pull out name
          . . I LINE?." "1";;>>".E  D  ; test case found
          . . . D ZT(.@ZARY,SECTION,$P(LINE,";;>>",2)) ; put the test in the array
          S @ZARY@("ALL")="1"_"^"_@ZARY@(0) ; MAKE A BATTERY FOR ALL
          Q
          ;
ZTEST(ZARY,WHICH)   ; try out the tests using a passed array ZTEST
          N ZI,ZX,ZR,ZP
          S DEBUG=0
          ; I WHICH="ALL" D  Q ; RUN ALL THE TESTS
          ; . W "DOING ALL",!
          ; . N J,NT
          ; . S NT=$NA(ZARY("TESTS"))
          ; . W NT,@NT@(0),!
          ; . F J=1:1:@NT@(0) D  ;
          ; . . W @NT@(J),!
          ; . . D ZTEST^C0CUNIT(@ZARY,@NT@(J))
          I '$D(ZARY(WHICH))  D  Q ; TEST SECTION DOESN'T EXIST
          . W "ERROR -- TEST SECTION DOESN'T EXIST -> ",WHICH,!
          N FIRST,LAST
          S FIRST=$P(ZARY(WHICH),"^",1)
          S LAST=$P(ZARY(WHICH),"^",2)
          F ZI=FIRST:1:LAST  D
          . I ZARY(ZI)?1">"1.E  D  ; NOT A TEST, JUST RUN THE STATEMENT
          . . S ZP=$E(ZARY(ZI),2,$L(ZARY(ZI)))
          . . ;  W ZP,!
          . . S ZX=ZP
          . . W "RUNNING: "_ZP
          . . X ZX
          . . W "..SUCCESS: ",WHICH,!
          . I ZARY(ZI)?1"?"1.E  D  ; THIS IS A TEST
          . . S ZP=$E(ZARY(ZI),2,$L(ZARY(ZI)))
          . . S ZX="S ZR="_ZP
          . . W "TRYING: "_ZP
          . . X ZX
          . . W $S(ZR=1:"..PASSED ",1:"..FAILED "),!
          . . I '$D(TPASSED) D  ; NOT INITIALIZED YET
          . . . S TPASSED=0 S TFAILED=0
          . . I ZR S TPASSED=TPASSED+1
          . . I 'ZR S TFAILED=TFAILED+1
          Q
          ;
TEST   ; RUN ALL THE TEST CASES
          N ZTMP
          D ZLOAD(.ZTMP)
          D ZTEST(.ZTMP,"ALL")
          W "PASSED: ",TPASSED,!
          W "FAILED: ",TFAILED,!
          W !
          W "THE TESTS!",!
          ; I DEBUG ZWR ZTMP
          Q
          ;
GTSTS(GTZARY,RTN) ; return an array of test names
          N I,J S I="" S I=$O(GTZARY("TESTS",I))
          F J=0:0  Q:I=""  D
          . D PUSH^C0CXPATH(RTN,I)
          . S I=$O(GTZARY("TESTS",I))
          Q
          ;
TESTALL(RNM) ; RUN ALL THE TESTS
          N ZI,J,TZTMP,TSTS,TOTP,TOTF
          S TOTP=0 S TOTF=0
          D ZLOAD^C0CUNIT("TZTMP",RNM)
          D GTSTS(.TZTMP,"TSTS")
          F ZI=1:1:TSTS(0) D  ;
          . S TPASSED=0 S TFAILED=0
          . D ZTEST^C0CUNIT(.TZTMP,TSTS(ZI))
          . S TOTP=TOTP+TPASSED
          . S TOTF=TOTF+TFAILED
          . S $P(TSTS(ZI),"^",2)=TPASSED
          . S $P(TSTS(ZI),"^",3)=TFAILED
          F ZI=1:1:TSTS(0) D  ;
          . W "TEST=> ",$P(TSTS(ZI),"^",1)
          . W " PASSED=>",$P(TSTS(ZI),"^",2)
          . W " FAILED=>",$P(TSTS(ZI),"^",3),!
          W "TOTAL=> PASSED:",TOTP," FAILED:",TOTF,!
          Q
          ;
TLIST(ZARY) ; LIST ALL THE TESTS
          ; THEY ARE MARKED AS ;;><TESTNAME> IN THE TEST CASES
          ; ZARY IS PASSED BY REFERENCE
          N I,J,K S I="" S I=$O(ZARY("TESTS",I))
          S K=1
          F J=0:0  Q:I=""  D
          . ; W "I IS NOW=",I,!
          . W I," "
          . S I=$O(ZARY("TESTS",I))
          . S K=K+1 I K=6  D
          . . W !
          . . S K=1
          Q
          ;
MEDS
 N DEBUG S DEBUG=0
 N DFN S DFN=5685
 K ^TMP($J)
 W "Loading CCR Template into T using LOAD^GPLCCR0($NA(^TMP($J,""CCR"")))",!!
 N T S T=$NA(^TMP($J,"CCR"))     D LOAD^GPLCCR0(T)
 N XPATH S XPATH="//ContinuityOfCareRecord/Body/Medications"
 W "XPATH is: "_XPATH,!
 W "Getting Med Template into INXML using",!
 W "QUERY^GPLXPATH(T,XPATH,""INXML"")",!!
 D QUERY^GPLXPATH(T,XPATH,"INXML")
 W "Executing EXTRACT^C0CMED(INXML,DFN,OUTXML)",!
 W "OUTXML will be ^TMP($J,""OUT"")",!
 N OUTXML S OUTXML=$NA(^TMP($J,"OUT"))
 D EXTRACT^C0CMED6("INXML",DFN,OUTXML)
 D FILEOUT^C0CRNF(OUTXML,"TESTMEDS.xml")
 Q
PAT
 D ANALYZE^ARJTXRD("C0CDPT",.OUT) ; Analyze a routine in the directory
 N X,Y
 ; Select Patient
 S DIC=2,DIC(0)="AEMQ" D ^DIC
 ;
 W "You have selected patient "_Y,!!
 N I S I=89 F  S I=$O(OUT(I)) Q:I="ALINE"  D
 . W "OUT("_I_",0)"_" is "_$P(OUT(I,0)," ")_" "
 . W "valued at "
 . W @("$$"_$P(OUT(I,0),"(DFN)")_"^"_"C0CDPT"_"("_$P(Y,"^")_")")
 . W !
 Q
