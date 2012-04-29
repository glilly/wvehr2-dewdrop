DGRODEBR ;DJH/AMA - ROM DATA ELEMENT BUSINESS RULES ; 27 Apr 2004  12:57 PM
 ;;5.3;Registration;**533,572**;Aug 13, 1993
 ;
 ;BUSINESS RULES TO BE CHECKED JUST BEFORE FILING THE
 ;PATIENT DATA RETRIEVED FROM THE LAST SITE TREATED (LST)
 ;
 ;* DG*5.3*572 changed "I"nternal references to "E"xternal references
POW(DGDATA,DFN,LSTDFN) ;POW STATUS INDICATED?
 ;   DGDATA - Data element array from LST, ^TMP("DGROFDA",$J)
 ;      DFN - Pointer to the PATIENT (#2) file
 ;   LSTDFN - Pointer to the patient data from the LST, in DGDATA
 N RSPOW    ;REQUESTING SITE POW STATUS INDICATED
 N LSTPOW   ;LAST SITE TREATED POW STATUS INDICATED
 S RSPOW=$$GET1^DIQ(2,DFN,.525)
 S LSTPOW=$G(@DGDATA@(2,LSTDFN_",",.525,"E"))
 ;If either of the POW STATUS INDICATED? flags
 ;are "N"o, don't file the POW data element(s)
 I (RSPOW="NO")!(LSTPOW="NO") D
 . N FIELD
 . F FIELD=.525:.001:.528 K @DGDATA@(2,LSTDFN_",",FIELD)
 Q
 ;
AO(DGDATA,DFN,LSTDFN) ;AGENT ORANGE EXPOSURE INDICATED?
 ;   DGDATA - Data element array from LST, ^TMP("DGROFDA",$J)
 ;      DFN - Pointer to the PATIENT (#2) file
 ;   LSTDFN - Pointer to the patient data from the LST, in DGDATA
 N RSAO    ;R.S. AGENT ORANGE EXPOSURE INDICATED
 N LSTAO   ;LST AGENT ORANGE EXPOSURE INDICATED
 S RSAO=$$GET1^DIQ(2,DFN,.32102)
 S LSTAO=$G(@DGDATA@(2,LSTDFN_",",.32102,"E"))
 ;If either of the AGENT ORANGE EXPOSURE INDICATED?
 ;flags are "N"o, delete the AO data element(s)
 I (RSAO="NO")!(LSTAO="NO") D
 . N FIELD
 . ;added AO LOCATION OF EXPOSURE (2/.3213) for DG*5.3*572  DJH
 . F FIELD=.32102,.32107,.32108,.32109,.3211,.3213 K @DGDATA@(2,LSTDFN_",",FIELD)
 Q
 ;
IR(DGDATA,DFN,LSTDFN) ;RADIATION EXPOSURE INDICATED?
 ;   DGDATA - Data element array from LST, ^TMP("DGROFDA",$J)
 ;      DFN - Pointer to the PATIENT (#2) file
 ;   LSTDFN - Pointer to the patient data from the LST, in DGDATA
 N RSIR    ;R.S. RADIATION EXPOSURE INDICATED
 N LSTIR   ;LST RADIATION EXPOSURE INDICATED
 S RSIR=$$GET1^DIQ(2,DFN,.32103)
 S LSTIR=$G(@DGDATA@(2,LSTDFN_",",.32103,"E"))
 ;If either of the RADIATION EXPOSURE INDICATED
 ;flags are "N"o, delete the IR data elements
 I (RSIR="NO")!(LSTIR="NO") D
 . N FIELD
 . F FIELD=.32103,.32111,.3212 K @DGDATA@(2,LSTDFN_",",FIELD)
 Q
 ;
DOD(DGDATA,DFN,LSTDFN) ;DATE OF DEATH
 ;Retrieve all DATE OF DEATH data elements, but instead of being filed,
 ;they will be placed into a mail message to the appropriate group.
 ;
 ;   DGDATA - Data element array from LST, ^TMP("DGROFDA",$J)
 ;      DFN - Pointer to the PATIENT (#2) file
 ;   LSTDFN - Pointer to the patient data from the LST, in DGDATA
 ;
 N DGMSG,FLD
 ;Only send messages if actual DOD is defined (field # .351) ;DG*5.3*572
 I $D(@DGDATA@(2,LSTDFN_",",.351)) D
 . D DODMAIL^DGROMAIL(DGDATA,DFN,LSTDFN)
 . S DGMSG(1)=" "
 . S DGMSG(2)="Date of Death information has been retrieved from the LST."
 . S DGMSG(3)="This information has NOT been filed into the patient's record."
 . S DGMSG(4)="A mail message has been sent to the Register Once mail group."
 . D EN^DDIOL(.DGMSG) R A:5
 ;Delete DoD fields from FDA array so they're not filed.
 F FLD=.351:.001:.355 K @DGDATA@(2,LSTDFN_",",FLD)   ;DG*5.3*572 - added .355
 Q
 ;
TA(DGDATA,LSTDFN) ;TEMPORARY ADDRESS
 ;   DGDATA - Data element array from LST, ^TMP("DGROFDA",$J)
 ;   LSTDFN - Pointer to the patient data from the LST, in DGDATA
 N LSTTAED ;LST TEMPORARY ADDRESS END DATE (EXTERNAL)
 N LSTTAEDF ;LST TEMPORARY ADDRESS END DATE FILEMAN (DG*5.3*572)
 S LSTTAED=$G(@DGDATA@(2,LSTDFN_",",.1218,"E"))
 ;*Convert External LST date to Fileman date (DG*5.3*572)
 S X=LSTTAED
 S %DT="RSN"
 D ^%DT
 S LSTTAEDF=Y
 ;If the TEMPORARY ADDRESS END DATE is less than the
 ;date of the query, delete the TA data elements
 I (LSTTAEDF>0),(LSTTAEDF<DT) D
 . N FIELD
 . F FIELD=.12105,.12111,.12112,.1211:.0001:.1219 K @DGDATA@(2,LSTDFN_",",FIELD)
 K X,%DT,Y
 Q
 ;
SP(DGDATA,DFN,LSTDFN) ;SENSITIVE PATIENT
 ;   DGDATA - Data element array from LST, ^TMP("DGROFDA",$J)
 ;      DFN - Pointer to the PATIENT (#2) file
 ;   LSTDFN - Pointer to the patient data from the LST, in DGDATA
 ;
 N RSSP    ;R.S. SENSITIVE PATIENT
 N LSTSP   ;LST SENSITIVE PATIENT
 S RSSP=$$GET1^DIQ(38.1,DFN,2)
 S LSTSP=$G(@DGDATA@(38.1,LSTDFN_",",2,"E"))
 ;
 ;* Remove code deleting Primary Eligibility Code (DG*5.3*572)
 ;* In all cases, delete Patient Type
 K @DGDATA@(2,LSTDFN_",",391)
 ;
 ;If the SENSITIVE PATIENT flag is received from the HEC -- OR -- if the
 ;flag is NOT received from both the HEC and LST, retrieve and file all
 ;Sensitive data elements, but NOT the fields for the Security Log file.
 I '((RSSP'="SENSITIVE")&(LSTSP="SENSITIVE")) D  I 1
 . K @DGDATA@(38.1)
 E  D
 . ;Otherwise (flag not received from the HEC but is from the LST),
 . ;send a mail message to the ISO and the "Register Once" mail
 . ;group that this patient is listed as Sensitive
 . D SPMAIL^DGROMAIL(DFN)
 . N DGMSG
 . S DGMSG(1)=" "
 . S DGMSG(2)="Sensitive Patient information has been retrieved from the LST."
 . S DGMSG(3)="This information has been filed into the patient's record."
 . S DGMSG(4)="A mail message has been sent to the Register Once mail group"
 . S DGMSG(5)="and the ISO explaining that this information has been received."
 . D EN^DDIOL(.DGMSG) R A:5
 Q
 ;
RE ;RACE AND ETHNICITY
 ;If the RACE AND ETHNICITY data not already
 ;populated, file it (already the basic rule)
 Q
 ;
CA(DGDATA,LSTDFN) ;CONFIDENTIAL ADDRESS
 ;   DGDATA - Data element array from LST, ^TMP("DGROFDA",$J)
 ;   LSTDFN - Pointer to the patient data from the LST, in DGDATA
 N LSTCAAF   ;LST CONFIDENTIAL ADDRESS ACTIVE FLAG
 N LSTCAED   ;LST CONFIDENTIAL ADDRESS END DATE
 N LSTCAEDF ;LST CONFIDENTIAL ADDRESS END DATE FILEMAN (DG*5.3*572)
 S LSTCAAF=$G(@DGDATA@(2,LSTDFN_",",.14105,"E"))
 S LSTCAED=$G(@DGDATA@(2,LSTDFN_",",.1418,"E"))
 ;*Convert LSTCAED to Fileman format date for compare (DG*5.3*572)
 S X=LSTCAED
 S %DT="RSN"
 D ^%DT
 S LSTCAEDF=Y
 ;If the CONFIDENTIAL ADDRESS FLAG from the Last Site Treated is "N"o,
 ;  OR  if the C.A. END DATE from the LST is less than the Query date,
 ;delete the C.A. data elements
 I (LSTCAAF'="YES")!((LSTCAEDF>0)&(LSTCAEDF<DT)) D
 . N FIELD
 . F FIELD=.14105,.14111,.1411:.0001:.1418 K @DGDATA@(2,LSTDFN_",",FIELD)
 . K @DGDATA@(2.141)
 ;Else the Confidential Address information will be filed
 ;and a User Interface message will be displayed.
 E  D
 . N DGMSG
 . N DATEFM ;*DATE converted to Fileman format (DG*5.3*572)
 . S DGMSG(1)=" "
 . S DGMSG(2)="Confidential Address information has been retrieved from the LST."
 . S DGMSG(3)="This information has been filed into the patient's record."
 . S DATE=$G(@DGDATA@(2,LSTDFN_",",.1417,"E"))
 . ;* Convert DATE to FM format (DG*5.3*572)
 . K X,%DT,Y
 . S X=DATE
 . S %DT="RSN"
 . D ^%DT
 . S DATEFM=Y
 . I DATEFM>DT D
 . . S DGMSG(4)="   NOTE:  Confidential Address Start Date is in the future, "_DATE
 . . S DGMSG(5)=" "
 . D EN^DDIOL(.DGMSG) R A:5
 K X,%DT,Y
 Q
 ;
PA(DGDATA,LSTDFN) ;PERMANENT ADDRESS
 ;   DGDATA - Data element array from LST, ^TMP("DGROFDA",$J)
 ;   LSTDFN - Pointer to the patient data from the LST, in DGDATA
 N LSTBAI   ;LST BAD ADDRESS INDICATOR
 S LSTBAI=$G(@DGDATA@(2,LSTDFN_",",.121,"E"))
 ;If the BAD ADDRESS INDICATOR from LST is NOT null,
 ;delete the PERMANENT ADDRESS data elements
 I LSTBAI'="" D
 . N FIELD
 . F FIELD=.1112,.111:.001:.119,.12,.121 K @DGDATA@(2,LSTDFN_",",FIELD)
 Q
