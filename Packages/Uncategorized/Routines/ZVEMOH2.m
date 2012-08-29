ZVEMOH2 ;DJB,VRROLD**Help Text [01/15/95]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
VRROLD ;;;
 ;;;
 ;;;  E D I T   Submenu
 ;;;
 ;;;   'n'         Enter the line number of the line of code you wish to edit.
 ;;; HIGHLIGHT     You may also position the HIGHLIGHT and hit <TAB> to select
 ;;;               a line for editing. You may use the HIGHLIGHT/<TAB> combination
 ;;;               for other commands as well. Any other command that asks for
 ;;;               LINE NUMBER will accept <TAB> to mean the HIGHLIGHTED line.
 ;;;
 ;;;    I          Insert new code after selected line number. To insert a line
 ;;;               at the top of the routine, INSERT after line 0 (zero).
 ;;;
 ;;;    D          Delete selected line or range of lines. To select a range
 ;;;               use a dash. Ex. Delete lines 5-9.
 ;;;
 ;;;    LC         Locate and change string. This option will locate every
 ;;;               occurrance of the selected string and change it to the selected
 ;;;               value, within a selected range of lines.
 ;;;
 ;;;    SA         Save a line or range of lines. Use this option to move code
 ;;;               elsewhere in the program or to other programs.
 ;;;
 ;;;    UN         UNsave  copies SAved  code to a new location. The code will
 ;;;               be inserted after the selected line number. To UNSAVE a line
 ;;;               at the top of the routine, UNSAVE after line 0 (zero).
 ;;;
 ;;;    BK         Break a line into 2 lines. Trailing and leading spaces are
 ;;;               removed.
 ;;;
 ;;;    J          Join 2 selected lines. The 2nd line is joined to the end of
 ;;;               the 1st line and then deleted. Use Split to undo.
 ;;;
 ;;;    MD         This is a toggle switch that changes between screen edit mode
 ;;;               and line edit mode (REPLACE: WITH:).
 ;;;
 ;;;   PUR         The SAve and UNsave options use global ^%ZVEMS("E","SAVE")
 ;;;               as a holding location. ^%ZVEMS("E","SAVE") does not grow to any
 ;;;               great extent, but it can be killed at any time with this purge
 ;;;               option.
 ;;;***
