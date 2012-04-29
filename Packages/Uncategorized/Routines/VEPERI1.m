VEPERI1 ;DAOU/WCJ - Incoming HL7 messages ;2-MAY-2005
 ;;1.0;VOEB;;Jun 12, 2005
 ;;;VISTA OFFICE/EHR;
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ;  This program parses each incoming HL7 messageS.
 Q
 ;
 ; Put the HL7 record into an array that is easier to work with
 ; (Something similar to table)
 ;
 ; This got a little bit tricky since some segments repeat and
 ; segment within those segments repeat.  Some arbitrary limits
 ; were imposed to be able to handle this.
 ; 1) A segment may only repeat 9 times.  (no more than 9 IN1's)
 ; 2) Only 4 repeating segments may be within each other.
 ; IN1 could repeat 9 times.  Within IN1, IN3 can repeat 9 times.
 ; Another segment could repeat within the IN3, and another within
 ; that one, but that's it.
 ;
PARSE(HL7IN,HLP,HLF,DEL,FE,MSGEVNT,HLMTIEN) ;
 N I,SEG,DATA,ELEMENT,SETID,SEQ,SI,EVENT,TMP,J,K,LEVEL,TMP,BIT,OLDSETID
 ;
 S EVENT=$$FIND1^DIC(19904.15,,,MSGEVNT)
 I EVENT="" S FE=$$FATALERR^VEPERI6(1,"HL7","UNSUPPORTED EVENT IN FILE 19905.15",HLMTIEN)
 S FE=0,SETID=""
 ;
 F I=1:1 Q:'$D(HL7IN(I))  D  Q:FE
 . S DATA="",SEQ=0
 . F J=0:1 Q:'$D(HL7IN(I,J))  D  Q:FE
 .. S DATA=DATA_HL7IN(I,J)
 .. Q:DATA=""
 .. ; check if it's a segment on the first level.
 .. ; this means it is not within a repeating segment
 .. I 'J D
 ... S SEG=$P(DATA,DEL(1))
 ... I $$FIND1^DIC(19904.151,",1,","C","SEG")  S SETID=""
 .. F K=1:1:$L(DATA,DEL(1)) D  Q:FE
 ... ;
 ... ; look at the first sequence in a segment, see if it is a repeating segement
 ... ; by looking for SET ID in the table
 ... I 'J,'SEQ D  Q:FE
 .... Q:$P($G(HLF("TBL",SEG,SEQ+1,0)),U,2)'["SET ID"
 .... S SI=$P(DATA,DEL(1),K+1)
 .... I SI>9 S FE=$$FATALERR^VEPERI6(1,"DATA",SEG_" "_SEQ_" "_SETID_" "_" TOO MANY SETID'S - LIMIT 9",HLMTIEN,.HLP) Q
 .... S TMP=SEG
 .... F BIT=3:-1:0 S TMP=$P(HLF("TBL",TMP),U,4) Q:TMP=""
 .... I TMP'="" S FE=$$FATALERR^VEPERI6(1,"DATA",SEG_" "_SEQ_" "_SETID_" "_" TOO MANY REPEATING SEGMENTS - LIMIT 4",HLMTIEN,.HLP) Q
 .... I BIT=3 S SETID=0
 .... S TMP=SI_"E"_BIT
 .... I BIT=$G(LEVEL) S SETID=OLDSETID
 .... S OLDSETID=SETID,LEVEL=BIT
 .... S SETID=SETID+TMP
 ... I K=$L(DATA,DEL(1)),$D(HL7IN(I,J+1)) Q
 ... S ELEMENT=$P(DATA,DEL(1),K)
 ... I ELEMENT]"" D
 .... S ELEMENT=$$UP^VEPERIU(ELEMENT)
 .... S HLP(SEG,$S(SETID]"":SETID,1:1000),SEQ)=ELEMENT
 ... S SEQ=SEQ+1
 .. S DATA=$P(DATA,DEL(1),K)
 Q
 ;
 ; This runs through all the data sent it.
 ; It will further parse fields within segments (such as address)
 ; It also does execute code for mapping validation.
 ; It runs though the input transform to make sure the values
 ; are valid.  Sometimes, it is set to skip the input trans if
 ; doing so would cause an error.
 ;
VALIDATE(HLP,HLF,FE,DEL,HLMTIEN) ;
 N SEG,SEQ,SETID,REQ,PM,X,OK,PMEXE,XSTR,FILE,FIELD,DATAELEM,INTRANS
 N DIQUIET,PTR,FIELDS,SKIPTRAN,TMP,BIT,SI
 ;
 S DIQUIET=1
 S FE=0
 ;
 ; Start looping through the table and parsed data.
 ; It actually loops through the table, but frequently checks
 ; on the parsed data.  It needs to use the table because some
 ; required data may be missing.
 ;
 S SEG="" F  S SEG=$O(HLF("TBL",SEG)) Q:SEG=""!FE  D
 . ;
 . ; Make sure all required segments are there
 . I +$P(HLF("TBL",SEG),U,3),'$D(HLP(SEG)) D  Q  ; required segment not present
 .. S FE=$$FATALERR^VEPERI6(1,"HL7",SEG_" REQUIRED SEGMENT MISSING",HLMTIEN,.HLP)
 . ;
 . Q:'$D(HLP(SEG))  ; If no data in this segment, no need to validate
 . ;
 . S SEQ="" F  S SEQ=$O(HLF("TBL",SEG,SEQ))  Q:SEQ=""!(FE)  D
 .. ;
 .. S REQ=$P(HLF("TBL",SEG,SEQ,0),U,5)  ; required
 .. S PM=$P(HLF("TBL",SEG,SEQ,0),U,6)   ; pattern matching
 .. S XSTR=$G(HLF("TBL",SEG,SEQ,1))     ; execute string
 .. ;
 .. S SETID=0 F  S SETID=$O(HLP(SEG,SETID)) Q:SETID=""!(FE)  D
 ... S (DATAELEM,X)=$G(HLP(SEG,SETID,SEQ))
 ... ;
 ... ; This next section was added to handle the Next of Kin data
 ... ; NK1 and NK2 are seperate fields in Vista, not mulitply occurring ones.
 ... ; SET ID 1 needs to get stored in one place
 ... ; SET ID 2 gets stored in another
 ... ; If a segment is repeating and is being stored in a muliply occuring field,
 ... ; SET ID will be 1.  This is because the data is sored in the same field in Vista
 ... ; just another occurance of the multiple.
 ... ;
 ... S (FILE,FIELD,FIELDS)=""
 ... I $O(HLF("TBL",SEG,SEQ,"SETID",0)) D  Q:FE
 .... ;
 .... ; Only SET ID 1 defined for this one.
 .... I '$O(HLF("TBL",SEG,SEQ,"SETID",1)) D  Q
 ..... S FILE=$O(HLF("TBL",SEG,SEQ,"SETID",1,""))
 ..... S FIELDS=$O(HLF("TBL",SEG,SEQ,"SETID",1,FILE,""))
 .... ;
 .... ; Need to figure out which SET ID we are talking about.
 .... ; SET ID is currently a four digist number of potential SET ID's
 .... ; SET ID 2300 could be the 3rd IN3 withine the 2nd IN1.  So, set ID is either
 .... ; 2 or 3.
 .... S TMP=SEG
 .... F BIT=1:1:4 S TMP=$P(HLF("TBL",TMP),U,4) Q:TMP=""
 .... S SI=$E(SETID,BIT)
 .... ;
 .... ; Get the file and fields for that SET ID
 .... I $D(HLF("TBL",SEG,SEQ,"SETID",SI)) D  Q
 ..... S FILE=$O(HLF("TBL",SEG,SEQ,"SETID",SI,""))
 ..... S FIELDS=$O(HLF("TBL",SEG,SEQ,"SETID",SI,FILE,""))
 .... ;
 .... ; More than one SET ID defined in table yet not this one.  Time to bug out.
 .... S FE=$$FATALERR^VEPERI6(1,"DATA OR TABLE",SEG_" "_SEQ_" "_SETID,HLMTIEN,.HLP)
 ... ;
 ... ; This is supposedly a required field
 ... I REQ D  Q:FE
 .... I $G(HLP(SEG,SETID,SEQ))="" S FE=$$FATALERR^VEPERI6(1,"DATA",SEG_" "_SEQ_" "_SETID_" MISSING",HLMTIEN,.HLP) Q
 ... ;
 ... ; Not much to do with this field past this point if it ain't there
 ... Q:X=""
 ... ;
 ... ; Pattern Match the field
 ... I PM]"" D  Q:FE
 .... S OK=0
 .... S PMEXE="I "_PM_" S OK=1"
 .... X PMEXE
 .... I 'OK S FE=$$FATALERR^VEPERI6(1,"DATA",SEG_" "_SEQ_" "_X_" "_PMEXE,HLMTIEN,.HLP) Q
 ... ;
 ... ; This is an execute string.  Mostly used for data mapping.
 ... ; If X is different going out than coming in, store it.
 ... I XSTR]"" D  Q:FE
 .... S OK=0
 .... X XSTR
 .... I 'OK S FE=$$FATALERR^VEPERI6(1,"DATA",SEG_" "_SEQ_" "_X_" "_XSTR,HLMTIEN,.HLP) Q
 .... I X'=DATAELEM S HLP(SEG,SETID,SEQ,0)=X,DATAELEM=X
 ... ;
 ... ; If there is no place to store the data, no need to continue
 ... I FILE=""!(FIELDS="") Q
 ... ;
 ... ; This next section loops through FIELDS since mutiple Vista Fields can go into
 ... ; one HL7 field.  Address is an an example.  This only works if the fields are in
 ... ; the same file.
 ... N FLDLOOP
 ... F FLDLOOP=1:1:$L(FIELDS,",") D  Q:FE
 .... S FIELD=$P(FIELDS,",",FLDLOOP)
 .... N X
 .... S X=$P(DATAELEM,DEL(2),FLDLOOP)
 .... S INTRANS="",SKIPTRAN=$P($G(HLF("MAP",FILE,FIELD)),U,4)
 .... ;
 .... ; Need to skip the input trans on some fields becasue they cause errors.  Some
 .... ; input trans expect certain variables to be there or are dependent on other
 .... ; fields.  AT this time, we can only use the stand alone checks here.
 .... I 'SKIPTRAN S INTRANS=$$GET1^DID(FILE,FIELD,,"INPUT TRANSFORM")
 .... ;
 .... ; If there is data and an input transform then let's do it.
 .... I X]"",INTRANS]"" D  Q:FE
 ..... X INTRANS
 ..... I '$D(X) D  Q  ; if X is not defined, input transform killed it
 ...... S FE=$$FATALERR^VEPERI6(1,"DATA",SEG_" "_SEQ_" "_DATAELEM_" "_INTRANS,HLMTIEN,.HLP)
 .... ;
 .... ; If X made it this far, we ought to save it
 .... I X]"" S HLF("DATA",FILE,FIELD,SETID)=X
 .... ;
 .... ; It this field is a pointer to another field, we need to see if LAYGO is allowed
 .... ; or if the data is in the pointed to file.
 .... I $P(HLF("MAP",FILE,FIELD),U,5) D
 ..... Q:'$P(HLF("MAP",FILE,FIELD),U,6)   ; if laygo is allowed, do not check
 ..... S PTR=$P(HLF("MAP",FILE,FIELD),U,5)
 ..... K RESULTS
 ..... D FIND^DIC(PTR,,"@;.01","MO",X,,,,,"RESULTS")
 ..... I '+RESULTS("DILIST",0) S FE=$$FATALERR^VEPERI6(1,"DATA",SEG_" "_SEQ_" "_SETID_" "_X_" PTR NO MATCHES",HLMTIEN,.HLP) Q
 ..... I +RESULTS("DILIST",0)>1 S FE=$$FATALERR^VEPERI6(1,"DATA",SEG_" "_SEQ_" "_SETID_" "_X_" PTR TO MANY MATCHES",HLMTIEN,.HLP) Q
 ..... S HLF("DATA",FILE,FIELD,SETID)=RESULTS("DILIST","ID",1,.01)
 Q
