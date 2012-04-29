GMTSDESC        ; SLC/AGP - APIS TO RETURN HS TYPE AND HS OBJECTS DESC   ; 05/28/2008
        ;;2.7;Health Summary;**89**;Oct 20, 1995;Build 61
        ;
        Q
BEG(OUTPUT,IEN,FILENUM,CNT)     ;
        N DTYPE,NODE
        S DTYPE=$S(FILENUM=142:"Health Summary Type",FILENUM=142.1:"Local Health Summary Component",FILENUM=142.5:"Health Summary Object",1:"")
        ;S CNT=CNT+1 S @OUTPUT@(CNT)=$$REPEAT^XLFSTR("-",79)
        S CNT=CNT+1 S @OUTPUT@(CNT)=DTYPE_":"
        ;S CNT=CNT+1 S @OUTPUT@(CNT)=$J(" ",24)_"Name: "_$P(NODE,U)
        Q
        ;
COMP(OUTPUT,IEN,FILENUM,CNT)    ;
        I IEN<99999 Q
        D BEG(.OUTPUT,IEN,FILENUM,.CNT)
        N GBL,NODE,TEXT
        S NODE=$G(^GMT(142.1,IEN,0))
        S TEXT=$$LJ^XLFSTR($P(NODE,U),50)_"Abbreviation: "_$P(NODE,U,4)
        S CNT=CNT+1,@OUTPUT@(CNT)=TEXT
        I $D(^GMT(142.1,IEN,3.5,0))>0 D
        .S GBL=$NA(^GMT(142.1,IEN,3.5)) D COMPM(.OUTPUT,IEN,3.5,GBL,.CNT)
        S CNT=CNT+1,@OUTPUT@(CNT)="Time Limits Applicable: "_$P(NODE,U,3)
        S CNT=CNT+1,@OUTPUT@(CNT)="Maximum Occurrences Applicable: "_$P(NODE,U,3)
        I $P(NODE,U,10)="Y" S CNT=CNT+1,@OUTPUT@(CNT)="Hospital Location Applicable: Y"
        I $P(NODE,U,11)="Y" S CNT=CNT+1,@OUTPUT@(CNT)="ICD Text Applicable: Y"
        I $P(NODE,U,12)="Y" S CNT=CNT+1,@OUTPUT@(CNT)="Provider Narrative Applicable: Y"
        I $P(NODE,U,14)="Y" S CNT=CNT+1,@OUTPUT@(CNT)="CPT Narrative Applicable: Y"
        I $P(NODE,U,13)'="" S CNT=CNT+1,@OUTPUT@(CNT)="Prefix: "_$P(NODE,U,13)
        I $P(NODE,U,2)'="" S CNT=CNT+1,@OUTPUT@(CNT)="Print Routine: "_$P(NODE,U,2)
        I $D(^GMT(142.1,IEN,.1,0))>0 D
        .S GBL=$NA(^GMT(142.1,IEN,.1)) D COMPM(.OUTPUT,IEN,.1,GBL,.CNT)
        I $D(^GMT(142.1,IEN,1,0))>0 D
        .S GBL=$NA(^GMT(142.1,IEN,1)) D COMPM(.OUTPUT,IEN,1,GBL,.CNT)
        Q
        ;
COMPM(OUTPUT,IEN,SUBSC,GBL,CNT) ;
        N I,INDENT,NODE,TEXT
        I SUBSC=3.5 S INDENT="",TITLE="Description:"
        I SUBSC=.1 S INDENT=$J(" ",5),TITLE="External/Extract Routine(s):"
        I SUBSC=1 S INDENT=$J(" ",5),TITLE="Selection File(s):"
        S CNT=CNT+1,@OUTPUT@(CNT)=TITLE
        S I=0 F  S I=$O(@GBL@(I)) Q:I'>0  D
        .I SUBSC=1 D  Q
        ..S NODE=@GBL@(I,0)
        ..S TEXT=INDENT_"File: "_$P(^DIC($P(NODE,U),0),U)
        ..S TEXT=TEXT_" Selection Count Limit: "_$P(NODE,U,2)
        ..S CNT=CNT+1,@OUTPUT@(CNT)=TEXT
        .S CNT=CNT+1,@OUTPUT@(CNT)=INDENT_$G(@GBL@(I,0))
        Q
        ;
EN(IEN,FILENUM,SUB)     ;
        I $D(^TMP($J,SUB,IEN))>0 Q
        N CNT,OUTPUT
        S CNT=0
        S OUTPUT=$NA(^TMP($J,SUB,IEN))
        D DIRECT(.OUTPUT,IEN,FILENUM,.CNT)
        Q
        ;
DIRECT(OUTPUT,IEN,FILENUM,CNT)  ;
        N ORDIALOG,TYPE
        I FILENUM=142.1 D COMP(.OUTPUT,IEN,FILENUM,.CNT)
        I FILENUM=142 D TYPE(.OUTPUT,IEN,FILENUM,.CNT)
        I FILENUM=142.5 D OBJECT(.OUTPUT,IEN,FILENUM,.CNT)
        Q
        ;
HEADER(OUTPUT,CNT)      ;
        N TEXT
        S TEXT=$$REPEAT^XLFSTR(" ",35)_"Max"_$$REPEAT^XLFSTR(" ",8)_"Hos"
        S TEXT=TEXT_"  ICD   Pro  CPT"
        S CNT=CNT+1,@OUTPUT@(CNT)=TEXT
        S TEXT="Abb   Ord    Component Name"_$$REPEAT^XLFSTR(" ",8)_"OCC"
        S TEXT=TEXT_"  Time  Loc  Text  Nar  Mod  Selection"
        S CNT=CNT+1,@OUTPUT@(CNT)=TEXT
        Q
        ;
OBJECT(OUTPUT,IEN,FILENUM,CNT)  ;
        D BEG(.OUTPUT,IEN,FILENUM,.CNT)
        N NUM,OBJ
        D EXTRACT^GMTSOBJ(IEN,.OBJ)
        S NUM=0 F  S NUM=$O(OBJ("D",NUM)) Q:NUM'>0  D
        .S CNT=CNT+1,@OUTPUT@(CNT)=$G(OBJ("D",NUM))
        Q
TYPE(OUTPUT,IEN,FILENUM,CNT)    ;
        D BEG(.OUTPUT,IEN,FILENUM,.CNT)
        N ARRAY,ERROR,IENS,NODE,NUM,SEL,SELNAM,TEXT
        S NODE=$G(^GMT(142,IEN,0))
        S CNT=CNT+1,@OUTPUT@(CNT)=$$RJ^XLFSTR("Name: ",30)_$P(NODE,U)
        S CNT=CNT+1,@OUTPUT@(CNT)=$$RJ^XLFSTR("Suppress Comp Without Data:",30)_$P(NODE,U,5)
        D HEADER(.OUTPUT,.CNT)
        S NUM=0 F  S NUM=$O(^GMT(142,IEN,1,NUM)) Q:NUM'>0  D
        .S NODE=$G(^GMT(142,IEN,1,NUM,0))
        .S CNT=CNT+1,@OUTPUT@(CNT)=$$TYPETEXT(NODE)
        .S SEL=0 F  S SEL=$O(^GMT(142,IEN,1,NUM,1,SEL)) Q:SEL'>0  D
        ..S IENS=SEL_","_NUM_","_IEN_","
        ..D GETS^DIQ(142.14,IENS,"**","E","ARRAY","ERROR")
        ..S SELNAM=$G(ARRAY(142.14,IENS,.01,"E"))
        ..S CNT=CNT+1,@OUTPUT@(CNT)=$$REPEAT^XLFSTR(" ",67)_SELNAM
        Q
        ;
TYPETEXT(NODE)  ;
        N ABB,CIEN,NAME
        S CIEN=$P(NODE,U,2) Q:CIEN'>0
        S NAME=$P($G(^GMT(142.1,CIEN,0)),U)
        S ABB=$P($G(^GMT(142.1,CIEN,0)),U,4)
        S TEXT=$$LJ^XLFSTR(ABB,6)
        S TEXT=TEXT_$$LJ^XLFSTR($P(NODE,U),7)
        S TEXT=TEXT_$$LJ^XLFSTR($E(NAME,1,21),22)
        S TEXT=TEXT_$$LJ^XLFSTR($P(NODE,U,3),5)
        S TEXT=TEXT_$$LJ^XLFSTR($P(NODE,U,4),6)
        S TEXT=TEXT_$$LJ^XLFSTR($P(NODE,U,6),5)
        S TEXT=TEXT_$$LJ^XLFSTR($P(NODE,U,7),6)
        S TEXT=TEXT_$$LJ^XLFSTR($P(NODE,U,8),5)
        S TEXT=TEXT_$$LJ^XLFSTR($P(NODE,U,9),8)
        Q TEXT
        ;
