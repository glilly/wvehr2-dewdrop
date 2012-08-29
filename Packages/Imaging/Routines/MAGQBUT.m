MAGQBUT ;WOIFO/RMP - Imaging Background Processor Utilities [ 03/25/2001 11:20 ]
 ;;3.0;IMAGING;**7,8,48,20**;Apr 12, 2006
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
FTYPE(RESULT) ;
 ; RPC[MAGQ FTYPE]
 S X="ERR^MAGQBTM",@^%ZOSF("TRAP")
 N MAX,INDX,PLACE
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S U="^",MAX=$P(^MAG(2006.1,PLACE,2,0),U,4),INDX=0
 Q:+MAX<1
 F  S INDX=$O(^MAG(2006.1,PLACE,2,INDX)) Q:INDX'?1N.N  D  Q:INDX=MAX
 . S RESULT(INDX-1)=$G(^MAG(2006.1,PLACE,2,INDX,0))
 Q
CHGSERV(RESULT,NOTIFY) ;
 ; RPC[MAGQ FS CHNGE]
 S X="ERR^MAGQBTM",@^%ZOSF("TRAP")
 N SPACE,DATA,IEN,SIZE,CWL,MIN,CNT,TNODE,TINT,NOW,TLTIME,TOD,PLACE,TS,AUTON
 S U="^",(INDX,SPACE,SIZE,CNT)=0,(RESULT,IEN)=""
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S MIN=$$SPARM
 S CWL=$$CWL^MAGBAPI(PLACE)
 S DATA=$S(CWL?1N.N:$G(^MAG(2005.2,CWL,0)),1:0)
 ;Check for scheduled purge
 S AUTON=$G(^MAG(2006.1,PLACE,5))
 I $P(AUTON,U,3) D
 . N T1,T2
 . S T1="0000",T2=$P(AUTON,U,5),T1=$E(T1,1,($L(T1)-$L(T2)))_T2
 . I ($$FMADD^XLFDT($$NOW^XLFDT,-$P(AUTON,U,4),"","",""))>($P(AUTON,U,6)_"."_T1) D
 . . S $P(RESULT,U,4)="PURGE"
 . . S $P(^MAG(2006.1,PLACE,5),U,6)=$P($$NOW^XLFDT,".")
 . . Q
 . Q
 I $P($G(^MAG(2006.1,PLACE,1)),U,10) D  Q  ;Cache balancing off
 . S SPACE=+$P($G(^MAG(2005.2,CWL,0)),U,5),SIZE=+$P($G(^MAG(2005.2,CWL,0)),U,3)
 . I (SIZE>0)&(((SPACE/SIZE)*100)>MIN) D  Q
 . . S $P(RESULT,U)=1
 . . D  Q
 . . . I SIZE S $P(RESULT,U,5)=$P(((SPACE/SIZE)*100),".")_"."_$E($P(((SPACE/SIZE)*100),".",2),1,2) Q
 . . . E  S $P(RESULT,U,5)="0.00" Q
 . E  D
 . . I SIZE S $P(RESULT,U,5)=$P(((SPACE/SIZE)*100),".")_"."_$E($P(((SPACE/SIZE)*100),".",2),1,2)
 . . E  S $P(RESULT,U,5)="0.00"
 . . S $P(RESULT,U)=$S(SPACE>0:2,1:0)
 . . S $P(RESULT,U,2,3)=$P(^MAG(2005.2,$P(^MAG(2006.1,PLACE,0),U,3),0),U,1,2)
 . . I ($P($G(^MAG(2006.1,PLACE,5)),U)&(SPACE>0)) S $P(RESULT,U,4)="PURGE" Q
 . . D:(NOTIFY!(SPACE>0)) TMESS(SPACE,PLACE)
 . . Q
 . Q
 D FSP(MIN,.SPACE,.SIZE,.IEN,.TS,PLACE)
 I SIZE S $P(RESULT,U,5)=$P(((SPACE/SIZE)*100),".")_"."_$E($P(((SPACE/SIZE)*100),".",2),1,2)
 E  S $P(RESULT,U,5)="0.00"
 I IEN D SCWL(IEN,PLACE)
 I SIZE>0,(((SPACE/SIZE)*100)>MIN) S $P(RESULT,U)=1 Q
 S $P(RESULT,U)=$S(SPACE>0:2,1:0)
 S $P(RESULT,U,2,3)=$P(^MAG(2005.2,$P(^MAG(2006.1,PLACE,0),U,3),0),U,1,2)
 I ($P($G(^MAG(2006.1,PLACE,5)),U)&(SPACE>0)) D  Q
 . S $P(RESULT,U,4)="PURGE"
 . D TPMESS^MAGQBUT5(PLACE)
 . Q
 D:(NOTIFY!(SPACE>0)) TMESS(TS,PLACE)
 Q
TMESS(TS,PLACE) ;Trigger a message
 N TN S TN=^MAG(2006.1,PLACE,3)
 Q:$$FMADD^XLFDT($P(TN,"^",11),"",$P(TN,"^",7),"","")>$$NOW^XLFDT
 D ICCL^MAGQBUT1(CNT_U_TS_U_SPACE_U_$P($G(^MAG(2006.1,PLACE,5)),U),$P(TN,"^",7)_" hours.",PLACE)
 Q
TPURGE ; 
 S $P(RESULT,U,2,3)=$P(^MAG(2005.2,$P(^MAG(2006.1,PLACE,0),U,3),0),1,2)
 S TNODE=^MAG(2006.1,PLACE,3)
 S TINT=$P(TNODE,"^",8) I "^W^D^"[("^"_TINT_"^") D  ;CONDITIONAL PURGE
 . S NOW=$$NOW^XLFDT,TOD=$P(TNODE,"^",9)
 . Q:NOW<$$FMADD^XLFDT($P(NOW,"."),"",TOD,"","")
 . S TLTIME=$P(TNODE,"^",10)
 . I NOW>$$FMADD^XLFDT(TLTIME,$S(TINT="D":1,TINT="W":7),"","","") D
 . . S $P(RESULT,"^",4)="PURGE"
 Q
MAXSP(IEN,FS,SZ,NODE,MIN) ;
 N SPACE,SIZE
 S SPACE=+$P(NODE,U,5),SIZE=+$P(NODE,U,3)
 I SIZE>0,(((SPACE/SIZE)*100)>MIN),SPACE>FS D  Q 1
 . S FS=SPACE,SZ=SIZE
 Q 0
HFIND(SHARE,IEN) ;HASHED SHARE AT THE SAME LOCATION
 N INDEX,NODE,RESULT
 S INDEX=0,RESULT=""
 F  S INDEX=$O(^MAG(2005.2,"AC",SHARE,INDEX)) Q:INDEX'?1N.N  D
 . Q:INDEX=IEN
 . I $P(^MAG(2005.2,INDEX,0),"^",8)="Y" S RESULT=1
 Q RESULT
SPARM() ;Site Parameter for PERCENT server space to be held in reserve
 N VALUE
 S VALUE=$P($G(^MAG(2006.1,$$PLACE^MAGBAPI(+$G(DUZ(2))),1)),U,8)
 Q $S(VALUE>0:VALUE,1:5)
SCWL(IEN,PLACE) ;
 S $P(^MAG(2006.1,PLACE,0),U,3)=IEN
 S $P(^MAG(2006.1,PLACE,"PACS"),U,3)=IEN
 Q
FSP(MIN,SPACE,SIZE,IEN,TOTAL,PLACE) ; Find Space
 N INDX,DATA S (TOTAL,INDX)=0
 F  S INDX=$O(^MAG(2005.2,INDX)) Q:INDX'?1N.N  D
 . S DATA=$G(^MAG(2005.2,INDX,0))
 . Q:$P(DATA,U,6,7)'["1^MAG"
 . Q:$P(DATA,U,9)="1"  ;ROUTING SHARE
 . Q:$P(DATA,U,10)'=PLACE
 . I $P(DATA,U,8)'="Y",$$HFIND($P(DATA,"^",2),INDX) Q
 . Q:$P(DATA,U,2)[":"
 . Q:$E($P(DATA,U,2),1,2)'="\\"
 . S TOTAL=TOTAL+(+$P(DATA,U,5))
 . S CNT=CNT+1
 . I $$MAXSP(INDX,.SPACE,.SIZE,DATA,MIN) S IEN=INDX
 Q
SLAD(RESULT) ;SITE LAST ACCESS DATE(DEFAULT TO 180)
 N PLACE
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 S RESULT=$S(+$P(^MAG(2006.1,PLACE,1),"^",2):+$P(^MAG(2006.1,PLACE,1),"^",2),1:180)
 Q
DQUE(QIEN) ;
 N ZNODE,TYPE,MAGIEN,PLACE,QP,QT
 S ZNODE=$G(^MAGQUEUE(2006.03,QIEN,0))
 S PLACE=$P(ZNODE,U,12)
 S TYPE=$P(ZNODE,U)
 I TYPE="" D DBQ(QIEN,PLACE,ZNODE) Q
 S QP=$O(^MAGQUEUE(2006.031,"C",PLACE,TYPE,""))
 L +^MAGQUEUE(2006.031,QP,0)
 S QT=+$P($G(^MAGQUEUE(2006.031,QP,0)),U,5)
 S $P(^MAGQUEUE(2006.031,QP,0),U,5)=QT-1
 L -^MAGQUEUE(2006.031,QP,0)
 K ^MAGQUEUE(2006.03,"C",PLACE,$P(ZNODE,U),QIEN)
 K ^MAGQUEUE(2006.03,QIEN,0)
 I $P(ZNODE,U,5)]"" D
 . K ^MAGQUEUE(2006.03,"D",PLACE,TYPE,$E($P(ZNODE,U,5),1,30),QIEN)
 L +^MAGQUEUE(2006.03,0)
 S $P(^MAGQUEUE(2006.03,0),"^",4)=$P(^MAGQUEUE(2006.03,0),"^",4)-1
 L -^MAGQUEUE(2006.03,0)
 Q:("^JBTOHD^PREFET^JUKEBOX^")'[("^"_TYPE_"^")
 S MAGIEN=$P(ZNODE,U,7)
 Q:'MAGIEN
 I TYPE="JUKEBOX" D  Q
 . K ^MAGQUEUE(2006.03,"E",PLACE,MAGIEN,QIEN)
 I "^JBTOHD^PREFET^"[("^"_TYPE_"^") D  Q
 . Q:$P(ZNODE,U,8)']""
 . K ^MAGQUEUE(2006.03,"F",PLACE,MAGIEN,$P(ZNODE,U,8),QIEN)
 . Q
 Q
DQUE1(RESULT,QIEN) ;[MAGQB QUEDEL]
 D DQUE(QIEN)
 Q
DBQ(QIEN,PLACE,ZNODE) ;
 N INDX
 F INDX="DELETE","ABSTRACT","JUKEBOX","JBTOHD","PREFET","IMPORT" D
 . K ^MAGQUEUE(2006.03,"C",PLACE,INDX,QIEN)
 . K:$P(ZNODE,U,5)]"" ^MAGQUEUE(2006.03,"D",PLACE,INDX,$E($P(ZNODE,U,5),1,30),QIEN)
 . I INDX="JUKEBOX" D
 . . K:$P(ZNODE,U,7) ^MAGQUEUE(2006.03,"E",PLACE,$P(ZNODE,U,7),QIEN) Q
 . I "^JBTOHD^PREFET^"[("^"_INDX_"^") D 
 . . K:($P(ZNODE,U,7)&$P(ZNODE,U,8)]"") ^MAGQUEUE(2006.03,"F",PLACE,$P(ZNODE,U,7),$P(ZNODE,U,8),QIEN) Q
 K ^MAGQUEUE(2006.03,QIEN,0)
 Q
JBQUE(RESULT,QIEN) ; RPC[MAGQBP JBQUE]
 S X="ERR^MAGQBTM",@^%ZOSF("TRAP")
 S RESULT=$$JUKEBOX^MAGBAPI(QIEN,$$PLACE^MAGBAPI(+$G(DUZ(2))))
 Q
POSTI ;
 D INI^MAGUSIT
 N DIC,X,DA,Y,NODE1,NODE3,PLACE,KEYS
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2)))
 Q:'PLACE
 S DIC="^MAG(2006.1,"_PLACE_",2,",DIC(0)="XL",X="TXT",DLAYGO="2006.112"
 S DA(1)=PLACE,DIC("P")="2006.112"
 D ^DIC
 S (DIE,DIC,DLAYGO)=2006.1,DA=PLACE,DIC(0)="XL"
 S NODE1=$G(^MAG(2006.1,1,1)),NODE3=$G(^MAG(2006.1,PLACE,3)),DR=""
 S KEYS=$G(^MAG(2006.1,PLACE,"KEYS"))
 S DR=$S(($P(NODE1,"^",2)'?1N.N):"8///45",1:DR)
 I ($P(NODE1,"^",5)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"9///45"
 I ($P(NODE1,"^",10)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"20///1"
 I ($P(NODE3,"^",1)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"21///45"
 I ($P(NODE3,"^",2)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"22///45"
 I ($P(NODE3,"^",3)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"23///120"
 I ($P(NODE3,"^",4)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"24///120"
 I ($P(NODE3,"^",5)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"102///10"
 I ($P(NODE3,"^",6)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"103///15"
 I ($P(NODE3,"^",7)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"11.5///6"
 S DR=DR_$S((DR["/"):";",1:"")_"11.6///D"
 I ($P(NODE3,"^",9)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"11.7///4"
 I ($P(NODE3,"^",10)'?1N.E) D
 . S DR=DR_$S((DR["/"):";",1:"")_"11.8///"_$$NOW^XLFDT
 I ($P(NODE3,"^",11)'?1N.E) D
 . S DR=DR_$S((DR["/"):";",1:"")_"11.9///"_$$NOW^XLFDT
 I ($P(KEYS,"^",2)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"121///60"
 I ($P(KEYS,"^",3)'?1N.N) S DR=DR_$S((DR["/"):";",1:"")_"122///90"
 D ^DIE
 ; Enable the Imaging Health Summary component
 I $D(^GMT(142.1,235)) D
 . S (DIE,DIC)=142.1,DA=235
 . S DR="5///@;8///@"
 . D ^DIE
 K DIE,DIC,DA,Y,X,DLAYGO,DR
 D MMGRP^MAGQAI
 Q
X1 ; CLEANUP
 N PC
 S DIR(0)="Y",DIR("B")="YES"
 S DIR("?")="This activity removes already processed queues which precede the current queue pointer.  These queues are not necessary for file recovery.The current BP software will recover files during purge or by the verify."
 S DIR("A")="Do you wish to remove old processed Background Processor Queues" D
 . D ^DIR Q:($D(DIRUT)!(Y'="1"))
 . F PC="JUKEBOX","JBTOHD","PREFET","IMPORT","GCC","DELETE" D FOQUE("",PC)
 ; REINDEX FIELD 4 (COMPLETION STATUS) IN FILE 2006.03 (QUEUE)
 K DIR
 K ^MAGQUEUE(2006.03,"C")
 S DIK="^MAGQUEUE(2006.03,"
 D IXALL^DIK K DIK
 K DIRUT
 Q
FOQUE(RESULT,PROC) ;[MAGQ COQ] PASS A BP PROCESS TO DELETE OLD FAILED QUEUES
 N XX,JXMAX,JHMAX,QIEN,PLACE,LQP,CNT
 S PLACE=$$PLACE^MAGBAPI(+$G(DUZ(2))),CNT=0
 S QIEN=$O(^MAGQUEUE(2006.031,"C",PLACE,PROC,""))
 I QIEN D
 . S LQP=$P($G(^MAGQUEUE(2006.031,QIEN,0)),"^",2)
 . Q:'LQP
 . S XX=0
 . F  S XX=$O(^MAGQUEUE(2006.03,"C",PLACE,PROC,XX)) Q:'XX  Q:XX>(LQP)  D
 . . S CNT=CNT+1
 . . D DQUE(XX)
 S RESULT=CNT
 Q
