ZVEMSH8 ;DJB,VSHL**MISCELLANEOUS [3/8/95 6:55am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
MISC ;;;
 ;;; M I S C E L L A N E O U S
 ;;;
 ;;; S H E L L   P A R A M E T E R S
 ;;;
 ;;; There are a few VShell parameters which you can adjust to meet your needs by
 ;;; running the PARAM System QWIK. Type ..PARAM at the '>>' prompt. The following
 ;;; parameters can be set:
 ;;;
 ;;;   Global Kill: NO/YES
 ;;;                If you enter code at the '>>' prompt that is killing a
 ;;;                global, you will be warned and asked if you want the code
 ;;;                executed. The default answer to that question is setable here.
 ;;;
 ;;;   Prompt: ACTIVE/INACTIVE
 ;;;                If Prompt is set to INACTIVE, the VShell's prompt will be
 ;;;                '>>'. If Prompt is ACTIVE, the VShell's prompt will include
 ;;;                UCI and Volume Set. Example: VAH,ROU>>
 ;;;
 ;;;   Time-out: SECONDS
 ;;;                You can set the length of time before the VShell times out
 ;;;                from inactivity. Enter the time out length in seconds.
 ;;;
 ;;;   SAVE Routine: ROUTINE NAME
 ;;;                The routine entered here will be the default routine when
 ;;;                you run System QWIK ..QSAVE, to save your User QWIKs.
 ;;;                ..QSAVE is also used to restore your previously saved QWIKs.
 ;;;                NOTE: It is your responsibility to insure that the routine
 ;;;                entered here doesn't already exist. If it does, it will
 ;;;                be overwritten.
 ;;;
 ;;;   <DEL> different from <BS>
 ;;;                  When set to DIFF, the <BS> key (8) deletes the character
 ;;;                  to the left of the cursor, and the <DEL> key (127)
 ;;;                  deletes the character under the cursor. When set to SAME,
 ;;;                  both the <BS> and <DEL> keys delete the character to the
 ;;;                  left of the cursor. You can do ..KEY to see what your <BS>
 ;;;                  key is sending. If it's sending 127, the same as your <DEL>
 ;;;                  key and you want these keys to delete the character to the
 ;;;                  left of the cursor, set this parameter to SAME.
 ;;;
 ;;; V S H E L L   T I M E   O U T
 ;;;
 ;;; If no activity occurs at the '>>' prompt, the VShell will time out. It will
 ;;; then look to see if you have a User QWIK named TO, and execute it. You can
 ;;; set TO to run any M code you'd like. Setting TO="HALT" will cause the VShell
 ;;; to quit.
 ;;;
 ;;; The VShell comes with its own screensaver which you can use by setting
 ;;; TO="DO ^%ZVEMSTO". This screensaver will disable Control-C. Hitting any key
 ;;; will return you back to your normal screen.
 ;;;
 ;;; To disable Control-Y in VAX DSM, set TO="DO VMS^%ZVEMSTO". Then set up the
 ;;; following file called TIMEOUT.COM, in your Log-In Directory:
 ;;;
 ;;;     $ SET NOCONTROL=(T,Y)
 ;;;     $ DEFINE/USER SYS$INPUT SYS$COMMAND
 ;;;     $ DSM/UCI=VAH/VOL=ROU/ENV=MMPSMGR VMS1^%ZVEMSTO
 ;;;
 ;;; NOTE: In the last line, replace MMPSMGR with your own Mumps Manager account.
 ;;;
 ;;; The VSHELL also includes a screen blanker. Set TO="BLANK^%ZVEMSTO". If you're
 ;;; on a VAX, change TIMEOUT.COM to call BLANK^%ZVEMSTO instead of VM1^%ZVEMSTO.
 ;;;***
