IBJPI2 ;DAOU/BHS - IIV SITE PARAMETERS SCREEN ACTIONS ;26-JUN-2002
 ;;2.0;INTEGRATED BILLING;**184,271,316**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; IIV - Insurance Identification and Verification Interface
 ;
 ; Only call from tag
 Q
 ;
MP ; Most Popular Payer processing
 Q
 ; Set error trap to ensure that lock is released
 N $ES,$ET
 S $ET="D ER^IBJPI2"
 ; Check lock
 L +^IBCNE("MP"):1 I '$T W !!,"The Most Popular Payers List is being edited by another user, please retry later." D PAUSE^VALM1 G MPX
 ; Call ListMan screen
 D EN^IBJPI3
 L -^IBCNE("MP")  ; Unlock
 ;
MPX ; MP exit pt
 D INIT^IBJPI S VALMBCK="R"
 Q
 ;
BE ; Batch Extract processing
 ; Init vars
 N DIR,X,Y,DIRUT,TYPE,IEN,DR,DA,DIE,DIC
 ;
 D FULL^VALM1
 W @IOF,!,"Batch Extract Parameters",!
BE1 S DIR(0)="SO^1:Buffer;2:Appt;3:Nonverified;4:No insurance"
 S DIR("A")="Batch extract parameters to edit"
 S DIR("?")="^D BEHLP^IBJPI2"
 D ^DIR K DIR I $D(DIRUT) G BEX
 S TYPE=Y
 ;
 S IEN=0 F  S IEN=$O(^IBE(350.9,1,51.17,IEN)) Q:'IEN  I $P($G(^IBE(350.9,1,51.17,IEN,0)),U,1)=TYPE Q
 ;
 I IEN=""!(IEN=0) W !,"Extract Not Defined - ERROR!" G BEX
 ;
 ; Display only Active and Max Ct for Buffer Extract
 I TYPE=1 S DR=".02;.05"
 ; Display only Active, Sel Criteria #1 and Max Ct for Appt
 I TYPE=2 S DR=".02;.03;.05"
 ; Display Active, Sel Crit #1, Sel Crit #2 and Max Ct for Non-verified
 I TYPE=3 S DR=".02;.03;.04;.05"
 ; Display Active, Sel Crit #1, Sel Crit #2 and Max Ct for No active
 I TYPE=4 S DR=".02;.03;.04;.05"
 S DIE="^IBE(350.9,1,51.17,",DA=IEN,DA(1)=1 D ^DIE K DA,DR,DIE,DIC,X,Y
 G BE1
 ;
BEX D INIT^IBJPI S VALMBCK="R"
 Q
 ;
BEHLP ; Help text display for Batch Extract selection prompt
 N DIR
 W @IOF
 W !,"  Please select an extract to view/modify settings:"
 W !!,"   1 - INS. BUFFER:  Examines entries in the Insurance Buffer to find"
 W !,"                     patient/insurance combinations that qualify for an"
 W !,"                     electronic insurance eligibility inquiry"
 W !!,"   2 - APPOINTMENT:  Reviews upcoming appointments to identify patients that"
 W !,"                     have active insurance that has not been recently verified,"
 W !,"                     or patients that have no active insurance for which an"
 W !,"                     ""identification"" inquiry should be made to search the"
 W !,"                     National Healthcare Cache for previously unknown policies"
 W !!,"   3 - NON-VERIFIED: Uses past visits to identify patients that have"
 W !,"                     been seen recently and have active insurance coverage, but"
 W !,"                     have not had the insurance information verified recently."
 W !!,"   4 - NO INSURANCE: Also uses past visits, but identifies patients with no"
 W !,"                     active insurance on file and attempts to search for"
 W !,"                     previously unknown policies by sending an ""identification"""
 W !,"                     inquiry to the National Healthcare Cache database and/or"
 W !,"                     queries the most popular insurance companies"
 D PAUSE^VALM1
BEHLPEX Q
 ;
IIVEDIT(IBJDR) ; -- IBJP IIV EDIT ACTIONS (GP,PW):  Edit IIV Site Parameters
 ; IBJDR - 0 (General Parameters section)
 ;         1 (Patients Without Insurance section)
 N DA,DR,DIE,DIC,X,Y
 ;
 D FULL^VALM1
 W @IOF,!,$S(IBJDR=0:"General",IBJDR=1:"Patients Without Insurance",1:"Unknown")_" Parameters",!
 ; Build string of fields to edit or input template based on IBJDR
 I IBJDR'="" S DR=$P($T(@IBJDR),";;",2,999)
 I DR'="" S DIE="^IBE(350.9,",DA=1 D ^DIE K DA,DR,DIE,DIC,X,Y
 ;
 D INIT^IBJPI S VALMBCK="R"
 Q
 ;
0 ;;[IBCNE GENERAL PARAMETER EDIT]
1 ;;51.08
 ;
 ;
ER ; Unlock most popular payer and return to log error
 L -^IBCNE("MP")
 D ^%ZTER
 D UNWIND^%ZTER
 Q
 ;
