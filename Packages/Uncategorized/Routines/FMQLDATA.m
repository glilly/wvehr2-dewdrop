FMQLDATA;       Caregraf - FMQL Data Query Processor ; Jun 29th, 2011
           ;;0.9;FMQLQP;;Jun 29th, 2011
        
        
DESONE(REPLY,PARAMS)    
           I '$D(PARAMS("TYPE")) D ERRORREPLY^FMQLJSON(REPLY,"Type Not Specified") Q
           I '$D(PARAMS("ID")) D ERRORREPLY^FMQLJSON(REPLY,"ID Not Specified") Q
           ; CNODESTOP defaults to 10 unless set explicitly
           N CNODESTOP S CNODESTOP=$S($D(PARAMS("CNODESTOP")):$G(PARAMS("CNODESTOP")),1:10)
           N NTYPE S NTYPE=$TR(PARAMS("TYPE"),"_",".")
           N FLINF D BLDFLINF^FMQLUTIL(NTYPE,.FLINF)
           I $D(FLINF("BAD")) D ERRORREPLY^FMQLJSON(REPLY,FLINF("BAD")) Q
           I '$D(FLINF("GL")) D ERRORREPLY^FMQLJSON(REPLY,"Can Only Describe a Global") Q
           I '$D(@FLINF("ARRAY")@(PARAMS("ID"),0)) D ERRORREPLY^FMQLJSON(REPLY,"No such identifier for type "_PARAMS("TYPE")) Q
           D REPLYSTART^FMQLJSON(REPLY)
           D LISTSTART^FMQLJSON(REPLY,"results") ; TBD: remove for new JSON
           D ONEOFTYPE(REPLY,.FLINF,FLINF("ARRAY"),PARAMS("ID"),CNODESTOP)
           D LISTEND^FMQLJSON(REPLY)
           ; the query as args
           D DICTSTART^FMQLJSON(REPLY,"fmql")
           D DASSERT^FMQLJSON(REPLY,"OP","DESCRIBE")
           D DASSERT^FMQLJSON(REPLY,"URI",FLINF("EFILE")_"-"_PARAMS("ID"))
           D DASSERT^FMQLJSON(REPLY,"CSTOP",CNODESTOP)
           D DICTEND^FMQLJSON(REPLY)
           D REPLYEND^FMQLJSON(REPLY)
           Q
        
ALL(REPLY,PARAMS)       
           I '$D(PARAMS("TYPE")) D ERRORREPLY^FMQLJSON(REPLY,"Type Not Specified") Q
           S FILE=$TR(PARAMS("TYPE"),"_",".")
           N FLINF D BLDFLINF^FMQLUTIL(FILE,.FLINF)
           I $D(FLINF("BAD")) D ERRORREPLY^FMQLJSON(REPLY,FLINF("BAD")) Q
           N BPERR,PFLINF,PID,IENA
           I '$D(FLINF("GL")) D  ; Handle Describe or Count of contained nodes.
           . I '$D(PARAMS("IN")) S BPERR="Missing: Contained Node Selection requires 'IN'" Q
           . D PARSEURL^FMQLUTIL(PARAMS("IN"),.PFLINF,.PID)
           . I '$D(PID) S BPERR="Bad Value: 'IN' requires ID" Q
           . I '$D(PFLINF("GL")) S BPERR="Bad Value: 'IN' must be a global type" Q
           . I PFLINF("FILE")'=FLINF("PARENT") S BPERR="Bad Value: CNode parent must be in 'IN'" Q
           . S IENA=$NA(@PFLINF("ARRAY")@(PID,FLINF("PLOCSUB")))
           E  S IENA=""
           I $D(BPERR) D ERRORREPLY^FMQLJSON(REPLY,BPERR) Q
           ; Defaults of -1,0,-1 for no LIMIT, no offset, no max cut off if no IDX, 
           N LIMIT S LIMIT=$S($G(PARAMS("LIMIT"))?0.1"-"1.N:PARAMS("LIMIT"),1:-1)
           N OFFSET S OFFSET=$S($G(PARAMS("OFFSET"))?1.N:PARAMS("OFFSET"),1:0)
           N NOIDXMX S NOIDXMX=$S($G(PARAMS("NOIDXMX"))?1.N:PARAMS("NOIDXMX"),1:-1)
           N CNODESTOP 
           I PARAMS("OP")="DESCRIBE" S CNODESTOP=$S($D(PARAMS("CNODESTOP")):$G(PARAMS("CNODESTOP")),1:10)
           N TOX ; Default value is "" for COUNT
           S TOX=$S((PARAMS("OP")="SELECT"):"D JSEL^FMQLDATA(REPLY,.FLINF,FAR,IEN,.PARAMS)",(PARAMS("OP")="DESCRIBE"):"D JDES^FMQLDATA(REPLY,.FLINF,FAR,IEN,CNODESTOP,.PARAMS)","1":"")
           D REPLYSTART^FMQLJSON(REPLY)
           D LISTSTART^FMQLJSON(REPLY,"results")
           N CNT S CNT=$$XIENA^FMQLUTIL(.FLINF,$G(PARAMS("FILTER")),IENA,LIMIT,OFFSET,NOIDXMX,TOX,.PARAMS)
           D LISTEND^FMQLJSON(REPLY)
           ; Note: if problem listing (no indexed filter), CNT<0
           D DASSERT^FMQLJSON(REPLY,"count",CNT)
           ; TBD: how to record NOIDXMX?
           D DICTSTART^FMQLJSON(REPLY,"fmql")
           D DASSERT^FMQLJSON(REPLY,"OP",PARAMS("OP"))
           D DASSERT^FMQLJSON(REPLY,"TYPELABEL",FLINF("LABEL"))
           D DASSERT^FMQLJSON(REPLY,"TYPE",FLINF("EFILE"))
           I PARAMS("OP")'="COUNT" D
           . D DASSERT^FMQLJSON(REPLY,"LIMIT",LIMIT)
           . D DASSERT^FMQLJSON(REPLY,"OFFSET",OFFSET)
           I $D(PARAMS("FILTER")) D DASSERT^FMQLJSON(REPLY,"FILTER",PARAMS("FILTER"))
           ; Only for DESCRIBE
           I $D(CNODESTOP) D DASSERT^FMQLJSON(REPLY,"CSTOP",CNODESTOP)
           D DICTEND^FMQLJSON(REPLY)
           D REPLYEND^FMQLJSON(REPLY)        
           Q
        
JSEL(REPLY,FLINF,FAR,IEN,PARAMS)        
           D DICTSTART^FMQLJSON(REPLY)
           ; FID=IEN for Globals. Only qualify for CNodes
           ; - replace for unusual IENS in .11 etc.
           N FID S FID=$S('$D(FLINF("GL")):IEN_"_"_$QS(FAR,$QL(FAR)-1),1:IEN)
           D IDFIELD(.FLINF,FAR,IEN,FID)
           I $D(PARAMS("PREDICATE")) D
           . N FDINF D BLDFDINF^FMQLUTIL(.FLINF,PARAMS("PREDICATE"),.FDINF)
           . Q:$D(FDINF("BAD"))  ; TBD: centralize
           . Q:FDINF("TYPE")=9  ; Don't allow CNode selection this way. Force "IN".
           . D ONEFIELD(FAR,IEN,.FDINF)
           D DICTEND^FMQLJSON(REPLY)
           Q
        
JDES(REPLY,FLINF,FAR,IEN,CNODESTOP,PARAMS)      
           ; Last Subscript for CNode
           N ID S ID=$S('$D(FLINF("GL")):IEN_"_"_$QS(FAR,$QL(FAR)-1),1:IEN) 
           D ONEOFTYPE(REPLY,.FLINF,FAR,ID,CNODESTOP)
           Q
        
ONEOFTYPE(REPLY,FLINF,FAR,FID,CNODESTOP)        
           N ID S ID=$P(FID,"_") ; Allow for CNode
           D DICTSTART^FMQLJSON(REPLY)
           N FIELD S FIELD=0 F  S FIELD=$O(^DD(FLINF("FILE"),FIELD)) Q:FIELD'=+FIELD  D
           . N FDINF D BLDFDINF^FMQLUTIL(.FLINF,FIELD,.FDINF)
           . Q:$D(FDINF("BAD"))
           . I FDINF("TYPE")=9 D  ; TBD: loop with walkers and B Index
           . . Q:'$D(@FAR@(ID,FDINF("LOCSUB")))
           . . N NFAR S NFAR=$NA(@FAR@(ID,FDINF("LOCSUB")))
           . . ; Pharma+ case: CNode location but no list params in 0 node
           . . Q:$P($G(@NFAR@(0)),"^",4)=""
           . . ; Using $O to skip missing CNodes, starting after 1 etc.
           . . N BFLINF D BLDFLINF^FMQLUTIL(FDINF("BFILE"),.BFLINF)
           . . ; Ignore if over CNODESTOP
           . . N CCNT S CCNT=0
           . . N BID S BID=0 F  S BID=$O(@NFAR@(BID)) Q:BID'=+BID!(CCNT=CNODESTOP)  S CCNT=CCNT+1
           . . I CCNT'=CNODESTOP  D
           . . . Q:CCNT=0  ; Don't mark empty bnodes (Pharma et al)
           . . . D BNLISTSTART^FMQLJSON(REPLY,BFLINF("EFILE"),FDINF("LABEL"),FIELD)
           . . . ; No need for NFAR or BFLINF if FLINF (even if CNode) supports ARRAY
           . . . N BID S BID=0 F  S BID=$O(@NFAR@(BID)) Q:BID'=+BID  D
           . . . . D ONEOFTYPE(REPLY,.BFLINF,NFAR,BID_"_"_FID,CNODESTOP)
           . . . D BNLISTEND^FMQLJSON(REPLY)
           . . E  D BNLISTSTOPPED^FMQLJSON(REPLY,BFLINF("EFILE"),FDINF("LABEL"),FIELD)    
           . E  D ONEFIELD(FAR,ID,.FDINF) D:FDINF("FIELD")=.01 IDFIELD(.FLINF,FAR,ID,FID)
           ; TBD: properly count SLABS ala other CNodes
           I FLINF("FILE")="63.04",CNODESTOP>0 D BLDBNODES^FMQLSLAB(FAR,FID)
           D DICTEND^FMQLJSON(REPLY)
           Q
        
IDFIELD(FLINF,FAR,ID,FID)       
           ; TBD: is this redundant?
           N O1L S O1L=$P($G(@FAR@(ID,0)),"^")
           ; All records should have a value for .01. TBD: check above.
           ; Saw bug in RPMS (9001021) where index has "^" as name and 0 is "^".
           Q:O1L=""
           N FDINF D BLDFDINF^FMQLUTIL(.FLINF,.01,.FDINF)  ; Assume ok. FLINF checked
           N EVALUE S EVALUE=$$GETEVAL^FMQLUTIL(.FDINF,O1L)
           N PVALUE S PVALUE=$TR(FLINF("FILE"),".","_")_"-"_FID
           N PLABEL S PLABEL=$TR(FLINF("LABEL"),"/","_")_"/"_$TR(EVALUE,"/","_")
           ; SAMEAS ONLY FOR GLOBALS
           N PSAMEAS I $D(FLINF("GL")),$L($T(RESOLVE^FMQLSSAM)) D RESOLVE^FMQLSSAM(FLINF("FILE"),ID,PLABEL,.PSAMEAS)
           D ASSERT^FMQLJSON(REPLY,"URI",".01","7",PVALUE,PLABEL,.PSAMEAS)
           Q
        
ONEFIELD(FAR,ID,FDINF)  
           Q:FDINF("TYPE")=6 ; Computed (TBD: v0.9)
           Q:FDINF("FIELD")=".001"  ; TBD: extract properly
           Q:'$D(@FAR@(ID,FDINF("LOCSUB")))
           I FDINF("TYPE")=5 D
           . ; Pharma+ case: WP location but no entries (ala special case for 9)
           . ; TBD: "" only entry. Seen in RAD, P/H. 
           . Q:'$D(@FAR@(ID,FDINF("LOCSUB"),1))
           . D WPASTART^FMQLJSON(REPLY,FDINF("LABEL"),FDINF("FIELD"))
           . F WPR=1:1 Q:'$D(@FAR@(ID,FDINF("LOCSUB"),WPR))  D
           . . D WPALINE^FMQLJSON(REPLY,@FAR@(ID,FDINF("LOCSUB"),WPR,0))
           . D WPAEND^FMQLJSON(REPLY)
           E  D
           . ; Check as sub values may exist but not the value indicated. 
           . ; Saw WP field's location overloaded for another field 
           . ; (RPMS:811.8 vs VistA's which is ok)
           . Q:$G(@FAR@(ID,FDINF("LOCSUB")))=""
           . N LOCSUB S LOCSUB=@FAR@(ID,FDINF("LOCSUB"))
           . ; For $E values, don't just take the $E limit.
           . N IVALUE S IVALUE=$S($D(FDINF("LOCPOS")):$P(LOCSUB,"^",FDINF("LOCPOS")),1:LOCSUB) Q:IVALUE=""
           . N EVALUE S EVALUE=$$GETEVAL^FMQLUTIL(.FDINF,IVALUE)
           . I FDINF("TYPE")=7 D
           . . N PFLINF D BLDFLINF^FMQLUTIL(FDINF("PFILE"),.PFLINF)
           . . Q:$D(PFLINF("BAD"))
           . . S PVALUE=$TR(PFLINF("FILE"),".","_")_"-"_IVALUE
           . . S PLABEL=$TR(PFLINF("LABEL"),"/","_")_"/"_$TR(EVALUE,"/","_")
           . . N PSAMEAS I $L($T(RESOLVE^FMQLSSAM)) D RESOLVE^FMQLSSAM(PFLINF("FILE"),IVALUE,PLABEL,.PSAMEAS)
           . . D ASSERT^FMQLJSON(REPLY,FDINF("LABEL"),FDINF("FIELD"),"7",PVALUE,PLABEL,.PSAMEAS)
           . E  I FDINF("TYPE")=8 D
           . . N PID S PID=$P(IVALUE,";")
           . . Q:PID'=+PID  ; Corrupt pointer
           . . Q:$P(IVALUE,";",2)=""  ; Corrupt pointer
           . . N LOCZ S LOCZ="^"_$P(IVALUE,";",2)_"0)"  ; 0 has file's description
           . . Q:'$D(@LOCZ)
           . . N PFI S PFI=@LOCZ
           . . N PFILE S PFILE=+$P(PFI,"^",2)
           . . N PFLBL S PFLBL=$TR($P(PFI,"^",1),"/","_")
           . . S PVALUE=$TR(PFILE,".","_")_"-"_PID
           . . S PLABEL=$TR(PFLBL,"/","_")_"/"_$TR(EVALUE,"/","_")
           . . N PSAMEAS I $L($T(RESOLVE^FMQLSSAM)) D RESOLVE^FMQLSSAM(PFILE,PID,PLABEL,.PSAMEAS)
           . . D ASSERT^FMQLJSON(REPLY,FDINF("LABEL"),FDINF("FIELD"),"8",PVALUE,PLABEL,.PSAMEAS)
           . E  D ASSERT^FMQLJSON(REPLY,FDINF("LABEL"),FDINF("FIELD"),FDINF("TYPE"),EVALUE)
           Q
        
CNTREFS(REPLY,PARAMS)   
           I '$D(PARAMS("TYPE")) D ERRORREPLY^FMQLJSON(REPLY,"Type Not Specified") Q
           I '$D(PARAMS("ID")) D ERRORREPLY^FMQLJSON(REPLY,"ID Not Specified") Q
           N NTINF D BLDFLINF^FMQLUTIL(PARAMS("TYPE"),.NTINF)
           I $D(NTINF("BAD")) D ERRORREPLY^FMQLJSON(REPLY,NTINF("BAD")) Q
           I '$D(@NTINF("ARRAY")@(PARAMS("ID"),0)) D ERRORREPLY^FMQLJSON(REPLY,"No such identifier for type "_PARAMS("TYPE")) Q
           N TARGET S TARGET=NTINF("EFILE")_"-"_PARAMS("ID")
           ; NOIDXMX is important. Otherwise the unimportant will take time.
           N NOIDXMX S NOIDXMX=$G(PARAMS("NOIDXMX"))
           S:(NOIDXMX'=+NOIDXMX) NOIDXMX=-1
           N TCNT S TCNT=0
           D REPLYSTART^FMQLJSON(REPLY)
           D LISTSTART^FMQLJSON(REPLY,"results")
           N RFL ; Order referrer types by name
           S FILE="" F  S FILE=$O(^DD(NTINF("FILE"),0,"PT",FILE)) Q:FILE'=+FILE  D
           . N FLINF D BLDFLINF^FMQLUTIL(FILE,.FLINF)
           . Q:($D(FLINF("BAD"))!$D(FLINF("PARENT")))
           . S RFL(FLINF("LABEL"),FILE)=""
           ; Walk referring files in order (know ok as orderer catches bad files)
           S FILELABEL="" F  S FILELABEL=$O(RFL(FILELABEL)) Q:FILELABEL=""  D
           . S FILE="" F  S FILE=$O(RFL(FILELABEL,FILE)) Q:FILE=""  D
           . . N FLINF D BLDFLINF^FMQLUTIL(FILE,.FLINF)
           . . ; Q:FLINF("FMSIZE")<1  ; surely empty files aren't costly
           . . N FIELD S FIELD="" F  S FIELD=$O(^DD(NTINF("FILE"),0,"PT",FILE,FIELD)) Q:FIELD'=+FIELD  D
           . . . N FDINF D BLDFDINF^FMQLUTIL(.FLINF,FIELD,.FDINF)
           . . . I $D(FDINF("BAD")) Q
           . . . I FDINF("TYPE")'=7 Q  ; PTR only for now (no vptr)
           . . . N FLT S FLT=FIELD_"="_NTINF("FILE")_"-"_PARAMS("ID")
           . . . N CNT S CNT=$$XIENA^FMQLUTIL(.FLINF,FLT,"",-1,0,NOIDXMX,"")
           . . . Q:CNT=-1 ; means no idx max exceeded.
           . . . Q:CNT=0 
           . . . D DICTSTART^FMQLJSON(REPLY)
           . . . N FLDLABEL S FLDLABEL=FDINF("LABEL") ; Add predicate
           . . . D DASSERT^FMQLJSON(REPLY,"file",FLINF("EFILE"))
           . . . D DASSERT^FMQLJSON(REPLY,"fileLabel",FILELABEL)
           . . . D DASSERT^FMQLJSON(REPLY,"field",FIELD)
           . . . D DASSERT^FMQLJSON(REPLY,"fieldLabel",FDINF("PRED"))
           . . . D DASSERT^FMQLJSON(REPLY,"count",CNT)
           . . . D DICTEND^FMQLJSON(REPLY)
           . . . S TCNT=TCNT+CNT
           D LISTEND^FMQLJSON(REPLY)
           D DASSERT^FMQLJSON(REPLY,"total",TCNT)
           D DICTSTART^FMQLJSON(REPLY,"fmql")
           D DASSERT^FMQLJSON(REPLY,"OP","COUNT REFS")
           D DASSERT^FMQLJSON(REPLY,"URI",TARGET)
           D DICTEND^FMQLJSON(REPLY)
           D REPLYEND^FMQLJSON(REPLY)
           Q
