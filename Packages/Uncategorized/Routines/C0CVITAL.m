C0CVITAL ; CCDCCR/CJE/GPL - CCR/CCD PROCESSING FOR VITALS ; 07/16/08
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;Copyright 2008,2009 George Lilly, University of Minnesota and others.
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
EXTRACT(VITXML,DFN,VITOUTXML) ; EXTRACT VITALS INTO PROVIDED XML TEMPLATE
 ;
 ; VITXML AND OUTXML ARE PASSED BY NAME SO GLOBALS CAN BE USED
 ; IVITXML CONTAINS ONLY THE VITALS SECTION OF THE OVERALL TEMPLATE
 ;
 N VITRSLT,J,K,VITPTMP,X,VITVMAP,TBUF,VORDR
 S C0CVLMT=$$GET^C0CPARMS("VITLIMIT") ; GET THE LIMIT PARM
 S C0CVSTRT=$$GET^C0CPARMS("VITSTART") ; GET START PARM
 D DT^DILF(,C0CVLMT,.C0CEDT) ;
 D DT^DILF(,C0CVSTRT,.C0CSDT) ; 
 ;D DT^DILF(,C0CVLMT,.C0CSDT) ; GPL TESTING
 ;D DT^DILF(,C0CVSTRT,.C0CEDT) ; 
 W "VITALS START: ",C0CVSTRT," LIMIT: ",C0CVLMT,!
 I $$RPMS^C0CUTIL() D VITRPMS QUIT
 I ($$VISTA^C0CUTIL())!($$WV^C0CUTIL())!($$OV^C0CUTIL()) D VITVISTA QUIT
 ;I $$SYSNAME^C0CSYS()="RPMS" D VITRPMS
 ;E  D VITVISTA
 Q
 ;
VITVISTA ; EXTRACT VITALS FROM VISTA INTO PROVIDED XML TEMPLATE
 D FASTVIT^ORQQVI(.VITRSLT,DFN,C0CEDT,C0CSDT) ; GPL THIS ONE WORKS FOR AT
 ; LEAST ONE SET OF VITALS - TO DO, CALL IT REPETIVELY TO GET EARLIER VITALS
 ;D VITALS^ORQQVI(.VITRSLT,DFN,C0CEDT,C0CSDT)
 ;D VITALS^ORQQVI(.VITRSLT,DFN,C0CSDT,C0CEDT)
 ;D VITALS^ORQQVI(.VITRSLT,DFN,C0CVSTRT,C0CVLMT) ; GPL LET GMR HANDLE THE DATES
 I '$D(VITRSLT(1)) S @VITOUTXML@(0)=0 Q  ; RETURN NOT FOUND AND QUIT
 I $P(VITRSLT(1),U,2)="No vitals found." D  Q  ; NULL RESULT FROM RPC
 . I DEBUG W "NO VITALS FOUND FROM VITALS RPC",!
 . S @VITOUTXML@(0)=0
 I $P(VITRSLT(1),U,2)="No vitals found." Q  ; QUIT
 ; ZWR RPCRSLT
 S VITTVMAP=$NA(^TMP("C0CCCR",$J,"VITALS"))
 S VITTARYTMP=$NA(^TMP("C0CCCR",$J,"VITALARYTMP"))
 K @VITTVMAP,@VITTARYTMP ; KILL OLD ARRAY VALUES
 N VSORT,VDATES,VCNT ; ARRAY FOR DATE SORTED VITALS INDEX
 D VITDVISTA(.VDATES) ; PULL OUT THE DATES INTO AN ARRAY
 I DEBUG ZWR VDATES ;DEBUG
 S VCNT=$$SORTDT^C0CUTIL(.VSORT,.VDATES,-1) ; PUT VITALS IN REVERSE
 ; DATE ORDER AND COUNT THEM. VSORT CONTAINS INDIRECT INDEXES ONLY
 S @VITTVMAP@(0)=VCNT ; SAVE NUMBER OF VITALS
 F J=1:1:VCNT  D  ; FOR EACH VITAL IN THE LIST
 . I $D(VITRSLT(VSORT(J))) D
 . . S VITVMAP=$NA(@VITTVMAP@(J))
 . . K @VITVMAP
 . . I DEBUG W "VMAP= ",VITVMAP,!
 . . S VITPTMP=VITRSLT(VSORT(J)) ; DATE SORTED VITAL FROM RETURN ARRAY
 . . I DEBUG W "VITAL ",VSORT(J),!
 . . I DEBUG W VITRSLT(VSORT(J))," ",$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT"),!
 . . I DEBUG W $P(VITPTMP,U,4),!
 . . S @VITVMAP@("VITALSIGNSDATAOBJECTID")="VITAL"_J ; UNIQUE OBJID
        . . ;B  ;gpl
        . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^GMR(120.5,$P(VITPTMP,U,1),0)),U,6)
        . . I @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_" D  ;
        . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORSYSTEM_1"
 . . I $P(VITPTMP,U,2)="HT" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="HEIGHT"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="HEIGHT"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="248327008"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . ;S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P(^GMR(120.5,$P(VITPTMP,U,1),0),U,6)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P(VITPTMP,U,3)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")="in"
 . . E  I $P(VITPTMP,U,2)="WT" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="WEIGHT"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="WEIGHT"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="107647005"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . ;S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P(^GMR(120.5,$P(VITPTMP,U,1),0),U,6)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P(VITPTMP,U,3)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")="lbs"
 . . E  I $P(VITPTMP,U,2)="BP" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . ;S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="BLOOD PRESSURE"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="BLOOD PRESSURE"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="392570002"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . ;S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P(^GMR(120.5,$P(VITPTMP,U,1),0),U,6)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P(VITPTMP,U,3)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=""
 . . E  I $P(VITPTMP,U,2)="T" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="TEMPERATURE"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="TEMPERATURE"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="309646008"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . ;S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P(^GMR(120.5,$P(VITPTMP,U,1),0),U,6)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P(VITPTMP,U,3)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")="F"
 . . E  I $P(VITPTMP,U,2)="R" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="RESPIRATION"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="RESPIRATION"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="366147009"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . ;S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P(^GMR(120.5,$P(VITPTMP,U,1),0),U,6)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P(VITPTMP,U,3)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=""
 . . E  I $P(VITPTMP,U,2)="P" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="PULSE"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="PULSE"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="366199006"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . ;S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P(^GMR(120.5,$P(VITPTMP,U,1),0),U,6)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P(VITPTMP,U,3)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=""
 . . E  I $P(VITPTMP,U,2)="PN" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="PAIN"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="PAIN"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="22253000"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . ;S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P(^GMR(120.5,$P(VITPTMP,U,1),0),U,6)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P(VITPTMP,U,3)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=""
 . . E  I $P(VITPTMP,U,2)="BMI" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="BMI"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="BMI"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="60621009"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . ;S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P(^GMR(120.5,$P(VITPTMP,U,1),0),U,6)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P(VITPTMP,U,3)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=""
 . . E  D
 . . . ;W "IN VITAL:  OTHER",!
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="OTHER VITAL"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="UNKNOWN"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="OTHER"
 . . . ;S @VITVMAP@("VITALSIGNSDESCCODEVALUE")=""
 . . . ;S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")=""
 . . . ;S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . ;S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^GMR(120.5,$P(VITPTMP,U,1),0)),U,6)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P(VITPTMP,U,3)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")="UNKNOWN"
        . . I @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_" D  ;
        . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORSYSTEM_1" ;
 . . S VITARYTMP=$NA(@VITTARYTMP@(J))
 . . K @VITARYTMP
 . . D MAP^C0CXPATH(VITXML,VITVMAP,VITARYTMP)
 . . I J=1 D  ; FIRST ONE IS JUST A COPY
 . . . ; W "FIRST ONE",!
 . . . D CP^C0CXPATH(VITARYTMP,VITOUTXML)
 . . . I DEBUG W "VITOUTXML ",VITOUTXML,!
 . . I J>1 D  ; AFTER THE FIRST, INSERT INNER XML
 . . . D INSINNER^C0CXPATH(VITOUTXML,VITARYTMP)
 ; ZWR ^TMP($J,"VITALS",*)
 ; ZWR ^TMP($J,"VITALARYTMP",*) ; SHOW THE RESULTS
 I DEBUG D PARY^C0CXPATH(VITOUTXML)
 N VITTMP,I
 D MISSING^C0CXPATH(VITOUTXML,"VITTMP") ; SEARCH XML FOR MISSING VARS
 I VITTMP(0)>0 D  ; IF THERE ARE MISSING VARS - MARKED AS @@X@@
 . W "VITALS MISSING ",!
 . F I=1:1:VITTMP(0) W VITTMP(I),!
 Q
 ;
VITRPMS ; EXTRACT VITALS FROM RPMS INTO PROVIDED XML TEMPLATE
 ; RPMS VITAL RPC ONLY RETURNS LATEST VITAL IN SPECIFIED DATE RANGE NOT ALL VITALS IN DATE RANGE
 ; WE NEED TO SETUP THE VARIABLES THE INTERNAL CALL NEEDS TO BYPASS A HARD CODE OF ONE VITAL FOR DATE RANGE
 N END,START,DATA
 D DT^DILF("",C0CVLMT,.END)
 D DT^DILF("",C0CVSTRT,.START)
 ; RPC OUTPUT FORMAT:
 ; vfile ien^vital name^vital abbr^date/time taken(FM FORMAT)^value+units (US & metric)
 D QUERY^BEHOVM("LISTX") ; RUN QUERY VITALS CALL
 I '$D(^TMP("CIAVMRPC",$J)) S @VITOUTXML@(0)=0 Q  ; RETURN NOT FOUND AND QUIT
 ;ZW ^TMP("CIAVMRPC",$J)
 S VITTVMAP=$NA(^TMP("C0CCCR",$J,"VITALS"))
 S VITTARYTMP=$NA(^TMP("C0CCCR",$J,"VITALARYTMP"))
 K @VITTVMAP,@VITTARYTMP ; KILL OLD ARRAY VALUES
 N VSORT,VDATES,VCNT ; ARRAY FOR DATE SORTED VITALS INDEX
 D VITDRPMS(.VDATES) ; PULL OUT THE DATES INTO AN ARRAY
 S VCNT=$$SORTDT^C0CUTIL(.VSORT,.VDATES,-1) ; PUT VITALS IN REVERSE
 ; DATE ORDER AND COUNT THEM. VSORT CONTAINS INDIRECT INDEXES ONLY
 S @VITTVMAP@(0)=VCNT ; SAVE NUMBER OF VITALS
 F J=1:1:VCNT  D  ; FOR EACH VITAL IN THE LIST
 . I $D(^TMP("CIAVMRPC",$J,0,(VSORT(J)))) D
 . . S VITVMAP=$NA(@VITTVMAP@(J))
 . . K @VITVMAP
 . . I DEBUG W "VMAP= ",VITVMAP,!
 . . S VITPTMP=^TMP("CIAVMRPC",$J,0,(VSORT(J))) ; DATE SORTED VITAL FROM RETURN ARRAY
 . . I DEBUG W "VITAL ",VSORT(J),!
 . . I DEBUG W ^TMP("CIAVMRPC",$J,0,(VSORT(J)))," ",$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT"),!
 . . I DEBUG W $P(VITPTMP,U,4),!
 . . S @VITVMAP@("VITALSIGNSDATAOBJECTID")="VITAL"_J ; UNIQUE OBJID
 . . I $P(VITPTMP,U,3)="HT" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="HEIGHT"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="HEIGHT"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="248327008"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^AUPNVMSR($P(VITPTMP,U,1),12)),U,4)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P($P(VITPTMP,U,5)," ",1)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=$P($P(VITPTMP,U,5)," ",2)
 . . E  I $P(VITPTMP,U,3)="WT" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="WEIGHT"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="WEIGHT"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="107647005"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^AUPNVMSR($P(VITPTMP,U,1),12)),U,4)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P($P(VITPTMP,U,5)," ",1)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=$P($P(VITPTMP,U,5)," ",2)
 . . E  I $P(VITPTMP,U,3)="BP" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="BLOOD PRESSURE"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="BLOOD PRESSURE"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="392570002"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^AUPNVMSR($P(VITPTMP,U,1),12)),U,4)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P($P(VITPTMP,U,5)," ",1)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=$P($P(VITPTMP,U,5)," ",2)
 . . E  I $P(VITPTMP,U,3)="TMP" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="TEMPERATURE"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="TEMPERATURE"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="309646008"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^AUPNVMSR($P(VITPTMP,U,1),12)),U,4)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P($P(VITPTMP,U,5)," ",1)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=$P($P(VITPTMP,U,5)," ",2)
 . . E  I $P(VITPTMP,U,3)="RS" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="RESPIRATION"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="RESPIRATION"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="366147009"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^AUPNVMSR($P(VITPTMP,U,1),12)),U,4)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P($P(VITPTMP,U,5)," ",1)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=$P($P(VITPTMP,U,5)," ",2)
 . . E  I $P(VITPTMP,U,3)="PU" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="PULSE"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="PULSE"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="366199006"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^AUPNVMSR($P(VITPTMP,U,1),12)),U,4)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P($P(VITPTMP,U,5)," ",1)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=$P($P(VITPTMP,U,5)," ",2)
 . . E  I $P(VITPTMP,U,3)="PA" D
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="PAIN"
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")="PAIN"
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")="22253000"
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")="SNOMED"
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^AUPNVMSR($P(VITPTMP,U,1),12)),U,4)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P($P(VITPTMP,U,5)," ",1)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=$P($P(VITPTMP,U,5)," ",2)
 . . E  D
 . . . ;W "IN VITAL:  OTHER",!
 . . . S @VITVMAP@("VITALSIGNSDATETIMETYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSEXACTDATETIME")=$$FMDTOUTC^C0CUTIL($P(VITPTMP,U,4),"DT")
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")=$P(VITPTMP,U,2)
 . . . S @VITVMAP@("VITALSIGNSSOURCEACTORID")="ACTORSYSTEM_1"
 . . . S @VITVMAP@("VITALSIGNSTESTOBJECTID")="VITALTEST"_J
 . . . S @VITVMAP@("VITALSIGNSTESTTYPETEXT")="OBSERVED"
 . . . S @VITVMAP@("VITALSIGNSDESCRIPTIONTEXT")=$P(VITPTMP,U,2)
 . . . S @VITVMAP@("VITALSIGNSDESCCODEVALUE")=""
 . . . S @VITVMAP@("VITALSIGNSDESCCODINGSYSTEM")=""
 . . . S @VITVMAP@("VITALSIGNSCODEVERSION")=""
 . . . S @VITVMAP@("VITALSIGNSTESTSOURCEACTORID")="ACTORPROVIDER_"_$P($G(^AUPNVMSR($P(VITPTMP,U,1),12)),U,4)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTVALUE")=$P($P(VITPTMP,U,5)," ",1)
 . . . S @VITVMAP@("VITALSIGNSTESTRESULTUNIT")=$P($P(VITPTMP,U,5)," ",2)
 . . S VITARYTMP=$NA(@VITTARYTMP@(J))
 . . K @VITARYTMP
 . . D MAP^C0CXPATH(VITXML,VITVMAP,VITARYTMP)
 . . I J=1 D  ; FIRST ONE IS JUST A COPY
 . . . ; W "FIRST ONE",!
 . . . D CP^C0CXPATH(VITARYTMP,VITOUTXML)
 . . . I DEBUG W "VITOUTXML ",VITOUTXML,!
 . . I J>1 D  ; AFTER THE FIRST, INSERT INNER XML
 . . . D INSINNER^C0CXPATH(VITOUTXML,VITARYTMP)
 ; ZWR ^TMP($J,"VITALS",*)
 ; ZWR ^TMP($J,"VITALARYTMP",*) ; SHOW THE RESULTS
 I DEBUG D PARY^C0CXPATH(VITOUTXML)
 N VITTMP,I
 D MISSING^C0CXPATH(VITOUTXML,"VITTMP") ; SEARCH XML FOR MISSING VARS
 I VITTMP(0)>0 D  ; IF THERE ARE MISSING VARS - MARKED AS @@X@@
 . W "VITALS MISSING ",!
 . F I=1:1:VITTMP(0) W VITTMP(I),!
 K ^TMP("CIAVMRPC",$J)
 Q
 ;
VITDRPMS(VDT) ; RUN DATE SORTING ALGORITHM FOR RPMS
 ; VDT IS PASSED BY REFERENCE AND WILL CONTAIN THE ARRAY
 ; OF DATES IN THE VITALS RESULTS
 N VDTI,VDTJ,VTDCNT
 S VTDCNT=0 ; COUNT TO BUILD ARRAY
 S VDTJ="" ; USED TO VISIT THE RESULTS
 F VDTI=0:0 D  Q:$O(^TMP("CIAVMRPC",$J,0,VDTJ))=""  ; VISIT ALL RESULTS
 . S VDTJ=$O(^TMP("CIAVMRPC",$J,0,VDTJ)) ; NEXT RESULT
 . S VTDCNT=VTDCNT+1 ; INCREMENT COUNTER
 . S VDT(VTDCNT)=$P(^TMP("CIAVMRPC",$J,0,VDTJ),U,4) ; PULL OUT THE DATE
 S VDT(0)=VTDCNT
 Q
 ;
VITDVISTA(VDT) ; RUN DATE SORTING ALGORITHM FOR VISTA
 ; VDT IS PASSED BY REFERENCE AND WILL CONTAIN THE ARRAY
 ; OF DATES IN THE VITALS RESULTS
 N VDTI,VDTJ,VTDCNT
 S VTDCNT=0 ; COUNT TO BUILD ARRAY
 S VDTJ="" ; USED TO VISIT THE RESULTS
 F VDTI=0:0 D  Q:$O(VITRSLT(VDTJ))=""  ; VISIT ALL RESULTS
 . S VDTJ=$O(VITRSLT(VDTJ)) ; NEXT RESULT
 . S VTDCNT=VTDCNT+1 ; INCREMENT COUNTER
 . S VDT(VTDCNT)=$P(VITRSLT(VDTJ),U,4) ; PULL OUT THE DATE
 S VDT(0)=VTDCNT
 Q
 ;
