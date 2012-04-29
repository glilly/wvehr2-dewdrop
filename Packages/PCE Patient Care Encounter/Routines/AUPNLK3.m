AUPNLK3 ; IHS/CMI/LAB - IHS PATIENT LOOKUP CHECK FOR DUPLICATES ;1/29/07  09:05
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
 ;'Modified' MAS Patient Look-up Check for Duplicates, June 1987
 ;
 ; Upon exiting this routine AUPNLK3 will be set as follows:
 ;
 ;          AUPNLK3 =  0 means ok to add patient
 ;          AUPNLK3 = -1 means do not add patient
 ;
 ; AUPQF3 values have the following meaing.
 ;
 ;        0 = Initial state
 ;        1 = Missing fields
 ;        2 = No potential duplicates
 ;        3 = Operator said no
 ;        4 = Operator said yes
 ;
START ;
 D INIT ;                    Initialization
 I AUPQF3 D EOJ Q
 D SEARCH ;                  Do search
 I AUPQF3 D EOJ Q
 D SHOW ;                    Show list of potential duplicates
 D ASK ;                     See if still want to add
 D EOJ
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
SEARCH ; SEARCH FOR POTENTIAL DUPLICATES
 S AUPNM=AUPX,SEX=AUPIDS(.02),DOB=AUPIDS(.03),SSN=AUPIDS(.09)
 W !!?3,"...searching for potential duplicates"
 D ^AUPNLKD
 I 'AUPD W !!?3,"No potential duplicates have been identified." S AUPQF3=2 Q
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
SHOW ; SHOW LIST OF POTENTIAL DUPLICATES
 W !!?3,*7,"The following patients have been identified as potential duplicates:",!
 F Y=0:0 S Y=$O(AUPD(Y)) Q:'Y  W !?5,$P(^DPT(Y,0),U) X DIC("W") I $D(^DPT(Y,.01)) F AUPAN=0:0 S AUPAN=$O(^DPT(Y,.01,AUPAN)) Q:AUPAN'=+AUPAN  I $D(^(AUPAN,0)) W !?10,$P(^(0),U,1)
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
ASK ; ASK OPERATOR
 F AUPL=0:0 D ASKADD Q:%
 I %'=1 S AUPQF3=3 Q
 S AUPQF3=4
 Q
 ;
ASKADD ;
 W !!?3,"Do you still want to add '",AUPX,"' as a new patient"
 S %=2 D YN^DICN I '% W !!?6,"Enter 'YES' to add new patient, or 'NO' not to." Q
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
INIT ; INITIALIZATION
 S AUPQF3=0
 I '$D(AUPX)!('$D(AUPIDS(.02)))!('$D(AUPIDS(.03)))!('$D(AUPIDS(.09))) W !?3,*7,"Unable to search for potential duplicates, Sex, Date of Birth and",!?3,"Social Security Number must be defined." S AUPQF3=1 Q
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
EOJ ;
 S AUPNLK3=$S(AUPQF3#2:-1,1:0)
 K AUPAN,AUPD,AUPNM,AUPQF3
 K DOB,SEX,SSN
 Q
