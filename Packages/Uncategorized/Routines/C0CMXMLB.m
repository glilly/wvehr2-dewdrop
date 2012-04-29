MXMLBLD ;;ISF/RWF - Tool to build XML ;07/09/09  16:55
 ;;8.0;KERNEL;;;Build 2
 QUIT
 ;
 ;DOC - The top level tag
 ;DOCTYPE - Want to include a DOCTYPE node
 ;FLAG - Set to 'G' to store the output in the global ^TMP("MXMLBLD",$J,
START(DOC,DOCTYPE,FLAG,NO1ST) ;Call this once at the begining.
 K ^TMP("MXMLBLD",$J)
 S ^TMP("MXMLBLD",$J,"DOC")=DOC,^TMP("MXMLBLD",$J,"STK")=0
 I $G(FLAG)["G" S ^TMP("MXMLBLD",$J,"CNT")=1
 I $G(NO1ST)'=1 D OUTPUT($$XMLHDR)
 D:$L($G(DOCTYPE)) OUTPUT("<!DOCTYPE "_DOCTYPE_">") D OUTPUT("<"_DOC_">")
 Q
 ;
END ;Call this once to close out the document
 D OUTPUT("</"_$G(^TMP("MXMLBLD",$J,"DOC"))_">")
 I '$G(^TMP("MXMLBLD",$J,"CNT")) K ^TMP("MXMLBLD",$J)
 K ^TMP("MXMLBLD",$J,"DOC"),^("CNT"),^("STK")
 Q
 ;
ITEM(INDENT,TAG,ATT,VALUE) ;Output a Item
 N I,X
 S ATT=$G(ATT)
 I '$D(VALUE) D OUTPUT($$BLS($G(INDENT))_"<"_TAG_$$ATT(.ATT)_" />") Q
 D OUTPUT($$BLS($G(INDENT))_"<"_TAG_$$ATT(.ATT)_">"_$$CHARCHK(VALUE)_"</"_TAG_">")
 Q
 ;DOITEM is a callback to output the lower level.
MULTI(INDENT,TAG,ATT,DOITEM) ;Output a Multipule
 N I,X,S
 S ATT=$G(ATT)
 D PUSH($G(INDENT),TAG,.ATT)
 D @DOITEM
 D POP
 Q
 ;
ATT(ATT) ;Output a string of attributes
 I $D(ATT)<9 Q ""
 N I,S,V
 S S="",I=""
 F  S I=$O(ATT(I)) Q:I=""  S S=S_" "_I_"="_$$Q(ATT(I))
 Q S
 ;
Q(X) ;Add Quotes - Changed by gpl to use single instead of double quotes 6/11
 ;I X'[$C(34) Q $C(34)_X_$C(34)
 I X'[$C(39) Q $C(39)_X_$C(39)
 ;N Q,Y,I,Z S Q=$C(34),(Y,Z)=""
 N Q,Y,I,Z S Q=$C(39),(Y,Z)=""
 F I=1:1:$L(X,Q)-1 S Y=Y_$P(X,Q,I)_Q_Q
 S Y=Y_$P(X,Q,$L(X,Q))
 ;Q $C(34)_Y_$C(34)
 Q $C(39)_Y_$C(39)
 ;
XMLHDR() ; -- provides current XML standard header
 Q "<?xml version=""1.0"" encoding=""utf-8"" ?>"
 ;
OUTPUT(S) ;Output
 N C S C=$G(^TMP("MXMLBLD",$J,"CNT"))
 I C S ^TMP("MXMLBLD",$J,C)=S,^TMP("MXMLBLD",$J,"CNT")=C+1 Q
 W S,!
 Q
 ;
CHARCHK(STR) ; -- replace xml character limits with entities
 N A,I,X,Y,Z,NEWSTR
 S (Y,Z)=""
 ;IF STR["&" SET NEWSTR=STR DO  SET STR=Y_Z
 ;. FOR X=1:1  SET Y=Y_$PIECE(NEWSTR,"&",X)_"&amp;",Z=$PIECE(STR,"&",X+1,999) QUIT:Z'["&"
 I STR["&" F I=1:1:$L(STR,"&")-1 S STR=$P(STR,"&",1,I)_"&amp;"_$P(STR,"&",I+1,999)
 I STR["<" F  S STR=$PIECE(STR,"<",1)_"&lt;"_$PIECE(STR,"<",2,99) Q:STR'["<"
 I STR[">" F  S STR=$PIECE(STR,">",1)_"&gt;"_$PIECE(STR,">",2,99) Q:STR'[">"
 I STR["'" F  S STR=$PIECE(STR,"'",1)_"&apos;"_$PIECE(STR,"'",2,99) Q:STR'["'"
 I STR["""" F  S STR=$PIECE(STR,"""",1)_"&quot;"_$PIECE(STR,"""",2,99) Q:STR'[""""
 ;
 S STR=$TR(STR,$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31))
 QUIT STR
 ;
COMMENT(VAL) ;Add Comments
 N I,L
 ;I $D($G(VAL))=1 D OUTPUT("<!-- "_ATT_" -->") Q
 I $D(VAL) D OUTPUT("<!-- "_ATT_" -->") Q  ;CHANGED BY GPL FOR GTM
 S I="",L="<!--"
 F  S I=$O(ATT(I)) Q:I=""  D OUTPUT(L_ATT(I)) S L=""
 D OUTPUT("-->")
 Q
 ;
PUSH(INDENT,TAG,ATT) ;Write a TAG and save.
 N CNT
 S ATT=$G(ATT)
 D OUTPUT($$BLS($G(INDENT))_"<"_TAG_$$ATT(.ATT)_">")
 S CNT=$G(^TMP("MXMLBLD",$J,"STK"))+1,^TMP("MXMLBLD",$J,"STK")=CNT,^TMP("MXMLBLD",$J,"STK",CNT)=INDENT_"^"_TAG
 Q
 ;
POP ;Write last pushed tag and pop
 N CNT,TAG,INDENT,X
 S CNT=$G(^TMP("MXMLBLD",$J,"STK")),X=^TMP("MXMLBLD",$J,"STK",CNT),^TMP("MXMLBLD",$J,"STK")=CNT-1
 S INDENT=+X,TAG=$P(X,"^",2)
 D OUTPUT($$BLS(INDENT)_"</"_TAG_">")
 Q
 ;
BLS(I) ;Return INDENT string
 N S
 S S="",I=$G(I) S:I>0 $P(S," ",I)=" "
 Q S
 ;
INDENT() ;Renturn indent level
 Q +$G(^TMP("MXMLBLD",$J,"STK"))
