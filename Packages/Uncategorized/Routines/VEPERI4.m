VEPERI4 ;DAOU/WCJ - Incoming HL7 messages ;2-MAY-2005
 ;;1.0;VOEB;;Jun 12, 2005
 ;;;VISTA OFFICE/EHR;
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ;  Set up as INTERFACE,BILLING user.
 ;  If there isn't one, add one first
 Q
 ;
 ; Sets up needed variables DUZ, DUZ(1), DUZ(2), DUZ("AG"), ...
 ; for user INTERFACE,BILLING.  If the user is not on file, it will
 ; be added.
 ;
 ; Returns Fatal Error if BAD things happened
 ;
GETUSER(DUZ,FE,HLMTIEN) ;
 S FE=0
 D ADDUSR(.DUZ)
 ;
 I 'DUZ S FE=$$FATALERR^VEPERI6(1,"USER","CAN'T FIND/ADD INTERFACE,BILLING USER",HLMTIEN) Q
 ;
 D DUZ^XUP(DUZ)
 Q
 ;
 ; This will add a user INTERFACE,BILLING to file 200.
 ; DUZ which is passed in by reference will either be returned with
 ; the entry number to 200 or a 0 if something bad happened.
 ;
ADDUSR(DUZ) ;
 N DR,DIC,DIE,D0,X,Y,DA
 N FDA,MSG,VER,ACC,MENU,IENS,IEN
 ;
 ; Check to see if User already exists
 S DUZ=0
 S X="INTERFACE,BILLING"
 S Y=$$FIND1^DIC(200,"","B",X,"","")
 ;
 ; Found more than one.  BAD
 I Y="" Q
 ;
 ; Found one.  GOOD
 I Y>0 S DUZ=+Y Q
 ;
 ; Found none. Add New Person.  OK
 S DIC="^VA(200,",DIC(0)="L"
 D FILE^DICN I Y<1 Q
 S (DUZ,IEN)=+Y
 ;
 S $P(^VA(200,IEN,0),U,4)="@"   ; give them real access
 ;
 ; add some fields to 200
 S ACC="49668467798373",VER="738379354950678466"
 S IENS=IEN_","
 S FDA(200,IENS,200.05)=0
 S FDA(200,IENS,200.04)=1
 S FDA(200,IENS,1)="BCI"
 S FDA(200,IENS,2)=ACC
 S FDA(200,IENS,11)=VER
 S FDA(200,IENS,7.2)=1
 S FDA(200,IENS,201)="Systems Manager Menu"
 K ^VA(200,"AOLD",ACC)  ;Delete old Access code
 K ^VA(200,IEN,"VOLD")  ;Kill off old verify codes for user
 D UPDATE^DIE("","FDA","IENS","MSG")
 ;
 ; add division to subfile
 K FDA,MSG,IENS
 S IENS="?2,"_IEN_","
 S FDA(200.02,IENS,.01)="VISTA EHR"
 S FDA(200.02,IENS,1)="Y"
 D UPDATE^DIE("","FDA","IENS","MSG")
 Q
