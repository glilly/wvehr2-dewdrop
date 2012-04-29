LA7VOBRA ;DALOI/JMC - LAB OBR segment builder (cont'd); 11-14-01
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64**;Sep 27, 1994
 ;
 Q
 ;
 ;
OBR4 ; Build OBR-4 sequence - Universal service ID
 ;
 S LA764=0,LA7Y=""
 ; specify component position - primary/alternate
 S LA7COMP=0
 ;
 ; Send non-VA test codes as first coding system
 I LA7ALT'="" D
 . N I
 . F I=1:1:3 S $P(LA7Y,$E(LA7ECH),LA7COMP+I)=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",I),LA7FS_LA7ECH)
 . S LA7COMP=LA7COMP+I
 ;
 ; Send NLT test codes as primary unless non-VA codes then send as alternate code
 I LA7NLT'="" D
 . S LA764=$O(^LAM("E",LA7NLT,0)),LA7Z=""
 . I LA764 S LA7Z=$$GET1^DIQ(64,LA764_",",.01,"I")
 . I LA7Z="" D
 . . N LA7642
 . . S LA764=$O(^LAM("E",$P(LA7NLT,".")_".0000",0))
 . . I LA764 S LA7Z=$$GET1^DIQ(64,LA764_",",.01,"I")
 . . S LA7642=$O(^LAB(64.2,"C","."_$P(LA7NLT,".",2),0))
 . . I LA764,LA7642 S LA7Z=LA7Z_"~"_$$GET1^DIQ(64.2,LA7624_",",.01,"I")
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+1)=$$CHKDATA^LA7VHLU3(LA7NLT,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+2)=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+3)="99VA64"
 . S LA7COMP=LA7COMP+3
 ;
 ; Send file #60 test name if available and no alternate
 I LA7COMP<4,LA760 D
 . S LA7TN=$$GET1^DIQ(60,LA760_",",.01)
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+1)=LA760
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+2)=$$CHKDATA^LA7VHLU3(LA7TN,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH),LA7COMP+3)="99VA60"
 ;
 Q
 ;
 ;
OBR9 ; Build OBR-9 sequence - collection volume
 ;
 ; Collection volume
 S $P(LA7Y,$E(LA7ECH,1))=LA7VOL
 ;
 I LA764061 D
 . S LA7IENS=LA764061_","
 . D GETS^DIQ(64.061,LA7IENS,".01;1","E","LA7Y")
 . ; Collection Volume units code
 . S $P(LA7X,$E(LA7ECH,4),1)=$G(LA7Y(64.061,LA7IENS,.01,"E"))
 . ; Collection Volume units text
 . S $P(LA7X,$E(LA7ECH,4),2)=$$CHKDATA^LA7VHLU3($G(LA7Y(64.061,LA7IENS,1,"E")),LA7FS_LA7ECH)
 . ; LOINC coding system
 . S $P(LA7X,$E(LA7ECH,4),3)="LN"
 . S $P(LA7Y,$E(LA7ECH,1),2)=LA7X
 ;
 Q
 ;
 ;
OBR15 ; Build OBR-15 sequence - specimen source
 ;
 S LA764061=0
 S LA7COMP=0 ; specify subcomponent position - primary/alternate
 S LA7Y=""
 ;
 ; Get entry in #64.061 for this Topography file #61 entry.
 I LA761>0 S LA764061=$$GET1^DIQ(61,LA761_",",.09,"I","LA7ERR")
 ;
 ; If no specimen code then default to HL7 0070 entry "XXX"
 I LA764061<1 D
 . N LA7SCR
 . S LA7SCR="I $P(^LAB(64.061,Y,0),U,5)=""0070"",$P(^LAB(64.061,Y,0),U,7)=""S"""
 . S LA764061=$$FIND1^DIC(64.061,,"X","XXX","D",LA7SCR,"LA7ERR")
 ;
 I LA764061<1 Q LA7Y
 ;
 D GETS^DIQ(64.061,LA764061_",",".01;1;2;3;5","","LA7Z","LA7ERR")
 I '$D(LA7Z) Q LA7Y
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
 I LA7Z(64.061,LA764061_",",2)'="",LA7COMP<6 D
 . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",2),LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)=LA7X
 . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",.01),LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
 . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)="HL7"_LA7Z(64.061,LA764061_",",5)
 . S LA7COMP=LA7COMP+3
 ;
 ; Send LOINC code as primary unless HL7 code then send as alternate code
 I LA7Z(64.061,LA764061_",",1)'="",LA7COMP<6 D
 . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",1),LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)=LA7X
 . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",.01),LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
 . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)="LN"
 . S LA7COMP=LA7COMP+3
 ;
 ; If VA code and not HL7 and/or LOINC
 I LA7Z(64.061,LA764061_",",3)'="",LA7COMP<6 D
 . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",3),LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+1)=LA7X
 . S LA7X=$$CHKDATA^LA7VHLU3(LA7Z(64.061,LA764061_",",.01),LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+2)=LA7X
 . S $P(LA7Y,$E(LA7ECH,4),LA7COMP+3)="99VA64.061"
 ;
 ; LA7ALT should contain "CONTROL" in 4th piece if from file #62.3
 I $P(LA7ALT,"^",4)'="" D
 . N LA7TXT
 . S LA7TXT=$$CHKDATA^LA7VHLU3($P(LA7ALT,"^",4),LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),3)=LA7TXT
 ;
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
 ;
 ;
OBR24 ; Build OBR-24 sequence - diagnostic service id
 ;
 ; Code non-MI subscripts
 I $P(LA7SS,"^")'="MI" D  Q
 . S LA7X=$P(LA7SS,"^")
 . S LA7Y=$S(LA7X="CH":"CH",LA7X="SP":"SP",LA7X="CY":"CP",LA7X="EM":"PAT",LA7X="AU":"PAT",LA7X="BB":"BLB",1:"LAB")
 ;
 ; Code MI subscripts
 S LA7X=$P(LA7SS,"^",2)
 S LA7Y=$S(LA7X=11:"MB",LA7X=14:"PAR",LA7X=18:"MYC",LA7X=22:"MCB",LA7X=33:"VR",1:"MB")
 ;
 Q
 ;
 ;
OBR26 ; Build OBR-26 sequence - Parent result
 ;
 S LA7Y=""
 ;
 ; Move component into sub-component position
 ; Translate component character to sub-component character
 S LA7C=$E(LA7ECH,1),LA7SC=$E(LA7ECH,4)
 ;
 ; Parent result observation identifier in 1st component
 I LA7OBX3'="" S $P(LA7Y,$E(LA7ECH,1),1)=$TR(LA7OBX3,LA7C,LA7SC)
 ;
 ; Parent sub-id in 2nd component
 I LA7OBX4'="" S $P(LA7Y,$E(LA7ECH,1),2)=$TR(LA7OBX4,LA7C,LA7SC)
 ;
 ; Parent test result in 3rd component
 I LA7OBX5'="" S $P(LA7Y,$E(LA7ECH,1),3)=$TR(LA7OBX5,LA7C,LA7SC)
 ;
 Q
 ;
 ;
OBR29 ; Build OBR-29 sequence - Parent
 ;
 S LA7Y=""
 ;
 I $G(LA7PON)'="" D
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7PON,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,1),1)=LA7Z
 ;
 I $G(LA7FON)'="" D
 . S LA7Z=$$CHKDATA^LA7VHLU3(LA7FON,LA7FS_LA7ECH)
 . S $P(LA7Y,$E(LA7ECH,2),1)=LA7Z
 ;
 Q
 ;
 ;
OBRPF ; Build OBR-18,19,20,21 Placer/Filler #1/#2
 ;
 S (LA7Y,LA7Z)="",LA7I=0
 F  S LA7I=$O(LA7X(LA7I)) Q:'LA7I  S $P(LA7Z,"^",LA7I)=LA7X(LA7I)
 S LA7Y=$$CHKDATA^LA7VHLU3(LA7Z,LA7FS_LA7ECH)
 Q
