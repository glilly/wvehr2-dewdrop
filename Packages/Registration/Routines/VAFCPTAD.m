VAFCPTAD ;ISA/RJS,Zoltan - ADD NEW PATIENT FROM QUERY ;APR 6, 1999
 ;;5.3;Registration;**149**;Aug 13, 1993
ADD(ARRAY) ;-- Adds new patient to local data base
 ; Input Format:
 ;    ARRAY(FIELD NUMBER)=FIELD VALUE.
 ; Example:
 ;    ARRAY(.01)=Patient Name
 ;
 ; Return Values:
 ;    On Failure:  -1^message (indicates failure condition.)
 ;    On Success:  DFN of new patient record.
 N DFN,LOCKFLE,FLD,ZTQUEUED,DIQUIET,RETURN,X,Y
 S (ZTQUEUED,DIQUIET)=1
 S DIC="^DPT(",DIC(0)="L",DLAYGO=2
 S X=$G(@ARRAY@(.01))
 K DD,D0 D FILE^DICN K DIC,DLAYGO
 I $P(Y,U,3)'=1 S RETURN="-1^COULD NOT ADD PATIENT TO PATIENT FILE" G EXIT
 ;-- Add rest of required data
 S (DFN,RETURN)=+Y
 L +^DPT(DFN):60
 ;
 I ('$T) S RETURN="-1^COULD NOT LOCK RECORD TO ADD PATIENT TO PATIENT FILE" G EXIT
 ;
 ;--Data needs to be loaded in a certain sequence
 ;
 S DA=DFN,DIE=2
 ;
 K DR
 S DR=".09////"_$G(@ARRAY@(.09))
 D ^DIE
 ;
 K DR
 S FLD=.03 D EDIT^VAFCPTED(DFN,ARRAY,FLD)
 ;
 W !
 W !,"NAME: "_$G(@ARRAY@(.01))
 W !,"SOCIAL SECURITY NUMBER: "_$G(@ARRAY@(.09))
 W !,"DATE OF BIRTH: "_$G(@ARRAY@(.03))
 W !
 S DR=".02;391;1901;.301"
 D ^DIE
 ;
 ;update 991.01,991.02,991.03
 N ERR
 S ERR=$$UPDATE^MPIFAPI(DFN,ARRAY)
 ;
 L -^DPT(DFN)
EXIT ;
 K DIE,DA,DR
 Q RETURN
