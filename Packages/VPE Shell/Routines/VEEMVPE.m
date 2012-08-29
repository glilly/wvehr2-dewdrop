VEEMVPE ;DJB,VPE**Edit PERSON ; 9/13/02 5:28pm
 ;;12;VPE;;
 ;
EN ;
 NEW FLAGQ,VEEPERI,VEEPERN
TOP W @IOF
 W !,"*** ENTER/EDIT PERSON ***",!
 S FLAGQ=0
 D GETPER G:FLAGQ EX
 D EDIT
 G TOP
EX ;
 Q
 ;
GETPER ;Select a Person
 ;Return:
 ;   VEEPERI...Person IEN
 ;   VEEPERN...Person name
 ;   FLAGQ.....Quit variable
 ;
 NEW %,%Y,DDH,DIC,X,Y
 S DIC="^VEE(19200.111,"
 S DIC(0)="QEAML"
 S DIC("A")="Select PERSON: "
 D ^DIC I Y<0 S FLAGQ=1 Q
 S VEEPERI=+Y,VEEPERN=$P(Y,"^",2)
 Q
 ;
EDIT ;Edit Person
 NEW DA,DIERR,DIMSG,DINUM,DR,DTOUT,DUTOUT,I
 NEW DDSFILE,DDSPAGE,DDSPARM,DDSSAVE,DIERR
 ;
 S DDSFILE=19200.111
 S DA=VEEPERI
 S DR="[VEEM PER]"
 S DDSPARM="CE"
 D ^DDS
 I $G(DIERR) D DDSERR Q  ;... process error & quit
 Q
 ;
DDSERR ;Form couldn't load
 NEW I
 W @IOF,!!,"Screenman couldn't load this form."
 S I=0
 F  S I=$O(^TMP("DIERR",$J,1,"TEXT",I)) Q:I'>0  W !,^(I)
 D PAUSE^%ZVEMKU(2,"R")
 KILL ^TMP("DIERR",$J)
 Q
