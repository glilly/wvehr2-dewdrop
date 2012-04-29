MAGDQR02 ;WOIFO/EdM - Imaging RPCs for Query/Retrieve ; 05/16/2005  09:30
 ;;3.0;IMAGING;**51**;26-August-2005
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
 Q
 ;
QUERY ; --- perform actual query --- Called by TaskMan
 N ACC,ANY,MAGD0,MAGD1,MAGD2,ERROR,FD,FT,I,IMAGE,L,LD,LT,OFFSET,P,PAT,SID,SSN,T,TIM,UID,V,X
 ;
 K ^TMP("MAG",$J,"QR")
 S (PAT,SSN,ACC,UID,SID,SDT,TIM,ERROR)=0
 S FD=0,LD=9999999,FT=0,LT=240000
 ;
 S T="0008,0020",I=0
 S P="" F  S P=$O(REQ(T,P)) Q:P=""  D:REQ(T,P)'=""
 . N F,U
 . S I=I+1 I I>1 D ERR^MAGDQR01("More than one study date specified.") Q
 . S (X,F,U)=REQ(T,P) S:X["-" F=$P(X,"-",1),U=$P(X,"-",2)
 . I F'="",F'?8N D ERR^MAGDQR01("Invalid 'from' date: """_F_""".")
 . I U'="",U'?8N D ERR^MAGDQR01("Invalid 'until' date: """_U_""".")
 . S FD=+F S:FD FD=FD-17000000
 . S LD=+U S:LD LD=LD-17000000
 . S TIM=1
 . Q
 ;
 S T="0008,0030",I=0
 S P="" F  S P=$O(REQ(T,P)) Q:P=""  D:REQ(T,P)'=""
 . N F,U
 . S I=I+1 I I>1 D ERR^MAGDQR01("More than one study time specified.") Q
 . S (X,F,U)=REQ(T,P) S:X["-" F=$P(X,"-",1),U=$P(X,"-",2)
 . D CHKTIM(F,"from")
 . D CHKTIM(U,"until")
 . S FT=+$E(F_"000000",1,6)
 . S LT=+$E(U_"000000",1,6)
 . S TIM=1
 . Q
 I ERROR D ERRSAV^MAGDQR01 Q
 ;
 S FD=FT/1E6+FD,LD=LT/1E6+LD
 ;
 S T="0010,0010",ANY=0
 S P="" F  S P=$O(REQ(T,P)) Q:P=""  D:REQ(T,P)'=""
 . ; The references below to ^DPT are permitted according to the
 . ; explicit permission in Section II of the PIMS V5.3 technical manual
 . ; (dated 23 Nov 2004)
 . S ANY=1
 . S I=$$MATCHD^MAGDQR03(REQ(T,P),"^DPT(""B"",LOOP)","^TMP(""MAG"",$J,""QR"",1,LOOP)")
 . S V="" F  S V=$O(^TMP("MAG",$J,"QR",1,V)) Q:V=""  D
 . . S I="" F  S I=$O(^DPT("B",V,I)) Q:I=""  S ^TMP("MAG",$J,"QR",2,I)="",PAT=1
 . . Q
 . Q
 I ANY,'PAT D  Q
 . D ERR^MAGDQR01("No matches for tag "_T)
 . D ERRSAV^MAGDQR01
 . Q
 ;
 S T="0010,0020",ANY=0
 S P="" F  S P=$O(REQ(T,P)) Q:P=""  D:REQ(T,P)'=""
 . ; The references below to ^DPT are permitted according to the
 . ; explicit permission in Section II of the PIMS V5.3 technical manual
 . ; (dated 23 Nov 2004)
 . S ANY=1
 . S I=$$MATCHD^MAGDQR03($TR(REQ(T,P),"-"),"^DPT(""SSN"",LOOP)","^TMP(""MAG"",$J,""QR"",3,LOOP)")
 . S V="" F  S V=$O(^TMP("MAG",$J,"QR",3,V)) Q:V=""  D
 . . S I="" F  S I=$O(^DPT("SSN",V,I)) Q:I=""  S ^TMP("MAG",$J,"QR",4,I)="",SSN=1
 . . Q
 . Q
 I ANY,'SSN D  Q
 . D ERR^MAGDQR01("No matches for tag "_T)
 . D ERRSAV^MAGDQR01
 . Q
 ;
 S T="0008,0050",ANY=0
 S P="" F  S P=$O(REQ(T,P)) Q:P=""  D:REQ(T,P)'=""
 . ; The references below to ^RADPT are permitted according to the
 . ; existing Integration Agreement # 1172
 . S ANY=1
 . S I=$$MATCHD^MAGDQR03(REQ(T,P),"^RADPT(""ADC"",LOOP)","^TMP(""MAG"",$J,""QR"",5,LOOP)")
 . S V="" F  S V=$O(^TMP("MAG",$J,"QR",5,V)) Q:V=""  D
 . . S MAGD0="" F  S MAGD0=$O(^RADPT("ADC",V,MAGD0)) Q:MAGD0=""  D
 . . . S MAGD1="" F  S MAGD1=$O(^RADPT("ADC",V,MAGD0,MAGD1)) Q:MAGD1=""  D
 . . . . S MAGD2="" F  S MAGD2=$O(^RADPT("ADC",V,MAGD0,MAGD1,MAGD2)) Q:MAGD2=""  D
 . . . . . S ^TMP("MAG",$J,"QR",6,MAGD0_"^"_MAGD1_"^"_MAGD2)="",ACC=1
 . . . . . Q
 . . . . Q
 . . . Q
 . . Q
 . Q
 I ANY,'ACC D  Q
 . D ERR^MAGDQR01("No matches for tag "_T)
 . D ERRSAV^MAGDQR01
 . Q
 ;
 S T="0020,0010",ANY=0
 S P="" F  S P=$O(REQ(T,P)) Q:P=""  D:REQ(T,P)'=""
 . ; The references below to ^RADPT are permitted according to the
 . ; existing Integration Agreement # 1172
 . S ANY=1
 . S I=$$MATCHD^MAGDQR03("*-"_REQ(T,P),"^RADPT(""ADC"",LOOP)","^TMP(""MAG"",$J,""QR"",9,LOOP)")
 . S V="" F  S V=$O(^TMP("MAG",$J,"QR",9,V)) Q:V=""  D
 . . S MAGD0="" F  S MAGD0=$O(^RADPT("ADC",V,MAGD0)) Q:MAGD0=""  D
 . . . S MAGD1="" F  S MAGD1=$O(^RADPT("ADC",V,MAGD0,MAGD1)) Q:MAGD1=""  D
 . . . . S MAGD2="" F  S MAGD2=$O(^RADPT("ADC",V,MAGD0,MAGD1,MAGD2)) Q:MAGD2=""  D
 . . . . . S ^TMP("MAG",$J,"QR",10,MAGD0_"^"_MAGD1_"^"_MAGD2)="",SID=1
 . . . . . Q
 . . . . Q
 . . . Q
 . . Q
 . Q
 I ANY,'SID D  Q
 . D ERR^MAGDQR01("No matches for tag "_T)
 . D ERRSAV^MAGDQR01
 . Q
 ;
 S T="0020,000D",ANY=0
 S P="" F  S P=$O(REQ(T,P)) Q:P=""  D:REQ(T,P)'=""
 . S ANY=1
 . S I=$$MATCHD^MAGDQR03(REQ(T,P),"^MAG(2005,""P"",LOOP)","^TMP(""MAG"",$J,""QR"",7,LOOP)")
 . S V="" F  S V=$O(^TMP("MAG",$J,"QR",7,V)) Q:V=""  D
 . . S I="" F  S I=$O(^MAG(2005,"P",V,I)) Q:I=""  D
 . . . ; If this image has a parent, its UID is not a study UID
 . . . Q:$P($G(^MAG(2005,I,0)),"^",10)
 . . . S ^TMP("MAG",$J,"QR",8,I)="",UID=1
 . . . Q
 . . Q
 . Q
 I ANY,'UID D  Q
 . D ERR^MAGDQR01("No matches for tag "_T)
 . D ERRSAV^MAGDQR01
 . Q
 ;
 I TIM,'(PAT+SSN+SID+UID+ACC) D TIM^MAGDQR04
 ;
 I '(PAT+SSN+SID+UID+ACC) D  Q
 . D ERR^MAGDQR01("No Selection Specified.")
 . D ERRSAV^MAGDQR01
 . Q
 ;
 D ELIM(ACC,SID,6,10,"Accession and Study ID",0)
 M ^TMP("MAG",$J,"QR",12)=^TMP("MAG",$J,"QR",6)
 M ^TMP("MAG",$J,"QR",12)=^TMP("MAG",$J,"QR",10)
 ;
 D ELIM(PAT,SSN,2,4,"Patient Name and ID",0)
 M ^TMP("MAG",$J,"QR",11)=^TMP("MAG",$J,"QR",2)
 M ^TMP("MAG",$J,"QR",11)=^TMP("MAG",$J,"QR",4)
 ;
 D ELIM(PAT+SSN,ACC+SID,11,12,"Patient and Study Info",1)
 I ERROR D ERRSAV^MAGDQR01 Q
 ;
 S ANY=0
 D
 . I UID D  Q
 . . S IMAGE="" F  S IMAGE=$O(^TMP("MAG",$J,"QR",8,IMAGE)) Q:IMAGE=""  D
 . . . S X=$G(^MAG(2005,IMAGE,0)),P=$P(X,"^",7)
 . . . I PAT+SSN,P,'$D(^TMP("MAG",$J,"QR",11,P)) Q
 . . . S X=$G(^MAG(2005,IMAGE,2)),V=$P(X,"^",6) Q:V'=74
 . . . S V=$P(X,"^",5) I V,(V<FD)!(V>LD) Q
 . . . S X=$G(^RARPT(+$P(X,"^",7),0)) ; IA # 1171
 . . . S MAGD0=$P(X,"^",2),MAGD1=9999999.9999-$P(X,"^",3),V=$P(X,"^",4)
 . . . S MAGD2=$O(^RADPT(MAGD0,"DT",MAGD1,"P","B",V,"")) ; IA # 1172
 . . . I ACC+SID,'$D(^TMP("MAG",$J,"QR",12,MAGD0_"^"_MAGD1_"^"_MAGD2)) Q
 . . . D RESULT^MAGDQR03
 . . . Q
 . . Q
 . ;
 . I ACC+SID D  Q
 . . N OK,P1,P2,P3,P4
 . . S P="" F  S P=$O(^TMP("MAG",$J,"QR",12,P)) Q:P=""  D
 . . . S MAGD0=$P(P,"^",1),MAGD1=$P(P,"^",2),MAGD2=$P(P,"^",3)
 . . . I PAT+SSN,'$D(^TMP("MAG",$J,"QR",11,MAGD0)) Q
 . . . S OK=0 D  Q:'OK
 . . . . S V=$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",17) Q:'V  ; IA # 1172
 . . . . S P1=0 F  S P1=$O(^RARPT(V,2005,P1)) Q:'P1  D  Q:OK  ; IA # 1171
 . . . . . S P2=+$G(^RARPT(V,2005,P1,0)) Q:'P2  ; IA # 1171
 . . . . . I UID,$D(^TMP("MAG",$J,"QR",8,P2)) S OK=1,IMAGE=P2 Q
 . . . . . I 'UID S OK=1,IMAGE=P2 Q
 . . . . . S P3=0 F  S P3=$O(^MAG(2005,P2,1,P3)) Q:'P3  D  Q:OK
 . . . . . . S P4=$P($G(^MAG(2005,P2,1,P3,0)),"^",1) Q:'P4
 . . . . . . I UID,$D(^TMP("MAG",$J,"QR",8,P4)) S OK=1,IMAGE=P4 Q
 . . . . . . I 'UID S OK=1,IMAGE=P4 Q
 . . . . . . Q
 . . . . . Q
 . . . . Q
 . . . D RESULT^MAGDQR03
 . . . Q
 . . Q
 . ;
 . I PAT+SSN D  Q
 . . S P="" F  S P=$O(^TMP("MAG",$J,"QR",11,P)) Q:P=""  D
 . . . S IMAGE="" F  S IMAGE=$O(^MAG(2005,"AC",P,IMAGE)) Q:IMAGE=""  D
 . . . . Q:$P($G(^MAG(2005,IMAGE,0)),"^",10)
 . . . . S X=$G(^MAG(2005,IMAGE,2)),V=$P(X,"^",6) Q:V'=74
 . . . . S V=$P(X,"^",5) I V,(V<FD)!(V>LD) Q
 . . . . S X=$G(^RARPT(+$P(X,"^",7),0)) ; IA # 1171
 . . . . S MAGD0=$P(X,"^",2),MAGD1=9999999.9999-$P(X,"^",3),V=$P(X,"^",4)
 . . . . S MAGD2=$O(^RADPT(MAGD0,"DT",MAGD1,"P","B",V,"")) ; IA # 1172
 . . . . I ACC+SID,'$D(^TMP("MAG",$J,"QR",12,MAGD0_"^"_MAGD1_"^"_MAGD2)) Q
 . . . . D RESULT^MAGDQR03
 . . . . Q
 . . . Q
 . . Q
 . Q
 ;
 S $P(^MAGDQR(2006.5732,RESULT,0),"^",2,3)="OK^"_$$NOW^XLFDT()
 K ^TMP("MAG",$J,"QR")
 Q
 ;
CHKTIM(V,L) ;
 Q:V=""
 I V'?1.6N D ERR^MAGDQR01("Invalid '"_L_"' time: """_V_""".")
 I $E(V,1,2)>23 D ERR^MAGDQR01("Invalid hours in '"_L_"' time: """_V_""".")
 I $E(V,3,4),$E(V,3,4)>59 D ERR^MAGDQR01("Invalid minutes in '"_L_"' time: """_V_""".")
 I $E(V,5,6),$E(V,5,6)>59 D ERR^MAGDQR01("Invalid seconds '"_L_"' time: """_V_""".")
 Q
 ;
ELIM(ONE,TWO,I1,I2,E,C) N ANY,I,O
 Q:'ONE  Q:'TWO
 S I="" F  S I=$O(^TMP("MAG",$J,"QR",I1,I)) Q:I=""  D
 . S O=I I C Q:I'["^"  S O=+I
 . I '$D(^TMP("MAG",$J,"QR",I2,O)) K ^TMP("MAG",$J,"QR",I1,I)
 . Q
 S I="" F  S I=$O(^TMP("MAG",$J,"QR",I2,I)) Q:I=""  D
 . S O=I I C Q:I'["^"  S O=+I
 . I '$D(^TMP("MAG",$J,"QR",I1,O)) K ^TMP("MAG",$J,"QR",I2,I)
 . Q
 S ANY=$O(^TMP("MAG",$J,"QR",I1,""))*$O(^TMP("MAG",$J,"QR",I2,""))
 D:'ANY ERR^MAGDQR01("No matches left, conflict between "_E)
 Q
 ;
