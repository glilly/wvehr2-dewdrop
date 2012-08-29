ZVEMOH ;DJB,VRROLD**Help Text [12/31/94]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
VRROLD ;;;
 ;;; V R R . . . . . . . . . The VRoutine Reader . . . . . . . . . . David Bolduc
 ;;;
 ;;;  NOTES: VRR displays the line number for all program lines not having a
 ;;;         line tag. It also displays the total program lines at the top of
 ;;;         the screen. The 2 vertical bars at the left side of the top and
 ;;;         bottom borders, help delineate line tags.
 ;;;         Submenu 'ED=Edit' is only available if you have global ^%ZVEMS("E")
 ;;;         on your system and you eXecute ^%ZVEMS("E").
 ;;;
 ;;;  E N T R Y   P O I N T S:
 ;;;
 ;;;        DO ^%ZVEMO - Normal entry point.
 ;;;        DO PARAM^%ZVEMO(routine) - To bypass routine selection prompt.
 ;;;        X ^%ZVEMS("E") - VPE routine editor that utilizes the VRR module.
 ;;;
 ;;;
 ;;;  In the RESULT column, the word 'selected' indicates you will receive a
 ;;;  prompt asking you to enter the required value. T,G,F,L Options position
 ;;;  the selected line to the top of the display.
 ;;;
 ;;; E N T E R                            R  E  S  U  L  T
 ;;; ---------    ---------------------------------------------------------------
 ;;;    ^         Quit current session.
 ;;;
 ;;; <SPACE>      Quit current session.
 ;;;
 ;;;  N A V I G A T E   Submenu
 ;;;
 ;;; <RETURN>     Continue on to next page.
 ;;;
 ;;;    U         Move UP a page. U will move you back 12 lines if you are in
 ;;;              single space mode, or 6 lines if in double space mode.
 ;;;
 ;;;    T         Move to the top of the routine.
 ;;;
 ;;;    B         Move to the bottom of the routine.
 ;;;
 ;;;    G         Go to selected line number.
 ;;;
 ;;;    F         Find selected Line Tag. If the Tag does not exist the display
 ;;;              will be blank. Use 'T' to return to top of program.
 ;;;
 ;;;    L         Locate selected string. If the string does not exist the display
 ;;;              will be blank. Use 'T' to return to top of program.
 ;;;
 ;;;   <AU>       Hitting the Up Arrow key moves the HIGHLIGHT up one line. Once
 ;;;              the HIGHLIGHT reaches the top of the page, hitting <AU> will
 ;;;              insert a new line at the top, thus backing up 1 line.
 ;;;
 ;;;   <AD>       Hitting the Down Arrow key moves the HIGHLIGHT down one line.
 ;;;              Once the HIGHLIGHT reaches the bottom of the page, hitting <AD>
 ;;;              will insert a new line at the bottom, thus moving ahead 1 line.
 ;;;
 ;;;   <AL>       Move highlight to top of page.
 ;;;
 ;;;   <AR>       Move highlight to bottom of page.
 ;;;***
