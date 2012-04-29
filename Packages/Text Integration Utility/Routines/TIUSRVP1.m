TIUSRVP1        ; SLC/JER - More API's in support of PUT ;8/14/07
        ;;1.0;TEXT INTEGRATION UTILITIES;**19,59,89,100,109,167,113,112,219**;Jun 20, 1997;Build 11
SITEPARM(TIUY)  ; Get site parameters for GUI
        N TIUPRM0,TIUPRM1
        D SETPARM^TIULE
        S TIUY=TIUPRM0
        Q
DEFDOC(TIUY,HLOC,USER,TIUDT,TIUIEN)     ; Get default primary provider
        N TIUSPRM,TIUDDOC,TIUAUTH
        D SITEPARM(.TIUSPRM)
        S TIUDDOC=+$P(TIUSPRM,U,8)
        S TIUAUTH=$S((+$G(USER)!('+$G(TIUIEN))):0,1:+$P($G(^TIU(8925,+$G(TIUIEN),12)),U,2))
        S USER=$S(+$G(USER):+$G(USER),+$G(TIUAUTH):+$G(TIUAUTH),1:DUZ)
        S TIUDT=$S(+$G(TIUDT):+$G(TIUDT),1:DT)
        S TIUY=$S(TIUDDOC=1:$$DFLTDOC^TIUPXAPI(HLOC),TIUDDOC=2:$$CURDOC(USER),1:"0^")
        Q
CURDOC(USER,TIUDT)      ; Is the current user a known Provider?
        N TIUY,TIUPROV S TIUY="0^"
        S USER=$S(+$G(USER):+$G(USER),1:DUZ)
        S TIUDT=$S(+$G(TIUDT):+$G(TIUDT),1:DT)
        S TIUPROV=$$PROVIDER^TIUPXAP1(USER,TIUDT)
        I +TIUPROV S TIUY=USER_U_$$PERSNAME^TIULC1(USER)
        Q TIUY
ISAPROV(TIUY,USER,DATE) ; Is user a provider?
        ; Checks USR CLASS PROVIDER AND 200 Person Class
        ; DATE must not include time (for ISA^USRLM)
        S USER=$G(USER,DUZ)
        S DATE=$G(DATE,DT)
        S TIUY=$$PROVIDER^TIUPXAP1(USER,DATE)
        Q
USRPROV(TIUY,USER,DATE) ; Is USER a USR CLASS provider?
        ; Checks USR CLASS PROVIDER only
        ; DATE must not include time
        N TIUERR
        S USER=$G(USER,DUZ)
        S DATE=$G(DATE,DT),TIUY=0
        I +$$ISA^USRLM(USER,"PROVIDER",.TIUERR,DATE) S TIUY=1 ;  DBIA/ICR 2324
        Q
DOCPARM(TIUY,TIUDA,TIUTYP)      ; Get document parameters for GUI
        I '+$G(TIUTYP),+$G(TIUDA) S TIUTYP=+$G(^TIU(8925,+TIUDA,0))
        I '+$G(TIUTYP) S TIUY(0)="" Q
        D DOCPRM^TIULC1(TIUTYP,.TIUY,$G(TIUDA))
        I '$D(TIUY) S TIUY(0)=""
        Q
CONSTUB(TIUDA,GMRCVP,DFN)       ; Create a stub for a Consult Report
        N DIE,DR,DA
        D STUB(.TIUDA,"CONSULT REPORT",DFN)
        I +TIUDA'>0 Q
        S DIE=8925,DA=+TIUDA,DR="1405////^S X=GMRCVP"
        D ^DIE
        Q
STUB(TIUDA,TIUTITL,DFN) ; Create a stub
        N TIUVSIT,TIUFPRIV,DIC,DIE,DR,DA,DLAYGO,X,Y S TIUFPRIV=1
        I +$G(TIUTITL)'>0 S TIUTITL=$$WHATITLE^TIUPUTU(TIUTITL)
        I +TIUTITL'>0 S TIUDA=-1 Q
        S (DIC,DLAYGO)=8925,DIC(0)="LF"
        S X=""""_"`"_+TIUTITL_""""
        D ^DIC S TIUDA=+Y Q:+Y'>0
        D EVENT(.TIU,DFN) I $L($G(TIU("VSTR")))'>0 S TIUDA=-1 Q
        S DIE=DIC,DA=TIUDA
        S DR=".02////"_+DFN_";.03////"_$P($G(TIU("VISIT")),U)_";.04////"_+$$DOCCLASS^TIULC1(TIUTITL)_";.05///UNDICTATED;.13////E;1301////"_+$$NOW^XLFDT
        D ^DIE
        Q
EVENT(TIUY,DFN) ; Create an Event-type Visit Entry
        N VDT,VSTR,DGPM
        S DGPM=$G(^DPT(DFN,.105)) ;DBIA/ICR 10035
        I +DGPM'>0 D
        . S VDT=$$NOW^XLFDT
        . S VSTR=";"_VDT_";"_"E"
        D PATVADPT^TIULV(.TIUY,+DFN,DGPM,$G(VSTR))
        I $G(TIUY("LOC"))="",+DUZ D
        .N TIUPREF,IDX
        .S TIUPREF=$$PERSPRF^TIULE(DUZ)
        .S IDX=+$P(TIUPREF,U,2)
        .I IDX S TIUY("LOC")=IDX_U_$P($G(^SC(IDX,0)),U,1) ; DBIA/ICR 10040
        Q
GETPNAME(TIUY,TIUTYPE)   ; Get Print Name of a Document
        S TIUY=$$PNAME^TIULC1(TIUTYPE)
        Q
SAVED(TIUY,TIUDA)       ; Was the document committed to the database?
        N TIUD12,TIUD13,TIUEBY,TIUAUT,TIUECS S TIUY=1
        S TIUD12=$G(^TIU(8925,TIUDA,12)),TIUD13=$G(^(13))
        S TIUEBY=$P(TIUD13,U,2),TIUAUT=$P(TIUD12,U,2),TIUECS=$P(TIUD12,U,8)
        I $D(^TIU(8925,"ASAVE",+DUZ,TIUDA)) D  Q
        . S TIUY="0^You appear to have been disconnected..."
        I DUZ'=TIUEBY,(TIUEBY'=TIUAUT),$D(^TIU(8925,"ASAVE",+TIUEBY,TIUDA)) D  Q
        . S TIUY="0^The transcriber appears to have been disconnected..."
        I DUZ'=TIUAUT,$D(^TIU(8925,"ASAVE",+TIUAUT,TIUDA)) D  Q
        . S TIUY="0^The author appears to have been disconnected..."
        I DUZ'=TIUECS,$D(^TIU(8925,"ASAVE",+TIUECS,TIUDA)) D  Q
        . S TIUY="0^The expected cosigner appears to have been disconnected..."
        Q
STUFREC(TIUDA,TIUREC,DFN,PARENT,TITLE,TIU)      ; load TIUREC for create
        N TIUREQCS,TIUSCAT,TIUSTAT,TIUCPF
        ;Set a flag to indicate whether or not a Title is a member of the
        ;Clinical Procedures Class (1=Yes and 0=No)
        S TIUCPF=+$$ISA^TIULX(TITLE,+$$CLASS^TIUCP)
        S TIUSTAT=$$STATUS(TIUDA,+$G(SUPPRESS),$G(TITLE))
        D REQCOS^TIUSRVA(.TIUREQCS,+TITLE,"",$S(+$G(TIUREC(1202)):+$G(TIUREC(1202)),1:DUZ))
        I +$G(PARENT)'>0 D
        . S TIUREC(.02)=$G(DFN),TIUREC(.03)=$P($G(TIU("VISIT")),U)
        . S TIUREC(.05)=$S(+$G(TIUREC(.05)):+$G(TIUREC(.05)),+TIUSTAT:TIUSTAT,1:5)
        . S TIUREC(.07)=$P($G(TIU("EDT")),U),TIUREC(.08)=$P($G(TIU("LDT")),U)
        . S TIUREC(1401)=$P($G(TIU("AD#")),U)
        . S TIUREC(1402)=$P($G(TIU("TS")),U)
        . S TIUREC(1404)=$P($G(TIU("SVC")),U)
        I +$G(PARENT)>0 D
        . S TIUREC(.02)=+$P($G(^TIU(8925,+PARENT,0)),U,2)
        . S TIUREC(.03)=+$P($G(^TIU(8925,+PARENT,0)),U,3)
        . S TIUREC(.05)=$S(+$G(TIUREC(.05)):+$G(TIUREC(.05)),+TIUSTAT:TIUSTAT,1:5)
        . S TIUREC(.06)=PARENT,TIUREC(.07)=$P(TIU("EDT"),U)
        . S TIUREC(.08)=$P(TIU("LDT"),U)
        . S TIUREC(1401)=$P($G(^TIU(8925,+PARENT,14)),U)
        . S TIUREC(1402)=$P($G(^TIU(8925,+PARENT,14)),U,2)
        . S TIUREC(1404)=$P($G(^TIU(8925,+PARENT,14)),U,4)
        . S TIUREC(1405)=$P($G(^TIU(8925,+PARENT,14)),U,5)
        S TIUREC(.04)=$$DOCCLASS^TIULC1(TITLE)
        S TIUSCAT=$S(+$L($P($G(TIU("CAT")),U)):$P($G(TIU("CAT")),U),+$L($P($G(TIU("VSTR")),";",3)):$P($G(TIU("VSTR")),";",3),1:"")
        S TIUREC(.13)=TIUSCAT
        ;If the document is a member of the Clinical Procedures Class, set the
        ;Author/Dictator and the Expected Signer fields to Null
        S (TIUREC(1202),TIUREC(1204))=$S(+$G(TIUREC(1202)):+$G(TIUREC(1202)),TIUCPF:"",1:+$G(DUZ))
        S TIUREC(1212)=$P($G(TIU("INST")),U)
        S TIUREC(1205)=$P($G(TIU("LOC")),U)
        S TIUREC(1211)=$P($G(TIU("VLOC")),U)
        S TIUREC(1201)=$$NOW^XLFDT
        S TIUREC(1301)=$S($G(TIUREC(1301))]"":$P(TIUREC(1301),U),1:$$NOW^XLFDT)
        I +$$ISDS^TIULX(TITLE) D
        . I +$G(TIU("LDT"))'>0 S TIUREC(.12)=1
        . S TIUREC(.13)="H"
        . D REFDT(.TIUREC)
        ;If the document is a member of the Clinical Procedures Class, set the
        ;Entered By field to Null
        S TIUREC(1303)="R",TIUREC(1302)=$S(TIUCPF:"",1:$G(DUZ))
        I $S(+$G(TIUREC(1208))&(+$G(TIUREC(1204))'=+$G(TIUREC(1208))):1,+$G(TIUREQCS):1,1:0) S TIUREC(1506)=1
        Q
REFDT(TIUX)     ; Hack Ref Date/time for DS's
        S TIUX(1301)=$S(+$G(TIU("LDT")):+$G(TIU("LDT")),1:$G(TIUX(1301)))
        Q
STATUS(TIUDA,SUPPRESS,TITLE)     ; Compute the status of the current record
        N TIUDPRM,TIUY
        ; If the document is an addendum, compute status based on processing
        ; requirements of the Parent document or its ancestors
        I +$$ISADDNDM^TIULC1(TIUDA) D
        . S TIUDA=$S(+$P(^TIU(8925,TIUDA,0),U,6):$P(^(0),U,6),1:TIUDA)
        . S TITLE=+$G(^TIU(8925,TIUDA,0))
        D DOCPRM^TIULC1(TITLE,.TIUDPRM,$G(TIUDA))
        I +$P(TIUDPRM(0),U,2),+$G(SUPPRESS) S TIUY=3 G STATUX
        S TIUY=$S(+$$REQVER^TIULC(+TIUDA,+$P($G(TIUDPRM(0)),U,3)):4,1:5)
STATUX  Q TIUY
IDATTCH(TIUY,TIUDA,TIUDAD)      ; Attach TIUDA as ID Child entry to TIUDAD
        N TIUX
        S TIUX(2101)=TIUDAD
        D FILE^TIUSRVP(.TIUY,TIUDA,.TIUX,1)
        D AUDLINK^TIUGR1(TIUDA,"a",TIUDAD)
        D SENDID^TIUALRT1(TIUDA)
        Q
IDDTCH(TIUY,TIUDA)      ; Detach TIUDA from its ID Parent
        N TIUX,IDDAD
        I '+$G(^TIU(8925,TIUDA,21)) D  Q
        . S TIUY="0^Record #"_TIUDA_" is NOT an ID Entry."
        S IDDAD=+$G(^TIU(8925,TIUDA,21))
        S TIUX(2101)="@"
        D FILE^TIUSRVP(.TIUY,TIUDA,.TIUX,1)
        D AUDLINK^TIUGR1(TIUDA,"d",IDDAD)
        D IDDEL^TIUALRT1(TIUDA)
        Q
CANDEL(TIUDA)   ; Boolean function to evaluate delete request
        Q $S($P(^TIU(8925,TIUDA,0),U,5)>3:0,'+$$EMPTYDOC^TIULF(TIUDA):0,1:1)
