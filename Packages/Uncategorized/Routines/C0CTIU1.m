C0CTIU1 ; C0C/ELN - PROCESSING FOR TIU NOTES Contd. ; 19/10/2010
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;ELN UTILITY PROGRAM TO SUPPORT C0CTIU
C0CDATE(EDTE)   ; Converts external date to internal date format
        ; INPUT : EXTERNAL DATE (TIME IS OPTIONAL)
        ; OUTOUT: INTERNAL DATE, STORAGE FORMAT YYYMMMDD
        ; (TIME WILL BE RETURNED IF INCLUDED WITH INPUT)
        ;
        Q:'$D(EDTE) -1
        N X,%DT,Y
        S X=EDTE
        S %DT="TS"
        D ^%DT
        Q Y
        ;
XMAP(IXML,INARY,OXML)   ; SUBSTITUTE MULTIPLE @@X@@ VARS WITH VALUES IN INARY
        ; AND PUT THE RESULTS IN OXML
        N XCNT
        I '$D(DEBUG) S DEBUG=0
        I '$D(IXML) W "MALFORMED XML PASSED TO MAP",! Q
        I '$D(@IXML@(0)) D  ; INITIALIZE COUNT
        . S XCNT=$O(@IXML@(""),-1)
        E  S XCNT=@IXML@(0) ;COUNT
        I $O(@INARY@(""))="" W "EMPTY ARRAY PASSED TO MAP",! Q
        ;
        N I,J,TNAM,TVAL,TSTR
        S @OXML@(0)=XCNT ; TOTAL LINES IN OUTPUT
        F I=1:1:XCNT  D   ; LOOP THROUGH WHOLE ARRAY
        . S @OXML@(I)=@IXML@(I),C0CSLFLG=0 ; COPY THE LINE TO OUTPUT
        . I @OXML@(I)?.E1"@@".E D  ; IS THERE A VARIABLE HERE?
        . . S TSTR=$P(@IXML@(I),"@@",1) ; INIT TO PART BEFORE VARS
        . . F J=2:2:10  D  Q:$P(@IXML@(I),"@@",J+2)=""  ; QUIT IF NO MORE VARS
        . . . I DEBUG W "IN MAPPING LOOP: ",TSTR,! H 1
        . . . S TNAM=$P(@OXML@(I),"@@",J) ; EXTRACT THE VARIABLE NAME
        . . . S TVAL="@@"_$P(@IXML@(I),"@@",J)_"@@" ; DEFAULT UNCHANGED
        . . . I $D(@INARY@(TNAM))  D  ; IS THE VARIABLE IN THE MAP?
        . . . . I $D(@INARY@(TNAM,"WP")) D  Q
        . . . . . D DOWPFLD(I,J)
        . . . . I '$D(@INARY@(TNAM,"F")) D  ; NOT A SPECIAL FIELD
        . . . . . S TVAL=@INARY@(TNAM) ; PULL OUT MAPPED VALUE
        . . . . E  D DOFLD() ; PROCESS A FIELD ELAN
        . . . S TVAL=$$SYMENC^MXMLUTL(TVAL) ;MAKE SURE THE VALUE IS XML SAFE
        . . . S TSTR=TSTR_TVAL_$P(@IXML@(I),"@@",J+1) ; ADD VAR AND PART AFTER
        . . I $G(C0CSLFLG)=1 M @OXML@(I)=TSTR Q
        . . S @OXML@(I)=TSTR ; COPY LINE WITH MAPPED VALUES
        . . I DEBUG W TSTR H 1
        I DEBUG W "MAPPED",!
        K C0CSLFLG
        Q
DOWPFLD(I,J)    ;WORDPROCESSING FIELD MANIPULATION
        N C0CTXCNT
        S C0CTXCNT=0
        F  S C0CTXCNT=$O(@INARY@(TNAM,"WP",C0CTXCNT)) Q:C0CTXCNT=""  D
        . S TSTR(C0CTXCNT)=TSTR_$G(@INARY@(TNAM,"WP",C0CTXCNT))_$P(@IXML@(I),"@@",J+1)
        S C0CSLFLG=1
        Q
DOFLD() ;QUIT
        Q
BUILD(BLIST,BDEST)      ; A COPY MACHINE THAT TAKE INSTRUCTIONS IN ARRAY BLIST
        ; WHICH HAVE ARRAY;START;FINISH AND COPIES THEM TO DEST
        ; DEST IS CLEARED TO START
        ; USES PUSH TO DO THE COPY
        N I,WPSEQ
        K @BDEST
        F I=1:1:@BLIST@(0) D  ; FOR EACH INSTRUCTION IN BLIST
        . N J,ATMP
        . S ATMP=$$ARRAY^C0CXPATH(@BLIST@(I))
        . I $G(DEBUG) W "ATMP=",ATMP,!
        . I $G(DEBUG) W @BLIST@(I),!
        . F J=$$START^C0CXPATH(@BLIST@(I)):1:$$FINISH^C0CXPATH(@BLIST@(I)) D  ;
        . . ; FOR EACH LINE IN THIS INSTR
        . . I $G(DEBUG) W "BDEST= ",BDEST,!
        . . I $G(DEBUG) W "ATMP= ",@ATMP@(J),!
        . . I $D(@ATMP@(J,1)),$G(@ATMP@(J))="<Value>@@RESULTTESTVALUE@@</Value>" D  Q
        . . . S WPSEQ=0
        . . . D PUSH^C0CXPATH(BDEST,"<Value>")
        . . . F  S WPSEQ=$O(@ATMP@(J,WPSEQ)) Q:WPSEQ=""  D
        . . . . D PUSH^C0CXPATH(BDEST,$$SYMENC^MXMLUTL($$XVAL^C0CXPATH(@ATMP@(J,WPSEQ)))_"&#x0A;")
        . . . D PUSH^C0CXPATH(BDEST,"</Value>")
        . . D PUSH^C0CXPATH(BDEST,@ATMP@(J))
        Q
