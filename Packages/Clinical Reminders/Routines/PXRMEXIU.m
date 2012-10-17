PXRMEXIU        ; SLC/PKR/PJH - Utilities for installing repository entries. ;06/02/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;===============================================
DEF(FDA,NAMECHG)        ;Check the reminder definition to make sure the related
        ;reminder exists and all the findings exist.
        N ABBR,ALIST,IEN,IENS,FILENUM,FINDING,LRD,OFINDING,PT01
        N RRG,SPONSOR,TEXT,VERSN
        S IENS=$O(FDA(811.9,""))
        ;
        ;Related reminder guideline field 1.4.
        I $D(FDA(811.9,IENS,1.4)) D
        . S RRG=FDA(811.9,IENS,1.4)
        . S IEN=$$EXISTS^PXRMEXIU(811.9,RRG)
        . I IEN=0 D
        ..;Get replacement.
        .. N DIC,X,Y
        .. S TEXT(1)=" "
        .. S TEXT(2)="The Related Reminder Guideline does not exist on your system!"
        .. S TEXT(3)="It is "_RRG_" input a replacement or ^ to leave it empty."
        .. D MES^XPDUTL(.TEXT)
        ..;If this is being called during a KIDS install we need echoing on.
        .. I $D(XPDNM) X ^%ZOSF("EON")
        .. S DIC=811.9,DIC(0)="AEMQ"
        .. D ^DIC
        .. I $D(XPDNM) X ^%ZOSF("EOFF")
        .. I Y=-1 K FDA(811.9,IENS,1.4)
        .. E  S FDA(811.9,IENS,1.4)=$P(Y,U,2)
        ;
        ;Sponsor field 101.
        I $D(FDA(811.9,IENS,101)) D
        . S SPONSOR=FDA(811.9,IENS,101)
        . S IEN=$$FIND1^DIC(811.6,"","",SPONSOR)
        . I IEN=0 D
        ..;Get replacement.
        .. N DIC,X,Y
        .. S TEXT(1)=" "
        .. S TEXT(2)="The Sponsor does not exist on your system!"
        .. S TEXT(3)="It is "_SPONSOR_" input a replacement or ^ to leave it empty."
        .. D MES^XPDUTL(.TEXT)
        ..;If this is being called during a KIDS install we need echoing on.
        .. I $D(XPDNM) X ^%ZOSF("EON")
        .. S DIC=811.6,DIC(0)="AEMQ"
        .. D ^DIC
        .. I $D(XPDNM) X ^%ZOSF("EOFF")
        .. I Y=-1 K FDA(811.9,IENS,101)
        .. E  S FDA(811.9,IENS,101)=$P(Y,U,2)
        ;
        ;Linked reminder dialog field 51.
        S LRD=$G(FDA(811.9,IENS,51))
        S IEN=$S(LRD="":0,1:+$O(^PXRMD(801.41,"B",LRD,"")))
        I IEN=0 K FDA(811.9,IENS,51)
        ;
        ;Search the finding multiple for replacements and missing findings.
        D BLDALIST^PXRMVPTR(811.902,.01,.ALIST)
        S IENS=""
        F  S IENS=$O(FDA(811.902,IENS)) Q:IENS=""  D
        . S (FINDING,OFINDING)=FDA(811.902,IENS,.01)
        . S ABBR=$P(FINDING,".",1)
        . S PT01=$P(FINDING,".",2)
        . S FILENUM=$P(ALIST(ABBR),U,1)
        . I $D(NAMECHG(FILENUM,PT01)) D
        .. S FINDING=ABBR_"."_NAMECHG(FILENUM,PT01)
        .. S FDA(811.902,IENS,.01)=FINDING
        . S IEN=+$$VFIND1(FINDING,.ALIST)
        . I IEN>0 S FDA(811.902,IENS,.01)=ABBR_".`"_IEN
        . I IEN=0 D
        ..;Get replacement
        .. N DIC,DUOUT,TEXT,X,Y
        .. S TEXT="Finding "_FINDING_" does not exist; input a replacement or ^ to quit the Exchange install."
        .. W !,TEXT
        .. S DIC=FILENUM
        .. I DIC="60" S DIC("S")="I $$LABPANEL^PXRMEXIU(Y)"
        .. S DIC(0)="AEMNQ"
        .. S Y=-1
        .. F  Q:+Y'=-1  D
        ...;If this is being called during a KIDS install we need echoing on.
        ... I $D(XPDNM) X ^%ZOSF("EON")
        ... D ^DIC
        ... I $D(XPDNM) X ^%ZOSF("EOFF")
        ... I $D(DUOUT) S Y="" K FDA
        .. I Y="" Q
        .. S FINDING=ABBR_"."_$P(Y,U,2),FDA(811.902,IENS,.01)=FINDING
        .;Save the finding information for the history.
        . S ^TMP("PXRMEXIA",$J,"DEFF",$P(IENS,",",1),OFINDING)=FINDING
        .;Save changes to Orderable items for dialog
        . I FILENUM=101.43,OFINDING'=FINDING
        . S NAMECHG(FILENUM,$P(OFINDING,".",2))=$P(FINDING,".",2)
        S VERSN=$$GETTAGV^PXRMEXU3(^PXD(811.8,PXRMRIEN,100,3,0),"<PACKAGE_VERSION>")
        I VERSN=1.5 D CEFD^PXRMDATE(.FDA)
        Q
        ;
        ;===============================================
EXISTS(FILENUM,NAME,FLAG)       ;Check for existence of an entry with the
        ;same name. Return 0 for null name. If FLAG="W" then if necessary
        ;display the warning message.
        I NAME="" Q 0
        ;Return the ien if it does, 0 otherwise.
        N IEN
        I FILENUM=0 S IEN=$$EXISTS^PXRMEXCF(NAME) Q
        N FLAGS,RESULT
        S RESULT=NAME
        ;Special lookup for files 80 and 80.1, they do not have a standard "B"
        ;cross-reference.
        I (FILENUM=80)!(FILENUM=80.1) D
        .;Name may or may not have the necessary space appended, make sure
        .;it does.
        . S RESULT=$S($E(NAME,$L(NAME))'=" ":NAME_" ",1:NAME)
        . S FLAGS="MX"
        E  S FLAGS="BX"
        I FILENUM=811.6 S FLAGS=FLAGS_"U"
        ;File 8927.1 only allows upper case .01s.
        I FILENUM=8927.1 S RESULT=$$UP^XLFSTR(NAME)
        S IEN=$$FIND1^DIC(FILENUM,"",FLAGS,RESULT)
        I +IEN>0 Q IEN
        ;If IEN is null then there was an error try FIND^DIC.
        N FILENAME,LIST,MSG,NFOUND,TEXT
        D FIND^DIC(FILENUM,"","",FLAGS,NAME,"","","","","LIST","MSG")
        S NFOUND=+$P(LIST("DILIST",0),U,1)
        I NFOUND=0 Q 0
        I NFOUND=1 Q LIST("DILIST",2,1)
        ;Multiple entries with the same name found. If FLAG="W" display the
        ;warning message, return the first entry on the list and quit.
        I $G(FLAG)="W" D  Q LIST("DILIST",2,1)
        . S FILENAME=$$GET1^DID(FILENUM,"","","NAME")
        . S TEXT(1)="Warning there are "_NFOUND_" "_FILENAME_" entries with the name "_NAME_"!"
        . S TEXT(2)="If this is used as a finding, and it is not resolved by FileMan during"
        . S TEXT(3)="installation, any component using this finding will not install."
        . D EN^DDIOL(.TEXT)
        . H 3
        ;If FLAG is not "W" prompt the user for the replacement.
        I NFOUND>1 S IEN=$$GETIEN^PXRMEXU0(NFOUND,.LIST)
        Q IEN
        ;
        ;===============================================
GETACT(CHOICES,DIR)     ;Get the action
        ;If CHOICES is empty the only action is skip.
        I CHOICES="" Q "S"
        N DIROUT,DIRUT,DTOUT,DUOUT,X,Y
        S DIR(0)="S"_U
        I CHOICES["C" S DIR(0)=DIR(0)_"C:Create a new entry by copying to a new name"
        I CHOICES["D" S DIR(0)=DIR(0)_";D:Delete (from the reminder/dialog)"
        I CHOICES["I" S DIR(0)=DIR(0)_";I:Install"
        I CHOICES["M" S DIR(0)=DIR(0)_";M:Merge findings"
        I CHOICES["O" S DIR(0)=DIR(0)_";O:Overwrite the current entry"
        I CHOICES["P" S DIR(0)=DIR(0)_";P:Replace (in the reminder/dialog) with an existing entry"
        I CHOICES["Q" S DIR(0)=DIR(0)_";Q:Quit the install"
        I CHOICES["R" S DIR(0)=DIR(0)_";R:Restart"
        I CHOICES["S" S DIR(0)=DIR(0)_";S:Skip, do not install this entry"
        ;If this is being called during a KIDS install we need echoing on.
        I $D(XPDNM) X ^%ZOSF("EON")
        D ^DIR
        I $D(XPDNM) X ^%ZOSF("EOFF")
        I $D(DIROUT)!$D(DIRUT) S Y="S"
        I $D(DTOUT)!($D(DUOUT)) S Y="S"
        Q Y
        ;
        ;===============================================
GETNAME(MIN,MAX)        ;Get a name to use.
        N DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
        S DIR(0)="FAOU"_U_MIN_":"_MAX
        S DIR("A")="Input the new name: "
        D ^DIR
        I $D(DIROUT)!$D(DIRUT) Q ""
        I $D(DTOUT)!$D(DUOUT) Q ""
        Q Y
        ;
        ;===============================================
GETUNAME(ATTR)  ;Get a unique name to use, ATTR holds the attributes.
        N IEN,NEWPT01,TEXT
GNEW    S NEWPT01=$$GETNAME(ATTR("MIN FIELD LENGTH"),ATTR("FIELD LENGTH"))
        S IEN=+$$EXISTS(ATTR("FILE NUMBER"),NEWPT01)
        I IEN>0 D  G GNEW
        . S TEXT(1)=ATTR("FILE NAME")_" entry "_NEWPT01_" already exists."
        . S TEXT(2)="Input a different name or type <ENTER> to quit."
        . D EN^DDIOL(.TEXT)
        E  S ATTR("NAME")=NEWPT01
        Q NEWPT01
        ;
        ;===============================================
HF(FDA,NAMECHG) ;Check the health factor to make sure a category does not
        ;have a category.
        N IENS
        S IENS=$O(FDA(9999999.64,""))
        I IENS="" Q
        I FDA(9999999.64,IENS,.1)="CATEGORY" K FDA(9999999.64,IENS,.03)
        Q
        ;
        ;===============================================
LABPANEL(IEN)   ;
        N NODE
        S NODE=^LAB(60,IEN,0)
        I $P(NODE,U,4)'["CH" Q 1
        I $P(NODE,U,5)="" Q 0
        Q 1
        ;
        ;===============================================
REXISTS(NAME,DATEP)     ;See if this Exchange File entry already exists.
        N IEN,LUVALUE
        S LUVALUE(1)=NAME
        S LUVALUE(2)=DATEP
        S IEN=+$$FIND1^DIC(811.8,"","KU",.LUVALUE)
        Q IEN
        ;
        ;===============================================
TERM(FDA,NAMECHG)       ;Check the reminder term to make sure all the
        ;findings exist.
        N ABBR,ALIST,IEN,IENS,FILENUM,FINDING,OFINDING,PT01
        ;Search the finding multiple for replacements and missing findings.
        D BLDALIST^PXRMVPTR(811.52,.01,.ALIST)
        S IENS=""
        F  S IENS=$O(FDA(811.52,IENS)) Q:IENS=""  D
        . S (FINDING,OFINDING)=FDA(811.52,IENS,.01)
        . S ABBR=$P(FINDING,".",1)
        . S PT01=$P(FINDING,".",2)
        . S FILENUM=$P(ALIST(ABBR),U,1)
        . I $D(NAMECHG(FILENUM,PT01)) D
        .. S FINDING=ABBR_"."_NAMECHG(FILENUM,PT01)
        .. S FDA(811.52,IENS,.01)=FINDING
        . S IEN=+$$VFIND1(FINDING,.ALIST)
        . I IEN>0 S FDA(811.52,IENS,.01)=ABBR_".`"_IEN
        . I IEN=0 D
        ..;Get replacement
        .. N DIC,DUOUT,TEXT,X,Y
        .. S TEXT="Finding "_FINDING_" does not exist; input a replacement or ^ to quit the Exchange install."
        .. D BMES^XPDUTL(TEXT)
        .. S DIC=FILENUM
        .. I DIC="60" S DIC("S")="I $$LABPANEL^PXRMEXIU(Y)"
        .. S DIC(0)="AEMNQ"
        .. S Y=-1
        .. F  Q:+Y'=-1  D
        ...;If this is being called during a KIDS install we need echoing on.
        ... I $D(XPDNM) X ^%ZOSF("EON")
        ... D ^DIC
        ... I $D(XPDNM) X ^%ZOSF("EOFF")
        ... I $D(DUOUT) D
        .... S Y=""
        .... K FDA
        .. I Y="" K FDA(811.52,IENS)
        .. E  D
        ... S FINDING=ABBR_"."_$P(Y,U,2)
        ... S FDA(811.52,IENS,.01)=FINDING
        .;Save the finding information for the history.
        . S ^TMP("PXRMEXIA",$J,"TRMF",$P(IENS,",",1),OFINDING)=FINDING
        Q
        ;
        ;===============================================
TIUOBJ(FDA)     ;Resolve the name of the health summary object.
        N END,HSOBJIEN,IENS,TEMP
        S IENS=$O(FDA(8925.1,""))
        S TEMP=$G(FDA(8925.1,IENS,9))
        I TEMP'["TIU^GMTSOBJ" Q
        S TEMP=$P(TEMP,",",2)
        S END=$L(TEMP)-1
        S TEMP=$E(TEMP,1,END)
        S HSOBJIEN=$O(^GMT(142.5,"B",TEMP,""))
        S FDA(8925.1,IENS,9)="S X=$$TIU^GMTSOBJ(DFN,"_HSOBJIEN_")"
        Q
        ;
        ;===============================================
VDLGFIND(ABBR,IEN,ALIST)        ;
        ;determine if the finding item associated with a reminder dialog
        ;is active returns a 1 if it is inactive returns a 0
        N FILENUM
        S FILENUM=$P(ALIST(ABBR),U,1)
        Q $$FILESCR^PXRMDLG6(IEN,FILENUM)
        ;
        ;===============================================
VFIND1(VPTR,ALIST)      ;Given a variable pointer of the form ABBR.NAME
        ;and ALIST which contains the link between abbreviations and files
        ;return the IEN if it exists and 0 if no match if found.
        N ABBR,IEN,FILENUM,PT01,RESULT
        S IEN=0
        S ABBR=$P(VPTR,".",1)
        S PT01=$P(VPTR,".",2,99)
        S FILENUM=$P(ALIST(ABBR),U,1)
        S IEN=$$EXISTS(FILENUM,PT01)
        Q IEN
        ;
