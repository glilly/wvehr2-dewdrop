C0CORSLT        ; CCDCCR/GPL - CCR/CCD PROCESSING ADDITIONAL RESULTS ; 06/27/11
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;Copyright 2011 George Lilly.
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
        W "NO ENTRY FROM TOP",!
        Q
        ;
EN(ZVARS,DFN)   ; LOOKS FOR CCR RESULTS THAT ARE NOT LAB RESULTS AND ADDS
        ; THEM TO THE LAB VARIABLES ZVARS IS PASSED BY REFERENCE
        ; AN EXAMPLE IS EKG RESULTS THAT ARE FOUND IN NOTES AND CONSULTS
        ; THIS IS CREATED FOR MU CERTIFICATION BY GPL
        D ENTRY^C0CCPT(DFN,,,1) ; RETURNS ALL RESULTS IN VISIT LOCAL VARIABLE
        N ZN ; RESULT NUMBER
        S ZN=$O(@ZVARS@(""),-1) ; NEXT RESULT
        N ZI S ZI=""
        F  S ZI=$O(VISIT(ZI)) Q:ZI=""  D  ; FOR EACH VISIT
        . I $G(VISIT(ZI,"TEXT",1))["ECG DONE" D  ; GOT AN ECG
        . . S ZN=ZN+1 ; INCREMENT RESULT COUNT
        . . N ZDATE,ZPRV,ZTXT
        . . S ZDATE=$G(VISIT(ZI,"DATE",0)) ; DATE OF PROCEDURE
        . . S ZPRV=$P($G(VISIT(ZI,"PRV",2)),"^",1) ;PROVIDER
        . . S ZTXT=$P($G(VISIT(ZI,"TEXT",4)),"ECG RESULTS: ",2)
        . . S @ZVARS@(ZN,"RESULTASSESSMENTDATETIME")=$$FMDTOUTC^C0CUTIL(ZDATE,"DT")
        . . S @ZVARS@(ZN,"RESULTCODE")="34534-8"
        . . S @ZVARS@(ZN,"RESULTCODINGSYSTEM")="LOINC"
        . . S @ZVARS@(ZN,"RESULTDESCRIPTIONTEXT")="Electrocardiogram LOINC:34534-8"
        . . S @ZVARS@(ZN,"RESULTOBJECTID")="RESULT"_ZN
        . . S @ZVARS@(ZN,"RESULTSOURCEACTORID")="ACTORPROVIDER_"_ZPRV
        . . S @ZVARS@(ZN,"RESULTSTATUS")=""
        . . S @ZVARS@(ZN,"M","TEST",0)=1
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTCODEVALUE")="34534-8"
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTCODINGSYSTEM")="LOINC"
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTDATETIME")=$$FMDTOUTC^C0CUTIL(ZDATE,"DT")
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTDESCRIPTIONTEXT")="Electrocardiogram LOINC:34534-8"
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTFLAG")=""
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTNORMALDESCTEXT")=""
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTNORMALSOURCEACTORID")="ACTORORGANIZATION_VASTANUM"
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTOBJECTID")="RESULTTEST_ECG_"_ZN
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTSOURCEACTORID")="ACTORPROVIDER"_ZPRV
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTSTATUSTEXT")="F"
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTUNITS")=""
        . . S @ZVARS@(ZN,"M","TEST",1,"RESULTTESTVALUE")=ZTXT
        . . S @ZVARS@(0)=ZN ; UPDATE RESULTS COUNT
        Q
        ;
OLD     ; OLD CODE FOR OTHER WAYS OF DOING THE ECG
        ; FOR CERTIFICATION - SAVE EKG RESULTS gpl
        W !,"CPT=",ZCPT
        I ZCPT["93000" D  ; THIS IS AN EKG
        . D RNF1TO2^C0CRNF(C0CPRSLT,"ZRNF") ; SAVE FOR LABS
        . M ^GPL("RNF2")=@C0CPRSLT
        Q
        ;
