VEPERI7 ;DAOU/WCJ - Incoming HL7 messages ;2-MAY-2005
 ;;1.0;VOEB;;Jun 12, 2005
 ;;;VISTA OFFICE/EHR;
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ; Process patients from the pending file
 ; New patients were put in a holding file until the user acts on them.
 ; This is where the user acts on them.
 Q
 ;
EN ;
 ;
 N DIC,DIR,IEN,TAG,X,Y,RESULT,I,ADD,DFN,IENS,DA,IENS
 N DIE,DR,PATIENT,NAME,DOB,SEX,FID
 ;
 ; Look up record in holding file
 ;
 S DIC=19904.21,DIC(0)="AEQMZ"
 S DIC("S")="I $P(^(0),U,10)="""",$P(^(0),U,11)="""""
 S DIC("A")="Enter Patient Name (LAST,FIRST) or Billing System ID: "
 D ^DIC
 Q:Y<0
 S IEN=+Y,NAME=$P(Y(0),U,2),DOB=$P(Y(0),U,3),SEX=$P(Y(0),U,4),FID=$P(Y(0),U,6)
 ;
 ; Ask what do do
 ;
 S DIR(0)="S^N:NEW;E:EXISTING;R:REJECT"
 S DIR("A")="PATIENT TYPE "
 S DIR("B")="N"
 D ^DIR
 Q:X=""
 ;
 ; Get more info is needed for the various actions
 ;
 S TAG=$S(X="N":"NEW",X="E":"EXIST",X="R":"REJECT",1:"")
 Q:TAG=""
 D @TAG
 I '$G(ADD),$G(DFN)<0 Q
 ;
 ; See if there are any others like this one
 ;
 S IENS=$$OTHERS()
 Q:'IENS
 ;
 ; At this point, I have all the IEN's for this patient, the DFN
 ; if it's an existing patient, or a flag saying it is new.
 ;
 D PENDING^VEPERI0($G(IENS),.DFN)
 ;
 ; If no DFN, then this was the first occurance of a new patient and there was
 ; an error.  It is no longer a pending add so reject it.
 ;
 I '$G(DFN) S IEN=$P(IENS,",") D REJECT Q
 ;
 F I=1:1 S IEN=$P(IENS,",") Q:IEN=""  D STAMPDFN
 Q
 ;
 ; New Patient, make sure
 ;
NEW S ADD=0
 S DIR(0)="S^Y:YES;N:NO"
 S DIR("A")="OK TO ADD "
 S DIR("B")="Y"
 D ^DIR
 I X="Y" S ADD=1
 Q
 ;
 ; This patient was picked as an existing patient
 ; since the lookup rotuine couldn't figure it out, the user needs to link them.
 ;
EXIST ;
 N ENAME,ESEX,EDOB,EFID
 S DFN=0
 S DIC=2
 S DIC(0)="AEQMVZ"
 S DIC("A")="Which existing patient ? "
 D ^DIC
 I Y<0 Q
 S PATIENT=+Y
 S ENAME=$P(Y(0),U,1)
 S ESEX=$P(Y(0),U,2)
 S EDOB=$P(Y(0),U,3)
 S EFID=$$GET1^DIQ(9000001,+Y_",",19907)
 W !!,"INTERFACE",?20,"VOE SYSTEM"
 W !,NAME,?20,ENAME
 W !,SEX,?20,ESEX
 W !,DOB,?20,EDOB
 W !,FID,?20,EFID,!!
 S DIR(0)="S^Y:YES;N:NO"
 S DIR("A")="OK TO FILE "
 D ^DIR
 I X="Y" S DFN=PATIENT
 Q
 ;
 ; Either a user rejected this or it errored upon processing
REJECT ;
 S DIE=19904.21,DR=".1///NOW",DA=IEN
 D ^DIE
 Q
 ;
 ; Stamp the record with the patient that is was matched with
STAMPDFN ;
 S DIE=19904.21,DR=".11///^S X=DFN",DA=IEN
 D ^DIE
 Q
 ;
 ; Look for mulitple occurrances of this patientfor them all to be processed
 ; return a string of IENS from file 772 (the pointed to file)
OTHERS() ;
 N IENS,SCREEN,RESULT
 S SCREEN="I $P(^(0),U,10)="""",$P(^(0),U,11)="""",$P(^(0),U,3)=DOB,$P(^(0),U,4)=SEX,$P(^(0),U,6)=FID"
 D FIND^DIC(19904.21,,,"CMO",NAME,"CD",,SCREEN,,"RESULT","ERR")
 I '+$G(RESULT("DILIST",0)) Q 0
 S IENS=""
 F I=1:1 Q:'$D(RESULT("DILIST",1,I))  S IENS=IENS_RESULT("DILIST",1,I)_$S($D(RESULT("DILIST",2,I+1)):",",1:"")
 Q IENS
 ;
 ; simple report of patients awaiting action
REPORT ;
 N DIC,FLDS,BY,L
 S DIC=19904.21,FLDS="[NEW PATIENTS]",BY="[NEW PATIENTS]",L=0
 D EN1^DIP
 Q
