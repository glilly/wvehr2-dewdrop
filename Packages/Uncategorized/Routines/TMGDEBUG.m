TMGDEBUG        ;TMG/kst/Debug utilities: logging, record dump ;03/25/06, 7/11/10
                ;;1.0;TMG-LIB;**1**;07/12/05;Build 23
        ;"TMG DEBUG UTILITIES
        ;"Kevin Toppenberg MD
        ;"GNU General Public License (GPL) applies
        ;"7-12-2005
        ;"=======================================================================
        ;" API -- Public Functions.
        ;"=======================================================================
        ;"$$GetDebugMode^TMGDEBUG(DefVal)
        ;"OpenDefLogFile^TMGDEBUG
        ;"OpenLogFile^TMGDEBUG(DefPath,DefName)
        ;"DebugMsg^TMGDEBUG(DBIndent,Msg,A,B,C,D,E,F,G,H,I,J,K,L)
        ;"DebugWrite^TMGDEBUG(DBIndent,s,AddNewline)
        ;"DebugIndent^TMGDEBUG(Num)
        ;"ArrayDump^TMGDEBUG(ArrayP,index,indent)
        ;"ASKANODES
        ;"ArrayNodes(pArray)
        ;"DebugEntry^TMGDEBUG((DBIndent,ProcName)
        ;"DebugExit^TMGDEBUG(DBIndent,ProcName)
        ;"ShowError^TMGDEBUG(PriorErrorFound,Error)
        ;"$$FMERRSTR(ERRARRAY) -- same as $$GetErrStr()
        ;"$$GetErrStr^TMGDEBUG(ErrArray)
        ;"ShowIfDIERR^TMGDEBUG(ErrMsg,PriorErrorFound)  ;really same as below
        ;"ShowDIERR^TMGDEBUG(ErrMsg,PriorErrorFound)
        ;"ExpandLine(Pos)
        ;"ASKDUMP -- A record dumper -- a little different from Fileman Inquire
        ;"DumpRec(FileNum,IEN) -- dump (display) a record, using Fileman functionality.
        ;"DumpRec2(FileNum,IEN,ShowEmpty) -- dump (display) a record, NOT Fileman's Inquire code
        ;"=======================================================================
        ;"Private API functions
        ;"DumpRec2(FileNum,IEN,ShowEmpty)
        ;"WriteRLabel(IEN,Ender)
        ;"WriteFLabel(Label,Field,Type,Ender)
        ;"WriteLine(Line)
        ;"=======================================================================
        ;"DEPENDENCIES
        ;"      TMGUSRIF
        ;"Note: This module accesses custom file 22711, TMG UPLOAD SETTINGS
        ;"      It is OK if this file does not exist (i.e. on other computer systems.)  However, the function
        ;"      OpenDefLogFile will fail to find a default specified file, and would not open a log file.
        ;"      Nothing is PUT INTO this file in this module.  So new global would NOT be created.
        ;"=======================================================================
        ;"=======================================================================
GetDebugMode(DefVal)
               ;"Purpose: to ask if debug output desired
               ;"Input: DefVal [optional] -- Default choice
               ;"result: returns values as below
               ;"        0, cdbNone - no debug
               ;"        1, cdbToScrn - Debug output to screen
               ;"        2, cdbToFile - Debug output to file
               ;"        3, cdbToTail - Debug output to X tail dialog box.
               ;"        Note: 2-2-06 I am adding a mode (-1) which is EXTRA QUIET (used initially in ShowError)
               ;"Note: This does not set up output streams etc, just gets preference.
               new cdbNone set cdbNone=0
               new cdbAbort set cdbAbort=0
               new cdbToScrn set cdbToScrn=1  ;"was 2
               new cdbToFile set cdbToFile=2  ;"was 3
               new cdbToTail set cdbToTail=3  ;"was 4
               new Input
               new result set result=cdbNone ;"the default
               new Default set Default=$get(DefVal,3)
               write !,"Select debug output option:",!
               write "   '^'. Abort",!
               write "    0.  NO debug output",!
               write "    1.  Show debug output on screen",!
               write "    2.  Send debug output to file",!
               if $get(DispMode(cDialog)) do
               . write "    3. Show debug output in X tail dialog box.",!
               write "Enter option number ("_Default_"): "
               read Input,!
               if Input="" do
               . write "Defaulting to: ",Default,!
               . set Input=Default
               if Input="^" set result=cdbAbort
               if Input=0 set result=cdbNone
               if Input=1 set result=cdbToScrn
               if Input=2 set result=cdbToFile
               if Input=3 set result=cdbToTail
GDMDone
               quit result
OpenDefLogFile
               ;"Purpose: To open a default log file for debug output
               ;"Results: none
               new DefPath,DefName
               set DefPath=$piece($get(^TMG(22711,1,2)),"^",1)
               set DefName=$piece($get(^TMG(22711,1,1)),"^",1)
               do OpenLogFile(.DefPath,.DefName)
               quit
OpenLogFile(DefPath,DefName)
               ;"Purpose: To open a log file for debug output
               ;"Input:   DefPath -- the default path, like this: "/tmp/" <-- note trailing '/'
               ;"           DefName -- default file name (without path).  e.g. "LogFile.tmp"
               ;"Results: None
               new DebugFPath set DebugFPath=$get(DefPath,"/tmp/")
               new DebugFName set DebugFName=$get(DefName,"M_DebugLog.tmp")
               if $get(TMGDEBUG)>1 do
               . write "Note: Sending debug output to file: ",DebugFPath,DebugFName,!
               ;"new DebugFile  -- don't NEW here, needs to be global-scope
               set DebugFile=DebugFPath_DebugFName
               new FileSpec set FileSpec(DebugFile)=""
               if +$piece($get(^TMG(22711,1,1)),"^",2)'=1 do
               . ;"kill any pre-existing log
               . new result
               . set result=$$DEL^%ZISH(DebugFPath,$name(FileSpec))  ;"delete any preexisting one.
               open DebugFile
               use $PRINCIPAL
               quit
DebugMsg(DBIndent,Msg,A,B,C,D,E,F,G,H,I,J,K,L)
               ;"PUBLIC FUNCTION
               ;"Purpose: a debugging message output procedure
               ;"Input:DBIndent -- the value of indentation expected
               ;"        Msg -- a string or value to show as message
               ;"        A..L -- extra values to show.
               ;"
               if $get(TMGDEBUG,0)=0 quit
               set cTrue=$get(cTrue,1)
               set DBIndent=$get(DBIndent,0)
               set Msg=$get(Msg)
               set Msg=Msg_$get(A)
               set Msg=Msg_$get(B)
               set Msg=Msg_$get(C)
               set Msg=Msg_$get(D)
               set Msg=Msg_$get(E)
               set Msg=Msg_$get(F)
               set Msg=Msg_$get(G)
               set Msg=Msg_$get(H)
               set Msg=Msg_$get(I)
               set Msg=Msg_$get(J)
               set Msg=Msg_$get(K)
               set Msg=Msg_$get(L)
               do DebugIndent(DBIndent)
               do DebugWrite(DBIndent,.Msg,cTrue)
               quit
DebugWrite(DBIndent,s,AddNewline)
               ;"PUBLIC FUNCTION
               ;"Purpose: to write debug output.  Having the proc separate will allow
               ;"        easier dump to file etc.
               ;"Input:DBIndent, the amount of indentation expected for output.
               ;"        s -- the text to write
               ;"      AddNewline -- boolean, 1 if ! (i.e. newline) should be written after s
               ;"Relevant DEBUG values
               ;"        cdbNone - no debug (0)
               ;"        cdbToScrn - Debug output to screen (1)
               ;"        cdbToFile - Debug output to file (2)
               ;"        cdbToTail - Debug output to X tail dialog box. (3)
               ;"Note: If above values are not defined, then functionality will be ignored.
               set cdbNone=$get(cdbNone,0)
               set cdbToScrn=$get(cdbToScrn,1)
               set cdbToFile=$get(cdbToFile,2)
               set cdbToTail=$get(cdbToTail,3)
               set TMGDEBUG=$get(TMGDEBUG,cdbNone)
               if $get(TMGDEBUG)=cdbNone quit
               if (TMGDEBUG=$get(cdbToFile))!(TMGDEBUG=$get(cdbToTail)) do
               . if $data(DebugFile) use DebugFile
               new ch,chN,l,i
               set l=$length(s)
               for i=1:1:l do
               . set ch=$extract(s,i)
               . set chN=$ascii(ch)
               . if (chN<32)&(chN'=13) write "<",chN,">"
               . else  write ch
               ;"write s
               set cTrue=$get(cTrue,1)
               if $get(AddNewline)=cTrue write !
               if (TMGDEBUG=$get(cdbToFile))!(TMGDEBUG=$get(cdbToTail)) do
               . use $PRINCIPAL
               quit
DebugIndent(DBIndentForced)
               ;"PUBLIC FUNCTION
               ;"Purpose: to provide a unified indentation for debug messages
               ;"Input: DBIndent = number of indentations
               ;"       Forced = 1 if to indent regardless of DEBUG mode
               set Forced=$get(Forced,0)
               if ($get(TMGDEBUG,0)=0)&(Forced=0) quit
               new i
               for i=1:1:DBIndent do
               . if Forced do DebugWrite(DBIndent,"  ")
               . else  do DebugWrite(DBIndent,". ")
               quit
ArrayDump(ArrayP,TMGIDX,indent,flags)
               ;"PUBLIC FUNCTION
               ;"Purpose: to get a custom version of GTM's "zwr" command
               ;"Input: Uses global scope var DBIndent (if defined)
               ;"        ArrayP: NAME of global or variable to display, i.e. "^VA(200)", "MyVar"
               ;"        TMGIDX: initial index (i.e. 5 if wanting to start with ^VA(200,5) -- Optional
               ;"        indent: spacing from left margin to begin with. (A number.  Each count is 2 spaces)
               ;"                OPTIONAL: indent may be an array, with information about columns
               ;"                to skip.  For example:
               ;"                indent=3, indent(2)=0 --> show | for columns 1 & 3, but NOT 2
               ;"        flags: OPTIONAL.  "F"-> flat (don't use tre structure)
               ;"Result: none
               ;"--Leave out, this calls itself recursively! do DebugEntry("ArrayDump")
               ;"--Leave out, this calls itself recursively! do DebugMsg^TMGDEBUG("ArrayP=",ArrayP,", TMGIDX=",index)
               if $data(ArrayP)=0 quit
               if $get(flags)["F" do  goto ADDone
               . new ref set ref=ArrayP
               . new nNums set nNums=$qlength(ref)
               . new lValue set lValue=$qsubscript(ref,nNums)
               . write ref,"=""",$get(@ref),"""",!
               . for  set ref=$query(@ref) quit:(ref="")!($qsubscript(ref,nNums)'=lValue)  do
               . . write ref,"=""",$get(@ref),"""",!
               ;"Note: I need to do some validation to ensure ArrayP doesn't have any null nodes.
               new X set X="SET TEMP=$GET("_ArrayP_")"
               set X=$$UP^XLFSTR(X)
               do ^DIM ;"a method to ensure ArrayP doesn't have an invalid reference.
               if $get(X)="" quit
               set DBIndent=$get(DBIndent,0)
               set cTrue=$get(cTrue,1)
               set cFalse=$get(cFalse,0)
               ;"Force this function to output, even if TMGDEBUG is not defined.
               ;"if $data(TMGDEBUG)=0 new TMGDEBUG  ;"//kt 1-16-06, doesn't seem to be working
               new TMGDEBUG  ;"//kt added 1-16-06
               set TMGDEBUG=1
               new ChildP,TMGi
               set TMGIDX=$get(TMGIDX,"")
               set indent=$get(indent,0)
               new SavIndex set SavIndex=TMGIDX
               do DebugIndent(DBIndent)
               if indent>0 do
               . for TMGi=1:1:indent-1 do
               . . new s set s=""
               . . if $get(indent(TMGi),-1)=0 set s="  "
               . . else  set s="| "
               . . do DebugWrite(DBIndent,s)
               . do DebugWrite(DBIndent,"}~")
               if TMGIDX'="" do
               . if $data(@ArrayP@(TMGIDX))#10=1 do
               . . new s set s=@ArrayP@(TMGIDX)
               . . if s="" set s=""""""
               . . new qt set qt=""
               . . if +TMGIDX'=TMGIDX set qt=""""
               . . do DebugWrite(DBIndent,qt_TMGIDX_qt_" = "_s,cTrue)
               . else  do
               . . do DebugWrite(DBIndent,TMGIDX,1)
               . set ArrayP=$name(@ArrayP@(TMGIDX))
               else  do
               . ;"do DebugWrite(DBIndent,ArrayP_"(*)",cFalse)
               . do DebugWrite(DBIndent,ArrayP,cFalse)
               . if $data(@ArrayP)#10=1 do
               . . do DebugWrite(0,"="_$get(@ArrayP),cFalse)
               . do DebugWrite(0,"",cTrue)
               set TMGIDX=$order(@ArrayP@(""))
               if TMGIDX="" goto ADDone
               set indent=indent+1
               for  do  quit:TMGIDX=""
               . new tTMGIDX set tTMGIDX=$order(@ArrayP@(TMGIDX))
               . if tTMGIDX="" set indent(indent)=0
               . new tIndent merge tIndent=indent
               . do ArrayDump(ArrayP,TMGIDX,.tIndent)  ;"Call self recursively
               . set TMGIDX=$order(@ArrayP@(TMGIDX))
               ;"Put in a blank space at end of subbranch
               do DebugIndent(DBIndent)
               if indent>0 do
               . for TMGi=1:1:indent-1 do
               . . new s set s=""
               . . if $get(indent(TMGi),-1)=0 set s="  "
               . . else  set s="| "
               . . do DebugWrite(DBIndent,s)
               . do DebugWrite(DBIndent," ",1)
ADDone
               ;"--Leave out, this calls itself recursively! do DebugExit("ArrayDump")
               quit
ASKANODES
               ;"Purpose: to ask user for the name of an array, then display nodes
               new name
               write !
               read "Enter name of array to display nodes in: ",name,!
               if name="^" set name=""
               if name'="" do ArrayNodes(name)
               quit
ArrayNodes(pArray)
               ;"Purpose: To display all the nodes of the given array
               ;"Input: pArray -- NAME OF array to display
               new TMGi
               write pArray,!
               set TMGi=$order(@pArray@(""))
               if TMGi'="" for  do  quit:(TMGi="")
               . write " +--(",TMGi,")",!
               . set TMGi=$order(@pArray@(TMGi))
               quit
DebugEntry(DBIndent,ProcName)
               ;"PUBLIC FUNCTION
               ;"Purpose: A way to show when entering a procedure, in debug mode
               ;"Input: DBIndent, a variable to keep track of indentation amount--PASS BY REFERENCE
               ;"        ProcName: any arbitrary name to show when decreasing indent amount.
               set ProcName=$get(ProcName,"?")
               set DBIndent=$get(DBIndent,0)
               do DebugMsg(DBIndent,ProcName_" {")
               set DBIndent=DBIndent+1
               quit
DebugExit(DBIndent,ProcName)
               ;"PUBLIC FUNCTION
               ;"Purpose: A way to show when leaving a procedure, in debug mode
               ;"Input: DBIndent, a variable to keep track of indentation amount--PASS BY REFERENCE
               ;"        ProcName: any arbitrary name to show when decreasing indent amount.
               ;"write "DBIndent=",DBIndent,!
               ;"write "ProcName=",ProcName,!
               set ProcName=$get(ProcName,"?")
               set DBIndent=$get(DBIndent)-1
               if DBIndent<0 set DBIndent=0
               do DebugMsg(DBIndent,"}  //"_ProcName)
               quit
ShowError(PriorErrorFound,Error)
               ;"Purpose: to output an error message
               ;"Input: [OPTIONAL] PriorErrorFound -- var to see if an error already shown.
               ;"                if not passed, then default value used ('no prior error')
               ;"        Error -- a string to display
               ;"results: none
               if $get(TMGDEBUG)=-1 quit  ;"EXTRA QUIET mode --> skip entirely
               if $get(TMGDEBUG)>0 do DebugEntry(.DBIndent,"ShowError")
               if $get(TMGDEBUG)>0 do DebugMsg(.DBIndent,"Error msg=",Error)
               if $get(PriorErrorFound,0) do  goto ShErrQuit  ;"Remove to show cascading errors
               . if $get(TMGDEBUG)>0 do DebugMsg(.DBIndent,"Prior error found, so won't show this error.")
               if $data(DBIndent)=0 new DBIndent  ;"If it wasn't global before, keep it that way.
               new SaveIndent set SaveIndent=$get(DBIndent)
               set DBIndent=1
               do PopupBox^TMGUSRIF("<!> ERROR . . .",Error)
               set PriorErrorFound=1
               set DBIndent=SaveIndent
ShErrQuit
               if $get(TMGDEBUG)>0 do DebugExit(.DBIndent,"ShowError")
               quit
FMERRSTR(ERRARRAY)
               QUIT $$GetErrStr(.ERRARRAY)
               ;
GetErrStr(ErrArray)
               ;"Purpose: convert a standard DIERR array into a string for output
               ;"Input: ErrArray -- PASS BY REFERENCE.  example:
               ;"      array("DIERR")="1^1"
               ;"      array("DIERR",1)=311
               ;"      array("DIERR",1,"PARAM",0)=3
               ;"      array("DIERR",1,"PARAM","FIELD")=.02
               ;"      array("DIERR",1,"PARAM","FILE")=2
               ;"      array("DIERR",1,"PARAM","IENS")="+1,"
               ;"      array("DIERR",1,"TEXT",1)="The new record '+1,' lacks some required identifiers."
               ;"      array("DIERR","E",311,1)=""
               ;"Results: returns one long equivalent string from above array.
               new ErrStr
               new TMGIDX
               new ErrNum
               set ErrStr=""
               for ErrNum=1:1:+$get(ErrArray("DIERR")) do
               . set ErrStr=ErrStr_"Fileman says: '"
               . if ErrNum'=1 set ErrStr=ErrStr_"(Error# "_ErrNum_") "
               . set TMGIDX=$order(ErrArray("DIERR",ErrNum,"TEXT",""))
               . if TMGIDX'="" for  do  quit:(TMGIDX="")
               . . set ErrStr=ErrStr_$get(ErrArray("DIERR",ErrNum,"TEXT",TMGIDX))_" "
               . . set TMGIDX=$order(ErrArray("DIERR",ErrNum,"TEXT",TMGIDX))
               . if $get(ErrArray("DIERR",ErrNum,"PARAM",0))>0 do
               . . set TMGIDX=$order(ErrArray("DIERR",ErrNum,"PARAM",0))
               . . set ErrStr=ErrStr_"Details: "
               . . for  do  quit:(TMGIDX="")
               . . . if TMGIDX="" quit
               . . . set ErrStr=ErrStr_"["_TMGIDX_"]="_$get(ErrArray("DIERR",1,"PARAM",TMGIDX))_"  "
               . . . set TMGIDX=$order(ErrArray("DIERR",ErrNum,"PARAM",TMGIDX))
               quit ErrStr
ShowIfDIERR(ErrMsg,PriorErrorFound)      ;"really same as below
               goto SEL1
ShowDIERR(ErrMsg,PriorErrorFound)
               ;"Purpose: To provide a standard output mechanism for the fileman DIERR message
               ;"Input:   ErrMsg -- PASS BY REFERENCE.  a standard error message array, as
               ;"                   put out by fileman calls
               ;"         PriorErrorFound -- OPTIONAL variable to keep track if prior error found.
               ;"          Note -- can also be used as ErrorFound (i.e. set to 1 if error found)
               ;"Output -- none
               ;"Result -- none
SEL1
               if $get(TMGDEBUG)=-1 quit  ;"EXTRA QUIET mode --> skip entirely
               if $get(TMGDEBUG)>0 do DebugEntry(.DBIndent,"ShowDIERR")
               if $data(ErrMsg("DIERR")) do
               . if $get(TMGDEBUG)>0 do DebugMsg(.DBIndent,"Error message found.  Here is array:")
               . if $get(TMGDEBUG) do ArrayDump("ErrMsg")
               . new ErrStr
               . set ErrStr=$$GetErrStr(.ErrMsg)
               . do ShowError(.PriorErrorFound,.ErrStr)
               if $get(TMGDEBUG)>0 do DebugExit(.DBIndent,"ShowDIERR")
               quit
ExpandLine(Pos)
               ;"Purpose: to expand a line of code, found at position "Pos", using ^XINDX8 functionality
               ;"Input: Pos: a position as returned by $ZPOS (e.g. G+5^DIS, or +23^DIS)
               ;"Output: Writes to the currently selecte IO device and expansion of one line of code
               ;"Note: This is used for taking the very long lines of code, as found in Fileman, and
               ;"      convert them to a format with one command on each line.
               ;"      Note: it appears to do syntax checking and shows ERROR if syntax is not per VA
               ;"      conventions--such as commands must be UPPERCASE  etc.
               ;"--- copied and modified from XINDX8.m ---
               kill ^UTILITY($J)
               new label,offset,RTN,dmod
               do ParsePos^TMGMISC(Pos,.label,.offset,.RTN,.dmod)
               if label'="" do  ;"change position from one relative to label into one relative to top of file
               . new CodeArray
               . set Pos=$$ConvertPos^TMGMISC(Pos,"CodeArray")
               . do ParsePos^TMGMISC(Pos,.label,.offset,.RTN,.dmod)
               if RTN="" goto ELDone
               do BUILD^XINDX7
               set ^UTILITY($J,RTN)=""
               do LOAD^XINDEX
               set CCN=0
               for I=1:1:+^UTILITY($J,1,RTN,0,0) S CCN=CCN+$L(^UTILITY($J,1,RTN,0,I,0))+2
               set ^UTILITY($J,1,RTN,0)=CCN
               ;"do ^XINDX8  -- included below
               new Q,DDOT,LO,PG,LIN,ML,IDT
               new tIOSL set tIOSL=IOSL
               set IOSL=999999  ;"really long 'page length' prevents header printout (and error)
               set Q=""""
               set DDOT=0
               set LO=0
               set PG=+$G(PG)
               set LC=offset
               if $D(^UTILITY($J,1,RTN,0,LC)) do
               . S LIN=^(LC,0),ML=0,IDT=10
               . set LO=LC-1
               . D CD^XINDX8
               K AGR,EOC,IDT,JJ,LO,ML,OLD,SAV,TY
               set IOSL=tIOSL ;"restore saved IOSL
ELDone
               quit
DumpRec(FileNum,IEN)
               ;"Purpose: to dump (display) a record, using Fileman functionality.
               ;"Input: FileNum -- the number of the file to dump from
               ;"       IEN -- the record number to display
               ;"Note: this code is modified from INQ^DII
               new DIC,X,Y,DI,DPP,DK,DICSS
               set X=FileNum,Y=X
               set DI=$get(^DIC(FileNum,0,"GL")) if DI="" quit
               set DPP(1)=FileNum_"^^^@"
               set DK=FileNum
               K ^UTILITY($J),^(U,$J),DIC,DIQ,DISV,DIBT,DICS
               set DIK=1
               set ^UTILITY(U,$J,DIK,IEN)=""   ;"<-- note, to have multiple IEN's shown, iterate via DIK
               do S^DII  ;"Jump into Fileman code.
               quit
xASKDUMP
               ;"Purpose: A record dumper -- a little different from Fileman Inquire
               new DIC,X,Y
               new FileNum,IEN
               new UseDefault set UseDefault=1
               ;"Pick file to dump from
xASK1      set DIC=1
               set DIC(0)="AEQM"
               if UseDefault do   ;"leave the redundant do loop, it protects $T, so second do ^DIC isn't called
               . do ^DICRW  ;" has default value of user's last response
               else  do ^DIC  ;doesn't have default value...
               if +Y'>0 write ! goto xASKDone
               set FileNum=+Y
               ;"Pick record to dump
xASKLOOP        kill DIC,X
               set DIC=+FileNum
               set DIC(0)="AEQM"
               do ^DIC write !
               if +Y'>0 set UseDefault=0 goto xASK1
               set IEN=+Y
               new % set %=2
               write "Display empty fields"
               do YN^DICN
               if %=-1 write ! goto xASKDone
               new %ZIS
               set %ZIS("A")="Enter Output Device: "
               set %ZIS("B")="HOME"
               do ^%ZIS  ;"standard device call
               if POP do  goto xASKDone
               . do ShowError^TMGDEBUG(.PriorErrorFound,"Error opening output.  Aborting.")
               use IO
               ;"Do the output
               write !
               do DumpRec2(FileNum,IEN,(%=1))
               ;" Close the output device
               do ^%ZISC
               new temp
               read "Press [ENTER] to continue...",temp:$get(DTIME,3600),!
               goto xASKLOOP
xASKDone
               quit
ASKDUMP
               ;"Purpose: A record dumper -- a little different from Fileman Inquire
               write !!,"  -= RECORD DUMPER =-",!
               new FIENS,IENS
AL1
               set FIENS=$$AskFIENS^TMGDBAPI()
               if (FIENS["?")!(FIENS="^") goto ASKDone
               set FileNum=$piece(FIENS,"^",1)
               set IENS=$piece(FIENS,"^",2)
AL2
               set IENS=$$AskIENS^TMGDBAPI(FileNum,IENS)
               if (IENS["?")!(IENS="") goto AL1
               new % set %=2
               write "Display empty fields"
               do YN^DICN
               if %=-1 write ! goto ASKDone
               new %ZIS
               set %ZIS("A")="Enter Output Device: "
               set %ZIS("B")="HOME"
               do ^%ZIS  ;"standard device call
               if POP do  goto ASKDone
               . do ShowError^TMGDEBUG(.PriorErrorFound,"Error opening output.  Aborting.")
               use IO
               ;"Do the output
               write ! do DumpRec2(FileNum,IENS,(%=1))
               ;" Close the output device
               do ^%ZISC
               do PressToCont^TMGUSRIF
               ;"new temp
               ;"read "Press [ENTER] to continue...",temp:$get(DTIME,3600),!
               set IENS=$piece(IENS,",",2,99)  ;"force Pick of new record to dump
               if +IENS>0 goto AL2
               goto AL1
ASKDone
               quit
DumpRec2(FileNum,IENS,ShowEmpty,FieldsArray)
               ;"Purpose: to dump (display) a record, NOT using ^DII (Fileman's Inquire code)
               ;"Input: FileNum -- the number of the file to dump from
               ;"       IENS -- the record number to display (or IENS: #,#,#,)
               ;"       ShowEmpty -- OPTIONAL;  if 1 then empty fields will be displayed
               ;"       FieldsArray -- OPTIONAL.  PASS BY REFERENCE.
               ;"          Allows user to specify which fields to show.  Format:
               ;"            FieldsArray(FieldtoShow)="" <-- FieldtoShow is name or number
               ;"            FieldsArray(FieldtoShow)="" <-- FieldtoShow is name or number
               ;"          Default is an empty array, in which all fields are considered
               new Fields
               set Fields("*")=""
               new flags set flags="i"
               if $get(ShowEmpty)=1 set flags=flags_"b"
               write "Record# ",IENS," in FILE: ",FileNum,!
               new field,fieldName
               if $data(FieldsArray)=0 do
               . set field=$order(^DD(FileNum,0))
               . if +field>0 for  do  quit:(+field'>0)
               . . set fieldName=$piece(^DD(FileNum,field,0),"^",1)
               . . set Fields("TAG NAME",field)=fieldName_"("_field_")"
               . . set field=$order(^DD(FileNum,field))
               else  do   ;"Handle case of showing ONLY requested fields
               . new temp set temp=""
               . for  set temp=$order(FieldsArray(temp)) quit:(temp="")  do
               . . if +temp=temp do
               . . . set field=+temp
               . . . set fieldName=$piece(^DD(FileNum,field,0),"^",1)
               . . else  do
               . . . set fieldName=temp
               . . . if $$SetFileFldNums^TMGDBAPI(FileNum,fieldName,,.field)=0 quit
               . . set Fields("TAG NAME",field)=fieldName_"("_field_")"
               . ;"Now exclude those fields not specifically included
               . set field=0
               . for  set field=$order(^DD(FileNum,field)) quit:(+field'>0)  do
               . . if $data(Fields("TAG NAME",field))'=0 quit
               . . set fieldName=$piece(^DD(FileNum,field,0),"^",1)
               . . set Fields("Field Exclude",field)=""
               new RFn,FFn,LFn,WPLFn
               set RFn="WriteRLabel^TMGDEBUG"
               set FFn="WriteFLabel^TMGDEBUG"
               set LFn="WriteLine^TMGDEBUG"
               set WPLFn="WriteWPLine^TMGDEBUG"
               ;"write "Using flags (options): ",flags,!
               if +IENS=IENS do
               . do Write1Rec^TMGXMLE2(FileNum,IENS,.Fields,flags,,,"",RFn,FFn,LFn,WPLFn)
               else  do  ;"dump a subfile record
               . do Write1Rec^TMGXMLE2(FileNum,+IENS,.Fields,flags,,IENS,"",RFn,FFn,LFn,WPLFn)
               quit
WriteRLabel(IEN,Ender)
               ;"Purpose: To actually write out labels for record starting and ending.
               ;"      IEN -- the IEN (record number) of the record
               ;"      Ender -- OPTIONAL if 1, then ends field.
               ;"Results: none.
               ;"Note: Used by DumpRec2 above, with callback from TMGXMLE2
               if +$get(Ender)>0 write !
               else  write "     Multiple Entry #",IEN,"",!
               quit
WriteFLabel(Label,Field,Type,Ender)
               ;"Purpose: This is the code that actually does writing of labels etc for output
               ;"      This is a CUSTOM CALL BACK function called by Write1Fld^TMGXMLE2
               ;"Input: Label -- OPTIONAL -- Name of label, to write after  'label='
               ;"       Field -- OPTIONAL -- Name of field, to write after  'id='
               ;"       Type -- OPTIONAL -- Typeof field, to write after  'type='
               ;"      Ender -- OPTIONAL if 1, then ends field.
               ;"Results: none.
               ;"Note: Used by DumpRec2 above, with callback from TMGXMLE2
               ;"To write out <Field label="NAME" id=".01" type="FREE TEXT"> or </Field>
               if +$get(Ender)>0 do
               . write !
               else  do
               . new s set s=Field
               . if $get(Field)'="" write $$RJ^XLFSTR(.s,6," "),"-"
               . if $get(Label)'="" write Label," "
               . ;"if $get(Type)'="" write "type=""",Type,""" "
               . write ": "
                quit
WriteLine(Line)
               ;"Purpose: To actually write out labels for record starting and ending.
               ;"Input: Line -- The line of text to be written out.
               ;"Results: none.
               ;"Note: Used by DumpRec2 above, with callback from TMGXMLE2
               write line
               quit
WriteWPLine(Line)
               ;"Purpose: To actually write out line from WP field
               ;"Input: Line -- The line of text to be written out.
               ;"Results: none.
               ;"Note: Used by DumpRec2 above, with callback from TMGXMLE2
               write line,!
               quit
