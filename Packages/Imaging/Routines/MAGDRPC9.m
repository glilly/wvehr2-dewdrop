MAGDRPC9 ;WOIFO/EdM - Imaging RPCs ; 11/03/2005  14:48
 ;;3.0;IMAGING;**50**;26-May-2006
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
NEWUID(OUT,OLD,NEW,IMAGE) ; RPC = MAG NEW SOP INSTANCE UID
 N D0,L,X
 S IMAGE=+$G(IMAGE),OLD=$G(OLD)
 S:$G(NEW)="" NEW=OLD
 S D0=0 S:OLD'="" D0=$O(^MAG(2005,"P",OLD,""))
 I IMAGE,D0,IMAGE'=D0 S OUT="-1,UID cannot belong to multiple images ("_IMAGE_"/"_D0_")" Q
 I IMAGE,'D0 S D0=IMAGE
 I 'D0 S OUT="-2,Cannot find image with UID "_OLD Q
 S OUT=$P($G(^MAG(2005,D0,"SOP")),"^",2) Q:OUT'=""
 S L=$L(NEW,".")-1,X=$P(NEW,".",L+1),L=$P(NEW,".",1,L)_"."
 L +^MAG(2005,"P"):1E9 ; Background process MUST wait
 S OUT="" F  D  Q:OUT'=""
 . S OUT=L_X
 . I $L(OUT)>64 S OUT="-3,Cannot use "_NEW_" to create valid UID" Q
 . I $D(^MAG(2005,"P",OUT)) S OUT="",X=X+1 Q
 . S $P(^MAG(2005,D0,"SOP"),"^",2)=OUT
 . S ^MAG(2005,"P",OUT,D0)=1
 . Q
 L -^MAG(2005,"P")
 Q
 ;
NEXT(OUT,SEED,DIR) ; RPC = MAG RAD GET NEXT RPT BY DATE
 N D2,DFN,EXAMDATE,NAME
 ;
 ; ^RADPT(DFN,"DT",D1,"P",D2,0) = Data, $P(17) = pointer to report
 ; ^RADPT("AR",9999999.9999-D1,DFN,D1)="" ; IA # 65
 ;
 ; OUT = report_pointer ^ ExamDate ^ Patient ^ D2
 ;
 S SEED=$G(SEED),DIR=$S($G(DIR)<0:-1,1:1) ; default is ascending order
 S EXAMDATE=$P(SEED,"^",1),DFN=$P(SEED,"^",2),D2=$P(SEED,"^",3)
 S OUT=0 F  D  Q:OUT
 . I EXAMDATE="" S EXAMDATE=$O(^RADPT("AR",""),DIR),DFN="" ; IA # 65
 . I EXAMDATE="" S OUT=-1 Q
 . I DFN="" S DFN=$O(^RADPT("AR",EXAMDATE,""),DIR) ; IA # 65
 . I DFN="" S EXAMDATE=$O(^RADPT("AR",EXAMDATE),DIR),D2="" Q  ; IA # 65
 . S:'D2 D2=$S(DIR>0:0,1:" ")
 . S D2=$O(^RADPT(DFN,"DT",9999999.9999-EXAMDATE,"P",D2),DIR) ; IA # 1172
 . I 'D2 D  Q
 . . S DFN=$O(^RADPT("AR",EXAMDATE,DFN),DIR),D2="" ; IA # 65
 . . I 'DFN D
 . . . S EXAMDATE=$O(^RADPT("AR",EXAMDATE),DIR),DFN="" ; IA # 65
 . . . I EXAMDATE="" S OUT=-1
 . . . Q
 . . Q
 . S OUT=$P($G(^RADPT(DFN,"DT",9999999.9999-EXAMDATE,"P",D2,0)),"^",17) ; IA # 1172
 . S:OUT OUT=OUT_"^"_EXAMDATE_"^"_DFN_"^"_D2
 . Q
 Q
 ;
NXTPTRPT(OUT,DFN,RARPT1,DIR) ; RPC = MAG RAD GET NEXT RPT BY PT
 S DFN=$G(DFN)
 I 'DFN S OUT="-1,Patient DFN not passed" Q
 I '$D(^RARPT("C",DFN)) S OUT="-2,Patient does not have any radiology reports" Q  ; IA # 2442
 S RARPT1=$G(RARPT1),DIR=$S($G(DIR)<0:-1,1:1) ; default is ascending order
 S OUT=$O(^RARPT("C",DFN,RARPT1),DIR) ; IA # 2442
 Q
 ;
GETICN(OUT,DFN) ; RPC = MAG DICOM GET ICN
 S OUT=$$GETICN^MPIF001(DFN)
 Q
 ;
CLEAN ; Overflow from MAGDRPC4
 N STUID
 S S0=$P(SENT(I),"^",1),S1=$P(SENT(I),"^",2)
 Q:'$D(^MAGDOUTP(2006.574,S0,1,S1))
 L +^MAGDOUTP(2006.574,S0,1,0):1E9 ; Background process MUST wait
 S X=$G(^MAGDOUTP(2006.574,S0,0)),LOC=$P(X,"^",4),PRI=+$P(X,"^",5)
 S STS=$P($G(^MAGDOUTP(2006.574,S0,1,S1,0)),"^",2)
 K ^MAGDOUTP(2006.574,S0,1,S1)
 I LOC'="",STS'="" K ^MAGDOUTP(2006.574,"STS",LOC,PRI,STS,S0,S1)
 S X=$G(^MAGDOUTP(2006.574,S0,1,0))
 S $P(X,"^",4)=$P(X,"^",4)-1
 S ^MAGDOUTP(2006.574,S0,1,0)=X
 L -^MAGDOUTP(2006.574,S0,1,0)
 Q:$O(^MAGDOUTP(2006.574,S0,1,0))
 L +^MAGDOUTP(2006.574,0):1E9 ; Background process MUST wait
 S STUID=$G(^MAGDOUTP(2006.574,S0,2))
 K ^MAGDOUTP(2006.574,S0)
 K:STUID'="" ^MAGDOUTP(2006.574,"STUDY",STUID)
 S X=$G(^MAGDOUTP(2006.574,0))
 S $P(X,"^",4)=$P(X,"^",4)-1
 S ^MAGDOUTP(2006.574,0)=X
 L -^MAGDOUTP(2006.574,0)
 Q
 ;
IENLOOK ; Overflow from MAGDRPC4
 ; lookup image by the IEN
 N D0,GROUPIEN,P,X
 S NUMBER=+$P(NUMBER,"`",2)
 ; patient safety checks
 D CHK^MAGGSQI(.X,NUMBER) I +$G(X(0))'=1 D  Q
 . S OUT(1)="-9,"_$P(X(0),"^",2,999)
 . Q
 S GROUPIEN=$P($G(^MAG(2005,NUMBER,0)),"^",10)
 I GROUPIEN D CHK^MAGGSQI(.X,GROUPIEN) I +$G(X(0))'=1 D  Q
 . S OUT(1)="-10,Group #"_GROUPIEN_": "_$P(X(0),"^",2,999)
 . Q
 ;
 S X=$G(^MAG(2005,NUMBER,2)),P=$P(X,"^",6),D0=$P(X,"^",7)
 I 'P!'D0 D  ; get parent from group
 . S:GROUPIEN X=$G(^MAG(2005,GROUPIEN,2)),P=$P(X,"^",6),D0=$P(X,"^",7)
 . Q
 ;
 S OUT(2)=P_"^"_D0_"^"_NUMBER_"^" ; result w/o Accession Number
 I 'P!'D0 S OUT(1)="-6,Warning - Parent file entry is not present - no Accession Number."
 E  I P=74 D
 . S X=P_"^"_D0_"^"_NUMBER_"^"_$P($G(^RARPT(D0,0)),"^",1) ; IA # 1171
 . S OUT(1)=1,OUT(2)=X
 . Q
 E  I P=8925 D
 . ; get pointer from TIU to consult request
 . S X=$$GET1^DIQ(8925,D0,1405,"I") ; IA ???
 . I $P(X,";",2)="GMR(123," D
 . . S X=P_"^"_D0_"^"_NUMBER_"^GMRC-"_$P(X,";")
 . . S OUT(1)=1,OUT(2)=X
 . . Q
 . E  S OUT(1)="-8,Problem with parent file "_P_", internal entry number "_D0_" - no Accession Number."
 . Q
 E  S OUT(1)="-7,Parent file "_P_" not yet supported - no Accession Number."
 Q
 ;
