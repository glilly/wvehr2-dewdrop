IVMPREC9        ;ALB/KCL/BRM/CKN - PROCESS INCOMING (Z05 EVENT TYPE) HL7 MESSAGES (CON'T) ; 8/15/08 10:25am
        ;;2.0;INCOME VERIFICATION MATCH;**34,58,115**; 21-OCT-94;Build 28
        ;;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
        ;
        ;
STORE   ; - store HL7 fields that have a different value than DHCP fields in
        ;   the IVM Patient (#301.5) file (#301.511) multiple for uploading
        ;
        G:IVMFLG STORE2
        S X=$$IEN^IVMUFNC4("PID")
        ;
        K DIC("DR")
        S DA(1)=IVM3015
        I $G(^IVM(301.5,DA(1),"IN",0))']"" S ^(0)="^301.501PA^^"
        S DIC="^IVM(301.5,"_DA(1)_",""IN"",",DIC(0)="L",DLAYGO=301.501
        K DD,DO D FILE^DICN
        K DIC,DLAYGO,X,Y
        ;
        ; - build mail message if SUPRESS DEMOGRAPHIC NOTIFICATION field is
        ;   not set in the IVM Site Parameter (#301.9) file
        ;
        I '$P($G(^IVM(301.9,1,0)),"^",5),'IVMADFLG D DEMBULL^IVMPREC6
        ;
        ; - set flag in order to not repeat STORE tag for one msg
        S IVMFLG=1
        ;
        S DA(2)=DA(1)
        S DA(1)=$P(^IVM(301.5,DA(1),"IN",0),"^",3)
        ;
STORE2  ;
        ; - X as the record in the IVM Demo Upload Fields (#301.92) file
        S X=+IVMDEMDA
        I $G(^IVM(301.5,DA(2),"IN",DA(1),"DEM",0))']"" S ^(0)="^301.511PA^^"
        S DIC="^IVM(301.5,"_DA(2)_",""IN"",DA(1),""DEM"",",DIC(0)="L"
        S DIC("DR")=".02////^S X=IVMFLD",DLAYGO=301.511
        K DD,DO D FILE^DICN
        K DIC,DLAYGO,X,Y
        ;
        Q
        ;
        ;
LOOK    ; Find the current DHCP field value.
        ;  Input:   DR  --   Field number of the field in file #2
        ;          DFN  --   Pointer to the patient in file #2
        ;  Output:   Y  --   Internal value of field
        S DIC="^DPT(",DA=DFN,DIQ="IVM",DIQ(0)="I" D EN^DIQ1
        S Y=$G(IVM(2,DFN,DR,"I"))
        K DIC,DIQ,DR,IVM
        Q
AUTOEPC(DFN,UPDEPC)     ;
        ; this functionality is copied from IVMLDEM6 and modified to allow
        ; an automated upload of patient communications information
        ;  Input:     DFN  -  as patient IEN
        ;          UPDEPC  -  array contains flag for update/noupdate for all
        ;                     communication types.
        ; Output: IVMFLAG  -  1 if communications fields updated
        ;                     0 if communications fields not updated
        ;
        N IVMFLAG,IVMI,IVMJ,IVMNODE,IVMPTR,Y,UPDT,IVMCVAL,IVMCFLD,SITEFLD,DFLG,CTYP,UPDT
        S IVMFLAG=0  ;initialize flags
        ; - check for required parameters
        Q:'$G(DFN) IVMFLAG
        S IVMDA2=$G(IVM3015)
        Q:'$G(IVMDA2) IVMFLAG
        S IVMDA1=$O(^HL(771.3,"B","PID",""))
        S IVMDA1=$O(^IVM(301.5,IVMDA2,"IN","B",IVMDA1,""),-1)
        Q:'IVMDA1 IVMFLAG
        ;
        S IVMI=0 F  S IVMI=$O(^IVM(301.92,"AD",IVMI)) Q:IVMI']""  D
        .S IVMJ=0 F  S IVMJ=$O(^IVM(301.5,IVMDA2,"IN",IVMDA1,"DEM","B",IVMI,IVMJ)) Q:IVMJ']""  D
        ..S (UPDT,DFLG)=0
        ..; - check for data node in (#301.511) sub-file
        ..S IVMNODE=$G(^IVM(301.5,IVMDA2,"IN",IVMDA1,"DEM",IVMJ,0))
        ..I ('+IVMNODE)!($P(IVMNODE,"^",2)']"") Q
        ..;Check if fields needs to be updated for particular comm. Type.
        ..S CTYP=0 F  S CTYP=$O(UPDEPC(CTYP)) Q:CTYP=""!UPDT  D
        ...I ("^"_$G(UPDEPC(CTYP))_"^")[("^"_+IVMNODE_"^") S UPDT=1
        ..S IVMCFLD=$P($G(^IVM(301.92,+IVMNODE,0)),"^",5),IVMCVAL=$P(IVMNODE,"^",2)
        ..; - load communications fields rec'd from IVM into DHCP (#2) file
        ..I UPDT D UPLOAD^IVMLDEM6(+DFN,IVMCFLD,IVMCVAL) S IVMFLAG=1
        ..; delete inaccurate Addr Change Site data if Source is not VAMC
        ..I UPDT,((IVMCFLD=.1311)!(IVMCFLD=.1313)!(IVMCFLD=.137)) D
        ...I IVMCVAL="VAMC" Q
        ...S SITEFLD=$S(IVMCFLD=.1311:.13111,IVMCFLD=.1313:.1314,IVMCFLD=.137:.138)
        ... S FDA(2,+DFN_",",SITEFLD)="@" D UPDATE^DIE("E","FDA")
        ..; - remove entry only for Email, Cell and Pager from (#301.511) sub-file
        ..S CTYP=0 F  S CTYP=$O(EPCFARY(CTYP)) Q:CTYP=""!DFLG  D
        ...I ("^"_$G(EPCFARY(CTYP))_"^")[("^"_+IVMNODE_"^") S DFLG=1
        ..I DFLG D DELENT^IVMLDEMU(IVMDA2,IVMDA1,IVMJ)
        ;Delete all communication data (Email, Cell phone, Pager) if they are not received in Z05.
        I $D(EPCDEL) D
        . N CTYPE,DIE,DR,DA,CNTR,VAL
        . S DR="",CNTR=0,VAL="@"
        . S CTYPE="" F  S CTYPE=$O(EPCDEL(CTYPE)) Q:CTYPE=""  D
        . . F I=1:1:$L(EPCDEL(CTYPE),"^") S CNTR=CNTR+1,$P(DR,";",CNTR)=$P(EPCDEL(CTYPE),"^",I)_"////^S X=VAL"
        . S DIE="^DPT(",DA=DFN
        . D ^DIE K DIE,DA,DR
        Q IVMFLAG
        ;
AUTORINC(DFN)   ;
        ; application to automatically upload Rated Incompetent data
        ; Input:     DFN   -   Patient IEN
        N IVMI,IVMJ,IVMDA1,IVMDA2,IVMNODE,IVMFLAG,IVMRIVAL,IVMRIFLD
        S IVMFLAG=0
        S IVMDA2=$G(IVM3015)
        I 'IVMDA2 Q IVMFLAG
        S IVMDA1=$O(^HL(771.3,"B","PID",""))
        S IVMDA1=$O(^IVM(301.5,IVMDA2,"IN","B",IVMDA1,""),-1)
        S IVMI=$O(^IVM(301.92,"C","ZPD08","")) I IVMI="" Q IVMFLAG
        S IVMJ=$O(^IVM(301.5,IVMDA2,"IN",IVMDA1,"DEM","B",IVMI,""))
        I IVMJ']"" Q IVMFLAG
        ; - check for data node in (#301.511) sub-file
        S IVMNODE=$G(^IVM(301.5,IVMDA2,"IN",IVMDA1,"DEM",IVMJ,0))
        I '(+IVMNODE)!($P(IVMNODE,"^",2)']"") Q IVMFLAG
        S IVMRIFLD=$P($G(^IVM(301.92,+IVMNODE,0)),"^",5),IVMRIVAL=$P(IVMNODE,"^",2)
        I IVMRIVAL="""""" S IVMRIVAL="@"
        D UPLOAD^IVMLDEM6(DFN,IVMRIFLD,IVMRIVAL) S IVMFLAG=1
        ; - remove entry from (#301.511) sub-file
        D DELENT^IVMLDEMU(IVMDA2,IVMDA1,IVMJ)
        Q IVMFLAG
PHONE   ; - ask user to delete phone # [Residence] from Patient (#2) file
        ; This tag is moved here from IVMLDEM6 due to routine size limit
        D FULL^VALM1
        W ! S DIR("A")="Is it okay to delete the patient's Phone Number [Residence]"
        W ! S DIR("A",1)="The patient's address has been updated and the phonenumber"
        S DIR("A",2)="remains on file."
        S DIR("A",3)=" "
        S DIR("A",4)="Patient Name: "_$P($$PT^IVMUFNC4(+DFN),"^")_" ("_$P($$PT^IVMUFNC4(+DFN),"^",3)_")"
        S DIR("A",5)="Phone Number [Residence]: "_$P($G(^DPT(+DFN,.13)),"^")
        S DIR("A",6)=" "
        S DIR("?",1)="Enter 'YES' to delete the patient's Phone Number [Residence] that is"
        S DIR("?",2)="currently on file.  Enter 'NO' to quit without deleting the patient's"
        S DIR("?")="Phone Number [Residence]."
        S DIR(0)="Y",DIR("B")="NO"
        D ^DIR K DIR
        S:Y $P(^DPT(DFN,.13),"^")="" W !!,"Patient's Phone Number [Residence] has ",$S(Y:"",1:"not "),"been deleted."
        Q
        ;
