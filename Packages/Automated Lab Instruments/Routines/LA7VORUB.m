LA7VORUB        ;DALOI/JMC - Builder of HL7 Lab Results cont'd ;Jan 16, 2009
        ;;5.2;AUTOMATED LAB INSTRUMENTS;**68,250068**;Sep 27, 1994;Build 9
        ;
        ; Modified from FOIA VISTA,
        ; Copyright (C) 2007 WorldVistA
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
        ; You should have received a copy of the GNU General Public License
        ; along with this program; if not, write to the Free Software
        ; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
        ;
        Q
        ;
        ;
OBR     ;Observation Request segment for Lab Order
        ;
        N I,LA761,LA762,LA7DATA,LA7PLOBR,LA7RS,LA7RSDT,LA7SNM,LA7X,LA7Y,LADFINST,OBR
        ;
        ; Retrieve placer's OBR information stored in #69.6
        D RETOBR^LA7VHLU(LA("SITE"),LA("RUID"),LA("NLT"),.LA7PLOBR)
        ;
        ; Retrieve "ORUT" node for this NLT from file #63
        S LA7NLT(63)=""
        I LA7NLT'="" D
        . S LA7X=$O(^LR(LRDFN,LRSS,LRIDT,"ORUT","B",LA7NLT,0))
        . I LA7X>0 S LA7NLT(63)=$G(^LR(LRDFN,LRSS,LRIDT,"ORUT",LA7X,0))
        ;
        ; Default institution from Kernel
        S LADFINST=+$$KSP^XUPARAM("INST")
        ;
        ; Retreive accession info used below - accession area^accession date^accession number
        S LA7Y=$$CHECKUID^LRWU4(LA("HUID"))
        I LA7Y S LA("HUID",68)=$P(LA7Y,"^",2,4)
        E  S LA("HUID",68)=""
        ;
        ; Initialize OBR segment
        S OBR(0)="OBR"
        S OBR(1)=$$OBR1^LA7VOBR(.LA7OBRSN)
        ;
        ; Remote UID
        M LA7X=LA("RUID")
        S OBR(2)=$$OBR2^LA7VOBR(.LA7X,LA7FS,LA7ECH)
        ;
        ; Host UID
        K LA7X
        M LA7X=LA("HUID")
        S OBR(3)=$$OBR3^LA7VOBR(.LA7X,LA7FS,LA7ECH)
        ;
        ; Universal service ID, build from info stored in #69.6
        K LA7X
        S LA7X=""
        I $G(LA7PLOBR("OBR-4"))'="" S OBR(4)=$$CNVFLD^LA7VHLU3(LA7PLOBR("OBR-4"),LA7PLOBR("ECH"),LA7ECH)
        E  S OBR(4)=$$OBR4^LA7VOBR(LA7NLT,"",LA7X,LA7FS,LA7ECH)
        ;
        ; Collection D/T - only send date if d/t is inexact (2nd piece)
        K LA7X
        S LA7X=$P(LA763(0),"^") S:$P(LA763(0),"^",2) LA7X=$P(LA7X,".")
        S OBR(7)=$$OBR7^LA7VOBR(LA7X)
        ;
        ; Specimen action code
        ; If no OBR from PENDING ORDER file (#69.6) then assume added test.
        I $G(LA7INTYP)=10,$G(LA7PLOBR("OBR-4"))="" S OBR(11)=$$OBR11^LA7VOBR("A")
        ;
        ; Infection Warning
        S OBR(12)=$$OBR12^LA7VOBR(LRDFN,LA7FS,LA7ECH)
        ;
        ; Revelant clinical information
        I LA("SUB")="CH",$D(^LR(LRDFN,"CH",LRIDT,1)) D
        . S I=0,LA7Y=""
        . F  S I=$O(^LR(LRDFN,"CH",LRIDT,1,I)) Q:'I  S LA7X=$G(^LR(LRDFN,"CH",LRIDT,1,I,0)) S:$E(LA7X)="~" LA7Y=LA7Y_$S(LA7Y="":"",1:" ")_$E(LA7X,2,999)
        . S OBR(13)=$$OBR13^LA7VOBR(LA7Y,LA7FS,LA7ECH)
        ;
        I LA("SUB")="MI",$D(^LR(LRDFN,"MI",LRIDT,1)) D
        . S LA7Y=$G(^LR(LRDFN,"MI",LRIDT,99))
        . I LA7Y'="" S OBR(13)=$$OBR13^LA7VOBR(LA7Y,LA7FS,LA7ECH)
        ;
        ; Lab Arrival Time
        ; "CH" subscript does not store lab arrival time - attempt to retrieve from file #68.
        ; Other subscripts do store lab arrival time (date/time received).
        I LA("SUB")?1(1"MI",1"SP",1"CY",1"EM") S OBR(14)=$$OBR14^LA7VOBR($P(LA763(0),"^",10))
        I LA("SUB")="CH",LA("HUID",68) D
        . S LA7X=$G(^LRO(68,$P(LA("HUID",68),"^"),1,$P(LA("HUID",68),"^",2),1,$P(LA("HUID",68),"^",3),3))
        . I $P(LA7X,"^",3) S OBR(14)=$$OBR14^LA7VOBR($P(LA7X,"^",3))
        ;
        ; Specimen source 
        S (LA761,LA762,LA7SNM)=""
        I LA("SUB")?1(1"CH",1"MI") D
        . S LA761=$P(LA763(0),U,5)
        . I LA761="" D CREATE^LA7LOG(27)
        . I LA("SUB")="MI" S LA762=$P(LA763(0),U,11)
        I LA7NVAF=1,LA("SUB")'="CH" S LA7SNM=1
        S OBR(15)=$$OBR15^LA7VOBR(LA761,LA762,"",LA7FS,LA7ECH,"",LA7SNM)
        ;
        ; Ordering provider
        K LA7X
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
        I LA("SUB")?1(1"MI",1"SP",1"CY",1"EM") S LA7X=$P(LA763(0),"^",7)
        ;
        I LA7Y="" S LA7Y=LADFINST
        S OBR(16)=$$ORC12^LA7VORC(LA7X,LA7Y,LA7FS,LA7ECH,$S($G(LA7INTYP)=30:2,$G(LA7NVAF)=1:0,1:1))
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
        I $G(LA7PLOBR("OBR-19"))'="" S OBR(19)=$$CHKDATA^LA7VHLU3(LA7PLOBR("OBR-19"),LA7FS_LA7ECH)
        ; Else build collecting UID if sending to VA facility
        I $G(LA7PLOBR("OBR-19"))="",'LA7NVAF,LA("RUID")'="" D
        . K LA7X
        . S LA7X(7)=LA("RUID")
        . S OBR(19)=$$OBR19^LA7VOBR(.LA7X,LA7FS,LA7ECH)
        ;
        ; Filler Field #1
        ; Send file #63 ien info - used by HDR to track patient/specimen
        K LA7X
        S LA7X(1)=LA("LRDFN"),LA7X(2)=LA("SUB"),LA7X(3)=LA("LRIDT")
        S OBR(20)=$$OBR20^LA7VOBR(.LA7X,LA7FS,LA7ECH)
        ;
        ; Filler Field #2
        ; Send Accession/test info - used by DSS to track patient/specimen
        ; LRACC^LRAA^LRAD^LRAN^Accession Area^Area Abbreviation^NLT
        K LA7X
        S LA7X(1)=$P(LA763(0),"^",6),LA7X(7)=LA7NLT
        S LA7Y=LA("HUID",68)
        I LA7Y D
        . N I
        . F I=1,2,3 S LA7X(I+1)=$P(LA7Y,"^",I)
        . S LA7X(5)=$P($G(^LRO(68,$P(LA7Y,"^"),0)),"^")
        . S LA7X(6)=$P($G(^LRO(68,$P(LA7Y,"^"),0)),"^",11)
        S OBR(21)=$$OBR20^LA7VOBR(.LA7X,LA7FS,LA7ECH)
        K LA7X,LAY7
        ;
        ; Date Report Completed/Report status/Responsible person
        ; Determine report date and status from 0 node.
        S LA7RSDT=$P(LA763(0),"^",3),(LA7PRI,LA7RS)=""
        ;
        ; If CYEMSP subscripts then check for corrected report
        I LA("SUB")?1(1"SP",1"CY",1"EM") D
        . S LA7RSDT=$P(LA763(0),"^",11),LA7PRI=$P(LA763(0),"^",2)
        . I LA7RSDT S LA7RS="F"
        . I $P(LA763(0),"^",15) S LA7RS="C"
        . I $G(LRSB)=1.2,$G(LA7SR) S LA7RSDT=+$G(^LR(LRDFN,LA("SUB"),LRIDT,LRSB,LA7SR,0),"^")
        ;
        ; If MI subscript then also check various sections and audit subfile for corrected report
        I LA("SUB")="MI" D
        . S LA7PRI=$P(LA763(0),"^",4)
        . S LA7X=$S(LRSB=11:1,LRSB=11.6:1,LRSB=12:1,LRSB=14:5,LRSB=16:5,LRSB=18:8,LRSB=20:8,LRSB=22:11,LRSB=26:11,LRSB=24:11,LRSB=33:16,LRSB=36:16,1:0)
        . S LA7Y=$G(^LR(LRDFN,"MI",LRIDT,LA7X),"^")
        . I $P(LA7Y,"^") S LA7RSDT=$P(LA7Y,"^"),LA7RS=$P(LA7Y,"^",2),LA7PRI=$P(LA7Y,"^",3)
        . I $P(LA763(0),"^",9)=1 S LA7RS="C" Q
        . I '$D(^LR(LRDFN,"MI",LRIDT,32)) Q
        . S I=0
        . F  S I=$O(^LR(LRDFN,"MI",LRIDT,32,I)) Q:'I  I $P(^(I,0),"^",4)>1,LA7RS="F" S LA7RS="C" Q
        ;
        ; Also check for individual test status on "ORUT" node in file #63
        I $P(LA7NLT(63),"^",10) S LA7RS=$P(LA7NLT(63),"^",10)
        ;
        I LA("SUB")="CH",LA7RS="" D
        . S LA7RS="F"
        . S I=1
        . F  S I=$O(^LR(LRDFN,"CH",LRIDT,I)) Q:I<1  I $P(^(I),"^",10)=2 S LA7RS="C"
        ;
        ; Date Report Completed
        I LA7RSDT S OBR(22)=$$OBR22^LA7VOBR(LA7RSDT)
        ;
        ; Diagnostic service id
        S OBR(24)=$$OBR24^LA7VOBR(LA("SUB")_"^"_$G(LRSB))
        ;
        ; Result status
        I LA7RS'="" S OBR(25)=$$OBR25^LA7VOBR(LA7RS)
        ;
        ; Parent Result and Parent
        I $D(LA7PARNT) D
        . S OBR(26)=$$OBR26^LA7VOBR(LA7PARNT(1),LA7PARNT(2),LA7PARNT(3),LA7FS,LA7ECH)
        . S OBR(29)=$$OBR29^LA7VOBR(LA("RUID"),LA("HUID"),LA7FS,LA7ECH)
        ;
        ; Reason for Study
        S LA7X=""
        I LA("HUID",68)'="" S LA7X=$$ORIFN^LA7VORM4($P(LA("HUID",68),"^"),$P(LA("HUID",68),"^",2),$P(LA("HUID",68),"^",3))
        I LA7X'="" S OBR(31)=$$OBR31^LA7VOBR(LA7X,LA7FS,LA7ECH)
        ; 
        ; Principle result interpreter
        I LA("SUB")?1(1"MI",1"SP",1"CY",1"EM") D
        . I LA("SUB")="MI" S LA7X=$P(LA763(0),"^",4)
        . E  S LA7X=$P(LA763(0),"^",2)
        . S OBR(32)=$$OBR32^LA7VOBR(LA7X,LADFINST,LA7FS,LA7ECH)
        ; 
        ; Assistant result interpreter
        I LA("SUB")?1(1"SP",1"EM"),$P(LA763(0),"^",4) S OBR(33)=$$OBR33^LA7VOBR($P(LA763(0),"^",4),LADFINST,LA7FS,LA7ECH)
        ; 
        ; Technician
        I LA("SUB")?1(1"CY",1"EM"),$P(LA763(0),"^",4) S OBR(34)=$$OBR34^LA7VOBR($P(LA763(0),"^",4),LADFINST,LA7FS,LA7ECH)
        ; 
        ; Typist - VistA stores as free text
        I LA("SUB")?1(1"SP",1"CY",1"EM"),$P(LA763(0),"^",9)'="" S OBR(35)=$$OBR35^LA7VOBR($P(LA763(0),"^",9),LADFINST,LA7FS,LA7ECH)
        ;
        ; Procedure code - use Order NLT code
        S OBR(44)=$$OBR44^LA7VOBR(LA7NLT,LA7FS,LA7ECH)
        ;
        I LA7INTYP=80 K OBR(15),OBR(18),OBR(19),OBR(20),OBR(21),OBR(44)
        ;
        D BUILDSEG^LA7VHLU(.OBR,.LA7DATA,LA7FS)
        D FILESEG^LA7VHLU(GBL,.LA7DATA)
        ;
        ; Check for flag to only build message but do not file
        I '$G(LA7NOMSG) D FILE6249^LA7VHLU(LA76249,.LA7DATA)
        ;
        Q
