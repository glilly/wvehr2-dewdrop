BPS01P5 ;BHAM ISC/BEE - BPS*1.0*5 POST INSTALL ROUTINE ;14-NOV-06
 ;;1.0;E CLAIMS MGMT ENGINE;**5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 Q
 ;
EN ;BPS*1.0*5 - POST-INSTALL
 N X,Y,%DT,ZTDESC,ZTSAVE,ZTIO,ZTDTH,ZTRTN
 S X="N",%DT="ST"
 D ^%DT
 S ZTDTH=Y
 S ZTIO=""
 S ZTDESC="BPS*1.0*5 POST INSTALL"
 S ZTSAVE("*")=""
 S ZTRTN="EN1^BPS01P5"
 D ^%ZTLOAD
 Q
 ;
EN1 N DIFROM,TMPARR,XMDUZ,XMSUB,XMTEXT,XMY
 ;
 ;Perform Data Cleanup - Delete Values from Obsolete Fields
 D 02  ;BPS CLAIMS
 D 31  ;BPS CERTIFICATION
 D 56  ;BPS PHARMACIES
 D 57  ;BPS LOG OF TRANSACTIONS
 D 58  ;BPS STATISTICS
 D 59  ;BPS TRANSACTIONS
 D 91  ;BPS NCPDP FIELD DEFS
 D 99^BPS01P5A  ;BPS SETUP
 ;
 ;Delete Obsolete Files
 D DEL^BPS01P5A
 ;
 ;Convert BPSECX/BPSECP
 D EN^BPS01P5A
 ;
 ; Update BPS Statistics
 D STAT^BPS01P5B
 ;
 ; Move Submit Date/Time from submit queue to BPS Transaction
 D SUBMIT^BPS01P5B
 ;
 ;Delete obsolete BPS NCPDP FIELD DEF records
 D DEL91^BPS01P5C
 ;
 ;Delete fields from data dictionaries
 D EN^BPS01P5B
 ;
 ;Delete entries from 'BPS NCPDP FIELD 420' with leading zeros.
 D 420
 ;
 ;Clean up indexes
 D IND
 ;
 ;Send mail to the user
 S TMPARR(1)=""
 S TMPARR(2)="The conversion of data from the ^BPSECP global to the BPS LOG file"
 I $D(^BPSECP("LOG")) S TMPARR(3)="did not complete properly.  Please log a Remedy Ticket"
 E  S TMPARR(3)="has successfully completed."
 S XMSUB="BPS*1.0*5 installation has been completed"
 S XMDUZ="E CLAIMS MGMT ENGINE PACKAGE"
 S XMTEXT="TMPARR("
 S XMY(DUZ)=""
 S XMY("G.BPS OPECC")=""
 D ^XMD
 Q
 ;
 ;BPS CLAIMS (#9002313.02)
02 N IEN,IEN02,IEN57,IEN92,NODE0,VPIEN
 S IEN=0 F  S IEN=$O(^BPSC(IEN)) Q:'IEN  D
 .N I,X
 .;
 .;Fix 'Transmitted On'
 .S NODE0=$G(^BPSC(IEN,0))
 .I $P(NODE0,U,5)="" D
 ..S $P(NODE0,U,5)=$P(NODE0,U,6)
 ..I $P(NODE0,U,5)]"" S ^BPSC("AE",$E($P(NODE0,U,5),1,30),IEN)=""
 .;
 .;Fix fields for Reversal Claims
 .I $P($G(^BPSC(IEN,100)),U,3)="B2" D
 ..S IEN57=$O(^BPSTL("AER",IEN,"")) Q:IEN57=""
 ..;
 ..;Electronic payer (.02)
 ..S IEN92=$P($G(^BPSTL(IEN57,10,1,0)),U,3)
 ..S:IEN92 $P(NODE0,U,2)=IEN92
 ..;
 ..;Original Claim IEN
 ..S IEN02=$P($G(^BPSTL(IEN57,0)),U,4) Q:IEN02=""
 ..;
 ..;MEDICATION NUMBER (.03)/MEDICATION NAME (.04)
 ..N MED S MED=$G(^BPSC(IEN,400,1,0))
 ..S:$P(MED,U,3)="" $P(MED,U,3)=1
 ..S:$P(MED,U,4)="" $P(MED,U,4)=$P($G(^BPSC(IEN02,400,1,0)),U,4)
 ..S ^BPSC(IEN,400,1,0)=MED
 ..K MED
 ..;
 ..;VA PLAN IEN (1.04)
 ..S VPIEN=$P($G(^BPSC(IEN02,1)),U,4)
 ..S:VPIEN]"" $P(^BPSC(IEN,1),U,4)=VPIEN
 .;
 .;Store '0' Node
 .S ^BPSC(IEN,0)=NODE0
 .;
 .;'1' Node
 .S X=$G(^BPSC(IEN,1))
 .I $TR(X,U)]"" D
 ..F I=2,3 S $P(X,U,I)=""  ;Reset selected fields
 ..S ^BPSC(IEN,1)=X
 .;
 .;'300' Node
 .S X=$G(^BPSC(IEN,300))
 .I $TR(X,U)]"" D
 ..F I=8,15,16,17,18,19 S $P(X,U,I)=""  ;Reset selected fields
 ..S ^BPSC(IEN,300)=X
 .;
 .;'320' Node
 .K ^BPSC(IEN,320)
 .;
 .;'498' Node
 .K ^BPSC(IEN,498)
 .;
 .N IEN2
 .S IEN2=0 F  S IEN2=$O(^BPSC(IEN,400,IEN2)) Q:'IEN2  D
 ..;
 ..;'400;0' Node
 ..S X=$G(^BPSC(IEN,400,IEN2,0))
 ..I $TR(X,U)]"" D
 ...S $P(X,U,2)=""
 ...S ^BPSC(IEN,400,IEN2,0)=X
 ..;
 ..;'400;400' Node
 ..S X=$G(^BPSC(IEN,400,IEN2,400))
 ..I $TR(X,U)]"" D
 ...F I=4,10,16,22 S $P(X,U,I)=""
 ...S ^BPSC(IEN,400,IEN2,400)=X
 ..;
 ..;'400;420' Node
 ..S X=$G(^BPSC(IEN,400,IEN2,420))
 ..I $TR(X,U)]"" D
 ...F I=25,28,32 S $P(X,U,I)=""
 ...S ^BPSC(IEN,400,IEN2,420)=X
 ..;
 ..;'400;430' Node
 ..S X=$G(^BPSC(IEN,400,IEN2,430))
 ..I $TR(X,U)]"" D
 ...F I=7,9,10 S $P(X,U,I)=""
 ...S ^BPSC(IEN,400,IEN2,430)=X
 ..;
 ..;'400;440' Node
 ..S X=$G(^BPSC(IEN,400,IEN2,440))
 ..I $TR(X,U)]"" D
 ...S $P(X,U)=""
 ...S ^BPSC(IEN,400,IEN2,440)=X
 ;
 K IEN,IEN02,IEN57,IEN92,VPIEN
 Q
 ;
 ;BPS CERTIFICATION (#9002313.31)
31 N IEN
 ;
 S IEN=0 F  S IEN=$O(^BPS(9002313.31,IEN)) Q:'IEN  D
 .N X
 .S X=$G(^BPS(9002313.31,IEN,0))
 .I $TR(X,U)]"" S $P(X,U,5)="",^BPS(9002313.31,IEN,0)=X  ;Reset field
 .S X=$G(^BPS(9002313.31,IEN,4))
 .I $TR(X,U)]"" S $P(X,U)="",^BPS(9002313.31,IEN,4)=X  ;Reset field
 ;
 K IEN
 Q
 ;
 ;BPS PHARMACIES (#9002313.56)
56 N IEN,IEN2
 ;
 S IEN=0 F  S IEN=$O(^BPS(9002313.56,IEN)) Q:'IEN  D
 .N I,X
 .;
 .;'0' Node
 .S X=$G(^BPS(9002313.56,IEN,0))
 .I $TR(X,U)]"" D
 ..F I=4:1:7 S $P(X,U,I)=""  ;Reset selected fields
 ..S ^BPS(9002313.56,IEN,0)=X
 .;
 .;CAID' Node (Reset MEDICAID # and DEFAULT CAID PROVIDER #)
 .K ^BPS(9002313.56,IEN,"CAID")
 .;
 .;'INSURER/INSURER-ASSIGNED #' Node (Reset INSURER and INSURER-ASSIGNED #)
 .K ^BPS(9002313.56,IEN,"INSURER-ASSIGNED #")
 .;
 .;'PRESCRIBER' Node (Reset PRESCRIBER)
 .S IEN2=0 F  S IEN2=$O(^BPS(9002313.56,IEN,"OPSITE",IEN2)) Q:'IEN2  D
 ..K ^BPS(9002313.56,IEN,"OPSITE",IEN2,1)  ;Reset PRESCRIBER information
 ;
 K IEN,IEN2
 Q
 ;
 ;BPS LOG OF TRANSACTIONS (#9002313.57)
57 N IEN
 S IEN=0 F  S IEN=$O(^BPSTL(IEN)) Q:'IEN  D
 .N I,X
 .;
 .;'0' Node
 .S X=$G(^BPSTL(IEN,0))
 .I $TR(X,U)]"" D
 ..F I=7,12:1:16 S $P(X,U,I)=""  ;Reset selected fields
 ..S ^BPSTL(IEN,0)=X
 .;
 .;'1' Node
 .S X=$G(^BPSTL(IEN,1))
 .I $TR(X,U)]"" D
 ..F I=3,5,6,14 S $P(X,U,I)=""  ;Reset selected fields
 ..S ^BPSTL(IEN,1)=X
 .;
 .;'2' Node
 .N NRES,RES,ND2
 .S ND2=$G(^BPSTL(IEN,2))
 .S RES=$P(ND2,U,2,99)
 .S RES=$TR(RES,"]")  ;Translate ']' to NULL
 .;
 .;Translate '[Previously: ' to ';'
 .S NRES=""
 .F I=1:1:$L(RES,"[Previously: ") S NRES=NRES_$S(I>1:";",1:"")_$P(RES,"[Previously: ",I)
 .;
 .;Store changes
 .S ^BPSTL(IEN,2)=$P(ND2,U)_U_NRES
 .;
 .;'3' Node
 .K ^BPSTL(IEN,3)
 .;
 .;'4' Node
 .S X=$G(^BPSTL(IEN,4))
 .I $TR(X,U)]"" D
 ..S $P(X,U,3)=""  ;Reset PAPER REVERSAL
 ..S ^BPSTL(IEN,4)=X
 .;
 .;'5' Node
 .S X=$G(^BPSTL(IEN,5))
 .I $TR(X,U)]"" D
 ..S $P(X,U,6)=""   ;Reset PRICE MANUALLY ENTERED
 ..S ^BPSTL(IEN,5)=X
 .;
 .;'6' Node
 .K ^BPSTL(IEN,6)
 .;
 .;'7' Node
 .K ^BPSTL(IEN,7)
 .;
 .;'8' Node
 .S X=$G(^BPSTL(IEN,8))
 .I $TR(X,U)]"" D
 ..S $P(X,U,2)=""  ;Reset RETRY ON DIAL OUT
 ..S ^BPSTL(IEN,8)=X
 ;
 K IEN
 Q
 ;
 ;BPS STATISTICS (#9002313.58)
58 N DIK,IEN,X
 ;
 ;Clear out the "B" index
 K ^BPSECX("S","B")
 ;
 S IEN=0 F  S IEN=$O(^BPSECX("S",IEN)) Q:'IEN  D
 .;
 .;'M' Node
 .K ^BPSECX("S",IEN,"M")
 .;
 .;'C' Node
 .K ^BPSECX("S",IEN,"C")
 .;
 .;'CT' Node
 .K ^BPSECX("S",IEN,"CT")
 .;
 .;'D' Node
 .K ^BPSECX("S",IEN,"D")
 .;
 .;'CR' Node
 .K ^BPSECX("S",IEN,"CR")
 .;
 .;'CR2' Node
 .K ^BPSECX("S",IEN,"CR2")
 .;
 .;'CRN' Node
 .K ^BPSECX("S",IEN,"CRN")
 .;
 .;'ABSBPOSV' Node
 .K ^BPSECX("S",IEN,"ABSBPOSV")
 .;
 .;'V' Node
 .K ^BPSECX("S",IEN,"V")
 .;
 .;Copy IEN into .01 field
 .S X=$G(^BPSECX("S",IEN,0))
 .S $P(X,U)=IEN,^BPSECX("S",IEN,0)=X
 .S ^BPSECX("S","B",$E(IEN,1,30),IEN)=""
 .;
 .;Update File Header Field
 .S $P(^BPSECX("S",0),U,3)=IEN
 ;
 K DIK,IEN,X
 ;
 Q
 ;
 ;BPS TRANSACTION (#9002313.59)
59 N IEN
 S IEN=0 F  S IEN=$O(^BPST(IEN)) Q:'IEN  D
 .N I,X
 .;
 .;'0' Node
 .S X=$G(^BPST(IEN,0))
 .I $TR(X,U)]"" D
 ..F I=7,12:1:16 S $P(X,U,I)=""  ;Reset selected fields
 ..S ^BPST(IEN,0)=X
 .;
 .;'1' Node
 .S X=$G(^BPST(IEN,1))
 .I $TR(X,U)]"" D
 ..F I=3,5,6,14 S $P(X,U,I)=""  ;Reset selected fields
 ..S ^BPST(IEN,1)=X
 .;
 .;'2' Node
 .N NRES,RES,ND2
 .S ND2=$G(^BPST(IEN,2))
 .S RES=$P(ND2,U,2,99)
 .S RES=$TR(RES,"]")  ;Translate ']' to NULL
 .;
 .;Translate '[Previously: ' to ';'
 .S NRES=""
 .F I=1:1:$L(RES,"[Previously: ") S NRES=NRES_$S(I>1:";",1:"")_$P(RES,"[Previously: ",I)
 .;
 .;Store changes
 .S ^BPST(IEN,2)=$P(ND2,U)_U_NRES
 .S $P(^BPST(IEN,2),U,2)=NRES
 .;
 .;'3' Node
 .K ^BPST(IEN,3)
 .;
 .;'4' Node
 .S X=$G(^BPST(IEN,4))
 .I $TR(X,U)]"" D
 ..S $P(X,U,3)=""  ;Reset PAPER REVERSAL
 ..S ^BPST(IEN,4)=X
 .;
 .;'5' Node
 .S X=$G(^BPST(IEN,5))
 .I $TR(X,U)]"" D
 ..S $P(X,U,6)=""   ;Reset PRICE MANUALLY ENTERED
 ..S ^BPST(IEN,5)=X
 .;
 .;'6' Node
 .K ^BPST(IEN,6)
 .;
 .;'7' Node
 .K ^BPST(IEN,7)
 .;
 .;'8' Node
 .S X=$G(^BPST(IEN,8))
 .I $TR(X,U)]"" D
 ..S $P(X,U,2)=""  ;Reset RETRY ON DIAL OUT
 ..S ^BPST(IEN,8)=X
 ;
 K IEN
 Q
 ;
 ;BPS NCPDP FIELD DEFS (#9002313.91)
91 N IEN
 S IEN=0 F  S IEN=$O(^BPSF(9002313.91,IEN)) Q:'IEN  D
 .N I,X
 .;
 .;'0' Node
 .S X=$G(^BPSF(9002313.91,IEN,0))
 .I $TR(X,U)]"" D
 ..F I=2,5 S $P(X,U,I)=""  ;Reset selected fields
 ..S ^BPSF(9002313.91,IEN,0)=X
 .;
 .;Remove Format Code (Field 20)
 .K ^BPSF(9002313.91,IEN,20)
 ;
 K IEN
 Q
 ;
 ;Delete entries with leading zeros from BPS NCPDP FIELD 420 (#9002313.8242)
420 N DIE,DA,DR,CD
 S CD=0 F  S CD=$O(^BPSF(9002313.8242,"B",CD)) Q:CD=""  D
 .I $E(CD,1)'="0" Q
 .S DA=$O(^BPSF(9002313.8242,"B",CD,"")) Q:DA=""
 .S DIE=9002313.8242,DR=".01////@"
 .D ^DIE
 Q
 ;
 ;Delete indexes
IND K ^BPSC("D") ;9002313.02 - Billing Item PCN #
 K ^BPSC("E") ;9002313.02 - Billing Item VCN #
 K ^BPSTL("AI") ;9002313.57 - INSURER
 K ^BPSTL("AR") ;9002313.57 - POSTED TO A/R
 K ^BPSTL("AS") ;9002313.57 - NEEDS BILLING
 K ^BPST("AR") ;9002313.59 - POSTED TO A/R
 Q
