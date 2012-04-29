PPPCHK1 ; ALB/DMB - PATIENT FILE CHECK ROUTINES ; 4/28/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
EN ; Check the patient file "B" and "SSN" xref
 ;
 S ENTRIES=$P($G(^DPT(0)),"^",4)
 W !,"Checking ""B"" Xref"
 S BENTRIES=$$CHKXREF("B")
 W !,"Checking ""SSN"" Xref"
 S SENTRIES=$$CHKXREF("SSN")
 W !,"Total Entries Per Header Node --> ",ENTRIES
 W !,"Total Entries In ""B"" Xref ----> ",BENTRIES
 W !,"Total Entries In ""SSN"" Xref --> ",SENTRIES
 Q
 ;
CHKXREF(XREFNAME) ; Count the entries in the xref
 ;
 N NAME,IFN,CNT
 ;
 S (IFN,NAME)="",CNT=0
 F  S NAME=$O(^DPT(XREFNAME,NAME)) Q:NAME=""  D
 .F  S IFN=$O(^DPT(XREFNAME,NAME,IFN))  Q:IFN=""  D
 ..S CNT=CNT+1
 ..I '(CNT#100) W "."
 Q CNT
