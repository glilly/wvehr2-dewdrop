XUSNPIE2        ;FO-OAKLAND/JLI - DATA ENTRY FOR INITIAL NPI VALUES ;5/13/08  17:41
        ;;8.0;KERNEL;**410,435,454,462,480**;Jul 10, 1995;Build 38
        ;;Per VHA Directive 2004-038, this routine should not be modified
        Q
        ;
PRINTOPT        ;
        N DIR,%ZIS,ION,OPTION,PRNTFRMT,XUSDIV,XUSSORT,XUSRESO,Y,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK
        K IO("Q")
        W !,"Select one of the following:",!!,?11,"1",?21,"All providers",!,?11,"2",?21,"All providers without NPI numbers",!
        S DIR(0)="N^1:2",DIR("A")="Select a report option",DIR("B")="1" D ^DIR K DIR Q:Y'>0  S OPTION=+Y
        S XUSRESO="" D  Q:XUSRESO=""
        . S DIR(0)="S^P:Providers who are not residents;R:Residents only;B:Both"
        . S DIR("B")="P",DIR("A")="Selection: "
        . D ^DIR K DIR Q:"PRB"'[Y
        . S XUSRESO=Y Q
        S DIR(0)="Y",DIR("B")="NO",DIR("A")="Sort by DIVISION" D ^DIR K DIR Q:Y="^"  S XUSDIV=+Y
        S PRNTFRMT=1
        I XUSDIV S DIR(0)="N^1:2",DIR("A")="Output type (1=Printed text or 2=^-delimited)" D ^DIR K DIR Q:Y'>0  S PRNTFRMT=Y
        S DIR(0)="Y",DIR("B")="YES",DIR("A")="Sort by SERVICE/SECTION"_$S(XUSDIV>0:" (as well)",1:"") D ^DIR K DIR Q:Y="^"  S XUSSORT=+Y
        W !!,">>> Report processing time is approximately 10 minutes."
        W !,"    Recommend text output be queued to a network printer."
        W !
        S %ZIS="MQ" D ^%ZIS Q:POP
        I $D(IO("Q")) D  Q
        . S ZTSAVE("OPTION")="",ZTSAVE("XUSSORT")="",ZTSAVE("XUSDIV")="",ZTSAVE("PRNTFRMT")="",ZTSAVE("XUSRESO")=""
        . S ZTIO=ION,ZTRTN="DQ^XUSNPIE2",ZTDESC="NPI PRINT JOB FOR OPTION "_OPTION
        . D ^%ZTLOAD W:$D(ZTSK) !,"Queued as Task "_ZTSK D HOME^%ZIS Q
        ;
DQ      ; entry point for queued print job
        U IO D PRNTPROV(OPTION,XUSSORT,XUSDIV,PRNTFRMT,XUSRESO)
        U IO D ^%ZISC
        Q
        ;
PRNTPROV(OPTION,XUSSORT,XUSDIV,PRNTFRMT,XUSRESO)        ;
        ; PRINT PROVIDER INFO
        ;
        ; OPTION   SPECIFIES TYPE OF PRINT - 1=ALL PROVIDERS, 2=NEEDS NPI ONLY
        ; XUSSORT  INDICATES WHETHER SORTED BY SERVICE/SECTION
        ; XUSDIV   INDICATES WHETHER SORTED BY DIVISION
        ; PRNTFRMT INDICATES TYPE OF OUTPUT, PRINTED OR ^-DELIMITED
        ;
        ; ZEXCEPT: IOSL    - KERNEL VARIABLE
        N PAGENUM,LINENUM,PROVNAME,TAXDESCR,TAXONOMY,SERVSECT,DIRUT,DTOUT
        N GLOBLOC,IEN,NPI,DATETIME,GLOBVALU,NCOUNT,GLOBLOC1,XUSDIVNM,CNTTOTAL,CNTNONE,CNTEXMPT,CNTDONE,MULTDIV,MULTDIVC
        S CNTTOTAL=0,CNTNONE=0,CNTEXMPT=0,CNTDONE=0
        S PAGENUM=0,LINENUM=0
        S DATETIME=$$NOW^XLFDT()
        S GLOBLOC1=$$GETDATA(OPTION,XUSSORT,XUSDIV,XUSRESO)
        I PRNTFRMT'=1 W !,"PROVIDER_NAME^LAST4^IEN^NPI^TAXONOMY_CODE^TAXONOMY DESCRIPTION"_$S(XUSDIV:"^DIVISION",1:"")_$S(XUSSORT:"^SERVICE/SECTION",1:"")
        S GLOBLOC=GLOBLOC1,XUSDIVNM="" F  S XUSDIVNM=$O(@GLOBLOC1@(XUSDIVNM)) Q:XUSDIVNM=""  D  Q:$D(DIRUT)!$D(DTOUT)
        . S SERVSECT="" F  S SERVSECT=$O(@GLOBLOC1@(XUSDIVNM,SERVSECT)) Q:SERVSECT=""  S GLOBLOC=$NA(@GLOBLOC1@(XUSDIVNM,SERVSECT)) D  Q:$D(DIRUT)!$D(DTOUT)
        . . I PRNTFRMT=1 D HEADER(OPTION,DATETIME,.PAGENUM,.LINENUM,XUSDIV,XUSDIVNM,XUSSORT,SERVSECT,XUSRESO) Q:$D(DIRUT)!$D(DTOUT)
        . . S PROVNAME="" F  S PROVNAME=$O(@GLOBLOC@(PROVNAME)) Q:PROVNAME=""  Q:$D(DIRUT)!$D(DTOUT)  S IEN=0 F  S IEN=$O(@GLOBLOC@(PROVNAME,IEN)) Q:IEN'>0  D  Q:$D(DIRUT)!$D(DTOUT)
        . . . S NCOUNT=0
        . . . S TAXDESCR="" F  S TAXDESCR=$O(@GLOBLOC@(PROVNAME,IEN,TAXDESCR)) Q:TAXDESCR=""  S GLOBVALU=@GLOBLOC@(PROVNAME,IEN,TAXDESCR) D
        . . . . S NPI=$P(GLOBVALU,U,3),TAXONOMY=$P(GLOBVALU,U,4)
        . . . . I PRNTFRMT=1 S NCOUNT=NCOUNT+1 W:NCOUNT=1 !,PROVNAME,?33,$$ALIGNRGT(IEN,11),?49,NPI W !,?6,TAXONOMY,"  ",TAXDESCR
        . . . . I PRNTFRMT'=1 W !,PROVNAME_U_$E($$GET1^DIQ(200,IEN_",",9),6,9)_U_IEN_U_NPI_U_TAXONOMY_U_TAXDESCR_$S(XUSDIV:U_XUSDIVNM,1:"")_$S(XUSSORT:U_SERVSECT,1:"")
        . . . . Q
        . . . I PRNTFRMT=1 S LINENUM=LINENUM+NCOUNT+1 I LINENUM>(IOSL-4) D HEADER(OPTION,DATETIME,.PAGENUM,.LINENUM,XUSDIV,XUSDIVNM,XUSSORT,SERVSECT,XUSRESO) Q:$D(DIRUT)!$D(DTOUT)
        . . . Q
        . . Q
        . Q
        I '($D(DIRUT)!$D(DTOUT)),PRNTFRMT=1 D
        . S PROVNAME="" I $O(@GLOBLOC@(PROVNAME))="" W !,?20,"* * * N O  D A T A  F O U N D * * *",!! I 1
        . E  D
        . . N TOTTYP S TOTTYP=$S(XUSRESO="R":"Residents",1:"Billable Providers")
        . . W !!,"Total "_TOTTYP_":",?43,CNTTOTAL,!,TOTTYP_" with an NPI:",?43,CNTDONE,!,"EXEMPT "_TOTTYP_":",?43,CNTEXMPT,!,TOTTYP_" Still Needing an NPI:",?43,CNTNONE
        . . I $G(MULTDIV)>0 W !!,MULTDIV," Providers were repeated a total of ",MULTDIVC," times",!," due to listing under multiple divisions"
        . . Q
        . W !!,?27,"*** End of Report ***"
        . Q
        Q
        ;
HEADER(OPTION,DATETIME,PAGNOREF,LINNOREF,XUSDIV,XUSDIVNM,XUSSORT,SERVSECT,XUSRESO)      ;
        ; ZEXCEPT: IOF,IOST  KERNEL IO VARIABLES
        ; ZEXCEPT: DIRUT,DTOUT  NEWED IN CALLING PRNTPROV - INDICATE QUIT TO PRNTPROV
        N TEMPVAL,DIR,X,Y
        S PAGNOREF=PAGNOREF+1
        ; Don't page feed on the first page
        IF PAGNOREF>1 I $E(IOST,1,2)="C-" S DIR(0)="E" D ^DIR I 'Y S DIRUT=1 Q
        IF PAGNOREF>1 W @IOF
        W:$E(IOST,1,2)'="C-" !
        W "Active Provider Report ("_$S(XUSRESO="P":"no residents)",XUSRESO="R":"residents only)",1:"includes residents)")
        W ?48,$$FMTE^XLFDT(DATETIME),"  Page: ",PAGNOREF
        W !," Report Option: Provider List       Active Providers",$S(OPTION=2:" Without NPI Numbers",1:"")
        W !!,"Provider Name",?39,"IEN",?49,$S(OPTION'=2:"NPI",1:"")
        W !,"      Taxonomy"
        W !,"--------------------------------------------------------------------------------"
        S LINNOREF=6
        I XUSDIV W !,"DIVISION: ",XUSDIVNM,"   " S LINNOREF=LINNOREF+1
        I XUSSORT W:'XUSDIV ! W "SERVICE/SECTION: ",SERVSECT S:'XUSDIV LINNOREF=LINNOREF+1
        Q
        ;
GETDATA(OPTION,XUSSORT,XUSDIV,XUSRESO)  ; get data for reports for providers
        N NPI,PROVNAME,TAXDESCR,TAXONOMY,XUSDEFLT,XUSDIVCN,XUSDIVN,XUSDIVNM,XUSGLOB,XUSACTV,XUSSKIP
        N XUSIEN,XUSSERVC,XUSVAL,CNTCLEAN,X
        S XUSRESO=$G(XUSRESO)
        ; ZEXCEPT: CNTTOTAL,CNTNONE,CNTEXMPT,CNTDONE - NEWed and initialized in PRNTPROV or killed based on CNTCLEAN
        S CNTCLEAN=0 I '$D(CNTTOTAL) S CNTCLEAN=1
        S XUSGLOB=$NA(^TMP($J,"XUSNPIPRNT")) K @XUSGLOB
        I 'XUSDIV S XUSDIVNM(1)=" ",XUSDEFLT=" "
        I XUSDIV S XUSDEFLT=$$NS^XUAF4($$KSP^XUPARAM("INST")),XUSDEFLT=$P(XUSDEFLT,U)
        I 'XUSSORT S XUSSERVC=" "
        F XUSIEN=0:0 S XUSIEN=$O(^VA(200,XUSIEN)) Q:XUSIEN'>0  D
        . ; Don't report TERMINATED or DISUSERed users
        . S XUSACTV=$$ACTIVE^XUSER(XUSIEN)
        . I XUSACTV=""!($P(XUSACTV,U)=0) Q
        . ; Don't report users with null NPI ENTRY STATUS
        . S XUSVAL=$$CHEKNPI^XUSNPIED(XUSIEN),XUSVAL=$$NPISTATS^XUSNPIED(XUSIEN)
        . Q:XUSVAL=""
        . S PROVNAME=$$GET1^DIQ(200,XUSIEN_",",.01),NPI=$$GETNPI^XUSNPIED(XUSIEN),TAXONOMY=$$GETTAXON^XUSNPIED(XUSIEN,.TAXDESCR) I TAXONOMY=-1 S TAXONOMY=" ",TAXDESCR=" "
        . ; Determine whether provider is a resident for local reports.
        . I OPTION'=3,XUSRESO'="B" S XUSSKIP=0 D  Q:XUSSKIP
        . . I XUSRESO="R",TAXONOMY'="390200000X" S XUSSKIP=1 Q
        . . I XUSRESO="P",TAXONOMY="390200000X" S XUSSKIP=1
        . . Q
        . I NPI="",$$EXMPTNPI^XUSNPIED(XUSIEN) S NPI="EXEMPTED  "
        . S CNTTOTAL=$G(CNTTOTAL)+1 S:NPI="" CNTNONE=$G(CNTNONE)+1 S:NPI="EXEMPTED  " CNTEXMPT=$G(CNTEXMPT)+1 S:NPI?10N CNTDONE=$G(CNTDONE)+1
        . I '((XUSVAL="N")!(OPTION'=2)) Q
        . I XUSSORT S XUSSERVC=$$GET1^DIQ(200,XUSIEN_",",29) I XUSSERVC="" S XUSSERVC=" "
        . I XUSDIV D
        . . K XUSDIVNM S XUSDIVCN=0,XUSDIVNM(1)=XUSDEFLT
        . . F XUSDIVN=0:0 S XUSDIVN=$O(^VA(200,XUSIEN,2,XUSDIVN)) Q:XUSDIVN'>0  S XUSDIVCN=XUSDIVCN+1,XUSDIVNM(XUSDIVCN)=$$GET1^DIQ(200.02,XUSDIVN_","_XUSIEN_",",.01)
        . . I XUSDIVCN>1 S MULTDIV=$G(MULTDIV)+1,MULTDIVC=$G(MULTDIVC)+XUSDIVCN-1
        . . Q
        . F XUSDIVN=0:0 S XUSDIVN=$O(XUSDIVNM(XUSDIVN)) Q:XUSDIVN'>0  D
        . . S X=PROVNAME_U_XUSIEN_U_NPI_U_TAXONOMY_U_TAXDESCR
        . . S @XUSGLOB@(XUSDIVNM(XUSDIVN),XUSSERVC,PROVNAME,XUSIEN,TAXDESCR)=X
        . . Q 
        . Q
        I CNTCLEAN K CNTTOTAL,CNTNONE,CNTEXMPT,CNTDONE
        Q XUSGLOB
        ;
ALIGNRGT(TEXT,WIDTH)    ; align text right in a specified width
        N RESULT
        S $P(RESULT," ",WIDTH)=" ",RESULT=RESULT_TEXT,RESULT=$E(RESULT,$L(RESULT)-WIDTH+1,$L(RESULT))
        Q RESULT
        ;
CHKOLD1(IEN)    ; check for earlier value, and activate if present
        N IEN1,STATUS,NPI,DATE,XUFDA
        S IEN1=$O(^VA(200,IEN,"NPISTATUS"," "),-1) I IEN1>0 D  I STATUS=0 D CHKOLD1(IEN)
        . S STATUS=^VA(200,IEN,"NPISTATUS",IEN1,0),NPI=$P(STATUS,U,3),DATE=$P(STATUS,U),STATUS=$P(STATUS,U,2)
        . I STATUS=0 D DELETNPI(IEN,IEN1,DATE) Q  ; entry making it INACTIVE - remove it
        . I STATUS=1 D SET^XUSNPIE1(IEN,NPI)
        . Q
        Q
        ;
DELETNPI(IEN,OIEN,ODATEVAL)     ;
        N XUFDA
        I $D(ODATEVAL) S XUFDA(200.042,OIEN_","_IEN_",",.01)="@" D FILE^DIE("","XUFDA")
        I $O(^VA(200,IEN,"NPISTATUS",0))>0 Q
        N XUFDA
        I $$GET1^DIQ(200,IEN_",",41.99) S XUFDA(200,IEN_",",41.99)="@"
        I $$GET1^DIQ(200,IEN_",",41.98)'="" S XUFDA(200,IEN_",",41.98)="@"
        I $D(XUFDA) D FILE^DIE("","XUFDA")
        Q
        ;
CLERXMPT        ; edit entry indicating whether a provider is exempt from needing an NPI
        N DIC,DIR,FDA,IEN,Y
        W ! S DIC="^VA(200,",DIC(0)="AEQ" S DIC("A")="select Provider: " D ^DIC Q:Y'>0  S IEN=+Y
        I $$HASNPI^XUSNPIED(IEN) W !,"This Provider already has an NPI value.  Nothing to do." Q
        I '$$CHEKNPI^XUSNPIED(IEN),'$$EXMPTNPI^XUSNPIED(IEN) W !,"This Provider does not appear to need an NPI or Exemption." Q
        I $$EXMPTNPI^XUSNPIED(IEN) D  Q  ; currently marked as Exempt
        . S DIR(0)="Y",DIR("A")="Provider is currently EXEMPT from needing an NPI, set to NEEDS an NPI (Y/N)" D ^DIR I 'Y Q
        . S FDA(200,IEN_",",41.98)="N" D FILE^DIE("","FDA")
        . W !,$S($$NEEDSNPI^XUSNPIED(IEN):"File updated",1:"Ecountered a problem updating file, status NOT set to NEEDS an NPI")
        . Q
        ; check to make sure provider should be exempt
        S DIR(0)="Y",DIR("A")="Confirm that Provider should be Exempt from needing an NPI (Y/N)" D ^DIR I 'Y Q
        ; and update file to show as exempt
        S FDA(200,IEN_",",41.98)="E" D FILE^DIE("","FDA")
        W !,$S($$EXMPTNPI^XUSNPIED(IEN):"File updated",1:"Ecountered a problem updating file, status NOT set to EXEMPT")
        Q
