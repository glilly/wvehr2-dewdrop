LA7VORU ;DALOI/JMC - Builder of HL7 Lab Results OBR/OBX/NTE ;Jan 31, 2005
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**27,46,61,64,71**;Sep 27, 1994
 ;
EN(LA) ; called from IN^LA7VMSG(...)
 ; variables
 ; LA("HUID") - Host Unique ID from the local ACCESSION file (#68)
 ; LA("SITE") - Ordering site IEN in the INSTITUTION file (#4)
 ; LA("RUID") - Remote sites Unique ID from ACCESSION file (#68)
 ; LA("ORD") - Free text ordered test name from WKLD CODE file (#64)
 ; LA("NLT") - National Laboratory test code from WKLD CODE file (#64)
 ; LA("LRIDT") - Inverse date/time the lab arrival time (accession date/time)
 ; LA("SUB") - test subscript defined in LABORATORY TEST file (#60)
 ; LA("LRDFN") - IEN in LAB DATA file (#63)
 ; LA("ORD"), LA("NLT"), and LA("SUB") are sent for specific lab results.
 ; LA("AUTO-INST") - Auto-Instrument
 ;
 N LA763,LA7NLT,LA7NVAF,LA7X,PRIMARY
 ;
 S PRIMARY=$$PRIM^VASITE(DT),LA("AUTO-INST")=""
 I $G(PRIMARY)'="" D
 . S PRIMARY=$$SITE^VASITE(DT,PRIMARY)
 . S PRIMARY=$P(PRIMARY,U,3)
 . S LA("AUTO-INST")="LA7V HOST "_PRIMARY
 ;
 I '$O(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),0)) D  Q
 . ; need to add error logging when no entry in 63.
 ;
 ; Get zeroth node of entry in #63.
 S LA763(0)=$G(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),0))
 S LA7NLT=$G(LA("NLT"))
 ;
 S LA7NVAF=$$NVAF^LA7VHLU2(+LA("SITE"))
 S LA7NTESN=0
 D ORC
 ;
 I $G(LA("SUB"))="CH" D CH
 I $G(LA("SUB"))="MI" D MI^LA7VORU1
 I "SPCYEM"[$G(LA("SUB")) D AP^LA7VORU2
 Q
 ;
 ;
CH ; Build segments for "CH" subscript
 ;
 D OBR
 D NTE
 S LA7OBXSN=0
 D OBX
 ;
 Q
 ;
 ;
ORC ; Build ORC segment
 ;
 N LA763,LA7696,LA7DATA,LA7SM,LA7X,LA7Y,ORC
 ;
 S LA763(0)=$G(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),0))
 ;
 S ORC(0)="ORC"
 ;
 ; Order control
 S ORC(1)=$$ORC1^LA7VORC("RE")
 ;
 ; Remote UID
 S ORC(2)=$$ORC2^LA7VORC(LA("RUID"),LA7FS,LA7ECH)
 ;
 ; Host UID
 S ORC(3)=$$ORC3^LA7VORC(LA("HUID"),LA7FS,LA7ECH)
 ;
 ; Return shipping manifest if found
 S LA7SM="",LA7696=0
 I LA("SITE")'="",LA("RUID")'="" S LA7696=$O(^LRO(69.6,"RST",LA("SITE"),LA("RUID"),0))
 I LA7696 S LA7SM=$P($G(^LRO(69.6,LA7696,0)),U,14)
 I LA7SM'="" S ORC(4)=$$ORC4^LA7VORC(LA7SM,LA7FS,LA7ECH)
 ;
 ; Order status
 ; DoD/CHCS requires ORC-5 valued otherwise will not process message
 I LA7NVAF=1 S ORC(5)=$$ORC5^LA7VORC("CM",LA7FS,LA7ECH)
 ;
 ; Ordering provider
 S (LA7X,LA7Y)=""
 ; "CH" subscript stores requesting provider and requesting div/location.
 I LA("SUB")="CH" D
 . N LA7J
 . S LA7J=$P(LA763(0),"^",13)
 . I $P(LA7J,";",2)="SC(" S LA7Y=$$GET1^DIQ(44,$P(LA7J,";")_",",3,"I")
 . I $P(LA7J,";",2)="DIC(4," S LA7Y=$P(LA7J,";")
 . S LA7X=$P(LA763(0),"^",10)
 ;
 ; Other subscripts only store requesting provider
 I "CYEMMISP"[LA("SUB") S LA7X=$P(LA763(0),"^",7)
 ; Get default institution from MailMan Site Parameters file
 I LA7Y="" S LA7Y=$$GET1^DIQ(4.3,"1,",217,"I")
 S ORC(12)=$$ORC12^LA7VORC(LA7X,LA7Y,LA7FS,LA7ECH)
 ;
 ; Entering organization
 S ORC(17)=$$ORC17^LA7VORC(LA7Y,LA7FS,LA7ECH)
 ;
 D BUILDSEG^LA7VHLU(.ORC,.LA7DATA,LA7FS)
 D FILESEG^LA7VHLU(GBL,.LA7DATA)
 ;
 ; Check for flag to only build message but do not file
 I '$G(LA7NOMSG) D FILE6249^LA7VHLU(LA76249P,.LA7DATA)
 ;
 Q
 ;
 ;
OBR ;Observation Request segment for Lab Order
 ;
 N LA761,LA762,LA7DATA,LA7PLOBR,LA7X,LA7Y,OBR
 ;
 ; Retrieve placer's OBR information stored in #69.6
 D RETOBR^LA7VHLU(LA("SITE"),LA("RUID"),LA("NLT"),.LA7PLOBR)
 ;
 ; Initialize OBR segment
 S OBR(0)="OBR"
 S OBR(1)=$$OBR1^LA7VOBR(.LA7OBRSN)
 ;
 ; Remote UID
 S OBR(2)=$$OBR2^LA7VOBR(LA("RUID"),LA7FS,LA7ECH)
 ;
 ; Host UID
 S OBR(3)=$$OBR3^LA7VOBR(LA("HUID"),LA7FS,LA7ECH)
 ;
 ; Universal service ID, build from info stored in #69.6
 S LA7X=""
 I $G(LA7PLOBR("OBR-4"))'="" S OBR(4)=$$CNVFLD^LA7VHLU3(LA7PLOBR("OBR-4"),LA7PLOBR("ECH"),LA7ECH)
 E  S OBR(4)=$$OBR4^LA7VOBR(LA7NLT,"",LA7X,LA7FS,LA7ECH)
 ;
 ; Collection D/T
 S OBR(7)=$$OBR7^LA7VOBR($P(LA763(0),U))
 ;
 ; Specimen action code
 ; If no OBR from PENDING ORDER file (#69.6) then assume added test.
 I $G(LA7INTYP)=10,$G(LA7PLOBR("OBR-4"))="" S OBR(11)=$$OBR11^LA7VOBR("A")
 ;
 ; Infection Warning
 S OBR(12)=$$OBR12^LA7VOBR(LRDFN,LA7FS,LA7ECH)
 ;
 ; Lab Arrival Time
 ; "CH" subscript does not store lab arrival time, use collection time.
 ; Other subscripts do store lab arrival time (date/time received).
 I "CYEMMISP"[LA("SUB") S OBR(14)=$$OBR14^LA7VOBR($P(LA763(0),"^",10))
 I LA("SUB")="CH" S OBR(14)=$$OBR14^LA7VOBR($P(LA763(0),"^"))
 ;
 ; Specimen source 
 S (LA761,LA762)=""
 I "CHMI"[LA("SUB") D
 . S LA761=$P(LA763(0),U,5)
 . I LA761="" D CREATE^LA7LOG(27)
 . I LA("SUB")="MI" S LA762=$P(LA763(0),U,11)
 S OBR(15)=$$OBR15^LA7VOBR(LA761,LA762,"",LA7FS,LA7ECH)
 ;
 ; Ordering provider
 S (LA7X,LA7Y)=""
 ; "CH" subscript stores requesting provider and requesting div/location.
 I LA("SUB")="CH" D
 . N LA7J
 . S LA7J=$P(LA763(0),"^",13)
 . I $P(LA7J,";",2)="SC(" S LA7Y=$$GET1^DIQ(44,$P(LA7J,";")_",",3,"I")
 . I $P(LA7J,";",2)="DIC(4," S LA7Y=$P(LA7J,";")
 . S LA7X=$P(LA763(0),"^",10)
 ;
 ; Other subscripts only store requesting provider
 I "CYEMMISP"[LA("SUB") S LA7X=$P(LA763(0),"^",7)
 ; Get default institution from MailMan Site Parameters file
 I LA7Y="" S LA7Y=$$GET1^DIQ(4.3,"1,",217,"I")
 S OBR(16)=$$ORC12^LA7VORC(LA7X,LA7Y,LA7FS,LA7ECH)
 ;
 ; Placer Field #1 (remote auto-inst)
 ; Build from info stored in #69.6
 I $G(LA7PLOBR("OBR-18"))'="" D
 . S OBR(18)=$$CHKDATA^LA7VHLU3(LA7PLOBR("OBR-18"),LA7FS_LA7ECH)
 ; Else build "auto instrument" if sending to VA facility
 I $G(LA7PLOBR("OBR-18"))="",'LA7NVAF D
 . N LA7X
 . S LA7X(1)=LA("AUTO-INST")
 . S OBR(18)=$$OBR18^LA7VOBR(.LA7X,LA7FS,LA7ECH)
 ;
 ; Placer Field #2
 I $G(LA7PLOBR("OBR-19"))'="" D
 . S OBR(19)=$$CHKDATA^LA7VHLU3(LA7PLOBR("OBR-19"),LA7FS_LA7ECH)
 ; Else build collecting UID if sending to VA facility
 I $G(LA7PLOBR("OBR-19"))="",'LA7NVAF,LA("RUID")'="" D
 . K LA7X
 . S LA7X(7)=LA("RUID")
 . S OBR(19)=$$OBR19^LA7VOBR(.LA7X,LA7FS,LA7ECH)
 ;
 ; Filler Field #1
 ; Send file #63 ien info - used by HDR to track patient/specimen
 K LA7X
 S LA7X(1)=LA("LRDFN")
 S LA7X(2)=LA("SUB")
 S LA7X(3)=LA("LRIDT")
 S OBR(20)=$$OBR20^LA7VOBR(.LA7X,LA7FS,LA7ECH)
 ;
 ; Date Report Completed
 I $P(LA763(0),"^",3) S OBR(22)=$$OBR22^LA7VOBR($P(LA763(0),"^",3))
 ;
 ; Diagnostic service id
 S OBR(24)=$$OBR24^LA7VOBR(LA("SUB")_"^"_$G(LRSB))
 ;
 ; Parent Result and Parent
 I $D(LA7PARNT) D
 . S OBR(26)=$$OBR26^LA7VOBR(LA7PARNT(1),LA7PARNT(2),LA7PARNT(3),LA7FS,LA7ECH)
 . S OBR(29)=$$OBR29^LA7VOBR(LA("RUID"),LA("HUID"),LA7FS,LA7ECH)
 ;
 ; Principle result interpreter
 ; Get default institution from MailMan Site Parameters file
 I "CYEMMISP"[LA("SUB") D
 . I LA("SUB")="MI" S LA7X=$P(LA763(0),"^",4)
 . E  S LA7X=$P(LA763(0),"^",2)
 . S LA7Y=$$GET1^DIQ(4.3,"1,",217,"I")
 . S OBR(32)=$$OBR32^LA7VOBR(LA7X,LA7Y,LA7FS,LA7ECH)
 ; 
 ; Assistant result interpreter
 ; Get default institution from MailMan Site Parameters file
 I "EMSP"[LA("SUB") D
 . S LA7X=$P(LA763(0),"^",4),LA7Y=$$GET1^DIQ(4.3,"1,",217,"I")
 . S OBR(33)=$$OBR33^LA7VOBR(LA7X,LA7Y,LA7FS,LA7ECH)
 ; 
 ; Technician
 ; Get default institution from MailMan Site Parameters file
 I "CYEM"[LA("SUB") D
 . S LA7X=$P(LA763(0),"^",4),LA7Y=$$GET1^DIQ(4.3,"1,",217,"I")
 . S OBR(34)=$$OBR34^LA7VOBR(LA7X,LA7Y,LA7FS,LA7ECH)
 ; 
 ; Typist - VistA stores as free text
 ; Get default institution from MailMan Site Parameters file
 I "CYEMSP"[LA("SUB") D
 . S LA7X=$P(LA763(0),"^",9),LA7Y=$$GET1^DIQ(4.3,"1,",217,"I")
 . S OBR(35)=$$OBR35^LA7VOBR(LA7X,LA7Y,LA7FS,LA7ECH)
 ; 
 D BUILDSEG^LA7VHLU(.OBR,.LA7DATA,LA7FS)
 D FILESEG^LA7VHLU(GBL,.LA7DATA)
 ;
 ; Check for flag to only build message but do not file
 I '$G(LA7NOMSG) D FILE6249^LA7VHLU(LA76249,.LA7DATA)
 ;
 Q
 ;
 ;
OBX ;Observation/Result segment for Lab Results
 ;
 N LA7953,LA7DATA,LA7VT,LA7VTIEN,LA7X
 ;
 S LA7VTIEN=0
 F  S LA7VTIEN=$O(^LAHM(62.49,LA(62.49),1,LA7VTIEN)) Q:'LA7VTIEN  D
 . S LA7VT=$P(^LAHM(62.49,LA(62.49),1,LA7VTIEN,0),"^",1,2)
 . ; Build OBX segment
 . K LA7DATA
 . D OBX^LA7VOBX(LA("LRDFN"),LA("SUB"),LA("LRIDT"),$P(LA7VT,"^",1,2),.LA7DATA,.LA7OBXSN,LA7FS,LA7ECH,$G(LA7NVAF))
 . ; If OBX failed to build then don't store
 . I '$D(LA7DATA) Q
 . ;
 . D FILESEG^LA7VHLU(GBL,.LA7DATA)
 . I '$G(LA7NOMSG) D FILE6249^LA7VHLU(LA76249,.LA7DATA)
 . ;
 . ; Send performing lab comment and interpretation from file #60
 . S LA7NTESN=0
 . I LA7NVAF=1 D PLC^LA7VORUA
 . D INTRP^LA7VORUA
 . ;
 . ; Mark result as sent - set to 1, if corrected results set to 2
 . I LA("SUB")="CH" D
 . . I $P(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),$P(LA7VT,"^")),"^",10)>1 Q
 . . S $P(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),$P(LA7VT,"^")),"^",10)=$S($P(LA7VT,"^",2)="C":2,1:1)
 ;
 Q
 ;
 ;
NTE ; Build NTE segment
 ;
 D NTE^LA7VORUA
 Q
