MAGDQR04 ;WOIFO/EdM - Imaging RPCs for Query/Retrieve ; 05/16/2005  09:30
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
TIM ; Overflow from MAGDQR02
 N SDT,V
 ; The references below to ^RADPT are permitted according to the
 ; existing Integration Agreement # 1172
 S V="" F  S V=$O(^RADPT("ADC",V)) Q:V=""  D
 . S MAGD0="" F  S MAGD0=$O(^RADPT("ADC",V,MAGD0)) Q:MAGD0=""  D
 . . S MAGD1="" F  S MAGD1=$O(^RADPT("ADC",V,MAGD0,MAGD1)) Q:MAGD1=""  D
 . . . S SDT=9999999.9999-MAGD1 Q:SDT<FD  Q:SDT>LD
 . . . S MAGD2="" F  S MAGD2=$O(^RADPT("ADC",V,MAGD0,MAGD1,MAGD2)) Q:MAGD2=""  D
 . . . . S ^TMP("MAG",$J,"QR",10,MAGD0_"^"_MAGD1_"^"_MAGD2)="",TIM=2
 . . . . S ANY=1,SID=1
 . . . . Q
 . . . Q
 . . Q
 . Q
 I TIM=1 D  Q
 . D ERR^MAGDQR01("No matches for tag 0008,0020 / 0008,0030")
 . D ERRSAV^MAGDQR01
 . Q
 ;
 Q
 ;
STUDY(OUT,UID) ; RPC = MAG STUDY UID QUERY
 N D1,F1,F2,F3,IMAGE,N,NET,PASS,SERIES,USER,X
 I $G(UID)="" S OUT(1)="-1,No UID specified." Q
 I UID'?1.64(1N,1".") S OUT(1)="-2,Invalid UID format: """_UID_"""." Q
 S N=1
 S SERIES="" F  S SERIES=$O(^MAG(2005,"P",UID,SERIES)) Q:SERIES=""  D
 . Q:$P($G(^MAG(2005,SERIES,0)),"^",10)
 . S D1=0 F  S D1=$O(^MAG(2005,SERIES,1,D1)) Q:'D1  D
 . . S IMAGE=+$G(^MAG(2005,SERIES,1,D1,0)) Q:'IMAGE
 . . S NET=$P($G(^MAG(2005,IMAGE,0)),"^",3),(USER,PASS)=""
 . . I NET S X=$G(^MAG(2005.2,NET,2)),USER=$P(X,"^",1),PASS=$P(X,"^",2)
 . . D FILEFIND^MAGDFB(IMAGE,"FULL",0,0,.F1,.F2,.F3)
 . . S N=N+1,OUT(N)=IMAGE_"^"_F2_"^"_USER_"^"_PASS
 . . Q
 . Q
 S X=" image" S:N'=2 X=X_"s" S X=X_" found"
 S OUT(1)=(N-1)_X
 Q
 ;
INFO(OUT,IMAGE) ; RPC = MAG IMAGE CURRENT INFO
 ;
 ; 0008,0020  Study Date
 ; 0008,0050  Accession Number
 ; 0008,0060  Modality
 ; 0008,0090  Referring Physician's Name
 ; 0008,1030  Study Description (may be VA procedure name)
 ; 0008,1050  Performing (attending) Physician
 ; 0010,0010  Patient Name
 ; 0010,0020  Patient ID
 ; 0010,0030  Patient's Birth Date
 ; 0010,0040  Patient's Sex
 ; 0010,1000  Other Patient IDs (= ICN, Integration Control Number)
 ; 0010,1040  Address
 ; 0010,2160  Ethnic Group
 ; 0010,2000  Medical Alerts
 ; 0020,000D  Study Instance UID
 ; 0032,1032  Requesting Physician
 ; 0032,1033  Requesting Service
 ; 0032,1060  Requested Procedure Description (CPT name)
 ; 0032,1064  Requested Procedure Code Sequence
 ; 0008,0100  > Code Value (CPT code)
 ; 0008,0102  > Coding Scheme Designator ("C4")
 ; 0008,0104  > Code Meaning (CPT name)
 ; 0038,0300  Current Patient Location (ward)
 ;
 N ACN,ATP,CPT,D0,D1,D2,D3,DFN,I,MO,N,P,REQP,RFP,RQL,T,TAG,UID,V,WRD,X
 I '$G(IMAGE) S OUT(1)="-1,No Image Specified." Q
 I '$D(^MAG(2005,IMAGE)) S OUT(1)="-2,No Such Image ("_IMAGE_")." Q
 ;
 S X=$G(^MAG(2005,IMAGE,0)),P=$P(X,"^",10)
 S TAG("0008,1030")=$P(X,"^",8) ; Procedure
 S DFN=$P(X,"^",7) D:DFN
 . ; The following references to ^DPT are allowed according to
 . ; PIMS V5.3 Technical Manual, Section II.
 . S TAG("0010,0010")=$P(^DPT(DFN,0),"^",1) ; Patient Name
 . S TAG("0010,0020")=$P(^DPT(DFN,0),"^",9) ; Patient ID (SSN)
 . S TAG("0010,0030")=$P(^DPT(DFN,0),"^",3)\1+17000000 ; Patient's Birth Date
 . S TAG("0010,0032")=$TR($J("."_$P($P(^DPT(DFN,0),"^",3),".",2)*1E6,6)," ",0) ; Patient's Birth Time [probably always blank]
 . S TAG("0010,2160")=$P(^DPT(DFN,0),"^",6) ; Patient's Race
 . S TAG("0010,0040")=$P(^DPT(DFN,0),"^",2) ; Patient's Sex
 . S X=$$GETICN^MPIF001(DFN)
 . S:X'="" TAG("0010,1000")=X ; Other Patient ID
 . S X=$G(^DPT(DFN,0.11)) D:X'=""
 . . S P=$P(X,"^",5) S:P V=$P($G(^DIC(5,+P,0)),"^",1) ; IA # 10056
 . . S:V'="" $P(X,"^",5)=V ; State
 . . S TAG("0010,1040")=$P(X,"^",1,6) ; Patient's Address
 . . Q
 . Q
 ;
 S UID=$S(P:$G(^MAG(2005,+P,"PACS")),1:$G(^MAG(2005,IMAGE,"PACS")))
 S TAG("0020,000D")=UID ; Study Instance UID
 ; The following references to ^RADPT are allowed according to IA # 1172
 S I=0
 I UID'="" S D0="" F  S D0=$O(^RADPT("ADC",UID,D0)) Q:D0=""  D
 . S D1="" F  S D1=$O(^RADPT("ADC",UID,D0,D1)) Q:D1=""  D
 . . N VAINDT
 . . S I=I+1,TAG("0008,0020",I)=9999999.9999-D1\1+17000000 ; Study Date
 . . S VAINDT=9999999.9999-D1 D INP^VADPT ; Supported reference
 . . S:$G(VAIN(2))'="" RFP(VAIN(2))="" ; Referring Physician's Name
 . . S:$G(VAIN(4))'="" RFP(VAIN(4))="" ; Current Ward
 . . S:$G(VAIN(11))'="" ATP(VAIN(11))="" ; Performing (attending) Physician
 . . S D2="" F  S D2=$O(^RADPT("ADC",UID,D0,D1,D2)) Q:D2=""  D
 . . . S X=$G(^RADPT(D0,"DT",D1,"P",D2,0))
 . . . S P=$P(X,"^",2) D:P
 . . . . S M1=0 F  S M1=$O(^RAMIS(71,+P,"MDL",M1)) Q:'M1  D  ; IA # 1174
 . . . . . S V=$P($G(^RAMIS(71,+P,"MDL",M1,0)),"^",1) S:V'="" MO(V)="" ; IA # 1174
 . . . . . Q
 . . . . S V=$P($G(^RAMIS(71,+P,0)),"^",9) S:V CPT(+V)="" ; IA # 1174
 . . . . Q
 . . . S P=$P(X,"^",14) D:P
 . . . . S V=$P($G(^VA(200,+P,0)),"^",1)
 . . . . S:V'="" REQP(V)=""
 . . . . Q
 . . . S P=$P(X,"^",17) D:P
 . . . . S X=$G(^RARPT(+P,0)) Q:X=""  ; IA # 1171
 . . . . S V=$P(X,"^",1) S:V'="" ACN(V)=""
 . . . . Q
 . . . S P=$P(X,"^",22) D:P
 . . . . S X=$G(^SC(+P,0)) Q:X=""  ; IA # 10040
 . . . . S V=$P(X,"^",1) S:V'="" RQL(V)=""
 . . . . Q
 . . . S P=0,D3=0 F  S D3=$O(^RADPT(D0,"P",D1,"DT",D2,"H",D3)) Q:'D3  D
 . . . . S X=$G(^RADPT(D0,"P",D1,"DT",D2,"H",D3,0)) Q:X=""
 . . . . S P=P+1,TAG("0010,2000  "_$J(P,5))=X
 . . . . Q
 . . . Q
 . . Q
 . Q
 S V="" F  S V=$O(ACN(V)) Q:V=""  D
 . S I=I+1,TAG("0008,0050",I)=ACN(V) ; Accession Number
 . Q
 S V="" F  S V=$O(WRD(V)) Q:V=""  D
 . S I=I+1,TAG("0038,0300",I)=$P(V,"^",2) ; Current Patient Location
 . Q
 S V="" F  S V=$O(RFP(V)) Q:V=""  D
 . S I=I+1,TAG("0008,0090",I)=$P(V,"^",2) ; Referring Physician's Name
 . Q
 S V="" F  S V=$O(ATP(V)) Q:V=""  D
 . S I=I+1,TAG("0008,1050",I)=$P(V,"^",2) ; Performing (attending) Physician
 . Q
 S V="" F  S V=$O(RQL(V)) Q:V=""  D
 . S I=I+1,TAG("0032,1033",I)=RQL(V) ; Requesting Service
 . Q
 S V="" F  S V=$O(MO(V)) Q:V=""  D
 . S I=I+1,TAG("0008,0060",I)=MO(V) ; Modality
 . Q
 S V="" F  S V=$O(REQP(V)) Q:V=""  D
 . S I=I+1,TAG("0032,1032",I)=REQP(V) ; Requesting Physician
 . Q
 S V="" F  S V=$O(CPT(V)) Q:V=""  D
 . S X=$$CPT^ICPTCOD(V) ; IA # 1995, supported reference
 . Q:$P(X,"^",2)=""
 . S I=I+1
 . S TAG("0031,1064 0008,0100",I)=$P(X,"^",2) ; CPT Code
 . S TAG("0031,1064 0008,0104",I)=$P(X,"^",3) ; Code Meaning
 . S TAG("0031,1060",I)=$P(X,"^",3) ; Requested Procedure Description
 . S TAG("0031,1064 0008,0102",I)="C4" ; Coding Scheme Designator
 . Q
 ;
 S N=1,T="" F  S T=$O(TAG(T)) Q:T=""  D
 . S V=""
 . S:$D(TAG(T))#2 V=TAG(T)
 . S I="" F  S I=$O(TAG(T,I)) Q:I=""  S:V'="" V=V_"\" S V=V_TAG(T,I)
 . S:V'="" N=N+1,OUT(N)=T_"^"_V
 . Q
 ;
 S OUT(1)=(N-1)_" data fields returned."
 Q
 ;
CLEAN(OUT) ; RPC = MAG DICOM QUERY CLEANUP
 N D0,H,N,STAMP
 L +^MAGDQR(2006.5732,0):1E6 ; Background task MUST wait
 S D0=0 F  S D0=$O(^MAGDQR(2006.5732,D0)) Q:'D0  D
 . S X=$G(^MAGDQR(2006.5732,D0,0)),STAMP=$P(X,"^",3)
 . Q:DT-STAMP<5
 . K ^MAGDQR(2006.5732,D0)
 . K ^MAGDQR(2006.5732,"B",D0)
 . Q
 S (D0,N,H)=0 F  S D0=$O(^MAGDQR(2006.5732,D0)) Q:'D0  S N=N+1,H=D0
 S X="DICOM QUERY RETRIEVE RESULT^2006.2006.5732^"_H_"^"_N
 S ^MAGDQR(2006.5732,0)=X
 L -^MAGDQR(2006.5732,0)
 Q
 ;
