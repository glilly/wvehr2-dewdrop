IMRNTL ;HCIOFO/FAI - Immunology National Data Base Inquiry ;05/19/00  16:09
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
 ;[IMR INQUIRY NATIONAL] - Inquiry To National Data Base
NPI S (IMRDAY,IMRSD,IMRED,IMRN1,IMRN2,IMR2C,IMRDL)="",(IMRRMAX,IMRTEST,IMRMC)=0
 D ^IMRDATE D CHK^IMREDIT G:DA<1 KIL S DFN=+Y D ^VADPT S X=$P(VADM(2),"^",1) D XOR^IMRXOR S IMRSSN=X D MSG Q
 Q
ND D ^IMRDATE D MSG
 Q
NARV D ^IMRDATE D MSG
 Q
KIL Q
ASKQ2 Q
KILL Q
ASKQ Q
MSG ; Query Report From National Message
 K DIR S DIR(0)="S^N:All National;S:Specific",DIR("A")="Select Facility Source of Information" D ^DIR K DIR
 I $D(DIRUT) D KILL Q
 W !!,"Sending Request Message to the National Registry..." H 5
 W !,"Your request will be returned via e-mail.  Thank you."
 Q
ASKQ1 K DIR S DIR(0)="Y",DIR("A")="Return Report Requested in Delimited Form",DIR("B")="NO"
 S DIR("?")="This will determine whether the report returned will be in a report format or delimited format for the user to use" D ^DIR K DIR
 Q:$D(DIRUT)!($D(DIROUT))
 S IMRDL=Y
 Q
