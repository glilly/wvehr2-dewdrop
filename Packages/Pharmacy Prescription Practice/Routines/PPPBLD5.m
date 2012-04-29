PPPBLD5 ;ALB/DMB - ADD NEW PATS TO FFX FROM CDROM ; 5/14/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
NEWSSN ;
 ; This routine is intended to be a background task which
 ; checks a new SSN against MDP.  It is called via a MUMPS
 ; cross-reference on the SSN field of the NEW SSN File.
 ; It expects to have the variables PPPSSN and PPPIFN
 ; defined on input.
 ;
 ; PPPSSN = The new SSN being added
 ; PPPIFN = The entry number for that SSN in teh New SSN file
 ;
 N BFFXEND,BFFXSTRT,EXCARRY,INARRY,OUTARRY,LKUPERR,TMP,RESULT
 N LOGMSG,STANO,UCI,ZERONODE,NOSSNERR,LSTPROC
 ;
 S PPPMRT="NEWSSN_PPPBLD5"
 S LKUPERR=-9003
 S NOSSNERR=-9017
 S BFFXSTRT=1012
 S BFFXEND=1013
 S LSTPROC=""
 ;
 ; Initialize the input, output and exclusion arrays.
 ; Note: Leave off the ^ as we will add it later.
 ;
 S INARRY="TMP(""PPP"","_$J_",""IN"")"
 S OUTARRY="TMP(""PPP"","_$J_",""OUT"")"
 S EXCARRY="TMP(""PPP"","_$J_",""EXC"")"
 ;
 ; Log start of routine.
 ;
 S TMP=$$LOGEVNT^PPPMSC1(BFFXSTRT,PPPMRT)
 ;
 ; Get the station number from the parameter file.
 ;
 S STANO=$P($G(^PPP(1020.1,1,0)),"^",9)
 I STANO="" D  Q
 .S TMP=$$LOGEVNT^PPPMSC1(LKUPERR,PPPMRT,"Station Number Not Found")
 .S PPPTMP(1)="CDROM^PPPBLD3 -> Station Number Not In Parameter File"
 .S TMP=$$SNDBLTN^PPPMSC1("PPP NOTIFICATION","PRESCRIPTION PRACTICES","PPPTMP(")
 .K PPPMRT,PPPTMP
 ;
 ; Get the UCI from Parameter File.
 ;
 S UCI=$$GETUCI^PPPGET3("TMP")
 I UCI="" D  Q
 .S TMP=$$LOGEVNT^PPPMSC1(LKUPERR,PPPMRT,"UCI Not Found")
 .S PPPTMP(1)="CDROM^PPPBLD3 -> UCI not available via Kernel call."
 .S TMP=$$SNDBLTN^PPPMSC1("PPP NOTIFICATION","PRESCRIPTION PRACTICES","PPPTMP(")
 .K PPPMRT,PPPTMP
 ;
 ; Build the required variables
 ;
 S INARRY="^"_UCI_INARRY
 S OUTARRY="^"_UCI_OUTARRY
 S EXCARRY="^"_UCI_EXCARRY
 S @EXCARRY@(STANO)=""
 ;
 ; Check for SSN's to process
 ;
 I '$D(PPPSSN) D  Q
 .S TMP=$$LOGEVNT^PPPMSC1(NOSSNERR,PPPMRT)
 .K PPPMRT
 ;
 ; Copy the New SSN File to the inarry.
 ;
 K @INARRY
 S @INARRY@(PPPSSN)=""
 ;
 ; Now call the build routine.
 ;
 S RESULT=$$BFFX^PPPBLD1(INARRY,OUTARRY,EXCARRY,LSTPROC)
 I +RESULT'<0 D
 .;
 .; Get the station numbers from the FFX file and send PDX's
 .;
 .S PATDFN=+$$GETDFN^PPPGET1(PPPSSN)
 .K PPPTMP,PPPERR
 .S TMP=$$BSA(PATDFN,"PPPTMP")
 .S PPPERR(1)="An error occurred while attempting to send a PDX from NEWSSN."
 .S PPPERR(2)=""
 .S TMP=$$SNDPDX^PPPPDX1(PATDFN,"PPPTMP","PPPERR")
 .I $D(PPPERR(3)) D
 ..S TMP=$$SNDBLTN^PPPMSC1("PPP NOTIFICATION","PRESCRIPTION PRACTICES","PPPERR(")
 .S TMP=$$STATUPDT^PPPMSC1(8,1)
 .K PPPTMP,PPPERR
 .;
 .; Kill the entry in the NEWSSN file.
 .;
 .S DIK="^PPP(1020.7,"
 .S DA=PPPIFN
 .D ^DIK
 ;
 ; Log the end of the routine.
 ;
 S LOGMSG="Result: "_$P(RESULT,"^")_", New Entries: "_$P(RESULT,"^",2)_", Edited Entries: "_$P(RESULT,"^",3)
 S TMP=$$LOGEVNT^PPPMSC1(BFFXEND,PPPMRT,LOGMSG)
 K PPPSSN,PPPIFN,PPPMRT,PPPTMP,@INARRY,@OUTARRY,@EXCARRY
 Q
 ;
BSA(PATDFN,STARRAY) ; Build the station array
 ;
 N TOTSTA,STAPTR,FFXIFN
 ;
 S TOTSTA=0
 F STAPTR=0:0 S STAPTR=$O(^PPP(1020.2,"APOV",PATDFN,STAPTR)) Q:STAPTR=""  D
 .S FFXIFN=$O(^PPP(1020.2,"APOV",PATDFN,STAPTR,"")) Q:FFXIFN=""
 .I '$D(^PPP(1020.5,"B",STAPTR)) S @STARRAY@(STAPTR)="",TOTSTA=TOTSTA+1
 Q TOTSTA
