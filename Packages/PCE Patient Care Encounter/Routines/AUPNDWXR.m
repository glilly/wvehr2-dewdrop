AUPNDWXR ;IHS/SD/SDR - Routine to populate DW Audit file - [ 04/15/2004  9:49 AM ]
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;
 ; This routine will be used to populate the DW Audit file
 ; (^AUPNDWAF) for exporting edited patients to the Data
 ; Warehouse.  The patients are actually exported using code for
 ; the DW (BDW namespace).   Entries are purged once an export has been
 ; done and the process starts over.
 ;
 ; The fields are divided into 5 categories with the following fields
 ; in each category:
 ;
 ; BASE:
 ;     Date of Birth
 ;     Date of Death
 ;     Underlying Cause of Death
 ;     Sex
 ;     SSN
 ;     SSN Verification Status
 ;     Father's Full Name
 ;     Mother's Maiden Name
 ; DEMOGRAPHIC:
 ;     Patient's Full Name
 ;     Mailing Address Street
 ;     Mailing Address City
 ;     Mailing Address State
 ;     Mailing Address Zip
 ;     Community of Residence
 ;     Date Moved to Community
 ;     Eligibility for Services Code
 ;     Veteran Eligible
 ;     Classification Code
 ;     Tribe Code
 ;     Blood Quantum
 ;     Reg Record Status Code
 ; ALIAS:
 ;     Alias Full Name
 ; CHART:
 ;     Chart Facility Code
 ;     Chart Number (HRN)
 ;     Chart Status Code
 ; INSURANCE ELIGIBILITY:
 ;     Coverage Type (Medicare/Railroad/Medicaid/PI)
 ;     Eligibility Begin Date (Medicare/Railroad/Medicaid/PI)
 ;     Policy Number (Medicaid/PI)
 ;     Medicaid State of Eligibility
 ;     Medicaid Plan Name
 ;     Insurer Name (Medicare/Railroad/Medicaid/PI)
 ;     Eligibility End Date (Medicare/Railroad/Medicaid/PI)
 ;     Prefix/Suffix (Medicare/Railroad/Medicaid)
 ;     Policy Holder Name (PI)
 ;     Relationship to Insured (Medicaid/PI)
 ;     Date of Last Update (Medicaid)
 ;
SET(AUPNDFN,CAT) ; EP
 I $G(DUZ("AG"))="E" Q  ;Line added DAOU/JLG  2/9/05  VistaOffice does not use this.
 S CAT=$S(CAT="BASE":2,CAT="DEMO":4,CAT="ALIAS":6,CAT="CHART":8,CAT="ELIG":11)
 S $P(^AUPNDWAF(AUPNDFN,0),"^",1)=AUPNDFN
 S ^AUPNDWAF("B",AUPNDFN,AUPNDFN)=""  ;IHS/CMI/LAB added b index to fileman file
 S $P(^AUPNDWAF(AUPNDFN,0),"^",CAT)=DT
 Q
KILL(AUPNDFN,CAT) ;    EP
 D SET(AUPNDFN,CAT)
 Q
 ;
