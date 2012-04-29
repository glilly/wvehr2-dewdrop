PXRMPDR ;SLC/AGP,PKR - Patient List Demographic report main routine ;09/02/2009
        ;;2.0;CLINICAL REMINDERS;**4,6,12**;Feb 04, 2005;Build 73
        ;
EN(PLIEN)       ; -- main entry point for PXRM PATIENT LIST DEMOGRAPHIC
        N ARRAY,DC,DDATA,DELIM,DTOUT,DUOUT
        W @IOF
        K ^TMP("PXRMPLD",$J),^TMP("PXRMPLN",$J)
        S DELIM=0
OPTION  ;
        W !,"Select the items to include on the report."
ADDSEL  D ADDSEL^PXRMPDRS(.DDATA,"ADD")
        I $D(DTOUT)!$D(DUOUT) Q
APPSEL  D APPSEL^PXRMPDRS(.DDATA,"APP")
        I $D(DTOUT)!$D(DUOUT) G ADDSEL
DEMSEL  D DEMSEL^PXRMPDRS(.DDATA,"DEM")
        I $D(DTOUT)!$D(DUOUT) G APPSEL
PFACSEL S DDATA("PFAC",0)=$$ASKYN^PXRMEUT("N","Include the patient's preferred facility")
        I $D(DTOUT)!$D(DUOUT) G DEMSEL
        S DDATA("PFAC","LEN")=$S(DDATA("PFAC",0)=1:1,1:0)
ELIGSEL D ELIGSEL^PXRMPDRS(.DDATA,"ELIG")
        I $D(DTOUT)!$D(DUOUT) G PFACSEL
DATASEL D DATASEL^PXRMPDRS(PLIEN,.DDATA,"FIND")
        I $D(DTOUT)!$D(DUOUT) G ELIGSEL
INPSEL  D INPSEL^PXRMPDRS(.DDATA,"INP")
        I $D(DTOUT)!$D(DUOUT) G DATASEL
REMDATA D REMSEL^PXRMPDRS(PLIEN,.DDATA,"REM")
        I $D(DTOUT)!$D(DUOUT) G INPSEL
        S DELIM=$$ASKYN^PXRMEUT("Y","Delimited Report:")
        I $D(DTOUT)!$D(DUOUT) G REMDATA
        S DC=$S(DELIM:$$DELIMSEL^PXRMXSD,1:U)
        I $D(DTOUT)!$D(DUOUT) G OPTION
DEVICE  ;
        N DESC,DIR,PXRMQUE,RTN,SAVE,%ZIS
        S %ZIS="M"
        S DESC="Patient List Demographic Report"
        S RTN="GETPDATA^PXRMPDR(DELIM,DC,PLIEN,.DDATA)"
        S SAVE("DELIM")="",SAVE("DC")="",SAVE("PLIEN")=""
        S SAVE("DDATA(")=""
        S PXRMQUE=$$DEVICE^PXRMXQUE(RTN,DESC,.SAVE,.%ZIS,1)
        I PXRMQUE'="" G EXIT
        I $D(DTOUT)!$D(DUOUT) G EXIT
        S DIR(0)="E" D ^DIR
EXIT    D KVA^VADPT
        K ^TMP("PXRMPLD",$J),^TMP("PXRMPLN",$J)
        Q
        ;
GETPDATA(DELIM,DC,PLIEN,DDATA)  ;
        N DATA,DATE,DCREAT,DFN,DTYPE,ERRMSG
        N GETADD,GETAPP,GETDEM,GETELIG,GETFIND,GETINP,GETREM
        N IEN,IND,JND,KND,LND
        N LISTNAME,PIECE
        N PDATA,PNAME,RIEN,TDATA
        K ^TMP("PXRMPD",$J)
        S LISTNAME=$P(^PXRMXP(810.5,PLIEN,0),U,1)
        S DCREAT=$P(^PXRMXP(810.5,PLIEN,0),U,4)
        S GETDEM=$S(DDATA("DEM","LEN")>0:1,1:0)
        S GETADD=$S(DDATA("ADD","LEN")>0:1,1:0)
        S GETINP=$S(DDATA("INP","LEN")>0:1,1:0)
        S GETELIG=$S(DDATA("ELIG","LEN")>0:1,1:0)
        S GETAPP=$S(DDATA("APP","LEN")>0:1,1:0)
        S GETFIND=$S(DDATA("FIND","LEN")>0:1,1:0)
        S GETREM=$S(DDATA("REM","LEN")>0:1,1:0)
        S IEN=0
        F  S IEN=+$O(^PXRMXP(810.5,PLIEN,30,IEN)) Q:IEN=0  D
        . S DFN=$P(^PXRMXP(810.5,PLIEN,30,IEN,0),U,1) I DFN="" Q
        .;#DBIA 10035
        . S PNAME=$P($G(^DPT(DFN,0)),U,1)
        . I PNAME="" S PNAME="UNDEFINED"_DFN
        . S ^TMP("PXRMPLN",$J,PNAME,DFN)=""
        . S PDATA=""
        . I GETDEM D
        .. N VADM
        .. D DEM^VADPT
        .. F IND=1:1:DDATA("DEM","LEN") D
        ... S JND=$P(DDATA("DEM"),",",IND)
        ... S KND=0
        ... F  S KND=$O(DDATA("DEM",JND,KND)) Q:KND=""  D
        .... S PIECE=$P(DDATA("DEM",JND,KND),U,2)
        .... S TDATA=$P(VADM(KND),U,PIECE)
        .... S LND=""
        .... F  S LND=$O(VADM(KND,LND)) Q:LND=""  D
        ..... I TDATA'="" S TDATA=TDATA_"~"
        ..... S TDATA=TDATA_$P(VADM(KND,LND),U,PIECE)
        .... I KND=2,'DDATA("DEM","FULLSSN") S TDATA=$E(TDATA,8,11)
        .... S $P(PDATA,U,KND)=TDATA
        .. I PDATA'="" S ^TMP("PXRMPLD",$J,DFN,"DEM")=PDATA,PDATA=""
        . I DDATA("PFAC",0)=1 D
        ..;DBIA #1850
        .. S TDATA=$$GET1^DIQ(2,DFN,27.02,"E","","ERRMSG")
        .. I TDATA="" S TDATA="NONE"
        .. S ^TMP("PXRMPLD",$J,DFN,"PFAC")=TDATA
        . I GETADD D
        .. N ADDTYPE,LND,MND,OFFSET,VAPA
        .. D ADD^VADPT
        .. S ADDTYPE=$S(((DT'<VAPA(9))&(DT'>VAPA(10))):"T",1:"R")
        ..;If the confidential address is active make sure the categories
        ..;match those that were selected. VHA Directive 2003-025 states
        ..;the confidential address must be used if it is active.
        .. I VAPA(12),DDATA("ADD")["1," D
        ... F LND=1:1:DDATA("ADD",22,"LEN") D
        .... S MND=$P(DDATA("ADD",22,"LIST"),",",LND)
        ....;If this category = VAPA(22,MND), was selected use it.
        .... I $D(VAPA(22,MND)) S ADDTYPE="C"
        .. S OFFSET=$S(ADDTYPE="C":12,1:0)
        .. S (VAPA(23),VAPA(23+OFFSET))=ADDTYPE
        .. F IND=1:1:DDATA("ADD","LEN") D
        ... S JND=$P(DDATA("ADD"),",",IND)
        ...;The offset is only used for addresses.
        ... I JND=2 S OFFSET=0
        ... S KND=0
        ... F  S KND=+$O(DDATA("ADD",JND,KND)) Q:KND=0  D
        .... S PIECE=$P(DDATA("ADD",JND,KND),U,2)
        .... S TDATA=$P(VAPA(KND+OFFSET),U,PIECE)
        .... S $P(PDATA,U,KND)=TDATA
        .. I PDATA'="" S ^TMP("PXRMPLD",$J,DFN,"ADD")=PDATA,PDATA=""
        . I GETINP D
        .. N VAIP
        .. D INP^VADPT
        .. F IND=1:1:DDATA("INP","LEN") D
        ... S JND=$P(DDATA("INP"),",",IND)
        ... S KND=0
        ... F  S KND=$O(DDATA("INP",JND,KND)) Q:KND=""  D
        .... S PIECE=$P(DDATA("INP",JND,KND),U,2)
        .... S TDATA=$P(VAIN(KND),U,PIECE)
        .... S $P(PDATA,U,KND)=TDATA
        .. I PDATA'="" S ^TMP("PXRMPLD",$J,DFN,"INP")=PDATA,PDATA=""
        . I GETELIG D
        .. N VAEL
        .. D ELIG^VADPT
        .. F IND=1:1:DDATA("ELIG","LEN") D
        ... S JND=$P(DDATA("ELIG"),",",IND)
        ... S KND=0
        ... F  S KND=$O(DDATA("ELIG",JND,KND)) Q:KND=""  D
        .... S PIECE=$P(DDATA("ELIG",JND,KND),U,2)
        .... S TDATA=$P(VAEL(KND),U,PIECE)
        .... I KND=4 S TDATA=$S(TDATA=1:"YES",1:"NO")
        .... S $P(PDATA,U,KND)=TDATA
        .. I PDATA'="" S ^TMP("PXRMPLD",$J,DFN,"ELIG")=PDATA,PDATA=""
        . D KVA^VADPT
        . I GETREM D
        .. S IND=0
        .. F  S IND=$O(DDATA("REM","IEN",IND)) Q:IND=""  D
        ... S PDATA=$G(^PXRMXP(810.5,PLIEN,30,IEN,"REM",IND,0))
        ... I PDATA="" Q
        ... S RIEN=$P(PDATA,U,1)
        ... S ^TMP("PXRMPLD",$J,DFN,"REM",RIEN)=PDATA,PDATA=""
        . I GETFIND D
        .. N DL
        .. F IND=1:1:DDATA("FIND","LEN") D
        ... S JND=$P(DDATA("FIND"),",",IND)
        ... S DTYPE=DDATA("FIND",JND,JND)
        ... S KND=$O(^PXRMXP(810.5,PLIEN,30,IEN,"DATA","B",DTYPE,""))
        ... S DL=$S(KND="":0,1:$L(^PXRMXP(810.5,PLIEN,30,IEN,"DATA",KND,0),U))
        ... S DATA=$S(KND="":"",1:$P(^PXRMXP(810.5,PLIEN,30,IEN,"DATA",KND,0),U,2,DL))
        ... S ^TMP("PXRMPLD",$J,DFN,"FIND",JND)=DATA
        ;Get appointment data for all patients on the list.
        I GETAPP D
        . N APPLIST,ARRAY,COUNT,DONE
        . S ARRAY(1)=DT,ARRAY(3)="I;R",ARRAY(4)="^TMP($J,""PXRMPL"""
        . S ARRAY("FLDS")=""
        . F IND=1:1:DDATA("APP","LEN") D
        .. S JND=$P(DDATA("APP"),",",IND)
        .. S KND=0
        .. F  S KND=$O(DDATA("APP",JND,KND)) Q:KND=""  S ARRAY("FLDS")=ARRAY("FLDS")_KND_";"
        . K ^TMP($J,"PXRMPL"),^TMP($J,"SDAMA301")
        . S IND=0
        . F  S IND=+$O(^PXRMXP(810.5,PLIEN,30,IND)) Q:IND=0  D
        .. S DFN=$P(^PXRMXP(810.5,PLIEN,30,IND,0),U,1)
        .. I DFN'="" S ^TMP($J,"PXRMPL",DFN)=""
        . S COUNT=$$SDAPI^SDAMA301(.ARRAY)
        . I COUNT=-1 D  Q
        .. D APPERR^PXRMPDRS
        .. S DDATA("APP","ERROR")=""
        .. K ^TMP($J,"PXRMPL"),^TMP($J,"SDAMA301")
        .;Data is ^TMP($J,"SDAMA301",DFN,CLINIC,DATE)=DATE^CLINIC
        .;Resort by DATE then CLINIC.
        . S DFN=""
        . F  S DFN=$O(^TMP($J,"SDAMA301",DFN)) Q:DFN=""  D
        .. K APPLIST
        .. S JND=0
        .. F  S JND=$O(^TMP($J,"SDAMA301",DFN,JND)) Q:JND=""  D
        ... S DATE=0
        ... F  S DATE=$O(^TMP($J,"SDAMA301",DFN,JND,DATE)) Q:DATE=""  S APPLIST(DATE,JND)=""
        .. S (DATE,DONE,KND)=0
        .. F  S DATE=$O(APPLIST(DATE)) Q:(DONE)!(DATE="")  D
        ... S JND=0
        ... F  S JND=$O(APPLIST(DATE,JND)) Q:(DONE)!(JND="")  D
        .... S KND=KND+1
        .... I KND=DDATA("APP","MAX") S DONE=1
        .... S TDATA=^TMP($J,"SDAMA301",DFN,JND,DATE)
        .... S PDATA=$$FMTE^XLFDT($P(TDATA,U,1))
        .... S TDATA=$P(TDATA,U,2),TDATA=$P(TDATA,";",2)
        .... S PDATA=PDATA_U_TDATA
        .... S ^TMP("PXRMPLD",$J,DFN,"APP",KND)=PDATA
        . K ^TMP($J,"PXRMPL"),^TMP($J,"SDAMA301")
        I DELIM=1 D DELIMPR^PXRMPDRP(DC,PLIEN,.DDATA)
        I DELIM=0 D REGPR^PXRMPDRP(PLIEN,.DDATA)
        Q
        ;
LENGTH(STR,STR1)        ;
        I ($L(STR)+$L(STR1))>245 W !,STR S STR=STR1
        E  S STR=STR_U_STR1,STR1=""
        Q
        ;
