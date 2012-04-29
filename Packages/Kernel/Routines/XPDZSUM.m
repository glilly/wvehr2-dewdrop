XPDZSUM ;WV/TOAD-KIDS check Before checksums ;12/01/2005  10:40
 ;;8.0;KERNEL;**L34**;Jul 10,1995
 ;
 ; This routine is the prototype for a new KIDS option that compares the
 ; checksums for routines being brought in by a patch to those currently
 ; installed on the system.  It parses the patch description, extracts
 ; the checksums from the table and records them in the Checksum subfile
 ; of the Patch Record file (437016).  It then uses ^%ZOSF("RSUM") to
 ; compare the before values and warn of any potential collisions.  It
 ; also records the patch list for each routine and records that, too, in
 ; the Checksum subfile, and compares it to the current routine's
 ; patch list.
 ;
 ; history
 ;
 ; 2005 11 29  Rick Marshall wrote outline, then shifted to routine
 ;             XPDZHFS to explore the algorithm
 ; 2005 11 30  Rick Marshall complete algorithm exploration, copied
 ;             relevant code back to this routine, then worked on the
 ;             checksum and patch list extract and compare
 ; 2005 12 01  Rick Marshall continues refining the extract & compare
 ;
 ; contents
 ;
 ; 1. prompt for KIDS text file
 ; 2. load description into ^TMP($J)
 ; 3. find routine table
 ; 4. extract checksums and patch list
 ; ; 5. file them in the Checksum subfile
 ; ; 6. clear ^TMP($J)
 ; 5. compare to current routines
 ;
 ; XPDZSUM contents
 ;
 ; FINDSUMS. find checksums & patch lists in a KIDS description file
 ; DRIVEFS. test FINDSUMS
 ; ISHEAD.  return whether a line is a routine table header line
 ; DRIVEIH. test ISHEAD
 ; COLUMNS. extract column values from floating multi-space delimiters
 ; DRIVEC. test COLUMNS
 ;
 ;
FINDSUMS(PATH,FILE) ; find checksums & patch lists in a KIDS description file
 ; PATH_FILE = KIDS description file, input to $$FTG^%ZISH in F1
 ;
 ; called by DRIVEFS (tester), DIRSUMS^XPDZHFS
 ; calls $$FTG^%ZISH, $$UP^XLFSTR, ANALYZE, $$COLUMNS
 ;
 ; FINDSUMS contents
 ;
 ; F1. transfer KIDS description file to ^TMP
 ; F2. traverse description
 ; F3. find routine table in description
 ; F4. find end of routine table
 ; F5. extract and display columns from the row
 ; F6. compare before checksum & patch list to current routine
 ;
 ; F1. transfer KIDS description file to ^TMP
 ;
 K ^TMP("XPDZHFS",$J)
 D
 . N ROOT S ROOT=$NA(^TMP("XPDZHFS",$J,1,0))
 . N SUB S SUB=3
 . N SUCCESS S SUCCESS=$$FTG^%ZISH(PATH,FILE,ROOT,SUB)
 . ; Device Handler: transfer a file to a global
 ;
 ; F2. traverse description
 ;
 N TABLE S TABLE=0 ; whether line is part of routine table
 N ROUTINES ; to routine lines in table
 N TYPE S TYPE=0 ; what type of routine table is this? (see ANALYZE)
 N NUM S NUM=0 F  D  Q:'NUM
 . S NUM=$O(^TMP("XPDZHFS",$J,NUM)) Q:'NUM
 . ; W !,NUM,?5
 . N LINE S LINE=$G(^TMP("XPDZHFS",$J,NUM,0))
 . N UP S UP=$$UP^XLFSTR(LINE) ; Kernel: XLF library: upper case
 . ;
 . ; F3. find routine table in description
 . ;
 . I 'TABLE D  Q:'TABLE  ; find routine table header line
 . . N ISHEAD ; whether it is a table header line
 . . D ANALYZE(LINE,.ISHEAD,.TYPE) ; analyse the line
 . . Q:'ISHEAD  ; skip each line until we find the table
 . . S TABLE=1 ; we have entered the routine table
 . . S ROUTINES=-1 ; we have not yet seen the first routine lines
 . I $TR(UP," -_=")'="" S ROUTINES=ROUTINES+1 ; count non-null table lines
 . ; header line does not count (moves from -1 to 0)
 . Q:'ROUTINES  ; the rest of the loop only applies to routine lines
 . ;
 . ; F4. find end of routine table
 . ;
 . S TABLE=0 D  Q:'TABLE  ; assume it's the end, pass screens to continue
 . . ; after first non-null routine line, next blank line is end:
 . . Q:$TR(UP," -_=")=""  ; I am concerned about whether this is too tight
 . . Q:UP["LIST OF PRECEDING PATCHES"
 . . Q:UP["NO ROUTINE"
 . . Q:UP["CHECK^XTSUMBLD"
 . . Q:UP["NOTE: "!(UP["NOTE ")
 . . Q:UP["INSTALLATION"
 . . S TABLE=1
 . ;
 . ; F5. extract and display columns from the row
 . ;
 . N COLUMNS S COLUMNS=$$COLUMNS(LINE) ; extract the columns
 . ;
 . N R S R=$P(COLUMNS,U) ; all four types start with routine
 . W !?3,R ; routine
 . ;
 . N B,A,P S (B,P)="" ; order varies on the other 3 fields
 . ;
 . I TYPE>2 D  ; for types 3 and 4, the before comes next
 . . S B=$P(COLUMNS,U,2)
 . . S A=$P(COLUMNS,U,3)
 . . I TYPE=4 S P=$P(COLUMNS,U,4)
 . E  D  ; for types 1 and 2, no before, after comes next
 . . S A=$P(COLUMNS,U,2)
 . . I TYPE=1 S P=$P(COLUMNS,U,3)
 . ;
 . W ?13,B,?28,A,?43,P ; sum before, sum after, patch list
 . ;
 . ; F6. compare before checksum & patch list to current routine
 . ;
 ;
 QUIT  ; end of FINDSUMS
 ;
 ;
DRIVEFS ; test FINDSUMS
 ;
 D FINDSUMS("c:\voe\patches\XU\","XU-8_SEQ-120_PAT-135.TXT")
 QUIT  ; end of DRIVEFS
 ;
 ;
ANALYZE(LINE,ISHEAD,TYPE,DEBUG) ; analyze a line from a KIDS description
 ;
 ; .ISHEAD = 1 if it is the routine table header line, else 0
 ; .TYPE = set of codes: which type of routine table is it:
 ;     1 = routine                     checksum after    patch list
 ;     2 = routine                     checksum after
 ;     3 = routine   checksum before   checksum after
 ;     4 = routine   checksum before   checksum after   patch list
 ;
 ;     and not yet handled:
 ;     5 = routine   sum & patches before   sum & patches after
 ;     6 = none (may have routines; consider how to handle later)
 ;     7 = none (informational)
 ; DEBUG (optional) = 1 to make ANALYZE write debugging info
 ;
 ; I1. quickly screen out poor candidates
 ;
 S ISHEAD=0 ; assume it is not a header line
 I LINE'["   " Q  ; unless there are columns, it's not a header line
 S LINE=$$UP^XLFSTR(LINE) ; convert to upper case
 ; better be checksums:
 I LINE'["CHECKSUM",LINE'["BEFORE",LINE'["OLD",LINE'["CHKSUM" Q
 I LINE["(V)" Q  ; associated patches lines contain "BEFORE"
 I LINE["CHECK^XTSUMBLD" Q  ; extra header line contains "CHECKSUM"
 I LINE["VERIFY CHECKSUMS IN TRANSPORT GLOBAL" Q  ; install step line
 ;
 ; I2. extract columns
 ;
 N COLUMNS S COLUMNS=$$COLUMNS(LINE) ; extract columns
 N LENGTH S LENGTH=$L(COLUMNS,U) ; how many columns?
 I $G(DEBUG) W !,LENGTH ; for debugging
 I LENGTH<2!(LENGTH>4) Q  ; unless there are 2-4 columns, it's not
 S TYPE=6 ; assume the routine table requires special handling
 ;
 S COLUMNS=$TR(COLUMNS," AEIOUC") ; condense: extract spaces, vowels, C
 ; C because of all the variations of CHCKSUM/CHKSUM
 ;
 N R S R=$P(COLUMNS,U) ; routine name
 N B S B=$P(COLUMNS,U,2) ; checksum before patch
 N A S A=$P(COLUMNS,U,3) ; checksum after patch
 N P S P=$P(COLUMNS,U,4) ; patch list after patch
 ;
 I LENGTH=2 D  ; if only two columns, it's name and checksum after
 . S A=B,B="" ; set checksum after and clear before
 . S TYPE=2
 E  I LENGTH=3 D  ; two different types have three columns
 . S TYPE=3 ; assume it is name, before, and after
 . I "^PTHLST^2NDLN^NDTR^LST^^"'[(U_A_U) D  ; if patch list, it's type 1
 . . S P=A,A=B,B="" ; set after & patches, clear before
 . . S TYPE=1
 E  S TYPE=4 ; the preferred type, all four columns
 ;
 I $G(DEBUG) W !?3,R,?13,B,?28,A,?43,P ; for debugging
 ;
 ; I3. decide whether they look like routine table header columns
 ;
 D  ; change that to no unless a pattern is met
 . ;
 . I "^NM^RTN^RTNNM^RNT^NM^RNTNM^PRGRM^"'[(U_R_U) D  Q  ; routine name
 . . I $G(DEBUG) W "R: [",R,"] ",$L(R)
 . I "^BFR^LD^HKSM^HKSMBFR^BFRPTH^^BFRHKSM^"'[(U_B_U) D  Q
 . . I $G(DEBUG) W "B: [",B,"] ",$L(B)
 . I "^FTR^NW^HKSM^HKSMFTR^^FTRPTH^NWHKSM^FTRHKSM^"'[(U_A_U) D  Q
 . . I $G(DEBUG) W "A: ",A,"[ ",$L(A)
 . I "^PTHLST^2NDLN^NDTR^LST^^"'[(U_P_U) D  Q  ; patch list after patch
 . . I $G(DEBUG) W "P: ",P,"[ ",$L(P)
 . ;
 . S ISHEAD=1
 Q:'ISHEAD
 ;
 ; I4. display canonical header
 ;
 W !,TYPE
 W ?3,"routine"
 I TYPE>2 W ?13,"sum before"
 W ?28,"sum after"
 I TYPE=1!(TYPE=4) W ?48,"patch list"
 ;
 QUIT  ; end of ANALYZE
 ;
 ;
DRIVEA ; test ANALYZE
 ;
 N LINE S LINE="  Routine      ChkSum      2nd Line"
 N ISHEAD
 D ISHEAD(LINE,.ISHEAD,.TYPE,1)
 W !!,ISHEAD
 QUIT  ; end of DRIVEIH
 ;
 ;
COLUMNS(LINE) ; extract column values from floating multi-space delimiters
 ; given a free text line containing floating columns of data
 ; delimited by multiple spaces (2 or more), extract the columns and
 ; return them ^-delimited.  This could later be extended to choose the
 ; delimiters (instead of spaces and ^s).
 ;
 ; we need to extend this tool to handle empty columns
 ;
 N COLUMNS S COLUMNS="" ; return value
 S LINE=$$TRIM^XLFSTR(LINE,"LR") ; trim leading & trailing spaces
 N COUNT ; count columns extracted
 F COUNT=1:1 Q:LINE=""  D  ; continue until LINE reduced to empty
 . N COLUMN S COLUMN=$P(LINE,"  ") ; copy first column
 . S $P(COLUMNS,U,COUNT)=COLUMN ; place it into the return value
 . S $P(LINE,"  ")="" ; remove it from LINE
 . S LINE=$$TRIM^XLFSTR(LINE,"L") ; remove leading spaces from LINE
 ;
 QUIT COLUMNS  ; end of COLUMNS, return extracted column values
 ;
 ;
DRIVEC ; test COLUMNS
 ;
 N LINE S LINE=" Routine         Old       New      2nd Line "
 W !,"Before: ",LINE
 W !!,"After: ",$$COLUMNS(LINE)
 QUIT  ; end of DRIVEC
 ;
 ;
 QUIT  ; end of routine XPDZSUM
