ZVEMS ;DJB,VSHL**Setup VShell [11/17/96 12:47pm]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
 Q
NOTES ;General notes
 ;;VEE File numbers: 19200-19204
 ;;************** SCROLLING **************
 ;;Keep Scroll arrays from clashing. Any array originating in ^ZVEMKT
 ;;can't allow branching (to Help for example) which will call ^ZVEMKT
 ;;and start another array that will clash. Only external users of the
 ;;scroller (like VGL) which have a different subscript, can do this.
 ;;^%ZVEMKT - Scroller
 ;; IMPORT          ^TMP("VEE","K",$J,
 ;; RTN                    ""
 ;; GLB                    ""
 ;;External IMPORTING - Subscript starts with "I" when IMPORTING.
 ;; VGL                     ^TMP("VEE","IG"_GLS,$J,
 ;; VGL(Piece)              ^TMP("VEE","IGP",$J,
 ;; VEDD(Global Location)   ^TMP("VEE","ID"_VEDDS,$J,
 ;;VRR(Rtn Edit)           ^TMP("VEE","IR"_VRRS,$J,
 ;;
 ;;VEET("HD") + VEET("FT") - 1 = Top $Y
 ;;Top $Y + VEET("S2") - VEET("S1") = Bottom $Y
 ;;************** NEW VPE VERSION **************
 ;;Notes for changing version number and doing updates.
 ;;VEE File number range: 19200-19204
 ;;NEW VERSION: 1. VPE_xx.DOC.....in DOS..Update version number
 ;;             2. Change 2nd line of ^ZVEM*
