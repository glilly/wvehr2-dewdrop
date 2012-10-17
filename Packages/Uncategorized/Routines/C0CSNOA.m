C0CSNOA   ; CCDCCR/GPL - SNOMED CT ANALYSIS ROUTINES; 10/14/08
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;Copyright 2008,2009 George Lilly, University of Minnesota.
        ;Licensed under the terms of the GNU General Public License.
        ;See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        ; THESE ROUTINES ANALYZE THE POTENTIAL RETRIEVAL OF SNOMED CT CODES
        ; FOR PATIENT DRUG ALLERGIES FOR INCLUSION IN THE CCR OR CCD
        ; USING THE VISTA LEXICON ^LEX
        ;
ANALYZE(BEGIEN,IENCNT)  ; SNOMED RETRIEVAL ANALYSIS ROUTINE
           ; BEGINS AT BEGIEN AND GOES FOR IENCNT DRUGS IN GMRD
           ; TO RESUME AT NEXT DRUG, USE BEGIEN=""
           ; USE RESET^C0CSNOA TO RESET TO TOP OF DRUG LIST
           ;
           N SNOARY,SNOTMP,SNOI,SNOIEN,RATTR
           N CCRGLO
           D ASETUP ; SET UP VARIABLES AND GLOBALS
           D AINIT ; INITIALIZE ATTRIBUTE VALUE TABLE
           I '$D(@SNOBASE@("RESUME")) S @SNOBASE@("RESUME")=$O(@GMRBASE@(1)) ;1ST TME
           S RESUME=@SNOBASE@("RESUME") ; WHERE WE LEFT OFF LAST RUN
           S SNOIEN=BEGIEN ; BEGIN WITH THE BEGIEN RECORD
           I SNOIEN="" S SNOIEN=RESUME
           I +SNOIEN=0 D  Q  ; AT THE END OF THE ALLERGY LIST
           . W "END OF DRUG LIST, CALL RESET^C0CSNOA",!
           F SNOI=1:1:IENCNT  D  Q:+SNOIEN=0  ; FOR IENCNT NUMBER OF PATIENTS OR END
           . ;D CCRRPC^C0CCCR(.CCRGLO,SNOIEN,"CCR","","","") ;PROCESS THE CCR
           . W SNOIEN,@GMRBASE@(SNOIEN,0),!
           . N SNORTN,TTERM ; RETURN ARRAY
           . S TTERM=$P(@GMRBASE@(SNOIEN,0),"^",1)_" ALLERGY"
           . D TEXTRPC(.SNORTN,TTERM)
           . I $D(SNORTN) ZWR SNORTN
           . K @SNOBASE@("VARS",SNOIEN) ; CLEAR OUT OLD VARS
           . I $P(TTMP,"^",1)=1 S @SNOBASE@("VARS",SNOIEN)=TTERM_"^"_TTMP_"^"_SNORTN(0)
           . ;
           . ; EVALUATE THE VARIABLES AND CREATE AN ATTRIBUTE MAP
           . ;
           . S RATTR=$$SETATTR(SNOIEN) ; SET THE ATTRIBUTE STRING BASED ON THE VARS
           . S @SNOBASE@("ATTR",SNOIEN)=RATTR ; SAVE THE ATRIBUTES FOR THIS DRUG
           . ;
           . N CATNAME,CATTBL
           . S CATNAME=""
           . D CPUSH(.CATNAME,SNOBASE,"SNOTBL",SNOIEN,RATTR) ; ADD TO CATEGORY
           . ; W "CATEGORY NAME: ",CATNAME,!
           . ;
           . S SNOIEN=$O(@GMRBASE@(SNOIEN)) ; NEXT RECORD
           . S @SNOBASE@("RESUME")=SNOIEN ; WHERE WE ARE LEAVING OFF THIS RUN
           ; D PARY^C0CXPATH(@SNOBASE@("ATTRTBL"))
           Q
           ;
TEXTRPC(ORTN,ITEXT)     ; CALL THE LEXICON WITH ITEXT AND RETURN RESULTS IN ORTN
        ;
        ;N TTMP
        W ITEXT,!
        S TTMP=$$TEXT^LEXTRAN(ITEXT,"","","SCT","ORTN")
        Q
        ;
ASETUP  ; SET UP GLOBALS AND VARS SNOBASE AND SNOTBL
             I '$D(SNOBASE) S SNOBASE=$NA(^TMP("C0CSNO"))
             I '$D(@SNOBASE) S @SNOBASE=""
             I '$D(GMRBASE) S GMRBASE=$NA(^GMRD(120.82))
             I '$D(SNOTBL) S SNOTBL=$NA(^TMP("C0CSNO","SNOTBL","TABLE")) ; ATTR TABLE
             S ^TMP("C0CSNO","TABLES","SNOTBL")=SNOTBL ; TABLE OF TABLES
             Q
             ;
AINIT   ; INITIALIZE ATTRIBUTE TABLE
             I '$D(SNOBASE) D ASETUP ; FOR COMMAND LINE CALLS
             K @SNOTBL
             D APUSH^C0CRIMA(SNOTBL,"CODE")
             D APUSH^C0CRIMA(SNOTBL,"NOCODE")
             D APUSH^C0CRIMA(SNOTBL,"MULTICODE")
             D APUSH^C0CRIMA(SNOTBL,"SUBMULTI")
             D APUSH^C0CRIMA(SNOTBL,"DONE")
             Q
APOST(PRSLT,PTBL,PVAL)  ; POST AN ATTRIBUTE PVAL TO PRSLT USING PTBL
           ; PSRLT AND PTBL ARE PASSED BY NAME. PVAL IS A STRING
           ; PTBL IS THE NAME OF A TABLE IN @SNOBASE@("TABLES") - "SNOTBL"=ALL VALUES
           ; PVAL WILL BE PLACED IN THE STRING PRSLT AT $P(X,U,@PTBL@(PVAL))
           I '$D(SNOBASE) D ASETUP ; FOR COMMANDLINE PROCESSING
           N USETBL
           I '$D(@SNOBASE@("TABLES",PTBL)) D  Q  ; NO TABLE
           . W "ERROR NO SUCH TABLE",!
           S USETBL=@SNOBASE@("TABLES",PTBL)
           S $P(@PRSLT,U,@USETBL@(PVAL))=PVAL
           Q
SETATTR(SDFN)   ; SET ATTRIBUTES BASED ON VARS
           N SBASE,SATTR
           S SBASE=$NA(@SNOBASE@("VARS",SDFN))
           D APOST("SATTR","SNOTBL","DONE")
           I $P(TTMP,"^",1)=1 D APOST("SATTR","SNOTBL","CODE")
           I $P(TTMP,"^",1)=-1 D APOST("SATTR","SNOTBL","NOCODE")
           Q SATTR  ; C0C
           I $D(@SBASE@("PROBLEMS",1)) D  ;
           . D APOST("SATTR","SNOTBL","PROBLEMS")
           . ; W "POSTING PROBLEMS",!
           I $D(@SBASE@("VITALS",1)) D APOST("SATTR","SNOTBL","VITALS")
           I $D(@SBASE@("MEDS",1)) D  ; IF THE PATIENT HAS MEDS VARIABLES
           . D APOST("SATTR","SNOTBL","MEDS")
           . N ZR,ZI
           . D GETPA^C0CRIMA(.ZR,SDFN,"MEDS","MEDPRODUCTNAMECODEVALUE") ;CHECK FOR MED CODES
           . I ZR(0)>0 D  ; VAR LOOKUP WAS GOOD, CHECK FOR NON=NULL RETURN
           . . F ZI=1:1:ZR(0) D  ; LOOP THROUGH RETURNED VAR^VALUE PAIRS
           . . . I $P(ZR(ZI),"^",2)'="" D APOST("SATTR","SNOTBL","MEDSCODE") ;CODES
           . ; D PATD^C0CSNOA(2,"MEDS","MEDPRODUCTNAMECODEVALUE") CHECK FOR MED CODES
           D APOST("SATTR","SNOTBL","NOTEXTRACTED") ; OUTPUT NOT YET PRODUCED
           ; W "ATTRIBUTES: ",SATTR,!
           Q SATTR
           ;
RESET   ; KILL RESUME INDICATOR TO START OVER. ALSO KILL SNO TMP VALUES
           K ^TMP("C0CSNO","RESUME")
           K ^TMP("C0CSNO")
           Q
           ;
CLIST   ; LIST THE CATEGORIES
           ;
           I '$D(SNOBASE) D ASETUP ; FOR COMMAND LINE CALLS
           N CLBASE,CLNUM,ZI,CLIDX
           S CLBASE=$NA(@SNOBASE@("SNOTBL","CATS"))
           S CLNUM=@CLBASE@(0)
           F ZI=1:1:CLNUM D  ; LOOP THROUGH THE CATEGORIES
           . S CLIDX=@CLBASE@(ZI)
           . W "(",$P(@CLBASE@(CLIDX),"^",1)
           . W ":",$P(@CLBASE@(CLIDX),"^",2),") "
           . W CLIDX,!
           ; D PARY^C0CXPATH(CLBASE)
           Q
           ;
CPUSH(CATRTN,CBASE,CTBL,CDFN,CATTR)     ; ADD PATIENTS TO CATEGORIES
           ; AND PASS BACK THE NAME OF THE CATEGORY TO WHICH THE PATIENT
           ; WAS ADDED IN CATRTN, WHICH IS PASSED BY REFERENCE
           ; CBASE IS WHERE TO PUT THE CATEGORIES PASSED BY NAME
           ; CTBL IS THE NAME OF THE TABLE USED TO CREATE THE ATTRIBUTES,
           ; PASSED BY NAME AND USED TO CREATE CATEGORY NAMES IE "@CTBL_X"
           ; WHERE X IS THE CATEGORY NUMBER. CTBL(0) IS THE NUMBER OF CATEGORIES
           ; CATBL(X)=CATTR STORES THE ATTRIBUTE IN THE CATEGORY
           ; CDFN IS THE PATIENT DFN, CATTR IS THE ATTRIBUTE STRING
           ; THE LIST OF PATIENTS IN A CATEGORY IS STORED INDEXED BY CATEGORY
           ; NUMBER IE CTBL_X(CDFN)=""
           ;
           ; N CCTBL,CENTRY,CNUM,CCOUNT,CPATLIST
           S CCTBL=$NA(@CBASE@(CTBL,"CATS"))
           ; W "CBASE: ",CCTBL,!
           ;
           I '$D(@CCTBL@(CATTR)) D  ; FIRST PATIENT IN THIS CATEGORY
           . D PUSH^C0CXPATH(CCTBL,CATTR) ; ADD THE CATEGORY TO THE ARRAY
           . S CNUM=@CCTBL@(0) ; ARRAY ENTRY NUMBER FOR THIS CATEGORY
           . S CENTRY=CTBL_"_"_CNUM_U_0 ; TABLE ENTRY DEFAULT
           . S @CCTBL@(CATTR)=CENTRY ; DEFAULT NON INCREMENTED TABLE ENTRY
           . ; NOTE THAT P1 IS THE CATEGORY NAME MADE UP OF THE TABLE NAME
           . ; AND CATGORY ARRAY NUMBER. P2 IS THE COUNT WHICH IS INITIALLY 0
           ;
           S CCOUNT=$P(@CCTBL@(CATTR),U,2) ; COUNT OF PATIENTS IN THIS CATEGORY
           S CCOUNT=CCOUNT+1 ; INCREMENT THE COUNT
           S $P(@CCTBL@(CATTR),U,2)=CCOUNT ; PUT IT BACK
           ;
           S CATRTN=$P(@CCTBL@(CATTR),U,1) ; THE CATEGORY NAME WHICH IS RETURNED
           ;
           S CPATLIST=$NA(@CBASE@(CTBL,"IENS",CATRTN)) ; BASE OF PAT LIST FOR THIS CAT
           ; W "IENS BASE: ",CPATLIST,!
           S @CPATLIST@(CDFN)="" ; ADD THIS PATIENT TO THE CAT PAT LIST
           ;
           Q
           ;
REUSE   ; GET SAVED VALUES FROM ^TMP("C0CSAV") AND PUT THEM IN A DATABASE
        ;
        D ASETUP
        D AINIT
        N SNOI,SNOJ,SNOK,SNOSNO,SNOSEC,SNOIEN,SNOOLD,SNOSRCH
        S SAVBASE=$NA(^TMP("C0CSAV","VARS"))
        S SNOI=""
        F  D  Q:$O(@SAVBASE@(SNOI))="" ;THE WHOLE LIST
        . S SNOI=$O(@SAVBASE@(SNOI))
        . S SNOJ=@SAVBASE@(SNOI)
        . S SNOK=$P($P(SNOJ,"^",1)," ALLERGY",1)
        . S SNOSRCH=$P(SNOJ,"^",1) ;SEARCH TERM USED TO OBTAIN SNOMED CODE
        . S SNOIEN=$P(SNOJ,"^",3) ; IEN OF ELEMENT IN LEXICON
        . S SNOSNO=$P(SNOJ,"^",4) ; SNOMED CODE
        . S SNOSEC=$P(SNOJ,"^",5) ; SECTION OF SNOMED FOR THIS CODE
        . S SNOOLD=$P(SNOJ,"^",7) ; OLD NUMBER FOR THIS CODE
        . W "SEARCH:",SNOSRCH," IEN:",SNOIEN," CODE:",SNOSNO," SEC:",SNOSEC," OLD:",SNOOLD,!
        . W SNOK,!
        . W SNOJ,!
        Q
        ;
