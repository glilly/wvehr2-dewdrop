MAGDQR01 ;WOIFO/EdM - Imaging RPCs for Query/Retrieve ; 05/16/2005  08:45
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
FIND(OUT,TAGS,RESULT,OFFSET,MAX) ; RPC = MAG CFIND QUERY
 N ERROR,I,N,P,REQ,T,V,X,ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTSK
 ;
 S RESULT=$G(RESULT),OFFSET=$G(OFFSET)
 S ERROR=0
 ;
 I 'RESULT D  Q
 . S REQ("0008,0020")=-1 ; Study Date
 . S REQ("0008,0030")=-1 ; Study Time
 . S REQ("0008,0050")=-1 ; Accession Number
 . S REQ("0010,0010")=-1 ; Patient's Name
 . S REQ("0010,0020")=-1 ; Patient ID
 . S REQ("0020,0010")=-1 ; Study ID
 . ; TAGS(i) = tag | VR | flag | value
 . S I="" F  S I=$O(TAGS(I)) Q:I=""  D
 . . S X=TAGS(I),T=$P(X,"|",1) Q:T=""
 . . S V=$P(X,"|",4,$L(X)+2) S:V="*" V=""
 . . S:$TR(V,"UNKOW","unkow")="<unknown>" V=""
 . . S L=$L(V,"\") S:V="" L=0
 . . S REQ(T)=L F P=1:1:L S REQ(T,P)=$P(V,"\",P)
 . . Q
 . S T="" F  S T=$O(REQ(T)) Q:T=""  D:REQ(T)<0 ERR("Missing required tag """_T_""".")
 . I ERROR D ERRLOG Q
 . ;
 . ; Convert DICOM name to VA name
 . ;
 . S T="0010,0010"
 . S P="" F  S P=$O(REQ(T,P)) Q:P=""  S REQ(T,P)=$$DCM2VA(REQ(T,P))
 . ;
 . ; Initialize Result Set
 . ;
 . L +^MAGDQR(2006.5732,0):1E9 ; Background process MUST wait
 . S X=$G(^MAGDQR(2006.5732,0))
 . S $P(X,"^",1,2)="DICOM QUERY RETRIEVE RESULT^2006.2006.5732"
 . S RESULT=$O(^MAGDQR(2006.5732," "),-1)+1
 . S $P(X,"^",3)=RESULT
 . S $P(X,"^",4)=$P(X,"^",4)+1
 . S ^MAGDQR(2006.5732,0)=X
 . S ^MAGDQR(2006.5732,RESULT,0)=RESULT_"^IP^"_$$NOW^XLFDT()
 . S ^MAGDQR(2006.5732,"B",RESULT,RESULT)=""
 . L -^MAGDQR(2006.5732,0)
 . ;
 . ; Queue up actual query
 . ;
 . S ZTRTN="QUERY^MAGDQR02"
 . S ZTDESC="Perform DICOM Query, result-set="_RESULT
 . S ZTDTH=$H
 . S ZTSAVE("RESULT")=RESULT
 . S T="" F  S T=$O(REQ(T)) Q:T=""  D
 . . S ZTSAVE("REQ("""_T_""")")=REQ(T)
 . . S P="" F  S P=$O(REQ(T,P)) Q:P=""  S ZTSAVE("REQ("""_T_""","_P_")")=REQ(T,P)
 . . Q
 . D ^%ZTLOAD,HOME^%ZIS
 . D:'$G(ZTSK) ERR("TaskMan did not Accept Request")
 . S:$G(ZTSK) $P(^MAGDQR(2006.5732,RESULT,0),"^",4)=ZTSK
 . I ERROR D ERRLOG Q
 . S OUT(1)="0,"_RESULT_",Query Started through TaskMan"
 . Q
 ;
 I OFFSET<0 D  Q  ; All done, clean up result-set
 . S OUT(1)="1,Result Set Cleaned Up"
 . Q:'$D(^MAGDQR(2006.5732,RESULT))
 . L +^MAGDQR(2006.5732,0):1E9 ; Background process MUST wait
 . S X=$G(^MAGDQR(2006.5732,0))
 . S $P(X,"^",1,2)="DICOM QUERY RETRIEVE RESULT^2006.2006.5732"
 . S:$P(X,"^",4)>0 $P(X,"^",4)=$P(X,"^",4)-1
 . S ^MAGDQR(2006.5732,0)=X
 . K ^MAGDQR(2006.5732,RESULT)
 . K ^MAGDQR(2006.5732,"B",RESULT)
 . L -^MAGDQR(2006.5732,0)
 . Q
 ;
 I 'OFFSET D  Q:V'="OK"  ; Is the query done?
 . S X=$G(^MAGDQR(2006.5732,RESULT,0))
 . S V=$P(X,"^",2) Q:V="OK"
 . I V="X" S OUT(1)="-2,No result returned" S V="OK" Q
 . S ZTSK=$P(X,"^",4) D STAT^%ZTLOAD
 . I $G(ZTSK(2))'["Inactive" S OUT(1)="-1,TaskMan still active" Q
 . I ZTSK(2)["Finished" S V="OK" Q
 . S OUT(1)="-13,TaskMan aborted: "_ZTSK(2)
 . Q
 ;
 S:'$G(MAX) MAX=100
 S I=OFFSET,N=1 F  S I=$O(^MAGDQR(2006.5732,RESULT,1,I)) Q:'I  D  Q:N>MAX
 . S OFFSET=I
 . S N=N+1,OUT(N)=$G(^MAGDQR(2006.5732,RESULT,1,I,0))
 . Q
 I N=1 S OUT(1)="0,No more results." Q
 S OUT(1)=(N-1)_","_OFFSET_",result(s)."
 Q
 ;
DCM2VA(NAME) N I,P
 S NAME=$TR(NAME,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ; Ignore prefixes and suffices
 F I=1:1:3 D
 . S P(I)=$P(NAME,"^",I)
 . F  Q:$E(P(I),1)'=" "   S P(I)=$E(P(I),2,$L(P(I)))
 . F  Q:$E(P(I),$L(P(I)))'=" "   S P(I)=$E(P(I),1,$L(P(I))-1)
 . Q
 S NAME=P(1)_","_P(2) S:P(3)'="" NAME=NAME_" "_P(3)
 Q NAME
 ;
ERR(X) S ERROR=ERROR+1,ERROR(ERROR)=X
 Q
 ;
ERRLOG N I,O
 S O=1,I="" F  S I=$O(ERROR(I)) Q:I=""  S O=O+1,OUT(O)=ERROR(I)
 SET OUT(1)=(-O)_",Errors encountered"
 Q
 ;
ERRSAV N I,O
 S $P(^MAGDQR(2006.5732,RESULT,0),"^",2,3)="OK^"_$$NOW^XLFDT()
 K ^MAGDQR(2006.5732,"RESULT",1)
 S O=0,I="" F  S I=$O(ERROR(I)) Q:I=""  D
 . S O=O+1,^MAGDQR(2006.5732,RESULT,1,O,0)="0000,0902^"_ERROR(I)
 . Q
 Q
 ;
