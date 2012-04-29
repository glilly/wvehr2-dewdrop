MAGQBUT5 ;WOIFO/RMP - BP Utilities  ;Oct 21, 2005 1:23 PM
 ;;3.0;IMAGING;**20**;Apr 12, 2006
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed             |
 ;; | in any way.  Modifications to this software may result in an  |
 ;; | adulterated medical device under 21CFR820, the use of which   |
 ;; | is considered to be a violation of US Federal Statutes.       |
 ;; +---------------------------------------------------------------+
 ;;
AI(RESULT) ; List of Associated Institution candidates;
 N INDEX,INST,J,K,L,OUT
 S K=0
 S RESULT(K)=""
 S K=K+1
 D LIST^DIC(40.8,,".01;.07I",,,,,,,,"OUT")
 S RESULT(K)="The following Medical Center Divisions have Imaging Site Parameters defined on",K=K+1
 S RESULT(K)="your system:" D
 . S INDEX=0,K=K+1 F  S INDEX=INDEX+1 Q:'$D(OUT("DILIST","ID",INDEX))  D
 . . S INST=OUT("DILIST","ID",INDEX,.07),J=0 F  S J=$O(^MAG(2006.1,J)) Q:'J  I $P(^MAG(2006.1,J,0),U)=INST D  Q
 . . . S RESULT(K)=OUT("DILIST","ID",INDEX,.01)_" "_INST,K=K+1 Q
 . . Q
 . Q
 I INDEX=1 S RESULT(K)="None",K=K+1
 S RESULT(K)="The following Medical Center Divisions have 'Associated Institutions' defined on",K=K+1
 S RESULT(K)="your system:" D
 . S INDEX="",K=K+1,L=K  F  S INDEX=$O(^MAG(2006.1,"B",INDEX)) Q:'INDEX  D
 . . Q:$P($G(^MAG(2006.1,$O(^MAG(2006.1,"B",INDEX,"")),0)),U)=INDEX
 . . S RESULT(K)=$P($G(^DIC(4,INDEX,0)),U)_" "_INDEX,K=K+1 Q
 . Q
 I K=L S RESULT(K)="None",K=K+1
 S RESULT(K)="The following Medical Center Divisions have NO Imaging parameter affiliations",K=K+1
 S RESULT(K)="defined on your system:" D
 . S INDEX=0,K=K+1,L=K F  S INDEX=INDEX+1 Q:'$D(OUT("DILIST","ID",INDEX))  D
 . . S INST=OUT("DILIST","ID",INDEX,.07) Q:$D(^MAG(2006.1,"B",INST))  D
 . . . S RESULT(K)=OUT("DILIST","ID",INDEX,.01)_" "_INST,K=K+1 Q
 . . Q
 . Q
 I K=L S RESULT(K)="None",K=K+1
 K OUT
 D CLEAN^DILF
 Q
PLNM(PLACE) ;  Returns the Institution name of the Place
 N INST
 Q:'PLACE " "
 S INST=$P($G(^MAG(2006.1,PLACE,0)),U)
 Q $P($G(^DIC(4,INST,0)),U)
TPMESS(PLACE) ;Trigger a purge message
 N Y,LOC,CNT,XMSUB
 D NOW^%DTC S Y=% D DD^%DT
 S LOC=$$KSP^XUPARAM("WHERE")
 S CNT=1,^TMP($J,"MAGQ",CNT)="SITE: "_LOC
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="DATE: "_Y_" "_$G(^XMB("TIMEZONE"))
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="SENDER: "_$$PLNM^MAGQBUT5(PLACE)_" Imaging Background Processor"
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="An automatic purge event has been initiated"
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="in order to maintain adequate image storage"
 S CNT=CNT+1,^TMP($J,"MAGQ",CNT)="no operator intervention is required."
 S XMSUB="Vista Imaging BP Queue processor - Autopurge"
 D MAILSHR^MAGQBUT1
 Q
 ;
