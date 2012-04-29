MAGQBIM ;WOIFO/RMP - Import functions  ;19 Nov 2001 1:23 PM
 ;;3.0;IMAGING;**7,20**;Apr 12, 2006
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
 ;
 Q
ENTRY(QP,QUE,QP2,ZN,RES) ;
 K OUT,ERR,IEN
 S IEN=$S($P(ZN,U,11)?1N.N:$P(ZN,U,11),1:QP)
 D FIND^DIC(2006.041,"","@;.02","PQ",IEN,1,"","","","OUT","ERR")
 I ($D(ERR)!($P($G(OUT("DILIST",0)),U)<1)) D  Q
 . D QSTAT^MAGQBTM(IEN,QUE_" Dequeue Failed on TrackId lookup.",QUE,$$PLACE^MAGBAPI(+$G(DUZ(2))))
 . S RES="0"_U_QP2_U_" Dequeue Failed on TrackId lookup."
 . Q
 N VALUE
 S VALUE=$P(OUT("DILIST",1,0),U,2)
 S RES=QP_U_VALUE_U_$TR($P(ZN,U,10),"|",U)_U_IEN
 S $P(RES,U,8)=+$P(ZN,U,9)
 Q
STAT(QP,TIME,MESS) ;
 N TRACKID
 K OUT,ERR,FDA
 S FDA(2006.041,"+1,",.01)=QP
 D FIND^DIC(2006.041,"","@;.02","PQ",QP,1,"","","","OUT","ERR")
 Q:$D(ERR)
 Q:$P(OUT("DILIST",0),U)<1
 S TRACKID=$P(OUT("DILIST",1,0),U,2)
 S FDA(2006.041,"+1,",.02)=TRACKID
 S FDA(2006.041,"+1,",1)="BP QUEUE STATUS"
 S FDA(2006.041,"+1,",2)=TIME
 S FDA(2006.041,"+1,",3)=MESS
 D UPDATE^DIE("U","FDA","","MAGIMP")
 Q
TIDL(QP,QUE,RES) ;
 K OUT,ERR
 S RES=0
 D FIND^DIC(2006.041,"","@;.02","PQ",QP,1,"","","","OUT","ERR")
 I ($D(ERR)!($P($G(OUT("DILIST",0)),U)<1)) D  Q
 . D QSTAT^MAGQBTM(QP,QUE_"      Requeue Failed on TrackId lookup.",QUE,$$PLACE^MAGBAPI(+$G(DUZ(2))))
 . Q
 S RES=$P($G(OUT("DILIST",1,0)),U,2)
 Q
