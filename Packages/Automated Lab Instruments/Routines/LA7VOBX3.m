LA7VOBX3 ;DALOI/JMC - LAB OBX Segment message builder (MI subscripts) cont'd ; 5/26/00
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64**;Sep 27, 1994
 ;
MI ; Build OBX segments for results that are microbiology subscript.
 ; Called by LA7VOBX
 ;
 N I,LA761,LA76305,LA7ALT,LA7ALTCS,LA7CODE,LA7DIV,LA7IENS,LA7LOINC,LA7NLT,LA7OBX,LA7ORS,LA7PARNT,LA7SAVID,LA7SUBFL,LA7VAL,LA7VERP
 ;
 I $P(LRIDT,",",2) S LRIDT(2)=$P(LRIDT,",",2),LRIDT(3)=$P(LRIDT,",",3),LRIDT=$P(LRIDT,",")
 ;
 I '$D(^LR(LRDFN,LRSS,LRIDT)) Q
 ;
 F I=0,1,5,8,11,16 S LA76305(I)=$G(^LR(LRDFN,LRSS,LRIDT,I))
 ;
 S (LA7ALT,LA7ALTCS,LA7CODE,LA7ID,LA7LOINC,LA7NLT,LA7ORS,LA7SAVID,LA7SUBFL,LA7VAL,LA7VERP)=""
 ;
 ; Specimen topography
 S LA761=$P(LA76305(0),"^",5)
 ; Default codes
 S LA7CODE=$$DEFCODE^LA7VHLU5(LRSS,LRSB,LA7CODE,LA761)
 ;
 ; Gram stain
 I LRSB=11.6 D
 . N LA7ERR
 . S LA7VERP=$P(LA76305(1),"^",3)
 . S LA7ORS=$P(LA76305(1),"^",2)
 . S LA7OBX(2)=$$OBX2^LA7VOBX(63.05,11.6)
 . S LA7IENS=LRIDT(2)_","_LRIDT_","_LRDFN_","
 . S LA7VAL=$$GET1^DIQ(63.29,LA7IENS,.01,"","LA7ERR")
 . ; Setup DoD special coding system
 . I LA7NVAF=1,$P(LA7CODE,"!",2) S LA7ALTCS="99VA64MG"
 ;
 ; Micro organism
 I $P(LRSB,",")=12 D
 . S LA7VERP=$P(LA76305(1),"^",3)
 . S LA7ORS=$P(LA76305(1),"^",2)
 . S LA7SUBFL=63.3
 . ; Working on colony count
 . I $P(LRSB,",",2)=1 D CC Q
 . ; Working on organism
 . I $G(LRIDT(3))="" D ORG Q
 . ; Working on susceptibilities
 . I $P(LA76305(1),"^",4) S LA7VERP=$P(LA76305(1),"^",4)
 . D MIC
 ;
 ; Parasite organism
 I $P(LRSB,",")=16 D
 . S LA7ORS=$P(LA76305(5),"^",2)
 . S LA7VERP=$P(LA76305(5),"^",3)
 . ; Working on organism
 . S LA7SUBFL=63.34 D ORG
 ;
 ; Mycology organism
 I $P(LRSB,",")=20 D
 . S LA7ORS=$P(LA76305(8),"^",2)
 . S LA7VERP=$P(LA76305(8),"^",3)
 . S LA7SUBFL=63.37
 . ; Working on colony count
 . I $P(LRSB,",",2)=1 D CC Q
 . ; Working on organism
 . D ORG
 ;
 ; Acid Fast stain
 I LRSB=24 D
 . N LA7ERR
 . S LA7VERP=$P(LA76305(11),"^",3)
 . S LA7ORS=$P(LA76305(11),"^",2)
 . S LA7OBX(2)=$$OBX2^LA7VOBX(63.05,24)
 . S LA7IENS=LRIDT_","_LRDFN_","
 . S LA7VAL=$$GET1^DIQ(63.05,LA7IENS,24,"","LA7ERR")
 ;
 ; Acid Fast stain quantity
 I LRSB=25 D
 . N LA7ERR
 . S LA7VERP=$P(LA76305(11),"^",3)
 . S LA7ORS=$P(LA76305(11),"^",2)
 . S LA7OBX(2)=$$OBX2^LA7VOBX(63.05,25)
 . S LA7IENS=LRIDT_","_LRDFN_","
 . S LA7VAL=$$GET1^DIQ(63.05,LA7IENS,25,"","LA7ERR")
 ;
 ; TB organism
 I $P(LRSB,",")=26 D
 . S LA7ORS=$P(LA76305(11),"^",2)
 . S LA7VERP=$P(LA76305(11),"^",5)
 . S LA7SUBFL=63.39
 . ; Working on organism
 . I $G(LRIDT(3))="" D ORG Q
 . ; Working on susceptibilities
 . D MIC
 ;
 ; Virology virus
 I $P(LRSB,",")=36 D
 . S LA7ORS=$P(LA76305(16),"^",2)
 . S LA7VERP=$P(LA76305(16),"^",3)
 . ; Working on virus
 . S LA7SUBFL=63.43
 . D ORG
 ;
 D GEN
 ;
 Q
 ;
 ;
CC ; Organism's Colony count
 ; If "CFU/ml" found then move units to OBX-6 (Units).
 N LA7X
 ;
 S LA7ID=$P(LRSB,",")_"-"_LRIDT(2)
 S LA7IENS=LRIDT(2)_","_LRIDT_","_LRDFN_","
 S LA7OBX(2)=$$OBX2^LA7VOBX(LA7SUBFL,1)
 S LA7VAL=$$GET1^DIQ(LA7SUBFL,LA7IENS,1)
 S LA7X=$$UP^XLFSTR(LA7VAL)
 I LA7X["CFU/ML" D
 . S LA7OBX(6)="CFU/ml"
 . S LA7X("CFU/ml")="",LA7X("CFU/ML")=""
 . S LA7VAL=$$REPLACE^XLFSTR(LA7VAL,.LA7X)
 ;
 ; Setup DoD special coding system
 I LA7NVAF=1,$P(LA7CODE,"!",2) S LA7ALTCS="99VA64MC"
 ;
 Q
 ;
 ;
ORG ; Organism
 ;
 S LA7ID=LRSB_"-"_LRIDT(2)
 S LA7OBX(2)=$$OBX2^LA7VOBX(LA7SUBFL,.01)
 S LA7IENS=LRIDT(2)_","_LRIDT_","_LRDFN_","
 S LA7VAL=$$GET1^DIQ(LA7SUBFL,LA7IENS,.01)
 ;
 ; Check for Snomed coding
 S X=$$GET1^DIQ(LA7SUBFL,LA7IENS,".01:2")
 I X'="" S LA7VAL=X_"^"_LA7VAL_"^SNM"
 ;
 S LA7OBX(8)=$$OBX8^LA7VOBX("A")
 ;
 ; Setup DoD special coding system
 I LA7NVAF=1,$P(LA7CODE,"!",2) S LA7ALTCS="99VA64MO"
 ;
 ; Set flag to save sub-id for parent-child relationship
 S LA7SAVID=1
 Q
 ;
 ;
MIC ; Organism's susceptibilities
 ;
 N LA7IENS,LA7SUB
 ;
 ; Bact or TB organism
 S LA7SUB=$S($P(LRSB,",")=12:3,1:12)
 ;
 ;S LA7X=$O(^LAB(62.06,"AD",LRIDT(3),0)) Q:'LA7X
 S LA7OBX(2)=$$OBX2^LA7VOBX(62.06,.01)
 ;
 S LA7X=$G(^LR(LRDFN,"MI",LRIDT,LA7SUB,LRIDT(2),LRIDT(3)))
 S LA7VAL=$P(LA7X,"^")
 I LA7VAL'="" D
 . I "SIR"[$E(LA7VAL) S LA7OBX(8)=$$OBX8^LA7VOBX($E(LA7VAL)) Q
 . I "SIR"[$E($P(LA7X,"^",2)) S LA7OBX(8)=$$OBX8^LA7VOBX($E($P(LA7X,"^",2))) Q
 ;
 ; Determine access screen for this susceptibility
 I $P(LA7X,"^",3)="" S $P(LA7X,"^",3)="A"
 S LA7OBX(13)=$$OBX13^LA7VOBX($P(LA7X,"^",3),"MIS",LA7FS,LA7ECH)
 ;
 ; Setup DoD special coding system
 I LA7NVAF=1,$P(LA7CODE,"!",2) S LA7ALTCS="99VA64MS"
 ;
 Q
 ;
 ;
GEN ; Fields common to all MI OBX segments.
 ;
 ; Initialize OBX segment
 S LA7OBX(0)="OBX"
 S LA7OBX(1)=$$OBX1^LA7VOBX(.LA7OBXSN)
 ;
 S LA7OBX(3)=$$OBX3^LA7VOBX($P(LA7CODE,"!",2),$P(LA7CODE,"!",3),LA7ALT,LA7FS,LA7ECH)
 ;
 ; Change normal coding system for DoD special
 I LA7NVAF=1,LA7ALTCS'="" D
 . F I=3,6 I $P(LA7OBX(3),$E(LA7ECH,1),I)="99VA64" S $P(LA7OBX(3),$E(LA7ECH,1),I)=LA7ALTCS Q
 ;
 ; Test value
 S LA7OBX(5)=$$OBX5^LA7VOBX(LA7VAL,LA7OBX(2),LA7FS,LA7ECH)
 ;
 ; Set sub-id and save for constructing parents
 I LA7ID'="" D
 . S LA7OBX(4)=$$OBX4^LA7VOBX(LA7ID,LA7FS,LA7ECH)
 . I LA7SAVID F I=1:1:3 S LA7ID(LA7ID,I)=LA7OBX(I+2)
 ;
 ; Order result status - "P"artial, "F"inal , "A"mended results
 ; If no status from individual components then use status from zeroth node.
 ; If no release date then pending else final
 ; If amended, overrides all other status
 I LA7ORS="" S LA7ORS=$S('$P(LA76305(0),"^",3):"P",1:"F")
 I $P(LA76305(0),"^",9) S LA7ORS="A"
 S LA7OBX(11)=$$OBX11^LA7VOBX(LA7ORS)
 ;
 S LA7DIV=""
 I $$DIV4^XUSER(.LA7DIV,$P(LA76305(0),"^",4)) S LA7DIV=$O(LA7DIV(0))
 ;
 ; Observation date/time - collection date/time per HL7 standard
 I $P(LA76305(0),"^") S LA7OBX(14)=$$OBX14^LA7VOBX($P(LA76305(0),"^"))
 ;
 ; Facility that performed the testing
 S LA7OBX(15)=$$OBX15^LA7VOBX(LA7DIV,LA7FS,LA7ECH)
 ;
 ; Person that verified the test
 I $P(LA76305(0),"^",4) S LA7VERP=$P(LA76305(0),"^",4)
 I LA7VERP S LA7OBX(16)=$$OBX16^LA7VOBX(LA7VERP,LA7DIV,LA7FS,LA7ECH)
 ;
 D BUILDSEG^LA7VHLU(.LA7OBX,.LA7ARRAY,LA7FS)
 ;
 Q
