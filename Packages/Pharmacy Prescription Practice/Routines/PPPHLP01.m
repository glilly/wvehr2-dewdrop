PPPHLP01 ;ALB/JFP - PPP, HELP MESSAGES;01JAN94
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**37**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
HLPDOM1 ; -- Displays options for call to domain
 W !!,?2,"The network address of the Institution entered"
 W !,?2,"(ie: BOSTON would have BOSTON.MED.VA.GOV as its domain)",!
 W !,?2,"(Note: The system will try to match the institution with"
 W !,?2,"       the correct Domain, this Domain can be overwritten"
 W !,?2,"       Also the domain is not always in the format: "
 W !,?2,"       (Institution Name.MED.VA.GOV )"
 QUIT
 ;
HLPD1 ; -- Displays domain
 S DIC="^DIC(4.2,"
 S DIC(0)="C"
 S D="B"
 D DQ^DICQ
 K DIC,D
 QUIT
 ;
HLPXREF ; -- Display single question mark help for add/edit FFXE
 W !,?2,"Enter Patient Name (last,first middle) or SSN"
 QUIT
 ;
HLPX1 ; -- Displays entries in FFXE for ?? processing
 S DIC="^PPP(1020.2,"
 S DIC(0)="C"
 S D="B"
 D DQ^DICQ
 K DIC,D
 I Y>0 D HLPX2
 QUIT
 ;
HLPX2 ; -- Displays entries in PATIENT file for ?? processing
 S DIC="^DPT("
 S DIC(0)="C"
 S D="B"
 D DQ^DICQ
 K DIC,D
 QUIT
 ;
HLPINST1 ; -- Display single question mark help for institution
 W !,?2,"Answer with Institution Name, or Station Number"
 QUIT
 ;
HLPI1 ; -- Displays institutions associated with patient entered
 D CLEAR^VALM1
 S DIC="^DIC(4,"
 S DIC(0)="C"
 S D="B"
 D DQ^DICQ
 K DIC,D
 QUIT
 ;
 N INSTIFN,PPPCNT
 ;
 S INSTIFN=""
 S PPPCNT=0
 F  D  Q:INSTIFN=""
 .S PPPCNT=PPPCNT+1
 .S INSTIFN=$O(^PPP(1020.2,"APOV",PATDFN,INSTIFN))
 .W:INSTIFN'="" !,?5,$$GETSTANM^PPPGET1(INSTIFN)
 I PPPCNT=0 W !,?2,"No institution(s) found for patient entered"
 QUIT
 ;
 ;
END ; -- End of code
 QUIT
