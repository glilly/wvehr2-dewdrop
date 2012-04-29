IMRERR ;ISC-SF/JLI/WAA-ERROR TO GENERATE AN ALERT ON INVALID ACCESS TRAPPING ;3/3/99  15:39
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**6**;Feb 09, 1998
 ;
ACESSERR ;
 S X="N",%DT="TS" D ^%DT
 S ^IMR(158.8,Y,0)=Y_U_DUZ_U_IMRLOC,^IMR(158.8,"B",Y,Y)="",^(0)=$P(^IMR(158.8,0),U,1,2)_U_Y_U_($P(^(0),U,4)+1)
 S X="BADACESS" D @X
 D H^XUS K %DT,X,Y,IMRLOC,DIC
 Q
 ;
 ;  The following entries are referenced by the "SCR" nodes associated
 ;  with the files used in this package.
 ;
SETA ;
SETMGR(ACCESS) ; This change was made on 3/3/99 by WAA
 ; Input:
 ;       ACCESS=File DD Number
 ;
 S IMRLOC="File Access "_$G(ACCESS) D ACESSERR
 Q
BADACESS ;
 W !!!!!,"     YOU HAVE INSUFFICIENT SECURITY TO ACCESS THIS OPTION"
 W !,"     SEE YOUR IMMUNOLOGY COORDINATOR FOR THE PROPER KEYS",!!
ALERT N XX,XQA
 S STAT=$O(^IMR(158.9,0)) Q:STAT'>0
 S XX=0 F  S XX=$O(^IMR(158.9,STAT,1,"B",XX)) Q:XX'>0  S XQA(XX)=""
 Q:'$D(XQA)
 S XQAID="IMR ACCESS VIOLATION NOTICE"
 D NOW^%DTC S IMRT=$E(%,4,5)_"/"_$E(%,6,7)_"/"_(1700+$E(%,1,3))_" @"_$E($P(%,".",2),1,1)_":"_$E($P(%,".",2),3,4)
 I DUZ>0 S NAME=$$GET1^DIQ(200,DUZ,.01),NAME=$G(NAME)
 S IMRY0=$G(XQY0)
 S XQAMSG="IMR ACCESS VIOLATION BY "_NAME_"  "_IMRT_" "_$P($G(IMRY0),U)
 S XQADATA=NAME_"^"_IMRT_"^"_$G(IMRLOC)_"^"_$P(IMRY0,U)_"^"_$P(IMRY0,U,2)
 S XQAFLAG="R"
 S XQAROU="LOOK^IMRERR"
 D SETUP^XQALERT
 H 4
 Q
LOOK ;
 S IMRN=$P(XQADATA,U),IMRT=$P(XQADATA,U,2),IMROI="["_$P(XQADATA,U,4)_"]"
 S IMROO=$P(XQADATA,U,5),IMRLOC=$P(XQADATA,U,3)
 W @IOF
 W !,"IMR - IMMUNOLOGY UNATHORIZED ACCESS ATTEMPT",!
 W !,"An attempt was made to invoke IMR functionality by a person who does"
 W !,"not have the neccessary Security Keys.  Details of this attempt"
 W !,"are as follows:"
 W !!,"Violator's Name:  "_IMRN
 W !,"Time:             "_IMRT
 W !,"VIOLATION:        ",$S($G(IMRLOC)'="":IMRLOC,1:"UNKNOWN")
 W !!,"ACCESS WAS ATTEMPTED BUT NOT GAINED",!!
 N DIR S DIR(0)="E" D ^DIR
 Q
