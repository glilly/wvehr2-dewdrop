XUMF1H  ;ISS/RAM - MFS Handler ;6/27/06  07:50
        ;;8.0;KERNEL;**407,474**;Jul 10, 1995;Build 13
        ;Per VHA Directive 10-92-142, this routine should not be modified
        ;
        ; This routine handles Master File HL7 messages.
        ;
MAIN    ; -- entry point
        ;
        N CNT,ERR,I,X,HLFS,HLCS,ERROR,HLRESLTA,IFN,IEN,MTPE,TYPE,ARRAY
        N HDT,KEY,MID,REASON,VALUE,XREF,ALL,GROUP,PARAM,ROOT,SEG,QRD,XUMF
        N QID,WHAT,WHO,HLSCS,CDSYS,EXIT,HLREP,NUMBER,Y,XXX,YYY,XIEN
        N XUMFSDS,FDA,LIST,ERRCNT,PKV,MKEY,MKEY1,TYP,MFI,IMPLY,RECORD,OUT
        ;
        D INIT,PROCESS,REPLY,EXIT
        ;
        Q
        ;
INIT    ; -- initialize
        ;
        K ^TMP("DILIST",$J),^TMP("DIERR",$J)
        K ^TMP("HLS",$J),^TMP("HLA",$J)
        K ^TMP("XUMF MFS",$J),^TMP("XUMF ERROR",$J)
        K ^TMP("XUMF EVENT",$J)
        ;
        S XUMF=1,DUZ(0)="@"
        ;
        S (ERROR,CNT,TYPE,ARRAY,EXIT,ERRCNT)=0
        S HLFS=HL("FS"),HLCS=$E(HL("ECH"))
        S HLSCS=$E(HL("ECH"),4),HLREP=$E(HL("ECH"),2)
        ;
        Q
        ;
PROCESS ; -- pull message text
        ;
        F  X HLNEXT Q:HLQUIT'>0  D
        .Q:$P(HLNODE,HLFS)=""
        .Q:"^MSH^MSA^QRD^MFI^MFE^ZRT^"'[(U_$P(HLNODE,HLFS)_U)
        .D @($P(HLNODE,HLFS))
        I $D(LIST) D LIST
        I $D(FDA) D UPDATE
        I $D(RECORD) D RECORD
        I $D(IFN) D EVT^XUMF0,POST
        ;
        Q
        ;
MSH     ; -- MSH segment
        ;
        Q
        ;
MSA     ; -- MSA segment
        ;
        N CODE
        ;
        S CODE=$P(HLNODE,HLFS,2)
        ;
        I CODE="AE"!(CODE="AR") D
        .S ERROR=ERROR_U_$P(HLNODE,HLFS,4)_U_$G(ERR)
        .D EM^XUMFX(ERROR,.ERR)
        ;
        Q
        ;
MFI     ; -- MFI segment
        ;
        Q:ERROR
        Q:EXIT
        ;
        Q
        ;
MFE     ; -- MFE SEGMENT
        ;
        Q:ERROR
        Q:EXIT
        ;
        S PKV=$P(HLNODE,HLFS,5),MFI=$P(PKV,"@")
        ;
        I $D(LIST) D LIST K LIST,LISTVUID
        I $D(FDA) D UPDATE K FDA
        I $D(RECORD) D RECORD
        I $D(IFN),(IFN'=$O(^DIC(4.001,"MFID",MFI,0))) D POST
        ;
        K IFN,IEN,PRE,POST,VUID,IMPLY,RECORD
        K ^TMP("XUMF IMPLIED LOGIC",$J)
        ;
        I MFI="" S ERROR="1^MFI not resolved HLNODE: "_HLNODE Q
        S IFN=$O(^DIC(4.001,"MFID",MFI,0))
        I 'IFN S ERROR="1^IFN not resolved HLNODE: "_HLNODE Q
        ;
        S VUID=$P($P(PKV,"@",2),HLCS)
        ;
        Q:ARRAY
        ;
        ;MFE processing
        D MFE0 Q:ERROR
        ;
        D:'$G(IEN) MFE^XUMF0(IFN,VUID,.IEN,.ERROR) Q:ERROR
        ;
        ;D MFE0
        ;
        ;Implied logic flag - must be set by MFE-Processing Logic field (#4)
        S IMPLY=+$G(^TMP("XUMF IMPLIED LOGIC",$J))
        S IMPLY("KILL")=0
        K ^TMP("XUMF IMPLIED LOGIC",$J)
        ;
        I IEN D
        .; clean multiple flag
        .K:'$D(XIEN(IFN,IEN)) XIEN
        .S XIEN(IFN,IEN)=$G(XIEN(IFN,IEN))+1
        .;
        .N ROOT
        .S ROOT=$$ROOT^DILFD(IFN,,1)
        .M RECORD("BEFORE")=@ROOT@(IEN)
        .S RECORD("STATUS")=$$GETSTAT^XTID(IFN,,IEN_",")
        .;
        .S ^TMP("XUMF EVENT",$J,IFN,"BEFORE",IEN,"REPLACED BY")=$P($G(@ROOT@(IEN,"VUID")),U,3)
        .S ^TMP("XUMF EVENT",$J,IFN,"BEFORE",IEN,"INHERITS FROM")=$$RPLCMNT^XTIDTRM(IFN,IEN)
        ;
        Q
        ;
ZRT     ; -- data segments
        ;
        Q:ERROR
        Q:EXIT
        ;
        I $G(ARRAY) D ARRAY Q
        ;
        N COL,X,Y,Z,DTYP,IDX,SEQ,DATA,NAME,VUID1,LIST1
        N FIELD,SUBFILE,LKUP,REPEAT,CLEAN,TIMEZONE,WP
        ;
        S NAME=$P(HLNODE,HLFS,2)
        ;
        D ZRT0 Q:ERROR  I $G(OUT) K OUT Q
        ;
        I 'IEN,NAME="Term" D STUB^XUMF0 Q
        I 'IEN S ERROR="1^IEN not defined IFN: "_IFN_" VUID: "_VUID Q
        ;
        ;D ZRT0 Q:ERROR
        ;
        S IENS=IEN_","
        ;
        S IDX=$O(^DIC(4.001,+IFN,1,"B",NAME,0))
        I 'IDX S ERROR="1^parameter "_NAME_" not defined IFN: "_IFN Q
        S DATA=$G(^DIC(4.001,+IFN,1,+IDX,0))
        S TYP=$P(DATA,U,3),TYP=$$GET1^DIQ(771.4,(+TYP_","),.01)
        S FIELD=$P(DATA,U,2),SUBFILE=$P(DATA,U,4),MKEY=$P(DATA,U,6)
        S LKUP=$P(DATA,U,7),TIMEZONE=$P(DATA,U,14),LIST1=$P(DATA,U,8)
        S REPEAT=$P(DATA,U,11),CLEAN=$P(DATA,U,12),VUID1=$P(DATA,U,13)
        S WP=$P(DATA,U,16)
        ;
        I WP D WP Q
        ;
        S VALUE=$$UNESC^XUMF0($P(HLNODE,HLFS,3),.HL)
        S VALUE=$$DTYP^XUMFXP(VALUE,TYP,HLCS,0,TIMEZONE)
        ;
        I NAME="Status" D STATUS Q
        ;
        I 'SUBFILE D  Q
        .S VALUE=$$VAL^XUMF0(IFN,FIELD,VUID1,VALUE,IENS) Q:VALUE="^"
        .S FDA(IFN,IENS,FIELD)=VALUE
        ;
        N IENS1
        ;
        I LIST1 D  Q
        .S VALUE=$$VAL^XUMF0(SUBFILE,FIELD,VUID1,VALUE,"?+1,"_IENS) Q:VALUE="^"
        .I MKEY=NAME S ZKEY=VALUE ;S:VUID1'="" LISTVUID(SUBFILE)=1
        .I '$D(ZKEY) S ERROR="1^ZKEY error "_SUBFILE_" VUID: "_VUID Q
        .I ((ZKEY="")!(ZKEY=$C(34,34))) S LIST(SUBFILE)="" Q
        .S LIST(SUBFILE,ZKEY,FIELD)=VALUE
        .I IMPLY D IMPLY
        ;
        I CLEAN,$G(XIEN(IFN,IEN))'>1 D
        .N ROOT,IDX
        .S ROOT=$$ROOT^DILFD(SUBFILE,","_IENS,1)
        .S IDX=0 F  S IDX=$O(@ROOT@(IDX)) Q:'IDX  D
        ..D
        ...N DA,DIK,DIC S DA(1)=+IENS,DA=IDX,DIK=$P(ROOT,")")_"," D ^DIK
        ;
        I MKEY=NAME Q:VALUE=""  D
        .N FDA,IEN
        .;
        .S VALUE=$$VAL^XUMF0(SUBFILE,FIELD,VUID1,VALUE,"?+1,"_IENS) Q:VALUE="^"
        .S FDA(SUBFILE,"?+1,"_IENS,.01)=VALUE
        .D UPDATE^DIE(,"FDA","IEN","ERR")
        .I $D(ERR) D  Q
        ..S ERROR="1^subfile update error SUBFILE#: "_SUBFILE
        ..D EM(ERROR,.ERR) K ERR
        .S IENS1=IEN(1)_","_IENS,MKEY(NAME)=IENS1
        ;
        I MKEY'="",MKEY'=NAME S IENS1=$G(MKEY(MKEY)) Q:IENS1=""
        S:MKEY'=NAME VALUE=$$VAL^XUMF0(SUBFILE,FIELD,VUID1,VALUE,"?+1,"_IENS) Q:VALUE="^"
        S:$D(IENS1) FDA(SUBFILE,IENS1,FIELD)=VALUE
        I IMPLY D IMPLY
        ;
        Q
        ;
IMPLY   ; -- Implied value logic
        N PREV,ARR
        S ARR=$S(LIST1:"LIST",1:"FDA")
        S PREV=$S(LIST1:ZKEY,1:IENS1)
        I MKEY=NAME D  Q
        .I IMPLY("KILL") K IMPLY("PREV") S IMPLY("KILL")=0
        .S IMPLY("PREV",PREV)=""
        S PREV="" F  S PREV=$O(IMPLY("PREV",PREV)) Q:PREV=""  D
        .S @ARR@(SUBFILE,PREV,FIELD)=VALUE
        S IMPLY("KILL")=1
        Q
        ;
LIST    ; -- process list
        ;
        N SUBFILE,ZKEY,FIELD,VALUE,IENS,CNT
        ;
        S IENS=IEN_","
        ;
        ;remove non-standard sub-records (not in message)
        S SUBFILE=0
        F  S SUBFILE=$O(LIST(SUBFILE)) Q:'SUBFILE  D
        .N ROOT,IDX
        .S ROOT=$$ROOT^DILFD(SUBFILE,","_IENS,1)
        .S IDX=0 F  S IDX=$O(@ROOT@(IDX)) Q:'IDX  D
        ..S VALUE=$$GET1^DIQ(SUBFILE,IDX_","_IENS,.01,"I")
        ..I '$D(LIST(SUBFILE,VALUE)) D
        ...N DA,DIK,DIC S DA(1)=+IENS,DA=IDX,DIK=$P(ROOT,")")_"," D ^DIK
        ;
        ;update sub-records
        S SUBFILE=0
        F  S SUBFILE=$O(LIST(SUBFILE)) Q:'SUBFILE  D
        .S ZKEY="",CNT=0
        .F  S ZKEY=$O(LIST(SUBFILE,ZKEY)) Q:ZKEY=""  D
        ..N IDX,ROOT
        ..S ROOT=$$ROOT^DILFD(SUBFILE,","_IENS,1)
        ..S IDX=$O(@ROOT@("B",ZKEY,0))
        ..I $O(@ROOT@("B",ZKEY,IDX)) D DELLIST(IDX)
        ..I 'IDX D ADDLIST Q
        ..S FIELD=0
        ..F  S FIELD=$O(LIST(SUBFILE,ZKEY,FIELD)) Q:'FIELD  D
        ...N X S X=$$GET1^DIQ(SUBFILE,IDX_","_IENS,FIELD)
        ...S VALUE=LIST(SUBFILE,ZKEY,FIELD)
        ...Q:VALUE=X  Q:(VALUE=""""&X="")
        ...S FDA(SUBFILE,IDX_","_IENS,FIELD)=VALUE
        ;
        Q
        ;
ADDLIST ; -- add new sub-record
        ;
        N FDA
        ;
        S CNT=$G(CNT)+1
        S FIELD=0
        F  S FIELD=$O(LIST(SUBFILE,ZKEY,FIELD)) Q:'FIELD  D
        .S VALUE=LIST(SUBFILE,ZKEY,FIELD) Q:VALUE=""
        .S FDA(SUBFILE,"+"_CNT_","_IENS,FIELD)=VALUE
        ;
        Q:'$D(FDA)
        ;
        D UPDATE^DIE(,"FDA",,"ERR")
        I $D(ERR) D  Q
        .S ERROR="1^subfile update error SUBFILE#: "_SUBFILE
        .D EM(ERROR,.ERR) K ERR
        ;
        Q
        ;
DELLIST(IDX)    ; -- delete duplicate
        ;
        F  S IDX=$O(@ROOT@("B",ZKEY,IDX)) Q:'IDX  D
        .N DA,DIK,DIC S DA(1)=+IENS,DA=IDX,DIK=$P(ROOT,")")_"," D ^DIK
        ;
        Q
        ;
UPDATE  ; -- FileMan update
        ;
        Q:ERROR
        Q:EXIT
        ;
        D:$D(FDA) FILE^DIE(,"FDA","ERR")
        I $D(ERR) D
        .S ERROR="1^updating error"
        .D EM(ERROR,.ERR) K ERR
        ;
        Q
        ;
ARRAY   ; -- query data stored in array (not filed)
        ;
        S ^TMP("XUMF ARRAY",$J,IFN,VUID,$P(HLNODE,HLFS,2))=$P(HLNODE,HLFS,3)
        ;
        Q
        ;
ADD     ; -- ADD-processing logic
        ;
        N X
        ;
        S X=$G(^DIC(4.001,+IFN,3)) X:X'="" X
        ;
        Q
        ;
MFE0    ; -- MFE-processing logic
        ;if creating a new entry you must set IEN and other tasks performed in STUB^XUMF0 (if appropriate)
        ;
        N X
        ;
        S X=$G(^DIC(4.001,+IFN,4)) X:X'="" X
        ;
        Q
        ;
ZRT0    ; -- ZRT-processing logic
        ;
        N X
        ;
        S X=$G(^DIC(4.001,+IFN,5)) X:X'="" X
        ;
        Q
        ;
POST    ; -- post-processing logic
        ;
        N X
        ;
        S X=$G(^DIC(4.001,+IFN,2)) X:X'="" X
        ;
        Q
        ;
EXIT    ; -- cleanup, and quit
        ;
        K ^TMP("DILIST",$J),^TMP("DIERR",$J),^TMP("HLS",$J),^TMP("HLA",$J)
        ;
        K ^TMP("XUMF MFS",$J),^TMP("XUMF ERROR",$J),^TMP("XUMF EVENT",$J)
        ;
        Q
        ;
REPLY   ; -- MFK
        ;
        N X,I,I1,I2,CNT
        ;
        S CNT=1
        S X="MSA"_HLFS_$S(ERROR:"AE",1:"AA")_HLFS_HL("MID")_HLFS_$P(ERROR,U,2)
        S ^TMP("HLA",$J,CNT)=X
        S CNT=CNT+1
        ;
        S I1="",I=0
        F  S I1=$O(^TMP("XUMF ERROR",$J,I1)) Q:'$L(I1)  D
        .S I2="" F  S I2=$O(^TMP("XUMF ERROR",$J,I1,I2)) Q:'$L(I2)  D
        ..S X=$G(^(I2))
        ..Q:'$L(X)
        ..S I=I+1
        ..S X="ERR"_HLFS_I_HLFS_$S($O(^TMP("XUMF ERROR",$J,I1))!$O(^TMP("XUMF ERROR",$J,I1,I2)):1,1:0)_HLFS_X
        ..S ^TMP("HLA",$J,CNT)=X
        ..S CNT=CNT+1
        ;
        D:ERROR EM^XUMF0
        ;
        D GENACK^HLMA1($G(HL("EID")),$G(HLMTIENS),$G(HL("EIDS")),"GM",1,.HLRESLT)
        ;
        Q
        ;
EM(ERROR,ERR)   ; -- error message
        ;
        N X,I,Y
        ;
        D MSG^DIALOG("AM",.X,80,,"ERR")
        ;
        S ERRCNT=ERRCNT+1
        ;
        S ^TMP("XUMF ERROR",$J,ERRCNT_".01")=""
        S ^TMP("XUMF ERROR",$J,ERRCNT_".02")=""
        S ^TMP("XUMF ERROR",$J,ERRCNT_".03")=$G(ERROR)
        S ^TMP("XUMF ERROR",$J,ERRCNT_".04")=""
        S ^TMP("XUMF ERROR",$J,ERRCNT_".05")="VUID: "_$G(VUID)_"   IFN: "_$G(IFN)_"   IEN: "_IEN
        S ^TMP("XUMF ERROR",$J,ERRCNT_".06")=""
        S X=.9 F  S X=$O(X(X)) Q:'X  D
        .S ^TMP("XUMF ERROR",$J,ERRCNT_"."_X)=X(X)
        ;
        Q
        ;
STATUS  ;
        ;
        I VALUE=$P($$GETSTAT^XTID(IFN,,IEN_","),U) Q
        ;
        I SUBFILE="" S ERROR="1^status parameter error" Q
        ;
        N FDA
        S FDA(SUBFILE,"?+1,"_IENS,.01)=$$NOW^XLFDT
        S FDA(SUBFILE,"?+1,"_IENS,.02)=VALUE
        D UPDATE^DIE(,"FDA",,"ERR")
        I $D(ERR) D
        .S ERROR="1^effective date and status error"
        .D EM(ERROR,.ERR) K ERR
        ;
        Q
        ;
WP      ;
        ;
        N X,Y,A,I,CNT,X1,X2,ESC
        D SEGPRSE^XUMFXHL7("HLNODE","X",HLFS,60)
        ;
        S CNT=1
        S A(CNT)=X(2)
        S I=0
        F  S I=$O(X(2,I)) Q:'I  D
        .S Y=X(2,I)
        .I $E(Y,1)=" " D  Q
        ..S A(CNT)=A(CNT)_" "
        ..Q:$P(Y," ",2)=""
        ..S CNT=CNT+1
        ..S A(CNT)=$P(Y," ",2,99)
        .S X1=$P(Y," ",1)
        .S X2=$P(Y," ",2,99)
        .S A(CNT)=A(CNT)_X1_$S(X2="":"",1:" ")
        .Q:X2=""
        .S CNT=CNT+1
        .S A(CNT)=X2
        ;
        D UNESCWP^XUMF0(.A,.HL)
        ;
        D WP^DIE(IFN,IENS,FIELD,"K","A","ERR")
        ;
        I $D(ERR) D
        .S ERROR="1^wp field error"
        .D EM(ERROR,.ERR) K ERR
        ;
        Q
        ;
RECORD  ;MFS event protocol data
        ;
        N ROOT,NODE,NODE1,CHANGE,STATUS
        ;
        I $G(ERROR) D  Q
        .S ^TMP("XUMF EVENT",$J,"ERROR")=ERROR
        .S ^TMP("XUMF EVENT",$J,"ERROR",1)=$G(IFN)_U_$G(IEN)
        ;
        S ROOT=$$ROOT^DILFD(IFN,,1)
        M RECORD("AFTER")=@ROOT@(IEN)
        ;
        I $G(RECORD("NEW")) M ^TMP("XUMF EVENT",$J,IFN,"NEW",IEN)=RECORD("AFTER") Q
        ;
        S ^TMP("XUMF EVENT",$J,IFN,"AFTER",IEN,"REPLACED BY")=$P($G(@ROOT@(IEN,"VUID")),U,3)
        S ^TMP("XUMF EVENT",$J,IFN,"AFTER",IEN,"INHERITS FROM")=$$RPLCMNT^XTIDTRM(IFN,IEN)
        ;
        S STATUS=$$GETSTAT^XTID(IFN,,IEN_",")
        I RECORD("STATUS")'=STATUS D
        .S ^TMP("XUMF EVENT",$J,IFN,"STATUS",IEN)=$P(RECORD("STATUS"),U,1,2)_U_$P(STATUS,U,1,2)
        ;
        S NODE=$Q(RECORD("AFTER","")),NODE1=$Q(RECORD("BEFORE","")),CHANGE=0
        I $P(NODE,"RECORD(""AFTER")'=$P(NODE1,"RECORD(""BEFORE") S CHANGE=1
        I @NODE'=@NODE1 S CHANGE=1
        I 'CHANGE FOR  SET NODE=$Q(@NODE) Q:NODE=""!(NODE["(""BEFORE")  D  Q:CHANGE
        .S NODE1=$Q(@NODE1) I NODE1="" S CHANGE=1 Q
        .I $P(NODE,"RECORD(""AFTER")'=$P(NODE1,"RECORD(""BEFORE") S CHANGE=1 Q
        .I @NODE'=@NODE1 S CHANGE=1 Q
        ;
        I CHANGE D
        .M ^TMP("XUMF EVENT",$J,IFN,"AFTER",IEN)=RECORD("AFTER")
        .M ^TMP("XUMF EVENT",$J,IFN,"BEFORE",IEN)=RECORD("BEFORE")
        ;
        Q
        ;
