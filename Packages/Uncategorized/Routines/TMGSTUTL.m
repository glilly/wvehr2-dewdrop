TMGSTUTL        ;TMG/kst/String Utilities and Library ;03/25/06,5/10/10 ; 5/19/10 5:01pm
                ;;1.0;TMG-LIB;**1**;09/01/05;Build 23
        ;"TMG STRING UTILITIES
        ;"=======================================================================
        ;" API -- Public Functions.
        ;"=======================================================================
        ;"SetStrLen^TMGSTUTL(Text,Width)
        ;"$$NestSplit^TMGSTUTL(Text,OpenBracket,CloseBracket,SBefore,S,SAfter)
        ;"$$Substitute^TMGSTUTL(S,Match,NewValue)
        ;"$$FormatArray^TMGSTUTL(InArray,OutArray,Divider)
        ;"$$Trim^TMGSTUTL(S,TrimCh)  ; --> or use $$TRIM^XLFSTR
        ;"$$TrimL^TMGSTUTL(S,TrimCh)
        ;"$$TrimR^TMGSTUTL(S,TrimCh)
        ;"$$TrimRType^TMGSTUTL(S,type)
        ;"$$NumLWS^TMGSTUTL(S)
        ;"$$MakeWS^TMGSTUTL(n)
        ;"CleaveToArray^TMGSTUTL(Text,Divider,Array)
        ;"CleaveStr^TMGSTUTL(Text,Divider,PartB)
        ;"$$ADDWRAP^TMGSTUTL(PriorS,AddS,MaxWidth,IndentS) -- AddS to PriorS, but wrap first wrap if needed)
        ;"WordWrapArray^TMGSTUTL(.Array,Width,SpecialIndent)
        ;"SplitStr^TMGSTUTL(Text,Width,PartB)
        ;"SplitLine^TMGSTUTL(s,.LineArray,Width)
        ;"WriteWP^TMGSTUTL(NodeRef)
        ;"WPINSERT(REF,LNUM,S) ;insert one line into a WP record at given line number
        ;"WPDEL(REF,LNUM) ;delete one line in a WP record at given line number
        ;"WPFIX(REF) ; fix the line numbers in a WP field to that they are all integers.
        ;"$$LPad^TMGSTUTL(S,width)   ;"NOTE: should use XLFSTR fn below
        ;"$$RPad^TMGSTUTL(S,width)   ;"NOTE: should use XLFSTR fn below
        ;"$$Center^TMGSTUTL(S,width) ;"NOTE: should use XLFSTR fn below
        ;"$$Clip^TMGSTUTL(S,width)
        ;"$$STRB2H^TMGSTUTL(s,F) Convert a string to hex characters
        ;"$$CapWords^TMGSTUTL(S,Divider) ;"capitalize the first character of each word in a string
        ;"$$LinuxStr^TMGSTUTL(S) ;"Convert string to a valid linux filename
        ;"StrToWP^TMGSTUTL(s,pArray,width,DivCh,InitLine)  ;"wrap long string into a WP array
        ;"$$WPToStr^TMGSTUTL(pArray,DivCh,MaxLen,InitLine)
        ;"WP2ARRAY(REF,ARRAY) -- convert a Fileman WP array into a flat ARRAY
        ;"ARRAY2WP(ARRAY,REF) -- convert ARRAY to a Fileman WP array
        ;"Comp2Strs(s1,s2) -- compare two strings and assign an arbritrary score to their similarity
        ;"$$PosNum(s,[Num],LeadingSpace) -- return position of a number in a string
        ;"IsNumeric(s) -- deterimine if word s is a numeric
        ;"ScrubNumeric(s) -- remove numeric words from a sentence
        ;"Pos(subStr,s,count) -- return the beginning position of subStr in s
        ;"DiffPos(s1,s2) -- Return the position of the first difference between s1 and s2
        ;"DiffWords(Words1,Words2) -- Return index of first different word between Words arrays
        ;"SimStr(s1,p1,s2,p2) -- return matching string in s1 and s2, starting at position p1,p2
        ;"SimWord(Words1,p1,Words2,p2) -- return the matching words in both words array 1 and 2, starting
        ;"                              at word positions p1 and p2.
        ;"SimPos(s1,s2) -- return the first position that two strings are similar.
        ;"SimWPos(Words1,Words2,DivStr,p1,p2,MatchStr) -- return the first position that two word arrays
        ;"          are similar.  This means the first index in Words array 1 that matches to words in Words array 2.
        ;"DiffStr(s1,s2,DivChr) -- Return how s1 differs from s2.
        ;"CatArray(Words,i1,i2,DivChr) -- return concat array from index1 to index2
        ;"$$QtProtect(s) -- Protects quotes by converting all quotes to double quotes (" --> "")
        ;"$$QTPROTECT(S) -- Same as $$QtProtect(s)
        ;"$$InQt(s,Pos) -- return if a character at position P is inside quotes in s
        ;"$$HNQTSUB(s,SubStr) --Same as $$HasNonQtSub
        ;"$$HasNonQtSub(s,SubStr) -- return if string s contains SubStr, but not inside quotes.
        ;"$$GetWord(s,Pos,OpenDiv,CloseDiv) -- extract a word from a sentance, bounded by OpenDiv,CloseDiv
        ;"$$MATCHXTR(s,DivCh,Group,Map) -- Same as $$MatchXtract
        ;"$$MatchXtract(s,DivCh,Group,Map) -- extract a string bounded by DivCh, honoring matching encapsulators
        ;"MapMatch(s,Map) -- map a string with nested braces, parentheses etc (encapsulators)
        ;"$$CmdChStrip(s) -- Strips all characters < #32 from string.
        ;"$$StrBounds(s,p) -- return position of end of string
        ;"NonWhite(s,p) -- return index of first non-whitespace character
        ;"Pad2Pos(Pos,ch) -- return a padding string from current $X up to Pos, using ch
        ;"HTML2TXT(Array) -- Take WP array that is HTML formatted, and strip <P>, and return in a format of 1 line per array node.
        ;"TrimTags(lineS) -- cut out HTML tags (e.g. <...>) from lineS, however, <no data> is protected
        ;"$$IsHTML(IEN8925) --specify if the text held in the REPORT TEXT field in record IEN8925 is HTML markup
        ;"=======================================================================
        ;"Dependancies
        ;"  uses TMGDEBUG for debug messaging.
        ;"=======================================================================
        ;"=======================================================================
        ;"------------------------------------------------------------------------
        ;"FYI, String functions in XLFSTR module:
        ;"------------------------------------------------------------------------
        ;"$$CJ^XLFSTR(s,i[,p]) -- Returns a center-justified string
        ;"        s=string, i=field size, p(optional)=pad character
        ;"$$LJ^XLFSTR(s,i[,p]) -- Returns a left-justified string
        ;"        s=string, i=field size, p(optional)=pad character
        ;"$$RJ^XLFSTR(s,i[,p]) -- Returns a right-justified string
        ;"        s=string, i=field size, p(optional)=pad character
        ;"$$INVERT^XLFSTR(s) -- returns an inverted string (i.e. "ABC"-->"CBA")
        ;"$$LOW^XLFSTR(s) -- returns string with all letters converted to lower-case
        ;"$$UP^XLFSTR(s) -- returns string with all letters converted to upper-case
        ;"$$TRIM^XLFSTR(s,[LRFlags],[char])
        ;"$$REPEAT^XLFSTR(s,Count) -- returns a string that is a repeat of s Count times
        ;"$$REPLACE^XLFSTR(s,.spec) -- Uses a multi-character $TRanslate to return a
        ;"                                string with the specified string replaced
        ;"        s=input string, spec=array passed by reference
        ;"        spec format:
        ;"        spec("Any_Search_String")="Replacement_String"
        ;"$$STRIP^XLFSTR(s,Char) -- returns string striped of all instances of Char
        ;"=======================================================================
SetStrLen(Text,Width)
               ;"PUBLIC FUNCTION
               ;"Purpose: To make string exactly Width in length
               ;"  Shorten as needed, or pad with terminal spaces as needed.
               ;"Input: Text -- should be passed as reference.  This is string to alter.
               ;"       Width -- the desired width
               ;"Results: none.
               set Text=$get(Text)
               set Width=$get(Width,80)
               new result set result=Text
               new i,Len
               set Len=$length(result)
               if Len>Width do
               . set result=$extract(result,1,Width)
               else  if Len<Width do
               . for i=1:1:(Width-Len) set result=result_" "
               set Text=result  ;"pass back changes
               quit
NestSplit(Text,OpenBracket,CloseBracket,SBefore,S,SAfter)
               ;"PUBLIC FUNCTION
               ;"Purpose: To take a string in this format:
               ;"          Text='a big black {{Data.Section[{{MVar.Num}}]}} chased me'
               ;"        OpenBracket='{{'
               ;"        CloseBracket='}}'
               ;"  and return:
               ;"        SBefore='a big black {{Data.Section['
               ;"        S='MVar.Num
               ;"        SAfter=']}} chased me'
               ;"  Notice that this function will return the INNER-MOST text inside the brackets pair
               ;"  Note: if multiple sets of brackets exist in the string, like this:
               ;"        'I am a {{MVar.Person}} who loves {{MVar.Food}} every day.
               ;"        Then the LAST set (i.e. MVar.Food) will be returned in S
               ;"
               ;"Input:Text -- the string to operate on
               ;"        OpenBracket -- string with opening brackets (i.e. '(','{', '{{' etc.)
               ;"        CloseBracket -- string with close brackets (i.e. ')','}','}}' etc.)
               ;"        SBefore -- SHOULD BE PASSED BY REFERENCE... to receive results.
               ;"        S -- SHOULD BE PASSED BY REFERENCE... to receive results.
               ;"        SAfter -- SHOULD BE PASSED BY REFERENCE... to receive results.
               ;"Output: SBefore -- returns all text up to innermost opening brackets, or "" if none
               ;"          S -- returns text INSIDE innermost brackets -- with brackets REMOVED, or "" if none
               ;"          SAfter -- returns all text after innermost opening brackets, or "" if none
               ;"          Text is NOT changed
               ;"        NOTE: Above vars must be passed by reference to recieve results.
               ;"Results: 1=valid results returned in output vars.
               ;"           0=No text found inside brackets, so output vars empty.
               set SBefore="",S="",SAfter=""
               new Result set Result=0
               ;"do DebugEntry^TMGDEBUG(.DBIndent,"NestSplit")
               if $data(Text)#10=0 goto QNSp
               ;"do DebugMsg^TMGDEBUG(DBIndent,"Looking at '",Text,"'")
               if ($data(OpenBracket)#10=0)!($data(CloseBracket)#10=0) goto QNSp
               if '((Text[OpenBracket)&(Text[CloseBracket)) goto QNSp
               ;"First we need to get the text after LAST instance of OpenBracket
               ;"i.e. 'MVar.Num}}]}}' chased m from 'a big black {{Data.Section[{{MVar.Num}}]}} chased me'
               new i set i=2
               new part set part=""
               new temp set temp=""
NSL1           set temp=$piece(Text,OpenBracket,i)
               if temp'="" do  goto NSL1
               . set part=temp
               . set SBefore=$piece(Text,OpenBracket,1,i-1)
               . set i=i+1
               ;"do DebugMsg^TMGDEBUG(DBIndent,"First part is: ",SBefore)
               ;"Now we find the text before the FIRST instance of CloseBracket
               ;"i.e. 'MVar.Num' from 'MVar.Num}}]}} chased me'
               ;"do DebugMsg^TMGDEBUG(DBIndent,"part=",part)
               set S=$piece(part,CloseBracket,1)
               set SAfter=$piece(part,CloseBracket,2,128)
               ;"do DebugMsg^TMGDEBUG(DBIndent,"Main result is :",S)
               ;"do DebugMsg^TMGDEBUG(DBIndent,"Part after result is: ",SAfter)
               ;"If we got here, we are successful
               set Result=1
QNSp
               ;"do DebugExit^TMGDEBUG(.DBIndent,"NestSplit")
               quit Result
Substitute(S,Match,NewValue)
               ;"PUBLIC FUNCTION
               ;"Purpose: to look for all instances of Match in S, and replace with NewValue
               ;"Input: S - string to alter.  Altered if passed by reference
               ;"       Match -- the sequence to look for, i.e. '##'
               ;"       NewValue -- what to replace Match with, i.e. '$$'
               ;"Note: This is different than $translate, as follows
               ;"      $translate("ABC###DEF","###","$") --> "ABC$$$DEF"
               ;"      Substitute("ABC###DEF","###","$") --> "ABC$DEF"
               ;"Result: returns altered string (if any alterations indicated)
               ;"Output: S is altered, if passed by reference.
               new spec
               set spec($get(Match))=$get(NewValue)
               set S=$$REPLACE^XLFSTR(S,.spec)
               quit S
FormatArray(InArray,OutArray,Divider)
               ;"PUBLIC FUNCTION
               ;"Purpose: The XML parser does not recognize whitespace, or end-of-line
               ;"        characters.  Thus many lines get lumped together.  However, if there
               ;"        is a significant amount of text, then the parser will put the text into
               ;"        several lines (when get attrib text called etc.)
               ;"        SO, this function is to take an array composed of input lines (each
               ;"        with multiple sublines clumped together), and format it such that each
               ;"        line is separated in the array.
               ;"        e.g. Take this input array"
               ;"        InArray(cText,1)="line one\nline two\nline three\n
               ;"        InArray(cText,2)="line four\nline five\nline six\n
               ;"        and convert to:
               ;"        OutArray(1)="line one"
               ;"        OutArray(2)="line two"
               ;"        OutArray(3)="line three"
               ;"        OutArray(4)="line four"
               ;"        OutArray(5)="line five"
               ;"        OutArray(6)="line six"
               ;"Input: InArray, best if passed by reference (faster) -- see example above
               ;"                Note: expected to be in format: InArray(cText,n)
               ;"        OutArray, must be passed by reference-- see example above
               ;"        Divider: the character(s) that divides lines ("\n" in this example)
               ;"Note: It is expected that InArray will be index by integers (i.e. 1, 2, 3)
               ;"        And this should be the case, as that is how XML functions pass back.
               ;"        Limit of 256 separate lines on any one InArray line
               ;"Output: OutArray is set, any prior data is killed
               ;"result: 1=OK to continue, 0=abort
               set DEBUG=$get(DEBUG,0)
               set cOKToCont=$get(cOKToCont,1)
               set cAbort=$get(cAbort,0)
               if DEBUG>0 do DebugEntry^TMGDEBUG(.DBIndent,"FormatArray")
               new result set result=cOKToCont
               new InIndex
               new OutIndex set OutIndex=1
               new TempArray
               new Done
               kill OutArray ;"remove any prior data
               if DEBUG>0 do DebugMsg^TMGDEBUG(DBIndent,"Input array:")
               if DEBUG do ArrayDump^TMGDEBUG("InArray")
               if $data(Divider)=0 do  goto FADone
               . set result=cAbort
               set Done=0
               for InIndex=1:1 do  quit:Done
               . if $data(InArray(cText,InIndex))=0 set Done=1 quit
               . if DEBUG>0 do DebugMsg^TMGDEBUG(DBIndent,"Converting line: ",InArray(cText,InIndex))
               . do CleaveToArray^TMGSTUTL(InArray(cText,InIndex),Divider,.TempArray,OutIndex)
               . if DEBUG>0 do DebugMsg^TMGDEBUG(DBIndent,"Resulting temp array:")
               . if DEBUG do ArrayDump^TMGDEBUG("TempArray")
               . set OutIndex=TempArray(cMaxNode)+1
               . kill TempArray(cMaxNode)
               . merge OutArray=TempArray
               . if DEBUG>0 do DebugMsg^TMGDEBUG(DBIndent,"OutArray so far:")
               . if DEBUG do ArrayDump^TMGDEBUG("OutArray")
FADone
               if DEBUG>0 do DebugExit^TMGDEBUG(.DBIndent,"FormatArray")
               quit result
TrimL(S,TrimCh)
               ;"Purpose: To a trip a string of leading white space
               ;"        i.e. convert "  hello" into "hello"
               ;"Input: S -- the string to convert.  Won't be changed if passed by reference
               ;"      TrimCh -- OPTIONAL: Charachter to trim.  Default is " "
               ;"Results: returns modified string
               ;"Note: processing limitation is string length=1024
               set TrimCh=$get(TrimCh," ")
               new result set result=$get(S)
               new Ch set Ch=""
               for  do  quit:(Ch'=TrimCh)
               . set Ch=$extract(result,1,1)
               . if Ch=TrimCh set result=$extract(result,2,1024)
               quit result
TrimR(S,TrimCh)
               ;"Purpose: To a trip a string of trailing white space
               ;"        i.e. convert "hello   " into "hello"
               ;"Input: S -- the string to convert.  Won't be changed if passed by reference
               ;"      TrimCh -- OPTIONAL: Charachter to trim.  Default is " "
               ;"Results: returns modified string
               ;"Note: processing limitation is string length=1024
               set DEBUG=$get(DEBUG,0)
               set cOKToCont=$get(cOKToCont,1)
               set cAbort=$get(cAbort,0)
               set TrimCh=$get(TrimCh," ")
               if DEBUG>0 do DebugEntry^TMGDEBUG(.DBIndent,"TrimR")
               new result set result=$get(S)
               new Ch set Ch=""
               new L
               for  do  quit:(Ch'=TrimCh)
               . set L=$length(result)
               . set Ch=$extract(result,L,L)
               . if Ch=TrimCh do
               . . set result=$extract(result,1,L-1)
               if DEBUG>0 do DebugExit^TMGDEBUG(.DBIndent,"TrimR")
               quit result
Trim(S,TrimCh)
               ;"Purpose: To a trip a string of leading and trailing white space
               ;"        i.e. convert "    hello   " into "hello"
               ;"Input: S -- the string to convert.  Won't be changed if passed by reference
               ;"      TrimCh -- OPTIONAL: Charachter to trim.  Default is " "
               ;"Results: returns modified string
               ;"Note: processing limitation is string length=1024
               ;"NOTE: this function could be replaced with $$TRIM^XLFSTR
               set DEBUG=$get(DEBUG,0)
               set cOKToCont=$get(cOKToCont,1)
               set cAbort=$get(cAbort,0)
               set TrimCh=$get(TrimCh," ")
               if DEBUG>0 do DebugEntry^TMGDEBUG(.DBIndent,"Trim")
               new result set result=$get(S)
               set result=$$TrimL(.result,TrimCh)
               set result=$$TrimR(.result,TrimCh)
               if DEBUG>0 do DebugExit^TMGDEBUG(.DBIndent,"Trim")
               quit result
TrimRType(S,type)
               ;"Scope: PUBLIC FUNCTION
               ;"Purpose: trim characters on the right of the string of a specified type.
               ;"         Goal, to be able to distinguish between numbers and strings.
               ;"         i.e. "1234<=" --> "1234" by trimming strings
               ;"Input: S -- The string to work on
               ;"       type -- the type of characters to TRIM: N for numbers,C for non-numbers (characters)
               ;"Results : modified string
               set tempS=$get(S)
               set type=$$UP^XLFSTR($get(type)) goto:(type="") TRTDone
               new done set done=0
               for  quit:(tempS="")!done  do
               . new c set c=$extract(tempS,$length(tempS))
               . new cType set cType="C"
               . if +c=c set cType="N"
               . if type["N" do
               . . if cType="N" set tempS=$extract(tempS,1,$length(tempS)-1) quit
               . . set done=1
               . else  if type["C" do
               . . if cType="C"  set tempS=$extract(tempS,1,$length(tempS)-1) quit
               . . set done=1
               . else  set done=1
TRTDone quit tempS
NumLWS(S)
               ;"Scope: PUBLIC FUNCTION
               ;":Purpose: To count the number of white space characters on the left
               ;"                side of the string
               new result set result=0
               new i,ch
               set S=$get(S)
               for i=1:1:$length(S)  do  quit:(ch'=" ")
               . set ch=$extract(S,i,i)
               . if ch=" " set result=result+1
               quit result
MakeWS(n)
               ;"Scope: PUBLIC FUNCTION
               ;"Purpose: Return a whitespace string that is n characters long
               new result set result=""
               set n=$get(n,0)
               if n'>0 goto MWSDone
               new i
               for i=1:1:n set result=result_" "
MWSDone
               quit result
CleaveToArray(Text,Divider,Array,InitIndex)
               ;"Purpose: To take a string, delineated by 'divider' and
               ;"        to split it up into all its parts, putting each part
               ;"        into an array.  e.g.:
               ;"        This/Is/A/Test, with '/' divider would result in
               ;"        Array(1)="This"
               ;"        Array(2)="Is"
               ;"        Array(3)="A"
               ;"        Array(4)="Test"
               ;"        Array(cMaxNode)=4    ;cMaxNode="MAXNODE"
               ;"Input: Text - the input string -- should NOT be passed by reference.
               ;"         Divider - the delineating string
               ;"         Array - The array to receive output **SHOULD BE PASSED BY REFERENCE.
               ;"         InitIndex - OPTIONAL -- The index of the array to start with, i.e. 0 or 1. Default=1
               ;"Output: Array is changed, as outlined above
               ;"Result: none
               ;"Notes:  Note -- Text is NOT changed (unless passed by reference, in
               ;"                which case the next to the last piece is put into Text)
               ;"        Array is killed, the filled with data **ONLY** IF DIVISIONS FOUND
               ;"        Limit of 256 nodes
               ;"        if cMaxNode is not defined, "MAXNODE" will be used
               set DBIndent=$get(DBIndent,0)
               do DebugEntry^TMGDEBUG(.DBIndent,"CleaveToArray")
               set InitIndex=$get(InitIndex,1)
               new PartB
               new count set count=InitIndex
               set cMaxNode=$get(cMaxNode,"MAXNODE")
               kill Array  ;"Clear out any old data
C2ArLoop
               if '(Text[Divider) do  goto C2ArDone
               . set Array(count)=Text ;"put it all into first line.
               . set Array(cMaxNode)=1
               do CleaveStr(.Text,Divider,.PartB)
               set Array(count)=Text
               set Array(cMaxNode)=count
               set count=count+1
               if '(PartB[Divider) do  goto C2ArDone
               . set Array(count)=PartB
               . set Array(cMaxNode)=count
               else  do  goto C2ArLoop
               . set Text=$get(PartB)
               . set PartB=""
C2ArDone
               do DebugExit^TMGDEBUG(.DBIndent,"CleaveToArray")
               quit
CleaveStr(Text,Divider,PartB)
               ;"Purpse: To take a string, delineated by 'Divider'
               ;"        and to split it into two parts: Text and PartB
               ;"         e.g. Text="Hello\nThere"
               ;"             Divider="\n"
               ;"           Function will result in: Text="Hello", PartB="There"
               ;"Input: Text - the input string **SHOULD BE PASSED BY REFERENCE.
               ;"         Divider - the delineating string
               ;"        PartB - the string to get second part **SHOULD BE PASSED BY REFERENCE.
               ;"Output: Text and PartB will be changed
               ;"        Function will result in: Text="Hello", PartB="There"
               ;"Result: none
               set DBIndent=$get(DBIndent,0)
               do DebugEntry^TMGDEBUG(.DBIndent,"CleaveStr")
               do DebugMsg^TMGDEBUG(DBIndent,"Text=",Text)
               if '$data(Text) goto CSDone
               if '$Data(Divider) goto CSDone
               set PartB=""
               new PartA
               if Text[Divider do
               . set PartA=$piece(Text,Divider,1)
               . set PartB=$piece(Text,Divider,2,256)
               . set Text=PartA
               do DebugMsg^TMGDEBUG(DBIndent,"After Processing, Text='",Text,"', and PartB='",PartB,"'")
CSDone
               do DebugExit^TMGDEBUG(.DBIndent,"CleaveStr")
               quit
SplitStr(Text,Width,PartB)
               ;"PUBLIC FUNCTION
               ;"Purpose: To a string into two parts.  The first part will fit within 'Width'
               ;"           the second part is what is left over
               ;"          The split will be inteligent, so words are not divided (splits at a space)
               ;"Input:  Text = input text.  **Should be passed by reference
               ;"          Width = the constraining width
               ;"        PartB = the left over part. **Should be passed by reference
               ;"output: Text and PartB are modified
               ;"result: none.
               new Len,s1
               set Width=$get(Width,80)
               new SpaceFound set SpaceFound=0
               new SplitPoint set SplitPoint=Width
               set Text=$get(Text)
               set PartB=""
               set Len=$length(Text)
               if Len>Width do
               . new Ch
               . for SplitPoint=SplitPoint:-1:1 do  quit:SpaceFound
               . . set Ch=$extract(Text,SplitPoint,SplitPoint)
               . . set SpaceFound=(Ch=" ")
               . if 'SpaceFound set SplitPoint=Width
               . set s1=$extract(Text,1,SplitPoint)
               . set PartB=$extract(Text,SplitPoint+1,1024)  ;"max String length=1024
               . set Text=s1
               else  do
               quit
ADDWRAP(PriorS,AddS,MaxWidth,IndentS)
               ;"Purpose: to add AddS to PriorS, but wrap first wrap if needed)
               ;"Input: PriorS : this is the total allowed width.
               ;"       AddS : this is the new addition string fragment to add
               ;"       MaxWidth : this is the length to wrap in.  OPTIONAL.  Default=60
               ;"       IndentS : this is the character string added to second line
               ;"                 to effect an indentations.  OPTIONAL
               ;"NOTE: To effect the wrapping of the line, the result string has
               ;"        CR_LF added between lines.
               ;"      Spaces MUST be included in AddS to allow wrapping of line, otherwise
               ;"        there will be no place to break line, and wrapping will not occur.
               ;"       It is assumed that PriorS is NOT longer than MaxWidth
               ;"Result: Returns one long string, divided by CR_LF's
               set PriorS=$get(PriorS)
               set AddS=$get(AddS)
               set MaxWidth=+$get(MaxWidth)
               if MaxWidth=0 set MaxWidth=60
               set IndentS=$get(IndentS)
               new lastLine set lastLine=PriorS
               new numLines set numLines=$length(PriorS,$char(13,10))
               set lastLine=$piece(PriorS,$char(13,10),numLines)
               if $length(lastLine)<$length(PriorS) do
               . set Result=$piece(PriorS,$char(13,10),1,numLines-1)
               else  set Result=""
               if $extract(lastLine,$length(lastLine))'=" " set lastLine=lastLine_" "
               set lastLine=lastLine_AddS
               new PartB
               for  quit:($length(lastLine)'>MaxWidth)  do
               . do SplitStr(.lastLine,MaxWidth,.PartB)
               . if Result'="" set Result=Result_$char(13,10)
               . set Result=Result_lastLine
               . set lastLine=IndentS_PartB
               if Result'="" set Result=Result_$char(13,10)
               set Result=Result_lastLine
               quit Result
WordWrapArray(Array,Width,SpecialIndent)
               ;"Scope: PUBLIC FUNCTION
               ;"Purpose: To take an array and perform word wrapping such that
               ;"        no line is longer than Width.
               ;"        This function is really designed for reformatting a Fileman WP field
               ;"Input: Array MUST BE PASSED BY REFERENCE.  This contains the array
               ;"        to be reformatted.  Changes will be made to this array.
               ;"        It is expected that Array will be in this format:
               ;"                Array(1)="Some text on the first line."
               ;"                Array(2)="Some text on the second line."
               ;"                Array(3)="Some text on the third line."
               ;"                Array(4)="Some text on the fourth line."
               ;"        or
               ;"                Array(1,0)="Some text on the first line."
               ;"                Array(2,0)="Some text on the second line."
               ;"                Array(3,0)="Some text on the third line."
               ;"                Array(4,0)="Some text on the fourth line."
               ;"        Width -- the limit on the length of any line.  Default value=70
               ;"        SpecialIndent : if 1, then wrapping is done like this:
               ;"                "   This is a very long line......"
               ;"           will be wrapped like this:
               ;"                "   This is a very
               ;"                "   long line ...
               ;"          Notice that the leading space is copied subsequent line.
               ;"          Also, a line like this:
               ;"                "   1. Here is the beginning of a paragraph that is very long..."
               ;"            will be wrapped like this:
               ;"                "   1. Here is the beginning of a paragraph
               ;"                "      that is very long..."
               ;"          Notice that a pattern '#. ' causes the wrapping to match the start of
               ;"                of the text on the line above.
               ;"          The exact rules for matching this are as follows:
               ;"                (FirstWord?.N1".")!(FirstWord?1.3E1".")
               ;"                i.e. any number of digits, followed by "."
               ;"                OR 1-4 all upper-case characters followed by a "."
               ;"                        This will allow "VIII. " pattern but not "viii. "
               ;"                        HOWEVER, might get confused with a word, like "NOTE. "
               ;"
               ;"          This, below, is not dependant on SpecialIndent setting
               ;"          Also, because some of the lines have already partly wrapped, like this:
               ;"                "   1. Here is the beginning of a paragraph that is very long..."
               ;"                "and this is a line that has already wrapped.
               ;"                So when the first line is wrapped, it would look like this:
               ;"                "   1. Here is the beginning of a paragraph
               ;"                "      that is very long..."
               ;"                "and this is a line that has already wrapped.
               ;"                But is should look like this:
               ;"                "   1. Here is the beginning of a paragraph
               ;"                "      that is very long...and this is a line
               ;"                "      that has already wrapped.
               ;"                But the next line SHOULD NOT be pulled up if it is the start
               ;"                of a new paragraph.  I will tell by looking for #. paattern.
               ;"Result -- none
               if $get(TMGDEBUG)>0 do DebugEntry^TMGDEBUG(.DBIndent,"WordWrapArray^TMGSTUTL")
               new tempArray set tempArray=""  ;"holds result during work.
               new tindex set tindex=0
               new index
               set index=$order(Array(""))
               new s
               new residualS set residualS=""
               new AddZero set AddZero=0
               set Width=$get(Width,70)
                if $get(TMGDEBUG)>0 do DebugMsg^TMGDEBUG(.DBIndent,"Starting loop")
               if index'="" for  do  quit:((index="")&(residualS=""))
               . set s=$get(Array(index))
               . if s="" do
               . . set s=$get(Array(index,0))
               . . set AddZero=1
               . if residualS'="" do  ;"See if should join to next line. Don't if '#. ' pattern
               . . new FirstWord set FirstWord=$piece($$Trim(s)," ",1)
               . . if $get(TMGDEBUG)>0 do DebugMsg^TMGDEBUG(.DBIndent,"First Word: ",FirstWord)
               . . if (FirstWord?.N1".")!(FirstWord?1.4U1".") do     ;"match for '#.' pattern
               . . . ;"Here we have the next line is a new paragraph, so don't link to residualS
               . . . set tindex=tindex+1
               . . . if AddZero=0 set tempArray(tindex)=residualS
               . . . else  set tempArray(tindex,0)=residualS
               . . . set residualS=""
               . if $length(residualS)+$length(s)'<256 do
               . . if $get(TMGDEBUG)>0 do DebugMsg^TMGDEBUG(.DBIndent,"ERROR -- string too long.")
               . set s=residualS_s
               . set residualS=""
               . if $length(s)>Width do
               . . if $get(TMGDEBUG)>0 do DebugMsg^TMGDEBUG(.DBIndent,"Long line: ",s)
               . . new LineArray
               . . new NumLines
               . . set NumLines=$$SplitLine(.s,.LineArray,Width,.SpecialIndent)
               . . if $get(TMGDEBUG)>0 do ArrayDump^TMGDEBUG("LineArray")
               . . set s=""
               . . new LineIndex
               . . for LineIndex=1:1:NumLines do
               . . . set tindex=tindex+1
               . . . if AddZero=0 set tempArray(tindex)=LineArray(LineIndex)
               . . . else  set tempArray(tindex,0)=LineArray(LineIndex)
               . . ;"long wrap probably continues into next paragraph, so link together.
               . . if NumLines>2 do
               . . . if AddZero=0 set residualS=tempArray(tindex) set tempArray(tindex)=""
               . . . else  set residualS=tempArray(tindex,0) set tempArray(tindex,0)=""
               . . . set tindex=tindex-1
               . else  do
               . . set tindex=tindex+1
               . . if AddZero=0 set tempArray(tindex)=s
               . . else  set tempArray(tindex,0)=s
               . set index=$order(Array(index))
               else  do
               . if $get(TMGDEBUG)>0 do DebugMsg^TMGDEBUG(.DBIndent,"Array appears empty")
               kill Array
               merge Array=tempArray
                if $get(TMGDEBUG)>0 do ArrayDump^TMGDEBUG("Array")
               if $get(TMGDEBUG)>0 do DebugExit^TMGDEBUG(.DBIndent," WordWrapArray^TMGSTUTL")
               quit
SplitLine(s,LineArray,Width,SpecialIndent,Indent,DivS)
               ;"Scope: PUBLIC FUNCTION
               ;"Purpose: To take a long line, and wrap into an array, such that each
               ;"        line is not longer than Width.
               ;"        Line breaks will be made at spaces (or DivS), unless there are
               ;"        no spaces (of divS) in the entire line (in which case, the line
               ;"        will be divided at Width).
               ;"Input: s= string with the long line. **If passed by reference**, then
               ;"                it WILL BE CHANGED to equal the last line of array.
               ;"       LineArray -- MUST BE PASSED BY REFERENCE. This OUT variable will
               ;"                receive the resulting array.
               ;"                e.g. LineArray(1)=first Line.
               ;"                     LineArray(2)=Second Line. ...
               ;"       Width = the desired wrap width.
               ;"       SpecialIndent [OPTIONAL]: if 1, then wrapping is done like this:
               ;"                "   This is a very long line......"
               ;"           will be wrapped like this:
               ;"                "   This is a very
               ;"                "   long line ...
               ;"          Notice that the leading space is copied subsequent line.
               ;"          Also, a line like this:
               ;"                "   1. Here is the beginning of a paragraph that is very long..."
               ;"            will be wrapped like this:
               ;"                "   1. Here is the beginning of a paragraph
               ;"                "      that is very long..."
               ;"          Notice that a pattern '#. ' causes the wrapping to match the start
               ;"                of the text on the line above.
               ;"       Indent [OPTIONAL]: Any absolute amount that all lines should be indented by.
               ;"                This could be used if this long line is continuation of an
               ;"                indentation above it.
               ;"       DivS [OPTIONAL] : Default is " ", this is the divider character
               ;"                         or string, that will represent dividers between
               ;"                         words or phrases
               ;"Result: resulting number of lines (1 if no wrap needed).
               if $get(TMGDEBUG)>0 do DebugEntry^TMGDEBUG(.DBIndent,"SplitLine")
               new result set result=0
               kill LineArray
               if ($get(s)="")!($get(Width)'>0) goto SPDone
               new index set index=0
               new p,tempS,splitPoint
               set DivS=$get(DivS," ")
               new PreSpace set PreSpace=$$NeededWS(s,.SpecialIndent,.Indent)
               if ($length(s)>Width) for  do  quit:($length(s)'>Width)
               . for splitPoint=1:1:Width do  quit:($length(tempS)>Width)
               . . set tempS=$piece(s,DivS,1,splitPoint)
               . if splitPoint>1 do
               . . set tempS=$piece(s,DivS,1,splitPoint-1)
               . . set s=$piece(s,DivS,splitPoint,Width)
               . else  do
               . . ;"We must have a word > Width with no spaces--so just divide
               . . set tempS=$extract(s,1,Width)
               . . set s=$extract(s,Width+1,999)
               . set index=index+1
               . set LineArray(index)=tempS
               . set s=PreSpace_s
               set index=index+1
               set LineArray(index)=s
               set result=index
SPDone
               if $get(TMGDEBUG)>0 do DebugExit^TMGDEBUG(.DBIndent,"SplitLine")
               quit result
NeededWS(S,SpecialIndent,Indent)
               ;"Scope: PRIVATE
               ;"Purpose: Evaluate the line, and create the white space string
               ;"        need for wrapped lines
               ;"Input: s -- the string to eval.  i.e.
               ;"                "  John is very happy today ... .. .. .. .."
               ;"        or        "  1. John is very happy today ... .. .. .. .."
               ;"        SpecialIndent -- See SplitLine() discussion
               ;"        Indent -- See SplitLine() discussion
               new result set result=""
               if $get(S)="" goto NdWSDone
               new WSNum
               set WSNum=+$get(Indent,0)
               set WSNum=WSNum+$$NumLWS(S)
               if $get(SpecialIndent)=1 do
               . new ts,FirstWord
               . set ts=$$TrimL(.S)
               . set FirstWord=$piece(ts," ",1)
               . if (FirstWord?.N1".")!(FirstWord?1.4U1".") do     ;"match for '#.' pattern
               . . set WSNum=WSNum+$length(FirstWord)
               . . set ts=$piece(ts," ",2,9999)
               . . set WSNum=WSNum+$$NumLWS(.ts)+1
               set result=$$MakeWS(WSNum)
NdWSDone
               quit result
WriteWP(NodeRef)
               ;"Purpose: Given a reference to a WP field, this function will print it out.
               ;"INput: NodeRef -- the name of the node to print out.
               ;"        For example, "^PS(50.605,1,1)"
               ;"Modification: 2/10/06 -- I removed need for @NodeRef@(0) to contain data.
               new i
               ;"if $get(@NodeRef@(0))="" goto WWPDone
               set i=$order(@NodeRef@(0))
               if i'="" for  do  quit:(i="")
               . new OneLine
               . set OneLine=$get(@NodeRef@(i))
               . if OneLine="" set OneLine=$get(@NodeRef@(i,0))
               . write OneLine,!
               . set i=$order(@NodeRef@(i))
WWPDone quit
WPINSERT(REF,LNUM,S)    ;
               ;"Purpose: to insert one line into a WP record at given line number
               ;"Input: REF -- the is the reference to the node holding the WP record.  OPEN FORMAT.
               ;"              e.g. '^HL(772,177,"IN",'
               ;"       LNUM -- The line number to insert BEFORE.
               ;"       S -- The string to insert at LNUM.
               ;"Results : none.
               SET REF=$GET(REF) IF REF="" GOTO WPIDN
               NEW HDR SET HDR=REF_"0)"
               NEW DT SET DT=$PIECE($GET(@HDR),"^",5)
               IF DT'?7N DO  GOTO WPIDN
               . ;"Could put an error message here.  Don't seem to be pointing to a WP file.
               NEW REF2 SET REF2=REF_(LNUM-0.1)_",0)"
               SET @REF2=$GET(S)
               DO WPFIX(REF)
WPIDN     QUIT
WPDEL(REF,LNUM) ;
               ;"Purpose: to delete one line in a WP record at given line number
               ;"Input: REF -- the is the reference to the node holding the WP record.  OPEN FORMAT.
               ;"              e.g. '^HL(772,177,"IN",'
               ;"       LNUM -- The line number to delete.
               ;"Results : none.
               SET REF=$GET(REF) IF REF="" GOTO WPIDN
               NEW HDR SET HDR=REF_"0)"
               NEW DT SET DT=$PIECE($GET(@HDR),"^",5)
               IF DT'?7N DO  GOTO WPDDN
               . ;"Could put an error message here.  Don't seem to be pointing to a WP file.
               NEW CREF SET CREF=$$CREF^DILF(REF)
               KILL @CREF@(LNUM)
               DO WPFIX(REF)
WPDDN     QUIT
WPFIX(REF)      ;
               ;"Purpose: to fix the line numbers in a WP field to that they are all integers.
               ;"Input: REF -- the is the reference to the node holding the WP record.  OPEN FORMAT.
               ;"              e.g. '^HL(772,177,"IN",'
               SET REF=$GET(REF) IF REF="" GOTO WPFDN
               NEW HDR SET HDR=REF_"0)"
               NEW DT SET DT=$PIECE($GET(@HDR),"^",5)
               IF DT'?7N DO  GOTO WPFDN
               . ;"Could put an error message here.  Don't seem to be pointing to a WP file.
               NEW CREF SET CREF=$$CREF^DILF(REF)
               NEW TEMPA MERGE TEMPA=@CREF
               KILL @CREF
               NEW LINE SET LINE=0
               NEW I SET I=0
               FOR  SET I=$ORDER(TEMPA(I)) QUIT:+I'>0  DO
               . SET LINE=LINE+1
               . SET @CREF@(LINE,0)=$GET(TEMPA(I,0))
               SET @CREF@(0)=TEMPA(0)
               SET $P(@CREF@(0),"^",3)=LINE
               SET $P(@CREF@(0),"^",4)=LINE
WPFDN     QUIT
LPad(S,width)
               ;"Purpose: To add space ("pad") string S such that final width is per specified with.
               ;"                space is added to left side of string
               ;"Input: S : the string to pad.
               ;"        width : the desired final width
               ;"result: returns resulting string
               ;"Example: LPad("$5.23",7)="  $5.23"
               quit $$RJ^XLFSTR(.S,.width," ")
RPad(S,width)
               ;"Purpose: To add space ("pad") string S such that final width is per specified with.
               ;"                space is added to right side of string
               ;"Input: S : the string to pad.
               ;"        width : the desired final width
               ;"result: returns resulting string
               ;"Example: RPad("$5.23",7)="$5.23  "
               quit $$LJ^XLFSTR(.S,.width," ")
Center(S,width)
               ;"Purpose: to return a center justified string
               quit $$CJ^XLFSTR(.S,.width," ")
Clip(S,width)
               ;"Purpose: to ensure that string S is no longer than width
               new result set result=$get(S)
               if result'="" set result=$extract(S,1,width)
ClipDone
               quit result
STRB2H(s,F,noSpace)
               ;"Convert a string to hex characters)
               ;"Input: s -- the input string (need not be ascii characters)
               ;"        F -- (optional) if F>0 then will append an ascii display of string.
               ;"      noSpace -- (Optional) if >0 then characters NOT separated by spaces
               ;"result -- the converted string
               new i,ch
               new result set result=""
               for i=1:1:$length(s) do
               . set ch=$extract(s,i)
               . set result=result_$$HEXCHR^TMGMISC($ascii(ch))
               . if +$get(noSpace)=0 set result=result_" "
               if $get(F)>0 set result=result_"   "_$$HIDECTRLS^TMGSTUTL(s)
               quit result
HIDECTRLS(s)
               ;"hide all unprintable characters from a string
               new i,ch,byte
               new result set result=""
               for i=1:1:$length(s) do
               . set ch=$e(s,i)
               . set byte=$ascii(ch)
               . if (byte<32)!(byte>122) set result=result_"."
               . else  set result=result_ch
               quit result
CapWords(S,Divider)
               ;"Purpose: convert each word in the string: 'test string' --> 'Test String', 'TEST STRING' --> 'Test String'
               ;"Input: S -- the string to convert
               ;"        Divider -- [OPTIONAL] the character used to separate string (default is ' ' [space])
               ;"Result: returns the converted string
               new s2,part
               new result set result=""
               set Divider=$get(Divider," ")
               set s2=$$LOW^XLFSTR(S)
               for i=1:1 do  quit:part=""
               . set part=$piece(s2,Divider,i)
               . if part="" quit
               . set $extract(part,1)=$$UP^XLFSTR($extract(part,1))
               . if result'="" set result=result_Divider
               . set result=result_part
               quit result
LinuxStr(S)
               ;"Purpose: convert string to a valid linux filename
               ;"      e.g. 'File Name' --> 'File\ Name'
               quit $$Substitute(.S," ","\ ")
NiceSplit(S,Len,s1,s2,s2Min,DivCh)
               ;"Purpose: to split S into two strings, s1 & s2
               ;"      Furthermore, s1's length must be <= length.
               ;"      and the split will be made at spaces
               ;"Input: S -- the string to split
               ;"       Len -- the length limit of s1
               ;"       s1 -- PASS BY REFERENCE, an OUT parameter
               ;"              receives first part of split
               ;"       s2 -- PASS BY REFERENCE, an OUT parameter
               ;"              receives the rest of string
               ;"       s2Min -- OPTIONAL -- the minimum that
               ;"              length of s2 can be.  Note, if s2
               ;"              is "", then this is not applied
               ;"       DivCH -- OPTIONAL, default is " ".
               ;"              This is the character to split words by
               ;"Output: s1 and s2 is filled with data
               ;"Result: none
               set (s1,s2)=""
               if $get(DivCh)="" set DivCh=" "
               if $length(S)'>Len do  goto NSpDone
               . set s1=S
               new i
               new done
               for i=200:-1:1 do  quit:(done)
               . set s1=$piece(S,DivCh,1,i)_DivCh
               . set s2=$piece(S,DivCh,i+1,999)
               . set done=($length(s1)'>Len)
               . if done,+$get(s2Min)>0 do
               . . if s2="" quit
               . . set done=($length(s2)'<s2Min)
NSpDone quit
StrToWP(s,pArray,width,DivCh,InitLine)
               ;"Purpose: to take a long string and wrap it into formal WP format
               ;"Input: s:  the long string to wrap into the WP field
               ;"      pArray: the NAME of the array to put output into.
               ;"              Any pre-existing data in this array will NOT be killed
               ;"      width: OPTIONAL -- the width to target for word wrapping. Default is 60
               ;"      DivCh: OPTIONAL -- the character to use separate words (to allow nice wrapping). Default is " "
               ;"      InitLine: OPTIONAL -- the line to start putting data into.  Default is 1
               ;"Output: pArray will be filled as follows:
               ;"          @pArray@(InitLine+0)=line 1
               ;"          @pArray@(InitLine+1)=line 2
               ;"          @pArray@(InitLine+2)=line 3
               if +$get(width)=0 set width=60
               if $get(DivCh)="" set DivCh=" "
               new tempS set tempS=$get(s)
               if $get(InitLine)="" set InitLine=1
               new curLine set curLine=+InitLine
               ;"kill @pArray
               for  do  quit:(tempS="")
               . new s1,s2
               . do NiceSplit(tempS,width,.s1,.s2,,DivCh)
               . set @pArray@(curLine)=s1
               . set curLine=curLine+1
               . set tempS=s2
               quit
WPToStr(pArray,DivCh,MaxLen,InitLine)
               ;"Purpose: This is the opposite of StrToWP.  It takes a WP field, and concatenates
               ;"         each line to make one long string.
               ;"Input: pArray: the NAME of the array to get WP lines from. Expected format as follows
               ;"          @pArray@(InitLine+0)=line 1
               ;"          @pArray@(InitLine+1)=line 2
               ;"          @pArray@(InitLine+2)=line 3
               ;"              -or-
               ;"          @pArray@(InitLine+0,0)=line 1
               ;"          @pArray@(InitLine+1,0)=line 2
               ;"          @pArray@(InitLine+2,0)=line 3
               ;"       DivCh: OPTIONAL, default is " ".  This character is appended to the end of each line, e.g
               ;"              output=output_line1_DivCh_line2
               ;"       MaxLen: OPTIONAL, default=255.  The maximum allowable length of the resulting string.
               ;"       InitLine: OPTIONAL -- the line in pArray to start reading data from.  Default is 1
               ;"result: Returns one long string representing the WP array
               new i,OneLine,result,Len
               set i=$get(InitLine,1)
               set result=""
               set DivCh=$get(DivCh," ")
               set MaxLen=$get(MaxLen,255)
               set Len=0
               for  do  quit:(OneLine="")!(Len'<MaxLen)!(+i'>0)
               . set OneLine=$get(@pArray@(i))
               . if OneLine="" set OneLine=$get(@pArray@(i,0))
               . if OneLine="" quit
               . set Len=$length(result)+$length(DivCh)
               . if Len+$length(OneLine)>MaxLen do
               . . set OneLine=$extract(OneLine,1,(MaxLen-Len))
               . set result=result_OneLine_DivCh
               . set Len=Len+$length(OneLine)
               . set i=$order(@pArray@(i))
               quit result;
WP2ARRAY(REF,OUTREF)    ;
               ;"Purpose: to convert a Fileman WP array into a flat ARRAY
               ;"Input:REF -- The reference to the header node (e.g.  "^TMG(22702,99,1)" for example below)
               ;"      ARRAY -- REFERENCE to OUT PARAMETER.  Prior values killed.
               ;"Note:  The format of a WP field is as follows:
               ;"      e.g.    ^TMG(22702,99,1,0) = ^^4^4^3050118^
               ;"               ^TMG(22702,99,1,1,0) = Here is the first line of text
               ;"               ^TMG(22702,99,1,2,0) = And here is another line
               ;"               ^TMG(22702,99,1,3,0) =
               ;"               ^TMG(22702,99,1,4,0) = And here is a final line
               ;"  And the format of the 0 node is: ^^<line count>^<linecount>^<fmdate>^^
               ;"Output: ARRAY(1) -- 1st line
               ;"        ARRAY(2) -- 2nd line ... etc.
               ;"RESULTS: none
               NEW TREF SET TREF=$GET(REF)
               SET OUTREF=$GET(OUTREF)
               IF OUTREF="" GOTO W2ADN
               KILL @OUTREF
               IF $DATA(@TREF)=0 GOTO W2ADN
               NEW I SET I=0
               FOR  SET TREF=$QUERY(@TREF) QUIT:(TREF="")  DO
               . SET @OUTREF@(I)=@TREF
               . SET I=I+1
               IF $LENGTH($GET(@OUTREF@(0)),"^")>5 KILL @OUTREF@(0)
W2ADN     QUIT
               ;
ARRAY2WP(REFARRAY,REF)  ;
               ;"Purpose: to convert an ARRAY to a Fileman WP array
               ;"Input:REFARRAY -- Reference (aka 'name') of plain array containing text
               ;"                 data, to be loaded into a Fileman-format WP array.  E.g.
               ;"                      ARRAY(1) -- 1st line
               ;"                      ARRAY(1,2) -- 2nd line  <-- sub-nodes OK
               ;"                      ARRAY(2) -- 3rd line ... etc.
               ;"               NOTE: that the array is 'flattened' into top-level indices
               ;"      REF -- The reference to the header node (e.g.  "^TMG(22702,99,1)" for example below)
               ;"              Prior data in @REF is killed
               ;"Note:  The format of a WP field is as follows:
               ;"      e.g.    ^TMG(22702,99,1,0) = ^^4^4^3050118^
               ;"               ^TMG(22702,99,1,1,0) = Here is the first line of text
               ;"               ^TMG(22702,99,1,2,0) = And here is another line
               ;"               ^TMG(22702,99,1,3,0) =
               ;"               ^TMG(22702,99,1,4,0) = And here is a final line
               ;"  And the format of the 0 node is: ^^<line count>^<linecount>^<fmdate>^^
               ;"Output: @REF is stuffed with data.  No XREF's are triggered.
               ;"RESULTS: none
               SET REF=$GET(REF)
               KILL @REF
               NEW AREF SET AREF=$GET(REFARRAY)
               IF $DATA(@AREF)=0 GOTO A2WDN
               NEW I SET I=0
               FOR  SET AREF=$QUERY(@AREF) QUIT:(AREF="")  DO
               . SET I=I+1
               . SET @REF@(I,0)=$GET(@AREF)
               NEW S
               SET $PIECE(S,"^",3)=I
               SET $PIECE(S,"^",4)=I
               NEW X,%
               DO NOW^%DTC
               SET $PIECE(S,"^",5)=X
               SET @REFARRAY@(0)=S
A2WDN     QUIT
               ;
Comp2Strs(s1,s2)
               ;"Purpose: To compare two strings and assign an arbritrary score to their similarity
               ;"Input: s1,s2 -- The two strings to compare
               ;"Result: a score comparing the two strings
               ;"      0.5 point for every word in s1 that is also in s2 (case specific)
               ;"      0.25 point for every word in s1 that is also in s2 (not case specific)
               ;"      0.5 point for every word in s2 that is also in s1 (case specific)
               ;"      0.25 point for every word in s2 that is also in s1 (not case specific)
               ;"      1 points if same number of words in string (compared each way)
               ;"      2 points for each word that is in the same position in each string (case specific)
               ;"      1.5 points for each word that is in the same position in each string (not case specific)
               new score set score=0
               new Us1 set Us1=$$UP^XLFSTR(s1)
               new Us2 set Us2=$$UP^XLFSTR(s2)
               new i
               for i=1:1:$length(s1," ") do
               . if s2[$piece(s1," ",i) set score=score+0.5
               . else  if Us2[$piece(Us1," ",i) set score=score+0.25
               . if $piece(s1," ",i)=$piece(s2," ",i) set score=score+1
               . else  if $piece(Us1," ",i)=$piece(Us2," ",i) set score=score+1.5
               for i=1:1:$length(s2," ") do
               . if s1[$piece(s2," ",i) set score=score+0.5
               . else  if Us1[$piece(Us2," ",i) set score=score+0.25
               . if $piece(s1," ",i)=$piece(s2," ",i) set score=score+1
               . else  if $piece(Us1," ",i)=$piece(Us2," ",i) set score=score+1.5
               if $length(s1," ")=$length(s2," ") set score=score+2
               quit score
PosNum(s,Num,LeadingSpace)
               ;"Purpose: To return the position of the first Number in a string
               ;"Input: S -- string to check
               ;"       Num -- OPTIONAL, default is 0-9 numbers.  number to look for.
               ;"       LeadingSpace -- OPTIONAL.  If 1 then looks for " #" or " .#", not just "#"
               ;"Results: -1 if not found, otherwise position of found digit.
               new result set result=-1
               new Leader set Leader=""
               if $get(LeadingSpace)=1 set Leader=" "
               if $get(Num) do  goto PNDone
               . set result=$find(s,Leader_Num)-1
               new temp,i,decimalFound
               for i=0:1:9 do
               . set decimalFound=0
               . set temp=$find(s,Leader_i)
               . if (temp=0)&(Leader'="") do
               . . set temp=$find(s,Leader_"."_i)
               . . if temp>-1 set decimalFound=1
               . if temp>-1 set temp=temp-$length(Leader_i)
               . if decimalFound set temp=temp-1
               . if (temp>0)&((temp<result)!(result=-1)) set result=temp
PNDone
               if (result>0)&(Leader=" ") set result=result+1
               quit result
IsNumeric(s)
               ;"Purpose: To deterimine if word s is a numeric
               ;"      Examples of numeric words:
               ;"              10,  N-100,  0.5%,   50000UNT/ML
               ;"      the test will be if the word contains any digit 0-9
               ;"Results: 1 if is a numeric word, 0 if not.
               quit ($$PosNum(.s)>0)
ScrubNumeric(s)
               ;"Purpose: This is a specialty function designed to remove numeric words
               ;"      from a sentence.  E.g.
               ;"        BELLADONNA ALK 0.3/PHENOBARB 16MG CHW TB --> BELLADONNA ALK /PHENOBARB CHW TB
               ;"        ESTROGENS,CONJUGATED 2MG/ML INJ (IN OIL) --> ESTROGENS,CONJUGATED INJ (IN OIL)
               new Array,i,result
               set s=$$Substitute(s,"/MG","")
               set s=$$Substitute(s,"/ML","")
               set s=$$Substitute(s,"/"," / ")
               set s=$$Substitute(s,"-"," - ")
               do CleaveToArray(s," ",.Array)
               new ToKill
               set i=0 for  set i=$order(Array(i)) quit:+i'>0  do
               . if (Array(i)="MG")&($get(ToKill(i-1))=1) set ToKill(i)=1 quit
               . if (Array(i)="MCG")&($get(ToKill(i-1))=1) set ToKill(i)=1 quit
               . if (Array(i)="MEQ")&($get(ToKill(i-1))=1) set ToKill(i)=1 quit
               . if (Array(i)="%")&($get(ToKill(i-1))=1) set ToKill(i)=1 quit
               . if (Array(i)="MM")&($get(ToKill(i-1))=1) set ToKill(i)=1 quit
               . if $$IsNumeric(Array(i))=0 quit
               . set ToKill(i)=1
               . new tempS set tempS=$get(Array(i-1))
               . if (tempS="/")!(tempS="-") set ToKill(i-1)=1
               . if (tempS="NO")!(tempS="#") set ToKill(i-1)=1
               set i=0 for  set i=$order(Array(i)) quit:+i'>0  do
               . if $get(ToKill(i))=1 kill Array(i)
               set i="",result=""
               for  set i=$order(Array(i)) quit:+i'>0  do
               . set result=result_Array(i)_" "
               set result=$$Trim(result)
               set result=$$Substitute(result," / ","/")
               set result=$$Substitute(result," - ","-")
               quit result
Pos(subStr,s,count)
               ;"Purpose: return the beginning position of subStr in s
               ;"Input: subStr -- the string to be searched for in s
               ;"       s -- the string to search
               ;"       count -- OPTIONAL, the instance to return pos of (1=1st, 2=2nd, etc.)
               ;"              if count=2 and only 1 instance exists, then 0 returned
               ;"Result: the beginning position, or 0 if not found
               ;"Note: This function differs from $find in that $find returns the pos of the
               ;"      first character AFTER the subStr
               set count=$get(count,1)
               new result set result=0
               new instance set instance=1
PS1
               set result=$find(s,subStr,result+1)
               if result>0 set result=result-$length(subStr)
               if count>instance set instance=instance+1 goto PS1
               quit result
ArrayPos(array,s)
               ;"Purpose: return the index position of s in array
               ;"...
               quit
DiffPos(s1,s2)
               ;"Purpose: Return the position of the first difference between s1 and s2
               ;"Input -- s1, s2 :  The strings to compare.
               ;"result:  the position (in s1) of the first difference, or 0 if no difference
               new l set l=$length(s1)
               if $length(s2)>l set l=$length(s2)
               new done set done=0
               new i for i=1:1:l do  quit:(done=1)
               . set done=($extract(s1,1,i)'=$extract(s2,1,i))
               new result set result=0
               if done=1 set result=i
               quit result
DiffWPos(Words1,Words2)
               ;"Purpose: Return the index of the first different word between Words arrays
               ;"Input:  Words1,Words2 -- the array of words, such as would be made
               ;"              by CleaveToArray^TMGSTUTL
               ;"Returns: Index of first different word in Words1, or 0 if no difference
               new l set l=+$get(Words1("MAXNODE"))
               if +$get(Words2("MAXNODE"))>l set l=+$get(Words2("MAXNODE"))
               new done set done=0
               new i for i=1:1:l do  quit:(done=1)
               . set done=($get(Words1(i))'=$get(Words2(i)))
               new result
               if done=1 set result=i
               else  set result=0
               quit result
SimStr(s1,p1,s2,p2)
               ;"Purpose: return the matching string in both s1 and s2, starting
               ;"         at positions p1 and p2.
               ;"         Example: s1='Tom is 12 years old', p1=7
               ;"                  s2='Bill will be 12 years young tomorrow' p2=13
               ;"                 would return ' 12 years '
               new ch1,ch2,offset,result,done
               set result="",done=0
               for offset=0:1:9999 do  quit:(done=1)
               . set ch1=$extract(s1,p1+offset)
               . set ch2=$extract(s2,p2+offset)
               . if (ch1=ch2) set result=result_ch1
               . else  set done=1
               quit result
SimWord(Words1,p1,Words2,p2)
               ;"Purpose: return the matching words in both words array 1 and 2, starting
               ;"         at word positions p1 and p2.  This function is different from
               ;"         SimStr in that it works with whole words
               ;"         Example:
               ;"              Words1(1)=Tom               Words2(1)=Bill
               ;"              Words1(2)=is                Words2(2)=will
               ;"              Words1(3)=12                Words2(3)=be
               ;"              Words1(4)=years             Words2(4)=12
               ;"              Words1(5)=old               Words2(5)=years
               ;"              Words1("MAXNODE")=5         Words2(6)=young
               ;"                                          Words2(7)=tomorrow
               ;"                                          Words1("MAXNODE")=7
               ;"              This will return 3, (where '12 years' starts)
               ;"              if p1=3 and p2=4 would return '12 years'
               ;"Note: A '|' will be used as word separator when constructing result
               ;"Input:  Words1,Words2 -- the array of words, such as would be made
               ;"              by CleaveToArray^TMGSTUTL.  e.g.
               ;"        p1,p2 -- the index of the word in Words array to start with
               ;"result: (see example)
               new w1,w2,offset,result,done
               set result="",done=0
               for offset=0:1:$get(Words1("MAXNODE")) do  quit:(done=1)
               . set w1=$get(Words1(offset+p1))
               . set w2=$get(Words2(offset+p2))
               . if (w1=w2)&(w1'="") do
               . . if (result'="") set result=result_"|"
               . . set result=result_w1
               . else  set done=1
               quit result
SimPos(s1,s2,DivStr,pos1,pos2,MatchStr)
               ;"Purpose: return the first position that two strings are similar.  This means
               ;"         the first position in string s1 that characters match in s2.  A
               ;"         match will be set to mean 3 or more characters being the same.
               ;"         Example: s1='Tom is 12 years old'
               ;"                  s2='Bill will be 12 years young tomorrow'
               ;"                  This will return 7, (where '12 years' starts)
               ;"Input: s1,s2 -- the two strings to compare
               ;"       DivStr -- OPTIONAL, the character to use to separate the answers
               ;"                        in the return string.  Default is '^'
               ;"       pos1 -- OPTIONAL, an OUT PARAMETER.  Returns Pos1 from result
               ;"       pos2 -- OPTIONAL, an OUT PARAMETER.  Returns Pos2 from result
               ;"       MatchStr -- OPTIONAL, an OUT PARAMETER.  Returns MatchStr from result
               ;"Results: Pos1^Pos2^MatchStr  Pos1=position in s1, Pos2=position in s2,
               ;"                             MatchStr=the matching Str
               set DivStr=$get(DivStr,"^")
               new startPos,subStr,found,s2Pos
               set found=0,s2Pos=0
               for startPos=1:1:$length(s1) do  quit:(found=1)
               . set subStr=$extract(s1,startPos,startPos+3)
               . set s2Pos=$$Pos(subStr,s2)
               . set found=(s2Pos>0)
               new result
               if found=1 do
               . set pos1=startPos,pos2=s2Pos
               . set MatchStr=$$SimStr(s1,startPos,s2,s2Pos)
               else  do
               . set pos1=0,pos2=0,MatchStr=""
               set result=pos1_DivStr_pos2_DivStr_MatchStr
               quit result
SimWPos(Words1,Words2,DivStr,p1,p2,MatchStr)
               ;"Purpose: return the first position that two word arrays are similar.  This means
               ;"         the first index in Words array 1 that matches to words in Words array 2.
               ;"         A match will be set to mean the two words are equal
               ;"         Example:
               ;"              Words1(1)=Tom               Words2(1)=Bill
               ;"              Words1(2)=is                Words2(2)=will
               ;"              Words1(3)=12                Words2(3)=be
               ;"              Words1(4)=years             Words2(4)=12
               ;"              Words1(5)=old               Words2(5)=years
               ;"              Words1("MAXNODE")=5         Words2(6)=young
               ;"                                          Words2(7)=tomorrow
               ;"                                          Words2("MAXNODE")=7
               ;"              This will return 3, (where '12 years' starts)
               ;"Input: Words1,Words2 -- the two arrays to compare
               ;"       DivStr -- OPTIONAL, the character to use to separate the answers
               ;"                        in the return string.  Default is '^'
               ;"       pos1 -- OPTIONAL, an OUT PARAMETER.  Returns Pos1 from result
               ;"       pos2 -- OPTIONAL, an OUT PARAMETER.  Returns Pos2 from result
               ;"       MatchStr -- OPTIONAL, an OUT PARAMETER.  Returns MatchStr from result
               ;"Results: Pos1^Pos2^MatchStr  Pos1=position in Words1, Pos2=position in Words2,
               ;"                             MatchStr=the first matching Word or phrase
               ;"                                 Note: | will be used as a word separator for phrases.
               set DivStr=$get(DivStr,"^")
               new startPos,word1,found,w2Pos
               set found=0,s2Pos=0
               for startPos=1:1:+$get(Words1("MAXNODE")) do  quit:(found=1)
               . set word1=$get(Words1(startPos))
               . set w2Pos=$$IndexOf^TMGMISC($name(Words2),word1)
               . set found=(w2Pos>0)
               if found=1 do
               . set p1=startPos,p2=w2Pos
               . set MatchStr=$$SimWord(.Words1,p1,.Words2,p2)
               else  do
               . set p1=0,p2=0,MatchStr=""
               new result set result=p1_DivStr_p2_DivStr_MatchStr
               quit result
DiffStr(s1,s2,DivChr)
               ;"Purpose: Return how s1 differs from s2.  E.g.
               ;"          s1='Today was the birthday of Bill and John'
               ;"          s2='Yesterday was the birthday of Tom and Sue'
               ;"          results='Today^1^Bill^26^John^35'
               ;"          This means that 'Today', starting at pos 1 in s1 differs
               ;"            from s2.  And 'Bill' starting at pos 26 differs from s2 etc..
               ;"Input: s1,s2 -- the two strings to compare
               ;"       DivStr -- OPTIONAL, the character to use to separate the answers
               ;"                        in the return string.  Default is '^'
               ;"Results: DiffStr1^pos1^DiffStr2^pos2^...
               set DivChr=$get(DivChr,"^")
               new result set result=""
               new offset set offset=0
               new p1,p2,matchStr,matchLen
               new diffStr,temp
DSLoop
               set temp=$$SimPos(s1,s2,DivChr,.p1,.p2,.matchStr)
               ;"Returns: Pos1^Pos2^MatchStr  Pos1=pos in s1, Pos2=pos in s2, MatchStr=the matching Str
               if p1=0 set:(s1'="") result=result_s1_DivChr_(+offset) goto DSDone
               set matchLen=$length(matchStr)
               if p1>1 do
               . set diffStr=$extract(s1,1,p1-1)
               . set result=result_diffStr_DivChr_(1+offset)_DivChr
               set offset=offset+(p1+matchLen-1)
               set s1=$extract(s1,p1+matchLen,9999)  ;"trim s1
               set s2=$extract(s2,p2+matchLen,9999)  ;"trim s2
               goto DSLoop
DSDone
               quit result
DiffWords(Words1,Words2,DivChr)
               ;"Purpose: Return how Word arrays Words1 differs from Words2.  E.g.
               ;"         Example:
               ;"              Words1(1)=Tom               Words2(1)=Bill
               ;"              Words1(2)=is                Words2(2)=will
               ;"              Words1(3)=12                Words2(3)=be
               ;"              Words1(4)=years             Words2(4)=12
               ;"              Words1(5)=old               Words2(5)=years
               ;"              Words1("MAXNODE")=5         Words2(6)=young
               ;"                                          Words2(7)=tomorrow
               ;"                                          Words1("MAXNODE")=7
               ;"
               ;"          s1='Today was the birthday of Bill and John'
               ;"          s2='Yesterday was the birthday of Tom and Sue'
               ;"          results='Tom is^1^old^5'
               ;"          This means that 'Tom is', starting at pos 1 in Words1 differs
               ;"            from Words2.  And 'old' starting at pos 5 differs from Words2 etc..
               ;"Input: Words1,Words2 -- PASS BY REFERENCE.  The two word arrays to compare
               ;"       DivStr -- OPTIONAL, the character to use to separate the answers
               ;"                        in the return string.  Default is '^'
               ;"Note: The words in DiffStr are divided by "|"
               ;"Results:  DiffStr1A>DiffStr1B^pos1>pos2^DiffStr2A>DiffStr2B^pos1>pos2^...
               ;"      The A DiffStr would be what the value is in Words1, and
               ;"      the B DiffStr would be what the value is in Words2, or @ if deleted.
               set DivChr=$get(DivChr,"^")
               new result set result=""
               new trimmed1,trimmed2 set trimmed1=0,trimmed2=0
               new p1,p2,matchStr,matchLen
               new diffStr1,diffStr2,temp
               new tWords1,tWords2
               merge tWords1=Words1
               merge tWords2=Words2
               new i,len1,len2,trimLen1,trimLen2
               new diffPos1,diffPos2
               set len1=+$get(tWords1("MAXNODE"))
               set len2=+$get(tWords2("MAXNODE"))
DWLoop
               set temp=$$SimWPos(.tWords1,.tWords2,DivChr,.p1,.p2,.matchStr)
               ;"Returns: Pos1^Pos2^MatchStr  Pos1=pos in s1, Pos2=pos in s2, MatchStr=the matching Str
               ;"Possible return options:
               ;"  p1=p2=0 -- two strings have nothing in common
               ;"  p1=p2=1 -- first word of each string is the same
               ;"  p1=p2=X -- words 1..(X-1) differ from each other.
               ;"  p1>p2 -- e.g. EXT REL TAB  -->  XR TAB
               ;"  p1<p2 -- XR TAB  -->  EXT REL TAB
               if (p1=0)&(p2=0) do
               . set diffStr1=$$CatArray(.tWords1,1,len1,"|")
               . set diffStr2=$$CatArray(.tWords2,1,len2,"|")
               . set trimLen1=len1,trimLen2=len2
               . set diffPos1=1+trimmed1
               . set diffPos2=1+trimmed2
               else  if (p1=1)&(p2=1) do
               . set diffStr1="@",diffStr2="@"
               . set trimLen1=1,trimLen2=1
               . set diffPos1=0,diffPos2=0
               else  do
               . set diffStr1=$$CatArray(.tWords1,1,p1-1,"|")
               . set diffStr2=$$CatArray(.tWords2,1,p2-1,"|")
               . set trimLen1=p1-1,trimLen2=p2-1
               . set diffPos1=1+trimmed1,diffPos2=1+trimmed2
               if diffStr1="" set diffStr1="@"
               if diffStr2="" set diffStr2="@"
               if '((diffStr1="@")&(diffStr1="@")) do
               . set:(result'="")&($extract(result,$length(result))'=DivChr) result=result_DivChr
               . set result=result_diffStr1_">"_diffStr2_DivChr
               . set result=result_diffPos1_">"_diffPos2
               do ListTrim^TMGMISC("tWords1",1,trimLen1,"MAXNODE")
               do ListTrim^TMGMISC("tWords2",1,trimLen2,"MAXNODE")
               set trimmed1=trimmed1+trimLen1
               set trimmed2=trimmed2+trimLen2
               if ($get(tWords1("MAXNODE"))=0)&($get(tWords2("MAXNODE"))=0) goto DWDone
               goto DWLoop
DWDone
               quit result
CatArray(Words,i1,i2,DivChr)
               ;"Purpose: For given word array, return contatenated results from index1 to index2
               ;"Input: Words -- PASS BY REFERENCE.  Array of Words, as might be created by CleaveToArray
               ;"       i1 -- the index to start concat at
               ;"       i2 -- the last index to include in concat
               ;"       DivChr -- OPTIONAL.  The character to used to separate words.  Default=" "
               new result set result=""
               set DivChr=$get(DivChr," ")
               new i for i=i1:1:i2 do
               . new word set word=$get(Words(i))
               . if word="" quit
               . set:(result'="")&($extract(result,$length(result))'=DivChr) result=result_DivChr
               . set result=result_word
               quit result
QTPROTECT(S)    ;"SAAC compliant entry point
               quit $$QtProtect(.S)
QtProtect(s)
               ;"Purpose: Protects quotes by converting all quotes do double quotes (" --> "")
               ;"Input : s -- The string to be modified.  Original string is unchanged.
               ;"Result: returns a string with all instances of single instances of quotes
               ;"        being replaced with two quotes.
               new tempS
               set tempS=$$Substitute($get(s),"""""","<^@^>")  ;"protect original double quotes
               set tempS=$$Substitute(tempS,"""","""""")
               set tempS=$$Substitute(tempS,"<^@^>","""""")  ;"reverse protection
               quit tempS
GetStrPos(s,StartPos,P1,P2)      ;"INCOMPLETE!!
               ;"Purpose: return position of start and end of a string (marked by starting
               ;"      and ending quote.  Search is started at StartPos.
               ;"      Example: if s='She said "Hello" to Bill', and StartPos=1
               ;"      then P1 should be returned as 10, and P2 as 16
               ;"Input: s -- the text to be
               ;"       StartPos -- the position to start the search at. Optional: default=1
               ;"       P1 -- PASS BY REFERENCE, an Out Parameter
               ;"       P2 -- PASS BY REFERENCE, an Out Parameter
               ;"Results: None
               ;"Output: P1 and P2 are returned as per example above, or 0 if not quotes in text
               set P1=0,P2=0
               if s'["""" goto GSPDone
               set StartPos=+$get(StartPos,1)
               new tempS set tempS=$extract(s,StartPos,$length(s))
               set tempS=$$Substitute(tempS,"""""",$char(1)_$char(1))
               ;"FINISH...   NOT COMPLETED...
GSPDone
               quit
InQt(s,Pos)
               ;"Purpose: to return if a given character, in string(s), is insided quotes
               ;"         e.g. s='His name is "Bill," OK?'  and if p=14, then returns 1
               ;"         (note the above string is usually stored as:
               ;"           "His name is ""Bill,"" OK?" in the text editor, BUT in the
               ;"          strings that will be passed here I will get only 1 quote character
               ;"Input: s -- the string to scan
               ;"       Pos -- the position of the character in question
               ;"Results: 0 if not inside quotes, 1 if it is.
               ;"NOTE: if Pos points to the bounding quotes, the result is 0
               new inQt set inQt=0
               if (Pos>$length(s))!(Pos<1) goto IQtDone
               new p set p=$find(s,"""")-1
               if p<Pos for p=p-1:1:Pos set:($extract(s,p)="""") inQt='inQt
IQtDone quit inQt
HNQTSUB(s,SubStr)        ;"A ALL CAPS ENTRY POINT
               quit $$HasNonQtSub(.s,.SubStr)
HasNonQtSub(s,SubStr)
               ;"Purpose: Return if string S contains SubStr, not inside quotes.
               new Result set Result=0
               if s'[SubStr goto HNQCDn
               new p set p=1
               new done set done=0
               new instance set instance=0
               for  do  quit:(done=1)
               . set instance=instance+1
               . set p=$$Pos(SubStr,s,instance)
               . if p=0 set done=1 quit
               . if $$InQt(.s,p)=0 set Result=1,done=1 quit
HNQCDn   quit Result
GetWord(s,Pos,OpenDiv,CloseDiv)
               ;"Purpose: Extract a word from a sentance, bounded by OpenDiv,CloseDiv
               ;"Example: s="The cat is hungry", Pos=14 --> returns "hungry"
               ;"Example: s="Find('Purple')", Pos=8, OpenDiv="(", CloseDiv=")" --> returns "'Purple'"
               ;"Input: s -- the string containing the source sentence
               ;"       Pos -- the index of a character anywhere inside desired word.
               ;"       OpenDiv -- OPTIONAL, default is " "  this is what marks the start of the word.
               ;"                NOTE: if $length(OpenDiv)>1, then OpenDiv is considered
               ;"                      to be a SET of characters, any of which can be used
               ;"                      as a opening character.
               ;"       CloseDiv -- OPTIONAL, default is " "  this is what marks the end of the word.
               ;"                NOTE: if $length(CloseDiv)>1, then CloseDiv is considered
               ;"                      to be a SET of characters, any of which can be used
               ;"                      as a closing character.
               ;"Results: returns desired word, or "" if problem.
               ;
               new result set result=""
               set OpenDiv=$get(OpenDiv," ")
               set CloseDiv=$get(CloseDiv," ")
               set Pos=+$get(Pos) if Pos'>0 goto GWdDone
               new p1,p2,len,i
               set len=$length(s)
               for p2=Pos:1:len if CloseDiv[$extract(s,p2) set p2=p2-1 quit
               for p1=Pos:-1:1 if OpenDiv[$extract(s,p1) set p1=p1+1 quit
               set result=$extract(s,p1,p2)
GWdDone quit result
MATCHXTR(s,DivCh,Group,Map,Restrict)
               ;"Purpose: Provide a SAAC compliant (all upper case) entry point) for MatchXtract
               quit $$MatchXtract(.s,.DivCh,.Group,.Map,.Restrict)
               ;
MatchXtract(s,DivCh,Group,Map,Restrict)
               ;"Purpose to extract a string bounded by DivCh, honoring matching encapsulators
               ;"Note: the following markers are honored as paired encapsulators:
               ;"      ( ),  { },  | |,  < >,  # #, [ ],
               ;"      To specify which set to use, DivCh should specify only OPENING character
               ;"E.g. DivCh="{"
               ;"       s="Hello {There}" --> return "There"
               ;"       s="Hello {There {nested braces} friend}" --> return "There {nested braces} friend"
               ;"     DivCh="|"
               ;"       s="Hello |There|" --> "There"
               ;"       s="Hello |There{|friend|}|" --> "There{|friend|}"
               ;"          Notice that the second "|" was not paired to the first, because an opening brace was first.
               ;"Input: s -- The string to evaluate
               ;"       DivCh -- The opening character of the encapsulator to use
               ;"       Group -- OPTIONAL.  Default is 1.  If line has more than one set of encapsulated entries, which group to get from
               ;"       Map -- OPTIONAL.  PASS BY REFERENCE.  If function is to be called multiple times,
               ;"              then a prior Map variable can be passed to speed processing.
               ;"       Restrict -- OPTIONAL.  A string of allowed opening encapsulators (allows others to be ignored)
               ;"                  e.g. "{(|"  <-- will cause "<>#[]" to be ignored
               ;"Results: Returns extracted string.
               if $data(Map)=0 do MapMatch(s,.Map,.Restrict)
               set Group=$get(Group,1)
               set DivCh=$get(DivCh)
               new Result set Result=""
               new i set i=0
               for  set i=$order(Map(Group,i)) quit:(i="")!(Result'="")  do
               . if DivCh'=$get(Map(Group,i)) quit
               . new p,j
               . for j=1,2 set p(j)=+$get(Map(Group,i,"Pos",j))
               . set Result=$extract(s,p(1)+1,p(2)-1)
               quit Result
MapMatch(s,Map,Restrict)
               ;"Purpose to map a string with nested braces, parentheses etc (encapsulators)
               ;"Note: the following markers are honored as paired encapsulators:
               ;"      ( ),  { },  | |,  < >,  # #,  " "
               ;"Input: s -- string to evaluate
               ;"       Map -- PASS BY REFERENCE.  An OUT PARAMETER.  Prior values are killed.  Format:
               ;"           Map(Group,Depth)=OpeningSymbol
               ;"           Map(Group,Depth,"Pos",1)=index of opening symbol
               ;"           Map(Group,Depth,"Pos",2)=index of paired closing symbol
               ;"       Restrict -- OPTIONAL.  A string of allowed opening encapsulators (allows others to be ignored)
               ;"                  e.g. "{(|"  <-- will cause "<>#[]" to be ignored
               ;"E.g.  s="Hello |There{|friend|}|"
               ;"           Map(1,1)="|"
               ;"           Map(1,1,"Pos",1)=7
               ;"           Map(1,1,"Pos",2)=23
               ;"           Map(1,2)="{"
               ;"           Map(1,2,"Pos",1)=13
               ;"           Map(1,2,"Pos",2)=22
               ;"           Map(1,3)="|"
               ;"           Map(1,3,"Pos",1)=14
               ;"           Map(1,3,"Pos",2)=21
               ;"Eg.   s="Hello |There{|friend|}|  This is more (and I (want { to say} !) OK?)"
               ;"           map(1,1)="|"
               ;"           map(1,1,"Pos",1)=7
               ;"           map(1,1,"Pos",2)=23
               ;"           map(1,2)="{"
               ;"           map(1,2,"Pos",1)=13
               ;"           map(1,2,"Pos",2)=22
               ;"           map(1,3)="|"
               ;"           map(1,3,"Pos",1)=14
               ;"           map(1,3,"Pos",2)=21
               ;"           map(2,1)="("
               ;"           map(2,1,"Pos",1)=39
               ;"           map(2,1,"Pos",2)=68
               ;"           map(2,2)="("
               ;"           map(2,2,"Pos",1)=46
               ;"           map(2,2,"Pos",2)=63
               ;"           map(2,3)="{"
               ;"           map(2,3,"Pos",1)=52
               ;"           map(2,3,"Pos",2)=60
               ;"Results: none
               set Restrict=$get(Restrict,"({|<#""")
               new Match,Depth,i,Group
               if Restrict["(" set Match("(")=")"
               if Restrict["{" set Match("{")="}"
               if Restrict["|" set Match("|")="|"
               if Restrict["<" set Match("<")=">"
               if Restrict["#" set Match("#")="#"
               if Restrict["""" set Match("""")=""""
               kill Map
               set Depth=0,Group=1
               for i=1:1:$length(s) do
               . new ch set ch=$extract(s,i)
               . if ch=$get(Map(Group,Depth,"Closer")) do  quit
               . . set Map(Group,Depth,"Pos",2)=i
               . . kill Map(Group,Depth,"Closer")
               . . set Depth=Depth-1
               . . if Depth=0 set Group=Group+1
               . if $data(Match(ch))=0 quit
               . set Depth=Depth+1
               . set Map(Group,Depth)=ch
               . set Map(Group,Depth,"Closer")=Match(ch)
               . set Map(Group,Depth,"Pos",1)=i
               quit
CmdChStrip(s)
               ;"Purpose: Strip all characters < #32 from string.
               new Codes,i,result
               set Codes=""
               for i=1:1:31 set Codes=Codes_$char(i)
               set result=$translate(s,Codes,"")
               quit result
StrBounds(s,p)
               ;"Purpose: given position of start of string, returns index of end of string
               ;"Input: s -- the string to eval
               ;"       p -- the index of the start of the string
               ;"Results : returns the index of the end of the string, or 0 if not found.
               new result set result=0
               for p=p+1:1 quit:(p>$length(s))!(result>0)  do
               . if $extract(s,p)'="""" quit
               . set p=p+1
               . if $extract(s,p)="""" quit
               . set result=p-1
               quit result
NonWhite(s,p)
               ;"Purpose: given starting position, return index of first non-whitespace character
               ;"         Note: either a " " or a TAB [$char(9)] will be considered a whitespace char
               ;"result: returns index if non-whitespace, or index past end of string if none found.
               new result,ch,done
               for result=p:1 quit:(result>$length(s))  do  quit:done
               . set ch=$extract(s,result)
               . set done=(ch'=" ")&(ch'=$char(9))
               quit result
Pad2Pos(Pos,ch)
               ;"Purpose: return a string that can be used to pad from the current $X
               ;"         screen cursor position, up to Pos, using char Ch (optional)
               ;"Input: Pos -- a screen X cursor position, i.e. from 1-80 etc (depending on screen width)
               ;"       ch -- Optional, default is " "
               ;"Result: returns string of padded characters.
               new width set width=+$get(Pos)-$X if width'>0 set width=0
               quit $$LJ^XLFSTR("",width,.ch)
HTML2TXT(Array)
               ;"Purpose: text a WP array that is HTML formatted, and strip <P>, and
               ;"         return in a format of 1 line per array node.
               ;"Input: Array -- PASS BY REFERENCE.  This array will be altered.
               ;"Results: none
               ;"NOTE: This conversion causes some loss of HTML tags, so a round trip
               ;"      conversion back to HTML would fail.
               ;"Called from: TMGTIUOJ.m
               new outArray,outI
               set outI=1
               ;"Clear out confusing non-breaking spaces.
               new spec
               set spec("&nbsp;")=" "
               set spec("&lt;")="<"
               set spec("&gt;")=">"
               set spec("&amp;")="&"
               set spec("&quot;")=""""
               new line set line=0
               for  set line=$order(Array(line)) quit:(line="")  do
               . new lineS set lineS=$get(Array(line,0))
               . set Array(line,0)=$$REPLACE^XLFSTR(lineS,.spec)
               new s2 set s2=""
               new line set line=0
               for  set line=$order(Array(line)) quit:(line="")  do
               . new lineS set lineS=s2_$get(Array(line,0))
               . set s2=""
               . for  do  quit:(lineS'["<")
               . . if (lineS["<P>")&($piece(lineS,"<P>",1)'["<BR>") do  quit
               . . . set outArray(outI,0)=$piece(lineS,"<P>",1)
               . . . set outI=outI+1
               . . . set outArray(outI,0)=""  ;"Add blank line to create paragraph break.
               . . . set outI=outI+1
               . . . set lineS=$piece(lineS,"<P>",2,999)
               . . if (lineS["</P>")&($piece(lineS,"</P>",1)'["<BR>") do  quit
               . . . set outArray(outI,0)=$piece(lineS,"</P>",1)
               . . . set outI=outI+1
               . . . set outArray(outI,0)=""  ;"Add blank line to create paragraph break.
               . . . set outI=outI+1
               . . . set lineS=$piece(lineS,"</P>",2,999)
               . . if (lineS["</LI>")&($piece(lineS,"</LI>",1)'["<BR>") do  quit
               . . . set outArray(outI,0)=$piece(lineS,"</LI>",1)   ;"   _"</LI>"
               . . . set outI=outI+1
               . . . set outArray(outI,0)=""  ;"Add blank line to create paragraph break.
               . . . set outI=outI+1
               . . . set lineS=$piece(lineS,"</LI>",2,999)
               . . if lineS["<BR>" do  quit
               . . . set outArray(outI,0)=$piece(lineS,"<BR>",1)
               . . . set outI=outI+1
               . . . set lineS=$piece(lineS,"<BR>",2,999)
               . . set s2=lineS,lineS=""
               . set s2=s2_lineS
               if s2'="" do
               . set outArray(outI,0)=s2
               . set outI=outI+1
               kill Array
               merge Array=outArray
               quit
TrimTags(lineS)
               ;"Purpose: To cut out HTML tags (e.g. <...>) from lineS, however, <no data> is protected
               ;"Input: lineS : the string to work on.
               ;"Results: the modified string
               ;"Called from: TMGTIUOJ.m
               new result,key,spec
               set spec("<no data>")="[no data]"
               set result=$$REPLACE^XLFSTR(lineS,.spec)
               for  quit:((result'["<")!(result'[">"))  do
               . new partA,partB
               . set partA=$piece(result,"<",1)
               . new temp set temp=$extract(result,$length(partA)+1,999)
               . set partB=$piece(temp,">",2,99)
               . set result=partA_partB
              quit result
IsHTML(IEN8925)
               ;"Purpose: to specify if the text held in the REPORT TEXT field is HTML markup
               ;"Input: IEN8925 -- record number in file 8925
               ;"Results: 1 if HTML markup, 0 otherwise.
               ;"Note: This is not a perfect test.
               ;
               new result set result=0
               new Done set Done=0
               new line set line=0
               for  set line=$order(^TIU(8925,IEN8925,"TEXT",line)) quit:(line="")!Done  do
               . new lineS set lineS=$$UP^XLFSTR($get(^TIU(8925,IEN8925,"TEXT",line,0)))
               . if (lineS["<!DOCTYPE HTML")!(lineS["<HTML>") set Done=1,result=1 quit
               quit result
