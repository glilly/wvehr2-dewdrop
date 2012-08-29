XWB2HL7A ;;ISF/AC - Remote RPCs via HL7. ;03/14/2000  00:36
 ;;1.1;RPC BROKER;**12**;Mar 28, 1997
RPCINFO ;RPC Information
 ;Msg Type: SPQ - stored procedure request (event Q01)
 ;--------------
 ;MSH Message Header
 ;SPR Store Procedure Request
 ;    Query Tag^Query/Response Format Code^Stored Proc Name^Param List
 ;[ RDF ] Table Row Definition
 ;        # of Columns per Row^Column Description
 ;[ DSC ] Continuation Pointer
 ;--------------
 ;Response Msg Type: TBR - tabular data response 
 ;--------------
 ;MSH Message Header
 ;MSA Message Acknowledgment
 ;[ERR] Error
 ;QAK Query Acknowledgment
 ;RDF Table Row Definition
 ;        # of Columns per Row^Column Description
 ;{ RDT } Table Row Data
 ;        Column Value
 ;[ DSC ] Continuation Pointer
 ;-------------
DIRECT(XWB2SPN,XWB2HNDL,XWB2RET,XWB2DEST,XWB2PRAM,XWB2PARY) ;DIR RPC CALL
 N XWB2DRCT
 S XWB2DRCT=1
 G D2
 ;
 ;-------------
 ;This is where the RPC calls to send the RPC to the remote system
 ;(procedurename, query tag, error return, destination, Parameter array)
CALL(XWB2SPN,XWB2HNDL,XWB2RET,XWB2DEST,XWB2PRAM,XWB2PARY) ;RPC CALL
 ;
D2 N I,J,HL,HLA,HLL,XWB2LSTI,HLERR,XWB2EMAP,XWB2FLD,XWB2LPRM,XWB2MAP2,XWB2PARM,XWB2QTAG,XWB2SPRL,XWB2SPR,XWB2X,XWB2EID,XWB2MIEN,XWB2OVFL,XWB2RSLT,Y
 S XWB2QTAG=$G(XWB2HNDL)
 S XWB2SPN=$G(XWB2SPN)
 S XWB2FLD="@SPR.4.2"
 S (XWB2RET,XWB2PARM)=""
 D BLDDIST($G(XWB2DEST))
 I '$O(HLL("LINKS",0)) S $P(XWB2RET,"^",2,3)="-1^Station # not found" Q
 S XWB2EID=+$$FIND1^DIC(101,,"MX","XWB RPC EVENT")
 I 'XWB2EID S $P(XWB2RET,"^",2,3)="-1^RPC Broker Protocol not setup" Q
 D INIT^HLFNC2(.XWB2EID,.HL)
 I $O(HL(""))']"" S $P(XWB2RET,"^",2,3)="-1^RPC Broker Params not setup" Q
 ;XWB2EMAP=encoding characters to map by order.
 ;XWB2MAP2=escaped characters used for mapping encoding characters.
 S Y=""
 F I=3,0,1,2,4 S Y=Y_$S(I:$E(HL("ECH"),I),1:HL("FS"))
 S XWB2EMAP=Y,XWB2MAP2="EFSRT"
 F I=0:0 S I=$O(XWB2PRAM(I)) Q:I'>0!$P(XWB2RET,"^",2)  D
 .I $L(XWB2PRAM(I))>255 S $P(XWB2RET,"^",2,3)="-1^RPC Parameter(s) exceed length of 255." Q
 .S XWB2PRAM(I)=$$XLATE(XWB2PRAM(I),.XWB2OVFL)
 .S J=0
 .I $O(XWB2OVFL(0)) D  K XWB2OVFL
 ..F K=1,2 I $D(XWB2OVFL(K)) D
 ...S XWB2PRAM(I,(K/10))=XWB2OVFL(1)
 ...S J=(K/10) K XWB2OVFL(K)
 .F  S J=$O(XWB2PRAM(I,J)) Q:J'>0!$P(XWB2RET,"^",2)  D
 ..I $L(XWB2PRAM(I))>255 S $P(XWB2RET,"^",2,3)="-1^RPC Parameter(s) exceed length of 255." Q
 ..S XWB2PRAM(I,J)=$$XLATE(XWB2PRAM(I,J),.XWB2OVFL)
 ..I $O(XWB2OVFL(0)) D  K XWB2OVFL
 ...F K=1,2 I $D(XWB2OVFL(K)) D
 ....S XWB2PRAM(I,J+(K/10))=XWB2OVFL(1)
 ....S J=J+(K/10) K XWB2OVFL(K)
 I $P(XWB2RET,"^",2) Q
 D RPCSEND
 M XWB2RET=XWB2RSLT ;Move the return info into return var.
CALLXIT ;Cleanup before exit.
 Q
 ;
RPCSEND ;
 N I,J
 S HLA("HLS",1)="SPR"_HL("FS")_XWB2QTAG_HL("FS")_"T"_HL("FS")_XWB2SPN_HL("FS")_XWB2FLD_$E(HL("ECH"))
 S XWB2SPRL=$L(HLA("HLS",1)),XWB2SPR=$NA(HLA("HLS",1))
 S I=$O(XWB2PRAM(0)) Q:I'>0  D
 .S XWB2LSTI=I,XWB2X=XWB2PRAM(I)
 .I (XWB2SPRL+$L(XWB2X))>255!$O(XWB2PRAM(I,0)) D NXTNODE
 .S @XWB2SPR=@XWB2SPR_XWB2X,XWB2SPRL=$L(@XWB2SPR)
 .F J=0:0 S J=$O(XWB2PRAM(I,J)) Q:J'>0  D
 ..S XWB2X=XWB2PRAM(I,J)
 ..D NXTNODE
 ..S @XWB2SPR=@XWB2SPR_XWB2X,XWB2SPRL=$L(@XWB2SPR)
 ..Q
 F  S I=$O(XWB2PRAM(I)) Q:I'>0  D
 .S XWB2X=XWB2PRAM(I)
 .I (XWB2SPRL+$L(XWB2X)+1)>255!$O(XWB2PRAM(I,0)) D NXTNODE
 .S @XWB2SPR=@XWB2SPR_$E(HL("ECH"),4)_XWB2X,XWB2SPRL=$L(@XWB2SPR)
 .F J=0:0 S J=$O(XWB2PRAM(I,J)) Q:J'>0  D
 ..S XWB2X=XWB2PRAM(I,J)
 ..D NXTNODE
 ..S @XWB2SPR=@XWB2SPR_XWB2X,XWB2SPRL=$L(@XWB2SPR)
 ..Q
 S HLA("HLS",2)="RDF"_HL("FS")_"1"_HL("FS")_"@DSP.3"_$E(HL("ECH"))_"TX"_$E(HL("ECH"))_"300"
 I $D(XWB2DRCT) D DIRECT^HLMA(XWB2EID,"LM",1,.XWB2RSLT) Q
 D GENERATE^HLMA(XWB2EID,"LM",1,.XWB2RSLT,.XWB2MIEN)
 Q
 ;
NXTNODE ;Get next node
 N XWB2QL,XWB2QS
 S XWB2QL=$QL($NA(@XWB2SPR))
 I XWB2QL=2 S XWB2SPR=$NA(@XWB2SPR@(1)),@XWB2SPR="" Q
 I XWB2QL=3 D  Q
 .S XWB2QS=+$QS($NA(@XWB2SPR),3)+1
 .S XWB2SPR=$NA(@$NA(@XWB2SPR,2)@(XWB2QS)),@XWB2SPR=""
 Q
 ;
 ;
BLDDIST(X) ;Build distribution list -- HLL("LINKS") ARRAY.
 N %,XWB2LIST
 D LINK^HLUTIL3(X,.XWB2LIST,"I")
 S %=+$O(XWB2LIST(0)) Q:'%
 S HLL("LINKS",1)="XWB RPC SUBSCRIBER"_U_XWB2LIST(%)
 Q
XLATE(X,%) ;TRANSLATE FS and Encoding characters to Formating codes.
 ;
 N I,I1,I2,L,L1,L2,LCNT,LOVFL,LS,X1,X2,Y
 S X(0)=X
 F I=0:1:2 S L=0 D  Q:L'>255
 .S LS=$L(X(I))
 .F I1=1:1:5 S X1=$E(XWB2EMAP,I1),X2=$E(XWB2MAP2,I1) S L=L+(($L(X(I),X1)-1)*2)
 .S L=L+LS
 .I L>255 D
 ..S LOVFL=L-255
 ..S L1=(LS+1)-$S(LOVFL<170:LOVFL,1:170)
 ..S L1=$S(L1<86:86,1:L1)
 ..S L2=LS-$S(LOVFL<170:LOVFL,1:170)
 ..S L2=$S(L2>85:L2,1:85)
 ..S X(I+1)=$E(X(I),L1,LS)
 ..S X(I)=$E(X(I),1,L2)
 ;
 S %(0)=X(0)
 F I2=0:1:2 Q:'$D(X(I2))  S X=X(I2) D
 .S Y=""
 .F I1=1:1:5 S X1=$E(XWB2EMAP,I1),X2=$E(XWB2MAP2,I1) D
 ..S LS=$L(X)
 ..S L=$L(X,X1)
 ..I L>1 D
 ...F I=1:1:L S Y=Y_$P(X,X1,I)_$S(I'=L:$$ECODE(X2),1:"")
 ...S X=Y,Y=""
 .S %(I2)=X
 S Y=%(0) K %(0)
 Q Y
ECODE(X) ;
 N Y
 S Y=$E(HL("ECH"),3)_X_$E(HL("ECH"),3)
 Q Y
 ;
