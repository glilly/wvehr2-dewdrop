C0SLAB    ; GPL - Smart Lab Processing ;4/15/12  17:05
        ;;0.1;C0S;nopatch;noreleasedate;Build 1
        ;Copyright 2012 George Lilly.  Licensed under the terms of the GNU
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
        Q
        ;
        ; sample VistA NHIN lab result
        ;
        ;^TMP("C0STBL",32,"lab",8,"collected@value")=3110626.16
        ;^TMP("C0STBL",32,"lab",8,"comment")="Report Released Date/Time: Jun 26, 2011@19:00"
        ;^TMP("C0STBL",32,"lab",8,"comment@xml:space")="preserve"
        ;^TMP("C0STBL",32,"lab",8,"facility@code")=100
        ;^TMP("C0STBL",32,"lab",8,"facility@name")="VOE OFFICE INSTITUTION"
        ;^TMP("C0STBL",32,"lab",8,"groupName@value")="CH 0626 47"
        ;^TMP("C0STBL",32,"lab",8,"high@value")=" 101"
        ;^TMP("C0STBL",32,"lab",8,"id@value")="CH;6889372.84;67003"
        ;^TMP("C0STBL",32,"lab",8,"interpretation@value")="H"
        ;^TMP("C0STBL",32,"lab",8,"labOrderID@value")=336
        ;^TMP("C0STBL",32,"lab",8,"localName@value")="FBLDGLU"
        ;^TMP("C0STBL",32,"lab",8,"loinc@value")="14771-0"
        ;^TMP("C0STBL",32,"lab",8,"low@value")="69 "
        ;^TMP("C0STBL",32,"lab",8,"orderID@value")=807
        ;^TMP("C0STBL",32,"lab",8,"result@value")=178
        ;^TMP("C0STBL",32,"lab",8,"resulted@value")=3110626.190006
        ;^TMP("C0STBL",32,"lab",8,"sample@value")="SERUM"
        ;^TMP("C0STBL",32,"lab",8,"specimen@code")="0X500"
        ;^TMP("C0STBL",32,"lab",8,"specimen@name")="SERUM"
        ;^TMP("C0STBL",32,"lab",8,"status@value")="completed"
        ;^TMP("C0STBL",32,"lab",8,"test@value")="FASTING BLOOD GLUCOSE"
        ;^TMP("C0STBL",32,"lab",8,"type@value")="CH"
        ;^TMP("C0STBL",32,"lab",8,"units@value")="MG/DL"
        ;^TMP("C0STBL",32,"lab",8,"vuid@value")=4656342
        ;
        ; sample Smart lab result triples
        ;
        ;G("loinc:29571-7","dcterms:identifier")="29571-7"
        ;G("loinc:29571-7","dcterms:title")="Phe DBS Ql"
        ;G("loinc:29571-7","rdf:type")="sp:Code"
        ;G("loinc:29571-7","sp:system")="http://loinc.org/codes/"
        ;G("loinc:38478-4","dcterms:identifier")="38478-4"
        ;G("loinc:38478-4","dcterms:title")="Biotinidase DBS Ql"
        ;G("loinc:38478-4","rdf:type")="sp:Code"
        ;G("loinc:38478-4","sp:system")="http://loinc.org/codes/"
        ;G("qqWZZIew993","rdf:type")="sp:Attribution"
        ;G("qqWZZIew993","sp:startDate")="2007-04-21"
        ;G("qqWZZIew994","rdf:type")="sp:NarrativeResult"
        ;G("qqWZZIew994","sp:value")="Normal"
        ;G("qqWZZIew995","dcterms:title")="Biotinidase DBS Ql"
        ;G("qqWZZIew995","rdf:type")="sp:CodedValue"
        ;G("qqWZZIew995","sp:code")="loinc:38478-4"
        ;G("qqWZZIew997","rdf:type")="sp:Attribution"
        ;G("qqWZZIew997","sp:startDate")="2007-09-08"
        ;G("qqWZZIew998","rdf:type")="sp:NarrativeResult"
        ;G("qqWZZIew998","sp:value")="Normal"
        ;G("qqWZZIew999","dcterms:title")="Phe DBS Ql"
        ;G("qqWZZIew999","rdf:type")="sp:CodedValue"
        ;G("qqWZZIew999","sp:code")="loinc:29571-7"
        ;G("smart:99912345/lab_results/3d9b39249193","rdf:type")="sp:LabResult"
        ;G("smart:99912345/lab_results/3d9b39249193","sp:belongsTo")="smart:99912345"
        ;G("smart:99912345/lab_results/3d9b39249193","sp:labName")="qqWZZIew995"
        ;G("smart:99912345/lab_results/3d9b39249193","sp:narrativeResult")="qqWZZIew994"
        ;G("smart:99912345/lab_results/3d9b39249193","sp:specimenCollected")="qqWZZIew993"
        ;G("smart:99912345/lab_results/426c7adc4f54","rdf:type")="sp:LabResult"
        ;G("smart:99912345/lab_results/426c7adc4f54","sp:belongsTo")="smart:99912345"
        ;G("smart:99912345/lab_results/426c7adc4f54","sp:labName")="qqWZZIew999"
        ;G("smart:99912345/lab_results/426c7adc4f54","sp:narrativeResult")="qqWZZIew998"
        ;G("smart:99912345/lab_results/426c7adc4f54","sp:specimenCollected")="qqWZZIew997"
        ;
        ;
        ;  another Smart example, this one with sp:quantitativeResult
        ;
        ;G("loinc:786-4","dcterms:identifier")="786-4"
        ;G("loinc:786-4","dcterms:title")="MCHC RBC Auto-mCnc"
        ;G("loinc:786-4","rdf:type")="sp:Code"
        ;G("loinc:786-4","sp:system")="http://loinc.org/codes/"
        ;G("nodeID:4439","rdf:type")="sp:ValueAndUnit"
        ;G("nodeID:4439","sp:unit")="g/dL"
        ;G("nodeID:4439","sp:value")=36.6
        ;G("nodeID:4613","rdf:type")="sp:ValueAndUnit"
        ;G("nodeID:4613","sp:unit")="g/dL"
        ;G("nodeID:4613","sp:value")=32
        ;G("nodeID:4672","rdf:type")="sp:Attribution"
        ;G("nodeID:4672","sp:startDate")="2005-03-10"
        ;G("nodeID:4866","rdf:type")="sp:ValueAndUnit"
        ;G("nodeID:4866","sp:unit")="g/dL"
        ;G("nodeID:4866","sp:value")=36
        ;G("nodeID:4871","dcterms:title")="MCHC RBC Auto-mCnc"
        ;G("nodeID:4871","rdf:type")="sp:CodedValue"
        ;G("nodeID:4871","sp:code")="loinc:786-4"
        ;G("nodeID:5221","rdf:type")="sp:QuantitativeResult"
        ;G("nodeID:5221","sp:normalRange")="nodeID:5282"
        ;G("nodeID:5221","sp:valueAndUnit")="nodeID:4439"
        ;G("nodeID:5282","rdf:type")="sp:ValueRange"
        ;G("nodeID:5282","sp:maximum")="nodeID:4866"
        ;G("nodeID:5282","sp:minimum")="nodeID:4613"
        ;G("smart:1540505/lab_results/2fc100850766","rdf:type")="sp:LabResult"
        ;G("smart:1540505/lab_results/2fc100850766","sp:belongsTo")="smart:1540505"
        ;G("smart:1540505/lab_results/2fc100850766","sp:labName")="nodeID:4871"
        ;G("smart:1540505/lab_results/2fc100850766","sp:quantitativeResult")="nodeID:5221"
        ;G("smart:1540505/lab_results/2fc100850766","sp:specimenCollected")="nodeID:4672"
        ;
LAB(GRTN,C0SARY)        ; GRTN, passed by reference,
        ; is the return name of the graph created. "" if none
        ; C0SARY is passed in by reference and is the NHIN array of lab
        ;
        I $O(C0SARY("lab",""))="" D  Q  ;
        . I $D(DEBUG) W !,"No Labs"
        S GRTN="" ; default to no labs
        N C0SGRF
        S C0SGRF="vistaSmart:"_ZPATID_"/lab_results"
        I $D(DEBUG) W !,"Processing ",C0SGRF
        D DELGRAPH^C0XF2N(C0SGRF) ; delete the old graph
        D INITFARY^C0XF2N("C0XFARY") ; which triple store to use
        N FARY S FARY="C0XFARY"
        D USEFARY^C0XF2N(FARY)
        D VOCINIT^C0XUTIL
        ;
        D STARTADD^C0XF2N ; initialize to create triples
        ;
        N ZI S ZI=""
        F  S ZI=$O(C0SARY("lab",ZI)) Q:ZI=""  D  ;
        . N LRN,ZR ; ZR is the local array for building the new triples
        . S LRN=$NA(C0SARY("lab",ZI)) ; base for values in this lab result
        . ;
        . N RSLTID ; unique Id for this lab result
        . S RSLTID=C0SGRF_"/"_$$LKY17^C0XF2N ; use a random number
        . ;
        . ; i don't like this because the same labs result gets a
        . ; different ID every time it's reported. Can't trace it back to VistA
        . ; I'd rather be using id@value ie "id@value")="CH;6889372.84;67003"
        . ; .. either that or store an OID with the lab result - but that
        . ; will have to wait for the redesign of file 60.. - gpl 4/16/2012
        . ;
        . N LOINC S LOINC=$G(@LRN@("loinc@value"))
        . I LOINC="" D  Q  ;
        . . I $D(DEBUG) W !,"NO LOINC VALUE, SKIPPING"
        . N LABTST S LABTST=$G(@LRN@("test@value"))
        . I $D(DEBUG) D  ;
        . . W !,"Processing Lab Result ",RSLTID
        . . W !,"test: ",LABTST
        . . W !,"loinc: ",LOINC
        . ;
        . ; first do the base result graph
        . ;
        . S ZR("rdf:type")="sp:LabResult"
        . S ZR("sp:belongsTo")=C0SGRF ; the subject for this patient's lab results
        . ; ie /vista/smart/99912345/lab_results
        . ;
        . N LABNAME S LABNAME=$$ANONS^C0XF2N ; new node for lab name
        . S ZR("sp:labName")=LABNAME
        . ;
        . N NARRSLT S NARRSLT=$$ANONS^C0XF2N ; new node for narrative result
        . S ZR("sp:narrativeResult")=NARRSLT
        . ;
        . N QNTRSLT S QNTRSLT=$$ANONS^C0XF2N ; new node for narrative result
        . S ZR("sp:quantitativeResult")=QNTRSLT
        . ;
        . N SPECCOLL S SPECCOLL=$$ANONS^C0XF2N ; new node for specimen collected
        . S ZR("sp:specimenCollected")=SPECCOLL
        . ;
        . D ADDINN^C0XF2N(C0SGRF,RSLTID,.ZR) ; addIfNotNull the triples
        . K ZR ; clean up
        . ;
        . ; create the narrative result graph
        . ;
        . N IVAL S IVAL=$G(@LRN@("interpretation@value"))'="" D  ; H OR L
        . I IVAL'=""
        . . S ZR("rdf:type")="sp:NarrativeResult"
        . . S ZR("sp:value")=$G(@LRN@("interpretation@value")) ; H or L
        . . I ZR("sp:value")="L" S ZR("sp:value")="abnormal"
        . . I ZR("sp:value")="H" S ZR("sp:value")="abnormal"
        . . I ZR("sp:value")="HH" S ZR("sp:value")="critical"
        . . I ZR("sp:value")="LL" S ZR("sp:value")="critical"
        . . D ADDINN^C0XF2N(C0SGRF,NARRSLT,.ZR)
        . . K ZR
        . ;
        . ; create the quantitative result graph
        . ; 
        . S ZR("rdf:type")="sp:QuantitativeResult"
        . N NORMNM S NORMNM=$$ANONS^C0XF2N ; new node for normal range graph
        . N VUNM S VUNM=$$ANONS^C0XF2N ; new node for value and unit graph
        . N HASNORMAL S HASNORMAL=0
        . I $G(@LRN@("high@value"))'="" S HASNORMAL=1
        . I HASNORMAL S ZR("sp:normalRange")=NORMNM
        . S ZR("sp:valueAndUnit")=VUNM
        . D ADDINN^C0XF2N(C0SGRF,QNTRSLT,.ZR)
        . K ZR
        . ;
        . ; create the normal range graph
        . ;
        . I HASNORMAL D  ; 
        . . S ZR("rdf:type")="sp:ValueRange"
        . . N MAXNM S MAXNM=$$ANONS^C0XF2N ; new node for maximum graph
        . . N MINNM S MINNM=$$ANONS^C0XF2N ; new node for minimum graph
        . . S ZR("sp:maximum")=MAXNM
        . . S ZR("sp:minimum")=MINNM
        . . D ADDINN^C0XF2N(C0SGRF,NORMNM,.ZR)
        . . K ZR
        . . ;
        . . ; create the maximum graph
        . . ; 
        . . S ZR("rdf:type")="sp:ValueAndUnit"
        . . S ZR("sp:unit")=$G(@LRN@("units@value"))
        . . S ZR("sp:value")=$G(@LRN@("high@value"))
        . . D ADDINN^C0XF2N(C0SGRF,MAXNM,.ZR)
        . . K ZR
        . . ;
        . . ; create the minimum graph
        . . ; 
        . . S ZR("rdf:type")="sp:ValueAndUnit"
        . . S ZR("sp:unit")=$G(@LRN@("units@value"))
        . . S ZR("sp:value")=$G(@LRN@("low@value"))
        . . D ADDINN^C0XF2N(C0SGRF,MINNM,.ZR)
        . . K ZR
        . ;
        . ; create the value and unit graph
        . ;
        . S ZR("rdf:type")="sp:ValueAndUnit"
        . S ZR("sp:unit")=$G(@LRN@("units@value"))
        . I ZR("sp:unit")="" S ZR("sp:unit")=$G(@LRN@("test@value"))
        . S ZR("sp:value")=$G(@LRN@("result@value"))
        . D ADDINN^C0XF2N(C0SGRF,VUNM,.ZR)
        . K ZR
        . ;
        . ; create specimen collected graph
        . ; 
        . S ZR("rdf:type")="sp:Attribution"
        . S ZR("sp:startDate")=$$SPDATE^C0SUTIL($G(@LRN@("collected@value")))
        . D ADDINN^C0XF2N(C0SGRF,SPECCOLL,.ZR)
        . K ZR
        . ;
        . ; create lab name graph - this contains the test name and code
        . ;
        . I LOINC'="" D  ;
        . . S ZR("rdf:type")="sp:CodedValue"
        . . S ZR("dcterms:title")=LABTST
        . . N LOINCNM S LOINCNM="loinc:"_LOINC
        . . S ZR("sp:code")="loinc:"_LOINC
        . . D ADDINN^C0XF2N(C0SGRF,LABNAME,.ZR)
        . . K ZR
        . . S ZR("dcterms:identifier")=LOINC
        . . S ZR("dcterms:title")=LABTST
        . . S ZR("rdf:type")="sp:Code"
        . . S ZR("sp:system")="http://loinc.org/codes/"
        . . D ADDINN^C0XF2N(C0SGRF,LOINCNM,.ZR)
        . . K ZR
        . ;
        . ; that's all for now folks (there is more to do like reference ranges
        . ; and result values)
        . ;
        D BULKLOAD^C0XF2N(.C0XFDA)
        S GRTN=C0SGRF
        Q
        ;
SAMPLE  ; import sample lab tests to the triplestore
        N GN
        S GN=$NA(^rdf("lab_results"))
        D INSRDF^C0XF2N(GN,"/smart/lab/samples")
        Q
        ;
