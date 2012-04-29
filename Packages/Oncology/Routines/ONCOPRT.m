ONCOPRT ;Hines OIFO/GWB - Oncology reports ;05/05/00
 ;;2.11;ONCOLOGY;**24,25,26,27,36**;Mar 07, 1995
 ;This routine invokes Integration Agreement #3151
 ;
 ;[SUS *..Casefinding/Suspense ...]
SUS ;[SP Print Suspense List by Suspense Date (132c)]
 S BY="@75,INTERNAL(#3),75,.01,75,2;S1"
 S (FR,TO)=DUZ(2)_",?"
 S FLDS="[ONCO SUSPENSE]"
 G PRT60
 ;
DI ;[DI Disease Index]
 ;This option invokes Integration Agreement #3151
 S OSPIEN=$O(^ONCO(160.1,"C",DUZ(2),0))
 S AFLDIV=""
 I $O(^ONCO(160.1,OSPIEN,6,0)) D
 .S ADIEN=0 F  S ADIEN=$O(^ONCO(160.1,OSPIEN,6,ADIEN)) Q:ADIEN'>0  S AFLDIV=AFLDIV_^ONCO(160.1,OSPIEN,6,ADIEN,0)_U
 S DIC="^AUPNVPOV(",L=0
 S BY="[ONC DISEASE INDEX]"
 S FLDS="[ONC DISEASE INDEX]"
 S DIS(0)="I $$DIDIV^ONCFUNC(D0)=""Y"""
 D EN1^DIP
 K AFLDIV,ADIEN,OSPIEN
 G EX
 ;
STD ;[TD Print Suspense List by Month/Terminal Digit (132c)]
 S BY="@75,INTERNAL(#3),#75,+12;S1;C27,@TERMINAL DIGIT;S1"
 S (FR,TO)=DUZ(2)_",?,?"
 S FLDS="[ONCO SUSPENSE]",DHD="[ONCO SUSPENSE/TERMDIG-HDR]"
 G PRT60
 ;
SAT ;[CS Print Complete Suspense List by Term Digit (132c)]
 S BY="@75,INTERNAL(#3),75,.01,@TERMINAL DIGIT;S1"
 S (FR,TO)=DUZ(2)
 S FLDS="[ONCO SUSPENSE]",DHD="[ONCO SUSPENSE-ALL/TERMDIG-HDR]"
 W !!?10,"This option produces a list for requesting all charts"
 W !?10,"that are currently in suspense.",!
 G PRT60
 ;
DNP ;[NP Oncology Patient List-NO Primaries/Suspense]
 S BY="@75,INTERNAL(#3),@NO PRIMARY;L1,NAME"
 S (FR,TO)=DUZ(2)
 S FLDS="[ONCO PATIENT ONLY]"
 G PRT60
 ;
 ;[ABS *..Abstracting/Printing ...]
ABI ;[NC Print Abstract NOT Complete List]
 S BY="[ONCO ABSTRACT NOT-COMPLETE]"
 G PRT655
 ;
 ;[FOL *..Follow-up Functions ...]
PFH ;[FH Patient Follow-up History]
 D PAT I Y'<0 D  G EX
 .S BY="@NUMBER"
 .S (FR,TO)=+Y
 .S FLDS="[ONCO FOLLOWUP HISTORY]"
 .D PRT60
 Q
 ;
DAD ;[FA Print Due Follow-up/Admission List]
 W ! S (BY,FLDS)="[ONCO DUE FOLLOWUP-ADM/DIS]"
 S DIS(0)="I $$PFTD^ONCFUNC(D0)=""Y"""
 G PRT60
 ;
DUF ;[DF Print Due Follow-up List by Month Due]
 W ! S (BY,FLDS)="[ONCO DUE FOLLOWUP]"
 S DIS(0)="I $$PFTD^ONCFUNC(D0)=""Y"""
 G PRT60
 ;
DTD ;[TD Print Due Follow-up List by 'Terminal Digit']
 W ! S (BY,FLDS)="[ONCO DUE FOLLOWUP/TERMDIG]"
 S DIS(0)="I $$PFTD^ONCFUNC(D0)=""Y"""
 G PRT60
 ;
DEL ;[LF Print Delinquent (LTF) List]
 W !!?5,"The FOLLOW-UP STATUS will be changed from ACTIVE to (LTF)."
 W !?5,"After 15 months the patient is considered LOST TO FOLLOW-UP."
 W !! S (BY,FLDS)="[ONCO DELINQUENT(LTF) LIST]"
 S DIS(0)="I $$PFTD^ONCFUNC(D0)=""Y"""
 G PRT60
 ;
FST ;[SR Follow-up Status Report by Patient (132c)]
 W ! S (BY,FLDS)="[ONCO FOLLOWUP STATUS RPT]"
 S DIS(0)="I $$PFTD^ONCFUNC(D0)=""Y"""
 G PRT60
 ;
 ;[FP Follow-up Procedures Menu ...]
PFR ;[FR Individual Follow-up Report]
 D PAT I Y'<0 D  G EX
 .S BY="@NUMBER"
 .S (FR,TO)=+Y
 .S FLDS="[ONCO FOLLOWUP PATIENT RPT]"
 .D PRT60
 Q
 ;
ACOS80 ;[AA Accession Register-ACOS (80c)]
 S (BY,FLDS)="[ONCO ACCREG-ACOS80]" D HA G PRT655
 ;
AC80ST ;[AS Accession Register-Site (80c)]
 S (BY,FLDS)="[ONCO ACCREG-SITE/GP80]" D HA G PRT655
 ;
EOAC ;[AE Accession Register-EOVA (132c)]
 S (BY,FLDS)="[ONCO ACCREG-EOVA132]" D HA G PRT655
 ;
HA ;Help for Accession Registers
 W !!?3,"For a complete register:"
 W !?5,"START WITH ACC/SEQ NUMBER: FIRST// <Enter>"
 W !!?3,"For a single accession year (e.g. 1999):"
 W !,?5,"START WITH ACC/SEQ NUMBER: FIRST// 1999-00000"
 W !,?5,"GO TO ACC/SEQ NUMBER: LAST// 1999-99999"
 W !!?3,"For a single patient (e.g. 1999-00001):"
 W !,?5,"START WITH ACC/SEQ NUMBER: FIRST// 1999-00001/00"
 W !,?5,"GO TO ACC/SEQ NUMBER: LAST// 1999-00001/99"
 W !
 Q
 ;
ACOSPT ;[PA Patient Index-ACOS (132c)]
 S BY="NAME",(FR,TO)=""
 S FLDS="[ONCO PATIENT INDX-ACOS]"
 S DIS(0)="I $$PFTD^ONCFUNC(D0)=""Y"""
 G PRT60
 ;
PAT80 ;[PS Patient Index-Site (80c)]
 S BY="NAME"
 S (FR,TO)=""
 S FLDS="[ONCO PATIENT INDX80]"
 S DIS(0)="I $$PFTD^ONCFUNC(D0)=""Y"""
 G PRT60
 ;
EOVA ;[PE Patient Index-EOVA (132c)]
 S BY="NAME"
 S (FR,TO)=""
 S FLDS="[ONCO PATIENT INDX-EOVA132]"
 S DIS(0)="I $$PFTD^ONCFUNC(D0)=""Y"""
 G PRT60
 ;
ICD80 ;[IN Primary ICDO Listing (80c)]
 S (BY,FLDS)="[ONCO ICDO-SITE80]"
 G PRT655
 ;
SIT80 ;[SG Primary Site/GP Listing (80c)]
 S (BY,FLDS)="[ONCO SITE/GP80]"
 G PRT655
 ;
ICD132 ;[IW Primary ICDO Listing (132c)]
 S (BY,FLDS)="[ONCO ICDO-SITE132]"
 G PRT655
 ;
PAT ;ONCOLOGY PATIENT (160) lookup
 W !
 S DIC="^ONCO(160,",DIC(0)="AEQM",DIC("A")=" Select Patient Name: "
 D ^DIC K DIC W !
 Q
 ;
PRT60 ;Print ONCOLOGY PATIENT (160) file
 S DIC="^ONCO(160,",L=0 D EN1^DIP G EX
 ;
PRT655 ;Print ONCOLOGY PRIMARY (165.5) file
 S DIC="^ONCO(165.5,",L=0 D EN1^DIP G EX
 ;
EX K DIC,DIS,BY,FR,TO,FLDS,L,Y
 Q
