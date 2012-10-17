LA7VOBRB        ;DALOI/JMC - LAB OBR segment builder (cont'd);Jun 25, 2012
        ;;5.2;AUTOMATED LAB INSTRUMENTS;**68,250068**;Sep 27, 1994;Build 9
        ;
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
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
        ;
OBR15   ; Build OBR-15 sequence - specimen source
        ;
        S LA764061=0
        S LA7COMP=0 ; specify subcomponent position - primary/alternate
        S LA7Y="",LA7SNM=$G(LA7SNM)
        ;
        ; Get entry in #64.061 and SNOMED code for this Topography file #61 entry.
        I LA761>0 D
        . S LA761(0)=$G(^LAB(61,LA761,0)),LA764061=$P(LA761(0),"^",9)
        . S $P(LA7Y,$E(LA7ECH,4),9)=$$CHKDATA^LA7VHLU3($P(LA761(0),"^"),LA7FS_LA7ECH)
        ;
        ; If no specimen code then default to HL7 0070 entry "XXX"
        I LA764061<1 D
        . N LA7SCR
        . S LA7SCR="I $P(^LAB(64.061,Y,0),U,5)=""0070"",$P(^LAB(64.061,Y,0),U,7)=""S"""
        . S LA764061=$$FIND1^DIC(64.061,,"X","XXX","D",LA7SCR,"LA7ERR")
        ;
        I LA764061 D GETS^DIQ(64.061,LA764061_",",".01;1;2;3;5","","LA7Z","LA7ERR")
        ;
        ; Send non-standard local code as primary
        I $P(LA7ALT,"^")'=""!($P(LA7ALT,"^",2)'="") D
        . S LA7X=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^"),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH,4),1)=LA7X
        . S LA7X=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",2),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH,4),2)=LA7X
        . S $P(LA7Y,$E(LA7ECH,4),3)=$P(LA7ALT,"^",3)
        . S LA7COMP=LA7COMP+3
        ;
        ; Send HL7 Table 0070 coding as primary code
        I 'LA7SNM,LA764061,LA7Z(64.061,LA764061_",",2)'="",LA7COMP<6 D
        . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",2),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)=LA7X
        . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",.01),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
        . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)="HL7"_LA7Z(64.061,LA764061_",",5)
        . S LA7COMP=LA7COMP+3
        ;
        ; Build SNOMED CT as primary code
        ;I LA761,LA7COMP<6 D
        ;. S LA7X=$$IEN2SCT^LA7VSPMA(61,LA761,DT)
        ;. I LA7X="" Q
        ;. S $P(LA7X,"^",2)=$$CHKDATA^LA7VHLU3($P(LA7X,"^",2),LA7FS_LA7ECH)
        ;. S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1,LA7COMP+3)=$TR($P(LA7X,"^",1,3),"^",$E(LA7ECH,4))
        ;. S $P(LA7Y,$E(LA7ECH,4),7)=$P(LA7X,"^",4)
        ;. S LA7COMP=LA7COMP+3
        ;
        ; If VA code and not HL7 and/or LOINC
        I LA764061,LA7Z(64.061,LA764061_",",3)'="",LA7COMP<6 D
        . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",3),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)=LA7X
        . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",.01),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
        . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)="99VA64.061"
        . S $P(LA7Y,$E(LA7ECH,4),$S(LA7COMP<4:7,1:8))="5.2"
        ;
        ; LA7ALT should contain "CONTROL" in 4th piece if from file #62.3
        I $P(LA7ALT,"^",4)'="" D
        . N LA7TXT
        . S LA7TXT=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",4),LA7FS_LA7ECH)
        . S $P(LA7Y,$E(LA7ECH,1),3)=LA7TXT
        ;
        ; Get entry in #62 for this collection sample entry.
        I LA762,$P(LA7ALT,"^",5)="",$P(LA7ALT,"^",6)="" D
        . S LA7X=$$GET1^DIQ(62,LA762_",",.01,"","LA7ERR")
        . S LA7X=$$TRIM^XLFSTR(LA7X,"LR"," ")
        . S LA7X=$$CHKDATA^LA7VHLU3(LA7X,LA7FS_LA7ECH)
        . S LA7X=LA762_$E(LA7ECH,4)_LA7X_$E(LA7ECH,4)_"99VA62"
        . S $P(LA7Y,$E(LA7ECH,1),4)=LA7X
        ;
        ; Send collection sample code for DoD.
        I $P(LA7ALT,"^",5)'=""!($P(LA7ALT,"^",6)'="") D
        . S X=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",5),LA7FS_LA7ECH)
        . S Y=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",6),LA7FS_LA7ECH)
        . S LA7X=X_$E(LA7ECH,4)_Y_$E(LA7ECH,4)_$P(LA7ALT,"^",7)
        . S $P(LA7Y,$E(LA7ECH,1),4)=LA7X
        ;
        ; Send specimen shipping condition - collection method
        I $G(LA7CM) D
        . S X=$$GET1^DIQ(62.93,LA7CM_",",.01)
        . I X'="" S X=$$CHKDATA^LA7VHLU3(X,LA7FS_LA7ECH)
        . S Y=$$GET1^DIQ(62.93,LA7CM_",",.02)
        . I Y'="" S Y=$$CHKDATA^LA7VHLU3(Y,LA7FS_LA7ECH)
        . S LA7X=Y_$E(LA7ECH,4)_X_$E(LA7ECH,4)_"99VA62.93"
        . S $P(LA7Y,$E(LA7ECH,1),6)=LA7X
        Q
