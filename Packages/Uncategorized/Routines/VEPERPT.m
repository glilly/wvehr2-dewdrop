VEPERPT ;DAOU/KFK - PATIENT LOOKUP ERROR REPORT COMPILE ; 6/2/05 5:26pm
 ;;1.0;VOEB;;Jun 12, 2005
 ;
 ; This is the compile routine for the Patient Lookup Error Report.
 ; It is called from VEPERIER.  The data is gathered from file 19904.2
 ; (VEPER HL7 ERRORS) and stored in the scratch global (^TMP($J...)).
 ;
 ; Must call at EN
 Q
 ;
EN(HL7ERTN,HL7ESPC) ; Entry
 ; Init
 N BGDT,EN,ENDT,ERDT,HL7BDT,HL7DT,HL7EDT,HL7SRT,MSG,SORT1,SORT2,SORT3
 I '$D(ZTQUEUED),$G(IOST)["C-" W !!,"Compiling report data ..."
 ;
 ; Kill scratch globals
 K ^TMP($J,HL7ERTN)
 S HL7BDT=HL7ESPC("BEGDT"),HL7EDT=HL7ESPC("ENDDT"),HL7SRT=HL7ESPC("SORT")
 ;
 ; Loop thru the HL7 Error File (#19904.2)
 S BGDT=$P(HL7BDT,"."),ENDT=$P(HL7EDT,".")
 F  S BGDT=$O(^VEPER(19904.2,"B",BGDT)) Q:BGDT=""!($P(BGDT,".",1)>ENDT)  D
 . S EN=$O(^VEPER(19904.2,"B",BGDT,""))
 . I HL7SRT=1 D
 . . S SORT1=$P(^VEPER(19904.2,EN,0),U,4)
 . . S SORT2=$P(^VEPER(19904.2,EN,0),U,2)
 . . S SORT3=$P(^VEPER(19904.2,EN,0),U,5)
 . I HL7SRT=2 D
 . . S SORT1=$P(^VEPER(19904.2,EN,0),U,2)
 . . S SORT2=$P(^VEPER(19904.2,EN,0),U,4)
 . . S SORT3=$P(^VEPER(19904.2,EN,0),U,5)
 . I HL7SRT=3 D
 . . S SORT1=$P(^VEPER(19904.2,EN,0),U,5)
 . . S SORT2=$P(^VEPER(19904.2,EN,0),U,2)
 . . S SORT3=$P(^VEPER(19904.2,EN,0),U,4)
 . S MSG=^VEPER(19904.2,EN,1),ERDT=$P(^VEPER(19904.2,EN,0),U),HL7DT=$P(^VEPER(19904.2,EN,0),U,6)
 . I SORT1=""!(SORT2="")!(SORT3="") Q
 . S ^TMP($J,HL7ERTN,SORT1,SORT2,SORT3)=ERDT_U_MSG_U_HL7DT
 Q
