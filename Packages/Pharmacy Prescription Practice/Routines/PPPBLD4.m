PPPBLD4 ;ALB/DMB - ADD NEW PATS TO FFX FROM CDROM ; 3/9/92
 ;;1.0;PHARMACY PRESCRIPTION PRACTICE;**38**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
NEWPAT ;
 ;
 N BFFXEND,BFFXSTRT,EXCARRY,INARRY,OUTARRY,LKUPERR,TMP,RESULT
 N LOGMSG,STANO,UCI,ZERONODE,NOSSNERR
 ;
 S PPPMRT="NEWPAT_PPPBLD4"
 S LKUPERR=-9003
 S NOSSNERR=-9017
 S BFFXSTRT=1012
 S BFFXEND=1013
 ;
 ; Initialize the input, output and exclusion arrays.
 ; Note: Leave off the ^ as we will add it later.
 ;
 S INARRY="TMP(""PPP"","_$J_",""IN"")"
 S OUTARRY="TMP(""PPP"","_$J_",""OUT"")"
 S EXCARRY="TMP(""PPP"","_$J_",""EXC"")"
 S SSNARRY="^PPP(1020.7,""B"")"
 ;
 ; Log start of routine.
 ;
 S TMP=$$LOGEVNT^PPPMSC1(BFFXSTRT,PPPMRT)
 ;
 ;VMP OIFO BAY PINES;ELR;PPP*1*38
 S X="MPIF001" X ^%ZOSF("TEST") I '$T D  Q
 .S TMP=$$LOGEVNT^PPPMSC1(LKUPERR,PPPMRT,"MPI not Installed")
 .S PPPTMP(1)="CDROM^PPPBLD3 -> MPI not installed."
 .S TMP=$$SNDBLTN^PPPMSC1("PPP NOTIFICATION","PRESCRIPTION PRACTICES","PPPTMP(")
 .K PPPMRT,PPPTMP
 ; Get the station number from the parameter file.
 ;
 S STANO=$P($G(^PPP(1020.1,1,0)),"^",9)
 I STANO="" D  Q
 .S TMP=$$LOGEVNT^PPPMSC1(LKUPERR,PPPMRT,"Station Number Not Found")
 .S PPPTMP(1)="CDROM^PPPBLD3 -> Station Number Not In Parameter File"
 .S TMP=$$SNDBLTN^PPPMSC1("PPP NOTIFICATION","PRESCRIPTION PRACTICES","PPPTMP(")
 .K PPPMRT,PPPTMP
 ;
 ; Get the UCI from Kernel.
 ;VMP OIFO BAY PINES;ELR;PPP*1*38
 ;removed getting uci and setting extended reference for "TMP" global
 ;
 ; Build the required variables
 ;
 S INARRY="^"_INARRY
 S OUTARRY="^"_OUTARRY
 S EXCARRY="^"_EXCARRY
 S @EXCARRY@(STANO)=""
 ; Check for SSN's to process
 ;
 I '$D(@SSNARRY) D  Q
 .S TMP=$$LOGEVNT^PPPMSC1(NOSSNERR,PPPMRT)
 .K PPPMRT
 ;
 ; Copy the New SSN File to the inarry.
 ;
 S %X="^PPP(1020.7,""B"","
 S %Y="^TMP(""PPP"","_$J_",""IN"","
 D %XY^%RCR
 ;
 ; Now call the build routine.
 ;
 S RESULT=$$BFFX^PPPBLD1(INARRY,OUTARRY,EXCARRY,"")
 ;
 ;VMP OIFO BAY PINES;ELR;PPP*1*38
 ;removed setting ZERO NODE MANUALLY USE ^DIK IN PPPBLD1A
 ;
 ; Log the end of the routine.
 ;
 S LOGMSG="Result: "_$P(RESULT,"^")_", New Entries: "_$P(RESULT,"^",2)_", Edited Entries: "_$P(RESULT,"^",3)
 S TMP=$$LOGEVNT^PPPMSC1(BFFXEND,PPPMRT,LOGMSG)
 K PPPMRT,PPPTMP,@INARRY,@OUTARRY,@EXCARRY
 Q
