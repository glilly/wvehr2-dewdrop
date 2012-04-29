GMVDCSAV        ;HOIFO/DAD-VITALS COMPONENT: SAVE DATA ; 2/13/09 8:47AM
        ;;5.0;GEN. MED. REC. - VITALS;**9,3,25**;Oct 31, 2002;Build 4
        ;
        ; This routine uses the following IAs:
        ; #10103 - ^XLFDT calls           (supported)
        ;
        ; This routine supports the following IAs:
        ; #3996 - GMV ADD VM RPC called at EN1  (private)
        ;
        ; 01/28/2005 KAM GMRV*5*9 Record midnight with 1 second added
        ;                         Stop adding second on multiple patent entry
        ;
EN1(RESULT,GMVDATA)     ; GMV ADD VM [RPC entry point]
        ; Saves vitals data
        N GMVCNT,GMVD0,GMVFDA,GMVINUM,GMVQNUM,GMVRNUM,GMVIEN,GMVDUN
        N GMVVNUM,GMVVMEAS,GMVVQUAL,GMVVREAS
        D QUALTWO
        Q
        ;I $O(@GMVDATA@("V",0))>0 D VITMEA
        ;I $O(@GMVDATA@("I",0))>0 D ENTERR
        ;I $G(RESULT(0))="OK" D MSG("OK: Data saved")
        ;Q
        ;
VITMEA  ; *** Save vital measurement data ***
        S GMVVNUM=0 K GMVFDA
        S GMVCNT=+$O(@GMVDATA@("V",1E25),-1)
        F  S GMVVNUM=$O(@GMVDATA@("V",GMVVNUM)) Q:GMVVNUM'>0  D
        . S GMVVMEAS=$G(@GMVDATA@("V",GMVVNUM))
        . S GMVFDA(120.5,"+"_GMVVNUM_",",.01)=GMVDTDUN ; Date time taken
        . S GMVFDA(120.5,"+"_GMVVNUM_",",.02)=GMVDFN   ; Patient
        . S GMVFDA(120.5,"+"_GMVVNUM_",",.03)=$P(GMVVMEAS,U) ;
        . S GMVFDA(120.5,"+"_GMVVNUM_",",.04)=GMVDTENT  ; Date Time entered
        . S GMVFDA(120.5,"+"_GMVVNUM_",",.05)=GMVHOSPL  ; Hospital
        . S GMVFDA(120.5,"+"_GMVVNUM_",",.06)=GMVENTBY  ; Entered by (DUZ)
        . S GMVFDA(120.5,"+"_GMVVNUM_",",1.2)=$P($P(GMVVMEAS,U,2),";",1) ; Rate
        . S GMVFDA(120.5,"+"_GMVVNUM_",",1.4)=$P($P(GMVVMEAS,U,2),";",2) ; Sup 02
        . S GMVQNUM=0
        . F  S GMVQNUM=$O(@GMVDATA@("Q",GMVVNUM,GMVQNUM)) Q:GMVQNUM'>0  D
        .. S GMVVQUAL=$G(@GMVDATA@("Q",GMVVNUM,GMVQNUM))
        .. S GMVCNT=GMVCNT+1
        .. S GMVFDA(120.505,"+"_GMVCNT_",","+"_GMVVNUM_",",.01)=GMVVQUAL
        .. Q
        . Q
        D UPDATE^DIE("","GMVFDA"),FMERROR
        S RESULT(0)="OK"
        Q
        ;
ENTERR  ; *** Save entered in error data ***
        S GMVINUM=0 K GMVFDA
        S GMVCNT=+$O(@GMVDATA@("I",1E25),-1)
        F  S GMVINUM=$O(@GMVDATA@("I",GMVINUM)) Q:GMVINUM'>0  D
        . S GMVD0=$G(@GMVDATA@("I",GMVINUM))
        . S GMVFDA(120.5,GMVD0_",",2)=1
        . S GMVFDA(120.5,GMVD0_",",3)=GMVERRBY
        . S GMVRNUM=0
        . F  S GMVRNUM=$O(@GMVDATA@("R",GMVINUM,GMVRNUM)) Q:GMVRNUM'>0  D
        .. S GMVVREAS=$G(@GMVDATA@("R",GMVINUM,GMVRNUM))
        .. S GMVCNT=GMVCNT+1
        .. S GMVFDA(120.506,"+"_GMVCNT_","_GMVD0_",",.01)=GMVVREAS
        .. Q
        . Q
        D UPDATE^DIE("","GMVFDA"),FMERROR
        S RESULT(0)="OK"
        Q
QUALTWO ; Add a new entry to FILE 120.5
        S GMVVNUM=0 K GMVFDA
        S GMVVMEAS=$P(GMVDATA,"*",1) ;
        S GMVDTDUN=+$P(GMVVMEAS,"^",1) ; Date time
        ;01/28/2005 KAM GMRV*5*9 Added next Line PAL-0105-60940
        I +$P(GMVDTDUN,".",2)'>0 S GMVDTDUN=$$FMADD^XLFDT(GMVDTDUN,"","","",1)
        S GMVDFN=$P(GMVVMEAS,"^",2) ; Patient DFN
        S GMVVTYP=$P(GMVVMEAS,"^",3) ; Vital type
        S GMVDTDUN=$$CHKDT(GMVDTDUN,$P(GMVVTYP,";",1))
        S GMVDTENT=$$NOW^XLFDT ; Current date time
        S GMVHOSPL=$P(GMVVMEAS,"^",4) ; Hospital
        S GMVENTBY=$P(GMVVMEAS,"^",5) ; DUZ
        S GMVFDA(120.5,"+1,",.01)=GMVDTDUN ; Date time taken
        S GMVFDA(120.5,"+1,",.02)=GMVDFN   ; Patient
        S GMVFDA(120.5,"+1,",.03)=$P(GMVVTYP,";",1)   ; Vital Type
        S GMVFDA(120.5,"+1,",.04)=GMVDTENT  ; Date Time entered
        S GMVFDA(120.5,"+1,",.05)=GMVHOSPL  ; Hospital
        S GMVFDA(120.5,"+1,",.06)=GMVENTBY  ; Entered by (DUZ)
        S GMVFDA(120.5,"+1,",1.2)=$P(GMVVTYP,";",2) ; Rate
        S GMVFDA(120.5,"+1,",1.4)=$P(GMVVTYP,";",3) ; Sup 02
        S GMVIEN=""
        D UPDATE^DIE("","GMVFDA","GMVIEN"),FMERROR
        S GMVCNT=1
        S GMVQUALS=$P(GMVDATA,"*",2)
        F GMVLOOP=1:1:$L(GMVQUALS,":")+1 D
        . S GMVVQUAL=$P(GMVQUALS,":",GMVLOOP)
        . Q:GMVVQUAL=""
        . S GMVCNT=GMVCNT+1
        . D ADDQUAL^GMVGETQ(.GMVRES,GMVIEN(1)_"^"_GMVVQUAL)
        . Q
        Q
        ;
CHKDT(GMVDT,GMVSAV)     ;Check id there ios a vital entered for that date and time
        N GMVA,GMVQ
        S GMVQ=0
        S GMVA=""
        F  S GMVA=$O(^GMR(120.5,"B",GMVDT,GMVA)) Q:GMVA=""  D
        . ;01/28/2005 KAM GMRV*5*9 Added next Line BHS-0504-10643
        . I GMVDFN'=$P($G(^GMR(120.5,GMVA,0)),U,2) Q
        . S GMVTY=$P($G(^GMR(120.5,GMVA,0)),"^",3)
        . I GMVTY=GMVSAV D
        . . S GMVDT=$$FMADD^XLFDT(GMVDT,"","","",1)
        . . Q
        . Q
        Q GMVDT
MSG(X)  ; *** Add a line to the message array ***
        S (GMVMSG,RESULT(-1))=1+$G(RESULT(-1),0)
        S RESULT(GMVMSG)=X
        I $P(X,":")="ERROR" S RESULT(0)="ERROR"
        Q
        ;
FMERROR ;
        I $O(^TMP("DIERR",$J,0))>0 D
        . N GMVER1,GMVER2
        . S GMVER1=0
        . F  S GMVER1=$O(^TMP("DIERR",$J,GMVER1)) Q:GMVER1'>0  D
        .. S GMVER2=0
        .. F  S GMVER2=$O(^TMP("DIERR",$J,GMVER1,"TEXT",GMVER2)) Q:GMVER2'>0  D
        ... D MSG("ERROR: "_$G(^TMP("DIERR",$J,GMVER1,"TEXT",GMVER2)))
        ... Q
        .. Q
        . Q
        D CLEAN^DILF
        Q
