MAGDQR03 ;WOIFO/EdM - Imaging RPCs for Query/Retrieve ; 05/16/2005  08:45
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
RESULT N E,L,OK,V,X,T
 S OK=1
 S T="" F  S T=$O(REQ(T)) Q:T=""  D
 . S L=$TR(T,",")
 . S E=$TR($E(L,1),"0123456789abcdef","QRSTUVWXYZABCDEF")
 . S $E(L,1)=E S:L'?8UN L=""
 . I L'="",$T(@L)'="" D @L Q
 . D ERR^MAGDQR01("Undefined tag: """_T_""".") S OK=0
 . Q
 Q:'OK
 ;
 S ANY=ANY+1
 D
 . N R1,V1,V2,VAL
 . S R1=$O(^MAGDQR(2006.5732,RESULT,1," "),-1)+1
 . S ^MAGDQR(2006.5732,RESULT,1,R1,0)="0000,0902^Result # "_ANY
 . S T="" F  S T=$O(V(T)) Q:T=""  D
 . . S VAL=$G(V(T))
 . . S V1="" F  S V1=$O(V(T,V1)) Q:V1=""  D
 . . . Q:$G(V(T,V1))=""
 . . . S:VAL'="" VAL=VAL_"\" S VAL=VAL_V(T,V1)
 . . . Q
 . . S R1=R1+1,^MAGDQR(2006.5732,RESULT,1,R1,0)=T_"^"_VAL
 . . S ^MAGDQR(2006.5732,RESULT,1,"B",T,R1)=""
 . . Q:$D(V(T))<10
 . . S V1="" F  S V1=$O(V(T,V1)) Q:V1=""  D
 . . . S V2="" F  S V2=$O(V(T,V1,V2)) Q:V2=""  D
 . . . . S VAL=$G(V(T,V1,V2)) Q:VAL=""
 . . . . S R1=R1+1,^MAGDQR(2006.5732,RESULT,1,R1,0)=T_"^"_VAL
 . . . . S ^MAGDQR(2006.5732,RESULT,1,"B",T,R1)=""
 . . . . Q
 . . . Q
 . . Q
 . Q
 Q
 ;
COMPARE(TAG,ACTUAL) N LOC,TMP,WILD
 Q:'$G(REQ(TAG)) 1
 S WILD=$G(REQ(TAG,1)) Q:WILD="" 0
 Q:$G(ACTUAL)="" 0
 S LOC(ACTUAL)=""
 Q $$MATCHD(WILD,"LOC(LOOP)","TMP(LOOP)")
 ;
MATCH1(X,Y) N I,M
 F  Q:X=""  Q:Y=""  D
 . I $E(X,1)=$E(Y,1) S X=$E(X,2,$L(X)),Y=$E(Y,2,$L(Y)) Q
 . I $E(Y,1)="?" S X=$E(X,2,$L(X)),Y=$E(Y,2,$L(Y)) Q
 . I $E(Y,1)="*" D  Q:M
 . . I Y="*" S (X,Y)="",M=1 Q
 . . S Y=$E(Y,2,$L(Y)),M=0
 . . F I=1:1:$L(X) I $$MATCH1($E(X,I,$L(X)),Y) S M=1,X=$E(X,I,$L(X)) Q
 . . Q
 . S X="!",Y=""
 . Q
 S:$TR(Y,"*")="" Y="" Q:X'="" 0 Q:Y'="" 0
 Q 1
 ;
MATCHD(WILDCARD,STRUCTUR,FOUND) N C,LOOP,L1,L9,SEEK,X,Y
 ;  -- Scans a structure,
 ;     reports entries in @STRUCTUR that match WILDCARD;
 ;     the result is reported in local array @FOUND
 S C=0
 S L1=$P($P(WILDCARD,"?",1),"*",1),L9=L1_"~"
 I L1=WILDCARD D  Q C
 . S LOOP=L1
 . I $D(@STRUCTUR) S @FOUND="" Q
 . Q
 S LOOP=L1 F  D  S LOOP=$O(@STRUCTUR) Q:LOOP=""  Q:LOOP]]L9
 . Q:LOOP=""  Q:'$D(@STRUCTUR)
 . Q:'$$MATCH1(LOOP,WILDCARD)
 . S C=C+1
 . S @FOUND=""
 . Q
 Q C
 ;
Q0080020 ;R Study Date
 S V(T)=$P($G(^MAG(2005,IMAGE,2)),"^",5)\1+17000000
 Q
 ;
Q0080030 ;R  Study Time
 S V(T)=$TR($J("."_$P($P($G(^MAG(2005,IMAGE,2)),"^",5),".",2)*1E6,6)," ",0)
 Q
 ;
Q0080050 ;R  Accession Number
 S X=$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",17) ; IA # 1172
 S V(T)=$P($G(^RARPT(+X,0)),"^",1) ; IA # 1171
 Q
 ;
Q0100010 ;R  Patient's Name
 S V(T)=$P($G(^DPT(MAGD0,0)),"^",1) ; No IA needed, PIMS 5.3
 Q
 ;
Q0100020 ;R  Patient ID
 S V(T)=$P($G(^DPT(MAGD0,0)),"^",9) ; No IA needed, PIMS 5.3
 Q
 ;
Q0200010 ;R  Study ID
 S V(T)=$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",1) ; IA # 1172
 Q
 ;
Q020000D ;U  Study Instance UID
 S V(T)=$P($G(^MAG(2005,IMAGE,"PACS")),"^",1)
 Q
 ;
Q0080061 ;O  Modalities in Study
 N P1,P2,R
 S R=""
 S P1=0 F  S P1=$O(^MAG(2005,IMAGE,1,P1)) Q:'P1  D
 . S P2=+$G(^MAG(2005,IMAGE,1,P1,0)) Q:'P2
 . S X=$P($G(^MAG(2005,P2,0)),"^",8) Q:$E(X,1,4)'="RAD"
 . S:R'="" R=R_"," S R=R_$E(X,5,$L(X))
 . Q
 S V(T)=R
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0080062 ;O  SOP Classes in Study
 ; --- probably not supported --- ?
 ; ? ? ?
 Q
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0080090 ;O  Referring Physician's Name
 S X=$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",14) ; IA # 1172
 S V(T)=$P($G(^VA(200,+X,0)),"^",1)
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0081030 ;O  Study Description
 S X=$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",2) ; IA # 1172
 S V(T)=$P($G(^RAMIS(71,+X,0)),"^",1) ; IA # 1174
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0081032 ;O  Procedure Code Sequence
 Q
 ;
Q0080100 ;O  >Code Value
 S X=$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",2) ; IA # 1172
 S X=$P($G(^RAMIS(71,+X,0)),"^",9) ; IA # 1174
 S X=$$CPT^ICPTCOD(+X) ; IA # 1995, supported reference
 S V("0008,1030",1,T)=$P(X,"^",2)
 Q
 ;
Q0080102 ;O  >Coding Scheme Designator
 S V("0008,1030",1,T)="C4"
 Q
 ;
Q0080103 ;O  >Coding Scheme Version
 S V("0008,1030",1,T)=4
 Q
 ;
Q0080104 ;O  >Code Meaning
 S X=$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",2) ; IA # 1172
 S X=$P($G(^RAMIS(71,+X,0)),"^",9) ; IA # 1174
 S X=$$CPT^ICPTCOD(+X) ; IA # 1995, supported reference
 S V("0008,1030",1,T)=$P(X,"^",3)
 Q
 ;
Q0081060 ;O  Name of Physician(s) Reading Study
 S X=$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",17) ; IA # 1172
 S X=$P($G(^RARPT(+X,0)),"^",9) ; IA # 1171
 S V(T)=$P($G(^VA(200,+X,0)),"^",1)
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0081080 ;O  Admitting Diagnoses Description
 ; ? ? ?
 ;;;S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0100021 ;O  Issuer of Patient ID
 S V(T)="USSSA"
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0100030 ;O  Patient's Birth Date
 S V(T)=$P($G(^DPT(MAGD0,0)),"^",3)\1+17000000
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0100032 ;O  Patient's Birth Time
 S V(T)=$TR($J("."_$P($P($G(^DPT(MAGD0,0)),"^",3),".",2)*1E6,6)," ",0)
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0100040 ;O  Patient's Sex
 S V(T)=$P($G(^DPT(MAGD0,0)),"^",2)
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0101000 ;O  Other Patient IDs
 N DFN,I,VA,VADPT
 S DFN=+MAGD0 D DEM^VADPT
 S X=$P(^DPT(DFN,0),"^",9) S:X'="" DFN(X)=""
 S:$G(VA("PID"))'="" DFN(VA("PID"))=""
 S:$G(VA("BID"))'="" DFN(VA("BID"))=""
 S X=$$GETICN^MPIF001(DFN) S:X'="" DFN(X)=""
 S I=0,X="" F  S X=$O(DFN(X)) Q:X=""  S I=I+1,V(T,I)=DFN(X)
 ;;;S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0101001 ;O  Other Patient Names
 N D1,I
 S (I,D1)=0 F  S D1=$O(^DPT(MAGD0,0.01,D1)) Q:'D1  D
 . S X=$P($G(^DPT(MAGD0,0.01,D1,0)),"^",1)
 . S:X'="" I=I+1,V(T,I)=X
 . Q
 ;;;S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0101010 ;O  Patient's Age
 N DD,DM,DY,WHEN
 S X=$P($G(^DPT(MAGD0,0)),"^",3)
 S WHEN=9999999.9999-MAGD1 ;;; select one of these two
 S WHEN=DT                 ;;; select one of these two
 S DY=$E(WHEN,1,3)-$E(X,1,3)
 S DM=$E(WHEN,4,5)-$E(X,4,5)
 S DD=$E(WHEN,6,7)-$E(X,6,7)
 S:DD<0 DM=DM-1 S:DM<0 DY=DY-1
 S V(T)=DY
 ;;;S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0001020 ;O  Patient's Size
 S V(T)=$P($G(^DPT(MAGD0,57)),"^",1) ; height in cm - field not populated
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0101030 ;O  Patient's Weight
 S V(T)=$P($G(^DPT(MAGD0,57)),"^",2) ; weight in kg - field not populated
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0102160 ;O  Ethnic Group
 S V(T)=$P($G(^DPT(MAGD0,0)),"^",6)
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0102180 ;O  Occupation
 S V(T)=$P($G(^DPT(MAGD0,0)),"^",7)
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q01021B0 ;O  Additional Patient History
 N D1,I
 S X=+$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",17) ; IA # 1172
 S (D1,I)=0 F  S D1=$O(^RARPT(X,"H",D1)) Q:'D1  D  ; IA # 1171
 . S I=I+1,V(T,I)=$G(^RARPT(X,"H",D1,0)) ; IA # 1171
 . Q
 ;;;S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0104000 ;O  Patient Comments
 ; ? ? ?
 ; (there is a modality that passes the accession number in this field)
 ;;;S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0201206 ;O  Number of Study Related Series
 N N,S,UID
 S UID=$G(V("0020,000D")),N=0
 I UID'=""  S S="" F  S S=$O(^MAG(2005,"P",UID,S)) Q:S=""  S N=N+1
 S V(T)=N
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
Q0201208 ;O  Number of Study Related Instances
 N N,P1,P2,S,UID
 S UID=$G(V("0020,000D")),N=0
 I UID'=""  S S="" F  S S=$O(^MAG(2005,"P",UID,S)) Q:S=""  D
 . S P1=0 F  S P1=$O(^MAG(2005,S,1,P1)) Q:'P1  D
 . . S P2=+$G(^MAG(2005,S,1,P1,0)) Q:'P2
 . . S N=N+1
 . . Q
 . Q
 S V(T)=N
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
U008010C ;O  Interpretation Author
 S X=+$P($G(^RADPT(MAGD0,"DT",MAGD1,"P",MAGD2,0)),"^",12) ; IA # 1172
 S V(T)=$P($G(^VA(200,X,0)),"^",1)
 S:'$$COMPARE(T,V(T)) OK=0
 Q
 ;
