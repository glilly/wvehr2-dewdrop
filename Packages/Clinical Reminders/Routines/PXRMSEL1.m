PXRMSEL1        ; SLC/PJH - PXRM Selection ;06/19/2009
        ;;2.0;CLINICAL REMINDERS;**12**;Feb 04, 2005;Build 73
        ;
        ; Called by PXRMSEL
        ;
BUILD   ;Build selection list
        ;
        D CHGCAP^VALM("HEADER1"," Item")
        ;Reminder Dialog
        I PXRMGTYP="DLG" D  Q
        .N CODE,DATA,DDIS,PXRMDIEN,PXRMDNAM,PXRMITEM,PXRMRNAM,TXT,TYP
        .S CODE="",VALMCNT=0
        .F  S CODE=$O(^PXRMD(801.41,"B",CODE)) Q:CODE=""  D
        ..;Get Dialog detail
        ..S PXRMDIEN=$O(^PXRMD(801.41,"B",CODE,"")) Q:'PXRMDIEN
        ..S DATA=$G(^PXRMD(801.41,PXRMDIEN,0)) Q:$P(DATA,U,4)'="R"
        ..S PXRMDNAM=$P(DATA,U),PXRMRNAM="",DDIS=0
        ..I $P(DATA,U,3)>0 S DDIS=1
        ..I $O(^PXD(811.9,"AG",PXRMDIEN,"")),DDIS=0 S DDIS=2
        ..S PXRMITEM=$P($G(^PXRMD(801.41,PXRMDIEN,0)),U,2)
        ..I PXRMITEM D
        ...I $E(PXRMVIEW,2)="N" S PXRMRNAM=$P($G(^PXD(811.9,PXRMITEM,0)),U)
        ...I $E(PXRMVIEW,2)="P" S PXRMRNAM=$P($G(^PXD(811.9,PXRMITEM,0)),U,3)
        ..S PXRMDNAM=$E(PXRMDNAM,1,39),PXRMRNAM=$E(PXRMRNAM,1,39)
        ..S:PXRMRNAM="" PXRMRNAM="*NONE*"
        ..S TXT=PXRMDNAM_$J("",40-$L(PXRMDNAM))_PXRMRNAM
        ..S VALMCNT=VALMCNT+1,TXT=$J(VALMCNT,4)_"  "_TXT
        ..S TXT=$E(TXT,1,71)_$J("",71-$L(TXT))
        ..S TXT=TXT_" "_$S(DDIS=1:"Disabled",DDIS=2:"Linked",1:"")
        ..D SET^VALM10(VALMCNT,TXT,PXRMDIEN)
        .D CHGCAP^VALM("HEADER2","Reminder Dialog Name"_$J("",20)_"Source Reminder")
        .D CHGCAP^VALM("HEADER3"," Status")
        ;
        ;All dialogs types
        I PXRMGTYP="DLGE" D  Q
        .N CODE,DATA,DDIS,DTYP,PXRMDIEN,PXRMDNAM,PXRMITEM,TXT
        .S CODE="",VALMCNT=0,VALMBG=1
        .F  S CODE=$O(^PXRMD(801.41,"B",CODE)) Q:CODE=""  D
        ..;Get Dialog detail
        ..S PXRMDIEN=$O(^PXRMD(801.41,"B",CODE,"")) Q:'PXRMDIEN
        ..S DATA=$G(^PXRMD(801.41,PXRMDIEN,0)),DTYP=$P(DATA,U,4)
        ..I PXRMDTYP'="A" Q:DTYP'=PXRMDTYP
        ..Q:DTYP="R"
        ..S PXRMDNAM=$P(DATA,U),DDIS=0 I $P(DATA,U,3)>0 S DDIS=1
        ..S PXRMITEM=$O(^PXD(811.9,"AG",PXRMDIEN,""))
        ..I PXRMITEM,DDIS=0 S DDIS=2
        ..S PXRMDNAM=$E(PXRMDNAM,1,39)
        ..S TXT=PXRMDNAM_$J("",40-$L(PXRMDNAM))_$$LIT(DTYP)
        ..S VALMCNT=VALMCNT+1,TXT=$J(VALMCNT,4)_"  "_TXT
        ..S TXT=$E(TXT,1,71)_$J("",71-$L(TXT))
        ..S TXT=TXT_$S(DDIS=1:"Disabled",1:"")
        ..D SET^VALM10(VALMCNT,TXT,PXRMDIEN)
        .D CHGCAP^VALM("HEADER2","Dialog Name"_$J("",29)_"Dialog type")
        .D CHGCAP^VALM("HEADER3","Status")
        ;
        ;Link reminders to dialogs
        I PXRMGTYP="DLGR" D  Q
        .N CODE,DATA,DDIS,DTYP,DIEN,DNAM,MODE,PNAM,RIEN,RNAM,SUB,TXT,TYPE
        .S CODE="",VALMCNT=0,VALMBG=1,MODE=$E(PXRMVIEW,2),TYPE=$E(PXRMVIEW)
        .S SUB=$S(MODE="P":"D",1:"B")
        .F  S CODE=$O(^PXD(811.9,SUB,CODE)) Q:CODE=""  D
        ..;Get Dialog detail
        ..S RIEN=""
        ..F  S RIEN=$O(^PXD(811.9,SUB,CODE,RIEN)) Q:'RIEN  D
        ...S DATA=$G(^PXD(811.9,RIEN,0)) Q:DATA=""
        ...S RNAM=$P(DATA,U),PNAM=$P(DATA,U,3)
        ...S DIEN=$P($G(^PXD(811.9,RIEN,51)),U)
        ...I TYPE="L" Q:'DIEN
        ...I MODE="P" S:PNAM]"" RNAM=PNAM
        ...S RNAM=$E(RNAM,1,34),DNAM="",DDIS=2
        ...D:DIEN
        ....S DATA=$G(^PXRMD(801.41,DIEN,0)),DDIS=0
        ....S DNAM=$P(DATA,U) I $P(DATA,U,3)]"" S DDIS=1
        ....S DNAM=$E(DNAM,1,27) I DNAM="" S DNAM="??"
        ...S TXT=RNAM_$J("",35-$L(RNAM))
        ...S TXT=TXT_DNAM_$J("",28-$L(DNAM))
        ...S VALMCNT=VALMCNT+1,TXT=$J(VALMCNT,4)_"  "_TXT
        ...S TXT=$E(TXT,1,71)_$J("",71-$L(TXT))
        ...S TXT=TXT_$S(DDIS=1:"Disabled",1:"")
        ...D SET^VALM10(VALMCNT,TXT,RIEN)
        .I MODE="N" S TXT="Reminder Name"_$J("",22)
        .I MODE="P" S TXT="Reminder Print Name"_$J("",16)
        .S TXT=TXT_"Linked Dialog Name & Dialog St"
        .D CHGCAP^VALM("HEADER2",TXT)
        .D CHGCAP^VALM("HEADER3","atus")
        ;
        ;Finding item parameters
        I PXRMGTYP="FIP" D  Q
        .N CODE,DATA,DNAM,DSUB,IEN,FDIS,FSUB,FITEM,FLIT,FTYP,TXT
        .S CODE="",VALMCNT=0
        .F  S CODE=$O(^PXRMD(801.43,"B",CODE)) Q:CODE=""  D
        ..S IEN=$O(^PXRMD(801.43,"B",CODE,""))
        ..S DATA=$G(^PXRMD(801.43,IEN,0)),TXT=$E($P(DATA,U),1,39)
        ..S FITEM=$P(DATA,U,2),FTYP=$P(FITEM,";",2),FSUB=$P(FITEM,";")
        ..I FTYP]"" S FTYP=$G(DEF1(FTYP)) S:FTYP="" FTYP="??"
        ..S FLIT="??" I FSUB S FLIT=FTYP_"("_FSUB_")"
        ..S VALMCNT=VALMCNT+1,TXT=$J(VALMCNT,4)_"  "_FTYP_"-"_TXT
        ..S DSUB=$P(DATA,U,4),DNAM="",FDIS=$P(DATA,U,3)
        ..I DSUB S DNAM=$P($G(^PXRMD(801.41,DSUB,0)),U)
        ..S TXT=TXT_$J("",40-$L(TXT))_DNAM
        ..S TXT=$E(TXT,1,71)_$J("",71-$L(TXT))_$S(FDIS=1:"Disabled",1:"Enabled")
        ..D SET^VALM10(VALMCNT,TXT,IEN)
        .D CHGCAP^VALM("HEADER2","Finding Item Type & Name"_$J("",10)_"Dialog Group/Element")
        .D CHGCAP^VALM("HEADER3","Status")
        ;
        ;Finding Type Parameters
        I PXRMGTYP="FPAR" D
        .N CODE,FDES,TXT,IEN
        .S CODE="",VALMCNT=0
        .F  S CODE=$O(^PXRMD(801.45,"B",CODE)) Q:CODE=""  D
        ..I CODE="POV" S FDES="DIAGNOSIS (POV)"
        ..I CODE="CPT" S FDES="PROCEDURE (CPT)"
        ..I $D(DEF2(CODE)) S FDES=DEF2(CODE)
        ..S VALMCNT=VALMCNT+1,TXT=$J(VALMCNT,4)_"  "_FDES
        ..S IEN=$O(^PXRMD(801.45,"B",CODE,""))
        ..D SET^VALM10(VALMCNT,TXT,IEN)
        .D CHGCAP^VALM("HEADER2","Finding Type Parameter")
        ;
        ;Reminder Categories
        I PXRMGTYP="RCAT" D  Q
        .N CODE,DATA,TXT,IEN
        .S CODE="",VALMCNT=0
        .F  S CODE=$O(^PXRMD(811.7,"B",CODE)) Q:CODE=""  D
        ..S IEN=$O(^PXRMD(811.7,"B",CODE,""))
        ..S DATA=$G(^PXRMD(811.7,IEN,0)),TXT=$P(DATA,U)
        ..S VALMCNT=VALMCNT+1,TXT=$J(VALMCNT,4)_"  "_TXT
        ..D SET^VALM10(VALMCNT,TXT,IEN)
        .D CHGCAP^VALM("HEADER2","Reminder Category")
        ;
        ;Taxonomy
        I PXRMGTYP="DTAX" D  Q
        .N CODE,DATA,TXT,IEN
        .S CODE="",VALMCNT=0
        .F  S CODE=$O(^PXD(811.2,"B",CODE)) Q:CODE=""  D
        ..S IEN=$O(^PXD(811.2,"B",CODE,""))
        ..S DATA=$G(^PXD(811.2,IEN,0)),TXT=$P(DATA,U)
        ..S VALMCNT=VALMCNT+1,TXT=$J(VALMCNT,4)_"  "_TXT
        ..D SET^VALM10(VALMCNT,TXT,IEN)
        .D CHGCAP^VALM("HEADER2","Reminder Taxonomy")
        ;
        ;Resolution Statuses
        I PXRMGTYP="RESN" D  Q
        .N CODE,DATA,HED,IEN,TXT,TYP
        .S CODE="",VALMCNT=0
        .F  S CODE=$O(^PXRMD(801.9,"B",CODE)) Q:CODE=""  D
        ..S IEN=$O(^PXRMD(801.9,"B",CODE,""))
        ..S DATA=$G(^PXRMD(801.9,IEN,0))
        ..S TXT=$E($P(DATA,U),1,39),TYP=$P(DATA,U,6)
        ..S VALMCNT=VALMCNT+1,TXT=$J(VALMCNT,4)_"  "_TXT
        ..S TXT=TXT_$J("",40-$L(TXT))_$S(TYP=1:"NATIONAL",1:"LOCAL")
        ..D SET^VALM10(VALMCNT,TXT,IEN)
        .S HED="Reminder Resolution Status        National/Local"
        .D CHGCAP^VALM("HEADER2",HED)
        ;
        ;Health Factor Resolutions
        I PXRMGTYP="SHFR" D  Q
        .N CODE,DARRAY,DATA,HCNT,IEN,RNAM,SUB,TXT
        .S IEN=0
        .F  S IEN=$O(^PXRMD(801.95,IEN)) Q:'IEN  D
        ..S DATA=$G(^AUTTHF(IEN,0)),TXT=$E($P(DATA,U),1,39) Q:TXT=""
        ..S DARRAY(TXT)=IEN
        .S CODE="",VALMCNT=0,HCNT=0
        .F  S CODE=$O(DARRAY(CODE)) Q:CODE=""  D
        ..S IEN=DARRAY(CODE)
        ..S DATA=$G(^AUTTHF(IEN,0))
        ..S VALMCNT=VALMCNT+1,HCNT=HCNT+1,TXT=$J(VALMCNT,4)_"  "_CODE
        ..S SUB=$O(^PXRMD(801.95,IEN,1,"B",0))
        ..S RNAM="" I SUB S RNAM=$P($G(^PXRMD(801.9,SUB,0)),U)
        ..S TXT=TXT_$J("",40-$L(TXT))_RNAM
        ..F  S SUB=$O(^PXRMD(801.95,IEN,1,"B",SUB)) Q:'SUB  D
        ...S RNAM=$P($G(^PXRMD(801.9,SUB,0)),U)
        ...S TXT=TXT_"/"_RNAM
        ..D SET^VALM10(VALMCNT,TXT,IEN)
        .D CHGCAP^VALM("HEADER2","Health Factors"_$J("",20)_"Resolution Status")
        ;
        Q
        ;
LIT(INP)        ;Dialog type description
        Q:INP="E" "Dialog Element"
        Q:INP="F" "Forced Value"
        Q:INP="G" "Dialog Group"
        Q:INP="P" "Additional Prompt"
        Q:INP="R" "Reminder Dialog"
        Q:INP="S" "Result Group"
        Q:INP="T" "Result Element"
        Q "???"
