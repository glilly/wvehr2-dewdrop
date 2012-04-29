C0CMED ; WV/CCDCCR/GPL/SMH - CCR/CCD Medications Driver; Mar 23 2009
 ;;1.0;C0C;;May 19, 2009;Build 2
 ; Copyright 2008,2009 George Lilly, University of Minnesota and Sam Habiel.
 ; Licensed under the terms of the GNU General Public License.
 ; See attached copy of the License.
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
 ; --Revision History
 ; July 2008 - Initial Version/GPL
 ; July 2008 - March 2009 various revisions
 ; March 2009 - Reconstruction of routine as driver for other med routines/SMH
 ; June 2011 - Redone to support all meds using the FOIA NHIN routines/gpl
 ;
 Q
 ;
 ; THIS VERSION IS DEPRECATED BECAUSE IT DOES NOT GENEREATE XML IN
 ; THE RIGHT ORDER... AND IT HAS TO BE IN THE RIGHT ORDER... :(
 ; GPL
 ;
EXTRACT(MEDXML,DFN,MEDOUTXML) ; Private; Extract medications into provided XML template
 ; DFN passed by reference
 ; MEDXML and MEDOUTXML are passed by Name
 ; MEDXML is the input template
 ; MEDOUTXML is the output template
 ; Both of them refer to ^TMP globals where the XML documents are stored
 ;
 N GN
 D EN^C0CNHIN(.GN,DFN,"MED;",1) ; RETRIEVE NHIN ARRAY OF MEDS
 ; this call uses GET^NHINV to retrieve xml of the meds and then
 ; parses with MXML and uses DOMO^C0CDOM to extract an NHIN array
 ;
 ; we now create an NHIN Array of the Meds section of the CCR
 ;
 N ZI S ZI=""
 F  S ZI=$O(GN("med",ZI)) Q:ZI=""  D  ; for each med
 . N GA S GA=$NA(GN("med",ZI))
 . N GM S GM="Medication" ; to keep the lines shorter
 . S GC(GM,ZI,"CCRDataObjectID")="MED_"_ZI
 . N ZD,ZD2 S ZD=$G(@GA@("ordered@value")) ; FILEMAN DATE
 . I ZD="" S ZD=$G(@GA@("start@value")) ; for inpatient meds
 . S ZD2=$$FMDTOUTC^C0CUTIL(ZD,"DT")
 . S GC(GM,ZI,"DateTime[1].ExactDateTime")=ZD2
 . S GC(GM,ZI,"DateTime[1].Type.Text")="Documented Date"
 . ;S GC(GM,ZI,"DateTime[2].ExactDateTime")=""
 . ;S GC(GM,ZI,"DateTime[2].Type.Text")=""
 . N GSIG S GSIG=$G(@GA@("sig"))
 . I GSIG["|" S GSIG=$P(GSIG,"|",2) ; eRx has name of drug separated by |
 . S GC(GM,ZI,"Description.Text")=GSIG
 . N GD S GD="Directions.Direction" ; MAKING THE STRINGS SHORTER
 . ;S GC(GM,ZI,GD_".DeliveryMethod.Text")="@@MEDDELIVERYMETHOD@@"
 . ;S GC(GM,ZI,GD_".Description.Text")=""
 . ;S GC(GM,ZI,GD_".DirectionSequenceModifier")="@@MEDDIRSEQ@@"
 . ;S GC(GM,ZI,GD_".Dose.Rate.Units.Unit")="@@MEDRATEUNIT@@"
 . ;S GC(GM,ZI,GD_".Dose.Rate.Value")="@@MEDRATEVALUE@@"
 . ;S GC(GM,ZI,GD_".Dose.Units.Unit")="@@MEDDOSEUNIT@@"
 . ;S GC(GM,ZI,GD_".Dose.Value")="@@MEDDOSEVALUE@@"
 . ;S GC(GM,ZI,GD_".DoseIndicator.Text")="@@MEDDOSEINDICATOR@@"
 . ;S GC(GM,ZI,GD_".Duration.Units.Unit")="@@MEDDURATIONUNIT@@"
 . ;S GC(GM,ZI,GD_".Duration.Value")="@@MEDDURATIONVALUE@@"
 . ;S GC(GM,ZI,GD_".Frequency.Value")="@@MEDFREQUENCYVALUE@@"
 . ;S GC(GM,ZI,GD_".Indication.PRNFlag.Text")="@@MEDPRNFLAG@@"
 . ;S GC(GM,ZI,GD_".Indication.Problem.CCRDataObjectID")=""
 . ;S GC(GM,ZI,GD_".Indication.Problem.Description.Code.CodingSystem")=""
 . ;S GC(GM,ZI,GD_".Indication.Problem.Description.Code.Value")=""
 . ;S GC(GM,ZI,GD_".Indication.Problem.Description.Code.Version")=""
 . ;S GC(GM,ZI,GD_".Indication.Problem.Description.Text")=""
 . ;S GC(GM,ZI,GD_".Indication.Problem.Source.Actor.ActorID")=""
 . ;S GC(GM,ZI,GD_".Indication.Problem.Type.Text")=""
 . ;S GC(GM,ZI,GD_".Interval.Units.Unit")="@@MEDINTERVALUNIT@@"
 . ;S GC(GM,ZI,GD_".Interval.Value")="@@MEDINTERVALVALUE@@"
 . ;S GC(GM,ZI,GD_".MultipleDirectionModifier.Text")="@@MEDMULDIRMOD@@"
 . S GC(GM,ZI,GD_".Route.Text")=$G(@GA@("doses.dose@route"))
 . ;S GC(GM,ZI,GD_".StopIndicator.Text")="@@MEDSTOPINDICATOR@@"
 . ;S GC(GM,ZI,GD_".Vehicle.Text")="@@MEDVEHICLETEXT@@"
 . ;S GC(GM,ZI,"FullfillmentInstructions.Text")=""
 . ;S GC(GM,ZI,"IDs.ID")="@@MEDRXNO@@"
 . ;S GC(GM,ZI,"IDs.Type.Text")="@@MEDRXNOTXT@@"
 . ;S GC(GM,ZI,"PatientInstructions.Instruction.Text")="@@MEDPTINSTRUCTIONS@@"
 . ;S GC(GM,ZI,"Product.BrandName.Text")="@@MEDBRANDNAMETEXT@@"
 . S GC(GM,ZI,"Product.Concentration.Units.Unit")=$G(@GA@("doses.dose@units"))
 . S GC(GM,ZI,"Product.Concentration.Value")=$G(@GA@("doses.dose@dose"))
 . S GC(GM,ZI,"Product.Form.Text")=$G(@GA@("form@value"))
 . N GV S GV=$G(@GA@("products.product.vaProduct@vuid"))
 . N GR S GR=$$RXNCUI3^C0PLKUP(GV)
 . S GC(GM,ZI,"Product.ProductName.Code.CodingSystem")=$S(GR:"RxNorm",1:"VUID")
 . S GC(GM,ZI,"Product.ProductName.Code.Value")=$S(GR:GR,1:GV)
 . S GC(GM,ZI,"Product.ProductName.Code.Version")="08AB_081201F"
 . S GC(GM,ZI,"Product.ProductName.Text")=$G(@GA@("name@value"))
 . S GC(GM,ZI,"Product.Strength.Units.Unit")=$G(@GA@("doses.dose@units"))
 . S GC(GM,ZI,"Product.Strength.Value")=$G(@GA@("doses.dose@dose"))
 . ;S GC(GM,ZI,"Quantity.Units.Unit")="@@MEDQUANTITYUNIT@@"
 . ;S GC(GM,ZI,"Quantity.Value")="@@MEDQUANTITYVALUE@@"
 . ;S GC(GM,ZI,"Refills.Refill.Number")="@@MEDRFNO@@"
 . N GDUZ S GDUZ=$G(@GA@("orderingProvider@code")) ;PROVIDER DUZ
 . S GC(GM,ZI,"Source.Actor.ActorID")="PROVIDER_"_GDUZ
 . S GC(GM,ZI,"Status.Text")=$G(@GA@("status@value"))
 . S GC(GM,ZI,"Type.Text")="Medication"
 N C0CDOCID
 S C0CDOCID=$$DOMI^C0CDOM("GC",,"Medications") ; insert to dom
 D OUTXML^C0CDOM(MEDOUTXML,C0CDOCID,1) ; render the xml
 N ZSIZE S ZSIZE=$O(@MEDOUTXML@(""),-1)
 S @MEDOUTXML@(0)=ZSIZE ; RETURN STATUS IS NUMBER OF LINES OF XML
 W !,MEDOUTXML
 ;ZWR GN
 ;ZWR GC
 ;B
 Q
 ;
