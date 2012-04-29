PPPVPP ;ALB/JFP - Environment check for PPP ; 01 MAR 94
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; This routine contains environmental checks which get executed
 ; before the initialization is allowed to run.  DIFQ is killed
 ; if problem encountered.
 ;
EN ;
 N XQABT1
 ;
 S XQABT1=$H
 S IOP="HOME" D ^%ZIS
 W !!,">>> Checking for required packages"
 D DUZ,ENV2:$D(DIFQ)
 Q
 ;
DUZ ; check to see if valid user defined and DUZ(0)="@"
 ;
 N X
 S X=$O(^VA(200,+$G(DUZ),0))
 I X']""!($G(DUZ(0))'="@") W !!?3,"The variable DUZ must be set to a valid entry in the NEW PERSON file",!?3,"and the variable DUZ(0) must equal ""@"" before you continue!" K DIFQ
 Q
 ;
 ;
ENV ; environmental check to make sure required packages/patches are
 ; installed.
 ;
 W !
 I $G(^DG(43,1,"VERSION"))<5.3 W !?3,*7,"ERROR... MAS Version 5.3 is required for PPP v1.0" K DIFQ
 E  W !," - MAS v5.3 (OK)"
 I +$G(^PS(59.7,1,49.99))<6 W !?3,*7,"ERROR... Outpatient PHARMACY Version 6.0 is required for PPP v1.0" K DIFQ
 E  W !," - Outpatient PHARMACY v6.0 (OK)"
 I '$D(^VAT(394.61)) W !?3,*7,"ERROR... PDX Version 1.5 is required for PPP v1.0" K DIFQ
 E  W !," - PDX v1.5 (OK)"
 I '$D(^VAMP(394.99)) W !?3,*7,"ERROR... MPD v1.0 is required for PPP v1.0" K DIFQ
 E  W !," - MPD v1.0 (OK)"
 Q
 ;
ENV2 ; environmental check to make sure required packages/patches are
 ; installed.  Uses utility in KERNEL v7.2
 ;
 W !
 I $$VERSION^XPDUTL("DG")<5.3 W !?3,*7,"ERROR... MAS Version 5.3 is required for PPP v1.0" K DIFQ
 E  W !," - MAS v5.3 (OK)"
 I $$VERSION^XPDUTL("PSO")<6 W !?3,*7,"ERROR... Outpatient PHARMACY Version 6.0 is required for PPP v1.0" K DIFQ
 E  W !," - Outpatient PHARMACY v6.0 (OK)"
 I $$VERSION^XPDUTL("VAQ")<1.5 W !?3,*7,"ERROR... PDX Version 1.5 is required for PPP v1.0" K DIFQ
 E  W !," - PDX v1.5 (OK)"
 I $$VERSION^XPDUTL("VAM")<1.0 W !?3,*7,"ERROR... MPD v1.0 is required for PPP v1.0" K DIFQ
 E  W !," - MPD v1.0 (OK)"
 Q
 ;
