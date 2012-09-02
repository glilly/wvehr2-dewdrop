TMGDEBU2        ;TMG/kst/SACC-compliant Debug utilities ;07/17/12
                ;;1.0;TMG-LIB;**1,17**;07/17/12;Build 23
        ;
        ;"TMG DEBUG UTILITIES
        ;"SACC compliant versions of TMGDEBUG
        ;"Kevin Toppenberg MD
        ;"GNU General Public License (GPL) applies
        ;"7-17-2012
        ;
        ;"NOTE: This will contain SACC-compliant versions of code from TMGDEBUG
        ;"      If routine is not found here, the please migrate and update the
        ;"      code to be compliant.
        ;"=======================================================================
        ;" API -- Public Functions.
        ;"=======================================================================
        ;"SHOWERR(PRIORERRORFOUND,ERROR) -- Output an error message
        ;"GETERRST(ERRARRAY) --Convert a standard DIERR array into a string for output
        ;"SHOWDIER(ERRMSG,PRIORERRORFOUND) --A standard output mechanism for the fileman DIERR message
        ;
        ;"=======================================================================
        ;"Private API functions
        ;"=======================================================================
        ;"
        ;"=======================================================================
        ;"DEPENDENCIES: TMGUSRI2
        ;"=======================================================================
        ;
SHOWERR(PRIORERRORFOUND,ERROR)  ;
               ;"Purpose: to output an error message
               ;"Input: [OPTIONAL] PRIORERRORFOUND -- var to see if an error already shown.
               ;"                if not passed, then default value used ('no prior error')
               ;"        Error -- a string to display
               ;"results: none
               ;
               DO POPUPBOX^TMGUSRI2("<!> ERROR . . .",ERROR)
               SET PRIORERRORFOUND=1
               QUIT
               ;
GETERRST(ERRARRAY)      ;
               ;"Purpose: convert a standard DIERR array into a string for output
               ;"Input: ERRARRAY -- PASS BY REFERENCE.  example:
               ;"      array("DIERR")="1^1"
               ;"      array("DIERR",1)=311
               ;"      array("DIERR",1,"PARAM",0)=3
               ;"      array("DIERR",1,"PARAM","FIELD")=.02
               ;"      array("DIERR",1,"PARAM","FILE")=2
               ;"      array("DIERR",1,"PARAM","IENS")="+1,"
               ;"      array("DIERR",1,"TEXT",1)="The new record '+1,' lacks some required identifiers."
               ;"      array("DIERR","E",311,1)=""
               ;"Results: returns one long equivalent string from above array.
               ;
               NEW TMGERRSTR,TMGIDX,TMGERRNUM
               ;
               SET TMGERRSTR=""
               FOR TMGERRNUM=1:1:+$GET(ERRARRAY("DIERR")) DO
               . SET TMGERRSTR=TMGERRSTR_"Fileman says: '"
               . IF TMGERRNUM'=1 SET TMGERRSTR=TMGERRSTR_"(Error# "_TMGERRNUM_") "
               . SET TMGIDX=$ORDER(ERRARRAY("DIERR",TMGERRNUM,"TEXT",""))
               . IF TMGIDX'="" FOR  DO  QUIT:(TMGIDX="")
               . . SET TMGERRSTR=TMGERRSTR_$GET(ERRARRAY("DIERR",TMGERRNUM,"TEXT",TMGIDX))_" "
               . . SET TMGIDX=$ORDER(ERRARRAY("DIERR",TMGERRNUM,"TEXT",TMGIDX))
               . IF $GET(ERRARRAY("DIERR",TMGERRNUM,"PARAM",0))>0 DO
               . . SET TMGIDX=$ORDER(ERRARRAY("DIERR",TMGERRNUM,"PARAM",0))
               . . SET TMGERRSTR=TMGERRSTR_"Details: "
               . . FOR  DO  QUIT:(TMGIDX="")
               . . . IF TMGIDX="" QUIT
               . . . SET TMGERRSTR=TMGERRSTR_"["_TMGIDX_"]="_$GET(ERRARRAY("DIERR",1,"PARAM",TMGIDX))_"  "
               . . . SET TMGIDX=$ORDER(ERRARRAY("DIERR",TMGERRNUM,"PARAM",TMGIDX))
               ;
               QUIT TMGERRSTR
               ;
SHOWDIER(ERRMSG,PRIORERRORFOUND)        ;
               ;"Purpose: To provide a standard output mechanism for the fileman DIERR message
               ;"Input:   ERRMSG -- PASS BY REFERENCE.  a standard error message array, as
               ;"                   put out by fileman calls
               ;"         PRIORERRORFOUND -- OPTIONAL variable to keep track if prior error found.
               ;"          Note -- can also be used as ErrorFound (i.e. set to 1 if error found)
               ;"Output -- none, displays error to console
               ;"Result -- none
               IF $DATA(ERRMSG("DIERR")) DO
               . NEW TMGERRSTR SET TMGERRSTR=$$GETERRST(.ERRMSG)
               . DO SHOWERR(.PRIORERRORFOUND,.TMGERRSTR)
               QUIT
               ;
