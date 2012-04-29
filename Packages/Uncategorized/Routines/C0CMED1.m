C0CMED1 ; WV/CCDCCR/SMH - CCR/CCD PROCESSING FOR MEDICATIONS ;01/10/09
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;;Last modified Sat Jan 10 21:42:27 PST 2009
 ; Copyright 2009 WorldVistA.  Licensed under the terms of the GNU
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
EXTRACT(MINXML,DFN,OUTXML,MEDCOUNT,FLAGS) ; EXTRACT MEDICATIONS INTO PROVIDED XML TEMPLATE
 ;
 ; INXML AND OUTXML ARE PASSED BY NAME SO GLOBALS CAN BE USED
 ; INXML WILL CONTAIN ONLY THE MEDICATIONS SECTION OF THE OVERALL TEMPLATE
 ;
 ; MEDS is return array from RPC.
 ; MAP is a mapping variable map (store result) for each med
 ; MED is holds each array element from MEDS(J), one medicine
 ; MEDCOUNT is a counter passed by Reference.
 ; FLAGS are: MEDALL(bool)^MEDLIMIT(int)^MEDACTIVE(bool)^MEDPENDING(bool)
 ; FLAGS are set-up in C0CMED.
 ;
 ; RX^PSO52API is a Pharmacy Re-Enginnering (PRE) API to get all
 ; med data available.
 ; http://www.va.gov/vdl/documents/Clinical/Pharm-Outpatient_Pharmacy/phar_1_api_r0807.pdf
 ; Output of API is ^TMP($J,"SUBSCRIPT",DFN,RXIENS).
 ; D PARY^C0CXPATH(MINXML)
 N MEDS,MAP
 K ^TMP($J,"CCDCCR") ; PLEASE DON'T KILL ALL OF ^TMP($J) HERE!!!!
 N ALL S ALL=+FLAGS
 N ACTIVE S ACTIVE=$P(FLAGS,U,3)
 ; Below, X1 is today; X2 is the number of days we want to go back
 ; X is the result of this calculation using C^%DTC.
 N X,X1,X2
 S X1=DT
 S X2=-$P($P(FLAGS,U,2),"-",2)
 D C^%DTC
 ; I discovered that I shouldn't put an ending date (last parameter)
 ; because it seems that it will get meds whose beginning is after X but
 ; whose exipriation is before the ending date.
 D RX^PSO52API(DFN,"CCDCCR","","","",X,"")
 M MEDS=^TMP($J,"CCDCCR",DFN)
 ; @(0) contains the number of meds or -1^NO DATA FOUND
 ; If it is -1, we quit.
 I $P(MEDS(0),U)=-1 S @OUTXML@(0)=0 Q
 ZWRITE:$G(DEBUG) MEDS
 N RXIEN S RXIEN=0
 F  S RXIEN=$O(MEDS(RXIEN)) Q:$G(RXIEN)=""  D  ; FOR EACH MEDICATION IN THE LIST
 . N MED M MED=MEDS(RXIEN)
 . I 'ALL,ACTIVE,$P(MED(100),U,2)'="ACTIVE" QUIT
 . S MEDCOUNT=MEDCOUNT+1
 . W:$G(DEBUG) "RXIEN IS ",RXIEN,!
 . S MAP=$NA(^TMP("C0CCCR",$J,"MEDMAP",MEDCOUNT))
 . ; K @MAP DO NOT KILL HERE, WAS CLEARED IN C0CMED
 . W:$G(DEBUG) "MAP= ",MAP,!
 . S @MAP@("MEDOBJECTID")="MED"_MEDCOUNT ; MEDCOUNT FOR ID
 . ; S @MAP@("MEDOBJECTID")="MED"_MED(.01) ;Rx Number
 . S @MAP@("MEDISSUEDATETXT")="Issue Date"
 . S @MAP@("MEDISSUEDATE")=$$FMDTOUTC^C0CUTIL($P(MED(1),U))
 . S @MAP@("MEDLASTFILLDATETXT")="Last Fill Date"
 . S @MAP@("MEDLASTFILLDATE")=$$FMDTOUTC^C0CUTIL($P($G(MED(101)),U))
 . S @MAP@("MEDRXNOTXT")="Prescription Number"
 . S @MAP@("MEDRXNO")=MED(.01)
 . S @MAP@("MEDTYPETEXT")="Medication"
 . S @MAP@("MEDDETAILUNADORNED")=""  ; Leave blank, field has its uses
 . S @MAP@("MEDSTATUSTEXT")=$P(MED(100),U,2)
 . S @MAP@("MEDSOURCEACTORID")="ACTORPROVIDER_"_$P(MED(4),U)
 . S @MAP@("MEDPRODUCTNAMETEXT")=$P(MED(6),U,2)
 . ; 12/30/08: I will be using RxNorm for coding...
 . ; 176.001 is the file for Concepts; 176.003 is the file for
 . ; sources (i.e. for RxNorm Version)
 . ;
 . ; We need the VUID first for the National Drug File entry first
 . ; We get the VUID of the drug, by looking up the VA Product entry
 . ; (file 50.68) using the call NDF^PSS50, returned in node 22.
 . ; Field 99.99 is the VUID.
 . ;
 . ; We use the VUID to look up the RxNorm in file 176.001; same idea.
 . ; Get IEN first using $$FIND1^DIC, then get the RxNorm number by
 . ; $$GET1^DIQ.
 . ;
 . ; I get the RxNorm name and version from the RxNorm Sources (file
 . ; 176.003), by searching for "RXNORM", then get the data.
 . N MEDIEN S MEDIEN=$P(MED(6),U)
 . D NDF^PSS50(MEDIEN,,,,,"NDF")
 . N NDFDATA M NDFDATA=^TMP($J,"NDF",MEDIEN)
 . N NDFIEN S NDFIEN=$P(NDFDATA(20),U)
 . N VAPROD S VAPROD=$P(NDFDATA(22),U)
 . ;
 . ; NDFIEN is not necessarily defined; it won't be if the drug
 . ; is not matched to the national drug file (e.g. if the drug is
 . ; new on the market, compounded, or is a fake drug [blue pill].
 . ; To protect against failure, I will put an if/else block
 . ;
 . N VUID,RXNIEN,RXNORM,SRCIEN,RXNNAME,RXNVER
 . I NDFIEN,$D(^C0CRXN) D  ; $Data is for Systems that don't have our RxNorm file yet.
 . . S VUID=$$GET1^DIQ(50.68,VAPROD,99.99)
 . . S RXNIEN=$$FIND1^DIC(176.001,,,VUID,"VUID")
 . . S RXNORM=$$GET1^DIQ(176.001,RXNIEN,.01)
 . . S SRCIEN=$$FIND1^DIC(176.003,,"B","RXNORM")
 . . S RXNNAME=$$GET1^DIQ(176.003,SRCIEN,6)
 . . S RXNVER=$$GET1^DIQ(176.003,SRCIEN,7)
 . ;
 . E  S (RXNORM,RXNNAME,RXNVER)=""
 . ; End if/else block
 . S @MAP@("MEDPRODUCTNAMECODEVALUE")=RXNORM
 . S @MAP@("MEDPRODUCTNAMECODINGINGSYSTEM")=RXNNAME
 . S @MAP@("MEDPRODUCTNAMECODEVERSION")=RXNVER
 . ;
 . S @MAP@("MEDBRANDNAMETEXT")=MED(6.5)
 . D DOSE^PSS50(MEDIEN,,,,,"DOSE")
 . N DOSEDATA M DOSEDATA=^TMP($J,"DOSE",MEDIEN)
 . S @MAP@("MEDSTRENGTHVALUE")=DOSEDATA(901)
 . S @MAP@("MEDSTRENGTHUNIT")=$P(DOSEDATA(902),U,2)
 . ; Units, concentration, etc, come from another call
 . ; $$CPRS^PSNAPIS which returns dosage-form^va class^strengh^unit
 . ; This call takes nodes 1 and 3 of ^PSDRUG(D0,"ND") as parameters
 . ; NDF Entry IEN, and VA Product IEN
 . ; These can be obtained using NDF^PSS50 (IEN,,,,,"SUBSCRIPT")
 . ; These have been collected above.
 . N CONCDATA
 . ; If a drug was not matched to NDF, then the NDFIEN is gonna be ""
 . ; and this will crash the call. So...
 . I NDFIEN="" S CONCDATA=""
 . E  S CONCDATA=$$CPRS^PSNAPIS(NDFIEN,VAPROD)
 . S @MAP@("MEDFORMTEXT")=$P(CONCDATA,U,1)
 . S @MAP@("MEDCONCVALUE")=$P(CONCDATA,U,3)
 . S @MAP@("MEDCONCUNIT")=$P(CONCDATA,U,4)
 . S @MAP@("MEDQUANTITYVALUE")=MED(7)
 . ; Oddly, there is no easy place to find the dispense unit.
 . ; It's not included in the original call, so we have to go to the drug file.
 . ; That would be DATA^PSS50(IEN,,,,,"SUBSCRIPT")
 . ; Node 14.5 is the Dispense Unit
 . D DATA^PSS50(MEDIEN,,,,,"QTY")
 . N QTYDATA M QTYDATA=^TMP($J,"QTY",MEDIEN)
 . S @MAP@("MEDQUANTITYUNIT")=QTYDATA(14.5)
 . ;
 . ; --- START OF DIRECTIONS ---
 . ; Sig data not in any API :-(  Oh yes, you can get the whole thing, but...
 . ; we want the compoenents.
 . ; It's in node 6 of ^PSRX(IEN)
 . ; So, here we go again
 . ; ^PSRX(D0,6,D1,0)= (#.01) DOSAGE ORDERED [1F] ^ (#1) DISPENSE UNITS PER DOSE
 . ; ==>[2N] ^ (#2) UNITS [3P:50.607] ^ (#3) NOUN [4F] ^ (#4)
 . ; ==>DURATION [5F] ^ (#5) CONJUNCTION [6S] ^ (#6) ROUTE
 . ; ==>[7P:51.2] ^ (#7) SCHEDULE [8F] ^ (#8) VERB [9F] ^
 . ;
 . N DIRNUM S DIRNUM=0 ; Sigline number
 . S DIRCNT=0 ; COUNT OF MULTIPLE DIRECTIONS
 . F  S DIRNUM=$O(^PSRX(RXIEN,6,DIRNUM)) Q:DIRNUM=""  D
 . . S DIRCNT=DIRCNT+1 ; INCREMENT DIRECTIONS COUNT
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRECTIONDESCRIPTIONTEXT")=""  ; This is reserved for systems not able to generate the sig in components.
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDOSEINDICATOR")="1"  ; means that we are specifying it. See E2369-05.
 . . N SIGDATA S SIGDATA=^PSRX(RXIEN,6,DIRNUM,0)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDELIVERYMETHOD")=$P(SIGDATA,U,9)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDOSEVALUE")=$P(SIGDATA,U,1)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDOSEUNIT")=@MAP@("MEDCONCUNIT")
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDRATEVALUE")=""  ; For inpatient
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDRATEUNIT")=""  ; For inpatient
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDVEHICLETEXT")=""  ; For inpatient
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRECTIONROUTETEXT")=$$GET1^DIQ(51.2,$P(SIGDATA,U,7),.01)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDFREQUENCYVALUE")=$P(SIGDATA,U,8)
 . . ; Invervals... again another call.
 . . ; In the wisdom of the original programmers, the schedule is a free text field
 . . ; However, it gets translated by a call to the administration schedule file
 . . ; to see if that schedule exists.
 . . ; That's the same thing I am going to do.
 . . ; The call is AP^PSS51P1(PSSPP,PSSFT,PSSWDIEN,PSSSTPY,LIST,PSSFREQ).
 . . ; PSSPP is "PSJ" (for some reason, schedules are stored as PSJ, not PSO--
 . . ; I looked), PSSFT is the name, and list is the ^TMP name to store the data in.
 . . ; So...
 . . D AP^PSS51P1("PSJ",$P(SIGDATA,U,8),,,"SCHEDULE")
 . . N SCHEDATA M SCHEDATA=^TMP($J,"SCHEDULE")
 . . N INTERVAL
 . . I $P(SCHEDATA(0),U)=-1 S INTERVAL=""
 . . E  D
 . . . N SUB S SUB=$O(SCHEDATA(0))
 . . . S INTERVAL=SCHEDATA(SUB,2)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDINTERVALVALUE")=INTERVAL
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDINTERVALUNIT")="Minute"
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDURATIONVALUE")=$P(SIGDATA,U,5)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDURATIONUNIT")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPRNFLAG")=$P(SIGDATA,U,8)["PRN"
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMOBJECTID")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMTYPETXT")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMDESCRIPTION")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMCODEVALUE")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMCODINGSYSTEM")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMCODINGVERSION")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDPROBLEMSOURCEACTORID")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDSTOPINDICATOR")=""
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDDIRSEQ")=DIRNUM
 . . N DIRMOD S DIRMOD=$P(SIGDATA,U,6)
 . . S @MAP@("M","DIRECTIONS",DIRCNT,"MEDMULDIRMOD")=$S(DIRMOD="T":"THEN",DIRMOD="A":"AND",DIRMOD="X":"EXCEPT",1:"")
 . ;
 . ; --- END OF DIRECTIONS ---
 . ;
 . ; ^PSRX(22,"INS1",1,0)="FOR BLOOD PRESSURE"
 . S @MAP@("MEDPTINSTRUCTIONS")=$G(^PSRX(RXIEN,"INS1",1,0))
 . ; ^PSRX(22,"PRC",1,0)="Pharmacist: you must obey my command"
 . S @MAP@("MEDFULLFILLMENTINSTRUCTIONS")=$G(^PSRX(RXIEN,"PRC",1,0))
 . S @MAP@("MEDRFNO")=MED(9)
 . N RESULT S RESULT=$NA(^TMP("C0CCCR",$J,"MAPPED"))
 . K @RESULT
 . D MAP^C0CXPATH(MINXML,MAP,RESULT)
 . ; MAPPING DIRECTIONS
 . N DIRXML1 S DIRXML1="MEDDIR1" ; VARIABLE AND NAME VARIABLE TEMPLATE
 . N DIRXML2 S DIRXML2="MEDDIR2" ; VARIABLE AND NAME VARIABLE RESULT
 . D QUERY^C0CXPATH(MINXML,"//Medications/Medication/Directions",DIRXML1)
 . D REPLACE^C0CXPATH(RESULT,"","//Medications/Medication/Directions")
 . ; N MDZ1,MDZNA
 . I DIRCNT>0 D  ; IF THERE ARE DIRCTIONS
 . . F MDZ1=1:1:DIRCNT  D  ; FOR EACH DIRECTION
 . . . S MDZNA=$NA(@MAP@("M","DIRECTIONS",MDZ1))
 . . . D MAP^C0CXPATH(DIRXML1,MDZNA,DIRXML2)
 . . . D INSERT^C0CXPATH(RESULT,DIRXML2,"//Medications/Medication")
 . I MEDCOUNT=1 D CP^C0CXPATH(RESULT,OUTXML) ; First one is a copy
 . E  D INSINNER^C0CXPATH(OUTXML,RESULT) ; AFTER FIRST, INSERT INNER XML
 N MEDTMP,MEDI
 D MISSING^C0CXPATH(OUTXML,"MEDTMP") ; SEARCH XML FOR MISSING VARS
 I MEDTMP(0)>0 D  ; IF THERE ARE MISSING VARS - MARKED AS @@X@@
 . W "MEDICATION MISSING ",!
 . F MEDI=1:1:MEDTMP(0) W MEDTMP(MEDI),!
 Q
 ;
