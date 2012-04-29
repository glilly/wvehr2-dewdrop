ZJOB1   ;ISF/RWF - GT.M Job Exam ;06/08/2004  17:15
        ;;8.0;KERNEL;**275**;Jul 10, 1995;Build 13
        Q
        ;  =============
        ; Reserved Symbols, Current Symbol Table Cleared and Replaced with Target Symbols
        ; zz1z - Index
        ; zz2z - Variable set syntax
        ; zz3z - Target Job ID
LOAD    ; Load variables from target process into current partition
        N zz1z,zz2z,zz3z,zz4z
        s zz3z=PID
        K (zz1z,zz2z,zz3z)
        F zz1z=1:1 S zz2z=$G(^XUTL("XUSYS",zz3z,"JE","V",zz1z)) Q:zz2z=""  D
        . ; Overly Long Strings may not be complete...
        . ; Better to throw away some data than to crash
        . ; But save if you can
        . I zz2z'["=" Q:$G(zz4z)=""  S zz2z=zz4z_"="""_@zz4z_zz2z
        . ;
        . I zz2z["="""&($E(zz2z,$L(zz2z))'="""") S zz2z=zz2z_""""
        . S @zz2z
        . S zz4z=$P(zz2z,"=")
        .Q
        Q
        ;  =============
        ;^XUTL("XUSYS",538971386,"JE","V",42)="ZTSK=0"
UNIX    ; gtmsendint shell script should be save in $gtm_dist
        ;  INSTALL Note:
        ;    When loading this into the $gtm_dist location, remember to
        ;      chmod 555 $gtm_dist/gtmsendint
        ;     so that the privs will be available for all.
        ;   Everything between the lines goes into gtmsendint
        ; VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
        ; -------------------------------------------------------
        ;#!/bin/tcsh -f
        ; ## Swith the CASE construct on the number of arguments, 0, 1, or more...
        ; switch ($#)
        ; ## Case of NO Arguments, Interrupt everyone who runs mumps.
        ; case 0:
        ; foreach proc (`ps --no-headers -o pid= -C mumps`)
        ; $gtm_dist/mupip intrpt $proc >>&/tmp/gtmsendint.$$.log
        ; end
        ; breaksw
        ; ## One Argument Form to exclude the first argument (current Job $J)
        ; ##  and process everyone else and then do the current $J to signal
        ; ##   this completion of the task.
        ; case 1:
        ; foreach proc (`ps --no-headers -o pid= -C mumps`)
        ; if ($proc != $1) $gtm_dist/mupip intrpt $proc >>&/tmp/gtmsendint.$$.log
        ; end
        ; $gtm_dist/mupip intrpt $1 >>&/tmp/gtmsendint.$$.log
        ; breaksw
        ; ## Else Clause
        ; ## This list of arguments (greater than 1) is the target(s) followed by the
        ; ##   current $J of this process to signal completion of the process
        ; default:
        ; foreach proc ($*)
        ; $gtm_dist/mupip intrpt $proc >>&/tmp/gtmsendint.$$.log
        ; end
        ; breaksw
        ; endsw
        ; -------------------------------------------------------
        ; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
VMS     ; GTMSENDINT.COM DCL code should be saved in GTM$DIST
        ;$! This is the file to process requests MUPIP INTRPT
        ;$! Hides the MUPIP output
        ;$ if p1 .eqs. "" then $exit
        ;$ define sys$output NL:
        ;$ mupip INTRPT /ID='p1'
        ;$ if p2 .eqs. "" then goto end
        ;$ mupip INTRPT /ID='p2'
        ;$end:
        ;$ deassign sys$output
        ;$exit
