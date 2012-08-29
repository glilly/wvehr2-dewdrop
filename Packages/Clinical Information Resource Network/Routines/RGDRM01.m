RGDRM01 ;BAY/ALS-MPI/PD AWARE DUPLICATE RECORD MERGE ;02/22/00
 ;;1.0;CLINICAL INFO RESOURCE NETWORK;**6,10,12,29,36**;30 Apr 99
 ;
 ;Reference to ^DPT( supported by IA #2070
 ;Reference to ^DPT("AICN" supported by IA #2070
 ;Reference to $$A40^MPIFA40 supported by IA #4294
 ;
CKICNS(DFNFRM,DFNTO) ;Check ICN's and CMORs of FROM and TO records of
 ; duplicate record pair
 N CMORFRM,CMORTO,RETURN,ICNFRM,ICNTO,LOCFRM,LOCTO
 S RETURN="1^OK to merge"
 I ($G(DFNFRM)'>0)!($G(DFNTO)'>0) S RETURN="0^DFN NOT PASSED" G EXIT
 S CMORFRM=$$GETVCCI^MPIF001(DFNFRM)
 S CMORTO=$$GETVCCI^MPIF001(DFNTO)
 S ICNFRM=$$GETICN^MPIF001(DFNFRM)
 ; If FROM record has no ICN quit
 I ICNFRM<0 G EXIT
 S ICNTO=$$GETICN^MPIF001(DFNTO)
 S LOCFRM=$$IFLOCAL^MPIF001(DFNFRM)
 S LOCTO=$$IFLOCAL^MPIF001(DFNTO)
 ; If both records have local ICNs, delete FROM data, keep TO data 
 I (LOCFRM=1)&(LOCTO=1) S ICN=$P(ICNFRM,"V",1) D DEL D DEL^RGDRM03 G EXIT
 S HOME=$$SITE^VASITE()
 ; If both records have National ICNs, log an exception
 ;I ($E(ICNFRM,1,3)'=$E($P(HOME,"^",3),1,3)&(ICNFRM>0))&($E(ICNTO,1,3)'=$E($P(HOME,"^",3),1,3)&(ICNTO>0)) D  G EXIT
 ;. S RETURN="0^CANNOT MERGE RECORDS "_DFNFRM_" AND "_DFNTO_", both records have national ICNs assigned and must be resolved before merging."
 ; If both records have a national ICN, delete the FROM data and call A40^MPIFA40 to trigger messaging to MPI and TFs
 I ($E(ICNFRM,1,3)'=$E($P(HOME,"^",3),1,3)&(ICNFRM>0))&($E(ICNTO,1,3)'=$E($P(HOME,"^",3),1,3)&(ICNTO>0)) D
 . S ERR=$$A40^MPIFA40(DFNTO,DFNFRM)
 . I $P(ERR,"^",1)=-1 S RETURN="0^CANNOT MERGE RECORDS "_DFNFRM_" AND "_DFNTO_", "_$P(ERR,"^",2)
 . I $P(RETURN,"^",1)>0 S ICN=$P(ICNFRM,"V",1) D DEL D DEL^RGDRM03
 ; If FROM record is local and TO record is null, merge
 I (LOCFRM=1)&(ICNTO<0) D MRGICN D MRGCMOR^RGDRM03
 ; If FROM record is National and TO record is local, merge
 E  I ($E(ICNFRM,1,3)'=$E($P(HOME,"^",3),1,3)&(ICNFRM>0))&(LOCTO=1) D MRGICN D MRGCMOR^RGDRM03
 ; If FROM record is National and TO record is null, merge
 E  I ($E(ICNFRM,1,3)'=$E($P(HOME,"^",3),1,3)&(ICNFRM>0))&(ICNTO<1) D MRGICN D MRGCMOR^RGDRM03
 ; If FROM record is local and TO record is National, delete FROM data, keep TO data
 E  I (LOCFRM=1)&(LOCTO=0)&(ICNTO>0) S ICN=$P(ICNFRM,"V",1) D DEL D DEL^RGDRM03 G EXIT
 ;
EXIT ;
 Q RETURN
MRGICN ;Set ICN and ICN Checksum in TO record to values in FROM record
 N ICN,CKSUM,DIQUIET,RGRSICN
 S DIQUIET=1,RGRSICN=1
 S ICN=$P(ICNFRM,"V",1),CKSUM=$P(ICNFRM,"V",2)
 L +^DPT(DFNTO):10
 S DIE="^DPT(",DA=DFNTO,DR="991.01///^S X=ICN;991.02///^S X=CKSUM"
 D ^DIE K DIE,DA,DR
 L -^DPT(DFNTO)
 S ICNTO="" S ICNTO=$$GETICN^MPIF001(DFNTO)
 ;Make sure local icn flag is not set if national just got assigned
 I ($E(ICNTO,1,3)'=$E($P(HOME,"^",3),1,3)&(ICNTO>0)) D
 . L +^DPT(DFNTO):10
 . S DIE="^DPT(",DA=DFNTO,DR="991.04///@"
 . D ^DIE K DIE,DA,DR
 . L -^DPT(DFNTO)
 ; set local icn flag to Y if local just got assigned
 I $E(ICNTO,1,3)=$E($P(HOME,"^",3),1,3) D
 . L +^DPT(DFNTO):10
 . S DIE="^DPT(",DA=DFNTO,DR="991.04///^S X=1"
 . D ^DIE K DIE,DA,DR
 . L -^DPT(DFNTO)
DEL ;Delete ICN, ICN Checksum and Locally Assigned ICN fields in FROM record
 N DIQUIET,RGRSICN
 S DIQUIET=1,RGRSICN=1
 L +^DPT(DFNFRM):10
 S DIE="^DPT(",DA=DFNFRM,DR="991.01///@;991.02///@;991.04///@"
 D ^DIE K DIE,DA,DR
 K ^DPT("AICN",ICN,DFNFRM)
 L -^DPT(DFNFRM)
DELEXC ;Delete exceptions on file for patient record being removed.
 S EXCT=""
 F  S EXCT=$O(^RGHL7(991.1,"ADFN",EXCT)) Q:EXCT=""  D
 . I $D(^RGHL7(991.1,"ADFN",EXCT,DFNFRM)) D
 .. S IEN=0
 .. F  S IEN=$O(^RGHL7(991.1,"ADFN",EXCT,DFNFRM,IEN)) Q:'IEN  D
 ... S IEN2=0
 ... F  S IEN2=$O(^RGHL7(991.1,"ADFN",EXCT,DFNFRM,IEN,IEN2)) Q:'IEN2  D
 .... S NUM="" S NUM=$P(^RGHL7(991.1,IEN,1,0),"^",4)
 .... I NUM=1 D
 ..... L +^RGHL7(991.1,IEN):10
 ..... S DIK="^RGHL7(991.1,",DA=IEN
 ..... D ^DIK K DIK,DA
 ..... L -^RGHL7(991.1,IEN)
 .... E  I NUM>1 D DELE
 K EXCT,IEN,IEN2,NUM
QUIT Q
DELE ;Delete exception
 L +^RGHL7(991.1,IEN):10
 S DA(1)=IEN,DA=IEN2
 S DIK="^RGHL7(991.1,"_DA(1)_",1,"
 D ^DIK K DIK,DA
 L -^RGHL7(991.1,IEN)
 Q
