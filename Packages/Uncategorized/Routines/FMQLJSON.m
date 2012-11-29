FMQLJSON;       Caregraf - FMQL JSON Builder ; Jun 29th, 2011
           ;;0.9;FMQLQP;;Jun 29th, 2011
        
        
ERRORREPLY(REPLY,MSG)   
           D REPLYSTART^FMQLJSON(.REPLY)
           D DASSERT^FMQLJSON(.REPLY,"error",MSG) 
           D REPLYEND^FMQLJSON(.REPLY)
           Q
REPLYSTART(JSON)        
           S @JSON@("INDEX")=0
           S @JSON@("OFFSET")=1
           S @JSON@(0)=""
           D PUTDATA(JSON,"{")
           S @JSON@("LSTLVL")=0
           S @JSON@("LSTLVL",0)=""
           Q
LISTSTART(JSON,LABEL)   
           D CONTSTART(JSON,""""_LABEL_""":[")
           Q
DICTSTART(JSON,LABEL)   
           I $D(LABEL) D CONTSTART(JSON,""""_LABEL_""":{") Q
           D CONTSTART(JSON,"{")
           Q
CONTSTART(JSON,MARK)    
           D PUTDATA(JSON,@JSON@("LSTLVL",@JSON@("LSTLVL")))
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))=","
           S @JSON@("LSTLVL")=@JSON@("LSTLVL")+1
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))=""
           D PUTDATA(JSON,MARK)
           Q
ASSERT(JSON,FIELD,IFIELD,FMTYPE,VALUE,PLABEL,PSAMEAS)   
           D PUTDATA(JSON,@JSON@("LSTLVL",@JSON@("LSTLVL")))
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))="," ; if next el then put a col before it
           S PRED=$$FIELDTOPRED^FMQLUTIL(FIELD)
           D PUTDATA(JSON,""""_PRED_""":{""fmId"":"""_IFIELD_""",""fmType"":"""_FMTYPE_""",""value"":"""_$$JSONSTRING(VALUE)_"""")
           I $G(PLABEL)'="" D
           . D PUTDATA(JSON,",""type"":""uri"",""label"":"""_$$JSONSTRING(PLABEL)_"""")
           . I $D(PSAMEAS) D
           . . D PUTDATA(JSON,",""sameAs"":"""_PSAMEAS("URI")_"""")
           . . D:$D(PSAMEAS("LABEL")) PUTDATA(JSON,",""sameAsLabel"":"""_$$JSONSTRING(PSAMEAS("LABEL"))_"""")
           E  D
           . I FMTYPE="1" D PUTDATA(JSON,",""type"":""typed-literal"",""datatype"":""http://www.w3.org/1999/02/22-rdf-syntax-ns#dateTime""") Q
           . D PUTDATA(JSON,",""type"":""literal""")
           D PUTDATA(JSON,"}")
           Q
DASSERT(JSON,LVALUE,RVALUE)     
           D PUTDATA(JSON,@JSON@("LSTLVL",@JSON@("LSTLVL")))
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))="," ; if next el then put a col before it
           D PUTDATA(JSON,""""_LVALUE_""":"""_$$JSONSTRING(RVALUE)_"""")
           Q
VASSERT(JSON,LVALUE,VALUE)      
           D PUTDATA(JSON,@JSON@("LSTLVL",@JSON@("LSTLVL")))
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))="," ; if next el then put a col before it
           D PUTDATA(JSON,""""_LVALUE_""":{""type"":""literal"",""value"":"""_VALUE_"""}")
           Q
WPASTART(JSON,FIELD,IFIELD)     
           D PUTDATA(JSON,@JSON@("LSTLVL",@JSON@("LSTLVL")))
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))="," ; if next el then put a col before it
           S @JSON@("LSTLVL")=@JSON@("LSTLVL")+1
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))=""
           D PUTDATA(JSON,""""_$$FIELDTOPRED^FMQLUTIL(FIELD)_""":{""fmId"":"""_IFIELD_""",""fmType"":""5"",""type"":""typed-literal"",""datatype"":""http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral"",""value"":""")
           Q
WPALINE(JSON,LINE)      
           D PUTDATA(JSON,@JSON@("LSTLVL",@JSON@("LSTLVL")))
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))="\r" ; if next el then put a col before it
           D PUTDATA(JSON,$$JSONSTRING(LINE))
           Q
WPAEND(JSON)    
           D CONTEND(JSON,"""}")
           Q
BNLISTSTART(JSON,BFL,BFDLBL,BFD)        
           D PUTDATA(JSON,@JSON@("LSTLVL",@JSON@("LSTLVL")))
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))=","
           S @JSON@("LSTLVL")=@JSON@("LSTLVL")+1
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))=""
           D PUTDATA(JSON,""""_$$FIELDTOPRED^FMQLUTIL(BFDLBL)_""":{""fmId"":"""_BFD_""",""type"":""cnodes"",""file"":"""_BFL_""",""value"":[")
           Q
BNLISTEND(JSON) 
           D CONTEND(JSON,"]}")
           Q
BNLISTSTOPPED(JSON,BFL,BFDLBL,BFD)      
           D PUTDATA(JSON,@JSON@("LSTLVL",@JSON@("LSTLVL")))
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))=","
           S @JSON@("LSTLVL")=@JSON@("LSTLVL")+1
           S @JSON@("LSTLVL",@JSON@("LSTLVL"))=""
           D PUTDATA(JSON,""""_$$FIELDTOPRED^FMQLUTIL(BFDLBL)_""":{""fmId"":"""_BFD_""",""type"":""cnodes"",""stopped"":""true"",""file"":"""_BFL_"""")
           D CONTEND(JSON,"}")
           Q
DICTEND(JSON)   
           D CONTEND(JSON,"}")
           Q
LISTEND(JSON)   
           D CONTEND(JSON,"]")
           Q
CONTEND(JSON,MARKUP)    
           D PUTDATA(JSON,MARKUP)
           K @JSON@("LSTLVL",@JSON@("LSTLVL"))
           S @JSON@("LSTLVL")=@JSON@("LSTLVL")-1
           Q
REPLYEND(JSON)  
           D PUTDATA(JSON,"}")
           K @JSON@("LSTLVL")
           K @JSON@("INDEX")
           K @JSON@("OFFSET")
           Q
PUTDATA(JSON,DATA)      
           S NODESIZE=201 ; TBD: lower (10) slows replies. But little advan over 1024, even slows the small.
           N LEN S LEN=$L(DATA)
           N NUM S NUM=LEN
           N OFFSET S OFFSET=@JSON@("OFFSET")
           N INDEX S INDEX=@JSON@("INDEX")
           I NUM+OFFSET-1>NODESIZE D
           . S NUM=NODESIZE-OFFSET+1 
           . S @JSON@(@JSON@("INDEX"))=@JSON@(@JSON@("INDEX"))_$E(DATA,1,NUM) 
           . S @JSON@("OFFSET")=1 S @JSON@("INDEX")=INDEX+1 S @JSON@(@JSON@("INDEX"))="" 
           . D PUTDATA(JSON,$E(DATA,NUM+1,LEN))
           . Q
           E  D
           . S @JSON@(@JSON@("INDEX"))=@JSON@(@JSON@("INDEX"))_DATA
           . S @JSON@("OFFSET")=@JSON@("OFFSET")+NUM
           . Q
           Q
JSONSTRING(MSTR)        
           N JSTR S JSTR=""
           N I F I=1:1:$L(MSTR) D
           . N NC S NC=$E(MSTR,I) 
           . N CD S CD=$A(NC) Q:CD=""  ; Check "" though GT/M and Cache say $A works for all unicode
           . ; \b,\t,\n,\f,\r separated - ",\ escaped with \ - 32 to 126 themselves; others 4 hex unicode. 
           . S JSTR=JSTR_$S(CD=8:"\b",CD=9:"\t",CD=10:"\n",CD=12:"\f",CD=13:"\r",CD=34:$C(92)_$C(34),CD=92:$C(92)_$C(92),(CD>31&(CD<127)):NC,$L($T(FUNC^%UTF2HEX)):"\u"_$TR($J($$FUNC^%UTF2HEX(NC),4)," ","0"),1:"\u"_$TR($J($ZHEX(CD),4)," ","0"))
           Q JSTR
        
        
