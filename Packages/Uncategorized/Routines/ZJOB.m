ZJOB    ;ISF/RWF - GT.M Job Exam ;8/15/07  16:28
        ;;8.0;KERNEL;**349**;Jul 10, 1995;Build 13
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; Various edits between Wally, Dave Whitten, Bhaskar,           ;
        ; and Chris Richardson over a period of time.                   ;
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;
        ;PID is decimal job number.
        I $ZV'["GT.M" W !,"This is for GT.M only" Q
        N PID,HEXPID,DTIME
        S DTIME=600
RPID    ; Request the PID
        F  D   Q:"^"[PID
        . S PID=$$ASKJOB
        . D:PID>0
        . . N ACTION
        . . S ACTION="L"
        . . D DOIT
        . . F  D ASK Q:ACTION="^"  D DOIT Q:ACTION="^"
        . .Q
        .Q
        ; Single Exit
        W !!
        Q
        ;
ASK     ; Ask for user input
        R !,"Job Exam Action: L//",ACTION:DTIME
        S:'$T ACTION="^"
        S:ACTION="" ACTION="L"
        I ACTION["^" Q  ;Exit
        ;
        ;first non-space, UPPER character
        S ACTION=$TR($E($TR(ACTION," ")),"klsv","KLSV")
        Q
        ;
DOIT    ; Action Prompt
        I ACTION="S" D ^ZSY  S ACTION="L" ;FALLTHRU
        I ACTION="L"!(ACTION="V") D DISPLAY(PID,ACTION) Q
        I ACTION="*" D LOAD^ZJOB1 S ACTION="^" Q
        I ACTION="K" W !,"Sorry Kill Job not supported yet" Q  ;G ACTION
        ; All Else
        W:ACTION'="?" !,"Unknown Action received"
        ;ACTION["?"
        W !,"Enter '^' to choose another JOB "
        W !,"Enter 'L' to display status information about other Job"
        W !,"Enter 'S' to display current System Status"
        W !,"Enter 'V' to display local variables of other job"
        W !,"Enter '*' to load other job's symbol table into current job and Q"
        W !,"Enter 'K' to send a Kill Job command to other job"
        Q
        ;
ASKJOB()        ;Ask for Job PID/Commands
        N PID
        W !!,"Examine Another JOB Utility "
        F   S PID=$$RDJNUM  Q:PID="^"  Q:PID=+PID
        Q PID
        ;
RDJNUM()        ;
        N INP,PID
        S INP=""
        R !,"Enter JOB number: ",INP:DTIME S:'$T INP="^"
        S INP=$TR(INP,"hlsv","HLSV")
        I "^"[INP Q "^"  ;abend
        ;
        I INP["?" D  Q " "
        . W !,"To display information about another Job"
        . W !,"   enter JOB number in Hexidecimal or Decimal"
        . W !,"   Enter Hexadecimal with a leading/trailing 'h' "
        . W !,"To display current System Status enter S"
        . W !,"To exit enter ^"
        .Q
        I INP["S" D ^ZSY Q " " ;
        ;
        ; good hex or decimal number
        S PID=$TR(INP,"abcdefh","ABCDEFH")
        I $L($TR(PID,"0123456789ABCDEFH","")) D  Q " "
        . W !,"Invalid character in JOB number."
        .Q
        ;
        ;If in Hex, Convert PID to decimal
        I PID["H" S PID=$$DEC($TR(PID,"H")) ; ...and continue
        ; good job number but it is your own job.  Don't go there...
        I PID=$JOB D  Q " "
        . W !,"Can't EXAMINE your own process."
        .Q
        ;
        ; VA check to see if a GTM job exists.
        I $L($T(XUSCNT)),'$$CHECK^XUSCNT(PID) W !,"Not running thru VA kernel." ;decimal job
        ;
        ;W !,"JOB #",PID," does not exist"
        ;Q " " ; bad job number so re-ask
        Q PID
        ;
INTRPT(JOB)     ;Send MUPIP intrpt
        N $ET,$ES S $ET="D IRTERR^ZJOB"
        ; shouldn't interrupt ourself
        I JOB=$JOB Q 0
        ;We need a LOCK to guarantee commands from two processes don't conflict
        N X,OLDINTRPT,TMP,ZSYSCMD,ZPATH,%J
        L +^XUTL("XUSYS","COMMAND"):10 Q:'$T 0
        ;
        S ^XUTL("XUSYS","COMMAND")="EXAM",^("COMMAND",0)=$J_":"_$H
        K ^XUTL("XUSYS",JOB,"JE")
        S OLDINTRP=$ZINTERRUPT,%J=$J
        S TMP=0,$ZINTERRUPT="S TMP=1"
        ;
        I $ZV["VMS" S JOB=$$HEX(JOB),%J=$$HEX(%J)
        S ZSYSCMD="mupip intrpt "_JOB ; interrupt other job
        I $ZV["VMS" S ZPATH="@gtm$dist:"  ; VMS path
        ;E  S ZPATH="sudo $gtm_dist" ;$ztrnlnm("gtm_dist") ;Unix path
        E  S ZPATH="$gtm_dist/" ;Unix path
        W !,"Send intrp to job. Any error means you don't have the privilege to intrpt.",!
        ZSYSTEM ZPATH_ZSYSCMD ; System Request
        ;Now send to self
        ;
        ;ZSYSTEM ZPATH_"mupip intrpt "_%J
        ; wait is too long 60>>30
        H 1 S TMP=1
        ; wait for interrupt, will set TMP=1
        ;F X=1:1:30 H 1 Q:TMP=1  ;ZINTERRUPT does not stop a HANG
        ; Restore old $ZINTERRPT
        S $ZINTERRUPT=OLDINTRP
        K ^XUTL("XUSYS","COMMAND") ;Cleanup
        L -^XUTL("XUSYS","COMMAND")
        Q TMP  ;Report if we received interrupt
        ;
ITRERR  ;Handle error during Interrupt
        U $P W !,"Error: ",$ES
        S $ET="Q:($ES&$Q) 0 Q:$ES  S $EC="""" Q 0"
        Q
        ;
DISPLAY(JOB,ACTION)     ;Display Job info, L is always the default.  No need to test for it.
        ; The "L" header is part of the "V" Option
        ;Send the interupt
        I '$$INTRPT(JOB) W !,"Unable to Examine JOB, please retry later" Q
        D DISPL ;Show Header
        I ACTION="V" D DISPV ;Show symbol table
        Q
        ;
DISPL   ; ACTION="L" means single page info
        ; Show short job info
        ; Current Routine and Line Number  ;Current Line Executing
        D GETINFO
        S HEXJOB="" I $ZV["VMS" S HEXJOB=$$HEX(JOB)
        W !,"JOB #: "_JOB W:$L(HEXJOB) " ("_HEXJOB_")" W ?40,"Process Name: "_$G(^XUTL("XUSYS",JOB,"NM"))
        W !,"Device: "_$P($G(^XUTL("XUSYS",JOB,"JE","D",1))," ")
        W !,"Process State: "_PS W:$L(IMAGE) ?40,"IMAGE: "_IMAGE_" ("_INAME_")"
        W !,"JOB Type: "_JTYPE,?25,"CPU Time: "_CTIME,?50,"Login time: "_LTIME
        W !!,"Routine line: <"_$G(^XUTL("XUSYS",JOB,"INTERRUPT"))_">"
        W !,CODELINE
        Q
        ;
        ; No Symbol Residue from this module.  The following are ephemeral
        ; S - Information Type
        ; I - Variable
DISPV   ; ACTION="V"  ; lookup how XTER is doing variable handling...
        ; print $ZGBLDIR and $ZROUTINES
        N C,I,S
        F S="Stack","Locks","Devices","Intrinsic Variables","Variables"    D
        . S C=$E(S),I=""
        . D:$D(^XUTL("XUSYS",JOB,"JE",C))  W !
        . . W !,"Section "_S
        . . F  S I=$O(^XUTL("XUSYS",JOB,"JE",C,I)) Q:I=""  W !,^(I)
        . . Q
        . Q
        Q
        ;  ==============
GETINFO ; Identify the Target Process's state.
        ; Setup, process state > ps, Image name > iname, CPU time > ctime, Login time > ltime
        S (PS,INAME,CTIME,LTIME,JTYPE,IMAGE,CODELINE)=""
        S CODELINE=$G(^XUTL("XUSYS",JOB,"codeline"))
        I $zv["VMS" D VSTATE  Q
        ; Assume Unix as default
        D USTATE
        Q
        ;
VSTATE  ; VMS get Process state
        S TNAME=$ZGETJPI(JOB,"TERMINAL"),NM=$ZGETJPI(JOB,"prcnam")
        S JTYPE=$ZGETJPI(JOB,"jobtype"),PS=$ZGETJPI(JOB,"state")
        S LTIME=$$DATETIME($ZGETJPI(PID,"LOGINTIM")),CTIME=$$CPUTIME($ZGETJPI(JOB,"cputim"))
        Q
        ;
DATETIME(HOROLOG)       ;
        Q $ZDATE(HOROLOG,"DD-MON-YY 24:60:SS","Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec")
        ;
CPUTIME(S)      ; Calculate the VMS CPU time from first argument, S
        N T,SS,M,H,D
        S T=S#100,S=S\100 S:$L(T)=1 T="0"_T
        S SS=S#60,S=S\60 S:$L(SS)=1 SS="0"_SS
        S M=S#60,S=S\60 S:$L(M)=1 M="0"_M
        S H=S#24,D=S\24 S:$L(H)=1 H="0"_H
        Q D_" "_H_":"_M_":"_SS_"."_T
        ;
BLINDPID        ;
        N ZE S ZE=$ZS,$EC=""
        I ZE["NOPRIV" S NOPRIV=1
        Q
        ; MAY BE REDUNDANT OR WRONG
USTATE  ;UNIX Process state.
        N %FILE,%TEXT,U,%J,ZCMD,$ET,$ES
        S $ET="D UERR^ZJOB",STATE="",U="^"
        S %FILE="/tmp/_gtm_sy_"_$J_".tmp"
        ;S ZCMD="ps ef -C mumps >"_%FILE ;| grep "_JOB_">"_%FILE
        S ZCMD="ps eo pid,tty,stat,time,etime,cmd -C mumps >"_%FILE ;| grep "_JOB_">"_%FILE
        ;W !,ZCMD
        ZSYSTEM ZCMD
        O %FILE:(readonly)
        ; Get only line of text from temp file
        U %FILE
        F EXIT=0:0 R %TEXT Q:%TEXT=""  D  Q:EXIT
        . Q:+%TEXT'=JOB
        . S %TEXT=$$VPE(%TEXT," ",U) ; parse each line of the ps output
        . S TNAME=$P(%TEXT,U,2),PS=$P(%TEXT,U,3),CTIME=$P(%TEXT,U,4),LTIME=$P(%TEXT,U,5),JTYPE=$P(%TEXT,U,7)
        . S EXIT=1
        .Q
        ;
        U $P C %FILE:DELETE
        S PS=$S(PS="S":"hib",PS="D":"lef",PS="R":"run",1:PS)
        Q
        ;  ================
UERR    ;Error
        S $EC=""
        U $P W !,"Error: "_$ZS
        Q:$Q -9
        Q
        ;
HEX(D)  ;Decimal to Hex
        Q $$FUNC^%DH(D,8)
DEC(H)  ;Hex to Decimal
        Q $$FUNC^%HD(H)
        ;
VPE(%OLDSTR,%OLDDEL,%NEWDEL)    ; $PIECE extract based on variable length delimiter
        N %LEN,%PIECE,%NEWSTR
        S %STRING=$G(%STRING)
        S %OLDDEL=$G(%OLDDEL) I %OLDDEL="" S %OLDDEL=" "
        S %LEN=$L(%OLDDEL)
        ; each %OLDDEL-sized chunk of %OLDSTR that might be delimiter
        S %NEWDEL=$G(%NEWDEL) I %NEWDEL="" S %NEWDEL="^"
        ; each piece of the old string
        S %NEWSTR="" ; new reformatted string to return
        F  Q:%OLDSTR=""  D
        . S %PIECE=$P(%OLDSTR,%OLDDEL)
        . S $P(%OLDSTR,%OLDDEL)=""
        . S %NEWSTR=%NEWSTR_$S(%NEWSTR="":"",1:%NEWDEL)_%PIECE
        . F  Q:%OLDDEL'=$E(%OLDSTR,1,%LEN)  S $E(%OLDSTR,1,%LEN)=""
        .Q
        Q %NEWSTR
        ;
