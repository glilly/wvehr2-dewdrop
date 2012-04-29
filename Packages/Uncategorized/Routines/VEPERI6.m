VEPERI6 ;DAOU/WCJ - Interface Utilities ;2-MAY-2005
 ;;1.0;VOEB;;Jun 12, 2005
 ;;;VISTA OFFICE/EHR;
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ; Interface Utilities
 ; Log Error
 Q
 ; Save errors to error file.
 ; ERRFLAG - 0 just log
 ;           1 log and stop processing
 ; ERRTYP - grouping for reporting prpose
 ; ERRMSG - free text error
 ; HL7PTR - Points to the original message in  file 772
 ; HLP - Parsed HL7 message
 ;
FATALERR(ERRFLAG,ERRTYP,ERRMSG,HL7PTR,HLP) ;
 ;
 N NAME,FI,HL7DT
 S NAME=$$GETDATA^VEPERI3("PID",1000,6)
 S FI=$$GETDATA^VEPERI3("PID",1000,3)
 S HL7DT=$$GETDATA^VEPERI3("MSH",1000,6)
 S:'$D(HL7PTR) HL7PTR=""
 ;
 N ERRDT,DIC,X,DIE,Y,DA,DR
 ;
 S ERRDT=""""_$$NOW^XLFDT_""""
 S DIC="^VEPER(19904.2,",DIC(0)="L",X=ERRDT
 D ^DIC
 S DIE=DIC,DA=+Y
 K DR
 S DR=".02///^S X=NAME;.03////"_HL7PTR_";.04////"_FI_";.05////"_ERRTYP_";.06////"_HL7DT_";1.01////"_ERRMSG D ^DIE
 Q ERRFLAG_U_ERRTYP_U_ERRMSG
