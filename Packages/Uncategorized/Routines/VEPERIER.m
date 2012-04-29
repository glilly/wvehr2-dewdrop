VEPERIER ;DAOU/KFK;ERROR REPORT FOR PATIENT LOOKUP; ; 6/3/05 5:27pm
 ;;1.0;VOEB;;Jun 12, 2005;Build 1
 ;
 ; This is the routine for the Patient Lookup Error Report.
 ;
 ; Must call at EN
 Q
 ;
EN ; Main entry pt
 ; Init vars
 N STOP,HL7ERTN,POP,HL7ESPC
 ;
 S STOP=0,HL7ERTN="VEPERIER"
 ;
 ;Check for email
 I $D(HL7ESPC("MM")) D  G EXIT
 . D COMPILE(HL7ERTN,.HL7ESPC)
R5 ;
 W @IOF
 W !,"Error messages are generated daily.  Please select a date or date"
 W !,"range when errors were generated to view the associated error detail."
 ;
 ; Date Range params
R10 D DTRANGE I STOP G:$$STOP EXIT G R5
 ; Sort by param - Foreign ID or Patient
R50 D SORT I STOP G:$$STOP EXIT G R10
 ; Select output device
R100 D DEVICE(HL7ERTN,.HL7ESPC) I STOP G:$$STOP EXIT G R50
 G EXIT
 ;
EXIT ; Exit pt
 Q
 ;
COMPILE(HL7ERTN,HL7ESPC) ;
 ; Entry point called from EN^XUTMDEVQ in either direct or queued mode.
 ; Input params:
 ;  HL7ERTN = Routine name for ^TMP($J,...
 ;  HL7ESPC = Array passed by ref of the report params
 ;
 ; Init scratch globals
 K ^TMP($J,HL7ERTN)
 ; Compile
 D EN^VEPERPT(HL7ERTN,.HL7ESPC)
 ; Print
 I '$G(ZTSTOP) D
 . D EN6^VEPERPTA(HL7ERTN)
 ; Close device
 D ^%ZISC
 ; Kill scratch globals
 K ^TMP($J,HL7ERTN)
 ; Purge task record
 I $D(ZTQUEUED) S ZTREQ="@"
 ;
COMPILX ; COMPILE exit pt
 Q
 ;
STOP() ; Determine if user wants to exit out of the whole option
 ; Init vars
 N DIR,X,Y,DIRUT
 ;
 W !
 S DIR(0)="Y"
 S DIR("A")="Do you want to exit out of this option entirely"
 S DIR("B")="YES"
 S DIR("?",1)="  Enter YES to immediately exit out of this option."
 S DIR("?")="  Enter NO to return to the previous question."
 D ^DIR K DIR
 I $D(DIRUT) S (STOP,Y)=1 G STOPX
 I 'Y S STOP=0
 ;
STOPX ; STOP exit pt
 Q Y
 ;
DTRANGE ; Determine start and end dates for date range param
 ; Init vars
 N X,Y,DIRUT
 ;
 W !
 ;
 S DIR(0)="D^:-NOW:EX"
 S DIR("A")="Start DATE"
 S DIR("?",1)="   Please enter a valid date for which an Error Message"
 S DIR("?")="   would have been received. Future dates are not allowed."
 D ^DIR K DIR
 I $D(DIRUT) S STOP=1 G DTRANGX
 S HL7ESPC("BEGDT")=Y
 ; End date
DTRANG1 S DIR(0)="DA^"_Y_":-NOW:EX"
 S DIR("A")="  End DATE:  "
 S DIR("?",1)="   Please enter a valid date for which an Error Message"
 S DIR("?",2)="   would have been received.  This date must not precede"
 S DIR("?")="   the Start Date.  Future dates are not allowed."
 D ^DIR K DIR
 I $D(DIRUT) S STOP=1 G DTRANGX
 S HL7ESPC("ENDDT")=Y
 ;
DTRANGX ; DTRANGE exit pt
 Q
 ;
TYPEX ; TYPE exit pt
 Q
 ;
SORT ; Prompt to allow users to sort the report by Foreign ID (default) or
 ;  Patient Name
 ; Init vars
 N DIR,X,Y,DIRUT
 ;
 S DIR(0)="S^1:Patient ID;2:Patient Name;3:Error Type"
 S DIR("A")="Select the primary sort field"
 S DIR("B")=1
 S DIR("?",1)="  1 - Patient ID is the primary sort."
 S DIR("?",2)="      (Default)"
 S DIR("?",3)="  2 - Patient Name is the primary sort."
 S DIR("?")="  3 - Error Type is the primary sort."
 D ^DIR K DIR
 I $D(DIRUT) S STOP=1 G SORTX
 S HL7ESPC("SORT")=Y
 ;
SORTX ; SORT exit pt
 Q
 ;
DEVICE(HL7ERTN,HL7ESPC) ; Device Handler and possible TaskManager calls
 ;
 ; Input params:
 ;  HL7ERTN = Routine name for ^TMP($J,...
 ;  HL7ESPC = Array passed by ref of the report params
 ;
 ; Init vars
 N ZTRTN,ZTDESC,ZTSAVE,POP
 ;
 S ZTRTN="COMPILE^VEPERIER("""_HL7ERTN_""",.HL7ESPC)"
 S ZTDESC="HL7 Error Report sorted by "_$S(HL7ESPC("SORT")="1":"Patient ID",HL7ESPC("SORT")=2:"Patient Name",1:"Error Type")
 S ZTSAVE("HL7ESPC(")=""
 S ZTSAVE("HL7ERTN")=""
 D EN^XUTMDEVQ(ZTRTN,ZTDESC,.ZTSAVE)
 I POP S STOP=1
 ;
DEVICEX ; DEVICE exit pt
 Q
 ;
