ONCGENED        ;Hines OIFO/GWB - EDITS API ; 3/7/07 4:21pm
        ;;2.11;ONCOLOGY;**47,48**;Mar 07,1995;Build 13
        ;
NAACCR  D CLEAR^ONCSAPIE(1)
        K ^TMP("ONC",$J)
        K ^TMP("ONC1",$J)
        K ONCEDLST
        N BLANK,NINE,ZERO,ZNINE,X
        S BLANK=" "
        S ZERO=0
        S NINE=9
        S ZNINE="09"
        S EXTRACT=$O(^ONCO(160.16,"B","VACCR EXTRACT V11.2",0))
        S EXT="VACCR"
        S DEVICE=0,OIEN=0,PAGE=1,HDRIEN=12,OUT=0
        S OSP=$O(^ONCO(160.1,"C",DUZ(2),0))
        I OSP="" S OSP=$O(^ONCO(160.1,0))
        S IINPNT=$P($G(^ONCO(160.1,OSP,1)),U,4)
        S DXH=$$GET1^DIQ(160.19,IINPNT,.01,"I")
        S STAT1=DXH
        S PAGE=1
        S IEN=D0
        S ONCDST=$NA(^TMP("ONC",$J))
        S MSGLST=$NA(^TMP("ONC1",$J))
        ;
        ;S RC=$$RBQPREP^ONCSED01(.ONCSAPI,.ONCDST,"DEBUG")
        S RC=$$RBQPREP^ONCSED01(.ONCSAPI,.ONCDST)
        ;S ERRFLG=RC
        I RC<0 D PRTERRS^ONCSAPIE() Q
        ;
        N D0
        D OUTPUT(IEN,EXTRACT,.OUT)
        I $G(EDITS)="NO" D END^ONCSNACR(.ONCDST) Q
        ;
EDITS   S RC=$$RBQEXEC^ONCSED01(.ONCSAPI,.ONCDST,MSGLST)
        S ERRFLG=RC
        I RC<0 D PRTERRS^ONCSAPIE()
        I RC>0 D  Q:RC<0
        . N %ZIS,IOP,POP
        . S %ZIS("B")="HOME"
        . D ^%ZIS  Q:$G(POP)  U IO
        . S RC=$$REPORT^ONCSED01(.ONCSAPI,MSGLST,"MT")
        . D ^%ZISC
        Q
        ;
OUTPUT(IEN,EXTRACT,OUT) ;
        N POS
        S ACD160=$P(^ONCO(165.5,IEN,0),U,2)
        S POS=0
        F  S POS=$O(^ONCO(160.16,EXTRACT,"FIELD","B",POS)) Q:POS<1  D  Q:OUT
        .N NODE
        .S NODE=0
        .F  S NODE=$O(^ONCO(160.16,EXTRACT,"FIELD","B",POS,NODE)) Q:NODE<1  D  Q:OUT
        ..N STRING,DEFAULT,FILL,LEN
        ..Q:$G(^ONCO(160.16,EXTRACT,"FIELD",NODE,0))=""
        ..S STRING=$TR(^ONCO(160.16,EXTRACT,"FIELD",NODE,1),"~","^")
        ..S DEFAULT=^ONCO(160.16,EXTRACT,"FIELD",NODE,2)
        ..S FILL=$P(^ONCO(160.16,EXTRACT,"FIELD",NODE,3),U,1)
        ..S LEN=$P(^ONCO(160.16,EXTRACT,"FIELD",NODE,0),U,2)
        ..D DATA(IEN,ACD160,STRING,DEFAULT,FILL,LEN,NODE,POS)
        Q
        ;
DATA(IEN,ACD160,STRING,DEFAULT,FILL,LEN,NODE,POS)       ;Data print
        N ACDANS
        X STRING
        I ACDANS="" D  Q
        .N X,I
        .S X=""
        .I DEFAULT=8 D  Q
        ..F I=1:1:LEN D WRITE^ONCSNACR(.ONCDST,DEFAULT)
        .I @DEFAULT="09" D WRITE^ONCSNACR(.ONCDST,@DEFAULT) Q
        .F I=1:1:LEN D WRITE^ONCSNACR(.ONCDST,@DEFAULT)
        I $L(ACDANS)=LEN D WRITE^ONCSNACR(.ONCDST,ACDANS) Q
        I $L(ACDANS)>LEN D WRITE^ONCSNACR(.ONCDST,$E(ACDANS,1,LEN)) Q
        E  D  Q
        .N JUST,STUFF,I,REM,CAL
        .S JUST=$P(FILL,","),STUFF=$P(FILL,",",2)
        .S REM=LEN-$L(ACDANS)
        .I JUST="R" D WRITE^ONCSNACR(.ONCDST,ACDANS)
        .F I=1:1:REM D WRITE^ONCSNACR(.ONCDST,@STUFF)
        .I JUST="L" D WRITE^ONCSNACR(.ONCDST,ACDANS)
        Q
        ;
CHKSUM  ;Compute checksum
        Q:'$D(ONCDST)
        Q:$P($G(^ONCO(165.5,D0,7)),U,2)'=3
        W !," Computing checksum value for this abstract..."
        S CHECKSUM=$$CRC32^ONCSNACR(.ONCDST)
        S $P(^ONCO(165.5,D0,"EDITS"),U,1)=CHECKSUM
        Q
        ;
CHANGE  ;Check for change to ONCOLOGY PRIMARY (165.5) record
        S EDITS="NO" D NAACCR K EDITS
        S CHECKSUM=$$CRC32^ONCSNACR(.ONCDST)
        Q:$P($G(^ONCO(165.5,ONCOD0P,"EDITS")),U,1)=""
        I CHECKSUM'=$P($G(^ONCO(165.5,ONCOD0P,"EDITS")),U,1) D
        .W !
        .W !," You have made a change to a 'Completed' abstract."
        .W !," This abstract needs to be re-run through the EDITS API."
        .W !!," Calling EDITS API..."
        .D ^ONCGENED
        .I ERRFLG'=0 D  Q
        ..W !!," EDITS errors were encountered."
        ..W !!," The ABSTRACT STATUS has been changed to 0 (Incomplete)."
        ..S DIE="^ONCO(165.5,"
        ..S DA=ONCOD0P
        ..S DR="91///0;197///@;198///^S X=DT;199///^S X=DUZ"
        ..D ^DIE
        ..W !
        ..Q:$G(EAFLAG)="YES"
        ..K DIR S DIR(0)="YA"
        ..S DIR("A")=" Do you wish to return to the Primary Menu Options? "
        ..S DIR("B")="Yes" D ^DIR K DIR
        ..I Y=1 S Y="@0"
        .W !!," No EDITS errors or warnings.  ABSTRACT STATUS = 3 (Complete)."
        .S DIE="^ONCO(165.5,"
        .S DA=ONCOD0P
        .S DR="197///^S X=CHECKSUM;198///^S X=DT;199///^S X=DUZ"
        .D ^DIE
        .S EDITS="NO" D NAACCR K EDITS
        .S CHECKSUM=$$CRC32^ONCSNACR(.ONCDST)
        .S $P(^ONCO(165.5,D0,"EDITS"),U,1)=CHECKSUM
        .W !
        .K DIR S DIR(0)="E" D ^DIR
        Q
