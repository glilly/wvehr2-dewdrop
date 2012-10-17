PSO327PI        ;VGH-CARRIAGE RETURNS IN HL7 RECORDS - RESEND ;3/11/09
        ;;7.0;OUTPATIENT PHARMACY;**327**;MAR 2009;Build 4
        ;THIS ROUTINE WILL ALLOW USERS TO ENTER THE PRESCRIPTION NUMBER THAT NEEDS TO BE RESENT TO THE HDR.
EN      ;
        D INIT
        S PSODONE=0
        F  D PROMPT Q:PSODONE
        Q
PROMPT  ;DIC READ
        W !!
        K DIC,X,Y
        S DIC=52,DIC(0)="AEQXZ"
        D ^DIC
        I Y<1 S PSODONE=1 Q
        S PSORXIEN=$P(Y,"^"),PSORX=$P(Y,"^",2)
        S PSOPAT=$P(Y(0),"^",2)
        S PSODPT=$G(^DPT(PSOPAT,0))
        S PSOPAT=$P(PSODPT,"^")
        S PSOSSN=$E($P(PSODPT,"^",9),6,9)
        W !,"Rx IEN: "_PSORXIEN
        W !,"Patient: "_PSOPAT_"   ("_PSOSSN_")",!
        K DIR S DIR("A")="Is this Correct? "
        S DIR(0)="SA^1:YES;0:NO"
        S DIR("?")="Enter Y to resend the Prescription to the HDR"
        D ^DIR
        I Y<1 Q
        D RESEND
        W "  ... SENT"
        Q
RESEND  ;RESEND PRESCRIPTION BACK TO HDR
        D EN^PSOHDR("PRES",PSORXIEN)
        Q
INIT    ;INITIALIZE VARIABLES
        K PSORX,PSORXIEN,PSOPAT,PSODONE,PSOSSN,PSODPT
        K DIR,DIC,X,Y
        Q
