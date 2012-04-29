HLCSQUE ;ALB/MFK HL7 UTILITY FUNCTIONS - 10/4/94 11AM ;05/08/2000  11:07
 ;;1.6;HEALTH LEVEL SEVEN;**14,61,59**;Oct 13, 1995
ENQUEUE(IEN,HLDIR) ;Assign a message for queue entry
 ; INPUT: IEN  - Internal Entry Number for file 870 - HL7 QUEUE
 ;        HLDIR  - Direction of queue (IN/OUT)
 ; OUTPUT: BEG - Location in the queue to stuff the message
 ;        -1   - Error
 ; NOTE: All the locks have been commented out.
 N FRONT,BACK,DIC,DA,X,BP,FP,REC,DINUM,ENTRY,Y,RETURN,BPOINTER
 N FPOINTER,HLCNT
 ;  Make sure required variables were given
 S IEN=$G(IEN)
 Q:(IEN="") "-1^Queue not given"
 I +IEN<1 S IEN=$O(^HLCS(870,"B",IEN,""))
 Q:(IEN="") "-1^Invalid queue"
 S HLDIR=$G(HLDIR)
 S HLDIR=$S(HLDIR="1":"IN",HLDIR=2:"OUT",1:HLDIR)
 I HLDIR'="IN",(HLDIR'="OUT") Q "-1^Invalid Direction"
 I HLDIR="IN" S HLDIR=1,BPOINTER="IN QUEUE BACK POINTER",FPOINTER="IN QUEUE FRONT POINTER"
 I HLDIR="OUT" S HLDIR=2,BPOINTER="OUT QUEUE BACK POINTER",FPOINTER="OUT QUEUE FRONT POINTER"
 F  L +^HLCS(870,IEN,FPOINTER):1 Q:$T  H 1
 S FRONT=$G(^HLCS(870,IEN,FPOINTER))
 L -^HLCS(870,IEN,FPOINTER)
 D DELETE^HLCSQUE1(IEN,HLDIR,FRONT)
 F  L +^HLCS(870,IEN,BPOINTER):1 Q:$T  H 1
 S BACK=$G(^HLCS(870,IEN,BPOINTER))
 ; Set up DICN call
 S DIC="^HLCS(870,"_IEN_","_HLDIR_","
 S ENTRY=HLDIR+18
 S DIC(0)="LNX",DA(1)=IEN,DIC("P")=$P(^DD(870,ENTRY,0),"^",2)
 S (DINUM,X)=BACK+1
 ;  Create Record
 K DD,DO
 F  L +^HLCS(870,IEN,HLDIR):1 Q:$T  H 1
 F HLCNT=0:1 D  Q:Y>0  H HLCNT
 . D FILE^DICN
 S REC=$P(Y,"^",1)
 ;  Set the 'status' to 'S' for stub
 S $P(^HLCS(870,IEN,HLDIR,REC,0),"^",2)="S"
 S ^HLCS(870,IEN,BPOINTER)=BACK+1
 ;  Put queue pointers back
 S RETURN=IEN_"^"_REC
EXIT1 ;  Unlock and return results
 L -^HLCS(870,IEN,HLDIR)
 L -^HLCS(870,IEN,BPOINTER)
 K IEN,HLDIR
 Q RETURN
DEQUEUE(IEN,HLDIR) ;Release the next message from the queue
 N MSG,RETURN,FRONT,FP,BACK,POINTER
 S IEN=$G(IEN)
 Q:(IEN="") "-1^Queue not given"
 I +IEN<1 S IEN=$O(^HLCS(870,"B",IEN,""))
 Q:(IEN="") "-1^Invalid queue"
 S HLDIR=$G(HLDIR)
 S HLDIR=$S(HLDIR="1":"IN",HLDIR=2:"OUT",1:HLDIR)
 I HLDIR'="IN",(HLDIR'="OUT") Q "-1^Invalid Direction"
 I HLDIR="IN" S HLDIR=1,POINTER="IN QUEUE FRONT POINTER"
 I HLDIR="OUT" S HLDIR=2,POINTER="OUT QUEUE FRONT POINTER"
 F  L +^HLCS(870,IEN,POINTER):1 Q:$T  H 1
 S FRONT=$G(^HLCS(870,IEN,POINTER))
 L -^HLCS(870,IEN,POINTER)
 D DELETE^HLCSQUE1(IEN,HLDIR,FRONT)
 ;If queue empty or "Stub" record don't dequeue
 F  L +^HLCS(870,IEN,HLDIR,FRONT+1,0):1 Q:$T  H 1
 I '$D(^HLCS(870,IEN,HLDIR,FRONT+1,0)) S RETURN="-1^NO NEXT RECORD" G EXIT2
 I ($P($G(^HLCS(870,IEN,HLDIR,FRONT+1,0)),"^",2)'="P") S RETURN="-1^STUB" G EXIT2
 ; for status "P"
 S ^HLCS(870,IEN,POINTER)=FRONT+1
 S RETURN=IEN_"^"_(FRONT+1)
 ;  Return success
EXIT2 ;
 L -^HLCS(870,IEN,HLDIR,FRONT+1,0)
 L -^HLCS(870,IEN,POINTER)
 Q RETURN
CLEARQUE(IEN,HLDIR) ;Empty an entire queue
 ; IEN - Entry number for queue - can be name from "B" X-ref
 ; HLDIR - Can be "IN", "OUT", 1 or 2.
 ; output: 0 for success
 ;        -1^error for error
 N MSG,X,ERR,FP,BP
 ;NOTE: this is not needed to initialize a queue
 ; enqueue will set up (?) a new queue
 ;  Make sure that required variables exist
 S IEN=$G(IEN)
 Q:(IEN="") "-1^Internal Entry Number missing"
 I +IEN<1 S IEN=$O(^HLCS(870,"B",IEN,""))
 Q:(IEN="") "-1^Invalid IEN"
 ;  Convert direction to a number
 S HLDIR=$G(HLDIR)
 Q:(HLDIR'="IN")&(HLDIR'="OUT")&(HLDIR'=1)&(HLDIR'=2) "-1^Invalid direction"
 S HLDIR=$S(HLDIR="IN":1,HLDIR="OUT":2,HLDIR=2:2,1:1)
 ;  If in queue, set front pointer to 6, out pointer gets set to 8
 I HLDIR=1 S FP="IN QUEUE FRONT POINTER",BP="IN QUEUE BACK POINTER"
 I HLDIR=2 S FP="OUT QUEUE FRONT POINTER",BP="OUT QUEUE BACK POINTER"
 S MSG=0
 W !
 ;  Loop through and delete messages
 F  S MSG=$O(^HLCS(870,IEN,HLDIR,MSG)) Q:(MSG'>0)  D
 .S ERR=$$DELMSG^HLCSQUE1(IEN,HLDIR,MSG) W "."
 .I ERR W ERR,!
 ;  Clear front and back pointers
 S ^HLCS(870,IEN,FP)=0
 S ^HLCS(870,IEN,BP)=0
 ;K IEN,HLDIR
 Q 0
 ;
PUSH(HLDOUT0,HLDOUT1) ;-- Place message back on queue
 ;  INPUT - HLDOUT0 IEN of file 870
 ;          HLDOUT1 IEN of Out Multiple
 ;  OUTPUT- NONE
 ;
 ;-- exit if not vaild variables
 I 'HLDOUT0!'HLDOUT1 G PUSHQ
 ;-- exit if global does not already exist
 I '$D(^HLCS(870,HLDOUT0,"OUT QUEUE FRONT POINTER")) G PUSHQ
 S ^HLCS(870,HLDOUT0,"OUT QUEUE FRONT POINTER")=(HLDOUT1-1)
PUSHQ Q
 ;
