PPPDSP4 ;ALB/JFP - PRINT OTHER FACLITIES ROUTINES ; 5/14/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; These routines control the display of other facilities
 ; via the list processor.
 ;
POF(PATDFN,TARRY) ; Print Other Facilities
 ;
 ; This is the main entry point for calling the list processor.
 ;  PATDFN - The patient internal entry number
 ;  TARRY  - This function takes the data contained in TARRY and
 ;           formats it for display in the list processor.
 ;
 N DIC,DR,DA,DIQ,DUOUT,DTOUT,U,PARMERR,PATSSN,PPPTMP
 N STANAME,LINEDATA,PDXDATA,LSTARRY
 ;
 S PARMERR=-9001
 S U="^"
 ;
 I $G(PATDFN)<1 Q PARMERR
 I '$D(@TARRY) Q PARMERR
 ;
 K XQORS,VALMEVL
 D EN^VALM("PPP VISITS")
 Q 0
 ;
HDR ; -- Writes out the header.
 ;
 S VALMHDR(1)=""
 S VALMHDR(2)="Patient: "_PATNAME_"  ("_$E(PATSSN,1,3)_"-"_$E(PATSSN,4,5)_"-"_$E(PATSSN,6,9)_")    DOB: "_$$I2EDT^PPPCNV1(PATDOB)
 Q
 ;
INIT ; -- Sets display array from data array
 ; Now order through the array and print the info.
 ;
 N TXTLINE
 ;
 S LSTARRY="^TMP(""PPPL3"",$J)" K @LSTARRY
 ;
 S DIC="^DPT(",DA=PATDFN,DR=".01;.03;.09",DIQ="PPPTMP" D EN^DIQ1
 S PATNAME=PPPTMP(2,PATDFN,.01)
 S PATDOB=$$E2IDT^PPPCNV1(PPPTMP(2,PATDFN,.03))
 S PATSSN=PPPTMP(2,PATDFN,.09)
 K PPPTMP,DIC,DR,DA,DTOUT,DUOUT
 ;
 S VALMCNT=0
 S (TXTLINE,STANAME)=""
 F  S STANAME=$O(@TARRY@(STANAME)) Q:STANAME=""  D
 .S LINEDATA=$G(@TARRY@(STANAME,2))
 .S TXTLINE=$$SETFLD^VALM1($E($P(LINEDATA,U),1,18),TXTLINE,"STATION")
 .S TXTLINE=$$SETFLD^VALM1($S(+$P(LINEDATA,U,2)'<0:$P(LINEDATA,U,2),1:"UNKNOWN"),TXTLINE,"LASTPDX")
 .S TXTLINE=$$SETFLD^VALM1($P(LINEDATA,U,3),TXTLINE,"STATUS")
 .S TXTLINE=$$SETFLD^VALM1($P(LINEDATA,U,4),TXTLINE,"PHDATA")
 .D SETL
 .I @TARRY@(STANAME,0)>0 D
 ..S PDXDATA=@TARRY@(STANAME,1)
 ..I PATNAME'=$P(PDXDATA,U,1) D
 ...S TXTLINE="  Warning... PDX Name ("_$P(PDXDATA,U,1)_") Does Not Equal Local Name."
 ...D SETL
 ..I PATDOB'=$P(PDXDATA,U,2) D
 ...S TXTLINE="  Warning... PDX DOB ("_$$I2EDT^PPPCNV1($P(PDXDATA,U,2))_") Does Not Equal Local DOB."
 ...D SETL
 Q
 ;
FNL ; -- Clean Up
 ;
 K @LSTARRY
 K PATNAME,PATDOB
 Q
 ;
SETL ; -- Sets up list manager diplay array
 S VALMCNT=VALMCNT+1
 S @LSTARRY@(VALMCNT,0)=$E(TXTLINE,1,79)
 Q
 ;
OTH ; -- Diplays other facilities only
 W !!,"Collecting Pharmacy Data...Please Wait!"
 D DSPMED^PPPDSP3(PATDFN,TARRY,"O")
 S TMP=$$STATUPDT^PPPMSC1(9,1)
 Q
 ;
BOTH ; -- Displays both other facilities and local facility
 W !!,"Collecting Pharmacy Data...Please Wait!"
 D DSPMED^PPPDSP3(PATDFN,TARRY,"B")
 S TMP=$$STATUPDT^PPPMSC1(9,1)
 Q
 ;
END ; -- End of code
 Q
 ;
