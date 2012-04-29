ARJTDDKR ;WV/TOAD-FileMan Search All Routines ;5/24/2004  19:08
 ;;22.0;VA FileMan;;Mar 30, 1999;
 ;
 ; Change History:
 ;
 ; 2004 05 24  modified to handle GT.M as well as DSM
 ;
 ; table of contents:
 ;    ALL - search all routines in current environment
 ;    RSE - search selected routines
 ;    FEEDBACK - give routine search feedback
 ;    SEARCH - search 1 routine
 ;    CONTAINS - function: does code contain what we're looking for
 ;    CODEROU - cross-reference results by code then routine
 ;    RESULTS - report results of search
 ;    ADDLINE - add a line to the Line WP field (2)
 ;
 ; input:
 ;   .CONTAINS(string)="" to search any line containing the string
 ;    FIND = optional. special search, e.g., "DSM"
 ;
 ; output:
 ;    .EXIT = returns 1 if interrupted.
 ;    report to current device
 ;
 ;
ALL(CONTAINS,FIND,EXIT) ; public subroutine: search all routines
 ;
 ; input: DSM-specific ^ () global (name = space)
 ; called by ALL^ARJTDDK -- master search option
 ; calls:
 ;    FEEDBACK - give routine search feedback
 ;    SEARCH - search each routine
 ;    RESULTS^ARJTDDKU - report results of search
 ;
 W !!,"Searching all routines"
 K ^XTMP("DSMROUTINES")
 S ^XTMP("DSMROUTINES",0)=$$FMADD^XLFDT($$DT^XLFDT(),90)_U_$$DT^XLFDT()
 ;
 S EXIT=0 ; not interrupted so far
 N PRE S PRE="" ; trace shifting prefixes
 N COUNT ; number of routines searched
 N FOUND S FOUND=0 ; number of matching routines found
 N ROU S ROU="" ; name of each routine
 F COUNT=0:1 D  Q:ROU=""!EXIT
 . S ROU=$O(^ (ROU)) Q:ROU=""  ; DSM stores rtn direc. in ^[space].
 . I COUNT,'(COUNT#100) D FEEDBACK(COUNT,ROU,.PRE,.EXIT) Q:EXIT
 . D SEARCH($P(ROU,"."),.CONTAINS,FIND,.FOUND)
 D RESULTS^ARJTDDKU(EXIT,COUNT,FOUND,"Search","routine")
 Q:EXIT
 D COMPILE^ARJTDDKS(1)
 ;
 QUIT  ; end of ALL
 ;
 ;
RSE(CONTAINS,FIND,EXIT) ; public subroutine: search selected routines
 ;
 ; calls:
 ;    ^%RSEL - select routines to search
 ;    FEEDBACK - give routine search feedback
 ;    SEARCH - search each routine
 ;    RESULTS - report results of search
 ; note: since DSM's ^%RSEL returns its list in the local %UTILITY
 ; variable, a large symbol table size is needed to hold large lists.
 ;
 N %UTILITY D ^%RSEL Q:$O(%UTILITY(""))=""
 W !!,"Searching selected routines"
 K ^XTMP("DSMROUTINES")
 S ^XTMP("DSMROUTINES",0)=$$FMADD^XLFDT($$DT^XLFDT(),90)_U_$$DT^XLFDT()
 ;
 S EXIT=0 ; not interrupted so far
 N PRE S PRE="" ; trace shifting prefixes
 N COUNT ; number of routines searched
 N FOUND S FOUND=0 ; number of matching routines found
 N ROU S ROU="" ; name of each routine
 F COUNT=0:1 D  Q:ROU=""!EXIT
 . S ROU=$O(%UTILITY(ROU)) Q:ROU=""
 . I COUNT,'(COUNT#100) D FEEDBACK(COUNT,ROU,.PRE,.EXIT) Q:EXIT
 . D SEARCH($P(ROU,"."),.CONTAINS,FIND,.FOUND)
 D RESULTS^ARJTDDKU(EXIT,COUNT,FOUND,"Search","routine")
 Q:EXIT
 D COMPILE^ARJTDDKS()
 ;
 QUIT  ; end of ALL
 ;
 ;
FEEDBACK(COUNT,ROU,PRE,EXIT) ; subroutine: give routine search feedback
 ;
 ; input:
 ;    COUNT = # searched so far
 ;    ROU = name of next routine to search
 ; in/output: .PRE = 1st 2 letters of previous routine searched
 ; called by: ALL, RSE
 ;
 S EXIT=0 ; not interrupted yet
 N READ ; results of quick read command
 W "." ; dots
 I '(COUNT#1000) W !,$FN(COUNT,",")," routines searched so far" ; counts
 I $E(ROU,1,2)'=PRE S PRE=$E(ROU,1,2) W " ",PRE,"*" ; changing prefixes
 R READ:0 S EXIT=READ=U ; quick reads to allow ^-escape
 ;
 QUIT  ; end of FEEDBACK
 ;
 ;
SEARCH(RTN,CONTAINS,FIND,FINDCNT) ; subroutine: search 1 routine
 ;
 ; input: RTN = name of routine to search
 ; in/output: .FINDCNT = optional. increments # of instances found
 ; called by: ALL, RSE
 ; calls:
 ;    $$CONTAINS - test each line: does it contain what we're looking for
 ;    CHECK^ARJTDIM - search each line of code
 ;
 ; S.1. Traverse The Routine Lines
 ;
 Q:RTN=""  ; need a routine name
 N SKIP S SKIP=0 D  Q:SKIP  ; we skip routine if doesn't exist or too big
 . ; if error, will probably be because too large, report & skip
 . N $ET S $ET="S SKIP=1 W !?5,RTN,"" TOO LARGE!"",! S ($EC,$ZE)="""""
 . S SKIP=$T(^@RTN)="" ; make sure 1st line exists
 N FOUND S FOUND=0 ; flag success or failure for routine
 N FIRST S FIRST=1 ; only report routine name on 1st hit
 N FOUNDR S FOUNDR=0 ; any found within routine?
 N RIEN ; the IEN of routine's entry in Cache Routine file (663075)
 N LIEN ; the last line # in the Line WP field (2)
 N NUM ; # lines
 N LINE ; each line of code
 N CODE ; the code part of each line
 F NUM=1:1 S LINE=$T(+NUM^@RTN) Q:LINE=""  I $$CONTAINS(LINE,.CONTAINS) D
 . ;
 . ; S.2. Parse each simply matching line using ARJTDIM
 . ;
 . I $G(MAH) W !!,"+",NUM,"  ",LINE
 . S CODE=$P(LINE," ",2,99999) ; ARJTDIM doesn't deal with labels
 . F  Q:CODE=""  Q:" ."'[$E(CODE)  S $E(CODE)="" ; or spaces and periods
 . Q:CODE=""  ; skip line if nothing but labels, periods, and spaces
 . D CHECK^ARJTDIM(CODE,FIND,.FOUND) ; parse line
 . Q:'FOUND  ; skip lines that don't match
 . S FOUNDR=1,FOUND=0
 . ;
 . ; S.3. Count routine once if one of its lines completely matches
 . ;
 . I FIRST D  ; when routine first gets a hit
 . . W !?5,RTN ; make its name stand out
 . . I $X>6 W ! ; try to keep first match line on same line with name
 . . S RIEN=$O(^DIZ(663075,"B",RTN,0))
 . . I '$D(^DIZ(663075,+RIEN,0)) D  ; create a new entry if missing
 . . . N RNODE S RNODE=$G(^DIZ(663075,0)) ; file header
 . . . S RIEN=$P(RNODE,U,3) ; most recent IEN assigned
 . . . F  S RIEN=RIEN+1 Q:'$D(^DIZ(663075,RIEN))  ; find free IEN
 . . . S $P(RNODE,U,3,4)=RIEN_U_($P(RNODE,U,4)+1) ; update recent & count
 . . . S ^DIZ(663075,0)=RNODE ; update header
 . . . S ^DIZ(663075,RIEN,0)=RTN ; new entry's Routine Name field (.01)
 . . . S ^DIZ(663075,"B",RTN,RIEN)="" ; cross-reference new entry
 . . S LIEN=$O(^DIZ(663075,RIEN,1," "),-1) ; find last line in WP
 . . I LIEN>0 D ADDLINE(RIEN,.LIEN," ")
 . . D ADDLINE(RIEN,.LIEN,$$HTE^XLFDT($H))
 . S FIRST=0 ; no longer 1st hit
 . S FINDCNT=$G(FINDCNT)+1 ; one more routine found
 . ;
 . ; S.4. Report each completely matching line
 . ;
 . W FINDCNT,"." ; for ease of using the report, # each match found
 . W ?7 ; indent for clarity
 . N LINEID ; how shall we ID the line?
 . I $E(LINE)'=" " S LINEID=$P(LINE," ") ; as label, if any
 . E  S LINEID="+"_NUM ; otherwise as absolute offset
 . S LINEID=LINEID_$J(" ",9-$L(LINEID)) ; ID then "tab" to col 16
 . W LINEID ; display line ID to screen
 . S LINE=$P(LINE," ",2,9999) ; remove label and ls
 . N LINCHUNK ; each chunk of line to show
 . F  Q:'$L(LINE)  D  ; repeat until we're out of code
 . . S LINCHUNK=$E(LINE,1,64)
 . . W ?16,LINCHUNK,! ; write to screen what will fit
 . . D ADDLINE(RIEN,.LIEN,LINEID_LINCHUNK) ; set ID + line chunk
 . . S LINEID="         " ; just "tab" for remaining chunks
 . . S $E(LINE,1,64)="" ; clear written code
 I FOUNDR D
 . W ! ; line feed to end list of matching lines for routine
 . Q:FIND'="DSM"  ; rest of block for John Harvey
 . M ^XTMP("DSMROUTINES","ROU CODE",RTN)=FOUND("DSM")
 . D CODEROU(RTN,.FOUND)
 ;
 QUIT  ; end of SEARCH
 ;
 ;
CONTAINS(CODE,CONTAINS) ; function: does code contain what we're looking for
 ;
 ; input: CODE = line of code
 ; output: true if line contains any of CONTAINS
 ; called by: SEARCH
 ;
 N DOES I $D(CONTAINS)#2 S DOES=CODE[CONTAINS Q DOES
 I $D(CONTAINS)>9 D  Q DOES
 . N SUB S SUB=""
 . F  S SUB=$O(CONTAINS(SUB)) Q:SUB=""  S DOES=CODE[SUB Q:DOES
 QUIT 0 ; end of CONTAINS
 ;
 ;
CODEROU(ROU,FOUND) ; subroutine: cross-reference results by code then routine
 N NUM
 N SUB S SUB="DSMROUTINES"
 N CODE S CODE="" F  D  Q:CODE=""
 . S CODE=$O(FOUND("DSM",CODE)) Q:CODE=""
 . S NUM=$G(^XTMP(SUB,"CODE ROU",CODE,ROU))+FOUND("DSM",CODE)
 . S ^XTMP(SUB,"CODE ROU",CODE,ROU)=NUM
 . ;
 . S NUM=$G(^XTMP(SUB,"CODE ROU",CODE,0))+FOUND("DSM",CODE)
 . S ^XTMP(SUB,"CODE ROU",CODE,0)=NUM
 Q
 ;
 ;
RESULTS(EXIT,COUNT,FOUND) ; subroutine: report results of search
 ;
 ; input:
 ;    COUNT = # of routines searched
 ;    FOUND = # of instances found
 ; called by: ALL, RSE
 ;
 W !
 I EXIT W !,"Search interrupted."
 W !,COUNT," routine",$E("s",COUNT'=1)," searched."
 W !,FOUND," instance",$E("s",FOUND'=1)," found."
 QUIT  ; end of RESULTS
 ;
 ;
ADDLINE(RIEN,LIEN,LINE) ; add a line to the Line WP field (2)
 ;
 ; Input:
 ;    LIEN = last line # in WP field
 ;    LINE = the line of text to append
 ;
 S LIEN=LIEN+1
 S ^DIZ(663075,RIEN,1,LIEN,0)=LINE
 QUIT  ; end of ADDLINE
 ;
