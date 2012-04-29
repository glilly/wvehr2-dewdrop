XPDZHFS ;WV/TOAD-KIDS HFS Tools ;11/30/2005  15:42
 ;;8.0;KERNEL;**L34**;Jul 10,1995
 ;
 ; This routine is a development toolkit for a new KIDS option that
 ; compares the checksums for routines being brought in by a patch to
 ; those currently installed on the system.  It contains subroutines
 ; used during development to try out APIs and draft preliminary
 ; steps toward the final draft.  These are all programmer-mode tools,
 ; none supported.
 ;
 ; calls
 ; this routine and XPDZSUM call each other
 ;
 ; history
 ;
 ; 2005 11 29  Rick Marshall developed this to try out algorithms for
 ;             routine XPDZSUM
 ; 2005 11 30  Rick Marshall finished the experiments and moved the
 ;             relevant subroutines back to XPDZSUM
 ;
 ; contents
 ;
 ; ISHEAD.  return whether a line is a routine table header line
 ; DRIVEIH. test ISHEAD
 ; PRINTDIR. list the files in a directory (PATH)
 ; DRIVEPD. test PRINTDIR
 ; DIRSUMS. find checksums & patch lists in a KIDS directory
 ; DRIVEDS. test DIRSUMS
 ;
 ;
ISHEAD(LINE,DEBUG) ; given a line from a KIDS description, return whether it
 ; is the header line of a routine checksum table
 ;
 ; I1. quickly screen out poor candidates
 ;
 I LINE'["   " Q 0 ; unless there are columns, it's not a header line
 S LINE=$$UP^XLFSTR(LINE) ; convert to upper case
 ; better be checksums:
 I LINE'["CHECKSUM",LINE'["BEFORE",LINE'["OLD",LINE'["CHKSUM" Q 0
 I LINE["(V)" Q 0 ; associated patches lines contain "BEFORE"
 I LINE["CHECK^XTSUMBLD" Q 0 ; extra header line contains "CHECKSUM"
 I LINE["VERIFY CHECKSUMS IN TRANSPORT GLOBAL" Q 0 ; install step line
 ;
 ; I2. extract columns
 ;
 N COLUMNS S COLUMNS=$$COLUMNS^XPDZSUM(LINE) ; extract columns
 N LENGTH S LENGTH=$L(COLUMNS,U) ; how many columns?
 I $G(DEBUG) W !,LENGTH ; for debugging
 I LENGTH<2!(LENGTH>4) Q 0 ; unless there are 2-4 columns, it's not
 ;
 S COLUMNS=$TR(COLUMNS," AEIOUC") ; condense by extracting spaces, vowels, & C
 ; C because of all the variations of CHCKSUM/CHKSUM
 N R S R=$P(COLUMNS,U) ; routine name
 N B S B=$P(COLUMNS,U,2) ; checksum before patch
 N A S A=$P(COLUMNS,U,3) ; checksum after patch
 N P S P=$P(COLUMNS,U,4) ; patch list after patch
 I LENGTH=2 S A=B,B="" ; if only two columns, it's name and after
 ; rarely, 3 cols is after & patch list:
 I LENGTH=3,A="PTHLST"!(A="2NDLN") S P=A,A=B,B=""
 ;
 W !,R,?12,B,?27,A,?42,P ; for debugging
 ;
 ; I3. decide whether they look like routine table header columns
 ;
 N HEADER S HEADER=0 ; assume it is not a header line
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
 . S HEADER=1
 ;
 QUIT HEADER  ; end of ISHEAD, return answer
 ;
 ;
DRIVEIH ; test ISHEAD
 ;
 N LINE S LINE="  Routine      ChkSum      2nd Line"
 N ISHEAD S ISHEAD=$$ISHEAD(LINE,1)
 W !!,ISHEAD
 QUIT  ; end of DRIVEIH
 ;
 ;
PRINTDIR(PATH) ; list the files in a directory (PATH)
 ;
 ; P1. transfer directory listing to ^TMP
 ;
 K ^TMP("XPDZHFS")
 D
 . N FILES S FILES("*")=""
 . N ROOT S ROOT=$NA(^TMP("XPDZHFS",$J))
 . N SUCCESS S SUCCESS=$$LIST^%ZISH(PATH,"FILES",ROOT)
 ;
 ; P2. print directory listing
 ;
 N FILE S FILE="" F  D  Q:FILE=""
 . S FILE=$O(^TMP("XPDZHFS",$J,FILE)) Q:FILE=""
 . W !,FILE
 ;
 QUIT  ; end of PRINTDIR
 ;
 ;
DRIVEPD ; test PRINTDIR
 ;
 D PRINTDIR("c:\voe\patches\XU\")
 QUIT  ; end of DRIVEPD
 ;
 ;
DIRSUMS(PATH,START) ; find checksums & patch lists in a KIDS directory
 ;
 ; P1. transfer directory listing to ^TMP
 ;
 K ^TMP("XPDZHFS","DIRSUMS")
 D
 . N FILES S FILES("*")=""
 . N ROOT S ROOT=$NA(^TMP("XPDZHFS","DIRSUMS",$J))
 . N SUCCESS S SUCCESS=$$LIST^%ZISH(PATH,"FILES",ROOT)
 ;
 ; P2. print listing of KIDS description files
 ;
 N FILE S FILE=$G(START) F  D  Q:FILE=""
 . S FILE=$O(^TMP("XPDZHFS","DIRSUMS",$J,FILE)) Q:FILE=""
 . N UP S UP=$$UP^XLFSTR(FILE)
 . Q:UP'?1.AN1"-"1.(1N,1"P")1"_SEQ-"1.N1"_PAT-"1.N1".TXT"
 . ; e.g., XU-8_SEQ-133_PAT-152.txt
 . W !!?12,FILE,": ",!
 . D FINDSUMS^XPDZSUM(PATH,FILE)
 . ;
 . ; P3. prompt after each listing to allow check/escape
 . ;
 . N Y D  I 'Y S FILE="" Q  ; allow escape
 . . N DA,DIR,DIROUT,DIRUT,DTOUT,DUOUT,X
 . . S DIR(0)="EA" ; end-of-page read
 . . S DIR("A")=""
 . . D ^DIR ; FileMan Reader
 ;
 QUIT  ; end of DIRSUMS
 ;
 ;
DRIVEDS ; test DIRSUMS
 ;
 D DIRSUMS("c:\voe\patches\XU\","")
 QUIT  ; end of DRIVEDS
 ;
 ;
 ; end of routine XPDZSUM
