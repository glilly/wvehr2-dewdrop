C0SPROB   ; GPL - Smart Problem Processing ;5/01/12  17:05
        ;;1.0;VISTA SMART CONTAINER;;Sep 26, 2012;Build 5
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
        ; sample VistA NHIN problem list
        ;
        ;^TMP("C0STBL",91,"problem",1,"acuity@value")="C"
        ;^TMP("C0STBL",91,"problem",1,"entered@value")=3110531
        ;^TMP("C0STBL",91,"problem",1,"facility@code")=100
        ;^TMP("C0STBL",91,"problem",1,"facility@name")="VOE OFFICE INSTITUTION"
        ;^TMP("C0STBL",91,"problem",1,"icd@value")=414.9
        ;^TMP("C0STBL",91,"problem",1,"id@value")=100
        ;^TMP("C0STBL",91,"problem",1,"location@value")="DR OFFICE"
        ;^TMP("C0STBL",91,"problem",1,"name@value")="Coronary Artery Disease"
        ;^TMP("C0STBL",91,"problem",1,"onset@value")=3100201
        ;^TMP("C0STBL",91,"problem",1,"provider@code")=63
        ;^TMP("C0STBL",91,"problem",1,"provider@name")="KING,MATTHEW MICHAEL"
        ;^TMP("C0STBL",91,"problem",1,"removed@value")=0
        ;^TMP("C0STBL",91,"problem",1,"sc@value")=0
        ;^TMP("C0STBL",91,"problem",1,"status@value")="A"
        ;^TMP("C0STBL",91,"problem",1,"unverified@value")=0
        ;^TMP("C0STBL",91,"problem",1,"updated@value")=3110531
        ;^TMP("C0STBL",91,"problem",2,"acuity@value")="C"
        ;^TMP("C0STBL",91,"problem",2,"entered@value")=3110602
        ;^TMP("C0STBL",91,"problem",2,"facility@code")=100
        ;^TMP("C0STBL",91,"problem",2,"facility@name")="VOE OFFICE INSTITUTION"
        ;^TMP("C0STBL",91,"problem",2,"icd@value")=780.2
        ;^TMP("C0STBL",91,"problem",2,"id@value")=108
        ;^TMP("C0STBL",91,"problem",2,"name@value")="Syncope and collapse"
        ;^TMP("C0STBL",91,"problem",2,"onset@value")=3110102
        ;^TMP("C0STBL",91,"problem",2,"provider@code")=63
        ;^TMP("C0STBL",91,"problem",2,"provider@name")="KING,MATTHEW MICHAEL"
        ;^TMP("C0STBL",91,"problem",2,"removed@value")=0
        ;^TMP("C0STBL",91,"problem",2,"sc@value")=0
        ;^TMP("C0STBL",91,"problem",2,"status@value")="A"
        ;^TMP("C0STBL",91,"problem",2,"unverified@value")=0
        ;^TMP("C0STBL",91,"problem",2,"updated@value")=3110602
        ;^TMP("C0STBL",91,"problem",3,"acuity@value")="C"
        ;^TMP("C0STBL",91,"problem",3,"entered@value")=3110602
        ;^TMP("C0STBL",91,"problem",3,"facility@code")=100
        ;^TMP("C0STBL",91,"problem",3,"facility@name")="VOE OFFICE INSTITUTION"
        ;^TMP("C0STBL",91,"problem",3,"icd@value")=433.91
        ;^TMP("C0STBL",91,"problem",3,"id@value")=109
        ;^TMP("C0STBL",91,"problem",3,"name@value")="Occlusion and Stenosis of Unspecifid Precerebral Artery with Cerebral Infarctio"
        ;^TMP("C0STBL",91,"problem",3,"onset@value")=3100101
        ;^TMP("C0STBL",91,"problem",3,"provider@code")=63
        ;^TMP("C0STBL",91,"problem",3,"provider@name")="KING,MATTHEW MICHAEL"
        ;^TMP("C0STBL",91,"problem",3,"removed@value")=0
        ;^TMP("C0STBL",91,"problem",3,"sc@value")=0
        ;^TMP("C0STBL",91,"problem",3,"status@value")="A"
        ;^TMP("C0STBL",91,"problem",3,"unverified@value")=0
        ;^TMP("C0STBL",91,"problem",3,"updated@value")=3110602
        ;^TMP("C0STBL",91,"problem",4,"entered@value")=3110603
        ;^TMP("C0STBL",91,"problem",4,"facility@code")=100
        ;^TMP("C0STBL",91,"problem",4,"facility@name")="VOE OFFICE INSTITUTION"
        ;^TMP("C0STBL",91,"problem",4,"icd@value")="00.66"
        ;^TMP("C0STBL",91,"problem",4,"id@value")=115
        ;^TMP("C0STBL",91,"problem",4,"location@value")="DR OFFICE"
        ;^TMP("C0STBL",91,"problem",4,"name@value")="00.66"
        ;^TMP("C0STBL",91,"problem",4,"provider@code")=63
        ;^TMP("C0STBL",91,"problem",4,"provider@name")="KING,MATTHEW MICHAEL"
        ;^TMP("C0STBL",91,"problem",4,"removed@value")=0
        ;^TMP("C0STBL",91,"problem",4,"status@value")="A"
        ;^TMP("C0STBL",91,"problem",4,"unverified@value")=0
        ;^TMP("C0STBL",91,"problem",4,"updated@value")=3110603
        ;^TMP("C0STBL",91,"problem",5,"entered@value")=3110603
        ;^TMP("C0STBL",91,"problem",5,"facility@code")=100
        ;^TMP("C0STBL",91,"problem",5,"facility@name")="VOE OFFICE INSTITUTION"
        ;^TMP("C0STBL",91,"problem",5,"icd@value")=37.21
        ;^TMP("C0STBL",91,"problem",5,"id@value")=116
        ;^TMP("C0STBL",91,"problem",5,"location@value")="DR OFFICE"
        ;^TMP("C0STBL",91,"problem",5,"name@value")=37.21
        ;^TMP("C0STBL",91,"problem",5,"provider@code")=63
        ;^TMP("C0STBL",91,"problem",5,"provider@name")="KING,MATTHEW MICHAEL"
        ;^TMP("C0STBL",91,"problem",5,"removed@value")=0
        ;^TMP("C0STBL",91,"problem",5,"status@value")="A"
        ;^TMP("C0STBL",91,"problem",5,"unverified@value")=0
        ;^TMP("C0STBL",91,"problem",5,"updated@value")=3110603
        ;^TMP("C0STBL",91,"problem",6,"entered@value")=3110603
        ;^TMP("C0STBL",91,"problem",6,"facility@code")=100
        ;^TMP("C0STBL",91,"problem",6,"facility@name")="VOE OFFICE INSTITUTION"
        ;^TMP("C0STBL",91,"problem",6,"icd@value")=81.51
        ;^TMP("C0STBL",91,"problem",6,"id@value")=117
        ;^TMP("C0STBL",91,"problem",6,"location@value")="DR OFFICE"
        ;^TMP("C0STBL",91,"problem",6,"name@value")=81.51
        ;^TMP("C0STBL",91,"problem",6,"provider@code")=63
        ;^TMP("C0STBL",91,"problem",6,"provider@name")="KING,MATTHEW MICHAEL"
        ;^TMP("C0STBL",91,"problem",6,"removed@value")=0
        ;^TMP("C0STBL",91,"problem",6,"status@value")="A"
        ;^TMP("C0STBL",91,"problem",6,"unverified@value")=0
        ;^TMP("C0STBL",91,"problem",6,"updated@value")=3110603
        ;^TMP("C0STBL",91,"problem",7,"entered@value")=3110603
        ;^TMP("C0STBL",91,"problem",7,"facility@code")=100
        ;^TMP("C0STBL",91,"problem",7,"facility@name")="VOE OFFICE INSTITUTION"
        ;^TMP("C0STBL",91,"problem",7,"icd@value")=47.09
        ;^TMP("C0STBL",91,"problem",7,"id@value")=118
        ;^TMP("C0STBL",91,"problem",7,"location@value")="DR OFFICE"
        ;^TMP("C0STBL",91,"problem",7,"name@value")=47.09
        ;^TMP("C0STBL",91,"problem",7,"provider@code")=63
        ;^TMP("C0STBL",91,"problem",7,"provider@name")="KING,MATTHEW MICHAEL"
        ;^TMP("C0STBL",91,"problem",7,"removed@value")=0
        ;^TMP("C0STBL",91,"problem",7,"status@value")="A"
        ;^TMP("C0STBL",91,"problem",7,"unverified@value")=0
        ;^TMP("C0STBL",91,"problem",7,"updated@value")=3110603
        ;^TMP("C0STBL",91,"problem",8,"entered@value")=3110603
        ;^TMP("C0STBL",91,"problem",8,"facility@code")=100
        ;^TMP("C0STBL",91,"problem",8,"facility@name")="VOE OFFICE INSTITUTION"
        ;^TMP("C0STBL",91,"problem",8,"icd@value")="250.00"
        ;^TMP("C0STBL",91,"problem",8,"id@value")=119
        ;^TMP("C0STBL",91,"problem",8,"location@value")="DR OFFICE"
        ;^TMP("C0STBL",91,"problem",8,"name@value")="Diabetes Mellitus without mentionof Complication, type II or unspecified type,"
        ;^TMP("C0STBL",91,"problem",8,"provider@code")=63
        ;^TMP("C0STBL",91,"problem",8,"provider@name")="KING,MATTHEW MICHAEL"
        ;^TMP("C0STBL",91,"problem",8,"removed@value")=0
        ;^TMP("C0STBL",91,"problem",8,"status@value")="A"
        ;^TMP("C0STBL",91,"problem",8,"unverified@value")=0
        ;^TMP("C0STBL",91,"problem",8,"updated@value")=3110603
        ;
        ; sample Smart lab result triples
        ;
        ;G("node16rk1fgdvx10882","code")="snomed:40930008"
        ;G("node16rk1fgdvx10882","dcterms:title")="Hypothyroidism"
        ;G("node16rk1fgdvx10882","rdf:type")="sp:CodedValue"
        ;G("node16rk1fgdvx11051","code")="snomed:188155002"
        ;G("node16rk1fgdvx11051","dcterms:title")="Primary malignant neoplasm of lower outer quadrant of female breast"
        ;G("node16rk1fgdvx11051","rdf:type")="sp:CodedValue"
        ;G("node16rk1fgdvx11073","code")="snomed:353295004"
        ;G("node16rk1fgdvx11073","dcterms:title")="Toxic diffuse goiter"
        ;G("node16rk1fgdvx11073","rdf:type")="sp:CodedValue"
        ;G("node16rk1fgdvx11089","code")="snomed:54302000"
        ;G("node16rk1fgdvx11089","dcterms:title")="Disorder of breast"
        ;G("node16rk1fgdvx11089","rdf:type")="sp:CodedValue"
        ;G("node16rk1fgdvx11351","code")="snomed:38341003"
        ;G("node16rk1fgdvx11351","dcterms:title")="Essential hypertension"
        ;G("node16rk1fgdvx11351","rdf:type")="sp:CodedValue"
        ;G("node16rk1fgdvx11390","code")="snomed:44054006"
        ;G("node16rk1fgdvx11390","dcterms:title")="Diabetes mellitus type 2"
        ;G("node16rk1fgdvx11390","rdf:type")="sp:CodedValue"
        ;G("node16rk1fgdvx11558","code")="snomed:195967001"
        ;G("node16rk1fgdvx11558","dcterms:title")="Asthma"
        ;G("node16rk1fgdvx11558","rdf:type")="sp:CodedValue"
        ;G("node16rk1fgdvx11578","code")="snomed:254837009"
        ;G("node16rk1fgdvx11578","dcterms:title")="Primary malignant neoplasm of female breast"
        ;G("node16rk1fgdvx11578","rdf:type")="sp:CodedValue"
        ;G("node16rk1fgdvx11687","code")="snomed:8517006"
        ;G("node16rk1fgdvx11687","dcterms:title")="History of tobacco use"
        ;G("node16rk1fgdvx11687","rdf:type")="sp:CodedValue"
        ;G("node16rk1fgdvx11716","code")="snomed:55822004"
        ;G("node16rk1fgdvx11716","dcterms:title")="Hyperlipidemia"
        ;G("node16rk1fgdvx11716","rdf:type")="sp:CodedValue"
        ;G("smart:1577780/problems/69560e4721e1","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/69560e4721e1","problemName")="node16rk1fgdvx11089"
        ;G("smart:1577780/problems/69560e4721e1","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/69560e4721e1","startDate")="2005-08-02"
        ;G("smart:1577780/problems/06ef10c4e92c","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/06ef10c4e92c","problemName")="node16rk1fgdvx11051"
        ;G("smart:1577780/problems/06ef10c4e92c","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/06ef10c4e92c","startDate")="2006-02-20"
        ;G("smart:1577780/problems/9894ba9dfe5a","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/9894ba9dfe5a","problemName")="node16rk1fgdvx11578"
        ;G("smart:1577780/problems/9894ba9dfe5a","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/9894ba9dfe5a","startDate")="2005-08-22"
        ;G("smart:1577780/problems/c109aa7a0675","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/c109aa7a0675","problemName")="node16rk1fgdvx11558"
        ;G("smart:1577780/problems/c109aa7a0675","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/c109aa7a0675","startDate")="2005-09-22"
        ;G("smart:1577780/problems/1c50100614a2","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/1c50100614a2","problemName")="node16rk1fgdvx11073"
        ;G("smart:1577780/problems/1c50100614a2","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/1c50100614a2","startDate")="2007-02-21"
        ;G("smart:1577780/problems/083dffb2c4a0","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/083dffb2c4a0","problemName")="node16rk1fgdvx11390"
        ;G("smart:1577780/problems/083dffb2c4a0","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/083dffb2c4a0","startDate")="2007-01-07"
        ;G("smart:1577780/problems/762b5639a2d1","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/762b5639a2d1","problemName")="node16rk1fgdvx11687"
        ;G("smart:1577780/problems/762b5639a2d1","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/762b5639a2d1","startDate")="2006-02-20"
        ;G("smart:1577780/problems/9dc9053dd6f4","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/9dc9053dd6f4","problemName")="node16rk1fgdvx11716"
        ;G("smart:1577780/problems/9dc9053dd6f4","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/9dc9053dd6f4","startDate")="2008-04-08"
        ;G("smart:1577780/problems/e3fe9b7ee552","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/e3fe9b7ee552","problemName")="node16rk1fgdvx10882"
        ;G("smart:1577780/problems/e3fe9b7ee552","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/e3fe9b7ee552","startDate")="2005-10-27"
        ;G("smart:1577780/problems/9933307e8f95","belongsTo")="smart:1577780"
        ;G("smart:1577780/problems/9933307e8f95","problemName")="node16rk1fgdvx11351"
        ;G("smart:1577780/problems/9933307e8f95","rdf:type")="sp:Problem"
        ;G("smart:1577780/problems/9933307e8f95","startDate")="2005-08-22"
        ;G("snomed:188155002","dcterms:identifier")=188155002
        ;G("snomed:188155002","dcterms:title")="Primary malignant neoplasm of lower outer quadrant of female breast"
        ;G("snomed:188155002","rdf:type")="sp:Code"
        ;G("snomed:188155002","system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        ;G("snomed:195967001","dcterms:identifier")=195967001
        ;G("snomed:195967001","dcterms:title")="Asthma"
        ;G("snomed:195967001","rdf:type")="sp:Code"
        ;G("snomed:195967001","system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        ;G("snomed:254837009","dcterms:identifier")=254837009
        ;G("snomed:254837009","dcterms:title")="Primary malignant neoplasm of female breast"
        ;G("snomed:254837009","rdf:type")="sp:Code"
        ;G("snomed:254837009","system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        ;G("snomed:353295004","dcterms:identifier")=353295004
        ;G("snomed:353295004","dcterms:title")="Toxic diffuse goiter"
        ;G("snomed:353295004","rdf:type")="sp:Code"
        ;G("snomed:353295004","system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        ;G("snomed:38341003","dcterms:identifier")=38341003
        ;G("snomed:38341003","dcterms:title")="Essential hypertension"
        ;G("snomed:38341003","rdf:type")="sp:Code"
        ;G("snomed:38341003","system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        ;G("snomed:40930008","dcterms:identifier")=40930008
        ;G("snomed:40930008","dcterms:title")="Hypothyroidism"
        ;G("snomed:40930008","rdf:type")="sp:Code"
        ;G("snomed:40930008","system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        ;G("snomed:44054006","dcterms:identifier")=44054006
        ;G("snomed:44054006","dcterms:title")="Diabetes mellitus type 2"
        ;G("snomed:44054006","rdf:type")="sp:Code"
        ;G("snomed:44054006","system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        ;G("snomed:54302000","dcterms:identifier")=54302000
        ;G("snomed:54302000","dcterms:title")="Disorder of breast"
        ;G("snomed:54302000","rdf:type")="sp:Code"
        ;G("snomed:54302000","system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        ;G("snomed:55822004","dcterms:identifier")=55822004
        ;G("snomed:55822004","dcterms:title")="Hyperlipidemia"
        ;G("snomed:55822004","rdf:type")="sp:Code"
        ;G("snomed:55822004","system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        ;G("snomed:8517006","dcterms:identifier")=8517006
        ;G("snomed:8517006","dcterms:title")="History of tobacco use"
        ;G("snomed:8517006","rdf:type")="sp:Code"
        ;G("snomed:8517006","system")="http://purl.bioontology.org/ontology/SNOMEDCT/"
        
        ;
PROB(GRTN,C0SARY)       ; GRTN, passed by reference,
        ; is the return name of the graph created. "" if none
        ; C0SARY is passed in by reference and is the NHIN array of problems
        ;
        I $O(C0SARY("problem",""))="" D  Q  ;
        . I $D(DEBUG) W !,"No Problems"
        S GRTN="" ; default to no problems
        N C0SGRF
        S C0SGRF="vistaSmart:"_ZPATID_"/problems"
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
        F  S ZI=$O(C0SARY("problem",ZI)) Q:ZI=""  D  ;
        . N LRN,ZR ; ZR is the local array for building the new triples
        . S LRN=$NA(C0SARY("problem",ZI)) ; base for values in this lab result
        . ;
        . N PROBID ; unique Id for this problem
        . S PROBID=C0SGRF_"/"_$$LKY17^C0XF2N ; use a random number
        . ;
        . ; i don't like this because the same problems gets a
        . ; different ID every time it's reported. Can't trace it back to VistA
        . ; I'd rather be using id@value ie "id@value")="118"
        . ;
        . N SNOMED,ICD S ICD=$G(@LRN@("icd@value"))
        . S SNOMED=$$SNOMED(ICD) ; look up the snomed code in the map
        . N SNOGRF ; graph for SNOMED code
        . I SNOMED="" D  ;
        . . S SNOMED=ICD ; if not found, return the ICD code
        . . S SNOGRF="icd9:"_SNOMED
        . E  S SNOGRF="snomed:"_SNOMED
        . N SNOTIT S SNOTIT=$G(@LRN@("name@value"))
        . I $D(DEBUG) D  ;
        . . W !,"Processing Problem List ",PROBID
        . . W !,"problem: ",SNOTIT
        . . W !,"code: ",SNOMED
        . ;
        . ; first do the base result graph
        . ;
        . S ZR("rdf:type")="sp:Problem"
        . S ZR("sp:belongsTo")=C0SGRF ; the subject for this patient's problems
        . ; ie /vista/smart/99912345/problems
        . ;
        . N PROBNAME S PROBNAME=$$ANONS^C0XF2N ; new node for problem name
        . S ZR("sp:problemName")=PROBNAME
        . ;
        . N STARTDT S STARTDT=$$SPDATE^C0SUTIL($G(@LRN@("entered@value")))
        . S ZR("sp:startDate")=STARTDT
        . ;
        . D ADDINN^C0XF2N(C0SGRF,PROBID,.ZR) ; addIfNotNull the triples
        . K ZR ; clean up
        . ;
        . ; create the problemName graph
        . ;
        . S ZR("rdf:type")="sp:CodedValue"
        . ;S ZR("sp:code")="snomed:"_SNOMED
        . S ZR("sp:code")=SNOGRF
        . S ZR("dcterms:title")=$G(@LRN@("name@value"))
        . D ADDINN^C0XF2N(C0SGRF,PROBNAME,.ZR)
        . K ZR
        . ;
        . ; create snomed graph
        . ; 
        . S ZR("rdf:type")="sp:Code"
        . S ZR("sp:system")="http://purl.bioontology.org/ontology/SNOMEDCT"
        . I SNOGRF["icd9" S ZR("sp:system")="http://purl.bioontology.org/ontology/ICD9"
        . S ZR("dcterms:identifier")=SNOMED
        . S ZR("dcterms:title")=SNOTIT
        . D ADDINN^C0XF2N(C0SGRF,SNOGRF,.ZR)
        . K ZR
        . ;
        D BULKLOAD^C0XF2N(.C0XFDA)
        S GRTN=C0SGRF
        Q
        ;
SNOMED(ZICD)    ; extrinsic which returns SNOMED code given an ICD9 code
        ; requires the mapping table installed in the triplestore
        ;
        N ZSN,ZARY,ZSUB,ZSUBS
        I $E(ZICD,$L(ZICD))="." S ZICD=$P(ZICD,".",1) ; handle trailing dots
        D subjects^C0XGET1(.ZSUBS,"cg:ontology#code",ZICD) ; subjects with the ICD9 code
        S ZSUB=$O(ZSUBS("")) ; pick the first one
        I ZSUB="" Q ""
        D objects^C0XGET1(.ZARY,ZSUB,"cg:ontology#toCode")
        S ZSN=$O(ZARY(""))
        I $D(DEBUG) W !,ZSN," ",$$object^C0XGET1(ZSUB,"rdfs:label")
        Q ZSN
        ;
