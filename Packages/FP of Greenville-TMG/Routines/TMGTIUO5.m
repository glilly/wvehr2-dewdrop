TMGTIUO5        ;TMG/kst-Text objects for use in CPRS ; 7/20/12
                ;;1.0;TMG-LIB;**1,17**;7/20/12;Build 23
        ;
        ;"Kevin Toppenberg MD
        ;"(C) 10/2010
        ;"Released under: GNU General Public License (GPL)
        ;
        ;" This is spill over code from TMGTIUOJ, to make that file size smaller.
        ;"       
        ;"=======================================================================
        ;"PUBLIC FUNCTIONS
        ;"=======================================================================
        ;
        ;"=======================================================================
        ;"PRIVATE FUNCTIONS
        ;"=======================================================================
        ;"GNOTELST(DFN,LIST,INCDAYS) --Return a list of notes for patient in given time span
        ;"XTRCTSPC(IEN8925,STARTMARKERS,ENDMARKERS,ARRAY,SPACES) -- scan the REPORT TEXT field in given document and return ...
        ;"MERGEIN(PARTARRAY,MASTERARRAY) --combine PARTARRAY into MasterARRAY.
        ;"=======================================================================
        ;"Dependancies : %DTC TMGTHM1 XLFSTR
        ;"=======================================================================
GNOTELST(DFN,LIST,INCDAYS)      ;"GET NOTE LIST
               ;"Purpose: Return a list of notes for patient in given time span
               ;"Input: DFN -- IEN in PATIENT file (the patient record number)
               ;"       LIST -- PASS BY REFERENCE, an OUT PARAMETER. (Format below)
               ;"       INCDAYS -- Number of DAYS to search in.
               ;"              E.g. 4 --> get notes from last 4 days
               ;"Output: LIST format:
               ;"              LIST(FMTimeOfNote,IEN8925)=""
               ;"              LIST(FMTimeOfNote,IEN8925)=""
               ;"              LIST(FMTimeOfNote,IEN8925)=""
               ;"        If no notes found, then array is left blank.  Prior entries KILLED
               ;"Results: none
               ;
               KILL LIST
               SET DFN=+$GET(DFN)
               IF DFN'>0 GOTO GNLDONE
               SET INCDAYS=+$GET(INCDAYS)
               NEW TEMP
               MERGE TEMP=^TIU(8925,"C",DFN)
               SET IEN=""
               FOR  SET IEN=$ORDER(TEMP(IEN)) QUIT:(IEN="")  DO
               . NEW X,X1,X2,%Y,STARTDATE
               . DO NOW^%DTC SET X1=X
               . SET STARTDATE=$PIECE($GET(^TIU(8925,IEN,0)),"^",7)
               . SET X2=STARTDATE
               . DO ^%DTC ;"calculate X=X1-X2.  Returns #days between
               . IF X>INCDAYS QUIT
               . SET LIST(STARTDATE,IEN)=""
               ;
GNLDONE QUIT
               ;
               ;
XTRCTSPC(IEN8925,STARTMARKERS,ENDMARKERS,ARRAY,SPACES)  ;"EXTRACT SPECIAL
               ;"Purpose: To scan the REPORT TEXT field in given document and return
               ;"         paragraph of text that is started by STARTMARKERS, and ended by ENDMARKERS.
               ;"         I.E. Search for a line that contains MARKERS.  Return that line and
               ;"         all following lines until line found with ENDMARKERS, or
               ;"         end of text.
               ;"Input: IEN8925 -- IEN in file 8925 (TIU DOCUMENT)
               ;"       STARTMARKERS -- the string to search for that indicates start of block
               ;"       ENDMARKERS -- the string to search for that indicates the end of block.
               ;"              NOTE: if ENDMARKERS="BLANK_LINE", then search is
               ;"              ended when a blank line is encountered.
               ;"       ARRAY -- PASS BY REFERENCE, an OUT PARAMETER.  Prior values killed.
               ;"              Format:  ARRAY(0)=MaxLineCount
               ;"                       ARRAY(1)="Text line 1"
               ;"                       ARRAY(2)="Text line 2" ...
               ;"       SPACES -- OPTIONAL.  Pass by reference. AN OUT PARAMETER.
               ;"                      Fill with the space length that found tables are indented with.
               ;"Result: 1 if data found, otherwise 0
               ;
               NEW RESULT SET RESULT=0
               NEW ISHTML
               KILL ARRAY
               SET SPACES=""
               SET IEN8925=+$GET(IEN8925)
               IF IEN8925'>0 GOTO ESDONE
               IF $DATA(^TIU(8925,IEN8925,"TEXT"))'>0 GOTO ESDONE
               IF $GET(STARTMARKERS)="" GOTO ESDONE
               IF $GET(ENDMARKERS)="" GOTO ESDONE
               NEW REF SET REF=$NAME(^TIU(8925,IEN8925,"TEXT"))
               NEW TEMPARRAY
               NEW ISHTML SET ISHTML=$$ISHTML^TMGHTM1(IEN8925)
               IF ISHTML DO
               . MERGE TEMPARRAY=^TIU(8925,IEN8925,"TEXT")
               . DO HTML2TXT^TMGHTM1(.TEMPARRAY)
               . SET REF="TEMPARRAY"
               NEW LINE,I,BLOCKFOUND,DONE
               SET LINE=0,I=0,BLOCKFOUND=0,DONE=0
               FOR  SET LINE=$ORDER(@REF@(LINE)) QUIT:(LINE="")!DONE  DO
               . NEW LINES SET LINES=$GET(@REF@(LINE,0))
               . IF (BLOCKFOUND=0) DO  QUIT  ;"don't include header line with output
               . . IF LINES[STARTMARKERS DO
               . . . SET BLOCKFOUND=1
               . . . FOR  QUIT:$EXTRACT(LINES,1)'=" "  DO
               . . . . SET SPACES=SPACES_" "
               . . . . SET LINES=$EXTRACT(LINES,2,$LENGTH(LINES))
               . IF (BLOCKFOUND=1) DO
               . . SET I=I+1,ARRAY(0)=I
               . . NEW S2 SET S2=$$TRIM^XLFSTR(LINES)
               . . SET S2=$$TRIM^XLFSTR(S2,"LR",$CHAR(9))
               . . SET ARRAY(I)=LINES
               . . IF S2="" SET ARRAY(I)=S2
               . . SET RESULT=1
               . . IF (ENDMARKERS="BLANK_LINE")&(S2="") SET BLOCKFOUND=0,DONE=1 QUIT
               . . IF LINES[ENDMARKERS SET BLOCKFOUND=0,DONE=1 QUIT  ;"include line with END marker
               IF 'ISHTML SET SPACES=$CHAR(9)
               ;
ESDONE   QUIT RESULT
               ;
               ;
               ; 
MERGEIN(PARTARRAY,MASTERARRAY)  ;"MERGE INTO
               ;"Purpose: to combine PARTARRAY into MasterARRAY.
               ;"Input: PARTARRAY -- PASS BY REFERENCE
               ;"       MASTERARRAY -- PASS BY REFERENCE
               ;"Note:  Arrays are combine in a 'transparent' manner such that newer entries
               ;"       will overwrite older entries only for identical values.  For example:
               ;"                  -- BLOCK --   <--- MasterArray
               ;"                      TSH = 1.56
               ;"                      LDL = 140
               ;"                  -- END BLOCK --
               ;"
               ;"                  -- BLOCK --   <--- PARTArray
               ;"                      LDL = 150
               ;"                  -- END BLOCK --
               ;"
               ;"             The above two blocks will result in this final array
               ;"                  -- BLOCK --
               ;"                      TSH = 1.56
               ;"                      LDL = 150   <--- this value overwrote older entry
               ;"                  -- END BLOCK --
               ;"
               ;"              In this mode, only data that is in a LABEL <--> VALUE format
               ;"                 will be checked for newer vs older entries.  All other
               ;"                 lines will simply be included in one large summation block.
               ;"              And the allowed format for LABEL <--> VALUE will be:
               ;"                      Label = value      or
               ;"                      Label : value
               ;"
               ;"Output: MasterARRAY will be filled as follows:
               ;"       ARRAY(Seq#)="text line"
               ;"       ARRAY(Seq#)="text line"
               ;"       //kt old --> ARRAY("text line")=""
               ;"       ARRAY("KEY-VALUE",KEYName)=VALUE
               ;"       ARRAY("KEY-VALUE",KEYName,"LINE")=original line
               ;
               NEW SORTARRAY
               NEW LINENUM SET LINENUM=0
               ;"NOTE: I think PARTARRAY AND TEMPARRAY are supposed to be the same thing
               ;"FIX!!!
               FOR  SET LINENUM=$ORDER(TEMPARRAY(LINENUM)) QUIT:(+LINENUM'>0)  DO
               . NEW LINE SET LINE=$GET(TEMPARRAY(LINENUM))
               . IF (LINE["=")!(LINE[":") DO
               . . NEW KEY,SHORTKEY,VALUE,PIVOT
               . . IF LINE["=" SET PIVOT="="
               . . ELSE  SET PIVOT=":"
               . . SET KEY=$PIECE(LINE,PIVOT,1)
               . . SET SHORTKEY=$$UP^XLFSTR($$TRIM^XLFSTR(KEY))
               . . SET VALUE=$PIECE(LINE,PIVOT,2,999)
               . . SET VALUE=$$TRIM^XLFSTR(VALUE) ;"//kt 7/14/12
               . . SET ARRAY("KEY-VALUE",SHORTKEY)=VALUE
               . . SET ARRAY("KEY-VALUE",SHORTKEY,"LINE")=LINE
               . ELSE  DO
               . . IF LINE="" QUIT
               . . SET LINE=$$TRIM^XLFSTR(LINE)  ;"//kt 7/14/12
               . . SET SORTARRAY($$UP^XLFSTR(LINE))=LINE ;"//kt 7/14/12
               . . ;"SET ARRAY(LINE)=""
               NEW ONELINE SET ONELINE=""
               NEW I SET I=1
               FOR  SET ONELINE=$ORDER(SORTARRAY(ONELINE)) Q:ONELINE=""  DO
               . NEW LINE SET LINE=$GET(SORTARRAY(ONELINE))
               . SET ARRAY(I)=LINE
               . SET I=I+1
               ;
               QUIT
               ;
               ;
