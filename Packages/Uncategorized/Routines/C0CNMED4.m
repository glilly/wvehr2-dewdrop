C0CMED4         ; WV/CCDCCR/SMH/gpl - CCR/CCD PROCESSING FOR MEDICATIONS - Inpatient Meds/Unit Dose ;10/13/08
 ;;0.1;CCDCCR;;;Build 2
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
EXTRACT(MINXML,DFN,OUTXML,MEDCOUNT) ; EXTRACT MEDICATIONS INTO PROVIDED XML TEMPLATE
 ;
 ; this routine has be adapted to retrieve meds from GET^NHINV by gpl 6/2011
 ;
 ; MINXML is the Input XML Template, passed by name
 ; DFN is Patient IEN
 ; OUTXML is the resultant XML.
 ;
 ; MEDS is return array from API.
 ; MED is holds each array element from MEDS, one medicine
 ; MAP is a mapping variable map (store result) for each med
 ;
 ; Inpatient Meds will be extracted using this routine and and the one following.
 ; Inpatient Meds Unit Dose is going to be C0CMED4
 ; Inpatient Meds IVs is going to be C0CMED5
 ;
 ; We will use two Pharmacy ReEnginnering API's:
 ; PSS431^PSS55(DFN,PO,PSDATE,PEDATE,LIST) - provides most info
 ; PSS432^PSS55(DFN,PO,LIST) - provides schedule info
 ; For more information, see the PRE documentation at:
 ; http://www.va.gov/vdl/documents/Clinical/Pharm-Inpatient_Med/phar_1_api_r0807.pdf
 ;
 ; Med data is stored in Unit Dose multiple of file 55, pharmacy patient
 ;
 N MEDS,MAP
 ;K ^TMP($J)
 ;D PSS431^PSS55(DFN,,,,"UD") ; Output is in ^TMP($J,"UD",*)
 ;I ^TMP($J,"UD",0)'>0 S @OUTXML@(0)=0 QUIT  ; No Meds - Quit
 ;; Otherwise, we go on...
 D EN^C0CNHIN(.MEDS,DFN,"MED;") ; gpl get the NHIN Array of meds
 I '$D(MEDS) Q  ; no meds
 N ZI S ZI=""
 N ZCOUNT S ZCOUNT=0
 F  S ZI=$O(MEDS("med",ZI)) Q:ZI=""  D  ; for each returned med
 . I $G(MEDS("med",ZI,"vaType@value"))="I" S ZCOUNT=ZCOUNT+1
 IF ZCOUNT=0 Q  ; no inpatient meds
 ;M MEDS=^TMP($J,"UD")
 I DEBUG ZWR MEDS
 S MEDMAP=$NA(^TMP("C0CCCR",$J,"MEDMAP"))
 ;N MEDCOUNT S MEDCOUNT=@MEDMAP@(0) ; We already have meds in the array
 N I S I=0
 F  S I=$O(MEDS("med",I)) Q:'I  D  ; For each medication
 . N MED M MED=MEDS("med",I)
 . I $G(MED("vaType@value"))'="I" Q  ; not inpatient
 . S MEDCOUNT=MEDCOUNT+1
 . S @MEDMAP@(0)=MEDCOUNT ; Update MedMap array counter
 . S MAP=$NA(^TMP("C0CCCR",$J,"MEDMAP",MEDCOUNT))
 . ;N RXIEN S RXIEN=MED(.01) ; Order Number
 . N RXIEN S RXIEN=$G(MED("orderID@value")) ; ien of the med
 . I DEBUG W "RXIEN IS ",RXIEN,!
 . I DEBUG W "MAP= ",MAP,!
 . S @MAP@("MEDOBJECTID")="MED_INPATIENT_UD"_RXIEN
 . S @MAP@("MEDISSUEDATETXT")="Order Date"
 . ;S @MAP@("MEDISSUEDATE")=$$FMDTOUTC^C0CUTIL($P(MED(27),U),"DT")
 . S @MAP@("MEDISSUEDATE")=$$FMDTOUTC^C0CUTIL($G(MED("start@value")),"DT")
 . S @MAP@("MEDLASTFILLDATETXT")="" ; For Outpatient
 . S @MAP@("MEDLASTFILLDATE")="" ; For Outpatient
 . S @MAP@("MEDRXNOTXT")="" ; For Outpatient
 . S @MAP@("MEDRXNO")="" ; For Outpatient
 . S @MAP@("MEDTYPETEXT")="Medication"
 . S @MAP@("MEDDETAILUNADORNED")=""  ; Leave blank, field has its uses
 . ;S @MAP@("MEDSTATUSTEXT")="ACTIVE"
 . N C0CMST S C0CMST=$G(MED("vaStatus@value")) ; need to filter status
 . I C0CMST="EXPIRED" S C0CMST="Prior History No Longer Active"
 . I C0CMST="ACTIVE" S C0CMST="Active" ;
 . S @MAP@("MEDSTATUSTEXT")=C0CMST
 . ;S @MAP@("MEDSOURCEACTORID")="ACTORPROVIDER_"_$P(MED(1),U)
 . S @MAP@("MEDSOURCEACTORID")="ACTORPROVIDER_"_$G(MED("orderingProvider@code"))
 . ;S @MAP@("MEDPRODUCTNAMETEXT")=MED("DDRUG",1,.01)
 . S @MAP@("MEDPRODUCTNAMETEXT")=$G(MED("name@value"))
 . ; NDC is field 31 in the drug file.
 . ; The actual drug entry in the drug file is not necessarily supplied.
 . ; It' node 1, internal form.
 . ;N MEDIEN S MEDIEN=MED(1,"I")
 . ;S @MAP@("MEDPRODUCTNAMECODEVALUE")=$S($L(MEDIEN):$$GET1^DIQ(50,MEDIEN,31,"E"),1:"")
 . N ZVUID S ZVUID=$G(MED("products.product.vaProduct@vuid")) ; VUID
 . N ZC,ZCD,ZCDS,ZCDSV ; CODE,CODE SYSTEM,CODE VERSION
 . D  ;
 . . S ZC=$$CODE^C0CUTIL(ZVUID)
 . . S ZCD=$P(ZC,"^",1) ; CODE TO USE
 . . S ZCDS=$P(ZC,"^",2) ; CODING SYSTEM - RXNORM OR VUID
 . . S ZCDSV=$P(ZC,"^",3) ; CODING SYSTEM VERSION
 . ;N ZRXNORM S ZRXNORM=""
 . ;S ZRXNORM=$$RXNCUI3^C0PLKUP(ZVUID)
 . S @MAP@("MEDPRODUCTNAMECODEVALUE")=ZCD
 . ;S @MAP@("MEDPRODUCTNAMECODINGINGSYSTEM")=$S($L(MEDIEN):"NDC",1:"")
 . S @MAP@("MEDPRODUCTNAMECODINGINGSYSTEM")=ZCDS
 . ;S @MAP@("MEDPRODUCTNAMECODEVERSION")=$S($L(MEDIEN):"none",1:"")
 . S @MAP@("MEDPRODUCTNAMECODEVERSION")=ZCDSV
 . S @MAP@("MEDBRANDNAMETEXT")=""
 . S @MAP@("MEDPRODUCTNAMETEXT")=$G(MED("name@value"))_" "_ZCDS_": "_ZCD
 . ;I $L(MEDIEN) D DOSE^PSS50(MEDIEN,,,,,"DOSE")
 . ;I $L(MEDIEN) N DOSEDATA M DOSEDATA=^TMP($J,"DOSE",MEDIEN)
 . ;S @MAP@("MEDSTRENGTHVALUE")=$S($L(MEDIEN):DOSEDATA(901),1:"")
 . S @MAP@("MEDSTRENGTHVALUE")=$G(MED("doses.dose@dose"))
 . ;S @MAP@("MEDSTRENGTHUNIT")=$S($P(DOSEDATA(902),U,2),1:"")
 . S @MAP@("MEDSTRENGTHUNIT")=$G(MED("doses.dose@units"))
 . ; Units, concentration, etc, come from another call
 . ; $$CPRS^PSNAPIS which returns dosage-form^va class^strengh^unit
 . ; This call takes nodes 1 and 3 of ^PSDRUG(D0,"ND") as parameters
 . ; NDF Entry IEN, and VA Product Name
 . ; These can be obtained using NDF^PSS50 (IEN,,,,,"SUBSCRIPT")
 . ; Documented in the same manual.
 . ;N NDFDATA,CONCDATA
 . ;I $L(MEDIEN) D
 . ;. D NDF^PSS50(MEDIEN,,,,,"CONC")
 . ;. M NDFDATA=^TMP($J,"CONC",MEDIEN)
 . ;. N NDFIEN S NDFIEN=$P(NDFDATA(20),U)
 . ;. N VAPROD S VAPROD=$P(NDFDATA(22),U)
 . ;. ; If a drug was not matched to NDF, then the NDFIEN is gonna be ""
 . ;. ; and this will crash the call. So...
 . ;. I NDFIEN="" S CONCDATA=""
 . ;. E  S CONCDATA=$$CPRS^PSNAPIS(NDFIEN,VAPROD)
 . ;E  S (NDFDATA,CONCDATA)="" ; This line is defensive programming to prevent undef errors.
 . ;S @MAP@("MEDFORMTEXT")=$S($L(MEDIEN):$P(CONCDATA,U,1),1:"")
 . S @MAP@("MEDFORMTEXT")=$G(MED("form@value"))
 . ;S @MAP@("MEDCONCVALUE")=$S($L(MEDIEN):$P(CONCDATA,U,3),1:"")
 . S @MAP@("MEDCONCVALUE")=$G(MED("doses.dose@dose"))
 . ;S @MAP@("MEDCONCUNIT")=$S($L(MEDIEN):$P(CONCDATA,U,4),1:"")
 . S @MAP@("MEDCONCUNIT")=$G(MED("doses.does@units"))
 . ;S @MAP@("MEDQUANTITYVALUE")=""  ; not provided for in Non-VA meds.
 . S @MAP@("MEDQUANTITYVALUE")=$G(MED("doses.dose@unitsPerDose")) ;
 . ; Oddly, there is no easy place to find the dispense unit.
 . ; It's not included in the original call, so we have to go to the drug file.
 . ; That would be DATA^PSS50(IEN,,,,,"SUBSCRIPT")
 . ; Node 14.5 is the Dispense Unit
 . ;I $L(MEDIEN) D
 . ;. D DATA^PSS50(MEDIEN,,,,,"QTY")
 . ;. N QTYDATA M QTYDATA=^TMP($J,"QTY",MEDIEN)
 . ;. S @MAP@("MEDQUANTITYUNIT")=QTYDATA(14.5)
 . ;E  S @MAP@("MEDQUANTITYUNIT")=""
 . S @MAP@("MEDQUANTITYUNIT")=$G(MED("dose.dose@unitsPerDose"))
 . ;
 . ; --- START OF DIRECTIONS ---
 . ; Dosage is field 2, route is 3, schedule is 4
 . ; These are all free text fields, and don't point to any files
 . ; For that reason, I will use the field I never used before:
 . ; MEDDIRECTIONDESCRIPTIONTEXT
 . ;S @MAP@("M","DIRECTIONS",1,"MEDDIRECTIONDESCRIPTIONTEXT")=MED(2,"E")_" "_MED(3,"E")_" "_MED(4,"E")
 . S @MAP@("M","DIRECTIONS",1,"MEDDIRECTIONDESCRIPTIONTEXT")=$G(MED("sig"))
 . ; $G(MED("products.product.vaProduct@name"))
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
 . ; S @MAP@("MEDPTINSTRUCTIONS","F")="52.41^105"
 . ;S @MAP@("MEDPTINSTRUCTIONS")=MED(10,1) ; WP Field
 . S @MAP@("MEDPTINSTRUCTIONS")=""
 . ;S @MAP@("MEDFULLFILLMENTINSTRUCTIONS")=MED(14,1) ; WP Field
 . S @MAP@("MEDFULLFILLMENTINSTRUCTIONS")=""
 . S @MAP@("MEDRFNO")=""
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
 . N DIRCNT S DIRCNT=1 ; THERE ARE ALWAYS DIRECTIONS
 . I DIRCNT>0 D  ; IF THERE ARE DIRCTIONS
 . . F MDZ1=1:1:DIRCNT  D  ; FOR EACH DIRECTION
 . . . S MDZNA=$NA(@MAP@("M","DIRECTIONS",MDZ1))
 . . . D MAP^C0CXPATH(DIRXML1,MDZNA,DIRXML2)
 . . . D INSERT^C0CXPATH(RESULT,DIRXML2,"//Medications/Medication")
 . D:MEDCOUNT=1 CP^C0CXPATH(RESULT,OUTXML) ; First one is a copy
 . D:MEDCOUNT>1 INSINNER^C0CXPATH(OUTXML,RESULT) ; AFTER THE FIRST, INSERT INNER XML
 N MEDTMP,MEDI
 D MISSING^C0CXPATH(OUTXML,"MEDTMP") ; SEARCH XML FOR MISSING VARS
 I MEDTMP(0)>0 D  ; IF THERE ARE MISSING VARS - MARKED AS @@X@@
 . W "MEDICATION MISSING ",!
 . F MEDI=1:1:MEDTMP(0) W MEDTMP(MEDI),!
 Q
 ;
