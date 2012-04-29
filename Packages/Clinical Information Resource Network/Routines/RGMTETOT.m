RGMTETOT        ;BIR/CML-Compile Totals for Site Exceptions ;11/15/01
        ;;1.0;CLINICAL INFO RESOURCE NETWORK;**20,30,43,45,52**;30 Apr 99;Build 2
        ;
        ;Reference to ^DPT("AICNL" supported by IA #2070
        ;
        ;Variable RGHLMQ cannot be killed in this routine, it is needed for the remote query
        ;
        ;Use this routine to compile totals of a site's exceptions in file #991.1
        S DUMP=0 G START
        ;
DUMP1   ;Use this call to dump all data in ascii format for table
        S DUMP=1 G START
        ;
DUMP2   ;Use this call to dump data in ascii format for table - just for exceptions sites have to deal with
        S DUMP=2
        ;
START   ;
        ;do purge of any dups for POTENTIAL MATCH Exceptions
        K TYPEARR,^XTMP("RGMT","HLMQETOT")
        S ^XTMP("RGMT",0)=$$FMADD^XLFDT(DT,30)_"^"_$$NOW^XLFDT_"^MPI/PD Maintenance Data"
        D PURGE
        ;create type array from file 991.11
        S TYPE=233 F  S TYPE=$O(^RGHL7(991.11,TYPE)) Q:'TYPE  I TYPE'=218 S TYPEARR(TYPE)=0 ;MPIC_772; **52 remove 215, 216, and 217
        ;
        ;start loop
        S TYPE=233 F  S TYPE=$O(^RGHL7(991.1,"AC",TYPE)) Q:'TYPE  D  ;MPIC_772; **52 remove 215, 216, and 217
        .Q:TYPE=218
        .S IEN1=0 F  S IEN1=$O(^RGHL7(991.1,"AC",TYPE,IEN1)) Q:'IEN1  D
        ..S IEN2=0 F  S IEN2=$O(^RGHL7(991.1,"AC",TYPE,IEN1,IEN2)) Q:'IEN2  D
        ...I '$D(^RGHL7(991.1,IEN1,1,IEN2,0)) Q
        ...S STAT=$P(^RGHL7(991.1,IEN1,1,IEN2,0),"^",5) I STAT<1 S TYPEARR(TYPE)=TYPEARR(TYPE)+1
        ;
PRT     ;
        S GRAND=0
        S SITENM=$P($$SITE^VASITE(),"^",2),$P(LN,"-",81)=""
        D NOW^%DTC S RUNDT=$$FMTE^XLFDT($E(%,1,12))
        ;
PRT0    I 'DUMP D
        .W !!,"Exception Totals for ",SITENM
        .W !,"Printed ",RUNDT,!,LN
        .S TYPE=0 F  S TYPE=$O(TYPEARR(TYPE)) Q:'TYPE  I +TYPEARR(TYPE) D
        ..S GRAND=GRAND+TYPEARR(TYPE)
        ..W !!,"TYPE: ",TYPE,?12,$P($T(@TYPE),";;",2),?67,"TOTAL = ",$J(TYPEARR(TYPE),4)
        ..W !,"DESCRIPTION:"
        ..S TXT=0 F  S TXT=$O(^RGHL7(991.11,TYPE,99,TXT)) Q:'TXT  W !,^RGHL7(991.11,TYPE,99,TXT,0)
        .W !!?56,"TOTAL EXCEPTIONS: ",$J(GRAND,5)
        ;
PRT1    I DUMP=1 D
        .W !!,"At this point it is necessary for you to increase the right margin."
        .W !,"At the DEVICE prompt enter=> ;255"
        .W ! D ^%ZIS I POP W !,"DOWNLOAD ABORTED!" Q
        .W !!,"Data string=Site;Run Date;Date CIRN Installed;Exceptions 218 & 234" ;MPIC_772; **52 remove 215, 216, and 217
        .S STR=SITENM_";"_RUNDT_";"
        .S TYPE=0 F  S TYPE=$O(TYPEARR(TYPE)) Q:'TYPE  D
        ..S STR=STR_";"_TYPEARR(TYPE)
        .W !!,STR
        ;
PRT2    I DUMP=2 D
        .S ICN=0,LOCCNT=0 F  S ICN=$O(^DPT("AICNL",1,ICN)) Q:'ICN  S LOCCNT=LOCCNT+1
        .S SITEIEN=+$$SITE^VASITE(),STANUM=$P($$SITE^VASITE(),"^",3)
        .I '$D(RGHLMQ) W !!,"Data string:"
        .I '$D(RGHLMQ) W !,"Site;Sta#;;;LocICNs,218,234" ;MPIC_772; **52 remove 215, 216, and 217
        .S STR=SITENM_";"_STANUM_";;;"_LOCCNT
        .F TYPE=218,234 S STR=STR_";"_TYPEARR(TYPE) ;MPIC_772; **52 remove 215, 216, and 217
        .I '$D(RGHLMQ) W !!,STR
        .I $D(RGHLMQ) S ^XTMP("RGMT","HLMQETOT",STANUM,1)=STR
        ;
QUIT    ;
        K %,CIRNIEN,CNT,DA,DIK,DUMP,DUPCNT,EXCDT,GRAND,ICN,IEN,IEN1,IEN2,LN,LOCCNT,OLDDT,OLDNODE,PTNM
        K RGDFN,RUNDT,SITEIEN,SITENM,STANUM,STAT,STR,TXT,TYPE,XCNT,HOME,DFN,RCNT,VADM
        K ^XTMP("RGMT","ETOT")
        Q
        ;
PURGE   ;
        I '$D(RGHLMQ) W !!,"...purging duplicate Potential Match Exceptions",!
        K ^XTMP("RGMT","ETOT")
        S (RGDFN,CNT,XCNT,DUPCNT)=0,HOME=$$SITE^VASITE()
        F  S RGDFN=$O(^RGHL7(991.1,"ADFN",218,RGDFN)) Q:'RGDFN  D
        .S IEN=0
        .F  S IEN=$O(^RGHL7(991.1,"ADFN",218,RGDFN,IEN)) Q:'IEN  D
        ..S IEN2=0
        ..F  S IEN2=$O(^RGHL7(991.1,"ADFN",218,RGDFN,IEN,IEN2)) Q:'IEN2  D
        ...I '$D(^RGHL7(991.1,IEN,0)) Q
        ...S CNT=CNT+1
        ...S EXCDT=$P(^RGHL7(991.1,IEN,0),"^",3)
        ...I '$D(^XTMP("RGMT","ETOT",RGDFN)) D  Q
        ....S XCNT=XCNT+1
        ....D SETTMP
        ...I $D(^XTMP("RGMT","ETOT",RGDFN))  D
        ....S OLDNODE=^XTMP("RGMT","ETOT",RGDFN)
        ....S OLDDT=$P(OLDNODE,"^")
        ....I EXCDT>OLDDT D  Q
        .....S DA(1)=$P(OLDNODE,"^",2),DA=$P(OLDNODE,"^",3)
        .....D DELDUP
        .....D SETTMP
        ....I OLDDT>EXCDT!(OLDDT=EXCDT) D
        .....S DA(1)=IEN,DA=IEN2
        .....D DELDUP
        I '$D(RGHLMQ) W !,DUPCNT," duplicate patient entries for POTENTIAL MATCH exceptions were identified"
        I '$D(RGHLMQ) W !,"and deleted from the CIRN HL7 EXCEPTION LOG file (#991.1)."
        ;
        K ^XTMP("RGMT","ETOT")
        S (RCNT,RGDFN)=0 N IEN,SUB
        F  S RGDFN=$O(^RGHL7(991.1,"ADFN",218,RGDFN)) Q:'RGDFN  D
        .;S ICN=+$$GETICN^MPIF001(RGDFN)
        .;I $E(ICN,1,3)=$P(HOME,"^",3)!(ICN<0) D
        .;**43 shouldn't check for locals or no ICN, check for processed/not processed
        .S IEN=0  F  S IEN=$O(^RGHL7(991.1,"ADFN",218,RGDFN,IEN)) Q:IEN=""  D
        ..S SUB=$O(^RGHL7(991.1,"ADFN",218,RGDFN,IEN,""))
        ..I $P($G(^RGHL7(991.1,IEN,1,SUB,0)),"^",5)=0 D
        ...S DFN=RGDFN D DEM^VADPT
        ...I VADM(1)=""!(VADM(2)="") Q
        ...S RCNT=RCNT+1
        ...S ^XTMP("RGMT","ETOT",VADM(1),RGDFN)=$P(VADM(2),"^")_"^"_$P(VADM(3),"^",2)
        ;
        ;count the number of patients who need to be resolved
        S PTNM="",CNT=0
        F  S PTNM=$O(^XTMP("RGMT","ETOT",PTNM)) Q:PTNM=""  D
        .S RGDFN=0
        .F  S RGDFN=$O(^XTMP("RGMT","ETOT",PTNM,RGDFN)) Q:'RGDFN  S CNT=CNT+1
        S TYPEARR(218)=CNT
        Q
        ;
SETTMP  ;set TMP global for patient check
        S ^XTMP("RGMT","ETOT",RGDFN)=EXCDT_"^"_IEN_"^"_IEN2
        Q
        ;
DELDUP  ;delete patient dups from file
        S DUPCNT=DUPCNT+1
        S DIK="^RGHL7(991.1,"_DA(1)_",1,"
        D ^DIK K DIK,DA
        Q
        ;
218     ;;(Potential Matches Returned)
234     ;;(Primary View Reject)
