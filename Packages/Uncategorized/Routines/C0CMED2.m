C0CMED2 ; WV/CCDCCR/SMH - CCR/CCD Meds - Pending for Vista
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;;Last Modified Sat Jan 10 21:41:14 PST 2009
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
EXTRACT(MINXML,DFN,OUTXML,MEDCOUNT)           ; EXTRACT MEDICATIONS INTO PROVIDED XML TEMPLATE
 ;
 ; MINXML is the Input XML Template, passed by name
 ; DFN is Patient IEN (by Value)
 ; OUTXML is the resultant XML (by Name)
 ; MEDCOUNT is the current count of extracted meds, passed by Reference
 ;
 ; MEDS is return array from RPC.
 ; MAP is a mapping variable map (store result) for each med
 ; MED is holds each array element from MEDS, one medicine
 ;
 ; PEN^PSO5241 is a Pharmacy Re-Enginnering (PRE) API to get Pending
 ; meds data available.
 ; http://www.va.gov/vdl/documents/Clinical/Pharm-Outpatient_Pharmacy/phar_1_api_r0807.pdf
 ; Output of API is ^TMP($J,"SUBSCRIPT",DFN,RXIENS).
 ; File for pending meds is 52.41
 ; Unfortuantely, API does not supply us with any useful info beyond
 ; the IEN in 52.41, and the Med Name, and route.
 ; So, most of the info is going to get pulled from 52.41.
 N MEDS,MAP
 K ^TMP($J,"CCDCCR") ; PLEASE DON'T KILL ALL OF ^TMP($J) HERE!!!!
 D PEN^PSO5241(DFN,"CCDCCR")
 M MEDS=^TMP($J,"CCDCCR",DFN)
 ; @(0) contains the number of meds or -1^NO DATA FOUND
 ; If it is -1, we quit.
 I $P(MEDS(0),U)=-1 S @OUTXML@(0)=0 QUIT
 ZWRITE:$G(DEBUG) MEDS
 N RXIEN S RXIEN=0
 N MEDFIRST S MEDFIRST=1 ; FLAG FOR FIRST MED IN THIS SECTION FOR MERGING
 F  S RXIEN=$O(MEDS(RXIEN)) Q:RXIEN="B"  D  ; FOR EACH MEDICATION IN THE LIST
 . I $$GET1^DIQ(52.41,RXIEN,2,"I")="RF" QUIT  ; Dont' want refill request as a "pending" order
 . S MEDCOUNT=MEDCOUNT+1
 . I DEBUG W "RXIEN IS ",RXIEN,!
 . S MAP=$NA(^TMP("C0CCCR",$J,"MEDMAP",MEDCOUNT))
 . ; K @MAP DON'T KILL MAP HERE, IT IS DONE IN C0CMED
 . I DEBUG W "MAP= ",MAP,!
 . N MED M MED=MEDS(RXIEN) ; PULL OUT MEDICATION FROM
 . S @MAP@("MEDOBJECTID")="MED_PENDING"_MEDCOUNT ; MEDCOUNT FOR ID
 . ; S @MAP@("MEDOBJECTID")="MED_PENDING"_MED(.01) ;Pending IEN
 . S @MAP@("MEDISSUEDATETXT")="Issue Date"
 . ; Field 6 is "Effective date", and we pull it in timson format w/ I
 . S @MAP@("MEDISSUEDATE")=$$FMDTOUTC^C0CUTIL($$GET1^DIQ(52.41,RXIEN,6,"I"),"DT")
 . ; Med never filled; next 4 fields are not applicable.
 . S @MAP@("MEDLASTFILLDATETXT")=""
 . S @MAP@("MEDLASTFILLDATE")=""
 . S @MAP@("MEDRXNOTXT")=""
 . S @MAP@("MEDRXNO")=""
 . S @MAP@("MEDTYPETEXT")="Medication"
 . S @MAP@("MEDDETAILUNADORNED")=""  ; Leave blank, field has its uses
 . S @MAP@("MEDSTATUSTEXT")="On Hold" ; nearest status for pending meds
 . S @MAP@("MEDSOURCEACTORID")="ACTORPROVIDER_"_$$GET1^DIQ(52.41,RXIEN,5,"I")
 . S @MAP@("MEDPRODUCTNAMETEXT")=$P(MED(11),U,2)
 . ; NDC not supplied in API, but is rather trivial to obtain
 . ; MED(11) piece 1 has the IEN of the drug (file 50)
 . ; IEN is field 31 in the drug file.
 . ;
 . ; MEDIEN (node 11 in the returned output) might not necessarily be defined
 . ; It is not defined when a dose in not chosen in CPRS. There is a long
 . ; series of fields that depend on it. We will use If and Else to deal
 . ; with that
 . N MEDIEN S MEDIEN=$P(MED(11),U)
 . I +MEDIEN>0 D  ; start of if/else block
 . . ; 12/30/08: I will be using RxNorm for coding...
 . . ; 176.001 is the file for Concepts; 176.003 is the file for
 . . ; sources (i.e. for RxNorm Version)
 . . ;
 . . ; We need the VUID first for the National Drug File entry first
 . . ; We get the VUID of the drug, by looking up the VA Product entry
 . . ; (file 50.68) using the call NDF^PSS50, returned in node 22.
 . . ; Field 99.99 is the VUID.
 . . ;
 . . ; We use the VUID to look up the RxNorm in file 176.001; same idea.
 . . ; Get IEN first using $$FIND1^DIC, then get the RxNorm number by
 . . ; $$GET1^DIQ.
 . . ;
 . . ; I get the RxNorm name and version from the RxNorm Sources (file
 . . ; 176.003), by searching for "RXNORM", then get the data.
 . . D NDF^PSS50(MEDIEN,,,,,"NDF")
 . . N NDFDATA M NDFDATA=^TMP($J,"NDF",MEDIEN)
 . . N NDFIEN S NDFIEN=$P(NDFDATA(20),U)
 . . N VAPROD S VAPROD=$P(NDFDATA(22),U)
 . . ;
 . . ; NDFIEN is not necessarily defined; it won't be if the drug
 . . ; is not matched to the national drug file (e.g. if the drug is
 . . ; new on the market, compounded, or is a fake drug [blue pill].
 . . ; To protect against failure, I will put an if/else block
 . . N VUID,RXNIEN,RXNORM,SRCIEN,RXNNAME,RXNVER
 . . I NDFIEN,$D(^C0CRXN) D  ; $Data is for Systems that don't have our RxNorm file yet.
 . . . S VUID=$$GET1^DIQ(50.68,VAPROD,99.99)
 . . . S RXNIEN=$$FIND1^DIC(176.001,,,VUID,"VUID")
 . . . S RXNORM=$$GET1^DIQ(176.001,RXNIEN,.01)
 . . . S SRCIEN=$$FIND1^DIC(176.003,,"B","RXNORM")
 . . . S RXNNAME=$$GET1^DIQ(176.003,SRCIEN,6)
 . . . S RXNVER=$$GET1^DIQ(176.003,SRCIEN,7)
 . . ;
 . . E  S (RXNORM,RXNNAME,RXNVER)=""
 . . ; End if/else block
 . . S @MAP@("MEDPRODUCTNAMECODEVALUE")=RXNORM
 . . S @MAP@("MEDPRODUCTNAMECODINGINGSYSTEM")=RXNNAME
 . . S @MAP@("MEDPRODUCTNAMECODEVERSION")=RXNVER
 . . ;
 . . S @MAP@("MEDBRANDNAMETEXT")=""
 . . D DOSE^PSS50(MEDIEN,,,,,"DOSE")
 . . N DOSEDATA M DOSEDATA=^TMP($J,"DOSE",MEDIEN)
 . . S @MAP@("MEDSTRENGTHVALUE")=DOSEDATA(901)
 . . S @MAP@("MEDSTRENGTHUNIT")=$P(DOSEDATA(902),U,2)
 . . ; Units, concentration, etc, come from another call
 . . ; $$CPRS^PSNAPIS which returns dosage-form^va class^strengh^unit
 . . ; This call takes nodes 1 and 3 of ^PSDRUG(D0,"ND") as parameters
 . . ; NDF Entry IEN, and VA Product Name
 . . ; These can be obtained using NDF^PSS50 (IEN,,,,,"SUBSCRIPT")
 . . ; Documented in the same manual; executed above.
 . . N CONCDATA
 . . ; If a drug was not matched to NDF, then the NDFIEN is gonna be ""
 . . ; and this will crash the call. So...
 . . I NDFIEN="" S CONCDATA=""
 . . E  S CONCDATA=$$CPRS^PSNAPIS(NDFIEN,VAPROD)
 . . S @MAP@("MEDFORMTEXT")=$P(CONCDATA,U,1)
 . . S @MAP@("MEDCONCVALUE")=$P(CONCDATA,U,3)
 . . S @MAP@("MEDCONCUNIT")=$P(CONCDATA,U,4)
 . . S @MAP@("MEDQUANTITYVALUE")=$$GET1^DIQ(52.41,RXIEN,12)
 . . ; Oddly, there is no easy place to find the dispense unit.
 . . ; It's not included in the original call, so we have to go to the drug file.
 . . ; That would be DATA^PSS50(IEN,,,,,"SUBSCRIPT")
 . . ; Node 14.5 is the Dispense Unit
 . . D DATA^PSS50(MEDIEN,,,,,"QTY")
 . . N QTYDATA M QTYDATA=^TMP($J,"QTY",MEDIEN)
 . . S @MAP@("MEDQUANTITYUNIT")=QTYDATA(14.5)
 . E  D
 . . S @MAP@("MEDPRODUCTNAMECODEVALUE")=""
 . . S @MAP@("MEDPRODUCTNAMECODINGINGSYSTEM")=""
 . . S @MAP@("MEDPRODUCTNAMECODEVERSION")=""
 . . S @MAP@("MEDBRANDNAMETEXT")=""
 . . S @MAP@("MEDSTRENGTHVALUE")=""
 . . S @MAP@("MEDSTRENGTHUNIT")=""
 . . S @MAP@("MEDFORMTEXT")=""
 . . S @MAP@("MEDCONCVALUE")=""
 . . S @MAP@("MEDCONCUNIT")=""
 . . S @MAP@("MEDSIZETEXT")=""
 . . S @MAP@("MEDQUANTITYVALUE")=""
 . . S @MAP@("MEDQUANTITYUNIT")=""
 . ; end of if/else block
 . ;
 . ; --- START OF DIRECTIONS ---
 . ; Sig data is not in any API. We obtain it using the IEN from
 . ; the PEN API to file 52.41. It's in field 3, which is a multiple.
 . ; I will be using FM call GETS^DIQ(FILE,IENS,FIELD,FLAGS,TARGET_ROOT)
 . K FMSIG ; it's passed via the symbol table, so remove any leftovers from last call
 . D GETS^DIQ(52.41,RXIEN,"3*",,"FMSIG")
 . N FMSIGNUM S FMSIGNUM=0 ; Sigline number in fileman.
 . ; FMSIGNUM gets outputted as "IEN,RXIEN,".
 . ; DIRNUM will be first piece for IEN.
 . ; DIRNUM is the proper Sigline numer.
 . ; SIGDATA is the simplfied array. Subscripts are really field numbers
 . ; in subfile 52.413.
 . N DIRCNT S DIRCNT=0 ; COUNT OF DIRECTIONS
 . F  S FMSIGNUM=$O(FMSIG(52.413,FMSIGNUM)) Q:FMSIGNUM=""  D
 . . N DIRNUM S DIRNUM=$P(FMSIGNUM,",")
 . . S DIRCNT=DIRCNT+1 ; INCREMENT DIRECTIONS COUNT
 . . N SIGDATA M SIGDATA=FMSIG(52.413,FMSIGNUM)
 . . ; If this is an order for a refill; it's not really a new order; move on to next
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRECTIONDESCRIPTIONTEXT")=""  ; This is reserved for systems not able to generate the sig in components.
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDOSEINDICATOR")="1"  ; means that we are specifying it. See E2369-05.
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDELIVERYMETHOD")=SIGDATA(13)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDOSEVALUE")=SIGDATA(8)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDOSEUNIT")=@MAP@("MEDCONCUNIT")
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDRATEVALUE")=""  ; For inpatient
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDRATEUNIT")=""  ; For inpatient
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDVEHICLETEXT")=""  ; For inpatient
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRECTIONROUTETEXT")=SIGDATA(10)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDFREQUENCYVALUE")=SIGDATA(1)
 . . ; Invervals... again another call.
 . . ; The schedule is a free text field
 . . ; However, it gets translated by a call to the administration
 . . ; schedule file to see if that schedule exists.
 . . ; That's the same thing I am going to do.
 . . ; The call is AP^PSS51P1(PSSPP,PSSFT,PSSWDIEN,PSSSTPY,LIST,PSSFREQ).
 . . ; PSSPP is "PSJ" (for some reason, schedules are stored as PSJ, not PSO--
 . . ; I looked), PSSFT is the name,
 . . ; and list is the ^TMP name to store the data in.
 . . ; Also, freqency may have "PRN" in it, so strip that out
 . . N FREQ S FREQ=SIGDATA(1)
 . . I FREQ["PRN" S FREQ=$E(FREQ,1,$F(FREQ,"PRN")-5) ; 5 for $L("PRN") + 1 + sp
 . . D AP^PSS51P1("PSJ",FREQ,,,"SCHEDULE")
 . . N SCHEDATA M SCHEDATA=^TMP($J,"SCHEDULE")
 . . N INTERVAL
 . . I $P(SCHEDATA(0),U)=-1 S INTERVAL=""
 . . E  D
 . . . N SUB S SUB=$O(SCHEDATA(0))
 . . . S INTERVAL=SCHEDATA(SUB,2)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDINTERVALVALUE")=INTERVAL
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDINTERVALUNIT")="Minute"
 . . ; Duration comes as M2,H2,D2,W2,L2 for 2 minutes,hours,days,weeks,months
 . . N DUR S DUR=SIGDATA(2)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDURATIONVALUE")=$E(DUR,2,$L(DUR))
 . . N DURUNIT S DURUNIT=$E(DUR)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDURATIONUNIT")=$S(DURUNIT="M":"Minutes",DURUNIT="H":"Hours",DURUNIT="D":"Days",DURUNIT="W":"Weeks",DURUNIT="L":"Months",1:"")
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPRNFLAG")=SIGDATA(1)["PRN"
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMOBJECTID")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMTYPETXT")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMDESCRIPTION")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMCODEVALUE")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMCODINGSYSTEM")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMCODINGVERSION")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMSOURCEACTORID")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDSTOPINDICATOR")="" ; Vista doesn't have that field
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRSEQ")=DIRNUM
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDMULDIRMOD")=SIGDATA(6)
 . ;
 . ; --- END OF DIRECTIONS ---
 . ;
 . ; S @MAP@("MEDPTINSTRUCTIONS","F")="52.41^105"
 . S @MAP@("MEDPTINSTRUCTIONS")=$G(^PSRX(RXIEN,"PI",1,0)) ;GPL
 . ; W @MAP@("MEDPTINSTRUCTIONS"),!
 . ; S @MAP@("MEDFULLFILLMENTINSTRUCTIONS","F")="52.41^9"
 . S @MAP@("MEDFULLFILLMENTINSTRUCTIONS")=$G(^PSRX(RXIEN,"SIG1",1,0)) ;GPL
 . ; W @MAP@("MEDFULLFILLMENTINSTRUCTIONS"),!
 . S @MAP@("MEDRFNO")=$$GET1^DIQ(52.41,RXIEN,13)
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
 . I DIRCNT>0 D  ; IF THERE ARE DIRCTIONS
 . . F MDZ1=1:1:DIRCNT  D  ; FOR EACH DIRECTION
 . . . S MDZNA=$NA(@MAP@("M","DIRECTIONS",MDZ1))
 . . . D MAP^C0CXPATH(DIRXML1,MDZNA,DIRXML2)
 . . . D INSERT^C0CXPATH(RESULT,DIRXML2,"//Medications/Medication")
 . I MEDFIRST D  ;
 . . S MEDFIRST=0 ; RESET FIRST FLAG
 . . D CP^C0CXPATH(RESULT,OUTXML) ; First one is a copy
 . D:'MEDFIRST INSINNER^C0CXPATH(OUTXML,RESULT) ; AFTER FIRST, INSERT INNER
 N MEDTMP,MEDI
 D MISSING^C0CXPATH(OUTXML,"MEDTMP") ; SEARCH XML FOR MISSING VARS
 I MEDTMP(0)>0 D  ; IF THERE ARE MISSING VARS - MARKED AS @@X@@
 . W "Pending Medication MISSING ",!
 . F MEDI=1:1:MEDTMP(0) W MEDTMP(MEDI),!
 Q
 ;
