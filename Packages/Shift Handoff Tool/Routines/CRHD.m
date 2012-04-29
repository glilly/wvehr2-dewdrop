CRHD    ; CAIRO/CLC - GET THE PATIENT DATA ELEMENTS FOR CHANGEOVER LIST ;04-Mar-2008 16:00;CLC
        ;;1.0;CRHD;****;Jan 28, 2008;Build 19
        ;=================================================================
ALG(CRHDROOT,CRHDSTR)   ; Allergies
        D ALG^CRHDUT(.CRHDROOT,.CRHDSTR)
        Q
ACTMED(CRHDROOT,CRHDSTR)        ;Active Medications
        D ACTMED^CRHDUT(.CRHDROOT,.CRHDSTR)
        Q
CONSULT(CRHDROOT,CRHDSTR)       ;consults orders - call from cprs
        D CONSULT^CRHDUT(.CRHDROOT,.CRHDSTR)
        Q
IMAGING(CRHDROOT,CRHDSTR)       ;Radiology orders - call from cprs
        D IMAGING^CRHDUT(.CRHDROOT,.CRHDSTR)
        Q
LABS(CRHDROOT,CRHDSTR)  ;LABS orders - call from cprs
        D LABS^CRHDUT(.CRHDROOT,.CRHDSTR)
        Q
PROC(CRHDROOT,CRHDSTR)  ;Procedures orders - call from cprs
        D PROC^CRHDUT(.CRHDROOT,.CRHDSTR)
        Q
PROB(CRHDROOT,CRHDSTR)  ;DFN,NUM,HDR) ;
        D PROB^CRHDUT(.CRHDROOT,.CRHDSTR)
        Q
RECENTLR(ROOT,DFN,NUM,HDR)      ;
        D RECNTLAB^CRHDUT(.CRHDROOT,.CRHDSTR)
        Q
PATDEMO(CRHDROOT,CRHDSTR)       ;GET PATIENTS DEMOGRAPHICS
        D PATDEMO^CRHDUT2(.CRHDROOT,.CRHDSTR)
        Q
CODESTS(CRHDROOT,CRHDSTR)       ; GET CODE STATUS
        D CODESTS^CRHD2(.CRHDROOT,.CRHDSTR)
        Q
