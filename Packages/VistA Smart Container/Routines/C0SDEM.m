C0SDEM    ; GPL - Smart Demographics Processing ;2/22/12  17:05
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
        ;<?xml version="1.0" encoding="utf-8"?>
        ;<rdf:RDF
        ;  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        ;  xmlns:sp="http://smartplatforms.org/terms#"
        ;  xmlns:dcterms="http://purl.org/dc/terms/"
        ;  xmlns:v="http://www.w3.org/2006/vcard/ns#"
        ;  xmlns:foaf="http://xmlns.com/foaf/0.1/">
        ;   <sp:Demographics>
        ;
        ;     <v:n>
        ;        <v:Name>
        ;            <v:given-name>Bob</v:given-name>
        ;            <v:additional-name>J</v:additional-name>
        ;            <v:family-name>Odenkirk</v:family-name>
        ;        </v:Name>
        ;     </v:n>
        ;
        ;     <v:adr>
        ;        <v:Address>
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Home" />
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Pref" />
        ;
        ;          <v:street-address>15 Main St</v:street-address>
        ;          <v:extended-address>Apt 2</v:extended-address>
        ;          <v:locality>Wonderland</v:locality>
        ;          <v:region>OZ</v:region>
        ;          <v:postal-code>54321</v:postal-code>
        ;          <v:country>USA</v:country>
        ;        </v:Address>
        ;     </v:adr>
        ;
        ;     <v:tel>
        ;        <v:Tel>
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Home" />
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Pref" />
        ;          <rdf:value>800-555-1212</rdf:value>
        ;        </v:Tel>
        ;     </v:tel>
        ;
        ;     <v:tel>
        ;        <v:Tel>
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Cell" />
        ;          <rdf:value>800-555-1515</rdf:value>
        ;        </v:Tel>
        ;     </v:tel>
        ;
        ;     <foaf:gender>male</foaf:gender>
        ;     <v:bday>1959-12-25</v:bday>
        ;     <v:email>bob.odenkirk@example.com</v:email>
        ;
        ;     <sp:medicalRecordNumber>
        ;       <sp:Code>
        ;        <dcterms:title>My Hospital Record 2304575</dcterms:title> 
        ;        <dcterms:identifier>2304575</dcterms:identifier> 
        ;        <sp:system>My Hospital Record</sp:system> 
        ;       </sp:Code>
        ;     </sp:medicalRecordNumber>
        ;
        ;   </sp:Demographics>
        ;</rdf:RDF><?xml version="1.0" encoding="utf-8"?>
        ;<rdf:RDF
        ;  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        ;  xmlns:sp="http://smartplatforms.org/terms#"
        ;  xmlns:dcterms="http://purl.org/dc/terms/"
        ;  xmlns:v="http://www.w3.org/2006/vcard/ns#"
        ;  xmlns:foaf="http://xmlns.com/foaf/0.1/">
        ;   <sp:Demographics>
        ;
        ;     <v:n>
        ;        <v:Name>
        ;            <v:given-name>Bob</v:given-name>
        ;            <v:additional-name>J</v:additional-name>
        ;            <v:family-name>Odenkirk</v:family-name>
        ;        </v:Name>
        ;     </v:n>
        ;
        ;     <v:adr>
        ;        <v:Address>
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Home" />
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Pref" />
        ;
        ;          <v:street-address>15 Main St</v:street-address>
        ;          <v:extended-address>Apt 2</v:extended-address>
        ;          <v:locality>Wonderland</v:locality>
        ;          <v:region>OZ</v:region>
        ;          <v:postal-code>54321</v:postal-code>
        ;          <v:country>USA</v:country>
        ;        </v:Address>
        ;     </v:adr>
        ;
        ;     <v:tel>
        ;        <v:Tel>
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Home" />
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Pref" />
        ;          <rdf:value>800-555-1212</rdf:value>
        ;        </v:Tel>
        ;     </v:tel>
        ;
        ;     <v:tel>
        ;        <v:Tel>
        ;          <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Cell" />
        ;          <rdf:value>800-555-1515</rdf:value>
        ;        </v:Tel>
        ;     </v:tel>
        ;
        ;     <foaf:gender>male</foaf:gender>
        ;     <v:bday>1959-12-25</v:bday>
        ;     <v:email>bob.odenkirk@example.com</v:email>
        ;
        ;     <sp:medicalRecordNumber>
        ;       <sp:Code>
        ;        <dcterms:title>My Hospital Record 2304575</dcterms:title> 
        ;        <dcterms:identifier>2304575</dcterms:identifier> 
        ;        <sp:system>My Hospital Record</sp:system> 
        ;       </sp:Code>
        ;     </sp:medicalRecordNumber>
        ;
        ;   </sp:Demographics>
        ;</rdf:RDF>
        ;G(1)="nodeID:25591^rdf:type^v:Home"
        ;G(2)="nodeID:25591^rdf:type^v:Pref"
        ;G(3)="nodeID:25591^rdf:type^v:Tel"
        ;G(4)="nodeID:25591^rdf:value^800-369-6403"
        ;G(5)="nodeID:25611^rdf:type^v:Name"
        ;G(6)="nodeID:25611^v:additional-name^N"
        ;G(7)="nodeID:25611^v:family-name^Brooks"
        ;G(8)="nodeID:25611^v:given-name^Brian"
        ;G(9)="nodeID:25622^dcterms:identifier^981968"
        ;G(10)="nodeID:25622^dcterms:title^My Hospital Record 981968"
        ;G(11)="nodeID:25622^rdf:type^sp:Code"
        ;G(12)="nodeID:25622^sp:system^My Hospital Record"
        ;G(13)="nodeID:25623^rdf:type^v:Address"
        ;G(14)="nodeID:25623^rdf:type^v:Home"
        ;G(15)="nodeID:25623^rdf:type^v:Pref"
        ;G(16)="nodeID:25623^v:locality^Bixby"
        ;G(17)="nodeID:25623^v:postal-code^74008"
        ;G(18)="nodeID:25623^v:region^OK"
        ;G(19)="nodeID:25623^v:street-address^82 Lake St"
        ;G(20)="smart:981968/demographics^foaf:gender^male"
        ;G(21)="smart:981968/demographics^rdf:type^sp:Demographics"
        ;G(22)="smart:981968/demographics^sp:belongsTo^smart:981968"
        ;G(23)="smart:981968/demographics^sp:medicalRecordNumber^nodeID:25622"
        ;G(24)="smart:981968/demographics^v:adr^nodeID:25623"
        ;G(25)="smart:981968/demographics^v:bday^1956-03-23"
        ;G(26)="smart:981968/demographics^v:email^brian.brooks@example.com"
        ;G(27)="smart:981968/demographics^v:n^nodeID:25611"
        ;G(28)="smart:981968/demographics^v:tel^nodeID:25591"
        Q
        ;
PATIENT(GRTN,C0SARY)    ; GRTN, passed by reference,
        ; is the return name of the graph created. "" if none
        ; C0SARY is passed in by reference and is the NHIN array of patient
        ;
        I $O(C0SARY("patient",""))="" D  Q  ;
        . I $D(DEBUG) W !,"No Patient array"
        . S GRTN=""
        S GRTN="" ; default to no patient
        N C0SGRF
        S C0SGRF="vistaSmart:"_ZPATID_"/patient"
        S ZPAT=C0SGRF ; subject is the same as the graph name
        I $D(DEBUG) W !,"Processing ",C0SGRF
        D DELGRAPH^C0XF2N(C0SGRF) ; delete the old graph
        D INITFARY^C0XF2N("C0XFARY") ; which triple store to use
        N FARY S FARY="C0XFARY"
        D USEFARY^C0XF2N(FARY)
        D VOCINIT^C0XUTIL
        ;
        N ZPN,ZR
        D STARTADD^C0XF2N
        ;
        ; First do the base demographic graph
        ;
        S ZPN=$NA(C0SARY("patient",1)) ; name of predicate array for this patient
        N SEX S SEX=$G(@ZPN@("gender@value"))
        I SEX="M" S SEX="male"
        I SEX="F" S SEX="female"
        S ZR("foaf:gender")=SEX
        S ZR("rdf:type")="sp:Demographics"
        S ZR("sp:belongsTo")=ZPAT
        N PATIENT
        S PATIENT=$P(ZPAT,"#",2)
        I $D(DEBUG) W !,"PROCESSING PATIENT ",PATIENT
        N NMREC S NMREC=$$ANONS^C0XF2N ; new anonomous subject for med rec graph
        S ZR("sp:medicalRecordNumber")=NMREC
        N NVADR S NVADR=$$ANONS^C0XF2N ; for address
        S ZR("v:adr")=NVADR
        N NNAME S NNAME=$$ANONS^C0XF2N ; for name
        S ZR("v:n")=NNAME
        N NTEL S NTEL=$$ANONS^C0XF2N ; for telephone
        I $D(@ZPN@("telecomList.telecom@value")) S ZR("v:tel")=NTEL ; only if exists
        N BDATE
        S ZX=""
        S ZX=$G(@ZPN@("dob@value")) ; date of birth in fileman format
        S BDATE=$$FMTE^XLFDT(ZX,"7D") ; ordered date
        S BDATE=$TR(BDATE,"/","-") ; change slashes to hyphens
        I BDATE="" S BDATE="UNKNOWN"
        N Z2,Z3
        S Z2=$P(BDATE,"-",2)
        S Z3=$P(BDATE,"-",3)
        I $L(Z2)=1 S $P(BDATE,"-",2)="0"_Z2
        I $L(Z3)=1 S $P(BDATE,"-",3)="0"_Z3
        S ZR("v:bday")=BDATE
        I $D(C0SVISTA) D  ;
        . S ZR("vista:SSN")=$G(@ZPN@("ssn@value")) ; SSN
        . S ZR("vista:DFN")=$G(@ZPN@("id@value")) ; DFN
        D ADDINN^C0XF2N(C0SGRF,ZPAT,.ZR) ; create base graph
        K ZR
        ;
        ; create address sub-graph
        ;
        S ZR("rdf:type")="v:Address"
        S ZR("rdf:type")="v:Home"
        S ZR("v:locality")=$G(@ZPN@("address@city"))
        S ZR("v:postal-code")=$G(@ZPN@("address@postalCode"))
        S ZR("v:region")=$G(@ZPN@("address@stateProvince"))
        S ZR("v:street-address")=$G(@ZPN@("address@streetLine1"))
        D ADDINN^C0XF2N(C0SGRF,NVADR,.ZR) ; create the vcard address
        K ZR
        ;
        ; create medical record subgraph
        ;
        S ZR("dcterms:identifier")=$G(@ZPN@("id@value"))
        S ZR("dcterms:title")="VistA Patient Record "_ZR("dcterms:identifier")
        S ZR("rdf:type")="sp:Code"
        S ZR("sp:system")="VistA Patient Record"
        D ADDINN^C0XF2N(C0SGRF,NMREC,.ZR) ; create medical record graph
        K ZR
        ;
        ; create name subgraph
        ;
        N ZNF,ZNL,ZNM,ZNAM
        S ZR("rdf:type")="v:Name"
        S ZX=$G(@ZPN@("givenNames@value")) ; first name and middle names
        S ZNF=$P(ZX," ",1) ; first name is first piece
        S ZNM=$P(ZX," ",2) ; middle names are the rest
        S ZR("v:additional-name")=ZNM
        S ZR("v:family-name")=$G(@ZPN@("familyName@value"))
        S ZR("v:given-name")=ZNF
        D ADDINN^C0XF2N(C0SGRF,NNAME,.ZR) ; insert name graph
        K ZR
        ;
        ; create telephone subgraph
        ;
        D  ;
        . S ZR("rdf:value")=$G(@ZPN@("telecomList.telecom@value"))
        . I ZR("rdf:value")="" Q  ; telephone number missing, no subgraph
        . S ZR("rdf:type")="v:Tel"
        . D ADDINN^C0XF2N(C0SGRF,NTEL,.ZR)
        K ZR
        ;
        ; load the demographics graph and all sub graphs to the triple store
        ;
        D BULKLOAD^C0XF2N(.C0XFDA)
        S GRTN=C0SGRF
        Q
        ;
AGES    ; LIST ALL PATIENTS AND THEIR AGES
        N ZI S ZI=0
        F  S ZI=$O(^DPT(ZI)) Q:+ZI=0  D  ; FOR EVERY PATIENT
        . N ZDOB
        . S ZDOB=$$GET1^DIQ(2,ZI_",","DOB","I") ; FILEMAN DOB
        . N ZNAME
        . S ZNAME=$P(^DPT(ZI,0),U)
        . N ZSEX
        . S ZSEX=$$GET1^DIQ(2,ZI_",","SEX")
        . W !,"DFN:",ZI," ",ZNAME," AGE: ",+$$BRIEF^VWTIME(ZDOB)," YEAR OLD ",ZSEX
        Q
        ;
