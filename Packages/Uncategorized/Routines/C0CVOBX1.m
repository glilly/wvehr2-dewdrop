LA7VOBX1 ;DALOI/JMC - LAB OBX Segment message builder (CH subscript) cont'd; 04/21/09
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,61,63**;Sep 27, 1994;Build 2
 ; JMC - mods to check for IHS V LAB file
 ;
CH ; Observation/Result segment for "CH" subscript results.
 ; Called by LA7VOBX
 ;
 N LA76304,LA7ALT,LA7DIV,LA7I,LA7X,LA7Y,X
 ;
 ; "CH" subscript requires a dataname
 I '$G(LRSB) Q
 ;
 ; get result node from LR global.
 S LA76304(0)=$G(^LR(LRDFN,LRSS,LRIDT,0))
 S LA7VAL=$G(^LR(LRDFN,LRSS,LRIDT,LRSB))
 ;
 ; Check if test is OK to send - (O)utput or (B)oth
 S LA7X=$P(LA7VAL,"^",12)
 I LA7X]"","BO"'[LA7X Q
 I LA7X="",'$$OKTOSND^LA7VHLU1(LRSS,LRSB,+$P($P(LA7VAL,"^",3),"!",5)) Q
 ;
 ; If no result NLT or LOINC try to determine from file #60
 S LA7X=$P(LA7VAL,"^",3)
 ; WV check for IHS - NLT/LN codes from V LAB file
 I $D(^AUPNVLAB) D TMPCHK^C0CLA7Q
 ;
 I $P(LA7X,"!",2)=""!($P(LA7X,"!",3)="") S $P(LA7VAL,"^",3)=$$DEFCODE^LA7VHLU5(LRSS,LRSB,LA7X,$P(LA76304(0),"^",5))
 ; No result NLT code - log error
 I $P($P(LA7VAL,"^",3),"!",2)="" D
 . N LA7X
 . S LA7X="["_LRSB_"]"_$$GET1^DID(63.04,LRSB,"","LABEL")
 . D CREATE^LA7LOG(36)
 ;
 ; something missing - No NLT code, etc.
 I LA7VAL="" Q
 ;
 ; Check for missing units/reference ranges
 S LA7X=$P(LA7VAL,"^",5)
 ;
 ; Results missing units, lookup in file #60
 I $P(LA7X,"!",7)="" S $P(LA7X,"!",7)=$P($$REFUNIT^LA7VHLU1(LRSB,$P(LA76304(0),"^",5)),"^",3)
 ;
 ; If results missing reference ranges, use values from file #60.
 I $P(LA7X,"!",2)="",$P(LA7X,"!",3)="",$P(LA7X,"!",11)="",$P(LA7X,"!",12)="" D
 . S LA7Y=$$REFUNIT^LA7VHLU1(LRSB,$P(LA76304(0),"^",5))
 . S $P(LA7X,"!",2)=$P(LA7Y,"^")
 . S $P(LA7X,"!",3)=$P(LA7Y,"^",2)
 . S $P(LA7X,"!",11)=$P(LA7Y,"^",6)
 . S $P(LA7X,"!",12)=$P(LA7Y,"^",7)
 ; Use therapeutic low/high if low/high missing.
 I $P(LA7X,"!",2)="",$P(LA7X,"!",3)="" D
 . S $P(LA7X,"!",2)=$P(LA7X,"!",11)
 . S $P(LA7X,"!",3)=$P(LA7X,"!",12)
 ;
 ; Evaluate low/high reference ranges in case M code in these fields.
 S:$G(SEX)="" SEX="M" S:$G(AGE)="" AGE=99
 F LA7I=2,3 I $E($P(LA7X,"!",LA7I),1,3)="$S(" D
 . S @("X="_$P(LA7X,"!",LA7I))
 . S $P(LA7X,"!",LA7I)=X
 ;
 ; Put units/reference ranges back in variable LA7VAL
 S $P(LA7VAL,"^",5)=LA7X
 ;
 ; Initialize OBX segment
 S LA7OBX(0)="OBX"
 S LA7OBX(1)=$$OBX1^LA7VOBX(.LA7OBXSN)
 ;
 ; Value type
 S LA7OBX(2)=$$OBX2^LA7VOBX(63.04,LRSB)
 ;
 ; Observation identifer
 ; build alternate code based on dataname from file #63 in case it's needed
 S LA7X=$P(LA7VAL,"^",3)
 S LA7ALT="CH"_LRSB_"^"_$$GET1^DID(63.04,LRSB,"","LABEL")_"^"_"99VA63"
 S LA7OBX(3)=$$OBX3^LA7VOBX($P(LA7X,"!",2),$P(LA7X,"!",3),LA7ALT,LA7FS,LA7ECH)
 ;
 ; Test value
 S LA7OBX(5)=$$OBX5^LA7VOBX($P(LA7VAL,"^"),LA7OBX(2),LA7FS,LA7ECH)
 ;
 ; Units - remove leading and trailing spaces
 S LA7X=$P(LA7VAL,"^",5),LA7X=$$TRIM^XLFSTR(LA7X,"LR"," ")
 S LA7OBX(6)=$$OBX6^LA7VOBX($P(LA7X,"!",7),"",LA7FS,LA7ECH)
 ;
 ; Reference range
 S LA7OBX(7)=$$OBX7^LA7VOBX($P(LA7X,"!",2),$P(LA7X,"!",3),LA7FS,LA7ECH)
 ;
 ; Abnormal flags
 S LA7OBX(8)=$$OBX8^LA7VOBX($P(LA7VAL,U,2))
 ;
 ; "P"artial or "F"inal results
 S LA7OBX(11)=$$OBX11^LA7VOBX($S("canccommentpending"[$P(LA7VAL,"^"):$P(LA7VAL,"^"),1:"F"))
 ;
 ; Observation date/time - collection date/time per HL7 standard
 I $P(LA76304(0),"^") S LA7OBX(14)=$$OBX14^LA7VOBX($P(LA76304(0),"^"))
 ;
 S LA7DIV=$P(LA7VAL,"^",9)
 I LA7DIV="",$$DIV4^XUSER(.LA7DIV,$P(LA7VAL,"^",4)) S LA7DIV=$O(LA7DIV(0))
 ;
 ; Facility that performed the testing
 S LA7OBX(15)=$$OBX15^LA7VOBX(LA7DIV,LA7FS,LA7ECH)
 ;
 ; Person that verified the test
 S LA7OBX(16)=$$OBX16^LA7VOBX($P(LA7VAL,"^",4),LA7DIV,LA7FS,LA7ECH)
 ;
 ; Observation method
 S LA7X=$P($P(LA7VAL,"^",3),"!",4)
 I LA7X S LA7OBX(17)=$$OBX17^LA7VOBX(LA7X,LA7FS,LA7ECH)
 ;
 ; Equipment entity identifier
 I $L($P(LA7VAL,"^",11)) S LA7OBX(18)=$$OBX18^LA7VOBX($P(LA7VAL,"^",11),LA7FS,LA7ECH)
 ;
 D BUILDSEG^LA7VHLU(.LA7OBX,.LA7ARRAY,LA7FS)
 ;
 Q
