PXRMDLST        ; SLC/PJH - Reminder Dialog Inquiry ;07/31/2009
        ;;2.0;CLINICAL REMINDERS;**12**;Feb 04, 2005;Build 73
        ;
        ;
START   N BY,DC,DHD,DIC,EXPAND,FLDS,FR,L,LIT,LOGIC,NOW,TO,Y
        N PXRMFIEN,PXRMHD
        ;
        S LIT="ALL DIALOGS"
        I PXRMDTYP="R" S LIT="REMINDER DIALOGS"
        I PXRMDTYP="P" S LIT="DIALOG PROMPTS"
        I PXRMDTYP="F" S LIT="DIALOG FORCED VALUES"
        I PXRMDTYP="E" S LIT="DIALOG ELEMENTS"
        I PXRMDTYP="G" S LIT="DIALOG GROUPS"
        ;
        ;DIC is killed by DIP.
SELECT  S DIC="^PXRMD(801.41,"
        S DIC(0)="AEMQ"
        S DIC("A")="Select Dialog Definition: "
        ;Current dialog type only
        S DIC("S")="I $P(^(0),U,4)=PXRMDTYP"
        D ^DIC
        I Y'=-1 D  G SELECT
        .;^DIP options
        .D SET
        .D DISP
END     Q
        ;
        ;List all (for protocol PXRM SELECTION LIST)
        ;--------
ALL     N BY,DC,DHD,DIC,DIS,FLDS,FR,L,LIT,LOGIC,NOW,TO,Y
        S LIT="ALL DIALOGS"
        I PXRMDTYP="R" S LIT="REMINDER DIALOGS"
        I PXRMDTYP="P" S LIT="DIALOG PROMPTS"
        I PXRMDTYP="E" S LIT="DIALOG ELEMENTS"
        I PXRMDTYP="G" S LIT="DIALOG GROUPS"
        I PXRMDTYP="F" S LIT="DIALOG FORCED VALUES"
        I $G(PXRMGTYP)="DLG" S LIT="REMINDER DIALOGS"
        S Y=1
        D SET
        S DIC="^PXRMD(801.41,"
        ;
        I PXRMDTYP'="A" S DIS(0)="I $P($G(^PXRMD(801.41,D0,0)),U,4)=PXRMDTYP"
        S BY=".01"
        S FR=""
        S TO=""
        S DHD="W ?0 D HED^PXRMDLST"
        D DISP
        Q
        ;
        ;Inquire/Print Option (for protocol PXRM GENERAL INQUIRE/PRINT)
        ;--------------------
INQ(Y)  N BY,DC,DHD,DIC,FLDS,FR,L,LOGIC,NOW,TO
        S DIC="^PXRMD(801.41,"
        S DIC(0)="AEMQ"
        D SET
        D DISP
        Q
        ;
        ;Inquiry/Print for dialog edit (for protocol PXRM DIALOG SELECTION INQ)
        ;-----------------------------
INQ1    W IORESET
        D START
        Q
        ;
        ;
        ;Display using print templates
        ;-----------------------------
DISP    S L=0,FLDS="[PXRM REMINDER DIALOG]"
        I PXRMDTYP="E" S FLDS="[PXRM DIALOG ELEMENT]"
        I PXRMDTYP="F" S FLDS="[PXRM DIALOG FORCED VALUE]"
        I PXRMDTYP="G" S FLDS="[PXRM DIALOG GROUP]"
        I PXRMDTYP="P" S FLDS="[PXRM DIALOG PROMPT]"
        I PXRMDTYP="S" S FLDS="[PXRM RESULT GROUP]"
        I PXRMDTYP="T" S FLDS="[PXRM RESULT ELEMENT]"
        ;
        D EN1^DIP
        Q
        ;
        ;Header
        ;------
HED     N TEMP,TEXTLEN,TEXTHED,TEXTUND
        S TEXTHED="REMINDER DIALOG INQUIRY"
        S TEXTUND=$TR($J("",IOM)," ","-")
        S TEMP=NOW_"  Page "_DC
        S TEXTLEN=$L(TEMP)
        W TEXTHED
        W ?(IOM-TEXTLEN),TEMP
        W !,TEXTUND,!!
        Q
        ;
        ;Get question text
        ;-----------------
PROMPT  N DTYP,FIRST,NODE,SUB,LINE,TAB
        S SUB=$P(X,U,2) Q:SUB=""
        S DTYP=$P($G(^PXRMD(801.41,SUB,0)),U,4) Q:DTYP=""
        ;Dialog element
        I DTYP="E" D  Q
        .S NODE=0,FIRST=1,TAB=26
        .F  S NODE=$O(^PXRMD(801.41,SUB,25,NODE)) Q:'NODE  D
        ..S LINE=$G(^PXRMD(801.41,SUB,25,NODE,0))
        ..I 'FIRST W !
        ..I FIRST,$L(LINE)>50 W ! S TAB=2
        ..W ?TAB,LINE
        ;Prompt/Forced Value
        I "FP"[DTYP W $P($G(^PXRMD(801.41,SUB,2)),U,4)
        Q
        ;
SET     ;Setup all the variables
        ; Set Date for Header
        S NOW=$$NOW^XLFDT
        S NOW=$$FMTE^XLFDT(NOW,"1P")
        ;
        ;These variables need to be setup every time because DIP kills them.
        S BY="NUMBER"
        S (FR,TO)=+$P(Y,U,1)
        S DHD="W ?0 D HED^PXRMDLST"
        ;
        Q
        ;
        ;Orderable item
        ;--------------
ORDER   I '$G(D0) Q
        N QNAM,QORDER,RIEN,RNAM
        S RIEN=$P($G(^PXRMD(801.41,D0,1)),U,3),RNAM=""
        I RIEN S RNAM=$P($G(^PXRMD(801.9,RIEN,0)),U)
        I RNAM'="ORDERED" W ?24,"N/A" Q
        S QORDER=$P($G(^PXRMD(801.41,D0,1)),U,7)
        I 'QORDER W ?24,"None" Q
        S QNAM=$P($G(^ORD(101.43,QORDER,0)),U) I QNAM="" S QNAM="Unknown"
        W ?24,QNAM," (OI["_QORDER_"])"
        Q
        ;
        ;Dialog ELEMENT pointed to by REMINDER DIALOGS/GROUPS
        ;"AGP NO LONGER USED REPLACE BY USE"
        ;----------------------------------------------------
REPLACE(DIEN,TAB,CUR)   ;
        Q:'$G(DIEN)
        N DATA,DSUB,DENAM,DETYP,DTLIT,DMES
        S DSUB=0
        F  S DSUB=$O(^PXRMD(801.41,"R",DIEN,DSUB)) Q:'DSUB  D
        .S DATA=$G(^PXRMD(801.41,DSUB,0)) Q:DATA=""
        .S DENAM=$P(DATA,U) Q:DENAM=""
        .S DETYP=$P(DATA,U,4) Q:DETYP=""
        .S DTLIT="??",DMES="" S:CUR=DSUB DMES="Current "
        .I DETYP="G" S DTLIT="Dialog Group"
        .I DETYP="E" S DTLIT="Dialog Element"
        .W ?TAB,DENAM_" ("_DMES_DTLIT_")",!
        Q
        ;
USE(DIEN,TAB,CUR,XREF)  ;
        Q:'$G(DIEN)
        N DATA,DSUB,DENAM,DETYP,DTLIT,DMES
        S DSUB=0
        F  S DSUB=$O(^PXRMD(801.41,XREF,DIEN,DSUB)) Q:'DSUB  D
        .S DATA=$G(^PXRMD(801.41,DSUB,0)) Q:DATA=""
        .S DENAM=$P(DATA,U) Q:DENAM=""
        .S DETYP=$P(DATA,U,4) Q:DETYP=""
        .S DTLIT="??",DMES="" S:CUR=DSUB DMES="Current "
        .I DETYP="R" S DTLIT="Reminder Dialog"
        .I DETYP="G" S DTLIT="Dialog Group"
        .I DETYP="E" S DTLIT="Dialog Element"
        .I DETYP="S" S DTLIT="Result Group"
        .W ?TAB,DENAM_" ("_DMES_DTLIT_")",!
        Q
