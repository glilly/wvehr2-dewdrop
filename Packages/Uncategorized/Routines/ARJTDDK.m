ARJTDDK ;WV/TOAD-FileMan Search All Code ;5/26/2004  20:01
 ;;3.0T1;OPENVISTA;;Jun 20, 2004;Build 1
 ;
 ; Change History:
 ;
 ; 2004 05 24  WV/TOAD: change TEST to handle GT.M as well as DSM
 ; 2003 05 26  WV/TOAD: replace ALL^ARJTDDKR with ALL^ARJTDDKA
 ;
 ; Table of Contents:
 ;    ALL = search all code for something
 ;    PM = search for alternation in pattern match
 ;    DSM = search for DSM-specific code
 ;
 ; Not yet done:
 ;    1. "free text" MUMPS fields --> DONE
 ;    2. template lines
 ;    3. new-style indexes
 ;    4. constructed indirect code
 ;    5. look for other computed/MUMPS hooks
 ;    6. extended cross-reference logic (e.g., trigger logic)
 ;
 ;
ALL(CONTAINS,FIND) ; search all code
 ;
 ; input:
 ;   .CONTAINS(string)="" to search any line containing the string
 ;    FIND = optional. special search, e.g., "DSM"
 ;
 ; output:
 ;    report to current device
 ;
 ; Calls:
 ;    ALL^ARJTDDKA - to search all routines
 ;    MUMPS^ARJTDDKM - to search all MUMPS fields
 ;    TEXT^ARJTDDK5 - search all "free-text" MUMPS fields
 ;    SEARCHDD^ARJTDDK4 - to search the entire DD
 ;
 W !!,"Lowering priority for duration of search.",!
 N ARJTPRI,Y X ^%ZOSF("PRIINQ") S ARJTPRI=Y
 N X S X=7 X ^%ZOSF("PRIORITY")
 N $ET S $ET="D TRAP^ARJTDDK"
 N EXIT S EXIT=0 ; not intrrupted yet
 D
 . W !!!,"1. SEARCH ALL ROUTINES"
 . D ALL^ARJTDDKA(.CONTAINS,FIND,.EXIT)
 I 'EXIT D
 . W !!!,"2. SEARCH ALL MUMPS FIELDS"
 . D MUMPS^ARJTDDKM(.CONTAINS,FIND,.EXIT)
 I 'EXIT D
 . W !!!,"3. SEARCH ALL ""FREE TEXT"" MUMPS FIELDS"
 . D TEXT^ARJTDDK5(.CONTAINS,FIND,.EXIT)
 I 'EXIT D
 . W !!!,"4. SEARCH ALL DATA DICTIONARIES"
 . D SEARCHDD^ARJTDDK4(.CONTAINS,FIND,.EXIT)
 W !!!
 I EXIT W "INTERRUPTED."
 E  W "DONE."
 S X=ARJTPRI X ^%ZOSF("PRIORITY")
 W !!,"Priority restored."
 ;
 QUIT  ; end of ALL
 ;
 ;
PM ; search all code for alternation in pattern match
 D ALL("?","?(")
 Q  ; end of PM
 ;
 ;
DSM ; search all code for DSM-specific code
 S U="^"
 N CONTAINS
 S CONTAINS("Z")=""
 S CONTAINS("&")=""
 S CONTAINS("^%")=""
 S CONTAINS("(%")=""
 S CONTAINS("U ")=""
 S CONTAINS("U:")=""
 S CONTAINS("O ")=""
 S CONTAINS("O:")=""
 S CONTAINS("C ")=""
 S CONTAINS("C:")=""
 ;
 D ALL(.CONTAINS,"DSM")
 Q  ; end of PM
 ;
 ;
TEST ; test ARJTDIM's ability to find $ZC
 N ZZDCOM
 N CODE S CODE="S Y=$ZC(%ARCCOS) S Z=$ZDATE(X) D ^%SPAWN D &ZLIB.%ZWRITE(0) S W=$&ZLIB.%SPAWN(42)"
 D CHECK^ARJTDIM(CODE,"DSM",.ZZDCOM)
 ZWRITE ZZDCOM
 Q
 ;
 ;
TRAP W !!,"$ZE = ",$ZE
 W !,"$EC = ",$EC
 S $EC=""
 N ARJTX F  D  Q:ARJTX="Q"!(ARJTX="^")!(ARJTX="")
 . R !,"TRAP>",ARJTX:DTIME W !
 . Q:ARJTX="Q"!(ARJTX="^")!(ARJTX="")
 . X ARJTX
 Q
 ;
