IBJPI ;DAOU/BHS - IBJP IIV SITE PARAMETERS SCREEN ;14-JUN-2002
 ;;2.0;INTEGRATED BILLING;**184,271,316**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; IIV - Insurance Identification and Verification Interface
 ;
EN ; main entry pt for IBJP IIV SITE PARAMS
 N POP,X,CTRLCOL,VALMHDR,VALMCNT,%DT
 D EN^VALM("IBJP IIV SITE PARAMETERS")
 Q
 ;
HDR ; header 
 S VALMHDR(1)="Only authorized persons may edit this data."
 Q
 ;
INIT ; init vars & list array
 K ^TMP($J,"IBJPI")
 ; Kills data and video control arrays with active list
 D CLEAN^VALM10
 D BLD
 Q
 ;
HELP ; help
 D FULL^VALM1
 W @IOF
 W !,"This screen displays all of the eIIV Site Parameters used to manage the"
 W !,"eIIV application used for Insurance Identification and Verification."
 W !!,"The first section, General Parameters, concerns overall parameters"
 W !,"for monitoring the interface and controlling IIV communication"
 W !,"between VistA and the EC located in Austin."
 W !!,"The second section, Batch Extracts, concerns extract specific parameters"
 W !,"including active status, selection criteria and maximum records extracted"
 W !,"per day."
 W !!,"The third section, Patients without Insurance, concerns whether or not"
 W !,"identification inquiries should be made for patients without insurance on"
 ;W !,"inactive policies or the Most Popular Payers list below to see if the"
 W !,"inactive policies to see if the patient is covered by one of those companies"
 ;W !,"patient is covered by one of those companies or payers."
 W !,"or payers."
 ;D PAUSE^VALM1
 ;W !!,"The final section, Most Popular Payers, is a list maintained by users"
 ;W !,"of the most popular payers for that site.  This list is site-specific and"
 ;W !,"is based on the payers selected by the user as those most likely to have"
 ;W !,"coverage for a patient at the site.  The columns display whether or not the"
 ;W !,"payer is locally active or nationally active and the national payer id."
 ;W !,"The locally active flag can be updated by the site as long as the eIIV"
 ;W !,"application has not been deactivated.  The nationally active flag"
 ;W !,"is only updated by the Eligibility Communicator.  Both flags must be set"
 ;W !,"to YES for an insurance inquiry to be transmitted to the Eligibility"
 ;W !,"Communicator."
 D PAUSE^VALM1
 W @IOF
 S VALMBCK="R"
 Q
 ;
EXIT ; exit
 K ^TMP($J,"IBJPI")
 D CLEAN^VALM10
 Q
 ;
BLD ; build screen array
 N IBLN,IBCOL,IBWID,IBIIV,IBIIVB,IBIEN,CT,IBEX1,IBEX2,IBEX,IEN
 N IBST,IBDATA,DISYS,X,STATUS,AIEN,ADATA
 ;
 S (IBLN,VALMCNT)=0,IBCOL=3,IBIIV=$G(^IBE(350.9,1,51))
 ; -- Gen Params
 ; Skip line
 S IBLN=$$SET("","",IBLN,0),IBWID=48
 S IBLN=$$SETN("General Parameters",IBLN,IBCOL,1,)
 S IBLN=$$SET("Days between electronic reverification checks:  ",$P(IBIIV,U),IBLN,IBWID)
 S IBLN=$$SET("Send daily statistical report via MailMan:  ",$S($P(IBIIV,U,2):"YES",$P(IBIIV,U,2)=0:"NO",1:""),IBLN,IBWID)
 I $P(IBIIV,U,2) S IBLN=$$SET("Time of day for daily statistical report:  ",$P(IBIIV,U,3),IBLN,IBWID)
 S IBLN=$$SET("Mail Group for eIIV messages:  ",$$MGRP^IBCNEUT5,IBLN,IBWID)
 S IBLN=$$SET("HL7 Response Processing Method:  ",$S($P(IBIIV,U,13)="B":"BATCH",$P(IBIIV,U,13)="I":"IMMEDIATE",1:""),IBLN,IBWID)
 I $P(IBIIV,U,13)="B" D
 . S IBLN=$$SET("HL7 Batch Start Time:  ",$P(IBIIV,U,14),IBLN,IBWID)
 . S IBLN=$$SET("HL7 Batch Stop Time:  ",$P(IBIIV,U,19),IBLN,IBWID)
 S IBLN=$$SET("Daily Maximum HL7 Messages:  ",$P(IBIIV,U,15),IBLN,IBWID)
 S IBLN=$$SET("Contact Person:  ",$S($P(IBIIV,U,16)'="":$$GET1^DIQ(200,$P(IBIIV,U,16)_",",.01,"E"),1:""),IBLN,IBWID)
 S IBWID=62
 S IBLN=$$SET("","",IBLN,0)
 S IBLN=$$SET("Receive MailMan message when unable to electronically","",IBLN,IBWID-12)
 S IBLN=$$SET("confirm insurance due to communication problem:  ",$S($P(IBIIV,U,20):"YES",$P(IBIIV,U,20)=0:"NO",1:""),IBLN,IBWID-6)
 ; Skip lines to force Batch Extracts to next page
 S IBLN=$$SET("","",IBLN,0)
 S IBLN=$$SET("","",IBLN,0)
 S IBLN=$$SET("","",IBLN,0)
 ; Skip lines for Immediate
 I $P(IBIIV,U,13)'="B" D
 . S IBLN=$$SET("","",IBLN,0)
 . S IBLN=$$SET("","",IBLN,0)
 ;
 ; -- Batch Extracts
 S IBWID=43
 S IBLN=$$SETN("Batch Extracts",IBLN,IBCOL,1,)
 S IBLN=$$SET("","",IBLN,0)
 S IBLN=$$SET("Extract               Selection  Maximum # to","",IBLN,IBWID)
 S IBLN=$$SETN(" Name          On/Off  Criteria   Extract/Day",IBLN,IBCOL+1,,1)
 ; Loop thru extracts
 S IEN=0 F  S IEN=$O(^IBE(350.9,1,51.17,IEN)) Q:'IEN  D
 . S IBIIVB=$G(^IBE(350.9,1,51.17,IEN,0))
 . S IBEX=+$P(IBIIVB,U)  ; Type
 . S IBST=$$FO^IBCNEUT1($S($P(IBIIVB,U)'="":$$GET1^DIQ(350.9002,$P(IBIIVB,U)_",1,",.01,"E"),1:""),14)
 . S IBST=IBST_$$FO^IBCNEUT1($S(+$P(IBIIVB,U,2):"ON",1:"OFF"),8)
 . S IBEX1=$S(+$P(IBIIVB,U,3)'=0:+$P(IBIIVB,U,3),1:$P(IBIIVB,U,3))
 . S IBEX2=$S(+$P(IBIIVB,U,4)'=0:+$P(IBIIVB,U,4),1:$P(IBIIVB,U,4))
 . S IBST=IBST_$$FO^IBCNEUT1($S(IBEX=1:"N/A",IBEX=2:IBEX1,IBEX=3!(IBEX=4):IBEX1_"/"_IBEX2,1:"ERROR"),11)
 . S IBST=IBST_$$FO^IBCNEUT1($S(+$P(IBIIVB,U,5):+$P(IBIIVB,U,5),1:$P(IBIIVB,U,5)),14)
 . S IBLN=$$SET(IBST,"",IBLN,IBWID)
 S IBLN=$$SET("","",IBLN,0)
 ;
 ; -- Pts w/o Ins
 ; Skip line
 S IBLN=$$SET("","",IBLN,0),IBWID=41
 S IBLN=$$SETN("Patients Without Insurance",IBLN,IBCOL,1,)
 S IBLN=$$SET("Look at a patient's inactive insurance?  ",$S($P(IBIIV,U,8):"YES",$P(IBIIV,U,8)=0:"NO",1:""),IBLN,IBWID)
 ;S IBLN=$$SET("Attempt inquiry by most popular payers?  ",$S($P(IBIIV,U,9):"YES",$P(IBIIV,U,9)=0:"NO",1:""),IBLN,IBWID)
 ;S IBLN=$$SET("How many payers to try?  ",$P(IBIIV,U,10),IBLN,IBWID)
 S IBLN=$$SET("","",IBLN,0)
 S VALMCNT=IBLN
 Q
 ; No longer allowing the use of Most Popular Payers
 ;
 ; -- Most Popular Payers
 ; Skip line
 S IBLN=$$SET("","",IBLN,0),IBWID=12
 S IBLN=$$SETN("Most Popular Payers",IBLN,IBCOL,1,)
 ;
 S IBLN=$$SET("  Saved By:  ",$$GET1^DIQ(350.9,1,51.24),IBLN,IBWID)
 S IBLN=$$SET("Last Saved:  ",$$FMTE^XLFDT($P(IBIIV,U,21),"5Z"),IBLN,IBWID)
 S IBWID=48
 S IBST="    "_$$FO^IBCNEUT1(" ",36)_"  "_$$FO^IBCNEUT1(" ",11)_"  "_$$FO^IBCNEUT1("Nationally",10)_"  "_$$FO^IBCNEUT1("Locally",7)
 S IBLN=$$SET(IBST,"",IBLN,IBWID)
 S IBST="  #  "_$$FO^IBCNEUT1("Payer Name",36)_"  "_$$FO^IBCNEUT1("National ID",11)_"  "_$$FO^IBCNEUT1(" Active?",10)_"  "_$$FO^IBCNEUT1(" Active?",8)
 S IBLN=$$SETN(IBST,IBLN,IBCOL+1,,1)
 ; Loop thru the current List of Payers
 S (IEN,CT)=0 F  S IEN=$O(^IBE(350.9,1,51.18,IEN)) Q:'IEN  D
 . S IBIEN=$P($G(^IBE(350.9,1,51.18,IEN,0)),U) Q:'IBIEN  ; Bad IEN
 . S CT=CT+1,IBST=$$FO^IBCNEUT1(CT,2,"R")_". "
 . ; Payer Name
 . S IBST=IBST_$$FO^IBCNEUT1($P($G(^IBE(365.12,IBIEN,0)),U),36)
 . ; National ID
 . S IBST=IBST_"  "_$$FO^IBCNEUT1($P($G(^IBE(365.12,IBIEN,0)),U,2),11)
 . ; Look up the payer application data
 . S AIEN=$$PYRAPP^IBCNEUT5("IIV",IBIEN)
 . ; WARNING - IIV application does not exist
 . I AIEN="" D  Q
 . . S IBLN=$$SET(IBST,"",IBLN,IBWID)
 . . S IBST="    ** Please remove from this list: Payer not configured for IIV **"
 . . S IBLN=$$SET(IBST,"",IBLN,"")
 . S ADATA=$G(^IBE(365.12,+IBIEN,1,+AIEN,0))
 . S IBST=IBST_"  "_$$FO^IBCNEUT1($S('$P(ADATA,U,2):"  NO",1:"  YES"),9)
 . S IBST=IBST_"  "_$$FO^IBCNEUT1($S('$P(ADATA,U,3):"   NO",1:"   YES"),7)
 . S IBLN=$$SET(IBST,"",IBLN,"")
 . ; WARNING - IIV application deactivated
 . I +$P(ADATA,U,11) D  Q
 . . S IBST="    ** Please remove from this list: Payer is deactivated for IIV **"
 . . S IBLN=$$SET(IBST,"",IBLN,"")
 . ; WARNING - Id Inq Req ID = YES & Use SSN as ID = NO
 . I +$P(ADATA,U,8),'$P(ADATA,U,9) D  Q
 . . S IBST="    ** Please remove from this list: Inquiries w/o subscriber ID rejected **"
 . . S IBLN=$$SET(IBST,"",IBLN,"")
 ; No Data Found if CT=0
 I CT=0 S IBLN=$$SET($$FO^IBCNEUT1("*** NO DATA FOUND!!!! ***",60),"",IBLN,IBWID)
 S IBLN=$$SET("","",IBLN,0),IBWID=71
 S IBLN=$$SET("A payer will be available for electronic identification only if it is","",IBLN,IBWID)
 S IBLN=$$SET($$FO^IBCNEUT1("  both nationally and locally active.",IBWID),"",IBLN,IBWID)
 ;
 S VALMCNT=IBLN
 ;
 Q
 ;
SET(TTL,DATA,LN,WID) ;
 ; TTL = caption for field
 ; DATA = field value
 ; LN = current line #
 ; WID = right justify width
 N IBY
 ; update line ct
 S LN=LN+1
 ; offset line by 3 spaces
 S IBY="   "_$J(TTL,WID)_DATA D SET1(IBY,LN,0,$L(IBY))
 Q LN
 ;
SETN(TTL,LN,COL,RV,UN) ;
 ; TTL = caption for field
 ; LN = current line #
 ; COL = column at which to start video attribute
 ; RV = 0/1 flag for reverse video
 ; UN = 0/1 flag for underline
 N IBY
 ; update line ct
 S LN=LN+1
 ; offset line by 2 spaces
 S IBY="  "_TTL D SET1(IBY,LN,COL,$L(TTL),$G(RV),$G(UN))
 Q LN
 ;
SET1(STR,LN,COL,WD,RV,UN) ; Set up ^TMP array with screen data
 ; STR = line text
 ; LN = current line #
 ; COL = column at which to start video attribute
 ; WD = width of video attribute
 ; RV = 0/1 flag for reverse video
 ; UN = 0/1 flag for underline
 D SET^VALM10(LN,STR)
 I $G(RV)'="" D CNTRL^VALM10(LN,COL,WD,IORVON,IORVOFF)
 I $G(UN)'="" D CNTRL^VALM10(LN,COL,WD-1,IOUON,IOUOFF)
 Q
 ;
