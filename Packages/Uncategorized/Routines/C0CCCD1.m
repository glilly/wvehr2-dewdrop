C0CCCD1 ; CCDCCR/GPL - CCD TEMPLATE AND ACCESS ROUTINES; 6/7/08
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;Copyright 2008,2009 George Lilly, University of Minnesota.
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
          W "This is a CCD TEMPLATE with processing routines",!
          W !
          Q
          ;
ZT(ZARY,BAT,LINE) ; private routine to add a line to the ZARY array
          ; ZARY IS PASSED BY NAME
          ; BAT is a string identifying the section
          ; LINE is a test which will evaluate to true or false
          ; I '$G(@ZARY) D  ; IF ZARY DOES NOT EXIST '
          ; . S @ZARY@(0)=0 ; initially there are no elements
          ; . W "GOT HERE LOADING "_LINE,!
          N CNT ; count of array elements
          S CNT=@ZARY@(0) ; contains array count
          S CNT=CNT+1 ; increment count
          S @ZARY@(CNT)=LINE ; put the line in the array
          ; S @ZARY@(BAT,CNT)="" ; index the test by battery
          S @ZARY@(0)=CNT ; update the array counter
          Q
          ;
ZLOAD(ZARY,ROUTINE) ; load tests into ZARY which is passed by reference
          ; ZARY IS PASSED BY NAME
          ; ZARY = name of the root, closed array format (e.g., "^TMP($J)")
          ; ROUTINE = NAME OF THE ROUTINE - PASSED BY VALUE
          K @ZARY S @ZARY=""
          S @ZARY@(0)=0 ; initialize array count
          N LINE,LABEL,BODY
          N INTEST S INTEST=0 ; switch for in the TEMPLATE section
          N SECTION S SECTION="[anonymous]" ; NO section LABEL
          ;
          N NUM F NUM=1:1 S LINE=$T(+NUM^@ROUTINE) Q:LINE=""  D
          . I LINE?." "1";<TEMPLATE>".E S INTEST=1 ; entering section
          . I LINE?." "1";</TEMPLATE>".E S INTEST=0 ; leaving section
          . I INTEST  D  ; within the section
          . . I LINE?." "1";><".E  D  ; sub-section name found
          . . . S SECTION=$P($P(LINE,";><",2),">",1) ; pull out name
          . . I LINE?." "1";;".E  D  ; line found
          . . . D ZT(ZARY,SECTION,$P(LINE,";;",2)) ; put the line in the array
          Q
          ;
LOAD(ARY) ; LOAD A CCR TEMPLATE INTO ARY PASSED BY NAME
          D ZLOAD(ARY,"C0CCCD1")
          ; ZWR @ARY
          Q
          ;
TRMCCD    ; ROUTINE TO BE WRITTEN TO REMOVE CCR MARKUP FROM CCD
          Q
MARKUP ;<MARKUP>
 ;;<Body>
 ;;<Problems>
 ;;</Problems>
 ;;<FamilyHistory>
 ;;</FamilyHistory>
 ;;<SocialHistory>
 ;;</SocialHistory>
 ;;<Alerts>
 ;;</Alerts>
 ;;<Medications>
 ;;</Medications>
 ;;<VitalSigns>
 ;;</VitalSigns>
 ;;<Results>
 ;;</Results>
 ;;</Body>
 ;;</ContinuityOfCareRecord>
 ;</MARKUP>
 ;;<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 CDA.xsd">
 ;;</ClinicalDocument>
 Q
 ;
 ;<TEMPLATE>
 ;;<?xml version="1.0"?>
 ;;<?xml-stylesheet type="text/xsl" href="CCD.xsl"?>
 ;;<ClinicalDocument xmlns="urn:hl7-org:v3" xmlns:voc="urn:hl7-org:v3/voc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:hl7-org:v3 CDA.xsd">
 ;;<typeId root="2.16.840.1.113883.1.3" extension="POCD_HD000040"/>
 ;;<templateId root="2.16.840.1.113883.10.20.1"/>
 ;;<id root="db734647-fc99-424c-a864-7e3cda82e703"/>
 ;;<code code="34133-9" codeSystem="2.16.840.1.113883.6.1" displayName="Summarization of episode note"/>
 ;;<title>Continuity of Care Document</title>
 ;;<effectiveTime value="20000407130000+0500"/>
 ;;<confidentialityCode code="N" codeSystem="2.16.840.1.113883.5.25"/>
 ;;<languageCode code="en-US"/>
 ;;<recordTarget>
 ;;<patientRole>
 ;;<id extension="@@ACTORIEN@@" root="2.16.840.1.113883.19.5"/>
 ;;<patient>
 ;;<name>
 ;;<given>@@ACTORGIVENNAME@@</given>
 ;;<family>@@ACTORFAMILYNAME@@</family>
 ;;<suffix>@@ACTORSUFFIXNAME@@</suffix>
 ;;</name>
 ;;<administrativeGenderCode code="@@ACTORGENDER@@" codeSystem="2.16.840.1.113883.5.1"/>
 ;;<birthTime value="@@ACTORDATEOFBIRTH@@"/>
 ;;</patient>
 ;;<providerOrganization>
 ;;<id root="2.16.840.1.113883.19.5"/>
 ;;<name>@@ORGANIZATIONNAME@@</name>
 ;;</providerOrganization>
 ;;</patientRole>
 ;;</recordTarget>
 ;;<author>
 ;;<time value="20000407130000+0500"/>
 ;;<assignedAuthor>
 ;;<id root="20cf14fb-b65c-4c8c-a54d-b0cca834c18c"/>
 ;;<assignedPerson>
 ;;<name>
 ;;<prefix>@@ACTORNAMEPREFIX@@</prefix>
 ;;<given>@@ACTORGIVENNAME@@</given>
 ;;<family>@@ACTORFAMILYNAME@@</family>
 ;;</name>
 ;;</assignedPerson>
 ;;<representedOrganization>
 ;;<id root="2.16.840.1.113883.19.5"/>
 ;;<name>@@ORGANIZATIONNAME@@</name>
 ;;</representedOrganization>
 ;;</assignedAuthor>
 ;;</author>
 ;;<informant>
 ;;<assignedEntity>
 ;;<id nullFlavor="NI"/>
 ;;<representedOrganization>
 ;;<id root="2.16.840.1.113883.19.5"/>
 ;;<name>@@ORGANIZATIONNAME@@</name>
 ;;</representedOrganization>
 ;;</assignedEntity>
 ;;</informant>
 ;;<custodian>
 ;;<assignedCustodian>
 ;;<representedCustodianOrganization>
 ;;<id root="2.16.840.1.113883.19.5"/>
 ;;<name>@@ORGANIZATIONNAME@@</name>
 ;;</representedCustodianOrganization>
 ;;</assignedCustodian>
 ;;</custodian>
 ;;<legalAuthenticator>
 ;;<time value="20000407130000+0500"/>
 ;;<signatureCode code="S"/>
 ;;<assignedEntity>
 ;;<id nullFlavor="NI"/>
 ;;<representedOrganization>
 ;;<id root="2.16.840.1.113883.19.5"/>
 ;;<name>@@ORGANIZATIONNAME@@</name>
 ;;</representedOrganization>
 ;;</assignedEntity>
 ;;</legalAuthenticator>
 ;;<Actors>
 ;;<ACTOR-NOK>
 ;;<participant typeCode="IND">
 ;;<associatedEntity classCode="NOK">
 ;;<id root="4ac71514-6a10-4164-9715-f8d96af48e6d"/>
 ;;<code code="65656005" codeSystem="2.16.840.1.113883.6.96" displayName="Biiological mother"/>
 ;;<telecom value="tel:(999)555-1212"/>
 ;;<associatedPerson>
 ;;<name>
 ;;<given>Henrietta</given>
 ;;<family>Levin</family>
 ;;</name>
 ;;</associatedPerson>
 ;;</associatedEntity>
 ;;</participant>
 ;;</ACTOR-NOK>
 ;;</Actors>
 ;;<documentationOf>
 ;;<serviceEvent classCode="PCPR">
 ;;<effectiveTime>
 ;;<high value="@@DATETIME@@"/>
 ;;</effectiveTime>
 ;;<performer typeCode="PRF">
 ;;<functionCode code="PCP" codeSystem="2.16.840.1.113883.5.88"/>
 ;;<time>
 ;;<low value="1990"/>
 ;;<high value='20000407'/>
 ;;</time>
 ;;<assignedEntity>
 ;;<id root="20cf14fb-b65c-4c8c-a54d-b0cca834c18c"/>
 ;;<assignedPerson>
 ;;<name>
 ;;<prefix>@@ACTORPREFIXNAME@@</prefix>
 ;;<given>@@ACTORGIVENNAME@@</given>
 ;;<family>@@ACTORFAMILYNAME@@</family>
 ;;</name>
 ;;</assignedPerson>
 ;;<representedOrganization>
 ;;<id root="2.16.840.1.113883.19.5"/>
 ;;<name>@@ORGANIZATIONNAME@@</name>
 ;;</representedOrganization>
 ;;</assignedEntity>
 ;;</performer>
 ;;</serviceEvent>
 ;;</documentationOf>
 ;;<Body>
 ;;<PROBLEMS-HTML>
 ;;<text><table border="1" width="100%"><thead><tr><th>Condition</th><th>Effective Dates</th><th>Condition Status</th></tr></thead><tbody>
 ;;<tr><td>@@PROBLEMDESCRIPTION@@</td>
 ;;<td>@@PROBLEMDATEOFONSET@@</td>
 ;;<td>Active</td></tr>
 ;;</tbody></table></text>
 ;;</PROBLEMS-HTML>
 ;;<Problems>
 ;;<component>
 ;;<section>
 ;;<templateId root='2.16.840.1.113883.10.20.1.11'/>
 ;;<code code="11450-4" codeSystem="2.16.840.1.113883.6.1"/>
 ;;<title>Problems</title>
 ;;<entry typeCode="DRIV">
 ;;<act classCode="ACT" moodCode="EVN">
 ;;<templateId root='2.16.840.1.113883.10.20.1.27'/>
 ;;<id root="6a2fa88d-4174-4909-aece-db44b60a3abb"/>
 ;;<code nullFlavor="NA"/>
 ;;<entryRelationship typeCode="SUBJ">
 ;;<observation classCode="OBS" moodCode="EVN">
 ;;<templateId root='2.16.840.1.113883.10.20.1.28'/>
 ;;<id root="d11275e7-67ae-11db-bd13-0800200c9a66"/>
 ;;<code code="ASSERTION" codeSystem="2.16.840.1.113883.5.4"/>
 ;;<statusCode code="completed"/>
 ;;<effectiveTime>
 ;;<low value="@@PROBLEMDATEOFONSET@@"/>
 ;;</effectiveTime>
 ;;<value xsi:type="CD" code="@@PROBLEMCODEVALUE@@" codeSystem="2.16.840.1.113883.6.96" displayName="@@PROBLEMDESCRIPTION@@"/>
 ;;<entryRelationship typeCode="REFR">
 ;;<observation classCode="OBS" moodCode="EVN">
 ;;<templateId root='2.16.840.1.113883.10.20.1.50'/>
 ;;<code code="33999-4" codeSystem="2.16.840.1.113883.6.1" displayName="Status"/>
 ;;<statusCode code="completed"/>
 ;;<value xsi:type="CE" code="55561003" codeSystem="2.16.840.1.113883.6.96" displayName="Active"/>
 ;;</observation>
 ;;</entryRelationship>
 ;;</observation>
 ;;</entryRelationship>
 ;;</act>
 ;;</entry>
 ;;</section>
 ;;</component>
 ;;</Problems>
 ;;<FamilyHistory>
 ;;</FamilyHistory>
 ;;<SocialHistory>
 ;;</SocialHistory>
 ;;<Alerts>
 ;;</Alerts>
 ;;<Medications>
 ;;</Medications>
 ;;<VitalSigns>
 ;;</VitalSigns>
 ;;<Results>
 ;;</Results>
 ;;</Body>
 ;;</ClinicalDocument>
 ;</TEMPLATE>
