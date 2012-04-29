LA7VORM1 ;DALOI/DLR - LAB ORM (Order) message builder ;1/27/07  12:25
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**27,51,46,61,64,73**;Sep 27, 1994;Build 7
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
BUILD(LA7628) ;
 ; Call with LA7628 = ien of entry in file #62.8 Shipping Manifest
 ;
 N LA7101,LA762801,LA7629,LA7NVAF,LA7PIDSN,LA7X,ECNT,GBL,SHP,SHPC,SITE,ORUID,NTST
 N LDATE,LDATE2
 ;
 I $G(LA7628)<1!('$D(^LAHM(62.8,+$G(LA7628),0))) D  Q
 . ; Need to add error logging for manifest not found.
 . D EXIT
 ;
 S LDATE2=$P(^LAHM(62.8,LA7628,0),"-",2)
 S LDATE=($E(LDATE2,1,4)-1700)_$E(LDATE2,5,8)
 S GBL="^TMP(""HLS"","_$J_")",ECNT=1
 S LA7628(0)=$G(^LAHM(62.8,LA7628,0))
 S LA7629=$P(LA7628(0),U,2)
 S LA7629(0)=$G(^LAHM(62.9,LA7629,0))
 S LA76248=+$P(LA7629(0),"^",7)
 S LA76248(0)=$G(^LAHM(62.48,LA76248,0))
 I '$P(LA76248(0),"^",3) D EXIT Q  ; not active
 ;
 S LA7V("INST")=$P(LA7629(0),U,11)
 Q:LA7V("INST")=$P(LA7629(0),U,6)  ;Same system shipment
 ;
 S LA7NVAF=$$NVAF^LA7VHLU2(+LA7V("INST")),SITE=""
 I LA7NVAF=0 S SITE=$$GET1^DIQ(4,+$P(LA7629(0),U,11)_",",99)
 I LA7NVAF=1 S SITE=$$ID^XUAF4("DMIS",+$P(LA7629(0),U,11))
 S LA7V("NON")=$P(LA7629(0),U,12)
 I LA7V("NON")'="" S SITE=LA7V("NON")
 ;
 S LA7X=$$NVAF^LA7VHLU2(+$P(LA7629(0),U,2))
 I LA7X=0 S LA7V("CLNT")=$$GET1^DIQ(4,+$P(LA7629(0),U,2)_",",99)
 I LA7X=1 S LA7V("CLNT")=$$ID^XUAF4("DMIS",+$P(LA7629(0),U,2))
 S $P(LA7V("CLNT"),U,2)=$$GET1^DIQ(4,+$P(LA7629(0),U,2)_",",.01)
 ;
 S LA7X=$$NVAF^LA7VHLU2(+$P(LA7629(0),U,3))
 I LA7X=0 S LA7V("HOST")=$$GET1^DIQ(4,+$P(LA7629(0),U,3)_",",99)
 I LA7X=1 S LA7V("HOST")=$$ID^XUAF4("DMIS",+$P(LA7629(0),U,3))
 S $P(LA7V("HOST"),U,2)=$$GET1^DIQ(4,+$P(LA7629(0),U,3)_",",.01)
 ;
 ; Assuming the receiving institution is the primary site (site with the computer system)
 ;
 ; Sort tests by patient,UID,test - only need to build one PID, PV1 per patient
 ; ^TMP("LA7628",$J, LRDFN, accession UID, ien of shipping manifest specimen entry)
 K ^TMP("LA7628",$J)
 S LA762801=0
 F  S LA762801=$O(^LAHM(62.8,LA7628,10,LA762801)) Q:'LA762801  D
 . S X(0)=$G(^LAHM(62.8,LA7628,10,LA762801,0))
 . I $P(X(0),"^",8)=0 Q  ; Removed from manifest
 . I $P(X(0),"^"),$L($P(X(0),"^",5)) S ^TMP("LA7628",$J,+$P(X(0),"^"),$P(X(0),"^",5),LA762801)=""
 K LA762801
 ;
 ; Nothing to send
 I '$D(^TMP("LA7628",$J)) D EXIT Q
 ;
 ; Set flag = 0 (multiple PID's/message - build one message)
 ;            1 (one PID/message - build multiple messages)
 ;            2 (one ORC/message - build multiple messages)
 S LA7SMSG=+$P(LA76248(0),"^",8)
 ;
 I LA7SMSG=0 D  Q:$G(HL)
 . D STARTMSG
 . I $G(HL) D EXIT
 ;
 S (LRDFN,LRI,LA7PIDSN)=0
 F  S LRDFN=$O(^TMP("LA7628",$J,LRDFN)) Q:'LRDFN  D  Q:$G(HL)
 . N LA7PID,LA7PV1,ORNUM
 . I LA7SMSG=1 D STARTMSG Q:$G(HL)
 . I LA7SMSG<2 D PID,PV1,IN1^LA7VORM4
 . S LA7UID=""
 . F  S LA7UID=$O(^TMP("LA7628",$J,LRDFN,LA7UID)) Q:LA7UID=""  D
 . . N LA76802,LA7ORC,X,ORCCHK,DGCHK
 . . S ORCCHK="",DGCHK=""
 . . S X=$Q(^LRO(68,"C",LA7UID))
 . . I $QS(X,3)'=LA7UID Q
 . . S LRAA=$QS(X,4),LRAD=$QS(X,5),LRAN=$QS(X,6)
 . . F I=0,.3,3 S LA76802(I)=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,I))
 . . S I=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,5,0))
 . . S LA76802(5)=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,5,I,0))
 . . ;check for VOE before inserting insurance
 . . I DUZ("AG")="E",LA7SMSG=2 D STARTMSG Q:$G(HL)  D PID,PV1,IN1^LA7VORM4
 . . I DUZ("AG")'="E",LA7SMSG=2 D STARTMSG Q:$G(HL)  D PID,PV1
 . . S (LA7OBRSN,LA762801)=0
 . . F  S LA762801=$O(^TMP("LA7628",$J,LRDFN,LA7UID,LA762801)) Q:'LA762801  D
 . . . N LA7OBR,I
 . . . F I=0,.1,1,2,5 S LA762801(I)=$G(^LAHM(62.8,LA7628,10,LA762801,I))
 . . . I $$CHKTST^LA7SMU(LA7628,LA762801)'=0 Q  ;deleted accession
 . . . ; check for VOE to prepare for Diagnosis codes.
 . . . I DUZ("AG")="E" D  ; check for VOE
 . . . . S ITEMNUM=0
 . . . . F  S ITEMNUM=ITEMNUM+1 Q:ITEMNUM>$P(^LRO(69,LDATE,1,0),"^",4)  D
 . . . . . I LRDFN=$P(^LRO(69,LDATE,1,ITEMNUM,0),"^") S ORNUM=$P(^LRO(69,LDATE,1,ITEMNUM,0),"^",11)
 . . . . I ORCCHK'=1 D ORC S ORCCHK=1
 . . . . D OBR^LA7VORM3,OBX^LA7VORM3
 . . . E  D  ; not VOE
 . . . . D ORC,OBR^LA7VORM3,OBX^LA7VORM3
 . . ; check for VOE before inserting Diagnosis code
 . . I DUZ("AG")="E",DGCHK'=1 D DG1^LA7VORM4(ORNUM) S DGCHK=1
 . . I LA7SMSG=2 D BLG,SENDMSG
 . I LA7SMSG<2 D BLG
 . I LA7SMSG=1 D SENDMSG
 ;
 I LA7SMSG=0 D SENDMSG
 ;
 ;
EXIT ;
 K @GBL,^TMP("LA7628",$J)
 K DIC,DFN,EID,HL,HLCOMP,HLFS,HLQ,HLSUB,INT
 K LA760,LA7628,LA762801,LA7629
 K LA7ECH,LA7FS,LA7MID,LA7V,LA7HDR,LA7OBRSN,LA7OBXSN,LA7VIEN,LAEVNT
 K LRAA,LRACC,LRAD,LRAN,LRDFN,LRI
 K LTST,NLT,NLTIEN,PCNT,RUID,SNIEN,TIEN,X,Y,LA
 K ORCCHK,DGCHK,LDATE,LDATE2
 D KVAR^LRX
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
 ;
STARTMSG ; Create/initialize HL message
 ;
 K @GBL
 S (LA76249,LA7PIDSN)=0
 D STARTMSG^LA7VHLU("LA7V Order to "_SITE,.LA76249)
 Q
 ;
 ;
SENDMSG ; File HL7 message with HL and LAB packages.
 ;
 N LA7DATA,LA7ID
 S LA7ID="LA7V HOST "_SITE_"-O-"_$P($G(LA7628(0)),"^")
 ; If no message to send then quit
 I '$D(^TMP("HLS",$J)) D  Q
 . N FDA,LA7ER
 . I $G(LA76248) S FDA(1,62.49,LA76249_",",.5)=LA76248
 . S FDA(1,62.49,LA76249_",",1)="O"
 . S FDA(1,62.49,LA76249_",",2)="E"
 . S FDA(1,62.49,LA76249_",",5)=LA7ID
 . D FILE^DIE("","FDA(1)","LA7ER(1)")
 . D CLEAN^DILF
 . L -^LAHM(62.49,LA76249)
 ;
 D GEN^LA7VHLU
 S LA7DATA="SM06"_"^"_$$NOW^XLFDT
 D SEUP^LA7SMU($P(LA7628(0),"^"),"1",LA7DATA)
 D UPDT6249
 ; Unlock entry
 L -^LAHM(62.49,LA76249)
 Q
 ;
 ;
UPDT6249 ; update entry in 62.49
 ;
 N FDA,LA7ER
 ;
 I $G(LA76248) S FDA(1,62.49,LA76249_",",.5)=LA76248
 S FDA(1,62.49,LA76249_",",1)="O"
 I $P(^LAHM(62.49,LA76249,0),"^",3)'="E" D
 . I $G(HL("APAT"))="AL" S FDA(1,62.49,LA76249_",",2)="A"
 . E  S FDA(1,62.49,LA76249_",",2)="X"
 . I $G(LA7ERR) S FDA(1,62.49,LA76249_",",2)="E"
 S FDA(1,62.49,LA76249_",",5)=LA7ID
 I $G(HL("SAN"))'="" S FDA(1,62.49,LA76249_",",102)=HL("SAN")
 I $G(HL("SAF"))'="" S FDA(1,62.49,LA76249_",",103)=HL("SAF")
 I $G(HL("MTN"))'="" S FDA(1,62.49,LA76249_",",108)=HL("MTN")
 I $G(HL("PID"))'="" S FDA(1,62.49,LA76249_",",110)=HL("PID")
 I $G(HL("VER"))'="" S FDA(1,62.49,LA76249_",",111)=HL("VER")
 I $P($G(LA7MID),"^")'="" S FDA(1,62.49,LA76249_",",109)=$P(LA7MID,"^")
 I $P($G(LA7MID),"^",2) D
 . S FDA(1,62.49,LA76249_",",160)=$P(LA7MID,"^",2)
 . S FDA(1,62.49,LA76249_",",161)=$P(LA7MID,"^",3)
 D FILE^DIE("","FDA(1)","LA7ER(1)")
 D CLEAN^DILF
 Q
 ;
 ;
PID ; Patient identification
 S LRDPF=$P(^LR(LRDFN,0),"^",2),DFN=$P(^(0),"^",3)
 D DEM^LRX
 D PID^LA7VPID(LRDFN,"",.LA7PID,.LA7PIDSN,.HL,"")
 ; DoD/CHCS facilities only use 1st repetition of PID-3.
 I LA7NVAF=1 D
 . S X=$P(LA7PID(0),LA7FS,4),X=$P(X,$E(LA7ECH,2))
 . S $P(LA7PID(0),LA7FS,4)=X
 D FILESEG^LA7VHLU(GBL,.LA7PID)
 D FILE6249^LA7VHLU(LA76249,.LA7PID)
 Q
 ;
 ;
PV1 ; Location information
 ; DoD/CHCS facilities do not use PV1 segment
 I LA7NVAF=1 Q
 ;
 D PV1^LA7VPID(LRDFN,.LA7PV1,LA7FS,LA7ECH)
 D FILESEG^LA7VHLU(GBL,.LA7PV1)
 D FILE6249^LA7VHLU(LA76249,.LA7PV1)
 Q
 ;
 ;
ORC ;Order Control
 ;
 N ORC,LA7DATA,LA7DUR,LA7DURU,LA76205,LA762801,LA7X
 ;
 S ORC(0)="ORC"
 S ORC(1)=$$ORC1^LA7VORC("NW")
 ;
 ; Place order number - accession UID
 S ORC(2)=$$ORC2^LA7VORC($P(LA76802(.3),"^"),LA7FS,LA7ECH)
 ;
 ; Placer group number - shipping manifest invoice #
 S ORC(4)=$$ORC4^LA7VORC($P(LA7628(0),"^"),LA7FS,LA7ECH)
 ;
 ; Quantity/Timing
 S (LA76205,LA7DUR,LA7DURU)=""
 S LA762801=0
 F  S LA762801=$O(^TMP("LA7628",$J,LRDFN,LA7UID,LA762801)) Q:'LA762801  D
 . N I,LA760
 . ; Test duration
 . F I=0,2 S LA762801(I)=$G(^LAHM(62.8,LA7628,10,LA762801,I))
 . I $P(LA762801(2),"^",4) D
 . . S LA7DUR=$P(LA762801(2),"^",6) ; collection duration
 . . S LA7DURU=$P(LA762801(2),"^",7) ; duration units
 . ; Test urgency - find highest urgency on accession
 . S LA760=+$P(LA762801(0),"^",2)
 . S X=+$$GET1^DIQ(68.04,LA760_","_LRAN_","_LRAD_","_LRAA_",",1,"I")
 . I 'LA76205 S LA76205=X
 . I LA76205,X<LA76205 S LA76205=X
 S ORC(7)=$$ORC7^LA7VORC(LA7DUR,LA7DURU,LA76205,LA7FS,LA7ECH)
 ;
 ; Order Date/Time - if no order date/time then try draw time
 I $P(LA76802(0),"^",4) S ORC(9)=$$ORC9^LA7VORC($P(LA76802(0),"^",4))
 I '$P(LA76802(0),"^",4),$P(LA76802(3),"^") S ORC(9)=$$ORC9^LA7VORC($P(LA76802(3),"^"))
 ;
 ; Ordering provider
 S LA7X=$$FNDOLOC^LA7VHLU2(LA7UID)
 S ORC(12)=$$ORC12^LA7VORC($P(LA76802(0),"^",8),$P(LA7X,"^",3),LA7FS,LA7ECH)
 ;
 ; Entering organization - VA facility
 S ORC(17)=$$ORC17^LA7VORC($P($G(LA7629(0)),U,2),LA7FS,LA7ECH)
 ;
 D BUILDSEG^LA7VHLU(.ORC,.LA7DATA,LA7FS)
 D FILESEG^LA7VHLU(GBL,.LA7DATA)
 D FILE6249^LA7VHLU(LA76249,.LA7DATA)
 Q
 ;
BLG ; Billing segment
 ;
 N LA7BLG
 ;
 I $P(LA7629(0),U,13)="" Q
 S LA7BLG(0)=$$BLG^LA7VHLU($P(LA7629(0),"^",13),"CO",LA7FS,LA7ECH)
 D FILESEG^LA7VHLU(GBL,.LA7BLG)
 D FILE6249^LA7VHLU(LA76249,.LA7BLG)
 Q
