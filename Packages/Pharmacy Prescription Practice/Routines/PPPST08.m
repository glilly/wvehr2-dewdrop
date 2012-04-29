PPPST08 ;ALB/JFP - PPP, SET UP MAIL GROUP;01MAR94
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
MAIL() ; Main entry point for adding mail group.
 ; INPUT  :  NONE
 ; OUTPUT :  0 - success
 ;          -1 - unsucessful
 ;
 ; (note: These calls will change to the support mailman entry pts
 ;        once they are verified.
 ;
MGEDT ; Add the Prescription Practices Mailgroup
 ;
 N Y,X,DA,DIC,DR,DUOUT,DTOUT,DIE,OUTCODE
 S OUTCODE=0
 S Y=$O(^XMB(3.8,"B","PRESCRIPTION PRACTICES",0))
 I 'Y D
 .S DIC(0)="L",DIC=3.8,X="PRESCRIPTION PRACTICES"
 .S DLAYGO=3.8
 .D ^DIC
 W !
 I +Y>0 D
 .W !!,">>> Please Add Users To Mail Group..."
 .S DA=+Y,DIE=3.8
 .S DR="3///Used to alert users of problems encountered with the Prescription Practices Utilities."
 .S DR(1,3.8,1)="4///private"
 .S DR(1,3.8,2)="5////"_DUZ
 .S DR(1,3.8,3)="10///UNRESTRICTED"
 .S DR(1,3.8,4)="2"
 .D ^DIE
 E  S OUTCODE=-1
 Q OUTCODE
 ;
 ;
MAIL1() ; -- Adds new mail group members
 ;
 ; INPUT  :  NONE
 ; OUTPUT :  0 - success
 ;          -1 - unsucessful
 ;
 ; (note: These calls uses the API in Mailman v7.1 for creating mail
 ;        groups
 ;
 N IPPP,DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 N APPP,BPPP,CPPP,DPPP,EPPP,FPPP,GPPP,ERR
 ;
 W !!,">>> Please add Users to the Prescription Practices Mail Group..."
 F IPPP=1:1 D  Q:$D(DIRUT)
 .S DIR(0)="PO^200:EQM"
 .S DIR("A")="Select Member"
 .S DIR("B")=""
 .D ^DIR
 .I $D(DIRUT) Q
 .S EPPP($P(Y,"^",1))=""
 K DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 ;
MG1 ; -- Inputs:
 S APPP="PRESCRIPTION PRACTICES"
 S BPPP="1" ; -- private
 S CPPP=$G(DUZ)
 S DPPP="1" ; -- no
 S EPPP=""
 S FPPP(1)="Used to notify users of problems encountered with the Prescription Practices Utilities"
 S GPPP="1" ; -- silent
 ;
 ; -- Outputs
 ;       X - sucessful value of mail group number
 ;         - unsucessful 0
 ; -- Call
 S ERR=$$MG^XMBGRP(APPP,BPPP,CPPP,DPPP,.EPPP,.FPPP,GPPP)
 I ERR>0 D  Q 0
 .W !,"Mail group created..entry number = ",ERR
 Q -1 ; -- error
 ;
