C0CMED6 ; WV/CCDCCR/SMH - Meds from RPMS: Outpatient Meds;01/10/09
 ;;1.0;C0C;;May 19, 2009;Build 2
 ; Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
 ; General Public License See attached copy of the License.
 ;
 ; This program is free software; you can redistribute it and/or modify
 ; it under the terms of the GNU General Public License as published by
 ; the Free Software Foundation; either version 2 of the License, or
 ; (at your option) any later version.
 ;
 ; This program is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ; GNU General Public License for more details.
 ;
 ; You should have received a copy of the GNU General Public License along
 ; with this program; if not, write to the Free Software Foundation, Inc.,
 ; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ;
 W "NO ENTRY FROM TOP",!
 Q
 ;
EXTRACT(MINXML,DFN,OUTXML,MEDCOUNT,FLAGS)  ; EXTRACT MEDICATIONS INTO PROVIDED XML TEMPLATE
 ;
 ; MINXML and OUTXML are passed by name so globals can be used
 ; MINXML will contain only the medications skeleton of the overall template
 ; MEDCOUNT is a counter passed by Reference.
 ; FLAGS are: MEDALL(bool)^MEDLIMIT(int)^MEDACTIVE(bool)^MEDPENDING(bool)
 ; FLAGS are set-up in C0CMED.
 ;
 ; MEDS is return array from RPC.
 ; MAP is a mapping variable map (store result) for each med
 ; MED is holds each array element from MEDS(J), one medicine
 ; J is a counter.
 ;
 ; GETRXS^BEHORXFN(ARRAYNAME,DFN,DAYS) will be the the API used.
 ; This API has been developed by Medsphere for IHS for getting
 ; Medications from RPMS. It has most of what we need.
 ; API written by Doug Martin when he worked for Medsphere (thanks Doug!)
 ; -- ARRAYNAME is passed by name (required)
 ; -- DFN is passed by value (required)
 ; -- DAYS is passed by value (optional; if not passed defaults to 365)
 ;
 ; Return:
 ; ~Type^PharmID^Drug^InfRate^StopDt^RefRem^TotDose^UnitDose^OrderID
 ; ^Status^LastFill^Chronic^Issued^Rx #^Provider^
 ; Status Reason^DEA Handling
 ;
 N MEDS,MEDS1,MAP
 D GETRXS^BEHORXFN("MEDS1",DFN,$P($P(FLAGS,U,2),"-",2)) ; 2nd piece of FLAGS is # of days to retrieve, which comes in the form "T-360"
 N ALL S ALL=+FLAGS
 N ACTIVE S ACTIVE=$P(FLAGS,U,3)
 N PENDING S PENDING=$P(FLAGS,U,4)
 S @OUTXML@(0)=0  ;By default, no meds
 ; If MEDS1 is not defined, then no meds
 I '$D(MEDS1) QUIT
 I DEBUG ZWR MEDS1,MINXML
 N MEDCNT S MEDCNT=0 ; Med Count
 ; The next line is a super line. It goes through the array return
 ; and if the first characters are ~OP, it grabs the line.
 ; This means that line is for a dispensed Outpatient Med.
 ; That line has the metadata about the med that I need.
 ; The next lines, however many, are the med and the sig.
 ; I won't be using those because I have to get the sig parsed exactly.
 N J S J="" F  S J=$O(MEDS1(J)) Q:J=""  I $E(MEDS1(J),1,3)="~OP" S MEDCNT=MEDCNT+1 S MEDS(MEDCNT)=MEDS1(J)
 K MEDS1
 S MEDCNT="" ; Initialize for $Order
 F  S MEDCNT=$O(MEDS(MEDCNT)) Q:MEDCNT=""  D  ; for each medication in the list
 . I 'ALL,ACTIVE,$P(MEDS(MEDCNT),U,10)'="ACTIVE" QUIT
 . I 'ALL,PENDING,$P(MEDS(MEDCNT),U,10)'="PENDING" QUIT
 . I DEBUG W "MEDCNT IS ",MEDCNT,!
 . S MAP=$NA(^TMP("C0CCCR",$J,"MEDMAP",MEDCNT))
 . ; K @MAP DO NOT KILL HERE, WAS CLEARED IN C0CMED
 . I DEBUG W "MAP= ",MAP,!
 . S @MAP@("MEDOBJECTID")="MED"_MEDCNT ; MEDCNT FOR ID
 . S @MAP@("MEDISSUEDATETXT")="Issue Date"
 . S @MAP@("MEDISSUEDATE")=$$FMDTOUTC^C0CUTIL($P(MEDS(MEDCNT),U,15),"DT")
 . S @MAP@("MEDLASTFILLDATETXT")="Last Fill Date"
 . S @MAP@("MEDLASTFILLDATE")=$$FMDTOUTC^C0CUTIL($P(MEDS(MEDCNT),U,11),"DT")
 . S @MAP@("MEDRXNOTXT")="Prescription Number"
 . S @MAP@("MEDRXNO")=$P(MEDS(MEDCNT),U,14)
 . S @MAP@("MEDTYPETEXT")="Medication"
 . S @MAP@("MEDDETAILUNADORNED")=""  ; Leave blank, field has its uses
 . S @MAP@("MEDSTATUSTEXT")=$P(MEDS(MEDCNT),U,10)
 . ; Provider only provided in API as text, not DUZ.
 . ; We need to get DUZ from filman file 52 (Prescription)
 . ; Field 4; IEN is Piece 2 of Meds stripped of trailing characters.
 . ; Note that I will use RXIEN several times later
 . N RXIEN S RXIEN=+$P(MEDS(MEDCNT),U,2)
 . S @MAP@("MEDSOURCEACTORID")="ACTORPROVIDER_"_$$GET1^DIQ(52,RXIEN,4,"I")
 . S @MAP@("MEDPRODUCTNAMETEXT")=$P(MEDS(MEDCNT),U,3)
 . ; --- RxNorm Stuff
 . ; 176.001 is the file for Concepts; 176.003 is the file for
 . ; sources (i.e. for RxNorm Version)
 . ;
 . ; I use 176.001 for the Vista version of this routine (files 1-3)
 . ; Since IHS does not have VUID's, I will be getting RxNorm codes
 . ; using NDCs. My specially crafted index (sounds evil) named "NDC"
 . ; is in file 176.002. The file is called RxNorm NDC to VUID.
 . ; Except that I don't need the VUID, but it's there if I need it.
 . ;
 . ; We obviously need the NDC. That is easily obtained from the prescription.
 . ; Field 27 in file 52
 . N NDC S NDC=$$GET1^DIQ(52,RXIEN,27,"I")
 . ; I discovered that file 176.002 might give you two codes for the NDC
 . ; One for the Clinical Drug, and one for the ingredient.
 . ; So the plan is to get the two RxNorm codes, and then find from
 . ; file 176.001 which one is the Clinical Drug.
 . ; ... I refactored this into GETRXN
 . N RXNORM,SRCIEN,RXNNAME,RXNVER
 . I +NDC,$D(^C0CRXN) D  ; $Data is for Systems that don't have our RxNorm file yet.
 . . S RXNORM=$$GETRXN(NDC)
 . . S SRCIEN=$$FIND1^DIC(176.003,,,"RXNORM","B")
 . . S RXNNAME=$$GET1^DIQ(176.003,SRCIEN,6)
 . . S RXNVER=$$GET1^DIQ(176.003,SRCIEN,7)
 . ;
 . E  S (RXNORM,RXNNAME,RXNVER)=""
 . ; End if/else block
 . S @MAP@("MEDPRODUCTNAMECODEVALUE")=RXNORM
 . S @MAP@("MEDPRODUCTNAMECODINGINGSYSTEM")=RXNNAME
 . S @MAP@("MEDPRODUCTNAMECODEVERSION")=RXNVER
 . ; --- End RxNorm section
 . ;
 . ; Brand name is 52 field 6.5
 . S @MAP@("MEDBRANDNAMETEXT")=$$GET1^DIQ(52,RXIEN,6.5)
 . ;
 . ; Next I need Med Form (tab, cap etc), strength (250mg)
 . ; concentration for liquids (250mg/mL)
 . ; Since IHS does not have any of the new calls that
 . ; Vista has, I will be doing a crosswalk:
 . ; File 52, field 6 is Drug IEN in file 50
 . ; File 50, field 22 is VA Product IEN in file 50.68
 . ; In file 50.68, I will get the following:
 . ; -- 1: Dosage Form
 . ; -- 2: Strength
 . ; -- 3: Units
 . ; -- 8: Dispense Units
 . ; -- Conc is 2 concatenated with 3
 . ;
 . ; *** If Drug is not matched to NDF, then VA Product will be "" ***
 . ;
 . N MEDIEN S MEDIEN=$$GET1^DIQ(52,RXIEN,6,"I") ; Drug IEN in 50
 . N VAPROD S VAPROD=$$GET1^DIQ(50,MEDIEN,22,"I") ; VA Product in file 50.68
 . I +VAPROD D
 . . S @MAP@("MEDSTRENGTHVALUE")=$$GET1^DIQ(50.68,VAPROD,2)
 . . S @MAP@("MEDSTRENGTHUNIT")=$$GET1^DIQ(50.68,VAPROD,3)
 . . S @MAP@("MEDFORMTEXT")=$$GET1^DIQ(50.68,VAPROD,1)
 . . S @MAP@("MEDCONCVALUE")=@MAP@("MEDSTRENGTHVALUE")
 . . S @MAP@("MEDCONCUNIT")=@MAP@("MEDSTRENGTHUNIT")
 . E  D
 . . S @MAP@("MEDSTRENGTHVALUE")=""
 . . S @MAP@("MEDSTRENGTHUNIT")=""
 . . S @MAP@("MEDFORMTEXT")=""
 . . S @MAP@("MEDCONCVALUE")=""
 . . S @MAP@("MEDCONCUNIT")=""
 . ; End Strengh/Conc stuff
 . ;
 . ; Quantity is in the prescription, field 7
 . S @MAP@("MEDQUANTITYVALUE")=$$GET1^DIQ(52,RXIEN,7)
 . ; Dispense unit is in the drug file, field 14.5
 . S @MAP@("MEDQUANTITYUNIT")=$$GET1^DIQ(50,MEDIEN,14.5)
 . ;
 . ; --- START OF DIRECTIONS ---
 . ; Sig data not in any API :-(  Oh yes, you can get the whole thing, but...
 . ; we want the components.
 . ; It's in multiple 113 in the Prescription File (52)
 . ; #.01 DOSAGE ORDERED [1F]    "20"
 . ; #1 DISPENSE UNITS PER DOSE [2N]  "1"
 . ; #2 UNITS [3P:50.607]     "MG"
 . ; #3 NOUN [4F]      "TABLET"
 . ; #4 DURATION [5F]      "10D"
 . ; #5 CONJUNCTION [6S]     "AND"
 . ; #6 ROUTE [7P:51.2]     "ORAL"
 . ; #7 SCHEDULE [8F]      "BID"
 . ; #8 VERB [9F]       "TAKE"
 . ;
 . ; Will use GETS^DIQ to get fields.
 . ; Data comes out like this:
 . ; SAMINS(52.0113,"1,23,",.01)=20
 . ; SAMINS(52.0113,"1,23,",1)=1
 . ; SAMINS(52.0113,"1,23,",2)="MG"
 . ; SAMINS(52.0113,"1,23,",3)="TABLET"
 . ; SAMINS(52.0113,"1,23,",4)="5D"
 . ; SAMINS(52.0113,"1,23,",5)="THEN"
 . ;
 . N RAWDATA
 . D GETS^DIQ(52,RXIEN,"113*",,"RAWDATA","DIERR")
 . D:$D(DIERR) ^%ZTER  ; Log if there's an error in retrieving sig field
 . ; none the less, continue; some parts are retrievable.
 . N FMSIG M FMSIG=RAWDATA(52.0113) ; Merge into subfile...
 . K RAWDATA
 . N FMSIGNUM S FMSIGNUM="" ; Sigline number in fileman.
 . ; FMSIGNUM gets outputted as "IEN,RXIEN,".
 . ; DIRCNT is the proper Sigline numer.
 . ; SIGDATA is the simplfied array.
 . F  S FMSIGNUM=$O(FMSIG(FMSIGNUM)) Q:FMSIGNUM=""  D
 . . N DIRCNT S DIRCNT=$P(FMSIGNUM,",")
 . . N SIGDATA M SIGDATA=FMSIG(FMSIGNUM)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRECTIONDESCRIPTIONTEXT")=""  ; This is reserved for systems not able to generate the sig in components.
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDOSEINDICATOR")="1"  ; means that we are specifying it. See E2369-05.
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDELIVERYMETHOD")=$G(SIGDATA(8))
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDOSEVALUE")=$G(SIGDATA(.01))
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDOSEUNIT")=$G(SIGDATA(2))
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDRATEVALUE")=""  ; For inpatient
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDRATEUNIT")=""  ; For inpatient
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDVEHICLETEXT")=""  ; For inpatient
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRECTIONROUTETEXT")=$G(SIGDATA(6))
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDFREQUENCYVALUE")=$G(SIGDATA(7))
 . . ; Invervals... again another call.
 . . ; In the wisdom of the original programmers, the schedule is a free text field
 . . ; However, it gets translated by a call to the administration schedule file
 . . ; to see if that schedule exists.
 . . ; That's the same thing I am going to do.
 . . ; Search B index of 51.1 (Admin Schedule) with schedule
 . . ; First, remove "PRN" if it exists (don't ask, that's how the file
 . . ; works; I wouldn't do it that way).
 . . N SCHNOPRN S SCHNOPRN=$G(SIGDATA(7))
 . . I SCHNOPRN["PRN" S SCHNOPRN=$E(SCHNOPRN,1,$F(SCHNOPRN,"PRN")-5)
 . . ; Super call below:
 . . ; 1=File 51.1 3=Field 2 (Frequency in Minutes)
 . . ; 4=Packed format, Exact Match 5=Lookup Value
 . . ; 6=# of entries to return 7=Index 10=Return Array
 . . ;
 . . ; I do not account for the fact that two schedules can be
 . . ; spelled identically (ie duplicate entry). In that case,
 . . ; I get the first. That's just a bad pharmacy pkg maintainer.
 . . N C0C515
 . . D FIND^DIC(51.1,,"@;2","PX",SCHNOPRN,1,"B",,,"C0C515")
 . . N INTERVAL S INTERVAL="" ; Default
 . . ; If there are entries found, get it
 . . I +$G(C0C515("DILIST",0)) S INTERVAL=$P(C0C515("DILIST",1,0),U,2)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDINTERVALVALUE")=INTERVAL
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDINTERVALUNIT")="Minute"
 . . ; Duration is 10M minutes, 10H hours, 10D for Days
 . . ; 10W for weeks, 10L for months. I smell $Select
 . . ; But we don't need to do that if there isn't a duration
 . . I +$G(SIGDATA(4)) D
 . . . N DURUNIT S DURUNIT=$E(SIGDATA(4),$L(SIGDATA(4))) ; get last char
 . . . N DURTXT S DURTXT=$S(DURUNIT="M":"Minutes",DURUNIT="H":"Hours",DURUNIT="D":"Days",DURUNIT="W":"Weeks",DURUNIT="L":"Months",1:"Days")
 . . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDURATIONVALUE")=+SIGDATA(4)
 . . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDURATIONUNIT")=DURTXT
 . . E  D
 . . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDURATIONVALUE")=""
 . . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDURATIONUNIT")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPRNFLAG")=$G(SIGDATA(4))["PRN"
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMOBJECTID")="" ; when avail
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMTYPETXT")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMDESCRIPTION")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMCODEVALUE")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMCODINGSYSTEM")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMCODINGVERSION")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMSOURCEACTORID")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDSTOPINDICATOR")="" ; not stored
 . . ; Another confusing line; I am pretty bad:
 . . ; If there is another entry in the FMSIG array (i.e. another line
 . . ; in the sig), set the direction count indicator.
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRSEQ")=""  ; Default
 . . S:+$O(FMSIG(FMSIGNUM)) @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRSEQ")=DIRCNT
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDMULDIRMOD")=$G(SIGDATA(5))
 . ;
 . ; --- END OF DIRECTIONS ---
 . ;
 . ; Med instructions is a WP field, thus the acrobatics
 . ; Notice buffer overflow protection set at 10,000 chars
 . ; -- 1. Med Patient Instructions
 . N MEDPTIN1 S MEDPTIN1=$$GET1^DIQ(52,RXIEN,115,,"MEDPTIN1")
 . N MEDPTIN2,J  S (MEDPTIN2,J)=""
 . I $L(MEDPTIN1) F  S J=$O(@MEDPTIN1@(J)) Q:J=""  Q:$L(MEDPTIN2)>10000  S MEDPTIN2=MEDPTIN2_@MEDPTIN1@(J)_" "
 . S @MAP@("MEDPTINSTRUCTIONS")=MEDPTIN2
 . K J
 . ; -- 2. Med Provider Instructions
 . N MEDPVIN1 S MEDPVIN1=$$GET1^DIQ(52,RXIEN,39,,"MEDPVIN1")
 . N MEDPVIN2,J S (MEDPVIN2,J)=""
 . I $L(MEDPVIN1) F  S J=$O(@MEDPVIN1@(J)) Q:J=""  Q:$L(MEDPVIN2)>10000  S MEDPVIN2=MEDPVIN2_@MEDPVIN1@(J)_" "
 . S @MAP@("MEDFULLFILLMENTINSTRUCTIONS")=MEDPVIN2
 . ;
 . ; Remaining refills
 . S @MAP@("MEDRFNO")=$P(MEDS(MEDCNT),U,6)
 . ; ------ END OF MAPPING
 . ;
 . ; ------ BEGIN XML INSERTION
 . N RESULT S RESULT=$NA(^TMP("C0CCCR",$J,"MAPPED"))
 . K @RESULT
 . D MAP^C0CXPATH(MINXML,MAP,RESULT)
 . ; D PARY^C0CXPATH(RESULT)
 . ; MAPPING DIRECTIONS
 . N MEDDIR1,DIRXML1 S DIRXML1="MEDDIR1" ; VARIABLE AND NAME VARIABLE TEMPLATE
 . N MEDDIR2,DIRXML2 S DIRXML2="MEDDIR2" ; VARIABLE AND NAME VARIABLE RESULT
 . D QUERY^C0CXPATH(MINXML,"//Medications/Medication/Directions",DIRXML1)
 . D REPLACE^C0CXPATH(RESULT,"","//Medications/Medication/Directions")
 . ; N MDZ1,MDZNA
 . N DIRCNT S DIRCNT=""
 . I +$O(@MAP@("M","DIRECTIONS",DIRCNT)) D  ; IF THERE ARE DIRCTIONS
 . . F DIRCNT=$O(@MAP@("M","DIRECTIONS",DIRCNT)) D  ; FOR EACH DIRECTION
 . . . S MDZNA=$NA(@MAP@("M","DIRECTIONS",DIRCNT))
 . . . D MAP^C0CXPATH(DIRXML1,MDZNA,DIRXML2)
 . . . D INSERT^C0CXPATH(RESULT,DIRXML2,"//Medications/Medication")
 . D:MEDCNT=1 CP^C0CXPATH(RESULT,OUTXML) ; First one is a copy
 . D:MEDCNT>1 INSINNER^C0CXPATH(OUTXML,RESULT) ; AFTER THE FIRST, INSERT INNER XML
 . S MEDCOUNT=MEDCNT
 N MEDTMP,MEDI
 D MISSING^C0CXPATH(OUTXML,"MEDTMP") ; SEARCH XML FOR MISSING VARS
 I MEDTMP(0)>0 D  ; IF THERE ARE MISSING VARS - MARKED AS @@X@@
 . W "MEDICATION MISSING ",!
 . F MEDI=1:1:MEDTMP(0) W MEDTMP(MEDI),!
 Q
 ;
GETRXN(NDC) ; Extrinsic Function; PUBLIC; NDC to RxNorm
 ;; Get RxNorm Concept Number for a Given NDC
 ;
 S NDC=$TR(NDC,"-")  ; Remove dashes
 N RXNORM,C0CZRXN,DIERR
 D FIND^DIC(176.002,,"@;.01","PX",NDC,"*","NDC",,,"C0CZRXN","DIERR")
 I $D(DIERR) D ^%ZTER BREAK
 S RXNORM(0)=+C0CZRXN("DILIST",0) ; RxNorm(0) will be # of entries
 N I S I=0
 F  S I=$O(C0CZRXN("DILIST",I)) Q:I=""  S RXNORM(I)=$P(C0CZRXN("DILIST",I,0),U,2)
 ; At this point, RxNorm(0) is # of entries; RxNorm(1...) are the entries
 ; If RxNorm(0) is 1, then we only have one entry, and that's it.
 I RXNORM(0)=1 QUIT RXNORM(1)  ; RETURN RXNORM(1)
 ; Otherwise, we need to find out which one is the semantic
 ; clinical drug. I built an index on 176.001 (RxNorm Concepts)
 ; for that purpose.
 I RXNORM(0)>1 D
 . S I=0
 . F  S I=$O(RXNORM(I)) Q:I=""  D  Q:$G(RXNORM)
 . . N RXNIEN S RXNIEN=$$FIND1^DIC(176.001,,,RXNORM(I),"SCD")
 . . I +$G(RXNIEN)=0 QUIT  ; try the next entry...
 . . E  S RXNORM=RXNORM(I) QUIT  ; We found the right code
 QUIT +$G(RXNORM)  ; RETURN RXNORM; if we couldn't find a clnical drug, return with 0
