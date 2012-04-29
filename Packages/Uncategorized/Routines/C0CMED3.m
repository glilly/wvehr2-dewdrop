C0CMED3 ; WV/CCDCCR/SMH - Meds: Non-VA/Outside Meds for Vista
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;;Last Modified: Sun Jan 11 05:45:03 UTC 2009
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
EXTRACT(MINXML,DFN,OUTXML,MEDCOUNT) ; Extract medications into provided xml template
 ;
 ; MINXML is the Input XML Template, (passed by name)
 ; DFN is Patient IEN (passed by value)
 ; OUTXML is the resultant XML (passed by name)
 ; MEDCOUNT is the number of Meds extracted so far (passed by reference)
 ;
 ; MEDS is return array from RPC.
 ; MAP is a mapping variable map (store result) for each med
 ; MED is holds each array element from MEDS, one medicine
 ;
 ; Non-VA meds don't have an API. They are stored in file 55, subfile 52.2
 ; Discontinued meds are indicated by the presence of a value in fields
 ; 5 or 6 (STATUS 1 or 2, and DISCONTINUED DATE)
 ; Will use Fileman API GETS^DIQ
 ;
 N MEDS,MAP
 K ^TMP($J,"CCDCCR") ; PLEASE DON'T KILL ALL OF ^TMP($J) HERE!!!!
 N NVA
 D GETS^DIQ(55,DFN,"52.2*","IE","NVA") ; Output in NVA in FDA array format.
 ; If NVA does not exist, then patient has no non-VA meds
 I $D(NVA)=0 S @OUTXML@(0)=0 QUIT
 ; Otherwise, we go on...
 M MEDS=NVA(55.05)
 ; We are done with NVA
 K NVA
 ;
 I DEBUG ZWRITE MEDS
 N FDAIEN S FDAIEN=0 ; For use in $Order in the MEDS array.
 N MEDFIRST S MEDFIRST=1 ; FLAG FOR FIRST MED PROCESSED HERE
 F  S FDAIEN=$O(MEDS(FDAIEN)) Q:FDAIEN=""  D  ; FOR EACH MEDICATION IN THE LIST
 . N MED M MED=MEDS(FDAIEN)
 . I MED(5,"I")!MED(6,"I") QUIT  ; If disconinued, we don't want to pull it.
 . S MEDCOUNT=MEDCOUNT+1
 . S MAP=$NA(^TMP("C0CCCR",$J,"MEDMAP",MEDCOUNT))
 . N RXIEN S RXIEN=$P(FDAIEN,",") ; First piece of FDAIEN is the number of the med for this patient
 . I DEBUG W "RXIEN IS ",RXIEN,!
 . I DEBUG W "MAP= ",MAP,!
 . S @MAP@("MEDOBJECTID")="MED_OUTSIDE"_MEDCOUNT ; MEDCOUNT FOR ID
 . S @MAP@("MEDISSUEDATETXT")="Documented Date"
 . ; Field 6 is "Effective date", and we pull it in timson format w/ I
 . S @MAP@("MEDISSUEDATE")=$$FMDTOUTC^C0CUTIL(MED(11,"I"),"DT")
 . ; Med never filled; next 4 fields are not applicable.
 . S @MAP@("MEDLASTFILLDATETXT")=""
 . S @MAP@("MEDLASTFILLDATE")=""
 . S @MAP@("MEDRXNOTXT")=""
 . S @MAP@("MEDRXNO")=""
 . S @MAP@("MEDTYPETEXT")="Medication"
 . S @MAP@("MEDDETAILUNADORNED")=""  ; Leave blank, field has its uses
 . S @MAP@("MEDSTATUSTEXT")="Active" ; nearest status for pending meds
 . S @MAP@("MEDSOURCEACTORID")="ACTORPROVIDER_"_MED(12,"I")
 . S @MAP@("MEDPRODUCTNAMETEXT")=MED(.01,"E")
 . ; NDC is field 31 in the drug file.
 . ; The actual drug entry in the drug file (MEDIEN) is not necessarily supplied.
 . ; It' node 1, internal form.
 . N MEDIEN S MEDIEN=MED(1,"I")
 . I +MEDIEN D  ; start of if/else block
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
 . . ; NDF^PSS50 ONLY EXISTS ON VISTA
 . . N NDFDATA,NDFIEN,VAPROD
 . . S NDFIEN=""
 . . I '$$RPMS^C0CUTIL() D
 . . . D NDF^PSS50(MEDIEN,,,,,"NDF")
 . . . ;N NDFDATA M NDFDATA=^TMP($J,"NDF",MEDIEN)
 . . . ;N NDFIEN S NDFIEN=$P(NDFDATA(20),U)
 . . . ;N VAPROD S VAPROD=$P(NDFDATA(22),U)
 . . . M NDFDATA=^TMP($J,"NDF",MEDIEN)
 . . . S NDFIEN=$P(NDFDATA(20),U)
 . . . S VAPROD=$P(NDFDATA(22),U)
 . . . S @MAP@("MEDPRODUCTNAMETEXT")=$$GET1^DIQ(50.68,VAPROD,.01) ;
 . . ; GPL - RESET THE NAME TO THE REAL NAME OF THE DRUG NOW THAT WE
 . . ;   HAVE IT.
 . . ;
 . . ; NDFIEN is not necessarily defined; it won't be if the drug
 . . ; is not matched to the national drug file (e.g. if the drug is
 . . ; new on the market, compounded, or is a fake drug [blue pill].
 . . ; To protect against failure, I will put an if/else block
 . . N VUID,RXNIEN,RXNORM,SRCIEN,RXNNAME,RXNVER
 . . ;
 . . ; begin changes for systems that have eRx installed
 . . ; RxNorm is found in the ^C0P("RXN") global - gpl
 . . ;
 . . N ZC,ZCD,ZCDS,ZCDSV ; CODE,CODE SYSTEM,CODE VERSION
 . . S (ZC,ZCD,ZCDS,ZCDSV)="" ; INITIALIZE
 . . S (RXNORM,RXNNAME,RXNVER)="" ;INITIALIZE
 . . I NDFIEN,$D(^C0P("RXN")) D  ;
 . . . S VUID=$$GET1^DIQ(50.68,VAPROD,99.99)
 . . . S ZC=$$CODE^C0CUTIL(VUID)
 . . . S ZCD=$P(ZC,"^",1) ; CODE TO USE
 . . . S ZCDS=$P(ZC,"^",2) ; CODING SYSTEM - RXNORM OR VUID
 . . . S ZCDSV=$P(ZC,"^",3) ; CODING SYSTEM VERSION
 . . . S RXNORM=ZCD ; THE CODE
 . . . S RXNNAME=ZCDS ; THE CODING SYSTEM
 . . . S RXNVER=ZCDSV ; THE CODING SYSTEM VERSION
 . . . N ZGMED S ZGMED=@MAP@("MEDPRODUCTNAMETEXT")
 . . . S @MAP@("MEDPRODUCTNAMETEXT")=ZGMED_" "_ZCDS_": "_ZCD
 . . E  I NDFIEN,$D(^C0CRXN) D  ; $Data is for Systems that don't have our RxNorm file yet.
 . . . S VUID=$$GET1^DIQ(50.68,VAPROD,99.99)
 . . . S RXNIEN=$$FIND1^DIC(176.001,,,VUID,"VUID")
 . . . S RXNORM=$$GET1^DIQ(176.001,RXNIEN,.01)
 . . . S SRCIEN=$$FIND1^DIC(176.003,,"B","RXNORM")
 . . . S RXNNAME=$$GET1^DIQ(176.003,SRCIEN,6)
 . . . S RXNVER=$$GET1^DIQ(176.003,SRCIEN,7)
 . . ;
 . . ;E  S (RXNORM,RXNNAME,RXNVER)=""
 . . ; End if/else block
 . . S @MAP@("MEDPRODUCTNAMECODEVALUE")=RXNORM
 . . S @MAP@("MEDPRODUCTNAMECODINGINGSYSTEM")=RXNNAME
 . . S @MAP@("MEDPRODUCTNAMECODEVERSION")=RXNVER
 . . ;
 . . S @MAP@("MEDBRANDNAMETEXT")=""
 . . ; DOSE^PSS50 ONLY ESISTS ON VISTA
 . . I '$$RPMS^C0CUTIL() D
 . . . D DOSE^PSS50(MEDIEN,,,,,"DOSE")
 . . . N DOSEDATA M DOSEDATA=^TMP($J,"DOSE",MEDIEN)
 . . . S @MAP@("MEDSTRENGTHVALUE")=DOSEDATA(901)
 . . . S @MAP@("MEDSTRENGTHUNIT")=$P(DOSEDATA(902),U,2)
 . . E  S @MAP@("MEDSTRENGTHVALUE")="" S @MAP@("MEDSTRENGTHUNIT")=""
 . . ; Units, concentration, etc, come from another call
 . . ; $$CPRS^PSNAPIS which returns dosage-form^va class^strengh^unit
 . . ; This call takes nodes 1 and 3 of ^PSDRUG(D0,"ND") as parameters
 . . ; NDF Entry IEN, and VA Product Name
 . . ; These can be obtained using NDF^PSS50 (IEN,,,,,"SUBSCRIPT")
 . . ; Documented in the same manual; executed above.
 . . ;
 . . ; If a drug was not matched to NDF, then the NDFIEN is gonna be ""
 . . ; and this will crash the call. So...
 . . I NDFIEN="" S CONCDATA=""
 . . E  S CONCDATA=$$CPRS^PSNAPIS(NDFIEN,VAPROD)
 . . S @MAP@("MEDFORMTEXT")=$P(CONCDATA,U,1)
 . . S @MAP@("MEDCONCVALUE")=$P(CONCDATA,U,3)
 . . S @MAP@("MEDCONCUNIT")=$P(CONCDATA,U,4)
 . . S @MAP@("MEDQUANTITYVALUE")=""  ; not provided for in Non-VA meds.
 . . ; Oddly, there is no easy place to find the dispense unit.
 . . ; It's not included in the original call, so we have to go to the drug file.
 . . ; That would be DATA^PSS50(IEN,,,,,"SUBSCRIPT")
 . . ; Node 14.5 is the Dispense Unit
 . . ; PSS50 ONLY EXISTS ON VISTA
 . . I '$$RPMS^C0CUTIL() D
 . . . D DATA^PSS50(MEDIEN,,,,,"QTY")
 . . . N QTYDATA M QTYDATA=^TMP($J,"QTY",MEDIEN)
 . . . S @MAP@("MEDQUANTITYUNIT")=QTYDATA(14.5)
 . . E  S @MAP@("MEDQUANTITYUNIT")=""
 . . S @MAP@("MEDQUANTITYUNIT")="" ; don't show these
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
 . ; End If/Else
 . ; --- START OF DIRECTIONS ---
 . ; Dosage is field 2, route is 3, schedule is 4
 . ; These are all free text fields, and don't point to any files
 . ; For that reason, I will use the field I never used before:
 . ; MEDDIRECTIONDESCRIPTIONTEXT
 . S DIRCNT=1 ; THERE IS ONLY ONE DIRECTION FOR OUTSIDE MEDS
 . ;
 . ; change for eRx meds - gpl 6/25/2011
 . ;
 . N ZERX S ZERX=MED(2,"E")_" "_MED(3,"E")_" "_MED(4,"E")
 . I ZERX["|" S ZERX=$P(ZERX,"|",2) ; GET RID OF MED NAME
 . S @MAP@("M","DIRECTIONS",1,"MEDDIRECTIONDESCRIPTIONTEXT")=ZERX
 . N ZERX2 S ZERX2=$P(MED(2,"E"),"|",2) ; sig for quantity
 . N ZFDBDRUG S ZFDBDRUG=$P(MED(2,"E"),"|",1) ; FDB DRUG NAME
 . I @MAP@("MEDPRODUCTNAMETEXT")["FREE TXT" D  ; FIX THE DRUG NAME
 . . S @MAP@("MEDPRODUCTNAMETEXT")=ZFDBDRUG ; USE FDB NAME
 . . S RXNORM=$P($P($G(MED(14,7)),"RXNORM:",2)," ",1) ; THE RXNORM
 . . S RXNORM=$$NISTMAP^C0CUTIL(RXNORM) ; CHANGE IF NECESSARY
 . . I RXNORM'="" D  ;
 . . . W !,"FOUND FREE TEXT RXNORM:",RXNORM
 . . . S RXNNAME="RXNORM" ; THE CODING SYSTEM
 . . . S RXNVER="" ; THE CODING SYSTEM VERSION
 . . . N ZGMED S ZGMED=@MAP@("MEDPRODUCTNAMETEXT")
 . . . S @MAP@("MEDPRODUCTNAMETEXT")=ZGMED_" "_RXNNAME_": "_RXNORM
 . . . S @MAP@("MEDPRODUCTNAMECODEVALUE")=RXNORM
 . . . S @MAP@("MEDPRODUCTNAMECODINGINGSYSTEM")=RXNNAME
 . . . S @MAP@("MEDPRODUCTNAMECODEVERSION")=RXNVER
 . . . I RXNORM["979334" D  ; PATCH FOR CERTIFICATION
 . . . . S @MAP@("MEDSTRENGTHVALUE")=650
 . . . . S @MAP@("MEDSTRENGTHUNIT")="mcg"
 . . . . S @MAP@("MEDFORMTEXT")="INHALER"
 . S @MAP@("MEDQUANTITYUNIT")=$P(ZERX2," ",3) ; THE UNITS
 . S @MAP@("MEDQUANTITYVALUE")=$P(ZERX2," ",2) ; THE QUANTITY
 . I @MAP@("MEDFORMTEXT")="" S @MAP@("MEDFORMTEXT")=$P(ZERX2," ",3) ;
 . ;S @MAP@("M","DIRECTIONS",1,"MEDDIRECTIONDESCRIPTIONTEXT")=MED(2,"E")_" "_MED(3,"E")_" "_MED(4,"E")
 . S @MAP@("M","DIRECTIONS",1,"MEDDOSEINDICATOR")="4"  ; means look in description text. See E2369-05.
 . S @MAP@("M","DIRECTIONS",1,"MEDDELIVERYMETHOD")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDDOSEVALUE")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDDOSEUNIT")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDRATEVALUE")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDRATEUNIT")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDVEHICLETEXT")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDDIRECTIONROUTETEXT")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDFREQUENCYVALUE")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDINTERVALVALUE")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDINTERVALUNIT")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDDURATIONVALUE")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDDURATIONUNIT")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDPRNFLAG")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDPROBLEMOBJECTID")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDPROBLEMTYPETXT")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDPROBLEMDESCRIPTION")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDPROBLEMCODEVALUE")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDPROBLEMCODINGSYSTEM")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDPROBLEMCODINGVERSION")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDPROBLEMSOURCEACTORID")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDSTOPINDICATOR")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDDIRSEQ")=""
 . S @MAP@("M","DIRECTIONS",1,"MEDMULDIRMOD")=""
 . ;
 . ; --- END OF DIRECTIONS ---
 . ;
 . S @MAP@("MEDRFNO")=""
 . I $D(MED(14,1)) D  ;
 . . S @MAP@("MEDFULLFILLMENTINSTRUCTIONS")=MED(14,1) ; WP Field
 . E  S @MAP@("MEDFULLFILLMENTINSTRUCTIONS")=""
 . S @MAP@("MEDFULLFILLMENTINSTRUCTIONS")="" ; don't put in these - gpl
 . N RESULT S RESULT=$NA(^TMP("C0CCCR",$J,"MAPPED"))
 . K @RESULT
 . D MAP^C0CXPATH(MINXML,MAP,RESULT)
 . ; D PARY^C0CXPATH(RESULT)
 . ; MAPPING DIRECTIONS
 . N MEDDIR1,DIRXML1 S DIRXML1="MEDDIR1" ; VARIABLE AND NAME VARIABLE TEMPLATE
 . N MEDDIR2,DIRXML2 S DIRXML2="MEDDIR2" ; VARIABLE AND NAME VARIABLE RESULT
 . D QUERY^C0CXPATH(MINXML,"//Medications/Medication/Directions",DIRXML1)
 . D REPLACE^C0CXPATH(RESULT,"","//Medications/Medication/Directions")
 . N MDZ1,MDZNA
 . I DIRCNT>0 D  ; IF THERE ARE DIRCTIONS
 . . F MDZ1=1:1:DIRCNT  D  ; FOR EACH DIRECTION
 . . . S MDZNA=$NA(@MAP@("M","DIRECTIONS",MDZ1))
 . . . D MAP^C0CXPATH(DIRXML1,MDZNA,DIRXML2)
 . . . D INSERT^C0CXPATH(RESULT,DIRXML2,"//Medications/Medication")
 . ;
 . ; MAP PATIENT INSTRUCTIONS - HAVE TO DO THIS AFTER MAPPING DIRECTIONS DUE TO XML SCHEMA VALIDATION
 . N MEDINT1,INTXML1 S INTXML1="MENINT1" ; VARIABLE AND NAME VARIABLE TEMPLATE
 . N MEDINT2,INTXML2 S INTXML2="MEDINT2" ; VARIABLE AND NAME VARIABLE RESULT
 . D QUERY^C0CXPATH(MINXML,"//Medications/Medication/PatientInstructions",INTXML1)
 . D REPLACE^C0CXPATH(RESULT,"","//Medications/Medication/PatientInstructions")
 . ;N MDI1 ; removing the "I" which is not in the protocol gpl 1/2010
 . ;S MDI1=$NA(@MAP@("I"))
 . ; S @MAP@("MEDPTINSTRUCTIONS","F")="52.41^105"
 . I $D(MED(10,1)) D  ;
 . . ;S @MAP@("I","MEDPTINSTRUCTIONS")=$P(MED(10,1),"  ",1) ; WP Field
 . . S @MAP@("MEDPTINSTRUCTIONS")=$P(MED(10,1),"  ",1) ; WP Field
 . E  S @MAP@("MEDPTINSTRUCTIONS")=""
 . ;E  S @MAP@("I","MEDPTINSTRUCTIONS")=""
 . ;D MAP^C0CXPATH(INTXML1,MDI1,INTXML2)
 . D MAP^C0CXPATH(INTXML1,MAP,INTXML2) ; JUST MAP WORKS.. GPL
 . D INSERT^C0CXPATH(RESULT,INTXML2,"//Medications/Medication")
 . ;
 . ; FLAG HAS TO BE RESET OUTSIDE THE IF STATMENT.
 . ;I MEDFIRST D  ;
 . ;. S MEDFIRST=0 ; RESET FIRST FLAG
 . ;. D CP^C0CXPATH(RESULT,OUTXML) ; First one is a copy
 . ;D:'MEDFIRST INSINNER^C0CXPATH(OUTXML,RESULT) ; AFTER FIRST, INSERT INNER XML
 . D:MEDFIRST CP^C0CXPATH(RESULT,OUTXML) ; First one is a copy
 . D:'MEDFIRST INSINNER^C0CXPATH(OUTXML,RESULT) ; AFTER THE FIRST, INSERT INNER XML
 . I MEDFIRST S MEDFIRST=0
 N MEDTMP,MEDI
 D MISSING^C0CXPATH(OUTXML,"MEDTMP") ; SEARCH XML FOR MISSING VARS
 I MEDTMP(0)>0 D  ; IF THERE ARE MISSING VARS - MARKED AS @@X@@
 . W "MEDICATION MISSING ",!
 . F MEDI=1:1:MEDTMP(0) W MEDTMP(MEDI),!
 Q
 ;
