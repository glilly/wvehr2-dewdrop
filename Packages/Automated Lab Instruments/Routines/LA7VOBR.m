LA7VOBR ;DALOI/JMC - LAB OBR segment builder ; 11-17-98
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64**;Sep 27, 1994
 ;
 Q
 ;
 ;
OBR1(LA7OBRSN) ; Build OBR-1 sequence - set segment id
 ; Call with LA7OBRSN = segment id (pass by reference)
 ;
 S LA7OBRSN=$G(LA7OBRSN)+1
 ;
 Q LA7OBRSN
 ;
OBR2(LA7ID,LA7FS,LA7ECH) ; Build OBR-2 sequence - placer's specimen id
 ; Call with LA7ID = placer's specimen id (accn number/UID)
 ;           LA7FS = HL7 field separator
 ;          LA7ECH = HL encoding characters
 ;
 N LA7Y
 ;
 S LA7ID=$$CHKDATA^LA7VHLU3(LA7ID,LA7FS_LA7ECH)
 S $P(LA7Y,$E(LA7ECH,1),1)=LA7ID
 ;
 Q LA7Y
 ;
 ;
OBR3(LA7ID,LA7FS,LA7ECH) ; Build OBR-3 sequence - filler's specimen id
 ; Call with LA7ID = filler's specimen id (accn number/UID)
 ;           LA7FS = HL7 field separator
 ;          LA7ECH = HL encoding characters
 ;
 N LA7Y
 ;
 S LA7ID=$$CHKDATA^LA7VHLU3(LA7ID,LA7FS_LA7ECH)
 S $P(LA7Y,$E(LA7ECH,1),1)=LA7ID
 ;
 Q LA7Y
 ;
 ;
OBR4(LA7NLT,LA760,LA7ALT,LA7FS,LA7ECH) ; Build OBR-4 sequence - Universal service ID
 ; Call with LA7NLT = NLT test code
 ;            LA760 = file #60 ien if known
 ;           LA7ALT = alternate order code and system in form 
 ;                     test code^test name^coding system
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns     LA7Y = OBR-4 sequence
 ;
 N LA764,LA7COMP,LA7ERR,LA7TN,LA7X,LA7Y,LA7Z
 ;
 D OBR4^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR7(LA7DT) ; Build OBR-7 sequence - collection date/time
 ; Call with LA7DT = FileMan date/time
 ; Returns OBR-7 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBR8(LA7DT) ; Build OBR-8 sequence - collection end date/time
 ; Call with LA7DT = FileMan date/time
 ; Returns OBR-8 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBR9(LA7VOL,LA764061,LA7FS,LA7ECH) ; Build OBR-9 sequence - collection volume
 ; Call with    LA7VOL = collection volume
 ;            LA764061 = units (pointer to #64.061)
 ;               LA7FS = HL7 field separator
 ;              LA7ECH = HL encoding characters
 ; Returns OBR-9 sequence
 ;
 N LA7IENS,LA7X,LA7Y
 ;
 D OBR9^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR11(LA7X) ; Build OBR-11 sequence - speciman action code
 ; Call with LA7X = HL7 Table 0065 entry
 ; Returns OBR-11 sequence
 ;
 ; JMC-12/09/99 Need to expand this function to determine based on collection status
 ;
 Q LA7X
 ;
 ;
OBR12(LRDFN,LA7FS,LA7ECH) ; Build OBR-12 sequence - patient info
 ; Call with  LRDFN = ien of patient in #63
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL7 encoding characters
 ; Returns OBR-12 sequence
 ;
 N LA7X
 ;
 S LRDFN=$G(LRDFN),LA7ECH=$G(LA7ECH)
 ; Infection Warning
 S LA7X=$P($G(^LR(LRDFN,.091)),U)
 S LA7X=$$CHKDATA^LA7VHLU3(LA7X,LA7FS_LA7ECH)
 ;
 Q $E(LA7ECH,1)_LA7X
 ;
 ;
OBR13(LA7TXT,LA7FS,LA7ECH) ; Build OBR-13 sequence - revelant clinical info
 ; Call with LA7TXT = text to place into OBR-13
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL7 encoding characters
 ; Returns OBR-12 sequence
 ;
 N LA7X
 ;
 S LA7X=$$CHKDATA^LA7VHLU3(LA7TXT,LA7FS_LA7ECH)
 ;
 Q LA7X
 ;
 ;
OBR14(LA7DT) ; Build OBR-14 sequence - speciman arrival date/time
 ; Call with LA7DT = FileMan date/time
 ; Returns OBR-14 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBR15(LA761,LA762,LA7ALT,LA7FS,LA7ECH,LA7CM) ; Build OBR-15 sequence - specimen source
 ; Call with LA761 = ien of topography file #61
 ;           LA762 = ien of collection sample in file #62
 ;          LA7ALT = alternate non-HL7 codes/text/coding system in form -
 ;                   specimen code^specimen text^specimen system^CONTROL^collection sample code^collection sample^collection system.
 ;                   "CONTROL" only present when specimen is a lab control from file #62.3.
 ;                   presence of these will override standard HL7 tables
 ;           LA7FS = HL7 field separator
 ;          LA7ECH = HL encoding characters
 ;           LA7CM = ien of shipping condition file #62.93 (collection method)
 ; Returns OBR-15 sequence in LA7Y
 ;
 N LA764061,LA7COMP,LA7ERR,LA7X,LA7Y,LA7Z,X,Y
 ;
 D OBR15^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR18(LA7X,LA7FS,LA7ECH) ; Build OBR-18 sequence - Placer's field #1
 ; Call with   LA7X = array containing components to store, pass by reference.
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns OBR-18 sequence
 ;
 N LA7I,LA7Y,LA7Z
 ;
 D OBRPF^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR19(LA7X,LA7FS,LA7ECH) ; Build OBR-19 sequence - Placer's field #2
 ; Call with LA7X() = array containing components to store, pass by reference.
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns OBR-19 sequence
 ;
 N LA7I,LA7Y,LA7Z
 ;
 D OBRPF^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR20(LA7X,LA7FS,LA7ECH) ; Build OBR-20 sequence - Filler's field #1
 ; Call with   LA7X = array containing components to store, pass by reference.
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns OBR-20 sequence
 ;
 N LA7I,LA7Y,LA7Z
 ;
 D OBRPF^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR21(LA7X,LA7FS,LA7ECH) ; Build OBR-21 sequence - Filler's field #2
 ; Call with LA7X() = array containing components to store, pass by reference.
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL encoding characters
 ;
 ; Returns OBR-21 sequence
 ;
 N LA7I,LA7Y,LA7Z
 ;
 D OBRPF^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR22(LA7DT) ; Build OBR-22 sequence - date report completed
 ; Call with LA7DT = FileMan date/time
 ;
 ; Returns OBR-22 sequence
 ;
 S LA7DT=$$CHKDT^LA7VHLU1(LA7DT)
 Q $$FMTHL7^XLFDT(LA7DT)
 ;
 ;
OBR24(LA7SS) ; Build OBR-24 sequence - diagnostice service id
 ; Call with LA7SS = File #63 subscript^section within subscript
 ;
 ; Returns OBR-24 sequence
 ;
 N LA7Y,LA7X
 ;
 D OBR24^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR26(LA7OBX3,LA7OBX4,LA7OBX5,LA7FS,LA7ECH)     ; Build OBR-26 sequence - Parent result
 ; Call with LA7OBX3 = OBX-3 observation id of parent result
 ;           LA7OBX4 = OBX-4 sub-id of parent result
 ;           LA7OBX5 = OBX-5 parent result
 ;             LA7FS = HL7 Field separator
 ;            LA7ECH = HL7 encoding characters
 ;
 N LA7C,LA7SC,LA7Y,LA7Z
 ;
 D OBR26^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR27(LA7DUR,LA7DURU,LA76205,LA7FS,LA7ECH) ; Build OBR-27 sequence - Quantity/Timing
 ; Call with  LA7DUR = collection duration
 ;           LA7DURU = duration units (pointer to #64.061)
 ;           LA76205 = test urgency
 ;             LA7FS = HL7 field separator
 ;            LA7ECH = HL encoding characters
 ;
 ; Returns OBR-27 sequence
 ;
 ; Since field is same as ORC-7, use builder for ORC-7 field.
 ;
 ;
 Q $$ORC7^LA7VORC(LA7DUR,LA7DURU,LA76205,LA7FS,LA7ECH)
 ;
 ;
OBR29(LA7PON,LA7FON,LA7FS,LA7ECH)       ; Build OBR-29 sequence - Parent
 ; Call with LA7PON = parent's placer order number
 ;           LA7FON = parent's filler order nubmer
 ;            LA7FS = HL7 field separator
 ;           LA7ECH = HL7 encoding characters
 ;
 N LA7Y,LA7Z
 ;
 D OBR29^LA7VOBRA
 ;
 Q LA7Y
 ;
 ;
OBR32(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build OBR-32 sequence - Principle Result Interpreter field
 ; Call with   LA7DUZ = DUZ of verifying user
 ;             LA7DIV = Institution of user
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns OBR-32 sequence
 ;
 Q $$XCN^LA7VHLU4(LA7DUZ,LA7DIV,LA7FS,LA7ECH)
 ;
 ;
OBR33(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build OBR-32 sequence - Assistant Result Interpreter field
 ; Call with   LA7DUZ = DUZ of assistant interpreter
 ;             LA7DIV = Institution of user
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns OBR-33 sequence
 ;
 Q $$XCN^LA7VHLU4(LA7DUZ,LA7DIV,LA7FS,LA7ECH)
 ;
 ;
OBR34(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build OBR-34 sequence - Technician field
 ; Call with   LA7DUZ = DUZ of techician
 ;             LA7DIV = Institution of user
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns OBR-34 sequence
 ;
 Q $$XCN^LA7VHLU4(LA7DUZ,LA7DIV,LA7FS,LA7ECH)
 ;
 ;
OBR35(LA7DUZ,LA7DIV,LA7FS,LA7ECH) ; Build OBR-35 sequence - Transcriptionist field
 ; Call with   LA7DUZ = DUZ of transcriptionist
 ;             LA7DIV = Institution of user
 ;              LA7FS = HL field separator
 ;             LA7ECH = HL encoding characters
 ;           
 ; Returns OBR-35 sequence
 ;
 Q $$XCN^LA7VHLU4(LA7DUZ,LA7DIV,LA7FS,LA7ECH)
