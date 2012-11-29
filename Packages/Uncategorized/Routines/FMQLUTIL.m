FMQLUTIL;       Caregraf - FMQL Utilities ; Jun 29th, 2011
           ;;0.9;FMQLQP;;Jun 29th, 2011
        
        
XIENA(FLINF,FILTER,IENA,LIMIT,OFFSET,NOIDXMX,TOX,PARAMS)        
           ; 01 FDINF of file must be ok. TBD: centralize in FLINF
           N O1FDINF D BLDFDINF^FMQLUTIL(.FLINF,.01,.O1FDINF)
           I $D(O1FDINF("BAD")) Q -2
           N PLC S PLC("OFFLFT")=OFFSET,PLC("CNT")=0,PLC("LIMIT")=LIMIT,PLC("NOIDXMX")=NOIDXMX
           N MFLT,IDXA,IDXSTART S MFLT="",IDXSTART=""
           I FILTER'=""  D
           . I $D(FLINF("GL"))  D
           . . S IENA="",IDXA=""
           . . S MFLT="S MFTEST="_$$FLTTOM^FMQLFILT(.FLINF,FILTER)
           . . D FLTIDX^FMQLFILT(.FLINF,FILTER,.IDXA,.IDXSTART)
           . . I $G(IDXSTART)="",$G(IDXA)'="" S IENA=IDXA,IDXA=""
           . . ; Fix for ORDERS. Must set MFLT to "" as doesn't apply properly
           . . I IENA="",IDXA="" D
           . . . D OFLTIDX^FMQLFILT(.FLINF,FILTER,.IDXA,.IDXSTART) 
           . . . I $G(IDXA)'="" S MFLT=""
           . ; Allow for Filtering CNodes
           . E  S MFLT="S MFTEST="_$$FLTTOM^FMQLFILT(.FLINF,FILTER,IENA)
           I $G(IDXA)'="" D XBYIDX(.FLINF,IDXA,IDXSTART,MFLT,.PLC,TOX,.PARAMS) Q PLC("CNT")
           I $G(IENA)'="" D XBYIENA(.FLINF,IENA,MFLT,.PLC,TOX,.PARAMS) Q PLC("CNT")
           ; Won't walk B or File if file is too big for NOIDXMX setting
           I FILTER'="",NOIDXMX'=-1,FLINF("FMSIZE")>NOIDXMX Q -1
           ; Use B Index if told to order by it and it is there.
           ; For now, only support order by .01
           I $G(PARAMS("ORDERBY"))=".01",$D(FLINF("BIDX")) D XBYIDX(.FLINF,FLINF("BIDX"),"",MFLT,.PLC,TOX,.PARAMS) Q PLC("CNT")
           ; Walk File IEN by IEN
           D XBYIENA(.FLINF,FLINF("ARRAY"),MFLT,.PLC,TOX,.PARAMS)
           Q PLC("CNT")
        
XBYIDX(FLINF,IDXA,IDXSTART,MFLT,PLC,TOX,PARAMS) 
           Q:'$D(@IDXA)
           N IDXV S IDXV=IDXSTART F  S IDXV=$O(@IDXA@(IDXV)) Q:IDXV=""  D
           . N IENA S IENA=$NA(@IDXA@(IDXV))
           . D XBYIENA(.FLINF,IENA,MFLT,.PLC,TOX,.PARAMS)
           Q
        
XBYIENA(FLINF,IENA,MFLT,PLC,TOX,PARAMS) 
           N IEN,MFTEST,FAR
           ; For IENA in IDX where IEN is not last subscript. Need to skip duplicates.
           S:'$D(PLC("LIEN")) PLC("LIEN")=0
           S FAR=$S($D(FLINF("GL")):FLINF("ARRAY"),1:IENA)
           S IEN=0 F  S IEN=$O(@IENA@(IEN)) Q:IEN'=+IEN!(PLC("CNT")=PLC("LIMIT"))  D
           . Q:IEN=PLC("LIEN") ; IEN already in this IDX walk
           . ; Despite what an index says, there is no such node.
           . Q:'$D(@FAR@(IEN))
           . ; Account for aliases in 2 and 68. ^DPT("B",NAME,IEN,"X")=1. TBD Generalize
           . I ((FLINF("FILE")="2")!(FLINF("FILE")="68")),$G(@IENA@(IEN))'="" Q
           . ; I MFLT'="" N IENA S IENA=FLINF("ARRAY") X MFLT Q:'MFTEST  ; Filter fails CNode FIX
           . I MFLT'="" X MFLT Q:'MFTEST  ; Quit if filter fails
           . I PLC("OFFLFT")>0 S PLC("OFFLFT")=PLC("OFFLFT")-1 Q
           . S PLC("CNT")=PLC("CNT")+1
           . S PLC("LIEN")=IEN  ; TBD replace with value of $D ie. 1,10 etc.
           . X TOX  ; Takes .FLINF, IEN, FAR (FAR for CNodes), PARAMS (extras for builder)
           Q
        
BLDFLINF(FILE,FLINF)    
           S FILE=$TR(FILE,"_",".")
           S FLINF("FILE")=FILE
           S FLINF("EFILE")=$TR(FILE,".","_")
           I $D(^DIC(FILE,0,"GL")) D BLDTFINF(FILE,.FLINF) Q
           I $G(^DD(FILE,0,"UP"))'="" D BLDSFINF(FILE,.FLINF) Q
           S FLINF("BAD")="No such file: "_FILE
           Q
        
BLDTFINF(FILE,FLINF)    
           I $G(^DIC(FILE,0))="" S FLINF("BAD")="^DIC 0 Has No Data for: "_FILE Q
           S FLINF("GL")=^DIC(FILE,0,"GL")
           ; Handle ^DPT( and ^GMR(120.5,
           S FLINF("ARRAY")=$E(FLINF("GL"),1,$L(FLINF("GL"))-1)
           I FLINF("ARRAY")["(" S FLINF("ARRAY")=FLINF("ARRAY")_")"
           ; S FLINF("ARRAY")=$TR(FLINF("GL"),",",")")
           I '$D(@FLINF("ARRAY")@(0)) S FLINF("BAD")="FM Corruption - bad array: "_FILE Q
           S FLHDR=@FLINF("ARRAY")@(0)
           S FLINF("LABEL")=$TR($P(FLHDR,"^"),"/","_")  ; alt is ^DD(FILE,0,"NM")
           I FLINF("LABEL")="" S FLINF("BAD")="FM Corruption - no file name: "_FILE Q
           S FLINF("FLAGS")=$P(FLHDR,"^",2)
           S FLINF("FMSIZE")=+$P(FLHDR,"^",4)
           ; I $D(@FLINF("ARRAY")@("B")) S FLINF("BIDX")=FLINF("GL")_"""B"")"
           ; S:$P($G(@FLINF("ARRAY")@(.01,1,1,0)),"^",2)="B" FLINF("BIDX")=FLINF("GL")_"""B"")"
           S:$$FIELDIDX(FILE,".01")="B" FLINF("BIDX")=FLINF("GL")_"""B"")"
           ; # of fields is: $P(^DD(FILE,0),"^",0)
           Q
        
        
BLDSFINF(FILE,FLINF)    
           ; Ex/ ^DD(8925.02,.01,0)="REPORT TEXT^W^^0;1^Q"
           I $P($G(^DD(FILE,.01,0)),"^",2)["W" S FLINF("BAD")="Word Processing File: "_FILE Q
           I '$D(^DD(FILE,0,"NM")) S FLINF("BAD")="FM Corruption - no file name: "_FILE Q
           S FLINF("LABEL")=$O(^DD(FILE,0,"NM",""))
           S FLINF("PARENT")=^DD(FILE,0,"UP")  ; Existence checked by caller
           I '$D(^DD(FLINF("PARENT"),"SB",FILE)) S FLINF("BAD")="FM Corruption - parent doesn't know sub file" Q
           ; Get Field by Sub File id and not by sub file label in "B"
           S FLINF("PFIELD")=$O(^DD(FLINF("PARENT"),"SB",FILE,""))  ; SubFile location in parent
           I '$D(^DD(FLINF("PARENT"),FLINF("PFIELD"),0)) S FLINF("BAD")="FM Corruption - DD doesn't know parent's field for sub file" Q
           S PLOCPOS=$P(^DD(FLINF("PARENT"),FLINF("PFIELD"),0),"^",4)
           I PLOCPOS="" S FLINF("BAD")="FM Corruption - DD has no location information for subfile" Q
           I $P(PLOCPOS,";",2)'="0" S FLINF("BAD")="FM Corruption - CNode not in position 0" Q
           S FLINF("PLOCSUB")=$P(PLOCPOS,";")
           Q
        
BLDFDINF(FLINF,FIELD,FDINF)     
           N FILE S FILE=FLINF("FILE")
           S FIELD=$TR(FIELD,"_",".")
           I '$D(^DD(FILE,FIELD,0)) S FDINF("BAD")="No 0 Definition: "_FILE_"/"_FIELD Q
           S FDINF("FIELD")=FIELD
           N FLAGS S FLAGS=$P(^DD(FILE,FIELD,0),"^",2)
           S FDINF("FLAGS")=FLAGS
           S FDINF("LABEL")=$P(^DD(FILE,FIELD,0),"^")
           S FDINF("PRED")=$$FIELDTOPRED(FDINF("LABEL"))
           ; Date/Number/Codes/String/WP String/Pointer/V Pointer/MULT/MUMPS
           ; TBD: Computed - B, m, D
           I +FLAGS D  ; WP and MULT both refer to subfile in flags.
           . I $P($G(^DD(+FLAGS,.01,0)),"^",2)["W" S FDINF("TYPE")=5
           . E  S FDINF("TYPE")=9 S FDINF("SUBFILE")=+FLAGS  ; TBD: validate ["M ?
           ; TBD: Default String even if no "F". Should log.
           E  S FDINF("TYPE")=$S(FLAGS["D":1,FLAGS["N":2,FLAGS["S":3,FLAGS["F":4,FLAGS["C":6,FLAGS["P":7,FLAGS["V":8,FLAGS["K":10,1:"4") ; Default to String
           I FDINF("TYPE")="" S FDINF("BAD")="No type set: "_FILE_"/"_FIELD Q
           I FDINF("TYPE")'=6 D
           . S FDLOC=$P(^DD(FILE,FIELD,0),"^",4) 
           . S FDINF("LOCSUB")=$P(FDLOC,";") 
           . ; Check for " ; "? ie. spaces even though field not given as computed
           . I $TR(FDINF("LOCSUB")," ")="" S FDINF("BAD")="No location for field: "_FILE_"/"_FIELD Q
           . ; Position of 9 is 1 but that's meaningless. Leave out position.
           . I FDINF("TYPE")'=9 D
           . . N LOCWHERE S LOCWHERE=$P(FDLOC,";",2)
           . . I LOCWHERE="" S FDINF("BAD")="No location position for field: "_FILE_"/"_FIELD Q
           . . ; Extract form for 63/.1 (E1,19) or 68/.1;E1,220 (limit for screenman?)
           . . I LOCWHERE?1"E"1.N1","1.N S FDINF("LOCE")=$E(LOCWHERE,1,$L(LOCWHERE)) Q
           . . I LOCWHERE=+LOCWHERE S FDINF("LOCPOS")=LOCWHERE Q
           . . ; TBD: is there another position type? Return an error until I support it.
           . . S FDINF("BAD")="Unsupported location position for field: "_FILE_"/"_FIELD_":"_LOCWHERE Q
           I FDINF("TYPE")=3 D 
           . N CODES S CODES=$P(^DD(FILE,FIELD,0),"^",3)
           . I CODES="" S FDINF("BAD")="No codes specified: "_FILE_"/"_FIELD Q
           . N C F C=1:1 Q:$P(CODES,";",C)=""  S FDINF("CODES",$P($P(CODES,";",C),":"))=$P($P(CODES,";",C),":",2)
           I FDINF("TYPE")=7 S FDINF("PFILE")=+$P(FLAGS,"P",2) Q
           I FDINF("TYPE")=9 S FDINF("BFILE")=+FLAGS Q
           I FDINF("TYPE")=8 D
           . I '$D(^DD(FILE,FIELD,"V")) S FDINF("BAD")="No VPTR Definition: "_FILE_"/"_FIELD Q
           . S X=0 F  S X=$O(^DD(FILE,FIELD,"V",X)) Q:X'=+X  D
           . . N PFILE S PFILE=$P(^DD(FILE,FIELD,"V",X,0),"^",1)
           . . I '$D(^DIC(PFILE,0,"GL")) S FDINF("BAD")="No Global for VPTR target: "_PFILE Q
           . . N PLOC S PLOC=^DIC(PFILE,0,"GL")
           . . S FDINF("PLOC",PLOC)=PFILE
           . . S FDINF("PFILE",PFILE)=PLOC
           Q
        
FIELDIDX(FILE,FIELD)    
           N IDXID,IDXINF,IDX
           S IDX=""
           ; From '$D(^DD(FILE,FIELD,1))
           I '$D(^DD(FILE,FIELD,1,1)) Q ""  ; indexes number 1 up
           S IDXID=0 F  S IDXID=$O(^DD(FILE,FIELD,1,IDXID)) Q:((IDXID'=+IDXID)!(IDX'=""))  D  ; > 0 has indexes
           . Q:'$D(^DD(FILE,FIELD,1,IDXID,0))  ; TBD Corruption note
           . S IDXINF=^DD(FILE,FIELD,1,IDXID,0)
           . I $P(IDXINF,"^",3)'="MUMPS" S IDX=$P(^DD(FILE,FIELD,1,IDXID,0),"^",2) Q
           Q IDX
        
GETEVAL(FDINF,IVAL)     
           Q:FDINF("TYPE")=1 $$MAKEXMLDATE^FMQLUTIL(IVAL)
           I FDINF("TYPE")=3,$D(FDINF("CODES",IVAL)) Q FDINF("CODES",IVAL)
           N EVAL S EVAL=IVAL ; Fallback to internal value
           I FDINF("TYPE")=7 D
           . I IVAL="0" Q ; TBD Common NULL value that doesn't resolve
           . N PFLINF D BLDFLINF(FDINF("PFILE"),.PFLINF)
           . Q:$D(PFLINF("BAD"))
           . N PFDINF D BLDFDINF(.PFLINF,.01,.PFDINF)
           . Q:$D(PFDINF("BAD"))
           . Q:$G(@PFLINF("ARRAY")@(IVAL,0))="" ; Invalid Pointer
           . S IVAL=$P(@PFLINF("ARRAY")@(IVAL,0),"^")
           . Q:IVAL=""
           . S EVAL=$$GETEVAL(.PFDINF,IVAL)
           ; VPTR very like PTR - once PFILE is know.
           I FDINF("TYPE")=8 D
           . N PLOC S PLOC="^"_$P(IVAL,";",2)
           . Q:'$D(FDINF("PLOC",PLOC)) ; TBD: catch the buggy ptr instead
           . N PFILE S PFILE=FDINF("PLOC",PLOC)
           . N PFLINF D BLDFLINF(PFILE,.PFLINF)
           . Q:$D(PFLINF("BAD"))
           . N PID S PID=$P(IVAL,";")
           . Q:$G(@PFLINF("ARRAY")@(PID,0))="" ; Invalid Pointer
           . N PFDINF D BLDFDINF(.PFLINF,.01,.PFDINF)
           . Q:$D(PFDINF("BAD"))
           . N PIVAL S PIVAL=$P(@PFLINF("ARRAY")@(PID,0),"^")
           . Q:PIVAL=""
           . S EVAL=$$GETEVAL(.PFDINF,PIVAL)
           Q EVAL
        
PARSEURL(URL,FLINF,ID)  
           N FILE S FILE=$P(URL,"-")
           D BLDFLINF(FILE,.FLINF)
           I $D(FLINF("BAD")) Q
           S ID=$P(URL,"-",2) ; TBD: support CNode Identification
           Q
        
MAKEXMLDATE(FMDATE)     
           N XMLDATE
           S XMLDATE=(+$E(FMDATE,1,3)+1700)
           Q:$L(FMDATE)<4 XMLDATE_"-00-00T00:00:00Z"
           S XMLDATE=XMLDATE_"-"_$S($E(FMDATE,5)="":"0"_$E(FMDATE,4),1:$E(FMDATE,4,5))
           Q:$L(FMDATE)<6 XMLDATE_"-00T00:00:00Z"
           S XMLDATE=XMLDATE_"-"_$S($E(FMDATE,7)="":"0"_$E(FMDATE,6),1:$E(FMDATE,6,7))_"T"
           Q:$L(FMDATE)<9 XMLDATE_"00:00:00Z"
           S XMLDATE=XMLDATE_$S($E(FMDATE,10)="":"0"_$E(FMDATE,9),1:$E(FMDATE,9,10))_":"
           Q:$L(FMDATE)<11 XMLDATE_"00:00Z"
           S XMLDATE=XMLDATE_$S($E(FMDATE,12)="":"0"_$E(FMDATE,11),1:$E(FMDATE,11,12))_":"
           Q:$L(FMDATE)<13 XMLDATE_"00Z"
           S XMLDATE=XMLDATE_$S($E(FMDATE,14)="":"0"_$E(FMDATE,13),1:$E(FMDATE,13,14))_"Z"
           Q XMLDATE
        
MAKEFMDATE(XMLDATE)     ;
           N FMDATE
           ; If missing month or day, then pad with 0s
           S FMDATE=(+$E(XMLDATE,1,4)-1700)
           Q:$L(XMLDATE)<7 FMDATE_"0000"
           S FMDATE=FMDATE_$E(XMLDATE,6,7)
           Q:$L(XMLDATE)<10 FMDATE_"00"
           S FMDATE=FMDATE_$E(XMLDATE,9,10)
           Q:$E(XMLDATE,11)'="T" FMDATE
           S FMDATE=FMDATE_"."
           ; If trailing info missing, ok as $E returns "". 
           ; Does mean will accept 3 for 03 which isn't correct XML
           S FMDATE=FMDATE_$E(XMLDATE,12,13)
           S FMDATE=FMDATE_$E(XMLDATE,15,16)
           S FMDATE=FMDATE_$E(XMLDATE,18,19)
           Q FMDATE
        
FIELDTOPRED(FIELD)      
           SET ALW="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz_ /"
           SET UPC="ABCDEFGHIJKLMNOPQRSTUVWXYZ /"
           SET LOC="abcdefghijklmnopqrstuvwxyz__"
           S PRED=$TR($TR(FIELD,$TR(FIELD,ALW)),UPC,LOC)
           Q PRED
        
