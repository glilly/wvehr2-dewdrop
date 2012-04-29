PPPDSP1 ;ALB/DMB - PRESC. PRACT. DISPLAY ROUTINES ; 1/24/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
BANNER(BNRTXT) ; Clear the screen and print the banner
 ;
 N BLANKS,PARMERR,TAB,I
 ;
 S PARMERR=-9001
 I '$D(BNRTXT) Q PARMERR
 I $L(BNRTXT)>80 Q PARMERR
 ;
 S BLANKS=""
 S TAB=((IOM-$L(BNRTXT))\2)
 F I=1:1:TAB S BLANKS=BLANKS_" "
 ;
 W @IOF,BLANKS,BNRTXT
 ;
 Q 0
 ;
DSPFFX(TARRY,FFXIFN) ; Display an FFX entry
 ;
 ;
 N PARMERR
 ;
 S PARMERR=-9001
 ;
 I '$D(TARRY) Q PARMERR
 I '$D(@TARRY@(FFXIFN)) Q PARMERR
 ;
 W !,"Entry Number: ",FFXIFN,!
 W "Entry Date  : ",@TARRY@(FFXIFN,"ED"),!
 W "Entry Source: ",@TARRY@(FFXIFN,"SOURCE"),!!
 W "Patient Name: ",@TARRY@(FFXIFN,"NAME")
 W ?40,"SSN: ",@TARRY@(FFXIFN,"SSN"),!
 W "Station: ",@TARRY@(FFXIFN,"POV")
 W " (",@TARRY@(FFXIFN,"STANO"),")"
 W ?40,"Domain: ",@TARRY@(FFXIFN,"DOMAIN"),!
 W "Last Visit Date: ",@TARRY@(FFXIFN,"LVD")
 W ?40,"Last Batch Request: ",@TARRY@(FFXIFN,"LBRD"),!
 W "Last PDX Date: ",@TARRY@(FFXIFN,"LPDX")
 W ?40,"Status: ",@TARRY@(FFXIFN,"STATUS"),!
 Q 0
