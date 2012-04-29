IBCNEHLT ;DAOU/ALA - HL7 Process Incoming MFN Messages ; 09 Dec 2005  3:30 PM
 ;;2.0;INTEGRATED BILLING;**184,251,271,300**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ;  This program will process incoming MFN messages and
 ;  update the appropriate tables
 ;
EN ;  Entry Point
 NEW AIEN,APIEN,APP,D0,D,DESC,DQ,DR,FILE,FLN,HEDI,ID,IEN
 NEW PEDI,SEG,STAT,HCT,NEWID,TSSN,USSN,REQSUB,NAFLG,NPFLG
 NEW IBCNACT,IBCNADT,FSVDY,PSVDY
 NEW BPSIEN,CMIEN,DATA,DATAAP,DATABPS,DATACM,DATE,ERROR,FIELDNO,FILENO
 NEW IBSEG,MSG,BUFF
 NEW X12TABLE,BADFMT
 ;
 ; BADFMT is true if a site with patch 300 receives an IIV message in the previous HL7 interface structure (pre-300)
 ;
 ; Build local table of file numbers to determine if response is IIV or ePHARM
 F D=11:1:18,21 S X12TABLE("365.0"_D)=""
 ;
 ; Decide if message belongs to "E-Pharm" or "IIV"
 S APP=""
 S HCT=0,ERFLG=0
 F  S HCT=$O(^TMP($J,"IBCNEHLI",HCT)) Q:HCT=""  D SPAR^IBCNEHLU I $G(IBSEG(1))="MFI" S FILE=$G(IBSEG(2)),FLN=$P(FILE,$E(HLECH,1),1) Q
 I ",366.01,366.02,366.03,365.12,355.3,"[(","_FLN_",") S APP="E-PHARM"
 I FLN=365.12 D
 . S HCT=0,BADFMT=0
 . F  S HCT=$O(^TMP($J,"IBCNEHLI",HCT)) Q:HCT=""  D  Q:(APP="IIV")!BADFMT
 .. D SPAR^IBCNEHLU
 .. I $G(IBSEG(1))="MFE",$P($G(IBSEG(5)),$E(HLECH,1),3)'="" D  Q
 ... S BADFMT=1,APP=""
 ... S MSG(1)="Log a Remedy Ticket for this issue."
 ... S MSG(2)="Please include in the Remedy Ticket that the IIV payer tables may be out"
 ... S MSG(3)="of sync with the master list and will need a new copy of the payer table"
 ... S MSG(4)="from Austin."
 ... D MSG^IBCNEUT5($$MGRP^IBCNEUT5(),"IIV payer tables may be out of synch with master list","MSG(")
 .. I $G(IBSEG(1))="ZPA" S APP="IIV"
 I $D(X12TABLE(FLN)) S APP="IIV"
 ; If neither IIV or ePHARM then quit
 I APP="" Q
 ;
 S HCT=1,NAFLG=0,NPFLG=0,D=""
 F  S HCT=$O(^TMP($J,"IBCNEHLI",HCT)) Q:HCT=""  D  Q:ERFLG
 . D SPAR^IBCNEHLU
 . S SEG=$G(IBSEG(1))
 . ;
 . I APP="E-PHARM" D
 .. I SEG="MFI" D
 ... S FILE=$G(IBSEG(2))
 ... S FLN=$P(FILE,$E(HLECH,1),1)
 ... ;
 ... ; Initialize MFK Message (Application Acknowledgement) variables
 ... ; Master File Identifier
 ... S DATAMFK("MFI-1")=$G(IBSEG(2))
 ... ;
 ... ; File-Level Event Code
 ... S DATAMFK("MFI-3")=$G(IBSEG(4))
 .. ;
 .. I SEG="MFE" D
 ... I $G(FLN)="" S ERFLG=1,MSG(1)="File Number not found in MFN message" Q
 ... I '$$VFILE^DILFD(FLN) S ERFLG=1,MSG(1)="File "_FLN_" not found in the Data Dictionary" Q
 ... ;
 ... ; Initialize MFK Message (Application Acknowledgement) variables
 ... ; Record-Level Event Code
 ... S DATAMFK("MFE-1")=$G(IBSEG(2))
 ... ;
 ... ; Primary Key Value
 ... S DATAMFK("MFE-4")=$G(IBSEG(5))
 ... ;
 ... ; Primary Key Value Type
 ... S DATAMFK("MFE-5")=$G(IBSEG(6))
 ... ;
 ... ; Transfer control to e-Pharmacy
 ... D ^IBCNRHLT Q
 .. ;
 .. ; Transfer control on other segments
 .. I ",ZCM,ZP0,ZPB,ZPL,ZPT,ZRX,"[(","_SEG_",") D ^IBCNRHLT
 . ;
 . ;
 . I APP="IIV" D
 .. I SEG="MFI" D
 ... S FILE=$G(IBSEG(2))
 ... S FLN=$P(FILE,$E(HLECH,1),1)
 .. ;
 .. I SEG="MFE" D
 ... I $G(FLN)="" S ERFLG=1,MSG(1)="File Number not found in MFN message" Q
 ... I '$$VFILE^DILFD(FLN) S ERFLG=1,MSG(1)="File "_FLN_" not found in the Data Dictionary" Q
 ... ;
 ... I FLN'=365.12 D  Q
 .... S DATA=$G(IBSEG(5))
 .... S ID=$$DECHL7^IBCNEHL2($P(DATA,$E(HLECH,1),1)),DESC=$$DECHL7^IBCNEHL2($P(DATA,$E(HLECH,1),2))
 .... D TFIL
 ... ;
 ... ; Pull the action code
 ... S IBCNACT=$G(IBSEG(2))
 ... ; Effective Date
 ... S IBCNADT=$G(IBSEG(4))
 .. ;
 .. I SEG="ZP0" D
 ... S ID=$$DECHL7^IBCNEHL2(IBSEG(3)),NEWID=$$DECHL7^IBCNEHL2(IBSEG(4))
 ... S DESC=$$DECHL7^IBCNEHL2(IBSEG(5)),HEDI=$$DECHL7^IBCNEHL2(IBSEG(6)),PEDI=$$DECHL7^IBCNEHL2(IBSEG(7))
 .. ;
 .. I SEG="ZPA" D
 ... S STAT=IBSEG(4),STAT=$S(STAT="Y":"Active",1:"Not Active")
 ... S TSSN=IBSEG(5),USSN=IBSEG(6),REQSUB=IBSEG(7)
 ... S FSVDY=IBSEG(8),PSVDY=IBSEG(9)
 ... D PFIL
 Q
 ;
PFIL ;  Payer Table Filer
 ;  Set the action:
 ;     MAD=Add, MUP=Update, MDC=Deactivate, MAC=Reactivate
 S IBCNADT=$$FMDATE^HLFNC(IBCNADT)
 I IBCNADT="" S IBCNADT=$$NOW^XLFDT()
 ;  If the action is MAD - Add the payer as new
 N IBNOK,IBAPP,IBID,IBDESC,IBSTR
 S IBNOK=0,IBAPP=($TR(APP," ")="")
 I IBCNACT="MAD" D  I IBNOK G PFILX
 . ; Check certain required fields: Application, VA National & Payer Name
 . ; If not populated, send MailMan message.
 . S IBID=($TR(ID," ")=""),IBDESC=($TR(DESC," ")="")
 . S IBNOK=IBAPP!IBID!IBDESC
 . I 'IBNOK D MAD(DESC) Q
 . S IBSTR="" I IBAPP S IBSTR="Application"
 . I IBID S:IBSTR]"" IBSTR=IBSTR_", " S IBSTR=IBSTR_"VA National"
 . I IBDESC S:IBSTR]"" IBSTR=IBSTR_", " S IBSTR=IBSTR_"Payer Name"
 . S MSG(1)="MAD action received.  "_IBSTR_" unknown."
 I IBCNACT'="MAD" D FND
 N IBCNTYPE
 I IEN<1!IBAPP D  G PFILX
 . S IBCNTYPE=$S(IBCNACT="MAD":"Add",IBCNACT="MUP":"Update",IBCNACT="MDC":"Deactivate",IBCNACT="MAC":"Reactivate",1:"Unknown")
 . S MSG(1)=IBCNTYPE_" ("_IBCNACT_") action received. Payer and/or Application may be unknown."
 . S MSG(2)=""
 . S MSG(3)="VA National : "_ID
 . S MSG(4)="Payer Name  : "_DESC
 . S MSG(5)="Application : "_APP
 . S MSG(6)=""
 . S MSG(7)="Log a Remedy Ticket for this issue."
 . S MSG(8)=""
 . S MSG(9)="Please include in the Remedy Ticket that VISTA did not receive the required"
 . S MSG(10)="information or the accurate information to add/update this Payer."
 . D MSG^IBCNEUT5($$MGRP^IBCNEUT5(),"IIV payer tables may be out of synch with master list","MSG(")
 ;
 S DESC=$E(DESC,1,80)    ;restriction of the field in the DD
 S DIC=$$ROOT^DILFD(FLN)
 S DR=".01///^S X=DESC;.02////^S X=NEWID;.05////^S X=PEDI;.06////^S X=HEDI"
 ;
 ;  If new payer, add the Date/Time created
 I NPFLG S DR=DR_";.04///^S X=$$NOW^XLFDT()"
 S DIE=DIC,DA=IEN D ^DIE
 ;
 ;  Check for application
 S DIC="^IBE(365.13,",DIC(0)="X",X=APP D ^DIC
 S AIEN=+Y I AIEN<1 D
 . S DLAYGO=365.13,DIC(0)="L",DIC("P")=DLAYGO
 . S DIE=DIC,X=APP
 . K DD,DO
 . D FILE^DICN
 . K DO
 . S AIEN=+Y
 ;
 S APIEN=$O(^IBE(365.12,IEN,1,"B",AIEN,""))
 I APIEN="" D
 . S DLAYGO=365.121,DIC(0)="L",DIC("P")=DLAYGO,DA(1)=IEN,X=AIEN
 . S DIC="^IBE(365.12,"_DA(1)_",1,",DIE=DIC
 . I '$D(^IBE(365.12,IEN,1,0)) S ^IBE(365.12,IEN,1,0)="^365.121P^^"
 . K DD,DO
 . D FILE^DICN
 . K DO
 . S APIEN=+Y,NAFLG=1
 ;
 I $G(STAT)="" S STAT=$P(^IBE(365.12,IEN,1,APIEN,0),U,2)
 ;
 S DA(1)=IEN,DA=APIEN,DIC="^IBE(365.12,"_DA(1)_",1,",DR=""
 ;
 I IBCNACT="MDC" S DR=DR_".11///^S X=1;.12////^S X=IBCNADT;",STAT=0
 I IBCNACT="MAC" S DR=DR_".11///^S X=0;.12///@;"
 S DR=DR_".02///^S X=STAT;.06///^S X=$$NOW^XLFDT()"
 I IBCNACT'="MDC" S DR=DR_";.08///^S X=REQSUB;.09///^S X=USSN;.1///^S X=TSSN;.14///^S X=FSVDY;.15///^S X=PSVDY"
 ;
 ;  If new application, add the Date/Time created
 I NAFLG S DR=DR_";.13///^S X=$$NOW^XLFDT()"
 ;
 S DIE=DIC D ^DIE
 I IBCNACT="MDC" D MDC Q
PFILX ;
 Q
 ;
TFIL ;  Non Payer Tables Filer
 NEW DIC,DIE,X,DA,DLAYGO,Y,DR,IEN
 S DIC(0)="X",X=ID,DIC=$$ROOT^DILFD(FLN)
 D ^DIC S IEN=+Y
 ;
 S DESC=$E(DESC,1,80)    ;restriction of the field in the DD
 ;
 ;  If no matching entry found, add it to table
 I IEN<1 D
 . S DLAYGO=FLN,DIC(0)="L",DIC("P")=DLAYGO,DIE=DIC
 . K DD,DO
 . D FILE^DICN S IEN=+Y
 . K DO
 ;
 S DR=".02///^S X=DESC",DA=IEN,DIE=DIC D ^DIE
 Q
 ;
MAD(X) ;  Add an entry
 D FND
 I IEN>0 G MADX
 NEW DIC,DIE,DA,DLAYGO,Y,DR
 S DIC=$$ROOT^DILFD(FLN)
 S DLAYGO=FLN,DIC(0)="L",DIC("P")=DLAYGO,DIE=DIC
 K DD,DO
 D FILE^DICN
 K DO
 S IEN=+Y,NPFLG=1
MADX ;
 Q
 ;
FND ;  Find an existing Payer entry
 NEW DIC,DIE,X,DA,DLAYGO,Y,DR
 S X=ID,DIC(0)="X",D="C",DIC=$$ROOT^DILFD(FLN)
 ;
 ;  Do a lookup with the "C" cross-reference
 D IX^DIC
 S IEN=+Y
 Q
 ;
MDC ;  Check for active transmissions and cancel
 NEW STA,HIEN,RIEN,TQIEN
 F STA=1,2,4,6 S TQIEN="" D
 . F  S TQIEN=$O(^IBCN(365.1,"AC",STA,TQIEN)) Q:TQIEN=""  D
 .. ;
 .. ;  If the record doesn't match the payer, quit
 .. I $P(^IBCN(365.1,TQIEN,0),U,3)'=IEN Q
 .. ;
 .. ;  Set the status to 'Cancelled'
 .. D SST^IBCNEUT2(TQIEN,7)
 .. ;
 .. ;  If a buffer entry, set to ! (bang)
 .. S BUFF=$P(^IBCN(365.1,TQIEN,0),U,5)
 .. I BUFF'="" D BUFF^IBCNEUT2(BUFF,17)
 .. ;
 .. ;  Change any responses status also
 .. S HIEN=0 F  S HIEN=$O(^IBCN(365.1,TQIEN,2,HIEN)) Q:'HIEN  D
 ... S RIEN=$P(^IBCN(365.1,TQIEN,2,HIEN,0),U,3)
 ... ;  If the Response status is 'Response Received', don't change it
 ... I $P(^IBCN(365,RIEN,0),U,6)=3 Q
 ... D RSP^IBCNEUT2(RIEN,7)
 Q
